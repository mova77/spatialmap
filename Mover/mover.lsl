//
// VKSL - Visual Knowledge in Second Life
// 2007(c) CC License by-nc-sa-2.5-it
//
// Authors:
//     JonnyBee Cioc    jonny@vulca.no
//     VisionRaymaker   vision.raymaker@vulca.no

// ===[ LICENSE ]=======================================

// License Creative Commons Attribution-Noncommercial-Share Alike 2.5 Italy
// http://creativecommons.org/licenses/by-nc-sa/2.5/it/

// ===[ CHANGE LOG ]====================================
integer version_major    =  1;
integer version_minor    =  0;
integer version_revision = 13;

// 2007-12-07 v1.0.13: first revision
// + linked message menu
// + full multi user menu

// ===[ CONSTANTS ]=====================================
integer DEBUG                         = TRUE;
integer LINK_NUMBER                   = LINK_SET;
string  SEPARATOR                     = "|";

// default object's name
string  DEFAULT_NODE                  = "NODE_";
string  DEFAULT_LINK                  = "LINK_";
string  DEFAULT_MOVER                 = "MOVER";

// channels
integer CHANNEL_COMMUNICATION         = -999;

// LINKED MESSAGE PUBLIC INTERFACE
// MODULE
integer MESSAGELINKED_RESET            = 0xFFFF;
integer MESSAGELINKED_MODULEREADY      = 0xFFFE;
integer MESSAGELINKED_VERSION          = 0xFFFD;
integer MESSAGELINKED_DEBUG            = 0xF000;

// ERROR
integer MESSAGELINKED_ERROR            = 0xE000;
integer MESSAGELINKED_LISTOVERFLOW     = 0xE001;
integer MESSAGELINKED_ILLEGALPARAM     = 0xE002;
integer MESSAGELINKED_TRUNCATEDMESSAGE = 0xE003;

// MENU DIALOG
integer MESSAGELINKED_DIALOG           = 0x2001;
integer MESSAGELINKED_DIALOGRESPONSE   = 0x2002;
integer PARAM_DIALOG_ID                = 0x2003;
integer PARAM_DIALOG_TITLE             = 0x2004;
integer PARAM_DIALOG_AVATAR            = 0x2005;
integer PARAM_DIALOG_CHANNEL           = 0x2006;
integer PARAM_DIALOG_BUTTON_ID         = 0x2007;

// HOVERTEXT
integer MESSAGELINKED_HOVERTEXT_SET    = 0x3000;
integer MESSAGELINKED_HOVERTEXT_UNSET  = 0x3001;
integer MESSAGELINKED_HOVERTEXT_TEXT   = 0x3002;
integer MESSAGELINKED_HOVERTEXT_COLOR  = 0x3003;
integer MESSAGELINKED_HOVERTEXT_ALPHA  = 0x3004;
integer PARAM_HOVERTEXT_TEXT           = 0x3005;
integer PARAM_HOVERTEXT_COLOR          = 0x3006;
integer PARAM_HOVERTEXT_ALPHA          = 0x3007;

// CHANNELS
integer MESSAGELINKED_LISTEN           = 0x4000;

// MOVER
integer MESSAGELINKED_MOVER_OFFSET     = 0xC100;

// map message commands
// commands
integer CMD_MAP_PARAMS       = 0x8000;
integer CMD_OBJECTREZ        = 0x8001;
integer CMD_MAPTYPE          = 0x8002;
integer CMD_NEWNODE          = 0x8003;
integer CMD_NEWLINK          = 0x8004;
integer CMD_NEWMOVER         = 0x8005;
integer CMD_TOUCH            = 0x8006;
integer CMD_LINKCHANGE       = 0x8007;
integer CMD_CUTBRANCH        = 0x8008;
integer CMD_CLEAR            = 0x8009;
integer CMD_CLEARMAP         = 0x800A;
integer CMD_SAVE             = 0x800B;
integer CMD_SAVED            = 0x800C;
integer CMD_NODENUMBER       = 0x800D;
integer CMD_MOVE             = 0x800E;
integer CMD_USER             = 0x800F;
integer CMD_LINKUSER         = 0x8010;
integer CMD_NAME             = 0x8011;

// map command's params
integer PARAM_MAPKEY         = 0x8100;
integer PARAM_MAPNAME        = 0x8101;
integer PARAM_MAPTYPE        = 0x8102;
integer PARAM_MAPOWNER       = 0x8103;
integer PARAM_MAPNODECOUNT   = 0x8104;
integer PARAM_MAPLINKCOUNT   = 0x8105;
integer PARAM_PARENTKEY      = 0x8106;
integer PARAM_USERKEY        = 0x8107;
integer PARAM_USERNAME       = 0x8108;
integer PARAM_MOVERKEY       = 0x8109;
integer PARAM_LINKKEY        = 0x810A;
integer PARAM_LINKNAME       = 0x810B;
integer PARAM_NODEKEY        = 0x810C;
integer PARAM_NODEID         = 0x810D;
integer PARAM_NODENAME       = 0x810E;
integer PARAM_POSITION       = 0x810F;
integer PARAM_TITLE          = 0x8110;

