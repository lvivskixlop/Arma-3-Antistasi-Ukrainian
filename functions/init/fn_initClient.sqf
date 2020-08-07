#include "..\Garage\defineGarage.inc"
private _fileName = "initClient.sqf";

//Make sure logLevel is always initialised.
//This should be overridden by the server, as appropriate. Hence the nil check.
if (isNil "logLevel") then { logLevel = 2 };scriptName "initClient.sqf";

[2,"initClient started",_fileName] call A3A_fnc_log;

call A3A_fnc_installSchrodingersBuildingFix;

if (hasInterface) then {
	waitUntil {!isNull player};
	waitUntil {player == player};
	//Disable player saving until they're fully ready, and have chosen whether to load their save.
	player setVariable ["canSave", false, true];
};

if (!isServer) then {
	call A3A_fnc_initFuncs;
	call A3A_fnc_initVar;
	[2,format ["MP client version: %1",localize "STR_antistasi_credits_generic_version_text"],_fileName] call A3A_fnc_log;
}
else {
	waitUntil {sleep 0.5;(!isNil "serverInitDone")};
};
[] execVM "briefing.sqf";

if (!hasInterface) exitWith {
	[2,format ["Headless client version: %1",localize "STR_antistasi_credits_generic_version_text"],_fileName] call A3A_fnc_log;
	[clientOwner] remoteExec ["A3A_fnc_addHC",2];
	call A3A_fnc_initFuncs;
	call A3A_fnc_initVar;
};

_isJip = _this select 1;
if (isMultiplayer) then {
	if (side player == teamPlayer) then {
		player setVariable ["eligible",true,true];
	};
	musicON = false;
	//waitUntil {scriptdone _introshot};
	disableUserInput true;
	cutText ["Чекаєм поки сервер ініціалізується","BLACK",0];
	[2,"Чекаєм сервера...",_fileName] call A3A_fnc_log;
	waitUntil {(!isNil "serverInitDone")};
	cutText ["Стартуєм місію","BLACK IN",0];
	[2,"Сервер завантажився!",_fileName] call A3A_fnc_log;
	[2,format ["JIP client: %1",_isJIP],_fileName] call A3A_fnc_log;
	if (hasTFAR) then {
		[] execVM "orgPlayers\radioJam.sqf";
	};
	tkPunish = if ("tkPunish" call BIS_fnc_getParamValue == 1) then {true} else {false};
	if (side player == teamPlayer) then {
		private _firedHandlerTk = {
			_typeX = _this select 1;
			if ((_typeX == "Put") or (_typeX == "Throw")) then {
				private _shieldDistance = 100;
				if (player distance petros < _shieldDistance) then {
					hint format ["Не можна використовувати вибухонебезпечні речовини з радіусі %1м від штабу! А то будуть тобі і ровер і колеґі!", _shieldDistance];
					deleteVehicle (_this select 6);
					if (_typeX == "Put") then {
						if (player distance petros < 10) then {
							[player, 20, 0.34, petros] call A3A_fnc_punishment;
						};
					};
				};
			};
		};
		player addEventHandler ["Fired", _firedHandlerTk];
		if (hasACE) then {
			["ace_firedPlayer", _firedHandlerTk ] call CBA_fnc_addEventHandler;
		};
	};
	if (!isNil "placementDone") then {_isJip = true};//workaround for BIS fail on JIP detection
}
else {
	theBoss = player;
	groupX = group player;
	if (worldName == "Tanoa") then {groupX setGroupId ["Pulu","GroupColor4"]} else {groupX setGroupId ["Stavros","GroupColor4"]};
	player setIdentity "protagonista";
	player setUnitRank "COLONEL";
	player hcSetGroup [group player];
	player setUnitTrait ["medic", true];
	player setUnitTrait ["engineer", true];
	waitUntil {/*(scriptdone _introshot) and */(!isNil "serverInitDone")};
};

[] spawn A3A_fnc_ambientCivs;
private ["_colourTeamPlayer", "_colorInvaders"];
_colourTeamPlayer = teamPlayer call BIS_fnc_sideColor;
_colorInvaders = Invaders call BIS_fnc_sideColor;
_positionX = if (side player == side (group petros)) then {position petros} else {getMarkerPos "respawn_west"};

{
	_x set [3, 0.33]
} forEach [_colourTeamPlayer, _colorInvaders];

