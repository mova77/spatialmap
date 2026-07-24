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

// 2007-12-07 v1.0.17: proxymenu: MD5 Listened Message <-> MessageLinked

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

// MAP
integer MESSAGELINKED_MAP              = 0xC000;

// map message commands
// commands
integer CMD_DIALOG           = 0x8013;
integer CMD_DIALOG_RESPONSE  = 0x8014;

// map command's params
integer PARAM_MAPKEY         = 0x8100;
integer PARAM_NODEKEY        = 0x810C;

// ===[ VARIABLES ]============================================================================
key     link_key;
integer map_secret;
integer separator_length;

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

	if(llStringLength(payload)>1023) {
		key map_user = findKey(params, PARAM_DIALOG_AVATAR);
		llMessageLinked(LINK_NUMBER,MESSAGELINKED_TRUNCATEDMESSAGE,"SERVER MESSAGE TRUNCATED: PAYLOAD BUFFER OVERFLOW 1024 BYTES",map_user);
	}

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


string findString(list params, integer param)
{
	integer index = llListFindList(params,[(string)param]);
	if(~index) return llList2String(params,++index);
	else return "";
}

debug(list _list)
{
	sendML(MESSAGELINKED_DEBUG, llGetScriptName()+SEPARATOR+llDumpList2String(_list,SEPARATOR));
}

sendML(integer messagelinked, string message)
{
	llMessageLinked(LINK_NUMBER, messagelinked, message, link_key);
}
string version() { return " v"+(string)version_major+"."+(string)version_minor+"."+(string)version_revision; }

//
// ===[ STATES ]=======================================================
//
default
{
	state_entry()
	{

		link_key = llGetLinkKey(llGetLinkNumber());
		separator_length = llStringLength(SEPARATOR);

		sendML(MESSAGELINKED_MODULEREADY, llGetScriptName()+" "+version());
	}

	link_message(integer sender_number, integer cmd, string text, key av)
	{
		if(cmd==MESSAGELINKED_RESET)
			llResetScript();
		else if(cmd==MESSAGELINKED_MAP){
			map_secret = (integer)text;
			state ready;
		}
	}
}

state ready
{
	state_entry()
	{llListen(CHANNEL_COMMUNICATION,"",NULL_KEY,"");
		}
	link_message(integer sender_number, integer cmd, string text, key av)
	{
		if(cmd==MESSAGELINKED_RESET)
			llResetScript();
		else if(cmd==MESSAGELINKED_DIALOGRESPONSE){

			list    params    = llParseString2List(text, [SEPARATOR], []);
			//integer menu_id   = findInt(params, PARAM_DIALOG_ID);
			//integer button_id = findInt(params, PARAM_DIALOG_BUTTON_ID);
			//key node = findKey(params, PARAM_NODEKEY);
			//fireServerEvent([CMD_DIALOG_RESPONSE,PARAM_NODEKEY,node,PARAM_DIALOG_ID,menu_id,PARAM_DIALOG_BUTTON_ID,button_id,PARAM_DIALOG_AVATAR,av]);
			fireServerEvent([CMD_DIALOG_RESPONSE]+params+[PARAM_DIALOG_AVATAR,av]);

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
					if(cmd==CMD_DIALOG)
					{
						key avatar = findKey(params, PARAM_DIALOG_AVATAR);
						integer menuid = findInt(params, PARAM_DIALOG_ID);
						string  menutitle = findString(params, PARAM_DIALOG_TITLE);
						key node = id;
						list menuparams = [PARAM_NODEKEY,node,PARAM_DIALOG_ID, menuid];
						if(menutitle!="")
							menuparams+= [PARAM_DIALOG_TITLE,menutitle];
						llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOG, llDumpList2String(menuparams,SEPARATOR), avatar);
					}
				}


			}
		}
	}

}
