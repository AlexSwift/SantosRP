include('shared.lua')

local Mat = Material("models/debug/debugwhite")

function ENT:Initialize()
end

function ENT:Think()
	local Pump = self:GetOwner()
	
	if (IsValid(Pump) and !IsValid(Pump.Hose)) then Pump.Hose = self end
end

function ENT:Draw()
	self:DrawModel()
	
	local Pump = self:GetOwner()
	
	if (!IsValid(Pump)) then return end
	
	
	Pump.Hose = self
	
	local Pos,Ang = self:GetPos(),self:GetAngles()
	local Pos2,Ang2 = Pump:GetPos(),Pump:GetAngles()
	
	local CurvePos1 = Pos2+Pump:GetUp()*42+Pump:GetRight()*15+Pump:GetForward()*-6
	local CurveAng1 = Pump:GetRight():Angle()
	
	local CurvePos2 = Pos+self:GetForward()*10
	local CurveAng2 = Ang
	
	self:SetRenderBoundsWS(Pos,Pos2)
	

	local Curve = nil
	
	if (EyePos():Distance(self:GetPos()) > MAIN_VIEWDISTANCE) then	
		Curve = BezierCurve(CurvePos1,CurveAng1,CurvePos2,CurveAng2,30,3)
	else
		Curve = BezierCurve(CurvePos1,CurveAng1,CurvePos2,CurveAng2,30,16)
	end
	
	render.SetMaterial(Mat)
	CurveToMesh(Curve,4,6)
end