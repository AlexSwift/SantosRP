local MChatTab = {}
local TextCol  = Color(255,255,255,255)
local TextCol2 = Color(200,50,50,255)
local TextCol3 = Color(160,200,240,255)
local Fade	   = Color(0,0,0,30)
local x 	   = 20
local y 	   = ScrH() - 480
local w,h	   = 600,250

CHAT_PAN	   = nil
CHAT_TEXT      = nil

local ChatOpened = false

hook.Remove("Initialize","ChatboxSpawn")

hook.Add("Initialize","ChatboxCreate",function()
	CHAT_PAN = vgui.Create("MBFrame")
	CHAT_PAN:SetPos(x,y)
	CHAT_PAN:SetSize(w,h)
	CHAT_PAN:SetTitle("")
	CHAT_PAN:SetVisible(false)
	CHAT_PAN:ShowCloseButton(false)
	CHAT_PAN:SetAlpha(0)
	CHAT_PAN.Paint = function(s,w,h)
		DrawSRPRect(0,0,w,h,MAIN_COLOR,MAIN_COLOR2)
	end
		
	local Pane = vgui.Create("DScrollPanel")
	Pane:SetPos(x+30,y+10)
	Pane:SetSize(w-50,h-50)
	Pane.Paint = function(s,w,h)
		--DrawRect(0,0,w,h,MAIN_BLACKCOLOR)
	end
	
	Pane.VBar.Paint 		= function(s,w,h) end
	Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect( 2 , 0 , w-4 , h , Fade ) end
	Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect( 2 , 2 , w-4 , h-4 , Fade ) end
	Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect( 2 , 2 , w-4 , h-4 , Fade ) end
	
	CHAT_TEXT = vgui.Create("DListLayout",Pane)
	CHAT_TEXT:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
	CHAT_TEXT:SetPos(5,5)
	
	CHAT_TEXT.PANE = Pane
	
	CHAT_PAN.Typer = vgui.Create("DTextEntry",CHAT_PAN)
	CHAT_PAN.Typer:SetPos(30,h-35)
	CHAT_PAN.Typer:SetSize(w-60,20)
	CHAT_PAN.Typer:SetText("Say: ")
	
	--This bit may look weird, but this is to prevent the double chatbox bug upon first load up of Garry's Mod.
	chat.Open(0)
	chat.Close()
end)

function GM:StartChat()
	if (!CHAT_PAN) then return end
	
	ChatOpened = true
	
	CHAT_TEXT:SetMouseInputEnabled(true)
	CHAT_TEXT:SetVisible(true)
	
	CHAT_PAN:Stop()
	CHAT_PAN:SetVisible(true)
	CHAT_PAN:AlphaTo( 255, 0.5, 0, function() end )
	
	
	CHAT_TEXT.PANE:Stop()
	CHAT_TEXT.PANE:SetVisible(true)
	CHAT_TEXT.PANE:AlphaTo( 255, 0.5, 0, function(anim,pan) end )
	
	return true
end

function GM:FinishChat() 
	if (!CHAT_PAN) then return end
	
	CHAT_TEXT:SetMouseInputEnabled(false)
	
	CHAT_PAN:Stop()
	CHAT_PAN:AlphaTo( 0, 0.5, 0, function(anim,pan) pan:SetVisible(false) end )
	
	
	CHAT_TEXT.PANE:Stop()
	CHAT_TEXT.PANE:AlphaTo( 0, 3, 10, function(anim,pan) pan:SetVisible(false) end )
end

function GM:ChatTextChanged(text)
	if (!CHAT_PAN) then return end
	
	CHAT_PAN.Typer:SetText("Say: "..text)
end

function IsChatOpen()
	return (CHAT_PAN and CHAT_PAN:IsVisible())
end


local function GenerateText(tab,category)
	if (!CHAT_PAN) then return end
	
	local a = CHAT_TEXT:Add("MBLabel")
	a:SetSize(CHAT_TEXT:GetWide()-5,1)
	
	for k,v in pairs(tab) do a:AddText(v[1],"ChatFont",v[2]) end
	
	a:SetupLines() --You need to call this AFTER adding the text...
	
	CHAT_TEXT.PANE.VBar:AnimateTo(CHAT_TEXT:GetTall(),0.5,0,0.5)
	
	if (!IsChatOpen()) then
		CHAT_TEXT.PANE:SetVisible(true)
		CHAT_TEXT.PANE:SetAlpha(255)
		
		CHAT_TEXT.PANE:Stop()
		CHAT_TEXT.PANE:AlphaTo( 0, 3, 10, function(anim,pan) pan:SetVisible(false) end )
	end
end

function GM:OnPlayerChat( pl , text , teamtext , dead ) 
	if (!IsValid(pl)) then return end --This function is now getting called when console talks.. odd...

	local Rank = pl:GetRank()
	local dat = {
		{
			"",
			MAIN_GREENCOLOR,
		},
		{
			pl:GetRPName()..": ",
			MAIN_YELLOWCOLOR,
		},
		{
			text,
			TextCol,
		},
	}
	
	if (text:find("(OOC)") == 2) then
		dat[2][1] = pl:Nick()..": "
		dat[3][2] = Color(200,200,200)
	end
	
	if (teamtext) then 
		dat[1][1] = "(Team)"
	elseif (dead) then 				
		dat[1][1] = "(Dead)" 						
		dat[1][2] = TextCol2
	elseif (Rank != 1) then 		
		dat[1][1] = "("..TranslateRank(Rank)..")" 	
		dat[1][2] = HSVToColor(Rank*30,1,1)
	else table.remove(dat,1) end
	
	chat.AddText(dat[2][2],dat[2][1],TextCol,text)
	GenerateText(dat)
end

function GM:ChatText( int , name , text ) 
	if (int == 0) then 
		local dat = {
			{
				"God: ",
				TextCol3,
			},
			{
				text,
				TextCol,
			},
		}
		
		chat.AddText(MAIN_COLOR,"Game: ",TextCol,text)
		GenerateText(dat) 
	end 
end