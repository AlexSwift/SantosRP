AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"

include"shared.lua"

function ENT:Initialize() 
	self:SetModel"models/props_c17/furnitureStove001a.mdl"
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()

    self:SetTrigger(true)
end

function ENT:FinishCooking()
	self:SetIsFinishedCooking(true)

	self:SetMethAmount(self.methAmount + math.random(1-self.methAmountDeviation, 1+self.methAmountDeviation))
	for i = 1, self:GetMethAmount() do
		local meth = ents.Create("santosrp_meth")
		meth:SetPos(self:GetPos() + Vector(0, 0, 40) +  VectorRand() * 15)
		meth:Spawn()
	end

	if IsValid(self:GetMethpan()) then self:GetMethpan():Remove() end
	self:Remove()
end

function ENT:Cook()
	local methpan = ents.Create"prop_physics"
	methpan:SetModel"models/props_c17/metalPot002a.mdl"
	methpan:SetPos(self:GetPos() + Vector(0, 10, 22))
	methpan:SetParent(self)
	methpan:Spawn()

	self:SetMethpan(methpan)
	self:SetStartedCooking(CurTime())
	self:SetMyCookingTime(self.cookTime * math.random(1-self.cookTimeDeviation, 1+self.cookTimeDeviation))
	self:SetFinishedCooking(self:GetStartedCooking() + self:GetMyCookingTime())

	local stove = self
	timer.Simple(self:GetMyCookingTime(), function() 
		if not IsValid(stove) then return end
		stove:FinishCooking() 
	end)

	self:SetIsCooking(true)
end

function ENT:Touch(ent)
	if ent:GetClass() ~= "santosrp_methpan" then return end
	if self:GetIsCooking() then return end
	self:Cook()
	ent:Remove()
end