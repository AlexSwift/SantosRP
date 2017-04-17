

local models = {
	Female = {
		"models/player/Group01/female_01.mdl",
		"models/player/Group01/female_02.mdl",
		"models/player/Group01/female_03.mdl",
		"models/player/Group01/female_04.mdl",
	},
	Male = {
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/male_04.mdl",
		"models/player/Group01/male_05.mdl",
		"models/player/Group01/male_06.mdl",
		"models/player/Group01/male_07.mdl",
		"models/player/Group01/male_08.mdl",
		"models/player/Group01/male_09.mdl",
	}
}


function SelectCharacter(Num,bFemale)
	local Mob = models.Male
	if (bFemale) then Mob = models.Female end
	
	local Count = table.Count(Mob)
	return Mob[Num%Count+1]
end
