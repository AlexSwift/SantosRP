include('shared.lua')

function ENT:Initialize()
end

function ENT:Think()
end

local FuelColor = Color(140,100,30)
local FuelColor2 = Color(140,100,30,100)

function ENT:Draw()
	self:DrawModel()
	
	local Ang = self:GetAngles()
	local Pos = self:GetPos()+self:GetForward()*10+self:GetUp()*50
	
	Ang:RotateAroundAxis(Ang:Forward(),90)
	Ang:RotateAroundAxis(Ang:Right(),-90)
	
	cam.Start3D2D(Pos,Ang,0.15)
		DrawRect(-102,-50,204,160,MAIN_TOTALBLACKCOLOR)
		DrawSRPRect(-70,-20,140,30,MAIN_COLOR,MAIN_COLOR2)
		
		DrawText("Gas price per liter","Trebuchet18",0,-30,MAIN_TEXTCOLOR,1)
		DrawText("2$","Trebuchet18",0,-5,MAIN_TEXTCOLOR,1)
		
		if (self.Hose) then
			local Par = self.Hose:GetParent()
			
			if (IsValid(Par) and Par:IsVehicle()) then
				DrawSRPRect(-70,25,140,30,MAIN_GREENCOLOR,MAIN_COLOR2)
				DrawText("Connected","Trebuchet18",0,40,MAIN_GREENCOLOR,1)
				
				local Fuel,MaxFuel = Par:GetFuel(),Par:GetMaxFuel()
				local c = Fuel/MaxFuel
				
				DrawRect(-70,60,140,30,FuelColor2)
				DrawRect(-70,60,140*c,30,FuelColor)
				DrawText("Fuel","Trebuchet18",0,75,MAIN_TEXTCOLOR,1)
				
				
			else
				DrawSRPRect(-70,25,140,30,MAIN_REDCOLOR,MAIN_COLOR2)
				DrawText("Not in use","Trebuchet18",0,40,MAIN_REDCOLOR,1)
			end
		end
		
	cam.End3D2D()
end