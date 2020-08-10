private ["_staticX","_nearX","_playerX"];

_staticX = _this select 0;
_playerX = _this select 1;

if (!alive _staticX) exitWith {hint "Не можна красти те, що вже знищено. Ви що, якись супер реставратор, чи шо?"};

if (alive gunner _staticX) exitWith {hint "Не можна красти станкову зброю, коли її хтось використовує."};

if ((alive assignedGunner _staticX) and (!isPlayer (assignedGunner _staticX))) exitWith {hint "Стрілець цієї зброї досі живий."};

if (activeGREF and ((typeOf _staticX == staticATteamPlayer) or (typeOf _staticX == staticAAteamPlayer))) exitWith {hint "Цю зброю розібрати не можна."};

_nearX = [markersX,_staticX] call BIS_fnc_nearestPosition;

if (not(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {hint "Ви повинні спочатку завоювати цю зону, щоб красти там станкову зброю."};

_staticX setOwner (owner _playerX);

private _staticClass =	typeOf _staticX;
private _staticComponents = getArray (configFile >> "CfgVehicles" >> _staticClass >> "assembleInfo" >> "dissasembleTo");

deleteVehicle _staticX;
 
//We need to create the ground weapon holder first, otherwise it won't spawn exactly where we tell it to.
private _groundWeaponHolder = createVehicle ["GroundWeaponHolder", (getPosATL _playerX), [], 0, "CAN_COLLIDE"];
 
for "_i" from 0 to ((count _staticComponents) - 1) do 
	{
		_groundWeaponHolder addBackpackCargoGlobal [(_staticComponents select _i), 1];
	};

[_groundWeaponHolder] call A3A_fnc_AIVEHinit;

/* [_bag1] call A3A_fnc_AIVEHinit;
[_bag2] call A3A_fnc_AIVEHinit; */

hint "Вкрадено. Вона не зникне, коли ви її знову зберете.";