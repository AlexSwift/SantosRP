local sw,sh = ScrW(),ScrH()

local Editor 	= nil
local VehList 	= santosRP.Vehicles.GetCarList()

local Zero		= Vector(0,0,30)
local CamPos 	= Vector(300,0,0)

local function PopulateListModifications(ent)
	if (!Editor or !IsValid(ent) or !ent.Data) then return end
	
	Editor.List2:Clear()
	
	santosRP.Vehicles.ForeachCarLights(ent,function(ent,v,k)
		v.GuiColor = table.Copy(v.Color)
		v.GuiColor.r = v.GuiColor.r/3
		v.GuiColor.g = v.GuiColor.g/3
		v.GuiColor.b = v.GuiColor.b/3
		
		local a = Editor.List2:Add("SRPButton")
		a:SetText("")
		a:SetTall(30)
		a.Paint = function(s,w,h)
			if (s.Hovered) then DrawRect(0,0,w-15,h-2,MAIN_GREENCOLOR)
			else DrawRect(0,0,w-15,h-2,v.GuiColor) end 
			DrawText(k..": Light pos: "..tostring(v.Pos),"Trebuchet18",10,5,MAIN_WHITECOLOR)
		end
		a.DoClick = function(s)
			Editor.Spec.LightID = k
			Editor.Spec.SeatID 	= nil
			
			Editor.Spec.PosPanels.x:SetValue(v.Pos.x)
			Editor.Spec.PosPanels.y:SetValue(v.Pos.y)
			Editor.Spec.PosPanels.z:SetValue(v.Pos.z)
			
			Editor.Spec.AngPanels.p:SetValue(v.Ang.p)
			Editor.Spec.AngPanels.y:SetValue(v.Ang.y)
			Editor.Spec.AngPanels.r:SetValue(v.Ang.r)
			
			Editor.Spec.SizePanel:SetValue(v.Size)
			
			
			Editor.Spec.ColorPan:SetColor(v.Color)
			Editor.Spec.LightTypePan:ChooseOption( v.LightType )
		end
	end)

	ForeachCarSeat(ent,function(ent,v,k)
		local a = Editor.List2:Add("SRPButton")
		a:SetText("")
		a:SetTall(30)
		a.Paint = function(s,w,h)
			if (s.Hovered) then DrawRect(0,0,w-15,h-2,MAIN_GREENCOLOR)
			else DrawRect(0,0,w-15,h-2,MAIN_COLOR2) end 
			DrawText(k..": Seat pos: "..tostring(v.Pos),"Trebuchet18",10,5,MAIN_TEXTCOLOR)
		end
		a.DoClick = function(s)
			Editor.Spec.LightID = nil
			Editor.Spec.SeatID 	= k
			
			Editor.Spec.PosPanels.x:SetValue(v.Pos.x)
			Editor.Spec.PosPanels.y:SetValue(v.Pos.y)
			Editor.Spec.PosPanels.z:SetValue(v.Pos.z)
			
			Editor.Spec.AngPanels.p:SetValue(v.Ang.p)
			Editor.Spec.AngPanels.y:SetValue(v.Ang.y)
			Editor.Spec.AngPanels.r:SetValue(v.Ang.r)
			
			Editor.Spec.SizePanel:SetValue(v.Size)
		end
	end)
end

local function PopulateList()
	if (!Editor) then return end
	
	--table.SortByMember(VehList,"Price",true)
	
	Editor.List:Clear()
	
	for k,v in pairs(VehList) do
		local a = Editor.List:Add("DPanel")
		a:SetText("")
		a:SetTall(109)
		a.Paint = function(s,W,ph)
			local H = 79
			DrawRect(H,0,W-H,H-26,MAIN_COLOR2)
			
			DrawSRPBox(0,0,H,H,MAIN_COLOR2,MAIN_COLOR)
			
			DrawText(v:GetName(),"Trebuchet24",78,5,MAIN_TEXTCOLOR)
		end
		
		local b = vgui.Create("SpawnIcon",a)
		b:SetPos(5,5)
		b:SetSize(64,64)
		b:SetModel(v:GetModel() )
		
		local c = vgui.Create("SRPButton",a)
		c:SetPos(200,65)
		c:SetSize(90,20)
		c:SetText("Select")
		c.DoClick = function(s)
			Editor.Selected = {v:GetName(),v}
			
			Editor.ModelPane:SetModel(Editor.Selected[2]:GetModel())
			Editor.ModelPane:SetVisible(true)
			
			Editor.ModelPane.Entity.Data = santosRP.Vehicles.LoadCarFile(Editor.Selected[2]:GetModel())
				
			PopulateListModifications(Editor.ModelPane.Entity)
		end
	end
