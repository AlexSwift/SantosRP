
local SunFlares = {
	surface.GetTextureID("mawbase/sunflares/flare1"),
	surface.GetTextureID("mawbase/sunflares/flare2"),
	surface.GetTextureID("mawbase/sunflares/s1"),
	surface.GetTextureID("mawbase/sunflares/s2"),
	surface.GetTextureID("mawbase/sunflares/s3"),
	surface.GetTextureID("mawbase/sunflares/s4"),
}

local SunGlow = surface.GetTextureID("sun/overlay")

MAIN_MAWSUNCOLOR = Color(255,255,255,255)

hook.Add("HUDPaint","RenderMawSunflare",function()
	GM = GM or GAMEMODE
	if (!GM.UseMawSun) then return end
	
	local Sun = GM:GetGlobalSHVar("SunPos")
	
	if (type(Sun):lower() != "vector") then return end
	
	local LPo	= GetCameraPos()
	local SPos 	= LPo+Sun
	local T		= {
		start   = LPo,
		endpos	= LPo+(Sun:GetNormal()*10000),
		filter  = LocalPlayer(),
	}
	
	T = util.TraceLine(T)
	
	if (T.Hit and !T.HitSky) then return end
	
	local Pos 	= SPos:ToScreen()
	local Dot 	= math.Clamp((LocalPlayer():GetAimVector():DotProduct( (SPos - LPo):GetNormal() )-0.5)*2,0,1)
	
	if (Dot <= 0) then return end
	
	local Size = 400+100*Dot
	
	local Cx   = ScrW()/2
	local Cy   = ScrH()/2
	
	local Gx   = Pos.x-Cx
	local Gy   = Pos.y-Cy
	
	local Col  = MAIN_MAWSUNCOLOR
	Col.a 	   = 250*Dot
	
	DrawTexturedRectRotated(Pos.x,Pos.y,Size*0.6,Size*0.6,Col,SunFlares[1],0)
	DrawTexturedRectRotated(Pos.x,Pos.y,Size,Size,Col,SunFlares[2],0)
	
	DrawTexturedRectRotated(Cx,Cy,64,64,Col,SunFlares[5],0)
	DrawTexturedRectRotated(Cx+Gx*0.5,Cy+Gy*0.5,140,140,Col,SunFlares[6],0)
	DrawTexturedRectRotated(Cx+Gx*0.2,Cy+Gy*0.2,50,50,Col,SunFlares[5],0)
	DrawTexturedRectRotated(Cx+Gx*0.30,Cy+Gy*0.30,53,53,Col,SunFlares[5],0)
	DrawTexturedRectRotated(Cx+Gx*0.25,Cy+Gy*0.25,90,90,Col,SunFlares[6],0)
	DrawTexturedRectRotated(Cx-Gx*0.12,Cy-Gy*0.12,90,90,Col,SunFlares[4],0)
	DrawTexturedRectRotated(Cx-Gx*0.2,Cy-Gy*0.2,210,210,Col,SunFlares[3],0)
	
end)