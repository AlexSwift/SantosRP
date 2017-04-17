local JOB = santosRP.Jobs.new()

JOB:SetName( 'Tow Truck Driver' )
JOB:ExtendLoadout( 'Citizen', { } )
JOB:SetPay( 900 )
JOB:SetColor( Color(160,200,60) )

JOB:Register()

return JOB