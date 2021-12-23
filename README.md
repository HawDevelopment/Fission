# Fission

An optimized fork of [Fusion](https://github.com/Elttob/Fusion).
Huge props to Elttob, Fusion is truely awesome. One of the best projects I've ever seen.

Changes from Fusion:

-   Computed now has a second optional argument `recapture`. If `recapture` is a boolean parameter and will only change the behavior of the computed if set `false`. If `recapture` is passed as false, it will not try to find used state objects when an update happens. This is good when you dont plan on adding and removing states in the computed.
-   Observers will be stored for future use in states. If you create to observers for the same state, it would be the same object.
-   Added `DoScheduling` symbol. When added to a property table and the value is set to false, Fission will no longer use the scheduler for that object. Instead it will just set the property. (I plan to set DoScheduling to false by defualt for future releases.)
