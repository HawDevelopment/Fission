--[[
    Signal.
    HawDevelopment
    12/19/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

local Signal = {}
Signal.__index = Signal

function Signal:connectCallback(callback: (...any) -> nil)
    if self._isfiring then
        self._shouldConnect = true
        table.insert(self._toConnect, callback)
    else
        table.insert(self._connections, callback)
    end
    local connected = true
    return function ()
        if not connected then
            return
        end
        connected = false
        local index = table.find(self._connections, callback)
        if index then
            self._connections[index] = nil
        end
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
    for _, callback in ipairs(self._connections) do
        callback(...)
    end
    if self._shouldConnect then
        self._shouldConnect = false
        for index, callback in ipairs(self._toConnect) do
            table.insert(self._connections, callback)
            self._toConnect[index] = nil
        end
    end
    for inst, properties in pairs(self._properties) do
        for _, key in ipairs(properties) do
            inst[key] = ...
        end
    end
    self._isfiring = false
end

local WEAK_KEYS_TABLE = { __mode = "k" }

return function (): Types.Signal
    local self = setmetatable({
        _isfiring = false,
        _shouldConnect = false,
        _properties = setmetatable({}, WEAK_KEYS_TABLE),
        _connections = {},
        _toConnect = {},
    }, Signal) :: any
    
    return self
end