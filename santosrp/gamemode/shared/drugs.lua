
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("CommitDrug")
	
	function meta:CommitDrug(seed)
		if (self.DrugTime and self.DrugTime > CurTime()) then self:ChatPrint("Woah there dude! Take it easy on them drugz!") return false end
		
		math.randomseed(seed)
		
		local Time = math.random(40,160)
		self.DrugTime = CurTime()+Time
		
		net.Start("CommitDrug")
			net.WriteUInt(seed,32)
		net.Send(self)
		
		return true
	end
	hook.Add("Tick","DrugReset",function()
		for k,v in pairs(player.GetAll()) do
			if (v.DrugTime and !v:Alive()) then
				v.DrugTime = nil
			end
		end
	end)
else
	local DrugData = {}
	
	function ThinkDrugData()
		local lp = LocalPlayer()
		if (!IsValid(lp)) then return end
		
		if (!lp:Alive() and DrugData and DrugData.Time) then
			DrugData.Time = nil
		end
	end
	
	net.Receive("CommitDrug",function()
		DrugData.Seed = net.ReadUInt(32)
		
		math.randomseed(DrugData.Seed)
		
		DrugData.Length = math.random(40,160)
		DrugData.Time 	= CurTime()+DrugData.Length
		
		DrugData.ColorStrength = math.Rand(0,10)
		DrugData.BloomStrength = math.Rand(0,10)
		DrugData.SobelStrength = math.Rand(0,1)
		DrugData.ColorModify   = Color(math.random(0,255),math.random(0,255),math.random(0,255))
	end)
		
	local Seed = 0
	local CD = CurTime()
		
	function GM:RenderScreenspaceEffects()
		if (!DrugData.Time or DrugData.Time < CurTime()) then return end
		
		local Time = CurTime()
		local Dif = DrugData.Time-Time
		local Ab  = 180/DrugData.Length
		
		local Arc  = math.min(1,2*math.sin(math.rad(Ab*Dif)))
		
		DrawBloom( 0.65, Arc*DrugData.BloomStrength, 9, 9, 1, DrugData.ColorStrength, 1, 1, 1 )
		DrawSharpen( 1*Arc*DrugData.SobelStrength,100*Arc*DrugData.SobelStrength)
		
		local tab =
		{
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 1,
			[ "$pp_colour_colour" ] = 1+DrugData.ColorStrength*Arc,
			[ "$pp_colour_mulr" ] = DrugData.ColorModify.r/255*Arc,
			[ "$pp_colour_mulg" ] = DrugData.ColorModify.g/255*Arc,
			[ "$pp_colour_mulb" ] = DrugData.ColorModify.b/255*Arc
		}
		
		DrawColorModify( tab )
	end
	
	hook.Add("Tick","DrugReset",ThinkDrugData)
end


