local JOB = santosRP.Jobs.new()

JOB:SetName( 'Bus Driver' )
JOB:ExtendLoadout( 'Citizen', { } )
JOB:SetPay( 800 )
JOB:SetColor( Color(100,220,250) )
JOB:SetModel("models/player/nypd/male_02.mdl")

JOB:Register()

return JOB