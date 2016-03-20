print("IoC MODULE LOAD")

IoC = nil

-- Системные переменные
local gateHP = {}
local gateWarnings = {}

-- Константы
local DEFAULT_INITIAL_GATE_HEALTH = 600000

local TargetMapId = 540;
local PerDamagePeriod = 20

do
	IoC = Api.NewFrame(function()
		if GetCurrentMapAreaID() == IoC.MapId then 
			return true
		else
			gateWarnings = {}
			gateHP = {}
			return false
		end
	end,
	{
		"SPELL_BUILDING_DAMAGE"
	})
	
	IoC.MapId = TargetMapId

	IoC:Subscribe()
end

function IoC:SPELL_BUILDING_DAMAGE(sourceGUID, _, _, _, destGUID, destName, _, _, _, _, _, damage)
	if sourceGUID == nil or destName == nil or destGUID == nil or damage == nil then
		return
	end

	-- Интересует только база орды
	if not destName:find(_L["Horde"]) then
		return
	end
	
	local guid = destGUID
	local currentHP = gateHP[guid]

	if currentHP == nil then 
		gateHP[guid] = DEFAULT_INITIAL_GATE_HEALTH -- initial gate health: 600000
	end

	if currentHP > damage then
		gateHP[guid] = currentHP - damage
	else
		gateHP[guid] = 0
	end

	local damagePercent = math.floor(gateHP[guid] / (DEFAULT_INITIAL_GATE_HEALTH / 100)) -- 0, 20, 40, 60, 80
	if damagePercent % PerDamagePeriod == 0 and gateWarnings[damagePercent] == nil then
		gateWarnings[damagePercent] = true

		print("Gate health = "..tostring(damagePercent))
	end
end
