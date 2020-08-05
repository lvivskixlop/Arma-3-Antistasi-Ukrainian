
_resourcesFIA = server getVariable "resourcesFIA";

if (_resourcesFIA < 5000) exitWith {hint "У ван не достатньо грошей, щоб відбудувати якись об'єкт штабу. Треба мати хоча б 5000 ₴."};

_destroyedSites = destroyedSites - citiesX;

if (!visibleMap) then {openMap true};
positionTel = [];
hint "Click on the zone you want to rebuild.";

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

_siteX = [markersX,_positionTel] call BIS_fnc_nearestPosition;

if (getMarkerPos _siteX distance _positionTel > 50) exitWith {hint "Треба клацнути біля маркера на карті."};

if ((not(_siteX in _destroyedSites)) and (!(_siteX in outposts))) exitWith {hint "Ви не можете це відбудувати."};

_leave = false;
_antennaDead = objNull;
_textX = "На цьому аванпості немає знищеної радіовежі.";
if (_siteX in outposts) then
	{
	_antennasDead = antennasDead select {_x inArea _siteX};
	if (count _antennasDead > 0) then
		{
		if (sidesX getVariable [_siteX, sideUnknown] != teamPlayer) then
			{
			_leave = true;
			_textX = format ["Ви не можете відбудувати радіовежу на аванпості, який вам не підконтрольний."];
			}
		else
			{
			_antennaDead = _antennasDead select 0;
			};
		}
	else
		{
		_leave = true
		};
	};

if (_leave) exitWith {hint format ["%1",_textX]};

if (isNull _antennaDead) then
	{
	_nameX = [_siteX] call A3A_fnc_localizar;

	hint format ["%1 Rebuilt"];

	[0,10,_positionTel] remoteExec ["A3A_fnc_citySupportChange",2];
	[5,0] remoteExec ["A3A_fnc_prestige",2];
	destroyedSites = destroyedSites - [_siteX];
	publicVariable "destroyedSites";
	}
else
	{
	hint "Radio Tower rebuilt";
	[_antennaDead] remoteExec ["A3A_fnc_rebuildRadioTower", 2];
	};
[0,-5000] remoteExec ["A3A_fnc_resourcesFIA",2];