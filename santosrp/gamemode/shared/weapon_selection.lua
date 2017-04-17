
if (SERVER) then
	--Are you serious? Do I really have to setup my own network function for weapon swaps IF i block CHudWeaponSelection?
	util.AddNetworkString("SelectWeapon")
	
	function NextWeapon(bForward,ply)
		local Wep 	= ply:GetActiveWeapon()
		local Weps 	= ply:GetWeapons()
		local Key 	= table.KeyFromValue( Weps, Wep )
		
		if (!IsValid(Wep)) then Key = 1 end
		
		if (bForward) then 
			local NewWep = Weps[Key+1] or Weps[1]
			if (IsValid(NewWep)) then ply:SelectWeapon(NewWep:GetClass()) end
		else
			local NewWep = Weps[Key-1] or Weps[#Weps]
			if (IsValid(NewWep)) then ply:SelectWeapon(NewWep:GetClass()) end
		end
	end
	
	function GM:PlayerSwitchWeapon(pl,oldWep,newWep)
		return false
	end
	
	net.Receive("SelectWeapon",function(bit,pl)
		if (util.tobool(net.ReadBit())) then NextWeapon(true,pl)
		else NextWeapon(false,pl) end
	end)
else
	local w,h = ScrW(),ScrH()
	local Sel = Color(0,0,40,255)
	
	local Spacing 		= 120
	local SpacingOff 	= 70
	local Width 		= 200
	
	local x,y 			= w-Width,h/3
	
	local CurY = 0
	
	local LastDraw = UnPredictedCurTime()
	
	local rad = math.rad
	local cos = math.cos
	local sin = math.sin
	
	local CD = CurTime()
	
	hook.Add("HUDPaint","DrawWeaponSelection",function()
		local A2 = (CD-(CurTime()-3.9))
		
		local DrawDif = UnPredictedCurTime()-LastDraw
		LastDraw = UnPredictedCurTime()
		
		if (A2 < 0) then return end
		
		local lp = LocalPlayer()
		
		local Weapons = lp:GetWeapons()
		local Select  = lp:GetActiveWeapon()
		
		if (!IsValid(Select)) then return end
		
		local R 		= math.min(1,cos(rad(90-A2*22.5))*2)
		local ID 	  	= table.KeyFromValue( Weapons, Select )
		
		CurY = CurY+(ID-CurY)*DrawDif*8
		
		local C 	= (CurY-ID)
		
		for i = -4,4 do
			local Ab = Weapons[ID+i]
			
			if (Ab) then
				local Text = Ab.PrintName or Ab:GetClass()
				Text = string.gsub(Text,"SRP ","")
				Text = string.gsub(Text,"weapon_","")
				Text = Text:gsub("^%l", string.upper)
				
				
				local AR = rad((C-i)*40)
				
				local CosAR,SinAR = cos(AR),sin(AR)
				
				local X,Y = x-CosAR*100,y-SinAR*200
				local A =  CosAR*R
				
				local BOB1A = MAIN_COLOR2.a*1
				local BOB2A = MAIN_COLOR.a*1
				
				local Ang = 20*SinAR
				
				MAIN_COLOR2.a = BOB1A*A
				MAIN_COLOR.a = BOB2A*A
				MAIN_WHITECOLOR.a = 255*A
				
				if (Ab == Select) then
					local BOB3A = MAIN_YELLOWCOLOR.a*1
					MAIN_YELLOWCOLOR.a = BOB3A*A
					
					DrawTextRotatedBox( 
						Text, 
						"Trebuchet24", 
						X,
						Y,
						Width,
						Spacing-SpacingOff, 
						MAIN_WHITECOLOR, 
						Ang, 
						Color(10, 10, 10, 100),
						MAIN_COLOR2
					)
					
					MAIN_YELLOWCOLOR.a = BOB3A
				else
					DrawTextRotatedBox( 
						Text, 
						"Trebuchet24", 
						X,
						Y,
						Width,
						Spacing-SpacingOff, 
						MAIN_WHITECOLOR, 
						Ang, 
						Color(0, 0, 0, 0),
						Color(0, 0, 0, 0)
					)
				end
				
				MAIN_COLOR.a = BOB2A
				MAIN_COLOR2.a = BOB1A
				MAIN_WHITECOLOR.a = 255
			end
		end
		
	end)
	
	
	hook.Add("PlayerBindPress","SelectWeapon",function(pl,bind,pressed)
		if (pressed and CD < CurTime() and !IsValid(pl:GetVehicle()) and !pl:KeyDown(IN_ATTACK) and !pl:KeyDown(IN_ATTACK2)) then
			local B = bind:lower()
			
			if (B == "invnext") then
				net.Start("SelectWeapon")
					net.WriteBit(true)
				net.SendToServer()
				
				CD = CurTime()+0.1
				
				return true
			elseif (B == "invprev") then 
				net.Start("SelectWeapon")
					net.WriteBit(false)
				net.SendToServer()
				
				CD = CurTime()+0.1
				
				return true
			end
		end
	end)
end

