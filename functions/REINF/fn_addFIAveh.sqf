
if (!(isNil "placingVehicle") && {placingVehicle}) exitWith { hint "Не можна купувати техніку, коли ставите якусь." };
if (player != player getVariable ["owner",player]) exitWith {hint "Ви не можете купити техніку, коли контролюєте ботом."};
if ([player,300] call A3A_fnc_enemyNearCheck) exitWith {Hint "Ви не можете купувати техніку, коли ворог поблизу."};


private _typeVehX = _this select 0;
if (_typeVehX == "not_supported") exitWith {hint "Техніка, яку ви попросили не підтримується у вашій збірці модів."};

vehiclePurchase_cost = [_typeVehX] call A3A_fnc_vehiclePrice;

private _resourcesFIA = 0;
if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA"} else
	{
	if (player != theBoss) then
		{
		_resourcesFIA = player getVariable "moneyX";
		}
	else
		{
		if ((_typeVehX == SDKMortar) or (_typeVehX == staticATteamPlayer) or (_typeVehX == staticAAteamPlayer) or (_typeVehX == SDKMGStatic)) then {_resourcesFIA = server getVariable "resourcesFIA"} else {_resourcesFIA = player getVariable "moneyX"};
		};
	};

if (_resourcesFIA < vehiclePurchase_cost) exitWith {hint format ["У вас немає достатньо грошей, щоб купити цю техніку. Треба %1₴",vehiclePurchase_cost]};
vehiclePurchase_nearestMarker = [markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer},player] call BIS_fnc_nearestPosition;
if !(player inArea vehiclePurchase_nearestMarker) exitWith {hint "Ви повинні бути біля прапора, щоб купити техніку."};

private _extraMessage =	format ["Купується техніку за %1₴", vehiclePurchase_cost];

[_typeVehX, "BUYFIA", _extraMessage] call A3A_fnc_vehPlacementBegin;