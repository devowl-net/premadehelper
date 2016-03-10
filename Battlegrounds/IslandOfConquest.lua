print("IoC MODULE LOAD")

local IoC = nil

-- Системные переменные
local gateHP = {}

-- Константы
local DEFAULT_INITIAL_GATE_HEALTH = 600000

local GateAlarmTime = 300000;
local wasFirstSpam = false;
local TargetMapId = 540;

do
	IoC = Api.NewFrame(function()
		if GetCurrentMapAreaID() == IoC.MapId then 
			return true
		else
			wasFirstSpam = false
			return false
		end
	end,
	{
		"SPELL_BUILDING_DAMAGE"
	})
	
	IoC.MapId = TargetMapId

	IoC:Subscribe()
end

function IoC:SPELL_BUILDING_DAMAGE(sourceGUID, _, _, _, destGUID, destName, _, _, _, _, _, amount)
	if sourceGUID == nil or destName == nil or destGUID == nil or amount == nil then
		return
	end

	-- Если уже была рассылка
	if not wasFirstSpam then
		return
	end

	-- База орды нас не интересует
	if not destName:find(_L["Horde"]) then
		return
	end

	local guid = destGUID
	if gateHP[guid] == nil then 
		gateHP[guid] = DEFAULT_INITIAL_GATE_HEALTH -- initial gate health: 600000
	end
	if gateHP[guid] > amount then
		gateHP[guid] = gateHP[guid] - amount
	else
		gateHP[guid] = 0
	end

	if gateHP[guid] < GateAlarmTime then
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		print("HEALTH LOWWWWWWWWWWWWWWWWWW")
		wasFirstSpam = true;
	end
end
