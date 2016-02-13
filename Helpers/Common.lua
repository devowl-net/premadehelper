
Common = { };

function Common:IsInsidePvpZone()
	local instance, instanceType = IsInInstance();
	if ( instance and instanceType == "pvp" ) then
		return true;
	end
	return false;
end