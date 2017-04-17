

local Prefix = {
	" ",
	"Kilo",
	"Million",
	"Billion",
	"Trillion",
}

function ConvertNumber(Number)
	local Pref = 1
	
	while (Number > 1000 and Pref < 5) do
		Number = math.floor(Number/1000)
		Pref = Pref+1
	end
	
	return Number,Prefix[Pref]
end