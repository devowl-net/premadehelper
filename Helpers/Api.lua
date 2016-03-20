Api = {};

Api.CombatLogs = {
	"SWING",
	"RANGE",
	"SPELL",
	--"SPELL_PERIODIC", 
	"SPELL_BUILDING",
	"ENVIRONMENTAL"
};

function Api.NewFrame(workCallback, ...)
	local frame =  CreateFrame("Frame");
	frame["Subscribe"] = Api.Subscribe
		-- ������� �� ������� ������������� ������������
	frame.Events = ...
	frame["WorkCallback"] = workCallback
	
	combatLog = false
	Api.__Enumerate(frame, Api.CombatLogs,
		function(self, combatEventName)
			Api.__Enumerate(self, self.Events,
				function(self, eventName)
					if(string.sub(eventName,1,string.len(combatEventName)) == combatEventName) then
						combatLog = true
					end
				end)
		end)
	
	frame.Internal_Events = {};
	if combatLog then
		-- ������� ������� ����� ��� �� ������� �� ������� �� ����������� ����
		-- http://wowwiki.wikia.com/wiki/API_COMBAT_LOG_EVENT
		frame.Internal_Events = { "COMBAT_LOG_EVENT_UNFILTERED" }
	end
	
	frame["Unsubscribe"] = Api.Unsubscribe
	frame["__Enumerate"] = Api.__Enumerate
	return frame
end

function eventHandler(self, eventName, ...)
	if eventName == nil then return end

	if self.WorkCallback ~= nil and self.WorkCallback() == false then 
		-- ��������� ������������ ��� ��� ������� � ������ ������
		return
	end

	--print("[timestamp]".. __tostring(timestamp).." [eventName] "..__tostring(eventName).." [sourceEventName] "..__tostring(sourceEventName)..__unpackToString(...))
	if self.Events[eventName] then
		--print(" [eventName] "..__tostring(eventName).."[timestamp]".. __tostring(timestamp).." 0) "..__tostring(sourceEventName)..__unpackToString(...))
		FireEvent(self, eventName, ...)
		--self[eventName](self, sourceEventName, ...); 
	elseif self.Internal_Events[eventName] then
		FireUnfilteredEvent(self, eventName, ...)
		--self[sourceEventName](self, ...)
	end
end

function FireUnfilteredEvent(self, eventName, param1, param2, ...)
	-- ���������������
	-- param1 - timestamp
	-- param2 - ��� �������
	eventName = param2
	
	if self.Events[eventName] then
		--print("Calling Unfiltered: " .. eventName)
		self[eventName](self, ...)
	end
	
end

function FireEvent(self, eventName, ...)
	-- ������� �������
	self[eventName](self, ...)
end

function IsUnfiltered(eventName)
	return not eventName == nil and string.find(eventName, "UNFILTERED") ~= nil
end

-- ��������
function Api:Subscribe()
	self:SetScript("OnEvent", eventHandler);
	
	-- ���������������� �������
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

	-- ���������� �������
	self:__Enumerate(self.Internal_Events, 
		function(self, eventName)
			self:RegisterEvent(eventName); 
			self.Internal_Events[eventName] = true
		end)
end

-- �������
function Api.Unsubscribe()
end

-- ������������
function Api:__Enumerate(sourceTable, callback)
	for f, t in ipairs( sourceTable ) do
		local functionName = t
		callback(self, functionName)
	end
end

-- ����� ����������
function __unpackToString(...)
	local result = ""
	local args = { params = select("#", ...), ... }
	for i = 1, args.params do
      result = result ..tostring(i)..") ".. tostring(args[i]) .. " | "
	end
	return result
end

-- ������� � ������� ��������
function __tostring(obj)
	if obj == nil then
		return "nil"
	else
		return tostring(obj)
	end
end

function __merge(str1, str2, str3)
-- TODO �� ... �������
	local result = ""
	if str1 ~= nil then
		result = __tostring(str1) 
	end

	if str2 ~= nil then
		result = result .. " " .. __tostring(str2)
	end
	
	if str3 ~= nil then
		result = result .. " " .. __tostring(str3)
	end

	return result
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