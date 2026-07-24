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
integer version_revision = 17;

// 2007-12-07 v1.0.13: first revision
// + linked message menu
// + full multi user menu

// ===[ CONSTANTS ]=====================================
integer DEBUG                         = FALSE;
integer LINK_NUMBER                   = LINK_SET;
string  SEPARATOR                     = "|";

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
integer PARAM_COLOR			 		= 0x8111;


// MOVER
integer MESSAGELINKED_MOVER_OFFSET     = 0xC100;

// menu ID
integer MENUID_ALL                     = 0x1000;
integer MENUID_START                   = 0x1001;
integer MENUID_ADMINJOIN               = 0x1002;
integer MENUID_ADMIN                   = 0x1003;
integer MENUID_USER                    = 0x1004;
integer MENUID_REQUEST                 = 0x1005;
integer MENUID_PENDING                 = 0x1007;
integer MENUID_ALLOWED                 = 0x1008;
integer MENUID_FIRSTNODE       		   = 0x1100;
integer MENUID_NEWNODE         	  	   = 0x1101;
integer MENUID_COLOR              	   = 0x1102;
integer MENUID_OTHERS             	   = 0x1103;

list    MENUCOLOR_BUTTONS       = ["WHITE","BLACK","GREEN","CYAN","YELLOW","PINK","RED","BROWN"];
list    MENUCOLOR_VALUE         = [<1,1,1>,<0,0,0>,<0,1,0>,<0.14,0.57,1.0>,<1,1,0>,<1,0.5,1>,<1,0,0>,<0.75,0.5,0>];
string  MENUCOLOR_TITLE         = "Menu ~ Choice color\nSelect a color from:\n%0";

// PRIVATE CONSTANTS
list    MENU_ITEMS;
integer MENU_CHANNEL            = -1000;
float   MENU_TIMEOUT            = 60.0;
string  MENU_TITLE              = "\nMap name    : %0\nMap owner    : %1\nMap type    : %2\n\nChoose an option:";
string  MENU_PENDING_TITLE      = "Menu ~ Pending\nPending user:\n%0";
string  MENU_ALLOWED_TITLE      = "Menu ~ Allowed User\nAllowed user joined to map's group:\n%0";

// menu buttons
list    MENU_BUTTONS            = [
	"Private Map",   "Group Map",       "Joinable Map",   "Public Map",
	"Modify map",    "Save",            "Clear all",      "Release",
	"Request",       "Info",            "Pending",        "Allowed",
	"AllowRequest",  "Stop Request",    "Next >>",        "<< Previous",
	"New node",		 "Concept",			"Move node",	  "Colors",
	"Cut branch",	 "Change Link",		"Clear"];
integer BUTTONID_PRIVATEMAP     = 0;
integer BUTTONID_GROUPMAP       = 1;
integer BUTTONID_JOINABLEMAP    = 2;
integer BUTTONID_PUBLICMAP      = 3;
//integer BUTTONID_MODIFYMAP      = 4;
integer BUTTONID_SAVE           = 5;
integer BUTTONID_CLEARALL       = 6;
integer BUTTONID_RELEASE        = 7;
//integer BUTTONID_REQUEST        = 8;
integer BUTTONID_INFO           = 9;
integer BUTTONID_SHOWPENDING    = 10;
integer BUTTONID_SHOWALLOWED    = 11;
integer BUTTONID_ALLOWREQUEST   = 12;
integer BUTTONID_STOPREQUEST    = 13;
integer BUTTONID_NEXT           = 14;
integer BUTTONID_PREVIOUS       = 15;
integer BUTTONID_NEWNODE        = 16;
integer BUTTONID_CONCEPT        = 17;
integer BUTTONID_MOVENODE       = 18;
integer BUTTONID_SETCOLOR       = 19;
integer BUTTONID_CUTBRANCH      = 20;
integer BUTTONID_CHANGELINK     = 21;
integer BUTTONID_CLEAR          = 22;

