AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"

include"shared.lua"

function ENT:Initialize() 
	self:SetModel"models/medieval/seedling.mdl" --TODO: find better model
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()

    self:SetTrigger(true)
end