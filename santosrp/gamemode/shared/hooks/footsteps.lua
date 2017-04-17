function GM:PlayerFootstep( pl, pos, ft, sound, vol, filter )
	if (CLIENT and MAIN_MOVIEMODE and pl == LocalPlayer()) then return true end
end