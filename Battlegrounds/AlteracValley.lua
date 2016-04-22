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


-- local unit = "boss1" 
-- local health = UnitHealth(unit);
-- print(health)


--local unit = "boss2"
--distanceSquared, checkedDistance = UnitDistanceSquared(unit)

--print("distanceSquared "..distanceSquared.. " checkedDistance "..tostring(checkedDistance))

function AV:CHAT_MSG_MONSTER_YELL(message, sender)
	if message == nil or sender == nil then return end
	
	local underAttackMessage = nil
	if sender == _L["Drektar"] then 
		underAttackMessage = __merge(_L["Drektar"], _L["UnderAttack"])
	elseif sender == _L["Vandar"] then
		-- underAttackMessage = __merge(_L["Vandar"], _L["UnderAttack"])
	end

	if underAttackMessage ~= nil then
		local message = Common:FormatInstanceMessage(underAttackMessage)
		SendChatMessage(message, "INSTANCE_CHAT" )
	end
end

function BattlegroundEnterOrLeave()
	--if (Common.IsInsidePvpZone())  then
	--	local currentZone = GetCurrentMapAreaID()
	--	if not bgzone and currentZone == TargetMapId then
	--		frame:RegisterEvent("SPELL_CAST_SUCCESS")
	--		scoreboard = {};
	--		print("++ANY++ Alterac Valley helper activated")
	--		_next_flag_check = time()
	--		bgzone = true
	--	else
	--		print("Alterac Valley OFF")
	--		frame:UnregisterEvent("SPELL_CAST_SUCCESS")
	--		bgzone = false
	--	end
	--end
end

function AV:SPELL_CAST_SUCCESS(...)
   print("SPELL_CAST_SUCCESS")
end

function AV:UPDATE_BATTLEFIELD_SCORE()
	flag_watcher()
end
