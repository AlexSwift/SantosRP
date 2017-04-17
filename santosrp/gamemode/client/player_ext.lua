net.Receive( "PlayerHunger", function()
	net.ReadEntity().Hunger = net.ReadUInt(8) 
end)

net.Receive("BankMoney",function()
	net.ReadEntity().bank_money = net.ReadDouble() 
end)

function RequestTransferFromBank(int)
	if (!int) then return end
	
	net.Start("RequestTransferFromBank")
		net.WriteUInt(int,32)
	net.SendToServer()
end

function RequestTransferToBank(int)
	if (!int) then return end
	
	net.Start("RequestTransferToBank")
		net.WriteUInt(int,32)
	net.SendToServer()
end

function RequestCraft(name)
	if (!santosRP.Items.GetRecipeForItem(name)) then return end
	
	net.Start("RequestCraft")
		net.WriteString(name)
	net.SendToServer()
end

net.Receive("CallbackLockVehicle",function() 
	LocalPlayer().CarLocked = util.tobool(net.ReadBit()) 
	surface.PlaySound("santosrp/atm_button.wav")
end)

function RequestLockVehicle()
	net.Start("RequestLockVehicle")
	net.SendToServer()
end

net.Receive("Money",function() 
	LocalPlayer().money = net.ReadDouble() 
end)

net.Receive("RPName",function() 
	net.ReadEntity().RPName = net.ReadString() 
end)