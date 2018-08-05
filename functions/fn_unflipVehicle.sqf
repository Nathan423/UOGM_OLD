params ["_unit"];

[_unit, surfaceNormal position _unit] remoteExec ["setVectorUp", _unit, false];
