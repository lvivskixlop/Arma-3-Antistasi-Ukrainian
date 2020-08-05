private ["_unit","_idRank","_newRank","_result"];
_unit = _this select 0;
//_idRank = rankId _unit + 1;
_rankX = _unit getVariable ["rankX","PRIVATE"];
switch (_rankX) do
	{
	case "PRIVATE": {_idRank= 1; _newRank = "Козак"};
	case "CORPORAL": {_idRank = 2; _newRank = "Вістун"};
	case "SERGEANT": {_idRank = 3; _newRank = "Ройовий"};
	case "LIEUTENANT": {_idRank = 4; _newRank = "Хорунжий"};
	case "CAPTAIN": {_idRank = 5; _newRank = "Сотник"};
	case "MAJOR": {_idRank = 6; _newRank = "Майор"};
	case "COLONEL": {_idRank = 7; _newRank = "Полковник"};
	};
_result = [_idRank,_newRank];
_result