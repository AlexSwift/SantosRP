
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("RequestCraft")
	
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
	
	net.Receive("RequestCraft",function(bit,pl) pl:Craft(net.ReadString()) end)
else
	function RequestCraft(name)
		if (!santosRP.Items.GetRecipeForItem(name)) then return end
		
		net.Start("RequestCraft")
			net.WriteString(name)
		net.SendToServer()
	end
end

function meta:CanCraft(name)
	local Recipe = santosRP.Items.GetRecipeForItem(name)
	if (!Recipe) then return false end
	
	for k,v in pairs(Recipe) do
		if (self:CountItem(k) < v) then
			return false
		end
	end
	
	return true
end