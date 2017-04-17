if SERVER then return end
 
_PlayerHat = ClientsideModel("models/props_junk/TrafficCone001a.mdl")
_PlayerHat:SetNoDraw(true)
 
 
hook.Add("PostPlayerDraw", "hatsss", function( ply )
	local Bone 				= ply:LookupBone("ValveBiped.Bip01_Head1")
	local BonePos , BoneAng = ply:GetBonePosition( Bone )
	
	local OffsetPos,OffsetAng = Vector(0,0,10),Angle(0,0,0)
	OffsetPos:Rotate(OffsetAng)
	
	local OldAng = BoneAng*1
	BoneAng:RotateAroundAxis(OldAng:Forward(),OffsetAng.r)
	BoneAng:RotateAroundAxis(OldAng:Right(),OffsetAng.p)
	BoneAng:RotateAroundAxis(OldAng:Up(),OffsetAng.y)
 
	_PlayerHat:SetModelScale(0.6, 0)
	_PlayerHat:SetRenderOrigin( BonePos + OffsetPos )
	_PlayerHat:SetRenderAngles( BoneAng )
	_PlayerHat:SetupBones()
 	_PlayerHat:DrawModel()
end)