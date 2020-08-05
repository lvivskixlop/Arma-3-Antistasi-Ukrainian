if (!hasInterface) exitWith {};
private ["_textX","_display","_setText"];
//sleep 3;
disableSerialization;
//waitUntil {!isNull (uiNameSpace getVariable "H8erHUD")};
if (isNull (uiNameSpace getVariable "H8erHUD")) exitWith {};
_display = uiNameSpace getVariable "H8erHUD";
if (isNil "_display") exitWith {};
waitUntil {sleep 0.5;!(isNil "theBoss")};
_setText = _display displayCtrl 1001;
_setText ctrlSetBackgroundColor [0,0,0,0];
_nameC = "None";
if (!isMultiplayer) then
	{
	_textX = format ["<t size='0.67' shadow='2'>" + "HR: %1 | Спільні Гроші: %2 ₴ | Авіаудари: %5 | %7 Агресія: %3 | %8 Агресія: %4 | Рівень війни: %6 | Інкогніто: %9", server getVariable "hr", server getVariable "resourcesFIA",floor prestigeNATO,floor prestigeCSAT,floor bombRuns,tierWar,nameOccupants,nameInvaders,["Off", "<t color='#1DA81D'>On</t>"] select ((captive player) and !(player getVariable ["INCAPACITATED",false]))];
	}
else
	{
	if (player != theBoss) then
		{
		if (isPlayer theBoss) then {_nameC = name theBoss} else {_nameC = "None"};
		_textX = format ["<t size='0.67' shadow='2'>" + "Командир: %3 | Звання: %2 | HR: %1 | Мої гроші: %4 ₴ | %8 Агресія: %5 | %9 Агресія: %6 | Рівень війни: %7 | Інкогніто: %10", server getVariable "hr", rank player, _nameC, player getVariable "moneyX",floor prestigeNATO, floor prestigeCSAT,tierWar,nameOccupants,nameInvaders,["Off", "<t color='#1DA81D'>On</t>"] select ((captive player) and !(player getVariable ["INCAPACITATED",false]))];
		}
	else
		{
		if ([(player getVariable ["owner",player])] call A3A_fnc_isMember) then
			{
			_textX = format ["<t size='0.67' shadow='2'>" + "Звання: %5 | HR: %1 | Мої гроші: %6 ₴ | Спільні гроші: %2 ₴ | Авіаудари: %7 | %9 Агресія: %3 | %10 Агресія: %4 | Рівень війни: %8 | Інкогніто: %11", server getVariable "hr", server getVariable "resourcesFIA", floor prestigeNATO, floor prestigeCSAT,rank player, player getVariable "moneyX",floor bombRuns,tierWar,nameOccupants,nameInvaders,["Off", "<t color='#1DA81D'>On</t>"] select ((captive player) and !(player getVariable ["INCAPACITATED",false]))];
			}
		else
			{
			_textX = format ["<t size='0.67' shadow='2'>" + "Звання: %1 | Мої гроші: %2 ₴ | Спільні гроші: %3 ₴ | %4 Агресія: %5 | %6 Агресія: %7 | Рівень війни: %8 | Інкогніто: %9",rank player,player getVariable "moneyX",server getVariable "resourcesFIA", nameOccupants, floor prestigeNATO, nameInvaders,floor prestigeCSAT,tierWar,["Off", "<t color='#1DA81D'>On</t>"] select ((captive player) and !(player getVariable ["INCAPACITATED",false]))];
			};
		};
	};

//if (captive player) then {_textX = format ["%1 ON",_textX]} else {_textX = format ["%1 OFF",_textX]};
_setText ctrlSetStructuredText (parseText format ["%1", _textX]);
_setText ctrlCommit 0;