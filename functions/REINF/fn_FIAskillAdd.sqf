if (player != theBoss) exitWith {hint "Тільки командир може це робити."};

if (skillFIA > 20) exitWith {hint "Ваше військо вже досягло максимального рівня."};
if (skillFIA > (tierWar*2)) exitWith {hint "Не можна підвищувати рівень війська при такому рівні війни. (Рів.Армії > (Рів.Війн. * 2))"};
_resourcesFIA = server getVariable "resourcesFIA";
_costs = 1000 + (1.5*(skillFIA *750));
if (_resourcesFIA < _costs) exitWith {hint format ["У вам не достатньо грошей, щоб намуштрувати своїх вояків на наступний рівень. Треба %1 ₴",_costs]};

_resourcesFIA = _resourcesFIA - _costs;
skillFIA = skillFIA + 1;
hint format ["Рівень вашого війська було покращено\nТепер у вас %1 рівень війська",skillFIA];
publicVariable "skillFIA";
server setVariable ["resourcesFIA",_resourcesFIA,true];
[] spawn A3A_fnc_statistics;
{
_costs = server getVariable _x;
_costs = round (_costs + (_costs * (skillFIA/280)));
server setVariable [_x,_costs,true];
} forEach soldiersSDK;
