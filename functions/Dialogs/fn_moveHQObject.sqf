if (player != theBoss) exitWith {hint "Лише командир може пересувати об'єкти штабу."};
private ["_thingX","_playerX","_id","_sites","_markerX","_size","_positionX"];

_thingX = _this select 0;
_playerX = _this select 1;
_id = _this select 2;

if (!(isNull attachedTo _thingX)) exitWith {hint "Об'єкт, який ви хочете пересунути вже хтось пересуває."};
if (vehicle _playerX != _playerX) exitWith {hint "Ви не можете пересувати об'єкти, коли знаходитесь в транспорті."};

if ({!(isNull _x)} count (attachedObjects _playerX) != 0) exitWith {hint "Ви не можете це пересунути, бо до вас причіплено інші штуки."};
_sites = markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer};
_markerX = [_sites,_playerX] call BIS_fnc_nearestPosition;
_size = [_markerX] call A3A_fnc_sizeMarker;
_positionX = getMarkerPos _markerX;
if (_playerX distance2D _positionX > _size) exitWith {hint "Щоб пересувати цей об'єкт він повинен бути ближче до центру зони, до якої він належить."};

_thingX setVariable ["objectBeingMoved", true];

_thingX removeAction _id;
_thingX attachTo [_playerX,[0,2,1]];

private _fnc_placeObject = {
	params [["_thingX", objNull], ["_playerX", objNull], ["_dropObjectActionIndex", -1]];

	if (isNull _thingX) exitWith {diag_log "[Antistasi] Error, trying to place invalid HQ object"};
	if (isNull _playerX) exitWith {diag_log "[Antistasi] Error, trying to place HQ object with invalid player"};

	if (!(_thingX getVariable ["objectBeingMoved", false])) exitWith {};

	if (_playerX == attachedTo _thingX) then {
		detach _thingX;
	};

	if (_dropObjectActionIndex != -1) then {
		_playerX removeAction _dropObjectActionIndex;
	};

	_thingX setVectorUp surfaceNormal position _thingX;
	_thingX setPosATL [getPosATL _thingX select 0,getPosATL _thingX select 1,0.1];

	_thingX setVariable ["objectBeingMoved", false];
	_thingX addAction ["Пересунути цей об'єкт", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)"];
};

private _actionX = _playerX addAction ["Drop Here", {
	(_this select 3) params ["_thingX", "_fnc_placeObject"];

	[_thingX, player, (_this select 2)] call _fnc_placeObject;
}, [_thingX, _fnc_placeObject],0,false,true,"",""];

waitUntil {sleep 1; (_playerX != attachedTo _thingX) or (vehicle _playerX != _playerX) or (_playerX distance2D _positionX > (_size-3)) or !([_playerX] call A3A_fnc_canFight) or (!isPlayer _playerX)};

[_thingX, _playerX, _actionX] call _fnc_placeObject;

if (vehicle _playerX != _playerX) exitWith {hint "Ви не можете пересувати об'єкти, коли знаходитесь в транспорті."};

if  (_playerX distance2D _positionX > _size) exitWith {hint "Цей об'єкт не може пересунутися далі від центру зони."};
