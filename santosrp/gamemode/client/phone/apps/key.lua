
APPS.Name = "Car Locker"
APPS.Icon = Material("santosrp/hud/appicons/key.png","smooth")





local BGCol  = Color(140,140,140,100)
local BGCol2 = Color(40,140,40,100)


function APPS:Draw(x,y,w,h) 
	if (LocalPlayer().CarLocked) then
		DrawRect(x,y,w,h,BGCol2)
		DrawText("Locked","SRP_Font32",x+w/2,y+h/2,MAIN_WHITECOLOR,1)
	else
		DrawRect(x,y,w,h,BGCol)
		DrawText("Unlocked","SRP_Font32",x+w/2,y+h/2,MAIN_WHITECOLOR,1)
	end
	
	DrawBottomGradient(x,y,w,h,MAIN_BLACKCOLOR)
	DrawText("Car Locker","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
	DrawText("Press Mouse1 to","SRP_Font20",x+w/2,y+60,MAIN_WHITECOLOR,1)
	DrawText("toggle lock","SRP_Font20",x+w/2,y+80,MAIN_WHITECOLOR,1)
end


function APPS:DoPrimaryFire(wep) 
	RequestLockVehicle()
end

	