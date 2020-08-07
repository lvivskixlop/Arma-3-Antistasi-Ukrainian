_veh = cursortarget;

if (isNull _veh) exitWith {hint "Ви не дивитесь на техніку"};

if (_veh distance getMarkerPos respawnTeamPlayer > 50) exitWith {hint "Техніка повинна бути в радіусі 50м від прапора."};

if ({isPlayer _x} count crew _veh > 0) exitWith {hint "Техніка повинна бути порожня, щоб її продати."};

_owner = _veh getVariable "ownerX";
_exit = false;
if (!isNil "_owner") then
	{
	if (_owner isEqualType "") then
		{
		if (getPlayerUID player != _owner) then {_exit = true};
		};
	};

if (_exit) exitWith {hint "Ви не можете продати цю техніку, бо вона вам не належить."};

if (not(_veh isKindOf "Air")) exitWith {hint "Лише повітряною технікою можна набирати очки авіаударів."};

_typeX = typeOf _veh;

//if (_typeX == vehSDKHeli) exitWith {hint "Syndikat Helicopters cannot be used to increase Airstrike points"};

_pointsX = 2;

if (_typeX in vehAttackHelis) then {_pointsX = 5};
if ((_typeX == vehCSATPlane) or (_typeX == vehNATOPlane)) then {_pointsX = 10};
deleteVehicle _veh;
hint format ["Додано %1 очків авіаудару.",_pointsX];
bombRuns = bombRuns + _pointsX;
publicVariable "bombRuns";
[] remoteExec ["A3A_fnc_statistics",theBoss];