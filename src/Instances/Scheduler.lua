--[[
    Run tasks
    HawDevelopment
    12/16/2021
--]]

local RunService = game:GetService("RunService")
local Package = script.Parent.Parent
local Types = require(Package.Types)
local None = require(Package.Utility.None)

local Scheduler = {}

local shouldUpdate = false
local propertyChanges: { [Instance]: { [string]: any } } = {}
local toUpdate: { [Types.Dependent | () -> nil]: string } = {}

function Scheduler.enqueueProperty(inst: Instance, property: string, value: any)
	shouldUpdate = true
	if value == nil then
		value = None
	end

	local tab = propertyChanges[inst]
	if not tab then
		propertyChanges[inst] = {
			[property] = value,
		}
	else
		tab[property] = value
	end
end

function Scheduler.enqueueCall(object: any | () -> nil, key: string | boolean?)
	shouldUpdate = true
	toUpdate[object] = key
end

function Scheduler.runTasks()
	if not shouldUpdate then
		return
	end
    
    for object, key in pairs(toUpdate) do
		if type(object) == "function" then
			object()
		else
			object[key](object)
		end
	end
    
	for inst, properties in pairs(propertyChanges) do
		for property, value in pairs(properties) do
			inst[property] = if value == None then nil else value
		end
	end

	shouldUpdate = false
	table.clear(propertyChanges)
	table.clear(toUpdate)
end

RunService:BindToRenderStep("__FissionUIScheduler", Enum.RenderPriority.Last.Value, Scheduler.runTasks)

return Scheduler
