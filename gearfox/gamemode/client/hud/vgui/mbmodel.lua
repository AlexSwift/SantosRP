local PANEL = {}
local Zero  = Vector(0,0,0)
local One   = Vector(1,1,1)

function PANEL:Init()
	self.bgcol		= MAIN_COLOR2
	
	self.Model = vgui.Create( "DModelPanel" , self )
	self.Model:SetCamPos( Vector( 30, 30, 30 ) )
	self.Model:SetLookAt( Zero )
	self.Model:SetSize( self:GetWide() , self:GetTall() )
	self.Model:SetPos( 0 , 0 )
	
	self.Model.DoRightClick 	= function(s) self:DoRightClick() end
	self.Model.DoClick 			= function(s) self:DoLeftClick() end
end

function PANEL:DoRightClick()
end

function PANEL:DoLeftClick()
end

function PANEL:SetModel( name , Texture )
	self.Model:SetModel( name )
		
	local MSize,SSize = self.Model.Entity:GetRenderBounds()
	SSize = SSize:Length()
		
	self.Model:SetCamPos( One * SSize )
	self.Model:SetLookAt( Zero )
	
	if (Texture) then self.Model.Entity:SetMaterial(Texture) end
end

function PANEL:GetModel()
	return self.Model.Entity:GetModel()
end

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:Paint(w,h)
	DrawRect( 0 , 0 , w , h , self.bgcol )
end
	
function PANEL:PerformLayout()
	self.Model:SetSize( self:GetWide() , self:GetTall() )
	self.Model:SetPos( 0 , 0 )
end
 
vgui.Register( "MBModel", PANEL , "Panel" )