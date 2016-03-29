print("IoC MODULE LOAD")

IoC = nil

-- —истемные переменные
local gateHP = {}
local AllyGateWarnings = {}
local HordeGateWarnings = {}

--  онстанты
local DEFAULT_INITIAL_GATE_HEALTH = 600000

local TargetMapId = 540;
local PerDamagePeriod = 10


do
	IoC = Api.NewFrame(function()
		if GetCurrentMapAreaID() == IoC.MapId then 
			return true
		else
			AllyGateWarnings = {}
			HordeGateWarnings = {}
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

function IoC:SPELL_BUILDING_DAMAGE(_, sourceGUID, p8, damage, p6, destGUID, destName, p5, p4, p3, p2, p1, damage)
	if sourceGUID == nil or destName == nil or destGUID == nil or damage == nil then
		return
	end
	
	local guid = destGUID
	local currentHP = gateHP[guid]

	if currentHP == nil then 
		gateHP[guid] = DEFAULT_INITIAL_GATE_HEALTH -- initial gate health: 600000
		currentHP = gateHP[guid]
	end

	if currentHP > damage then
		gateHP[guid] = currentHP - damage
	else
		gateHP[guid] = 0
	end

	local damagePercent = math.floor(gateHP[guid] / (DEFAULT_INITIAL_GATE_HEALTH / 100)) -- 0, 20, 40, 60, 80
	
	if damagePercent % PerDamagePeriod == 0 then

		local hordeWarning = string.find(destName, _L["IoCHorde"]) ~= nil
		local allyWarning = string.find(destName, _L["IoCAlliance"]) ~= nil
		
		-- ≈сли урон уже был опубликован то по новой не выводим, урон может повтор€тьс€ дл€ каждой башни.
		if (hordeWarning and HordeGateWarnings[damagePercent] ~= nil) or (allyWarning and AllyGateWarnings[damagePercent] ~= nil) then
			return
		end
		
		if allyWarning then
			return
			--AllyGateWarnings[damagePercent] = true
		end

		if hordeWarning then
			HordeGateWarnings[damagePercent] = true
		end
		
		local gateHealth = __merge(destName, tostring(damagePercent).."%")
		local message = Common:FormatInstanceMessage(gateHealth)
		SendChatMessage(message, "INSTANCE_CHAT" )
		--print(message);
		--print("-> "..destName.." -> "..tostring(damagePercent).."%")
	end
end
