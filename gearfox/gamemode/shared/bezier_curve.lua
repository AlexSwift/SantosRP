
--Took a while to get the right algorithm for this..
--By The Maw

local insert = table.insert

function BezierCurve(Point1,Ang1,Point2,Ang2,size,iter)
	local Points 	= {}
	local Step 		= 1/iter
	
	local Point1_for = Point1 + Ang1:Forward()*size
	local Point2_for = Point2 + Ang2:Forward()*size
	
	for i = 0,iter do
		local t = Step*i
		local Ab = (1-t)
		
		insert(Points,Ab^3*Point1+3*Ab^2*t*Point1_for+3*Ab*t^2*Point2_for+t^3*Point2)
	end
		
	return Points
end



if (CLIENT) then
	local tan	 = math.tan
	local rad	 = math.rad

	local MPos = mesh.Position
	local MNor = mesh.Normal
	local MAdv = mesh.AdvanceVertex
	
	
	function CurveToMesh(Curve,Size,iter)
		local Step = 360/iter
		
		local BSiz 		= tan(rad(Step/4))*Size
		local BHeight 	= BSiz/iter*4
		
		local LastAng = nil
		
		mesh.Begin(MATERIAL_QUADS,(#Curve-1)*iter)
			for k,v in pairs(Curve) do
				local NextCurve = Curve[k+1]
				
				if (NextCurve) then
					local Ang 	= (NextCurve-v):Angle()
					local Ang2 	= LastAng or Ang*1
					
					for i = 1,iter do
						local Rig 	= Ang:Right()
						local Rig2 	= Ang2:Right()
						
						MPos( v+Rig2*BSiz )
						MNor( Rig2 )
						MAdv()
			 
						MPos( NextCurve+Rig*BSiz )
						MNor( Rig )
						MAdv()
						
						Ang:RotateAroundAxis(Ang:Forward(),Step)
						Ang2:RotateAroundAxis(Ang2:Forward(),Step)
						
						local Rig 	= Ang:Right()
						local Rig2 	= Ang2:Right()
			 
						MPos( NextCurve+Rig*BSiz )
						MNor( Rig )
						MAdv()
						
						MPos( v+Rig2*BSiz )
						MNor( Rig2 )
						MAdv()
					end
					
					LastAng = Ang
				end
			end
		mesh.End()
	end
end
			