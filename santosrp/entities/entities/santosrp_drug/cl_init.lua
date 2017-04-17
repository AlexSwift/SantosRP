include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	math.randomseed(self:EntIndex())
	
	self.Color = Color(math.random(0,255),math.random(0,255),math.random(0,255))
	self:SetColor(self.Color)
	
	self.Emitter = ParticleEmitter(self:GetPos())
	
	self.CD = CurTime()
end

function ENT:Think()
	if (self.CD > CurTime()) then return end
	
	local p = self.Emitter:Add( "particle/particle_smokegrenade", self:GetPos()+VectorRand()*5)
	p:SetColor(self.Color.r,self.Color.g,self.Color.b)
	p:SetVelocity( VectorRand() )
	p:SetDieTime( 1 )
	p:SetStartAlpha( 0 )
	p:SetEndAlpha( 250 )
	p:SetStartSize(10)
	p:SetEndSize(0)
	p:SetRoll(math.random(0,360))
	p:SetRollDelta(math.Rand(-0.4,0.4))
	
	self.CD = CurTime()+0.1
end

function ENT:Draw()
	self:DrawModel()
end
