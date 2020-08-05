private ["_typeX","_costs","_positionTel","_quantity","_quantityMax"];

if (["Mines"] call BIS_fnc_taskExists) exitWith {hint "Ми можемо мінувати тільки одну ділянку одночасно."};

if (!([player] call A3A_fnc_hasRadio)) exitWith {if !(hasIFA) then {hint "Вам потрібно мати рацію, щоб віддавати накази іншим відділенням."} else {hint "У вашій групі повинен бути радист, щоб віддавати накази іншим відділенням."}};

_typeX = _this select 0;

_costs = (2*(server getVariable (SDKExp select 0))) + ([vehSDKTruck] call A3A_fnc_vehiclePrice);
_hr = 2;
if (_typeX == "delete") then
	{
	_costs = _costs - (server getVariable (SDKExp select 0));
	_hr = 1;
	};
if ((server getVariable "resourcesFIA" < _costs) or (server getVariable "hr" < _hr)) exitWith {hint format ["Недостатньо ресурсів, щоб найняти мінувальників (треба %1 ₴ і %2 HR)",_costs,_hr]};

if (_typeX == "delete") exitWith
	{
	hint "Мінери тепер доступні у ващому меню вищого командування.\n\nПошліть його кудись на карті і він буде там розміновувати, і складати всі міни в вантажівку.\n\nКоли він повернеться назад до штабу він вивантаже всі з вантажівки міни в арсенал.";
	[[],"A3A_fnc_mineSweep"] remoteExec ["A3A_fnc_scheduler",2];
	};

#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

_pool = jna_dataList select IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT;
_quantity = 0;
_quantityMax = 40;
_typeM =APERSMineMag;
if (_typeX == "ATMine") then
	{
	_quantityMax = 20;
	_typeM = ATMineMag;
	};

{
if (_x select 0 == _typeM) exitWith {_quantity = _x select 1}
} forEach _pool;

if (_quantity < 5) exitWith {hint "Вам потрібно хоча б 5 мін цього типу, щоб зробити мінне поле."};

if (!visibleMap) then {openMap true};
positionTel = [];
hint "Клацайте на позицію, де хочете замінувати.";

onMapSingleClick "positionTel = _pos;";

waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_positionTel = positionTel;

if (_quantity > _quantityMax) then
	{
	_quantity = _quantityMax;
	};

[[_typeX,_positionTel,_quantity],"A3A_fnc_buildMinefield"] remoteExec ["A3A_fnc_scheduler",2];