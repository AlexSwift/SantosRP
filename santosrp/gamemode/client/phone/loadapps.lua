
local Folder  	= GM.Folder:gsub("gamemodes/","").."/gamemode/client/phone/apps"
local insert 	= table.insert
local copy		= table.Copy

hook.Add("Initialize","LoadApps",function()
	local Items   	= file.Find(Folder.."/*.lua","LUA")
	local Base		= {}
	
	GAMEMODE.Apps 		= {}
	
	APPS = {}
	
	AddCSLuaFile(Folder.."/base.lua")
	include(Folder.."/base.lua")
	
	Base = copy(APPS)
	
	for k,v in pairs(Items) do
		if (v != "base.lua") then
			AddCSLuaFile(Folder.."/"..v)
			include(Folder.."/"..v)
			
			insert(GAMEMODE.Apps,APPS)
			
			APPS = copy(Base)
		end
	end
end)

function GetAppByName(App)
	for k,v in pairs( GAMEMODE.Apps ) do
		if (v.Name == name) then return v end
	end
	
	return nil
end

function GetApps()
	return GAMEMODE.Apps
end

