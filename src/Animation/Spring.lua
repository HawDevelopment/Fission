--[[
    Spring.
    HawDevelopment
    12/18/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)
local UnpackType = require(Package.Animation.UnpackType)
local SpringScheduler = require(Package.Animation.SpringScheduler)
local UseState = require(Package.Dependencies.UseState)
local Shared = require(Package.Dependencies.Shared)
local Signal = require(Package.Dependencies.Signal)

type SpringClass = {
    __index: any,
    get: (Types.Spring<any>, asDependency: boolean?) -> any,
    update: (Types.Spring<any>) -> boolean,
}

local Spring: SpringClass = {} :: any
Spring.__index = Spring

-- Returns the current value.
function Spring:get(asDependency: boolean?): any
    if asDependency ~= false and Shared.CurrentDependencySet then
        UseState(self :: any)
    end
    return self._value
end

-- Updates the spring.
-- This is called when:
--  - The goal state is changed.
--  - The spring is started.
--  - Speed / damping changes.
function Spring:update(): boolean
    local goal = (self._goalState :: any):get(false)
    
    if goal == self._goal then
        -- The speed / damping has changed, but the goal hasn't.
        -- So we need to reset the springscheduler.
        SpringScheduler.remove(self :: any)
        SpringScheduler.add(self :: any)
        return false
    else
        -- The goal has changed.
        
        local oldtype = self._currentType
        local newtype = typeof(goal)
        local unpackedGoal = UnpackType(goal, newtype)
        local numsprings = #unpackedGoal
        
        self._goal = goal
        self._currentType = newtype
        self._currentGoal = unpackedGoal
        
        if newtype ~= oldtype then
            -- The type has changed.
            
            table.clear(self._currentPosition)
            table.clear(self._currentVelocity)
            local positions = self._currentPosition
            local velocities = self._currentVelocity
            
            for i = 1, numsprings do
                positions[i] = unpackedGoal[i]
                velocities[i] = 0
            end
            
            self._currentPosition = positions
            self._currentVelocity = velocities
            self._value = goal
            SpringScheduler.remove(self :: any)
            return true
        elseif numsprings == 0 then
            -- It cant be animated.
            self._value = goal
            SpringScheduler.remove(self :: any)
            return true
        else
            SpringScheduler.add(self :: any)
        end
    end
end

return function <T>(goalState: Types.Value<any>, speed: Types.CanBeState<number>?, damping: Types.CanBeState<number>): Types.Spring<T>
    speed = if speed == nil then 10 else speed
    damping = if damping == nil then 1 else damping
    
    local speedIsState = type(speed) == "table" and speed.type == "State"
    local dampingIsState = type(damping) == "table" and damping.type == "State"
    
    local self = setmetatable({
        type = "State",
        kind = "Spring",
        _signal = Signal(),
        
        _speed = speed,
        _speedIsState = speedIsState,
        _lastSpeed = nil,
        _damping = damping,
        _dampingIsState = dampingIsState,
        _lastDamping = nil,
        
        _goalState = goalState,
        _goal = nil,
        _currentType = nil,
        _value = nil,
        _currentPosition = { },
        _currentVelocity = { },
        _currentGoal = nil,
    }, Spring) :: any
    
    goalState._signal:connectCallback(function()
        self:update()
    end)
    
    self:update()
    
    return self
end