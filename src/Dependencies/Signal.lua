--[[
    Signal.
    HawDevelopment
    12/19/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

local Signal = {}
Signal.__index = Signal

local WEAK_TABLE = { __mode = "k" }

function Signal:connectCallback(callback: (...any) -> nil)
    self._connectionsCount += 1
    self._connections[self._connectionsCount] = callback
    local index = self._connectionsCount
    local connected = true
    return function ()
        if not connected then
            return
        end
        
        self._connections[index] = nil
        self._connections[index] = self._connections[self._connectionsCount]
        self._connectionsCount -= 1
        connected = false
    end
end

function Signal:connectProperty(inst, key)
    local tab, index, disconnected = self._properties[inst], nil, false
    if not tab then
        self._properties[inst], index = { key }, 1
    else
        table.insert(tab, key)
        index = #tab
    end
    return function ()
        if disconnected then
            return
        end
        disconnected = true
        tab[index] = nil
        local length = #tab
        if length == 0 then
            self._properties[inst] = nil
        else
            tab[index] = tab[length]
            tab[length] = nil
        end
    end
end

function Signal:fire(...)
    for _, callback in ipairs(self._connections) do
        callback(...)
    end
    for inst, properties in pairs(self._properties) do
        for _, key in ipairs(properties) do
            inst[key] = ...
        end
    end
end

return function (weak: boolean?): Types.Signal
    local self = setmetatable({
        _properties = { },
        _connections = if weak then setmetatable({}, WEAK_TABLE) else {},
        _connectionsCount = 0,
    }, Signal) :: any
    
    return self
end