private ["_positionTel","_nearX","_thingX","_groupX","_unitsX","_leave"];
if (!visibleMap) then {openMap true};
positionTel = [];
_thingX = _this select 0;

onMapSingleClick "positionTel = _pos";

hint "Виберіть зону, до гарнізону якої хочете додати бійців.";

waitUntil {sleep 0.5; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_nearX = [markersX,_positionTel] call BIS_fnc_nearestPosition;

if !(_positionTel inArea _nearX) exitWith {hint "Треба клацати біля помаркованої зони."};

if (not(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) exitWith {hint format ["Ця зона нам не підконтрольна."]};

if ((_nearX in outpostsFIA) and !(isOnRoad getMarkerPos _nearX)) exitWith {hint "Не можна керувати гарнізоном в зоні цього типу."};

_thingX = _this select 0;

_groupX = grpNull;
_unitsX = objNull;

if ((_thingX select 0) isEqualType grpNull) then
	{
	_groupX = _thingX select 0;
	_unitsX = units _groupX;
	}
else
	{
	_unitsX = _thingX;
	};

_leave = false;

{
if ((typeOf _x == staticCrewTeamPlayer) or (typeOf _x == SDKUnarmed) or (typeOf _x in arrayCivs) or (!alive _x)) exitWith {_leave = true}
} forEach _unitsX;

if (_leave) exitWith {hint "Полонені, заручники, трупи не можуть бути додані до гарнізону."};

if ((groupID _groupX == "MineF") or (groupID _groupX == "Watch") or (isPlayer(leader _groupX))) exitWith {hint "Не можна ставити гарнізон на мінні поля, блокпости, аванпости."};


if (isNull _groupX) then
	{
	_groupX = createGroup teamPlayer;
	_unitsX joinSilent _groupX;
	//{arrayids = arrayids + [name _x]} forEach _unitsX;
	hint "Додаю бійців до гарнізону.";
	if !(hasIFA) then {{arrayids pushBackUnique (name _x)} forEach _unitsX};
	}
else
	{
	hint format ["Додаю %1 до гарнізону", groupID _groupX];
	theBoss hcRemoveGroup _groupX;
	};
/*
_garrison = [];
_garrison = _garrison + (garrison getVariable [_nearX,[]]);
{_garrison pushBack (typeOf _x)} forEach _unitsX;
garrison setVariable [_nearX,_garrison,true];
[_nearX] call A3A_fnc_mrkUpdate;
*/
[_unitsX,teamPlayer,_nearX,0] remoteExec ["A3A_fnc_garrisonUpdate",2];
_noBorrar = false;

if (spawner getVariable _nearX != 2) then
	{

	{deleteWaypoint _x} forEach waypoints _groupX;
	_wp = _groupX addWaypoint [(getMarkerPos _nearX), 0];
	_wp setWaypointType "MOVE";
	{
	_x setVariable ["markerX",_nearX,true];
	_x addEventHandler ["killed",
		{
		_victim = _this select 0;
		_markerX = _victim getVariable "markerX";
		if (!isNil "_markerX") then
			{
			if (sidesX getVariable [_markerX,sideUnknown] == teamPlayer) then
				{
				/*
				_garrison = [];
				_garrison = _garrison + (garrison getVariable [_markerX,[]]);
				if (_garrison isEqualType []) then
					{
					for "_i" from 0 to (count _garrison -1) do
						{
						if (typeOf _victim == (_garrison select _i)) exitWith {_garrison deleteAt _i};
						};
					garrison setVariable [_markerX,_garrison,true];
					};
				[_markerX] call A3A_fnc_mrkUpdate;
				*/
				[typeOf _victim,teamPlayer,_markerX,-1] remoteExec ["A3A_fnc_garrisonUpdate",2];
				_victim setVariable [_markerX,nil,true];
				};
			};
		}];
	} forEach _unitsX;

	waitUntil {sleep 1; (spawner getVariable _nearX == 2 or !(sidesX getVariable [_nearX,sideUnknown] == teamPlayer))};
	if (!(sidesX getVariable [_nearX,sideUnknown] == teamPlayer)) then {_noBorrar = true};
	};

if (!_noBorrar) then
	{
	{
	if (alive _x) then
		{
		deleteVehicle _x
		};
	} forEach _unitsX;
	deleteGroup _groupX;
	}
else
	{
	//añadir el groupX al HC y quitarles variables
	{
	if (alive _x) then
		{
		_x setVariable ["markerX",nil,true];
		_x removeAllEventHandlers "killed";
		_x addEventHandler ["killed", {
			_victim = _this select 0;
			_killer = _this select 1;
			[_victim] remoteExec ["A3A_fnc_postmortem",2];
			if ((isPlayer _killer) and (side _killer == teamPlayer)) then
				{
				if (!isMultiPlayer) then
					{
					_nul = [0,20] remoteExec ["A3A_fnc_resourcesFIA",2];
					_killer addRating 1000;
					};
				}
			else
				{
				if (side _killer == Occupants) then
					{
					_nul = [0.25,0,getPos _victim] remoteExec ["A3A_fnc_citySupportChange",2];
					[-0.25,0] remoteExec ["A3A_fnc_prestige",2];
					}
				else
					{
					if (side _killer == Invaders) then {[0,-0.25] remoteExec ["A3A_fnc_prestige",2]};
					};
				};
			_victim setVariable ["spawner",nil,true];
			}];
		};
	} forEach _unitsX;
	theBoss hcSetGroup [_groupX];
	hint format ["Група %1 тепер є в меню вищого командування, бо їх гарнізон було розбито і базу втрачено.",groupID _groupX];
	};

