if (!isServer) exitWith {};

private ["_typeX","_posbase","_potentials","_sites","_exists","_siteX","_pos","_city"];

_typeX = _this select 0;

_posbase = getMarkerPos respawnTeamPlayer;
_potentials = [];
_sites = [];
_exists = false;

_silencio = false;
if (count _this > 1) then {_silencio = true};

if ([_typeX] call BIS_fnc_taskExists) exitWith {if (!_silencio) then {[petros,"globalChat","Так я ж вже дав вам завдання цього типу."] remoteExec ["A3A_fnc_commsMP",theBoss]}};

if (_typeX == "AS") then
	{
	_sites = airportsX + citiesX + (controlsX select {!(isOnRoad getMarkerPos _x)});
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if ((count _sites > 0) and ({sidesX getVariable [_x,sideUnknown] == Occupants} count airportsX > 0)) then
		{
		//_potentials = _sites select {((getMarkerPos _x distance _posbase < distanceMission) and (not(spawner getVariable _x)))};
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			_pos = getMarkerPos _siteX;
			if (_pos distance _posbase < distanceMission) then
				{
				if (_siteX in controlsX) then
					{
					_markersX = markersX select {(getMarkerPos _x distance _pos < distanceSPWN) and (sidesX getVariable [_x,sideUnknown] == teamPlayer)};
					_markersX = _markersX - ["Synd_HQ"];
					_frontierX = if (count _markersX > 0) then {true} else {false};
					if (_frontierX) then
						{
						_potentials pushBack _siteX;
						};
					}
				else
					{
					if (spawner getVariable _siteX == 2) then {_potentials pushBack _siteX};
					};
				};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","Я не маю ніяких завдань на вбивство. Або перемістіть штаб ближче до ворога, або добийте ті завдання, які в вас вже є."] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Місії на вбивство є тільки тоді, коли в районі 4 км від штабу є міста, патрулі, чи аеродроми."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
		if (_siteX in airportsX) then {[[_siteX],"A3A_fnc_AS_Official"] remoteExec ["A3A_fnc_scheduler",2]} else {if (_siteX in citiesX) then {[[_siteX],"A3A_fnc_AS_Traitor"] remoteExec ["A3A_fnc_scheduler",2]} else {[[_siteX],"A3A_fnc_AS_SpecOP"] remoteExec ["A3A_fnc_scheduler",2]}};
		};
	};
if (_typeX == "CON") then
	{
	_sites = (controlsX select {(isOnRoad (getMarkerPos _x))})+ outposts + resourcesX;
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if (count _sites > 0) then
		{
		_potentials = _sites select {(getMarkerPos _x distance _posbase < distanceMission)};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","Я не маю ніяких завдань на захоплення. Або перемістіть штаб ближче до ворога, або добийте ті завдання, які в вас вже є."] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Місії на захоплення є тільки тоді, коли в районі 4 км від штабу є блокпости чи аванпости.."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
		[[_siteX],"A3A_fnc_CON_Outpost"] remoteExec ["A3A_fnc_scheduler",2];
		};
	};
if (_typeX == "DES") then
	{
	_sites = airportsX select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	_sites = _sites + antennas;
	if (count _sites > 0) then
		{
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			if (_siteX in markersX) then {_pos = getMarkerPos _siteX} else {_pos = getPos _siteX};
			if (_pos distance _posbase < distanceMission) then
				{
				if (_siteX in markersX) then
					{
					if (spawner getVariable _siteX == 2) then {_potentials pushBack _siteX};
					}
				else
					{
					_nearX = [markersX, getPos _siteX] call BIS_fnc_nearestPosition;
					if (sidesX getVariable [_nearX,sideUnknown] == Occupants) then {_potentials pushBack _siteX};
					};
				};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","Я не маю ніяких завдань на знищення. Або перемістіть штаб ближче до ворога, або добийте ті завдання, які в вас вже є."] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Місії на знищення потребують якогось ворожого аеродрому чи радіовежі в районі 4 км від штабу."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
//		if (_siteX in airportsX) then {if (random 10 < 8) then {[[_siteX],"A3A_fnc_DES_Vehicle"] remoteExec ["A3A_fnc_scheduler",2]} else {[[_siteX],"A3A_fnc_DES_Heli"] remoteExec ["A3A_fnc_scheduler",2]}};
		if (_siteX in airportsX) then {[[_siteX],"A3A_fnc_DES_Vehicle"] remoteExec ["A3A_fnc_scheduler",2]};
		if (_siteX in antennas) then {[[_siteX],"DES_antenna"] remoteExec ["A3A_fnc_scheduler",2]}
		};
	};
