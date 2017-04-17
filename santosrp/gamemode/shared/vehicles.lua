santosRP._VEHICLES = {}

local should_load = false

if santosRP.Vehicles then
	should_load = true
end

class 'santosRP.Vehicles' {

	public {
	
		static {
		
			LoadVehicles = function( tab )
			
				for k,v in pairs( tab ) do
				
					local vehicle = santosRP.Vehicles.new()
					vehicle:SetName( k )
					vehicle:SetDescription( v.Desc )
					vehicle:SetModel( v.Model )
					vehicle:SetScript( v.Script )
					vehicle:SetPrice( v.Price )
					vehicle:SetFuelTank( v.FuelTank or 10 )
					vehicle:SetFuelConsumption( v.FuelConsumption or 10 )
					vehicle:SetMaxSpeed( v.MaxSpeed or 0 )
					
					if v.SirenSound then
						vehicle:SetSirenSound( v.SirenSound )
					else
						vehicle:SetSirenSound( nil)
					end
					
					if v.Block then
						vehicle:SetBlocked( true )
					end
					
					if v.Job then
						vehicle:SetJobRequirement( v.Job )
					else
						vehicle:SetJobRequirement( nil )
					end
					
					if list.Get("Vehicles")[ vehicle:GetName() ] then
						vehicle:SetData( list.Get("Vehicles")[ vehicle:GetName() ] )
					end
					
					vehicle:Register()
				
				end
				
				santosRP.Vehicles.SyncMySQL()
			
			end;
			
			CleanupCarData = function(Data)
			
				local Dat = {Lights={},Seats={}}
				
				if (Data and Data.VC_ExtraSeats) then
					for a,l in pairs(Data.VC_ExtraSeats) do
						Dat.Seats[a] = {}
						
						Dat.Seats[a].Pos 		= l.Pos
						Dat.Seats[a].Ang 		= l.Ang or Angle(0,0,0)
					end
				end
				
				if (Data and Data.VC_Lights) then
					for a,l in pairs(Data.VC_Lights) do
						Dat.Lights[a] = {}
						
						local Col 		= WhiteCol
						local LightType = "Normal"
						
						if (l.BrakeColor) then 
							LightType = "Brakes"
							Col = string.Explode(" ",l.BrakeColor) 
							Col = Color(tonumber(Col[1]),tonumber(Col[2]),tonumber(Col[3]),255)
						elseif (l.BlinkersColor) then 
							LightType = "Blinker"
							Col = string.Explode(" ",l.BlinkersColor) 
							Col = Color(tonumber(Col[1]),tonumber(Col[2]),tonumber(Col[3]),255)
						elseif (l.HeadColor) then 
							LightType = "Headlight"
							Col = string.Explode(" ",l.HeadColor) 
							Col = Color(tonumber(Col[1]),tonumber(Col[2]),tonumber(Col[3]),255)
						elseif (l.ReverseColor) then 
							LightType = "Reverse"
							Col = string.Explode(" ",l.ReverseColor) 
							Col = Color(tonumber(Col[1]),tonumber(Col[2]),tonumber(Col[3]),255)
						elseif (l.NormalColor) then
							Col = string.Explode(" ",l.NormalColor) 
							Col = Color(tonumber(Col[1]),tonumber(Col[2]),tonumber(Col[3]),255)
						end
						
						if (l.Alpha) then Col.a = tonumber(l.Alpha) end
						
						Dat.Lights[a].Pos 		= l.Pos
						Dat.Lights[a].Ang 		= l.HeadLightAngle or Angle(0,0,0)
						Dat.Lights[a].LightType = LightType
						Dat.Lights[a].Color 	= Col
						Dat.Lights[a].Size 		= l.Size or 1
					end
				end
				
				return Dat
			end;
			
			ForeachCarSeat = function(ent,f)
				if (!IsValid(ent) or !ent.Data or !ent.Data.Seats) then return end
				for a,l in pairs(ent.Data.Seats) do f(ent,l,a) end
			end;
			
			ForeachCarLights = function(ent,f)
				if not CLIENT then return end
				if (!IsValid(ent) or !ent.Data or !ent.Data.Lights) then return end
				for a,l in pairs(ent.Data.Lights) do f(ent,l,a) end
			end;
			
			LoadCarFile = function( v_sModel )
			
				local File = "data/srpvehicles/"..string.gsub(string.gsub(v_sModel, "/", "_SRP_"), ".mdl", ".txt")
				local Data = {Lights={},Seats={}}
				
				--If not exist, check if theres a VCMod data file.
				if (!file.Exists(File,"GAME")) then 
					File = "data/VehController/Scripts_VCMod1/"..string.gsub(string.gsub(v_sModel, "/", "_$VC$_"), ".mdl", ".txt")
					
					--We only need to cleanup the data, if it comes from VCMod, as that is in an incorrect format.
					if (file.Exists(File,"GAME")) then
						Data = santosRP.Vehicles.CleanupCarData(util.JSONToTable(file.Read(File,"GAME")))
					end
				else
					Data = util.JSONToTable(file.Read(File,"GAME"))
				end
				
				return Data
			
			end;
			
			SaveCarFile = function(mdl,data)
				if (!mdl or !data) then return end
				
				local File = "srpvehicles/"..string.gsub(string.gsub(mdl, "/", "_SRP_"), ".mdl", ".txt")
				
				if (!file.IsDir("srpvehicles","DATA")) then file.CreateDir("srpvehicles") end
				
				local LongString = util.TableToJSON(data)
				file.Write(File,LongString)
				
				MsgN("Wrote "..File)
			end;
			
			SpawnVehicle = function( v_sName, data )
			
				local vehicle = santosRP.Vehicles.GetCarInfo( v_sName )
				if not vehicle then return end
				
				local car = ents.Create("prop_vehicle_jeep")
				car:SetModel( vehicle:GetModel() ) 
				car:SetKeyValue("vehiclescript", vehicle:GetScript() )
				car:SetPos( data.Position ) 
				car:SetColor( data.Color or Color( 255,255,255,255 ) )
				car:DrawShadow(false)
				car:Spawn()
				car.Data = santosRP.Vehicles.LoadCarFile( vehicle:GetModel() )
				
				if (SERVER) then
					santosRP.Vehicles.ForeachCarSeat(car ,function(ent,v)
						local seat = ents.Create("prop_vehicle_prisoner_pod") 
						seat:SetModel("models/props_phx/carseat2.mdl") 
						seat:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
						seat:SetOwner(ent)
						seat:SetMoveType(MOVETYPE_NONE)
						seat:SetPos(ent:LocalToWorld(v.Pos)) 
						seat:SetAngles(ent:LocalToWorldAngles(v.Ang)) 
						seat:SetParent(ent)
						seat:Spawn()
						seat:SetNoDraw(true)
						seat:DrawShadow(false)
					end)
					
				end
				
				return car
			
			end;
			
			FindSpawnPoint = function( ent )
			
				local spawn_point
			
				for k,v in pairs( ents.FindByClass( ent ) ) do
					if spawn_point then continue end
					local tab = ents.FindInSphere( v:GetPos(), 10 )
					for k2,v2 in pairs( tab ) do
						if v2:GetClass() == ent or v2:GetClass() == 'keyframe_rope' then 
							tab[k2] = nil
						end
					end
					if #tab > 0 then
						continue 
					end
					spawn_point = v
				end
				
				return spawn_point:GetPos(), spawn_point:GetAngles()
				
			end;
						
			
			GetCarList = function( )
			
				return santosRP._VEHICLES
			
			end;
			
			GetCarInfoByModel = function( v_sModel ) 
			
				for k,v in pairs( santosRP.Vehicles.GetCarList() ) do
					if string.lower( v:GetModel() ) == string.lower( v_sModel ) then return v end
					continue
				end
				
				return nil
				
			end;
			
			GetCarInfo = function( v_sName )
		
				for k,v in pairs( santosRP.Vehicles.GetCarList() ) do
					if string.lower( v:GetName() ) == string.lower( v_sName ) then return v end
					continue
				end
				
				return nil
				
			end;
			
			RequestBuyVehicle = function( v_sName )
			
				if not CLIENT then return end
				
				net.Start("RequestBuyVehicle")
					net.WriteString(v_sName)
				net.SendToServer()
				
			end;
			
			RequestSpawnVehicle = function( v_sName ,Col, location_ent )
			
				if not CLIENT then return end
			
				if not santosRP.Vehicles.GetCarInfo( v_sName ) then return end
				if not Col then
					Col = { r = 255, g = 255, b = 255, a = 255 }
				end
				
				Col = Color(Col.r,Col.g,Col.b,Col.a)
				
				net.Start("RequestSpawnVehicle")
					net.WriteString( location_ent or '' )
					net.WriteString(v_sName)
					net.WriteColor(Col)
				net.SendToServer()
			end;
			
			GetVehicle = function( v_sName )
			
				for k,v in pairs( santosRP.Vehicles.GetCarList() ) do
					if v:GetName() == v_sName then return v end
					continue
				end
				
				return nil
				
			end;
			
			SyncMySQL = function( )
			
				if not SERVER then return end
			
				local str = ''
				local w_clause = 'WHERE '
			
				GAMEMODE.Database:QueryAll("SELECT * FROM `santosrp`.`vehicle`;", function( data)
			
					for k,v in pairs( santosRP.Vehicles.GetCarList() ) do
						
						if not table.HasSubValue( data, v:GetName(), 'name' ) then
							str = str .. 'INSERT IGNORE INTO `santosrp`.`vehicle` ( name ) VALUES ( \'' .. v:GetName() .. '\' );\n'
							w_clause = w_clause .. 'name= \'' .. v:GetName() .. '\' OR '
						else
							v:SetMySQLID( data[ table.GetKeyFromSubValue( data, v:GetName() , 'name' ) ].id )
						end
					end
					w_clause = string.sub( w_clause, 1, #w_clause - 4 )
					
					if #str == 0 then return end
					
					GAMEMODE.Database( str, function( data )
						GAMEMODE.Database( 'SELECT * FROM `santosrp`.`vehicle` ' .. w_clause .. ';', function( data2 )
							if not data2 then return end
							santosRP.Vehicles.GetVehicle( data2.name ):SetMySQLID( data2.id )
						end)
					end)
					
				end)
			end;
			
			GetVehicleFromMySQLID = function( v_iMySQLID )
			
				if not v_iMySQLID then
					return					
				end
				
				for k,v in pairs( santosRP.Vehicles.GetCarList() ) do
					if v:GetMySQLID() == v_iMySQLID then return v end
					continue 
				end
				
				return nil
				
			end;
		
		};
	
		GetName = function( self )
		
			return self.v_sName
			
		end;
		
		GetDescription = function( self )
		
			return self.v_sDescription
			
		end;
		
		GetModel = function( self )

			return self.v_sModel
			
		end;
		
		GetScript = function( self )
		
			print( 'GetScript was called', self.v_sScript )
			
			return self.v_sScript
			
		end;
		
		GetPrice = function( self )
		
			return self.v_iPrice
			
		end;
		
		GetFuelTank = function( self )
		
			return self.v_iFuelTank 
			
		end;
		
		GetFuelConsumption = function( self )
		
			return self.v_iFuelConsumption
			
		end;
		
		GetMaxSpeed = function( self )
		
			return self.v_iMaxSpeed
			
		end;
		
		GetData = function( self )
		
			return self.v_aData
			
		end;
		
		GetMySQLID = function( self )
		
			return self.v_iMySQLID
			
		end;
		
		GetSirenSound = function( self )
		
			return self.v_sSirenSound
			
		end;
		
		GetBlocked = function( self )
			
			return self.v_bBlocked
			
		end;
		
		GetJobRequirement = function( self )
		
			return self.v_sJob
			
		end;
		
		SetMySQLID = function( self, v_iMySQLID ) --having to move this here because query callback does not count in the class boundaries 
		
			if not v_iMySQLID then return end
			self.v_iMySQLID = v_iMySQLID
			
		end;
		
		SetupCarFuel = function( self, car)
			if (!IsValid(car) or !car:IsVehicle()) then return end
			
			local Info = santosRP.Vehicles.GetCarInfoByModel(car:GetModel())
			
			if (!Info) then return end
			
			car.MaxFuel 			= Info.FuelTank or 10
			car.Fuel 				= Info.FuelTank or 10
			car.FuelConsumption 	= Info.FuelConsumption or 10
		end;
		
		UpdateCarFuel = function( self, car, pl)
			if (!IsValid(car) or !car:IsVehicle()) then return end
			
			net.Start("CarUpdateFuel")
				net.WriteEntity(car)
				net.WriteUInt(car.Fuel or 10,8)
			if (IsValid(pl)) then net.Send(pl)
			else net.Broadcast() end
		end
	
	};
	
	private {
	
		Register = function( self )
		
			if not self:GetName() then
				return
			end
			santosRP._VEHICLES[ self:GetName() ] = self
		
		end;
	
		SetName = function( self, v_sName )
		
			if not v_sName then return end
			self.v_sName = v_sName
		
		end;
	
		SetDescription = function( self, v_sDescription )
		
			if not v_sDescription then return end
			self.v_sDescription = v_sDescription
			
		end;
		
		SetModel = function( self, v_sModel )
		
			if not v_sModel then return end
			self.v_sModel = v_sModel
		
		end;
		
		SetScript = function( self, v_sScript )
		
			if not v_sScript then
				return
			end
			
			self.v_sScript = v_sScript
			
		end;
		
		SetPrice = function( self, v_iPrice )
		
			if not v_iPrice then
				print( v_iPrice )
				return 
			end
			self.v_iPrice = v_iPrice 
			
		end;
		
		SetFuelTank = function( self, v_iFuelTank )
		
			if not v_iFuelTank then return end
			self.v_iFuelTank = v_iFuelTank
			
		end;
		
		SetFuelConsumption = function( self, v_iFuelConsumption )
		
			if not v_iFuelConsumption then return end
			self.v_iFuelConsumption = v_iFuelConsumption
		
		end;
		
		SetMaxSpeed = function( self, v_iMaxSpeed )
		
			if not v_iMaxSpeed then return end
			self.v_iMaxSpeed = v_iMaxSpeed
			
		end;
		
		SetData = function( self, v_aData )
		
			if not v_aData then return end
			self.v_aData = v_aData
			
		end;
		
		SetSirenSound = function( self,v_sSirenSound )
			
			if not v_sSirenSound then return end
			self.v_sSirenSound = v_sSirenSound
			
		end;
		
		SetBlocked = function( self, v_bBlocked )
		
			if not v_bBlocked then return end
			self.v_bBlocked = v_bBlocked
			
		end;
		
		SetJobRequirement = function( self, v_sJob )
		
			if not v_sJob then return end
			self.v_sJob  = v_sJob
			
		end;
		
		v_sName				= '';
		v_sDescription		= '';
		v_sModel 			= '';
		v_sScript 			= '';
		v_iPrice 			= 0;
		v_iFuelTank 		= 10;
		v_iFuelConsumption	= 10;
		v_iMaxSpeed			= 0;
		v_aData				= {};
		v_iMySQLID			= 0;
		v_sSirenSound		= '';
		v_bBlocked			= false;
		v_sJob				= '';
	
	};
	
}

local _PLAYER = FindMetaTable("Player")

if SERVER then
	
