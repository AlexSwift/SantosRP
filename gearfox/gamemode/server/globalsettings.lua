
util.AddNetworkString( "GlobalNoclip" )
util.AddNetworkString( "PlayerCollision" )
util.AddNetworkString( "PlayerPickup" )
util.AddNetworkString( "PlayerPickupAdmin" )



function GM:SetEnableGlobalNoclip(boolean)
	self:SetGlobalSHVar("GlobalNoclip",util.tobool(boolean))
end

function GM:SetEnablePlayerCollision(boolean)
	self:SetGlobalSHVar("PlayerCollision",!util.tobool(boolean))
end

function GM:SetEnablePlayerPickup(boolean,boolean2)
	self:SetGlobalSHVar("PlayerPickup",util.tobool(boolean))
	self:SetGlobalSHVar("PlayerPickupAdmin",util.tobool(boolean2))
end
