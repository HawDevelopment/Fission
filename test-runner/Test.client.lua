local Fission = require(game.ReplicatedStorage.Fission)

local New = Fission.New
local Children = Fission.Children
local Value = Fission.Value
local Computed = Fission.Computed
local OnEvent = Fission.OnEvent
local Spring =  Fission.Spring

local clicked = Value(0)
local color = Value(Color3.new(0, 0, 0))

New("ScreenGui")({
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	[Children] = New("TextButton")({
		Size = UDim2.fromOffset(100, 100),
		Text = Computed(function()
			return "Clicked " .. clicked:get() .. " times"
		end, false),
        BackgroundColor3 = Spring(color),
		[OnEvent("Activated")] = function()
			clicked:set(clicked:get() + 1)
            color:set(Color3.new(math.random(), math.random(), math.random()))
		end,
	}),
})
