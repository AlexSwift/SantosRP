include('shared.lua')

function ENT:Initialize()
	self:SetSequence(self:LookupSequence("idle_all_01"))
end

function ENT:Think()
	if (self:GetSequence() != self.Seq) then self:ResetSequence(self:LookupSequence("idle_all_01")) end
end

function ENT:Draw()
	self:DrawModel()
end