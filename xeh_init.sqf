_n = [] spawn {
  if (isServer) then {
    if (is3DEN || is3DENMultiplayer) exitwith {};
    uogm_rc_index = radioChannelCreate [[0.96, 0.34, 0.13, 0.8], "GM CHAT", "%CHANNEL_LABEL (%UNIT_NAME)", [], false];
    publicVariable "uogm_rc_index";
    diag_log format ["Custom radio index: %1", uogm_rc_index];
    //missionNamespace setVariable ["uo_curZeus", false, true];

    /*uo_dummyZeusGroup = creategroup sideLogic;
    uo_dummyZeusGroup setVariable ["MCC_CPGroup",true,true];

    //server
    _dummy = uo_dummyZeusGroup createunit ["Logic", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
    _name = "uo_server";
    _dummy setvariable ["text","uo_server"];
    call compile (_name + " = _dummy");
    publicVariable _name;

    //CURATOR
    _dummy = uo_dummyZeusGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
    _name = "uo_curator";
    _dummy setvariable ["text","uo_curator"];
    _dummy setvariable ["Addons",2,true];
    _dummy setvariable ["vehicleinit","_this setvariable ['Addons',2,true];"];
    call compile (_name + " = _dummy");
    publicVariable _name;

    _null = [_dummy,[],true] call BIS_fnc_moduleCurator;

    //Add curator presets
    [uo_curator, "player",["%ALL"]] call BIS_fnc_setCuratorAttributes;
    [uo_curator, "object",["%ALL"]] call BIS_fnc_setCuratorAttributes;
    [uo_curator, "group",["%ALL"]] call BIS_fnc_setCuratorAttributes;
    [uo_curator, "waypoint",["%ALL"]] call BIS_fnc_setCuratorAttributes;
    [uo_curator, "marker",["%ALL"]] call BIS_fnc_setCuratorAttributes;*/
  };
};
