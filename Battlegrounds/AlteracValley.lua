print("AV MODULE LOAD")

AV = nil

-- http://wow.gamepedia.com/MapID
local TargetMapId = 401;

-- oQueue переменные
local _next_flag_check = 0 ;
local _instance_faction = nil
local scoreboard = {};
local _flags = nil ;
local _enemy = nil ;
local bgzone = false

do
	AV = Api.NewFrame(function()
		return GetCurrentMapAreaID() == AV.MapId
	end,
	{
		"CHAT_MSG_MONSTER_YELL"
	})
	
	AV.MapId = TargetMapId

	AV:Subscribe()
end

function AV:CHAT_MSG_MONSTER_YELL(message, sender)
	if message == nil or sender == nil then return end
	
	local underAttackMessage = nil
	if sender == _L["Drektar"] and GetBattlefieldArenaFaction() == 0 then 
		underAttackMessage = __merge(_L["Drektar"], _L["UnderAttack"])
	end

	if sender == _L["Vandar"] and GetBattlefieldArenaFaction() == 1 then
		underAttackMessage = __merge(_L["Vandar"], _L["UnderAttack"])
	end

	if underAttackMessage ~= nil then
		PHSay(underAttackMessage)
	end
end


