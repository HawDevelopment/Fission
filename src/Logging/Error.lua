--[[
    Error.
    
    Creates a new error object from an error string.
    
    Taken from: https://github.com/Elttob/Fusion/blob/main/src/Logging/parseError.lua
    HawDevelopment
    12/11/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)

return function(err: string): Types.Error
	return {
		type = "Error",
		raw = err,
		message = err:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback("", 2),
	}
end
