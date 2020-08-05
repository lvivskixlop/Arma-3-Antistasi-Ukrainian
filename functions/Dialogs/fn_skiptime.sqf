if (player!= theBoss) exitWith {hint "Лише командир може це робити."};
_presente = false;

{
if ((side _x == Occupants) or (side _x == Invaders)) then
	{
	if ([500,1,_x,teamPlayer] call A3A_fnc_distanceUnits) then {_presente = true};
	};
} forEach allUnits;
if (_presente) exitWith {hint "Ви не можете відпочивати, коли біля наших бійців є ворог."};
if (["rebelAttack"] call BIS_fnc_taskExists) exitWith {hint "Ви не можете відпочивати, коли ворог контратакує."};
if (["invaderPunish"] call BIS_fnc_taskExists) exitWith {hint "Ви не можете відпочивати, коли цивільних атакують."};
if (["DEF_HQ"] call BIS_fnc_taskExists) exitWith {hint "Ви не можете відпочивати, коли на штаб йде атака."};

_checkX = false;
_posHQ = getMarkerPos respawnTeamPlayer;
{
if ((_x distance _posHQ > 100) and (side _x == teamPlayer)) then {_checkX = true};
} forEach (allPlayers - (entities "HeadlessClient_F"));

if (_checkX) exitWith {hint "Всі гравці повинні бути в радіусі 100м від штабу, щоб відпочити."};

remoteExec ["A3A_fnc_resourcecheckSkipTime", 0];


