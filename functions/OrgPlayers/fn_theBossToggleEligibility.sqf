params ["_playerX", ["_suggestedNextBoss", objNull]];

_playerX = _playerX getVariable ["owner", _playerX];

if (_playerX getVariable ["eligible",true]) then
{
	_playerX setVariable ["eligible",false,true];
	if (_playerX == theBoss) then
	{
		theBoss = objNull; publicVariable "theBoss";
		
		if(!isNull _suggestedNextBoss && isPlayer _suggestedNextBoss) then {
			hint format ["Ви пішли у відставку з ролі командира. Командування перейде до %1, якщо він буде підходити на цю роль.", name _suggestedNextBoss];
			[_suggestedNextBoss] call A3A_fnc_makePlayerBossIfEligible;
		} else {
			hint "Ви пішли у відставку з ролі командира. Командування перейде до когось іншого.";
		};
		[] call A3A_fnc_assignBossIfNone;
	}
	else
	{
		hint "Ви вирішили, що ви не підходите на роль командира.";
	};
}
else
{
	hint "Тепер ви можете стати командиром.";
	_playerX setVariable ["eligible",true,true];
	[] call A3A_fnc_assignBossIfNone;
};