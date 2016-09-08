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
	local currentZone = GetCurrentMapAreaID()
	
	if (currentZone == IoC.MapId or currentZone == AV.MapId) then
		-- Its Av or IoC now
		self:Battleground40People()
	elseif not IsInsidePvpZone() then
		-- Its out of bg zone
		BgPlayers = {}
	else
		-- Other battlegrounds or pvp zone for example
	end
end

function AssistPromoter:Battleground40People()
	for i=1, GetNumBattlefieldScores() do
		local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(i);
		
		if BgPlayers[name] == nil then 
		else
			BgPlayers[name] = {}
		end
	end
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