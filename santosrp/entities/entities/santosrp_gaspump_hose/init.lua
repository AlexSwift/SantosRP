
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_lab/tpplug.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self.Phys = self:GetPhysicsObject()
	self.Phys:Sleep()
	
	self:SetPersistent(true)
	self.LastTouch = CurTime()
	
	self:NextThink(CurTime()+1)
end

function ENT:Think()
	local Owner = self:GetOwner()
	if (!IsValid(Owner)) then self:Remove() end
	
	local Hold = self:IsPlayerHolding()
	local Parent = self:GetParent()
	
	if (!Hold and !self.Phys:IsAsleep()) then	
		self.Phys:Sleep()
		self.Phys:EnableMotion(false)
		
		if (!IsValid(Parent)) then
			local HosePos,HoseAng = Owner:GetHoseSlot()
			
			self:SetPos(HosePos)
			self:SetAngles(HoseAng)
			
			self:SetParent(Owner)
		end
	end
	
	self:NextThink(CurTime()+0.1)
	return true
end

function ENT:StartTouch(ent)
	if (ent:IsVehicle() and self:IsPlayerHolding() and !self.Phys:IsAsleep() and self.LastTouch < CurTime()) then
		self.Phys:Sleep()
		self.Phys:EnableMotion(false)
		
		self:SetAngles((self:GetPos()-ent:GetPos()):Angle())
		
		self:SetParent(ent)
		
		
		if (IsValid(ent.Hose) and ent.Hose != self) then 
			local Ab = ent.Hose:GetOwner()
			local HosePos,HoseAng = Ab:GetHoseSlot()
			
			ent.Hose:SetPos(HosePos)
			ent.Hose:SetAngles(HoseAng)
			
			ent.Hose:SetParent(Ab)
		end
		
		ent.Hose = self
	end
end

function ENT:Use(user)
	if ( self:IsPlayerHolding() ) then return end
	
	self.LastTouch = CurTime()+1
	self:SetParent(nil)
	self.Phys:EnableMotion(true)
	self.Phys:Wake()
	
	user:PickupObject( self )
end