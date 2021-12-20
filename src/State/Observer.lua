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

-- Adds a function to the list of listeners.
-- Returns a function that when called will remove the listener.
function Observer:onChange(callback: () -> nil): () -> nil
    self.listeners += 1
    local disconnect = self.state._signal:connect(callback)
	strongRefs[self :: Types.Observer] = true

	local disconnected = false
	return function()
		if disconnected then
			return
		end
		disconnect()
        self.listeners -= 1
        if self.listeners == 0 then
            strongRefs[self :: Types.Observer] = nil
        end
	end
end

return function(state: Types.StateObject<any>): Types.Observer
	if state.observer then
		return state.observer :: Types.Observer
	end

	local self = setmetatable({
		type = "State",
		kind = "Observer",
		listeners = 0,
        state = state,
	}, Observer) :: Types.Observer

	state.observer = self
	return self
end
