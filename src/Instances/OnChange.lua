--[[
    OnChange
    
    Creates a new event symbol.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

local Chache: { [string]: Types.OnChange } = {}
return function(propertyName: string): Types.OnChange
	if Chache[propertyName] then
		return Chache[propertyName]
	end
	local onchange = {
		type = "Symbol",
		name = "OnChange",
		key = propertyName,
	} :: Types.OnChange
	Chache[propertyName] = onchange
	return onchange
end
