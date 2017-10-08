params ["_gm", "_params"];
disableSerialization;
//systemchat str _params;
_params params ["_control", "_press", "_x", "_y", "_shift", "_ctrl", "_alt"];

_mapPos2d = _control ctrlMapScreenToWorld [_x, _y];
//systemChat str _mapPos2d;

if (!isNil "uo_tpGM" && uo_tpGM) exitWith {
    _gm setPosASL [(_mapPos2d select 0), (_mapPos2d select 1), getTerrainHeightASL _mapPos2d];
    hintSilent format ["You teleported to %1", mapGridPosition _gm];
    _msg = text format ["[UO ADMIN]: %1 teleported to %2", name _gm, mapGridPosition _gm];
    _msg remoteExecCall ["diag_log", 2];
    uo_tpGM = false;
};

if (!isNil "uo_tpUser" && uo_tpUser) exitWith {
    _display = findDisplay 951230;
    _unitName = (_display displayCtrl 2100) lbData (lbCurSel (_display displayCtrl 2100));
    _unit = nil;
    {
        if (name _x == _unitName) then {
            _unit = _x;
            _x setPosASL [(_mapPos2d select 0), (_mapPos2d select 1), getTerrainHeightASL _mapPos2d];
        };
    } forEach PlayableUnits;
    hintSilent format ["%1 teleported to %2", name _unit, mapGridPosition _unit];
    _msg = text format ["[UO ADMIN]: %1 teleported %3 to %2", name _gm, mapGridPosition _gm, name _unit];
    _msg remoteExecCall ["diag_log", 2];
    uo_tpUser = false;
};

if (!isNil "uo_tpAllToMap" && uo_tpAllToMap) exitWith {
    _display = findDisplay 951230;
    _unitName = (_display displayCtrl 2100) lbData (lbCurSel (_display displayCtrl 2100));
    {
        _x setPosASL [(_mapPos2d select 0), (_mapPos2d select 1), getTerrainHeightASL _mapPos2d];
    } forEach PlayableUnits;
    hintSilent format ["You teleported %1 players to %2", count playableUnits, mapGridPosition _gm];
    _msg = text format ["[UO ADMIN]: %1 teleported all players to %2", name _gm, mapGridPosition _gm];
    _msg remoteExecCall ["diag_log", 2];
    uo_tpAllToMap = false;
};

if (player getVariable "uogm_mapMonitor") exitWith {
    _sortedByRange = [allMapMarkers,[],{_mapPos2d distance2D getMarkerPos _x},"ASCEND"] call BIS_fnc_sortBy;
    _sortedByRange params ["_nearestMarker"];
    //systemchat format ["Marker found: %1", _nearestMarker];
    if (((getMarkerPos _nearestMarker) distance2D _mapPos2d) < 4) then {
        _unit = nil;
        {
            if (str _x == _nearestMarker) then {
                _unit = _x;
            };
        } forEach allUnits;
        //systemChat str _unit;
        if (isPlayer _unit) then {
            _nearestUnits = nearestObjects [position _unit, ["Man", "Car", "Tank"], 1000];
            _nearestFriendly = [];
            if ((side _unit) countside _nearestUnits > 0) then {
                //systemChat str "Units found";
                {
                    _friend = _x;
                    if (side _friend == side _unit && {_friend != _unit} && {isPlayer _friend}) then {_nearestFriendly pushback _friend};
                } foreach _nearestUnits;
            };
            _display = findDisplay 951230;
            (_display displayCtrl 1005) ctrlSetText format ["Name: %1", (name _unit)];
            (_display displayCtrl 1006) ctrlSetText format ["Side: %1", (side _unit)];
            (_display displayCtrl 1007) ctrlSetText format ["Group: %1", groupID (group _unit)];
            (_display displayCtrl 1008) ctrlSetText format ["Steam ID: %1", (getPlayerUID _unit)];
            (_display displayCtrl 1009) ctrlSetText format ["Grid: %1",  (mapGridPosition _unit)];
            (_display displayCtrl 1010) ctrlSetText "Closest friendly: > 1000m";
            if (count _nearestFriendly > 0) then {
                _nearestFriendly params ["_closestFriend"];
                //systemChat str _closestFriend;
                (_display displayCtrl 1010) ctrlSetText format ["Closest friendly: %1m away", round (_unit distance2d _closestFriend)];
            };
        };
    };
};
