santosRP.MySQL = {}

local _Cache = {}
local _PLAYER = FindMetaTable("Player")

function santosRP.MySQL.UpdateCache( ply )

	if not _Cache[ ply:SteamID64() ] then 
		_Cache[ ply:SteamID64() ] = {}
	end
	
	_Cache[ ply:SteamID64() ].Money = ply:GetMoney() or 0
	_Cache[ ply:SteamID64() ].BankMoney = ply:GetBankMoney() or 0
	_Cache[ ply:SteamID64() ].Rank = ply.Rank or 1
	_Cache[ ply:SteamID64() ].Inventory = ply:GetInventory() or {}
	_Cache[ ply:SteamID64() ].RPName = ply:GetRPName() or ply:Nick()
	_Cache[ ply:SteamID64() ].ID = ply.MySQLID
	_Cache[ ply:SteamID64() ].SelectedModel = ply.SelectedModel
	_Cache[ ply:SteamID64() ].Color = ply:GetPlayerColor()
	
end

function santosRP.MySQL.GetCache( ply )

	if not _Cache[ ply:SteamID64() ] then return false end
	
	return _Cache[ ply:SteamID64() ]
	
end

function santosRP.MySQL.UpdatePlayerInfo(ply, data)

	if not data then santosRP.MySQL.CreatePlayer(ply) return end
	if not _Cache[ply:SteamID64()] then _Cache[ply:SteamID64()] = {} end

	for k, v in pairs(data) do
		_Cache[ply:SteamID64()][k] = v
		ply[k] = v
	end
	
	ply:SetMoney( data.money )
	ply:SetBankMoney( data.bank_money )
	ply:SetModel( data.SelectedModel or "models/player/Group01/male_07.mdl" )
	ply:SetRPName( data.RPName )
	ply:SetPlayerColor( IntToColorVector( data.Color ) )
	ply:KillSilent()
	ply:Spawn()
	ply:SetJob( 'Citizen' )
	ply:CreateSkillsFlags( data.Skills )
	
	for k,v in pairs( player.GetAll() ) do
		v:UpdateJob( ply )
	end
	
end

function santosRP.MySQL.UpdatePlayerInventory(ply, data)

	if not _Cache[ ply:SteamID64() ] then
		_Cache[ ply:SteamID64() ] = {}
	end

	_Cache[ply:SteamID64()].Inventory = data
end

function santosRP.MySQL.CreatePlayer( ply ) 

	GAMEMODE.Database("INSERT INTO `santosrp`.`player` ( steamid ) VALUES ( ? );", ply:SteamID64(), function( _, data)
		
		ply.MySQLID = data
		
		GAMEMODE.Database([[
			INSERT INTO `santosrp`.`player_info` (`player_id`, `rpname`, `money`, `bank_money`, `model`, `color`) VALUES (?, ?, ?, ?, ?, ?);]], 
			ply.MySQLID, ply:GetRPName() , 0, 0, ply:GetModel(), 2^32 - 1,
			function(data2) 
				santosRP.MySQL.UpdatePlayerInfo( ply,
					{Money = ply:GetMoney() or 0,
                     BankMoney = ply:GetBankMoney() or 0,
                     Rank = ply.Rank or 1,
                     Inventory = ply:GetInventory() or {},
                     RPName = ply.RPName or ply:Nick(),
                     ID = data,
                     SelectedModel = ply.SelectedModel,
					 Color = 2^16 + 2^8 + 1,
					 Skills = 0
					})
				ply:CallbackPlayerLoaded( true , ply:GetPData("answered", false))
			end)
		
		GAMEMODE.Database([[ INSERT INTO `santosrp`.`player_skills` (`player_id`, `skills`) VALUES ( ?, ? );]], ply.MySQLID, 0 )
		
	end)

end

function _PLAYER:LoadMySQL( )

	GAMEMODE.Database("SELECT * FROM `santosrp`.`player` WHERE steamid=?", self:SteamID64(), function(data)
		
		if not data then 
		
			santosRP.MySQL.CreatePlayer( self )
			return
			
		end
		
		self.MySQLID = data.id
		
		GAMEMODE.Database("SELECT * FROM `santosrp`.`player_info` WHERE player_id=?", self.MySQLID, function(data)
		
			if not data then return end
			
			PrintTable( data )
			
			santosRP.MySQL.UpdatePlayerInfo(self, {
				RPName = data.rpname,
				money = data.money,
				bank_money = data.bank_money,
				Rank = data.rank,
				SelectedModel = data.model,
				Color = data.color or (2^32 - 1)
			}, self)
			
			santosRP.MySQL.UpdateCache( self )
			
		end)
		
		GAMEMODE.Database("SELECT * FROM `santosrp`.`player_inventory` WHERE player_id=?", self.MySQLID, function(data)
		
			if not data then return end
			
			self:AddInventory( santosRP.Items.GetItemFromMySQLID( data.item_id ):GetData().Name, data.slot, true )
		end)
		
		GAMEMODE.Database("SELECT * FROM `santosrp`.`player_vehicles` WHERE player_id=?", self.MySQLID, function(data)
		
			if not data then return end
		
			self:AddVehicle( santosRP.Vehicles.GetVehicleFromMySQLID( data.vehicle_id ):GetName(), true )
		end)
		
		GAMEMODE.Database("SELECT * FROM `santosrp`.`player_vehicles` WHERE player_id=?", self.MySQLID, function(data)
		
			if not data then return end
		
			self:CreateSkillsFlags( data.skills )
		end)
		
		GAMEMODE.Database("SELECT * FROM `santosrp`.`player_vehicles` WHERE player_id=?", self.MySQLID, function(data)
		
			if not data then return end
		
			self:SetClothing( santosRP.Items.GetItemFromMySQLID( data.vehicle_id ):GetName(), true )
		end)
		
		self:CallbackPlayerLoaded( false )
		
	end)
	
end

function _PLAYER:SaveInfo(...)
	local args = {...}
	if #args % 2 ~= 0 then return end --still not 100% safe but it's as good as we can expend
	local str = ''
	
	for i = 1, #args/2 - 1 do
		
		str = str .. args[ i ] .. '=' .. args[i + 1] .. ', '
	
	end
	
	str = str .. args[ #args - 1 ] .. '=' .. args[ #args ]
	
	GAMEMODE.Database("UPDATE `santosrp`.`player_info` SET " .. str .. " WHERE player_id=" .. self.MySQLID, unpack( args ))
	
end