end

concommand.Add("srp_open_vehicleeditor",function() OpenVehicleEditor() end)

local function SaveInfo()
	if (!Editor) then return end
	
	local Ent = Editor.ModelPane.Entity
	if (!IsValid(Ent)) then return end
	
	SaveCarFile(Ent:GetModel(),Ent.Data)
end

local function AddSlider(x,y,txt,mins,maxs,func)
	if (!IsValid(Editor) or !IsValid(Editor.Spec)) then return end
	
	local p = vgui.Create("DNumSlider",Editor.Spec)
	p:SetPos(x,y) 
	p:SetText(txt)
	p:SetSize(200,25)
	p:SetMinMax(mins,maxs)
	p:SetValue(0)
	p.TextArea:SetDrawBackground( true )
	p.Paint = function(s,W,H) DrawRect(0,0,W,H,MAIN_COLOR) end
	p.OnValueChanged = function(s,val)
		local Ab = Editor.ModelPane.Entity
		
		if (IsValid(Ab) and Ab.Data) then
			local Lights = Ab.Data.Lights
			local Seats  = Ab.Data.Seats
			
			local LightID = Editor.Spec.LightID
			local SeatID  = Editor.Spec.SeatID
			
			if (LightID and Lights and Lights[LightID]) then
				func(Lights[LightID],val,true)
			elseif (SeatID and Seats and Seats[SeatID]) then
				func(Seats[SeatID],val,false)
			end
		end
	end
	
	return p
end
	
local Mat 		= Material("santosrp/effects/glow03")
local DebugWhi 	= Material("vgui/white")
local Mat2 		= Material("santosrp/effects/glow03_noz_shrine","ignorez")
local matBeam	= Material( "effects/lamp_beam" )

local rSetMaterial 		= render.SetMaterial
local rDrawQuadEasy  	= render.DrawQuadEasy
local rDrawBox  		= render.DrawBox

local StartBeam 	= render.StartBeam
local AddBeam 		= render.AddBeam
local EndBeam 		= render.EndBeam

local One 	= Vector(1,1,1)
local ZeroA = Angle(0,0,0)
local ZeroV = Vector(0,0,0)

local LampCol = Color(100,100,100)

