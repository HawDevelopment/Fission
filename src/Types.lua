--[[
    Types.
    
    A module where alle types are defined.
    
    HawDevelopment
    12/11/2021
--]]

type Set<T> = { [T]: any }

export type Symbol = {
	type: string,
	name: string,
}
export type Object = {
    type: string,
    kind: string,
}
export type Signal = {
    fire: (Signal, ...any) -> nil,
    connectCallback: (Signal, (...any) -> nil) -> () -> nil,
    connectProperty: (Signal, Instance, string) -> () -> nil,
}
export type StateObject<T> = Object & {
    get: (StateObject<T>, asDependency: boolean?) -> T,
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
    bind: (Value<T>, callback: (any) -> any) -> Binding<T>,
}

export type Binding<T> = StateObject<T> & {
    update: (Binding<T>, newValue: any) -> nil,
}

export type Computed<T> = StateObject<T>

export type Observer = Object & {
	onChange: (Observer, callback: () -> ()) -> () -> (),
}

export type Spring<T> = StateObject<T>
export type Tween<T> = StateObject<T>

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
	[string | OnEvent | OnChange | Children]: any,
}

return nil
