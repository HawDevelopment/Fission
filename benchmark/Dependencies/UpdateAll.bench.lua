--[[
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/benchmark/Dependencies/updateAll.bench.lua
    HawDevelopment
    12/12/2021
--]]

local Package = game:GetService("ReplicatedStorage").Fission
local UpdateAll = require(Package.Dependencies.UpdateAll)

local function update()
	return true
end

local function makeDependency(dependency, dependent)
	dependent.dependencySet[dependency] = true
	dependency.dependentSet[dependent] = true
end

return {

	{
		name = "Update empty tree",
		calls = 50000,

		preRun = function()
			local root = { dependentSet = {} }
			return root
		end,

		run = function(state)
			UpdateAll(state)
		end,
	},

	{
		name = "Update shallow tree",
		calls = 50000,

		preRun = function()
			local root = { dependentSet = {} }
			local A = { dependentSet = {}, dependencySet = {}, update = update }
			local B = { dependentSet = {}, dependencySet = {}, update = update }
			local C = { dependentSet = {}, dependencySet = {}, update = update }
			local D = { dependentSet = {}, dependencySet = {}, update = update }

			makeDependency(root, A)
			makeDependency(root, B)
			makeDependency(root, C)
			makeDependency(root, D)

			return root
		end,

		run = function(state)
			UpdateAll(state)
		end,
	},

	{
		name = "Update deep tree",
		calls = 50000,

		preRun = function()
			local root = { dependentSet = {} }
			local A = { dependentSet = {}, dependencySet = {}, update = update }
			local B = { dependentSet = {}, dependencySet = {}, update = update }
			local C = { dependentSet = {}, dependencySet = {}, update = update }
			local D = { dependentSet = {}, dependencySet = {}, update = update }

			makeDependency(root, A)
			makeDependency(A, B)
			makeDependency(B, C)
			makeDependency(C, D)

			return root
		end,

		run = function(state)
			UpdateAll(state)
		end,
	},

	{
		name = "Update tree with complex dependencies",
		calls = 50000,

		preRun = function()
			local root = { dependentSet = {} }
			local A = { dependentSet = {}, dependencySet = {}, update = update }
			local B = { dependentSet = {}, dependencySet = {}, update = update }
			local C = { dependentSet = {}, dependencySet = {}, update = update }
			local D = { dependentSet = {}, dependencySet = {}, update = update }

			makeDependency(root, A)
			makeDependency(A, B)
			makeDependency(B, C)
			makeDependency(C, D)
			makeDependency(A, C)
			makeDependency(A, D)
			makeDependency(B, D)

			return root
		end,

		run = function(state)
			UpdateAll(state)
		end,
	},
}
