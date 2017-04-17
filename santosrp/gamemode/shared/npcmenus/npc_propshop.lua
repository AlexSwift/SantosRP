


if (SERVER) then
	util.AddNetworkString("OpenPropShop")
else
	local Shop = nil
	
	local sw,sh = ScrW(),ScrH()
	
	local w,h = 600,400
	local x,y = sw/2-w/2,sh/2-h/2
	
	local function PopulateList()
		if (!Shop) then return end
		
		Shop.List:Clear()
		
		for k,v in pairs(GetModelCategoryList()) do
			for c,M in pairs( GetModelCategory(v) ) do
				local a = Shop.List:Add("SpawnIcon")
				a:SetSize(64,64)
				a:SetModel(M)
				a.DoClick = function(s)
					surface.PlaySound( "garrysmod/ui_click.wav" )
					
					--LocalPlayer():AddNote("Under heavy development. Coming soon....")
					santosRP.Items.RequestBuyEntity(M) 
				end
				a.Paint = function(s,w,h)
					DrawSRPBox(0,0,w,h,MAIN_COLOR2,MAIN_COLOR)
				end
			end
		end
	end
	
	
	net.Receive("OpenPropShop",function()
		if (!Shop) then
			Shop = vgui.Create("SRPFrame")
			Shop:SetPos(sw,y)
			Shop:SetSize(w,h)
			Shop:SetTitle("")
			Shop:MakePopup()
			Shop:ShowCloseButton( false )
			Shop.Text = "Prop Dealer"
			
			Shop.Exit = vgui.Create("SRPButton",Shop)
			Shop.Exit:SetPos(w-90,10)
			Shop.Exit:SetSize(80,20)
			Shop.Exit:SetText("Close")
			Shop.Exit.DoClick = function(s)
				Shop:Stop()
				Shop:MoveTo(sw,y,0.4,0,-1,function(anim,panel) panel:SetVisible(false) end)
			end
				
			
			Shop.Pane = vgui.Create("DScrollPanel",Shop)
			Shop.Pane:SetPos(5,30)
			Shop.Pane:SetSize(w-10,h-35)
			Shop.Pane.Paint = function(s,w,h) end
			
			Shop.Pane.VBar.Paint = function(s,w,h) end
			Shop.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Shop.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Shop.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			
			Shop.List = vgui.Create("DIconLayout",Shop.Pane)
			Shop.List:SetSize(Shop.Pane:GetWide()-10,Shop.Pane:GetTall()-10)
			Shop.List:SetPos(5,5)
			Shop.List:SetSpaceY(5)
			Shop.List:SetSpaceX(5)
			
			PopulateList()
		end
		
		Shop:Stop()
		Shop:SetVisible(true)
		Shop:MoveTo(x,y,0.4,0,-1,function(anim,panel) end)
	end)
end
	