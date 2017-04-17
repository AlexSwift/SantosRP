
APPS.Name = "Police CP"
APPS.Icon = Material("santosrp/hud/appicons/messenger.png","smooth")




local BGCol = Color(50,180,230,100)

function APPS:Draw(x,y,w,h) 
	DrawRect(x,y,w,h,BGCol)
	DrawBottomGradient(x,y,w,h,MAIN_BLACKCOLOR)
	DrawText("Police CP","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
end