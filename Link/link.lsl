//
// VKSL - Visual Knowledge in Second Life
// 2007(c) CC License by-nc-sa-2.5-it
//
// Authors:
//     JonnyBee Cioc    jonny@vulca.no
//     VisionRaymaker    vision.raymaker@vulca.no

// ===[ LICENSE ]=======================================

// License Creative Commons Attribution-Noncommercial-Share Alike 2.5 Italy
// http://creativecommons.org/licenses/by-nc-sa/2.5/it/

// ===[ CHANGE LOG ]====================================
integer version_major    =  1;
integer version_minor    =  0;
integer version_revision = 13;

// 2007-12-07 v1.0.13 full revision

// ===[ CONSTANTS ]=====================================
integer DEBUG                 = TRUE;
integer LINK_NUMBER           = LINK_SET;
string  SEPARATOR             = "|";

// channels
integer CHANNEL_COMMUNICATION   = -999;
integer CHANNEL_TITLE = 7;

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
integer PARAM_DIALOG_COLOR             = 0x2008;

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

// MAP
integer MESSAGELINKED_MAP              = 0xC000;

// menu constants
integer MENUID_LINK            = 0x1200;
integer MENUID_LINK_COLOR      = 0x1201;
integer BUTTONID_WRITEACTION    = 2;
integer BUTTONID_DELETEACTION   = 3;
integer BUTTONID_DELETELINK     = 4;
integer BUTTONID_COLORS         = 5;

// map message commands
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

// default object's name
string  DEFAULT_NODE          = "NODE_";
string  DEFAULT_LINK          = "LINK_";
string  DEFAULT_MOVER         = "MOVER";


// ===[ VARIABLES ]=====================================
integer separator_length;
integer map_secret;
integer isTalking2me       = FALSE;
integer isChangingLink     = TRUE;
integer useNameAsTitle     = FALSE;

key     link_from_node;
key     link_to_node;
key     link_map;
key     link_user;

vector  link_from_pos;
vector  link_to_pos;
vector  link_center;
string  link_title;
rotation link_rotation;

// ===[ FUNCTION ]==========================================
setTitle(string text)
{
    link_title = text;

    // notify children (!?!)
    llMessageLinked(LINK_NUMBER, MESSAGELINKED_HOVERTEXT_TEXT,text,NULL_KEY);
}

// set the object name from the connected nodes
setName(key kFrom,key kTo)
{
    integer n = llStringLength(DEFAULT_NODE);

    // get nodes names
    string from_name = llGetSubString((string)llGetObjectDetails(kFrom, [OBJECT_NAME]),n,-1);
    string to_name   = llGetSubString((string)llGetObjectDetails(kTo,   [OBJECT_NAME]),n,-1);

    string name = DEFAULT_LINK+ from_name +"-"+ to_name;
    // set the link object name
    llSetObjectName(name);

    if(useNameAsTitle)
        setTitle(name);
}

setLinkUser(key user)
{
    link_user = user;
}

vector getPos(key node)
{
    return llList2Vector(llGetObjectDetails(node,[OBJECT_POS]),0);
}


updatePrimitiveParams()
{
    // calculate center and orientation from connected node' centers
    vector delta   = link_from_pos - link_to_pos;
    link_center    = link_from_pos - delta/2.0;
    link_rotation  = llRotBetween(<0.0, 0.0, 1.0>, delta);

    // set the primitive params position/size/rotation
    llSetPrimitiveParams([
        PRIM_POSITION,    link_center,
        PRIM_SIZE,        <0.05,0.05, llVecDist(link_from_pos, link_to_pos)>,
        PRIM_ROTATION,    link_rotation
            ]);
}

dying(integer nodenumber)
{
    string nodeid = (string)nodenumber;
    string this_link_name = llGetObjectName();
    integer index = llSubStringIndex(this_link_name,"-");
    if(llGetSubString(this_link_name,llSubStringIndex(this_link_name,"_")+1,index-1)==nodeid
        || llGetSubString(this_link_name,index+1,-1)==nodeid)
        llDie();
}

// ===[ MESSAGE EVENTS ]====================================
fireLinkEvent(list params)
{
    notify(CHANNEL_COMMUNICATION, params);
}

notify(integer channel, list params)
{
    string msg = llDumpList2String(params,SEPARATOR);
    string md5 = llMD5String(msg, map_secret);            // 32 hex characters

    string payload = md5 + SEPARATOR + msg;

    if(llStringLength(payload)>1023)
        llMessageLinked(LINK_NUMBER,MESSAGELINKED_TRUNCATEDMESSAGE,"SERVER MESSAGE TRUNCATED: PAYLOAD BUFFER OVERFLOW 1024 BYTES",link_user);

    // Broadcasts message to the whole region. Maximum Payload 1023
    llRegionSay(channel, payload);
}




// ===[ UTILITY FUNCTIONS ]=======================================

// security check
// nobody can simply forge the correct message digest without knowing the map secret integer
// pass the check if the given md5 matches the computed one with the secret integer
integer check(string md5, string message)
{
    return md5==llMD5String(llGetSubString(message,32+separator_length, -1), map_secret);
}

// search for the param into the list
// return the paired value or NULL_KEY

key findKey(list params, integer param)
{
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2Key(params,++index);
    else return NULL_KEY;
}

integer findInt(list params, integer param)
{
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2Integer(params,++index);
    else return -1;
}

vector findVector(list params, integer param)
{
    integer index = llListFindList(params,[(string)param]);
    if(~index) return (vector)llList2String(params,++index);
    else return ZERO_VECTOR;
}

// ===[ MENU FUNCTIONS ]===============================
MenuCall(integer menuid, key avatar){
    list params = [PARAM_DIALOG_ID, menuid];
    llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOG, llDumpList2String(params,SEPARATOR), avatar);
}

