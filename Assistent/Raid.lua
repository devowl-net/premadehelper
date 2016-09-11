print("Raid module")
local AssistPromoter = nil

local BgPlayers = {}
local RaidPlayers = {}

do
	AssistPromoter = Api.NewFrame(function()

		-- ВВВВВВВВЫЫЫЫЫЫЫЫЫККККККККККЛЛЛЛЛЛЛЛЮЮЮЮЮЮЮЮЧЧЧЧЧЧЧЧИИИИИИИИЛЛЛЛЛЛЛЛ
		return false;
		-- ТОКА В МИРЕ. В мире не работает
		-- return not Common.IsInsidePvpZone()
	end,
	{
		"GROUP_ROSTER_UPDATE"
	})

	AssistPromoter:Subscribe()
end

function AssistPromoter:GROUP_ROSTER_UPDATE(...)
	
	-- Только для нормальных
end

function AssistPromoter:GetFraction()

	if AssistPromoter["Fraction"] ~= nil then
		return AssistPromoter["Fraction"]
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
	AssistPromoter["Fraction"] = sideNumber, englishFaction, localizedFaction

	return AssistPromoter["Fraction"]
end

-- C_LFGList.CreateListing(16, "Фарм ХК", 0, "", "Join quick !", true)