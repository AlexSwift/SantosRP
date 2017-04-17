local fram
function santosRP.HUD.openVehicleShop()
	if fram then fram:Remove() end
	fram = vgui.Create("DFrame")
	fram:SetSize(ScrW()*.5, ScrH()*.75)
	fram:Center()

	local scr = vgui.Create("DScrollPanel", fram)
	scr:Dock(FILL)
	scr:SetSize(fram:GetWide(), fram:GetTall())

	for k, veh in ipairs(santosRP.Vehicles.GetCarList()) do
		local item = vgui.Create("DPanel", scr)
		item:SetSize(scr:GetWide(), scr:GetTall() * .33)
		item:SetPos(0, 0)
		item:Dock(TOP)
		item.Paint = function() end

		local mdl = vgui.Create("DModelPanel", item)
		mdl:SetWide(item:GetWide() * .33)	
		mdl:SetModel(veh:GetModel())
		mdl:SetCamPos(Vector(250, 0, 50))
		mdl:SetLookAt(Vector(0, 0, 0))
		mdl:Dock(LEFT)

		local name = vgui.Create("DPanel", item)
		name:SetWide(item:GetWide() * .47)
		name:Dock(LEFT)
		local x, y = name:GetPos()
		name.Paint = function()
			draw.SimpleText(veh:GetName(), "Trebuchet24" , x+name:GetWide()/2, y+name:GetTall()/2-25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("$"..veh:GetPrice(), "Trebuchet24" , x+name:GetWide()/2, y+name:GetTall()/2+25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = vgui.Create("SRPButton", item)
		btn:SetWide(item:GetWide()*.2)
		btn:Dock(RIGHT)
		btn:SetText(LocalPlayer().Vehicles[veh:GetName()] and "Spawn" or "Purchase")
		btn:SetColor(LocalPlayer().Vehicles[veh:GetName()] and Color(0, 255, 0) or Color(255, 0, 0))
		btn.DoClick = function()
			if LocalPlayer().Vehicles[veh:GetName()] then
				santosRP.Vehicles.RequestBuyVehicle(veh:GetName())
			else
				santosRP.Vehicles.RequestSpawnVehicle(veh:GetName())
			end
		end

	end

	fram:MakePopup()
end

concommand.Add("srp_open_veh", santosRP.HUD.openVehicleShop)