--[[
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/test/Dependencies/useDependency.spec.lua
    HawDevelopment
    12/11/2021
--]]

local Package = game:GetService("ReplicatedStorage").Fission
local UseState = require(Package.Dependencies.UseState)
local Shared = require(Package.Dependencies.Shared)

return function()
	it("should add to a dependency set contextually", function()
		local set = {}
		Shared.CurrentDependencySet = set

		local dependency = { get = function() end }
		UseState(dependency)

		Shared.CurrentDependencySet = nil

		expect(set[dependency]).to.be.ok()
	end)

	it("should do nothing when no dependency set exists", function()
		expect(function()
			UseState({ get = function() end })
		end).never.to.throw()

		expect(Shared.CurrentDependencySet).never.to.be.ok()
	end)

	-- TODO: test in conjunction with initDependency
end
