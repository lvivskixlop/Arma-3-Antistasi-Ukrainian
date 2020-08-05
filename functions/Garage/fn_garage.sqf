#include "defineGarage.inc"

if (!(isNil "placingVehicle") && {placingVehicle}) exitWith { hint "Unable to open garage, you are already placing something" };
if (isNil "garageIsOpen") then {
	garageIsOpen = false;
};

garage_mode = _this select 0;

if (garage_mode == GARAGE_FACTION && (not([player] call A3A_fnc_isMember))) exitWith {hint "Ви не маєте доступу до гаража, так як ви не є членом сервера."};
if (garage_mode == GARAGE_FACTION && !allowMembersFactionGarageAccess && player != theBoss) exitWith {hint "Доступ до спільного гаражу вимкнений. Ви повинні бути командиром.";};
if (player != player getVariable "owner") exitWith {hint "Ви не маєте доступу до гаражу, коли контролюєте бота."};
if ([player,300] call A3A_fnc_enemyNearCheck) exitWith {Hint "Ви не можете користуватись гаражом, коли вороги поблизу."};

garage_vehiclesAvailable = [];

//Build a list of the vehicles available to us at this location
_hasAir = false;
_airportsX = airportsX select {(sidesX getVariable [_x,sideUnknown] == teamPlayer) and (player inArea _x)};
if (count _airportsX > 0) then {_hasAir = true};
{
	if (_x in vehPlanes) then
		{
		if (_hasAir) then {garage_vehiclesAvailable pushBack _x};
		}
	else
		{
		garage_vehiclesAvailable pushBack _x;
		};
} forEach (if (garage_mode == GARAGE_FACTION) then {vehInGarage} else {[] call A3A_fnc_getPersonalGarageLocal});

if (count garage_vehiclesAvailable == 0) exitWith {hintC "Гараж порожній, або у вас нема відповідного місця для техніки, що є.\n\nПовітряний транспорт можна дістати тільки біля аеродромів."};

garage_nearestMarker = [markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer},player] call BIS_fnc_nearestPosition;
if !(player inArea garage_nearestMarker) exitWith {hint "Ви повинні бути бляжче до гарнізону, щоб дістати техніку з гаража."};

garage_vehicleIndex = 0;
_initialType = garage_vehiclesAvailable select garage_vehicleIndex;

#define KEY_UP 200
#define KEY_DOWN 208

//We define this once and never remove it
//Because removing handlers can cause the IDs other handlers to change, stopping them being removed.
if (isNil "garage_keyDownHandler") then {
	garage_keyDownHandler = (findDisplay 46) displayAddEventHandler ["KeyDown",
	{
		if (!garageIsOpen) exitWith {false;};
		private _handled = false;
		private _leave = false;
		//Next vehicle
		if (_this select 1 == KEY_UP) then
			{
			_handled = true;
			if (garage_vehicleIndex + 1 > (count garage_vehiclesAvailable) - 1) then {garage_vehicleIndex = 0} else {garage_vehicleIndex = garage_vehicleIndex + 1};
			private _type = garage_vehiclesAvailable select garage_vehicleIndex;
			[_type] call A3A_fnc_vehPlacementChangeVehicle;
			};
		//Previous vehicle
		if (_this select 1 == KEY_DOWN) then
			{
			_handled = true;
			if (garage_vehicleIndex - 1 < 0) then {garage_vehicleIndex = (count garage_vehiclesAvailable) - 1} else {garage_vehicleIndex = garage_vehicleIndex - 1};
					private _type = garage_vehiclesAvailable select garage_vehicleIndex;
			[_type] call A3A_fnc_vehPlacementChangeVehicle;
			};
		_handled;
	}];
};
private _extraMessage = "Стрілочка Вверх-Вних, щоб перебирати техніку<br/>";

//Only allow access to the faction garage if someone else isn't already accessing it. 
//Try to find the player to make sure they're still online - aim to avoid a situation where players are locked out of the garage.
if (garage_mode == GARAGE_FACTION && !isNil "garageLocked" && {(allPlayers findIf { getPlayerUID _x == (garageLocked select 1)}) > -1}) exitWith {
	hint format ["%1 зара використовує гараж.  Почекайте трохи. Якщо воно залагає, то нехай %1 перезайде", garageLocked select 0];
};
//Define this last-thing, as we need to vehPlacement cleanup code to unset it.
garageLocked = [name player, getPlayerUID player];
publicVariable "garageLocked";

garageIsOpen = true;
[_initialType, "GARAGE", _extraMessage] call A3A_fnc_vehPlacementBegin;