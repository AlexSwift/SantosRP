local JOB = santosRP.Jobs.new()

JOB:SetName( 'Paramedic' )
JOB:ExtendLoadout( 'Citizen', { 'weapon_medkit', 'weapon_dribrillator' } )
JOB:SetPay( 1500 )
JOB:SetColor( Color(255,100,160) )
JOB:SetVehicle( 'GMC C5500 Ambulance' )
JOB:SetVehicleSpawnPoint( 'santosrp_point_car_paramedic' )

JOB:Register()

return JOB