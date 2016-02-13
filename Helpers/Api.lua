print("API init")

Api = {};

function Api.NewFrame(...)
   local frame =  CreateFrame("Frame");
   frame["Subscribe"] = Api.Subscribe
   frame.Events = ...
   frame["Unsubscribe"] = Api.Unsubscribe
   return frame
end

function Api.Subscribe(self)
   
   local eventHandler = 
   function(self, event, ...)
      self[event](self, ...); 
   end
   
   self:SetScript("OnEvent", eventHandler);
   
   for i = 1, select("#", self.Events) do
      local eventName = select(i, self.Events);
      print("Subscripting on " .. eventName)
      self:RegisterEvent(eventName); 
   end
   print("Subscripting finished")
end

function Api.Unsubscribe()
end

local test = Api.NewFrame(
   "SPELL_CAST_SUCCESS",
"PLAYER_LOGIN")

function test:SPELL_CAST_SUCCESS(...)
   print("SPELL_CAST_SUCCESS")
end

function test:PLAYER_LOGIN(...)
   print("PLAYER_LOGIN")
end

test:Subscribe();
test:Unsubscribe()