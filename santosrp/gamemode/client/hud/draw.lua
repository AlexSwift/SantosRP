santosRP.HUD = { }

local w,h = ScrW(),ScrH()

local BoxCol 		= table.Copy(MAIN_COLOR)
local InnerBoxCol 	= table.Copy(MAIN_COLOR2)

BoxCol.a 		= 255
InnerBoxCol.a 	= 255

function GM:HUDPaint()
	if (MAIN_MOVIEMODE or LocalPlayer().TakingPicture) then return end
	
	santosRP.HUD.DrawHealth()
	santosRP.HUD.DrawAmmo()
	santosRP.HUD.DrawHunger()
	santosRP.HUD.DrawStamina()
	
	surface.SetDrawColor(MAIN_COLOR2)

	draw.RoundedBoxEx(8, 525, -30, 200, 60, MAIN_COLOR2, false, false, true, true)
	draw.RoundedBoxEx(8, 275, -30, 200, 60, MAIN_COLOR2, false, false, true, true)
	draw.RoundedBoxEx(8, 25, -30, 200, 60, MAIN_COLOR2, false, false, true, true)
	
	DrawText("F1 - Info","SRP_Font20",125,14,MAIN_TEXTCOLOR,1)
	DrawText("F2 - Organization","SRP_Font20",375,14,MAIN_TEXTCOLOR,1)
	DrawText("F3 - Options","SRP_Font20",625,14,MAIN_TEXTCOLOR,1)
	
	DrawCarHUD()
end