



--For Joshua... Changes the material of that board at spawn on Rockford specifically

if (CLIENT) then
	hook.Add("InitPostEntity","ChangeMat",function()
		local Mat = Material("OCRP/BETAWEEK1")

		if (Mat) then
			Mat:SetString("$basetexture","santosrp/hud/santosrpadd")
			Mat:Recompute()
		end
	end)
else
	local OffHeight = -64
	
	hook.Add("InitPostEntity","ReplaceRockfordPumps",function()
		--Replace all default gaspumps on the map with our own!
		for k,v in pairs(ents.FindByModel("models/statua/shell/shellpump1.mdl")) do
			timer.Simple(k/10,function()
				local e = ents.Create("santosrp_gaspump")
				e:SetPos(v:GetPos()+v:GetUp()*OffHeight)
				e:SetAngles(v:GetRight():Angle())
				e:Spawn()
				e:Activate()
				
				local Phys = e:GetPhysicsObject()
				
				if (IsValid(Phys)) then
					Phys:EnableMotion(false)
					Phys:Sleep()
				end
				
				e:SetMoveType(MOVETYPE_NONE)
				
				e.CreatedByMap = function() return true end
				v:Remove()
			end)
		end
	end)
end

