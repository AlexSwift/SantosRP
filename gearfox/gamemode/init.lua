
AddCSLuaFile( "autolua.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function GM:Initialize()
end

function GM:PlayerInitialSpawn(pl)
end

function GM:Think()
end

function GM:PlayerCanHearPlayersVoice()
	return true, true
end 

function GM:CheckPassword(Mystery,IP,ServerPassword,Name)
	--This new hook returns AllowJoin,BlockMessage
end


function GM:PlayerSpawn(pl)
	hook.Call( "PlayerSetModel" , self , pl )
	self:PlayerLoadout(pl)
end

function GM:PlayerLoadout( ply )
	ply:Give("weapon_physcannon")
	ply:Give("weapon_physgun")
	ply:SelectWeapon("weapon_physgun")
	
	for k,v in pairs(ply:GetWeapons()) do
		v:DrawShadow(false)
	end
 
	return true
end




--Damnit Garry!
function GM:PlayerSetModel( ply )
    local cl_playermodel = ply:GetInfo("cl_playermodel")
    local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
    ply:SetModel( modelname )
end