// menu mask
integer BUTTONMASK_PRIVATEMAP   = 0x0000001;
integer BUTTONMASK_GROUPMAP     = 0x0000002;
integer BUTTONMASK_JOINABLEMAP  = 0x0000004;
integer BUTTONMASK_PUBLICMAP    = 0x0000008;
integer BUTTONMASK_INFO         = 0x0000010;
integer BUTTONMASK_SAVE         = 0x0000020;
integer BUTTONMASK_CLEARALL     = 0x0000040;
integer BUTTONMASK_MODIFYMAP    = 0x0000080;
integer BUTTONMASK_RELEASE      = 0x0000100;
integer BUTTONMASK_REQUEST      = 0x0000200;
integer BUTTONMASK_ACCEPT       = 0x0000400;
integer BUTTONMASK_DECLINE      = 0x0000800;
integer BUTTONMASK_STOPREQUEST  = 0x0001000;
integer BUTTONMASK_ALLOWREQUEST = 0x0002000;
integer BUTTONMASK_SHOWALLOWED  = 0x0004000;
integer BUTTONMASK_SHOWPENDING  = 0x0008000;
integer BUTTONMASK_NEXT         = 0x0010000;
integer BUTTONMASK_PREVIOUS     = 0x0020000;
integer BUTTONMASK_NEWNODE      = 0x0040000;
integer BUTTONMASK_CONCEPT      = 0x0080000;
integer BUTTONMASK_MOVENODE     = 0x0100000;
integer BUTTONMASK_SETCOLOR     = 0x0200000;
integer BUTTONMASK_CUTBRANCH    = 0x0400000;
integer BUTTONMASK_CHANGELINK   = 0x0800000;
integer BUTTONMASK_CLEAR        = 0x1000000;

// menu record
integer MENU_RECORD_ID      = 0;
integer MENU_RECORD_CHANNEL = 1;
integer MENU_RECORD_TITLE   = 2;
integer MENU_RECORD_PAGE    = 3;
integer MENU_RECORD_MASK    = 4;

integer MENU_STRIDE         = 5;

// menu handles record
integer MENUHANDLES_RECORD_TIMESTAMP = 0;
integer MENUHANDLES_RECORD_AVATAR    = 1;
integer MENUHANDLES_RECORD_CHANNEL   = 2;
integer MENUHANDLES_RECORD_HANDLE    = 3;
integer MENUHANDLES_RECORD_NODE      = 4;

integer MENUHANDLES_STRIDE           = 5;

// menu list
list    MENUS;
list    MENUIDS;


// ===[ VARIABLES ]====================================================
list    menu_handles;

string  map_name;
string  map_owner;
string  map_type;
integer link_number = LINK_SET;
key     link_key;
integer separator_length;

// ===[ INIT ]====================================================

