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
integer version_revision = 18;

// 2007-12-07 v1.0.13: menu revision
// # linked message via menu module

// 2007-12-07 v1.0.12: full revision
// + map types
// + commands, commands params
// + MESSAGES
// + menu costants, feasible menu building by mask
// + notify MESSAGES on secure channel
// + dynamic title varying on map type

// ===[ CONSTANTS ]=====================================
integer DEBUG                          = FALSE;
integer LINK_NUMBER                    = LINK_SET;
string  SEPARATOR                      = "|";

integer CHANNEL_COMMUNICATION          = -999;

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
integer PARAM_DIALOG_BUTTON_TEXT       = 0x2008;

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
integer CMD_ISUSERJOINED     = 0x8012;
integer CMD_DIALOG           = 0x8013;
integer CMD_DIALOG_RESPONSE  = 0x8014;

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

// default names
string  DEFAULT_NODE         = "NODE_";
string  DEFAULT_LINK         = "LINK_";
string  DEFAULT_MOVER        = "MOVER";

// ===[ MENU CONSTANTS ]========================================
// menu ID
integer MENUID_SERVER_ALL        = 0x1000;
integer MENUID_SERVER_START      = 0x1001;
integer MENUID_SERVER_ADMINJOIN  = 0x1002;
integer MENUID_SERVER_ADMIN      = 0x1003;
integer MENUID_SERVER_USER       = 0x1004;
integer MENUID_SERVER_REQUEST    = 0x1005;
integer MENUID_SERVER_PENDING    = 0x1007;
integer MENUID_SERVER_ALLOWED    = 0x1008;

// ===[ PRIVATE CONSTANTS ]=====================================
float   MODIFY_TIMEOUT        = 180;
vector  NODE_OFFSET_ON_REZ    = <0,0,1.5>;
string  INVENTORY_DIR         = "VKSL - Visual Knowledge in SL %0 (%1)";

// MESSAGES
list    MESSAGES             = [
	"Visual Knowledge in SL %0\nTool for the creation\nof 3D Mental Map",
	"Visual Knowledge in SL %0\nTool for the creation\nof 3D Mental Map\n\nOWNER: %1\nTYPE OF MAP: %2",
	"You have received an info card into your inventory into the folder %0.",
	"%0 request permission to join map's group for map %1 at %2 (%3, %4, %5).\n%6 pending users.\n%7",
	"We're sorry %0. We can't accept more user for this map. Contact the map owner %1.",
	"%0 owns map.",
	"%0 is already modifying the map.",
	"%0, you have been added to map's group.",
	"Accept new join request",
	"Stop join request"
		];


integer MSG_MAIN_TITLE           = 0;
integer MSG_EXTENDED_TITLE       = 1;
integer MSG_GIVEINFOCARD         = 2;
integer MSG_IM_REQUEST           = 3;
integer MSG_IM_CANTACCEPTREQUEST = 4;
integer MSG_USABILITY            = 5;
integer MSG_CANTMODIFY           = 6;
integer MSG_IM_REQUESTACCEPTED   = 7;
integer MSG_IM_REQUESTALLOWED    = 8;
integer MSG_IM_REQUESTSTOPPED    = 9;



// menu buttons id
integer BUTTONID_PRIVATEMAP     = 0;
integer BUTTONID_GROUPMAP       = 1;
integer BUTTONID_JOINABLEMAP    = 2;
integer BUTTONID_PUBLICMAP      = 3;
integer BUTTONID_MODIFYMAP      = 4;
integer BUTTONID_SAVE           = 5;
integer BUTTONID_CLEARALL       = 6;
integer BUTTONID_RELEASE        = 7;
integer BUTTONID_REQUEST        = 8;
integer BUTTONID_INFO           = 9;
integer BUTTONID_SHOWPENDING    = 10;
integer BUTTONID_SHOWALLOWED    = 11;
integer BUTTONID_ALLOWREQUEST   = 12;
integer BUTTONID_STOPREQUEST    = 13;
integer BUTTONID_NEXT           = 14;
integer BUTTONID_PREVIOUS       = 15;

