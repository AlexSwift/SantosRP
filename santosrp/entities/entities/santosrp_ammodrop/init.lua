
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( self.Model or "models/props_junk/watermelon01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	
	if (IsValid(phys)) then
		phys:Sleep()
		phys:EnableMotion(false)
	end
	
	self.DeleteTimer = CurTime()+60
end

function ENT:SetItem(Dat)
	self.Item = Dat
	
	if (self.Item and self.Item.AmmoClass and self.Item.AmmoNum) then
		self:SetModel( self.Item.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysWake()
	else
		self:Remove()
	end
end

function ENT:Use(user)
	if (IsValid(user) and self.Item) then
		user:GiveAmmo(self.Item.AmmoNum,self.Item.AmmoClass) 
		self:Remove()
	end
end

function ENT:Think()
	if (self.DeleteTimer < CurTime()) then self:Remove() end
end


