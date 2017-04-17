
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_junk/garbage_bag001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
	self:SetPersistent(true)
	
	self:SetHealth(100)
	self.Time = CurTime()+60
end

function ENT:Think()
	if (self.Time < CurTime()) then self:Remove() end
end

function ENT:Use(user)
	if (user:IsPlayer() and user:CommitDrug(self:EntIndex())) then
		self:Remove()
	end
end