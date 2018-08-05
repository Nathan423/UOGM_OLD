params ["_unit", "_control", "_ctrlNumber", "_newState"];
if (isNil "UOGM_Loaded") exitwith {};

switch _ctrlNumber do {
    case 2800: {
        //systemChat "Map Monitor";
        [] call uo_fnc_mapMonitor;
        _array = _unit getVariable "uogm_cbStates";
        _array set [0, _newState];
        _unit setVariable ["uogm_cbStates", _array];
        _state = switch (_newState) do {
            case 0: {false};
            case 1: {true};
        };
        _unit setVariable ["uogm_mapmonitor", _state];
        _msg = text format ["[UO ADMIN]: %1 has toggled the visibility of the map monitor", name player];
        _msg remoteExecCall ["diag_log", 2];
        //systemChat str _array;
    };
    case 2801: {
        _array = _unit getVariable "uogm_cbStates";
        _array set [1, _newState];
        _unit setVariable ["uogm_cbStates", _array];

        switch (_newState) do {
            case 1:{
              [_unit, true] remoteExec ["uo_fnc_handleZeus", 2, false];
              hint "You have zeus access";
            };
            case 0: {
              [_unit, false] remoteExec ["uo_fnc_handleZeus", 2, false];
              hint "You are no longer zeus";
            };
        };
    };
    case 2802: {
        //systemChat "Invisible";
        _array = _unit getVariable "uogm_cbStates";
        _array set [2, _newState];
        _unit setVariable ["uogm_cbStates", _array];
        _msg = text format ["[UO ADMIN]: %1 has toggled visibility", name player];
        _msg remoteExecCall ["diag_log", 2];
        //systemChat str _array;
        _state = switch (_newState) do {
            case 0: {false};
            case 1: {true};
        };
        [_unit, _state] remoteExec ["hideObjectGlobal", 2];
    };
    case 2803: {
        //systemChat "Invincible";
        _array = _unit getVariable "uogm_cbStates";
        _array set [3, _newState];
        _msg = text format ["[UO ADMIN]: %1 has toggled invincibility", name player];
        _msg remoteExecCall ["diag_log", 2];
        _unit setVariable ["uogm_cbStates", _array];
        //systemChat str _array;
        _state = switch (_newState) do {
            case 1: {false};
            case 0: {true};
        };
        _unit allowdamage _state;
    };
    case 2804: {
        //systemChat "Captive";
        _array = _unit getVariable "uogm_cbStates";
        _array set [4, _newState];
        _unit setVariable ["uogm_cbStates", _array];
        _msg = text format ["[UO ADMIN]: %1 has toggled captive mode", name player];
        _msg remoteExecCall ["diag_log", 2];
        //systemChat str _array;
        _unit setCaptive _newState;
    };
};
