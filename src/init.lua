--[[
    Imports
    HawDevelopment
    12/12/2021
--]]

local Types = require(script.Types)

export type StateObject<T> = Types.StateObject<T>
export type CanBeState<T> = Types.CanBeState<T>
export type Symbol = Types.Symbol
export type Value<T> = Types.Value<T>
export type Computed<T> = Types.Computed<T>
export type Observer = Types.Observer
export type Tween<T> = Types.Tween<T>
export type Spring<T> = Types.Spring<T>

type Fission = {
	New: (className: string) -> ((propertyTable: Types.PropertyTable) -> Instance),
	
	Children: Types.Children,
	OnEvent: (eventName: string) -> Types.OnEvent,
	OnChange: (propertyName: string) -> Types.OnChange,
    
	Value: <T>(initialValue: T) -> Value<T>,
	Computed: <T>(callback: () -> T) -> Computed<T>,
	Observer: (watchedState: StateObject<any>) -> Observer,

	Tween: <T>(goalState: StateObject<T>, tweenInfo: TweenInfo?) -> Types.Tween<T>,
	Spring: <T>(goalState: StateObject<T>, speed: number?, damping: number?) -> Spring<T>
}

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
} :: Fission
