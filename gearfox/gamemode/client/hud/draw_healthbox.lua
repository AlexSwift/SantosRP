function DrawHealthbar()
	local HP = LocalPlayer():Health()
	
	DrawText( HP, "MBDefaultFontSuperLarge", 112, ScrH()-102, MAIN_BLACKCOLOR )
	DrawText( HP, "MBDefaultFontSuperLarge", 110, ScrH()-100, MAIN_WHITECOLOR )
end