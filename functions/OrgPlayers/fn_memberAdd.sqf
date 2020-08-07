if (!(serverCommandAvailable "#logout") and (!isServer)) exitWith {hint "Only Server Admins or hosters can add a new member"};

if !(membershipEnabled) exitWith {hint "Функція членів сервера вимкнена."};

if (isNil "membersX") exitWith {hint "Функція членів сервера ще не ініціалізована. Почекайте трохи."};

_target = cursortarget;

if (!isPlayer _target) exitWith {hint "Ви ні на кого не покахуєте."};
_uid = getPlayerUID _target;
if ((_this select 0 == "add") and ([_target] call A3A_fnc_isMember)) exitWith {hint "Цей гравець вже є членом сервера"};
if ((_this select 0 == "remove") and  !([_target] call A3A_fnc_isMember)) exitWith {hint "Цей гравець не є членом сервера"};

if (_this select 0 == "add") then
	{
	membersX pushBackUnique _uid;
	hint format ["%1 тепер у списку членів сервера",name _target];
	["Вас додали до членів сервера"] remoteExec ["hint", _target];
	}
else
	{
	membersX = membersX - [_uid];
	hint format ["%1 був видалений зі списку членів сервера",name _target];
	["Вас видалили із членів сервера"] remoteExec ["hint", _target];
	};
publicVariable "membersX";