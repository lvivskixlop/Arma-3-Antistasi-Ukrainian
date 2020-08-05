_nul=createDialog "set_params";

waitUntil {dialog};
hint "У В А Г А!\n\nПРОЧИТАЙ!!!\n\n\nАнтастазі НЕ підтримує ванільного збереження. Воно не буде 100% працювати, якщо ви натиснете Зберегти і вийти, а потім Продовжити. Це стосується як самітньої гри, так і мультиплеєра.\n\n\nВ Антістазі є своя вбудована система збережень, яка працює як має бути.\n\nЩоб зберегти, підійдіть до карти штабу, виберіть 'Опції гри' -> 'Збереження'\n\nЩоб завантажити ПЕРЕЗАПУСТІТЬ гру, і тикніть ТАК.";
waitUntil {!dialog};

if (!isNil "loadLastSave" && {!loadLastSave}) then {
	_nul=createDialog "diff_menu";
	waitUntil {dialog};
	hint "Choose a difficulty level";
	waitUntil {!dialog};

	[] spawn {
		waitUntil {(!isNil "serverInitDone")};			// need following params to be initialized
		if (isNil "skillMult") exitWith {};
		if (skillMult == 1) then
			{
			//Easy Difficulty Tweaks
			server setVariable ["hr",25,true];
			server setVariable ["resourcesFIA",5000,true];
			vehInGarage = [vehSDKTruck,vehSDKTruck,SDKMortar,SDKMGStatic,staticAAteamPlayer];
			minWeaps = 15;
			if !(hasTFAR) then
				{
				["ItemRadio"] call A3A_fnc_unlockEquipment;
				haveRadio = true;
				};
			};
		if (skillMult == 3) then 
			{
			//Hard Difficulty Tweaks
			server setVariable ["hr",0,true];
			server setVariable ["resourcesFIA",200,true];
			minWeaps = 40;
			};
		[] call A3A_fnc_statistics;
		};
	_nul= createDialog "gameMode_menu";
	waitUntil {dialog};
	hint "Choose a Game Mode";
	waitUntil {!dialog};
};

