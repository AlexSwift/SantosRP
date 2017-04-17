local Blocklist = {}
local Up		= Vector(0,0,20)

if (SERVER) then
	util.AddNetworkString("RequestDeleteProp")
	
	net.Receive("RequestDeleteProp",function(siz,pl)
		local ent = net.ReadEntity()
		
		if (!IsValid(ent) or ent:IsPlayer()) then return end
		if (ent:CreatedByMap()) then return end
		
		local own = ent:GetPlayerOwner()
		
		if (own == pl or pl:HasPermit("proppickup")) then
			pl:AddInventory({
				Name = "Prop",
				Class = ent:GetClass(),
				Model = ent:GetModel(),
				Quantity = 1,
			})
			
			ent:Remove() 
		end
	end)
else
	function RequestDeleteProp(ent)
		net.Start("RequestDeleteProp")
			net.WriteEntity(ent)
		net.SendToServer()
	end
end