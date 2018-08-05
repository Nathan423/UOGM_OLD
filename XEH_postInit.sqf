#include "\a3\editor_f\Data\Scripts\dikCodes.h"

UO_debugConsole = false;

/*if (isServer) then {
	uogm_rc_index = radioChannelCreate [[0.96, 0.34, 0.13, 0.8], "GM CHAT", "%CHANNEL_LABEL (%UNIT_NAME)", []];
	publicVariable "uogm_rc_index";
};*/

if (hasInterface) then {
	[] spawn {
		waitUntil {!isNull player && {!isNil "UO_admins"}};

		player setVariable ["uogm_Spectator", false];
		player setVariable ["uogm_cbStates", [0,0,0,0,0]];
		player setVariable ["uogm_mapMonitor", false];

		//Add player settings
		["uogm_mapMon_enableGroupID", "CHECKBOX", "Enable Group ID (Map Monitor)", "United Operations", [true], nil, {
			params ["_value"];
			player setVariable ["uogm_mapMon_enableGroupID", _value];
		}] call CBA_Settings_fnc_init;
		["uogm_interfaceStyle", "CHECKBOX", "ACE Interaction Option", "United Operations", [true], nil, {
			params ["_value"];
			player setVariable ["uogm_interfaceStyle", _value];
		}] call CBA_Settings_fnc_init;

		_action = ["uo_admin_openGUI", "Open GM Menu", "", {createDialog "UOGM";}, {(call uo_fnc_hasGMAccess) && (player getVariable "uogm_interfaceStyle")}] call ace_interact_menu_fnc_createAction;
		[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

		//Adding a button
		["United Operations", "uogm_openGUI", "Open GM Console", {if (call uo_fnc_hasGMAccess) then {createDialog "UOGM";}}, {}, [DIK_APPS, [false, false, false]]] call CBA_fnc_addKeybind;

		//Adding player to GM in-game chat
		/*if (!isMultiplayer || serverCommandExecutable "#kick" || (getPlayerUID player) in UO_admins) then {
			uogm_rc_index radioChannelAdd [player];
		};*/

		sleep 10;

		while {true} do {
			_isGM = call uo_fnc_hasGMAccess;
			uiNamespace setVariable ["uogm_displayDebug", _isGM];

			if (!((player getVariable ["uogm_isGM", false]) isEqualTo _isGM)) then {
				player setVariable ["uogm_isGM", _isGM, true];
			};

			sleep 20;
		};
	};
};

UO_debugConsole = true;
