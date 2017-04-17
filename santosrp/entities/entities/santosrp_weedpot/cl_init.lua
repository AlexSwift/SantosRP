include"shared.lua"

function ENT:Plant()
	self.isPlanted = true
end

function ENT:Draw()
	self:DrawModel()
	if not self:GetIsPlanted() then return end
	local scale = math.Clamp(((CurTime() - self:GetStartedGrowing()) / self:GetMyGrowingTime()) , 0, 1) * 5
	local mtrx = Matrix()
	mtrx:SetScale(Vector(1, 1, scale))

	self:GetSeedling():EnableMatrix("RenderMultiply", mtrx)
end