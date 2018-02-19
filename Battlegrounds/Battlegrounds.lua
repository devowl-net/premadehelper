print("Battleground module")

local Battlegrounds = nil

-- Трапа раскидывающая рес
local HunterTrap = 82939

HeroismIds = 
{
  [ 2825] = "Жажда крови",
  [32182] = "Героизм",
  [80353] = "Искажение времени",
  [90355] = "Древняя истерия",
  [146555] = "Барабаны ярости"
};

-- ObjectiveTrackerFrame:Hide() при заходе
-- Зона Альта и Острова
function AVIoCZone()
	local currentZone = GetCurrentMapAreaID()
	return 
		currentZone == 540 or 
		currentZone == 401
end

local total = 0
 
local function onUpdate(self,elapsed)
    total = total + elapsed
    if total >= 5 then
		if AVIoCZone() then
			RequestBattlefieldScoreData()
		end
        total = 0
    end
end
 
local f = CreateFrame("frame")
f:SetScript("OnUpdate", onUpdate)

do
	Battlegrounds = Api.NewFrame(AVIoCZone,
		{
			"SPELL_CAST_SUCCESS",
			"SPELL_CAST_START"
		})

	Battlegrounds:Subscribe()
end

function Battlegrounds:SPELL_CAST_SUCCESS(...)
	-- Ищим того кто дал геру
	local casterPlayerName  = select(3, ...);
   	local spellId = select(10, ...);
	if HeroismIds[spellId] ~= nil then
		if IsPlayerFromBattlegroundRaid(casterPlayerName) then
			local spellLink, _ = GetSpellLink(spellId)
			local message = "ГЕРА: ["..GetShortPlayerName(casterPlayerName).."] group ".. GetPlayerGroup(casterPlayerName) ..spellLink
			PHSay(message, "square")
		end
	end
	
	-- Не актуально возможно с 7.0.3
	if spellId == HunterTrap then 
		--print("HunterTrap: "..caster)
	end
end

function Battlegrounds:SPELL_CAST_START(...)
	-- На ОЗ и Альтераке событие не приходит
	-- Уведомление о начале чека
	--local casterPlayerName  = select(3, ...);
	--  	local spellId = select(10, ...);
	--local spellName = select(11, ...);

	--if spellId == 97388 then
	--	local resultName = spellName ..":  ".. GetShortPlayerName(name);
	--	local message = resultName .. " группа [" .. GetPlayerGroup(name) .. "] ";
	--	PHSay(message, mark)
	--	print("ЧЕКАЕТ СЦУКО "..casterPlayerName)
	--end
	-- print(casterPlayerName.." "..spellId)
end

