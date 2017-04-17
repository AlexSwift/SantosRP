local B = {}
local A = {}

function input.IsMouseInBox( x , y , w , h )
	local mx, my = gui.MousePos()
	return (mx > x and mx < x+w and my > y and my < y+h)
end

function input.IsInBox( x2 , y2 , x , y , w , h )
	return (x2 > x and x2 < x+w and y2 > y and y2 < y+h)
end

function input.KeyPress(KEY,ID)
	ID = ID or ""
	if (input.IsKeyDown(KEY) and !IsChatOpen()) then
		if (!A[KEY..ID]) then A[KEY..ID] = true return true
		else return false end
	elseif (A[KEY..ID]) then A[KEY..ID] = false end
end

function input.MousePress(MOUSE,ID)
	ID = ID or ""
	if (input.IsMouseDown(MOUSE)) then
		if (!B[MOUSE..ID]) then B[MOUSE..ID] = true return true
		else return false end
	elseif (B[MOUSE..ID]) then B[MOUSE..ID] = false end
end
