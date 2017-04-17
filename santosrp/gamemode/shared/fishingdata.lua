
local Fish = table.Copy(santosRP.Items.GetAllFish())

table.SortByMember(Fish,"Chance",true)

function GetRandomFish()
	local Chance = math.Rand(0,1)
	
	for k,v in pairs(Fish) do
		if (Chance < v.Chance) then return v end
	end
	
	return nil
end

function GetFishByModel(model)
	for i = 1,#Fish do 
		if (Fish[i].Model == model) then return Fish[i] end
	end
end

function GetFishTable()
	return Fish
end