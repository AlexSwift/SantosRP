
/*
	This is an implimentation I made for gamemodes where the map is represented by a 2d map.
	The reason for this implimentation is for gamemodes that makes use of modelled maps, which means navmesh does not work properly.
	Therefore, a custom AI navigation algorithm had to be implimented.
	
	- The Maw
*/


local insert = table.insert
local remove = table.remove
local abs	 = math.abs

function CreateEmptyD2Map(w,h)
	local kLevelRows = w
	local kLevelCols = h
	
	local level = {}
	
	for x = 0, w do
		level[x] = {}
		for y = 0, h do
			level[x][y] = 0
		end
	end
	
	level.w = w
	level.h = h
	
	return level
end

--Check: Right, Left, Up, Down
local function CheckPosMove(map,pos,ClosedList,OpenList,ClosedCount,Count)
	local Dat = {
		Right 	= true,
		Left 	= true,
		Up 		= true,
		Down 	= true,
	}
	
	if (pos.x+1 > map.w) then 	Dat.Right = false end
	if (pos.x <= 0) then 		Dat.Left = false end
	if (pos.y+1 > map.h) then 	Dat.Down = false end
	if (pos.y <= 0) then 		Dat.Up = false end
	
	if (Dat.Right and map[pos.x+1][pos.y] > 0) then Dat.Right = false end
	if (Dat.Left and map[pos.x-1][pos.y] > 0) then Dat.Left = false end
	if (Dat.Up and map[pos.x][pos.y-1] > 0) then Dat.Up = false end
	if (Dat.Down and map[pos.x][pos.y+1] > 0) then Dat.Down = false end
	
	for k = 1,ClosedCount do
		local v = ClosedList[k]
		
		if (Dat.Right and v.Pos == pos+Vector(1,0,0)) then Dat.Right = false end
		if (Dat.Left and v.Pos == pos+Vector(-1,0,0)) then Dat.Left = false end
		if (Dat.Up and v.Pos == pos+Vector(0,-1,0)) then Dat.Up = false end
		if (Dat.Down and v.Pos == pos+Vector(0,1,0)) then Dat.Down = false end
		
		if (!Dat.Right and !Dat.Left and !Dat.Up and !Dat.Down) then break end
	end
	
	for k = 1,Count do
		local v = OpenList[k]
		
		if (Dat.Right and v.Pos == pos+Vector(1,0,0)) then Dat.Right = false end
		if (Dat.Left and v.Pos == pos+Vector(-1,0,0)) then Dat.Left = false end
		if (Dat.Up and v.Pos == pos+Vector(0,-1,0)) then Dat.Up = false end
		if (Dat.Down and v.Pos == pos+Vector(0,1,0)) then Dat.Down = false end
		
		if (!Dat.Right and !Dat.Left and !Dat.Up and !Dat.Down) then break end
	end
	
	return Dat
end

local function PerformAStar_CheckNodes(map,startpos,endpos)
	if (!map or !map[startpos.x] or !map[startpos.x][startpos.y]) then return end
	if (!map[endpos.x] or !map[endpos.x][endpos.y]) then return end
	
	local OpenList 		= {}
	local ClosedList	= {}
	
	local TempH 		= abs(startpos.x-endpos.x)+abs(startpos.y-endpos.y)
	local TempG			= 0
	
	OpenList[1]			= {Pos=startpos, g=0, h=TempH, f=TempH, par=1}  
	
	local Count			= 1
    local ClosedCount	= 0
	
	-- Base node stuff
	local RunTime	  = 0
	
	while (Count > 0 and RunTime < 9000) do
		RunTime = RunTime + 1
		
		local BaseID	  = 1 
		local LowFScore = OpenList[Count].f
		
		for k = 1,Count do
			local v = OpenList[k]
			
  		    if (v.f <= LowFScore) then
				LowFScore=v.f
				BaseID=k
			end
		end
		
		local CurrentNode = OpenList[BaseID]
		TempG=CurrentNode.g+1
		
		ClosedCount = ClosedCount+1
		ClosedList[ClosedCount] = CurrentNode
		
		local Dat = CheckPosMove(map,CurrentNode.Pos,ClosedList,OpenList,ClosedCount,Count)
		
		if (Dat.Right) then
			Count = Count+1
			TempH=abs(CurrentNode.Pos.x+1-endpos.x)+abs(CurrentNode.Pos.y-endpos.y)
			OpenList[Count] = {Pos = CurrentNode.Pos + Vector(1,0,0), g=TempG, h=TempH, f=TempG+TempH, par=ClosedCount}
		end

		if (Dat.Left) then
			Count = Count+1
			TempH=abs((CurrentNode.Pos.x-1)-endpos.x)+abs(CurrentNode.Pos.y-endpos.y)
			OpenList[Count] = {Pos = CurrentNode.Pos - Vector(1,0,0), g=TempG, h=TempH, f=TempG+TempH, par=ClosedCount}
		end

		if (Dat.Down) then
			Count = Count+1
			TempH=abs(CurrentNode.Pos.x-endpos.x)+abs(CurrentNode.Pos.y+1-endpos.y)
			OpenList[Count] = {Pos = CurrentNode.Pos + Vector(0,1,0), g=TempG, h=TempH, f=TempG+TempH, par=ClosedCount}
		end

		if (Dat.Up) then
			Count = Count+1
			TempH=abs(CurrentNode.Pos.x-endpos.x)+abs((CurrentNode.Pos.y-1)-endpos.y)
			OpenList[Count] = {Pos = CurrentNode.Pos - Vector(0,1,0), g=TempG, h=TempH, f=TempG+TempH, par=ClosedCount}
		end

		remove(OpenList,BaseID)
		
		Count = Count-1
		
		if (ClosedList[ClosedCount].Pos == endpos) then
			return ClosedList
		end
	end
	
	return nil
end

function PerformAStar(map,startpos,endpos)
	local CheckNodes = PerformAStar_CheckNodes(map,startpos,endpos)
	
	if (CheckNodes) then
		local Path = {}
		local PathID = {}
		
		local Last = table.getn(CheckNodes)
		PathID[1] = Last

		local i=1
		while (PathID[i]>1) do
			i=i+1
			insert(PathID,i,CheckNodes[PathID[i-1]].par)
		end
		
		for n = table.getn(PathID),1,-1 do
			insert(Path,CheckNodes[PathID[n]])
		end
		
		return Path,CheckNodes
	end
end