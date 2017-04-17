

hook.Add("Initialize","GearFoxInit",function()
	self = GM or GAMEMODE
	
	if (self.UseMawBlockCHud) then
		self:AddBlockCHud("CHudHealth")
		self:AddBlockCHud("CHudBattery")
		self:AddBlockCHud("CHudDamageIndicator")
		self:AddBlockCHud("CHudAmmo")
		self:AddBlockCHud("CHudSecondaryAmmo")
	end
end)