init(){
	if(DEBUG)
		llSay(0, version());

	MENU_ITEMS = [
		BUTTONMASK_PRIVATEMAP,   BUTTONMASK_GROUPMAP,     BUTTONMASK_JOINABLEMAP,   BUTTONMASK_PUBLICMAP,
		BUTTONMASK_MODIFYMAP,    BUTTONMASK_SAVE,         BUTTONMASK_CLEARALL,      BUTTONMASK_RELEASE,
		BUTTONMASK_REQUEST,      BUTTONMASK_INFO,         BUTTONMASK_SHOWPENDING,   BUTTONMASK_SHOWALLOWED,
		BUTTONMASK_ALLOWREQUEST, BUTTONMASK_STOPREQUEST,  BUTTONMASK_NEXT,          BUTTONMASK_PREVIOUS,
		BUTTONMASK_NEWNODE,   	 BUTTONMASK_CONCEPT,   	  BUTTONMASK_MOVENODE,		BUTTONMASK_SETCOLOR,
		BUTTONMASK_CUTBRANCH,	 BUTTONMASK_CHANGELINK,	  BUTTONMASK_CLEAR
			];

	MENUS = [
		// MENU ID     		MENU_CHANNEL     MENU TITLE     PAGE MENU MASK
		// MENUID_ALL,  	MENU_CHANNEL,    "Menu ~ All",     0, BUTTONMASK_INFO,
		MENUID_ALL,     	MENU_CHANNEL,    "Menu ~ All",     0, BUTTONMASK_INFO,
		MENUID_START,   	MENU_CHANNEL-1,  "Menu ~ Start",   0, BUTTONMASK_INFO | BUTTONMASK_PRIVATEMAP  | BUTTONMASK_GROUPMAP    | BUTTONMASK_JOINABLEMAP  | BUTTONMASK_PUBLICMAP,
		MENUID_ADMINJOIN,   MENU_CHANNEL-2,  "Menu ~ Admin",   0, BUTTONMASK_INFO | BUTTONMASK_SHOWALLOWED | BUTTONMASK_SHOWPENDING | BUTTONMASK_ALLOWREQUEST | BUTTONMASK_STOPREQUEST | BUTTONMASK_SAVE | BUTTONMASK_CLEARALL,
		MENUID_ADMIN, 		MENU_CHANNEL-4,  "Menu ~ Release", 0, BUTTONMASK_INFO | BUTTONMASK_SAVE | BUTTONMASK_CLEARALL,
		MENUID_USER,    	MENU_CHANNEL-3,  "Menu ~ User",    0, BUTTONMASK_INFO | BUTTONMASK_SAVE,
		MENUID_REQUEST, 	MENU_CHANNEL-5,  "Menu ~ Request", 0, BUTTONMASK_INFO | BUTTONMASK_REQUEST,
		MENUID_PENDING, 	MENU_CHANNEL-6,  "", 0, -1,
		MENUID_ALLOWED, 	MENU_CHANNEL-7,  "", 0, -1,
		MENUID_FIRSTNODE, 	MENU_CHANNEL-8,  "Menu ~ Main concept",   0, BUTTONMASK_NEWNODE | BUTTONMASK_CONCEPT | BUTTONMASK_MOVENODE | BUTTONMASK_SETCOLOR,
		MENUID_NEWNODE,   	MENU_CHANNEL-9,  "Menu ~ Create concept", 0, BUTTONMASK_NEWNODE | BUTTONMASK_CONCEPT | BUTTONMASK_MOVENODE | BUTTONMASK_SETCOLOR | BUTTONMASK_CUTBRANCH | BUTTONMASK_CHANGELINK | BUTTONMASK_CLEAR,
		MENUID_COLOR,     	MENU_CHANNEL-10, "Menu ~ Choice color",   0, -1,
		MENUID_OTHERS,    	MENU_CHANNEL-11, "Menu ~ Create new concept", 0, BUTTONMASK_NEWNODE
			];

	MENUIDS = llList2ListStrided(MENUS,0,-1,MENU_STRIDE);

	link_key = llGetLinkKey(llGetLinkNumber());
	separator_length = llStringLength(SEPARATOR);

	// set garbage collect on menu handles
	llSetTimerEvent(MENU_TIMEOUT);

	sendML(MESSAGELINKED_MODULEREADY, llGetScriptName()+" "+version());
}

// ===[ MENU FUNCTIONS ]===============================

