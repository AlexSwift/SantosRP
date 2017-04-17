AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"

include"shared.lua"

function ENT:Initialize() 
	self:SetModel"models/props_junk/terracotta01.mdl"
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()

    self:SetTrigger(true)
end

function ENT:FinishGrowing()
	self:SetIsHarvestReady(true)

	self:SetWeedHarvest(self.weedAmount + math.random(1-self.weedAmountDeviation, 1+self.weedAmountDeviation))
	for i = 1, self:GetWeedHarvest() do
		local weed = ents.Create("santosrp_weed")
		weed:SetPos(self:GetPos() + Vector(0, 0, 40) +  VectorRand() * 15)
		weed:Spawn()
	end

	if IsValid(self:GetSeedling()) then self:GetSeedling():Remove() end
	self:Remove()
end

function ENT:Plant()
	local seed = ents.Create"prop_physics"
	seed:SetModel"models/medieval/seedling.mdl"
	seed:SetPos(self:GetPos() + Vector(0, 0, 10))
	seed:SetParent(self)
	seed:Spawn()

	self:SetSeedling(seed)
	self:SetStartedGrowing(CurTime())
	self:SetMyGrowingTime(self.growTime * math.random(1-self.growTimeDeviation, 1+self.growTimeDeviation))
	self:SetFinishedGrowing(self:GetStartedGrowing() + self:GetMyGrowingTime())

	local pot = self
	timer.Simple(self:GetMyGrowingTime(), function() 
		if not IsValid(pot) then return end
		pot:FinishGrowing() 
	end)

	self:SetIsPlanted(true)
end

function ENT:Touch(ent)
	if ent:GetClass() ~= "santosrp_weedseed" then return end
	if self:GetIsPlanted() then return end
	self:Plant()
	ent:Remove()
end