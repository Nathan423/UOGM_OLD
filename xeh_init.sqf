[] spawn {
	if (isServer) then {
		if (is3DEN || is3DENMultiplayer) exitwith {};
		uogm_rc_index = radioChannelCreate [[0.96, 0.34, 0.13, 0.8], "GM CHAT", "%CHANNEL_LABEL (%UNIT_NAME)", [], false];
		publicVariable "uogm_rc_index";
		diag_log format ["Custom radio index: %1", uogm_rc_index];

		sleep 5;

		while {true} do {
			{
				_admin = admin owner _x;
				if (_x getVariable ["administratorLevel", 0] != _admin) then {
					_x setVariable ["administratorLevel", _admin, true];
				};
			} forEach playableUnits;

			sleep 10;
		};
	};
};
