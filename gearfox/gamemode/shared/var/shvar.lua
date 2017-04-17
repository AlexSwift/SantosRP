local EPT 		= FindMetaTable("Entity")
local SHNonTemp = {}



if (CLIENT) then
	net.Receive("_ReceiveSHVar",function(size)
		local Dat 	= net.ReadTable()
		local Ent 	= Dat.Ent
		
		if (!IsValid(Ent)) then return end
		if (!Ent._SHVarDat) then Ent._SHVarDat = {} end
		Ent._SHVarDat[Dat.Name] = Dat.Value
	end)
else
	hook.Add("PlayerAuthed","_AddSHVar",function(pl,sid,uid)
		for k,v in pairs( SHNonTemp ) do
			local Ent = ents.GetByIndex(k)
			if (IsValid(Ent)) then
				for a,b in pairs( v ) do
					Ent:SetSHVar(a,b,pl)
				end
			else
				SHNonTemp[k] = nil
			end
		end
	end)
	
	util.AddNetworkString("_ReceiveSHVar")
end

function EPT:GetSHVarTable()
	return self._SHVarDat
end

function EPT:SearchSHVarTable(Name)
	local DAT = {}
	
	if (!self._SHVarDat) then return {} end
	for k,v in pairs(self._SHVarDat) do
		if (k:find(Name) and v != nil) then
			DAT[k] = v
		end
	end
	
	return DAT
end

function EPT:AddNonTempSH(bKey,Value)
	local ID = self:EntIndex()
	
	if (!SHNonTemp[ID]) then SHNonTemp[ID] = {} end
	SHNonTemp[ID][bKey] = Value
	
	self:SetSHVar(bKey,Value)
end

function EPT:SetSHVar(Name,Var,ply) --Third argument should only be defined if it is send specificly only for this player.
	if (!self._SHVarDat) then self._SHVarDat = {} end
	self._SHVarDat[Name] = Var

	if (CLIENT) then return end
	
	local Dat = {
		Name = Name,
		Ent = self,
		Value = Var,
	}
	
	net.Start( "_ReceiveSHVar" )     
		net.WriteTable( Dat )
		
	if (IsValid(ply)) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function EPT:GetSHVar(Name,Var)
	local ID = self:EntIndex()
	if (!self._SHVarDat or self._SHVarDat[Name] == nil) then return Var or nil end
	return self._SHVarDat[Name]
end