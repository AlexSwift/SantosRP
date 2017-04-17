
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/pyroteknik/bill_100.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:PhysWake()
	
	self.Cash 		= 1
	
	self.RemoveTimer = CurTime()+60
end

function ENT:Think()
	if (self.RemoveTimer < CurTime()) then self:Remove() end
end

function ENT:SetCash(cash)
	self.Cash = cash
	
	if (cash >= 1000) then
		if (cash >= 1000000) then
			self:SetModel( "models/pyroteknik/money_sack_nobreak.mdl" )
		elseif (cash >= 100000) then
			self:SetModel( "models/gml/gold_bar_large.mdl" )
		elseif (cash >= 10000) then
			self:SetModel( "models/gml/gold_bar.mdl" )
		else
			self:SetModel( "models/pyroteknik/stack.mdl" )
		end
		
		self:PhysicsInit( SOLID_VPHYSICS )
	end
end

function ENT:StartTouch(ent)
	if (ent:GetClass()==self:GetClass() and ent:EntIndex() < self:EntIndex()) then
		ent.Cash = ent.Cash+self.Cash
		ent.RemoveTimer = CurTime()+60
		
		self:Remove() 
	end
end

function ENT:Use(user)
	if (user:IsPlayer()) then
		user:AddMoney(self.Cash)
		user:AddNote("You collected $"..self.Cash)
		
		self:Remove()
	end
end