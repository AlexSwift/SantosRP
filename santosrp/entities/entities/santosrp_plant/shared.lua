
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= "Maw"
ENT.Purpose			= "Stuff"


function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "TimeStarted" )
end