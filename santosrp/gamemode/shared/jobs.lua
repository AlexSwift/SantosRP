santosRP = santosRP or {}

class 'santosRP.Jobs' {

	public {
	
		static {
		
			j_aJobs = { };
		
			LoadJobs = function( )
			
				print( 'Loading Jobs' )
				
				include( GM.Folder:gsub("gamemodes/","") .. "/gamemode/shared/jobs/job_citizen.lua" )
				AddCSLuaFile( GM.Folder:gsub("gamemodes/","") .. "/gamemode/shared/jobs/job_citizen.lua" )
			
				local jobs = file.Find( GM.Folder:gsub("gamemodes/","") .. "/gamemode/shared/jobs/*.lua","LUA")
				
				for k,v in pairs( jobs ) do
				
					if v == 'job_citizen.lua' then continue end
				
					if SERVER then 
						AddCSLuaFile( GM.Folder:gsub("gamemodes/","") .. "/gamemode/shared/jobs/" .. v )
					end
				
					local JOB = CompileFile( GM.Folder:gsub("gamemodes/","") .. "/gamemode/shared/jobs/" .. v, 'Job Loading')()
					
					local ENT = { }
					ENT.Base = "santosrp_npc_base"
					ENT.Job = JOB:GetName()
					
					scripted_ents.Register( ENT, "santosrp_npc_job_" .. string.lower( string.Replace( ENT.Job, " ", "_" ) ) )
					
				end
				
				print( 'Jobs Loaded' )
				
			end;
			
			GetJobs = function( )
			
				return santosRP.Jobs.j_aJobs
				
			end;
			
			GetJob = function( j_sJob )
			
				if not santosRP.Jobs.GetJobs()[ j_sJob ] then return end
				
				return santosRP.Jobs.GetJobs()[ j_sJob ]
				
			end;
				
		
		};
		
		Extends = function( self, j_sJob )
		
			self = table.copy( santosRP.Jobs.GetJob( j_sJob ) )
			
		end;
		
		ExtendLoadout = function( self, j_sJob, j_aLoadout )
		
			if not santosRP.Jobs.GetJob( j_sJob ) then
			
				self:SetLoadout( j_aLoadout )
				
				return
			
			end
		
			local j_aLoadout_e = table.Copy( santosRP.Jobs.GetJob( j_sJob ):GetLoadout() )
			
			for k,v in pairs( j_aLoadout ) do
				table.insert( j_aLoadout_e, v )
			end
			
			self:SetLoadout( j_aLoadout_e )
			
		end;
		
		Loadout = function( self, ply )
		
			ply:StripWeapons( )
			
			for k,v in pairs( self:GetLoadout() ) do
				ply:Give( v )
			end
		
		end;
		
		Payday = function( self, ply )
		
			local Money = self.j_iPay or 500
			local Paycheck = math.random(Money,Money+100)
			ply:AddBankMoney(Paycheck)
			ply:ChatPrint("You received a paycheck of $"..Paycheck..". You can collect them from the bank!")
			ply:AddNote("You received a paycheck of $"..Paycheck..".")
			ply:AddNote("You can collect them from any bank!")
		
		end;
		
		SetName = function( self, j_sName )
		
			if not isstring(j_sName) then return end
			self.j_sName = j_sName
			
		end;
		
		GetName = function( self )
		
			return self.j_sName
			
		end;
		
		SetPay = function( self, j_iPay )
		
			if not isnumber(j_iPay) then return end
			if j_iPay < 0 then return end
			self.j_iPay = j_iPay
			
		end;
		
		GetPay = function( self )
		
			return self.j_iPay
			
		end;
		
		SetModel = function( self, j_sModel )
			
			if not isstring(j_sModel) or not util.IsValidModel(j_sModel) then return end
			self.j_sModel = j_sModel
			
		end;
		
		GetModel = function( self )
		
			return self.j_sModel
			
		end;
		
		SetLoadout = function( self, j_aLoadout )
		
			if istable(j_aLoadoutthen) then return end
			for k,v in pairs( j_aLoadout ) do
				if type( v ) ~= 'string' then return end
				continue
			end
			
			self.j_aLoadout = j_aLoadout
			
		end;
		
		GetLoadout = function( self )
		
			return self.j_aLoadout
			
		end;
		
		GetColor = function( self )
		
			return self.j_cColor
			
		end;
		
		SetColor = function( self, j_cColor )
		
			if not IsColor(j_cColor) then return end
			
			self.j_cColor = j_cColor
			
		end;
		
		GetVehicle = function( self )	
		
			return self.j_sVehicle
			
		end;
		
		SetVehicle = function( self, j_sVehicle )
			
			if not j_sVehicle then return end
			self.j_sVehicle = j_sVehicle
			
		end;
		
		GetVehicleSpawnPoint = function( self )	
		
			return self.j_sVSPoint
			
		end;
		
		SetVehicleSpawnPoint = function( self, j_sVSPoint )
			
			if not j_sVSPoint then return end
			self.j_sVSPoint = j_sVSPoint
			
		end;
		
		RequestSetJob = function()
		
			if not CLIENT then return end
		
			net.Start("RequestSetJob")
			net.SendToServer()
			
		end;
		
		RequestQuitJob = function()
		
			if not CLIENT then return end
		
			net.Start("RequestQuitJob")
			net.SendToServer()
			
		end;
		
		OpenDialog = function( self )
			
			if not CLIENT then return end

			local sw,sh = ScrW(),ScrH()
			local x,y   = sw/2-300,sh/2
			local width = 600
		
			self.j_gMenu = vgui.Create("SRPFrame")
			self.j_gMenu:SetPos(x,y)
			self.j_gMenu:SetWide(width)
			self.j_gMenu:SetTitle( self:GetName() )
			self.j_gMenu:ShowCloseButton(false)
			self.j_gMenu:MakePopup()
			
			local options = {}
			if LocalPlayer().Job ~= self.j_sName then
				options = self.j_aDialogs[ 1 ]
			elseif LocalPlayer().Job == self.j_sName then
				options = self.j_aDialogs[ 2 ]
			end
			
			local a = 0
			for k,v in pairs( options ) do
				a = a+1
				local b = vgui.Create("SRPButton",self.j_gMenu)
				b:SetText(v.text)
				b:SetPos(0,60*a)
				b:SetSize(width,50)
				b.Paint = function(s,W,H)
					if (s.Hovered) then DrawSRPBox(0,0,W,H,MAIN_GREENCOLOR,MAIN_COLOR2)
					else DrawSRPBox(0,0,W,H,MAIN_COLOR,MAIN_COLOR2) end
					DrawText(s.Text,"Trebuchet18",W/2,H/2,MAIN_WHITECOLOR,1)
				end
				
				b.DoClick = function() v.func( self ) end
				self.j_gMenu:SetTall(65+60*a)
			end
			
			self.j_gMenu:SetVisible(true)
		end;
		
		CloseDialog = function( self )
		
			self.j_gMenu:Remove()
			
		end;
		
		j_gMenu		= { };
	
	};
	