	util.AddNetworkString("RequestSpawnVehicle")
	util.AddNetworkString("RequestBuyVehicle")
	util.AddNetworkString("UpdateBoughtVehicles")
	
	net.Receive("RequestSpawnVehicle",function(bit,pl)
		local ent = net.ReadString( ) 
		local spawn_pos,spawn_angles = #ent > 0 and santosRP.Vehicles.FindSpawnPoint( ent ) or nil
		pl:SpawnCar( net.ReadString() , { Color = net.ReadColor(), Position = spawn_pos, Angles = spawn_angles  } ) --function FindSpawnPosition( ent )
	end)
	
	net.Receive("RequestBuyVehicle",function(bit,pl)
	
		local v_sName = net.ReadString() 
		local vehicle = santosRP.Vehicles.GetCarInfo( v_sName )
	
		if pl:GetBankMoney() < vehicle:GetPrice() then
			pl:AddNote( "Insufficient funds on your bank account!" )
			return
		end
		
		pl:AddBankMoney( -vehicle:GetPrice() )
		pl:AddVehicle( v_sName )
		--pl:SpawnCar( v_sName )
		
	end)
	
	function _PLAYER:AddVehicle( v_sName, dont_save )
	
		if not self.Vehicles then self.Vehicles = {} end
	
