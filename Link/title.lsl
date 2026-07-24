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

// 2007-12-28 v1.0.13: module public interface
// + linked message module reset
// + linked message module ready

// 2007-12-07 v1.0.12: full revision
// + added title script to change prim's hovertext via llMessageLinked
// + linked message to listening on choosen channel for hovertext with timeout
// + linked message to set hovertext title
// + linked message to unset hovertext title (no string over prim)
// + linked message to set hovertext's color
// + linked message to set hovertext's alpha


// ===[ CONSTANTS ]=====================================
float   CHANNEL_TIMEOUT                = 60.0;
string  SEPARATOR                      = "|";

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



// ===[ VARIABLES ]=================================================

integer title_handle;
float   title_alpha = 1.0;
vector  title_color = <1.0, 0.0, 0.0>;
string  title_text;


// ===[ MENU FUNCTIONS ]===============================

setTitle(string title)
{
    title_text = title;
    llSetText(title_text, title_color, title_alpha);
}

setColor(vector color)
{
    title_color = color;
    llSetText(title_text, title_color, title_alpha);
}

setAlpha(float alpha)
{
    title_alpha = alpha;
    llSetText(title_text, title_color, title_alpha);
}

openChannel(integer channel, key id)
{
    // create the listen channel to name change and inactivate it
    title_handle = llListen(channel,"",id,"");

    // set timeout
    llSetTimerEvent(CHANNEL_TIMEOUT);
}

closeChannel()
{
    // remove listen channel
    llListenRemove(title_handle);

    // stop timer event
    llSetTimerEvent(0.0);
}


// ===[ UTILITY FUNCTIONS ]=======================================

string findString(list params, integer param)
{
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2String(params,++index);
    else return "";
}

float findFloat(list params, integer param)
{
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2Float(params,++index);
    else return 1.0;
}

vector findVector(list params, integer param)
{
    integer index = llListFindList(params,[(string)param]);
    if(~index) return llList2Vector(params,++index);
    else return <1.0, 1.0, 1.0>;
}

string version() { return "v"+(string)version_major+"."+(string)version_minor+"."+(string)version_revision; }

//
// ===[ STATES ]=======================================================
//
default
{
    state_entry()
    {
        llMessageLinked(LINK_SET, MESSAGELINKED_MODULEREADY, llGetScriptName()+" "+version(), llGetLinkKey(llGetLinkNumber()));
    }

    listen(integer channel,string name,key id,string message){
        setTitle(message);
        closeChannel();
    }

    link_message(integer sender_number, integer cmd, string message, key id)
    {
        if(cmd==MESSAGELINKED_HOVERTEXT_SET)        {
            list params = llParseString2List(message,[SEPARATOR],[]);
            title_text  = findString(params, PARAM_HOVERTEXT_TEXT);
            title_alpha = findFloat(params, PARAM_HOVERTEXT_ALPHA);
            title_color = findVector(params, PARAM_HOVERTEXT_COLOR);
            llSetText(title_text, title_color, title_alpha);
        }
        else if(cmd==MESSAGELINKED_HOVERTEXT_TEXT)  setTitle(message);
        else if(cmd==MESSAGELINKED_HOVERTEXT_ALPHA) setAlpha((float)message);
        else if(cmd==MESSAGELINKED_HOVERTEXT_COLOR) setColor((vector)message);
        else if(cmd==MESSAGELINKED_HOVERTEXT_UNSET) setTitle("");
        else if(cmd==MESSAGELINKED_LISTEN)          openChannel((integer)message,id);
        else if(cmd==MESSAGELINKED_RESET)           llResetScript();
    }

    timer(){
        closeChannel();
    }
}