

--The chat commands function
local ChatCommands = {}

function AddChatCommand(aliases, FunctionCallback)
	for _, alias in ipairs(aliases) do
		ChatCommands["/"..alias:gsub(" ","_"):lower()] = FunctionCallback
	end
end

hook.Add( "PlayerSay", "ChatCommandsSRP", function( ply, text, team )
	local Dat = string.Explode(" ",text)
	
	if (ChatCommands[Dat[1]:lower()]) then
		return ChatCommands[Dat[1]:lower()](ply,table.concat(Dat," ",2)) or ""
	end
end)



--Lets set some simple ones up!
AddChatCommand({"ooc", "/"},function(ply, str)
	return table.concat(santosRP.chatSystem.formatMessage("(OOC)", ply, str))
end)

AddChatCommand({"looc", "."}, function(ply, str)
	ply:TalkInRadius(300, unpack(santosRP.chatSystem.formatMessage("(LOOC)", ply, str)))
end)

AddChatCommand({"yell", "y"}, function (ply, str)
	ply:TalkInRadius(500, unpack(santosRP.chatSystem.formatMessage("(yell)", ply, str)))
end)

AddChatCommand({"whisper", "w"}, function (ply, str)
	ply:TalkInRadius(100, unpack(santosRP.chatSystem.formatMessage("(yell)", ply, str)))
end)



AddChatCommand({"slay"},function(pl,str)
	if (pl:HasPermit("slay")) then
		if (str == "") then pl:Kill() return end
		
		for k,v in pairs(player.GetAll()) do
			if (v:Nick():lower():find(str:lower())) then
				if (v:GetRank() >= pl:GetRank()) then
					pl:AddNote("You cannot slay this player, as he is a higher rank than you!")
					return
				end
				
				v:Kill()
				pl:AddNote("You slayed "..v:Nick())
				break
			end
		end
	end
end)

AddChatCommand({"givemoney"},function(pl,str)
	if (str == "") then return end
	
	local Num = tonumber(string.Explode(" ",str)[1])
	
	if (!Num) then pl:AddNote("Unspecified number given!") return end
	if (pl:GetMoney() < Num) then return end
	
	local tr = pl:GetEyeTrace()
	
	if (tr.Entity and tr.Entity:IsPlayer()) then
		tr.Entity:AddMoney(Num)
		pl:AddMoney(-Num)
		pl:AddNote("You gave "..Num.." cash to "..tr.Entity:Nick())
	else
		pl:AddNote("No one to give money to!")
	end
end)

AddChatCommand({"dropmoney"},function(pl,str)
	if (str == "") then return end
	
	local Num = tonumber(string.Explode(" ",str)[1])
	
	if (!Num) then pl:AddNote("Unspecified number given!") return end
	if (pl:GetMoney() < Num) then return end
	
	pl:AddMoney(-Num)
	
	local tr = pl:GetEyeTrace()
	
	local Ab = ents.Create("prop_money")
	Ab:SetPos(tr.HitPos)
	Ab:Spawn()
	Ab:Activate()
	Ab:SetCash(Num)
end)

AddChatCommand({"kick"},function(pl,str)
	if (pl:HasPermit("kick")) then
		if (str == "") then return end
		
		local A = string.Explode(" ",str)
		
		if (!A[2]) then A[2] = "reason" end
		
		for k,v in pairs(player.GetAll()) do
			if (v:GetRPName():lower():find(A[1]:lower())) then
				if (v:GetRank() >= pl:GetRank()) then
					pl:AddNote("You cannot kick this player, as he is a higher rank than you!")
					return
				end
				
				pl:AddNote("You kicked "..v:Nick())
				v:Kick(table.concat(A," ",2))
				break
			end
		end
	end
end)

AddChatCommand({"goto"},function(pl,str)
	if (pl:HasPermit("goto")) then
		if (str == "") then return end
		
		for k,v in pairs(player.GetAll()) do
			if (v:GetRPName():lower():find(str:lower()) and v != pl) then
				pl:SetPos(v:GetPos())
				break
			end
		end
	end
end)

AddChatCommand({"bring"},function(pl,str)
	if (pl:HasPermit("goto")) then
		if (str == "") then return end
		
		for k,v in pairs(player.GetAll()) do
			if (v:GetRPName():lower():find(str:lower()) and v != pl) then
				v:SetPos(pl:GetPos())
				break
			end
		end
	end
end)
