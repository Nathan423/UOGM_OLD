params ["_unit"];
_spec = _unit getVariable "uogm_Spectator";

if (!_spec) then {
	closeDialog 0;
	hint "Enabling spectator\nPress CTRL+E to Exit\nPress CTRL+S to Toggle Spectate ACRE mode";
	['Initialize', [_unit, [], true]] call BIS_fnc_EGSpectator;
	_unit setVariable ["uogm_Spectator", true];
	_msg = text format ["[UO ADMIN]: %1 entered GM spectator", name player];
	_msg remoteExecCall ["diag_log", 2];
	sleep 1;
	_display = findDisplay 60492;
	_display displayAddEventHandler ["KeyDown",{
		_keycode = _this select 1;
		_isCtrl = _this select 3;
		if (_keycode == 18 && _isCtrl) then {
			["Terminate"] call BIS_fnc_EGSpectator;
			player setVariable ["uogm_Spectator", false];
			_msg = text format ["[UO ADMIN]: %1 exited GM spectator", name player];
			_msg remoteExecCall ["diag_log", 2];
			hint "Spectator successfully exited."
		};
		if (_keycode == 31 && _isCtrl) then {
			if ([player] call acre_api_fnc_isSpectator) then {
				[false] call acre_api_fnc_setSpectator;
				systemChat "ACRE Spectator disabled";
			} else {
				[true] call acre_api_fnc_setSpectator;
				systemChat "ACRE Spectator enabled";
			};
		};
	}];
};
