-- :) The diamond square algorithm. Used for terrain generation and image stuff.
-- Function CreateTerrain(Size (2 powered by Size), maximum height, Smoothness, Seed (Optional else 1) )
-- Returns a 2d table with a height defined on it

local random 	= math.random
local ceil 		= math.ceil

local add	= table.Add
local vec   = Vector

function CreateTerrain(size,maxheight,smoothness,seed)
	math.randomseed(seed or 1)
	
	local S 	= 2^size
	local SS 	= S*1
	
	local Grid = {}
	
	for X=0,S do 
		Grid[X] = {}
		for Y=0,S do 
			Grid[X][Y] = 0
		end
	end
	
	local Iteration = 0
	
	while (S>1) do
		Iteration = Iteration+1
		
		local SF = ceil(SS/S)
		
		for X=0,SF-1 do
			local XX = S*X
			
			for Y=0,SF-1 do
				local YY = S*Y
				
				Grid[XX+S/2][YY+S/2] 	= (Grid[XX][YY]+Grid[XX+S][YY]+Grid[XX+S][YY+S]+Grid[XX][YY+S])/4+random(-maxheight,maxheight)
				
				Grid[XX+S/2][YY] 		= (Grid[XX][YY]+Grid[XX+S][YY])/2+random(-maxheight,maxheight)
				Grid[XX+S/2][YY+S] 		= (Grid[XX+S][YY+S]+Grid[XX][YY+S])/2+random(-maxheight,maxheight)
				
				Grid[XX][YY+S/2] 		= (Grid[XX][YY]+Grid[XX][YY+S])/2+random(-maxheight,maxheight)
				Grid[XX+S][YY+S/2] 		= (Grid[XX+S][YY]+Grid[XX+S][YY+S])/2+random(-maxheight,maxheight)
			end	
		end
		
		maxheight = maxheight/smoothness
		S = S/2
	end
	
	return Grid
end


function TerrainToTriangles(Terrain,StretchX,StretchY,TextureScaleX,TextureScaleY,Origin)
	local Triangles = {}
	
	for x,a in pairs(Terrain) do
		local Tab = Terrain[x+1]
		if (Tab) then
			for y,z in pairs(a) do
				if (a[y+1]) then
					local V1 = vec(x*StretchX,y*StretchY,z)
					local V2 = vec((x+1)*StretchX,y*StretchY,Tab[y])
					local V3 = vec((x+1)*StretchX,(y+1)*StretchY,Tab[y+1])
					local V4 = vec(x*StretchX,(y+1)*StretchY,a[y+1])
					
					local N1 = (V3-V2):Cross(V1-V2)
					local N2 = (V1-V4):Cross(V3-V4)
					
					add(Triangles,{
						--Triangle 1
						{
							pos = Origin+V3,
							normal = N1,
						},
						{
							pos = Origin+V2,
							normal = N1,
						},
						{
							pos = Origin+V1,
							normal = N1,
						},
						--Triangle 2
						{
							pos = Origin+V1,
							normal = N2,
						},
						{
							pos = Origin+V4,
							normal = N2,
						},
						{
							pos = Origin+V3,
							normal = N2,
						},
					})
				else
					break
				end
			end
		else
			break
		end
	end
	
	return Triangles
end
	
	