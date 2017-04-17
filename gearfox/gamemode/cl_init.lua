
include( "shared.lua" )

GM.UseMawChat 		= true
GM.UseMawBlockCHud 	= true
GM.UseMawSun		= false

function GM:Initialize()
end

function GM:ShouldDrawLocalPlayer()
	return (!IsFirstPerson())
end

function GM:CallScreenClickHook()
end

