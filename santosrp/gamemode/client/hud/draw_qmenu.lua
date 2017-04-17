local QMenu

local w,h = 565,400
local x,y = ScrW()/2-w/2,ScrH()/2-h/2

local Corn 		= surface.GetTextureID("gui/sniper_corner")

local Money 	= Material("santosrp/hud/money_pile.png")

local rad = math.rad
local cos = math.cos
local sin = math.sin


local CamData = {
	angles 		= Angle(30,0,0),
	fov 		= 90,
	origin 		= Vector(-100,0,40),
	type 		= "3D",
	w 			= 128,
	h 			= 128,
	aspect 		= 1,
	x 			= 0,
	y 			= 0,
	zfar	 	= 6000,
	znear		= 0.1,
}





function GM:OnSpawnMenuOpen()
	MAIN_NEW = false
	
	if (!QMenu) then
		QMenu = vgui.Create("SRPFrame")
		QMenu:SetPos(x,ScrH())
		QMenu:SetSize(w,h)
		QMenu:SetTitle("Inventory")
		QMenu:ShowCloseButton(false)
		
		QMenu.Pane = vgui.Create("DScrollPanel",QMenu)
		QMenu.Pane:SetPos(0,30)
		QMenu.Pane:SetSize(w,h-30)
		QMenu.Pane.Paint = function(s,w,h) end
		
		QMenu.Pane.VBar.Paint = function(s,w,h) end
		QMenu.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		QMenu.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		QMenu.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		
		QMenu.List = vgui.Create("DIconLayout",QMenu.Pane)
		QMenu.List:SetSize(QMenu.Pane:GetWide()-10,QMenu.Pane:GetTall()-10)
		QMenu.List:SetPos(5,5)
		QMenu.List:SetSpaceY(5)
		QMenu.List:SetSpaceX(5)
		
		QMenu.ItemInfo = vgui.Create("SRPFrame")
		QMenu.ItemInfo:SetSize(QMenu:GetTall(), QMenu:GetWide() * .5)
		QMenu.ItemInfo:SetPos(ScrW() * .7, select(2, QMenu:GetPos()))
		QMenu.ItemInfo:SetTitle("Item Info")

		QMenu.ItemInfo.ItemModel = vgui.Create("SRPItem", QMenu.ItemInfo)
		QMenu.ItemInfo.ItemModel:SetTall(QMenu.ItemInfo:GetTall() * .33)
		QMenu.ItemInfo.ItemModel:Dock(TOP)

		QMenu.ItemInfo.NameLabel = vgui.Create("DLabel", QMenu.ItemInfo)
		QMenu.ItemInfo.NameLabel:Dock(TOP)
		QMenu.ItemInfo.NameLabel:SetText("Name: ", QMenu.ItemInfo)

		QMenu.ItemInfo.DescLabel = vgui.Create("DLabel", QMenu.ItemInfo)
		QMenu.ItemInfo.DescLabel:Dock(TOP)
		QMenu.ItemInfo.DescLabel:SetText("Description: ")

		QMenu.ItemInfo:MakePopup()


		for i = 1,MAIN_MAXINVENTORY do
			local a = QMenu.List:Add("SRPItem")
			a:SetIconSize(65)
			a:SetDoClick(function(self)
				if not self.Item then return end
				QMenu.ItemInfo.ItemModel:SetModel(self.Item.Model)
				QMenu.ItemInfo.NameLabel:SetText(self.Item.Name)
				QMenu.ItemInfo.DescLabel:SetText(self.Item.Desc)
			end)

			a:SetDoRightClick(function(self)
				if not self.Item then return end
				local context = DermaMenu()
				context:SetPos(gui.MouseX(), gui.MouseY())
				
				local context_has_options = false
				
				if self.Item.CanSpawn and self.Item.CanSpawn ~= false then
					context:AddOption("Drop", function()
						if (self.Item.Class == "prop_physics") then
							santosRP.Items.RequestSpawnProp(self.Item.Model)
						else
							santosRP.Items.RequestSpawnEntity(self.Item.Name)
						end		
					end)
					context_has_options = true
				end
				--if self.Item.CanUse and self.Item.CanUse ~= false then
					context:AddOption("Use", function()
						self.Item:OnUse(LocalPlayer()) --from the base, dunno if correct
					end)
					context_has_options = true
				--end
				if context_has_options then
					context:Open()
				end
			end)
			
			a.Think = function(s)
				local Inv = LocalPlayer().Inventory or {}
				
				if (Inv[i] != s.Item) then
					s.Item = Inv[i]
					s:SetItem(Inv[i])
				end
			end
		end
	end
	
	gui.EnableScreenClicker(true)
	
	QMenu:Stop()
	QMenu:SetVisible(true)
	QMenu:MoveTo(x,y,0.5,0,-1,function(anim,panel) end)
end

function GM:OnSpawnMenuClose()
	gui.EnableScreenClicker(false)

	QMenu.ItemInfo:Remove() 

	QMenu:Stop()
	QMenu:MoveTo(x,ScrH(),0.5,0,-1,function(anim,panel) panel:SetVisible(false) end)
end
