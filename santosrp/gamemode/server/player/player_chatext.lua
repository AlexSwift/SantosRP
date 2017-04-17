util.AddNetworkString"player_chatPrintAdv"

local plyMeta = FindMetaTable"Player"

function plyMeta:ChatPrintAdv(...)
	net.Start"player_chatPrintAdv"
		net.WriteTable{...}
	net.Send(self)
end

function plyMeta:TalkInRadius(radius, ...)
	santosRP.chatSystem.sendMessageToRadius(ply:EyePos(), radius, ...)
end