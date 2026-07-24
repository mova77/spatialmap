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

// 2007-12-07 v1.0.12
// + change title via linked MESSAGES

// 2007-12-07 v1.0.10
// + MESSAGES list as localizable resources
// + menu buttons list and indexing


// ===[ CONSTANTS ]=====================================
integer DEBUG                 = FALSE;
integer LINK_NUMBER           = LINK_SET;
string  SEPARATOR             = "|";

// default object's name
string  DEFAULT_NODE          = "NODE_";
string  DEFAULT_LINK          = "LINK_";
string  DEFAULT_MOVER         = "MOVER";

// channels
integer CHANNEL_COMMUNICATION = -999;
integer CHANNEL_TITLE = 7;

integer MAPTYPE_PRIVATE      = 0; // dont change: this *must* be zero
integer MAPTYPE_GROUP        = 1;
integer MAPTYPE_JOINABLE     = 2;
integer MAPTYPE_PUBLIC       = 3;

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

// MAP
integer MESSAGELINKED_MAP              = 0xC000;


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
integer PARAM_COLOR			 = 0x8111;

// node menu ids
integer MENUID_NODE_FIRSTNODE     = 0x1100;
integer MENUID_NODE_NEWNODE       = 0x1101;
integer MENUID_NODE_COLOR         = 0x1102;
integer MENUID_OTHERS             = 0x1103;

integer BUTTONID_NEXT           = 14;
integer BUTTONID_PREVIOUS       = 15;
integer BUTTONID_NEWNODE        = 16;
integer BUTTONID_CONCEPT        = 17;
integer BUTTONID_MOVENODE       = 18;
integer BUTTONID_SETCOLOR       = 19;
integer BUTTONID_CUTBRANCH      = 20;
integer BUTTONID_CHANGELINK     = 21;
integer BUTTONID_CLEAR          = 22;


// ===[ VARIABLES ]=================================================
vector  node_offset_on_rez    = <0.0, 1.0, 0.0>;
integer separator_length;
key     link_key;
//integer objectrez_handle;

// myself state
integer map_secret;
integer node_id;
integer map_type;
key     node_user;
key     node_parent;
key     node_map;
key     node_mover;
string  node_title;
integer node_counter    = 1;
//key     childObject;
key     user_changing;
list    new_node_user;
list    users_changing_link;
vector  parentOldPosition;

// status flag
integer isSelected      = FALSE;
integer isChangingLink  = FALSE;
integer isLinkEnd       = FALSE;
integer isChangingColor = FALSE;
integer isReady         = FALSE;

// ===[ FUNCTIONS ]====================================================
setNodeUser(key user)
{
	if(DEBUG) debug( ["NODESETUSER",llKey2Name(user),user]);
	node_user = user;
}

setNodeTitle(string title){
	if(DEBUG) debug( ["NODESETTITLE",title]);
	node_title = title;
	fireNodeEvent([CMD_NAME,PARAM_MAPKEY,node_map,PARAM_NODENAME,node_title]);
}

senseImpulse()
{
	// sense an active or passive object in the radius of 15cm all around
	llSensor("",NULL_KEY,ACTIVE|PASSIVE,0.15,PI);
}


// ===[ MESSAGE EVENTS ]====================================
fireNodeEvent(list params)
{
	if(DEBUG) debug(["FIRENODEEVENT"]+params);
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
			llMessageLinked(LINK_NUMBER,MESSAGELINKED_TRUNCATEDMESSAGE,"SERVER MESSAGE TRUNCATED: PAYLOAD BUFFER OVERFLOW 1024 BYTES",node_user);

	}

	// Broadcasts message to the whole region. Maximum Payload 1023
	llRegionSay(channel, payload);
}


