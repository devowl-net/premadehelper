
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
