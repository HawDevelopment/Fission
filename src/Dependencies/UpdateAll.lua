--[[
    UpdateAll.
    
    Updates all state dependencies.
    Will bot update the child elements, if there werent any changes.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

type Set<T> = { [T]: any }

return function(state: Types.Dependency)
	local processed = {}
	local processNow, processNext = {}, {}
	local processNowSize, processNextSize = 0, 0

	for dependent, _ in pairs(state.dependentSet) do
		processNowSize += 1
		processNow[processNowSize] = dependent
	end

	repeat
		local done = true
		for _, member in pairs(processNow) do
			if processed[member] then
				continue
			end
			processed[member] = true
			local changed = member:update()

			if changed and member.dependentSet then
				for dependent, _ in pairs(member.dependentSet) do
					if not processed[dependent] then
						for dependency, _ in pairs(dependent.dependencySet) do
							if not processed[dependency] then
								processNextSize += 1
								processNext[processNextSize] = dependency
							end
						end
						processNextSize += 1
						processNext[processNextSize] = dependent
						done = false
					end
				end
			end
		end
		if not done then
			processNow, processNext = processNext, processNow
			table.clear(processNext)
			processNowSize, processNextSize = processNextSize, 0
		end
	until done

	-- Clear any refrences
    table.clear(processNow)
    table.clear(processNext)
	table.clear(processed)
end
