if !([player] call A3A_fnc_isMember) exitWith {hint "Тільки члени сервера можуть наймати ботів."};

if (recruitCooldown > time) exitWith {hint format ["Почекайте %1, щоб знову наймати.",round (recruitCooldown - time)]};

if (player != player getVariable ["owner",player]) exitWith {hint "Ви не можете наймати, коли контролюєте бота."};

if ([player,300] call A3A_fnc_enemyNearCheck) exitWith {Hint "Ви не можете наймати бійців, коли ворог поблизу."};

if (player != leader group player) exitWith {hint "Ви не можете наймати бійців, бо ви не є командиром відділення."};

private _hr = server getVariable "hr";

if (_hr < 1) exitWith {hint "У вас не достатньо HR, щоб найняти бійців."};
private _arraytypeUnit = _this select 0;
private _typeUnit = _arraytypeUnit select 0;
private _costs = server getVariable _typeUnit;
private _resourcesFIA = 0;
if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA"} else {_resourcesFIA = player getVariable "moneyX";};

if (_costs > _resourcesFIA) exitWith {hint format ["У вас не достатньо грошей, щоб найняти цього бійця (треба %1 ₴)",_costs]};

if ((count units group player) + (count units stragglers) > 9) exitWith {hint "У вашому відділенні забагато бійців, або вони десь загубились і втратили з вами зв'язок."};

private _unit = group player createUnit [_typeUnit, position player, [], 0, "NONE"];

if (!isMultiPlayer) then {
	_nul = [-1, - _costs] remoteExec ["A3A_fnc_resourcesFIA",2];
} else {
	_nul = [-1, 0] remoteExec ["A3A_fnc_resourcesFIA",2];
	[- _costs] call A3A_fnc_resourcesPlayer;
	["moneyX",player getVariable ["moneyX",0]] call fn_SaveStat;
	hint "Бійця найнято.\n\nПам'ятайте. Якщо в меню груп (U-меню) будете перемикати групи, то ви можете втратити контроль над ботом.";
};

[_unit] spawn A3A_fnc_FIAinit;
_unit disableAI "AUTOCOMBAT";
sleep 1;
petros directSay "SentGenReinforcementsArrived";