if (_typeX == "LOG") then
	{
	_sites = outposts + citiesX - destroyedSites;
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if (random 100 < 20) then {_sites = _sites + banks};
	if (count _sites > 0) then
		{
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			if (_siteX in markersX) then
				{
				_pos = getMarkerPos _siteX;
				}
			else
				{
				_pos = getPos _siteX;
				};
			if (_pos distance _posbase < distanceMission) then
				{
				if (_siteX in citiesX) then
					{
					_dataX = server getVariable _siteX;
					_prestigeOPFOR = _dataX select 2;
					_prestigeBLUFOR = _dataX select 3;
					if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
						{
						_potentials pushBack _siteX;
						};
					}
				else
					{
					if ([_pos,_posbase] call A3A_fnc_isTheSameIsland) then {_potentials pushBack _siteX};
					};
				};
			if (_siteX in banks) then
				{
				_city = [citiesX, _pos] call BIS_fnc_nearestPosition;
				if (sidesX getVariable [_city,sideUnknown] == teamPlayer) then {_potentials = _potentials - [_siteX]};
				};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","Я не маю ніяких логістичних місій. Або перемістіть штаб ближче до ворога, або добийте ті завдання, які в вас вже є."] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Для логістичних місій треба мати аванпости, міста, чи банки в районі 4 км від штабу."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
		if (_siteX in citiesX) then {[[_siteX],"A3A_fnc_LOG_Supplies"] remoteExec ["A3A_fnc_scheduler",2]};
		if (_siteX in outposts) then {[[_siteX],"A3A_fnc_LOG_Ammo"] remoteExec ["A3A_fnc_scheduler",2]};
		if (_siteX in banks) then {[[_siteX],"A3A_fnc_LOG_Bank"] remoteExec ["A3A_fnc_scheduler",2]};
		};
	};
if (_typeX == "RES") then
	{
	_sites = airportsX + outposts + citiesX;
	_sites = _sites select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
	if (count _sites > 0) then
		{
		for "_i" from 0 to ((count _sites) - 1) do
			{
			_siteX = _sites select _i;
			_pos = getMarkerPos _siteX;
			if (_siteX in citiesX) then {if (_pos distance _posbase < distanceMission) then {_potentials pushBack _siteX}} else {if ((_pos distance _posbase < distanceMission) and (spawner getVariable _siteX == 2)) then {_potentials = _potentials + [_siteX]}};
			};
		};
	if (count _potentials == 0) then
		{
		if (!_silencio) then
			{
			[petros,"globalChat","Я не маю ніяких завдань на порятунок. Або перемістіть штаб ближче до ворога, або добийте ті завдання, які в вас вже є."] remoteExec ["A3A_fnc_commsMP",theBoss];
			[petros,"hint","Завдання на порятунок вимагають міст чи аеродромів в районі 4 км від штабу."] remoteExec ["A3A_fnc_commsMP",theBoss];
			};
		}
	else
		{
		_siteX = selectRandom _potentials;
		if (_siteX in citiesX) then {[[_siteX],"A3A_fnc_RES_Refugees"] remoteExec ["A3A_fnc_scheduler",2]} else {[[_siteX],"A3A_fnc_RES_Prisoners"] remoteExec ["A3A_fnc_scheduler",2]};
		};
	};
if (_typeX == "CONVOY") then
	{
	if (!bigAttackInProgress) then
		{
		_sites = (airportsX + resourcesX + factories + seaports + outposts - blackListDest) + (citiesX select {count (garrison getVariable [_x,[]]) < 10});
		_sites = _sites select {(sidesX getVariable [_x,sideUnknown] != teamPlayer) and !(_x in blackListDest)};
		if (count _sites > 0) then
			{
			for "_i" from 0 to ((count _sites) - 1) do
				{
				_siteX = _sites select _i;
				_pos = getMarkerPos _siteX;
				_base = [_siteX] call A3A_fnc_findBasesForConvoy;
				if ((_pos distance _posbase < (distanceMission*2)) and (_base !="")) then
					{
					if ((_siteX in citiesX) and (sidesX getVariable [_siteX,sideUnknown] == teamPlayer)) then
						{
						if (sidesX getVariable [_base,sideUnknown] == Occupants) then
							{
							_dataX = server getVariable _siteX;
							_prestigeOPFOR = _dataX select 2;
							_prestigeBLUFOR = _dataX select 3;
							if (_prestigeOPFOR + _prestigeBLUFOR < 90) then
								{
								_potentials pushBack _siteX;
								};
							}
						}
					else
						{
						if (((sidesX getVariable [_siteX,sideUnknown] == Occupants) and (sidesX getVariable [_base,sideUnknown] == Occupants)) or ((sidesX getVariable [_siteX,sideUnknown] == Invaders) and (sidesX getVariable [_base,sideUnknown] == Invaders))) then {_potentials pushBack _siteX};
						};
					};
				};
			};
		if (count _potentials == 0) then
			{
			if (!_silencio) then
				{
				[petros,"globalChat","Схоже, що ворог не планує перевозити якісь колони. Можна пересунути штаб ближче, або виконати вже активні завдання, щоб мати більше розвідданих."] remoteExec ["A3A_fnc_commsMP",theBoss];
				[petros,"hint","Для місій на колони потрібно, щоб в районі 5 км від штабу були міста чи аеродроми, та не активна військова база."] remoteExec ["A3A_fnc_commsMP",theBoss];
				};
			}
		else
			{
			_siteX = selectRandom _potentials;
			_base = [_siteX] call A3A_fnc_findBasesForConvoy;
			[[_siteX,_base],"A3A_fnc_convoy"] remoteExec ["A3A_fnc_scheduler",2];
			};
		}
	else
		{
		[petros,"globalChat","Там іде якись бій. Не думаю, щоб вони слали звітам якісь колони."] remoteExec ["A3A_fnc_commsMP",theBoss];
		[petros,"hint","Місії на колони потребують спокійної обстановки, а зара тут трішки загаряче."] remoteExec ["A3A_fnc_commsMP",theBoss];
		};
	};

if ((count _potentials > 0) and (!_silencio)) then {[petros,"globalChat","Маю для вас одне завдання."] remoteExec ["A3A_fnc_commsMP",theBoss]};
