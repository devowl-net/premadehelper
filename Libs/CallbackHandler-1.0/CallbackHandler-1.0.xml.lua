-- Auto generated by WoWBench 3.0.3.a2 from "D:/!Premade/PremadeHelper/PremadeHelper/Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml" on 2016-02-07 17:20:23
local WOWB_XMLFILE="D:/!Premade/PremadeHelper/PremadeHelper/Libs\\CallbackHandler-1.0\\CallbackHandler-1.0.xml";
local WOWB_XMLFILENOPATH="D:/!Premade/PremadeHelper/PremadeHelper/Libs\\CallbackHandler-1.0\\CallbackHandler-1.0.xml";
local WOWB_TAG = { [0]={content=""} }
local WOWB_PARENTOBJECT = WOWB_RootFrame;
local xfpc = WOWB_XMLFileParserContext:New(WOWB_XMLFILE);

do -- <Ui ...>
local WOWB_PARENT = WOWB_TAG;
local bIgnored = false;
xfpc.linenum=1
local WOWB_TAG = { [0]={  xmltag="Ui",   xmlfile=WOWB_XMLFILE,  xmlfilelinenum=1,  children={},  virtual=WOWB_ISVIRTUAL and "true",  content="",
["xmlns"] ="http://www.blizzard.com/wow/ui/",
["xmlns:xsi"] ="http://www.w3.org/2001/XMLSchema-instance",
["xsi:schemaLocation"] ="http://www.blizzard.com/wow/ui/..\\FrameXML\\UI.xsd",
}};
WOWB_PARENT[0]["Ui"] = WOWB_TAG;
do -- <Script ...>
local WOWB_PARENT = WOWB_TAG;
local bIgnored = false;
xfpc.linenum=3
local WOWB_TAG = { [0]={  xmltag="Script",   xmlfile=WOWB_XMLFILE,  xmlfilelinenum=3,  children={},  virtual=WOWB_ISVIRTUAL and "true",  content="",
["file"] ="CallbackHandler-1.0.lua",
}};
if not WOWB_EXECCOMPILED then
  WOWB_ParseXML_dofile(xfpc, WOWB_TAG[0].file);
end
tinsert(WOWB_PARENT[0], WOWB_TAG);
WOWB_ParseXML_CompileScriptNode(xfpc:Recurse(WOWB_TAG), WOWB_TAG);end -- Script
end -- Ui
if(not WOWB_TAG[0][WOWB_ROOTXMLTAG]) then xfpc:error("No <"..WOWB_ROOTXMLTAG.."> tag?"); end
WOWB_ParseXML_QueueScripts(WOWB_TAG[0][WOWB_ROOTXMLTAG]);

xfpc:Return();