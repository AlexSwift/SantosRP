
vgui.GetWorldPanel():SetWorldClicker(false)

local view = {}

local MovieMode_Pos = Vector(0,0,0)
local MovieMode_Ang = Vector(0,0,0)


function ToggleMovieMode() 
	MAIN_MOVIEMODE = !MAIN_MOVIEMODE 
	
	local lp = LocalPlayer()
	
	MovieMode_Pos = lp:GetShootPos()
	MovieMode_Ang = lp:GetAimVector()
end

hook.Add("CalcView","MainSantosCamera",function(ply, origin, angles, fov)
	view.origin				= nil
	view.angles				= angles
	
	if (MAIN_BOBBLEHEAD) then
		local Speed = ply:GetVelocity():Length()/400
		local Time = CurTime()*10
		local AddA = Angle(-math.cos(Time*2)/2*Speed,math.sin(Time)*2*Speed,math.sin(Time)/2*Speed)*math.min(1,Speed)
		
		view.angles	= angles+AddA
	end
		
	
	
	local VC = ply:GetVehicle()
	if (IsValid(VC) and VC:GetThirdPersonMode()) then
		local Or = VC:GetPos()
		Or.z = origin.z
		
		local tr = util.TraceLine({
			start=Or,
			endpos=Or-angles:Forward()*VC:GetCameraDistance()*100,
			filter={VC,ply},
			mask=MASK_SOLID_BRUSHONLY,
		})
		
		view.origin = tr.HitPos
	end
	
	local CraftT = GetCraftingTab()
		
	if (IsValid(CraftT)) then
		view.origin = origin
		view.angles = angles
		
		local NewView = GetCraftingView(view)
		
		view.origin = NewView.origin
		view.angles = NewView.angles
		
		return view
	end
	
	if (MAIN_MOVIEMODE) then
		MovieMode_Pos = MovieMode_Pos+((view.origin or origin)-MovieMode_Pos)/32
		MovieMode_Ang = MovieMode_Ang+(angles:Forward()-MovieMode_Ang)/32
	
		view.origin				= MovieMode_Pos
		view.angles				= MovieMode_Ang:Angle()
	end
	
	return view
end)


--Vehicle fix
