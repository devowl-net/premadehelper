print("Battleground module")
local Battlegrounds = nil
-- http://wowwiki.wikia.com/wiki/API_COMBAT_LOG_EVENT
--function mod:SPELL_CAST_SUCCESS(args)
--	if not bgzone then return end

--	local spellId = args.spellId;
--	local caster  = args.sourceName ;
	
--	if HeroismIds[spellId] ~= nil then
--		print("Героизм: "..caster.."-"..HeroismIds[spellId])
--	end
--end

HeroismIds = 
{
  [ 2825] = "Жажда крови",
  [32182] = "Героизм",
  [80353] = "Искажение времени",
  [90355] = "Древняя истерия",
  [102351] = "Барабаны ярости"
};

do
	Battlegrounds = Api.NewFrame(function()
		--return Common.IsInsidePvpZone()
		return true
	end,
	{
		"SPELL_CAST_SUCCESS"
	})

	Battlegrounds:Subscribe()
end

function Battlegrounds:SPELL_CAST_SUCCESS(...)
	--print(__UnpackToString(...))
	local caster  = select(3, ...);
   	local spellId = select(10, ...);
	if HeroismIds[spellId] ~= nil then
		print("Гера: "..caster.."-"..HeroismIds[spellId])
	end
end
