--[[
    Spring.
    HawDevelopment
    12/18/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local UnpackType = require(Package.Animation.UnpackType)
local SpringScheduler = require(Package.Animation.SpringScheduler)
local UseState = require(Package.Dependencies.UseState)
local Shared = require(Package.Dependencies.Shared)

local Spring = {}
Spring.__index = Spring

-- Returns the current value.
function Spring:get(asDependency: boolean?): any
    if asDependency ~= false and Shared.CurrentDependencySet then
        UseState(self :: Types.Dependency)
    end
    return self._value
end

-- Updates the spring.
-- This is called when:
--  - The goal state is changed.
--  - The spring is started.
--  - Speed / damping changes.
function Spring:update(): boolean
    local goal = self._goalState:get(false)
    
    if goal == self._goal then
        -- The speed / damping has changed, but the goal hasn't.
        -- So we need to reset the springscheduler.
        SpringScheduler.remove(self)
        SpringScheduler.add(self)
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
            SpringScheduler.remove(self)
            return true
        elseif numsprings == 0 then
            -- It cant be animated.
            self._value = goal
            SpringScheduler.remove(self)
            return true
        else
            SpringScheduler.add(self)
        end
    end
end

return function <T>(goalState: Types.Value<any>, speed: Types.CanBeState<number>?, damping: Types.CanBeState<number>): Types.Spring<T>
    speed = if speed == nil then 10 else speed
    damping = if damping == nil then 1 else damping
    
    local dependencySet = { [goalState] = true }
    local speedIsState = type(speed) == "table" and speed.type == "State"
    local dampingIsState = type(damping) == "table" and damping.type == "State"
    
    local self = setmetatable({
        type = "State",
        kind = "Spring",
        dependencySet = dependencySet,
        dependentSet = setmetatable({}, { __mode = "k" }),
        
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
    
    goalState.dependentSet[self :: Types.Dependent] = true
    self:update()
    
    return self
end