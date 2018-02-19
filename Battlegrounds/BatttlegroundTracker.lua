print("BattlegroundsTracker module")

local BattlegroundsTracker = nil

-- Чекеры
local Flags = {};
local CountLeft = 0
local BgPlayers = {}
local nextUpdateTime = nil

function Reset()
	Flags =  {};
	CountLeft = 0;
	BgPlayers = {}
	nextUpdateTime = nil
end

do
	BattlegroundsTracker = Api.NewFrame(function()
		local rightZone = AVIoCZone()
		if rightZone then
			if nextUpdateTime == nil then
				nextUpdateTime = time() + 4
			end
		else
			Reset()
		end
		
		return rightZone
	end,
	{
		"UPDATE_BATTLEFIELD_SCORE",
		"CHAT_MSG_BG_SYSTEM_NEUTRAL",
		"PLAYER_ENTERING_WORLD"
	})
	
	BattlegroundsTracker:Subscribe()
end

function BattlegroundsTracker:CHAT_MSG_BG_SYSTEM_NEUTRAL(message)
	print("MESSAGE: "..message)
	--if message == _L[
end

function BattlegroundsTracker:PLAYER_ENTERING_WORLD(...)

	if not IsInsidePvpZone() then
		Reset()
	end
end

function BattlegroundsTracker:GROUP_ROSTER_UPDATE(...)
	local currentZone = GetCurrentMapAreaID()
	
	if (currentZone == IoC.MapId or currentZone == AV.MapId) then
		-- Its Av or IoC now
		
	elseif not IsInsidePvpZone() then
		
	else
		-- Other battlegrounds or pvp zone for example
		self:Battleground40People()
	end
end

function BattlegroundsTracker:UPDATE_BATTLEFIELD_SCORE(...)
	
	if (nextUpdateTime == nil or nextUpdateTime > time()) then
		-- Если еще не настало время следующего обновления
		return
	end
	
	nextUpdateTime = time() + 4

	local numScores = GetNumBattlefieldScores()
	if (numScores <= 15) then
		return
	end
	
	-- Судя по всему отрытый фрем паганит данные
	if WorldStateScoreFrame:IsVisible() then
	  return 
	end

	-- Передвигаем закладку с "Альянс"\"Орда" на "Все"
	SetBattlefieldScoreFaction(nil);
	
	self:PointRetapObserver(numScores)
	self:LeaversObserver(numScores)
end

function BattlegroundsTracker:PointRetapObserver(numScores)
	
	local i, j
	for i = 1, numScores do

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
		
		-- Валидная фракция и валидное имя. 0 - орда 1 - альянс
		if name and faction and faction == GetBattlefieldArenaFaction() then
			
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
						local resultName = stat_name ..": ".. GetShortPlayerName(name);
						local message = resultName .. " group [" .. GetPlayerGroup(name) .. "] ";
						PHSay(message, mark)
					end
				end
				
				Flags[name][j] = playerStatData ;
			end
		end
	end
end

function BattlegroundsTracker:LeaversObserver(numScores)
	
	local myFaction = GetBattlefieldArenaFaction();
	local currentSeconds = GetSeconds()
	
	-- Belrock-Todeswache 0 27 3 115 0 Эльф крови Охотник на демонов DEMONHUNTER 13607119 601879 0 0 0 0 Истребление 4
	-- Returns basic scoreboard information for a battleground/arena participant. Does not include 
	-- battleground-specific score data (e.g. flags captured in Warsong Gulch, towers assaulted in Alterac Valley, etc)
	-- Мониторим ливеров
	for i=1, numScores do
		local 
			name, 
			killingBlows, 
			honorableKills, 
			deaths, 
			honorGained, 
			faction,
			_,
			class,
			classToken,
			_,
			_,
			_,
			_,
			_,
			_,
			talentSpec = GetBattlefieldScore(i);
		
		-- 0 - Horde (Battleground) / Green Team (Arena)
		-- 1 - Alliance (Battleground) / Gold Team (Arena)
		if myFaction ~= faction and name ~= nil then 

			if BgPlayers[name] == nil then

				local container = {}
				container.check_count = 0
				container.role = GetPlayerRole(classToken, talentSpec)
				BgPlayers[name] = container
			end

			BgPlayers[name].last_seen = currentSeconds
		end
	end

	for name, _ in pairs(BgPlayers) do
		local item = BgPlayers[name]
		if item ~= nil then
			if item.check_count >= 1 and item.last_seen ~= currentSeconds then

				CountLeft = CountLeft + 1
				
				local message = __tostring(CountLeft).." enemies left"
				
				if item.role == "Healer" then
					message = message.." [{rt5} Healer: "..name.."]"
				end
				PHSay(message, "skull")

				BgPlayers[name] = nil
			end

			item.check_count = item.check_count + 1
		end
	end
end