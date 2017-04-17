local PANEL = {}

function PANEL:Init()
	self.Lines = {}
	self.Texts = {}
	
	self.LineHeight = 20
end

function PANEL:AddText(text,font,color)
	if (!font) then font = "Trebuchet18" end
	if (!color) then color = MAIN_TEXTCOLOR end
	
	text = " "..text
	
	table.insert(self.Texts,{text,font,color,})
end

function PANEL:ClearText()
	self.Lines = {}
	self.Texts = {}
end

function PANEL:SetupLines()
	local w = 0
	local dat = {}
	local Tal = 20
	
	for k,v in pairs( self.Texts ) do
		surface.SetFont(v[2])
		local a,b = surface.GetTextSize(v[1])
		
		if (b > Tal) then Tal = b end
		
		if (w+a > self:GetWide()) then
			local Exp = string.Explode(" ",v[1])
			local Dat = ""
			local Tab = {}
			local wi  = 0
			
			for p,d in pairs( Exp ) do
				local si,so = surface.GetTextSize(" "..d)
				
				wi = wi + si
				
				if (w+wi < self:GetWide()) then 
					Dat = Dat.." "..d
				else 
					table.insert(dat,{Dat,v[2],v[3],})
					table.insert(self.Lines,dat)
					
					dat 	= {}
					Dat 	= " "..d 
					wi 		= 0 
					w 		= 0
				end
			end
			
			table.insert(dat,{Dat,v[2],v[3],})
		else
			w = w + a
			table.insert(dat,v)
		end
	end
	
	table.insert(self.Lines,dat)
	
	Tal = Tal*#self.Lines
	self:SetTall(Tal)
	
	self.Texts = nil --Since this function is called to setup a wrapped text, we no longer need the table with shit on.
end
	
function PANEL:SetTextColor( col )
end

function PANEL:SetTextFont( font )
end

function PANEL:Paint()
	if (self.Lines) then
		for k,v in pairs(self.Lines) do
			local w = 0
			for c,j in pairs(v) do
				local Text = j[1]
				local Font = j[2]
				local Col  = j[3]
				
				surface.SetFont(Font)
				
				local wid,hei = surface.GetTextSize(Text)
				
				surface.SetTextColor(Col)
				surface.SetTextPos(w,self.LineHeight*(k-1))
				surface.DrawText(Text)
				
				w = w+wid
			end
		end
	end
	
	return true
end
	
function PANEL:PerformLayout()
end
 
vgui.Register( "MBLabel", PANEL , "DLabel" )