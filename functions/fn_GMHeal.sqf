params ["_type"];

disableSerialization;
_unitbox = ((findDisplay 951230) displayCtrl 2100);
_execUnitname = _unitbox lbData (lbCurSel _unitbox);

switch (_type) do {
	case 1: {
		{
			if (name _x == _execUnitname) exitWith {
				[player, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
			};
		} forEach playableUnits;


		hint "Player was fully healed";

		_msg = text format ["[UO ADMIN]: %1 fully healed %2 with GM heal", name player, _execUnitname];
		_msg remoteExecCall ["diag_log", 2];
	};
	case 2: {
		{
			[player, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
		} forEach playableUnits;

		hint "All players were fully healed";

		_msg = text format ["[UO ADMIN]: %1 fully healed everybody with GM heal", name player];
		_msg remoteExecCall ["diag_log", 2];
	};
};
