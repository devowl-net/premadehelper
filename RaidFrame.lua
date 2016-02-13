-- Author      : SAP
-- Create Date : 10/5/2015 9:46:10 PM


function bRefreshList_OnClick()
	if RaidFrame:IsVisible() == 1 then
		print("Hiding")
		RaidFrame:Hide()
	else
		print("Visible")
	end
end
