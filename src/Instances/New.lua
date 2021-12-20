--[[
    New.
    
    Creates a new instance and binds any state.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local LogError = require(Package.Logging.LogError)
local Children = require(Package.Instances.Children)
local DoScheduling = require(Package.Instances.DoScheduling)
local Observer = require(Package.State.Observer)
local Scheduler = require(Package.Instances.Scheduler)
local DefaultProps = require(Package.Instances.DefaultProps)

type Set<T> = { [T]: any }

local OverrideParents = setmetatable({}, { __mode = "k" }) :: Set<Instance>

local function SetProperty(inst, key, value)
	inst[key] = value
end
local function GetProperty(inst, key)
	return inst[key]
end

local function New(className: string, propertyTable: Types.PropertyTable)
	-- TODO: Add cleanup tasks

	local toConnect: Set<RBXScriptSignal> = {}
    local doScheduling = if propertyTable[DoScheduling] == false then false else true

	-- Create the instance
	local ok, inst = pcall(Instance.new, className)
	if not ok then
		LogError("cannotCreateClass", nil, true, className)
	end
    local defualtProps = DefaultProps[className]
    if defualtProps then
        for key, value in pairs(defualtProps) do
            inst[key] = value
        end
    end

	-- Apply props
	for key, value: any | Types.Value<any> in pairs(propertyTable) do
		if key == Children or key == "Parent" then
			-- We do children and parenting separately
			continue
		elseif type(key) == "string" then

			if typeof(value) == "table" and value.type == "State" then
                if not pcall(SetProperty, inst, key, value:get(false)) then
                    LogError("cannotAssignProperty", nil, true, className, key)
                end
				-- Clean this up?
                if doScheduling then
                    Observer(value):onChange(function()
                        Scheduler.enqueueProperty(inst, key, value:get(false))
                    end)
                else
                    Observer(value):onChange(function()
                        inst[key] = value:get(false)
                    end)
                end
            else
                if not pcall(SetProperty, inst, key, value) then
                    LogError("cannotAssignProperty", nil, true, className, key)
                end
			end
		elseif typeof(key) == "table" and key.type == "Symbol" then
			-- Symbol
			if key.name == "OnEvent" then
				local ok, event = pcall(GetProperty, inst, key.key)
				if not ok or typeof(event) ~= "RBXScriptSignal" then
					LogError("cannotConnectEvent", nil, true, className, key.key)
				end
				toConnect[event] = value
			elseif key.name == "OnChange" then
				local ok, event = pcall(inst.GetPropertyChangedSignal, inst, key.key)
				if not ok then
					LogError("cannotConnectChange", nil, true, className, key.key)
				end

				toConnect[event] = function()
					value(inst[key.key])
				end
            elseif key.name == "DoScheduling" then
                -- Do nothing
			else
				LogError("unrecognisedPropertyKey", nil, true, typeof(key))
			end
		else
			LogError("unrecognisedPropertyKey", nil, true, typeof(key))
		end
	end

	-- Do children
	local children = propertyTable[Children]
	if children ~= nil then
		local currentChildren, prevChildren = {}, {}
		local function updateChildren()
			currentChildren, prevChildren = prevChildren, currentChildren

			local function recursiveAddChild(child)
				local childType = typeof(child)

				if childType == "Instance" then
					currentChildren[child] = true
					if prevChildren[child] == nil and OverrideParents[child] == nil then
						child.Parent = inst
					else
						prevChildren[child] = nil
					end
				elseif childType == "table" then
					if child.type == "State" then
						recursiveAddChild(child:get(false))
						local disconnect
						disconnect = Observer(child):onChange(function()
							task.defer(updateChildren)
							disconnect()
						end)
					else
						for _, subChild in pairs(child) do
							recursiveAddChild(subChild)
						end
					end
				elseif childType ~= "nil" then
					LogError("unrecognisedChildType", nil, false, childType)
				end
			end

			recursiveAddChild(children)

			for child in pairs(prevChildren) do
				if OverrideParents[child] == nil then
					child.Parent = nil
				end
			end
		end

		updateChildren()
	end

	-- Do parenting
	local parent = propertyTable.Parent
	if parent ~= nil then
		OverrideParents[inst] = parent
		if typeof(parent) == "table" and parent.type == "State" then
			-- State
			if not pcall(SetProperty, inst, "Parent", parent:get(false)) then
				LogError("cannotAssignProperty", nil, true, className, "Parent")
			end
            
            if doScheduling then
                Observer(parent):onChange(function()
                    Scheduler.enqueueProperty(inst, "Parent", parent:get(false))
                end)
            else
                Observer(parent):onChange(function()
                    inst.Parent = parent:get(false)
                end)
            end
		else
			if not pcall(SetProperty, inst, "Parent", parent) then
				LogError("cannotAssignProperty", nil, true, className, "Parent")
			end
		end
	end

	-- Connect events
	for event, func in pairs(toConnect) do
		event:Connect(func)
	end

	return inst
end

return function(className: string)
	return function(propertyTable: Types.PropertyTable): Instance
		return New(className, propertyTable)
	end
end
