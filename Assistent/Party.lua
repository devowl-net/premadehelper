print("Party module")
local Party = nil
local TimerDelay = 1
local queueChecker = CreateFrame("Frame");

local Q1MapName = nil
local Q2MapName = nil

local Q1Status = nil
local Q2Status = nil

local Q1Paused = false
local Q2Paused = false

local FirstCheck = true
do
	Party = Api.NewFrame(function()
		return not IsInsidePvpZone()
	end,
	{
		"LFG_QUEUE_STATUS_UPDATE"
	})

	Party:Subscribe()

	queueChecker:SetScript("OnUpdate", 
		function(self, sinceLastUpdate) 
			queueChecker:onUpdate(sinceLastUpdate); 
		end);	
end

function queueChecker:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = (self.sinceLastUpdate or 0) + sinceLastUpdate;
	if ( self.sinceLastUpdate >= TimerDelay ) then 
		QueueChecker()
		self.sinceLastUpdate = 0;
	end
end

function Party:LFG_QUEUE_STATUS_UPDATE(...)
	QueueChecker()
end

function QueueChecker()

	-- Ashran
	-- /script print(GetLFGQueueStats(LE_LFG_CATEGORY_WORLDPVP))
	-- true 0 0 0 22 0 0 40 1 6 ְרנאם -1 -1 -1 -1 -1 111038.286 1127
	-- nil
	local status1, mapName1, _, _, queuePaused1 = GetBattlefieldStatus(1);
	local status2, mapName2, _, _, queuePaused2 = GetBattlefieldStatus(2);
	local anyQueuePause = false

	if status1 ~= Q1Status or Q1MapName ~= mapName1 or Q1Paused ~= queuePaused1 then
		Q1Status	= status1;
		Q1MapName	= mapName1;
		Q1Paused	= queuePaused1
		
		if status1 == "queued" and queuePaused1 then
			PHSayParty("[" .. mapName1 .. "] queue is paused" , "triangle")
			anyQueuePause = true
		end
	end
	
	if status2 ~= Q2Status or Q2MapName ~= mapName2 or Q2Paused ~= queuePaused2 then
		Q2Status	= status2;
		Q2MapName	= mapName2;
		Q2Paused	= queuePaused2;
		
		if status2 == "queued" and queuePaused2  then
			PHSayParty("[" .. mapName2 .. "] queue is paused" , "triangle")
			anyQueuePause = true
		end
	end

	if not FirstCheck and anyQueuePause then
		DoReadyCheck()
	end

	FirstCheck = false
end


