local Logo = Material("gearfox/logo_watermark.png")

function GM:HUDPaint()
	DrawMaterialRect(ScrW()-254,ScrH()-130,256,128,MAIN_BLACKCOLOR,Logo)
	DrawMaterialRect(ScrW()-256,ScrH()-128,256,128,MAIN_WHITECOLOR,Logo)
	
	DrawHealthbar()
	DrawBatteryLife()
end

