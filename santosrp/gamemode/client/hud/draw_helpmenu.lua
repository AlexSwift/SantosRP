
local sw,sh = ScrW(),ScrH()
local w,h = 1200,700
local x,y = sw/2-w/2,sh/2-h/2
local Menu
local open = false

function GM:ShowHelp()
	if (!Menu) then
		Menu = vgui.Create("SRPFrame")
		Menu:SetPos(x,y)
		Menu:SetSize(w,h)
		Menu:SetTitle("50")
		Menu:SetVisible(false)
		Menu:ShowCloseButton(true)
		Menu:MakePopup()
		Menu.Text = "Information"
		
		local MO = vgui.Create("HTML",Menu)
		MO:SetPos(30,30)
		MO:SetSize(Menu:GetWide()-40,Menu:GetTall()-40)
		MO:OpenURL("http://santosrp.com/forums/index.php?/page/index.html")
		
		local Sheet = vgui.Create("DPropertySheet",Menu)
		Sheet:SetPos(10,80)
		Sheet:SetSize(w-20,h-90)
		Sheet.Paint = function()
		end
		
		open = true

	end
	
	if open then
		
		open = false
		Menu:SetVisible( false )
		
	else
	
		open = true
		Menu:SetVisible(true)
		
	end
	
end