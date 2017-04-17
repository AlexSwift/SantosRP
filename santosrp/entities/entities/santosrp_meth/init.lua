AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"

include"shared.lua"

function ENT:Initialize() 
	self:SetModel"models/props_c17/doll01.mdl" --TODO: find better model
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()

    self:SetTrigger(true)
end