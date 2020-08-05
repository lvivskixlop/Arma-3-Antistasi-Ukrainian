#include "defineGarage.inc"

private ["_pool","_veh","_typeVehX"];
_pool = false;
if (_this select 0 || !isMultiplayer) then {_pool = true};

if (side player != teamPlayer) exitWith {hint "Ви не можете використовувати гараж в режимі інкогніто."};//Only rebels can add vehicles to the garage.
if (!([player] call A3A_fnc_isMember)) exitWith {hint "Лише члени сервера мають доступ до гаража."};

_veh = cursorTarget;

if (isNull _veh) exitWith {hint "Ви не дивитесь на техніку."};

if (!alive _veh) exitWith {hint "Знищену техніку не можна додавати до гаража. Ну а нашо? Вона всеодно не воскресне."};
_closeX = markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer};
_closeX = _closeX select {(player inArea _x) and (_veh inArea _x)};

if (_closeX isEqualTo []) exitWith {hint format ["Ви і ваша техніка повинна бути оточена своїм гарнізоном, щоб покласти техніку до гаража."]};

//if (player distance2d getMarkerPos respawnTeamPlayer > 50) exitWith {hint "Ви повинні бути ближче ніж 50м до штабу."};

if ({alive _x} count (crew vehicle _veh) > 0) exitWith { hint "Та ж не можна ховати техніку, якщо в ній хтось сидить."};

_typeVehX = typeOf _veh;

if (_veh isKindOf "Man") exitWith {hint "Нє, ну ти знущаєшся чи шо?"};

if !(_veh isKindOf "AllVehicles") exitWith {hint "Цю техніку не можна сховати в гараж."};


if (_pool and (count vehInGarage >= (tierWar *3))) exitWith {hint "Ви не можете покласти більше техніки до гаража при теперішньому рівні війни."};

_exit = false;
if (!_pool) then
	{
	_owner = _veh getVariable "ownerX";
	if (!isNil "_owner") then
		{
		if (_owner isEqualType "") then
			{
			if (getPlayerUID player != _owner) then {_exit = true};
			};
		};
	};

if (_exit) exitWith {hint "Ви не можете сховати техніку до гаража, якщо ви не є її власником."};

if (_typeVehX isKindOf "Plane") then
	{
	_airportsX = airportsX select {(sidesX getVariable [_x,sideUnknown] == teamPlayer) and (player inArea _x)};
	if (count _airportsX == 0) then {_exit = true};
	};

if (_exit) exitWith {hint format ["Ви не можете ховати повітряну техніку до гаража, бо ваш штаб не знаходиться біля підконтрольного аеродрому."]};

if (_veh in staticsToSave) then {staticsToSave = staticsToSave - [_veh]; publicVariable "staticsToSave"};

[_veh,true] call A3A_fnc_empty;
if (_veh in reportedVehs) then {reportedVehs = reportedVehs - [_veh]; publicVariable "reportedVehs"};
if (_veh isKindOf "StaticWeapon") then {deleteVehicle _veh};
if (_pool) then
	{
	vehInGarage = vehInGarage + [_typeVehX];
	publicVariable "vehInGarage";
	hint format ["Додано до спільного гаражу"];
	}
else
	{
	[_typeVehX] call A3A_fnc_addToPersonalGarageLocal;
	hint "Додано до особистого гаражу";
	};
