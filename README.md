# Fission

An optimized fork of [Fusion](https://github.com/Elttob/Fusion).
Huge props to Elttob, Fusion is truely awesome. One of the best projects I've ever seen.

Note that, right now, this is a work in progress.
Theres still some bugs and quirks to be worked out.

Changes from Fusion:

-   Computed now takes a second argument `recapture`. If `recapture` is set to `false`, it will not recalculate dependencies, and will not provide error handling.
-   A state can only have one observer.
-   Added `DoScheduling` symbol. When added to a property table and the value is set to false, Fission will no longer use the scheduler. Instead it will just set the property.
