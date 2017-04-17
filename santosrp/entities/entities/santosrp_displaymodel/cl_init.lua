include"shared.lua"

local scale = Vector( 0,0,0 )

function ENT:Draw()

	self.csm:DrawModel()
	render.DrawBox( self:GetPos(), self:GetAngles(), Vector( -5,-5,-5), Vector( 5,5,5 ), Color( 255,255,255,80), true )
		
end

function ENT:Initialize()
	self.csm = ClientsideModel(self:GetModel())

	local vec_min,vec_max = self:GetRenderBounds()
	local vec_norm = vec_max - vec_min
	
	scale = Vector( 10/vec_norm.x ,10/vec_norm.y ,10/vec_norm.z )

end