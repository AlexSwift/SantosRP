
--This is just a fix for all the weapons that uses viewmodel specific rendering and etc.


function GM:PreDrawViewModel( vm, pl, wep )
	if (MAIN_MOVIEMODE or LocalPlayer().TakingPicture) then return true end
	if (IsValid(wep) and wep.PreDrawViewModel) then return wep:PreDrawViewModel(vm,pl,wep) end
	
end

function GM:PostDrawViewModel( vm, pl, wep )
	if ( wep.UseHands or !wep:IsScripted() ) then
		local hands = LocalPlayer():GetHands()
		
		if ( IsValid( hands ) ) then
			hands:DrawModel() 
		end

	end
	
	if (wep.PostDrawViewModel) then return wep:PostDrawViewModel(vm,pl,wep) end
end