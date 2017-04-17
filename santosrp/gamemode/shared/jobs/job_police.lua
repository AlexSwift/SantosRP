local JOB = santosRP.Jobs.new()

JOB:SetName( 'Police Officer' )
JOB:ExtendLoadout( 'Citizen', { 'weapon_pistol', 'weapon_handcuffs' } )
JOB:SetPay( 1600 )
JOB:SetColor( Color(100,160,255) )
JOB:SetVehicle( 'ECPD Dodge Charger Hellcat' )
JOB:SetVehicleSpawnPoint( 'santosrp_point_car_police' )

JOB:Register()

return JOB