local JOB = santosRP.Jobs.new()

JOB:SetName( 'Citizen' )
JOB:SetPay( 0 )
JOB:SetLoadout {
	"weapon_srphands",
	"weapon_fists",
	--"weapon_fishingpole",
	"weapon_srpkeys",
	"weapon_calendar",
	"weapon_phone",
}

JOB:Register()

return JOB