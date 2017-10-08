{ACRE_SERVER_GEAR_DESYNCED = false; hint "ACRE Error has been suppressed";} remoteExecCall ["bis_fnc_call", 0];

_msg = text format ["[UO ADMIN]: ACRE Message Hide has been executed by %1. THE MISSION IS STILL CONSIDERED BROKEN!!!", name player];
_msg remoteExecCall ["diag_log", 2];
