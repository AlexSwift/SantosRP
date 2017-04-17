


if (SERVER) then
	util.AddNetworkString("OpenShopVehicle")
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
	local ShopList = santosRP.Vehicles.GetCarList()
	
	local function PopulateList()
		if (!Shop) then return end
		
		ShopList = table.SortByPrice(ShopList)
		
		for k,v in pairs(ShopList) do
		
			if v:GetBlocked() then continue end
		
			local a = Shop.List:Add("DPanel")
			a:SetText("")
			a:SetTall(109)
			a.Paint = function(s,W,ph)
				local H = 79
				
				DrawRect(H,0,W-H,H-20,MAIN_COLOR2)
				
				if LocalPlayer().Vehicles and LocalPlayer().Vehicles[ v:GetName() ] then
					DrawSRPBox(0,0,H,H,MAIN_COLOR2,Color( 21, 200, 21 ))
				else
					DrawSRPBox(0,0,H,H,MAIN_COLOR2,MAIN_COLOR)
				end
				
				if LocalPlayer():GetBankMoney() >= v:GetPrice() then
					DrawMaterialRectRotated(H+20,H-10,50,100,MAIN_WHITECOLOR,Tag,90)
					DrawText( "$"..Comma(v:GetPrice()), "Trebuchet18", H+25,H-10, MAIN_TOTALBLACKCOLOR,1)				
				else 
					DrawMaterialRectRotated(H+20,H-10,50,100,Color(220,0,0,255),Tag,90)
					DrawText( "$"..Comma(v:GetPrice()), "Trebuchet18", H+25,H-10, MAIN_WHITECOLOR,1)
				end
				
				DrawText(v:GetName(),"Trebuchet24",78,5,MAIN_TEXTCOLOR)
				DrawText(v:GetDescription(),"Trebuchet18",78,25,MAIN_TEXTCOLOR)
			end
			
			local b = vgui.Create("SpawnIcon",a)
			b:SetPos(5,5)
			b:SetSize(64,64)
			b:SetModel(v:GetModel())
			
			local c = vgui.Create("SRPButton",a)
			c:SetPos(w/2-125,65)
			c:SetSize(90,20)
			c:SetText("Select")
			c.DoClick = function(s)
				Shop.Selected = {v:GetName(),v}
				
				Shop.ModelPane:SetModel(Shop.Selected[2]:GetModel())
				Shop.ModelPane:SetVisible(true)
			end
		end
		
	end
	
	
	net.Receive("OpenShopVehicle",function()
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
					
				DrawText("Vehicles - Bank: $"..Comma(LocalPlayer():GetBankMoney()),"Trebuchet24",8,5,MAIN_TEXTCOLOR)
				
				
				if (Shop.Selected) then
					local Bab = Shop.Selected[2]
					local X,Y = w/2,30
					
					DrawText("Max speed: "..Bab:GetMaxSpeed().." KM/H","Trebuchet24",X,Y,MAIN_TEXTCOLOR)
					DrawText("Fuel tank: "..Bab:GetFuelTank().." L","Trebuchet24",X,Y+20,MAIN_TEXTCOLOR)
					DrawText("Fuel consumption: "..Bab:GetFuelConsumption().." KM/L","Trebuchet24",X,Y+40,MAIN_TEXTCOLOR)
					
					if not Shop.Selected then
						Shop.b:SetText('')
					elseif not LocalPlayer().Vehicles then
						Shop.b:SetText("Purchase")
					elseif not LocalPlayer().Vehicles[Shop.Selected[2]:GetName()] then
						Shop.b:SetText("Purchase")
					else
						Shop.b:SetText("Spawn")
					end
					
					if LocalPlayer().Vehicles and LocalPlayer().Vehicles[ Shop.Selected[1] ] and Shop.b:GetText() ~= 'Spawn' then
						Shop.b:SetText( 'Spawn' )
					end
					
					--Frod! you need to use an or here, cus not all of the data from carlist contains this variable. :(
					--DrawText("Passenger Seats: " .. (Bab.PassengerSeats or 0),"Trebuchet24",X,Y+60,MAIN_TEXTCOLOR) 
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
				
				
			--Car Customizer
			Shop.ModelPane = vgui.Create("DModelPanel",Shop)
			Shop.ModelPane:SetPos(w/2,30)
			Shop.ModelPane:SetSize(w/2-10,h-140)
			Shop.ModelPane:SetModel("models/error.mdl")
			Shop.ModelPane:SetLookAt(Zero)
			Shop.ModelPane:SetVisible(false)
			Shop.ModelPane:SetCamPos(CamPos)
			
			Shop.Mixer = vgui.Create( "DColorMixer", Shop )
			Shop.Mixer:SetPos(w/2,h-100)
			Shop.Mixer:SetSize(w/2-100,90)
			Shop.Mixer:SetPalette( false )  		--Show/hide the palette			DEF:true
			Shop.Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
			Shop.Mixer:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
			Shop.Mixer:SetColor( MAIN_WHITECOLOR )	--Set the default color
			Shop.Mixer.ValueChanged = function(s,Col)
				Shop.ModelPane:SetColor(Col)
			end
				
			Shop.b = vgui.Create("SRPButton",Shop)
			Shop.b:SetPos(w-90,h-100)
			Shop.b:SetSize(80,90)
			Shop.b:SetText('')
			Shop.b.DoClick = function(s)
				if (!Shop.Selected) then return end
				
				if LocalPlayer().Vehicles and LocalPlayer().Vehicles[Shop.Selected[2]:GetName()] then
				
					santosRP.Vehicles.RequestSpawnVehicle(Shop.Selected[1], Shop.Mixer:GetColor())
					
				else
				
					santosRP.Vehicles.RequestBuyVehicle( Shop.Selected[1] )
					
				end
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
	