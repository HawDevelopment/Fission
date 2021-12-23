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
    if self._isfiring then
        table.insert(self._toConnect, callback)
    else
        self._connections[callback] = true
    end
    local connected = true
    return function ()
        if not connected then
            return
        end
        self._connections[callback] = nil
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
    self._isfiring = true
    for callback, _ in pairs(self._connections) do
        callback(...)
    end
    for index, callback in ipairs(self._toConnect) do
        self._connections[callback] = true
        self._toConnect[index] = nil
    end
    for inst, properties in pairs(self._properties) do
        for _, key in ipairs(properties) do
            inst[key] = ...
        end
    end
    self._isfiring = false
end

return function (): Types.Signal
    local self = setmetatable({
        _isfiring = false,
        _properties = {},
        _connections = {},
        _toConnect = {},
    }, Signal) :: any
    
    return self
end