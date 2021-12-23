--[[
    Tween.
    HawDevelopment
    12/22/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local Signal = require(Package.Dependencies.Signal)
local UseState = require(Package.Dependencies.UseState)
local TweenScheduler = require(Package.Animation.TweenScheduler)

local Tween = {}
Tween.__index = Tween

-- Gets the current value
function Tween:get(asDependency: boolean): any
    if asDependency ~= false then
        UseState(self :: any)
    end
    return self._value
end

-- Initates a new tween.
function Tween:update(): boolean
	self._prevValue = self._value
	self._nextValue = self._goalState:get(false)

	self._currentTweenStartTime = os.clock()
	self._currentTweenInfo = self._tweenInfo

	local tweenDuration = self._tweenInfo.DelayTime + self._tweenInfo.Time
	if self._tweenInfo.Reverses then
		tweenDuration += self._tweenInfo.Time
	end
	tweenDuration *= math.max(self._tweenInfo.RepeatCount, 1)
	self._currentTweenDuration = tweenDuration

	-- start animating this tween
	TweenScheduler.add(self :: any)
	return false
end

return function <T>(goalState: Types.Value<any>, tweenInfo: TweenInfo?): Types.Tween<T>
    
    local currentValue = (goalState :: any):get(false)
    
    local self = setmetatable({
        type = "State",
        kind = "Tween",
        _signal = Signal(),
        
        _goalState = goalState,
		_tweenInfo = tweenInfo or TweenInfo.new(),
        
        _prevValue = currentValue,
		_nextValue = currentValue,
		_value = currentValue,
        
        _currentTweenInfo = tweenInfo,
		_currentTweenDuration = 0,
		_currentTweenStartTime = 0
    }, Tween) :: any
    
    goalState._signal:connectCallback(function()
        self:update()
    end)
    
    return self
end