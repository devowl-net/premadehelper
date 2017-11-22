
function DataShow_OnDragStart()
	DataShow:StartMoving();
end

function DataShow_OnDragStop()
	DataShow:StopMovingOrSizing();
end

function DataShow_OnLoad()
	DataShow:RegisterForDrag("LeftButton");

	--local button = CreateFrame("Button", "only_for_testing", DataShow)
 --   button:SetPoint("CENTER", DataShow, "CENTER", 0, 0)
 --   button:SetWidth(200)
 --   button:SetHeight(50)
        
 --   button:SetText("My Test")
 --   button:SetNormalFontObject("GameFontNormalSmall")

end

function bCopyLastHourPlayers_OnClick()

	if BgPlayers == nil then
		print("No player was founded")
		return
	end
	local currentTime = GetServerTime()
	local Players = ""
	local OneHourSeconds = 60*60

	for name, _ in pairs(BgPlayers) do
		local item = LastSeenPlayers[name]
		local diff = currentTime - item.last_seen
		
		if diff < OneHourSeconds then
			Players = Players.."\n"..name
		end
	end

end
