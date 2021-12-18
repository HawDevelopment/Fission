-- local Fission = require(game.ReplicatedStorage.Fission)

-- local New = Fission.New
-- local Children = Fission.Children
-- local Value = Fission.Value
-- local Computed = Fission.Computed
-- local OnEvent = Fission.OnEvent

-- local clicked = Value(0)

-- New("ScreenGui")({
-- 	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
-- 	[Children] = New("TextButton")({
-- 		Size = UDim2.fromOffset(100, 100),
-- 		Text = Computed(function()
-- 			return "Clicked " .. clicked:get() .. " times"
-- 		end, false),
-- 		[OnEvent("Activated")] = function()
-- 			clicked:set(clicked:get() + 1)
-- 		end,
-- 	}),
-- })
