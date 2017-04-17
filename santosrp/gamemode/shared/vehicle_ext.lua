local meta = FindMetaTable("Vehicle")

if (SERVER) then
	util.AddNetworkString("CarToggle")
	util.AddNetworkString("CarUpdateFuel")
	
	function meta:EngineStart(bStart)
		if (bStart) then self:Fire("TurnOn", "" , 0)
		else self:Fire("TurnOff", "" , 0) end
		
		self.Offline = !bStart
		
		self:UpdateEngine()
	end
	
	function meta:UpdateEngine(pl)
		net.Start("CarToggle")
			net.WriteEntity(self)
			net.WriteBit(self.Offline)
		if (IsValid(pl)) then net.Send(pl)
		else net.Broadcast() end
	end
	
	hook.Add("Tick","CarFuelTick",function()
		for k,car in pairs(ents.FindByClass("prop_vehicle_jeep")) do
			if (!car.Driven) then car.Driven = 0 end
			
			local pl = car:GetDriver()
			
			if (IsValid(pl)) then
				local EngineOn = car:IsEngineOn()
				
				if (EngineOn) then car.Driven = car.Driven + car:GetVelocity():Length() end
				if (ConvertUnitsToKM(car.Driven) > santosRP.Vehicles.GetCarInfoByModel( car:GetModel() ):GetFuelConsumption()) then
					car.Driven = 0
					car:AddFuel(-1)
					
					if (car:GetFuel() <= 0 and EngineOn) then
						car:EngineStart(false)
					end
				end
			end
		end
	end)
	
	function meta:SetFuel(fuel)
		if (!self.MaxFuel) then self.MaxFuel = 10 end
		
		self.Fuel = math.Clamp(fuel,0,self.MaxFuel)
		
		UpdateCarFuel(self)
	end
	
	function meta:AddFuel(fuel)
		self:SetFuel(self:GetFuel()+fuel)
	end
	
	function UpdateCarFuel(car,pl)
		if (!IsValid(car) or !car:IsVehicle()) then return end
		
		net.Start("CarUpdateFuel")
			net.WriteEntity(car)
			net.WriteUInt(car.Fuel or 10,8)
		if (IsValid(pl)) then net.Send(pl)
		else net.Broadcast() end
	end
else
	net.Receive("CarToggle",function()
		local Car = net.ReadEntity()
		if (!IsValid(Car)) then return end
		
		Car.Offline = util.tobool(net.ReadBit())
	end)
	
	net.Receive("CarUpdateFuel",function() 
		local Car = net.ReadEntity()
		
		if (!IsValid(Car)) then return end
		
		Car.Fuel = net.ReadUInt(8)
	end)
end

function meta:GetFuel()
	return self.Fuel or 10
end

function meta:GetMaxFuel()
	return self.MaxFuel or 10
end

function meta:IsEngineOn()
	return !self.Offline
end