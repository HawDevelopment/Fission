--[[
    Cleanup.
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Utility/cleanup.lua
    HawDevelopment
    12/22/2021
--]]

export type Task = Instance | RBXScriptConnection | () -> () | { Destroy: (any) -> nil } | { destroy: (any) -> nil } | { Task }

function Cleanup (task: Task)
    local taskType = typeof(task)

	if taskType == "Instance" then
		task:Destroy()
	elseif taskType == "RBXScriptConnection" then
		task:Disconnect()
	elseif taskType == "function" then
		task()
	elseif taskType == "table" then
		if typeof(task.destroy) == "function" then
            ---@diagnostic disable-next-line: deprecated
			task:destroy()
		elseif typeof(task.Destroy) == "function" then
			task:Destroy()
		elseif (task :: { Task })[1] ~= nil then
			for _, subtask in ipairs((task :: { Task })) do
				Cleanup(subtask)
			end
		end
	end
end

return Cleanup