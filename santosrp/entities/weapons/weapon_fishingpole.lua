
AddCSLuaFile()

SWEP.PrintName			= "SRP Fishing Pole"
SWEP.Author				= "The Maw"
SWEP.Purpose    		= "Fish"

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.ViewModelFOV		= 60

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.RenderGroup = RENDERGROUP_BOTH


function SWEP:Initialize()
	self:SetHoldType( "revolver" )
	
	if (CLIENT) then
		self.Pole = ClientsideModel("models/props_junk/harpoon002a.mdl")
		self.Pole:SetNoDraw(true)
		self.Pole:SetModelScale(0.5,0)
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "FishingBob" )
end

local ZeroA = Angle(0,0,0)
local Zero  = Vector(0,0,0)
local Up    = Vector(0,0,1)

function SWEP:PrimaryAttack()
	if (CLIENT) then return end
	
	local pl = self.Owner
	
	if (!IsValid(pl)) then return end
	
	if (!IsValid(self.Bulp)) then 
		local Aim = pl:GetAimVector()
		
		self.Bulp = ents.Create("prop_fishinghook")
		self.Bulp:SetPos(pl:GetShootPos()+Aim*10)
		self.Bulp:Spawn()
		self.Bulp:Activate()
		
		self:SetFishingBob(self.Bulp)
		
		if (self.Sound) then self.Sound:Stop() end
		
		self.Sound = CreateSound(self.Owner,"FishingThrow")
		self.Sound:Play()
		
		self.Length = 2000
		
		local a,b = constraint.Elastic( 
			self.Owner, self.Bulp,  
			0, 0,  -- Bones
			Up*50, Zero, -- Vector pos  (rod, hook)
			self.Length, 1,1, -- Constant, damping, rdamping
			"cable/cable", --Material
			0, -- Width 
			true) -- stretchonly
			
		self.Rope = a
		self.Rope:Fire("SetSpringLength", self.Length)
		
		self.BulpSpawn = true
	end
end

function SWEP:Think()
	if (IsValid(self.Bulp) and IsValid(self.Owner)) then
		if (self.BulpSpawn) then 
			self.Bulp.Phys:SetVelocity((self.Owner:GetAimVector()*2+Up/2)*5000)
			self.Bulp.Phys:Wake()
			
			self.BulpSpawn = false
		else
			if (self.Bulp:GetVelocity():Length() < 10 and self.Sound) then 
				self.Sound:FadeOut(1)
			end
		end
			
		if (self.Sound2 and self.ReelCD < CurTime()-0.1) then 
			self.Sound2:Stop()
			self.Sound2 = nil
		end
	elseif (self.Sound2) then 
		self.Sound2:Stop()
		self.Sound2 = nil
	end
end

function SWEP:SecondaryAttack()
	if (CLIENT or !IsValid(self.Rope) or !IsValid(self.Bulp)) then return end
	if (self.ReelCD and self.ReelCD > CurTime()) then return end
	if (!IsValid(self.Owner)) then return end
	
	local Dis = self.Bulp:GetPos():Distance(self.Owner:GetPos())
	
	self.Length = math.max(0,Dis-10)
	self.Rope:Fire("SetSpringLength", self.Length)
	
	if (self.Length < 20) then 
		local Bob = self.Bulp.HookedFish
		
		if (Bob) then
			self.Owner:AddInventory({
				Name = Bob.Name,
				Quantity = 1,
				Class = "santosrp_prop_base",
				Model = Bob.Model,
			})
			self.Owner:EmitSound("weapons/bugbait/bugbait_squeeze"..math.random(1,3)..".wav")
		end
				
		self.Bulp:Remove() 
	end
	
	if (!self.Sound2) then
		self.Sound2 = CreateSound(self.Owner,"FishingReel")
		self.Sound2:Play()
	end
	
	self.ReelCD = CurTime()+0.1
end

function SWEP:OnRemove()
	if (IsValid(self.Bulp)) then self.Bulp:Remove() end
end

function SWEP:Holster()
	if (IsValid(self.Bulp)) then self.Bulp:Remove() end
	return true
end

function SWEP:Deploy()
	return true
end



local Mat = Material("models/debug/debugwhite")

local OffPos = Vector(20,-5,0)
local OffAng = Angle(90,90,20)

local UpAng = Vector(0,0,1):Angle()

function SWEP:PostDrawViewModel( vm,pl,wep)
	vm:SetMaterial(nil)
	
	local Ang = vm:GetAngles()
	local Pos = vm:GetPos()
	
	local Rop = OffPos*1
	local Roa = Ang*1
	
	Roa:RotateAroundAxis(Ang:Right(),OffAng.p)
	Roa:RotateAroundAxis(Ang:Forward(),OffAng.r)
	Roa:RotateAroundAxis(Ang:Up(),OffAng.y)
	
	Rop:Rotate(Ang)
	
	
	self.Pole:SetRenderOrigin(Pos+Rop)
	self.Pole:SetRenderAngles(Roa)
	self.Pole:DrawModel()
	
	local Bob = self:GetFishingBob() 
	
	if (IsValid(Bob)) then
		local Upp = Bob:GetUp()
		local BobPos = Bob:GetPos()+Upp*20-Bob:GetRight()*4
		local Curve = BezierCurve(BobPos,Upp:Angle(),self.Pole:GetPos()+Roa:Forward()*30,-UpAng,20,16)
	
		render.SetMaterial(Mat)
		
		cam.Start3D(EyePos(),EyeAngles())
			CurveToMesh(Curve,1,4)
		cam.End3D()
	end
end




local WOffPos = Vector(3,0,-20)
local WOffAng = Angle(-90,0,0)

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
	local pl = self.Owner
	
	if (!IsValid(pl)) then return end
	
	local ID 		= pl:LookupBone("ValveBiped.Bip01_R_Hand")
	
	if (!ID) then return end
	
	local Pos,Ang 	= pl:GetBonePosition(ID)
	
	local Rop = WOffPos*1
	local Roa = Ang*1
	
	Roa:RotateAroundAxis(Ang:Right(),WOffAng.p)
	Roa:RotateAroundAxis(Ang:Forward(),WOffAng.r)
	Roa:RotateAroundAxis(Ang:Up(),WOffAng.y)
	
	Rop:Rotate(Ang)
	
	self.Pole:SetRenderOrigin(Pos+Rop)
	self.Pole:SetRenderAngles(Roa)
	self.Pole:DrawModel()
	
	local Bob = self:GetFishingBob() 
	
	if (IsValid(Bob)) then
		local Upp 		= Bob:GetUp()
		local BobPos 	= Bob:GetPos()+Upp*20-Bob:GetRight()*4
		local Pos2 		= self.Pole:GetPos()+Roa:Forward()*30
		
		self:SetRenderBoundsWS(BobPos,Pos2)
	
		local Curve = BezierCurve(BobPos,Upp:Angle(),Pos2,-UpAng,20,16)
	
		render.SetMaterial(Mat)
		
		cam.Start3D(EyePos(),EyeAngles())
			CurveToMesh(Curve,3,6)
		cam.End3D()
	end
end

function SWEP:PreDrawViewModel( vm,pl,wep)
	vm:SetMaterial( "engine/occlusionproxy" )
end
