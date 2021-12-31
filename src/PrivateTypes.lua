--[[
    PrivateTypes.
    HawDevelopment
    12/31/2021
--]]

type Set<T> = { [T]: any }
type Symbol = {
	type: string,
	name: string,
}
export type Object = {
    type: string,
    kind: string,
}
export type Signal = {
    _connection: Set<(...any) -> nil>,
    _isfiring: boolean,
    _shouldConnect: boolean,
    _properties: { [Instance]: { string } },
    _connections: Set<(...any) -> nil>,
    _toConnect: { (...any) -> nil },
    
    fire: (Signal, ...any) -> nil,
    connectCallback: (Signal, (...any) -> nil) -> () -> nil,
    connectProperty: (Signal, Instance, string) -> () -> nil,
}
export type StateObject<T> = {
    type: string,
    kind: string,
    _value: T,
    _signal: Signal,
    get: (StateObject<T>, asDependency: boolean?) -> T,
    observer: Observer
}
export type CanBeState<T> = StateObject<T> | T

export type Animatable = number |
    CFrame |
    Color3 |
    ColorSequenceKeypoint |
    DateTime |
    NumberRange |
    NumberSequenceKeypoint |
    PhysicalProperties |
    Ray |
    Rect |
    Region3 |
    Region3int16 |
    UDim |
    UDim2 |
    Vector2 |
    Vector2int16 |
    Vector3 |
    Vector3int16

export type Error = {
	type: string,
	raw: string,
	message: string,
	trace: string,
}

export type Value<T> = StateObject<T> & {
	set: (Value<T>, newValue: any, force: boolean?) -> nil,
}

export type Computed<T> = StateObject<T> & {
    recapture: boolean?,
	_callback: () -> T,
    _connections: { [StateObject<any>]: (...any) -> nil },
    _dependencySet: Set<StateObject<any>>,
    _oldDependencySet: Set<StateObject<any>>,
    
    capture: (Computed<T>) -> boolean,
}

export type Observer = Object & {
	listeners: number,
    state: StateObject<any>,
    
	onChange: (Observer, callback: () -> nil) -> () -> nil,
}

export type Spring<T> = StateObject<T> & {
    _speed: CanBeState<number>?,
    _speedIsState: boolean,
    _lastSpeed: number?,
    _damping: CanBeState<number>?,
    _dampingIsState: boolean,
    _lastDamping: number?,
    
    _goalState: Value<any>,
    _goal: any?,
    _value: any?,
    _currentType: string?,
    _currentPosition: { [number]: number },
    _currentVelocity: { number },
    _currentGoal: { number },
    
    update: (Spring<T>) -> boolean
}

export type Tween<T> = StateObject<T> & {
    _goalState: Value<any>,
    _tweenInfo: TweenInfo,
    _prevValue: any,
    _nextValue: any,
    _value: any,
    _currentTweenInfo: TweenInfo,
    _currentTweenDuration: number,
    _currentTweenStartTime: number,
}

export type Children = Symbol
export type DoScheduling = Symbol

export type OnChange = Symbol & {
	key: string,
}

export type OnEvent = Symbol & {
	key: string,
}
export type None = Symbol

export type PropertyTable = {
	[string | OnEvent | OnChange | Children]: CanBeState<any>,
}

return nil
