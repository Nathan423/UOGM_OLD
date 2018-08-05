if (!isServer) exitWith {};

params ["_unit", "_enable"];

_zeus = missionNamespace getVariable ["uogm_curator", objNull];

if (isNull _zeus) then {
	_side = createCenter sidelogic;
	_group = createGroup _side;
	_zeus = _group createUnit ["ModuleCurator_F", [0,0,0], [], 0, "NONE"];
	_zeus allowCuratorLogicIgnoreAreas true;

	missionNamespace setVariable ["uogm_curator", _zeus, true];
};

_zeus = missionNamespace getVariable "uogm_curator";

if (_enable) then {
	_zeus addCuratorEditableObjects [allMissionObjects "All", true];
	_zeus addCuratorEditableObjects [vehicles+allunits-allplayers];

	_unit assignCurator _zeus;

	_msg = text format ["[UO ADMIN]: %1 enabled Zeus", name _unit];
	diag_log _msg;
} else {
	unassignCurator _zeus;

	_msg = text format ["[UO ADMIN]: %1 disabled Zeus", name _unit];
	diag_log _msg;
};
