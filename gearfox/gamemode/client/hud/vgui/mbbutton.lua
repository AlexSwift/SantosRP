local PANEL = {}

function PANEL:Init()
	self.Hover		= false
	self.Pressed 	= false
	self.Text 		= "No-Title Button"
	self.ClickSound	= "buttons/lightswitch2.wav"
	self.ClickEnable = true
	
	self.HoverSound = "common/bugreporter_succeeded.wav"
	self.HoverEnable = false
	
	
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
	DrawRect( 0 , 0 , w , h , MAIN_COLORD )
	if (self.Pressed) 	then 	DrawRect( 0 , h-3 , w , h , MAIN_GREENCOLOR ) 
	elseif (self.Hover) then 	DrawRect( 0 , h-3 , w , h , MAIN_COLOR )
	else 						DrawRect( 0 , h-3 , w , h , MAIN_COLORD ) end
	
	DrawText( self.Text, "Trebuchet18", w/2, h/2, MAIN_TEXTCOLOR, 1 )
end
	
function PANEL:PerformLayout()
end
 
vgui.Register( "MBButton", PANEL , "Button" )