include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local Fragments = {
	{"models/props/cs_office/plant01_p2.mdl",230},
	{"models/props/cs_office/plant01_p3.mdl",180},
	{"models/props/cs_office/plant01_p4.mdl",90},
	{"models/props/cs_office/plant01_p5.mdl",60},
	{"models/props/cs_office/plant01_p6.mdl",-15},
	{"models/props/cs_office/plant01_p7.mdl",-40},
}

function ENT:Initialize()
	self.FragModel = ClientsideModel("models/props/cs_office/plant01_p2.mdl")
	self.FragModel:SetNoDraw(true)
end

function ENT:Think()

end

function ENT:Draw()
	--self:DrawModel()
	
	local Time = CurTime()*20
	local Cop = 3+math.cos(Time/20)/2
	local Pos = self:GetPos()
	local OrgAng = self:GetAngles()*1
	
	OrgAng:RotateAroundAxis(OrgAng:Up(),Time)
	
	for i = 1,6 do
		local Ang = OrgAng*1
		Ang:RotateAroundAxis(Ang:Up(),Fragments[i][2])
		
		self.FragModel:SetModel(Fragments[i][1])
		self.FragModel:SetRenderOrigin(Pos-Ang:Forward()*Cop)
		self.FragModel:SetRenderAngles(OrgAng)
		self.FragModel:SetupBones()
		self.FragModel:DrawModel()
		
	end
end