// map type
list    MAP_TYPES            = ["PRIVATE MAP","GROUP MAP","JOINABLE MAP","PUBLIC MAP"];
integer MAPTYPE_UNDEFINED    =-1;
integer MAPTYPE_PRIVATE      = 0; // dont change: this *must* be zero
integer MAPTYPE_GROUP        = 1;
integer MAPTYPE_JOINABLE     = 2;
integer MAPTYPE_PUBLIC       = 3;


// ===[ VARIABLES ]====================================================
integer map_secret;
key     map_main_concept = NULL_KEY;
integer map_type;
key     map_user;
string  map_username;
string  map_name;
string  map_ownername;
integer module_inited;
key     link_key;
integer separator_length;
integer canAcceptNewRequest  = TRUE;

// delivered notecard and landmarks on info request
list    info_items;

// members strided list [name, key, ..., name, key]
list    user_pending;
list    user_allowed;

// other variable
integer num_request          = 0;
integer stop_request         = FALSE;

// ===[ INIT ]====================================================

init(){
	// generate random secret
	map_secret = (integer)llFrand(0x00FFFFFF);

	// store map owner name
	map_user      = llGetOwner();
	map_username  = llKey2Name(map_user);
	map_ownername = map_username;
	map_type      = MAPTYPE_UNDEFINED;

	// always allows server owner as allowed map user
	user_allowed = [map_username, map_user];

	integer items = llGetInventoryNumber(INVENTORY_ALL);
	while(items--)
	{
		string item = llGetInventoryName(INVENTORY_ALL, items);
		if(llGetInventoryType(item)!=INVENTORY_SCRIPT)
			if(item!=DEFAULT_NODE)
				info_items += item;
	}

	// set default hover text
	llSetText(format(llList2String(MESSAGES,MSG_MAIN_TITLE),[version()]),<1,1,1>,1);

	link_key = llGetLinkKey(llGetLinkNumber());
	separator_length = llStringLength(SEPARATOR);

	// send reset command to all script
	llMessageLinked(LINK_NUMBER, MESSAGELINKED_RESET, "RESET", link_key);

	// reset module init counter
	module_inited = 0;

}

// ===[ METHODS ]====================================================
setMapUser(key user)
{
	map_user     = user;
	map_username = llKey2Name(user);
	fireServerEvent([CMD_USER,PARAM_USERNAME,map_username,PARAM_USERKEY,map_user]);
}

setMapType(integer maptype)
{
	map_type = maptype;
	fireServerEvent([CMD_MAPTYPE,PARAM_MAPTYPE,map_type]);
}

setMapName(string mapname)
{
	map_name = mapname;
	fireServerEvent([CMD_NAME, PARAM_MAPNAME, map_name]);
}

setAcceptNewRequest(integer bool)
{
	if(bool!=canAcceptNewRequest)
		if(bool)
			llInstantMessage(map_user, llList2String(MESSAGES, MSG_IM_REQUESTALLOWED));
	else
		llInstantMessage(map_user, llList2String(MESSAGES, MSG_IM_REQUESTSTOPPED));
	canAcceptNewRequest = bool;
	//updateTitle();
}

giveInfocard(key giveTo)
{
	string info_inventory_dir = format(INVENTORY_DIR,[version(),llGetDate()]);
	llInstantMessage(giveTo, format(llList2String(MESSAGES, MSG_GIVEINFOCARD),[info_inventory_dir]));
	llGiveInventoryList(giveTo, info_inventory_dir, info_items);
}


updateTitle(){
	string map_title="";

	map_title = format(
		llList2String(MESSAGES,MSG_EXTENDED_TITLE),
		[version(),map_ownername,llList2String(MAP_TYPES, map_type)]);

	llSetText(map_title, <1,1,1>,1);
	if(DEBUG) debug(["SETTITLE",map_title]);
}


rezFirstNode()
{
	setMapUser(llGetOwner());
	llRezObject(DEFAULT_NODE, llGetPos()+NODE_OFFSET_ON_REZ, ZERO_VECTOR, ZERO_ROTATION, map_secret);

	if(DEBUG) debug(["REZFIRSTNODE",map_type,llList2String(MAP_TYPES, map_type),map_ownername]);
}

