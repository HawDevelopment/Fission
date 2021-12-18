--[[
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/test/Dependencies/captureDependencies.spec.lua
    HawDevelopment
    12/11/2021
--]]

local Package = game:GetService("ReplicatedStorage").Fission
local Capture = require(Package.Dependencies.Capture)
local Shared = require(Package.Dependencies.Shared)

return function()
	it("should set a dependency set contextually", function()
		local set = {}
		Capture(set, function()
			expect(Shared.CurrentDependencySet).to.equal(set)
		end)

		expect(Shared.CurrentDependencySet).never.to.equal(set)
	end)

	it("should correctly contain and resolve errors", function()
		local ok, err
		local set = {}

		expect(function()
			ok, err = Capture(set, function()
				error("oops")
			end)
		end).never.to.throw()

		expect(Shared.CurrentDependencySet).never.to.equal(set)

		expect(ok).to.equal(false)
		expect(err).to.be.a("table")
		expect(err.message).to.equal("oops")
	end)

	it("should pass arguments to the callback", function()
		local value1, value2, value3

		Capture({}, function(...)
			value1, value2, value3 = ...
		end, "foo", nil, "bar")

		expect(value1).to.equal("foo")
		expect(value2).to.equal(nil)
		expect(value3).to.equal("bar")
	end)

	it("should return values from the callback", function()
		local _, value = Capture({}, function(...)
			return "foo"
		end)

		expect(value).to.equal("foo")
	end)
end
