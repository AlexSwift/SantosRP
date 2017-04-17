local sw,sh = ScrW(),ScrH()

local CHP = 0
local x,y = 195,sh-85
local w,h = 140,65

function santosRP.HUD.DrawHunger()

	local HP,MHP = LocalPlayer():GetHunger(),100
	local C = math.Clamp(HP/MHP,0,1)
	CHP = CHP + (C-CHP)/32
	
	
	DrawSRPDiamond(x,y,w,h,MAIN_COLOR,MAIN_COLOR2)
	
	DrawText("Hunger","Trebuchet18",x+w/2,y+h/2-18,MAIN_TEXTCOLOR,1)
	DrawText(math.ceil(HP),"SRP_NumberFont20",x+w/2,y+h/2,MAIN_TEXTCOLOR,1)
end