// ===[ EVENTS ]===============================================================================

fireServerEvent(list params)
{
	notify(CHANNEL_COMMUNICATION, params);
}

notify(integer channel, list params)
{
	string msg = llDumpList2String(params,SEPARATOR);
	string md5 = llMD5String(msg, map_secret);            // 32 hex characters

	string payload = md5 + SEPARATOR + msg;

	if(llStringLength(payload)>1023)
		llMessageLinked(LINK_NUMBER,MESSAGELINKED_TRUNCATEDMESSAGE,"SERVER MESSAGE TRUNCATED: PAYLOAD BUFFER OVERFLOW 1024 BYTES",map_user);

	// Broadcasts message to the whole region. Maximum Payload 1023
	llRegionSay(channel, payload);
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


manageRequest(key requester) {
	string requesting_user = llKey2Name(requester);
	if(canAcceptNewRequest) {
		user_pending = (user_pending=[]) + user_pending + [requesting_user, requester];
		vector pos = llGetPos();
		integer x = (integer)pos.x;
		integer y = (integer)pos.y;
		integer z = (integer)pos.z;
		string  slurl = getSLUrl(llGetRegionName(),pos);
		llInstantMessage(llGetOwner(), format( llList2String(MESSAGES, MSG_IM_REQUEST), [ requesting_user, map_name, llGetRegionName(), x, y, z, llGetListLength(user_pending)>>1, slurl ]) );
	}
	else
		llInstantMessage(
			requester,
		format(
			llList2String(MESSAGES, MSG_IM_CANTACCEPTREQUEST),
		[requesting_user,map_ownername]));
}

// ===[ UTILITY FUNCTIONS ]=======================================
// security check
// nobody can simply forge the correct message digest without knowing the map secret integer
// pass the check if the given md5 matches the computed one with the secret integer
integer check(string md5, string message)
{
	return md5==llMD5String(llGetSubString(message,32+separator_length, -1), map_secret);
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

string findString(list params, integer param)
{
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2String(params,++index);
	else return "";
}

vector findVector(list params, integer param)
{
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2Vector(params,++index);
	else return ZERO_VECTOR;
}

string format(string str, list args)
{
	string pat;
	integer i=0;
	integer pos;
	integer plen;
	integer len = llGetListLength(args);
	for(;i<len;++i){
		pat = "%"+(string)i;
		plen= llStringLength(pat)-1;
		while((pos = llSubStringIndex(str,pat))>-1) {
			str = llInsertString(llDeleteSubString(str,pos,pos+plen),pos,llList2String(args,i));
		}
	}
	return str;
}

string getSLUrl(string nameSim, vector localPos) {
	string slurl = "http://slurl.com/secondlife/";

	slurl += llEscapeURL(nameSim) + "/";
	slurl += (string)llRound(localPos.x) + "/";
	slurl += (string)llRound(localPos.y) + "/";
	slurl += (string)llRound(localPos.z) + "/";

	return slurl;
}

integer min(integer a, integer b) { if(a<b) return a; else return b; }

string version() { return "v"+(string)version_major+"."+(string)version_minor+"."+(string)version_revision; }

//
// ===[ STATES ]=======================================================
//
default
{
	state_entry()
	{
		if(DEBUG) debug(["DEFAULT STATE ENTRY"]);

		//inizialize variables
		init();

		if(DEBUG) debug(["DEFAULT STATE ENTRY done!"]);
	}

	link_message(integer sender_number, integer cmd, string message, key avatar)
	{
		if(DEBUG) debug(["LINK_MESSAGE",cmd,message,llKey2Name(avatar),avatar]);

		if(cmd==MESSAGELINKED_MODULEREADY)
			++module_inited;
		if(module_inited==llGetInventoryNumber(INVENTORY_SCRIPT)-1)
			state inited;
	}

	changed(integer change)
	{
		if(change & CHANGED_OWNER)
			llResetScript();
	}

	state_exit()
	{
		llMessageLinked(LINK_NUMBER,MESSAGELINKED_MAP, (string)map_secret,llGetOwner());
		//sendML(MESSAGELINKED_MAP, (string)map_secret);
	}
}

state inited
{
	touch_start(integer total_number){
		key av = llDetectedKey(0);

		if(av==llGetOwner()) {
			setMapUser(av);
			MenuCall(MENUID_SERVER_START,av);
		}
		else
			MenuCall(MENUID_SERVER_ALL,av);
	}

	link_message(integer sender_number, integer cmd, string message, key avatar)
	{
		if(cmd==MESSAGELINKED_DIALOGRESPONSE) {
			list    params    = llParseString2List(message, [SEPARATOR], []);
			integer menu_id   = findInt(params, PARAM_DIALOG_ID);
			integer button_id = findInt(params, PARAM_DIALOG_BUTTON_ID);

			if(DEBUG) debug(["LINKMESSAGE DIALOG RESPONSE",menu_id, button_id]);

			if(button_id==BUTTONID_INFO) {
				giveInfocard(avatar);
			}
			else if(menu_id==MENUID_SERVER_START) {
				if(button_id==BUTTONID_PRIVATEMAP)       setMapType(MAPTYPE_PRIVATE);
				else if(button_id==BUTTONID_JOINABLEMAP) setMapType(MAPTYPE_JOINABLE);
				else if(button_id==BUTTONID_GROUPMAP)    setMapType(MAPTYPE_GROUP);
				else if(button_id==BUTTONID_PUBLICMAP)   setMapType(MAPTYPE_PUBLIC);

				if(~map_type){
					llListen(CHANNEL_COMMUNICATION,"",NULL_KEY,"");
					rezFirstNode();
				}
			}
		}
	}

	object_rez(key first_node)
	{
		map_main_concept = first_node;
		//llGiveInventoryList(first_node, "", [DEFAULT_NODE,DEFAULT_LINK,DEFAULT_MOVER]);
		llGiveInventory(first_node,DEFAULT_LINK);
		llGiveInventory(first_node,DEFAULT_NODE);
		llGiveInventory(first_node,DEFAULT_MOVER);
	}

	listen(integer channel, string name, key id, string message)
	{
		if(id==map_main_concept){
			fireServerEvent([CMD_NEWNODE,PARAM_NODEKEY,map_main_concept,PARAM_MAPKEY,llGetKey(),PARAM_MAPNODECOUNT,"1",PARAM_USERKEY,map_user,PARAM_MAPTYPE,map_type]);

			state ready;
		}
	}

	state_exit()
	{
		updateTitle();
	}

	changed(integer change)
	{
		if(change & CHANGED_OWNER)
			llResetScript();
	}
}

state ready
{
	state_entry()
	{
		// open channel for listen node<->server messages
		llListen(CHANNEL_COMMUNICATION, "", NULL_KEY, "");
	}

	touch_start(integer total_number){
		key av = llDetectedKey(0);

		// menu only for map owner on private map
		if(av==llGetOwner()){
			if(map_type==MAPTYPE_JOINABLE)
				MenuCall(MENUID_SERVER_ADMINJOIN,av);
			else
				MenuCall(MENUID_SERVER_ADMIN,av);
		}

		else {
			if(map_type==MAPTYPE_PUBLIC)
				MenuCall(MENUID_SERVER_USER,av);
			else if(map_type==MAPTYPE_GROUP){
				if(llSameGroup(av))
					MenuCall(MENUID_SERVER_USER,av);
				else
					MenuCall(MENUID_SERVER_ALL,av);
			}
			else if(map_type==MAPTYPE_JOINABLE){
				if(~llListFindList(llList2ListStrided(llDeleteSubList(user_allowed,0,0),0,-1,2),[av]))
					MenuCall(MENUID_SERVER_USER,av);
				else
					MenuCall(MENUID_SERVER_REQUEST,av);
			}
			else
				MenuCall(MENUID_SERVER_ALL,av);
		}
	}

	link_message(integer sender_number, integer cmd, string message, key avatar)
	{
		if(cmd==MESSAGELINKED_DIALOGRESPONSE) {
			list    params      = llParseString2List(message, [SEPARATOR], []);
			integer menu_id     = findInt(params, PARAM_DIALOG_ID);
			integer button_id   = findInt(params, PARAM_DIALOG_BUTTON_ID);
			string  button_text = findString(params, PARAM_DIALOG_BUTTON_TEXT);

			if(DEBUG) debug(["LINKMESSAGE DIALOG RESPONSE",menu_id, button_id]);

			if(menu_id==MENUID_SERVER_PENDING)
			{
				integer index = llListFindList(llList2ListStrided(user_pending,0,-1,2),[button_text]);
				if(~index)
				{
					index = index << 1;
					llInstantMessage(
						llList2Key(user_pending,index+1),
						format(
							llList2String(MESSAGES,MSG_IM_REQUESTACCEPTED),
						[llList2String(user_pending,index)]));

					user_allowed = (user_allowed=[]) + user_allowed + llList2List(user_pending, index, index + 1);

					user_pending = llDeleteSubList(user_pending, index, index + 1);

				}
			}
			else {

				if(button_id==BUTTONID_INFO)                giveInfocard(avatar);
				else if(button_id==BUTTONID_ALLOWREQUEST)   setAcceptNewRequest(TRUE);
				else if(button_id==BUTTONID_STOPREQUEST)    setAcceptNewRequest(FALSE);
				else if(button_id==BUTTONID_SHOWPENDING){
					MenuCallWithText(MENUID_SERVER_PENDING, llDumpList2String(llList2ListStrided(user_pending,0,-1,2), ","), avatar);
				}
				else if(button_id==BUTTONID_SHOWALLOWED){
					MenuCallWithText(MENUID_SERVER_ALLOWED, llDumpList2String(llList2ListStrided(user_allowed,0,-1,2), ","), avatar);
				}
				else if(button_id==BUTTONID_MODIFYMAP){
					setMapUser(avatar);
					if(map_type!=MAPTYPE_PRIVATE)
						llSetTimerEvent(MODIFY_TIMEOUT);
				}
				else if(button_id==BUTTONID_RELEASE)        setMapUser(NULL_KEY);
				else if(button_id==BUTTONID_REQUEST)        manageRequest(avatar);
				else if(button_id==BUTTONID_SAVE){
					setMapUser(avatar);
					if(map_type!=MAPTYPE_PRIVATE)
						llSetTimerEvent(MODIFY_TIMEOUT);

					fireServerEvent([CMD_SAVE]);            // PARAMS?
				}
				else if(button_id==BUTTONID_CLEARALL) {
					if(avatar==llGetOwner()){
						fireServerEvent([CMD_CLEARMAP]);
						llResetScript();
					}
				}
			}

			//updateTitle();
		}

	}

	listen(integer channel, string name, key id, string message){
		// message on server channel
		if(channel==CHANNEL_COMMUNICATION){
			list     params   = llParseString2List(message, [SEPARATOR], []);
			string   md5      = llList2String(params, 0);
			if(check(md5,message)) {
				integer cmd = llList2Integer(params, 1);

				if(findKey(params,PARAM_MAPKEY)==llGetKey()) {
					if(map_type!=MAPTYPE_PRIVATE)
						llSetTimerEvent(MODIFY_TIMEOUT);
					if(cmd==CMD_SAVED){ // TODO
						key object = findKey(params,PARAM_NODEKEY);
						llMessageLinked(LINK_NUMBER,CMD_SAVE,"",object);
					}
					else if(cmd==CMD_NAME){
						// set map name to first note concept
						if(name==(DEFAULT_NODE+"1"))
							setMapName(findString(params,PARAM_MAPNAME));
					}
					else if(cmd==CMD_ISUSERJOINED){
						key node_user = findKey(params,PARAM_USERKEY);
						if(~llListFindList(llList2ListStrided(llDeleteSubList(user_allowed,0,0),0,-1,2),[node_user]))
							fireServerEvent([CMD_ISUSERJOINED,PARAM_NODEKEY,id,PARAM_USERKEY,node_user]);
					}
				}


			}
		}
	}

	timer(){
		setMapUser(NULL_KEY);
		//updateTitle();
	}

	changed(integer change)
	{
		if(change & CHANGED_OWNER)
			llResetScript();
	}
}