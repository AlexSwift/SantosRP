local PANEL = {}
local Grad 	= Material("gui/gradient_down")

local Zero		= Vector(0,0,00)
local CamPos 	= Vector(15,0,15)

function PANEL:Init()
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self:SetText("")
	
	self._bmodel = vgui.Create("DModelPanel",self)
	self._bmodel:SetPos(5,5)
	self._bmodel:SetSize(self:GetWide()-10,self:GetTall()-10)
	self._bmodel:SetModel("")
	self._bmodel:SetLookAt(Zero)
	self._bmodel:SetCamPos(CamPos)
	self._bmodel:SetVisible(false)
end

function PANEL:SetIconSize(siz)
	self:SetSize(siz,siz)
end

function PANEL:SetItem(item)
	if (type(item) == "table") then self.Data = item
	else self.Data = santosRP.Items.GetItemDataFor(item) end
	
	if (self.Data and self.Data.Model) then
		self._bmodel:SetModel(self.Data.Model)
		self._bmodel:SetVisible(true)
	else
		self._bmodel:SetVisible(false)
	end
end

function PANEL:Paint(w,h)
	draw.RoundedBox(5, 0, 0 , w, h, MAIN_COLOR2)
end

function PANEL:SetDoClick(func)
	self.DoClick = func
	
	self._bmodel.DoClick = function() self:DoClick() end
end

function PANEL:SetDoRightClick(func)
	self.DoRightClick = func
	
	self._bmodel.DoRightClick = function() self:DoRightClick() end
end

function PANEL:PaintOver(w,h)
	return true
end
	
function PANEL:PerformLayout()
	self._bmodel:SetPos(5,5)
	self._bmodel:SetSize(self:GetWide()-10,self:GetTall()-10)
end
 
vgui.Register( "SRPItem", PANEL, "DButton" )