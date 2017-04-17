santosRP.ui = {}
santosRP.ui.utils = {}

local blurTex = Material("pp/blurscreen")

function santosRP.ui.utils.drawBlur(x, y, w, h, passes, divisor, amount)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blurTex)

	for i = 1, passes or 3 do
		blurTex:SetFloat("$blur", i / (divisor or 5) * (amount or 2))
		blurTex:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x, y, w, h)
	end
end

function santosRP.ui.utils.drawBlurredPanel(panel, ...)
	local x, y = panel:LocalToScreen(0, 0)
	local w, h = ScrW(), ScrH()

	santosRP.ui.utils.drawBlur(x * -1, y * -1, w, h, ...)
end