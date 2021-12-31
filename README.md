# Fission

An optimized fork of [Fusion](https://github.com/Elttob/Fusion).
Huge props to Elttob, Fusion is truely awesome. One of the best projects I've ever seen.

Changes from Fusion:

-   Computed now takes a second argument `recapture`. If `recapture` is set to `false`, it will not recalculate dependencies, and will not provide error handling.
-   A state can only have one observer.
-   Added `DoScheduling` symbol. When added to a property table and the value is set to false, Fission will no longer use the scheduler. Instead it will just set the property.
-   Added method `Value:bind`. It works a lot like a computed but can only be used for one value.

    ```lua
    local value = Value(1)

    value:bind(function(v)
        print(v)
    end) -- prints 1 (The binding will be called when its created)

    value:set(2) -- prints 2
    value:set("Hello") -- prints Hello
    ```
