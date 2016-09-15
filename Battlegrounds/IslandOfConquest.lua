print("IoC MODULE LOAD")

IoC = {}

-- Системные переменные
local gateHP = {}
local LastPercents = 100;

-- Константы
local DEFAULT_INITIAL_GATE_HEALTH = 600000

local TargetMapId = 540;

local HordeDamageFlow = {}

HordeDamageFlow[0 ] = { Left = -10, Right = 0 }
HordeDamageFlow[5 ] = { Left = 0, Right = 5 }
HordeDamageFlow[10] = { Left = 5, Right = 10 }
HordeDamageFlow[15] = { Left = 10, Right = 15 }
HordeDamageFlow[20] = { Left = 15, Right = 20 }
HordeDamageFlow[25] = { Left = 20, Right = 25 }
HordeDamageFlow[30] = { Left = 25, Right = 30 }
HordeDamageFlow[40] = { Left = 30, Right = 40 }
HordeDamageFlow[50] = { Left = 40, Right = 50 }
HordeDamageFlow[60] = { Left = 50, Right = 60 }
HordeDamageFlow[70] = { Left = 60, Right = 70 }
HordeDamageFlow[80] = { Left = 70, Right = 80 }
HordeDamageFlow[90] = { Left = 80, Right = 90 }

function IsInInterval(left, right, currentValue)
	return left < currentValue  and currentValue <= right;
end

do
	IoC = Api.NewFrame(function()
		return true
	end,
	{
		"SPELL_BUILDING_DAMAGE",
		"CHAT_MSG_BG_SYSTEM_NEUTRAL",
		"PLAYER_ENTERING_WORLD",
		"UPDATE_BATTLEFIELD_SCORE"
	})
	
	IoC.MapId = TargetMapId

	IoC:Subscribe()
	IoC.IsEnabled = nil
end

function IoC:SPELL_BUILDING_DAMAGE(_, sourceGUID, p8, damage, p6, destGUID, destName, p5, p4, p3, p2, p1, damage)
	if not IoC.IsEnabled then
		return
	end

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


	local hordeWarning = string.find(destName, _L["IoCHorde"]) ~= nil
	if not hordeWarning then 
		return
	end

	local damagePercent = math.floor(gateHP[guid] / (DEFAULT_INITIAL_GATE_HEALTH / 100)) -- 56, 79, 98

	local resultDamage = nil
	for key, _ in pairs(HordeDamageFlow) do
		local node = HordeDamageFlow[key]
		if IsInInterval(node.Left, node.Right, damagePercent) then
			resultDamage = key
			break
		end
	end

	-- Не логированный урон
	if resultDamage == nil then 
		return
	end

	-- Если бьют еще одни ворота, то дублировать не надо
	if resultDamage >= LastPercents then 
		-- PS если равень то весь отрезок будет спам
		return
	end
	
	-- в константу
	LastPercents = resultDamage

	local gateHealth = __merge(destName, tostring(resultDamage).."%")
	PHSayInstance(gateHealth)
end

function IoC:PLAYER_ENTERING_WORLD()
	if GetCurrentMapAreaID() == IoC.MapId then 
		-- http://wowwiki.wikia.com/wiki/API_RequestBattlefieldScoreData
		-- Requests the lastest battlefield score data from the server
		--		RequestBattlefieldScoreData()
		-- Used to retrieve the latest score info from the server, the 
		-- data is not received as soon as you call this you will need 
		-- to register and wait for UPDATE_BATTLEFIELD_SCORE. 
		RequestBattlefieldScoreData()
	else
		IoC.IsEnabled = nil
		gateHP = {}
		LastPercents = 100
	end
end
-- IoC.IsEnabled = IsBattlegroundGoing();
function IoC:UPDATE_BATTLEFIELD_SCORE()
	if IoC.IsEnabled ~= nil or GetCurrentMapAreaID() ~= IoC.MapId then
		return
	end

	local bgPlayers = GetNumBattlefieldScores()
	if (bgPlayers <= 15) then
		return
	end
	
	local isGoing = IsBattlegroundGoing();
	if isGoing ~= nil then
		IoC.IsEnabled = not isGoing
	end
end

function IoC:CHAT_MSG_BG_SYSTEM_NEUTRAL(message)
	print("MESSAGE: "..message)
end