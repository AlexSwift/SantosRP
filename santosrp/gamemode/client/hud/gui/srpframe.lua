local PANEL = {}
local Close = Material("gearfox/vgui/redcircle.png")
local Grad 	= Material("gui/gradient_down")

function PANEL:Init()
	self.Font 		= "Trebuchet18"
	self.Text		= "No-Title MBFrame"
	self.TextCol	= MAIN_TEXTCOLOR
	self.BrigCol	= MAIN_WHITECOLOR
	self.CloseRem   = false
	self.ShowClose 	= true
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:OnClose()
end

function PANEL:SetDeleteOnClose( bool )
	self.CloseRem = bool
end

function PANEL:SetTitle( name )
	self.Text = name
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:SetTextColor( col )
	self.TextCol = col
end

function PANEL:SetTextFont( font )
	self.Font = font
end

function PANEL:ShowCloseButton( bool )
	self.ShowClose = bool
end

function PANEL:OnMousePressed()
	if (!self.ShowClose) then return end
	
	local x,y = self:LocalToScreen( self:GetWide()-17 , 3 )
	
	if (input.IsMouseInBox( x , y , 14 , 14 )) then
		self:OnClose()
		
		if (self.CloseRem) then self:Remove()
		else self:SetVisible(false) end
	end
end

function PANEL:Paint(w,h)
	santosRP.ui.utils.drawBlurredPanel(self, 10)
end

function PANEL:PaintOver(w,h)
	DrawText( self.Text , self.Font , 8 , 6 , self.TextCol )
	
	if (self.ShowClose) then 
		local x,y = self:GetPos()
		surface.SetMaterial(Close)
		if (input.IsMouseInBox(x+w-17 , y+3 , 14 , 14)) then 
			surface.SetDrawColor(self.BrigCol)
		else 
			surface.SetDrawColor(self.TextCol)
		end
		surface.DrawTexturedRect(w-17, 3, 14, 14)
	end
	
	return true
end
	
function PANEL:PerformLayout()
end
 
vgui.Register( "SRPFrame", PANEL, "EditablePanel" )