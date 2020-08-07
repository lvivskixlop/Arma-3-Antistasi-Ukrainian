private ["_resourcesPlayer","_pointsXJ","_target"];
_resourcesPlayer = player getVariable "moneyX";
if (_resourcesPlayer < 100) exitWith {hint "У вас є менше ніж 100₴"};

if (count _this == 0) exitWith
	{
	[-100] call A3A_fnc_resourcesPlayer;
	[0,100] remoteExec ["A3A_fnc_resourcesFIA",2];
	_pointsXJ = (player getVariable "score") + 1;
	player setVariable ["score",_pointsXJ,true];
	hint "Ви передали 100₴ до спільного рахунку. Дай вам Бог здоров'я!";
	[] spawn A3A_fnc_statistics;
	["moneyX",player getVariable ["moneyX",0]] call fn_SaveStat;
	};
_target = cursortarget;

if (!isPlayer _target) exitWith {hint "Щоб передати іншому гравцеві гроші, ви повинні на нього дивитись."};

[-100] call A3A_fnc_resourcesPlayer;
_money = player getVariable "moneyX";
["moneyX",_money] call fn_SaveStat;
_moneyX = _target getVariable "moneyX";
_target setVariable ["moneyX",_moneyX + 100, true];
hint format ["Ви передали %1 100₴", name _target];
[] remoteExec ["A3A_fnc_statistics",_target];
[] spawn A3A_fnc_statistics;