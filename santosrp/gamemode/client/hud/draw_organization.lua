
local sw,sh = ScrW(),ScrH()
local w,h = 500,600
local x,y = sw/2-w/2,sh/2-h/2
local Menu


function UpdateOrganizationList()
	if (!Menu) then return end
	
	Menu.List:Clear()
	
	for k,v in pairs(GetOrganizations()) do
		local a = Menu.List:Add("DPanel")
		a:SetText("")
		a:SetTall(120)
		a.Paint = function(s,W,H)
			DrawSRPBox(0,0,W,H,MAIN_COLOR2,v.Color)
			DrawText(v.Name,"Trebuchet24",W/2,H/2,MAIN_WHITECOLOR,1)
			DrawText("Num in server: "..v.NumPlayers,"Trebuchet18",20,H/2+24,MAIN_TEXTCOLOR)
		end
	end
end

function GM:ShowTeam()
	if (!Menu) then
		Menu = vgui.Create("SRPFrame")
		Menu:SetPos(x,y)
		Menu:SetSize(w,h)
		Menu:SetTitle("50")
		Menu:SetVisible(false)
		Menu:ShowCloseButton(true)
		Menu:MakePopup()
		Menu.Text = "Organization"
		
		local Sheet = vgui.Create("DPropertySheet",Menu)
		Sheet:SetPos(10,30)
		Sheet:SetSize(w-20,h-30)
		Sheet.Paint = function()
		end
		
		--Org list
		Menu.Pane = vgui.Create("DScrollPanel",Sheet)
		Menu.Pane:SetPos(0,30)
		Menu.Pane:SetSize(w,h-35)
		Menu.Pane.Paint = function(s,w,h) end
		
		Sheet:AddSheet("Org list",Menu.Pane,"icon16/group.png",false,false,"List of organizations")
		
		Menu.Pane.VBar.Paint = function(s,w,h) end
		Menu.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		Menu.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		Menu.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		
		Menu.List = vgui.Create("DListLayout",Menu.Pane)
		Menu.List:SetSize(w-40,h-40)
		Menu.List:SetPos(5,5)
		
		
		
		--Create Org
		local a = vgui.Create("DPanel")
		a:SetText("")
		a.Paint = function(s,W,H) end
		
		Sheet:AddSheet("Create Org",a,"icon16/group.png",false,false,"Create an organization")
		
		local N = vgui.Create("DTextEntry",a)
		N:SetPos(20,20)
		N:SetSize(150,20)
		N:SetText("My Organization")
		
		
		local P = vgui.Create("DTextEntry",a)
		P:SetPos(20,45)
		P:SetSize(150,20)
		P:SetText("My Password")
		
		local Mixer = vgui.Create( "DColorMixer", a )
		Mixer:SetPos(20,70)
		Mixer:SetSize(305,90)
		Mixer:SetPalette( false )  	
		Mixer:SetAlphaBar( false ) 		
		Mixer:SetWangs( true )	 	
		Mixer:SetColor( MAIN_WHITECOLOR )
		
		local C = vgui.Create("SRPButton",a)
		C:SetPos(20,165)
		C:SetSize(150,40)
		C:SetText("Create Org")
		C.DoClick = function()
			RequestCreateOrganization(N:GetValue(),P:GetValue(),Mixer:GetColor())
		end
	end
	
	Menu:SetVisible(true)
end