local Blocks = {}

function GM:AddBlockCHud(Str)
	if (!table.HasValue(Blocks,Str)) then table.insert(Blocks,Str) end
end

hook.Add( "HUDShouldDraw", "ShouldDraw", function( name )
	if (table.HasValue(Blocks,name)) then return false end 
end)