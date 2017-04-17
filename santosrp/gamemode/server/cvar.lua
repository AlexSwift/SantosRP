--DEBUG: TO-BE-REMOVED
concommand.Add("SpawnEntity",function(pl,com,arg)
	local pos = pl:GetShootPos()
	local aim = pl:GetAimVector()
	
	local Trace = util.TraceLine({
		start=pos,
		endpos=pos+aim*500,
		filter=pl,
	})
	
	local e = ents.Create(arg[1])
	
	if (!IsValid(e)) then return end
	
	e:SetPos(Trace.HitPos)
	e:Spawn()
	e:Activate()
end)

concommand.Add("srp_getpos",function(pl,com,arg)
	local pos = pl:GetPos()
	local Ang = pl:GetAimVector():Angle()
	print("Vector("..math.ceil(pos.x)..","..math.ceil(pos.y)..","..math.ceil(pos.z)..")")
	print("Angle("..math.ceil(Ang.p)..","..math.ceil(Ang.y)..","..math.ceil(Ang.r)..")")
end)
--DEBUG END