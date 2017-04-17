local EPT 		= FindMetaTable("Entity")
local SHQTab	= 0
local SHQLimit	= 200
local SHQSend 	= {}
local SHNonTemp = {}

GM._GlobalSHVars = {}

if (CLIENT) then
	net.Receive("_ReceiveGlobalSHVar",function(size)
		local Dat = net.ReadTable()
		GAMEMODE._GlobalSHVars[Dat.Name] = Dat.Value
	end)
else
	hook.Add("PlayerAuthed","_AddGlobalSHVar",function(pl,sid,uid)
		GM = GM or GAMEMODE
		
		for k,v in pairs( GM._GlobalSHVars ) do
			GM:SetGlobalSHVar(k,v,pl)
		end
	end)
	
	util.AddNetworkString("_ReceiveGlobalSHVar")
end

function GM:GetGlobalSHVarTable()
	return self._GlobalSHVars
end

function GM:SetGlobalSHVar(Name,Var,ply)
	self._GlobalSHVars[Name] = Var

	if (CLIENT) then return end
	
	local Dat = {
		Name = Name,
		Value = Var,
	}
	
	net.Start( "_ReceiveGlobalSHVar" )     
		net.WriteTable( Dat )
		
	if (IsValid(ply)) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function GM:GetGlobalSHVar(Name,Var)
	if (!self._GlobalSHVars or self._GlobalSHVars[Name] == nil) then return Var or nil end
	return self._GlobalSHVars[Name]
end