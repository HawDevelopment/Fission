--[[
    Test runner, from fusion: https://github.com/Elttob/Fusion/blob/main/test-runner/Run.client.lua
    HawDevelopment
    12/11/2021
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local TestEZ = require(StarterPlayerScripts.TestEZ)

local RUN_TESTS = true
local RUN_BENCHMARKS = true

-- run unit tests
if RUN_TESTS then
	print("Running unit tests...")
	local data = TestEZ.TestBootstrap:run({
		ReplicatedStorage:WaitForChild("Tests"):WaitForChild("Test"),
	})

	if data.failureCount > 0 then
		warn("Unit tests failed! Wont be running benchmarks.")
		return
	end
end

-- run benchmarks
if RUN_BENCHMARKS then
	print("Running benchmarks...")

	-- wait for a bit to allow initial load to pass - this means the lag from a ton
	-- of things starting up shouldn't impact the benchmarks (as much)
	task.wait(5)

	local results = {}
	local maxNameLength = 0

	for _, instance in pairs(ReplicatedStorage.Tests.Benchmark:GetDescendants()) do
		if instance:IsA("ModuleScript") and instance.Name:match("%.bench$") then
			-- yield between benchmarks so we don't freeze Studio
			task.wait(0.5)

			local benchmarks = require(instance)

			local fileName = instance.Name:gsub("%.bench$", "")
			local fileResults = {}

			for index, benchmarkInfo in ipairs(benchmarks) do
				-- yield between benchmarks so we don't freeze Studio
				task.wait()

				local name = benchmarkInfo.name
				local calls = benchmarkInfo.calls

				local preRun = benchmarkInfo.preRun
				local run = benchmarkInfo.run
				local postRun = benchmarkInfo.postRun

				maxNameLength = math.max(maxNameLength, #name)

				local state

				if preRun ~= nil then
					state = preRun()
				end

				local start = os.clock()
				for n = 1, calls do
					run(state)
				end
				local fin = os.clock()

				if postRun ~= nil then
					postRun(state)
				end

				local timeMicros = (fin - start) * 1000000 / calls

				fileResults[index] = { name = name, time = timeMicros }
			end

			table.sort(fileResults, function(a, b)
				return a.name < b.name
			end)

			table.insert(results, { fileName = fileName, results = fileResults })
		end
	end

	table.sort(results, function(a, b)
		return a.fileName < b.fileName
	end)

	local resultsString = "Benchmark results:"

	for _, fileInfo in ipairs(results) do
		resultsString ..= "\n[+] " .. fileInfo.fileName

		for _, testInfo in ipairs(fileInfo.results) do
			resultsString ..= "\n   [+] "
			resultsString ..= testInfo.name .. " "
			resultsString ..= ("."):rep(maxNameLength - #testInfo.name + 4) .. " "
			resultsString ..= ("%.2f μs"):format(testInfo.time)
		end
	end

	print(resultsString)
end
