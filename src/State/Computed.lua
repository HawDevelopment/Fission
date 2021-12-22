--[[
    Computed.
    
    A way to change state.

    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local Capture = require(Package.Dependencies.Capture)
local UseState = require(Package.Dependencies.UseState)
local LogError = require(Package.Logging.LogError)
local Signal = require(Package.Dependencies.Signal)

local Computed = {}
Computed.__index = Computed

-- Returns the current value.
-- Also adds the computed to CurrentDependencySet if asDependency isnt false.
function Computed:get(asDependency: boolean?): any
	if asDependency ~= false then
		UseState(self :: any)
	end
	return self._value
end

-- Captures all used state inside the function.
function Computed:capture()
    -- Disconnect all connections and remove them.
	for index, func in pairs(self._connections) do
        func()
        self._connections[index] = nil
	end

	-- Store the old value, so if it errors we can revert.
	self._oldDependencySet, self._dependencySet = self._dependencySet, self._oldDependencySet
	table.clear(self._dependencySet)
    
	local ok, value = Capture(self._dependencySet, self._callback)
    
    if not ok then
        LogError("computedCallbackError", value, false)
        self._oldDependencySet, self._dependencySet = self._dependencySet, self._oldDependencySet
    else
        self._value = value
    end
    
    for dependency, _ in pairs(self._dependencySet) do
        if self.recapture == false then
            self._connections[dependency] = dependency._signal:connectCallback(function()
                self._value = self._callback()
                self._signal:fire(self._value)
            end)
        else
            self._connections[dependency] = dependency._signal:connectCallback(function()
                self:capture()
            end)
        end
    end
    
end

return function<T>(callback: () -> T, recapture: boolean?): Types.Computed<T>
	local computed = setmetatable({
		type = "State",
		kind = "Computed",
		recapture = recapture,
		_value = nil,
		_signal = Signal(),
        
        _connections = {},
		_dependencySet = {},
        _oldDependencySet = {},
        
        _callback = callback,
	}, Computed) :: any
    
    -- Intialize the value.
	computed:capture()

	return computed
end
