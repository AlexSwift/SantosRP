local sw,sh = ScrW(),ScrH()

local CHP = 0

local x,y = 195,sh-150
local w,h = 140,65

function santosRP.HUD.DrawStamina()
	local HP,MHP = 100,100
	local C = math.Clamp(HP/MHP,0,1)
	CHP = CHP + (C-CHP)/32
	
	
	DrawSRPDiamond(x,y,w,h,MAIN_COLOR,MAIN_COLOR2)
	
	DrawText("Stamina","Trebuchet18",x+w/2,y+h/2-18,MAIN_TEXTCOLOR,1)
	DrawText(math.ceil(HP),"SRP_NumberFont20",x+w/2,y+h/2,MAIN_TEXTCOLOR,1)
end