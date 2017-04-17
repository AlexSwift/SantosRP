local PANEL = {}

function PANEL:Init()
	self.bgcol 	  = MAIN_COLOR2
	self.hovercol = MAIN_COLORD
	self.foldecol = MAIN_COLORD2
	self.selecCol = MAIN_GREENCOLOR

	self.VBar.Paint 		= function(s) end
	self.VBar.btnGrip.Paint = function(s) DrawRect( 2 , 0 , s:GetWide()-4 , s:GetTall() , self.bgcol ) end
	self.VBar.btnDown.Paint = function(s) DrawRect( 2 , 2 , s:GetWide()-4 , s:GetTall()-4 , self.bgcol ) end
	self.VBar.btnUp.Paint 	= function(s) DrawRect( 2 , 2 , s:GetWide()-4 , s:GetTall()-4 , self.bgcol ) end
	
	self.Delta 		= 0
	self.Smooth 	= 0
	self.BGEnabled 	= true
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

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:EnableNodeBG( bool ) 
	self.BGEnabled = bool
end

function PANEL:AddNode( text )
	local V = self.BaseClass.AddNode( self, text )
	 
	V.BGEnabled = self.BGEnabled
	
	V.FolCol   	= self.foldecol
	V.HovCol   	= self.hovercol
	V.SelCol 	= self.selecCol
	V.OAddNode 	= V.AddNode
	
	V.Label:SetFont("Trebuchet18")
	V.Label.Paint = function(s,w,h) 
		if (V:HasChildren() and V.BGEnabled) then DrawRect( 0 , 1 , w , h-2 , V.FolCol )
		elseif (!V:HasChildren() and self:GetSelectedItem()==V) then DrawRect( 0 , 1 , w , h-2 , V.SelCol )
		elseif (V.Hovered) then DrawRect( 0 , 1 , w , h-2 , V.HovCol ) end 
	end
		
	V.AddNode  = function(s,txt)
		local D = s.OAddNode(s,txt)
		
		D.FolCol  	= s.FolCol
		D.HovCol  	= s.HovCol
		D.SelCol 	= s.SelCol
		D.BGEnabled = s.BGEnabled
		
		D.Label:SetFont("Trebuchet18")
		
		D.Label.Paint = function(p,w,h) 
			if (D:HasChildren() and D.BGEnabled) then DrawRect( 0 , 1 , w , h-2 , D.FolCol ) 
			elseif (!D:HasChildren() and self:GetSelectedItem()==D) then DrawRect( 0 , 1 , w , h-2 , D.SelCol )
			elseif (D.Hovered) then DrawRect( 0 , 1 , w , h-2 , D.HovCol ) end
		end
		
		D.OAddNode = D.AddNode
		D.AddNode = s.AddNode
		
		return D
	end
	
	return V
end

function PANEL:Think()
	if (self.Delta > 0.01 or self.Delta < -0.01 or self.Smooth > 0.01 or self.Smooth < -0.01) then
		self.Delta = self.Delta - self.Delta/8
		self.Smooth = self.Smooth + (self.Delta-self.Smooth)/32
		self:AddVScroll(-self.Smooth/2)
	end
end

function PANEL:Paint()
end

vgui.Register( "MBTree", PANEL , "DTree" )