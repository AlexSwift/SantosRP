local PANEL = {}
local Close = surface.GetTextureID("gearfox/vgui/close")
local Grad 	= Material("gui/gradient_up")

function PANEL:Init()
	self.Text		= "No Item"
	self.TextDesc	= "No Description"
	self.TextCol	= MAIN_TEXTCOLOR
	self.BrigCol	= MAIN_WHITECOLOR
	
	self._ib = vgui.Create("SRPItem",self)
	self._ib:SetPos(5,5)
	self._ib:SetIconSize(self:GetTall()-35)
	
	self._db = vgui.Create("SRPButton",self)
	self._db:SetPos(5,self:GetTall()-25)
	self._db:SetSize(self:GetWide()-10,20)
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:OnClose()
end

function PANEL:SetItem(item)
	self.Data = santosRP.Items.GetItemDataFor(item)
	
	if (self.Data) then
		self._ib:SetItem(item)
		self.Text = item
		self.TextDesc = self.Data.Desc
	end
		
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

function PANEL:SetButtonText( txt )
	self._db:SetText(txt)
end

function PANEL:SetButtonDoClick( func )
	self._db.DoClick = func
end

function PANEL:SetTextFont( font )
	self.Font = font
end

function PANEL:ShowCloseButton( bool )
	self.ShowClose = bool
end

function PANEL:OnMousePressed()
end

function PANEL:Paint(w,h)
	local Indent = self._ib:GetWide()+10
	
	DrawRect(0,0,w,h,MAIN_COLOR)
	DrawRect(Indent,5,w-Indent-5,h-35,MAIN_COLOR2)
	DrawMaterialRect(0,0,w,h,MAIN_BLACKCOLOR,Grad)
end

function PANEL:PaintOver(w,h)
	local Indent = self._ib:GetWide()+14
	
	DrawText( self.Text , "Trebuchet24" , Indent , 6 , self.TextCol )
	DrawText( self.TextDesc , "Trebuchet18" , Indent , 30 , self.TextCol )
	
	if (self.Data) then
		DrawText("Price: $"..self.Data.Price,"Trebuchet18",Indent,55,MAIN_GREENCOLOR)	
	end
	
	return true
end
	
function PANEL:PerformLayout()
	self._ib:SetPos(5,5)
	self._ib:SetIconSize(self:GetTall()-35)
	
	self._db:SetPos(5,self:GetTall()-25)
	self._db:SetSize(self:GetWide()-10,20)
end
 
vgui.Register( "SRPItemFrame", PANEL, "Panel" )