local JOB = santosRP.Jobs.new()

JOB:SetName( 'Mayor' )
JOB:ExtendLoadout( 'Citizen', { } )
JOB:SetPay( 5000 )
JOB:SetColor( Color(255,100,100) )
JOB:SetModel("models/obama/obama.mdl")

JOB:Register()

return JOB