--[[
    LogError.
    
    Prints an error message to the console.
    
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Logging/logErrorNonFatal.lua
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local Messages = require(Package.Logging.Messages)

return function(messageID: string, errObj: Types.Error | nil, fatal: boolean?, ...)
	local formatString: string = if Messages[messageID] then Messages[messageID] else messageID
	local str
	if not errObj then
		str = string.format("[Fission] " .. formatString .. "\n(ID: " .. messageID .. ")", ...)
	else
		formatString = formatString:gsub("ERROR_MESSAGE", errObj.message)
		str = string.format(
			"[Fission] " .. formatString .. "\n(ID: " .. messageID .. ")\n---- Stack trace ----\n" .. errObj.trace,
			...
		)
	end

	if not fatal then
		task.spawn(function(...)
			error(str:gsub("\n", "\n    "), 0)
		end, ...)
	else
		error(str:gsub("\n", "\n    "), 0)
	end
end
