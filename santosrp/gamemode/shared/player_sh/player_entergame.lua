
if (SERVER) then
	util.AddNetworkString("RequestSpawn")
	
	net.Receive("RequestSpawn",function(bit,pl)
		if (pl.SelectedModel) then return end
		
		pl.SelectedModel = SelectCharacter(net.ReadInt(16),util.tobool(net.ReadBit()))
		pl:KillSilent()
		pl:Spawn()
		pl.Color = net.ReadVector()
		pl:SetPlayerColor( pl.Color )
		pl:SetModel( pl.SelectedModel )
		pl:SetRPName( net.ReadString() )
		pl:SetJob( 'Citizen' )
		
		print( ColorVectorToInt( pl.Color ) )
		print( pl.Color ) 
		
		pl:SaveInfo( 'color', ColorVectorToInt( pl.Color ) )
		pl:SaveInfo( 'model', "'" .. pl.SelectedModel .. "'" )
		
	end)
else
	function RequestSpawn(CharID,bFemale,PlayerColor,Name)
		net.Start("RequestSpawn")
			net.WriteInt(CharID,16)
			net.WriteBit(bFemale)
			net.WriteVector(PlayerColor or Vector(1,1,1))
			net.WriteString(Name)
		net.SendToServer()
	end
end