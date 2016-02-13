print("IoC MODULE LOAD")

local mod = DBM:NewMod("z1600", "DBM-Premades", 2)
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)
-- Системные переменные
local gateHP = {}
local bgzone = false

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA" 	-- Required for BG start
)

-- Константы
local ISLAND_OF_CONQUEST_MAPID = 628;
local DEFAULT_INITIAL_GATE_HEALTH = 600000

local Alliance = "Альянс"
local GateAlarmTime = 300000;
local wasFirstSpam = false;
local TargetMapId = ISLAND_OF_CONQUEST_MAPID;

do
	local function initialize(self)
		if DBM:GetCurrentArea() == TargetMapId then
			firstSpam = false
			bgzone = true
			mod:RegisterShortTermEvents(
				"CHAT_MSG_MONSTER_YELL",
				"CHAT_MSG_BG_SYSTEM_ALLIANCE",
				"CHAT_MSG_BG_SYSTEM_HORDE",
				"CHAT_MSG_RAID_BOSS_EMOTE",
				"UNIT_DIED",
				"SPELL_BUILDING_DAMAGE"
			)
			print("Island of Conquest helper activated")
			gateHP = {}
		elseif bgzone then
			mod:UnregisterShortTermEvents()
			mod:Stop()
			bgzone = false
		end
	end
	
	mod.OnInitialize = initialize
	function mod:ZONE_CHANGED_NEW_AREA()
		self:Schedule(1, initialize)
	end
end

do
	local function checkForUpdates()
		-- Периодическая проверка
	end

	local function scheduleCheck(self)
		self:Schedule(1, checkForUpdates)
	end
	
	function mod:CHAT_MSG_MONSTER_YELL(msg)
		-- Когда мобы кричат что то
	end
	
	mod.CHAT_MSG_BG_SYSTEM_ALLIANCE = scheduleCheck
	mod.CHAT_MSG_BG_SYSTEM_HORDE = scheduleCheck
	mod.CHAT_MSG_RAID_BOSS_EMOTE = scheduleCheck
end

function mod:UNIT_DIED(args)
	-- Что то на поле боля погибает
end

function mod:SPELL_BUILDING_DAMAGE(sourceGUID, _, _, _, destGUID, destName, _, _, _, _, _, amount)
	if sourceGUID == nil or destName == nil or destGUID == nil or amount == nil or not bgzone then
		return
	end

	-- Если уже была рассылка
	if not firstSpam then
		return
	end

	-- База орды нас не интересует
	if not destName:find(Alliance) then
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
		firstSpam = true;
	end
end
