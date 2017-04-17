
function GM:ShowHelp(pl)
	pl:SendLua( "GM:ShowHelp()" )
end


function GM:ShowSpare1(pl)
	pl:SendLua( "GM:ShowSpare1()" )
end


function GM:ShowTeam(pl)
	pl:SendLua( "GM:ShowTeam()" )
	UpdateOrganizationList(pl)
end