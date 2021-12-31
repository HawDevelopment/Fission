--[[
    Value
    
    A way to store reactive state.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)
local UseState = require(Package.Dependencies.UseState)
local Shared = require(Package.Dependencies.Shared)
local Signal = require(Package.Dependencies.Signal)
local Binding = require(Package.State.Binding)

type ValueClass = {
    __index: any,
    get: (Types.Value<any>, asDependency: boolean) -> any,
    bind: (Types.Value<any>, callback: (any) -> any) -> Types.Binding,
    set: (newValue: any, force: boolean?) -> (),
}

local Value: ValueClass = {} :: any
Value.__index = Value

-- Returns the current value.
-- Adds the state to CurrentDependencySet, if asDependency isnt false.
function Value:get(asDependency: boolean?)
	if asDependency ~= false and Shared.CurrentDependencySet then
		UseState(self :: any)
	end
	return self._value
end

-- Binds a function to the value.
function Value:bind(callback: (any) -> any)
    return Binding(self, callback)
end

-- Updates current value.
-- If force is set to true, it will update it even if the value is the same.
function Value:set(newValue: any, force: boolean?)
	if not force and self._value == newValue then
        return
	end
    self._value = newValue
    self._signal:fire(newValue)
end

return function<T>(initialValue: T): Types.Value<T>
	local value = setmetatable({
		type = "State",
		kind = "State",
		_value = initialValue,
        _signal = Signal(),
	}, Value) :: any

	return value
end
