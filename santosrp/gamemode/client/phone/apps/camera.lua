
APPS.Name = "Camera"
APPS.Icon = Material("santosrp/hud/appicons/camera_icon.png","smooth")



if (SERVER) then return end

local rt		= GetRenderTarget("rtphonecamera",512,512)
local mot 		= Material("rtphonecamera")
local mattex 	= Material("santosrp/hud/phone_camera.png","noclamp smooth")

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
	CamData.angles = LocalPlayer():GetAimVector():Angle()
	CamData.origin = LocalPlayer():GetShootPos()
	
	local OldRT	= render.GetRenderTarget()
	
	mot:SetTexture( "$basetexture", rt )
	
	render.SetRenderTarget( rt )
	render.RenderView( CamData )
	render.SetRenderTarget( OldRT )
end
	
function APPS:Draw(x,y,w,h) 
	DrawMaterialRect(x,y,w,h,MAIN_WHITECOLOR,mot)
	DrawMaterialRect(x,y+h-80,w,80,MAIN_WHITECOLOR,mattex)
	
	DrawText("Camera","SRP_Font32",x+w/2,y+40,MAIN_WHITECOLOR,1)
end


function APPS:DoPrimaryFire(wep)
	LocalPlayer().TakingPicture = true
	LocalPlayer():ConCommand( "jpeg" )
	timer.Simple( 0.1, function() LocalPlayer().TakingPicture = false end )
end

	