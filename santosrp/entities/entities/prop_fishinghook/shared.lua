
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= "Maw"
ENT.Purpose			= "Stuff"

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Fish" )
end