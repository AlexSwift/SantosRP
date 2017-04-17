

local Text = surface.GetTextureID("gui/gradient")

function DrawBoxGradient(x,y,w,h,extw,color, linecolor)
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawRect( x, y, w, h )
	
	surface.SetTexture(Text)
	surface.DrawTexturedRectRotated( x-extw/2, y+h/2, extw, h, 180 )
	
	surface.SetDrawColor( linecolor.r, linecolor.g, linecolor.b, linecolor.a )
	surface.DrawLine(x-extw,y-1,x+w,y-1)
	surface.DrawLine(x-extw,y+h,x+w,y+h)
end

local Text2 = surface.GetTextureID("gui/gradient_down")

function DrawBoxGradientDown(x,y,w,h,color, gradcolor)
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawRect( x, y, w, h )
	
	surface.SetDrawColor( gradcolor.r, gradcolor.g, gradcolor.b, gradcolor.a )
	surface.SetTexture(Text2)
	surface.DrawTexturedRect( x, y, w, h/2 )
end