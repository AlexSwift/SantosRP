-- most of the code is from rp_industrial17_v1's day and night system by J----
local TIME_NOON			= 12;		-- 12:00pm
local TIME_MIDNIGHT		= 0;		-- 12:00am
local TIME_DAWN_START	= 4;		-- 4:00am
local TIME_DAWN_END		= 6.5;		-- 6:30am
local TIME_DUSK_START	= 17;		-- 5:00pm;
local TIME_DUSK_END		= 19.5;		-- 7:30pm;

local STYLE_LOW			= string.byte( 'a' );		-- style for night time
local STYLE_HIGH		= string.byte( 'm' );		-- style for day time

local NIGHT				= 0;
local DAWN				= 1;
local DAY				= 2;
local DUSK				= 3;
local STORM 			= 4;
local STORM_NIGHT		= 5;

local SKYPAINT =
{
	[DAWN] =
	{
		TopColor		= Vector( 0.2, 0.5, 1 ),
		BottomColor		= Vector( 0.46, 0.65, 0.49 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 1.84,
		StarFade		= 0.0,	-- Do not change!
		StarSpeed 		= 0.02,
		DuskScale		= 1,
		DuskIntensity	= 1,
		DuskColor		= Vector( 1, 0.2, 0 ),
		SunColor		= Vector( 0.2, 0.1, 0 ),
		SunSize			= 2,
	},
	[DAY] =
	{
		TopColor		= Vector( 0.2, 0.49, 1 ),
		BottomColor		= Vector( 0.8, 1, 1 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 1.84,
		StarFade		= 1.5,	-- Do not change!
		StarSpeed 		= 0.02,
		DuskScale		= 1,
		DuskIntensity	= 1,
		DuskColor		= Vector( 1, 0.2, 0 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.34,
	},
	[DUSK] =
	{
		TopColor		= Vector( 0.24, 0.15, 0.08 ),
		BottomColor		= Vector( .4, 0.07, 0 ),
		FadeBias		= 1,
		HDRScale		= 0.36,
		StarScale 		= 0.50,
		StarFade		= 1.50,	-- Do not change!
		StarSpeed 		= 0.0,
		DuskScale		= 1,
		DuskIntensity	= 1.94,
		DuskColor		= Vector( 0.69, 0.22, 0.02 ),
		SunColor		= Vector( 0.90, 0.30, 0.00 ),
		SunSize			= 0.44,
	},
	[NIGHT] =
	{
		TopColor		= Vector( 0.00, 0.00, 0.00 ),
		BottomColor		= Vector( 0.05, 0.05, 0.11 ),
		FadeBias		= 0.1,
		HDRScale		= 0.19,
		StarScale		= 1.50,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.01,
		DuskScale		= 0,
		DuskIntensity	= 0,
		DuskColor		= Vector( 1, 0.36, 0 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.0,
	},
	[STORM] =
	{
		TopColor		= Vector( 0.22, 0.22, 0.22 ),
		BottomColor		= Vector( 0.05, 0.05, 0.07 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 2.0,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.04,
		DuskScale		= 0.0,
		DuskIntensity	= 0.0,
		DuskColor		= Vector( 0.23, 0.23, 0.23 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.1,
	},
	[STORM_NIGHT] =
	{
		TopColor		= Vector( 0.01, 0.01, 0.01 ),
		BottomColor		= Vector( 0.00, 0.00, 0.00 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 2.0,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.04,
		DuskScale		= 0.0,
		DuskIntensity	= 0.0,
		DuskColor		= Vector( 0.23, 0.23, 0.23 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.1,
	}
};

local atmos =
{
	m_InitEntities = false,
	m_OldSkyName = "unknown",
	m_Time = 6.5,
	m_LastPeriod = NIGHT,
	m_LastStyle = '.',
	m_Cloudy = false,
	m_Paused = false,
	m_Storming = false,
	WasSnowing = false,
	m_NextStormCheck = CurTime() + 120,
	m_StormEnd = 0,
	m_LastStormStyle = "h",

	-- to easily hook functions within our own object instance
	Hook = function( self, name )

		local func = self[name];
		local function Wrapper( ... )
			func( self, ... );
		end

		hook.Add( name, string.format( "atmos.%s", tostring( self ), name ), Wrapper );

	end,

	LightStyle = function( self, int, style )

		-- a is too dark for engine.LightStyle, wait for b
		if( style != "a" and !self.m_Storming ) then

			engine.LightStyle( int, style );

			timer.Simple( 0.1, function()
				net.Start( "atmos_lightmaps" );
				net.Broadcast();
			end );

		end

		self.m_LastStyle = style;

	end,

	Initialize = function( self )

		self.m_OldSkyName = GetConVar("sv_skyname"):GetString();

		if( atmos_enabled:GetInt() >= 1 ) then

			RunConsoleCommand( "sv_skyname", "painted" );

			atmos_log( "Forcing sv_skyname to painted" );

		end

		self:Hook( "Think" );

		atmos_log( "Atmos version %s initializing.", tostring( atmos_version ) );

	end,

	InitEntities = function( self )

		self.m_LightEnvironment = ents.FindByClass( "light_environment" )[1];
		self.m_EnvSun = ents.FindByClass( "env_sun" )[1];
		self.m_EnvSkyPaint = ents.FindByClass( "env_skypaint" )[1];
		self.m_RelayDawn = ents.FindByName( "dawn" )[1];
		self.m_RelayDusk = ents.FindByName( "dusk" )[1];
		self.m_RelayCloudy = ents.FindByName( "cloudy" )[1];

		-- put the sun on the horizon initially
		if( IsValid( self.m_EnvSun ) ) then
			self.m_EnvSun:SetKeyValue( "sun_dir", "1 0 0" );
		end

		-- HACK: Fixes prop lighting since the first pattern change fails to update it.
		if( IsValid( self.m_LightEnvironment ) ) then
			self.m_LightEnvironment:Fire( "FadeToPattern", 'a' );
		else
			self:LightStyle( 0, 'b' );
		end

		-- log found entities
		if( IsValid( self.m_LightEnvironment ) ) then
			atmos_log( "Found light_environment" );
		else
			atmos_log( "No light_environment, using engine.LightStyle instead." );
		end

		if( IsValid( self.m_EnvSun ) ) then
			atmos_log( "Found env_sun" );
		end

		if( IsValid( self.m_EnvSkyPaint ) ) then

			atmos_log( "Found env_skypaint" );

		else

			local skyPaint = ents.Create( "env_skypaint" );
			skyPaint:Spawn();
			skyPaint:Activate();

			self.m_EnvSkyPaint = skyPaint;

			atmos_log( "Created env_skypaint" );

		end

		self.m_InitEntities = true;

	end,

	Think = function( self )

		if( atmos_enabled:GetInt() < 1 ) then return end
		if( not self.m_InitEntities ) then self:InitEntities(); end

		if( not self.m_Paused ) then
			self.m_Time = self.m_Time + ( 24 / atmos_dnc_length:GetInt() ) * FrameTime();
			if( self.m_Time > 24 ) then
				self.m_Time = 0;
			end
		end

		-- since our dawn/dusk periods last several hours find the mid point of them
		local dawnMidPoint = ( TIME_DAWN_END + TIME_DAWN_START ) / 2;
		local duskMidPoint = ( TIME_DUSK_END + TIME_DUSK_START ) / 2;

		-- dawn/dusk/night events
		
		if( self.m_Time >= TIME_DUSK_END and IsValid( self.m_EnvSun ) ) then
			if( self.m_LastPeriod ~= NIGHT ) then
				self.m_EnvSun:Fire( "TurnOff", "", 0 );
				
				self.m_LastPeriod = NIGHT;
			end

		elseif( self.m_Time >= duskMidPoint ) then
			if( self.m_LastPeriod ~= DUSK ) then
				if( IsValid( self.m_RelayDusk ) ) then
					self.m_RelayDusk:Fire( "Trigger", "" );
				end

				-- disabled because the clouds at night look pretty awful..
				--self.m_Cloudy = math.random() > 0.5;
				self.m_Cloudy = false;

				-- at dawn select if we should display clouds for night or not (50% chance)
				if( IsValid( self.m_EnvSkyPaint ) ) then
					if( self.m_Cloudy ) then
						self.m_EnvSkyPaint:SetStarTexture( "skybox/clouds" );
					else
						if( !self.m_Storming ) then
							self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );
						end
					end
				end

				self.m_LastPeriod = DUSK;
				
				for k,v in pairs(player.GetAll()) do
					if (v.SelectedModel) then
						santosRP.Jobs.GetJob( v.Job or 'Citizen' ):Payday(v)
					end
				end
				for k,v in pairs(ents.GetAll()) do 
					if v:GetName()=="1" then 
						v:Fire("turnon")
					end 
				end
				
			end

		elseif( self.m_Time >= dawnMidPoint ) then
			if( self.m_LastPeriod ~= DAWN ) then
				if( IsValid( self.m_RelayDawn ) ) then
					self.m_RelayDawn:Fire( "Trigger", "" );
				end

				-- disabled because clouds during transitions looks pretty awful, too
				--self.m_Cloudy = math.random() > 0.5;
				self.m_Cloudy = false;

				-- at dawn select if we should display clouds for day or not (50% chance)
				if( IsValid( self.m_EnvSkyPaint ) ) then
					if( self.m_Cloudy ) then
						self.m_EnvSkyPaint:SetStarTexture( "skybox/clouds" );
						SKYPAINT[DAY].StarFade = 1.5;
					else
						SKYPAINT[DAY].StarFade = 0;
					end
				end

				self.m_LastPeriod = DAWN;
				
				for k,v in pairs(ents.GetAll()) do 
					if v:GetName()=="1" then 
						v:Fire("turnon")
					end 
				end
			end

		elseif( self.m_Time >= TIME_DAWN_START and IsValid( self.m_EnvSun ) ) then
			if( self.m_LastPeriod ~= DAY ) then
				self.m_EnvSun:Fire( "TurnOn", "", 0 );

				self.m_LastPeriod = DAY;
			end

		end

		-- light_environment
		if( IsValid( self.m_LightEnvironment ) ) then
			local frac = 0;

			if( self.m_Time >= dawnMidPoint and self.m_Time < TIME_NOON ) then
				frac = math.EaseInOut( ( self.m_Time - dawnMidPoint ) / ( TIME_NOON - dawnMidPoint ), 0, 1 );
			elseif( self.m_Time >= TIME_NOON and self.m_Time < duskMidPoint ) then
				frac = 1 - math.EaseInOut( ( self.m_Time - TIME_NOON ) / ( duskMidPoint - TIME_NOON ), 1, 0 );
			end

			local style = string.char( math.floor( Lerp( frac, STYLE_LOW, STYLE_HIGH ) + 0.5 ) );

			if( self.m_LastStyle ~= style ) then
				self.m_LightEnvironment:Fire( "FadeToPattern", style );
				self.m_LastStyle = style;
			end
		end

		-- no light_environment, use engine.LightStyle instead?
		if( !IsValid( self.m_LightEnvironment ) ) then
			local frac = 0;

			if( self.m_Time >= dawnMidPoint and self.m_Time < TIME_NOON ) then
				frac = math.EaseInOut( ( self.m_Time - dawnMidPoint ) / ( TIME_NOON - dawnMidPoint ), 0, 1 );
			elseif( self.m_Time >= TIME_NOON and self.m_Time < duskMidPoint ) then
				frac = 1 - math.EaseInOut( ( self.m_Time - TIME_NOON ) / ( duskMidPoint - TIME_NOON ), 1, 0 );
			end

			local style = string.char( math.floor( Lerp( frac, STYLE_LOW, STYLE_HIGH ) + 0.5 ) );

			if( self.m_LastStyle ~= style ) then

				self:LightStyle( 0, style );

			end
		end

		-- env_sun
		if( IsValid( self.m_EnvSun ) ) then
			if( self.m_Time >= TIME_DAWN_START and self.m_Time <= TIME_DUSK_END ) then
				local frac = 1 - ( ( self.m_Time - TIME_DAWN_START ) / ( TIME_DUSK_END - TIME_DAWN_START ) );
				local angle = Angle( -180 * frac, 15, 0 );

				self.m_EnvSun:SetKeyValue( "sun_dir", tostring( angle:Forward() ) );
			end
		end

		-- env_skypaint
		if( IsValid( self.m_EnvSkyPaint ) ) then
			-- env_skypaint doesn't update fast enough.
			if( IsValid( self.m_EnvSun ) ) then
				self.m_EnvSkyPaint:SetSunNormal( self.m_EnvSun:GetInternalVariable( "m_vDirection" ) );
			end

			local cur = NIGHT;
			local next = NIGHT;
			local frac = 0;

			if( self.m_Time >= TIME_DAWN_START and self.m_Time < dawnMidPoint ) then
				cur = NIGHT;
				next = DAWN;
				frac = math.EaseInOut( ( self.m_Time - TIME_DAWN_START ) / ( dawnMidPoint - TIME_DAWN_START ), 0.5, 0.5 );
			elseif( self.m_Time >= dawnMidPoint and self.m_Time < TIME_DAWN_END ) then
				cur = DAWN;
				next = DAY;
				frac = math.EaseInOut( ( self.m_Time - dawnMidPoint ) / ( TIME_DAWN_END - dawnMidPoint ), 0.5, 0.5 );
			elseif( self.m_Time >= TIME_DUSK_START and self.m_Time < duskMidPoint ) then
				cur = DAY;
				next = DUSK;
				frac = math.EaseInOut( ( self.m_Time - TIME_DUSK_START ) / ( duskMidPoint - TIME_DUSK_START ), 0.5, 0.5 );
			elseif( self.m_Time >= duskMidPoint and self.m_Time < TIME_DUSK_END ) then
				cur = DUSK;
				next = NIGHT;
				frac = math.EaseInOut( ( self.m_Time - duskMidPoint ) / ( TIME_DUSK_END - duskMidPoint ), 0.5, 0.5 );
			elseif( self.m_Time >= TIME_DAWN_END and self.m_Time <= TIME_DUSK_END ) then
				cur = DAY;
				next = DAY;
			end

			-- lazy math inbound
			if( atmos_weather:GetInt() > 0 and self.m_NextStormCheck < CurTime() and !self:GetStorming() and ( cur == DAY or cur == DUSK ) ) then

				--atmos_log( "Attempting to start weather" );

				local rnd = math.random( 1, 100 );
				local chance = atmos_weather_chance:GetInt();

				--atmos_log( "rnd = %s\nchance = %s\n", tostring( rnd ), tostring( chance ) );

				if( chance != 0 and rnd <= chance ) then

					self:StartStorm();

				end

				self.m_NextStormCheck = CurTime() + ( 60 * math.random( 1, 5 ) );

			end

			if( self:GetStorming() ) then
				
				local cur = STORM;

				if( ( self.m_Time > TIME_MIDNIGHT and self.m_Time < TIME_DAWN_START ) or ( self.m_Time >= TIME_DUSK_END ) ) then

					cur = STORM_NIGHT;

				end

				self.m_EnvSkyPaint:SetTopColor( SKYPAINT[cur].TopColor );
				self.m_EnvSkyPaint:SetBottomColor( SKYPAINT[cur].BottomColor );
				self.m_EnvSkyPaint:SetSunColor( SKYPAINT[cur].SunColor );
				self.m_EnvSkyPaint:SetDuskColor( SKYPAINT[cur].DuskColor );
				self.m_EnvSkyPaint:SetFadeBias( SKYPAINT[cur].FadeBias );
				self.m_EnvSkyPaint:SetHDRScale( SKYPAINT[cur].HDRScale );
				self.m_EnvSkyPaint:SetDuskScale( SKYPAINT[cur].DuskScale );
				self.m_EnvSkyPaint:SetDuskIntensity( SKYPAINT[cur].DuskIntensity );

				if( !self:GetStorming() ) then

					self.m_EnvSkyPaint:SetSunSize( SKYPAINT[cur].SunSize );

				end

				self.m_EnvSkyPaint:SetStarFade( SKYPAINT[cur].StarFade );
				self.m_EnvSkyPaint:SetStarScale( SKYPAINT[cur].StarScale );
				--self.m_EnvSkyPaint:SetStarSpeed( SKYPAINT[cur].StarSpeed );

				if( self.m_StormEnd < CurTime() ) then

					self:StopStorm();

				end

			else

				self.m_EnvSkyPaint:SetTopColor( LerpVector( frac, SKYPAINT[cur].TopColor, SKYPAINT[next].TopColor ) );
				self.m_EnvSkyPaint:SetBottomColor( LerpVector( frac, SKYPAINT[cur].BottomColor, SKYPAINT[next].BottomColor ) );
				self.m_EnvSkyPaint:SetSunColor( LerpVector( frac, SKYPAINT[cur].SunColor, SKYPAINT[next].SunColor ) );
				self.m_EnvSkyPaint:SetDuskColor( LerpVector( frac, SKYPAINT[cur].DuskColor, SKYPAINT[next].DuskColor ) );
				self.m_EnvSkyPaint:SetFadeBias( Lerp( frac, SKYPAINT[cur].FadeBias, SKYPAINT[next].FadeBias ) );
				self.m_EnvSkyPaint:SetHDRScale( Lerp( frac, SKYPAINT[cur].HDRScale, SKYPAINT[next].HDRScale ) );
				self.m_EnvSkyPaint:SetDuskScale( Lerp( frac, SKYPAINT[cur].DuskScale, SKYPAINT[next].DuskScale ) );
				self.m_EnvSkyPaint:SetDuskIntensity( Lerp( frac, SKYPAINT[cur].DuskIntensity, SKYPAINT[next].DuskIntensity ) );

				if( !self:GetStorming() ) then

					self.m_EnvSkyPaint:SetSunSize( Lerp( frac, SKYPAINT[cur].SunSize, SKYPAINT[next].SunSize ) );

				end

				self.m_EnvSkyPaint:SetStarFade( Lerp( frac, SKYPAINT[cur].StarFade, SKYPAINT[next].StarFade ) );
				self.m_EnvSkyPaint:SetStarScale( Lerp( frac, SKYPAINT[cur].StarScale, SKYPAINT[next].StarScale ) );

				if( cur == NIGHT ) then

					self.m_EnvSkyPaint:SetStarSpeed( 0 );

				end

				--self.m_EnvSkyPaint:SetStarSpeed( SKYPAINT[cur].StarSpeed );

			end

		end

	end,

	TogglePause = function( self )

		self.m_Paused = not self.m_Paused;

	end,

	SetTime = function( self, time )

		self.m_Time = math.Clamp( time, 0, 24 );

		-- FIXME: we're bypassing the sun code
		if( IsValid( self.m_EnvSun ) ) then
			self.m_EnvSun:SetKeyValue( "sun_dir", "1 0 0" );
		end

		-- FIXME: we're bypassing the dusk/dawn events
		if( IsValid( self.m_EnvSkyPaint ) ) then
			self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );
			SKYPAINT[DAY].StarFade = 0;
		end

	end,

	GetTime = function( self )

		return self.m_Time;

	end,

	StartStorm = function( self )

		atmos_log( "Starting weather" );

		--local IsSnow = (math.random(1,2) == 2); -- merry fucking christmas assholes
		local IsSnow = false; -- needs more testing

		if( IsSnow ) then

			self.WasSnowing = true;

		end

		if( ( ( self.m_Time > TIME_MIDNIGHT and self.m_Time < TIME_DAWN_START ) or ( self.m_Time >= TIME_DUSK_END ) ) and IsValid( self.m_EnvSkyPaint ) ) then

			-- do nothing, we are already dark enough

		else

			if( !IsSnow and atmos_weather_lightstyle:GetInt() > 0 ) then

				self:LightStyle( 0, "d" );

			end

		end

		self.m_Storming = true;

		self.m_NextStormCheck = 0;
		self.m_StormEnd = CurTime() + atmos_weather_length:GetInt();

		if( IsValid( self.m_EnvSkyPaint ) ) then
			self.m_Cloudy = true;
			self.m_EnvSkyPaint:SetStarTexture( "skybox/clouds" );
		end

		if( IsValid( self.m_EnvSun ) ) then

			self.m_EnvSun:Fire( "TurnOff", "", 0 );

			if( IsValid( self.m_EnvSkyPaint ) ) then

				self.m_EnvSkyPaint:SetSunSize( 0 );

			end

			atmos_log( "Hiding sun" );

		end

		if( !IsSnow ) then

			net.Start( "atmos_storm" );
				net.WriteFloat( 1 );
			net.Broadcast();

		else

			net.Start( "atmos_snow" );
				net.WriteFloat( 1 );
			net.Broadcast();

		end

	end,

	StopStorm = function( self )

		atmos_log( "Stopping weather" );

		self.m_Storming = false;

		self.m_NextStormCheck = CurTime() + ( 60 * 20 );
		self.m_StormEnd = 0;
		self.m_Cloudy = false;

		if( ( ( self.m_Time > TIME_MIDNIGHT and self.m_Time < TIME_DAWN_START ) or ( self.m_Time >= TIME_DUSK_END ) ) and IsValid( self.m_EnvSkyPaint ) ) then

			self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );

		else

			if( IsValid( self.m_EnvSun ) ) then

				self.m_EnvSun:Fire( "TurnOn", "", 0 );

				if( IsValid( self.m_EnvSkyPaint ) ) then
					
					--self.m_EnvSkyPaint:SetSunSize( SKYPAINT[cur].SunSize );

				end

				atmos_log( "Showing sun" );

			end

		end

		net.Start( "atmos_storm" );
			net.WriteFloat( 0 );
		net.Broadcast();

		if( self.WasSnowing ) then

			net.Start( "atmos_snow" );
				net.WriteFloat( 0 );
			net.Broadcast();

		end

		if( !self.WasSnowing ) then

			local style = self.m_LastStyle;

			if( style == "a" ) then

				style = "b";

			end

			if( atmos_weather_lightstyle:GetInt() > 0 ) then

				self:LightStyle( 0, style );

			end

		end

		self.WasSnowing = false;

	end,

	GetStorming = function( self )

		return self.m_Storming;

	end,
};

-- global handle for debugging
AtmosGlobal = atmos;

hook.Add( "Initialize", "atmosInit", function() 

	atmos:Initialize();

end );

hook.Add( "PlayerInitialSpawn", "atmosInitialSpawn", function( pl )

	net.Start( "atmos_storm" );
		net.WriteFloat( atmos:GetStorming() and 1 or 0 );
	net.Broadcast();

end );

concommand.Add( "atmos_dnc_pause", function( pl, cmd, args )

	if( pl != NULL and !pl:IsSuperAdmin() ) then return end
	
	atmos:TogglePause();

	if( IsValid( pl ) ) then

		pl:PrintMessage( HUD_PRINTCONSOLE, "DNC is " .. (atmos.m_Paused and "paused" or "no longer paused") );

	else

		print( "DNC is " .. (atmos.m_Paused and "paused" or "no longer paused") );

	end

end );

concommand.Add( "atmos_dnc_settime", function( pl, cmd, args )

	if( pl != NULL and !pl:IsSuperAdmin() ) then return end

	atmos:SetTime( tonumber( args[1] or "0" ) );

end );

concommand.Add( "atmos_dnc_gettime", function( pl, cmd, args )

	local time = atmos:GetTime();
	local hours = math.floor( time );
	local minutes = ( time - hours ) * 60;

	if( IsValid( pl ) ) then

		pl:PrintMessage( HUD_PRINTCONSOLE, string.format( "The current time is %s", string.format( "%02i:%02i", hours, minutes ) ) );

	else

		print( string.format( "The current time is %s", string.format( "%02i:%02i", hours, minutes ) ) );

	end

end );

concommand.Add( "atmos_startstorm", function( pl, cmd, args )

	if( pl != NULL and !pl:IsSuperAdmin() ) then return end
	if( atmos:GetStorming() ) then return end

	atmos:StartStorm();

	AtmosMessageAll( Color( 255, 153, 0 ), "[atmos] ", Color( 255, 255, 255 ), string.format( "%s has started a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

	print( string.format( "%s has started a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

end );

concommand.Add( "atmos_stopstorm", function( pl, cmd, args )

	if( pl != NULL and !pl:IsSuperAdmin() ) then return end
	if( !atmos:GetStorming() ) then return end

	atmos:StopStorm();

	AtmosMessageAll( Color( 255, 153, 0 ), "[atmos] ", Color( 255, 255, 255 ), string.format( "%s has stopped a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

	print( string.format( "%s has stopped a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );
	
end );

function AtmosMessage( pl, ... )

	net.Start( "atmos_message" );
		net.WriteTable( { ... } );
	net.Send( pl );

end

function AtmosMessageAll( ... )

	net.Start( "atmos_message" );
		net.WriteTable( { ... } );
	net.Broadcast();

end

-- Net 
util.AddNetworkString( "atmos_cvar" );
util.AddNetworkString( "atmos_lightmaps" );
util.AddNetworkString( "atmos_storm" );
util.AddNetworkString( "atmos_snow" );
util.AddNetworkString( "atmos_message" );