// ===[ MENU FUNCTIONS ]===============================
MenuCall(integer menuid, key avatar){
	//list params = [PARAM_DIALOG_ID, menuid];
	fireNodeEvent([CMD_DIALOG, PARAM_MAPKEY, node_map, PARAM_DIALOG_ID, menuid, PARAM_DIALOG_AVATAR, avatar]);
	//llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOG, llDumpList2String(params,SEPARATOR), avatar);
}

MenuCallWithText(integer menuid, string title, key avatar){
	fireNodeEvent([CMD_DIALOG, PARAM_MAPKEY, node_map, PARAM_DIALOG_ID, menuid, PARAM_DIALOG_AVATAR, avatar, PARAM_DIALOG_TITLE, title]);
	//list params = [PARAM_DIALOG_ID, menuid, PARAM_DIALOG_TITLE, title];
	//llMessageLinked(LINK_NUMBER, MESSAGELINKED_DIALOG, llDumpList2String(params,SEPARATOR), avatar);
}

// ===[ UTILITY FUNCTIONS ]=======================================
// security check
// nobody can simply forge the correct message digest without knowing the map secret integer
// pass the check if the given md5 matches the computed one with the secret integer
integer check(string md5, string message)
{
	integer check = md5==llMD5String(llGetSubString(message,32+separator_length, -1), map_secret);
	if(DEBUG) debug( ["MD5CHECK",md5,message,b2s(check)]);
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


string b2s(integer boolean)
{
	return llList2String(["FALSE","TRUE"], boolean==TRUE);
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

string format(string str, list args)
{
	string pat;
	integer i=0;
	integer pos;
	integer plen;
	integer len = llGetListLength(args);
	for(;i<len;++i){
		pat = "%"+(string)i;
		plen= llStringLength(pat) - 1;
		while((pos = llSubStringIndex(str,pat))>-1) {
			str = llInsertString(llDeleteSubString(str,pos,pos+plen),pos,llList2String(args,i));
		}
	}
	return str;
}

string version() { return "v"+(string)version_major+"."+(string)version_minor+"."+(string)version_revision; }


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

		link_key = llGetLinkKey(llGetLinkNumber());
		separator_length = llStringLength(SEPARATOR);

		// start a single ping sensor
		senseImpulse();

		if(DEBUG) debug(["ONREZ secret",secret]);

		// notify new node creation
		fireNodeEvent([CMD_OBJECTREZ]);
	}

	listen(integer channel, string name, key id, string message)
	{
		if(channel==CHANNEL_COMMUNICATION){
			list     params   = llParseString2List(message, [SEPARATOR], []);
			string   md5      = llList2String(params, 0);

			if(DEBUG) debug(["LISTEN",message]);

			if(check(md5,message)) {
				integer cmd = llList2Integer(params, 1);

				// i'm just be rezzed i dunno my own map
				if(cmd==CMD_NEWNODE) {
					// the rezzer node send me
					// [CMD_NEWNODE,PARAM_NODEKEY,child_object,PARAM_MAPKEY,node_map,PARAM_MAPNODECOUNT,node_counter,PARAM_USERKEY,node_user]
					// where child_object is my own key
					if(findKey(params,PARAM_NODEKEY)==llGetKey()) {
						node_parent     = id;
						parentOldPosition = llList2Vector(llGetObjectDetails(id,[OBJECT_POS]),0);
						node_map        = findKey(params, PARAM_MAPKEY);
						node_id         = findInt(params, PARAM_MAPNODECOUNT);
						map_type        = findInt(params, PARAM_MAPTYPE);
						node_counter    = node_id + 1;
						setNodeUser(findKey(params, PARAM_USERKEY));

						integer index 	= llListFindList(params,[PARAM_COLOR]);
						if(~index) 		  llSetColor((vector)llList2String(params,++index),ALL_SIDES);

						llSetObjectName(DEFAULT_NODE+(string)node_id);
						fireNodeEvent([CMD_NODENUMBER,PARAM_MAPKEY,node_map,PARAM_MAPNODECOUNT,node_counter]);
						if(isReady)
							state ready;
						else
							isReady = TRUE;
					}
				}
			}
		}
	}

	changed(integer change){
		if((change & CHANGED_INVENTORY) && llGetInventoryNumber(INVENTORY_OBJECT)>=3){
			if(isReady)
				state ready;
			else
				isReady = TRUE;
		}
	}

	sensor(integer num_detected){
		vector size = llGetScale();
		llSetPos(llGetPos()+<0.0, 0.0, size.z>);
		senseImpulse();
	}
}

