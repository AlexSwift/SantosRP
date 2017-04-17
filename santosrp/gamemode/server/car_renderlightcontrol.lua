

local meta = FindMetaTable("Vehicle")


function meta:SpawnCarLightControl()
	if (IsValid(self.LightControl)) then self.LightControl:Remove() end
	
	self.LightControl = ents.Create("santosrp_car_renderfix")
	self.LightControl.Model = self:GetModel()
	self.LightControl:SetPos(self:GetPos())
	self.LightControl:SetAngles(self:GetAngles())
	self.LightControl:SetParent(self)
	self.LightControl:Spawn()
	self.LightControl:Activate()
end

function GM:OnEntityCreated( ent )
	if (ent:GetClass()=="prop_vehicle_jeep") then
		--ent:SpawnCarLightControl()
	end
end