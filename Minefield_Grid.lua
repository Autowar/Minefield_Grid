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
local tickAOE = 196 --armtick
local roachAOE = 212 --corroach
local skuttleAOE = 190	--corsktl
local blastwingAOE = 148 --blastwing

-----------------------------------------------------------------

local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local spGetAllUnits			= Spring.GetAllUnits	--( ) -> nil | unitTable = { [1] = number unitID, ... }
local spMarkerAddPoint		= Spring.MarkerAddPoint
local spEcho				= Spring.Echo
local spInsertUnitCmdDesc   = Spring.InsertUnitCmdDesc
local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
local spValidUnitID         = Spring.ValidUnitID
local spGetUnitPosition     = Spring.GetUnitPosition
local spGetUnitDefID        = Spring.GetUnitDefID
local spGiveOrderToUnit     = Spring.GiveOrderToUnit
local spGetUnitStates       = Spring.GetUnitStates
local spGiveOrderToUnitArray= Spring.GiveOrderToUnitArray
local spValidUnitID			= Spring.ValidUnitID
local spGetTeamUnits		= Spring.GetTeamUnits  --( number teamID ) -> nil | unitTable = { [1] = number unitID, etc... }
local spGetMyTeamID			= Spring.GetMyTeamID
local spGetMyAllyTeamID		= Spring.GetMyAllyTeamID
local spIsUnitIcon			= Spring.IsUnitIcon
local spGetSelectedUnits	= Spring.GetSelectedUnits	-- ( ) -> { [1] = unitID, ... }
local myAllyID 				= Spring.GetMyAllyTeamID()
local myTeamID 				= Spring.GetMyTeamID()
local CMD_ATTACK = CMD.ATTACK
local CMD_MOVE = CMD.MOVE
local CMD_UNIT_SET_TARGET = 34923
local CMD_GUARD = CMD.GUARD

-----------------------------------------------------------------


function widget:KeyPress(key, mods, isRepeat)
	--somehow "D" key id is 100
local dKey=100
	--ctrl + alt + D
	if key==dKey and mods and mods.alt then
	local selectedUnits = spGetSelectedUnits()
	local x,y,z
	local unitAOE
		for i=1, #selectedUnits do
			if spGetUnitDefID(selectedUnits[i]) == UnitDefNames["armtick"].id then
				unitAOE=tickAOE
			elseif spGetUnitDefID(selectedUnits[i]) == UnitDefNames["corroach"].id then
				unitAOE=roachAOE
			elseif spGetUnitDefID(selectedUnits[i]) == UnitDefNames["corsktl"].id then
				unitAOE=skuttleAOE
			elseif spGetUnitDefID(selectedUnits[i]) == UnitDefNames["blastwing"].id then
				unitAOE=blastwingAOE
			end
			if unitAOE~=nil then
				if i==1 then
					x,y,z = spGetUnitPosition(selectedUnits[i])
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x,0,z}, {"shift"})
					--Spring.MarkerAddPoint(x,0,z)
				elseif i==2 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x,0,z+unitAOE}, {"shift"})
					--Spring.MarkerAddPoint(x,0,z+unitAOE)
				elseif i==3 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x,0,z-unitAOE}, {"shift"})
					--Spring.MarkerAddPoint(x,0,z-unitAOE)
				elseif i==4 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+unitAOE,0,z}, {"shift"})
					--Spring.MarkerAddPoint(x+unitAOE,0,z)
				elseif i==5 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+unitAOE,0,z+unitAOE}, {"shift"})
					--Spring.MarkerAddPoint(x+unitAOE,0,z+unitAOE)
				elseif i==6 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+unitAOE,0,z-unitAOE}, {"shift"})
					--Spring.MarkerAddPoint(x+unitAOE,0,z-unitAOE)
				elseif i==7 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-unitAOE,0,z}, {"shift"})
					--Spring.MarkerAddPoint(x-unitAOE,0,z)
				elseif i==8 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-unitAOE,0,z+unitAOE}, {"shift"})
					--Spring.MarkerAddPoint(x-unitAOE,0,z+unitAOE)
				elseif i==9 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-unitAOE,0,z-unitAOE}, {"shift"})
					--Spring.MarkerAddPoint(x-unitAOE,0,z-unitAOE)
				elseif i==10 then --
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-(unitAOE*2),0,z+(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x-(unitAOE*2),0,z+(unitAOE*2))
				elseif i==11 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-(unitAOE*2),0,z+(unitAOE)}, {"shift"})
					--Spring.MarkerAddPoint(x-(unitAOE*2),0,z+(unitAOE))
				elseif i==12 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-(unitAOE*2),0,z}, {"shift"})
					--Spring.MarkerAddPoint(x-(unitAOE*2),0,z)
				elseif i==13 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-(unitAOE*2),0,z-(unitAOE)}, {"shift"})
					--Spring.MarkerAddPoint(x-(unitAOE*2),0,z-(unitAOE))
				elseif i==14 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-(unitAOE*2),0,z-(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x-(unitAOE*2),0,z-(unitAOE*2))
				elseif i==15 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-unitAOE,0,z-(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x-unitAOE,0,z-(unitAOE*2))
				elseif i==16 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x-unitAOE,0,z+(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x-unitAOE,0,z+(unitAOE*2))
				elseif i==17 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x,0,z+(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x,0,z+(unitAOE*2))
				elseif i==18 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x,0,z-(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x,0,z-(unitAOE*2))
				elseif i==19 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+unitAOE,0,z+(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x+unitAOE,0,z+(unitAOE*2))
				elseif i==20 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+unitAOE,0,z-(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x+unitAOE,0,z-(unitAOE*2))
				elseif i==21 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+(unitAOE*2),0,z+(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x+(unitAOE*2),0,z+(unitAOE*2))
				elseif i==22 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+(unitAOE*2),0,z+(unitAOE)}, {"shift"})
					--Spring.MarkerAddPoint(x+(unitAOE*2),0,z+(unitAOE))
				elseif i==23 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+(unitAOE*2),0,z}, {"shift"})
					--Spring.MarkerAddPoint(x+(unitAOE*2),0,z)
				elseif i==24 then
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+(unitAOE*2),0,z-(unitAOE)}, {"shift"})
					--Spring.MarkerAddPoint(x+(unitAOE*2),0,z-(unitAOE))
				elseif i==25 then --
					spGiveOrderToUnit(selectedUnits[i], CMD_MOVE, {x+(unitAOE*2),0,z-(unitAOE*2)}, {"shift"})
					--Spring.MarkerAddPoint(x+(unitAOE*2),0,z-(unitAOE*2))
				end
			end
		end
	end
end



--[[

local origin = {X=0,Y=0}
origin.X = originX
origin.Y = originY
local distance = 128
local points = {}
local currentcolumn = -10
local currentrow = -10
local currentX = origin.X + currentcolumn*distance
local currentY = origin.Y + currentrow*distance
repeat
points[#points+1] = {X=currentX,Y=currentY}
currentX = currentX + distance
currentcolumn = currentcolumn + 1
if currentcolumn == 10 then
currentcolumn = -10
currentY = currentY + distance
currentrow = currentrow + 1
end
until currentcolumn = 10, currentrow = 10 -- this makes a 20X20 grid

]]
