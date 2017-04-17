ENT.Base = "base_entity"
 
ENT.PrintName		= "SantosRP Math stove"
ENT.Author			= "Lenny."
ENT.Contact			= "santosrp.com"
ENT.Instructions	= "mhm"

ENT.Spawnable = true --only for sanbox

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsCooking")
	self:NetworkVar("Bool", 1, "IsFinishedCooking")
	self:NetworkVar("Float", 0, "StartedCooking")
	self:NetworkVar("Float", 1, "MyCookingTime")
	self:NetworkVar("Float", 2, "FinishedCooking")
	self:NetworkVar("Int", 0, "MethAmount")
	self:NetworkVar("Entity", 0, "Methpan")
end

ENT.cookTime = 5 --how long does it take until you can harvest weed

ENT.cookTimeDeviation = .1 --how much faster/slower can growing be in percent

ENT.methAmount = 3 --how much weed to be earned from once harvest
ENT.methAmountDeviation = .33 --how much more/less can be earned per harvest in percent