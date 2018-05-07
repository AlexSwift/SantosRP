DeriveGamemode("gearfox")

santosRP = santosRP or {}
santosRP.isBeta = false --need better way to do this

AddLuaSVFolder("server/mysql")

AddLuaSHFolder("shared/itemsystem")
AddLuaSHFolder("shared")
AddLuaSHFolder("shared/hooks")
AddLuaSHFolder("shared/npcmenus")
AddLuaSHFolder("shared/player_sh")

AddLuaSVFolder("server")
AddLuaSVFolder("server/hooks")

AddLuaCSFolder("client/ui")

AddLuaCSFolder("client/hud/gui")
AddLuaCSFolder("client/hud/dialogs")

AddLuaCSFolder("client")
AddLuaCSFolder("client/hud")

AddLuaSHFolder("client/phone")


GM.Name 			= "Santos RP"
GM.Author 			= "SantosRP Team"
GM.Email 			= ""
GM.Website 			= "santosrp.com"

function GM:PlayerNoClip( pl )
	return pl:HasPermit("noclip")
end

function ColorVectorToInt( color )
	local int = 0
	local col = { color.x * 255, color.y * 255, color.z * 255 }
	
	for i = 1, 3, 1 do
		int = int + bit.lshift( col[i], ( i - 1 ) * 8 )
	end
	
	return int
end

--[[---------------------------------------------------------
    Name: IntToCol( integer )
-----------------------------------------------------------]]
function IntToColorVector( integer )

	print( integer, type( integer ) )

	local col = { 0, 0, 0 }
	
	for i = 1, 4, 1 do
		col[i] = bit.band( bit.rshift( integer, ( i - 1 ) * 8 ), 255 )
	end
	
	return Vector( col[1]/255, col[2]/255, col[3]/255 )
end

function table.HasSubValue( tab, value, index )
	
	for k,v in pairs( tab ) do
		if index then
			if v[ index ] == value then return true end
		else
			if v == value then return true end
		end
		continue
	end
	
	return false
	
end

function table.GetKeyFromSubValue( tab, value, index )
	
	for k,v in pairs( tab ) do
		if index then
			if v[ index ] == value then return k end
		else
			if v == value then return k end
		end
		continue
	end
	
	return nil
	
end
