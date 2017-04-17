
local char = string.byte

function IsEnglish(sentence)
	sentence = string.gsub(sentence," ","")
	local Len = string.len(sentence) 
	
	if (Len < 1) then return false end
	
	for i = 1,Len do
		local B = char(sentence,i,i)
		if not ((B >= 65 and B <= 90) or (B >= 97 and B <= 122)) then
			return false
		end
	end
	
	return true
end