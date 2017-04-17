
AddCSLuaFile()

SWEP.PrintName			= "SRP ID"
SWEP.Author				= "The Maw"
SWEP.Purpose    		= "ID Card"

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"

SWEP.ViewModelFOV		= 54

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.RenderGroup = RENDERGROUP_BOTH

function SWEP:Initialize()
	self:SetHoldType( "camera" )
	
	if ( SERVER ) then return end
	
	self:InitializeSpawnIcon()
end

if (CLIENT) then
	function SWEP:InitializeSpawnIcon()
		self.SpawnIcon = vgui.Create( "SpawnIcon" ) 
		self.SpawnIcon:SetPos(70,140)
		self.SpawnIcon:SetSize(128,128)
		self.SpawnIcon:SetPaintedManually( true )
		self.SpawnIcon:SetModel( "models/error.mdl" )
	end
end

function SWEP:PrimaryAttack()

	-- Unlock Vehicles and Property main door
	
	local ent = self.Owner:GetEyeTrace().Entity
	if self.Owner.Car == ent and SERVER then
		self.Owner:ToggleLockCar()
		--TODO: Play sound for feedback of smth being unlocked/locked
	end
	
	if not SERVER then return end
	if not ent:IsDoor() then return end
	if not ent:Lock() then return end
	--TODO: Play sound for feedback of smth being locked
end

function SWEP:SecondaryAttack()

	-- Lock Vehicles And Property main door
	
	local ent = self.Owner:GetEyeTrace().Entity
	if self.Owner.Car == ent and SERVER then
		self.Owner:ToggleLockCar()
		--TODO: Play sound for feedback of smth being unlocked/locked
	end

	if not SERVER then return end
	if not ent:IsDoor() then return end
	if not ent:UnLock() then return end
	--TODO: Play sound for feedback of smth being unlocked
end

function SWEP:OnRemove()
	if ( SERVER ) then return end
	if (!IsValid(self.Owner)) then return end
	
	local vm = self.Owner:GetViewModel()
	
	if (IsValid(vm)) then
		local BoneID = vm:LookupBone("ValveBiped.Bip01_R_Clavicle")
		if (BoneID) then vm:ManipulateBonePosition( BoneID, Vector(0,0,0) ) end
	end
	
	self.SpawnIcon:Remove()
end

function SWEP:Holster()

	if (CLIENT) then
		local vm = self.Owner:GetViewModel()
		
		if (IsValid(vm)) then
			local BoneID = vm:LookupBone("ValveBiped.Bip01_R_Clavicle")
			if (BoneID) then vm:ManipulateBonePosition( BoneID, Vector(0,0,0) ) end
		end
	end
	
	return true
end

function SWEP:Deploy()
	if (CLIENT) then
		local vm = self.Owner:GetViewModel()
		
		if (IsValid(vm)) then
			local BoneID = vm:LookupBone("ValveBiped.Bip01_R_Clavicle")
			if (BoneID) then vm:ManipulateBonePosition( BoneID, Vector(0,50,0) ) end
		end
	end
	
	return true
end






local Card = Material("santosrp/hud/idcard.png","alphatest nocull")
local OffPos = Vector(27,0,0)
local OffAng = Angle(0,-90,80)

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
	
	if (!IsValid(self.SpawnIcon)) then self:InitializeSpawnIcon() end
	
	self.SpawnIcon:SetModel( pl:GetModel() )
	
	cam.Start3D2D(Pos+Rop,Roa,0.0125)
		DrawMaterialRect(0,0,512,512,MAIN_WHITECOLOR,Card)
		
		self.SpawnIcon:SetPaintedManually( false )
		self.SpawnIcon:PaintManual()
		self.SpawnIcon:SetPaintedManually( true )
		
		--Info
		DrawText(pl:GetRPName(),"SRP_Font20",320,185,MAIN_BLACKCOLOR)
		DrawText(pl:GetJob(),"SRP_Font20",320,235,MAIN_BLACKCOLOR)
		DrawText("Los Santos City","SRP_Font20",320,255,MAIN_BLACKCOLOR)
		DrawText(string.Explode(":",pl:SteamID())[3],"SRP_Font20",320,275,MAIN_BLACKCOLOR)
	cam.End3D2D()
end


local WOffPos = Vector(4,0,-4.7)
local WOffAng = Angle(0,-60,-90)

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
	
	if (!IsValid(self.SpawnIcon)) then self:InitializeSpawnIcon() end
	
	self.SpawnIcon:SetModel( pl:GetModel() )
	
	cam.Start3D2D(Pos+Rop,Roa,0.0125)
		DrawMaterialRect(0,0,512,512,MAIN_WHITECOLOR,Card)
		
		
		self.SpawnIcon:SetPaintedManually( false )
		self.SpawnIcon:PaintManual()
		self.SpawnIcon:SetPaintedManually( true )
		
		--Info
		DrawText(pl:GetRPName(),"SRP_Font20",320,185,MAIN_BLACKCOLOR)
		DrawText(pl:GetJob(),"SRP_Font20",320,235,MAIN_BLACKCOLOR)
		DrawText("Los Santos City","SRP_Font20",320,255,MAIN_BLACKCOLOR)
		DrawText(string.Explode(":",pl:SteamID())[3],"SRP_Font20",320,275,MAIN_BLACKCOLOR)
	cam.End3D2D()
end

function SWEP:PreDrawViewModel( vm,pl,wep)
	vm:SetMaterial( "engine/occlusionproxy" )
end
