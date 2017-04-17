local PANEL = {}

local showMin = 30 --[[from the the health bar should stay faded in
						TODO: add a setting for it]]
local show = 5 --default time for showing

local fadeIn = 3 --default speed for fading
local fadeIn = .5

local healthLerp = 15 --speed at which health interpolates

local width = .25 --percentage of screen height/width of the bar
local height = .05

local posy = .8 --distance from top of sreen to health bar in percent

function PANEL:Init()
	self.usualShow = 5

	self.curFadeInSpeed = fadeIn
	self.curFadeOutSpeed = fadeOut

	self.showUntil = CurTime() + self.usualShow

	self.sw, self.sh = ScrW(), ScrH()

	hook.Add("PlayerHurt", self.OnPlayerHurt)
end

function PANEL:OnPlayerHurt(vic)
	if vic ~= LocalPlayer() then return end
	self:AddShowTime()
end

function PANEL:AddShowTime(time)
	if self:IsShowing() then
		self.showUntil = (CurTime() - self.showUntil) < (time or show) and self.showUntil + (time or show)
	else
		self:FadeIn()
	end
end

function PANEL:IsShowing()
	if CurTime() < self.showUntil then
		return true
	else
		return false
	end
end

function PANEL:FadeIn(showTime, fadeSpeed)
	self.showUntil = CurTime() + (showTime or show)
	self.curFadeInSpeed = fadeSpeed or fadeIn
end

function PANEL:FadeOut(fadeSpeed)
	self.shownUntil = CurTime()
	self.curFadeOutTime = fadeSpeed or fadeOut
end

function PANEL:Draw()

	local fade
	if self:IsShowing() then
		fade = Lerp(self.curFadeInSpeed * FrameTime(), 0, 1)
	else
		fade = Lerp(self.curFadeOutSpeed * FrameTime(), 1, 0)
	end

	surface.SetDrawColor(Color(255, 0, 0, fade * 255))

	local barLength = Lerp(healthLerp * FrameTime(), 0, LocalPlayer():Health()/LocalPlayer():GetMaxHealth()) * width * self.sw
	surface.DrawRect(self.sw/2 - barLength/2, self.sh * posy, barLength,  self.sh * height)

end
vgui.Register("SRPHealthbar", PANEL, "EditablePanel")

local healthPanel
function santosRP.HUD.DrawHealth()
	if healthPanel then return end
	healthPanel = vgui.Create("SRPHealthbar")
end