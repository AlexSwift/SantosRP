AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:Initialize()
	
	resource.AddDir("models/santosrp")
	
	resource.AddDir("materials/santosrp")
	resource.AddDir("materials/models/santosrp")
	
	resource.AddDir("sound/santosrp")
	
	resource.AddDir("data/srpvehicles")
	resource.AddDir("data/VehController/Scripts_VCMod1")
	
	resource.AddFile("resource/fonts/Carre.ttf")
	
	-- Client Workshop Files [REQUIRES FUTURE CLEANUP]
	resource.AddWorkshop("238855334") -- Obama
	resource.AddWorkshop("323185781") -- COD:BO2
	resource.AddWorkshop("107411755") -- FBI
	resource.AddWorkshop("293036066") -- Fireman
	resource.AddWorkshop("201961855") -- Ambulance
	resource.AddWorkshop("213181442") -- Mobile Computing Pack
	resource.AddWorkshop("258999371") -- Suburban/Tahoe
	resource.AddWorkshop("263574779") -- Chevrolet Impala
	resource.AddWorkshop("163521815") -- TDM Bus
	resource.AddWorkshop("195151749") -- Tiny Money
	resource.AddWorkshop("274555791") -- Suits & Robbers
	resource.AddWorkshop("229256924") -- StreamURL
	resource.AddWorkshop("328735094") -- Rockford Map
	resource.AddWorkshop("328735857") -- Rockford Models/Materials
	resource.AddWorkshop("311241022") -- NYPD Cops
	resource.AddWorkshop("323285641") -- GTA V Vehicles
	resource.AddWorkshop("126921199") -- Aston Martin
	resource.AddWorkshop("113120185") -- Audi
	resource.AddWorkshop("112606459") -- TDM Base
	resource.AddWorkshop("113118541") -- BMW
	resource.AddWorkshop("119146471") -- Bugatti
	resource.AddWorkshop("126920533") -- Cadillac
	resource.AddWorkshop("113997239") -- Chevrolet
	resource.AddWorkshop("176984840") -- Chrysler
	resource.AddWorkshop("114000337") -- Citroen
	resource.AddWorkshop("286998866") -- Volvo
	resource.AddWorkshop("209683096") -- Honda
	resource.AddWorkshop("114001545") -- Dodge
	resource.AddWorkshop("349281554") -- Emergency Vehicles
	resource.AddWorkshop("119148996") -- Ferrari
	resource.AddWorkshop("113999373") -- Ford
	resource.AddWorkshop("120766823") -- GMC
	resource.AddWorkshop("234464092") -- Holden
	resource.AddWorkshop("120765874") -- Hudson
	resource.AddWorkshop("230680318") -- Land Rover
	resource.AddWorkshop("233934024") -- Mazda
	resource.AddWorkshop("217264937") -- McLaren
	resource.AddWorkshop("131246684") -- Mercedes
	resource.AddWorkshop("123455501") -- Mini
	resource.AddWorkshop("131243694") -- Mitsubishi
	resource.AddWorkshop("225810491") -- Multi Brand
	resource.AddWorkshop("195481065") -- Murica Truck pack
	resource.AddWorkshop("123455885") -- Nissan
	resource.AddWorkshop("254930849") -- Pagani
	resource.AddWorkshop("259899351") -- Porsche
	resource.AddWorkshop("261961088") -- Scion
	resource.AddWorkshop("303809753") -- Shelby 1000
	resource.AddWorkshop("266504181") -- Subaru
	resource.AddWorkshop("272988660") -- Vauxhall
	resource.AddWorkshop("123456202") -- Volkswagen
	resource.AddWorkshop("131245637") -- Toyota
	resource.AddWorkshop("221198333") -- Hummer
	resource.AddWorkshop("224183198") -- Jeep
	resource.AddWorkshop("226435666") -- Kia
	resource.AddWorkshop("119148120") -- Lamborghini
	resource.AddWorkshop("340445374") -- Gmod Vehicle Bundle
	-- Photon Essentials
	resource.AddWorkshop("339648087") -- Photon Lighting (For Client Resources Only)
	resource.AddWorkshop("385710680") -- [Photon] Evo City Police: 2015 Dodge Charger
	resource.AddWorkshop("376952257") -- 2015 Dodge Charger RT Hellcat
	resource.AddWorkshop("339684760") -- [Photon] Taurus Skin
	resource.AddWorkshop("198738919") -- Taurus Model
	resource.AddWorkshop("151171713") -- [LW] Police Stuff
	resource.AddWorkshop("258999371") -- [LW] Chevrolet Suburban/Tahoe Pack
	resource.AddWorkshop("263574779") -- [LW] Chevrolet Impala Package
	resource.AddWorkshop("339706423") -- [Photon] NYPD Impala Pack
	resource.AddWorkshop("266579667") -- [LW] Shared Textures
	resource.AddWorkshop("340514604") -- [Photon] Chevy Tahoe Police
	resource.AddWorkshop("340937730") -- [Photon] Crown Victoria Police Interceptor
	resource.AddWorkshop("144415557") -- Ford Crown Victoria Police Package
	resource.AddWorkshop("342286975") -- [Photon] Chicago Police Chevy Suburban Pack
	resource.AddWorkshop("227607345") -- [LW] Volvo S60 R
	resource.AddWorkshop("142628859") -- Driver SF police props
