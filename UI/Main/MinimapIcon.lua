local addon = PremadeHelper
local icon = LibStub("LibDBIcon-1.0")

local PremadeLDB = LibStub("LibDataBroker-1.1"):NewDataObject("PHObject", 
{
	type = "launcher",
	text = "Premade Helper",
	icon = "Interface\\ICONS\\spell_nature_bloodlust",
	OnClick = function(self, button)

		-- Minimap icon click
		if DataShow:IsVisible() then
			DataShow:Hide()
		else
			DataShow:Show()
		end
	end,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine("[PH] Premade Helper");
		--Add text here. The first line is ALWAYS a "header" type.
		--It will appear slightly larger than subsequent lines of text
		print("Show tooltip")
	end,
})

function addon:OnInitialize()
	-- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh!
	self.db = LibStub("AceDB-3.0"):New("PremadeDataBase", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	icon:Register("PHObject", PremadeLDB, self.db.profile.minimap)
	--self:RegisterChatCommand("bunnies", "CommandTheBunnies")
end
