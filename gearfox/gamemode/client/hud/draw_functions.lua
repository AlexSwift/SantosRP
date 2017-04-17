
local Grad 		= surface.GetTextureID("gui/gradient")
local GradUp 	= surface.GetTextureID("gui/gradient_up")
local GradDown 	= surface.GetTextureID("gui/gradient_down")

local RoundedBox 	= draw.RoundedBox
local SimpleText 	= draw.SimpleText

local SSetMaterial 				= surface.SetMaterial
local SSetTexture 				= surface.SetTexture
local SSetDrawColor 			= surface.SetDrawColor
local SDrawTexturedRect 		= surface.DrawTexturedRect
local SDrawLine					= surface.DrawLine
local SDrawOutlinedRect 		= surface.DrawOutlinedRect
local SDrawRect					= surface.DrawRect
local SDrawTexturedRectRotated 	= surface.DrawTexturedRectRotated
	
function DrawBoxy(x,y,w,h,color)
	RoundedBox( 8, x, y, w, h, color )
end

function DrawText(text,font,x,y,color,bCentered)
	SimpleText( text, font, x, y, color, bCentered or 0, bCentered or 0 )
end

function DrawRect(x,y,w,h,color)
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawRect( x, y, w, h )
end

function DrawOutlinedRect(x,y,w,h,color)
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawOutlinedRect( x, y, w, h )
end

function DrawLeftGradient(x,y,w,h,color)
	DrawTexturedRect(x,y,w,h,color,Grad)
end

function DrawTopGradient(x,y,w,h,color)
	DrawTexturedRect(x,y,w,h,color,GradUp)
end
	
function DrawBottomGradient(x,y,w,h,color)
	DrawTexturedRect(x,y,w,h,color,GradDown)
end

function DrawTexturedRect(x,y,w,h,color,texture)
	SSetTexture( texture )
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawTexturedRect( x, y, w, h )
end

function DrawTexturedRectRotated(x,y,w,h,color,texture,rot)
	SSetTexture( texture )
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawTexturedRectRotated( x, y, w, h, rot )
end

function DrawMaterialRect(x,y,w,h,color,material)
	SSetMaterial( material )
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawTexturedRect( x, y, w, h )
end

function DrawMaterialRectRotated(x,y,w,h,color,material,rot)
	SSetMaterial( material )
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawTexturedRectRotated( x, y, w, h, rot )
end

function DrawLine(x,y,x2,y2,color)
	SSetDrawColor( color.r, color.g, color.b, color.a )
	SDrawLine( x, y, x2, y2 )
end