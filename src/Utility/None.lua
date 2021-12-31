--[[
    Defined Nothing or nil
    HawDevelopment
    12/16/2021
--]]

--[[
	A symbol for representing nil values in contexts where nil is not usable.
]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)

return {
	type = "Symbol",
	name = "None",
} :: Types.None
