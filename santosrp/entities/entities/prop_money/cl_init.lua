include('shared.lua')

local Up = Vector(0,0,10)

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.CD = CurTime()
end

function ENT:Think()
	if (self.CD > CurTime()) then return end
	
	local p = self.Emitter:Add( "santosrp/effects/dollar", self:GetPos()+VectorRand()*5)
	p:SetColor(255,255,255)
	p:SetVelocity( VectorRand()*5+Up )
	p:SetDieTime( 1 )
	p:SetStartAlpha( 250 )
	p:SetEndAlpha( 0 )
	p:SetStartSize( 5 )
	p:SetEndSize( 2 )
	
	self.CD = CurTime()+0.2
end

function ENT:Draw()
	self.Entity:DrawModel()
end