menu(integer menuid, key av, key node)
{
	if(llGetListLength(menu_handles)< (64*MENUHANDLES_STRIDE)) {
		list buttons = [];
		// search for menu id
		integer menu_id = llListFindList(MENUIDS, [menuid]);
		if(~menu_id) {
			menu_id = menu_id*MENU_STRIDE;

			string  menu_title = llList2String(MENUS, menu_id + MENU_RECORD_TITLE);

			if(menuid==MENUID_PENDING) {
				buttons    = llParseString2List(menu_title, [","], []);
				menu_title = format(MENU_PENDING_TITLE, [numbered(buttons)]);
			} else if(menuid==MENUID_ALLOWED){
					menu_title = format(MENU_ALLOWED_TITLE, [numbered(llParseString2List(menu_title, [","], []))]);
			} else if(menuid==MENUID_COLOR) {
				buttons    = MENUCOLOR_BUTTONS;
				menu_title = format(MENUCOLOR_TITLE, [numbered(buttons)]);
			}
			else {
				buttons    = createMenuButtons(menu_id);
				menu_title = format(menu_title,[map_name, map_type, map_owner]);
			}

			integer num_buttons = llGetListLength(buttons);
			if(num_buttons>12){
				integer menu_page = llList2Integer(MENUS, menu_id + MENU_RECORD_PAGE);
				integer last_page = (integer)((num_buttons-11)/10);
				if(((num_buttons-11)%10)!=0 && (num_buttons-22)%10!=0)
					++last_page;
				if(menu_page==0){
					buttons =
						llList2List(buttons,0,10)+
						llList2List(MENU_BUTTONS, BUTTONID_NEXT, BUTTONID_NEXT);
				}
				else if(menu_page==last_page){
					buttons =
						llList2List(MENU_BUTTONS, BUTTONID_PREVIOUS, BUTTONID_PREVIOUS)+
						llList2List(buttons,(menu_page*10)+1,-1);
				}
				else{
					menu_page *= 10;
					buttons=
						llList2List(MENU_BUTTONS, BUTTONID_PREVIOUS, BUTTONID_PREVIOUS)+
						llList2List(buttons,menu_page+1,menu_page+10)+
						llList2List(MENU_BUTTONS, BUTTONID_NEXT, BUTTONID_NEXT);
				}
			}

			integer menu_channel = llList2Integer(MENUS, menu_id+MENU_RECORD_CHANNEL);
			llDialog(av, llGetSubString(menu_title,0,255), shortButtons(buttons), menu_channel);
			openChannel(av, menu_channel, node);
		}
		else
			sendML(MESSAGELINKED_ILLEGALPARAM, "No menu id...");
	} else
	sendML(MESSAGELINKED_LISTOVERFLOW, "No more menu channel available...");
}

// @param  menuid
// @return menu buttons from menu mask
list createMenuButtons(integer menuid)
{
	integer mask = llList2Integer(MENUS, menuid + MENU_RECORD_MASK);
	list buttons = [];
	integer i=0;
	integer l=llGetListLength(MENU_ITEMS);
	for(;i<l;++i)
		if(mask & llList2Integer(MENU_ITEMS,i))
			buttons += llList2String(MENU_BUTTONS,i);
	return buttons;
}

list shortButtons(list longbuttons)
{
	list shortbutton;
	integer i = 0;
	integer l = llGetListLength(longbuttons);
	for(;i<l;++i)
		shortbutton += [llGetSubString(llList2String(longbuttons,i),0,11)];
	return shortbutton;
}


openChannel(key avatar, integer channel,key node)
{
	//                0                           1                            2                            3
	//0:  MENUHANDLES_RECORD_TIMESTAMP    MENUHANDLES_RECORD_AVATAR    MENUHANDLES_RECORD_CHANNEL   MENUHANDLES_RECORD_HANDLE
	//4:  MENUHANDLES_RECORD_TIMESTAMP    MENUHANDLES_RECORD_AVATAR    MENUHANDLES_RECORD_CHANNEL   MENUHANDLES_RECORD_HANDLE
	//8:  MENUHANDLES_RECORD_TIMESTAMP    MENUHANDLES_RECORD_AVATAR    MENUHANDLES_RECORD_CHANNEL   MENUHANDLES_RECORD_HANDLE
	//12: MENUHANDLES_RECORD_TIMESTAMP    MENUHANDLES_RECORD_AVATAR    MENUHANDLES_RECORD_CHANNEL   MENUHANDLES_RECORD_HANDLE
	//16: MENUHANDLES_RECORD_TIMESTAMP    MENUHANDLES_RECORD_AVATAR    MENUHANDLES_RECORD_CHANNEL   MENUHANDLES_RECORD_HANDLE


	integer index = llListFindList( llList2ListStrided( llDeleteSubList(menu_handles, 0, 0), 0, -1, MENUHANDLES_STRIDE), [avatar] );

	// avatar is listening?
	if(~index)
	{
		index *= MENUHANDLES_STRIDE;

		// close used channel
		//llListenRemove(llList2Integer( menu_handles, index + MENUHANDLES_RECORD_CHANNEL));

		// open new channel
		integer menu_handle = llListen(channel, "", avatar, "");

		// remove old menu handle
		// and append new one
		menu_handles = (menu_handles = []) +
						llDeleteSubList(menu_handles, index, index+MENUHANDLES_STRIDE-1) +
						[llGetTime(), avatar, channel, menu_handle,node];


		if(DEBUG) debug(["OPENCHANNEL",index, menu_handle, llGetTime(), avatar, llKey2Name(avatar), channel ]);
	} else {
		// open new channel
		integer menu_handle = llListen(channel, "", avatar, "");

		// append menu handles
		menu_handles = (menu_handles = []) + menu_handles + [llGetTime(), avatar, channel, menu_handle, node];

		if(DEBUG) debug(["OPENCHANNEL",menu_handle, llGetTime(), avatar, llKey2Name(avatar), channel, node ]);
	}

}