	protected {
	
		Register = function( self )
		
			print( 'Loading ' .. self:GetName() )
		
			santosRP.Jobs.j_aJobs[ self:GetName( ) ] = self
		
		end;
	
	};
	
	private {
	
		j_sName		= '';
		j_iPay		= 0;
		j_sModel	= 'models/player/Group01/'; --Maybe add the options for multiple models, will tie in to the character player models
		j_aLoadout	= { };
		j_cColor	= Color( 255,255,255,255 );
		j_sVehicle	= '';
		j_sVSPoint	= '';
		j_aDialogs	= {
			[1] = {
				[1] = { text = "I'd like to sign up please!", func =function( self ) if (IsValid( self.j_gMenu)) then self:RequestSetJob() self:CloseDialog() end end },
				[2] = { text = "Nevermind", func = function( self ) if (IsValid( self.j_gMenu)) then self:CloseDialog() end end}
			},
			[2] = {
				[1] = { text = "Spawn Vehicle", func = function( self ) if (IsValid( self.j_gMenu )) then santosRP.Vehicles.RequestSpawnVehicle( self:GetVehicle(), Color(255,255,255,255), self:GetVehicleSpawnPoint() ) self:CloseDialog() end end},
				[2] = { text = "I quit!", func = function( self ) if (IsValid( self.j_gMenu )) then self:RequestQuitJob() self:CloseDialog() end end},
				[3] = { text = "Nevermind",func = function( self ) if (IsValid( self.j_gMenu)) then self:CloseDialog() end end}
			}
		};
	
	};
}

local _PLAYER = FindMetaTable( 'Player' )

if CLIENT then

	net.Receive("SetJob",function()
		local pl = net.ReadEntity()
		local job = net.ReadString()
		
		pl.Job = job
	end)
	
else

	util.AddNetworkString("SetJob")
	util.AddNetworkString("RequestSetJob")
	util.AddNetworkString("RequestQuitJob")

	net.Receive("RequestSetJob",function(bit,pl)
		if (IsValid(pl.TalkingNPC) and pl.TalkingNPC.Job) then
			pl:SetJob(pl.TalkingNPC.Job) 
		end
	end)
	
	net.Receive("RequestQuitJob",function(bit,pl) 
		if (IsValid(pl.TalkingNPC) and pl.TalkingNPC.Job == pl.Job) then
			pl:SetJob("Citizen") 
		end
	end)
	
	function _PLAYER:SetJob(Job)
	
		if (self.Job == Job) then return end --Why bother doing all this again to come back to the exact same result?
		if (!santosRP.Jobs.GetJob( Job )) then return end
		
		self.Job = Job
		
		santosRP.Jobs.GetJob( self.Job ):Loadout( self )
		
		self:SetModel(self:GetModel())
		self:EmitSound("items/itempickup.wav")
		
		self:UpdateJob()
		
		self:AddNote("You are now a " .. self.Job .. "!" )
		
		if self.Car then
			self.Car:Remove()
		end
		
	end

	function _PLAYER:UpdateJob(pl)
		if (!self.Job) then return end
		
		net.Start("SetJob")
			net.WriteEntity(self)
			net.WriteString(self.Job)
		if pl then
			net.Send( pl )
		else
			net.Broadcast() 
		end
	end
	
end

function _PLAYER:GetJob()
	return self.Job or "Citizen"
end

santosRP.Jobs.LoadJobs()