
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Hand Cuffs"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = ""
SWEP.Instructions = "Left Click: Restrain / Free"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/santosrp/handcuffs/handcuffs-1.mdl";
SWEP.WorldModel = ""; 

if CLIENT then
	function SWEP:GetViewModelPosition ( Pos, Ang )
		Ang:RotateAroundAxis(Ang:Forward(), 90);
		Pos = Pos + Ang:Forward() * 6;
		Pos = Pos + Ang:Right() * 2;
		
		return Pos, Ang;
	end 
end

function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()	
	if !self.Owner.Job == 'Police Officer' then self:Remove(); return end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	
	local EyeTrace = self.Owner:GetEyeTrace();
	
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")
	
	if CLIENT then return false; end
	
	local Distance = self.Owner:EyePos():Distance(EyeTrace.HitPos);
	if Distance > 75 then return false; end
	if !EyeTrace.Entity or !EyeTrace.Entity:IsValid() or !EyeTrace.Entity:IsPlayer() then return false; end
	
	if EyeTrace.Entity.Job ~= 'Citizen' then self.Owner:Notify('You cannot arrest government employees.'); return false; end
	
	if (EyeTrace.Entity.currentlyRestrained) then --Option to un-arrest
	
		self.Owner:Notify('You have released ' .. EyeTrace.Entity:GetRPName() .. '.')
		EyeTrace.Entity:Notify("You have been released.")
		
		return
	end
	
	self.Owner:Notify('You have restrained ' .. EyeTrace.Entity:GetRPName() .. '! Take him to the jail to finish the job!');
	EyeTrace.Entity:Notify('You have been restrained! Please cooperate with the officer or risk being banned.');
	
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack();
end