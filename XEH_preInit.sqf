#include "\a3\editor_f\Data\Scripts\dikCodes.h"

// Force activating all addons for this run of the missionStart
private["_cfgPatches", "_class", "_addons"];
if (isServer) then {
	UO_admins = ["_SP_PLAYER_"];

	if (isDedicated) then {
		UO_admins_userconfig = getArray (ConfigFile >> "ACE_ServerSettings" >> "UO_Admins" >> "admins");
	};

	if (!isNil "UO_admins_userconfig") then {
		UO_admins = UO_admins + UO_admins_userconfig;
	};

	publicVariable "UO_admins";
};
