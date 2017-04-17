
local NLRZone = {}

local Mat = Material("models/debug/debugwhite")

if (SERVER) then
	util.AddNetworkString("AddNLR")
	
	function CreateNLRZone(Pos,Radius,pl,tim)
		if (!IsValid(pl)) then return end
		
		local Dat = {
			Pos = Pos,
			Radius = Radius,
			Affect = pl,
			Time = CurTime()+tim,
		}
		
		for k,v in pairs(ents.FindInSphere(Pos,Radius)) do
			if (v:GetClass():find("info_player_")) then
				MsgN(pl:Nick().." died close to spawn. NLR Bubble not created!")
				return
			end
		end
		
		table.insert(NLRZone,Dat)
		
		net.Start("AddNLR")
			net.WriteVector(Dat.Pos)
			net.WriteUInt(math.ceil(Dat.Radius),32)
			net.WriteUInt(math.ceil(Dat.Time),32)
		net.Send(pl)
	end
else
	net.Receive("AddNLR",function()
		local Dat = {
			Pos = net.ReadVector(),
			Radius = net.ReadUInt(32),
			Time = net.ReadUInt(32),
		}
		
		table.insert(NLRZone,Dat)
	end)
	
	hook.Add("PostDrawTranslucentRenderables","RenderNLRBubbles",function()
		render.SetMaterial(Mat)
		
		render.SuppressEngineLighting(true)
		render.SetBlend(0.5)
		for k,v in pairs(NLRZone) do
			render.DrawWireframeSphere( v.Pos, v.Radius, 16, 16, MAIN_BLUECOLOR, true )
		end
		render.SetBlend(1)
		render.SuppressEngineLighting(false)
	end)
end


hook.Add("Tick","NLRTick",function()
	for k,v in pairs(NLRZone) do
	
		if (v.Time < CurTime()) then
			table.remove(NLRZone,k)
			break
		end
		
		if (SERVER) then
			if (!IsValid(v.Affect)) then
				table.remove(NLRZone,k)
				break
			elseif (v.Affect:Alive()) then
				local Dif = (v.Affect:GetPos()-v.Pos)
				
				if (Dif:Length() < v.Radius) then
					v.Affect:SetVelocity(Dif:GetNormal()*200)
				end
			end
		end
	end
end)
		
			