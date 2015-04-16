function widget:GetInfo()
  return {
    name      = "Minefield Grid",
    desc      = "The selected kamikaze units will spread out in a grid that to prevent a chain-explosion.",
    author    = "AutoWar",
    date      = "2014",
    license   = "GNU GPL, v2 or later",
    layer     = 9999,
    enabled   = true
  }
end

--tick aoe radius = 352/2 = 176 <= 196
--roach aoe radius = 384/2 = 192 <= 212
--skuttle aoe radius = 180 <= 190
--blastwing aoe radius = 128 <=148

-- could be improved by making it fetch the radii automatically
local AOEradii = {
	UnitDefNames["armtick"].id = 196,
	UnitDefNames["corroach"].id = 212,
	UnitDefNames["corsktl"].id = 190, -- Skuttle
	UnitDefNames["blastwing"].id = 148,
}

function widget:KeyPress(key, mods, isRepeat)

	local dKey = 100 -- ASCII code for D

	if key ~= dKey or not (mods and mods.alt) then return end -- alt + d

	local selectedUnits = Spring.GetSelectedUnits()
	if not selectedUnits or (#selectedUnits == 0) then return end -- no need to process empty groups

	local groupDefID = Spring.GetUnitDefID(selectedUnits[1]) -- gebork for mixed selection (but so was the original code)
	local x,y,z = Spring.GetUnitPosition(selectedUnits[1])
	local unitAOE = AOEradii[groupDefID]
	if not unitAOE then return end -- unsupported unit type

	local modifierKeys -- this gets passed each time so no need to recreate the table
	if mods.shift then modifierKeys = {"shift"} -- if the user wants shift, do so
	else modifierKeys = 0 end -- the same as an empty table for the purpose of GiveOrderToUnit

	-- for iterated outward spiral
	local offset = {0, 0}
	local delta_offset = {1, 0}

	for i=1, #selectedUnits do
		Spring.GiveOrderToUnit(selectedUnits[i], CMD.MOVE, {x + offset[1]*unitAOE, 0, z + offset[2]*unitAOE}, modifierKeys)

		-- spiral pattern
		offset[1] = offset[1] + delta_offset[1]
		offset[2] = offset[2] + delta_offset[2]

		-- spiral corner
		if ((offset[1] >= 0) and ((offset[1] == 1-offset[2]) or (offset[1] == offset[2])))
		or ((offset[1]  < 0) and -offset[1] == math.abs(offset[2])) then
			local swap_buffer = delta_offset[1]
			delta_offset[1] = -delta_offset[2]
			delta_offset[2] = swap_buffer
		end
	end
end