MenuCallWithText(integer menuid, string title, key avatar){
    list params = [PARAM_DIALOG_ID, menuid, PARAM_DIALOG_TITLE, title];
    llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOG, llDumpList2String(params,SEPARATOR), avatar);
}


//
// ===[ STATES ]=======================================================
//
default
{
    on_rez(integer secret){
        // set secret
        map_secret = secret;

        // open channel for listen link<->server & link<->nodes messages
        llListen(CHANNEL_COMMUNICATION, "", NULL_KEY, "");

        separator_length = llStringLength(SEPARATOR);

        // notify new link creation
        fireLinkEvent([CMD_OBJECTREZ]);
    }

    touch_start(integer total_number){
        key toucher;

        while(total_number--) {
            toucher = llDetectedKey(total_number);
            if(toucher==link_user || toucher==llGetOwner()){

                isTalking2me=TRUE;

                // no need to go through other detected
                total_number = 0;

                // prompt for link menu
                MenuCall(MENUID_LINK, toucher);

                // notify link touch
                fireLinkEvent([CMD_TOUCH,PARAM_MAPKEY,link_map,PARAM_LINKKEY,llGetKey()]);
            }
        }
    }

    listen(integer channel, string name, key id, string message) {
        if(channel==CHANNEL_COMMUNICATION) {
            list    params = llParseString2List(message, [SEPARATOR], []);
            string  md5    = llList2String(params, 0);
            if(check(md5,message)) {
                integer cmd = llList2Integer(params, 1);

                key talking_map = findKey(params, PARAM_MAPKEY);
                if(cmd==CMD_NEWLINK)
                    if(findKey(params,PARAM_LINKKEY)==llGetKey()) {
                        // get nodes and map keys
                        link_to_node    = id;
                        link_from_node  = findKey(params,PARAM_PARENTKEY);
                        link_map        = findKey(params,PARAM_MAPKEY);
                        link_user       = findKey(params,PARAM_USERKEY);

                        // set link name itself
                        setName(link_from_node, link_to_node);

                        // set current linked nodes position
                        link_from_pos = getPos(link_from_node);
                        link_to_pos   = getPos(link_to_node);

                        // calculate link center and orientation and update primitive params
                        updatePrimitiveParams();
                    }
                else if(cmd==CMD_TOUCH && id!=llGetKey()){
                    isTalking2me = FALSE;
                }
                if(talking_map==link_map) {
                    if(cmd==CMD_USER){
                        setLinkUser(findKey(params,PARAM_USERKEY));
                    }
                    else if(cmd==CMD_MOVE){
                        // modify message from source node
                        if(id==link_from_node){
                            // set current source node position
                            link_from_pos = getPos(link_from_node);

                            // calculate link center and orientation and update primitive params
                            updatePrimitiveParams();
                        }
                        // modify message from destination node
                        else if(id==link_to_node){
                            // set current source node position
                            link_to_pos = getPos(link_to_node);

                            // calculate link center and orientation and update primitive params
                            updatePrimitiveParams();
                        }
                    }
                    else if(cmd==CMD_LINKCHANGE){
                        if(isChangingLink){
                            string this_link_name     = llGetObjectName();
                            string other_node_name     = (string)llGetObjectDetails(id,[OBJECT_NAME]);

                            string end_link = llGetSubString(this_link_name, llSubStringIndex(this_link_name, "-")+1,-1);
                            string end_node = llGetSubString(other_node_name,llSubStringIndex(other_node_name,"_")+1,-1);

                            // changed the last link/node?
                            if(end_link==end_node)
                                llDie();
                            isChangingLink = FALSE;
                        }
                        else
                            isChangingLink = TRUE;
                    }
                    else if(cmd==CMD_CLEAR){
                        dying(findInt(params,PARAM_NODEID));
                    }
                    else if(cmd==CMD_CUTBRANCH){
                        dying(findInt(params,PARAM_NODEID));
                    }
                }
                else if(id==link_map){
                    if(cmd==CMD_CLEARMAP){
                        llDie();
                    }
                    else if(cmd==CMD_SAVE){
                        // response to save query with map key, myself key and text
                        fireLinkEvent([CMD_SAVED,PARAM_MAPKEY,link_map,PARAM_LINKKEY,llGetKey(),PARAM_TITLE,link_title]);
                    }
                    //else if(cmd==CMD_USER) {
                        // ownership changes to
                    //    setLinkUser(findKey(params,PARAM_USERKEY));
                    //}
                }
            }
        }
    }

    link_message(integer sender_number, integer cmd, string message, key id)
    {
        if(cmd==MESSAGELINKED_DIALOGRESPONSE) {
            list    params    = llParseString2List(message, [SEPARATOR], []);
            integer menu_id   = findInt(params, PARAM_DIALOG_ID);
            integer button_id = findInt(params, PARAM_DIALOG_BUTTON_ID);

            if(button_id==BUTTONID_WRITEACTION){
                llMessageLinked(LINK_NUMBER, MESSAGELINKED_LISTEN, (string)CHANNEL_TITLE, link_user);
            }
            else if(button_id==BUTTONID_DELETEACTION){
                llMessageLinked(LINK_NUMBER, MESSAGELINKED_HOVERTEXT_UNSET, "", link_user);
            }
            else if(button_id==BUTTONID_DELETELINK){
                // kill myself
                llDie();
            } else if(menu_id==MENUID_LINK_COLOR) {
                llSetLinkColor(LINK_SET,findVector(params,PARAM_DIALOG_COLOR),ALL_SIDES);
            }
            isTalking2me = FALSE;
        }

    }
}