// ===[ VARIABLES ]========================================
integer separator_length;
key     link_key;

// myself state
integer map_secret;
key     mover_map;
key     mover_user;

// ===[ MESSAGE EVENTS ]====================================
fireMoverEvent(list params)
{
    if(DEBUG) debug(["FIREMOVEREVENT"]+params);
    notify(CHANNEL_COMMUNICATION, params);
}

notify(integer channel, list params)
{
    string msg = llDumpList2String(params,SEPARATOR);
    string md5 = llMD5String(msg, map_secret);            // 32 hex characters

    string payload = md5+SEPARATOR+msg;

    if(DEBUG) {
        debug(["NOTIFY",channel]+params);
        if(llStringLength(payload)>1023)
            llMessageLinked(LINK_NUMBER,MESSAGELINKED_TRUNCATEDMESSAGE,"SERVER MESSAGE TRUNCATED: PAYLOAD BUFFER OVERFLOW 1024 BYTES",mover_user);

    }

    // Broadcasts message to the whole region. Maximum Payload 1023
    llRegionSay(channel, payload);
}

// ===[ FUNCTIONS ]===============================================
incrementPos(vector offset)
{
    vector pos = llGetPos() + offset;
    llSetPos(pos);
    fireMoverEvent([CMD_MOVE,PARAM_POSITION,pos]);
}

// ===[ UTILITY FUNCTIONS ]=======================================
// security check
// nobody can simply forge the correct message digest without knowing the map secret integer
// pass the check if the given md5 matches the computed one with the secret integer
integer check(string md5, string message)
{
    integer check = md5==llMD5String(llGetSubString(message,32+separator_length, -1), map_secret);
    if(DEBUG) debug( ["MD5CHECK",md5,message,llList2String(["FALSE","TRUE"],check)]);
    return check;
}

debug(list _list)
{
    sendML(MESSAGELINKED_DEBUG, llGetScriptName()+SEPARATOR+llDumpList2String(_list,SEPARATOR));
}

sendML(integer messagelinked, string message)
{
    llMessageLinked(LINK_NUMBER, messagelinked, message, link_key);
}

// search for the param into the list
// return the paired value or NULL_KEY

key findKey(list params, integer param)
{
    if(DEBUG) debug( ["FINDKEY",param]+params);
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2Key(params,++index);
    else return NULL_KEY;
}

integer findInt(list params, integer param)
{
    if(DEBUG) debug( ["FINDINT",param]+params);
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2Integer(params,++index);
    else return -1;
}

vector findVector(list params, integer param)
{
    if(DEBUG) debug( ["FINDVECTOR",param]+params);
    integer index = llListFindList(params,[(string)param]);
    if(~index) return (vector)llList2String(params,++index);
    else return ZERO_VECTOR;
}


//
// ===[ STATES ]=======================================================
//
default
{
    on_rez(integer secret){
        // set secret
        map_secret = secret;

        // open channel for listen node<->server & node<->node messages
        llListen(CHANNEL_COMMUNICATION, "", NULL_KEY, "");

        // notify new node creation
        fireMoverEvent([CMD_OBJECTREZ]);

        link_key = llGetLinkKey(llGetLinkNumber());
        separator_length=llStringLength(SEPARATOR);

        if(DEBUG) debug(["ONREZ secret",secret]);
    }

    link_message(integer sender_num, integer cmd, string message, key id){
        if(id==mover_user || id==llGetOwner()){
            if(cmd==MESSAGELINKED_MOVER_OFFSET)
                incrementPos((vector)message);
        }
    }

    listen(integer channel, string name, key id, string mess){
        if(channel==CHANNEL_COMMUNICATION){
            list     params     = llParseString2List(mess, [SEPARATOR], []);
            string     md5      = llList2String(params, 0);
            if(check(md5,mess)) {
                integer cmd = llList2Integer(params, 1);
                if(cmd==CMD_NEWMOVER){
                    if(findKey(params,PARAM_MOVERKEY)==llGetKey()){
                        mover_map  = findKey(params,PARAM_MAPKEY);
                        mover_user = findKey(params,PARAM_USERKEY);
                    }
                }
                else if(findKey(params,PARAM_MAPKEY)==mover_map){
                    if(cmd==CMD_TOUCH)
                        llDie();
                    else if(cmd==CMD_CLEARMAP)
                        llDie();
                }
            }
        }
    }
}