end
	
function GM:PlayerInitialSpawn(pl)
end

function GM:PlayerSpawn(pl)
	
	if (!pl.SelectedModel) then 
		pl:SetNoDraw(true) 
		return 
	end
	
	pl:SetNoDraw(false) 
	
	santosRP.Jobs.GetJob( pl.Job or 'Citizen' ):Loadout( pl )
	
	pl:SetHunger(100)

	pl:SetWalkSpeed(180)
	pl:SetRunSpeed(240)
	
	pl:SetModel(pl:GetJobModel())
	
	pl:InitializeHands("male07")
end

function GM:PlayerAuthed( pl, steamid, uniqueid )
end

function GM:PlayerCanHearPlayersVoice(pl1,pl2)
	return true
end 

function GM:PropBreak( att, prop )
	prop:Remove()
end

function GM:DoPlayerDeath(pl)
	pl:CreateRagdoll()
	CreateNLRZone(pl:GetPos(),1000,pl,300)
end

function GM:CanPlayerSuicide(pl)
	return false
end

function GM:GetFallDamage ( Player, flFallSpeed )
	return math.Clamp(flFallSpeed / 10, 10, 100);
end

function GM:ScalePlayerDamage ( Player, HitGroup, DmgInfo )
	if (Player:Alive()) then
		if (HitGroup == HITGROUP_HEAD) then
			DmgInfo:ScaleDamage(2);
			--if Player:MaleSex() then
				MoanFile = Sound("vo/npc/male01/ow0"..math.random(1, 2)..".wav");
			--else
				--MoanFile = Sound("vo/npc/female01/ow0"..math.random(1, 2)..".wav");
			--end;				
		elseif (HitGroup == HITGROUP_CHEST or HitGroup == HITGROUP_GENERIC) then
			--if Player:MaleSex() then
				MoanFile = Sound("vo/npc/male01/hitingut0"..math.random(1, 2)..".wav");
			--else
				--MoanFile = Sound("vo/npc/female01/hitingut0"..math.random(1, 2)..".wav");
			--end;
		elseif (HitGroup == HITGROUP_LEFTARM or HitGroup == HITGROUP_RIGHTARM) then
			--if Player:MaleSex() then
				MoanFile = Sound("vo/npc/male01/myarm0"..math.random(1, 2)..".wav");
			--else
				--MoanFile = Sound("vo/npc/female01/myarm0"..math.random(1, 2)..".wav");
			--end;
		elseif (HitGroup == HITGROUP_GEAR) then
			--if Player:MaleSex() then
				MoanFile = Sound("vo/npc/male01/startle0"..math.random(1, 2)..".wav");
			--else
				--MoanFile = Sound("vo/npc/female01/startle0"..math.random(1, 2)..".wav");
			--end;
		elseif (HitGroup == HITGROUP_RIGHTLEG or HitGroup == HITGROUP_LEFTLEG) then			
				--if Player:MaleSex() then
					MoanFile = Sound('vo/npc/male01/myleg0' .. math.random(1, 2) .. '.wav');
				--else
					--MoanFile = Sound('vo/npc/female01/myleg0' .. math.random(1, 2) .. '.wav');
				--end;
		else
			--if Player:MaleSex() then
				MoanFile = Sound("vo/npc/male01/pain0"..math.random(1, 9)..".wav");
			--else
				--MoanFile = Sound("vo/npc/female01/pain0"..math.random(1, 9)..".wav");
			--end;
		end;
		
		sound.Play(MoanFile, Player:GetPos(), 100, 100);
	end;
	
	return DmgInfo;
