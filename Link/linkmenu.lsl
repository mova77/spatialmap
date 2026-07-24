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

// MAP
integer MESSAGELINKED_MAP              = 0xC000;
integer PARAM_MAPNAME                  = 0x8101;
integer PARAM_MAPTYPE                  = 0x8102;
integer PARAM_MAPOWNER                 = 0x8103;

// menu ID
integer MENUID_LINK                    = 0x1200;
integer MENUID_LINK_COLOR              = 0x1201;

list    MENUCOLOR_BUTTONS              = ["WHITE","BLACK","GREEN","CYAN","YELLOW","PINK","RED","BROWN"];
list    MENUCOLOR_VALUE                = [<1,1,1>,<0,0,0>,<0,1,0>,<0.14,0.57,1.0>,<1,1,0>,<1,0.5,1>,<1,0,0>,<0.75,0.5,0>];
string  MENUCOLOR_TITLE                = "Menu ~ Choice color\nSelect a color from:\n%0";

// PRIVATE CONSTANTS
list    MENU_ITEMS;
integer MENU_CHANNEL                   = -1000;
float   MENU_TIMEOUT                   = 60.0;

// menu buttons
list    MENU_BUTTONS                   = ["Next >>", "<< Previous", "Write action","Del action","Del link","Colors"];
integer BUTTONID_NEXT                  = 0;
integer BUTTONID_PREVIOUS              = 1;
integer BUTTONID_WRITEACTION           = 2;
integer BUTTONID_DELETEACTION          = 3;
integer BUTTONID_DELETELINK            = 4;
integer BUTTONID_SETCOLOR              = 5;

// menu mask
integer BUTTONMASK_NEXT                = 0x00001;
integer BUTTONMASK_PREVIOUS            = 0x00002;
integer BUTTONMASK_WRITEACTION         = 0x00004;
integer BUTTONMASK_DELETEACTION        = 0x00008;
integer BUTTONMASK_DELETELINK          = 0x00010;
integer BUTTONMASK_SETCOLOR            = 0x00020;

// menu record
integer MENU_RECORD_ID                 = 0;
integer MENU_RECORD_CHANNEL            = 1;
integer MENU_RECORD_TITLE              = 2;
integer MENU_RECORD_PAGE               = 3;
integer MENU_RECORD_MASK               = 4;
integer MENU_STRIDE                    = 5;

// menu handles record
integer MENUHANDLES_RECORD_TIMESTAMP   = 0;
integer MENUHANDLES_RECORD_AVATAR      = 1;
integer MENUHANDLES_RECORD_CHANNEL     = 2;
integer MENUHANDLES_RECORD_HANDLE      = 3;
integer MENUHANDLES_STRIDE             = 4;

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
		BUTTONMASK_NEXT, BUTTONMASK_PREVIOUS,
		BUTTONMASK_WRITEACTION, BUTTONMASK_DELETEACTION, BUTTONMASK_DELETELINK,
		BUTTONMASK_SETCOLOR];

	MENUS = [
		//  MENU ID        MENU_CHANNEL    MENU TITLE     PAGE MENU MASK
		//MENUID_ALL,      MENU_CHANNEL,   "Menu ~ All",     0, BUTTONMASK_INFO,
		MENUID_LINK,       MENU_CHANNEL,   "Menu ~ Action",   0, BUTTONMASK_WRITEACTION | BUTTONMASK_DELETEACTION | BUTTONMASK_DELETELINK | BUTTONMASK_SETCOLOR,
		MENUID_LINK_COLOR, MENU_CHANNEL-1, "Menu ~ Choice color",   0, -1
			];

	MENUIDS = llList2ListStrided(MENUS,0,-1,MENU_STRIDE);

	link_key = llGetLinkKey(llGetLinkNumber());
	separator_length = llStringLength(SEPARATOR);

	// set garbage collect on menu handles
	llSetTimerEvent(MENU_TIMEOUT);

	sendML(MESSAGELINKED_MODULEREADY, llGetScriptName()+" "+version());
}

// ===[ MENU FUNCTIONS ]===============================

