util.AddNetworkString("PlayerHunger")
util.AddNetworkString("BankMoney")
util.AddNetworkString("RequestTransferFromBank")
util.AddNetworkString("RequestTransferToBank")
util.AddNetworkString("BuyItem")
util.AddNetworkString("RequestCraft")
util.AddNetworkString("RequestLockVehicle")
util.AddNetworkString("CallbackLockVehicle")
util.AddNetworkString("Money")
util.AddNetworkString("RPName")

local meta = FindMetaTable("Player")

function meta:SetHunger(int)
	self.Hunger = math.Clamp(math.ceil(int),0,100)
	
	net.Start("PlayerHunger")
		net.WriteEntity(self)
		net.WriteUInt(self.Hunger,8)
	net.Send(self)
end

function meta:AddHunger(int)
	self:SetHunger(self:GetHunger()+int)
end

timer.Simple( 30, function()

	for k,v in pairs( player.GetAll() ) do
		
		if (v:Alive()) then
			v:AddHunger(-1)
			if (v:GetHunger() <= 0) then v:Kill() v:ChatPrint("You died of hunger!") end
		end
		
	end
end)

net.Receive("RequestTransferFromBank",function(bit,pl) 
	local Ent = pl:GetEyeTraceNoCursor().Entity
	
	if (!IsValid(Ent) or Ent:GetClass() != "santosrp_atm") then return end
	if (Ent:GetPos():Distance(pl:GetPos()) > 200) then return end
	
	pl:TransferFromBank(net.ReadUInt(32)) 
end)

net.Receive("RequestTransferToBank",function(bit,pl) 
	local Ent = pl:GetEyeTraceNoCursor().Entity
	
	if (!IsValid(Ent) or Ent:GetClass() != "santosrp_atm") then return end
	if (Ent:GetPos():Distance(pl:GetPos()) > 200) then return end
	
	pl:TransferToBank(net.ReadUInt(32)) 
end)

function meta:SetBankMoney(int)
	if (!int) then return end
	
	self.bank_money = math.ceil(int)
	
	net.Start("BankMoney")
		net.WriteEntity(self)
		net.WriteDouble(self.bank_money)
	net.Send(self)
	
	self:SaveInfo( 'bank_money', int  )
	
end

function meta:AddBankMoney(int)
	self:SetBankMoney((self.bank_money or 0) + int)
end

function meta:TransferToBank(int)
	if (!int or int <= 0) then return end
	int = math.Clamp(int,0,self:GetMoney())
	
	self:AddBankMoney(int)
	self:AddMoney(-int)
end

function meta:TransferFromBank(int)
	if (!int or int <= 0) then return end
	int = math.Clamp(int,0,self:GetBankMoney())
	
	self:AddBankMoney(-int)
	self:AddMoney(int)
end

net.Receive("BuyItem",function(_,pl)
	if (!IsValid(pl.TalkingNPC)) then return end
	
	local Class = pl.TalkingNPC:GetClass()
	
	if (pl.TalkingNPC:GetPos():Distance(pl:GetPos()) > 200) then return end
	if (pl:IsInCar()) then return end
	
	local dat  = santosRP.Items.GetItemDataFor(net.ReadString())
	
	if (!dat or !dat.Seller) then return end
	if (dat.Seller != Class) then return end
	
	
	if (pl:GetMoney() >= dat.Price) then
		if (!pl:AddInventory(dat.Name)) then
			pl:AddNote("You don't have enough space in your inventory!")
		else
			pl:AddMoney(-dat.Price)
			pl:AddNote("You purchased "..(dat.Name).." for "..(dat.Price).." bucks!")
		end
	else
		pl:AddNote("Insufficient funds!")
	end
end)

function meta:Craft(name)
	local Recipe,Item = santosRP.Items.GetRecipeForItem(name)
	if (!Recipe) then self:AddNote("Invalid recipe") return end
	
	--Do a checkup to make sure the player have the resources before removing them.
	for k,v in pairs(Recipe) do
		if (self:CountItem(k) < v) then
			self:AddNote("You need "..v.." "..k.." to craft a "..name)
			return
		end
	end
	
	--Checkup complete. Success! Now start crafting procedure.
	for k,v in pairs(Recipe) do
		for i = 1,v do
			self:RemoveInventory(k)
		end
	end
	
	self:AddNote("You created a "..name)
	self:AddInventory(name)
end

net.Receive("RequestCraft",function(bit,pl) 
	pl:Craft(net.ReadString()) 
end)

function meta:InitializeHands(name)
	local oldhands = self:GetHands()
	
	if (IsValid( oldhands )) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	
	if (IsValid(hands)) then
		self:SetHands( hands )
		hands:SetOwner( self )
		
		local info = player_manager.TranslatePlayerHands( name )
		
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		local vm = self:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		self:DeleteOnRemove( hands )

		hands:Spawn()
	end
end

net.Receive("RequestLockVehicle",function(bit,pl) 
	pl:ToggleLockCar() 
end)
	
function meta:ToggleLockCar()
	if (!IsValid(self.Car)) then return end
	self.Car.Locked = !self.Car.Locked
	self.Car:EmitSound("santosrp/carlock.wav")
	
	net.Start("CallbackLockVehicle")
		net.WriteBit(util.tobool(self.Car.Locked))
	net.Send(self)
end

function meta:SetMoney(int)
	if (!int) then return end
	
	self.money = math.ceil(int)
	
	net.Start("Money")
		net.WriteDouble(self.money)
	net.Send(self)
	
	self:SaveInfo( 'money', int )
	
end

function meta:AddMoney(int)
	self:SetMoney((self.money or 0) + int)
end

function meta:SetRPName(name)
	name = name or "Bob Snyder"
	if (string.len(name) < 3) then return end
	if (!IsEnglish(name)) then return end
	
	self.RPName = name
	
	net.Start("RPName")
		net.WriteEntity(self)
		net.WriteString(name)
	net.Broadcast()
	
	self:SaveInfo( 'rpname' , "\'" ..name.. "\'"  )
	
end

function meta:UpdateRPName(pl)
	if (!IsValid(pl) or !self.RPName) then return end
	
	net.Start("RPName")
		net.WriteEntity(self)
		net.WriteString(self.RPName)
	net.Send(pl)
	
	self:SaveInfo( 'rpname' , "\'" ..self.RPName.. "\'" )
	
end