include("autolua.lua")

AddLuaSHFolder("shared/libs")

AddLuaCSFolder("client")
AddLuaCSFolder("client/hud/vgui")
AddLuaCSFolder("client/hud/menus")
AddLuaCSFolder("client/hud")

AddLuaSHFolder("shared")
AddLuaSHFolder("shared/var")

AddLuaSVFolder("server/libs")
AddLuaSVFolder("server")

GM.Name 			= "Gearfox"
GM.Author 			= "SantosRP Coders"
GM.Email 			= ""
GM.Website 			= "santosrp.com"
GM.Version			= 1.3


function GM:PlayerNoClip( pl )
	return (pl:IsAdmin() or self:GetGlobalSHVar("GlobalNoclip",false))
end
