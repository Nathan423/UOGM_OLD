class Extended_PreInit_EventHandlers {
	class ADDON	{
		init = "call compile preprocessFileLineNumbers '\z\uo\Addons\debugconsole\XEH_preInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers {
	class ADDON	{
		init = "call compile preprocessFileLineNumbers '\z\uo\Addons\debugconsole\xeh_postInit.sqf'";
	};
};
class Extended_Init_EventHandlers {
	class CAManBase {
		class ADDON {
			init = "call compile preprocessFileLineNumbers '\z\uo\Addons\debugconsole\xeh_init.sqf'";
		};
	};
};
