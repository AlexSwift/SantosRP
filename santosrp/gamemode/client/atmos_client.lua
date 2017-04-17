local atmoshud = CreateClientConVar( "atmos_cl_hudeffects", 1, true, false );
local weathereffects = CreateClientConVar( "atmos_cl_weather", 1, true, false );
local RainRadius = CreateClientConVar( "atmos_cl_rainradius", 16, true, false );
local SnowRadius = CreateClientConVar( "atmos_cl_snowradius", 32, true, false );

-- global so that atmos_rain can check it
AtmosStorming = false;
AtmosSnowing = false;

-- lightmap stuff
net.Receive( "atmos_lightmaps", function( len )

	render.RedownloadAllLightmaps();

end );

hook.Add( "InitPostEntity", "atmosFirstJoinLightmaps", function()

	render.RedownloadAllLightmaps();

end );

-- weather stuff, mostly from Disseminate's vein gamemode <3
local AtmosRainSound = nil;
local AtmosThunderSound = nil;
local AtmosRainSoundPlaying = false;
local AtmosThunderSoundPlaying = false;
local AtmosRainSoundLastVolume = 0;
local HUDRainDrops = {};
local HUDRainNextGenerate = 0;
local HUDRainMatID = surface.GetTextureID( "particle/warp_ripple3" );
local nextCloudEmit = 0;
local lightMul = 0;
local lightningStrike = false;
local emiter3d;
local nextThunder = 0;

local thunderSounds = {
	"atmos/thunder/thunder_1.wav",
	"atmos/thunder/thunder_2.wav",
	"atmos/thunder/thunder_3.wav",
	"atmos/thunder/thunder_far_away_1.wav",
	"atmos/thunder/thunder_far_away_2.wav"
};

local mat = CreateMaterial( "WhiteMaterial", "UnlitGeneric", {	-- Necessary to assign color by vertex
	["$basetexture"] = "color/white",
	["$vertexcolor"] = 1,	-- Necessary to assign color by vertex
	["$vertexalpha"] = 1,	-- Necessary to assign alpha to vertex
	["$model"] = 1
} );

local lightning = 
{
	{
		rad = 0,
		segments = {
			Vector(100,0,0),
			Vector(0,100,0),
			Vector(-25,50,0)
		},
		life = 1
	}
}

local RainEffect = false;
local SnowEffect = false;

local function StormThink()

	local origin = LocalPlayer():EyePos();

	-- rain sounds
	if( AtmosRainSound == nil or !AtmosRainSoundPlaying ) then
		
		AtmosRainSound = CreateSound( LocalPlayer(), "atmos/crucial_rumble_rain_nowind.wav" );
		AtmosRainSound:PlayEx( 0, 100 );

		AtmosRainSoundPlaying = true;
		
	end	

	if( atmos_Outside( origin ) and AtmosRainSoundLastVolume != 0.4 ) then
		
		AtmosRainSound:ChangeVolume( 0.4, 1 );
		AtmosRainSoundLastVolume = 0.4;
		
	elseif( !atmos_Outside( origin ) ) then
		
		if( util.IsSkyboxVisibleFromPoint( origin ) and AtmosRainSoundLastVolume != 0.15 ) then
			
			AtmosRainSound:ChangeVolume( 0.15, 1 );
			AtmosRainSoundLastVolume = 0.15;
			
		elseif( !util.IsSkyboxVisibleFromPoint( origin ) and AtmosRainSoundLastVolume != 0 ) then
			
			AtmosRainSound:ChangeVolume( 0, 1 );
			AtmosRainSoundLastVolume = 0;
			
		end
		
	end

	-- rain effect
	if( !RainEffect ) then

		local pos = LocalPlayer():GetPos();

		local drop = EffectData();
		drop:SetOrigin( pos );
		drop:SetMagnitude( 512 );
		drop:SetRadius( RainRadius:GetInt() );

		util.Effect( "atmos_rain", drop );

		RainEffect = true;

	end

	-- thunder sounds
	if( nextThunder < CurTime() ) then

		nextThunder = CurTime() + math.random( 5, 30 );

		local snd = Sound( table.Random( thunderSounds ) );
		
		AtmosThunderSound = CreateSound( LocalPlayer(), snd );
		AtmosThunderSoundPlaying = true;

		if( atmos_Outside( origin ) ) then

			AtmosThunderSound:PlayEx( 1, 100 );

		else

			AtmosThunderSound:PlayEx( 0.6, 80 );

		end

	end

