private ["_units"];

if (player != leader group player) exitWith {hint "Ви повинні бути командиром відділення, щоб ввімкнути автоматичне лікування"; autoHeal = false};

_units = units group player;

if ({alive _x} count _units == {isPlayer _x} count _units) exitWith {hint "Для автоматичного лікування у вашому відділенні повинен бути хоча б один бот"; autoHeal = false};
