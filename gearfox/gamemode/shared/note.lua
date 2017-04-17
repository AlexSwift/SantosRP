
local meta = FindMetaTable("Player")
local Dat  = {}

function meta:AddNote(Msg)
	if (CLIENT) then
		local DAT 	= {}
		DAT.Time 	= CurTime()
		DAT.Msg 	= Msg
		table.insert(Dat,DAT)
	else
		net.Start("_GFGetMessage")
			net.WriteString(Msg)
		net.Send(self)
	end
end

if (CLIENT) then
	net.Receive("_GFGetMessage",function(size)
		local DAT 	= {}
		DAT.Time 	= CurTime()
		DAT.Msg 	= net.ReadString()
		table.insert(Dat,DAT)
	end)
	
	hook.Add("HUDPaint","GearFoxDrawNotes",function()
		local N = CurTime()-5
		local C = 0
		local x = ScrW()
		local y = ScrH()/2
		
		surface.SetFont("Trebuchet18") --This is for the GetTextSize function. To get the correct size of a text.
		
		for k,v in pairs( Dat ) do
			if (v.Time < N) then 
				table.remove(Dat,k) 
			else
				local T = math.Clamp(v.Time-N,0,1)
				local T2 = math.Clamp(N+5-v.Time,0,1)
				C = C+1
				
				local W,H 	= surface.GetTextSize(v.Msg)
				local D 	= y+21*C
				local X 	= x-(W+10)*T2
				local B 	= MAIN_COLOR.a*1
				local K 	= MAIN_TEXTCOLOR.a*1
				
				MAIN_COLOR.a 		= B*T
				MAIN_TEXTCOLOR.a 	= K*T
				
				DrawRect(X,D,W+8,20,MAIN_COLOR)
				DrawText(v.Msg,"Trebuchet18",X+2,D+1,MAIN_TEXTCOLOR)
				
				MAIN_COLOR.a 		= B
				MAIN_TEXTCOLOR.a 	= K
			end
		end
	end)
else util.AddNetworkString( "_GFGetMessage" )
end