end

local function SnowThink()

	-- snow effect
	if( !SnowEffect ) then

		local pos = LocalPlayer():GetPos();

		local drop = EffectData();
		drop:SetOrigin( pos );
		drop:SetMagnitude( 800 );
		drop:SetRadius( SnowRadius:GetInt() );

		util.Effect( "atmos_snow", drop );

		SnowEffect = true;

	end

end

hook.Add( "Think", "atmosStormThink", function()

	if( !IsValid( LocalPlayer() ) ) then return end

	if( AtmosStorming and weathereffects:GetInt() > 0 ) then
		
		StormThink();

	else
		
		if( AtmosRainSound and AtmosRainSoundPlaying ) then

			AtmosRainSound:FadeOut( 3 );
			AtmosRainSoundPlaying = false;
			AtmosRainSoundLastVolume = 0;

		end

		if( AtmosThunderSound and AtmosThunderSoundPlaying ) then

			AtmosThunderSound:FadeOut( 3 );
			AtmosThunderSoundPlaying = false;

		end

		if( RainEffect ) then

			RainEffect = false;

		end
		
	end

	if( AtmosSnowing and weathereffects:GetInt() > 0 ) then
		
		SnowThink();

	else

		if( SnowEffect ) then

			SnowEffect = false;

		end
		
	end

end );

hook.Add( "HUDPaint", "atmosHUDPaint", function()

	if( !IsValid( LocalPlayer() ) ) then return end
	if( render.GetDXLevel() <= 90 ) then return end
	if( atmoshud:GetInt() < 1 or weathereffects:GetInt() < 1 ) then return end
	if( LocalPlayer():InVehicle() or LocalPlayer():WaterLevel() > 1 ) then return end

	local origin, angles = LocalPlayer():EyePos(), LocalPlayer():EyeAngles();

	if( AtmosStorming and atmos_Outside( origin ) and angles.p < 15 ) then
		
		if( CurTime() > HUDRainNextGenerate ) then
			
			HUDRainNextGenerate = CurTime() + math.Rand( 0.1, 0.4 );
			
			local t = { };
			t.x = math.random( 0, ScrW() );
			t.y = math.random( 0, ScrH() );
			t.r = math.random( 20, 40 );
			t.c = CurTime();
			
			table.insert( HUDRainDrops, t );
			
		end
		
	end
	
	for k, v in pairs( HUDRainDrops ) do
		
		if( CurTime() - v.c > 1 ) then
			table.remove( HUDRainDrops, k );
			continue;
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 * ( 1 - ( CurTime() - v.c ) ) );
		surface.SetTexture( HUDRainMatID );
		surface.DrawTexturedRect( v.x, v.y, v.r, v.r );
		
	end

end );

net.Receive( "atmos_storm", function( len )

	local state = net.ReadFloat();

	if( state == 1 ) then

		AtmosStorming = true;

	else

		AtmosStorming = false;

	end

end );

net.Receive( "atmos_snow", function( len )

	local state = net.ReadFloat();

	if( state == 1 ) then

		AtmosSnowing = true;

	else

		AtmosSnowing = false;

	end

end );

net.Receive( "atmos_message", function( len )

	local tab = net.ReadTable();

	if( #tab > 0 ) then

		chat.AddText( unpack( tab ) );

	end

end );
