local PANEL = {}

local matOn, matOff = Material("gearfox/vgui/greencircle16.png"), Material("gearfox/vgui/blueoutlinedcircle16.png")

function PANEL:Init()
	self:SetSize(16, 16)
	self:SetText("")

	self.mat = vgui.Create("Material")
	self.mat:SetSize(16, 16)
	self.mat:SetMaterial(self:GetChecked() and matOn or matOff)

	self:PerformLayout()
end

function PANEL:SetChecked( val )
	self.Button:SetChecked( val )

	self.mat:SetMaterial(val and matOn or matOff)
end

function PANEL:Paint()

end

function PANEL:PerformLayout()

	self.mat:SetPos((self:GetWide() - self.MatOn:GetWide())/2, (self:GetTall() - self.MatOn:GetTall())/2)

end



derma.DefineControl( "SRPCheckBox", "SRP Checkbox", PANEL, "DCheckBox" )