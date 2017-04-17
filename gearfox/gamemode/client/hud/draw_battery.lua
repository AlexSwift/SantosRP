local X = ScrW()-104

function DrawBatteryLife()
	local W = system.BatteryPower()
	if (W > 100) then return end
	
	DrawRect(X,4,100,12,MAIN_BLACKCOLOR)
	DrawRect(X,4,math.Clamp(W,0,100),12,MAIN_GREENCOLOR)
	DrawText("Battery: "..W.."%","Trebuchet18",X-5,2,MAIN_TEXTCOLOR,2)
end