function OpenVehicleEditor()
	if (!Editor) then
		Editor = vgui.Create("SRPFrame")
		Editor:SetPos(100,100)
		Editor:SetSize(sw-200,sh-200)
		Editor:SetTitle("")
		Editor:MakePopup()
		Editor.Text = "Editor"
		
		local w,h = Editor:GetWide(),Editor:GetTall()
		
		--Huge ass Model Panel stuff here!
		Editor.ModelPane = vgui.Create("DModelPanel",Editor)
		Editor.ModelPane:SetPos(305,30)
		Editor.ModelPane:SetSize(w-605,h-235)
		Editor.ModelPane:SetModel("models/error.mdl")
		Editor.ModelPane:SetLookAt(Zero)
		Editor.ModelPane:SetVisible(false)
		Editor.ModelPane:SetCamPos(CamPos)
		Editor.ModelPane.OnMousePressed = function(s,m)
			if (m == MOUSE_LEFT) then
				local gx,gy = gui.MousePos()
				s.Drag = s.Drag or {x=gx,y=gy}
			end
		end
		Editor.ModelPane.Think = function(s)
			if (s.Drag and input.IsMouseDown(MOUSE_LEFT)) then
				local gx,gy = gui.MousePos()
				local Ang = math.AngleNormalize(CamPos:Angle()+Angle(s.Drag.y-gy,s.Drag.x-gx,0))
				Ang.p = math.Clamp(Ang.p,-85,85)
				
				CamPos = Ang:Forward()*300 
				s:SetCamPos(CamPos)
				
				s.Drag = {x=gx,y=gy}
			else
				s.Drag = nil
			end
		end
		
		Editor.ModelPane.Paint = function(self,w,h)
			if ( !IsValid( self.Entity ) ) then return end
			
			DrawRect(0,0,w,h,MAIN_COLOR2)
			
			local x, y = self:LocalToScreen( 0, 0 )
			
			local ang = (self.vLookatPos-self.vCamPos):Angle()
			
			cam.Start3D( self.vCamPos, ang, 80, x, y, w, h )
			cam.IgnoreZ( true )
			
			render.SuppressEngineLighting( true )
			
			self.Entity:DrawModel()
			
			santosRP.Vehicles.ForeachCarLights(self.Entity,function(ent,v,k)
				rSetMaterial(Mat)
				rDrawQuadEasy(v.Pos,-ang:Forward(),30*v.Size,30*v.Size,v.Color)
				rSetMaterial(DebugWhi)
				rDrawBox(v.Pos,ZeroA,-One*v.Size*2,One*v.Size*2,v.Color)
				
				if (v.LightType == "Headlight") then
					local For = v.Ang:Forward()
					
					local ViewNormal 	= (v.Pos - CamPos):GetNormal()
					local ViewDot 		= 1-ViewNormal:Dot( For * -1 )
					
					if ( ViewDot >= 0 ) then
						local A = v.Color.a*1
						local Size = math.max(30,50*v.Size)
						v.Color.a = ViewDot/2*200
						
						rSetMaterial(matBeam)
						StartBeam(3)
							AddBeam(v.Pos,Size,0,v.Color)
							AddBeam(v.Pos+For*100,Size,0.5,v.Color)
							AddBeam(v.Pos+For*200,Size,1,MAIN_NOCOLOR)
						EndBeam()
						
						v.Color.a = A
					end
				end
				
				v.SPos = v.Pos:ToScreen()
				v.SPos2 = (v.Pos + v.Pos:GetNormal()*50):ToScreen()
			end)
			
			local A = self.Entity:GetModel()
			self.Entity:SetModel("models/props_phx/carseat2.mdl")
			
			render.SetColorModulation(0,50,0)
			
			ForeachCarSeat(self.Entity,function(ent,v)
				ent:SetRenderOrigin(v.Pos)
				ent:SetRenderAngles(v.Ang)
				ent:SetupBones()
				ent:DrawModel()
				
				v.SPos = v.Pos:ToScreen()
				v.SPos2 = (v.Pos + v.Pos:GetNormal()*50):ToScreen()
			end)
			
			render.SetColorModulation(1,1,1)
			
			self.Entity:SetRenderOrigin(ZeroV)
			self.Entity:SetRenderAngles(ZeroA)
			self.Entity:SetModel(A)
			
			render.SuppressEngineLighting( false )
			
			cam.IgnoreZ( false )
			cam.End3D()
			
			ForeachCarSeat(self.Entity,function(ent,v,k)
				local X2,Y2 = v.SPos.x/sw*w,v.SPos.y/sh*h
				local X,Y   = v.SPos2.x/sw*w,v.SPos2.y/sh*h
				
				DrawLine(X,Y,X2,Y2,MAIN_WHITECOLORT)
				
				if (Editor.Spec.SeatID == k) then DrawText(k..": Seat","Trebuchet24",X,Y,MAIN_WHITECOLOR,1)
				else DrawText(k..": Seat","DefaultSmall",X,Y,MAIN_WHITECOLOR,1) end
			end)
			
			santosRP.Vehicles.ForeachCarLights(self.Entity,function(ent,v,k)
				local X2,Y2 = v.SPos.x/sw*w,v.SPos.y/sh*h
				local X,Y   = v.SPos2.x/sw*w,v.SPos2.y/sh*h
				
				DrawLine(X,Y,X2,Y2,v.GuiColor)
				
				if (Editor.Spec.LightID == k) then DrawText(k..": "..v.LightType,"Trebuchet24",X,Y,v.Color,1)
				else DrawText(k..": "..v.LightType,"DefaultSmall",X,Y,v.Color,1) end
			end)
		end
		
		
		--Editor Specifications
		local p = vgui.Create("DPanel",Editor)
		p:SetPos(305,h-200)
		p:SetSize(w-605,195)
		p.Text = "Select a car model on the left. Then select a modification on the right."
		p.Paint = function(s,W,H)
			DrawRect(0,0,W,H,MAIN_COLOR2)
			DrawText(s.Text,"Trebuchet18",5,5,MAIN_WHITECOLOR)
		end
		
		Editor.Spec = p
		
		--Pos
		local slx = AddSlider(5,25,"Pos X",-200,200,function(data,val,bLight) data.Pos.x = val end)
		local sly = AddSlider(5,55,"Pos Y",-200,200,function(data,val,bLight) data.Pos.y = val end)
		local slz = AddSlider(5,85,"Pos X",-200,200,function(data,val,bLight) data.Pos.z = val end)
		
		p.PosPanels = {x=slx,y=sly,z=slz}
		
		
		--Ang
		local anp = AddSlider(210,25,"Pitch",-200,200,function(data,val,bLight) data.Ang.p = val end)
		local any = AddSlider(210,55,"Yaw",-200,200,function(data,val,bLight) data.Ang.y = val end)
		local anr = AddSlider(210,85,"Roll",-200,200,function(data,val,bLight) data.Ang.r = val end)
		
		p.AngPanels = {p=anp,y=any,r=anr}
		
		
		--Size
		local sip = AddSlider(5,115,"Size",0.1,20,function(data,val,bLight) if (bLight) then data.Size = val end end)
		
		p.SizePanel = sip
		
		
		local c = vgui.Create("SRPButton",p)
		c:SetPos(210,115)
		c:SetSize(200,25)
		c:SetText("Save File")
		c.DoClick = function(s) SaveInfo() end
		
		
		local c = vgui.Create("SRPButton",p)
		c:SetPos(415,25)
		c:SetSize(200,25)
		c:SetText("Remove Selected")
		c.DoClick = function(s)
			local Ab = Editor.ModelPane.Entity
			
			if (IsValid(Ab) and Ab.Data) then
				local Lights = Ab.Data.Lights
				local Seats  = Ab.Data.Seats
				
				local LightID = Editor.Spec.LightID
				local SeatID  = Editor.Spec.SeatID
				
				if (LightID and Lights and Lights[LightID]) then
					table.remove(Lights,LightID)
					Editor.Spec.LightID = nil
					Editor.Spec.SeatID = nil
					PopulateListModifications(Ab)
				elseif (SeatID and Seats and Seats[SeatID]) then
					table.remove(Seats,LightID)
					Editor.Spec.LightID = nil
					Editor.Spec.SeatID = nil
					PopulateListModifications(Ab)
				end
			end
		end
		
		local c = vgui.Create("SRPButton",p)
		c:SetPos(5,145)
		c:SetSize(200,25)
		c:SetText("Add New Light")
		c.DoClick = function(s)
			local Ab = Editor.ModelPane.Entity
			
			if (IsValid(Ab) and Ab.Data) then
				local Lights = Ab.Data.Lights
				
				if (Lights) then
					table.insert(Lights,{
						Pos = Vector(0,0,0),
						Ang = Angle(0,0,0),
						Size = 1,
						Color = Color(255,255,255),
						LightType = "Normal",
						GuiColor = Color(255/3,255/3,255/3),
					})
					PopulateListModifications(Ab)
				end
			end
		end
		
		local c = vgui.Create("SRPButton",p)
		c:SetPos(210,145)
		c:SetSize(200,25)
		c:SetText("Add New Seat")
		c.DoClick = function(s)
			local Ab = Editor.ModelPane.Entity
			
			if (IsValid(Ab) and Ab.Data) then
				local Seats  = Ab.Data.Seats
				
				if (Seats) then
					table.insert(Seats,{
						Pos = Vector(0,0,0),
						Ang = Angle(0,0,0),
					})
					PopulateListModifications(Ab)
				end
			end
		end
		
		local Entry = vgui.Create( "DComboBox",p)
		Entry:SetPos(415,55)
		Entry:SetSize(200,25)
		Entry:AddChoice("Normal")
		Entry:AddChoice("Headlight")
		Entry:AddChoice("Reverse")
		Entry:AddChoice("Blinker")
		Entry:AddChoice("Brakes")
		Entry:AddChoice("Siren1")
		Entry:AddChoice("Siren2")
		Entry.OnSelect = function(index,val,data)
			local Ab = Editor.ModelPane.Entity
			
			if (IsValid(Ab) and Ab.Data) then
				local Lights = Ab.Data.Lights
				local LightID = Editor.Spec.LightID
				if (LightID and Lights and Lights[LightID]) then
					Lights[LightID].LightType = data
				end
			end
		end
		
		p.LightTypePan = Entry
		
		local Mixer = vgui.Create( "DColorMixer", p )
		Mixer:SetPos(415,85)
		Mixer:SetSize(200,90)
		Mixer:SetPalette( false )  	
		Mixer:SetAlphaBar( true ) 		
		Mixer:SetWangs( true )	 	
		Mixer:SetColor( MAIN_WHITECOLOR )
		Mixer.ValueChanged = function(s,Col)
			local Ab = Editor.ModelPane.Entity
			
			if (IsValid(Ab) and Ab.Data) then
				local Lights = Ab.Data.Lights
				local LightID = Editor.Spec.LightID
				if (LightID and Lights and Lights[LightID]) then
					Lights[LightID].Color = Col
					
					Lights[LightID].GuiColor = table.Copy(Col)
					Lights[LightID].GuiColor.r = Lights[LightID].GuiColor.r/3
					Lights[LightID].GuiColor.g = Lights[LightID].GuiColor.g/3
					Lights[LightID].GuiColor.b = Lights[LightID].GuiColor.b/3
				end
			end
		end
		
		p.ColorPan = Mixer
		
		
		
		
		--List of car models incorperated in the gamemode
		Editor.Pane = vgui.Create("DScrollPanel",Editor)
		Editor.Pane:SetPos(0,30)
		Editor.Pane:SetSize(300,h-35)
		Editor.Pane.Paint = function(s,w,h) end
		
		Editor.Pane.VBar.Paint = function(s,w,h) end
		Editor.Pane.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR2) end
		Editor.Pane.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR2) end
		Editor.Pane.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR2) end
		
		Editor.List = vgui.Create("DListLayout",Editor.Pane)
		Editor.List:SetSize(Editor.Pane:GetWide()-10,Editor.Pane:GetTall()-10)
		Editor.List:SetPos(5,5)
		
		
		--List of modifications such as lights n seats n shit
		Editor.Pane2 = vgui.Create("DScrollPanel",Editor)
		Editor.Pane2:SetPos(w-300,30)
		Editor.Pane2:SetSize(300,h-35)
		Editor.Pane2.Paint = function(s,w,h) end
		
		Editor.Pane2.VBar.Paint = function(s,w,h) end
		Editor.Pane2.VBar.btnGrip.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR2) end
		Editor.Pane2.VBar.btnDown.Paint = function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR2) end
		Editor.Pane2.VBar.btnUp.Paint 	= function(s,w,h) DrawRect(2,2,w-4,h-4,MAIN_COLOR2) end
		
		Editor.List2 = vgui.Create("DListLayout",Editor.Pane2)
		Editor.List2:SetSize(Editor.Pane2:GetWide()-10,Editor.Pane2:GetTall()-10)
		Editor.List2:SetPos(5,5)
		
		PopulateList()
	end
	
	Editor:SetVisible(true)
end
		