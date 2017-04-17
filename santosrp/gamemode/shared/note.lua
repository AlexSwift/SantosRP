
local meta = FindMetaTable("Player")
local Dat  = {}

function meta:AddNote(Msg)
	if (CLIENT) then
		local DAT 	= {}
		DAT.Time 	= CurTime()
		DAT.Msg 	= Msg
		table.insert(Dat,DAT)
	else
		net.Start("_SRPGetMessage")
			net.WriteString(Msg)
		net.Send(self)
	end
end

if (CLIENT) then
	net.Receive("_SRPGetMessage",function(size)
		local DAT 	= {}
		DAT.Time 	= CurTime()
		DAT.Msg 	= net.ReadString()
		table.insert(Dat,DAT)
	end)
	
	hook.Remove("HUDPaint","GearFoxDrawNotes")
	
	local x = ScrW()
	local y = ScrH()/2
	local OffW,OffH = 40,20
		
	hook.Add("HUDPaint","SRPDrawNotes",function()
		local N = CurTime()-5
		local C = 0
		
		surface.SetFont("Trebuchet18") --This is for the GetTextSize function. To get the correct size of a text.
		
		for k,v in pairs( Dat ) do
			if (v.Time < N) then 
				table.remove(Dat,k) 
			else
				local T = math.Clamp(v.Time-N,0,1)
				local T2 = math.Clamp(N+5-v.Time,0,1)
				C = C+1
				
				local W,H 	= surface.GetTextSize(v.Msg)
				W = W + OffW
				H = H + OffH
				
				local D 	= y+(H+5)*C
				local X 	= x-(W+10)*T2
				
				local A 	= MAIN_COLOR.a*1
				local B 	= MAIN_COLOR2.a*1
				local K 	= MAIN_TEXTCOLOR.a*1
				
				MAIN_COLOR2.a 		= B*T
				MAIN_COLOR.a 		= A*T
				MAIN_TEXTCOLOR.a 	= K*T
				
				
				DrawSRPBox(X,D,W,H,MAIN_COLOR,MAIN_COLOR2)
				DrawText(v.Msg,"Trebuchet18",X+W/2,D+H/2,MAIN_TEXTCOLOR,1)
				
				MAIN_COLOR2.a 		= B
				MAIN_COLOR.a 		= A
				MAIN_TEXTCOLOR.a 	= K
			end
		end
	end)
else util.AddNetworkString( "_SRPGetMessage" )
end


