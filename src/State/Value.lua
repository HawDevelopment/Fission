--[[
    Value
    
    A way to store reactive state.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local UseState = require(Package.Dependencies.UseState)
local UpdateAll = require(Package.Dependencies.UpdateAll)
local Shared = require(Package.Dependencies.Shared)
local Scheduler = require(Package.Instances.Scheduler)

local Value = {}
Value.__index = Value

-- Returns the current value.
-- Adds the state to CurrentDependencySet, if asDependency isnt false.
function Value:get(asDependency: boolean?)
	if asDependency ~= false and Shared.CurrentDependencySet then
		UseState(self :: Types.Dependency)
	end
	return self._value
end

-- Updates current value.
-- If force is set to true, it will update it even if the value is the same.
function Value:set(newValue: any, force: boolean?)
	if not force and self._value == newValue then
        return
	end
    self._value = newValue
    UpdateAll(self :: Types.Dependency)
end

return function<T>(initialValue: T): Types.Value<T>
	local value = setmetatable({
		type = "State",
		kind = "State",
		_value = initialValue,
		dependentSet = setmetatable({}, { __mode = "k" }),
	}, Value) :: Types.Value<T>

	return value
end
