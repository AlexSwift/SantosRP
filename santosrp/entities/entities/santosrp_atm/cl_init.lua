include('shared.lua')

function ENT:Initialize()
end

local ABP = false

function ENT:Think()
	if (ABP and !LocalPlayer():KeyDown(IN_ATTACK)) then
		ABP = false
	end
end

local function Draw3DButton(mx,my,Title,x,y,w,h,DoClick)
	if (Panel3D2DCursorInBox(mx,my,x,y,w,h)) then
		DrawRect(x,y,w,h,MAIN_GREENCOLOR)
		
		local Press = LocalPlayer():KeyDown(IN_ATTACK)
		
		if (Press and DoClick and !ABP) then
			DoClick()
			surface.PlaySound("santosrp/atm_button.wav")
			ABP = true
		end
	else
		DrawRect(x,y,w,h,MAIN_COLOR2)
	end
	
	DrawText(Title,"DefaultSmall",x+w/2,y+h/2,MAIN_WHITECOLOR,1)
end

local Col = table.Copy(MAIN_COLOR)
Col.a = 255

function ENT:Draw()
	self:DrawModel()
	
	local lp = LocalPlayer()
	
	local Ang = self:GetAngles()
	local Pos = self:GetPos()+self:GetForward()*15+self:GetUp()*90
	
	Ang:RotateAroundAxis(Ang:Forward(),90)
	Ang:RotateAroundAxis(Ang:Right(),-90)
	Ang:RotateAroundAxis(Ang:Forward(),3)
	
	cam.Start3D2D(Pos,Ang,0.15)
		DrawRect(-130,-25,260,62,Col)
		DrawText("Santos ATM","SRP_Font48",0,5,MAIN_TEXTCOLOR,1)
	cam.End3D2D()
	
	Pos = self:GetPos()+self:GetForward()*15+self:GetUp()*15.5
	
	cam.Start3D2D(Pos,Ang,0.15)
		DrawRect(-130,-25,260,62,Col)
		DrawText("Santos ATM","SRP_Font48",0,5,MAIN_TEXTCOLOR,1)
	cam.End3D2D()
	
	Ang:RotateAroundAxis(Ang:Forward(),-3)
	Pos = self:GetPos()+self:GetForward()*15.3+self:GetUp()*80
	
	local mx,my = Panel3D2DCursorPos(Ang,Pos,0.15,self)
	
	cam.Start3D2D(Pos,Ang,0.15)
		DrawSRPRect(0,0,120,150,Col,MAIN_COLOR2)
		
		if (Panel3D2DCursorInBox(mx,my,0,0,120,150)) then
			if (!self.Menu) then
				self.Number = ""
				
				DrawText("Select what you wish","DefaultSmall",7,5,MAIN_WHITECOLOR)
				DrawText("to do below:","DefaultSmall",7,15,MAIN_WHITECOLOR)
				
				local BY = 30
				
				Draw3DButton(mx,my,"Withdraw",10,BY,60,20,function()
					self.Menu = "Withdraw"
				end)
				
				BY = 60
				
				Draw3DButton(mx,my,"Transfer",10,BY,60,20,function()
					self.Menu = "Transfer"
				end)
				
			else
				DrawText("Type how much you","DefaultSmall",7,5,MAIN_WHITECOLOR)
				
				if (self.Menu == "Transfer") then
					DrawText("wish to transfer:","DefaultSmall",7,15,MAIN_WHITECOLOR)
				else
					DrawText("wish to withdraw:","DefaultSmall",7,15,MAIN_WHITECOLOR)
				end
				
				local C = 0
				for x = 0,2 do
					local BX = 10+x*20
					
					for y = 0,2 do
						C = C+1
						local bY = 30+y*20
						
						Draw3DButton(mx,my,C,BX,bY,18,18,function()
							self.Number = self.Number..C
						end)
					end
				end
				
				Draw3DButton(mx,my,"0",10,90,18,18,function()
					self.Number = self.Number.."0"
				end)
				
				
				Draw3DButton(mx,my,"Enter",30,90,38,18,function()
					local num = tonumber(self.Number)
					if (self.Menu == "Transfer") then
						RequestTransferToBank(num)
					else
						RequestTransferFromBank(num)
					end
					
					self.Number = ""
				end)
				
				DrawText(self.Number,"DefaultSmall",10,110,MAIN_WHITECOLOR)
			end
			
			DrawText("Bank: $"..LocalPlayer():GetBankMoney(),"DefaultSmall",7,130,MAIN_WHITECOLOR)
		
			DrawRect(mx-2,my-2,4,4,MAIN_WHITECOLOR)
		else
			DrawText("Santos City ATM","DefaultSmall",60,15,MAIN_WHITECOLOR,1)
			DrawText("(Aim here to use)","DefaultSmall",60,25,MAIN_WHITECOLOR,1)
			
			self.Menu = nil
		end
	cam.End3D2D()
end