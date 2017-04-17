


if (SERVER) then
	util.AddNetworkString("OpenShop")
	
	
else
	local Shop = nil
	
	local sw,sh = ScrW(),ScrH()
	
	local w,h = 500,400
	local x,y = sw/2-w/2,sh/2-h/2
	
	local function PopulateList(NPC)
		if (!Shop) then return end
		
		Shop.List:Clear()
		
		for k,v in pairs(santosRP.Items.GetEntityShopList(NPC)) do
			local a = Shop.List:Add("SRPItemFrame")
			a:SetItem(v:GetData().Name)
			a:SetTall(120)
			
			a:SetButtonText( "Buy" )
			a:SetButtonDoClick( function(s)
				santosRP.Items.RequestBuyEntity(v:GetData().Name)
			end)
		end
	end
	
	
	net.Receive("OpenShop",function()
		local Ent = net.ReadEntity()
		
		if (!IsValid(Ent)) then return end
		
		local Class = Ent:GetClass():gsub("santosrp_npc_","")
		
		local Ab = string.sub(Class,1,1):upper()
		Class = Ab..string.sub(Class,2,Class:len())
		
		if (!Shop) then
			Shop = vgui.Create("SRPFrame")
			Shop:SetPos(sw,y)
			Shop:SetSize(w,h)
			Shop:SetTitle("")
			Shop:MakePopup()
			Shop.Text = Class
			Shop:ShowCloseButton( false )
			
			Shop.Exit = vgui.Create("SRPButton",Shop)
			Shop.Exit:SetPos(w-90,5)
			Shop.Exit:SetSize(80,20)
			Shop.Exit:SetText("Close")
			Shop.Exit.DoClick = function(s)
				Shop:Stop()
				Shop:MoveTo(sw,y,0.4,0,-1,function(anim,panel) panel:SetVisible(false) end)
			end
				
			Shop.Pane = vgui.Create("DScrollPanel",Shop)
			Shop.Pane:SetPos(0,30)
			Shop.Pane:SetSize(w,h-35)
			Shop.Pane.Paint = function(s,w,h) end
			
			Shop.Pane.VBar.Paint = function(s,w,h) end
			Shop.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Shop.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Shop.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			
			Shop.List = vgui.Create("DListLayout",Shop.Pane)
			Shop.List:SetSize(Shop.Pane:GetWide()-10,Shop.Pane:GetTall()-10)
			Shop.List:SetPos(5,5)
			
		end
		
		PopulateList(Ent)
		
		Shop.Text = Class
		
		Shop:Stop()
		Shop:SetVisible(true)
		Shop:MoveTo(x,y,0.4,0,-1,function(anim,panel) end)
	end)
end
	