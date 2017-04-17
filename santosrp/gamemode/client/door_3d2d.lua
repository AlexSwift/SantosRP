local function drawDoorText(door, pos, ang, scale)
	cam.Start3D2D(pos, ang , scale)
		surface.SetFont("SRP_Font64")
		surface.SetTextColor(Color(200, 200, 200))
		surface.SetTextPos(0, 0)
		surface.DrawText(door:GetOwner() and door:GetOwner():GetName() or "Unowned")

		surface.SetTextPos(0, 60)
		surface.SetFont("SRP_Font24")
		surface.DrawText(door:GetName())
	cam.End3D2D()
end

hook.Add("Initialize", "SRP_UpdateDoorDraws", santosRP.Property.UpdateDoorDraws)