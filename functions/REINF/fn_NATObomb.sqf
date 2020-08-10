if (bombRuns < 1) exitWith {hint "У вас не достатньо очків для авіаудару."};
//if (!allowPlayerRecruit) exitWith {hint "Сервер дууже навантажений. \nЗачекайте поки воно не вспокоїться, чи змініть налаштування FPS сервера, щоб це зробити."};
	if (!([player] call A3A_fnc_hasRadio)) exitWith {if !(hasIFA) then {hint "Вам потрібно мати рацію, щоб віддавати накази іншим відділенням."} else {hint "У вашій групі повинен бути радист, щоб віддавати накази іншим відділенням."}};
if ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count airportsX == 0) exitWith {hint "У вас повинен бути аеродром, щоб це зробити."};
_typeX = _this select 0;

positionTel = [];

hint "Виберіть місце, з якого злітатиме літак, який будєт всєх бамбіть.";

if (!visibleMap) then {openMap true};
onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_pos1 = positionTel;
positionTel = [];

_mrkorig = createMarkerLocal [format ["BRStart%1",random 1000], _pos1];//BRStart
_mrkorig setMarkerShapeLocal "ICON";
_mrkorig setMarkerTypeLocal "hd_destroy";
_mrkorig setMarkerColorLocal "ColorRed";
_mrkOrig setMarkerTextLocal "Бомбардування взліт";

hint "Виберіть на карті позицію, до якої літак буде відступати.";

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {deleteMarker _mrkOrig};

_pos2 = positionTel;
positionTel = [];

_ang = [_pos1,_pos2] call BIS_fnc_dirTo;

bombRuns = bombRuns - 1;
publicVariable "bombRuns";
[] spawn A3A_fnc_statistics;

_mrkDest = createMarkerLocal [format ["BRFin%1",random 1000], _pos2];//BRFin
_mrkDest setMarkerShapeLocal "ICON";
_mrkDest setMarkerTypeLocal "hd_destroy";
_mrkDest setMarkerColorLocal "ColorRed";
_mrkDest setMarkerTextLocal "Повернення";

//openMap false;

_angorig = _ang - 180;

_origpos = [_pos1, 2500, _angorig] call BIS_fnc_relPos;
_finpos = [_pos2, 2500, _ang] call BIS_fnc_relPos;

_planefn = [_origpos, _ang, vehSDKPlane, teamPlayer] call bis_fnc_spawnvehicle;
_plane = _planefn select 0;
_plane setPosATL [getPosATL _plane select 0, getPosATL _plane select 1, 1000];
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane flyInHeight 100;

driver _plane sideChat "Починаю бомбардування. Приліт 30 секунд.";
_wp1 = group _plane addWaypoint [_pos1, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "LIMITED";
_wp1 setWaypointBehaviour "CARELESS";

if (_typeX == "NAPALM" && napalmEnabled) then {_wp1 setWaypointStatements ["true", "[this,""NAPALM""] spawn A3A_fnc_airbomb"]} else {_typeX = "HE"};
if (_typeX == "CARPET") then {_wp1 setWaypointStatements ["true", "[this,""CARPET""] spawn A3A_fnc_airbomb"]};
if (_typeX == "HE") then {_wp1 setWaypointStatements ["true", "[this,""HE""] spawn A3A_fnc_airbomb"]};



_wp2 = group _plane addWaypoint [_pos2, 1];
_wp2 setWaypointSpeed "LIMITED";
_wp2 setWaypointType "MOVE";

_wp3 = group _plane addWaypoint [_finpos, 2];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "FULL";
_wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this; deleteGroup (group this)"];

waitUntil {sleep 1; (currentWaypoint group _plane == 4) or (!canMove _plane)};

deleteMarkerLocal _mrkOrig;
deleteMarkerLocal _mrkDest;
if ((!canMove _plane) and (!isNull _plane)) then
	{
	sleep cleantime;
	{deleteVehicle _x} forEach crew _plane; deleteVehicle _plane;
	deleteGroup group _plane;
	};