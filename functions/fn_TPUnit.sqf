params ["_unit", "_type"];
disableSerialization;
_listbox = ((findDisplay 951230) displayCtrl 2100);
_index = lbCurSel _listbox;

switch (_type) do {
	case "GMTOUSER": {
		[(_listbox lbData _index), name _unit] call uo_fnc_teleportU2U;
		//Hint "Teleported " + name _unit + " to " + (_listbox lbText _index);
		_msg = text format ["[UO ADMIN]: %1 teleported to %2", name _unit, (_listbox lbData _index)];
   		_msg remoteExecCall ["diag_log", 2];
	};
	case "USERTOGM": {
		[ name _unit, (_listbox lbData _index)] call uo_fnc_teleportU2U;
		//Hint "Teleported " + (_listbox lbText _index) + " to " + name _unit;
		_msg = text format ["[UO ADMIN]: %2 teleported to %1", name _unit, (_listbox lbText _index)];
   		_msg remoteExecCall ["diag_log", 2];
	};
	case "TPUSERMAP": {
		if (!isNil "uo_tpUser" && uo_tpUser) then { //Active click
			uo_tpUser = false;
			hintSilent "Teleportation cancelled";
		} else {
			uo_tpUser = true;
			uo_tpGM = false;
			uo_tpAllToMap = false;
			hintSilent "Click on the position you want to teleport the player to.";
		};
	};
	case "TPGMMAP": {
		if (!isNil "uo_tpGM" && uo_tpGM) then { //Active click
			uo_tpGM = false;
			hintSilent "Teleportation cancelled";
		} else {
			uo_tpGM = true;
			uo_tpUser = false;
			uo_tpAllToMap = false;
			hintSilent "Click on the position you want to teleport to.";
		};
	};
	case "TPALLTOGM": {
		{
			if (_x distance _unit > parseNumber (ctrlText ((findDisplay 951230) displayCtrl 1402)) && {_x != _unit}) then {
				_x setPosATL (getPosATL _unit);
				hint "You were moved to " + name _unit + "'s position.";
			};
		} forEach playableUnits;
	    hintSilent format ["You teleported %1 players to your position", count playableUnits, mapGridPosition _unit];
		_msg = text format ["[UO ADMIN]: %1 teleported all players to their position", name _unit];
   		_msg remoteExecCall ["diag_log", 2];
	};
	case "TPALLTOMAP": {
		if (!isNil "uo_tpAllToMap" && uo_tpAllToMap) then { //Active click
			uo_tpAllToMap = false;
			hintSilent "Teleportation cancelled";
		} else {
			uo_tpAllToMap = true;
			uo_tpUser = false;
			uo_tpGM = false;
			hintSilent "Click on the position you want to teleport everyone to.";
		};
	};
};
