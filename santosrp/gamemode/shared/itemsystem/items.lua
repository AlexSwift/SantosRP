local _i_aData = {       --Needs redoing
				Items = { },
				Recipes = {},
				Fish = {}
			};

local _PLAYER = FindMetaTable("Player")

class 'santosRP.Items' {

	public {
	
		static {
			i_sFolder 	= GM.Folder:gsub("gamemodes/","").."/gamemode/shared/itemsystem/items";
			
			LoadItems = function( )
			
				GeneratePropItems()
			
				local _ITEM = santosRP.Items.new()
				ITEM = {}
				
				AddCSLuaFile(santosRP.Items.i_sFolder .. "/base.lua")
				include(santosRP.Items.i_sFolder .."/base.lua")
				
				local BaseItem = table.Copy( ITEM )
				
				for k,v in pairs( file.Find( santosRP.Items.i_sFolder.."/*.lua","LUA") ) do
				
					if (v == "base.lua") then continue end
					
					local _ITEM2 = santosRP.Items.new()
					_ITEM2:SetData( BaseItem )
					
					AddCSLuaFile( santosRP.Items.i_sFolder .. "/" .. v )
					include( santosRP.Items.i_sFolder .. "/" .. v )
					
					_ITEM2:SetData( ITEM )
					_ITEM2:Register()
				end
				
				santosRP.Items.SyncMySQL()
				
			end;
			
			GetItemObjectFor = function( i_sName )
			
				for k,v in pairs( _i_aData.Items ) do
					if ( k == i_sName ) then return v end
				end
				
				return nil
			
			end;
			
			GetItemDataFor = function( i_sName )
				for k,v in pairs( _i_aData.Items ) do
					if ( k == i_sName ) then return v:GetData() end
				end
				
				return nil
			end;
			
			GetItemFromMySQLID = function( i_iMySQLID )
			
				if not SERVER then return end
				
				local item
				
				for k,v in pairs( _i_aData.Items ) do
					if v.i_iMySQLID == i_iMySQLID then
						item = v
					else
						continue
					end
				end
				
				return item
			
			end;
			
			GetRecipeForItem = function( i_sName)
				for k,v in pairs( _i_aData.Recipes ) do
					if ( k == i_sName) then return v.Recipe,v end
				end
				
				return nil
			end;
			
			GetAllRecipes =function( )
				return _i_aData.Recipes or {}
			end;
			
			GetAllCraftingItems = function( )
				return _i_aData.Recipes or {}
			end;
			
			GetAllItems =function( )
				return _i_aData.Items or {}
			end;
			
			GetAllFish =function( )
				return _i_aData.Fish or {}
			end;
			
			GetItemsByClass = function( i_sClass )
				local tab = {}
				for k,v in pairs( _i_aData.Items ) do
					if ( v.i_aItemData.Class == i_sClass) then table.insert( tab ,v ) end
				end
				
				return tab
			end;
			
			GetEntityShopList = function( Ent )
				local Class = Ent:GetClass()
				local tab = {}
				
				for k,v in pairs(_i_aData.Items) do
					if (v.i_aItemData.Seller == Class) then table.insert( tab, v ) end
				end
				
				PrintTable( tab )
				
				return tab
			end;
			
			GetFood = function( i_sName )
				local Item = santosRP.Items.GetItemDataFor( i_sName )
				if (Item and Item.FoodAmount ~= 0) then return Item end
			end;
			
			RequestSpawnProp = function(mdl)
				if not CLIENT then return end
				net.Start("RequestSpawnProp")
					net.WriteString(mdl)
				net.SendToServer()
			end;
			
			RequestSpawnEntity = function(name)
				if not CLIENT then return end
				net.Start("RequestSpawnEntity")
					net.WriteString(name)
				net.SendToServer()
			end;
			
			RequestBuyEntity = function(name)
				if not CLIENT then return end
				net.Start("BuyItem")
					net.WriteString(name)
				net.SendToServer()
			end;
			
		
		};
		
		GetData = function( self )
		
			return self.i_aItemData
		
		end;
		
		SetData = function( self, data )
		
			self.i_aItemData = table.Copy( data )

		end;
		
		Register = function( self )
			
			_i_aData.Items[ self.i_aItemData.Name ] = self
						
			if ( self.i_aItemData.Recipe ) then _i_aData.Recipes[self.i_aItemData.Name] = self end
			if ( self.i_aItemData.Fish ) then _i_aData.Fish[self.i_aItemData.Name] = self end
			
			
		end;
		
		CanSpawn = function( self )
		
			if self.i_aItemData.CanSpawn and self.i_aItemData.CanSpawn == false then
				return false
			end
			
			return true
			
		end;
		
		i_iMySQLID = 0
	
	};
	
