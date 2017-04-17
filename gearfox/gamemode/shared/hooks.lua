
// :O


hook.Add( "PhysgunPickup", "CanPickupPlayer_MB", function(ply,ent)
	GM = GM or GAMEMODE
	
	if (ent:IsPlayer() and GM:GetGlobalSHVar("PlayerPickup",false)) then
		if (GM:GetGlobalSHVar("PlayerPickupAdmin",false)) then return (ply:IsAdmin()) end
		return true
	end
end)

hook.Remove( "PostDrawEffects", "RenderHalos" )
