--Snippit for moving sprite textures.. Warning: GLua is slow so using this instead of source engines detail is a stupid idea! Only for small exact things!


local SpritePlants = {}
local Zero = Vector(0,0,0)
local Dir  = Vector(16,0,0)
local DirH = Vector(0,0,16)
local TMat = {}

function PlantSpriteAtVector(Origin,BoxSize,SpriteTable,MaxSprites)
	Zero.z 			= BoxSize.z
	SpritePlants 	= {}
	
	for k,v in pairs(SpriteTable) do if (!TMat[v]) then TMat[v],Unused = Material(v,"nocull") end end
	
	for i = 1,MaxSprites do
	
		local Random = Vector(math.Rand(-1,1),math.Rand(-1,1),0) * BoxSize
		local Tr = util.TraceLine({
			start = Origin+Zero+Random,
			endpos = Origin-Zero+Random,
			mask = MASK_SOLID_BRUSHONLY,
		})
		
		if (Tr.Hit and Tr.HitWorld) then 
			Dir:Rotate(Angle(0,math.random(0,360),0))
			
			table.insert(SpritePlants,{
				V1 = Tr.HitPos+Dir,
				V2 = Tr.HitPos-Dir,
				Matsy = TMat[SpriteTable[math.random(1,#SpriteTable)]],
			})
		end
	end
end

hook.Add("PostDrawTranslucentRenderables","RenderPlants",function()
	for k,v in pairs(SpritePlants) do
		local MOVE = (v.V1-v.V2):GetNormal()*math.cos(CurTime()*2+k*15)*5
		render.SetMaterial(v.Matsy)
		render.DrawQuad(v.V2+DirH+MOVE,v.V1+DirH+MOVE,v.V1,v.V2)
	end
end)

/*
	lua_run_cl PlantSpriteAtVector(player.GetByID(1):GetPos(),Vector(100,100,100),{"gearfox/grass.png",},300)
*/