	private {
		
		static {
			
			SyncMySQL = function( )
			
				if not SERVER then return end
			
				local str = ''
				local w_clause = 'WHERE '
			
				GAMEMODE.Database:QueryAll("SELECT * FROM `santosrp`.`item`;", function( data)
			
					for k,v in pairs( santosRP.Items.GetAllItems() ) do
						
						if not table.HasSubValue( data, k, 'name' ) then
							str = str .. 'INSERT IGNORE INTO `santosrp`.`item` ( name ) VALUES ( \'' .. k .. '\' );\n'
							w_clause = w_clause .. 'name= \'' .. k .. '\' OR '
						else
							v.i_iMySQLID = data[ table.GetKeyFromSubValue( data, k, 'name' ) ].id
						end
					end
					w_clause = string.sub( w_clause, 1, #w_clause - 4)
					
					if #str == 0 then return end
					
					GAMEMODE.Database( str, function( data )
						GAMEMODE.Database( 'SELECT * FROM `santosrp`.`item` ' .. w_clause .. ';', function( data2 )
							santosRP.Items.GetItemObjectFor( data2.name ).i_iMySQLID = data2.id
						end)
					end)
					
				end)
					
				
			end;
			
		};
	
		CopyData = function( self )
		
			return table.Copy( self.i_aItemData )
			
		end;
	
		i_aItemData = {};
	
	};
	
}


hook.Add("InitPostEntity", "FixingMySQL", function()
	print( 'Adding bot to bring server out of hibernation' )
	RunConsoleCommand( 'bot' )
end)

if SERVER then
	local Blocklist = {}
	local Up		= Vector(0,0,20)

	util.AddNetworkString("UpdateSlot")
	util.AddNetworkString("RequestSpawnProp")
	util.AddNetworkString("RequestSpawnEntity")

	function _PLAYER:AddInventory(name,SlotS, dont_save)
		
		local item = santosRP.Items.GetItemObjectFor(name)
		local Dat = item:GetData()
		
		if (!Dat) then return end
		if not Dat.OnBuy() then return true end
		if (!self.Inventory) then self.Inventory = {} end

		if (!SlotS) then
			for i = 1,MAIN_MAXINVENTORY do
				local Slot = self.Inventory[i]
				
				if SlotS then continue end
				
				if (!Slot) then
					SlotS = i
				end
			end
		end
		
		local Slot = self.Inventory[SlotS]
		if (!Slot) then
			self.Inventory[SlotS] = Dat
			self:UpdateSlot(SlotS)
			if not dont_save then
				GAMEMODE.Database("INSERT INTO `santosrp`.`player_inventory` ( player_id, item_id, slot, amount ) VALUES ( ?, ?, ?, ? );", self.MySQLID, item.i_iMySQLID, SlotS, 1, function( _, data)
				end)
			end
			
			return true
		else
			--You can't put this item to this slot. Rerun the function without the specified slot to find a new one!
			return self:AddInventory(Dat)
		end
	end
	
	function _PLAYER:SetClothing ( i_sName )
		
		if not self.Clothing then 
			self.Clothing = {} --Format [ i_sName ] = { Enabled = bool, Entity = Entity(0 ), item_Data = {} }
		end
		
		if self.Clothing[ i_sName ] and self.Clothing[i_sName].Enabled == true or self.Clothing[i_sName].Entity then
			self.Clothing[ i_sName ].Entity = nil
		end
		
		self.Clothing[i_sName] = { Enabled = true, ItemData = santosRP.Items.GetItemObjectFor( i_sName ), Entity = Entity(0) }
		
		for k,v in pairs( self.Clothing ) do
			if k == i_sNAme then return end
			if v.ItemData.Type == self.Clothing[i_sName].ItemData.Class then
				self.Clothing[ k ].Enabled = false
				self.Clothing[ k ].Entity = nil
			end
		end
		
		self.Clothing[i_sName].Entity = ents.Create( self.Clothing[i_sName].ItemData.Class )
		
	end
		

	function _PLAYER:RemoveInventory(Item,SlotS)
	
		local item = santosRP.Items.GetItemObjectFor(Item.Name)
	
		if (!self.Inventory) then return end
		
		if (!SlotS) then
		
			local bFind,Slot = self:HasItem(Item.Name)
			
			if (bFind) then
				self.Inventory[Slot] = nil
				self:UpdateSlot(Slot)
			end
			GAMEMODE.Database("DELETE FROM `santosrp`.`player_inventory` WHERE player_id=? AND item_id=? AND slot=?;", self.MySQLID, item.i_iMySQLID, Slot, function( _, data)
			
			end)
			
		else
		
			local Slot = self.Inventory[SlotS]
			
			if (Slot and Slot.Name == Item.Name) then
				self.Inventory[SlotS] = nil
				self:UpdateSlot(SlotS)
			end
			
			GAMEMODE.Database("DELETE FROM `santosrp`.`player_inventory` WHERE player_id=? AND item_id=? AND slot=?;", self.MySQLID, item.i_iMySQLID, SlotS, function( _, data)
			
			end)
		end
	end

