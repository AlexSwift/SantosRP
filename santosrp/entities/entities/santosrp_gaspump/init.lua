
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/gaspump001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self:DrawShadow(false)
	
	local Phys = self:GetPhysicsObject()
	
	Phys:Sleep()
	Phys:EnableMotion(false)
	
	self.IsFilling = false
	self.FillCD = CurTime()
end

function ENT:GetHoseSlot()
	local Pos = self:LocalToWorld(Vector(0,-18,58))
	local Ang = (-self:GetUp()):Angle()
	
	return Pos,Ang
end

function ENT:RespawnHose()
	if (IsValid(self.Hose)) then self.Hose:Remove() end
	
	local Pos,Ang = self:GetHoseSlot()
	
	self.Hose = ents.Create("santosrp_gaspump_hose")
	self.Hose:SetPos(Pos)
	self.Hose:SetAngles(Ang)
	self.Hose:SetOwner(self)
	self.Hose:Spawn()
	self.Hose:Activate()
	self.Hose:SetParent(self)
end

function ENT:Think()
	if (!IsValid(self.Hose)) then self:RespawnHose() end
	
	local Par = self.Hose:GetParent()
	
	if (self.IsFilling) then
		if (IsValid(Par) and Par:IsVehicle() and Par:GetFuel() < Par:GetMaxFuel() and IsValid(self.FillingPayer) and self.FillingPayer:GetMoney() >= 2) then
			if (self.FillCD < CurTime()) then
				self.FillCD = CurTime()+0.3
				
				self.FillingPayer:AddMoney(-2)
				
				Par:EmitSound("ambient/water/water_spray1.wav",70,70)
				Par:AddFuel(1)
			end
		else
			self.IsFilling = false
			self.FillingPayer = false
		end
	end
			
			
			
	
	if (self.Hose:GetPos():Distance(self:GetPos()) > 400) then	
		local Pos,Ang = self:GetHoseSlot()
		self.Hose:SetParent(nil)
		self.Hose:SetPos(Pos)
		self.Hose:SetAngles(Ang)
	end
end

function ENT:Use(user)
	local Par = self.Hose:GetParent()
	
	if (IsValid(Par) and Par:IsVehicle() and Par:GetFuel() < Par:GetMaxFuel() and user:GetMoney() >= 2) then
		self.FillingPayer = user
		self.IsFilling = true
	end
end