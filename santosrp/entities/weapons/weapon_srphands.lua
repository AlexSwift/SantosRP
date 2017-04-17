
AddCSLuaFile()

SWEP.PrintName			= "SRP Hands"
SWEP.Author				= "The Maw"
SWEP.Purpose    		= "Nothing"

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	
	self.Time = 0
	self.Range = 150
end

function SWEP:Think()
	if (self.Drag and (!self.Owner:KeyDown(IN_ATTACK) or !IsValid(self.Drag.Entity))) then
		self.Drag = nil
	end
end

function SWEP:PrimaryAttack()
	local Pos = self.Owner:GetShootPos()
	local Aim = self.Owner:GetAimVector()
	
	local Tr = util.TraceLine({
		start = Pos,
		endpos = Pos+Aim*self.Range,
		filter = player.GetAll(),
	})
	
	local HitEnt = Tr.Entity
	
	if (self.Drag) then 
		HitEnt = self.Drag.Entity
	else
		if (!IsValid(HitEnt) or HitEnt:GetMoveType() != MOVETYPE_VPHYSICS or HitEnt:IsVehicle()) then return end
		
		if (!self.Drag) then
			self.Drag = {
				OffPos = HitEnt:WorldToLocal(Tr.HitPos),
				Entity = HitEnt,
				Fraction = Tr.Fraction,
			}
		end
	end
	
	if (CLIENT or !IsValid(HitEnt)) then return end
	
	local Phys = HitEnt:GetPhysicsObject()
		
	if (IsValid(Phys)) then
		local Pos2 		= Pos + Aim*self.Range*self.Drag.Fraction
		local OffPos 	= HitEnt:LocalToWorld(self.Drag.OffPos)
		local Dif 		= Pos2-OffPos
		local Nom 		= (Dif:GetNormal()*math.min(1,Dif:Length()/100)*500-Phys:GetVelocity())*Phys:GetMass()
		
		Phys:ApplyForceOffset(Nom,OffPos)
		Phys:AddAngleVelocity(-Phys:GetAngleVelocity()/4)
	end
end

function SWEP:SecondaryAttack()
end

if (CLIENT) then
	local x,y = ScrW()/2,ScrH()/2

	local Col = table.Copy(MAIN_WHITECOLOR)

	function SWEP:DrawHUD()
		if (IsValid(self.Owner:GetVehicle())) then return end
		local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()
		
		local Tr = util.TraceLine({
			start = Pos,
			endpos = Pos+Aim*self.Range,
			filter = player.GetAll(),
		})
		
		local HitEnt = Tr.Entity
		
		if (IsValid(HitEnt) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and !self.Drag and !HitEnt:IsVehicle()) then
			self.Time = math.min(1,self.Time+2*FrameTime())
		else
			self.Time = math.max(0,self.Time-2*FrameTime())
		end
		
		if (self.Time > 0) then	
			Col.a = MAIN_WHITECOLOR.a*self.Time
			
			DrawText("Drag","SRP_Font32",x,y,Col,1)
		end
		
		if (self.Drag and IsValid(self.Drag.Entity)) then
			local Pos2 		= Pos + Aim*100*self.Drag.Fraction
			local OffPos 	= self.Drag.Entity:LocalToWorld(self.Drag.OffPos)
			local Dif 		= Pos2-OffPos
			
			local A = OffPos:ToScreen()
			local B = Pos2:ToScreen()
			
			
			DrawRect(A.x-2,A.y-2,4,4,MAIN_WHITECOLOR)
			DrawRect(B.x-2,B.y-2,4,4,MAIN_WHITECOLOR)
			
			DrawLine(A.x,A.y,B.x,B.y,MAIN_WHITECOLORT)
		end
	end
end

function SWEP:PreDrawViewModel( vm,pl,wep)
	return true
end
