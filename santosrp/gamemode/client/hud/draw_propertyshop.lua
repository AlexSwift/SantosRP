function santosRP.HUD.openVehicleShop()
	if fram then fram:Remove() end

	fram = vgui.Create("DFrame")
	fram:SetTitle("Property Shop")
	fram:SetSize(ScrW()*.5, ScrH()*.75)
	fram:Center()

	local scr = vgui.Create("DScrollPanel", fram)
	scr:Dock(FILL)
	scr:SetSize(fram:GetWide(), fram:GetTall())

	for k, prop in ipairs(santosRP.Property.GetPropertytable()) do
		if prop:HasOwner() and prop:GetOwner() ~= LocalPlayer() then continue end

		local item = vgui.Create("DPanel", scr)
		item:SetSize(scr:GetWide(), scr:GetTall() * .33)
		item:SetPos(0, 0)
		item:Dock(TOP)
		item.Paint = function() end

		local name = vgui.Create("DPanel", item)
		name:SetWide(item:GetWide() * .47)
		name:Dock(LEFT)
		local x, y = name:GetPos()
		name.Paint = function()
			draw.SimpleText(prop:GetName(), "Trebuchet24" , x+name:GetWide()/2, y+name:GetTall()/2-25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("$"..prop:GetPrice(), "Trebuchet24" , x+name:GetWide()/2, y+name:GetTall()/2+25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(prop:GetDoorNumber().." doors", "Trebuchet24" , x+name:GetWide()/2, y+name:GetTall()/2+50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = vgui.Create("SRPButton", item)
		btn:SetWide(item:GetWide()*.2)
		btn:Dock(RIGHT)
		btn:SetText(prop:IsOwned() and "OWNED" or "Purchase")
		btn.DoClick = function()
			prop:RequestBuy()
		end
	end

	fram:MakePopup()
end

net.Receive("OpenShopProperty", santosRP.HUD.openVehicleShop)