state ready
{
	state_entry()
	{
		// open channel for listen node<->server & node<->node messages
		llListen(CHANNEL_COMMUNICATION, "", NULL_KEY, "");

		if(llGetObjectName()!=DEFAULT_NODE+"1"){
			new_node_user = [node_user,NULL_KEY];
			llRezObject(DEFAULT_LINK,llGetPos(),ZERO_VECTOR,llGetRot(),map_secret);
		}
	}

	touch_start(integer total_number){
		key toucher;

		while(total_number--){
			toucher  = llDetectedKey(total_number);
			//if(isChangingLink && ~llListFindList(users_changing_link,[toucher])){
			integer i = llListFindList(users_changing_link,[toucher]);
			if(~i){
				fireNodeEvent([CMD_LINKCHANGE,PARAM_MAPKEY,node_map,PARAM_USERKEY,toucher]);
				users_changing_link = llDeleteSubList(users_changing_link,i,i);
				//isChangingLink = FALSE;

			}
			else if(toucher==node_user){

				// no need to go through other detected
				total_number=0;

				//else{
				if(llGetObjectName()==(DEFAULT_NODE+"1"))
					MenuCall(MENUID_NODE_FIRSTNODE, toucher);
				else
					MenuCall(MENUID_NODE_NEWNODE, toucher);
				isSelected = TRUE;
				//fireNodeEvent([CMD_TOUCH,PARAM_MAPKEY,node_map]);
				//}
				fireNodeEvent([CMD_TOUCH,PARAM_MAPKEY,node_map]);
			}
			else if(toucher==llGetOwner()){
				if(llGetObjectName()==(DEFAULT_NODE+"1"))
					MenuCall(MENUID_NODE_FIRSTNODE, toucher);
				else
					MenuCall(MENUID_NODE_NEWNODE, toucher);
				isSelected = TRUE;
				fireNodeEvent([CMD_TOUCH,PARAM_MAPKEY,node_map]);
			}
			else if(map_type==MAPTYPE_GROUP){
				if(llSameGroup(llDetectedKey(total_number)))
					MenuCall(MENUID_OTHERS,llDetectedKey(total_number));
			}
			else if(map_type==MAPTYPE_JOINABLE){
				fireNodeEvent([CMD_ISUSERJOINED,PARAM_MAPKEY,node_map,PARAM_USERKEY,toucher]);
				//if(~llListFindList(user_allowed,[llKey2Name(llDetectedKey(total_number))]))
				//    MenuCall(MENUID_OTHERS,llDetectedKey(total_number));
			}
			else if(map_type==MAPTYPE_PUBLIC){
				MenuCall(MENUID_OTHERS,llDetectedKey(total_number));
			}
		}
	}

	moving_end(){
		// notify end modify
		fireNodeEvent([CMD_MOVE,PARAM_MAPKEY,node_map,PARAM_POSITION,llGetPos()]);
	}

	object_rez(key child_object){
		//childObject = child_object;
		integer index = llListFindList(new_node_user,[NULL_KEY]);
		new_node_user = llListReplaceList(new_node_user,[child_object],index,index);
	}

	link_message(integer sender_number, integer cmd, string message, key id)
	{
		if(cmd==MESSAGELINKED_HOVERTEXT_SET)
			setNodeTitle(message);

	}

	listen(integer channel,string name, key uuid, string message){
		if(channel==CHANNEL_COMMUNICATION){
			list    params = llParseString2List(message, [SEPARATOR], []);
			string  md5    = llList2String(params, 0);

			if(DEBUG) debug(["LISTEN"]+params);

			if(check(md5,message)) {
				integer cmd = llList2Integer(params, 1);
				key talking_map = findKey(params, PARAM_MAPKEY);

				integer index = llListFindList(new_node_user,[uuid]);

				if(cmd==CMD_OBJECTREZ && ~index)
				{
					//llListenRemove(objectrez_handle);
					key new_user  = llList2Key(new_node_user,index-1);
					new_node_user = llDeleteSubList(new_node_user,index-1,index);
					// check object type and fire proper event
					if(name==DEFAULT_NODE){
						//llGiveInventoryList(uuid, "", [DEFAULT_NODE,DEFAULT_LINK,DEFAULT_MOVER]);
						llGiveInventory(uuid,DEFAULT_LINK);
						llGiveInventory(uuid,DEFAULT_NODE);
						llGiveInventory(uuid,DEFAULT_MOVER);
						fireNodeEvent([CMD_NEWNODE,PARAM_NODEKEY,uuid,PARAM_MAPKEY,node_map,PARAM_MAPNODECOUNT,node_counter,PARAM_USERKEY,new_user,PARAM_MAPTYPE,map_type,PARAM_COLOR,llGetColor(ALL_SIDES)]);			
						node_counter++;
					}
					else if(name==DEFAULT_LINK){
						fireNodeEvent([CMD_NEWLINK,PARAM_LINKKEY,uuid,PARAM_MAPKEY,node_map,PARAM_PARENTKEY,node_parent,PARAM_USERKEY,node_user]);
					}
					else if(name==DEFAULT_MOVER){
						node_mover = uuid;
						fireNodeEvent([CMD_NEWMOVER,PARAM_MOVERKEY,uuid,PARAM_MAPKEY,node_map,PARAM_USERKEY,node_user]);
					}

				}

				//else if(cmd==CMD_NEWNODE && talking_map==node_map)
				//    node_counter = findInt(params, PARAM_MAPNODECOUNT);

				else if(uuid==node_mover){
					vector new_pos = findVector(params,PARAM_POSITION);
					llSetPos(new_pos);
					fireNodeEvent([CMD_MOVE,PARAM_MAPKEY,node_map,PARAM_POSITION,new_pos]);
				}
				else if(talking_map==node_map) {
					if(cmd==CMD_TOUCH){
						if(uuid!=llGetKey())
							isSelected = FALSE;
					}
					else if(cmd==CMD_CUTBRANCH){
						if(findKey(params,PARAM_NODEKEY)==node_parent){
							fireNodeEvent([CMD_CUTBRANCH,PARAM_MAPKEY,node_map,PARAM_NODEKEY,llGetKey(),PARAM_NODEID,node_id]);
							llDie();
						}
					}
					else if(cmd==CMD_MOVE && uuid==node_parent){
						vector parentNewPosition = findVector(params,PARAM_POSITION);
						vector delta = parentNewPosition - parentOldPosition;
						vector pos = llGetPos() + delta;
						llSetPos(pos);
						parentOldPosition = parentNewPosition;
						fireNodeEvent([CMD_MOVE,PARAM_MAPKEY,node_map,PARAM_POSITION,pos]);
					}
					else if(cmd==CMD_LINKCHANGE && uuid!=llGetKey()){
						key changing_user = findKey(params,PARAM_USERKEY);
						if(isLinkEnd && changing_user==user_changing){
							node_parent = uuid;
							isLinkEnd   = FALSE;
							new_node_user = (new_node_user=[]) + new_node_user + [node_user,NULL_KEY];
							llRezObject(DEFAULT_LINK,llGetPos(),ZERO_VECTOR,llGetRot(),map_secret);

						}
						else {
							//isChangingLink = !isChangingLink;
							integer i = llListFindList(users_changing_link,[changing_user]);
							if(~i){
								users_changing_link = llDeleteSubList(users_changing_link,i,i);
							}
							else{
								users_changing_link += [changing_user];

							}
						}
					}
					else if(cmd==CMD_NODENUMBER){
						node_counter = findInt(params,PARAM_MAPNODECOUNT);
					}
				}
				else if(uuid==node_map) {
					// is going to save my map?
					if(cmd==CMD_SAVE){
						// notify the saved status with parameters
						fireNodeEvent([CMD_SAVED,PARAM_MAPKEY,node_map,PARAM_NODEKEY,llGetKey(),PARAM_NODENAME,node_title]);
					}
					// is going to clear all in my map? kill myself
					else if(cmd==CMD_CLEARMAP){
						llDie();
					}
					// is going to change the map node_user? change node ownership
					//else if(cmd==CMD_USER){
					//    setNodeUser(findKey(params,PARAM_USERKEY));
					//}
					else if(cmd==CMD_ISUSERJOINED && findKey(params,PARAM_NODEKEY)==llGetKey()){
						MenuCall(MENUID_OTHERS,findKey(params,PARAM_USERKEY));
					}
					else if(cmd==CMD_DIALOG_RESPONSE && findKey(params,PARAM_NODEKEY)==llGetKey()) {
						integer menu_id   = findInt(params, PARAM_DIALOG_ID);
						integer button_id = findInt(params, PARAM_DIALOG_BUTTON_ID);
						key     id = findKey(params, PARAM_DIALOG_AVATAR);

						if(button_id==BUTTONID_NEWNODE){
							//objectrez_handle = llListen(CHANNEL_COMMUNICATION, "", NULL_KEY, "");
							new_node_user = (new_node_user=[]) + new_node_user + [id,NULL_KEY];
							llRezObject(DEFAULT_NODE,llGetPos()+node_offset_on_rez,ZERO_VECTOR,llGetRot(),map_secret);
						}
						else if((menu_id==MENUID_NODE_FIRSTNODE)||(menu_id==MENUID_NODE_NEWNODE)) {
							if(button_id==BUTTONID_CONCEPT){
								llMessageLinked(LINK_NUMBER, MESSAGELINKED_LISTEN, (string)CHANNEL_TITLE, id);
							}
							else if(button_id==BUTTONID_CLEAR){
								fireNodeEvent([CMD_CLEAR,PARAM_MAPKEY,node_map,PARAM_NODEID,node_id]);
								llDie();
							}
							else if(button_id==BUTTONID_CUTBRANCH){
								fireNodeEvent([CMD_CUTBRANCH,PARAM_MAPKEY,node_map,PARAM_NODEKEY,llGetKey(),PARAM_NODEID,node_id]);
								llDie();
							}
							else if(button_id==BUTTONID_CHANGELINK){
								if(!isLinkEnd){
									isLinkEnd = TRUE;
									user_changing = id;
									//fireNodeEvent([CMD_LINKCHANGE,PARAM_MAPKEY,node_map]);
									fireNodeEvent([CMD_LINKCHANGE,PARAM_MAPKEY,node_map,PARAM_USERKEY,id]);
								}
								else{
									llInstantMessage(id,"Another user is changing this link...");
								}
							}
							else if(button_id==BUTTONID_MOVENODE){
								new_node_user = (new_node_user=[]) + new_node_user + [id,NULL_KEY];
								llRezObject(DEFAULT_MOVER,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,map_secret);
							}
							else if(button_id==BUTTONID_SETCOLOR){
								MenuCall(MENUID_NODE_COLOR,id);
								isChangingColor = TRUE;
							}

							if(!isChangingColor)
								isSelected = FALSE;

						} else if(menu_id==MENUID_NODE_COLOR) {
								llSetLinkColor(LINK_SET,findVector(params,PARAM_COLOR),ALL_SIDES);
							isChangingColor = FALSE;
						}

					}
				}

			}
		}

	}
}