--[[
    New.
    
    Creates a new instance and binds any state.
    
    HawDevelopment
    12/12/2021
--]]

local Package = script.Parent.Parent
local Types = require(Package.PrivateTypes)
local LogError = require(Package.Logging.LogError)
local Children = require(Package.Instances.Children)
local DoScheduling = require(Package.Instances.DoScheduling)
local Scheduler = require(Package.Instances.Scheduler)
local DefaultProps = require(Package.Instances.DefaultProps)
local CleanupOnDestroy = require(Package.Utility.CleanupOnDestroy)
local Cleanup = require(Package.Utility.Cleanup)
local Observer = require(Package.State.Observer)

type Set<T> = { [T]: any }
type Child = Types.CanBeState<Instance> | { Child } | nil

local OverrideParents: Set<Instance> = setmetatable({}, { __mode = "k" }) :: any
local StrongStateRefrence: Set<Types.StateObject<any>> = {}

local function SetProperty(inst, key, value)
	inst[key] = value
end
local function GetProperty(inst, key)
	return inst[key]
end
local function callback() end

local function New(className: string, propertyTable: Types.PropertyTable)
	local toConnect: Set<RBXScriptSignal> = {}
    local doScheduling = if propertyTable[DoScheduling] == false then false else true
    local cleanupTasks: { Cleanup.Task } = { }
    local inst: Instance
    local conn: RBXScriptConnection
    
    do
        -- Create the instance
        local ok, ret = pcall(Instance.new, className)
        if not ok then
            LogError("cannotCreateClass", nil, true, className)
        end
        inst = ret
        local defualtProps = DefaultProps[className]
        if defualtProps then
            for key, value in pairs(defualtProps) do
                ret[key] = value
            end
        end
        conn = inst.Changed:Connect(callback)
    end

	-- Apply props
	for key, value in pairs(propertyTable) do
		if key == Children or key == "Parent" then
			-- We do children and parenting separately
			continue
		elseif type(key) == "string" then
			if typeof(value) == "table" and value.type == "State" then
                if not pcall(SetProperty, inst, key, value:get(false)) then
                    LogError("cannotAssignProperty", nil, true, className, key)
                end
                if doScheduling then
                    table.insert(cleanupTasks, Observer(value):onChange(function()
                        Scheduler.enqueueProperty(inst, key, value:get(false))
                    end))
                else
                    table.insert(cleanupTasks, value._signal:connectProperty(inst, key))
                end
                
                StrongStateRefrence[value] = true
                table.insert(cleanupTasks, function()
                    StrongStateRefrence[value] = nil
                end)
                
                continue
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
	local children = propertyTable[Children] :: Child
	if children ~= nil then
		local currentChildren: Set<Instance> = {}
        local prevChildren: Set<Instance> = {}
        local connections: Set<Types.StateObject<any>> = {}
        
        -- Cleanup connections
        table.insert(cleanupTasks, function()
            for _, value in pairs(connections) do
                value()
            end
            table.clear(connections)
        end)
        
		local function updateChildren()
			currentChildren, prevChildren = prevChildren, currentChildren

			local function recursiveAddChild(child: Types.CanBeState<Instance> | table | nil)
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
                        local child: any = child
						recursiveAddChild(child:get(false))
                        
                        if not connections[child] then
                            connections[child] = child._signal:connectCallback(function()
                                task.defer(updateChildren)
                            end)
                        end
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
					child.Parent = nil :: Instance
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
            
            table.insert(cleanupTasks, 
                if doScheduling then
                    parent._signal:connectCallback(function(newValue)
                        Scheduler.enqueueProperty(inst, "Parent", newValue)
                    end)
                else
                    parent._signal:connectProperty(inst, "Parent")
            )
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
    
    -- Add cleanup tasks
    if #cleanupTasks ~= 0 then
        CleanupOnDestroy(inst, cleanupTasks)
    end
    
    -- Disconnect event
    conn:Disconnect()
    
	return inst
end

return function(className: string)
	return function(propertyTable: Types.PropertyTable): Instance
		return New(className, propertyTable)
	end
end
