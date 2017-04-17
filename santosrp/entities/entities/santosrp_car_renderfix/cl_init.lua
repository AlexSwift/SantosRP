include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

function ENT:Think()
	local Par = self:GetParent()
	if (!IsValid(Par)) then return end
	
	TickVehicleSound(Par)
	MarkCarRenderable(Par)
end

function ENT:Draw()
end