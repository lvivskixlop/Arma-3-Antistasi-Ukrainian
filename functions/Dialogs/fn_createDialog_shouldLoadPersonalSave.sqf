_nul=createDialog "should_load_personal_save";

waitUntil {dialog};
hint "У В А Г А!\n\nПРОЧИТАЙ!!!\n\n\nАнтастазі НЕ підтримує ванільного збереження. Воно не буде 100% працювати, якщо ви натиснете Зберегти і вийти, а потім Продовжити. Це стосується як самітньої гри, так і мультиплеєра.\n\n\nВ Антістазі є своя вбудована система збережень, яка працює як має бути.\n\nЩоб зберегти, підійдіть до карти штабу, виберіть 'Опції гри' -> 'Збереження'\n\nЩоб завантажити ПЕРЕЗАПУСТІТЬ гру, і тикніть ТАК.";
waitUntil {!dialog};

[] spawn A3A_fnc_credits;
diag_log "[Antistasi] Saving is now possible.";
player setVariable ['canSave', true, true];