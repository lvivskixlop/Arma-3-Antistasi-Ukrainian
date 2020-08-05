#include "defineGarage.inc"

//THIS SHOULDN'T BE CALLED OUTSIDE OF THE VEHICLE PLACEMENT SCRIPTS
//CALL AT YOUR OWN RISK

params ["_vehType"];

private _vehName = getText (configFile >> "CfgVehicles" >> _vehType >> "displayName");
private _turboKeyName = if (count (actionKeysNames ["turbo", 1]) > 0) then {actionKeysNames ["turbo", 1];} else {"""Клавіша не призначена""";};
[format ["<t size='0.7'>%1</t><br/><t size='0.5'>%2</t><br/><t size='0.5'>SPACE Поставити техніку<br/>Стрілочки Вліво-Вправо - крутити<br/>%3 Точне положення (ліпше не використовувати)<br/>ENTER Вийти</t>", _vehName, vehPlace_extraMessage, _turboKeyName],0,0,5,0,0,4] spawn bis_fnc_dynamicText;
