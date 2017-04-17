AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"

include"shared.lua"

function ENT:Initialize() 
	self:SetModel"models/pg_props/pg_obj/pg_fish.mdl" --TODO: find better model
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()
    self:SetColor(Color(139, 69, 19))

    self:SetTrigger(true)
end