		local vehicle = santosRP.Vehicles.GetVehicle( v_sName )
		self.Vehicles[ vehicle:GetName() ] = vehicle
		
		self:UpdateVehicles( v_sName )
		
		if not dont_save then
			GAMEMODE.Database("INSERT INTO `santosrp`.`player_vehicles` ( player_id, vehicle_id ) VALUES ( ?, ? );", self.MySQLID, vehicle:GetMySQLID(), function( _, data)
			end)
		end
		
	end
	
	function _PLAYER:RemoveVehicle( v_sName )
	
		if not self.Vehicles then self.Vehicles = {} end
	
		local vehicle = santosRP.Vehicles.GetVehicle( v_sName )
		if not self.Vehicles[ vehicle:GetName() ] then return end
		self.Vehicles[ vehicle:GetName() ] = nil
		
		self:UpdateVehicles( vehicle:GetName() )
	
		GAMEMODE.Database("DELETE FROM `santosrp`.`player_vehicles` WHERE player_id=? AND vehicle_id=?;", self.MySQLID, vehicle:GetMySQLID(), function( _, data)
		end)
		
	end
	
	function _PLAYER:UpdateVehicles( v_sName )
	
		net.Start( 'UpdateBoughtVehicles' )
			net.WriteString( v_sName )
			net.WriteBit( self.Vehicles[ v_sName ] )
		net.Send( self )
		
