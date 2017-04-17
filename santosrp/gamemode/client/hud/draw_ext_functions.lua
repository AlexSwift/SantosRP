
--This is just for this gamemode specific

local DrawRect 		= DrawRect
local DrawPoly 		= surface.DrawPoly
local SetDrawColor 	= surface.SetDrawColor

local Grad 			= Material("gui/gradient_down")

local rad = math.rad
local cos = math.cos
local sin = math.sin
local abs = math.abs

local Add 		= table.Add
local insert 	= table.insert

function DrawSRPRect(x,y,w,h,col,col2)
	DrawRect(x,y,w,h,col)
	DrawRect(x+5,y+5,w-10,h-10,col2)
end

function DrawSRPCircle(x,y,r,r2,startang,endang,iter,col,col2)
	local rstartang 	= rad(startang)
	local rendang 		= rad(endang)
	
	draw.NoTexture()
	
	local OutR 	= abs(r-4)
	local OutR2 = abs(r2+4)
	
	local Step = abs(rendang-rstartang)/iter
	
	SetDrawColor(col.r,col.g,col.b,col.a)
	
	for i = 0, iter-1 do
		local Time1 = Step*i+rstartang
		local Time2 = Time1+Step
		
		--First layer
		local dat2 	= {
			{
				x=cos(Time2)*OutR+x,
				y=-sin(Time2)*OutR+y,
				u=0,
				v=0,
			},
			{
				x=cos(Time2)*OutR2+x,
				y=-sin(Time2)*OutR2+y,
				u=1,
				v=0,
			},
			{
				x=cos(Time1)*OutR2+x,
				y=-sin(Time1)*OutR2+y,
				u=1,
				v=1,
			},
			{
				x=cos(Time1)*OutR+x,
				y=-sin(Time1)*OutR+y,
				u=0,
				v=1,
			},
		}
		
		DrawPoly(dat2)
	end
	
	if (col2) then DrawSRPCircle(x,y,r+4,r2-4,startang,endang,iter,col2) end
end

function DrawSRPDiamond(x,y,w,h,col,col2)
	local DigH = h/2
	
	--FirstLayer
	local dat 	= {
		{
			x=x,
			y=y+DigH,
			u=0,
			v=0.5,
		},
		{
			x=x+DigH,
			y=y,
			u=DigH/w,
			v=0,
		},
		{
			x=x+w-DigH,
			y=y,
			u=(w-DigH)/w,
			v=0,
		},
		{
			x=x+w,
			y=y+DigH,
			u=1,
			v=0.5,
		},
		{
			x=x+w-DigH,
			y=y+h,
			u=(w-DigH)/w,
			v=1,
		},
		{
			x=x+DigH,
			y=y+h,
			u=DigH/w,
			v=1,
		},
	}
	
	SetDrawColor(col.r,col.g,col.b,col.a)
	
	--Secondlayer
	if (col2) then 
		draw.NoTexture()
		DrawPoly(dat)
		surface.SetMaterial(Grad)
		DrawSRPDiamond(x+5,y+5,w-10,h-10,col2) 
	else
		DrawPoly(dat)
	end
end

function DrawSRPBox(x,y,w,h,col,col2)
	local DigH = h/3
	w = math.max(w,DigH)
	
	--FirstLayer
	--[[local dat 	= {
		{
			x=x,
			y=y+h,
			u=0,
			v=1,
		},
		{
			x=x,
			y=y+DigH,
			u=0,
			v=DigH/h,
		},
		{
			x=x+DigH,
			y=y,
			u=DigH/w,
			v=0,
		},
		{
			x=x+w,
			y=y,
			u=1,
			v=0,
		},
		{
			x=x+w,
			y=y+DigH*2,
			u=1,
			v=(DigH*2)/h,
		},
		{
			x=x+w-DigH,
			y=y+h,
			u=(w-DigH)/w,
			v=1,
		},
	}]]
	
	
	SetDrawColor(col.r,col.g,col.b,col.a)
	
	--Secondlayerwww
	--[[if (col2) then 
		draw.NoTexture()
		DrawPoly(dat)
		surface.SetMaterial(Grad)
		DrawSRPBox(x+5,y+5,w-10,h-10,col2) 
	else
		DrawPoly(dat)
	end]]
	--surface.DrawRect(x, y, w, h)
	draw.RoundedBox(16, x, y, w, h, col)
end


function DrawSRPStar(x,y,r1,r2,col,ang)
	ang = ang or 0
	draw.NoTexture()
	
	--FirstLayer
	local dat 	= {}
	
	for i = 1,8 do
		local Deg  	= rad(45*i+ang)
		local Deg2  = rad(90*i)
		local Dis 	= r1+r2*abs(cos(Deg2))
		
		local Tab 	= {
			x=x+Dis*cos(Deg),
			y=y+Dis*sin(Deg),
			u=0,
			v=0,
		}
		
		insert(dat,Tab)
	end
	
	SetDrawColor(col.r,col.g,col.b,col.a)
	DrawPoly(dat)
end

function DrawTextRotated( text, font, x, y, Tcol, ang)
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	
	local m = Matrix()
	m:SetTranslation( Vector( x, y, 0 ) )
	m:SetAngles( Angle( 0, ang, 0 ) )
	
	cam.PushModelMatrix( m )
		DrawText(text,font,0,0,Tcol,1)
	cam.PopModelMatrix()
	
	render.PopFilterMag()
	render.PopFilterMin()
end

function DrawTextRotatedBox( text, font, x, y, w, h, Tcol, ang, col, col2 )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	
	local m = Matrix()
	m:SetAngles( Angle( 0, ang, 0 ) )
	m:SetTranslation( Vector( x, y, 0 ) )
	
	cam.PushModelMatrix( m )
		DrawSRPBox(0,0,w,h,col,col2)
		DrawText(text,font,w/2,h/2,Tcol,1)
	cam.PopModelMatrix()
	
	render.PopFilterMag()
	render.PopFilterMin()
end


function surface.SetColor(color)
	surface.SetDrawColor(color.r, color.g, color.b, color.a)
end