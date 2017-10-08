#define QGVAR(thing) format ["ace_medical_%1", #thing]
params ["_type"];
fnc_heal = {
	params ["_target"];
	if (alive _target) exitWith {
		_target setVariable [QGVAR(pain), 0, true];
	    _target setVariable [QGVAR(morphine), 0, true];
	    _target setVariable [QGVAR(bloodVolume), 100, true];

	    // tourniquets
	    _target setVariable [QGVAR(tourniquets), [0,0,0,0,0,0], true];

	    // wounds and injuries
	    _target setVariable [QGVAR(openWounds), [], true];
	    _target setVariable [QGVAR(bandagedWounds), [], true];
	    _target setVariable [QGVAR(internalWounds), [], true];

	    // vitals
	    _target setVariable [QGVAR(heartRate), 80];
	    _target setVariable [QGVAR(heartRateAdjustments), []];
	    _target setVariable [QGVAR(bloodPressure), [80, 120]];
	    _target setVariable [QGVAR(peripheralResistance), 100];

	    // fractures
	    _target setVariable [QGVAR(fractures), []];

	    // IVs
	    _target setVariable [QGVAR(ivBags), nil, true];

	    // damage storage
	    _target setVariable [QGVAR(bodyPartStatus), [0,0,0,0,0,0], true];

	    // airway
	    _target setVariable [QGVAR(airwayStatus), 100, true];
	    _target setVariable [QGVAR(airwayOccluded), false, true];
	    _target setVariable [QGVAR(airwayCollapsed), false, true];

	    // generic medical admin
	    _target setVariable [QGVAR(addedToUnitLoop), false, true];
	    _target setVariable [QGVAR(inCardiacArrest), false, true];
	    _target setVariable [QGVAR(inReviveState), false, true];
	    _target setVariable ["ACE_isUnconscious", false, true];
	    _target setVariable [QGVAR(hasLostBlood), 0, true];
	    _target setVariable [QGVAR(isBleeding), false, true];
	    _target setVariable [QGVAR(hasPain), false, true];
	    _target setVariable [QGVAR(painSuppress), 0, true];

	    // medication
	    private _allUsedMedication = _target getVariable [QGVAR(allUsedMedication), []];
	    {
	       _target setVariable [_x select 0, nil];
	    } forEach _allUsedMedication;

	    // Resetting damage
	    _target setDamage 0;
	};
};

disableSerialization;
_unitbox = ((findDisplay 951230) displayCtrl 2100);
_execUnitname = _unitbox lbData (lbCurSel _unitbox);
switch (_type) do {
	case 1: {
		_execUnit = nil;
		{
			if (name _x == _execUnitname) then {_execUnit = _x};
		} forEach playableUnits;
		[_execUnit] call compile preprocessFileLineNumbers "fnc_heal";
		hint "Player was fully healed";
		_msg = text format ["[UO ADMIN]: %1 fully healed %2 with GM heal", name player, _execUnitname];
		_msg remoteExecCall ["diag_log", 2];
	};
	case 2: {
		{
			[_x] call compile preprocessFileLineNumbers "fnc_heal";
		} forEach playableUnits;
		hint "All players were fully healed";
		_msg = text format ["[UO ADMIN]: %1 fully healed everybody with GM heal", name player];
		_msg remoteExecCall ["diag_log", 2];
	};
};