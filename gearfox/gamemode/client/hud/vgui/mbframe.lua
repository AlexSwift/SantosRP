local PANEL = {}
local Close = surface.GetTextureID("gearfox/vgui/close")

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2
	
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
	DrawBoxy( 0 , 0 , w , h , self.bgcol )
	DrawLine( 0 , 20 , w , 20 , self.fgcol )
end

function PANEL:PaintOver(w,h)
	DrawText( self.Text , self.Font , 2 , 2 , self.TextCol )
	
	if (self.ShowClose) then 
		local x,y = self:GetPos()
	
		if (input.IsMouseInBox(x+w-17 , y+3 , 14 , 14)) then DrawTexturedRect( w-17 , 3 , 14 , 14 , self.BrigCol , Close )
		else DrawTexturedRect( w-17 , 3 , 14 , 14 , self.TextCol , Close ) end
	end
	
	return true
end
	
function PANEL:PerformLayout()
end
 
vgui.Register( "MBFrame", PANEL, "EditablePanel" )