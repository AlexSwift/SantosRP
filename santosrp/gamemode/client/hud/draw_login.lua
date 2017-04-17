santosRP.gui = santosRP.gui or {}
santosRP.gui.login = {}

local Zero		= Vector(0,0,50)
local CamPos 	= Vector(25,-15,50)

local sw,sh = ScrW(),ScrH()
local MS = math.min(sw,sh)
local OffHeight = 130

local Char  	= 1
local bFemale 	= false
local motdopen = false

local Grad 		= Material("gui/gradient")
local GradUp 	= Material("gui/gradient_up")

local Menu

local GCol  = table.Copy(MAIN_COLOR)
GCol.a = 50

function santosRP.gui.login.LoadCharacterCreationMenu()
	if (!IsValid(Menu)) then return end
	
	local c = vgui.Create("DModelPanel",Menu)
	c:SetPos(0,0)
	c:SetSize(MS/2,sh)
	c:SetModel(SelectCharacter(Char,bFemale))
	c:SetLookAt(Zero)
	c:SetCamPos(CamPos)
	c.LayoutEntity = function(s,ent)
		c.Entity.GetPlayerColor = function() return s.ColVector or Vector(1,1,1) end
		c.Entity:SetPoseParameter( "head_yaw", ((gui.MouseX()/sw)-0.45)*200 )
		c.Entity:SetPoseParameter( "head_pitch", ((gui.MouseY()/sh)-0.3)*200 )
	end
	
	Menu.Mob = c
	
	MS = MS/2
	
	--Clothes Color
	local Mixer = vgui.Create( "DColorMixer", Menu )
	Mixer:SetPos(MS,280+OffHeight)
	Mixer:SetSize(305,90)
	Mixer:SetPalette( false )  	
	Mixer:SetAlphaBar( false ) 		
	Mixer:SetWangs( true )	 	
	Mixer:SetColor( MAIN_WHITECOLOR )
	Mixer.ValueChanged = function(s,Col)
		c.ColVector = Vector(Col.r/255,Col.g/255,Col.b/255)
	end
	
	--First Name, Last Name
	local rpname,valid = LocalPlayer():GetRPName()
	
	local FirstName = vgui.Create("DTextEntry",Menu)
	FirstName:SetPos(MS,OffHeight+55)
	FirstName:SetSize(150,20)
	FirstName:SetText("Garry")
	
	local LastName = vgui.Create("DTextEntry",Menu)
	LastName:SetPos(MS+155,OffHeight+55)
	LastName:SetSize(150,20)
	LastName:SetText("Newman")
	
	--Character
	local Next = vgui.Create("MBButton",Menu)
	Next:SetPos(MS+155,130+OffHeight)
	Next:SetSize(150,40)
	Next:SetText("Next")
	Next.Paint = function(s,w,h)
		local Col = MAIN_COLOR
		
		if (s.Hovered) then Col = MAIN_GREENCOLOR end
		
		DrawSRPDiamond(-h,0,w+h,h,Col,MAIN_COLOR2)
		
		DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
	end
	Next.DoClick = function(s)
		Char = Char+1
		c:SetModel(SelectCharacter(Char,bFemale))
	end
	
	local Prev = vgui.Create("MBButton",Menu)
	Prev:SetPos(MS,130+OffHeight)
	Prev:SetSize(150,40)
	Prev:SetText("Prev")
	Prev.Paint = function(s,w,h)
		local Col = MAIN_COLOR
		
		if (s.Hovered) then Col = MAIN_GREENCOLOR end
		
		DrawSRPDiamond(0,0,w+h,h,Col,MAIN_COLOR2)
		
		DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
	end
	Prev.DoClick = function(s)
		Char = Char-1
		c:SetModel(SelectCharacter(Char,bFemale))
	end
	--End
	
	local BCheck = vgui.Create("SRPCheckBox",Menu)
	BCheck:SetPos(MS,200+OffHeight)
	BCheck:SetChecked(bFemale)
	BCheck.OnChange = function(s,bval)
		bFemale = bval
		c:SetModel(SelectCharacter(Char,bFemale))
	end
	
	local BCheck_Label = vgui.Create("DLabel",Menu)
	BCheck_Label:SetPos(MS+30,200+OffHeight)
	BCheck_Label:SetText("Female")
	
	
	local ErrorMessage = vgui.Create("DLabel",Menu)
	ErrorMessage:SetPos(MS,430+OffHeight)
	ErrorMessage:SetSize(300,30)
	ErrorMessage:SetText("")
	
	
	local Disconnect = vgui.Create("MBButton",Menu)
	Disconnect:SetPos(MS,380+OffHeight)
	Disconnect:SetSize(150,40)
	Disconnect:SetText("Disconnect")
	Disconnect.Paint = function(s,w,h)
		local Col = MAIN_COLOR
		
		if (s.Hovered) then Col = MAIN_GREENCOLOR end
		
		DrawSRPDiamond(0,0,w+h,h,Col,MAIN_COLOR2)
		
		DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
	end
	Disconnect.DoClick = function(s)
		LocalPlayer():ConCommand("disconnect")
	end
	
	local Connect = vgui.Create("MBButton",Menu)
	Connect:SetPos(MS+155,380+OffHeight)
	Connect:SetSize(150,40)
	Connect:SetText("Connect")
	Connect.Paint = function(s,w,h)
		local Col = MAIN_COLOR
		
		if (s.Hovered) then Col = MAIN_GREENCOLOR end
		
		DrawSRPDiamond(-h,0,w+h,h,Col,MAIN_COLOR2)
		
		DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
	end
	Connect.DoClick = function(s)
		
		local Name = FirstName:GetValue().." "..LastName:GetValue()
		
		RequestSpawn(Char,bFemale,c.ColVector,Name)
		
		Menu:Stop()
		Menu:AlphaTo( 0, 0.5, 0, function(anim,pan) Menu:Remove() end )
	end

	local MOTD = vgui.Create("SRPFrame",Menu)
	MOTD:SetSize(ScrW()*.2, ScrH()*.75)
	MOTD:Center()
	MOTD:SetPos(ScrW() - MOTD:GetWide(), select(2, MOTD:GetPos()))
	MOTD:SetTitle("MOTD")
	MOTD:ShowCloseButton(false)
	MOTD:IsDraggable(false)
	
	local MO = vgui.Create("HTML",MOTD)
	MO:Dock(FILL)
	MO:OpenURL("http://santosrp.com/forums/index.php?/page/index.html")
	
	local MOTDOpen = vgui.Create("MBButton",Menu)
	MOTDOpen:SetPos(sw-250,-30)
	MOTDOpen:SetSize(250,60)
	MOTDOpen:SetText("MOTD")
	MOTDOpen.Paint = function(s,w,h)
		local Col = MAIN_COLOR
		if (s.Hovered) or motdopen then Col = MAIN_GREENCOLOR end
		
		DrawSRPDiamond(0,0,w,h,Col,MAIN_COLOR2)
		DrawText(s.Text,"SRP_Font20",w/2,h/2+14,MAIN_TEXTCOLOR,1)
	end
	MOTDOpen.DoClick = function(s)
		if motdopen then
			motdopen = false
			MOTD:MoveTo(ScrW(), select(2, MOTD:GetPos()), 0.4, 0, -1)
		else
			motdopen = true
			MOTD:MoveTo(ScrW() - MOTD:GetWide(), select(2, MOTD:GetPos()),0.4,0,-1)
		end
	end	
