

AddCSLuaFile()

ENT.Base 			= "santosrp_npc_base"

function ENT:Use(user)
	if (user:IsPlayer()) then
		user.TalkingNPC = self
		net.Start("OpenPropShop")
		net.Send(user)
	end
end

