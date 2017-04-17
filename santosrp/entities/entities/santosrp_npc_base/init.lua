
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

local Mins = Vector(-16,-16,0)
local Maxs = Vector(16,16,80)


function ENT:Initialize()
	self:SetModel( self.Model or SelectCharacter(self:EntIndex(),false) )
	self:PhysicsInitBox( Mins, Maxs ) 
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_OBB )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionBounds( Mins, Maxs ) 
	
	local phys = self:GetPhysicsObject()
	
	if (IsValid(phys)) then
		phys:Sleep()
		phys:EnableMotion(false)
	end
end

function ENT:Use(user)
	if (user:IsPlayer()) then
		user.TalkingNPC = self
		local job = self.Job or 'Citizen'
		user:SendLua("santosRP.Jobs.GetJob( '" .. job .. "'):OpenDialog()")
	end
end

function ENT:Think()
end


