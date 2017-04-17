include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.Mob = ClientsideModel("models/props/pi_fern.mdl")
	self.Mob:SetNoDraw(true)
end

function ENT:Think()
end

function ENT:Draw()
	if (!self.GetTimeStarted or !IsValid(self.Mob)) then return end
	
	local Time 	= CurTime()
	local Start = self:GetTimeStarted()
	
	local Growth = math.Clamp((Time-Start)/60,0,1)
	
	local Ang = self:GetAngles()
	local Pos = self:GetPos()
	local Up  = self:GetUp()
	
	self:DrawModel()
	
	local Scale = 1/10
	
	for i = 1,7 do
		Ang:RotateAroundAxis(Up,40)
		
		self.Mob:SetRenderOrigin(Pos+Up*Growth*i*5)
		self.Mob:SetRenderAngles(Ang)
		self.Mob:SetModelScale(Growth - Scale*i*Growth,0)
		self.Mob:SetupBones()
		self.Mob:DrawModel()
	end
end
