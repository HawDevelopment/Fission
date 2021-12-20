# Fission

An optimized fork of [Fusion](https://github.com/Elttob/Fusion).

Changes from Fusion:

-   Computed now takes a second argument `recapture`. If `recapture` is set to `false`, it will not recalculate dependencies, and will not provide error handling.
-   A state can only have one observer.
-   Added `DoScheduling` symbol. When added to a property table and the value is set to false, Fission will no longer use the scheduler. Instead it will just set the property.