	end
	
	function _PLAYER:SpawnCar(Name,Data)
		local col = Data.Color or Color( 255,255,255,255 )
		if  not IsValid(self.TalkingNPC) then return end
		if (self.TalkingNPC:GetPos():Distance(self:GetPos()) > 200) then return end
		if (self:IsInCar()) then return end
		if (IsValid(self.Car)) then self.Car:Remove() end
		
		local vehicle_data = santosRP.Vehicles.GetCarInfo( Name )
		
		if self.Vehicles and not self.Vehicles[ Name ] and not vehicle_data:GetJobRequirement() then return end
		if vehicle_data:GetJobRequirement() and vehicle_data:GetJobRequirement() ~= self.Job then return end
		
		local car = santosRP.Vehicles.SpawnVehicle( Name, {Angles = Data.Angles or Angle( 0,0,0),Position = Data.Position or Vector(-3922.728271, -1487.679199, 48.970406), Color = Data.Color or Color( 255,255,255,255 ) } )
		
		self.Car = car
	end

else

	net.Receive( 'UpdateBoughtVehicles' , function( )
	
		if not LocalPlayer().Vehicles then 
			LocalPlayer().Vehicles = {}
		end
		
		local v_sName = net.ReadString()
		
		if tobool( net.ReadBit() ) then
			LocalPlayer().Vehicles[ v_sName ] = santosRP.Vehicles.GetVehicle( v_sName )
		else
			LocalPlayer().Vehicles[ v_sName ] = nil
		end
	
	end)
	
	net.Receive("CarUpdateFuel",function() 
		local Car = net.ReadEntity()
		
		if (!IsValid(Car)) then return end
		
		Car.Fuel = net.ReadUInt(8)
	end)

end

function _PLAYER:GetVehicles( )

	return self.Vehicles or {}
	
end

function table.SortByPrice( Table )

	local temp = {}
	local temp2 = {}

	
	for key, _ in pairs( Table ) do table.insert(temp, key) end
	table.sort(temp, function(a, b) return Table[a]:GetPrice() < Table[b]:GetPrice() end)
	
	for i = 1, #temp do
		table.insert( temp2 ,santosRP.Vehicles.GetCarList()[ temp[ i ] ] )
	end
	
