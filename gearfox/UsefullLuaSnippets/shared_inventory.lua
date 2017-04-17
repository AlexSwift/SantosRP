
--> Inherited from Old Age 2 scripts made by The Maw. <--

local meta  = FindMetaTable("Player")
local Slots = 16

if (SERVER) then
	util.AddNetworkString("SetSlotItem")
	util.AddNetworkString("SetupInventory")

	function meta:AddItem(item)
		local ID = nil
		if (!self.Inventory) then self.Inventory = {} ID = 1
		else for i = 1,Slots do if (!self.Inventory[i]) then ID = i break end end end
		
		if (ID) then
			self.Inventory[ID] = item
			
			net.Start("SetSlotItem")
				net.WriteEntity(self)
				net.WriteByte(ID)
				net.WriteString(item)
			net.Send(self)
		else return false end --We are returning false if there isn't any available slots left.
	end
	
	function meta:SetupInventory(dat) --We are using a table of items, using the indexes as the slotID
		self.Inventory = dat
		
		net.Start("SetupInventory")
			net.WriteEntity(self)
			net.WriteTable(dat)
		net.Send(self)
	end
else
	net.Receive("SetSlotItem",function(size)
		local Ply = net.ReadEntity()
		
		if (!Ply.Inventory) then Ply.Inventory = {} end
		Ply.Inventory[net.ReadByte()] = net.ReadString()
	end)
	
	net.Receive("SetupInventory",function(size) net.ReadEntity().Inventory = net.ReadTable() end)
end

function meta:GetSlot(id)
	if (!self.Inventory) then return nil end
	return self.Inventory[id] or nil
end

function meta:GetInventory(id)
	return self.Inventory or {}
end

function meta:HasRoom()
	if (!self.Inventory) then return true end
	for i = 1,Slots do if (!self.Inventory[i]) then return true end end
	return false
end
	
	
	
	
	
	