_introShot = [
	_positionX, // Target position
	format ["%1",worldName], // SITREP text
	50, //  altitude
	50, //  radius
	90, //  degrees viewing angle
	0, // clockwise movement
	[
		["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colourTeamPlayer, markerPos "insertMrk", 1, 1, 0, "Insertion Point", 0],
		["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colorInvaders, markerPos "towerBaseMrk", 1, 1, 0, "Radio Towers", 0]
	]
] spawn BIS_fnc_establishingShot;

//Initialise membershipEnabled so we can do isMember checks.
membershipEnabled = if (isMultiplayer && "membership" call BIS_fnc_getParamValue == 1) then {true} else {false};

disableUserInput false;
player setVariable ["spawner",true,true];

if (isMultiplayer && {playerMarkersEnabled}) then {
	[] spawn A3A_fnc_playerMarkers;
};

if (!hasACE) then {
	[player] spawn A3A_fnc_initRevive;
	[] spawn A3A_fnc_tags;
}
else	{
	if (!hasACEMedical) then {[player] spawn A3A_fnc_initRevive;};
};

if (player getVariable ["pvp",false]) exitWith {
	lastVehicleSpawned = objNull;
	[player] call A3A_fnc_pvpCheck;
	[player] call A3A_fnc_dress;
	if (hasACE) then {[] call A3A_fnc_ACEpvpReDress};
	respawnTeamPlayer setMarkerAlphaLocal 0;

	player addEventHandler ["GetInMan", {_this call A3A_fnc_ejectPvPPlayerIfInvalidVehicle}];
	player addEventHandler ["SeatSwitchedMan", {[_this select 0, assignedVehicleRole (_this select 0) select 0, _this select 2] call A3A_fnc_ejectPvPPlayerIfInvalidVehicle}];
	player addEventHandler ["InventoryOpened", {
		_override = false;
		_boxX = typeOf (_this select 1);
		if ((_boxX == NATOAmmoBox) or (_boxX == CSATAmmoBox)) then {_override = true};
		_override
	}];
	_nameX = if (side player == Occupants) then {nameOccupants} else {nameInvaders};
	waituntil {!isnull (finddisplay 46)};
	gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown", {
		_handled = FALSE;
		if (_this select 1 == 207) then {
			if (!hasACEhearing) then {
				if (soundVolume <= 0.5) then {
					0.5 fadeSound 1;
					hintSilent "Ви витягнули беруші.";
				}
				else {
					0.5 fadeSound 0.1;
					hintSilent "Ви вставили беруші.";
				};
			};
		}
		else {
			if (_this select 1 == 21) then {
				closedialog 0;
				_nul = createDialog "NATO_player";
			};
		};
		_handled
	}];
};

player setVariable ["score",0,true];
player setVariable ["owner",player,true];
player setVariable ["punish",0,true];
player setVariable ["moneyX",100,true];
player setUnitRank "PRIVATE";
player setVariable ["rankX",rank player,true];

stragglers = creategroup teamPlayer;
(group player) enableAttack false;
player setUnitTrait ["camouflageCoef",0.8];
player setUnitTrait ["audibleCoef",0.8];

//Give the player the base loadout.
[player] call A3A_fnc_dress;

