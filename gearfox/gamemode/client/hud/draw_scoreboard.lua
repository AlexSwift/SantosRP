local SCOREBOARD_FADE 	= Color(20,20,20,70)

local SCOREBOARD_OFF	= 101
local SCOREBOARD_WIDTH 	= 700
local SCOREBOARD_X 		= ScrW() / 2 - SCOREBOARD_WIDTH / 2

function GM:ScoreboardShow()
	self.ShowSB = true
end

function GM:ScoreboardHide()
	self.ShowSB = false
end

function GM:HUDDrawScoreBoard()
	if (!self.ShowSB) then return end
	
	local NPly 		= #player.GetAll()
	local Tall 		= SCOREBOARD_OFF + 20 * NPly + 20
	local y 		= ScrH() / 2 - Tall / 2
	local by 		= y + SCOREBOARD_OFF
	
	DrawBoxy(SCOREBOARD_X, y, SCOREBOARD_WIDTH, Tall, MAIN_COLOR)
	DrawRect(SCOREBOARD_X, by, SCOREBOARD_WIDTH, NPly*20, MAIN_COLORD)
	
	DrawText(self.Name, "ScoreboardFont", SCOREBOARD_X + 20, y + 20, MAIN_TEXTCOLOR)
	
	for k,v in pairs( player.GetAll() ) do
		local Y = by + 20 * (k-1)
		
		DrawText(v:Nick(), "Trebuchet18", SCOREBOARD_X + 2, Y, MAIN_TEXTCOLOR)
		DrawText(v:Ping(), "Trebuchet18", SCOREBOARD_X + SCOREBOARD_WIDTH - 30, Y, MAIN_TEXTCOLOR)
	end
end

