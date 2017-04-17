function GM:HUDShouldDraw( name )
	if (name == "CHudHealth" or 
		name == "CHudBattery" or 
		name == "CHudCrosshair" or
		name == "CHudVoiceStatus" or
		name == "CHudVoiceSelfStatus" or
		name == "CHudAmmo" or
		name == "CHudWeaponSelection") then return false end
		
	return true
end