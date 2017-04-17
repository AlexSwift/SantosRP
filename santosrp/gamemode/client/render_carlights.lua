


--This is just to replace the miserable VCMod. GOODBYE WE DONT NEED YOU BASTERDS!

local Mat 		= Material("santosrp/effects/glow03")
local Mat2 		= Material("santosrp/effects/glow03_noz_shrine","ignorez")
local matBeam	= Material( "effects/lamp_beam" )
local Color 	= Color

local WhiteCol = Color(255,255,255)
local LampCol = Color(100,100,100)

local abs = math.abs
local cos = math.cos
local sin = math.sin

local SetMaterial 	= render.SetMaterial
local DrawSprite 	= render.DrawSprite

local StartBeam 	= render.StartBeam
local AddBeam 		= render.AddBeam
local EndBeam 		= render.EndBeam

local PixelVisible 				= util.PixelVisible
local GetPixelVisibleHandle 	= util.GetPixelVisibleHandle

local function EmitBlinkSound(car,bIn)
	if (!bIn) then car:EmitSound("santosrp/blink_in.wav")
	else car:EmitSound("santosrp/blink_out.wav") end
end

local Flick = false

function GetFlick()
	local Time = CurTime()
	return ((Time-math.floor(Time)) < 0.5)
end



local function DrawGlow(Pos,Size,GlowSize,Col,ID,Veh,Siren,v)
	GlowSize = GlowSize+Size
	
	
	if (v and v.LightType == "Headlight") then
		local Ang = Veh:LocalToWorldAngles(v.Ang)
		local For = Ang:Forward()
		
		local ViewNormal 	= (Pos - EyePos()):GetNormal()
		local ViewDot 		= 1-ViewNormal:Dot( For * -1 )
		
		if ( ViewDot >= 0 ) then
			local A = Col.a*1
			local Size = math.max(30,GlowSize)
			
			Col.a = ViewDot/2*200
			
			SetMaterial(matBeam)
			StartBeam(3)
				AddBeam(Pos,GlowSize,0,Col)
				AddBeam(Pos+For*100,GlowSize,0.5,Col)
				AddBeam(Pos+For*200,GlowSize,1,MAIN_NOCOLOR)
			EndBeam()
			
			Col.a = A
			
			SetAppropriateLightMat(Pos)
		end
	end
	
	if (!MAIN_EXPENSIVE_CARLIGHT) then 
		DrawSprite(Pos,Size,Size,Col)
		return
	end
		
	if (!Veh.HandlerData) then Veh.HandlerData = {} end
	if (!Veh.HandlerData[ID]) then Veh.HandlerData[ID] = GetPixelVisibleHandle() end
	
	
	if (Siren) then 
		SetMaterial(Mat)
		DrawSprite(Pos,Size,Size,Col)
		SetMaterial(Mat2)
	end
	
	local Visible	= PixelVisible(Pos, 1, Veh.HandlerData[ID] )
	
	if (Visible <= 0) then return end
	
	DrawSprite(Pos,GlowSize*Visible,GlowSize*Visible,Col)
end


--Sound tick
function TickVehicleSound(v)
	local Time 	= CurTime()
	local AT 	= GetFlick()
	
	if (v.Data and v:IsEngineOn()) then
		
		if (v.Siren and santosRP.Vehicles.GetCarInfoByModel( v:GetModel() ):GetSirenSound() ) then
			if (!v.SirenSound) then v.SirenSound = CreateSound(v,santosRP.Vehicles.GetCarInfoByModel( v:GetModel() ):GetSirenSound()) v.SirenSound:Play() end
			if (!v.SirenSoundCD) then v.SirenSoundCD = Time + SoundDuration( santosRP.Vehicles.GetCarInfoByModel( v:GetModel() ):GetSirenSound() ) end
			
			if (v.SirenSoundCD < Time) then 
				v.SirenSound:Stop()
				v.SirenSound:Play()
				
				v.SirenSoundCD = Time + SoundDuration( santosRP.Vehicles.GetCarInfoByModel( v:GetModel() ):GetSirenSound() )-0.2 
			end
		elseif (v.SirenSound and v.SirenSound:IsPlaying()) then 
			v.SirenSoundCD = Time
			v.SirenSound:Stop()
		end
	elseif (v.SirenSound and v.SirenSound:IsPlaying()) then 
		v.SirenSoundCD = Time
		v.SirenSound:Stop()
	end
end



hook.Add("Tick","Flick",function()	
	local AT 	= GetFlick()
	
	if (AT and !Flick) then Flick = true
	elseif (!AT and Flick) then Flick = false end
end)



--Car light rendering
local Dat = {}
local rem = table.remove

function MarkCarRenderable(v)
	Dat[v:EntIndex()] = {v,CurTime()+0.1}
end

hook.Add("PostDrawTranslucentRenderables","RenderCarLights",function()
	local Time = CurTime()
	local Def = render.GetFogMode()*1
	
	render.FogMode(0)
	for k,v in pairs(Dat) do
		if (v[2] > Time and IsValid(v[1])) then RenderCarLights(v[1])
		else rem(Dat,k)
		end
	end
	render.FogMode(Def)
end)

function SetAppropriateLightMat(Pos)
	if (MAIN_EXPENSIVE_CARLIGHT) then SetMaterial(Mat2)
	else SetMaterial(Mat) end
end

	
function RenderCarLights(v)
	if (!v.Data or (v.IsEngineOn and !v:IsEngineOn())) then return end
	
	TickVehicleSound( v )
	
	local Pos,Ang = v:GetPos(),v:GetAngles()
	local Time 	  = CurTime()
	
	local GlowSize = 10
	
	SetAppropriateLightMat(Pos)
	
	local AT 	= GetFlick()
	
	santosRP.Vehicles.ForeachCarLights(v,function(v,l,a)
		local Ab = l.Pos*1
		Ab:Rotate(Ang)
			
		if (l.LightType == "Normal") then
			DrawGlow(Pos+Ab,50*l.Size,GlowSize,l.Color,a,v)
		elseif (l.LightType == "Brakes") then 
			if (v.Braking) then
				DrawGlow(Pos+Ab,100*l.Size,GlowSize,l.Color,a,v)
			else
				DrawGlow(Pos+Ab,50*l.Size,GlowSize,l.Color,a,v)
			end
		elseif (l.LightType == "Headlight") then
			DrawGlow(Pos+Ab,50*l.Size,GlowSize,l.Color,a,v,false,l)
		else
			if (v.Siren) then
				if (l.LightType == "Siren1") then
					local Flinch  = abs(80*cos(Time*10))
					DrawGlow(Pos+Ab,Flinch,20,l.Color,250+a,v,true)
				elseif (l.LightType == "Siren2") then
					local Flinch  = abs(80*sin(Time*10))
					DrawGlow(Pos+Ab,Flinch,20,l.Color,250+a,v,true)
				end
			end
		end
	end)
end