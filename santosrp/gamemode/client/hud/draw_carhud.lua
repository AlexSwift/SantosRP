
local x,y = ScrW()/2-100,ScrH()-140
local w,h = 200,90

local Ix,Iy = x+w/2,y-80
local Ioff = 200

local r 	= w/2+10
local r2 	= r+80

local rOff  = 30

local rad = math.rad
local cos = math.cos
local sin = math.sin

local ceil = math.ceil

local Indicator = Material("gui/arrow")



local Fx,Fy = Ix+260,y+40
local Fw,Fh = 130,70

local Fr 	= 70
local Fr2 	= Fr+50
local FrOff = 20



--OriginalSizeOfEverything
local O_r 		= r*1
local O_r2 		= r2*1
local O_Fr 		= Fr*1
local O_Fr2 	= Fr2*1
local O_w 		= w*1
local O_h 		= h*1

local O_x,O_y 	= x*1,y*1
local O_Ix,O_Iy = Ix*1,Iy*1
local O_Fx,O_Fy = Fx*1,Fy*1
local O_Fw,O_Fh = Fw*1,Fh*1

local O_rOff  	= rOff*1
local O_FrOff 	= FrOff*1

concommand.Add("srp_uiscale_carhud",function(pl,com,arg)
	local scale = tonumber(arg[1])
	if (!scale) then return end
	ScaleCarHUD(scale)
end)

hook.Add("Initialize","InitCarHudSettings",function()
	ScaleCarHUD(0.85)
end)

function ScaleCarHUD(Scale)
	r 		= O_r*Scale
	r2 		= O_r2*Scale
	Fr 		= O_Fr*Scale
	Fr2 	= O_Fr2*Scale
	w 		= O_w*Scale
	h 		= O_h*Scale
	x,y 	= ScrW()/2-100*Scale,ScrH()-140*Scale
	Ix,Iy 	= x+w/2,y-80*Scale
	Fx,Fy 	= Ix+260*Scale,y+40*Scale
	rOff  	= O_rOff*Scale
	FrOff 	= O_FrOff*Scale
	Fw,Fh 	= O_Fw*Scale,O_Fh*Scale
end

function DrawCarHUD()
	local lp = LocalPlayer()
	local Vehicle = lp:GetVehicle()
	
	if (!IsValid(Vehicle)) then return end
	
	--Speedometer
	local Vel 		= ConvertUnitsToKM(Vehicle:GetVelocity():Length()*60*60)
	local MaxSpeed 	= 200
	local C 		= math.Clamp(Vel/MaxSpeed,0,1)
	
	DrawSRPDiamond(x,y,w,h,MAIN_COLOR,MAIN_COLOR2)
	
	local X,Y = x+w/2,y+h/2+20
	
	DrawSRPCircle(X,Y,r,r2,-20,200,32,MAIN_COLOR,MAIN_COLOR2)
	DrawSRPCircle(X,Y,r+4,r+20,-20,200,32,MAIN_COLOR2)
	DrawSRPCircle(X,Y,r+4,r+14,200-220*C,200,32,MAIN_WHITECOLOR)
	
	for i = 0,10 do
		local R = rad(160+i*22)
		local r3 = (r2-rOff)
		
		local oX2 = cos(R)*r2
		local oY2 = sin(R)*r2
		
		local oX = cos(R)*r3
		local oY = sin(R)*r3
		
		DrawLine(X+oX,Y+oY,X+oX2,Y+oY2,MAIN_COLOR)
		DrawText(i*20,"SRP_NumberFont10",X+oX,Y+oY,MAIN_WHITECOLOR,1)
	end
	
	DrawText(math.floor(Vel),"SRP_NumberFont30",x+w/2,y+h/2,MAIN_WHITECOLOR,1)
	DrawText("km/h","Trebuchet18",x+w-40,y+h/2,MAIN_WHITECOLOR,1)
	
	
	--Indicators
	DrawSRPDiamond(Ix-Ioff-50,Iy-20,100,40,MAIN_COLOR,MAIN_COLOR2)
	DrawSRPDiamond(Ix+Ioff-50,Iy-20,100,40,MAIN_COLOR,MAIN_COLOR2)
		
	DrawMaterialRectRotated(Ix-Ioff,Iy,32,32,MAIN_BLACKCOLOR,Indicator,90)
	DrawMaterialRectRotated(Ix+Ioff,Iy,32,32,MAIN_BLACKCOLOR,Indicator,-90)
	if (Vehicle:TurningLeft() or Vehicle:Hazards()) and Vehicle:BlinkOn() then
		DrawMaterialRectRotated(Ix-Ioff*1,Iy,32,32,MAIN_YELLOWCOLOR,Indicator,90)
	end
	if (Vehicle:TurningRight() or Vehicle:Hazards()) and Vehicle:BlinkOn()  then
		DrawMaterialRectRotated(Ix-Ioff*-1,Iy,32,32,MAIN_YELLOWCOLOR,Indicator,-90)
	end
	
	
	--Fuel
	local Fuel 		= Vehicle:GetFuel()
	local MaxFuel 	= Vehicle:GetMaxFuel()
	local C 		= math.Clamp(Fuel/MaxFuel,0,1)
	
	DrawSRPDiamond(Fx,Fy,Fw,Fh,MAIN_COLOR,MAIN_COLOR2)
	
	local X,Y = Fx+Fw/2,Fy+Fh/2+10
	
	local FromAng,ToAng = -20,200
	local AngDif = ToAng-FromAng
	
	DrawSRPCircle(X,Y,Fr,Fr2,FromAng,ToAng,32,MAIN_COLOR,MAIN_COLOR2)
	DrawSRPCircle(X,Y,Fr+4,Fr+10,FromAng,ToAng,32,MAIN_COLOR2)
	DrawSRPCircle(X,Y,Fr+4,Fr+6,ToAng-AngDif*C,ToAng,32,MAIN_WHITECOLOR)
	
	DrawText(math.floor(Fuel),"SRP_NumberFont20",Fx+Fw/2,Fy+Fh/2,MAIN_WHITECOLOR,1)
	DrawText("lt","Trebuchet18",Fx+Fw-30,Fy+Fh/2,MAIN_WHITECOLOR,1)
	
	local Mx = MaxFuel/6
	local Ma = AngDif/6
	
	for i = 0,6 do
		local R = rad(160+i*Ma)
		local Fr3 = (Fr2-FrOff)
		
		local oX2 = cos(R)*Fr2
		local oY2 = sin(R)*Fr2
		
		local oX = cos(R)*Fr3
		local oY = sin(R)*Fr3
		
		DrawLine(X+oX,Y+oY,X+oX2,Y+oY2,MAIN_COLOR)
		DrawText(ceil(i*Mx),"SRP_NumberFont10",X+oX,Y+oY,MAIN_WHITECOLOR,1)
	end
end