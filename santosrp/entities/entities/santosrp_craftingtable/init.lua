
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_manor/table_02.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

function ENT:Think()
end

function ENT:Use(user)
	if (user:IsPlayer()) then
		user.TalkingNPC = self
		net.Start("OpenCraftingMenu")
			net.WriteEntity(self)
		net.Send(user)
	end
end