end

function santosRP.gui.login.SkipCharacterCreationMenu( )

	Menu:Stop()
	Menu:AlphaTo( 0, 0.5, 0, function(anim,pan) Menu:Remove() end )

end

function santosRP.gui.login.OpenWhitelistQuestions(questions)
	local fram = vgui.Create("SRPFrame")
	fram:SetSize(ScrW() * .5, ScrH() * .5)
	fram:Center()
	fram:MakePopup()
	fram:ShowCloseButton(false)

	local comboboxes = {}

	for k, question in ipairs(questions) do
		local labl = vgui.Create("DLabel", fram)
		labl:SetText(question.text)
		labl:Dock(TOP)

		comboboxes[k] = vgui.Create("DComboBox", frame)
		for _, option in ipairs(question.options) do
			comboboxes[k]:AddOption(option)
		end
		comboboxes[k]:Dock(TOP)
	end

	local btn = vgui.Create("MBButton", fram)
	btn:SetText("Submit")
	btn:Dock(BOTTOM)
	bt.DoClick = function()
		net.Start("SantosRP AnswerQuestions")

		local tab = {}

		for _, box in ipairs(comboboxes) do
			table.insert(tab, box.selected)
		end
		
		net.WriteTable(tab)
		net.SendToServer()
	end
end

hook.Add("InitPostEntity","LoginMenuLoad",function()

	Menu = vgui.Create("DFrame")
	Menu:SetPos(0,0)
	Menu:SetSize(sw,sh)
	Menu:SetTitle("")
	Menu:ShowCloseButton(false)
	Menu:MakePopup()
	--Menu:SetDraggable(false)
	Menu.Paint = function(s,w,h)
		--DrawRect(0,0,w,h,MAIN_TOTALBLACKCOLOR)
		--DrawMaterialRect(0,0,MS*2,h,GCol,Grad)
		santosRP.ui.utils.drawBlur(0, 0, w, h, 5)
		
		
		local rpname,valid = LocalPlayer():GetRPName()
		
		if (IsValid(s.Mob)) then
			DrawSRPBox(0,0,MS-10,h,MAIN_COLOR,MAIN_COLOR2)
			DrawText("Choose Character","SRP_Font64",MS,50,MAIN_TEXTCOLOR)
			DrawText("Face","SRP_Font32",MS,100+OffHeight,MAIN_TEXTCOLOR)
			
			DrawRect(MS-2,OffHeight+53,309,24,MAIN_COLOR)
			
			if (!valid) then
				DrawText("First Name","SRP_Font32",MS,20+OffHeight,MAIN_TEXTCOLOR)
				DrawText("Last Name","SRP_Font32",MS+155,20+OffHeight,MAIN_TEXTCOLOR)
			else
				DrawText("Your Name","SRP_Font32",MS,20+OffHeight,MAIN_TEXTCOLOR)
				DrawText(rpname,"SRP_Font20",MS,20+OffHeight+32,MAIN_TEXTCOLOR)
			end
			
			DrawText("Clothes Color","SRP_Font32",MS,250+OffHeight,MAIN_TEXTCOLOR)
		else
			DrawSRPBox(w/2-200,h/2-25,400,50,MAIN_COLOR,MAIN_COLOR2)
			DrawText("Initializing character...","SRP_Font32",w/2,h/2,MAIN_TEXTCOLOR,1)
		end
	end
	
end)