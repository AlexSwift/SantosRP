local VoiceMat 	= surface.GetTextureID("voice/speaker4")
local VoiceEna 	= true
local VOCOL	 	= table.Copy(MAIN_COLOR)

function GM:PlayerStartVoice( ply )
	if (!VoiceEna) then self.BaseClass:PlayerStartVoice( ply ) return end
	ply.Talking = true
end

function GM:PlayerEndVoice( ply )
	if (!VoiceEna) then self.BaseClass:PlayerEndVoice( ply ) return end
	ply.Talking = nil
end

function GM:SetEnableMawVoiceHUD(bool)
	VoiceEna = bool
end

hook.Add("HUDPaint","_VoiceChatDraw",function()
	if (!VoiceEna) then return end
	
	local D = 0

	for k,v in pairs( player.GetAll() ) do
		if (v.Talking) then
			local H = 30 + 30*D
			D = D+1
			
			local V = v:VoiceVolume()
			local D = MAIN_COLOR
			
			VOCOL.r = math.Clamp(D.r-100*V,0,255)
			VOCOL.g = math.Clamp(D.g+200*V,0,255)
			VOCOL.b = math.Clamp(D.b-100*V,0,255)
			
			DrawRect( 0, H, 200, 25, VOCOL )
			
			DrawTexturedRect( 180, H+4, 16, 16, MAIN_TEXTCOLOR, VoiceMat )
			DrawText( v:Nick(), "Trebuchet18", 4, H+3, MAIN_TEXTCOLOR )
		end
	end
end)