goPreviousPage(integer menu_index) {
	integer index = menu_index + MENU_RECORD_PAGE;
	MENUS = llListReplaceList( MENUS,[llList2Integer(MENUS, index)-1], index, index );
}

goNextPage(integer menu_index) {
	integer index = menu_index + MENU_RECORD_PAGE;
	MENUS = llListReplaceList( MENUS,[llList2Integer(MENUS, index)+1], index, index );
}

// ===[ UTILITY FUNCTIONS ]=======================================

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
	if(DEBUG) debug( ["MENUFINDKEY",param,llDumpList2String(params, ", ")]);
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2Key(params,++index);
	else return NULL_KEY;
}

integer findInt(list params, integer param)
{
	if(DEBUG) debug( ["MENUFINDINT",param,llDumpList2String(params, ", ")]);
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2Integer(params,++index);
	else return -1;
}

string findString(list params, integer param)
{
	if(DEBUG) debug( ["MENUFINDSTRING",param,llDumpList2String(params, ", ")]);
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2String(params,++index);
	else return "";
}


string numbered(list _list)
{
	string pending;
	integer ii = llGetListLength(_list);
	integer i=0;
	for(;i<ii;++i)
		pending += (string)(i+1)+". "+llList2String(_list, i)+"\n";
	return pending;
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

string version() { return llGetScriptName()+ " v"+(string)version_major+"."+(string)version_minor+"."+(string)version_revision; }

//
// ===[ STATES ]=======================================================
//
default
{
	state_entry()
	{
		//inizialize variables
		init();
	}

	link_message(integer sender_number, integer cmd, string text, key av)
	{
		if(cmd==MESSAGELINKED_RESET)
			llResetScript();
		else if(cmd==MESSAGELINKED_DIALOG) {
			list    params  = llParseString2List(text, [SEPARATOR], []);
			integer menu_id = findInt(params, PARAM_DIALOG_ID);
			key node = findKey(params, PARAM_NODEKEY);
			if(menu_id==MENUID_PENDING) {
				integer index      = MENU_STRIDE * llListFindList(MENUIDS, [MENUID_PENDING]);
				string  menu_title = findString(params, PARAM_DIALOG_TITLE);
				MENUS              = llListReplaceList( MENUS, [menu_title], index + MENU_RECORD_TITLE, index + MENU_RECORD_TITLE);
				menu(menu_id, av, node);
			}
			else if(menu_id==MENUID_ALLOWED) {
				integer index     = MENU_STRIDE * llListFindList(MENUIDS, [MENUID_ALLOWED] ) ;
				string menu_title = findString(params, PARAM_DIALOG_TITLE);
				MENUS             = llListReplaceList( MENUS, [menu_title], index + MENU_RECORD_TITLE, index + MENU_RECORD_TITLE);
				menu(menu_id, av, node);
			} else if(~llListFindList(MENUIDS,[menu_id])) {
					menu(menu_id, av, node);
			}
		}
		else if(cmd==MESSAGELINKED_MAP) {
			list params = llParseString2List(text, [SEPARATOR], []);

			string s;
			if((s=findString(params, PARAM_MAPNAME ))!="") map_name  = s;
			if((s=findString(params, PARAM_MAPOWNER))!="") map_owner = s;
			if((s=findString(params, PARAM_MAPTYPE ))!="") map_type  = s;
		}
	}


	listen(integer channel, string name, key av, string message)
	{
		integer index = llListFindList(menu_handles, [av, channel]);
		if(~index)
		{
			llListenRemove(llList2Integer(menu_handles, index + (MENUHANDLES_RECORD_HANDLE-MENUHANDLES_RECORD_AVATAR)));
			list menu_channels = llList2ListStrided(llDeleteSubList(MENUS, 0, MENU_RECORD_CHANNEL-1), 0, -1, MENU_STRIDE);
			integer menu_index = MENU_STRIDE*llListFindList(menu_channels, [channel]);
			integer menu_id    = llList2Integer(MENUS, menu_index);
			key node = llList2Key(menu_handles,index + (MENUHANDLES_RECORD_NODE-MENUHANDLES_RECORD_AVATAR));

			if(menu_index>=0) {
				if(message==llList2String(MENU_BUTTONS,BUTTONID_PREVIOUS)){
					goPreviousPage(menu_index);
					menu(menu_id, av,node);
				} else if(message==llList2String(MENU_BUTTONS,BUTTONID_NEXT)){
					goNextPage(menu_index);
					menu(menu_id, av,node);
				} else if(message==llList2String(MENU_BUTTONS,BUTTONID_SETCOLOR)) {
					menu(MENUID_COLOR,av,node);
				}
				else if(menu_id==MENUID_COLOR) {
					//list lButtons = MENUCOLOR_BUTTONS;
					//list sButtons = shortButtons(lButtons);
					//integer index2 = llListFindList(sButtons, [message]);
					integer index2 		= llListFindList(MENUCOLOR_BUTTONS, [message]);
					vector color_vector = llList2Vector(MENUCOLOR_VALUE,index2);
					list params 		= [PARAM_DIALOG_ID,menu_id,PARAM_COLOR,color_vector,PARAM_NODEKEY,node];
					llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOGRESPONSE, llDumpList2String(params,SEPARATOR), av);
				}
				else{
					list lButtons = [];
					if(menu_id==MENUID_PENDING) {
						string menu_title = llList2String(MENUS, menu_index + MENU_RECORD_TITLE);
						lButtons = llParseString2List(menu_title, [SEPARATOR], []);
					}
					else {
						lButtons = createMenuButtons(menu_index);
					}
					list    sButtons = shortButtons(lButtons);

					integer index2 = llListFindList(sButtons, [message]);

					string  button_text = llList2String(lButtons, index2);
					
					//integer button_id   = llListFindList(MENU_BUTTONS, [button_text]);
					integer button_id = llListFindList(MENU_BUTTONS, [llList2String(lButtons, index2)]);

					list 	params = [PARAM_DIALOG_ID, menu_id, PARAM_DIALOG_BUTTON_ID, button_id, PARAM_DIALOG_BUTTON_TEXT, button_text, PARAM_NODEKEY, node];
					
					llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOGRESPONSE, llDumpList2String(params, SEPARATOR), av);
				}
			}
		}
	}

	timer()
	{
		float channeltime;
		float time = llGetTime();
		integer i = 0;

		while(i<llGetListLength(menu_handles))
		{
			channeltime = llList2Float(menu_handles, i);
			if(time - channeltime > MENU_TIMEOUT)
				menu_handles = llDeleteSubList( menu_handles, i, i + MENUHANDLES_STRIDE-1 );
			else
				i+=MENUHANDLES_STRIDE;
		}
	}
}

