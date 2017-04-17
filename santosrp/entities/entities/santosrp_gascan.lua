

AddCSLuaFile()

ENT.Base 			= "santosrp_prop_base"

function ENT:StartTouch(ent)
	if (ent:IsVehicle() and ent:GetFuel() < ent:GetMaxFuel()) then
		ent:AddFuel(5)
		ent:EmitSound("ambient/water/water_spray1.wav")
		self:Remove()
	end
end

