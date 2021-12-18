--[[
    Capture.
    
    Gets all the used states in a function.
    Also returns the return of the function.
    
    HawDevelopment
    12/11/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local Shared = require(Package.Dependencies.Shared)
local Error = require(Package.Logging.Error)

type Set<T> = { [T]: any }

return function(saveto: Set<Types.Dependency>, func: (...any) -> any, ...)
	local prevDependencySet = Shared.CurrentDependencySet
	Shared.CurrentDependencySet = saveto

	local ok, ret = xpcall(func, Error, ...)

	Shared.CurrentDependencySet = prevDependencySet
	return ok, ret
end
