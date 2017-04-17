hook.Add( 'EntityTakeDamage', 'FixDoors', function( ent, dmginfo )

	if not IsValid(ent) or ent:GetClass() ~= "prop_door_rotating" then return end

	dmginfo:ScaleDamage( 0 )

end)