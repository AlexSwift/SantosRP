class 'santosRP.Property' {
	
	public {
	
		static {
		
			LoadProperty = function( p_sIdentifier )
			
				local data = file.Read( 'santosrp/properties/' .. p_sIdentifier , 'DATA' )
				local p_aData = util.JSONToTable( data )
				local p_aDoorData = p_aData.p_aDoorData
				local p_aInfo = p_aData.p_aInfo
				p_aInfo['Price'] = tonumber( p_aInfo['Price'] )
				local p_sIdentifier = string.sub( p_sIdentifier, 1, #p_sIdentifier - 4 )
				
				local property = santosRP.Property.new()
				
				local door_data = {}
				for k,v in pairs( property:GetDoorData( ) ) do
					door_data[ k ] = {}
					for k2,v2 in pairs( v ) do	
						table.insert( door_data[k] , Entity(v2) )
						--Setup Door Entity - Property references
					end
				end

				property:SetIdentifier( p_sIdentifier )
				property:SetDoorData( p_aDoorData )
				property:SetInfo( p_aInfo )
				
				santosRP.Property.p_aProperties[ p_sIdentifier ] = property
			
			end;
		
			LoadProperties = function( )
			
				local f = file.Find( 'santosrp/properties/*', 'DATA' )
				
				for k,v in pairs( f ) do
				
					santosRP.Property.LoadProperty( v )
				
				end
				
			end;
			
			SaveProperty = function( p_Property )
			
				local property = p_Property
				local p_sIdentifier = property:GetIdentifier()
				
				local door_data = {}
				for k,v in pairs( property:GetDoorData( ) ) do
					door_data[ k ] = {}
					for k2,v2 in pairs( v ) do	
						table.insert( door_data[k] , v2:EntIndex() )
					end
				end
				
				local p_aData = { p_aDoorData = door_data, p_aInfo = property:GetInfo(), p_aIdentifier }
				
				file.Write( 'santosrp/properties/' .. p_sIdentifier .. '.txt', util.TableToJSON( p_aData ) )
				
				santosRP.Property.p_aProperties[ p_sIdentifier ] = santosRP.Property.Copy( property )
				
			end;
			
			SaveProperties = function( )
			
				for k,v in pairs( santosRP.Property.GetPropertyList( ) ) do
				
					santosRP.Property.SaveProperty( v )
				
				end
			
			end;
			
			GetProperty = function( p_aIdentifier )
			
				return p_aProperties[ p_aIdentifier ] or false
				
			end;
			
			GetPropertyTable = function( )
			
				return santosRP.Property.p_aProperties
			
			end;
			
			GetPropertyList = function( )
				
				local p_aList = {}
				
				for k,v in pairs( santosRP.Property.GetPropertyTable( ) ) do
					table.insert( p_aList, k )
				end
				
				return p_aList
				
			end;
			
			Copy = function( p_Property )
			
				local property = santosRP.Property.new()
				property:SetDoorData( p_Property:GetDoorData() )
				property:SetInfo( property:GetInfo() )
				property:SetIdentifier( property:GetIdentifier() )
				
				return property
				
			end;
			
			GetPropertyFromDoor = function( door )
				
				for k,v in pairs( santosRP.Property.GetPropertyTable( ) ) do
					for k2,v2 in pairs( v:GetDoorData() ) do
						for k3,v3 in pairs( v2 ) do
							if v3 == door then
								return v
							end
						end
					end
				end
				
				return nil
				
			end;
			
			UpdateDoorDraws = function(self)
				for _, property in pairs(santosRP.Property.GetPropertyTable()) do
					local door = property:GetMainDoor()

					local oldDraw = door.Draw
					door.RenderOverride = function(self)
						self:DrawModel()
						if oldDraw then oldDraw() end

						local pos, ang = self:GetPos(), self:GetAngles()

						ang:RotateAroundAxis(ang:Up(), 90) 
						ang:RotateAroundAxis(ang:Forward(), 90)
						santosRP.Property.drawDoorText(door, pos + ang:Up() * 1.25 + ang:Right() * -17.5, ang , .2) --one side

						ang:RotateAroundAxis(ang:Right(), 180) 
						santosRP.Property.drawDoorText(door, pos + ang:Up() * 1.25 + ang:Forward() * -45 + ang:Right() * -17.5, ang , .2) --other side
					end
				end
			end;
			
			drawDoorText = function(door, pos, ang, scale)
			
				if not CLIENT then return end
			
				cam.Start3D2D(pos, ang , scale)
					surface.SetFont("SRP_Font64")
					surface.SetTextColor(Color(200, 200, 200))
					surface.SetTextPos(0, 0)
					surface.DrawText(door:GetOwner() and door:GetOwner():GetName() or "Unowned")

					surface.SetTextPos(0, 60)
					surface.SetFont("SRP_Font24")
					surface.DrawText(door:GetName())
				cam.End3D2D()
			end
		
		};
		
		SetDoorData = function( self, p_aDoorData )
		
			if not p_aDoorData then return false end
			
			self.p_aDoorData = p_aDoorData
			return true
			
		end;
		
		GetDoorData = function( self )
		
			return self.p_aDoorData
			
		end;
		
		SetInfo = function( self, p_aInfo )
		
			if not p_aInfo then return false end
			
			self.p_aInfo = p_aInfo
			return true
		
		end;
		
		GetInfo = function( self )
		
			return self.p_aInfo
			
		end;
		
		SetOwner = function( self, p_eOwner )
		
			if not p_eOwner then return false end
			if not p_eOwner:IsPlayer() then return false end
			
			self.p_eOwner = p_eOwner
			
			for k,v in pairs( self:GetDoorData().Other ) do
				v:SetOwner( p_eOwner )
			end
			
			self:GetDoorData().Main:SetOwner( p_eOwner )
			
			hook.Call("SRP PropertyOwnerUpdated", prop)

			return true
			
		end;
		
		RemoveOwner = function( self )
		
			self.p_eOwner = Entity( 0 )
			
			for k,v in pairs( self:GetDoorData().Other ) do
				v:SetOwner( self.p_eOwner )
			end
			
			self:GetDoorData().Main:SetOwner( self.p_eOwner )
			
		end;
		
		HasOwner = function( self )
		
			if not self.p_eOwner or not self.p_eOwner:IsPlayer() or self.p_eOwner:EntIndex() ~= 0 then return false end
			
			return self.p_eOwner
			
		end;
		
		GetMainDoor = function(self)
			return self:GetDoorData()["Main"]
		end;
		
		GetOwner = function( self )
		
			if not self:HasOwner() then return end
			
			return true
			
		end;
		
		SetIdentifier = function( self, p_sIdentifier )
		
			if not p_sIdentifier then return end
			self.p_sIdentifier = p_sIdentifier
		
		end;
		
		GetIdentifier = function( self )
		
			return self.p_sIdentifier
			
		end;
		
		GetName = function( self )
		
			return self:GetInfo().Name or 'No Name'
			
		end;
		
		SetName = function( self, name )
		
			if not name then return end
			self:GetInfo().Name = name
			
		end;	
		
		GetPrice = function( self )
		
			return self:GetInfo().Price or 0
			
		end;
		
		SetPrice = function( self, price )
		
			if not price then return end
			self:GetInfo().Price = price
		
		end;
		
		GetDoorNumber = function( self )
		
			return #self:GetDoorData().Main + #self:GetDoorData().Communal + #self:GetDoorData().Other
			
		end;

		RequestBuy = function(self)	
			if not CLIENT then return end

			net.Start"SRP BuyVehicle"
				net.WriteString(self:GetIdentifier())
			net.SendToServer()
		end;
	
	};
	
	private {
	
		static {
		
			p_aProperties = { }
		
		};
	
		p_sIdentifier = 'house_name';
		p_aInfo 	= { };
		p_aDoorData	= { };
		p_eOwner	= Entity( 0 )
	
	}
	
}

santosRP.Property.LoadProperties()

local _ENTITY = FindMetaTable("Entity")

function _ENTITY:IsDoor()
	if not IsValid(self) then return false end
	local class = self:GetClass()

	if class == "func_door" or
		class == "func_door_rotating" or
		class == "prop_door_rotating" or
		class == "prop_dynamic" then
		return true
	end
	return false
end

if SERVER then
	util.AddNetworkString"SRP BuyProperty"

	net.Receive("SRP BuyProperty", function(len, ply)
		local prop = santosRP.Property.GetProperty(net.ReadString())

		if prop:HasOwner() then ply:AddNote"Already owned!" return end

		if ply:GetBankMoney() < prop:GetPrice() then
			ply:AddNote"Insufficient funds on your bank account!"
			return
		end

		ply:AddBankMoney(-prop:GetPrice())
		prop:SetOwner(ply)
	end)

	function _ENTITY:Lock( ply )
		if not self:IsDoor() then return end
		if not santosRP.Property.GetPropertyFromDoor( self ):GetOwner() == ply then return end
		self:Fire("lock", "", 0)
	end
	
	function _ENTITY:UnLock( ply )
		if not self:IsDoor() then return end
		if not santosRP.Property.GetPropertyFromDoor( self ):GetOwner() == ply then return end
		self:Fire("unlock", "", 0)
	end

end

--- Just some property creation stuff

if not santosRP.isBeta then return end
if not CLIENT then return end --allow more than one person to do this, then upload them

local property

concommand.Add('santosrp_property_new', function( )

	property = santosRP.Property.new()
	property:GetDoorData()[ 'Main' ] = {}
	property:GetDoorData()[ 'Communal' ] = {}
	property:GetDoorData()[ 'Other' ] = {}
	
end)

concommand.Add('santosrp_property_name', function( ply,_,args)
	if not property then return end
	property:SetName( args[1] )
end)

concommand.Add('santosrp_property_identifier', function( ply,_,args)
	if not property then return end
	property:SetIdentifier( args[1] )
	santosRP.Property.GetPropertyList()[ args[1] ] = property -- only allow saving after name has been set
end)

concommand.Add('santosrp_property_door_main',function( )
	if not property then return end
	table.insert( property:GetDoorData()[ 'Main' ] , LocalPlayer():GetEyeTrace().Entity )
end)

concommand.Add('santosrp_property_door_communal',function( )
	if not property then return end
	table.insert( property:GetDoorData()[ 'Communal' ] , LocalPlayer():GetEyeTrace().Entity )
end)

concommand.Add('santosrp_property_door_other',function( )
	if not property then return end
	table.insert( property:GetDoorData()[ 'Other' ] , LocalPlayer():GetEyeTrace().Entity )
end)

concommand.Add('santosrp_property_name',function( ply, _, args )
	if not property then return end
	property:SetName( args[1] )
end)

concommand.Add('santosrp_property_price',function( ply, _, args )
	if not property then return end
	property:SetPrice( args[1] )
end)

concommand.Add('santosrp_property_save', function()
	if not property then return end
	santosRP.Property.SaveProperty( property )
	property = nil
end)
	