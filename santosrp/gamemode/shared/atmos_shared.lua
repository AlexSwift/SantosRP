
atmos_enabled = CreateConVar( "atmos_enabled", "1", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Atmos enabled." );
atmos_logging = CreateConVar( "atmos_log", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Turn atmos logging to console on or off." );

atmos_dnc_length = CreateConVar( "atmos_dnc_length", "4320", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration of one day in seconds." );

atmos_weather = CreateConVar( "atmos_weather", "1", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Atmos Weather enabled." );
atmos_weather_chance = CreateConVar( "atmos_weather_chance", "30", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "Chance for bad weather to occur between 1-100." );
atmos_weather_length = CreateConVar( "atmos_weather_length", "480", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration of a storm in seconds." );

atmos_weather_lightstyle = CreateConVar( "atmos_weather_lighting", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Allow weather to change the lighting (can be buggy?)." );

atmos_version = 0.6;
atmos_dev = false;
AtmosURL = "http://steamcommunity.com/sharedfiles/filedetails/?id=185609021";

function atmos_log( ... )

	if( atmos_logging:GetInt() < 1 ) then return end

	print( "[atmos] ".. string.format( ... ) .."\n" );

end

function atmos_Outside( pos )

	if( pos != nil ) then

		local trace = { };
		trace.start = pos;
		trace.endpos = trace.start + Vector( 0, 0, 32768 );
		trace.mask = MASK_BLOCKLOS;
		local tr = util.TraceLine( trace );
		
		if( tr.HitSky ) then return true end

	end
	
	return false;
	
end

function GetTimeOfExistance()
	local Real = CurTime()*0.05 + 1170
	local Time = Real/360*86400
	
	return Time
end

function GetTimeOfDay()
	local Real = CurTime()*0.05 + 1170
	local Time = Real/360*1440
	return Time%1440
end