menu(integer menuid, key av)
{
	if(llGetListLength(menu_handles)< (64*MENUHANDLES_STRIDE)) {
		list buttons = [];
		// search for menu id
		integer menu_id = llListFindList(MENUIDS, [menuid]);
		if(~menu_id) {
			menu_id = menu_id*MENU_STRIDE;

			string  menu_title;

			if(menuid==MENUID_LINK_COLOR) {
				buttons    = MENUCOLOR_BUTTONS;
				menu_title = format(MENUCOLOR_TITLE, [numbered(buttons)]);
			} else {
					buttons    = createMenuButtons(menu_id);
				menu_title = format(
					llList2String(MENUS, menu_id + MENU_RECORD_TITLE),
					[map_name, map_type, map_owner]);
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
			openChannel(av, menu_channel);
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


openChannel(key avatar, integer channel)
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
		//llListenRemove(llList2Integer( menu_handles, index + MENUHANDLES_RECORD_HANDLE));

		// open new channel
		integer menu_handle = llListen(channel, "", avatar, "");

		// remove old menu handle
		// and append new one
		menu_handles = (menu_handles = []) +
			llDeleteSubList(menu_handles, index, index+MENUHANDLES_STRIDE-1) +
			[llGetTime(), avatar, channel, menu_handle];


		if(DEBUG)
			llSay(0,
			format("OPENCHANNEL remove handle index:%0 create handle:%1 time:%2 avatarkey:%3 avatarname:%4 channel:%5",
			[index, menu_handle, llGetTime(), avatar, llKey2Name(avatar), channel ]));
	} else {
			// open new channel
			integer menu_handle = llListen(channel, "", avatar, "");

		// append menu handles
		menu_handles = (menu_handles = []) + menu_handles + [llGetTime(), avatar, channel, menu_handle];

		if(DEBUG)
			llSay(0,
			format("OPENCHANNEL create handle:%0 time:%1 avatarkey:%2 avatarname:%3 channel:%4",
			[menu_handle, llGetTime(), avatar, llKey2Name(avatar), channel ]));
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

debug(string message)
{
	sendML(MESSAGELINKED_DEBUG, message);
}

sendML(integer messagelinked, string message)
{
	llMessageLinked(LINK_NUMBER, messagelinked, message, link_key);
}

// search for the param into the list
// return the paired value or NULL_KEY

key findKey(list params, integer param)
{
	if(DEBUG) debug( format("NODEMENUFINDKEY param:%0 params:%1",[param,llDumpList2String(params, ", ")]));
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2Key(params,++index);
	else return NULL_KEY;
}

integer findInt(list params, integer param)
{
	if(DEBUG) debug( format("NODEMENUFINDINT param:%0 params:%1",[param,llDumpList2String(params, ", ")]));
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2Integer(params,++index);
	else return -1;
}

string findString(list params, integer param)
{
	if(DEBUG) debug( format("NODEMENUFINDSTRING param:%0 params:%1",[param,llDumpList2String(params, ", ")]));
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2String(params,++index);
	else return "";
}


string numbered(list _list)
{
	string numberedlist;
	integer ii = llGetListLength(_list);
	integer i=0;
	for(;i<ii;++i)
		numberedlist += (string)(i+1)+". "+llList2String(_list, i)+"\n";
	return numberedlist;
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

	link_message(integer linknum, integer cmd, string text, key av)
	{
		if(cmd==MESSAGELINKED_RESET)
			llResetScript();
		else if(cmd==MESSAGELINKED_DIALOG) {
			list    params  = llParseString2List(text, [SEPARATOR], []);
			integer menu_id = findInt(params, PARAM_DIALOG_ID);

			if(~llListFindList(MENUIDS, [menu_id]))
				menu(menu_id,av);
		}
		else if(cmd==MESSAGELINKED_MAP) {
			list params = llParseString2List(text, [SEPARATOR], []);

			map_name  = findString(params, PARAM_MAPNAME);
			map_owner = findString(params, PARAM_MAPOWNER);
			map_type  = findString(params, PARAM_MAPTYPE);
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

			if(menu_index>=0) {
				if(message==llList2String(MENU_BUTTONS,BUTTONID_PREVIOUS)){
					goPreviousPage(menu_index);
					menu(menu_id, av);
				} else if(message==llList2String(MENU_BUTTONS,BUTTONID_NEXT)){
						goNextPage(menu_index);
					menu(menu_id, av);
				} else if(message==llList2String(MENU_BUTTONS,BUTTONID_SETCOLOR)) {
						menu(MENUID_LINK_COLOR,av);
				}
				else if(menu_id==MENUID_LINK_COLOR) {
					//list lButtons = MENUCOLOR_BUTTONS;
					//list sButtons = shortButtons(lButtons);
					//integer index2 = llListFindList(sButtons, [message]);
					integer index2 = llListFindList(MENUCOLOR_BUTTONS, [message]);
					vector color_vector = llList2Vector(MENUCOLOR_VALUE,index2);
					list params = [PARAM_DIALOG_ID,menu_id,PARAM_DIALOG_COLOR,color_vector];
					llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOGRESPONSE, llDumpList2String(params,SEPARATOR), av);
				}
				else{
					list lButtons = createMenuButtons(menu_index);
					list sButtons = shortButtons(lButtons);

					integer index2 = llListFindList(sButtons, [message]);
					integer button_id = llListFindList(MENU_BUTTONS, [llList2String(lButtons, index2)]);
					list params = [PARAM_DIALOG_ID,menu_id,PARAM_DIALOG_BUTTON_ID,button_id];
					llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOGRESPONSE, llDumpList2String(params,SEPARATOR), av);

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

