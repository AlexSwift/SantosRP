
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_junk/watermelon01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
	
	self.Food = santosRP.Items.GetFood("Melon")
	self.RemoveTimer = CurTime()+60
end

function ENT:Think()
	if (self.RemoveTimer < CurTime()) then self:Remove() end
end

function ENT:SetFood(name)
	self.Food = santosRP.Items.GetFood(name)
	
	if (self.Food) then
		self:SetModel( self.Food.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysWake()
	else
		self:Remove()
	end
end

function ENT:Use(user)
	if (user:IsPlayer()) then
		local HP = user:Health()
		local Add = math.ceil(self.Food.FoodAmount/10)
		
		user:AddHunger(self.Food.FoodAmount)
		user:SetHealth(math.min(HP+Add,100))
		user:EmitSound("santosrp/eating.mp3")
		
		self:Remove()
	end
end