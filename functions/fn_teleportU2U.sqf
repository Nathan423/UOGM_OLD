
/*
    Library: Administrative
    Author(s): Naught
*/

    private ["_unit1", "_unit2"];
    { // forEach
        switch (name _x) do {
            case (_this select 0): {
                _unit1 = _x;
            };
            case (_this select 1): {
                _unit2 = _x;
            };
        };
    } forEach allUnits;
    if (!isNil "_unit1" && {!isNil "_unit2"}) then {
        _pos = getPosATL _unit1;
        _unit2 setPosATL _pos;
    };
