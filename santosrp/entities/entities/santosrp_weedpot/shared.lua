ENT.Base = "base_entity"
 
ENT.PrintName		= "SantosRP weedpot"
ENT.Author			= "Lenny."
ENT.Contact			= "santosrp.com"
ENT.Instructions	= "mhm"

ENT.Spawnable = true --only for sanbox

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsPlanted") --is it planted
	self:NetworkVar("Bool", 1, "IsHarvestReady") --can we harvest
	self:NetworkVar("Float", 0, "StartedGrowing") --when did it start growing
	self:NetworkVar("Float", 1, "MyGrowingTime")
	self:NetworkVar("Float", 2, "FinishedGrowing") --when will we be able to harvest
	self:NetworkVar("Int", 0, "WeedHarvest") --how much do we harvest
	self:NetworkVar("Entity", 0, "Seedling")
end

ENT.growTime = 5 --how long does it take until you can harvest weed

ENT.growTimeDeviation = .1 --how much faster/slower can growing be in percent

ENT.weedAmount = 3 --how much weed to be earned from once harvest
ENT.weedAmountDeviation = .33 --how much more/less can be earned per harvest in percent