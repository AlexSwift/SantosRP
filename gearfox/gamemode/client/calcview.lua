
local Camdist 	= 60 --Dont change this
local Camcdist 	= 60 --Dont change this
local CamMin	= 20
local CamMax	= 200
local Campos 	= Vector( 0 , 0 , 0 )
local Aimpos	= Vector( 0 , 0 , 0 )
local AimVect	= Vector( 0 , 0 , 0 )
local RPos		= Campos
local CamEnt 	= NULL
local DefDCam 	= nil
local EnabledFT = true
local CamZNear	= 1
local CamZFar	= nil
local CamKey 	= KEY_C
local CamHeight = 0
local NewFunc 	= nil

--I was wondering if I should use the vgui functions or the bindpress. The advantage is that the vgui one works even when your mouse is out.
--However, it might get annoying when you are trying to scroll a scrollbar. ;P
vgui.GetWorldPanel():SetWorldClicker(false)

hook.Add("PlayerBindPress","CameraScroll",function(ply,bind,pressed)
	self = GM or GAMEMODE
	
	if (EnabledFT and (!CamKey or input.IsKeyDown(CamKey))) then
		if (bind == "invnext") then 
			self:AddCameraDistance(10)
			return true
		end
		
		if (bind == "invprev") then 
			self:AddCameraDistance(-10)
			return true
		end
	end
end)

function GM:SetCameraKey(KEY)
	CamKey = KEY
end

function GM:SetCameraDistance(dist)
	if (dist > CamMax) then dist = CamMax end
	if (dist < CamMin) then dist = CamMin end
	
	if (Camdist != dist and LocalPlayer():Alive()) then
		if (dist == CamMin) then OnCameraModeSwitch(true)
		elseif (Camdist == CamMin) then OnCameraModeSwitch(false) end
	end
	
	Camdist = dist
end

function GM:AddCameraDistance(add)
	local dist = Camdist + add
	if (dist > CamMax) then dist = CamMax end
	if (dist < CamMin) then dist = CamMin end
	
	if (Camdist != dist and LocalPlayer():Alive()) then
		if (dist == CamMin) then self:OnCameraModeSwitch(true)
		elseif (Camdist == CamMin) then self:OnCameraModeSwitch(false) end
	end
	
	Camdist = dist
end

function GM:SetEnableThirdPerson(bool)
	EnabledFT = bool
end

function IsFirstPerson()
	return (!EnabledFT or Camdist <= CamMin)
end

function GM:OnCameraModeSwitch(bFirstPerson)
end

function GetCameraPos()
	return RPos
end

function SetCameraObject(Ent)
	CamEnt = Ent
end

function SetDefaultDeathPos(Pos)
	DefDCam = Pos
end

function SetCameraMinDistance(Dist)
	CamMin = Dist
end

function SetCameraMaxDistance(Dist)
	CamMax = Dist
end

function SetCameraZNear(Near)
	CamZNear = Near
end

function SetCameraZFar(Far)
	CamZFar = Far
end

function SetCameraOffsetHeight(H)
	CamHeight=H
end

function OverrideDefaultGFCamera(Fun)
	NewFunc = Fun
end

hook.Add("CalcView","View",function(ply, origin, angles, fov)
	if (NewFunc) then 
		local Cal = NewFunc(ply, origin, angles, fov) 
		
		if (Cal) then return Cal end
	end
	
	local view 				= {} 
	
	AimPos 					= ply:GetAimVector()
	AimVect					= AimVect + (AimPos-AimVect)/2
	
	view.znear 				= CamZNear 
	view.zfar  				= CamZFar
	
	view.origin 			= origin
	
	if (!ply:Alive()) then 
		if (DefDCam) then origin = DefDCam end 
		
		view.origin = origin + AimPos * -80 
		RPos = view.origin 
		return view 
	end
	
	if (!EnabledFT) then return view end
	
	if (Camdist > CamMin or IsValid(CamEnt)) then
		Camcdist				= Camcdist + (Camdist-Camcdist)/16
		local Distance			= Camcdist
		
		Campos 					= ply:GetShootPos()
		Campos.z				= Campos.z
		
		if (IsValid(CamEnt)) then Campos = CamEnt:GetPos() end
		
		local Aimer				= AimVect
		local data 				= {} 
					
		data.start 				= Campos
		data.endpos 			= Campos - Aimer * Distance
		data.filter 			= ply
		data.mask				= MASK_SOLID_BRUSHONLY
		data.mins				= ply:OBBMaxs()/3*-1
		data.maxs				= ply:OBBMaxs()/3
					
		local trace = util.TraceHull( data ) 
		
		view.origin 			= trace.HitPos
		view.angles 			= Aimer:Angle()
	end
	
	view.origin.z				= view.origin.z + CamHeight
	
	RPos 						= view.origin or origin
	
	return view
end)