	function _PLAYER:UpdateSlot(slot)
		if (!self.Inventory) then return end
		local Slot = self.Inventory[slot]
		net.Start("UpdateSlot")
			net.WriteUInt(slot,16)
			if (Slot) then 
				net.WriteBit(true)
				net.WriteString(Slot.Name)
			else
				net.WriteBit(false)
			end
		net.Send(self)
	end

	net.Receive("RequestSpawnProp",function(siz,pl)
		if (pl:IsInCar()) then pl:AddNote("You cannot spawn entities while driving!") return end

		local mdl = net.ReadString()
		local Dat = {
			Name = mdl,
			Model = mdl,
			Class = "prop_physics",
			Quantity = 1,
		}
		if (table.HasValue(Blocklist,mdl)) then return end
		if (!util.IsValidProp(mdl)) then return end
		if (!ModelExists(mdl)) then return end
		if (!pl:HasItem(Dat.Model)) then return end
		pl:RemoveInventory(Dat)
		
		local Tr = util.TraceLine({
			start = pl:GetShootPos(),
			endpos = pl:GetShootPos()+pl:GetAimVector()*400,
			filter = pl,
		})
			
		local ent = ents.Create("prop_physics")
		ent:SetPos(Tr.HitPos+Up)
		ent:SetAngles(Angle(0,pl:GetAimVector():Angle().y,0))
		ent:SetModel(mdl)
		ent:Spawn()
		ent:Activate()
		ent:PhysWake()
		
		timer.Simple(0.1,function() if (IsValid(ent)) then ent:SetPlayerOwner(pl) end end)
		
		undo.Create( "Prop" )
			undo.AddEntity( ent )
			undo.SetPlayer( pl )
			undo.AddFunction(function(tab) 
				if (IsValid(tab.Entities[1])) then
					tab.Owner:AddInventory(Dat)
				end
			end)
		undo.Finish( "Prop ("..mdl..")" )
	end)
	
	net.Receive("RequestSpawnEntity",function(siz,pl)
	
		if (pl:IsInCar()) then pl:AddNote("You cannot spawn entities while driving!") return end
		
		local name  = net.ReadString()
		local Dat 	= santosRP.Items.GetItemDataFor(name)
		local item	= santosRP.Items.GEtItemObjectFor( name )
		
		if (!Dat) then return end
		if (!pl:HasItem(name)) then return end
		if not item:CanSpawn() then return end
		
		local Tr = util.TraceLine({
			start = pl:GetShootPos(),
			endpos = pl:GetShootPos()+pl:GetAimVector()*400,
			filter = pl,
		})
			
		local ent = ents.Create(Dat.Class)
		
		if (!IsValid(ent)) then return end
		
		pl:RemoveInventory( Dat )
		
		if Dat.Class == 'prop_physics' then
			ent:SetModel( Dat.Name )
		end
		
		ent:SetPos(Tr.HitPos+Up)
		ent:SetAngles(Angle(0,pl:GetAimVector():Angle().y,0))
		ent:Spawn()
		ent:Activate()
		
		if (ent.SetItem) then ent:SetItem(Dat) end
		if (ent.SetFood) then ent:SetFood(Dat) end
		
		timer.Simple(0.1,function() if (IsValid(ent)) then ent:SetPlayerOwner(pl) end end)
		
		undo.Create( Dat.Class )
			undo.AddEntity( ent )
			undo.SetPlayer( pl )
			undo.AddFunction(function(tab) 
				if (IsValid(tab.Entities[1])) then
					tab.Owner:AddInventory(Dat)
				end
			end)
		undo.Finish( "Entity ("..Dat.Class..")" )
	end)
	
else
	
	net.Receive("UpdateSlot",function()
		local lp = LocalPlayer()
		
		if (!lp.Inventory) then lp.Inventory = {} end
		
		local Slot  = net.ReadUInt(16)
		local Valid = util.tobool(net.ReadBit())
		
		if (!Valid) then 
			lp.Inventory[Slot] = nil 
		else
			local s = net.ReadString()
			lp.Inventory[Slot] = santosRP.Items.GetAllItems()[s]:GetData()
		end
	end)
	
	function GM:OnUndo(name,str)
		LocalPlayer():AddNote(name .." undone")
		surface.PlaySound( "buttons/button15.wav" )
	end
	
end

function _PLAYER:GetInventory()
	return self.Inventory or {}
end

function _PLAYER:HasItem(name)
	if (!self.Inventory) then return false end
	
	for k,v in pairs(self.Inventory) do
		if (v and v.Name == name) then
			return true, k
		end
	end
	
	return false
end

function _PLAYER:CountItem(name)
	if (!self.Inventory) then return 0 end
	
	local Count = 0
	
	for k,v in pairs(self.Inventory) do
		if (v and v.Name == name) then
			Count = Count+1
		end
	end
	
	return Count
end
