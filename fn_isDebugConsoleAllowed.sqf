#include "\x\cba\addons\diagnostic\script_component.hpp"

// enable debug console in virtual arsenal
if (str missionConfigFile == "A3\Missions_F_Bootcamp\Scenarios\Arsenal.VR\description.ext") exitWith {true};

// give GMs access to the console
if (hasInterface && !isRemoteExecuted && uiNamespace getVariable ["uogm_displayDebug", false]) exitWith {true};

_enableDebugConsole = false;
if (isServer && isRemoteExecuted) then {
	{
		if ((owner _x) == remoteExecutedOwner) then {
			if (_x getVariable ["uogm_isGM", false]) exitWith {_enableDebugConsole = true};
		};
	} forEach playableUnits;
};
if (_enableDebugConsole) exitWith {true};

call {
	#include "\a3\functions_f\Debug\fn_isDebugConsoleAllowed.sqf";
};
