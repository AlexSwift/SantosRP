
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )



function ENT:Initialize()
	self:SetModel( self.Model or "models/tdmcars/bug_veyronss.mdl" )
	self:SetUseType( SIMPLE_USE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetNotSolid( true )
	self:DrawShadow(false)
end

function ENT:Use(user)
end

function ENT:Think()
end


