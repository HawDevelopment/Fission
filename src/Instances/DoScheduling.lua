--[[
    DoScheduling.
    
    A symbol that indicates if new should use the scheduler or just set the value.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)

return {
	type = "Symbol",
	name = "DoScheduling",
} :: Types.DoScheduling
