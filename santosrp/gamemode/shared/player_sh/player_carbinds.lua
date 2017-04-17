local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("CarSetup")
	
	hook.Add("Tick","CarBinds",function( )
		for k,car in pairs(ents.FindByClass("prop_vehicle_jeep")) do
			local pl = car:GetDriver()
			
			if (!IsValid(pl)) then 
				if (car.Braking) then
					car.Braking = false
					UpdateCarBinds(car)
				end
			
			else
				local Change = false
				
				if (pl:KeyDown(IN_RELOAD)) then
					if (!pl.CanToggleEngine and car:GetFuel() > 0) then
						if not car:IsEngineOn() then
							--car:EmitSound( santosRP.Vehicles.GetCarInfoByModel( car:GetModel() ).EngineSound or 'sounds/car/backup/engine/sound.mp3' )
							timer.Simple( --[[santosRP.VehiclesGetCarInfoByModel( car:GetModel() ).EngineTime or]] 3, function( )
								car:EngineStart( true )
							end)
						else
							car:EngineStart( false )
						end
						pl.CanToggleEngine = true
					end
				else
					pl.CanToggleEngine = false
				end
				
				
				if (pl:KeyDown(IN_SPEED)) then
					if (!pl.HoldingDock) then
						car.SLights = !car.SLights
						Change = true
						
						pl.HoldingDock = true
					end
				else
					pl.HoldingDock = false
				end
				
				if (pl:KeyDown(IN_WALK)) then
					if (!pl.HoldingDock2) then
						car.Siren = !car.Siren
						Change = true
						
						pl.HoldingDock2 = true
					end
				else
					pl.HoldingDock2 = false
				end
				
				if (!car:IsEngineOn()) then
					if (car.Braking or car.SLights or car.Siren) then
						car.Braking = false
						car.SLights = false
						car.Siren = false
						
						Change = true
					end
				else
					local Stop = (pl:KeyDown(IN_JUMP) or pl:KeyDown(IN_BACK))
					if (Stop and !car.Braking) then
						car.Braking = true
						Change = true
					elseif (!Stop and car.Braking) then
						car.Braking = false
						Change = true
					end
					
				end
				
				if (Change) then UpdateCarBinds(car) end
			end
		end
	end)

	function UpdateCarBinds(car,pl)
		if (!IsValid(car) or !car:IsVehicle()) then return end
		
		net.Start("CarSetup")
			net.WriteEntity(car)
			net.WriteBit(car.Siren or false)
			net.WriteBit(car.SLights or false)
			net.WriteBit(car.Braking or false)
		if (IsValid(pl)) then net.Send(pl)
		else net.Broadcast() end
	end
else
	net.Receive("CarSetup",function() 
		local Car = net.ReadEntity()
		
		if (!IsValid(Car)) then return end
		
		Car.Siren = util.tobool(net.ReadBit())
		Car.SLights = util.tobool(net.ReadBit())
		Car.Braking = util.tobool(net.ReadBit())
	end)
end

