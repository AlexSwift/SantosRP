local PANEL = {}

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2

	self.TabsBut  = {}
	self.Tabs     = {}
	self.TabSel   = ""
	self.VertTabs = false
	
	self.Slide	  = 0
end

function PANEL:OnClose()
end

function PANEL:SetVerticalTabs( bool )
	self.VertTabs = bool
end

function PANEL:SetTitle( name )
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:AddTab(Text)
	local A = vgui.Create("MBFrame",self)
	A:SetTitle("")
	A:SetVisible(false)
	A:ShowCloseButton(false)
	A:SetPos(0,20)
	A:SetSize(self:GetWide(),self:GetTall()-25)
	A.Paint = function(s,w,h) DrawRect(0,0,w,h,self.bgcol) end

	local D = vgui.Create("MBButton",self)
	D:SetText(Text)
	D.T	= #self.TabsBut*1
	
	if (D.T < 1) then A:SetVisible(true) self.TabSel = D.T end
	
	D.Paint = function(s,w,h) 
		if (self.TabSel == s.T) then DrawRect(0,0,w,h,self.bgcol)
		else DrawRect(0,0,w,h,self.fgcol) end
		
		DrawText( s.Text, "Trebuchet18", w/2, h/2, MAIN_TEXTCOLOR, 1 )
	end
	
	D.DoClick = function()
		for k,v in pairs(self.Tabs) do 
			v:SetVisible(false)
		end
		
		self.Tabs[D.T]:SetVisible(true)
		self.TabSel = D.T
	end
	
	table.insert(self.TabsBut,D)
	self.Tabs[D.T] = A
	
	return self.Tabs[D.T]
end
		

function PANEL:Paint()
	return true
end

function PANEL:Think()
	local Num = #self.TabsBut
	local W   = self:GetWide()
	local SW  = 100*Num
	local X,Y = self:LocalToScreen()

	if (SW > self:GetWide()) then 
		if (input.IsMouseInBox(X,Y,20,20) and self.Slide > 0) then 
			self.Slide = self.Slide-1
			
			self:PerformLayout()
		elseif (input.IsMouseInBox(X+W-20,Y,20,20) and self.Slide < SW-W) then 
			self.Slide = self.Slide+1
			
			self:PerformLayout()
		end
	end
end
	
function PANEL:PerformLayout()
	for k,v in pairs(self.TabsBut) do
		v:SetPos(100*(k-1)-self.Slide,0)
		v:SetSize(97,20)
	end
	
	if (self.Tabs[self.TabSel]) then
		self.Tabs[self.TabSel]:SetPos(0,20)
		self.Tabs[self.TabSel]:SetSize(self:GetWide(),self:GetTall()-25)
	end
end
 
vgui.Register( "MBTab", PANEL )