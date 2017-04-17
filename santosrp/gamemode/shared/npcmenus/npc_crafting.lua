


if (SERVER) then
	util.AddNetworkString("OpenCraftingMenu")
else
	local Craft = nil
	
	local CraftTable = NULL
	
	local Zero		= Vector(0,0,30)
	local CamPos 	= Vector(200,0,100)
	
	local TViewAng = Angle(90,0,0)
	local View	   = {}
	
	local List 		= {}
	
	local Mob = ClientsideModel("models/error.mdl")
	Mob:SetNoDraw(true)
	
	hook.Add("PostDrawTranslucentRenderables","DrawInventoryOnTable",function()
		if (!IsValid(CraftTable) or !IsValid(Craft)) then return end
		
		local lp 	= LocalPlayer()
		
		local Inv 	= lp:GetInventory()
		local Deg 	= 360/table.Count(Inv)
		
		local Pos 	= CraftTable:GetPos()+CraftTable:GetUp()*35
		local Ang 	= CraftTable:GetAngles()
		
		local C 	= Craft:GetAlpha()/255
		
		for k,v in pairs(Inv) do
			if (v.Model) then
				local Angs = CraftTable:LocalToWorldAngles(Angle(0,Deg*k,0))
				local RPos = Pos+Angs:Forward()*10*C
				
				Mob:SetModel(v.Model)
				local Rad = 2/Mob:GetModelRadius()
				Mob:SetModelScale(Rad*C,0)
				Mob:SetRenderOrigin(RPos)
				Mob:SetRenderAngles(Angs*2.5)
				Mob:SetupBones()
				Mob:DrawModel()
			end
		end
		
		if (Craft.Recipe) then
			local Pos 	= CraftTable:GetPos()+CraftTable:GetUp()*40
		
			local q = 0
			local Deg = 360/table.Count(Craft.Recipe)
			
			for k,v in pairs(Craft.Recipe) do
				local Item = santosRP.Items.GetItemDataFor(k)
				
				if (Item) then
					q = q+1
					local Angs 	= Angle(0,Deg*q,0)
					local RPos 	= Pos+Angs:Forward()*5*C
					local Count = lp:CountItem(k)
					local Deg2 	= 360/v
					
					Mob:SetModel(Item.Model)
					local Rad = 4/Mob:GetModelRadius()
					Mob:SetModelScale(Rad*C,0)
					
					for i = 1,v do
						local Angs2 = Angle(0,Deg2*i,0)
						local RPos2 = RPos+Angs2:Forward()*2*C
						
						Mob:SetRenderOrigin(RPos2)
						Mob:SetRenderAngles(Angs2)
						Mob:SetupBones()
						
						if (Count >= i) then
							render.SetColorModulation(0,1,0)
						else
							render.SetColorModulation(1,0,0)
						end
							
						Mob:DrawModel()
							
						render.SetColorModulation(1,1,1)
					end
				end
			end
		end
	end)
	
	function GetCraftingTab()
		return CraftTable
	end
	
	function GetCraftingView(CurView)
		if (!IsValid(CraftTable) or !IsValid(Craft) or !CurView) then return CurView end
		
		local Pos = CraftTable:GetPos()+CraftTable:GetUp()*60
		local Ang = CraftTable:LocalToWorldAngles(TViewAng)
		
		local C = Craft:GetAlpha()/255
		
		View.origin = LerpVector(C,CurView.origin,Pos)
		View.angles = LerpAngle(C,CurView.angles,Ang)
		
		return View
	end
	
	local function PopulateList()
		if (!Craft) then return end
		
		Craft.List:Clear()
		
		for k,v in pairs( santosRP.Items.GetAllRecipes() ) do
			local a = Craft.List:Add("DPanel")
			a:SetText("")
			a:SetTall(79)
			a.Paint = function(s,W,H)
				DrawSRPRect(0,0,W,H-5,MAIN_COLOR,MAIN_COLOR2)
				DrawRect(5,5,64,64,MAIN_COLOR2)
				
				DrawText(k,"Trebuchet24",74,5,MAIN_TEXTCOLOR)
				
				local txt = ""
				
				for S,b in pairs(v:GetData().Recipe) do
					txt = txt..b.."x "..S..","
				end
				
				if (LocalPlayer():CanCraft(k)) then
					DrawText(txt,"Default",74,32,MAIN_GREENCOLOR)
				else
					DrawText(txt,"Default",74,32,MAIN_REDCOLOR)
				end
			end
			
			local c = vgui.Create("SpawnIcon",a)
			c:SetPos(5,5)
			c:SetSize(64,64)
			c:SetModel(v:GetData().Model)
			c:SetToolTip("")
			
			local c = vgui.Create("MBButton",a)
			c:SetPos(Craft.Pane:GetWide()-105,49)
			c:SetSize(90,20)
			c:SetText("Select")
			c.Paint = function(s,w,h)
				if (s.Hovered) then DrawRect(0,0,w,h,MAIN_GREENCOLOR)
				else DrawRect(0,0,w,h,MAIN_COLOR2) end
				
				DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
			end
			
			c.DoClick = function(s)
				Craft.Recipe = v:GetData().Recipe
				Craft.Item	 = v
			end
		end
	end
	
	net.Receive("OpenCraftingMenu",function()
		CraftTable = net.ReadEntity()
		List = santosRP.Items.GetAllRecipes()
		if (!IsValid(CraftTable)) then return end
		if (CraftTable:GetPos():Distance(LocalPlayer():GetPos()) > 100) then CraftTable = nil return end
		
		if (!Craft) then
			Craft = vgui.Create("DFrame")
			Craft:SetSize(ScrW() * .8 + 10, ScrH() * .7)
			Craft:Center()
			Craft:SetPos(ScrW() * .05, select(2, Craft:GetPos()) - 10)
			Craft:SetTitle("")
			Craft:MakePopup()
			Craft:SetDraggable( false )
			Craft:SetAlpha(0)
			Craft:ShowCloseButton( false )
			Craft.Paint = function(s,w,h)
				DrawText("Crafting","SRP_Font32",w/2,20,MAIN_TEXTCOLOR,1)
				
			end
			Craft.Think = function(s)
				if (!IsValid(CraftTable)) then 
					s:SetVisible(false) 
				end
			end
			
			Craft.Exit = vgui.Create("MBButton",Craft)
			Craft.Exit:SetSize(Craft:GetWide() * .1 , Craft:GetTall() * .1)
			Craft.Exit:SetPos(Craft:GetWide() - Craft.Exit:GetWide(), Craft:GetTall() - Craft.Exit:GetTall())
			Craft.Exit:SetText("")
			Craft.Exit.Paint = function(s,w,h)
				if (s.Hovered) then DrawSRPRect(0,0,w,h,MAIN_GREENCOLOR,MAIN_COLOR2)
				else DrawSRPRect(0,0,w,h,MAIN_COLOR,MAIN_COLOR2) end
				
				DrawText("Exit","SRP_Font32",w/2,h/2,MAIN_TEXTCOLOR,1)
			end
			Craft.Exit.DoClick = function(s)
				Craft:Stop()
				Craft:AlphaTo( 0, 0.5, 0, function(anim,pan) pan:SetVisible(false) CraftTable = nil end )
			end
			
			Craft.Craft = vgui.Create("MBButton",Craft)
			Craft.Craft:SetSize(Craft:GetWide() * .1 , Craft:GetTall() * .1)
			Craft.Craft:SetPos(Craft:GetWide() - Craft.Craft:GetWide(), 0)
			Craft.Craft:SetText("")
			Craft.Craft.Paint = function(s,w,h)
				if (s.Hovered) then DrawSRPRect(0,0,w,h,MAIN_GREENCOLOR,MAIN_COLOR2)
				else DrawSRPRect(0,0,w,h,MAIN_COLOR,MAIN_COLOR2) end
				
				DrawText("Craft","SRP_Font32",w/2,h/2,MAIN_TEXTCOLOR,1)
			end
			Craft.Craft.DoClick = function(s)
				if (Craft.Item) then RequestCraft(Craft.Item.Name) end
			end
			
			
			Craft.Pane = vgui.Create("DScrollPanel",Craft)
			Craft.Pane:SetPos(0,0)
			Craft.Pane:SetSize(400,Craft:GetTall())
			Craft.Pane.Paint = function(s,w,h) DrawSRPRect(0,0,w,h,MAIN_COLOR,MAIN_COLOR2) end
			
			Craft.Pane.VBar.Paint = function(s,w,h) end
			Craft.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Craft.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			Craft.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
			
			Craft.List = vgui.Create("DListLayout",Craft.Pane)
			Craft.List:SetSize(Craft.Pane:GetWide()-10,Craft.Pane:GetTall()-10)
			Craft.List:SetPos(5,5)
			
			PopulateList()
		end
		
		Craft.Recipe = nil
		
		Craft:Stop()
		Craft:SetVisible(true)
		Craft:AlphaTo( 255, 0.5, 0, function(anim,pan) end )
	end)
end
	