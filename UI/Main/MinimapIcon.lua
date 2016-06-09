local addon = PremadeHelper --LibStub("AceAddon-3.0"):NewAddon("PremadeHelper", "AceConsole-3.0")
local icon = LibStub("LibDBIcon-1.0")

function addon:OnMinimapButtonClick()
	
end

local PremadeLDB = LibStub("LibDataBroker-1.1"):NewDataObject("PHObject", {
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
		tooltip:AddLine("Example text");
		--Add text here. The first line is ALWAYS a "header" type.
		--It will appear slightly larger than subsequent lines of text
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

--function addon:CommandTheBunnies()
--	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
--	if self.db.profile.minimap.hide then
--		icon:Hide("Bunnies!")
--	else
--		icon:Show("Bunnies!")
--	end
--end