--[[
    Signal.
    HawDevelopment
    12/19/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

local Signal = {}
Signal.__index = Signal

function Signal:connect(callback: (...any) -> nil)
    self._connections[callback] = true
    local connected = true
    return function ()
        if not connected then
            return
        end
        
        self._connections[callback] = nil
        connected = false
    end
end

function Signal:fire(...)
    for callback, _ in pairs(self._connections) do
        callback(...)
    end
end

return function (weak: boolean?): Types.Signal
    local self = setmetatable({
        _connections = if weak then setmetatable({}, {__mode = "k"}) else {},
    }, Signal) :: any
    
    return self
end