
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_junk/terracotta01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
	
	self:NextThink(CurTime()+1)
end

function ENT:Think()
	--if (!IsValid(self:GetPlayerOwner())) then self:Remove() end
	
	self:NextThink(CurTime()+1)
	return true
end

function ENT:Use(user)
end