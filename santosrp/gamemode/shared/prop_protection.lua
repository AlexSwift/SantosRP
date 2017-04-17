--Prop protection... lol...
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("AddBuddies")
	util.AddNetworkString("RemoveBuddies")
	util.AddNetworkString("UpdateBuddies")
	
	net.Receive("AddBuddies",function(siz,pl)
		pl:SetPlayerBuddy(net.ReadEntity(),true)
	end)
	
	net.Receive("RemoveBuddies",function(siz,pl)
		pl:SetPlayerBuddy(net.ReadEntity(),false)
	end)
	
	function meta:SetPlayerBuddy(pl,bAllow)
		if (!self.Buddies) then self.Buddies = {} end
		
		local bFind,Slot 	= self:IsBuddy(pl)
		
		if (bAllow) then
			if (!bFind) then table.insert(self.Buddies,pl) end
		elseif (bFind) then
			self.Buddies[Slot] = nil
		end
			
		net.Start("UpdateBuddies")
			net.WriteEntity(self)
			net.WriteEntity(pl)
			net.WriteBit(bAllow)
		net.Broadcast()
		
		self:CleanupBuddies()
	end
else
	function AddPropBuddy(pl)
		net.Start("AddBuddies")
			net.WriteEntity(pl)
		net.SendToServer()
	end
	
	function RemovePropBuddy(pl)
		net.Start("RemoveBuddies")
			net.WriteEntity(pl)
		net.SendToServer()
	end
	
	net.Receive("UpdateBuddies",function()
		local pl 	= net.ReadEntity()
		local bud 	= net.ReadEntity()
		local Allow = util.tobool(net.ReadBit())
		
		if (!IsValid(pl)) then return end
		if (!pl.Buddies) then pl.Buddies = {} end
		
		local bFind,Slot 	= pl:IsBuddy(bud)
		
		if (Allow) then
			if (!bFind) then table.insert(pl.Buddies,bud) end
		elseif (bFind) then
			pl.Buddies[Slot] = nil
		end
		
		pl:CleanupBuddies()
	end)
end

function meta:IsBuddy(pl)
	if (pl == self) then return true end
	if (!self.Buddies) then return false end
		
	for k,v in pairs(self.Buddies) do
		if (v == pl) then
			return true,k
		end
	end
	
	return false
end

function meta:CleanupBuddies()
	if (!self.Buddies) then return end
	
	local Dat = {}
	
	for k,v in pairs(self.Buddies) do
		if (IsValid(v)) then
			table.insert(Dat,v)
		end
	end
	
	self.Buddies = Dat
end

hook.Add("PhysgunPickup", "ProtectProps_Physgun", function(ply,ent)
	local O = ent:GetPlayerOwner()
	
	if (SERVER and ent:CreatedByMap()) then return false end
	if (ent:GetPersistent()) then return false end
	
	if (ply:HasPermit("proppickup")) then 
		if (ent:IsPlayer() and SERVER) then ent:SetMoveType(MOVETYPE_FLY) end
		
		return true 
	end
	
	if (!IsValid(O)) then return false end
	if (O == ply) then return true end
	if (O:IsBuddy(ply)) then return true end
	
	return false
end)


hook.Add("PhysgunDrop", "Physgun_dropped_mf", function(ply,ent)
	if (ent:IsPlayer()) then ent:SetMoveType(MOVETYPE_WALK) end
end)

function GM:CanPlayerUnfreeze( ply, ent, phys )
	local O = ent:GetPlayerOwner()
	
	if (ply:HasPermit("proppickup")) then return true end
	if (O == ply) then return true end
	if (IsValid(O) and O:IsBuddy(ply)) then return true end
end