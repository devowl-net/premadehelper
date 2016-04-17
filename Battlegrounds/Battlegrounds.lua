print("Battleground module")
local Battlegrounds = nil
local BattlegroundsTracker = nil
local nextUpdateTime = nil

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
		print("Гера: "..caster.."-"..HeroismIds[spellId])
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
		
		-- Валидная фракция и валидное имя
		if name and faction and faction ~= -1 then
			
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
				if (Flags[name][j] == nil) then
				  Flags[name][j] = 0;
				end
				
				-- Если человек что то захватил и изменилось значение в колонке
				if (Flags[name][j] ~= playerStatData) then
					
					-- http://wowprogramming.com/docs/api/GetBattlefieldStatInfo
					-- Returns information about a battleground-specific scoreboard column. 
					-- Battleground-specific statistics include flags captured in Warsong Gulch, 
					-- towers assaulted in Alterac Valley, etc.
					local stat_name = GetBattlefieldStatInfo( j ) ;
					local str = stat_name ..":  ".. name ;
					if (_L.BaseStates[ stat_name ] ~= nil) then
						str = _L.BaseStates[stat_name] ..":  ".. name ;
					end
	
					print("[PH] CHEKER:"..str)
				end
				
				Flags[name][j] = playerStatData ;
			end
		end
	end
	
end