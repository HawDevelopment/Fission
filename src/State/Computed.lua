--[[
    Computed.
    
    A way to change state.

    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)
local Capture = require(Package.Dependencies.Capture)
local UseState = require(Package.Dependencies.UseState)
local LogError = require(Package.Logging.LogError)
local Signal = require(Package.Dependencies.Signal)
local Shared = require(Package.Dependencies.Shared)

type ComputedClass = {
    __index: any,
    get: (Types.Computed<any>, asDependency: boolean?) -> any,
    capture: (Types.Computed<any>) -> (),
}

local Computed: ComputedClass = {} :: any
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
	for _, func in pairs(self._connections) do
        func()
	end
    table.clear(self._connections)

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
            table.insert(self._connections, dependency._signal:connectCallback(function()
		        local last = Shared.CurrentDependencySet
		        Shared.CurrentDependencySet = nil
                self._value = self._callback()
		        Shared.CurrentDependencySet = last
                self._signal:fire(self._value)
            end))
        else
            table.insert(self._connections, dependency._signal:connectCallback(function()
                self:capture()
            end))
        end
    end
    
    if ok then
        self._signal:fire(self._value)
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
