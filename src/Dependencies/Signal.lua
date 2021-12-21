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
    self._propertiesCount += 1
    self._properties[self._propertiesCount] = { inst, key }
    local index = self._propertiesCount
    local connected = true
    return function ()
        if not connected then
            return
        end
        self._properties[index] = nil
        self._properties[index] = self._properties[self._propertiesCount]
        self._propertiesCount -= 1
        connected = false
    end
end

function Signal:fire(...)
    if self._connectionsCount >= 0 then
        for _, callback in ipairs(self._connections) do
            callback(...)
        end
    end
    if self._propertiesCount >= 0 then
        for _, property in ipairs(self._properties) do
            property[1][property[2]] = ...
        end
    end
end

return function (weak: boolean?): Types.Signal
    local self = setmetatable({
        _properties = { },
        _propertiesCount = 0,
        _connections = if weak then setmetatable({}, WEAK_TABLE) else {},
        _connectionsCount = 0,
    }, Signal) :: any
    
    return self
end