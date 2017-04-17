
local meta = FindMetaTable("Player")

GM.Organizations = {}



if (SERVER) then
	util.AddNetworkString("UpdateOrg")
	util.AddNetworkString("UpdateOrgList")
	util.AddNetworkString("ClearOrgList")
	util.AddNetworkString("RequestCreateOrg")
	
	net.Receive("RequestCreateOrg",function(bit,pl)
		CreateOrganization(net.ReadString(),net.ReadString(),net.ReadColor(),pl)
	end)
	
	function CreateOrganization(name,pass,color,pl)
		if (GAMEMODE.Organizations[name] or !IsValid(pl)) then return end
		color.a = 255
		
		GAMEMODE.Organizations[name] = {
			Name = name,
			Pass = pass,
			Color = color,
			Players = {},
		}
		
		pl:JoinOrganization(name,pass)
		UpdateOrganizationList(pl)
	end
	
	function UpdateOrganizationList(pl)
		if (!IsValid(pl)) then return end
		
		net.Start("ClearOrgList") net.Send(pl)
		
		local c = 0
		for k,v in pairs(GAMEMODE.Organizations) do
			c = c+1
			timer.Simple(c/50,function()
				if (IsValid(pl)) then
					net.Start("UpdateOrgList")
						net.WriteString(v.Name)
						net.WriteColor(v.Color)
						net.WriteUInt(table.Count(v.Players),8)
					net.Send(pl)
				end
			end)
		end
	end
	
	
	function meta:LeaveOrganization()
		local org = GAMEMODE.Organizations[self.Organization]
		
		if (!org) then self:ChatPrint("You don't seem to be a member of any organization.") return end
		
		GAMEMODE.Organizations[self.Organization].Players[self:SteamID()] = nil
		
		if (table.Count(GAMEMODE.Organizations[self.Organization].Players) < 1) then
			GAMEMODE.Organizations[self.Organization] = nil
		end
		
		self:UpdateOrganization()
		
		self.Organization = nil
		
	end

	function meta:JoinOrganization(orgname,pass)
		if (self.Organization) then self:LeaveOrganization() end
		
		local org = GAMEMODE.Organizations[orgname]
		
		if (!org) then self:ChatPrint(orgname.." does not exist.") return end
		if (org.Pass != pass) then self:ChatPrint("Wrong password!") return end
		
		self.Organization = orgname
		GAMEMODE.Organizations[orgname].Players[self:SteamID()] = self:Nick()
		
		self:UpdateOrganization()
	end
	
	function meta:UpdateOrganization(pl)
		if (self.Organization) then
			net.Start("UpdateOrg")
				net.WriteEntity(self)
				net.WriteBit(util.tobool(self.Organization))
				net.WriteString(self.Organization)
			if (IsValid(pl)) then net.Send(pl)
			else net.Broadcast() end
		end
	end
else
	net.Receive("ClearOrgList",function() GAMEMODE.Organizations = {} end)
	
	net.Receive("UpdateOrgList",function()
		local Name = net.ReadString()
		
		GAMEMODE.Organizations[Name] = GAMEMODE.Organizations[Name] or {}
		GAMEMODE.Organizations[Name].Name = Name
		GAMEMODE.Organizations[Name].Color = net.ReadColor()
		GAMEMODE.Organizations[Name].NumPlayers = net.ReadUInt(8)
		
		UpdateOrganizationList()
	end)
	
	net.Receive("UpdateOrg",function()
		local pl = net.ReadEntity()
		
		if (util.tobool(net.ReadBit())) then
			pl.Organization = net.ReadString()
		else
			pl.Organization = nil
		end
	end)
	
	function RequestCreateOrganization(name,password,color)
		net.Start("RequestCreateOrg")
			net.WriteString(name)
			net.WriteString(password)
			net.WriteColor(Color(color.r,color.g,color.b)) --Bruteforcing this shit... Color can either be table or color apparently.
		net.SendToServer()
	end
end

function GetOrganizations()
	return GAMEMODE.Organizations
end

function meta:GetOrganization()
	return self.Organization
end
					