player setvariable ["compromised",0];
player addEventHandler ["FiredMan", {
	_player = _this select 0;
	if (captive _player) then {
		//if ({((side _x== Invaders) or (side _x== Occupants)) and (_x knowsAbout player > 1.4)} count allUnits > 0) then
		if ({if (((side _x == Occupants) or (side _x == Invaders)) and (_x distance player < 300)) exitWith {1}} count allUnits > 0) then {
			[_player,false] remoteExec ["setCaptive",0,_player];
			_player setCaptive false;
		}
		else {
			_city = [citiesX,_player] call BIS_fnc_nearestPosition;
			_size = [_city] call A3A_fnc_sizeMarker;
			_dataX = server getVariable _city;
			if (random 100 < _dataX select 2) then {
				if (_player distance getMarkerPos _city < _size * 1.5) then {
					[_player,false] remoteExec ["setCaptive",0,_player];
					_player setCaptive false;
					if (vehicle _player != _player) then {
						{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive",0,_x]; _x setCaptive false}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)) - [player]);
					};
				};
			};
		};
	};
}];
player addEventHandler ["HandleDamage", {
	private _victim = param [0];
	private _damage = param [2];
	private _instigator = param [6];
	if(!isNull _instigator && isPlayer _instigator && _victim != _instigator && side _instigator == teamPlayer && _damage > 0.9) then {
		[_instigator, 20, 0.21, _victim] remoteExec ["A3A_fnc_punishment",_instigator];
		[format ["%2 (UID: %3) вирішив постріляти по %1 (UID: %3), в %4м від штабу. %2, ти не правий!",name _victim,name _instigator,getPlayerUID _instigator,_victim distance2D posHQ]] remoteExec ["diag_log",2];
	};
}];
player addEventHandler ["InventoryOpened", {
	private ["_playerX","_containerX","_typeX"];
	_control = false;
	_playerX = _this select 0;
	if (captive _playerX) then {
		_containerX = _this select 1;
		_typeX = typeOf _containerX;
		if (((_containerX isKindOf "Man") and (!alive _containerX)) or (_typeX == NATOAmmoBox) or (_typeX == CSATAmmoBox)) then {
			if ({if (((side _x== Invaders) or (side _x== Occupants)) and (_x knowsAbout _playerX > 1.4)) exitWith {1}} count allUnits > 0) then{
				[_playerX,false] remoteExec ["setCaptive",0,_playerX];
				_playerX setCaptive false;
			}
			else {
				_city = [citiesX,_playerX] call BIS_fnc_nearestPosition;
				_size = [_city] call A3A_fnc_sizeMarker;
				_dataX = server getVariable _city;
				if (random 100 < _dataX select 2) then {
					if (_playerX distance getMarkerPos _city < _size * 1.5) then {
						[_playerX,false] remoteExec ["setCaptive",0,_playerX];
						_playerX setCaptive false;
					};
				};
			};
		};
	};
	_control
}];
/*
player addEventHandler ["InventoryClosed", {
	_control = false;
	_uniform = uniform player;
	_typeSoldier = getText (configfile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "uniformClass");
	_sideType = getNumber (configfile >> "CfgVehicles" >> _typeSoldier >> "side");
	if ((_sideType == 1) or (_sideType == 0) and (_uniform != "")) then {
		if !(player getVariable ["disguised",false]) then {
			hint "Ви носите ворожу форму. Боти можуть вас сплутати з кацапом і випадково застрелити!";
			player setVariable ["disguised",true];
			player addRating (-1*(2001 + rating player));
		};
	}
	else {
		if (player getVariable ["disguised",false]) then {
			hint "Ворожу форму знято.";
			player addRating (rating player * -1);
		};
	};
	_control
}];
*/
player addEventHandler ["HandleHeal", {
	_player = _this select 0;
	if (captive _player) then {
		if ({((side _x== Invaders) or (side _x== Occupants)) and (_x knowsAbout player > 1.4)} count allUnits > 0) then {
			[_player,false] remoteExec ["setCaptive",0,_player];
			_player setCaptive false;
		}
		else {
			_city = [citiesX,_player] call BIS_fnc_nearestPosition;
			_size = [_city] call A3A_fnc_sizeMarker;
			_dataX = server getVariable _city;
			if (random 100 < _dataX select 2) then {
				if (_player distance getMarkerPos _city < _size * 1.5) then {
					[_player,false] remoteExec ["setCaptive",0,_player];
					_player setCaptive false;
				};
			};
		};
	};
}];
player addEventHandler ["WeaponAssembled", {
	private ["_veh"];
	_veh = _this select 1;
	if (_veh isKindOf "StaticWeapon") then {
		if (not(_veh in staticsToSave)) then {
			staticsToSave pushBack _veh;
			publicVariable "staticsToSave";
			[_veh] call A3A_fnc_AIVEHinit;
		};
	_markersX = markersX select {sidesX getVariable [_x,sideUnknown] == teamPlayer};
	_pos = position _veh;
	if (_markersX findIf {_pos inArea _x} != -1) then {hint "Станкову зброю виставлено. Тепер її можуть використовувати боти з гарнізону."};
	}
	else {
		_veh addEventHandler ["Killed",{[_this select 0] remoteExec ["A3A_fnc_postmortem",2]}];
	};
}];
player addEventHandler ["WeaponDisassembled", {
	_bag1 = _this select 1;
	_bag2 = _this select 2;
	//_bag1 = objectParent (_this select 1);
	//_bag2 = objectParent (_this select 2);
	[_bag1] call A3A_fnc_AIVEHinit;
	[_bag2] call A3A_fnc_AIVEHinit;
}];

player addEventHandler ["GetInMan", {
	private ["_unit","_veh"];
	_unit = _this select 0;
	_veh = _this select 2;
	_exit = false;
	if (isMultiplayer) then {
		if !([player] call A3A_fnc_isMember) then {
			_owner = _veh getVariable "ownerX";
			if (!isNil "_owner") then {
				if (_owner isEqualType "") then {
					if ({getPlayerUID _x == _owner} count (units group player) == 0) then {
						hint "Ви не можете сісти в техніку до іншого гравця, бо ви не в одній групі. Міняється через 'U'.";
						moveOut _unit;
						_exit = true;
					};
				};
			};
		};
	};
	if (!_exit) then {
		if (((typeOf _veh) in arrayCivVeh) or ((typeOf _veh) in civBoats)) then {
			if (!(_veh in reportedVehs)) then {
				[] spawn A3A_fnc_goUndercover;
			};
		};
	};
}];

call A3A_fnc_initUndercover;

if (isMultiplayer) then {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;//Exec on client
	if (membershipEnabled) then {
		if !([player] call A3A_fnc_isMember) then {
			private _isMember = false;
			if (isServer) then {
				_isMember = true;
			};
			if (serverCommandAvailable "#logout") then {
				_isMember = true;
				hint "Вас немає в списку членів сервера. О, але я бачу, шо ви є адмін! Ну тоді ласкаво просимо! Зараз ми скоренько запишем вас до списку.";
			};
			
			if (_isMember) then {
				membersX pushBack (getPlayerUID player);
				publicVariable "membersX";
			} else {
				_nonMembers = {(side group _x == teamPlayer) and !([_x] call A3A_fnc_isMember)} count (call A3A_fnc_playableUnits);
				if (_nonMembers >= (playableSlotsNumber teamPlayer) - bookedSlots) then {["memberSlots",false,1,false,false] call BIS_fnc_endMission};
				if (memberDistance != 16000) then {[] execVM "orgPlayers\nonMemberDistance.sqf"};
				
				hint "Добрий день!\n\nВи долучились до сервера як гість.";
			};
		};
	};
};

[] remoteExec ["A3A_fnc_assignBossIfNone", 2];

waitUntil { scriptDone _introshot };

if (_isJip) then {
	[2,"Joining In Progress (JIP)",_filename] call A3A_fnc_log;

	waitUntil {!(isNil "missionsX")};
	if (count missionsX > 0) then {
		{
			_tsk = _x select 0;
			if ([_tsk] call BIS_fnc_taskExists) then {
				_state = _x select 1;
				if ((_tsk call BIS_fnc_taskState) != _state) then {
					/*
					_tskVar = _tsk call BIS_fnc_taskVar;
					_tskVar setTaskState _state;
					*/
					[_tsk,_state] call bis_fnc_taskSetState;
				};
			};
		} forEach missionsX;
	};
}
else 
{
	[2,"Not Joining in Progress (JIP)",_filename] call A3A_fnc_log;
};

[] spawn A3A_fnc_modBlacklist;

//Move this
//HC_commanderX synchronizeObjectsAdd [player];
//player synchronizeObjectsAdd [HC_commanderX];

_textX = [];

if ((hasTFAR) or (hasACRE)) then {
	_textX = ["Знайдено TFAR чи ACRE."];//TFAR or ACRE Detected\n\nAntistasi detects TFAR or ACRE in the server config.\nAll players will start with addon default radios.\nDefault revive system will shut down radios while players are unconscious.\n\n
};
if (hasACE) then {
	_textX = _textX + ["Знайдено ACE 3"];//ACE 3 Detected\n\nAntistasi detects ACE modules in the server config.\nACE items added to arsenal and ammoboxes. Default AI control is disabled\nIf ACE Medical is used, default revive system will be disabled.\nIf ACE Hearing is used, default earplugs will be disabled.
};
if (hasRHS) then {
	_textX = _textX + ["Знайдено RHS"];//RHS Detected\n\nAntistasi detects RHS in the server config.\nDepending on the modules will have the following effects.\n\nAFRF: Replaces CSAT by a mix of russian units\n\nUSAF: Replaces NATO by a mix of US units\n\nGREF: Recruited AI will count with RHS as basic weapons, replaces FIA with Chdk units. Adds some civilian trucks
};
if (hasFFAA) then {
	_textX = _textX + ["Знайдено... FFAA? Що ж то за мод такий, цікаво. Ну грай собі здоровий."];//FFAA Detected\n\nAntistasi detects FFAA in the server config.\nFIA Faction will be replaced by Spanish Armed Forces
};

if (hasTFAR or hasACE or hasRHS or hasACRE or hasFFAA) then {
	[_textX] spawn {
		sleep 0.5;
		_textX = _this select 0;
		"Integrated Mods Detected" hintC _textX;
		hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
			0 = _this spawn {
				_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
				hintSilent "";
			};
		}];
	};
};
waituntil {!isnull (finddisplay 46)};
gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",A3A_fnc_keys];
//removeAllActions boxX;

