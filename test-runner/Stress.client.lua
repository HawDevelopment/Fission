-- local RunService = game:GetService("RunService")
-- local Fission = require(game.ReplicatedStorage.Fission)

-- local NODE_SIZE = 10
-- local GRID_SIZE = 50

-- local New = Fission.New
-- local Value = Fission.Value
-- local Children = Fission.Children
-- local Computed = Fission.Computed

-- local function StressTester()
-- 	local TimeState = Value(time())

-- 	RunService.Heartbeat:Connect(function()
-- 		TimeState:set(time())
-- 	end)

-- 	local Nodes = {}
-- 	local Length = 0
-- 	for X = 0, GRID_SIZE - 1 do
-- 		for Y = 0, GRID_SIZE - 1 do
-- 			Length += 1
-- 			Nodes[Length] = New("Frame")({
-- 				BackgroundColor3 = Computed(function()
-- 					return Color3.new(0.5 + 0.5 * math.sin(TimeState:get() + X / NODE_SIZE + Y / NODE_SIZE), 0.5, 0.5)
-- 				end, false),

-- 				Position = UDim2.fromOffset(NODE_SIZE * X, NODE_SIZE * Y),
-- 				Size = UDim2.fromOffset(NODE_SIZE, NODE_SIZE),
-- 			})
-- 		end
-- 	end

-- 	local Frame = New("Frame")({
-- 		AnchorPoint = Vector2.new(0.5, 0.5),
-- 		Position = UDim2.fromScale(0.5, 0.5),
-- 		Size = UDim2.fromOffset(GRID_SIZE * NODE_SIZE, GRID_SIZE * NODE_SIZE),
-- 		[Children] = Nodes,
-- 	}) :: Frame

-- 	return Frame
-- end

-- local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

-- New("ScreenGui")({
-- 	Parent = PlayerGui,
-- 	[Fission.Children] = { StressTester() },
-- })
