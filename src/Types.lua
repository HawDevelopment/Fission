--[[
    Types.
    
    A module where alle types are defined.
    
    HawDevelopment
    12/11/2021
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
export type Dependent = {
	update: (Dependent) -> boolean,
	dependencySet: Set<Dependency>,
}
export type Dependency = {
	dependentSet: Set<Dependent>,
}
export type StateObject<T> = Object & Dependency & {
    _value: T,
    get: (StateObject<T>, asDependency: boolean?) -> T,
    observer: Observer?
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

export type Computed<T> = StateObject<T> & Dependent & {
    recapture: boolean?,
	_oldDependencySet: Set<Dependency>,
	_callback: () -> T,
}

export type Observer = Object & Dependent & {
	callbacks: { [() -> nil]: boolean },
	onChange: (Observer, callback: () -> nil) -> () -> nil,
}

export type Spring<T> = StateObject<T> & Dependent

export type Children = Symbol

export type OnChange = Symbol & {
	key: string,
}

export type OnEvent = Symbol & {
	key: string,
}
export type None = Symbol

export type PropertyTable = {
	[string | OnEvent | OnChange | Children]: any,
}

return nil
