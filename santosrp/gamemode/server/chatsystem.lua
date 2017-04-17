santosRP.chatSystem = {}

function santosRP.chatSystem.formatMessage(prefix, ply, ...)
	return {prefix.." ", ply:GetName(), ": ", ...}
end

function santosRP.chatSystem.sendMessageToRadius(origin, radius, ...)
	for _, ent in pairs(ents.FindInSphere(origin, radius)) do
		if not ent:IsPlayer() then continue end

		ent:ChatPrintAdv(...)
	end
end