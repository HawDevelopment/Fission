--[[
    CleanupOnDestroy
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Utility/cleanupOnDestroy.lua
    HawDevelopment
    12/22/2021
--]]

local RunService = game:GetService("RunService")

local Package = script.Parent.Parent
local Cleanup = require(Package.Utility.Cleanup)

type TaskData = {
    connection: RBXScriptConnection,
    task: Cleanup.Task,
    cleaned: boolean,
}

local function callback() end

local tasks: { TaskData } = {}
local numTasks = 0
local index = 1

local function RunTasks()
    if numTasks == 0 then
        return
    end
    
    local start = os.clock()
	local stop = start + 1/2000

	for _ = 1, numTasks do
		local taskData = tasks[index]

		if taskData.connection.Connected then
			index += 1
		else
			table.remove(tasks, index)
			taskData.cleaned = true
			Cleanup(taskData.task)
			numTasks -= 1
		end
        
        if index > numTasks then
            index = 1
            break
        end
        
		if os.clock() > stop or index > numTasks then
			break
		end
	end
end

RunService:BindToRenderStep("__FissionCleanUp", Enum.RenderPriority.First.Value, RunTasks)

return function (inst: Instance?, task: Cleanup.Task)
    local taskData = {
        connection = inst.AncestryChanged:Connect(callback),
        task = task,
        cleaned = false,
    }
    inst = nil

    numTasks += 1
    tasks[numTasks] = taskData
    
    return function ()
        if not taskData or taskData.cleaned then
            return
        end

        taskData.cleaned = true
        taskData.connection:Disconnect()
        Cleanup(task)
        local index = table.find(tasks, taskData)
        if index then
            tasks[index] = nil
            numTasks -= 1
            if numTasks ~= 0 then
                tasks[index] = tasks[numTasks]
            end
        end
    end
end