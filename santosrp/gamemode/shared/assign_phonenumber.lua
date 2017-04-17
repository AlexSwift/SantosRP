
local meta = FindMetaTable("Player")


function meta:GetPhonenumber()
	if (!self.PhoneNumber) then
		math.randomseed(tonumber(self:SteamID64()))
		self.PhoneNumber = math.random(10^9,10^9 * 9)
		math.randomseed(os.time())
	end
	
	return self.PhoneNumber
end


