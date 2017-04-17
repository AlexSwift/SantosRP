
--> Inherited from Old Age 2 scripts made by The Maw. <--

local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetXP")
	util.AddNetworkString("SetupLeveling")
	util.AddNetworkString("SetLevel")

	function meta:AddXP(xp)
		if (!self.xp) then self.xp = 0 end
		if (!self.Level) then self.Level = 1 end
		
		self.xp = self.xp + xp
		
		self:RecalcLevel()
		
		net.Start("SetXP")
			net.WriteEntity(self)
			net.WriteLong(self.xp)
		net.Broadcast() --Think ill be sending this to everyone :)
	end
	
	function meta:SetupPlayer(xp,level)
		net.Start("SetupLeveling")
			net.WriteEntity(self)
			net.WriteLong(xp)
			net.WriteByte(level)
		net.Broadcast()
		
		self.xp 	= xp
		self.Level 	= level
	end
	
	
	
	function meta:RecalcLevel()
		if (!self.xp) then return 1 end
		if (!self.Level) then self.Level = 1 end
		
		local Level = self.Level
		
		repeat
			local XP = 178 + Level^2 * (22*Level)
			
			if (self.xp >= XP) then Level = Level+1 self.xp = self.xp-XP end
		until (self.xp < XP or Level > 90)
		
		if (Level != self.Level) then 
			self:AddNote("Level up! :D")
			self.Level = Level
			
			net.Start("SetLevel")
				net.WriteEntity(self)
				net.WriteByte(self.Level)
			net.Broadcast()
			
			--LEVELUP!
		end
	end
else
	net.Receive("SetXP",function(size) net.ReadEntity().xp = net.ReadLong() end)
	net.Receive("SetLevel",function(size) net.ReadEntity().Level = net.ReadByte() end)
	
	net.Receive("SetupLeveling",function(size)
		local Ply 	= net.ReadEntity()
		
		Ply.xp 		= net.ReadLong()
		Ply.Level 	= net.ReadByte()
	end)
end

function meta:GetXP()
	return self.xp or 0
end

function meta:GetLevel()
	return self.Level or 1
end

function meta:GetRequiredXP()
	local Level = self:GetLevel()
	return (178 + Level^2 * (22*Level))
end
	
	
	
	
	
	