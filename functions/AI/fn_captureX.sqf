private _unit = _this select 0;
private _playerX = _this select 1;
private _recruiting = _this select 3;

[_unit,"remove"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],_unit];

if (!alive _unit) exitWith {};

private _sideX = side (group _unit);
private _interrogated = _unit getVariable ["interrogated", false];

private _modAggroOcc = 0;
private _modAggroInv = 0;
private _modHR = false;
private _response = "";
private _targetMarker = respawnOccupants;

if (_recruiting) then {
	_playerX globalChat "Ну що, не хочеш до нас долучитись?";

	private _chance = 0;
	if (_sideX == Occupants) then {
		if (faction _unit == factionFIA) then { _chance = 60; _modAggroOcc = 0.1; }
		else { _chance = 20; _modAggroOcc = 0.5; };
	}
	else {
		if (faction _unit == factionFIA) then { _chance = 60; _modAggroInv = 0.1; }
		else { _chance = 40; _modAggroInv = 0.5; };
	};
	if (_interrogated) then { _chance = _chance / 2 };

	if (random 100 < _chance) then {
		_response = "Пачіму бі і нєт. Ну нахєр той рускій мір.";
		_modHR = true;
		_targetMarker = respawnTeamPlayer;
	}
	else {
		_response =  "Пашол ти! Рускіє нє здаюцца!";
		_modAggroOcc = 0;
		_modAggroInv = 0;
	};
}
else {
	_playerX globalChat "Вертайся назад на свою базу і скажи своїм колєґам, що в нас ще достатньо гілок на деревах.";
	_response = selectRandom [
		"Харашо, спасіба. Я дольжен тібє сваю жізьнь!",
		"Спасіба. Абіщаю, чьто ві нє пожалєєте чьто міня атпустілі.",
		"Дякую! Я не забуду твоїх добрих вчинків!"
	];

	private _mult = if (_interrogated) then { 0.5 } else { 1.0 };
	if (_sideX == Occupants) then {
		if (faction _unit == factionFIA) then { _modAggroOcc = -0.3*_mult }
		else { _modAggroOcc = -0.6*_mult };
	}
	else {
		if (faction _unit == factionFIA) then { _modAggroInv = -0.05*_mult }
		else { _modAggroInv = -0.1*_mult };
	};
};


if (isMultiplayer) then {[_unit,true] remoteExec ["enableSimulationGlobal",2]} else {_unit enableSimulation true};
sleep 3;
_unit globalChat _response;
_unit enableAI "ANIM";
_unit enableAI "MOVE";
_unit stop false;
[_unit,""] remoteExec ["switchMove"];
_unit doMove (getMarkerPos _targetMarker);
// probably redundant. Should already be done in surrenderAction
if (_unit getVariable ["spawner",false]) then {_unit setVariable ["spawner",nil,true]};
sleep 100;
if (alive _unit) then
{
	[_modAggroOcc,_modAggroInv] remoteExec ["A3A_fnc_prestige",2];
	if (_modHR) then { [1,0] remoteExec ["A3A_fnc_resourcesFIA",2] };
};
deleteVehicle _unit;
