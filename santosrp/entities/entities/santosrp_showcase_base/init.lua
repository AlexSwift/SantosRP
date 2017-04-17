
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )



function ENT:Initialize()
	self:SetModel( self.Model or "models/tdmcars/bug_veyronss.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	
	if (IsValid(phys)) then
		phys:Sleep()
		phys:EnableMotion(false)
	end

	self:SetMoveType( MOVETYPE_NONE )
end

function ENT:Use(user)
end

function ENT:Think()
	if (self.Rotate) then 
	end
end


