

print("----API init----")

Api = {};

function Api.NewFrame(...)
   local frame =  CreateFrame("Frame");
   frame["Subscribe"] = Api.Subscribe
   frame.Events = ...
   frame["Unsubscribe"] = Api.Unsubscribe
   return frame
end

function eventHandler(self, event, ...)
	print("Calling: ".. event)
    self[event](self, ...); 
end

function Api.Subscribe(self)
	self:SetScript("OnEvent", eventHandler);
	for f, t in pairs( self.Events ) do
		local eventName = t
		
		self:RegisterEvent(eventName, self[eventName], true); 
		if self:IsEventRegistered(eventName) then
			print("+ Subscripting on " .. eventName)
		else
			print("- [Fail] Subscripting on " .. eventName)
		end
	end
	print(".Subscripting finished")
end

function Api.Unsubscribe()
end

local test = Api.NewFrame({ 
	"PLAYER_LOGIN",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"PLAYER_ENTERING_WORLD",
	"CHAT_MSG",
	 })

function test:CHAT_MSG(...)
   print("CHAT_MSG")
end

function test:UNIT_SPELLCAST_SUCCESS(...)
   print("UNIT_SPELLCAST_SUCCESS")
end
	 
function test:PLAYER_ENTERING_WORLD(...)
   print("PLAYER_ENTERING_WORLD")
end
	 
function test:CHAT_MSG_RAID_BOSS_EMOTE(...)
   print("CHAT_MSG_RAID_BOSS_EMOTE")
end
	 
function test:SPELL_CAST_SUCCESS(...)
   print("SPELL_CAST_SUCCESS")
end

function test:PLAYER_LOGIN(...)
   print("PLAYER_LOGIN")
end


test:Subscribe();
--test:Unsubscribe()