_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < 100) exitWith {hint "На спільному рахунку немає навіть 100₴"};
[100] call A3A_fnc_resourcesPlayer;
server setvariable ["resourcesFIA",_resourcesFIA - 100, true];
[] remoteExec ["A3A_fnc_statistics",theBoss];
[-2,theBoss] call A3A_fnc_playerScoreAdd;
["scorePlayer", player getVariable "score"] call fn_SaveStat;

hint format ["Ви взяли 100₴ зі спільного рахунку."];//You grabbed 100 € from the %1 Money Pool.\n\nThis will affect your prestige and status among %1 forces",nameTeamPlayer