local PANEL = {}

local Grad 			= Material("gui/gradient_up")

function PANEL:Init()
	self.Hover		= false
	self.Pressed 	= false
	self.Text 		= "No-Title Button"
	self.ClickSound	= "buttons/lightswitch2.wav"
	self.ClickEnable = true
	
	self.HoverSound = "santosrp/buttonrollover.wav"
	self.HoverEnable = true
	
	self:SetText("")
	self.SetText = function(s,txt) self.Text = txt end
end

function PANEL:OnCursorEntered()
	self.Hover = true 
	if (self.HoverEnable) then surface.PlaySound(self.HoverSound) end 
end

function PANEL:EnableHoverSound(bool)
	self.HoverEnable = bool
end

function PANEL:SetHoverSound(sound)
	self.HoverSound = sound
end

function PANEL:EnableClickSound(bool)
	self.ClickEnable = bool
end

function PANEL:SetClickSound(sound)
	self.ClickSound = sound
end

function PANEL:OnMousePressed()
	self.Pressed = true
	self:MouseCapture( true )
end

function PANEL:OnMouseReleased()
	if (self.Pressed) then 
		if (self.ClickEnable) then surface.PlaySound(self.ClickSound) end
		
		self:DoClick() 
	end
	
	self.Pressed = false
	self:MouseCapture( false )
end

function PANEL:OnCursorExited() 
	self.Hover = false 
end

function PANEL:Paint(w,h)
	if (self.Pressed) 	then 	DrawRect( 0 , 0 , w , h , MAIN_GREENCOLOR ) 
	elseif (self.Hover) then 	DrawRect( 0 , 0 , w , h , MAIN_COLOR )
	else 						DrawRect( 0 , 0 , w , h , MAIN_COLORD ) end
	
	DrawMaterialRect(0,0,w,h,MAIN_BLACKCOLORD,Grad)
	
	DrawText( self.Text, "Trebuchet18", w/2, h/2, MAIN_TEXTCOLOR, 1 )
end
	
function PANEL:PerformLayout()
end
 
vgui.Register( "SRPButton", PANEL , "Button" )