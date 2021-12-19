--[[
    Shared
    
    All state is captured and stored here.
    
    HawDevelopment
    12/11/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

type Set<T> = { [T]: any }

type Shared = {
	CurrentDependencySet: Set<Types.Dependency>?,
}

local Shared = {}

-- The set where state should be updated to.
Shared.CurrentDependencySet = nil

return Shared :: Shared