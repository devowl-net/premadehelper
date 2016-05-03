
function DataShow_OnDragStart()
	DataShow:StartMoving();
end

function DataShow_OnDragStop()
	DataShow:StopMovingOrSizing();
end

function DataShow_OnLoad()
	DataShow:RegisterForDrag("LeftButton");
end
