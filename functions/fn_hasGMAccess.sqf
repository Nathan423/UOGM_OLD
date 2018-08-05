if (!isMultiplayer || isServer || (getPlayerUID player) in UO_admins || (player getVariable ["administratorLevel", 0]) == 2) exitwith {true};
false;
