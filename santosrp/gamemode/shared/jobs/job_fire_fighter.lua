local JOB = santosRP.Jobs.new()

JOB:SetName( 'Fire Fighter' )
JOB:ExtendLoadout( 'Citizen', { 'weapon_fire_extinguisher', 'weapon_fireaxe' } )
JOB:SetPay( 1400 )
JOB:SetColor( Color(255,200,100) )
JOB:SetModel("models/fearless/fireman2.mdl")

JOB:Register()

return JOB