print("----API init----")

Api = {};

function Api.NewFrame(workCallback, ...)
	local frame =  CreateFrame("Frame");
	frame["Subscribe"] = Api.Subscribe
		-- События на которые подписывается пользователь
	frame.Events = ...
	frame["WorkCallback"] = workCallback
	-- События которые нужны что бы поджечь те которые не поджигаются сами
	frame.Internal_Events = { "COMBAT_LOG_EVENT_UNFILTERED" }
	frame["Unsubscribe"] = Api.Unsubscribe
	frame["__Enumerate"] = Api.__Enumerate
	return frame
end

function eventHandler(self, eventName, timestamp, sourceEventName, ...)
	if self.WorkCallback ~= nil and self.WorkCallback() == false then 
		-- проверяем обрабатываем или нет события в данный момент
		return
	end

	if eventName == nil then return end

	--print("[timestamp]".. __tostring(timestamp).." [eventName] "..__tostring(eventName).." [sourceEventName] "..__tostring(sourceEventName)..__UnpackToString(...))

	if self.Events[eventName] then
		print("[timestamp]".. __tostring(timestamp).." [eventName] "..__tostring(eventName).." 0) "..__tostring(sourceEventName)..__UnpackToString(...))
		self[eventName](self, sourceEventName, ...); 
	elseif self.Internal_Events[eventName] and self.Events[sourceEventName] then
		self[sourceEventName](self, ...)
	end
end

-- Подписка
function Api.Subscribe(self)
	self:SetScript("OnEvent", eventHandler);
	
	-- пользовательские события
	Api.__Enumerate(self, self.Events, 
		function(self, eventName)
			self:RegisterEvent(eventName); 
			self.Events[eventName] = true
			if not self:IsEventRegistered(eventName) then
				print("(-) Not subscripted on " .. eventName)
			else
				print("(+) subscripted on " .. eventName)
			end
		end)

	-- внутренние события
	self:__Enumerate(self.Internal_Events, 
		function(self, eventName)
			self:RegisterEvent(eventName); 
			self.Internal_Events[eventName] = true
		end)
end

-- Отписка
function Api.Unsubscribe()
end

-- Перечисление
function Api.__Enumerate(self, sourceTable, callback)
	for f, t in ipairs( sourceTable ) do
		local functionName = t
		callback(self, functionName)
	end
end

-- Вывод параметров
function __UnpackToString(...)
	local result = ""
	local args = { params = select("#", ...), ... }
	for i = 1, args.params do
      result = result ..tostring(i)..") ".. tostring(args[i]) .. " | "
	end
	return result
end

-- Перевод в строчку значения
function __tostring(obj)
	if obj == nil then
		return "nil"
	else
		return tostring(obj)
	end
end





----- TESTS-------------
------------------------

--local test = Api.NewFrame(workChecker, { 
--	"PLAYER_LOGIN",
--	--"SPELL_CAST_SUCCESS",
--	--"COMBAT_LOG_EVENT_UNFILTERED",
--	"CHAT_MSG_RAID_BOSS_EMOTE",
--	"PLAYER_ENTERING_WORLD",
--	"CHAT_MSG",
--	 })


----function test:COMBAT_LOG_EVENT_UNFILTERED(...)
----	print("COMBAT_LOG_EVENT_UNFILTERED")
----end

--function test:CHAT_MSG(...)
--   print("CHAT_MSG")
--end
	 
--function test:PLAYER_ENTERING_WORLD(...)
--   print("PLAYER_ENTERING_WORLD")
--end
	 
--function test:CHAT_MSG_RAID_BOSS_EMOTE(...)
--   print("CHAT_MSG_RAID_BOSS_EMOTE")
--end
	 
--function test:SPELL_CAST_SUCCESS(...)
--   print("SPELL_CAST_SUCCESS")
--end

--function test:PLAYER_LOGIN(...)
--   print("PLAYER_LOGIN")
--end


--test:Subscribe();
----test:Unsubscribe()