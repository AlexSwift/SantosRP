
APPS.Name = "Caller"
APPS.Icon = Material("santosrp/hud/appicons/caller.png","smooth")



local BGCol = Color(0,140,150,100)




function APPS:Draw(x,y,w,h) 
	DrawRect(x,y,w,h,BGCol)
	DrawBottomGradient(x,y,w,h,MAIN_BLACKCOLOR)
	DrawText("Caller","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
	DrawText("Your number:","SRP_Font20",x+w/2,y+60,MAIN_WHITECOLOR,1)
	DrawText(LocalPlayer():GetPhonenumber(),"SRP_NumberFont20",x+w/2,y+90,MAIN_WHITECOLOR,1)
	
	local Count = 0
	for Y = 0,2 do
		local pY = y+150+52*Y
		
		for X = 0,2 do
			local pX = x+23+52*X
			Count = Count+1
			
			DrawRect(pX,pY,50,50,MAIN_COLOR2)
			DrawText(Count,"SRP_NumberFont20",pX+25,pY+25,MAIN_WHITECOLOR,1)
		end
	end
			
			
end

	