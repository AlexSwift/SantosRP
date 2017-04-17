
function AddLuaCSFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (CLIENT) then include(Dir..DIR.."/"..v)
		else AddCSLuaFile(Dir..DIR.."/"..v) end
	end
end

function AddLuaSVFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (SERVER) then include(Dir..DIR.."/"..v) end
	end
end

function AddLuaSHFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (SERVER) then AddCSLuaFile(Dir..DIR.."/"..v) end
		include(Dir..DIR.."/"..v)
	end
end
