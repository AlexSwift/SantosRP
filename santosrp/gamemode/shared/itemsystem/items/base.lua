ITEM.Name 			= "SantosRP Base item"
ITEM.Desc 			= "N/A"
ITEM.Class 			= "santosrp_prop_base"
ITEM.Model			= "models/props_combine/breenlight.mdl"
ITEM.Price			= 1
ITEM.Seller			= nil

ITEM.FoodAmount		= nil

ITEM.FishChance		= nil
ITEM.FishScale		= nil
ITEM.FishResistance	= nil

ITEM.WepClass		= nil
ITEM.AmmoClass 		= nil
ITEM.AmmoNum 		= nil

ITEM.Recipe			= nil


function ITEM.OnPrimary(user,tr)
end

function ITEM.OnSecondary(user,tr)
end

function ITEM.OnUse(user)
end

function ITEM.OnBuy( )

	return true --Add item to inventory

end

function ITEM.OnCooked(campfire)
end
