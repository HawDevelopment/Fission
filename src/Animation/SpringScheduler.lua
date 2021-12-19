--[[
    SpringScheduler.
    
    Batches spring updates.
    
    HawDevelopment
    12/18/2021
--]]

local RunService = game:GetService("RunService")

local Package = script.Parent.Parent
local Types = require(Package.Types)
local PackType = require(Package.Animation.PackType)
local UpdateAll = require(Package.Dependencies.UpdateAll)
local LogError = require(Package.Logging.LogError)
local SpringCoefficients = require(Package.Animation.SpringCoefficients)

-- Change this to something lower for more precision
local EPSILON = 0.001

type Set<T> = { [T]: any }

local SpringScheduler = {}

local Buckets: { [number]: { [number]: Set<any> } } = {}

function SpringScheduler.add(spring: any)
    local damping = if spring._dampingIsState then spring._damping:get(false) else spring._damping
    local speed = if spring._speedIsState then spring._speed:get(false) else spring._speed
    
    if typeof(damping) ~= "number" then
        LogError("mistypedSpringDamping", nil, true, typeof(damping))
    elseif damping < 0 then
        LogError("invalidSpringDamping", nil, true, damping)
    elseif typeof(speed) ~= "number" then
        LogError("mistypedSpringSpeed", nil, true, typeof(speed))
    elseif speed < 0 then
        LogError("invalidSpringSpeed", nil, true, speed)
    end
    
    spring._lastSpeed = speed
    spring._lastDamping = damping
    
    local bucket = Buckets[damping]
    if not bucket then
        bucket = {}
        Buckets[damping] = bucket
    end
    local speedBucket = bucket[speed]
    if not speedBucket then
        speedBucket = {}
        bucket[speed] = speedBucket
    end
    speedBucket[spring] = true
end

function SpringScheduler.remove(spring: any)
    local damping = spring._lastDamping
    local speed = spring._lastSpeed
    if not Buckets[damping] or not Buckets[damping][speed] then
        return
    end
    Buckets[damping][speed][spring] = nil
end

local function Update(dt: number)
    for damping, bucket in ipairs(Buckets) do
        for speed, speedBucket in ipairs(bucket) do
            local posPosCoef, posVelCoef, velPosCoef, velVelCoef = SpringCoefficients(dt, damping, speed)
            
            for spring, _ in pairs(speedBucket) do
                local goals = spring._currentGoal
                local pos = spring._currentPosition
                local vel = spring._currentVelocity
                
                local moving = false
                
                for index, goal in ipairs(goals) do
                    local oldPosition = pos[index]
					local oldVelocity = vel[index]

					local oldDisplacement = oldPosition - goal

					local newDisplacement = oldDisplacement * posPosCoef + oldVelocity * posVelCoef
					local newVelocity = oldDisplacement * velPosCoef + oldVelocity * velVelCoef

					if
						math.abs(newDisplacement) > EPSILON or
						math.abs(newVelocity) > EPSILON
					then
						moving = true
					end

					pos[index] = newDisplacement + goal
					vel[index] = newVelocity
                end
                
                if moving then
                    spring._value = PackType(pos, spring._currentType)
                    UpdateAll(spring)
                else
                    SpringScheduler.remove(spring)
                end
            end
        end
    end
end

RunService:BindToRenderStep("__FissionSpringScheduler", Enum.RenderPriority.First.Value, Update)

return SpringScheduler