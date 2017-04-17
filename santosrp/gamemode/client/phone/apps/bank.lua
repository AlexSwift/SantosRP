
APPS.Name = "Bank"
APPS.Icon = Material("santosrp/hud/appicons/messenger.png","smooth")




local BGCol = Color(50,180,230,100)

function APPS:Draw(x,y,w,h) 
	DrawRect(x,y,w,h,BGCol)
	DrawBottomGradient(x,y,w,h,MAIN_BLACKCOLOR)
	DrawText("Bank Account:","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
	DrawText("$".. CommaInteger( LocalPlayer():GetBankMoney() ),"SRP_Font32",x+w/2,y+70,MAIN_WHITECOLOR,1)
	DrawText("Cash on Hand:","SRP_Font32",x+w/2,y+110,MAIN_WHITECOLOR,1)
	DrawText("$".. CommaInteger( LocalPlayer():GetMoney() ),"SRP_Font32",x+w/2,y+140,MAIN_WHITECOLOR,1)
end