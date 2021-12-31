-- local Fission = require(game.ReplicatedStorage.Fission)

-- local New = Fission.New
-- local Children = Fission.Children
-- local Value = Fission.Value
-- local Computed = Fission.Computed
-- local OnEvent = Fission.OnEvent
-- local Tween = Fission.Tween

-- local clicked = Value(0)

-- New("ScreenGui")({
--     Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"), 
--     [Children] = New("TextButton")({
--         Size = UDim2.fromOffset(100, 100),
--         BackgroundColor3 = Computed(function()
--             return clicked:get() % 2 == 0 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
--         end),
--         Text = Computed(function()
--             return "Clicked " .. tostring(clicked:get()) .. " times"
--         end),
--         [OnEvent("Activated")] = function()
--             clicked:set(clicked:get() + 1)
--         end,
--     })
-- })


