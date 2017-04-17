
local _PLAYER = FindMetaTable( 'Player' )

hook.Add( 'Initialize', 'InitializeSkills', function()

	local callback = function( owner, action )
	
		owner:SaveSkills( )
		
	end

	santosRP.Flags:CreateClass( 'Skills', callback )

	santosRP.Flags:CreateFlag( 'Skills', 'b_CanFish', 0 )
	santosRP.Flags:CreateFlag( 'Skills', 'b_CanDrive', 1 )
	
end)

function _PLAYER:CreateSkillsFlags( FL_BLOB )

	self.Skills = santosRP.Flags.new( 'Skills', self )
	self.Skills:SetFlags( FL_BLOB )
	
end

function _PLAYER:GetSkills( )

	return self.Skills
	
end

function _PLAYER:SaveSkills( )

	if not SERVER then return end
	
	GAMEMODE.Database:RawQuery( "UPDATE `santosrp`.`player_skills` SET skills=" .. self:GetSkills( ):GetFlags( ) .." WHERE player_id=" .. self.MySQLID ..";" )

end

