AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"

include"shared.lua"

function ENT:Initialize() 
	self:SetModel"models/props_c17/metalPot002a.mdl"
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()

    self:SetTrigger(true)
end