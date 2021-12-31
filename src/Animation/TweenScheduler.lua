--[[
    TweenScheduler.
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Animation/TweenScheduler.lua
    HawDevelopment
    12/22/2021
--]]

local RunService = game:GetService("RunService")

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)
local GetTweenRatio = require(Package.Animation.GetTweenRatio)
local LerpType = require(Package.Animation.LerpType)

type Set<T> = { [T]: any }

local TweenScheduler = {}

local tweens: Set<Types.Tween<any>> = {}

-- Adds a tween to the scheduler.
function TweenScheduler.add(tween: Types.Tween<any>)
    tweens[tween :: any] = true
end

-- Removes a tween from the scheduler.
function TweenScheduler.remove(tween: Types.Tween<any>)
    tweens[tween :: any] = nil
end

local function Update()
    local now = os.clock()
	for tween in pairs(tweens) do
		local currentTime = now - tween._currentTweenStartTime

		if currentTime > tween._currentTweenDuration then
			if tween._currentTweenInfo.Reverses then
				tween._value = tween._prevValue
			else
				tween._value = tween._nextValue
			end
			tween._signal:fire(tween._value)
			TweenScheduler.remove(tween :: any)
		else
			local ratio = GetTweenRatio(tween._currentTweenInfo, currentTime)
			local currentValue = LerpType(tween._prevValue, tween._nextValue, ratio)
			tween._value = currentValue
            tween._signal:fire(tween._value)
		end
	end
end

RunService:BindToRenderStep(
	"__FissionTweenScheduler",
	Enum.RenderPriority.First.Value,
	Update
)

return TweenScheduler