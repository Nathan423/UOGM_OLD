if ((uiNamespace getVariable ["uogm_endAttemptTime", -6]) + 5 <= time) exitWith {
	uiNamespace setVariable ["uogm_endAttemptTime", time];
	hint "Press again within 5 seconds to confirm.";
};

hint "Mission ending...";
["UO_GMEND", true] remoteExec ["BIS_fnc_endMission", 0];
