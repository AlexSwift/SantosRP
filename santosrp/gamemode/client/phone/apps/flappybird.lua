
APPS.Name = "Flappy Birds"
APPS.Icon = Material("santosrp/hud/appicons/flappybird.png","noclamp smooth")



local BGCol = Color(0,140,150,100)




function APPS:Draw(x,y,w,h) 
	DrawRect(x,y,w,h,BGCol)
	DrawBottomGradient(x,y,w,h,MAIN_BLACKCOLOR)
	DrawText("Flappy Birds","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
end

	