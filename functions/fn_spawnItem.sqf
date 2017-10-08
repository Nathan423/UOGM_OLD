FNC_AddItemToPlayer = {
	params ["_unit", "_item", "_amount"];
	_position = "none";
	for "_x" from 1 to _amount do {
		_succes = false;
		_parents = [configFile >> "CFGweapons" >> _item, true] call BIS_fnc_returnParents;
		_type = (_item call BIS_fnc_itemType) select 1;
		if (_position == "none") then {
			if (!_succes && "Rifle" in _parents) then {
				if (primaryWeapon _unit == "") then {
					_unit addWeaponGlobal _item;
					_succes = true;
				};
			};
			if (!_succes && "Pistol" in _parents) then {
				if (handgunWeapon _unit == "") then {
					_unit addWeaponGlobal _item;
					_succes = true;
				};
			};
			if (!_succes && "Launcher" in _parents) then {
				if (secondaryWeapon _unit == "") then {
					_unit addWeaponGlobal _item;
					_succes = true;
				};
			};
			if (!_succes && _type in ["Map", "GPS", "Compass", "Watch", "NVGoggles"]) then {
				if ([_unit, _type] call FNC_CanLinkItem) then {
					_unit linkItem _item;
					_succes = true;
				};
			};
			if (!_succes && _type == "uniform") then {
				if (uniform _unit == "") then {
					_unit forceAddUniform _item;
					_succes = true;
				};
			};
			if (!_succes && _type == "vest") then {
				if (vest _unit == "") then {
					_unit addVest _item;
					_succes = true;
				};
			};
			if (!_succes && _type == "backpack") then {
				if (backpack _unit == "") then {
					_unit addBackpackGlobal _item;
					_succes = true;
				};
			};
			if (!_succes && _type == "Headgear") then {
				if (headgear _unit == "") then {
					_unit addHeadgear _item;
					_succes = true;
				};
			};
			if (!_succes && _type == "Glasses") then {
				if (goggles _unit == "") then {
					_unit addGoggles _item;
					_succes = true;
				};
			};
			if (!_succes && _type == "Binocular") then {
				if (binocular _unit == "") then {
					_unit addWeaponGlobal _item;
					_succes = true;
				};
			};
			if (!_succes && _type in ["AccessoryMuzzle", "AccessoryPointer", "AccessorySights", "AccessoryBipod"]) then {
				if ([primaryWeapon _unit, _item] call FNC_CanAttachItem) then {
					if (!(_type in primaryWeaponItems _unit)) then {
						_unit addPrimaryWeaponItem _item;
						_succes = true;
					};
				};
				if ([handgunWeapon _unit, _item] call FNC_CanAttachItem) then {
					if (!(_type in handgunItems _unit)) then {
						_unit addHandgunItem _item;
						_succes = true;
					};
				};
				if ([secondaryWeapon _unit, _item] call FNC_CanAttachItem) then {
					if (!(_type in secondaryWeaponItems _unit)) then {
						_unit addSecondaryWeaponItem _item;
						_succes = true;
					};
				};
			};
		} else {
			if (!_succes) then {
				switch (_position) do {
					case "backpack": {
						if (_unit canAddItemToBackpack _item) then {
							_unit addItemToBackpack _item;
							_succes = true;
						};
					};
					case "vest": {
						if (_unit canAddItemToVest _item) then {
							_unit addItemToVest _item;
							_succes = true;
						};
					};
					case "uniform": {
						if (_unit canAddItemToUniform _item) then {
							_unit addItemToUniform _item;
							_succes = true;
						};
					};
				};
			};
		};
		if (!_succes) then {
			if (_unit canAdd _item && _type != "Backpack") then {
				_unit addItem _item;
				_succes = true;
			};
		};
	};
	hintSilent format ["%1 has been given to you.", _item];
};
params ["_gm", "_type"];
disableSerialization;
publicVariable "FNC_addItemToPlayer";


_itemBox = ((findDisplay 951230) displayCtrl 2101);
_unitbox = ((findDisplay 951230) displayCtrl 2100);
_editLine = ((findDisplay 951230) displayCtrl 1400);
_itemCount = ((findDisplay 951230) displayCtrl 1401);

_classname = if (ctrlText _editLine == "") then {_itemBox lbData (lbCurSel _itemBox);} else {ctrlText _editLine;};
_count = (ctrlText _itemCount);
_countNum = parseNumber _count;

switch (_type) do {
	case "PLAYER": {

		_execUnitname = _unitbox lbData (lbCurSel _unitbox);
		_execUnit = nil;
		{
			if (name _x == _execUnitname) then {_execUnit = _x};
		} forEach playableUnits;
		[_execUnit, _classname, _countNum] remoteExecCall ["FNC_addItemToPlayer", _execUnit, false];
		hint "Player was given the item";
		_msg = text format ["[UO ADMIN]: %1 gave %3 %2 to %4", name player,_classname , _countNum, _execUnitname];
		_msg remoteExecCall ["diag_log", 2];
	};
	case "ALL": {
		{
			[_x, _classname, _countNum] remoteExecCall ["FNC_addItemToPlayer", _x, false];
		} forEach playableUnits;
		hint "Everyone was given the item";
		_msg = text format ["[UO ADMIN]: %1 gave %3 %2 to everybody", name player,_classname , _countNum];
		_msg remoteExecCall ["diag_log", 2];
	};
	case "BOX": {
		_box = "Box_NATO_Wps_F" createVehicle (position player);
		clearBackpackCargoGlobal _box;
		clearItemCargoGlobal _box;
		clearWeaponCargoGlobal _box;
		clearMagazineCargoGlobal _box;
		_box setVariable ["NBW_Spawner", _gm];
		_box addAction ["[ADMIN]: DELETE BOX", {deleteVehicle (_this select 0)},[], 0, true, false, "", "(_this distance _target)<5 && (_target getVariable 'NBW_Spawner') == _this"];
		_box addItemCargoGlobal [_classname, _countNum];
		_msg = text format ["[UO ADMIN]: %1 gave %3 %2 in a box", name _gm, _classname, _countNum];
		_msg remoteExecCall ["diag_log", 2];
	};
};
