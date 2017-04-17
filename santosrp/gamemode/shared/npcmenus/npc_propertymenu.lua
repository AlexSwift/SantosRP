


if (SERVER) then
	util.AddNetworkString("OpenShopProperty")
else
	local Shop = nil
	
	local Grad 	= Material("gui/gradient_down")
	local Tag 	= Material("santosrp/hud/pricetag.png","smooth")
	
	local sw,sh = ScrW(),ScrH()
	
	local Zero		= Vector(0,0,30)
	local CamPos 	= Vector(200,0,100)

	local w,h = 800,500
	local x,y = sw/2-w/2,sh/2-h/2
	
	local Comma	   = string.Comma
	local ShopList = santosRP.Property.GetPropertyTable()
	
	local function PopulateList()
		if (!Shop) then return end
		
		--ShopList = table.SortByPrice(ShopList)
		
		for k,v in pairs(ShopList) do
		
			local a = Shop.List:Add("DPanel")
			a:SetText("")
			a:SetTall(109)
			a.Paint = function(s,W,ph)
				local H = 79
				
				DrawRect(H,0,W-H,H-20,MAIN_COLOR2)
				DrawSRPBox(0,0,H,H,MAIN_COLOR2,MAIN_COLOR)
				
				if LocalPlayer():GetBankMoney() >= v:GetPrice() then
					DrawMaterialRectRotated(H+20,H-10,50,100,MAIN_WHITECOLOR,Tag,90)
					DrawText( "$"..Comma(v:GetPrice()), "Trebuchet18", H+25,H-10, MAIN_TOTALBLACKCOLOR,1)				
				else 
					DrawMaterialRectRotated(H+20,H-10,50,100,Color(220,0,0,255),Tag,90)
					DrawText( "$"..Comma(v:GetPrice()), "Trebuchet18", H+25,H-10, MAIN_WHITECOLOR,1)
				end
				
				DrawText(v:GetName(),"Trebuchet24",78,5,MAIN_TEXTCOLOR)
				DrawText("$"..Comma(v:GetPrice()),"Trebuchet18",78,25,MAIN_TEXTCOLOR)
			end
			
			local b = vgui.Create("SpawnIcon",a)
			b:SetPos(5,5)
			b:SetSize(64,64)
			b:SetModel('models/error.mdl')
			b.Paint = function()
				DrawMaterialRect(5,5,64,64,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
			end
			
			local c = vgui.Create("SRPButton",a)
			c:SetPos(w/2-125,65)
			c:SetSize(90,20)
			c:SetText("Select")
			c.DoClick = function(s)
				Shop.Selected = {v:GetName(),v}
				
				DrawMaterialRect(w/2,30,w/2-100,90,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
				DrawMaterialRect(w/2,h-100,w/2-100,90,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
			end
		end
		
	end
	
	
	net.Receive("OpenShopProperty",function()
		if (!Shop) then
			Shop = vgui.Create("DFrame")
			Shop:SetPos(sw,y)
			Shop:SetSize(w,h)
			Shop:SetTitle("")
			Shop:MakePopup()
			Shop:SetDraggable( false )
			Shop:ShowCloseButton( false )
			Shop.Selected = nil
			Shop.Paint = function(s,w,h)
				DrawRect(0,0,w,h,MAIN_COLOR)
				DrawMaterialRect(0,30,w,h-32,MAIN_BLACKCOLOR,Grad)
				
				DrawRect(0,0,w,30,MAIN_COLOR2)
				DrawOutlinedRect(0,0,w,h,MAIN_COLOR)
				
				local a = MAIN_COLOR.a*1
				MAIN_COLOR.a = 255
				DrawSRPDiamond(-50,-30,w*0.8,60,MAIN_COLOR,MAIN_COLOR2)
				MAIN_COLOR.a = a
					
				DrawText("Properties - Bank: $"..Comma(LocalPlayer():GetBankMoney()),"Trebuchet24",8,5,MAIN_TEXTCOLOR)
				
				
				
				if (Shop.Selected) then
					local Bab = Shop.Selected[2]
					local X,Y = w/2,30
					
					DrawText("Name: "..Bab:GetName(),"Trebuchet24",X,Y,MAIN_TEXTCOLOR)
					DrawText("Price: "..Bab:GetPrice(),"Trebuchet24",X,Y+20,MAIN_TEXTCOLOR)
					--DrawText("Fuel consumption: "..Bab:GetFuelConsumption().." KM/L","Trebuchet24",X,Y+40,MAIN_TEXTCOLOR)
					
					Shop.b:SetText("Purchase")
					
					
					DrawMaterialRect(w/2 - 50 ,70	,w/2-10,290,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
					DrawMaterialRect(w/2 - 50 ,h-100,w/2-100,90,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
					
				else
				
					DrawMaterialRect(w/2,30,w/2-100,90,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
					DrawMaterialRect(w/2,h-100,w/2-100,90,MAIN_WHITECOLOR,Material("santosrp/hud/logo.png"))
					
				end
			end
			
			Shop.Exit = vgui.Create("SRPButton",Shop)
			Shop.Exit:SetPos(w-90,10)
			Shop.Exit:SetSize(80,20)
			Shop.Exit:SetText("Close")
			Shop.Exit.DoClick = function(s)
				Shop:Stop()
				Shop:MoveTo(sw,y,0.4,0,-1,function(anim,panel) panel:SetVisible(false) end)
			end
			
			--place holder for actual picture of house
				
			Shop.b = vgui.Create("SRPButton",Shop)
			Shop.b:SetPos(w-90,h-100)
			Shop.b:SetSize(80,90)
			Shop.b:SetText('')
			Shop.b.DoClick = function(s)
				if (!Shop.Selected) then return end
				
				Shop:Stop()
				Shop:MoveTo(sw,y,0.4,0,-1,function(anim,panel) panel:SetVisible(false) end)
			end
				
			--Carlist Pane
			Shop.Pane = vgui.Create("DScrollPanel",Shop)
			Shop.Pane:SetPos(5,30)
			Shop.Pane:SetSize(w/2-10,h-40)
			Shop.Pane.Paint = function(s,w,h) end
			
			Shop.Pane.VBar.Paint = function(s,w,h) end
			Shop.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Shop.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Shop.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			
			Shop.List = vgui.Create("DListLayout",Shop.Pane)
			Shop.List:SetSize(Shop.Pane:GetWide()-10,Shop.Pane:GetTall()-10)
			Shop.List:SetPos(5,5)
			
			PopulateList()
		end
		
		Shop:Stop()
		Shop:SetVisible(true)
		Shop:MoveTo(x,y,0.4,0,-1,function(anim,panel) end)
	end)
end
	