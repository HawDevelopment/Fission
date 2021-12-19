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
local Scheduler = require(Package.Instances.Scheduler)

local Computed = {}
Computed.__index = Computed

-- Returns the current value.
-- Also adds the computed to CurrentDependencySet if asDependency isnt false.
function Computed:get(asDependency: boolean?): any
	if asDependency ~= false then
		UseState(self :: Types.Dependency)
	end
	return self._value
end

-- Captures all used state inside the function.
function Computed:capture()
    -- remove this from all dependencies (so we dong get looping dependencies)
	for dependency, _ in pairs(self.dependencySet) do
		dependency.dependentSet[self] = nil
	end

	-- Store the old value, so if it errors we can revert.
	self._oldDependencySet, self.dependencySet = self.dependencySet, self._oldDependencySet
	table.clear(self.dependencySet)

	local ok, value = Capture(self.dependencySet, self._callback)

	if ok then
		local changed = value ~= self._value
		self._value = value

		-- Readd dependencies
		for dependency, _ in pairs(self.dependencySet) do
			dependency.dependentSet[self] = true
		end
		return changed
	else
		LogError("computedCallbackError", value, false)

		-- Revert and then readd dependencies
		self._oldDependencySet, self.dependencySet = self.dependencySet, self._oldDependencySet
		for dependency, _ in pairs(self.dependencySet) do
			dependency.dependentSet[self] = true
		end
		return false
	end
end

-- Recalculates the value.
-- Returns wether the value changed.
function Computed:update(): boolean
	-- Dont update if we dont want to.
	if self.recapture == false then
		local value = self._callback()
		local changed = self._value ~= value
		self._value = value
		return changed
    else
        return self:capture()
	end
end

return function<T>(callback: () -> T, recapture: boolean?): Types.Computed<T>
	local computed = setmetatable({
		type = "State",
		kind = "Computed",
		recapture = recapture,
		_value = nil,
		dependencySet = { },
		dependentSet = setmetatable({}, { __mode = "k" }),
		_callback = callback,
		_oldDependencySet = {},
	}, Computed) :: any
    
    -- Intialize the value.
	computed:capture()

	return computed
end
