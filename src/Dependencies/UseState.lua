--[[
    UseState
    
    Adds a state to the shared dependency set.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)
local Shared = require(Package.Dependencies.Shared)

type Set<T> = { [T]: any }

return function(dependency: Types.StateObject<any>)
	local set = Shared.CurrentDependencySet
	if set ~= nil then
		(set :: any)[dependency] = true
	end
end
