local PANEL = {}

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2
	
	self.HTML = vgui.Create( "HTML" , self )
	self.HTML:OpenURL("www.google.com")
	self.HTML.StatusChanged = function( s , str ) self.Status = str end
	
	self.Status = "Ready."
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:OpenURL(url)
	self.HTML:OpenURL(url)
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:Paint(w,h)
	DrawBoxy( 0 , 0 , w , h , self.bgcol )
	DrawLine( 0 , 20 , w , 20 , self.fgcol )
	
	DrawText( self.Status , "Trebuchet18" , 5 , self:GetTall()-20 , MAIN_WHITECOLOR )
	
	return true
end
	
function PANEL:PerformLayout()
	self.HTML:SetPos(1,22)
	self.HTML:SetSize(self:GetWide()-2,self:GetTall()-44)
end
 
vgui.Register( "MBBrowser", PANEL , "MBFrame" )