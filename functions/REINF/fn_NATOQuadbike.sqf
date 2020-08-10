_markerX = [markersX,player] call BIS_fnc_nearestPosition;

_sideX = side player;
_nameX = if (_sideX == Occupants) then {nameOccupants} else {nameInvaders};

if (sidesX getVariable [_markerX,sideUnknown] != _sideX) exitWith {hint format ["Ви повинні бути ближче до зони, яка належить %1, щоб замовити техніку.",_nameX]};
if ((!(_markerX in airportsX)) and (!(_markerX in seaports)) and (!(_markerX in outposts))) exitWith {hint "Ви повинні бути біля вашого порта, аванпоста чи аеродрому, щоб замовити техніку."};
if (not(player inArea _markerX)) exitWith {hint "Ви повинні бути біля вашого порта, аванпоста чи аеродрому, щоб замовити техніку."};

_typeBike = if (_sideX == Occupants) then {selectRandom vehNATOPVP} else {selectRandom vehCSATPVP};

if (!isNull lastVehicleSpawned) then
	{
	if (lastVehicleSpawned distance player < 100) then {deleteVehicle lastVehicleSpawned};
	};

hint "Vehicle available";
_pos = [];
_radius = 10;
while {_pos isEqualTo []} do
	{
	_pos = (position player) findEmptyPosition [5,_radius,"I_Truck_02_covered_F"];
	_radius = _radius + 10;
	};
lastVehicleSpawned = createVehicle [_typeBike,_pos, [], 10, "NONE"];

[lastVehicleSpawned] call A3A_fnc_AIVEHinit;