	return temp2
end


CarList = {
	["Ford F350 SuperDuty"] = {
			Desc = "A drivable Ford F350 SuperDuty by TheDanishMaster",
			Model = "models/tdmcars/for_f350.mdl",
			Script = "scripts/vehicles/TDMCars/f350.txt",
			Price = 33000,
		    FuelTank = 200,
		    FuelConsumption = 3.5,
		    MaxSpeed = 0,	
			PassengerSeats = 1,
	},
	["Audi S5"] = {
			Desc = "A drivable Audi S5 by TheDanishMaster",
			Model = "models/tdmcars/s5.mdl",
			Script = "scripts/vehicles/TDMCars/s5.txt",
			Price = 75000,
			FuelTank = 61,
		    FuelConsumption = 15.625,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Mitsubishi Lancer Evolution X GSR"] = {
			Desc = "A drivable Mitsubishi Lancer Evolution X GSR by TheDanishMaster",
			Model = "models/tdmcars/mitsu_evox.mdl",
			Script = "scripts/vehicles/TDMCars/mitsu_evox.txt",
			Price = 38000,
			FuelTank = 65,
		    FuelConsumption = 10.625,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volvo S60R"] = {
			Desc = "A drivable Volvo S60R by TheDanishMaster",
			Model = "models/tdmcars/vol_s60.mdl",
			Script = "scripts/vehicles/tdmcars/vols60.txt",
			Price = 55000,
			FuelTank = 58,
		    FuelConsumption = 16.8,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["BMW M1 1981"] = {
			Desc = "A drivable BMW M1 1981 by TheDanishMaster",
			Model = "models/tdmcars/bmwm1.mdl",
			Script = "scripts/vehicles/TDMCars/m1.txt",
			Price = 5000,
			FuelTank = 116,
		    FuelConsumption = 8.75,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Porsche 997 GT3"] = {
			Desc = "A drivable Porsche 997 GT3 by TheDanishMaster",
			Model = "models/tdmcars/997gt3.mdl",
			Script = "scripts/vehicles/TDMCars/997gt3.txt",
			Price = 160000,
			FuelTank = 80,
		    FuelConsumption = 19,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Toyota Prius"] = {
			Desc = "A drivable Toyota Prius by TheDanishMaster",
			Model = "models/tdmcars/prius.mdl",
			Script = "scripts/vehicles/TDMCars/prius.txt",
			Price = 26000,
			FuelTank = 53.55,
		    FuelConsumption = 31.25,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volvo XC90"] = {
			Desc = "A drivable Volvo XC90 by TheDanishMaster",
			Model = "models/tdmcars/vol_xc90.mdl",
			Script = "scripts/vehicles/tdmcars/volxc90.txt",
			Price = 38000,
			FuelTank = 95,
		    FuelConsumption = 13.3,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Morgan Aero SS"] = {
			Desc = "A drivable Morgan Aero SS by TheDanishMaster",
			Model = "models/tdmcars/morg_aeross.mdl",
			Script = "scripts/vehicles/TDMCars/morg_aeross.txt",
			Price = 55000,
		    FuelTank = 55,
		    FuelConsumption = 17,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Mitsubishi Eclipse GT"] = {
			Desc = "A drivable Mitsubishi Eclipse GT by TheDanishMaster",
			Model = "models/tdmcars/mitsu_eclipgt.mdl",
			Script = "scripts/vehicles/TDMCars/mitsu_eclipgt.txt",
			Price = 29000,
			FuelTank = 79,
		    FuelConsumption = 15.6,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volvo 850 R"] = {
			Desc = "A drivable Volvo 850 R by TheDanishMaster",
			Model = "models/tdmcars/vol_850r.mdl",
			Script = "scripts/vehicles/TDMCars/850r.txt",
			Price = 12000,
			FuelTank = 73,
		    FuelConsumption = 7.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Chevrolet Blazer"] = {
			Desc = "A drivable Chevrolet Blazer by TheDanishMaster",
			Model = "models/tdmcars/chev_blazer.mdl",
			Script = "scripts/vehicles/TDMCars/blazer.txt",
			Price = 19000,
			FuelTank = 85,
		    FuelConsumption = 8.125,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Toyota Supra"] = {
			Desc = "A drivable Toyota Supra by TheDanishMaster",
			Model = "models/tdmcars/supra.mdl",
			Script = "scripts/vehicles/TDMCars/supra.txt",
			Price = 68000,
			FuelTank = 60,
		    FuelConsumption = 10.6,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Scion tC"] = {
			Desc = "A drivable Scion tC by TheDanishMaster",
			Model = "models/tdmcars/scion_tc.mdl",
			Script = "scripts/vehicles/TDMCars/sciontc.txt",
			Price = 23000,
			FuelTank = 65,
		    FuelConsumption = 14,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["GMC Sierra"] = {
			Desc = "A drivable GMC Sierra by TheDanishMaster",
			Model = "models/tdmcars/gmc_sierralow.mdl",
			Script = "scripts/vehicles/TDMCars/sierralow.txt",
			Price = 26000,
			FuelTank = 117,
		    FuelConsumption = 10.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Chevrolet Camaro SS 69"] = {
			Desc = "A drivable Chevrolet Camaro SS 69 by TheDanishMaster",
			Model = "models/tdmcars/69camaro.mdl",
			Script = "scripts/vehicles/TDMCars/69camaro.txt",
			Price = 21000,
			FuelTank = 81,
		    FuelConsumption = 8,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volkswagen Scirocco R"] = {
			Desc = "A drivable Volkswagen Scirocco R by TheDanishMaster",
			Model = "models/tdmcars/vw_sciroccor.mdl",
			Script = "scripts/vehicles/TDMCars/sciroccor.txt",
			Price = 16000,
			FuelTank = 55,
		    FuelConsumption = 15.625,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Subaru Impreza WRX STi"] = {
			Desc = "The Subaru Impreza WRX STi, gmod-able by TDM",
			Model = "models/tdmcars/sub_wrxsti08.mdl",
			Script = "scripts/vehicles/TDMCars/subimpreza08.txt",
			Price = 35000,
			FuelTank = 88,
		    FuelConsumption = 12.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Nissan GT-R Black Edition"] = {
			Desc = "A drivable Nissan GT-R Black Edition by TheDanishMaster",
			Model = "models/tdmcars/nissan_gtr.mdl",
			Script = "scripts/vehicles/TDMCars/gtr.txt",
			Price = 150000,
			FuelTank = 87.75,
		    FuelConsumption = 12.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Toyota FJ Cruiser"] = {
			Desc = "A drivable Toyota FJ Cruiser by TheDanishMaster",
			Model = "models/tdmcars/toy_fj.mdl",
			Script = "scripts/vehicles/TDMCars/toyfj.txt",
			Price = 29000,
			FuelTank = 85.5,
		    FuelConsumption = 11.8,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Dodge Charger SRT8 2012"] = {
			Desc = "A drivable Dodge Charger SRT8 2012 by TheDanishMaster",
			Model = "models/tdmcars/dod_charger12.mdl",
			Script = "scripts/vehicles/TDMCars/charger2012.txt",
			Price = 58000,
			FuelTank = 88,
		    FuelConsumption = 10.67,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["ECPD Dodge Charger Hellcat"] = {
			Desc = "A drivable Dodge Charger Hellcat by Sentry",
			Model = "models/sentry/15hellcat_cop.mdl",
			Script = "scripts/vehicles/sentry/hellcat.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 3,
			Block = true,
			Job = "Police Officer",
			SirenSound = "santosrp/sirens/police_siren1.wav",
	},
	["Toyota RAV4 Sport"] = {
			Desc = "A drivable Toyota RAV4 Sport by TheDanishMaster",
			Model = "models/tdmcars/toy_rav4.mdl",
			Script = "scripts/vehicles/TDMCars/toyrav4.txt",
			Price = 38000,
			FuelTank = 72,
		    FuelConsumption = 15,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Audi TT 07"] = {
			Desc = "A drivable Audi TT 07 by TheDanishMaster",
			Model = "models/tdmcars/auditt.mdl",
			Script = "scripts/vehicles/TDMCars/auditt.txt",
			Price = 42000,
			FuelTank = 60,
		    FuelConsumption = 22,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Toyota MR2 GT"] = {
			Desc = "A drivable Toyota MR2 GT by TheDanishMaster",
			Model = "models/tdmcars/toy_mr2gt.mdl",
			Script = "scripts/vehicles/TDMCars/mr2gt.txt",
			Price = 27000,
		    FuellTank = 70,
		    FuelConsumption = 9,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Audi R8"] = {
			Desc = "A drivable Audi R8 by TheDanishMaster",
			Model = "models/tdmcars/audir8.mdl",
			Script = "scripts/vehicles/TDMCars/audir8.txt",
			Price = 180000,
			FuelTank = 103,
		    FuelConsumption = 8.125,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Nissan Skyline R34"] = {
			Desc = "A drivable Nissan Skyline R34 by TheDanishMaster",
			Model = "models/tdmcars/skyline_r34.mdl",
			Script = "scripts/vehicles/TDMCars/skyline_r34.txt",
			Price = 43000,
			FuelTank = 65,
		    FuelConsumption = 14,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Subaru Legacy RS 1990"] = {
			Desc = "The Subaru Subaru Legacy RS 1990, gmod-able by TDM",
			Model = "models/tdmcars/sub_legacyrs90.mdl",
			Script = "scripts/vehicles/TDMCars/sublegrs90.txt",
			Price = 9500,
			FuelTank = 60,
		    FuelConsumption = 10,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volkswagen Camper 1965"] = {
			Desc = "The Volkswagen Camper 1965, gmod-able by TDM",
			Model = "models/tdmcars/vw_camper65.mdl",
			Script = "scripts/vehicles/TDMCars/vwcamper.txt",
			Price = 12000,
			FuelTank = 60,
		    FuelConsumption = 6,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Chrysler 300c"] = {
			Desc = "A drivable Chrysler 300c by TheDanishMaster",
			Model = "models/tdmcars/chr_300c.mdl",
			Script = "scripts/vehicles/TDMCars/300c.txt",
			Price = 50000,
			FuelTank = 72,
		    FuelConsumption = 14.4,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Chevrolet Camaro ZL1"] = {
			Desc = "A drivable Chevrolet Camaro ZL1 by TheDanishMaster",
			Model = "models/tdmcars/chev_camzl1.mdl",
			Script = "scripts/vehicles/TDMCars/camarozl1.txt",
			Price = 65000,
		    FuelTank = 85.5,
		    FuelConsumption = 12,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volkswagen Golf VR6 GTi"] = {
			Desc = "A drivable VW Golf MK3 by TheDanishMaster",
			Model = "models/tdmcars/golfvr6_mk3.mdl",
			Script = "scripts/vehicles/TDMCars/golfvr6.txt",
			Price = 3500,
			FuelTank = 63,
		    FuelConsumption = 13.75,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["McLaren P1"] = {
			Desc = "A drivable McLaren P1 by TheDanishMaster",
			Model = "models/tdmcars/mclaren_p1.mdl",
			Script = "scripts/vehicles/TDMCars/mclarenp1.txt",
			Price = 1500000,
			FuelTank = 65,
		    FuelConsumption = 17.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Porsche Carrera GT"] = {
			Desc = "A drivable Porsche Carrera GT by TheDanishMaster",
			Model = "models/tdmcars/por_carreragt.mdl",
			Script = "scripts/vehicles/TDMCars/carreragt.txt",
			Price = 650000,
			FuelTank = 90,
		    FuelConsumption = 7.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Hudson Hornet"] = {
			Desc = "A drivable Hudson Hornet by TheDanishMaster",
			Model = "models/tdmcars/hud_hornet.mdl",
			Script = "scripts/vehicles/TDMCars/hudhornet.txt",
			Price = 14000,
			FuelTank = 70,
		    FuelConsumption = 15,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volkswagen New Beetle Convertible"] = {
			Desc = "The Volkswagen New Beetle Convertible, gmod-able by TDM",
			Model = "models/tdmcars/vw_beetleconv.mdl",
			Script = "scripts/vehicles/TDMCars/vwbeetleconv.txt",
			Price = 16000,
			FuelTank = 55,
		    FuelConsumption = 17,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volvo 242 Turbo"] = {
			Desc = "A drivable Volvo 242 Turbo by TheDanishMaster",
			Model = "models/tdmcars/242turbo.mdl",
			Script = "scripts/vehicles/tdmcars/242turbo.txt",
			Price = 25000,
			FuelTank = 66,
		    FuelConsumption = 10,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Scion FR-S"] = {
			Desc = "A drivable Scion FR-S by TheDanishMaster",
			Model = "models/tdmcars/scion_frs.mdl",
			Script = "scripts/vehicles/TDMCars/scionfrs.txt",
			Price = 26000,
			FuelTank = 135,
		    FuelConsumption = 14,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Noble M600"] = {
			Desc = "A drivable Noble M600 by TheDanishMaster",
			Model = "models/tdmcars/noblem600.mdl",
			Script = "scripts/vehicles/TDMCars/noblem600.txt",
			Price = 98000,
			FuelTank = 68,
		    FuelConsumption = 9,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Mitsubishi Lancer Evolution VIII"] = {
			Desc = "A drivable Mitsubishi Lancer Evolution VIII by TheDanishMaster",
			Model = "models/tdmcars/mitsu_evo8.mdl",
			Script = "scripts/vehicles/TDMCars/mitsu_evo8.txt",
			Price = 32000,
			FuelTank = 59,
		    FuelConsumption = 15.6,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Jeep Wrangler 1988"] = {
			Desc = "A drivable Jeep Wrangler 1988 by TheDanishMaster",
			Model = "models/tdmcars/jeep_wrangler88.mdl",
			Script = "scripts/vehicles/TDMCars/wrangler88.txt",
			Price = 12000,
			FuelTank = 75,
		    FuelConsumption = 10,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Subaru Impreza WRX STi 05"] = {
			Desc = "The Subaru Impreza WRX STi 05, gmod-able by TDM",
			Model = "models/tdmcars/sub_wrxsti05.mdl",
			Script = "scripts/vehicles/TDMCars/subimpreza05.txt",
			Price = 26000,
			FuelTank = 58,
		    FuelConsumption = 10,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Nissan 370z"] = {
			Desc = "The Nissan 370z, gmod-able by TDM",
			Model = "models/tdmcars/nis_370z.mdl",
			Script = "scripts/vehicles/TDMCars/370z.txt",
			Price = 32000,
			FuelTank = 85.5,
		    FuelConsumption = 9.375,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Nissan Silvia S15"] = {
			Desc = "A drivable Nissan Silvia S15 by TheDanishMaster",
			Model = "models/tdmcars/nissan_silvias15.mdl",
			Script = "scripts/vehicles/TDMCars/nissilvs15.txt",
			Price = 23000,
			FuelTank = 65,
		    FuelConsumption = 9,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volkswagen Beetle 1968"] = {
			Desc = "A drivable Volkswagen Beetle 1968 by TheDanishMaster",
			Model = "models/tdmcars/beetle.mdl",
			Script = "scripts/vehicles/TDMCars/beetle68.txt",
			Price = 3000,
			FuelTank = 45,
		    FuelConsumption = 13,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Bugatti Veyron SS"] = {
			Desc = "A drivable Bugatti Veyron SS by TheDanishMaster",
			Model = "models/tdmcars/bug_veyronss.mdl",
			Script = "scripts/vehicles/TDMCars/veyronss.txt",
			Price = 4000000,
			FuelTank = 118,
		    FuelConsumption = 6.8,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volkswagen Golf MKII"] = {
			Desc = "The good old VW Golf MKII, gmod-able by TDM",
			Model = "models/tdmcars/golf_mk2.mdl",
			Script = "scripts/vehicles/TDMCars/golfmk2.txt",
			Price = 2000,
			FuelTank = 55,
		    FuelConsumption = 15,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Toyota Tundra Crewmax"] = {
			Desc = "A drivable Toyota Tundra Crewmax by TheDanishMaster",
			Model = "models/tdmcars/toy_tundra.mdl",
			Script = "scripts/vehicles/TDMCars/toytundra.txt",
			Price = 43000,
			FuelTank = 115,
		    FuelConsumption = 8,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["BMW M3 E92"] = {
			Desc = "A drivable BMW M3 E92 by TheDanishMaster",
			Model = "models/tdmcars/bmwm3e92.mdl",
			Script = "scripts/vehicles/TDMCars/bmwm3e92.txt",
			Price = 80000,
			FuelTank = 63,
		    FuelConsumption = 28,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Pagani Zonda C12"] = {
			Desc = "A drivable Pagani Zonda C12 by TheDanishMaster",
			Model = "models/tdmcars/zondac12.mdl",
			Script = "scripts/vehicles/TDMCars/c12.txt",
			Price = 360000,
			FuelTank = 90,
		    FuelConsumption = 6.5,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Bugatti Veyron"] = {
			Desc = "A drivable Bugatti Veyron by TheDanishMaster",
			Model = "models/tdmcars/bug_veyron.mdl",
			Script = "scripts/vehicles/TDMCars/veyron.txt",
			Price = 3200000,
			FuelTank = 118,
		    FuelConsumption = 7,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Porsche Cayenne Turbo 12"] = {
			Desc = "A drivable Porsche Cayenne Turbo 12 by TheDanishMaster",
			Model = "models/tdmcars/por_cayenne12.mdl",
			Script = "scripts/vehicles/TDMCars/cayenne12.txt",
			Price = 88000,
			FuelTank = 78,
		    FuelConsumption = 9.4,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Porsche 918 Spyder"] = {
			Desc = "A drivable Porsche 918 Spyder by TheDanishMaster",
			Model = "models/tdmcars/por_918.mdl",
			Script = "scripts/vehicles/TDMCars/918spyd.txt",
			Price = 750000,
			FuelTank = 83,
		    FuelConsumption = 31,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Vauxhall Corsa VXR"] = {
			Desc = "A drivable Vauxhall Corsa VXR by TheDanishMaster",
			Model = "models/tdmcars/vaux_corsa.mdl",
			Script = "scripts/vehicles/TDMCars/vaux_corsa.txt",
			Price = 18000,
			FuelTank = 55,
		    FuelConsumption = 9,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Subaru Legacy GT 2010"] = {
			Desc = "The Subaru Legacy GT 2010, gmod-able by TDM",
			Model = "models/tdmcars/sub_legacygt10.mdl",
			Script = "scripts/vehicles/TDMCars/subleggt10.txt",
			Price = 29000,
			FuelTank = 81,
		    FuelConsumption = 11.25,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Bugatti EB110"] = {
			Desc = "A drivable Bugatti EB110 by TheDanishMaster",
			Model = "models/tdmcars/bug_eb110.mdl",
			Script = "scripts/vehicles/TDMCars/eb110.txt",
			Price = 1800000,
			FuelTank = 120,
		    FuelConsumption = 7,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Aston Martin DBS"] = {
			Desc = "A drivable Aston Martin DBS by TheDanishMaster",
			Model = "models/tdmcars/dbs.mdl",
			Script = "scripts/vehicles/TDMCars/dbs.txt",
			Price = 275000,
			FuelTank = 80,
		    FuelConsumption = 14.375,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Volvo XC70 Turbo"] = {
			Desc = "A drivable Volvo XC70 Turbo by TheDanishMaster",
			Model = "models/tdmcars/vol_xc70.mdl",
			Script = "scripts/vehicles/tdmcars/volxc70.txt",
			Price = 65000,
		    FuelTank = 0,
		    FuelConsumption = 10,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Porsche Cayenne Turbo S"] = {
			Desc = "A drivable Porsche Cayenne Turbo S by TheDanishMaster",
			Model = "models/tdmcars/cayenne.mdl",
			Script = "scripts/vehicles/TDMCars/cayenne.txt",
			Price = 78000,
			FuelTank = 85,
		    FuelConsumption = 150,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Vauxhall Insignia VXR"] = {
			Desc = "The Vauxhall Insignia VXR, gmod-able by TDM",
			Model = "models/tdmcars/vaux_insignia.mdl",
			Script = "scripts/vehicles/TDMCars/vaux_insignia.txt",
			Price = 49000,
			FuelTank = 70,
		    FuelConsumption = 16,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["BMW M5 E60"] = {
			Desc = "A drivable BMW M5 E60 by TheDanishMaster",
			Model = "models/tdmcars/bmwm5e60.mdl",
			Script = "scripts/vehicles/TDMCars/bmwm5e60.txt",
			Price = 75000,
			FuelTank = 60,
		    FuelConsumption = 10,
		    MaxSpeed = 0,
			PassengerSeats = 1,
	},
	["Chevrolet Impala LS Police Cruiser"] = {
			Desc = "Driveable Chevrolet Impala LS by LoneWolfie",
			Model = "models/LoneWolfie/chev_impala_09_police.mdl",
			Script = "scripts/vehicles/LWCars/chev_impala_09.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 1,
			Block = true,
			Job = "Police Officer",
			SirenSound = "santosrp/sirens/police_siren1.wav",
	},
	["GMC C5500 Ambulance"] = {
			Desc = "vroom vroom",
			Model = "models/sentry/c5500_ambu.mdl",
			Script = "scripts/vehicles/sentry/c5500.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 1,
			Block = true,
			Job = "Paramedic",
			SirenSound = "santosrp/sirens/ems_siren1.wav",
	},
	["Ford C-Series Firetruck"] = {
			Desc = "vroom vroom",
			Model = "models/sentry/caison_fire.mdl",
			Script = "scripts/vehicles/sgmcars/firetruck.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 1,
			Block = true,
			Job = "Fire Fighter",
			SirenSound = "santosrp/sirens/fire_siren1.wav",
	},
	["Chevrolet Suburban Police Cruiser"] = {
			Desc = "Driveable Chevrolet Suburban GMT900 by LoneWolfie",
			Model = "models/LoneWolfie/chev_suburban_pol.mdl",
			Script = "scripts/vehicles/LWCars/chev_suburban.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 1,
			Block = true,
			Job = "Police Officer",
			SirenSound = "santosrp/sirens/police_siren1.wav",
	},
	["SantosRP SWAT Van"] = {
			Desc = "Driveable SWAT Van by sentry",
			Model = "models/sentry/swatvan.mdl",
			Script = "scripts/vehicles/sgmcars/vswat.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 1,
			Block = true,
			Job = "SWAT",
			SirenSound = "santosrp/sirens/police_siren1.wav",
	},
	["Bus"] = {
			Desc = "A drivable Bus by TheDanishMaster",
			Model = "models/tdmcars/bus.mdl",
			Script = "scripts/vehicles/TDMCars/bus.txt",
			Price = 1,
			FuelTank = 200,
		    FuelConsumption = 20,
			MaxSpeed = 0,
			PassengerSeats = 1,
			Block = true,
			Job = "Bus Driver",
	},
}

if CLIENT then
	santosRP.Vehicles.LoadVehicles( CarList )
elseif should_load then
	santosRP.Vehicles.LoadVehicles( CarList )
end