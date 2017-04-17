
APPS.Name = "Maps"
APPS.Icon = Material("santosrp/hud/appicons/maps.png","smooth")



if (SERVER) then return end

local radius = 4000

local rad = math.rad
local cos = math.cos
local sin = math.sin

local Ab = {
	"NE",
	"E",
	"SE",
	"S",
	"SW",
	"W",
	"NW",
	"N",
}

local rt		= GetRenderTarget("rtphonemaps",512,512)
local mot 		= Material("rtphonemaps")

local CamData = {}
CamData.x = 0
CamData.y = 0
CamData.w = ScrW()
CamData.h = ScrH()
CamData.aspect = CamData.w/CamData.h
CamData.drawviewmodel = false
CamData.drawhud = false
CamData.fov = 50

function APPS:PreDraw(x,y,w,h)
	CamData.angles = Angle(90,LocalPlayer():EyeAngles().y,0)
	CamData.origin = LocalPlayer():GetShootPos() + Vector(0,0,radius)
	
	local OldRT	= render.GetRenderTarget()
	
	mot:SetTexture( "$basetexture", rt )
	
	render.SetRenderTarget( rt )
	render.RenderView( CamData )
	render.SetRenderTarget( OldRT )
end

function APPS:Draw(x,y,w,h) 
	DrawMaterialRect(x,y,w,h,MAIN_WHITECOLOR,mot)
	
	local Ang = LocalPlayer():GetAimVector():Angle().y
	DrawSRPStar(x+w*0.2,y+h*0.9,3,15,MAIN_WHITECOLOR,Ang)
	
	for i = 1,8 do
		local ra = rad(Ang+45*i)
		local ox = x+w*0.2+cos(ra)*30
		local oy = y+h*0.9+sin(ra)*30
		
		if (math.floor(i/2) == math.ceil(i/2)) then
			DrawText(Ab[i],"SRP_Font16",ox,oy,MAIN_WHITECOLOR,1)
		else
			DrawText(Ab[i],"SRP_Font10",ox,oy,MAIN_WHITECOLOR,1)
		end
	end
	DrawText("Maps","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
end