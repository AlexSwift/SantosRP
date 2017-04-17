TOOL.Category		=	"SaveProps"
TOOL.Name			=	"PermaProps"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

if(CLIENT)then
	language.Add("Tool.permaprops.name", "PermaProps")
	language.Add("Tool.permaprops.desc", "Save a props permanently")
	language.Add("Tool.permaprops.0", "LeftClick: Add RightClick: Remove Reload: Update")
end

function TOOL:LeftClick(trace)

	if (CLIENT) then return end

	if (not trace.Entity:IsValid()) then return end

	self:GetOwner():ConCommand('perma_save')

	return true

end

function TOOL:RightClick(trace)

	if (CLIENT) then return end

	if (not trace.Entity:IsValid()) then return end

	self:GetOwner():ConCommand('perma_remove')

	return true

end

function TOOL:Reload(trace)

	if (CLIENT) then return end

	if (not trace.Entity:IsValid()) then ReloadPermaProps() return false end

	if trace.Entity.PermaProps then

		self:GetOwner():ConCommand('perma_update')

	else

		return false

	end

	return true

end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "PermaProps", Description = "Save a props for server restarts\nBy Malboro"})

end
