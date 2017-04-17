
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_junk/terracotta01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
	
	self:NextThink(CurTime()+1)
	self:SetTimeStarted(CurTime())
end

function ENT:Think()
	--if (!IsValid(self:GetPlayerOwner())) then self:Remove() end
	
	self:NextThink(CurTime()+1)
	return true
end

function ENT:Use(user)
	if (user:IsPlayer()) then
		if (self:GetTimeStarted() < CurTime()-10) then
			self:SetTimeStarted(CurTime())
			local a = ents.Create("santosrp_drug")
			a:SetPos(self:GetPos()+self:GetUp()*20)
			a:Spawn()
			a:Activate()
		end
	end
end