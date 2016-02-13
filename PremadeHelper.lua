PremadeHelper = LibStub("AceAddon-3.0"):NewAddon("PremadeHelper", "AceConsole-3.0", "AceEvent-3.0" );

function PremadeHelper:OnInitialize()
		-- Called when the addon is loaded

		-- Print a message to the chat frame
		self:Print("OnInitialize Event Fired: Hello")
end

function PremadeHelper:OnEnable()
		-- Called when the addon is enabled

		-- Print a message to the chat frame
		self:Print("OnEnable Event Fired: Hello, again ;)")
	 -- RaidFrame:Show()
end

function PremadeHelper:OnDisable()
		-- Called when the addon is disabled
end
