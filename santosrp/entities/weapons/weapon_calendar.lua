
AddCSLuaFile()

SWEP.PrintName			= "SRP Calendar"
SWEP.Author				= "The Maw"
SWEP.Purpose    		= "Check for date"

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= ""

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
end
function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
	if ( SERVER ) then return end
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	return true
end


local OffPos = Vector(6.6,-12,-7)
local OffAng = Angle(30,90,-90)

local w,h = 800,600
local rH  = 80
local W,H = w/7,(h-rH)/5

local Cross 	= Material("santosrp/hud/cross.png","smooth")

function SWEP:PostDrawViewModel( vm,pl,wep)

	vm:SetMaterial(nil)
	
	local ID  = vm:LookupBone("ValveBiped.Bip01_R_Hand")
		
	if (!ID) then return end
	
	local Pos,Ang 	= vm:GetBonePosition(ID)
	local TrueTime 	= GetTimeOfExistance()
	local Calendar 	= ConvertToCalendar(TrueTime)
	
	local Rop = OffPos*1
	local Roa = Ang*1
	
	Roa:RotateAroundAxis(Roa:Right(),OffAng.p)
	Roa:RotateAroundAxis(Roa:Up(),OffAng.y)
	Roa:RotateAroundAxis(Roa:Forward(),OffAng.r)
	
	Rop:Rotate(Ang)
	
	cam.Start3D2D(Pos+Rop,Roa,0.013)
		DrawRect(0,0,w,h,MAIN_WHITECOLOR)
		DrawRect(0,0,w,rH,MAIN_REDCOLOR)
		
		DrawText(Calendar[3],"SRP_Font64",w/2,rH/2,MAIN_BLACKCOLOR,1)
		
		local Page1 = math.floor(TrueTime/3024000)*3024000
		local Day 	= tonumber(Calendar[2])
		local Month = tonumber(Calendar[4])
		
		local A = 0
		
		for i = 0,4 do
			local y = rH+H*i
			DrawLine(0,y,w,y,MAIN_BLACKCOLOR)
			
			for b = 0,6 do
				local DayTime 	= Page1+86400*A
				local Cal 		= ConvertToCalendar(DayTime)
				local x 		= W*b
				
				DrawLine(x,rH,x,h,MAIN_BLACKCOLOR)
				
				if (Cal[3] == Calendar[3]) then
					local Col = MAIN_BLACKCOLOR
					if (Calendar[2] == Cal[2]) then Col = MAIN_REDCOLOR end
					
					DrawText(Cal[2],"SRP_Font64",x+5,y,Col)
					DrawText(Cal[1],"SRP_Font20",x+5,y+50,Col)
					
					if (Day > tonumber(Cal[2])) then
						DrawMaterialRect(x,y,W,H,MAIN_REDCOLOR,Cross)
					end
				else
					DrawText(Cal[2],"SRP_Font64",x+5,y,MAIN_GREYCOLOR)
					DrawText(Cal[1],"SRP_Font20",x+5,y+50,MAIN_GREYCOLOR)
				end
				
				A = A+1
			end
		end
	cam.End3D2D()
end


function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

function SWEP:PreDrawViewModel( vm,pl,wep)

	vm:SetMaterial( "engine/occlusionproxy" )
	
end

