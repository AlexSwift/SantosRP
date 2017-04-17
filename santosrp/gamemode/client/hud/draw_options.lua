
local sw,sh = ScrW(),ScrH()
local w,h = 500,600
local x,y = sw/2-w/2,sh/2-h/2
local Menu

function GM:ShowSpare1()
	if (!Menu) then
		Menu = vgui.Create("SRPFrame")
		Menu:SetPos(x,y)
		Menu:SetSize(w,h)
		Menu:SetTitle("Spare")
		Menu:SetVisible(false)
		Menu:ShowCloseButton(true)
		Menu:MakePopup()
		Menu.Text = "Options"
		
		--Toggle Expensive Light
		local BCheck = vgui.Create("SRPCheckBox",Menu)
		BCheck:SetPos(10,40)
		BCheck:SetChecked(MAIN_EXPENSIVE_CARLIGHT)
		BCheck.OnChange = function(s,bval)
			MAIN_EXPENSIVE_CARLIGHT = bval
		end
		
		local BCheck_Label = vgui.Create("DLabel",Menu)
		BCheck_Label:SetPos(30,40)
		BCheck_Label:SetText("Toggle Expensive Light")
		BCheck_Label:SizeToContents()
		
		
		
		--Toggle Movie Mode
		local BCheck2 = vgui.Create("SRPCheckBox",Menu)
		BCheck2:SetPos(10,60)
		BCheck2:SetChecked(MAIN_MOVIEMODE)
		BCheck2.OnChange = function(s,bval)
			MAIN_MOVIEMODE = bval
		end
		
		local BCheck2_Label = vgui.Create("DLabel",Menu)
		BCheck2_Label:SetPos(30,60)
		BCheck2_Label:SetText("Toggle Movie Mode")
		BCheck2_Label:SizeToContents()
		
		
		--Toggle Bobblehead
		local BCheck3 = vgui.Create("SRPCheckBox",Menu)
		BCheck3:SetPos(10,80)
		BCheck3:SetChecked(MAIN_BOBBLEHEAD)
		BCheck3.OnChange = function(s,bval)
			MAIN_BOBBLEHEAD = bval
		end
		
		local BCheck3_Label = vgui.Create("DLabel",Menu)
		BCheck3_Label:SetPos(30,80)
		BCheck3_Label:SetText("Toggle Bobblehead")
		BCheck3_Label:SizeToContents()
		
		
		
	end
	
	Menu:SetVisible(true)
end