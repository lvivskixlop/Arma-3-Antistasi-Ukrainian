private ["_veh","_esStatic","_groupX","_maxCargo"];

if (count hcSelected player != 1) exitWith {hint "Ви повинні вибрати групу в меню вищого командування."};

_groupX = (hcSelected player select 0);

if ((groupID _groupX == "Watch") or (groupID _groupX == "MineF")) exitwith {hint "Ця група вже має техніку, від якої залежить місія."};

_veh = cursortarget;

_typeX = typeOf _veh;

//if (cursortarget == "") exitWith {hint "Ви ні на шо не дивитесь"};
//if ((not(_typeX in vehFIA)) and (not(_typeX in vehAAFland)) and (not(_typeX in arrayCivVeh))) exitWith {hint "Техніку, на яку ви дивитесь не підходить."};

if ((!alive _veh) or (!canMove _veh)) exitWith {hint "Вибрана техніка є знищена, чи не може їздити."};
if ({(alive _x) and (_x in _veh)} count allUnits > 0) exitWith {hint "Вибрана техніка не є порожня."};
if (_veh isKindOf "StaticWeapon") exitWith {hint "Ви не може призначити станкову зброю цілій групі."};

_esStatic = false;
{if (vehicle _x isKindOf "StaticWeapon") then {_esStatic = true}} forEach units _groupX;
if (_esStatic) exitWith {hint "Станкова зброя не може замінити техніку."};//Static Weapon Squads cannot change of vehicle

//_maxCargo = (_veh emptyPositions "Cargo") + (_veh emptyPositions "Commander") + (_veh emptyPositions "Gunner") + (_veh emptyPositions "Driver");
_maxCargo = (getNumber (configFile >> "CfgVehicles" >> (_typeX) >> "transportSoldier")) + (count allTurrets [_veh, true]) + 1;
if ({alive _x} count units _groupX > _maxCargo) exitWith {hint "В техніці не достатньо місця для всієї групи."};

hint format ["Техніку призначено до відділення %1", groupID _groupX];

_owner = _veh getVariable "owner";
if (!isNil "_owner") then
	{
	{unassignVehicle _x; _x leaveVehicle _veh} forEach units _owner;
	};

if (count allTurrets [_veh, false] > 0) then
			{
			_veh allowCrewInImmobile true;
			};

_groupX addVehicle _veh;
_veh setVariable ["owner",_groupX,true];

leader _groupX assignAsDriver _veh;
{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _groupX;





