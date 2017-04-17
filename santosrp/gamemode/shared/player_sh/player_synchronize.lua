local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SyncPlayer_MF")
	util.AddNetworkString("SyncPlayer_MF_Callback")
	util.AddNetworkString("LoadEntity_MF")
	
	net.Receive("SyncPlayer_MF",function(siz,pl)
		pl:LoadMySQL()
	end)
	
	net.Receive("LoadEntity_MF",function(siz,pl)
		local ent = net.ReadEntity()
		
		if (!IsValid(ent)) then return end
		if (ent:CreatedByMap()) then return end
		
		if (ent:IsPlayer()) then 
			ent:SetRank(ent:GetRank(),pl)
			ent:UpdateJob(pl)
			ent:UpdateOrganization(pl)
			ent:UpdateRPName(pl)
			return 
		else
			ent:UpdatePlayerOwner(pl)
			
			if (ent:IsVehicle()) then
				UpdateCarBinds(ent,pl)
				ent:UpdateEngine(pl)
			end
		end
	end)
	
	function meta:CallbackPlayerLoaded( bool , questioned)
		net.Start("SyncPlayer_MF_Callback")
			net.WriteBit( bool )
			net.WriteBit( questioned )
			if questioned then
				--TODO wrtie question table
			end
		net.Send( self )
	end
else
	local hasvalue = table.HasValue
	local simple = timer.Simple
	local Skip = {
		"prop_dynamic",
		"prop_door_rotating",
		"func_door",
		"func_breakable_surf",
		"func_movelinear",
		"func_tracktrain",
		"func_breakable",
		"class C_FuncAreaPortalWindow",
		"class C_BaseEntity",
		"class C_FuncOccluder",
		"class C_RopeKeyframe",
		"class C_Sun",
		"class C_ParticleSystem",
		"env_sprite",
	}
	
	local Q = 0
	function GM:InitPostEntity()
		net.Start("SyncPlayer_MF") net.SendToServer()
	end
	
	function GM:NetworkEntityCreated(ent)
		if (hasvalue(Skip,ent:GetClass()) or !IsValid(ent)) then return end
		if (ent:GetClass() == "prop_vehicle_jeep") then 
			ent.Data = santosRP.Vehicles.LoadCarFile( ent:GetModel() )
			MarkCarRenderable( ent )
			--santosRP.Vehicles.SetupCarFuel(ent)
		end
		
		Q=Q+1
		simple(0.1*Q,function()
			if (IsValid(ent)) then
				net.Start("LoadEntity_MF") 
					net.WriteEntity(ent) 
				net.SendToServer()
			end
			
			Q=Q-1
		end)
	end
	
	net.Receive("SyncPlayer_MF_Callback",function()
		local bool = net.ReadBit()
		local shouldQuestion = net.ReadBit()
		if bool == 1 then
			santosRP.gui.login.LoadCharacterCreationMenu()
			if shouldQuestion then
				--santosRP.gui.login.OpenWhitelistQuestions(net.ReadTable())
			end
		elseif bool == 0 then
			santosRP.gui.login.SkipCharacterCreationMenu( )
		end
	end)
end
