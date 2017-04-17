net.Receive("player_chatPrintAdv", function()
	chat.AddText(unpack(net.ReadTable()))
end)