--[[
    Binding.
    
    A way to create a performant computed for one value.
    
    HawDevelopment
    12/31/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local UseState = require(Package.Dependencies.UseState)
local Shared = require(Package.Dependencies.Shared)
local Signal = require(Package.Dependencies.Signal)

type BindingClass = {
    get: (asDependency: boolean?) -> any,
}

local Binding = {}
Binding.__index = Binding

function Binding:get(asDependency: boolean?)
    if asDependency ~= false and Shared.CurrentDependencySet then
        UseState(self :: any)
    end
    return self._value
end

function Binding:update(newValue: any)
    local callbackValue = self._callback(newValue)
    if callbackValue ~= nil then
        self._value = callbackValue
        self._signal:fire(callbackValue)
        return true
    end
    return false
end

return function <T>(value: Types.Value<any>, callback: (any) -> any): Types.Binding<T>
    local binding = setmetatable({
        type = "State",
        kind = "Binding",
        _callback = callback,
        _value = nil,
        _signal = Signal()
    }, Binding)
    
    binding:update(value:get(false))
    value._signal:connectCallback(function(newValue: any)
        binding:update(newValue)
    end)
    
    return binding :: any
end
