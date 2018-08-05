/**
 * @Project: Arma Game Moderator Console
 * @Filename: fnc_mapMonitor.sqf
 * @Last modified time: 7/28/2017 - 20:28
 * @License: APL-SA (https://www.bistudio.com/community/licenses/arma-public-license-share-alike)
 * @Arguments:
 *
 * @Return:
 **/
#include "\x\cba\addons\main\script_component.hpp"

#define DEFAULT_PARAM(idx,dft)  (if ((count _this) > idx) then {_this select idx} else {dft})
#define MARKER_ALPHA 0.75 // Default Marker Alpha
#define BULLET_MARKER_THICKNESS 0.25 // Bullet marker line thickness in meters
if (isNil "_this") then {_this = []};
if (typeName(_this) != "ARRAY") then {_this = [_this]};
private ["_detailLevel", "_interval"];
_detailLevel = DEFAULT_PARAM(0,1); // 0 = Low, 1 = Normal, 2 = High, 3 = Very High
_interval = DEFAULT_PARAM(1,1); // Second(s)
/* Function Load Code */
if ((isNil "uo_mapMonitor_fnc_init") || {!uo_mapMonitor_fnc_init}) then {
	uo_mapMonitor_fnc_init = true;
	uo_mapMonitor_constantUpdate = true; // Whether markers should update while the map isn't open.
	uo_mapMonitor_bulletMarkerLifetime = 2; // Seconds of marker lifetime.
	uo_mapMonitor_bulletMaxFlighttime = 3; // Seconds of max bullet lifetime.
	uo_mapMonitor_bulletMarkerRefreshRate = 24; // Hertz of bullet tracking refresh rate, same as FPS.
	uo_mapMonitor_fnc_compareBool = {
		((_this select 0) && (_this select 1)) || {!(_this select 0) && !(_this select 1)}; // Either both true or both false
	};
	uo_mapMonitor_fnc_getSideColor = {
		switch (_this select 0) do {
			case WEST: {"ColorBlue"};
			case EAST: {"ColorRed"};
			case RESISTANCE: {"ColorGreen"};
			default {"ColorUNKNOWN"};
		};
	};
	uo_mapMonitor_fnc_drawBulletMarker = {
		private ["_unit", "_startPos", "_endPos", "_startTime", "_endTime", "_distance", "_dir", "_color", "_markerLine", "_markerEnd"];
		_unit = _this select 0;
		_startPos = _this select 1;
		_endPos = _this select 2;
		_startTime = DEFAULT_PARAM(3,0);
		_endTime = DEFAULT_PARAM(4,uo_mapMonitor_bulletMaxFlighttime);
		_distance = if (isNil "_endPos") then {
			private ["_cfg"];
			_cfg = configFile >> typeOf(_projectile) >> "typicalspeed";
			if (isNumber(_cfg)) then {
				getNumber(_cfg) * (_endTime - _startTime); // Estimate range
			} else {
				300; // Average range of aprox. 150 meters
			};
		} else {
			/* Delete 3rd Dimension */
			_startPos set [2, 0];
			_endPos set [2, 0];
			_startPos distance _endPos;
		};
		_distance = _distance / 2; // Due to marker mechanics
		_dir = ((_endPos select 0) - (_startPos select 0)) atan2 ((_endPos select 1) - (_startPos select 1));
		_color = [side _unit] call uo_mapMonitor_fnc_getSideColor;
		/* Create line marker */
		_markerLine = createMarkerLocal [format["shot_line_%1_%2_%3", _unit, random(100), diag_tickTime], [
			((_startPos select 0) + (_distance * sin(_dir))),
			((_startPos select 1) + (_distance * cos(_dir))),
			0
		]];
		_markerLine setMarkerShapeLocal 'RECTANGLE';
		_markerLine setMarkerColorLocal _color;
		_markerLine setMarkerDirLocal _dir;
		_markerLine setMarkerSizeLocal [BULLET_MARKER_THICKNESS, _distance];
		_markerLine setMarkerAlphaLocal MARKER_ALPHA;
		/* Create line-end-dot marker */
		_markerEnd = createMarkerLocal [format["shot_end_%1_%2_%3", _unit, random(100), diag_tickTime], _endPos];
		_markerEnd setMarkerShapeLocal 'ELLIPSE';
		_markerEnd setMarkerColorLocal _color;
		_markerEnd setMarkerSizeLocal [(BULLET_MARKER_THICKNESS * 3), (BULLET_MARKER_THICKNESS * 3)];
		_markerEnd setMarkerAlphaLocal MARKER_ALPHA;
		[_markerLine, _markerEnd]
	};
	uo_mapMonitor_fnc_firedEH = {
		if (uo_mapMonitor) then {
			private ["_unit", "_projectile", "_startPos"];
			_unit = _this select 0;
			_projectile = _this select 6;
			_startPos = getPos _projectile;
			[_unit, _projectile, _startPos, time] spawn {
				private ["_unit", "_projectile", "_startPos", "_startTime", "_endTime", "_markers", "_trackProj"];
				_unit = _this select 0;
				_projectile = _this select 1;
				_startPos = _this select 2;
				_startTime = _this select 3;
				_endTime = time + uo_mapMonitor_bulletMaxFlighttime;
				_markers = [];
				_trackProj = true;
				while {_trackProj} do {
					_trackProj = !((isNull _projectile) || {!(alive _projectile)} || {time > _endTime});
					if (_trackProj) then {
						{deleteMarkerLocal _x} forEach _markers;
						_markers = [_unit, _startPos, (getPos _projectile), _startTime, time] call uo_mapMonitor_fnc_drawBulletMarker;
						uiSleep (1/uo_mapMonitor_bulletMarkerRefreshRate);
					} else {
						uiSleep uo_mapMonitor_bulletMarkerLifetime;
						{deleteMarkerLocal _x} forEach _markers;
					};
				};
			};
		};
	};
	uo_mapMonitor_fnc_addFiredEH = {
		private ["_obj"];
		_obj = _this select 0;
		if (isNil {_obj getVariable "uo_mapMonitor_firedEH"}) then {
			_obj setVariable ["uo_mapMonitor_firedEH",
				(_obj addEventHandler ["Fired", {_this call uo_mapMonitor_fnc_firedEH;}])
			];
		};
	};
	uo_mapMonitor_fnc_paintObjMarker = {
		#define DFT_MARKER_SIZE [1,1]
		private ["_markers", "_obj", "_type", "_color", "_size", "_alpha", "_marker"];
		_markers = _this select 0;
		_obj = _this select 1;
		_type = _this select 2;
		_color = _this select 3;
		_size = DEFAULT_PARAM(4,DFT_MARKER_SIZE);
		_alpha = DEFAULT_PARAM(5,1);
		_marker = createMarkerLocal[str(_obj), (getPos _obj)];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerDirLocal (getDir _obj);
		_marker setMarkerTypeLocal _type;
		_marker setMarkerColorLocal _color;
		_marker setMarkerAlphaLocal _alpha;
		_marker setMarkerSizeLocal _size;
		_markers set [(count _markers), [_obj, _marker, (alive _obj), (side _obj), (isPlayer _obj)]];
		_marker
	};
	uo_mapMonitor_fnc_monitor = {
		private ["_detailLevel", "_interval", "_markers"];
		_detailLevel = _this select 0;
		_interval = _this select 1;
		_markers = [];
		while {uo_mapMonitor} do {
			private ["_doneObjs", "_sigTerm"];
			_doneObjs = [];
			waitUntil {
				_sigTerm = !(isNil "uo_mapMonitor_sigTerm") && {uo_mapMonitor_sigTerm};
				visibleMap || {shownGPS} || {uo_mapMonitor_constantUpdate} || {_sigTerm};
			};
			{ // forEach
				private ["_obj", "_marker", "_alive", "_side", "_isPlayer"];
				_obj = _x select 0;
				_marker = _x select 1;
				_alive = _x select 2;
				_side = _x select 3;
				_isPlayer = _x select 4;
				if ( // Object has changed state or script is ending
					_sigTerm || // Script ending
					{isNull _obj} || // Object deleted
					{(side _obj) != _side} || // Changed sides
					{(vehicle _obj) != _obj} || // Switched vehicles
					{!([(alive _obj), _alive] call uo_mapMonitor_fnc_compareBool)} || // Died or was revived
					{!([(isPlayer _obj), _isPlayer] call uo_mapMonitor_fnc_compareBool)} // Changed playable status
				) then { // Delete marker
					deleteMarkerLocal _marker;
					_markers set [_forEachIndex, objNull];
				} else { // Keep marker
					_doneObjs set [(count _doneObjs), _obj];
					private ["_objPos", "_mrkPos"];
					_objPos = getPos _obj;
					_mrkPos = getMarkerPos _marker;
					if ( // Object has moved
						((getDir _obj) != (markerDir _marker)) ||
						{((_objPos select 0) != (_mrkPos select 0)) || {(_objPos select 1) != (_mrkPos select 1)}}
					) then { // Update marker position if needed
						_marker setMarkerPosLocal _objPos;
						_marker setMarkerDirLocal (getDir _obj);
					};
				};
			} forEach _markers;
			_markers = _markers - [objNull];
			/* Exit if received termination signal */
			if (_sigTerm) exitWith {
				uo_mapMonitor_sigTerm = false;
			};
			if (visibleMap || uo_mapMonitor_constantUpdate) then { // Repaint map markers
				/* Paint unit map markers */
				{ // forEach
					if (alive _x) then {
						[_x] call uo_mapMonitor_fnc_addFiredEH;
						private ["_playerStat"];
						_playerStat = _x getVariable "uo_mapMonitor_playerStat";
						if ((isNil "_playerStat") || {!([(isPlayer _x), (_playerStat select 1)] call uo_mapMonitor_fnc_compareBool)}) then {
							_x setVariable ["uo_mapMonitor_playerStat", [(name _x), (isPlayer _x)], true];
						};
						if (!(_x in _doneObjs) && {(vehicle _x) == _x}) then {
							private ["_color", "_type", "_marker"];
							_color = [side _x] call uo_mapMonitor_fnc_getSideColor;
							_type = if (isPlayer _x) then {"mil_arrow2"} else {"mil_arrow"};
							_marker = [_markers, _x, _type, _color, [0.4, 0.4], MARKER_ALPHA] call uo_mapMonitor_fnc_paintObjMarker;
							if (_detailLevel >= 1) then {
								if ((isPlayer _x) || {_detailLevel >= 3}) then {
									if (player getVariable ["uogm_mapMon_enableGroupID", false]) then {
										_marker setMarkerTextLocal format ["%1 | %2",(name _x), (groupID (group _x))];
									} else {
										_marker setMarkerTextLocal format ["%1",(name _x)];
									};
								};
							};
						};
					};
				} forEach allUnits;
				/* Paint dead map markers */
				{ // forEach
					if (!(_x in _doneObjs)) then {
						private ["_marker", "_playerStat"];
						_marker = [_markers, _x, "mil_arrow", "ColorBlack", [0.4, 0.4], MARKER_ALPHA] call uo_mapMonitor_fnc_paintObjMarker;
						_playerStat = _x getVariable "uo_mapMonitor_playerStat";
						if ((_detailLevel >= 1) && {!isNil "_playerStat"}) then {
							if ((_playerStat select 1) || {_detailLevel >= 3}) then {
								_marker setMarkerTextLocal (_playerStat select 0);
							};
						};
					};
				} forEach allDead;
				/* Paint vehicle map markers */
				{ // forEach
					if (_x isKindOf "AllVehicles") then { // Protect against fake vehicles
						if (alive _x) then {
							[_x] call uo_mapMonitor_fnc_addFiredEH;
						};
						if (!(_x in _doneObjs)) then {
							private ["_type", "_color", "_marker"];
							_type = switch (true) do {
								case (_x isKindOf "StaticWeapon"): {"b_inf"}; // Static Weapon
								case (_x isKindOf "Car"): {"b_motor_inf"}; // Motorized
								case (_x isKindOf "Tank"): {"b_armor"}; // Armor
								case (_x isKindOf "Helicopter"): {"b_air"}; // Helicopter
								case (_x isKindOf "Plane"): {"b_plane"}; // Airplane
								default {"b_unknown"}; // Anything else
							};
							_color = if (alive _x) then {
								[side _x] call uo_mapMonitor_fnc_getSideColor;
							} else {
								"ColorBlack";
							};
							_marker = [_markers, _x, _type, _color, [0.8, 0.8], MARKER_ALPHA] call uo_mapMonitor_fnc_paintObjMarker;
							if (_detailLevel >= 1) then {
								if (((count (crew _x)) > 0) && {isPlayer((crew _x) select 0)}) then {
									_marker setMarkerTextLocal (name ((crew _x) select 0));
								} else {
									if (_detailLevel >= 2) then {
										_marker setMarkerTextLocal ('"' + (typeOf(_x)) + '"');
									};
								};
							};
						};
					};
				} forEach vehicles;
			};
			uiSleep _interval;
		};
		hint "UO Map Monitor Ended.";
		uo_mapMonitor = false;
	};
};
/* Map Monitor Init Code */
if (isNil "uo_mapMonitor" || {!uo_mapMonitor}) then { // Not running
	if (_interval > 0) then {
		uo_mapMonitor = true;
		hint format["UO Map Monitor Starting.\nInterval: %1 second(s).", _interval];
		[_detailLevel, _interval] spawn uo_mapMonitor_fnc_monitor;
		player setVariable [QGVAR(MapMonitor), true];
	} else {
		hint format["UO Map Monitor Failed to Start.\n\Invalid Interval of %1 second(s).", _interval];
	};
} else { // Already Running
	uo_mapMonitor_sigTerm = true;
	player setVariable [QGVAR(MapMonitor), false];
	hintSilent "UO Map Monitor Ending...";
};
