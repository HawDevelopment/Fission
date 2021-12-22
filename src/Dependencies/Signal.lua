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
    local tab, index = self._properties[inst], 1
    if not tab then
        tab = { key }
        self._properties[inst] = tab
    else
        table.insert(tab, key)
        index = #tab
    end
    local connected = true
    return function ()
        if not connected then
            return
        end
        tab[index] = nil
        if #tab == 0 then
            self._properties[inst] = nil
        end
        connected = false
    end
end

function Signal:fire(...)
    if self._connectionsCount >= 0 then
        for _, callback in ipairs(self._connections) do
            callback(...)
        end
    end
    for inst, properties in pairs(self._properties) do
        for _, key in ipairs(properties) do
            inst[key] = ...
        end
    end
end

return function (): Types.Signal
    local self = setmetatable({
        _properties = { },
        _connections = {},
        _connectionsCount = 0,
    }, Signal) :: any
    
    return self
end