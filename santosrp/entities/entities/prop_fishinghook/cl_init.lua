include('shared.lua')

function ENT:Initialize()
end


function ENT:Think()
	local Fish = GetFishByModel(self:GetFish())
	
	if (Fish) then
		self.FishModel = ClientsideModel(Fish.Model)
		
		if (IsValid(self.FishModel)) then
			self.FishModel:SetModelScale(Fish.Scale,0)
			self.FishModel:SetNoDraw(true)
		end
	end
end

function ENT:Draw()
	self.Entity:DrawModel()
	
	if (IsValid(self.FishModel)) then
		self.FishModel:SetRenderOrigin(self:GetPos())
		self.FishModel:SetRenderAngles(self:GetAngles())
		self.FishModel:DrawModel()
	end
end