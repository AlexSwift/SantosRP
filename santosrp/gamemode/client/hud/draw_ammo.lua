local sw,sh = ScrW(),ScrH()

local x,y = sw-230,sh-120
local w,h = 200,70

function santosRP.HUD.DrawAmmo()
	local lp = LocalPlayer()
	
	local wep = lp:GetActiveWeapon()
	
	if (!IsValid(wep)) then return end

	local Ammo = lp:GetAmmoCount(wep:GetPrimaryAmmoType())
	local Clip = wep:Clip1()
	
	if (Clip >= 0) then
		DrawSRPDiamond(x,y,w,h,MAIN_COLOR,MAIN_COLOR2)
		DrawText("Ammo","Trebuchet18",x+w/2,y+15,MAIN_TEXTCOLOR,1)
		DrawText(Clip,"SRP_NumberFont20",x+w/2,y+35,MAIN_TEXTCOLOR,1)
		DrawText(Ammo,"SRP_NumberFont10",x+w/2,y+55,MAIN_TEXTCOLOR,1)
	end
end