local MChatTab = {}
local TextCol  = Color(255,255,255,255)
local TextCol2 = Color(200,50,50,255)
local TextCol3 = Color(160,200,240,255)
local x 	   = 20
local y 	   = ScrH() - 300
local d		   = {}
CHAT_PAN	   = nil

hook.Add("Initialize","ChatboxSpawn",function()
	CHAT_PAN = vgui.Create("MBFrame")
	CHAT_PAN:SetPos(x,y)
	CHAT_PAN:SetSize(400,200)
	CHAT_PAN:SetTitle("ChatBawx")
	CHAT_PAN:SetVisible(false)
	CHAT_PAN:ShowCloseButton(false)
		
	CHAT_TEXT = vgui.Create("MBPanelList")
	CHAT_TEXT:SetPos( x+5,y+25 )
	CHAT_TEXT:SetSize( 390, 150 )
	CHAT_TEXT:SetSpacing( 1 )
	CHAT_TEXT:EnableHorizontal( false )
	CHAT_TEXT:EnableVerticalScrollbar( true )
	CHAT_TEXT:SetLimit(30)
	CHAT_TEXT:SetMouseInputEnabled(false)
	
	CHAT_PAN.Typer = vgui.Create("DTextEntry",CHAT_PAN)
	CHAT_PAN.Typer:SetPos(5,175)
	CHAT_PAN.Typer:SetSize(370,20)
	CHAT_PAN.Typer:SetText("Say: ")
end)

function GM:SetEnableMawChat(bool)
	self.UseMawChat = bool
	
	if (!bool) then CHAT_PAN:SetVisible(false) CHAT_TEXT:SetVisible(false)
	else CHAT_TEXT:SetVisible(true) end
end

function GM:StartChat()
	if (!self.UseMawChat) then return false end
	if (!CHAT_PAN) then return end
	
	CHAT_TEXT:SetMouseInputEnabled(true)
	CHAT_PAN:SetVisible(true)
	return true
end

function GM:FinishChat() 
	if (!self.UseMawChat) then return end
	if (!CHAT_PAN) then return end
	
	CHAT_TEXT:SetMouseInputEnabled(false)
	CHAT_PAN:SetVisible(false)
end

function GM:ChatTextChanged(text)
	if (!self.UseMawChat) then return end
	if (!CHAT_PAN) then return end
	
	CHAT_PAN.Typer:SetText("Say: "..text)
end

function IsChatOpen()
	return (CHAT_PAN and CHAT_PAN:IsVisible())
end

local function GenerateText(tab)
	if (type(tab):lower() != "table") then return end
	
	local a = vgui.Create("MBLabel")
	a:SetSize(CHAT_TEXT:GetWide()-5,1)
	
	for k,v in pairs(tab) do a:AddText(v[1],v[2],v[3]) end
	
	a:SetupLines() --You need to call this AFTER adding the text...
	
	CHAT_TEXT:AddItem(a)
	CHAT_TEXT:InvalidateLayout(true)
	CHAT_TEXT:AddVScroll(40)
end

function GM:OnPlayerChat( pl , text , teamtext , dead ) 
	if (!self.UseMawChat) then return end
	if (!IsValid(pl)) then return end --This function is now getting called when console talks.. odd...
	
	local dat = {
		{
			"",
			"MBChatFont_Tag",
			MAIN_GREENCOLOR,
		},
		{
			pl:Nick()..": ",
			"MBChatFont",
			MAIN_YELLOWCOLOR,
		},
		{
			text,
			"MBChatFont",
			TextCol,
		},
	}
	
	if (text:lower() == ":awesome:") then pl.FaceTime = CurTime()+20 end
	if (text:lower() == "/clearchat" and pl == LocalPlayer()) then CHAT_TEXT:Clear(true) CHAT_TEXT:InvalidateLayout() return end
	
	if (teamtext) then 			dat[1][1] = "(Team)"
	elseif (dead) then 			dat[1][1] = "(Dead)" 	dat[1][3] = TextCol2
	elseif (pl:IsAdmin()) then 	dat[1][1] = "(Admin)" 	dat[1][3] = TextCol2
	else table.remove(dat,1) end
	
	chat.AddText(MAIN_YELLOWCOLOR,pl:Nick()..": ",TextCol,text)
	GenerateText(dat)
end

function GM:ChatText( int , name , text ) 
	if (!self.UseMawChat) then return end
	if (int == 0) then 
		local dat = {
			{
				"God: ",
				"MBChatFont",
				TextCol3,
			},
			{
				text,
				"MBChatFont",
				TextCol,
			},
		}
		
		chat.AddText(MAIN_COLOR,"Game: ",TextCol,text)
		GenerateText(dat) 
	end 
end