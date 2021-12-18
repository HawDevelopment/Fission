--[[
    UseState
    
    Adds a state to the shared dependency set.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local Shared = require(Package.Dependencies.Shared)

return function(dependency: Types.Dependency)
	local set = Shared.CurrentDependencySet
	if set ~= nil then
		set[dependency] = true
	end
end
