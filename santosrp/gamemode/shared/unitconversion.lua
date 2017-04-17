local Measure = {
	M 	= 52.49344,
	KM 	= 52493.44,
	AU 	= 7852906865466.24,
	LY 	= 496626287418591869.952,
}

local abs 	= math.abs
local floor = math.floor

function ConvertUnits(Number)
	Number = abs(Number)
	
	if (Number*10 < Measure.M) then
		return floor(Number*100)/100,"Units"
	elseif (Number*10 < Measure.KM) then
		return floor(Number/Measure.M*100)/100,"M"
	elseif (Number*10 < Measure.AU) then
		return floor(Number/Measure.KM*100)/100,"KM"
	elseif (Number*10 < Measure.LY) then
		return floor(Number/Measure.AU*100)/100,"AU"
	else
		return floor(Number/Measure.LY*100)/100,"LY"
	end
end

function ConvertUnitsToKM(Number)
	Number = abs(Number)
	return floor(Number/Measure.KM*100)/100,"KM"
end

function CommaInteger(int)
  local formatted = int
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end