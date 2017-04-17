
// :O

util.AddNetworkString( "SunPos" )


hook.Add("Initialize","LoadGearFox",function() 
	resource.AddDir("materials/gearfox") 
	resource.AddDir("materials/mawbase") 
	resource.AddDir("sound/mawbase") 
end)


hook.Add("InitPostEntity","LoadGearFoxSunPos",function()
	local Sun = ents.FindByClass("env_sun")[1]
	
	if (!IsValid(Sun)) then return end
	
	GM = GM or GAMEMODE
	
	local Ang = Sun:GetAngles()
	Ang.p = Sun:GetKeyValues().pitch
	Ang.y = Ang.y+180
	
	local Pos = Ang:Forward()*10
		
	GM:SetGlobalSHVar("SunPos",Pos)
end)