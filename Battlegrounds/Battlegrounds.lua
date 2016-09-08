print("Battleground module")
local Battlegrounds = nil
local BattlegroundsTracker = nil
local nextUpdateTime = nil

-- Трапа раскидывающая рес
local HunterTrap = 82939
local Flags = {};
HeroismIds = 
{
  [ 2825] = "Жажда крови",
  [32182] = "Героизм",
  [80353] = "Искажение времени",
  [90355] = "Древняя истерия",
  [102351] = "Барабаны ярости"
};

function AVIoCZone()
	local currentZone = GetCurrentMapAreaID()
	return currentZone == IoC.MapId or currentZone == AV.MapId
end

do
	Battlegrounds = Api.NewFrame(AVIoCZone,
		{
			"SPELL_CAST_SUCCESS"
		})
	
	Battlegrounds:Subscribe()
end

function Battlegrounds:SPELL_CAST_SUCCESS(...)
	local caster  = select(3, ...);
   	local spellId = select(10, ...);
	if HeroismIds[spellId] ~= nil then
		if IsPlayerFromBattlegroundRaid(caster) then
			local spellLink, _ = GetSpellLink(spellId)
			local message = "Героизм: "..caster.."-"..spellLink
			print(message)
		end
	end
	
	if spellId == HunterTrap then 
		--print("HunterTrap: "..caster)
	end
end

do
	BattlegroundsTracker = Api.NewFrame(function()
		local rightZone = AVIoCZone()
		if rightZone then
			if nextUpdateTime == nil then
				nextUpdateTime = time() + 4
			end
		else
			Flags =  {};
			nextUpdateTime = nil
		end
		
		return rightZone
	end,
	{
		"UPDATE_BATTLEFIELD_SCORE"
	})
	
	BattlegroundsTracker:Subscribe()
end

function BattlegroundsTracker:UPDATE_BATTLEFIELD_SCORE(...)
	
	if (nextUpdateTime > time()) then
		-- Если еще не настало время следующего обновления
		return
	end
	
	nextUpdateTime = time() + 4

	local bgPlayers = GetNumBattlefieldScores()
	if (bgPlayers <= 15) then
		return
	end
	
	-- Судя по всему отрытый фрем паганит данные
	if WorldStateScoreFrame:IsVisible() then
	  return 
	end

	-- Передвигаем закладку с "Альянс"\"Орда" на "Все"
	SetBattlefieldScoreFaction(nil);
	
	local i, j
	for i = 1, bgPlayers do

		-- http://wowprogramming.com/docs/api/GetBattlefieldScore
		local name, 
			killingBlows, 
			honorableKills, 
			deaths, 
			honorGained, 
			faction, 
			rank, 
			race, 
			class = GetBattlefieldScore(i);
		
		-- Валидная фракция и валидное имя. 0 - орда
		if name and faction and faction == 0 then
			
			-- http://wowprogramming.com/docs/api/GetNumBattlefieldStats
			-- Returns the number of battleground-specific statistics on the current battleground's 
			-- scoreboard. Battleground-specific statistics include flags captured in Warsong Gulch, 
			-- towers assaulted in Alterac Valley, etc. For the name and icon associated with each statistic
			local bgStats = GetNumBattlefieldStats()

			if Flags[name] == nil then
				Flags[name] = {}
			end
			
			for j = 1, bgStats do
				-- http://wowprogramming.com/docs/api/GetBattlefieldStatData
				-- Returns battleground-specific scoreboard information for a battleground participant. 
				-- Battleground-specific statistics include flags captured in Warsong Gulch, towers assaulted 
				-- in Alterac Valley, etc. For the name and icon associated with each statistic, see GetBattlefieldStatInfo(). 
				-- For basic battleground score information, see GetBattlefieldScore().
				local playerStatData = GetBattlefieldStatData(i, j);
				-- if (Flags[name][j] == nil) then
				--   Flags[name][j] = 0;
				-- end
				
				-- Если человек что то захватил и изменилось значение в колонке
				if (Flags[name][j] ~= nil and Flags[name][j] ~= playerStatData) then
					
					-- http://wowprogramming.com/docs/api/GetBattlefieldStatInfo
					-- Returns information about a battleground-specific scoreboard column. 
					-- Battleground-specific statistics include flags captured in Warsong Gulch, 
					-- towers assaulted in Alterac Valley, etc.
					local stat_name = GetBattlefieldStatInfo( j ) ;

					-- Нас интересуют только захваты башен и флагов
					if (_L.BaseStates[ stat_name ] ~= nil) then
						
						local mark = _L.BaseStates[ stat_name ]
						local resultName = stat_name ..":  ".. name;
						local message = mark.."[PH] " .. resultName .. " группа [" .. GetPlayerGroup(name) .. "] ".. mark;
						SendChatMessage(message, "SAY" )
						--print(mark.."[PH] CHECKER:" .. resultName .. mark)
					end
				end
				
				Flags[name][j] = playerStatData ;
			end
		end
	end
end

function GetPlayerGroup(playerName)
	local i, subgroup, name
	for i = 1, 40 do 

		-- Returns information about a member of the player's raid
		-- http://wowprogramming.com/docs/api/GetRaidRosterInfo
		-- name - Name of the raid member (string)
		-- rank - Rank of the member in the raid (number)
		--     0 - Raid member
		--     1 - Raid Assistant
		--     2 - Raid Leader
		-- subgroup - Index of the raid subgroup to which the member belongs (between 1 and MAX_RAID_GROUPS) (number)
		-- level - Character level of the member (number)
		-- class - Localized name of the member's class (string)
		-- fileName - A non-localized token representing the member's class (string)
		-- zone - Name of the zone in which the member is currently located (string)
		-- online - 1 if the member is currently online; otherwise nil (1nil)
		-- isDead - 1 if the member is currently dead; otherwise nil (1nil)
		-- role - Group role assigned to the member (string)
		--     MAINASSIST
		--     MAINTANK
		-- isML - 1 if the member is the master looter; otherwise nil (1nil)
		name, _, subgroup=GetRaidRosterInfo(i);
		if name == playerName then 
			return subgroup;
		end;
	end;

	return "?"
end

