--[[
    Observer.
    
    Binds callbacks for a state.

    HawDevelopment
    12/16/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

type Set<T> = { [T]: any }

local strongRefs: Set<Types.Observer> = {}

local Observer = {}
Observer.__index = Observer

-- Calls all the currently stored courotines.
function Observer:update(_): boolean
	for callback, _ in pairs(self.callbacks) do
        task.defer(callback)
	end

	return false
end

-- Adds a function to the list of listeners.
-- Returns a function that when called will remove the listener.
function Observer:onChange(callback: () -> nil): () -> nil
	self.callbacks[callback] = true

	strongRefs[self :: Types.Observer] = true

	local disconnected = false
	return function()
		if disconnected then
			return
		end
		disconnected = true
		self.callbacks[callback] = false
		if not next(self.callbacks) then
			strongRefs[self :: Types.Observer] = nil
		end
	end
end

return function(state: Types.State<any>): Types.Observer
	if state.observer then
		return state.observer
	end

	local self = setmetatable({
		type = "State",
		kind = "Observer",
		callbacks = {},
		listners = 0,
		dependencySet = { [state] = true },
		dependentSet = {},
	}, Observer) :: Types.Observer

	state.observer = self
	state.dependentSet[self :: Types.Dependent] = true
	return self
end
