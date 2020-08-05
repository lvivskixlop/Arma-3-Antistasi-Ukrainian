private ["_pos","_siteX","_city","_textX"];

_siteX = _this select 0;

_pos = getMarkerPos _siteX;

_textX = "";


if (_siteX in citiesX) then
	{
	_textX = format ["%1",[_siteX,false] call A3A_fnc_location];
	}
else
	{
	_city = [citiesX,_pos] call BIS_fnc_nearestPosition;
	_city = [_city,false] call A3A_fnc_location;
	if (_siteX in airportsX) then {_textX = format ["%1 Авіабаза",_city]};
	if (_siteX in resourcesX) then {_textX = format ["Ресурси біля %1",_city]};
	if (_siteX in factories) then {_textX = format ["Завод біля %1",_city]};
	if (_siteX in outposts) then {_textX = format ["Аванпост біля %1",_city]};
	if (_siteX in seaports) then {_textX = format ["Порт біля %1",_city]};
	if (_siteX in controlsX) then
		{
		if (isOnRoad getMarkerPos _siteX) then
			{
			_textX = format ["Блокпост біля %1",_city]
			}
		else
			{
			_textX = format ["Ліс біля %1",_city]//forest near
			};
		}
	else{
		if ((_siteX == "NATO_carrier") or (_siteX == "CSAT_carrier")) then {_textX = "their carrier"};
		};
	};
_textX