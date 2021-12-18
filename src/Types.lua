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

export type Dependent = {
	update: (Dependent) -> boolean,
	dependencySet: Set<Dependency>,
}

export type Dependency = {
	dependentSet: Set<Dependent>,
}

export type Error = {
	type: string,
	raw: string,
	message: string,
	trace: string,
}

export type Value<T> = {
	type: string,
	kind: string,
	_value: T,
	dependentSet: Set<Dependent>,

	set: (Value<T>, newValue: any, force: boolean?) -> nil,
	get: (Value<T>, asDependency: boolean?) -> T,
    recalculate: (Value<T>) -> nil,

	observer: Observer?,
}

export type Computed<T> = {
	type: string,
	kind: string,
	recapture: boolean?,
	_value: T,
	dependentSet: Set<Dependent>,
	dependencySet: Set<Dependency>,
	_oldDependencySet: Set<Dependency>,
	_callbacks: () -> T,

	get: (Computed<T>, asDependency: boolean?) -> T,
	update: (Computed<T>) -> boolean,

	observer: Observer?,
}

export type Observer = {
	type: string,
	kind: string,
	callbacks: { [() -> nil]: boolean },
	dependentSet: Set<Dependent>,
	dependencySet: Set<Dependency>,

	onChange: (Observer, callback: () -> nil) -> () -> nil,
	update: (Observer, Dependent) -> boolean,
}

export type State<T> = Value<T> | Computed<T>

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
