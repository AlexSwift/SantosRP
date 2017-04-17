sql.Query("CREATE TABLE IF NOT EXISTS permaprops('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'content' TEXT NOT NULL, PRIMARY KEY('id'));")

function ReloadPermaProps()
	
	for k, v in pairs( ents.GetAll() ) do

		if v.PermaProps == true then

			v:Remove()

		end

	end

	local content = sql.Query( "SELECT * FROM permaprops" )

	if content == nil then return end
	
	for k, v in pairs( content ) do

		if game.GetMap() == v.map then

			local data = util.JSONToTable(v.content)

			local e = ents.Create( data.class )
			if !e or !e:IsValid() then continue end
			e:SetRenderMode( RENDERMODE_TRANSALPHA )
			e:SetPos( data.pos )
			e:SetAngles( data.ang )
			e:SetColor( data.color )
			e:SetModel( data.model )
			e:SetMaterial( data.material )
			e:SetSkin( data.skin )
			e:SetSolid( data.solid )
			e:SetCollisionGroup( data.collision or 0)
			e.PermaProps = true
			e.ID = v.id

			if data.VehicleScript then

				e:SetKeyValue("VehicleScript", data.VehicleScript)
				e:Spawn()

				continue

			end

			e:Spawn()
			
			if data.class == "prop_door_rotating" then

				e:SetKeyValue("hardware", 1)
				e:SetKeyValue("distance","90")
				e:SetKeyValue("speed","100")
				e:SetKeyValue("returndelay","-1")
				e:SetKeyValue("spawnflags","8192")
				e:SetKeyValue("forceclosed","0")
				e:Activate()

				continue
			
			end

			e:SetMoveType(0)

			local phys = e:GetPhysicsObject()
			if phys and phys:IsValid() then
				phys:EnableMotion(false)
			end

			e:Fire( "SetDamageFilter", "FilterDamage", 0 )

		end

	end

end

hook.Add("InitPostEntity", "InitializePermaProps", ReloadPermaProps)
--[[
local function PermaSave( ply )

	--if not ply:IsAdmin() then return end

	local ent = ply:GetEyeTrace().Entity

	if not ent:IsValid() then ply:ChatPrint( "That is not a valid entity !" ) return end

	if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return end
	
	if ent.PermaProps then ply:ChatPrint( "That entity is already permanent !" ) return end

	-- The script can't save LIGHT, CAMERA .....
	if string.find(ent:GetClass(), "gmod_") then ply:ChatPrint( "You can't save this !" ) return end
	
	local content = {}
	content.class = ent:GetClass()
	content.pos = ent:GetPos()
	content.ang = ent:GetAngles()
	content.color = ent:GetColor()
	content.model = ent:GetModel()
	content.material = ent:GetMaterial()
	content.skin = ent:GetSkin()
	content.solid = ent:GetSolid()
	content.collision = ent:GetCollisionGroup()

	if ent:IsVehicle() then
		
		content.VehicleScript = ent:GetKeyValues().VehicleScript

	end

	ent:Remove()	

	local effectdata = EffectData()
	effectdata:SetOrigin(ent:GetPos())
	effectdata:SetMagnitude(2)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
	util.Effect("Sparks", effectdata)

	sql.Query("INSERT INTO permaprops (id, map, content) VALUES(NULL, ".. sql.SQLStr(game.GetMap()) ..", ".. sql.SQLStr(util.TableToJSON(content)) ..");")

	ReloadPermaProps()

	ply:ChatPrint("You saved " .. ent:GetClass() .. " with model ".. ent:GetModel() .. " to the database.")

end
concommand.Add( "perma_save", PermaSave )

local function PermaRemove( ply )

	--if not ply:IsAdmin() then return end

	local ent = ply:GetEyeTrace().Entity
	
	if not ent:IsValid() then ply:ChatPrint( "That is not a valid entity !" ) return end

	if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return end
	
	if not ent.PermaProps then ply:ChatPrint( "That is not a PermaProp !" ) return end
	
	ent:Remove()

	sql.Query("DELETE FROM permaprops WHERE id = ".. ent.ID ..";")

	ply:ChatPrint("You erased " .. ent:GetClass() .. " with a model of " .. ent:GetModel() .. " from the database.")

end
concommand.Add( "perma_remove", PermaRemove )

local function PermaUpdate( ply )

	--if not ply:IsAdmin() then return end

	local ent = ply:GetEyeTrace().Entity
	
	if not ent:IsValid() then ply:ChatPrint( "You have updated all PermaProps !" ) ReloadPermaProps() return end

	if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return end
	
	if not ent.PermaProps then ply:ChatPrint( "That is not a PermaProp !" ) return end
	
	local content = {}
	content.class = ent:GetClass()
	content.pos = ent:GetPos()
	content.ang = ent:GetAngles()
	content.color = ent:GetColor()
	content.model = ent:GetModel()
	content.material = ent:GetMaterial()
	content.skin = ent:GetSkin()
	content.solid = ent:GetSolid()
	content.collision = ent:GetCollisionGroup()

	if ent:IsVehicle() then
		
		content.VehicleScript = ent:GetKeyValues().VehicleScript

	end

	local effectdata = EffectData()
	effectdata:SetOrigin(ent:GetPos())
	effectdata:SetMagnitude(2)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
	util.Effect("Sparks", effectdata)

	sql.Query("UPDATE permaprops set content = ".. sql.SQLStr(util.TableToJSON(content)) .." WHERE id = ".. ent.ID .." AND map = ".. sql.SQLStr(game.GetMap()) .. ";")

	ReloadPermaProps()

	ply:ChatPrint("You updated the " .. ent:GetClass() .. " you selected in the database.")

end
concommand.Add( "perma_update", PermaUpdate )]]--