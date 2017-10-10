if !(getPlayerUID player in UO_admins) exitWith {
  hint "This functionality is only avalible for GMs";
  _msg = text format ["[UO ADMIN]: %1 tried to open the debug console, but failed (not GM)", name player];
  _msg remoteExecCall ["diag_log", 2];
};

//Code to open debug console
_msg = text format ["[UO ADMIN]: %1 has opened the debug console", name player];
_msg remoteExecCall ["diag_log", 2];
