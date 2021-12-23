--[[
    GetTweenRatio.
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Animation/getTweenRatio.lua
    HawDevelopment
    12/23/2021
--]]

local TweenService = game:GetService("TweenService")

return function (tweenInfo: TweenInfo, currentTime: number): number
    local delay = tweenInfo.DelayTime
	local duration = tweenInfo.Time

	local cycleDuration = delay + duration
	if tweenInfo.Reverses then
		cycleDuration += duration
	end

	if currentTime >= cycleDuration * math.max(tweenInfo.RepeatCount, 1) then
		return 1
	end

	local cycleTime = currentTime % cycleDuration

	if cycleTime <= delay then
		return 0
	end

	local tweenProgress = (cycleTime - delay) / duration
	if tweenProgress > 1 then
		tweenProgress = 2 - tweenProgress
	end
    
    return TweenService:GetValue(tweenProgress, tweenInfo.EasingStyle, tweenInfo.EasingDirection)
end