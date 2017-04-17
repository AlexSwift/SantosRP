
function resource.AddDir(DIR)
	local GAMEFIL,GAMEDIR = file.Find(DIR.."/*","GAME")
	for k,v in pairs( GAMEDIR ) do resource.AddDir(DIR.."/"..v) end
	for k,v in pairs( GAMEFIL ) do resource.AddFile(DIR.."/"..v) end
end