end

function GM:PlayerDeath ( Player, Inflictor, Killer )
	if (Inflictor && Inflictor:IsVehicle()) then
		Player.RespawnTime = CurTime() + 10;
		Player:AddNote('You have been rammed by a vehicle. Paramedics will probably not arrive in time to save you.');
	elseif (Inflictor && Inflictor:GetClass() == 'ent_fire') then
		Player.RespawnTime = CurTime() + 10;
		Player:AddNote('You have been knocked unconcious in a fire. Paramedics will probably not arrive in time to save you.');
	elseif Player:WaterLevel() >= 3 then
		Player.RespawnTime = CurTime() + 10;
		Player:AddNote('You have been knocked unconcious underwater. Paramedics will probably not arrive in time to save you.');
	else
		Player.RespawnTime = CurTime() + 100;
	end
end

function GM:PlayerDeathThink ( Player )
	Player.RespawnTime = Player.RespawnTime or 0
	if Player.RespawnTime < CurTime() then
		Player:Spawn()
		Player:AddNote('You have passed away... The paramedics were too slow.')
	end
end

function GM:EntityTakeDamage( entity, dmginfo )
    if (entity:IsValid() and entity.PermaProps) then
			dmginfo:ScaleDamage( 0 )
    end
    return dmginfo
end

local ClientResources = 0;
local function ProcessFolder ( Location )
	local a, b = file.Find(Location .. '/*', "GAME")
	for k,v in pairs(a) do
		local loc = Location
		local OurLocation = string.gsub(loc .. v, 'gamemodes/santosrp/content/', '')
		if string.sub(loc, -2) != 'db' then
			ClientResources = ClientResources + 1;
			resource.AddFile(OurLocation)
		end
	end
	for k, v in pairs(b) do
		local loc = Location .. v .. "/"
		for _, f in pairs(file.Find(loc .. "/*", "GAME")) do
			local OurLocation = string.gsub(loc .. f, 'gamemodes/santosrp/content/', '')
			
			if string.sub(loc, -2) != 'db' then
				ClientResources = ClientResources + 1;
				resource.AddFile(OurLocation)
			end
		end
		ProcessFolder( loc )
	end
end

if game.IsDedicated() then
	ProcessFolder('gamemodes/santosrp/content/models/')
	ProcessFolder('gamemodes/santosrp/content/materials/')
	ProcessFolder('gamemodes/santosrp/content/sound/')
	ProcessFolder('gamemodes/santosrp/content/resource/')
end

function GM:PlayerDisconnected(pl)
	for k,v in pairs(ents.GetAll()) do
		if (v.GetPlayerOwner and v:GetPlayerOwner() == pl) then
			v:Remove()
		end
	end
	
	if (IsValid(pl.Car)) then pl.Car:Remove() end
	
	MsgN(pl:Nick().."'s props have been deleted!")
end