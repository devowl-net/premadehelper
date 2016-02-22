print("AV MODULE LOAD")

local AV = nil


-- http://wow.gamepedia.com/MapID
local TargetMapId = 401;

-- oQueue переменные
local _next_flag_check = 0 ;
local _instance_faction = nil
local scoreboard = {};
local _flags = nil ;
local _enemy = nil ;
local bgzone = false

do
	AV = Api.NewFrame(function()
		return GetCurrentMapAreaID() == TargetMapId
	end,
	{
		"CHAT_MSG_MONSTER_YELL"
	})

	AV:Subscribe()
end

function AV:CHAT_MSG_MONSTER_YELL(message, sender)
	if message == nil or sender == nil then return end
	
	local underAttackMessage = nil
	if sender == _L["Drektar"] then 
		underAttackMessage = __merge(_L["Drektar"], _L["UnderAttack"])
	elseif sender == _L["Vandar"] then
		underAttackMessage = __merge(_L["Vandar"], _L["UnderAttack"])
	end

	if underAttackMessage ~= nil then
		local message = Common:FormatInstanceMessage(underAttackMessage)
		--print(message)
		SendChatMessage(message, "INSTANCE_CHAT" )
	end
end

function BattlegroundEnterOrLeave()
	--if (Common.IsInsidePvpZone())  then
	--	local currentZone = GetCurrentMapAreaID()
	--	if not bgzone and currentZone == TargetMapId then
	--		frame:RegisterEvent("SPELL_CAST_SUCCESS")
	--		scoreboard = {};
	--		print("++ANY++ Alterac Valley helper activated")
	--		_next_flag_check = time()
	--		bgzone = true
	--	else
	--		print("Alterac Valley OFF")
	--		frame:UnregisterEvent("SPELL_CAST_SUCCESS")
	--		bgzone = false
	--	end
	--end
end

--function AV:CHAT_MSG_BG_SYSTEM_HORDE()
--	flag_watcher()
--end
--function AV:CHAT_MSG_BG_SYSTEM_ALLIANCE()
--	flag_watcher()
--end



function AV:SPELL_CAST_SUCCESS(...)
   print("SPELL_CAST_SUCCESS")
end

function AV:UPDATE_BATTLEFIELD_SCORE()
	flag_watcher()
end

--local OQPacket = {};
--function new() 
--  local o = {} ;
--  o._vars = {} ; 
--  o._source = nil ;
--  o._sender = nil ;
--  o._pkt    = nil ;
--  setmetatable(o, { __index = OQPacket }) ;
--  return o ;
--end



-- ОБНОВЛЯЕТ ТОЛЬКО КОГДА СТАТИСТИКА ОТРЫТА
function flag_watcher()
	
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


--function get_bg_faction()
--  if (_instance_faction) then
--    return _instance_faction ;
--  end
--  local numScores    = GetNumBattlefieldScores() ;
--  local nMembers     = 0 ;
--  local hks          = 0 ;
--  local honor        = 0 ;
--  local deaths       = 0 ;
--  local i ;
--  for i=1, numScores do
--    local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i);
--    if (faction and (faction == 0)) then
--      faction = "H" ;
--    elseif (faction) then
--      faction = "A" ;
--    end
--    if (name == player_name) then
--      _instance_faction = faction ;
--      return faction ;	
--    end
--  end  
--  return "n" ;
--end

