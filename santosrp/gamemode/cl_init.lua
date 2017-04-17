
include("shared.lua")

hook.Remove("PlayerBindPress","CameraScroll")
hook.Remove("CalcView","View")

function GM:Initialize()
	self:SetEnableMawNameTag(false)
	self:SetEnableMawCircle(false)
	self:EnableMOTD(false)
	self:SetEnableThirdPerson(false)
	self:SetEnableMawChat(false)
	
	self.PixelHand		= util.GetPixelVisibleHandle()
	
	santosRP.Items.LoadItems()
	GeneratePropItems()
	
end

function GM:ShouldDrawLocalPlayer()
	if (IsValid(GetCraftingTab())) then return true end
	
	local VC = LocalPlayer():GetVehicle()
	return (IsValid(VC) and VC:GetThirdPersonMode())
end

function GM:ForceDermaSkin()
	return "SantosRP"
end