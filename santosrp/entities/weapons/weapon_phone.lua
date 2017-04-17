
AddCSLuaFile()

SWEP.PrintName			= "SRP Phone"
SWEP.Author				= "The Maw"
SWEP.Purpose    		= "Do everything on this!"

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/c_pistol.mdl"

SWEP.ViewModelFOV		= 50

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
	self:SetHoldType( "normal" )
	
	if (CLIENT) then
	
		self.PhoneModel = ClientsideModel("models/lt_c/tech/cellphone.mdl")
		self.PhoneModel:SetNoDraw(true)
		self.PhoneModel:SetSkin(1)
		
		self.Selected = 1
		
		self.Apps = GetApps()
	end
end

function SWEP:PrimaryAttack()
	if (SERVER) then return end
	if (!IsFirstTimePredicted() or !self.Apps) then return end
	
	if (self.Opened) then
		if (self.Opened.DoPrimaryFire) then
			self.Opened.DoPrimaryFire(self)
		end
	else
		self.Opened = self.Apps[self.Selected+1]
	end
end

function SWEP:SecondaryAttack()
	if (SERVER) then return end
	if (!IsFirstTimePredicted() or !self.Apps) then return end
	
	if (self.Opened) then self.Opened = nil return end
	
	self.Selected = (self.Selected+1)%#self.Apps
end

function SWEP:OnRemove()
	self:ResetBones()
	if ( SERVER ) then return end
	if (IsValid(self.PhoneModel)) then self.PhoneModel:Remove() end
end

function SWEP:Holster()
	self:ResetBones()
	return true
end

function SWEP:Deploy()

	print( 'test' )

	self:DeployBones()
	return true
end

local ZeroAng = Angle(0,0,0)

function SWEP:ResetBones()
	local pl = self.Owner
	if (!IsValid(pl)) then return end
	
	local ID  = pl:LookupBone("ValveBiped.Bip01_R_UpperArm")
	local ID2 = pl:LookupBone("ValveBiped.Bip01_R_Forearm")
	
	if (!ID or !ID2) then return end
	
	pl:ManipulateBoneAngles( ID, ZeroAng )
	pl:ManipulateBoneAngles( ID2, ZeroAng )
end

function SWEP:DeployBones()
	local pl = self.Owner
	if (!IsValid(pl)) then return end
	
	local ID  = pl:LookupBone("ValveBiped.Bip01_R_UpperArm")
	local ID2 = pl:LookupBone("ValveBiped.Bip01_R_Forearm")
	
	pl:ManipulateBoneAngles( ID, Angle(20,-50,0) )
	pl:ManipulateBoneAngles( ID2, Angle(-30,0,0) )
end

local OffPos = Vector(4,-3,-2.5)
local OffAng = Angle(110,0,0)

local x,y,w,h = -100,-195,200,375
local iw = 50
local ih = iw

function SWEP:PostDrawViewModel( vm,pl,wep)

	vm:SetMaterial(nil)
	
	if (!self.Apps) then self.Apps = GetApps() end
	if (!IsValid(self.PhoneModel)) then return end
	
	local ID  = vm:LookupBone("ValveBiped.Bip01_R_Hand")
		
	if (!ID) then return end
	
	local Pos,Ang 	= vm:GetBonePosition(ID)
	
	local Rop = OffPos*1
	local Roa = Ang*1
	
	Roa:RotateAroundAxis(Roa:Right(),OffAng.p)
	Roa:RotateAroundAxis(Roa:Up(),OffAng.y)
	Roa:RotateAroundAxis(Roa:Forward(),OffAng.r)
	
	Rop:Rotate(Ang)
	
	self.PhoneModel:SetRenderOrigin(Pos+Rop)
	self.PhoneModel:SetRenderAngles(Roa)
	self.PhoneModel:SetupBones()
	self.PhoneModel:DrawModel()
	
	
	Roa:RotateAroundAxis(Roa:Up(),90)
	
	cam.Start3D2D(Pos+Rop+Roa:Up()*0.5,Roa,0.013)
		DrawRect(x,y,w,h,MAIN_BLACKCOLOR)
		
		if (!self.Opened) then
			local DayTime 	= math.ceil(GetTimeOfDay())
			local Time 		= string.FormattedTime( DayTime, "%02i:%02i" )
			
			for k,v in pairs(self.Apps) do
				k = k-1
				local Ix = x+5+iw*(k-math.floor(k/4)*4)
				local Iy = y+60+ih*math.floor(k/4)
				
				if (self.Selected == k) then
					DrawRect(Ix,Iy,iw-4,ih-4,MAIN_WHITECOLOR)
			
					DrawText(v.Name,"SRP_Font32",x+w/2,y+h-30,MAIN_WHITECOLOR,1)
				end
				
				DrawMaterialRect(Ix,Iy,iw-4,ih-4,MAIN_WHITECOLOR,v.Icon)
			end
		
			DrawText(Time,"SRP_Font64",x+w/2,y+30,MAIN_WHITECOLOR,1)
		elseif (self.Opened.Draw) then
			self.Opened:Draw(x,y,w,h)
		end
	cam.End3D2D()
end


function SWEP:DrawWorldModel()

	local pl = self.Owner
	
	if (!IsValid(pl)) then return end --K.. you never know when it fucks up
	
	local ID = pl:LookupBone("ValveBiped.Bip01_R_Hand")
	
	if (!ID) then return end
	
	if (!IsValid(self.PhoneModel)) then
		self.PhoneModel = ClientsideModel("models/lt_c/tech/cellphone.mdl")
		self.PhoneModel:SetNoDraw(true)
	end
	
	local Pos,Ang 	= pl:GetBonePosition(ID)
	
	local Rop = OffPos*1
	local Roa = Ang*1
	
	Roa:RotateAroundAxis(Roa:Right(),OffAng.p)
	Roa:RotateAroundAxis(Roa:Up(),OffAng.y)
	Roa:RotateAroundAxis(Roa:Forward(),OffAng.r)
	
	Rop:Rotate(Ang)
	
	self.PhoneModel:SetRenderOrigin(Pos+Rop)
	self.PhoneModel:SetRenderAngles(Roa)
	self.PhoneModel:SetupBones()
	self.PhoneModel:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
end

function SWEP:RenderScreen()
	if (self.Opened and self.Opened.PreDraw) then self.Opened:PreDraw(x,y,w,h) end
end

function SWEP:PreDrawViewModel( vm,pl,wep)
	vm:SetMaterial( "engine/occlusionproxy" )
end