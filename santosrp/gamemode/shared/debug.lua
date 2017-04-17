santosRP.debug = {}

function santosRP.debug.print(...)
	if not santosRP.isBeta then return end
	MsgC(..., "\n")
end

function santosRP.debug.printSuccess(...)
	santosRP.debug.print(Color(0, 255, 0), ...)
end

function santosRP.debug.printProgress(...)
	santosRP.debug.print(Color(255, 165, 0), ...)
end

function santosRP.debug.printError(...)
	santosRP.debug.print(Color(255, 0, 0), "[SantosRP Error]", Color(255, 255, 255), debug.getinfo(2).source, ":", debug.getinfo(2).currentline, "\n", Color(255, 0, 0), ...)
end