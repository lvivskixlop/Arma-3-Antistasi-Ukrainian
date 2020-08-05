private ["_pool","_veh","_typeVehX"];

_veh = cursorObject;

if (isNull _veh) exitWith {hint "Ви не дивитесь на техніку"};

if (!alive _veh) exitWith {hint "Шо, серйозно? Хочете відкрити знищену техніку?"};

if (_veh isKindOf "Man") exitWith {hint "Ну ти знущаєшся?"};
if (not(_veh isKindOf "AllVehicles")) exitWith {hint "Техніка, на яку ви дивитесь не може бути використана."};
_ownerX = _veh getVariable "ownerX";

if (isNil "_ownerX") exitWith {hint "Техніка, на яку ви дивитесь вже відчинена."};

if (_ownerX != getPlayerUID player) exitWith {hint "Ви не можете зачиняти техніку, яка вам не належить. Ну це логічно."};

_veh setVariable ["ownerX",nil,true];

hint "Відчинено.";
