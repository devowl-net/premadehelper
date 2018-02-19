print("Raid module")
local Raid = nil

local BgPlayers = {}
local RaidPlayers = {}

do
	Raid = Api.NewFrame(function()

		-- ВВВВВВВВЫЫЫЫЫЫЫЫЫККККККККККЛЛЛЛЛЛЛЛЮЮЮЮЮЮЮЮЧЧЧЧЧЧЧЧИИИИИИИИЛЛЛЛЛЛЛЛ
		return false;
		-- ТОКА В МИРЕ. В мире не работает
		-- return not Common.IsInsidePvpZone()
	end,
	{
		"GROUP_ROSTER_UPDATE"
	})

	Raid:Subscribe()
end

function Raid:GROUP_ROSTER_UPDATE(...)
	
	-- Только для нормальных
end

function Raid:GetFraction()

	if Raid["Fraction"] ~= nil then
		return Raid["Fraction"]
	end

	local unit = "player"
	local englishFaction, localizedFaction = UnitFactionGroup(unit)
	local sideNumber = -1

	-- 0 - Horde (Battleground) / Green Team (Arena)
    -- 1 - Alliance (Battleground) / Gold Team (Arena)
	if englishFaction == "Horde" then
		sideNumber = 0
	else
		sideNumber = 1
	end

	--return sideNumber, englishFaction, localizedFaction
	Raid["Fraction"] = sideNumber, englishFaction, localizedFaction

	return Raid["Fraction"]
end

-- C_LFGList.CreateListing(16, "Фарм ХК", 0, "", "Join quick !", true)