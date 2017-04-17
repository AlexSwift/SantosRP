local PANEL = {}

function PANEL:Init()
	self.bgcol = MAIN_COLORD
	self.Limit = 100
	
	self:SetPadding( 1 )
	self:SetSpacing( 1 )
	self:SetAutoSize(false)
	self:EnableHorizontal( false )
	self:EnableVerticalScrollbar( true )
	self.VBar.Paint = function(s) end
	self.VBar.btnGrip.Paint = function(s,w,h) DrawRect( 2 , 0 , w-4 , h , self.bgcol ) end
	self.VBar.btnDown.Paint = function(s,w,h) DrawRect( 2 , 2 , w-4 , h-4 , self.bgcol ) end
	self.VBar.btnUp.Paint 	= function(s,w,h) DrawRect( 2 , 2 , w-4 , h-4 , self.bgcol ) end
	
	self.Delta = 0
	self.Smooth = 0
end

function PANEL:OnMouseWheeled(Delta)
	self.Delta = self.Delta+Delta
end

function PANEL:SetVScroll(num)
	self.VBar:SetScroll(num)
end

function PANEL:AddVScroll(num)
	self.VBar:AddScroll(num)
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetLimit(l)
	self.Limit = l
end

function PANEL:RemoveItem( item )
	for k, v in pairs( self.Items ) do
		if ( v == item ) then
			table.remove(self.Items,k)
			v:Remove()
		
			self:InvalidateLayout()
			break
		end
	end
end

function PANEL:Think()
	local It = self:GetItems()
	if (#It > self.Limit) then self:RemoveItem(It[#It-self.Limit]) end
	
	if (self.Delta > 0.01 or self.Delta < -0.01 or self.Smooth > 0.01 or self.Smooth < -0.01) then
		self.Delta = self.Delta - self.Delta/8
		self.Smooth = self.Smooth + (self.Delta-self.Smooth)/32
		self:AddVScroll(-self.Smooth/2)
	end
end

function PANEL:Paint()
end

vgui.Register( "MBPanelList", PANEL , "DPanelList" )