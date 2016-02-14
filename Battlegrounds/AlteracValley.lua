print("AV MODULE LOAD")

local AV = {}
local Vandar = "Вандар Грозовая Вершина"
local Drektar = "Дрек'Тар"

-- http://wow.gamepedia.com/MapID
local TargetMapId = 401;

-- oQueue переменные
local _next_flag_check = 0 ;
local _instance_faction = nil
local scoreboard = {};
local _flags = nil ;
local _enemy = nil ;
local bgzone = false

BG_STAT_COLUMN = { [ "База атакована"        ] = "База атакована",
                   [ "База защищена"         ] = "База защищена",
                   [ "Разрушитель уничтожен" ] = "Разрушитель уничтожен",
                   [ "Флаг захвачен"         ] = "Флаг захвачен",
                   [ "Флаг возвращен"        ] = "Флаг возвращен",
                   [ "Врат разрушены"        ] = "Врата разрушены",
                   [ "Кладбище атаковано"    ] = "Кладбище атаковано",
                   [ "Кладбище защищено"     ] = "Кладбище защищено",
                   [ "Башня атакованы"       ] = "Башня атакована",
                   [ "Башня защищена"        ] = "Башня защищена",
} ;

--BG_STAT_COLUMN = { [ "Bases Assaulted"       ] = "Base Assaulted",
--                      [ "Bases Defended"        ] = "Base Defended",
--                      [ "Demolishers Destroyed" ] = "Demolisher Destroyed",
--                      [ "Flag Captures"         ] = "Flag Captured",
--                      [ "Flag Returns"          ] = "Flag Returned",
--                      [ "Gates Destroyed"       ] = "Gate Destroyed",
--                      [ "Graveyards Assaulted"  ] = "Graveyard Assaulted",
--                      [ "Graveyards Defended"   ] = "Graveyard Defended",
--                      [ "Towers Assaulted"      ] = "Tower Assaulted",
--                      [ "Towers Defended"       ] = "Tower Defended",
--} ;




function AV:PLAYER_ENTERING_WORLD(...)
 -- handle PLAYER_ENTERING_WORLD here
end
function AV:PLAYER_LEAVING_WORLD(...)
 -- handle PLAYER_LEAVING_WORLD here
end

function AV:ZONE_CHANGED_NEW_AREA()
	BattlegroundEnterOrLeave()
	--print("ZONE_CHANGED_NEW_AREA "..tostring(bgzone))
end
function AV:PLAYER_LOGIN()
	BattlegroundEnterOrLeave()
	--print("PLAYER_LOGIN "..tostring(bgzone))
end

function AV:PLAYER_ENTERING_WORLD()
	BattlegroundEnterOrLeave()
	--print("PLAYER_ENTERING_WORLD "..tostring(bgzone))
end
function AV:PLAYER_LEAVING_WORLD()
	BattlegroundEnterOrLeave()
end


function BattlegroundEnterOrLeave()
	if (Common.IsInsidePvpZone())  then
		local currentZone = GetCurrentMapAreaID()
		if not bgzone and currentZone == TargetMapId then
			frame:RegisterEvent("SPELL_CAST_SUCCESS")
			scoreboard = {};
			print("++ANY++ Alterac Valley helper activated")
			_next_flag_check = time()
			bgzone = true
		else
			print("Alterac Valley OFF")
			frame:UnregisterEvent("SPELL_CAST_SUCCESS")
			bgzone = false
		end
	end
end

function AV:CHAT_MSG_BG_SYSTEM_HORDE()
	if not bgzone then return end

	flag_watcher()
end
function AV:CHAT_MSG_BG_SYSTEM_ALLIANCE()
	if not bgzone then return end

	flag_watcher()
end

function AV:CHAT_MSG_MONSTER_YELL(message, sender)
	print(sender .. "        " .. message)
	if message == nil or sender == nil then return end
	
	if sender == Drektar then 
		print("ДРЕКТАРА АТАКУЮТ")
		print("ДРЕКТАРА АТАКУЮТ")
		print("ДРЕКТАРА АТАКУЮТ")
		print("ДРЕКТАРА АТАКУЮТ")
	elseif sender == Vandar then
		print("ВАНДАРАА АТАКУЮТ")
		print("ВАНДАРАА АТАКУЮТ")
		print("ВАНДАРАА АТАКУЮТ")
		print("ВАНДАРАА АТАКУЮТ")
	end
end

function AV:UPDATE_BATTLEFIELD_SCORE()
	flag_watcher()
end

local OQPacket = {};
function new() 
  local o = {} ;
  o._vars = {} ; 
  o._source = nil ;
  o._sender = nil ;
  o._pkt    = nil ;
  setmetatable(o, { __index = OQPacket }) ;
  return o ;
end



