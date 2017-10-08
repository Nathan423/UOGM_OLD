params ["_gm", "_option"];
disableSerialization;

_display = findDisplay 951230;

switch _option do {
    case 1: {
        _textArray = [];
        for "_i" from 5 to 10 do {
            _control = 1000 + _i;
            _stringArray = (ctrlText (_display displayCtrl _control)) splitString ":";
            if (count _stringArray > 1) then {
                _textArray pushback (_stringArray select 1);
            } else {
                _textArray pushBack "nil";
            }
        };
        diag_log str _textArray;
        hint "Information about the player has been exported to your RPT file.";
        _msg = text format ["[UO ADMIN]: %1 has copied %2's information to their RPT", name player, _textArray select 0];
        _msg remoteExecCall ["diag_log", 2];
    };
    case 2: {

    };
    case 3: {

    };
};
