﻿local addon = LibStub("AceAddon-3.0"):NewAddon("PremadeHelper", "AceConsole-3.0")
local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Bunnies!", {
	type = "data source",
	text = "Premade Helper",
	icon = "Interface\\ICONS\\spell_nature_bloodlust",
	OnClick = OnButtonClick(),
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnButtonClick()
	if DataShow:IsVisible() then
		DataShow:Hide()
	else
		DataShow:Show()
	end
end

function addon:OnInitialize()
	-- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh!
	self.db = LibStub("AceDB-3.0"):New("BunniesDB", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	icon:Register("Bunnies!", bunnyLDB, self.db.profile.minimap)
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