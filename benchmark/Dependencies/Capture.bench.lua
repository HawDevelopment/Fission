--[[
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/benchmark/Dependencies/captureDependencies.bench.lua
    HawDevelopment
    12/12/2021
--]]

local Package = game:GetService("ReplicatedStorage").Fission
local Capture = require(Package.Dependencies.Capture)
local Value = require(Package.State.Value)

local function callback() end
local value = Value(10)
local function callback2()
	value:get()
end

return {

	{
		name = "Capture dependencies from callback",
		calls = 10000,

		preRun = function()
			return {}
		end,

		run = function(set)
			Capture(set, callback)
		end,
	},
	{
		name = "Capture dependencies from callback - Populated function",
		calls = 10000,

		preRun = function()
			return {}
		end,

		run = function(set)
			Capture(set, callback2)
		end,
	},
}
