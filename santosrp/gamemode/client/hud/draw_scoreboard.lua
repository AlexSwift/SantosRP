
local sw,sh = ScrW(),ScrH()

local bh,offh = 256,250
local w,h = 800,300
local x,y = sw/2-w/2,sh/2-h/2

local Logo_shadow 	= Material("santosrp/hud/logo_shadow.png")
local Logo 			= Material("santosrp/hud/logo.png")

local Grad 			= Material("gui/gradient_up")

local PlayerList = nil

local function PopulateList()
	if (!PlayerList) then return end
	
	PlayerList.List:Clear()
	
	local lp = LocalPlayer()
	
	for k,v in pairs(player.GetAll()) do
		local Line = (math.ceil(k/2) != math.floor(k/2))
		
		local a = PlayerList.List:Add("DPanel")
		a:SetText("")
		a:SetTall(35)
		a.Paint = function(s,W,H)
			if (!IsValid(v)) then return end
			
			local Col = v:GetJobColor()
			Col.a = 40
			
			DrawRect(0,0,W,H-5,Col)
			DrawOutlinedRect(0,0,W,H-5,Col)
			DrawMaterialRect(0,0,W,H-5,MAIN_COLOR2,Grad)
			
			DrawText(v:GetRPName(),"Trebuchet18",10,5,MAIN_TEXTCOLOR)
			DrawText(v:GetJob(),"Trebuchet18",300,5,MAIN_TEXTCOLOR)
			DrawText(v:Ping(),"Trebuchet18",W-13,5,MAIN_TEXTCOLOR,2)
			
			if (lp != v and lp:IsBuddy(v)) then
				DrawText("Prop Buddy","Trebuchet18",510,5,MAIN_GREENCOLOR)
			end
			
			
			Col.a = 255
		end
		
		if (v != lp) then
			local b = vgui.Create("MBButton",a)
			b:SetPos(w-200,0)
			b:SetSize(150,30)
			b:SetText("Toggle Buddy")
			b.Paint = function(s,w,h)
				if (s.Hovered) then DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_YELLOWCOLOR,1)
				else DrawText(s.Text,"Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1) end
			end
			b.DoClick = function(s)
				if (lp:IsBuddy(v)) then
					RemovePropBuddy(v)
				else
					AddPropBuddy(v)
				end
			end
		end
	end
end
	

function GM:ScoreboardShow()
	if (!PlayerList) then
		PlayerList = vgui.Create("DFrame")
		PlayerList:SetPos(x,y-offh/2)
		PlayerList:SetSize(w,h+offh)
		PlayerList:SetTitle("")
		PlayerList:MakePopup()
		PlayerList:SetAlpha(0)
		PlayerList:SetDraggable( false )
		PlayerList:ShowCloseButton( false )
		PlayerList.Paint = function(s,w,h)
			DrawSRPRect(0,offh,w,h-offh,MAIN_COLOR,MAIN_COLOR2)
			
			DrawMaterialRect(w/2-bh*2,0,bh*4,bh,MAIN_WHITECOLORT,Logo_shadow)
			DrawMaterialRect(w/2-bh*2,0,bh*4,bh,MAIN_WHITECOLOR,Logo)
		end
		
		PlayerList.Pane = vgui.Create("DScrollPanel",PlayerList)
		PlayerList.Pane:SetPos(5,offh+5)
		PlayerList.Pane:SetSize(w-10,h-10)
		PlayerList.Pane.Paint = function(s,w,h) end
		
		PlayerList.Pane.VBar.Paint = function(s,w,h) end
		PlayerList.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		PlayerList.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		PlayerList.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR) end
		
		PlayerList.List = vgui.Create("DListLayout",PlayerList.Pane)
		PlayerList.List:SetSize(PlayerList.Pane:GetWide()-10,PlayerList.Pane:GetTall()-10)
		PlayerList.List:SetPos(5,5)
	end
	
	PopulateList()
	
	PlayerList:Stop()
	PlayerList:SetVisible(true)
	PlayerList:AlphaTo( 255, 0.2, 0, function() end )
end

function GM:ScoreboardHide()
	PlayerList:Stop()
	PlayerList:AlphaTo( 0, 0.2, 0, function(anim,pan) pan:SetVisible(false) end )
end

function GM:HUDDrawScoreBoard()
end

