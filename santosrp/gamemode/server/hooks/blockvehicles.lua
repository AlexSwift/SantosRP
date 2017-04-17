
local bbox = Vector(5,5,5)

hook.Add("PlayerUse","CarSeats",function(pl,veh)
	if (!veh:IsVehicle() or IsValid(pl:GetVehicle())) then return end
	
	local SPos = pl:GetShootPos()
	local a = util.TraceHull({
		start=SPos,
		endpos=SPos+pl:GetAimVector()*50,
		filter={veh,pl},
		mins=-bbox,
		maxs=bbox,
	})
	--Seats
	if (IsValid(a.Entity) and a.Entity:GetClass() == "prop_vehicle_prisoner_pod" and a.Entity:GetParent() == veh and a.Entity:IsVehicle() and !veh.Locked) then	
		pl:EnterVehicle(a.Entity)
	end
end)

function GM:CanPlayerEnterVehicle( pl, veh, WhatIsThisArgument )
	--Locked
	if (veh.Locked) then 
		pl:AddNote("Locked!")
		pl:ChatPrint("Locked!")
		return false
	end
		
	--Job specific drivers
	local Info = santosRP.Vehicles.GetCarInfoByModel(veh:GetModel())
	
	if (Info and Info.Job and pl:GetJob() != Info.Job) then 
		pl:AddNote("You must be a "..Info.Job.." in order to operate this vehicle!")
		--pl:ChatPrint("You must have a job as a "..Info.Job.." in order to operate this vehicle!")
		return false 
	end
	
	return true
end