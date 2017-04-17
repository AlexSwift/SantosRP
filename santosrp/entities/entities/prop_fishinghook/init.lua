
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

local Up = Vector(0,0,1)

local FishTable = {
	"models/props/cs_militia/fishriver01.mdl",
	"models/props/de_inferno/goldfish.mdl"
}

function ENT:Initialize()
	self:SetModel( "models/props_junk/meathook001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	self.Phys = self:GetPhysicsObject()
	
	self.Phys:SetMaterial("ice")
	self.Phys:SetMass(10)
	self.Phys:SetDamping( 1.5, 4 )
end

function ENT:Think()
	local Ab = self:WaterLevel()
	if (Ab < 1) then 
		self:NextThink(CurTime()+1)
		return true 
	end

	if (!self.HookedFish) then
		local Fish = GetRandomFish()
		
		if (Fish) then
			self:SetFish(Fish.Model)
			self:EmitSound("npc/antlion/attack_double"..math.random(1,3)..".wav")
			
			self.Phys:SetVelocity(Up*2000)
			
			self.HookedFish = Fish
			
			self:NextThink(CurTime()+math.Rand(1,2))
			return true
		end
	else
		self:EmitSound("npc/antlion/attack_double"..math.random(1,3)..".wav")
		self.Phys:SetVelocity(VectorRand()*1000*self.HookedFish.Resistance)
		
		self:NextThink(CurTime()+math.Rand(1,2))
		return true
	end
	
	self:NextThink(CurTime()+5)
	return true
end

function ENT:Use(user)
end