-- ОБНОВЛЯЕТ ТОЛЬКО КОГДА СТАТИСТИКА ОТРЫТА
function flag_watcher()


	--if not bgzone then
	--	-- print("flag_watcher not bgzone")
	--  return
	--end
	
	---- Прошло ли достаточно времени с последнего обновления
	--local now = time();
	--if (_next_flag_check > now) then
	--	--print("now < _next_flag_check")
	--	--print(now)
	--	--print(_next_flag_check)
	--  return ;
	--end
	
	---- Запоминаем когда надо снова обновиться
	--_next_flag_check = now + 4 ; -- minimal
	
	---- не понятно зачем 0 - орда 1 - альянс
	----local p_faction = 0 ; -- 0 == horde, 1 == alliance, -1 == offline
	----if (get_bg_faction() == "A") then
	----  p_faction = 1 ;
	----end
	
	
	---- Если отрыто окно с результатами
	--if (WorldStateScoreFrame:IsVisible()) then
	--	print("WorldStateScoreFrame return")
	--  return ;
	--end
	
	---- clear faction
	--SetBattlefieldScoreFaction( nil ) ;
	--local nplayers = GetNumBattlefieldScores() ;
	
	--if (nplayers <= 10) then
	--	print("nplayers <= 10 =>>>>"..tostring(nplayers))
	--  -- not inside, the call failed, or in an arena match
	--  return ;
	--end
	
	---- Если значения есть то берутся они, иначе новая строка
	--_flags = _flags or new() ;
	--_enemy = _enemy or new() ;
	
	
--	local i, statndx ;
--	for i=1, nplayers do
--	  local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(i);
--	  if (name) and (faction) and faction ~= -1 then
--	    local nstats = GetNumBattlefieldStats() ;
--	    if (_flags[name] == nil) then
--	      _flags[name] = new() ;
--	    end
--	    for statndx = 1,nstats do
--	      local stat = GetBattlefieldStatData(i, statndx);
--	      if (_flags[name][statndx] == nil) then
--	        _flags[name][statndx] = 0 ;
--	      end
--	      if (_flags[name][statndx] ~= stat) then
--	        local stat_name = GetBattlefieldStatInfo( statndx ) ;
--	        local str = stat_name ..":  ".. name ;
--	        if (BG_STAT_COLUMN[ stat_name ] ~= nil) then
--	          str = BG_STAT_COLUMN[stat_name] ..":  ".. name ;
--			end

--			print(str)
--	      end
--	      _flags[name][statndx] = stat ;
--		  print(name.." "..tostring(stat))
--	    end
--	  elseif (name) and (faction) and (faction ~= p_faction) then
--	    if (_enemy[name] == nil) then
--	      _enemy[name] = new() ;
--	      _enemy[name].appearance = now ;
--	    end
--	    _enemy[name].last_seen = now ; -- always updating, last time seen ~= now... player left
--	    _enemy[name].strike = 0 ;
--	  end
--	end
	
	-- report rage-quitters
	--local s = oq.toon.stats["bg"] ;
	--if (oq.raid.type == OQ.TYPE_RBG) then
	--  s = oq.toon.stats["rbg"] ;
	--end
	
	--if (nplayers > 10) then -- just incase the GetBattlefieldScore was wonky
	--  local i, e ;
	--  for i,e in pairs(_enemy) do
	--    if (e.last_seen ~= nil) then
	--      if (e.last_seen ~= now) and (e.reported == nil) then
	--        if (e.strike >= 1) then
	--          -- don't report until the 2nd strike.  the scorecard can be flaky
	--          e.reported = true ;
	--          e.ragequit = true ;
	--          if (IsRatedBattleground() == false) then
	--            oq.new_tears( 1 ) ; -- acct wide; should increment your tear count only for regular bgs, as only enemy faction counts
	--          end
			  
	--            local diff = e.last_seen - e.appearance ;
	--            local min = floor((diff)/60) ;
	--            local sec = diff % 60 ;
	--            print( OQ.LILSTAR_ICON .."".. string.format( OQ.RAGEQUITSOFAR, i, min, sec, OQ_data.nrage or 0 ) ) ;
	--            -- play sound
	--            if ((now - last_runaway) > OQ_MIN_RUNAWAY_TM) then
	--              last_runaway = now ;
	--              PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav") ;
	--            end
	--        else
	--          e.strike = e.strike + 1 ;
	--        end
	--      end
	--    end
	--  end
	--end
end


function get_bg_faction()
  if (_instance_faction) then
    return _instance_faction ;
  end
  local numScores    = GetNumBattlefieldScores() ;
  local nMembers     = 0 ;
  local hks          = 0 ;
  local honor        = 0 ;
  local deaths       = 0 ;
  local i ;
  for i=1, numScores do
    local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i);
    if (faction and (faction == 0)) then
      faction = "H" ;
    elseif (faction) then
      faction = "A" ;
    end
    if (name == player_name) then
      _instance_faction = faction ;
      return faction ;	
    end
  end  
  return "n" ;
end

do
	AV = Api.NewFrame(function()
		return Common.IsInsidePvpZone() and GetCurrentMapAreaID() == TargetMapId
	end,
	{
		"CHAT_MSG_MONSTER_YELL"
	})

	AV:Subscribe()
end