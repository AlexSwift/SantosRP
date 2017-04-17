AddCSLuaFile()

SWEP.PrintName = "Battering Ram"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "SantosRP"
SWEP.Instructions = "Click to open doors"

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_rpg.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)

	local trac = self.Owner:GetEyeTrace()

	if not IsValid(trac.Entity) then return end
	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 then return end

	self:SetHoldType("pistol")

	if CLIENT then return end

	if not trac.Entity:IsDoor() then return end

	trac.Entity:UnLock()

	self:EmitSound(self.Sound)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Think()
end

function SWEP:DrawHUD()
end
