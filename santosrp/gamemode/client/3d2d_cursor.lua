local Zero = Vector(0,0,0)

function Panel3D2DCursorInBox(mx,my,x,y,w,h)
	return (mx > x and mx < x+w and my > y and my < y+h)
end

function Panel3D2DCursorPos(Ang,Pos,Scale,Ent)
	local Eye = LocalPlayer():EyePos()
	local Aim = LocalPlayer():GetAimVector()
	local Hit = util.IntersectRayWithPlane( Eye, Aim, Pos, Ang:Up() )
	
	Hit = Hit or Zero
	
	local Res  = Ent:WorldToLocal(Hit)
	local Res2 = Ent:WorldToLocal(Pos)
	local Result = (Res2-Res)/Scale
	
	return -Result.y,Result.z
end