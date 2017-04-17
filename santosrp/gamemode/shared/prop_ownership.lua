local meta = FindMetaTable("Entity")

if (SERVER) then
	util.AddNetworkString("SetPlayerOwner")
	
	--We are overriding the owner function cus the default one is a piece of shit.
	function meta:SetPlayerOwner(pl)
		self.PlayerOwner = pl
		
		net.Start("SetPlayerOwner")
			net.WriteEntity(self)
			net.WriteEntity(pl)
		net.Broadcast()
	end
	
	function meta:UpdatePlayerOwner(pl)
		if (!IsValid(self.PlayerOwner) or !self.PlayerOwner:IsPlayer()) then return end
		
		net.Start("SetPlayerOwner")
			net.WriteEntity(self)
			net.WriteEntity(self.PlayerOwner)
		net.Send(pl)
	end
else
	net.Receive("SetPlayerOwner",function()
		net.ReadEntity().PlayerOwner = net.ReadEntity() 
	end)
end

function meta:GetPlayerOwner()
	return self.PlayerOwner
end