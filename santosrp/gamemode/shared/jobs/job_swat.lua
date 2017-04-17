local JOB = santosRP.Jobs.new()

JOB:SetName( 'SWAT' )
JOB:ExtendLoadout( 'Citizen', { 'weapon_pistol', 'weapon_batteringram' } )
JOB:SetPay( 3200 )
JOB:SetColor( Color(50,100,200) )
JOB:SetModel("models/npc/fbi_assault.mdl")

JOB:Register()

return JOB