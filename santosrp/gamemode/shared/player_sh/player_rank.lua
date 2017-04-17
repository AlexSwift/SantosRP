local meta = FindMetaTable("Player")

local RankTranslation = {
	"Guest",
	"VIP",
	"Trial",
	"Mod",
	"Admin",
	"CEO",
	"Developer",
}


--Available permissions: kick, ban, noclip, playerpickup, proppickup, stream
local RankPermissions = {
	["Guest"] = {},
	["VIP"] = {
		"stream",
	},
	["Trial"] = {
		"stream",
		"kick",
	},
	["Mod"] = {
		"stream",
		"kick",
		"ban",
		"slay",
		"goto",
		"noclip",
	},
	["Admin"] = {
		"stream",
		"kick",
		"ban",
		"noclip",
		"slay",
		"goto",
		"playerpickup",
		"proppickup",
	},
	["CEO"] = {
		"stream",
		"kick",
		"ban",
		"noclip",
		"slay",
		"goto",
		"playerpickup",
		"proppickup",
		"timescale",
	},
	["Developer"] = {
		"stream",
		"kick",
		"ban",
		"noclip",
		"slay",
		"goto",
		"playerpickup",
		"proppickup",
		"timescale",
	},
}

if (SERVER) then
	util.AddNetworkString("Rank")

	function meta:SetRank(int,pl)
		self.Rank = math.ceil(int)
		
		net.Start("Rank")
			net.WriteEntity(self)
			net.WriteUInt(self.Rank,8)
		if (IsValid(pl)) then net.Send(pl)
		else net.Broadcast() end
	end
else
	net.Receive("Rank",function() net.ReadEntity().Rank = net.ReadUInt(8) end)
end

function meta:GetRank()
	return self.Rank or 1
end

function TranslateRank(ID)
	return RankTranslation[ID] or RankTranslation[1]
end

function meta:HasPermit(str)
	str = str:lower()
	
	local ab = self:GetRank()
	local tr = TranslateRank(ab)
	
	local permits = RankPermissions[tr]
	
	for k,v in pairs(permits) do
		if (v:lower() == str) then
			return true
		end
	end
end
	
	