//if ((!isServer) and (isMultiplayer)) then {boxX call jn_fnc_arsenal_init};

boxX allowDamage false;
boxX addAction ["Перенести з техніки до Арсеналу.", {[] spawn A3A_fnc_empty;}, 4];
boxX addAction ["Пересунути цей об'єкт", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)", 4];
flagX allowDamage false;
flagX addAction ["Найняти бійців", {if ([player,300] call A3A_fnc_enemyNearCheck) then {hint "Не можна наймати бійців, коли ворог поблизу."} else { [] spawn A3A_fnc_unit_recruit; }},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)"];
flagX addAction ["Пересунути цей об'єкт", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)", 4];

//Adds a light to the flag
private _flagLight = "#lightpoint" createVehicle (getPos flagX);
_flagLight setLightDayLight true;
_flagLight setLightColor [1, 1, 0.9];
_flagLight setLightBrightness 0.2;
_flagLight setLightAmbient [1, 1, 0.9];
_flagLight lightAttachObject [flagX, [0, 0, 4]];
_flagLight setLightAttenuation [7, 0, 0.5, 0.5];

vehicleBox allowDamage false;
vehicleBox addAction ["Полікувати, зремонтувати, переозброїти", A3A_fnc_healAndRepair,nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)", 4];
vehicleBox addAction ["Арсенал техніки", JN_fnc_arsenal_handleAction, [], 0, true, false, "", "alive _target && vehicle _this != _this", 10];
if (isMultiplayer) then {
	vehicleBox addAction ["Особистий гараж", { [GARAGE_PERSONAL] spawn A3A_fnc_garage },nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)", 4];
};
vehicleBox addAction ["Спільний гараж", { [GARAGE_FACTION] spawn A3A_fnc_garage; },nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)", 4];
vehicleBox addAction ["Купити техніку", {if ([player,300] call A3A_fnc_enemyNearCheck) then {hint "Не можна купувати техніку, коли ворог поблизу"} else {nul = createDialog "vehicle_option"}},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)", 4];
vehicleBox addAction ["Пересунути цей об'єкт", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)", 4];

