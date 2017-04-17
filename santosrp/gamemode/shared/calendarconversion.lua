


function ConvertToCalendar(Time)
	local Data = os.date( "%A,%d,%B,%m,%Y", Time )
	return string.Explode(",",Data)
end

	
	