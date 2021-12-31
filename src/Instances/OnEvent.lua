--[[
    OnEvent
    
    Creates a new event symbol.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)

local Chache: { [string]: Types.OnEvent } = {}
return function(propertyName: string): Types.OnEvent
	if Chache[propertyName] then
		return Chache[propertyName]
	end
	
    local onevent = {
		type = "Symbol",
		name = "OnEvent",
		key = propertyName,
	} :: Types.OnEvent
    
	Chache[propertyName] = onevent
	return onevent
end
