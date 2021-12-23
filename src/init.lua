--[[
    Imports
    HawDevelopment
    12/12/2021
--]]

return {
	New = require(script.Instances.New),
	OnChange = require(script.Instances.OnChange),
	OnEvent = require(script.Instances.OnEvent),
	Children = require(script.Instances.Children),
    DoScheduling = require(script.Instances.DoScheduling),

	Value = require(script.State.Value),
	Computed = require(script.State.Computed),
	Observer = require(script.State.Observer),
    
    Spring = require(script.Animation.Spring),
    Tween = require(script.Animation.Tween),
}