fireX allowDamage false;
[fireX, "fireX"] call A3A_fnc_flagaction;

mapX allowDamage false;
mapX addAction ["Опції гри", {hint format ["Antistasi - %2\n\nВерсія: %1\n\nСкладність: %3\nКількість зброї, що безкінечна: %4\nОбмеження телепорту: %5",antistasiVersion,worldName,if (skillMult == 2) then {"Нормальна"} else {if (skillMult == 1) then {"Для слабаків"} else {"Складна"}},minWeaps,if (limitedFT) then {"Та"} else {"Ніт"}]; nul=CreateDialog "game_options";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)", 4];
mapX addAction ["Інформація на карті", A3A_fnc_cityinfo,nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side (group _this) == teamPlayer)", 4];
mapX addAction ["Пересунути цей об'єкт", A3A_fnc_moveHQObject,nil,0,false,true,"","(_this == theBoss)", 4];
if (isMultiplayer) then {mapX addAction ["Інформація по ботах", { [] remoteExec ["A3A_fnc_AILoadInfo",4];},nil,0,false,true,"","((_this == theBoss) || (serverCommandAvailable ""#logout""))"]};
_nul = [player] execVM "OrgPlayers\unitTraits.sqf";
groupPetros = group petros;
groupPetros setGroupIdGlobal ["Петро","GroupColor4"];//Petros
petros setIdentity "friendlyX";
petros setName "Петро";
petros disableAI "MOVE";
petros disableAI "AUTOTARGET";
[petros,"mission"] call A3A_fnc_flagaction;

disableSerialization;
//1 cutRsc ["H8erHUD","PLAIN",0,false];
_layer = ["statisticsX"] call bis_fnc_rscLayer;
_layer cutRsc ["H8erHUD","PLAIN",0,false];
[] spawn A3A_fnc_statistics;

//Check if we need to relocate HQ
if (isNil "placementDone") then {
	if (isNil "playerPlacingHQ" || {!(playerPlacingHQ in (call A3A_fnc_playableUnits))}) then {
		playerPlacingHQ = player;
		publicVariable "playerPlacingHQ";
		call A3A_fnc_placementSelection;
	};
};

//Load the player's personal save.
if (isMultiplayer) then {
	[] spawn A3A_fnc_createDialog_shouldLoadPersonalSave;
}
else 
{
	if (loadLastSave) then {
		[] spawn A3A_fnc_loadPlayer;
	};
};

//Move the player to HQ now they're initialised.
player setPos (getMarkerPos respawnTeamPlayer);

//Disables rabbits and snakes, because they cause the log to be filled with "20:06:39 Ref to nonnetwork object Agent 0xf3b4a0c0"
//Can re-enable them if we find the source of the bug.
enableEnvironment [false, true];

[2,"initClient completed",_fileName] call A3A_fnc_log;
