local meta = FindMetaTable("Player")

function meta:IsInCar()
	return (IsValid(self:GetVehicle()))
end

function meta:GetHunger()
	return self.Hunger or 100
end

function meta:GetBankMoney()
	return self.bank_money or 0
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

function meta:GetMoney()
	return self.money or 0
end

function meta:GetRPName()
	return self.RPName or "[NoRPName]"..self:Nick(), self.RPName ~= nil
end

function meta:GetJobModel()
	local CurMdl = self.SelectedModel
	
	if (!self.Job or !santosRP.Jobs.GetJob( self.Job )) then return CurMdl end
	
	local Ab = string.Explode("/",CurMdl)
	Ab = Ab[#Ab]
	
	return santosRP.Jobs.GetJob( self.Job ):GetModel() .. Ab
end

function meta:GetJobColor()
	return santosRP.Jobs.GetJob( self.Job or 'Citizen' ):GetColor() or MAIN_GREYCOLOR
end