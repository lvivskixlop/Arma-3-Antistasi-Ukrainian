class Params
{
     class loadSave
     {
          title = "Завантажити попереднє збереження";
          values[] = {1,0};
          texts[] = {"Та","Ні"};
          default = 1;
     };
     class gameMode
     {
          title = "Game Mode";
          values[] = {1,2,3,4};
          texts[] = {"Reb vs Gov vs Inv(не то)","Reb vs Gov & Inv(і не ото)","Reb vs Gov(і навіть не то)","Reb vs Inv(треба ось це)"};
          default = 1;
     };
     class autoSave
     {
          title = "Щогодинне автозбереження";
          values[] = {1,0};
          texts[] = {"Та","Ні"};
          default = 1;
     };
     class membership
     {
          title = "Ввімкнути 'членів сервера'";
          texts[] = {"Та","Ні"};
          values[] = {1,0};
          default = 0;
     };
     class switchComm
     {
          title = "Ввімкнути командира? Щоб якись один гравець всім командував.";
          values[] = {1,0};
          texts[] = {"Та","Ні"};
          default = 1;
     };
     class tkPunish
     {
          title = "Покарання за френдлі фаєр";
          values[] = {1,0};
          texts[] = {"Та","Ні"};
          default = 0;
     };
     class mRadius
     {
          title = "Дистанція від штабу до місій";
          values[] = {2000,4000,6000,8000,10000,12000};
          default = 6000;
     };
     class allowPvP
     {
          title = "ПВП слоти";
          values[] = {1,0};
          texts[] = {"Та","Ні"};
          default = 0;
     };
     class pMarkers
     {
          title = "Маркери гравців";
          values[] = {1,0};
          texts[] = {"Та","Ні"};
          default = 0;
     };
     class AISkill
     {
          title = "Складність";
          values[] = {1,2,3};
          texts[] = {"Для слабаків","Середньо","Складно"};
          default = 3;
     };
     class unlockItem
     {
          title = "Кількість зброї в арсеналі, щоб та стала безкінечною.";
          values[] = {15,25,40};
          default = 25;
     };
     class memberOnlyMagLimit
     {
          title = "Обмеження кількості магазинів для гостей сервера.";
          values[] = {10,20,30,40,50,60};
          default = 40;
     };
     class civTraffic
     {
          title = "Трафік цивільних";
          values[] = {0,1,2,3};
          texts[] = {"Нема","Малий","Середній","Ліпше не треба"};
          default = 1;
     };
     class memberSlots
     {
          title = "Вісоток слотів, зарезервованих для членів сервера";
          values[] = {0,20,40,60,80,100};
          texts[] = {"Нема","20%","40%","60%","80%","Всі"};
          default = 20;
     };
     class memberDistance
     {
          title = "Максимальна відстань, на яку можуть відходити гості сервера від штабу чи членів сервера. Якщо відійдуть задалеко, то їх телепортує до штабу";
          values[] = {4000,5000,6000,7000,8000,16000};
          texts[] = {"4 км","5 км","6 км","7 км","8 км","Безмежна"};
          default = 16000;
     };
	 class allowMembersFactionGarageAccess
     {
          title = "Дати членам сервера доступ до спільного гаража.";
          texts[] = {"Та","Ні"};
          values[] = {1,0};
          default = 1;
     };
     class allowFT
     {
          title = "Ввімкнути телепорт";
          values[] = {0,1};
          texts[] = {"Ні","Та"};
          default = 1;
     };
     class napalmEnabled
     {
          title = "Бомбардування напалмом";
          values[] = {0,1};
          texts[] = {"Ні","Та"};
          default = 0;
     };
     class teamSwitchDelay
     {
          title = "Затримка перед тим, як гравець зможе долучитись до іншої групи.";
          values[] = {0, 900, 1800, 3600};
          texts[] = {"Нема","15 хв","30 хв","60 хв"};
          default = 0;
     };
     class unlockedUnlimitedAmmo
     {
          title = "Робити безкінечні набої до безкінечної зброї?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class allowGuidedLaunchers
     {
          title = "Дозволити безкінечні ПТУР-и?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class allowUnlockedExplosives
     {
          title = "Дозволити безкінечну вибухівку?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class startWithLongRangeRadio
     {
          title = "[TFAR] Стартувати з ДХ?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Spacer10
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class Kart
     {
          title = "Karts DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Mark
     {
          title = "Marksman DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Heli
     {
          title = "Heli DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Expansion
     {
          title = "Apex DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Jets
     {
          title = "Jets DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Orange
     {
          title = "Laws of War DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Tanks
     {
          title = "Tanks DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class GlobMob
     {
          title = "Global Mobilization DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Enoch
     {
          title = "Contact DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class OfficialMod
     {
          title = "ADR-97 DLC?";
          values[] = {1,0};
          texts[] =  {"Та","Ні"};
          default = 0;
     };
     class Spacer0
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class AdvancedParams
     {
          title = "Тільки для супер мудрих";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
	 class LogLevel
	 {
		  title = "Logging Level (Amount of detail in .rpt file)";
		  values[] = {1,2,3};
		  texts[] = {"Error", "Info", "Debug"};
		  default = 3;
	 };
     class CrateOptions
     {
          title = "Коробки з лутом";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
	 class truelyRandomCrates
	 {
		  title = "[Experimental] Справжній рандом в коробках: забрати будь-який баланс. Сам хз, що то таке, най буде як є";
		  values[] = {0, 1};
		  texts[] = {"False", "True"};
		  default = 0;
	 };
	 class cratePlayerScaling
	 {
		title = "Зменшувати кількість луту, коли є більше гравців? (Кажуть, що ліпше та)";
		values[] = {0, 1};
		texts[] = {"False", "True"};
		default = 1;
	 };
     class crateWepTypeMax
     {
          title = "Максимальна кількість типів зброї.";
          values[] = {0,2,4,6,8,12,16};
          texts[] = {"1","3","5","7","9","13","17"};
          default = 2;
     };
     class crateWepNumMax
     {
          title = "Максимальна кількість типів зброї.";
          values[] = {0,1,3,5,8,10,15};
          texts[] = {"None","1","3","5","8","10","15"};
          default = 3;
     };
     class Spacer1
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateItemTypeMax
     {
          title = "Максимальна кількість видів предметів";
          values[] = {0,2,4,9};
          texts[] = {"1","3","5","10"};
          default = 2;
     };
     class crateItemNumMax
     {
          title = "Максимальна кількість самих предметів";
          values[] = {0,1,3,5,10,15};
          texts[] = {"None","1","3","5","10","15"};
          default = 3;
     };
     class Spacer2
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateAmmoTypeMax
     {
          title = "Максимальна кількість типів набоїв";
          values[] = {0,2,4,6,9,14,19};
          texts[] = {"1","3","5","7","10","15","20"};
          default = 4;
     };
     class crateAmmoNumMax
     {
          title = "Максимальна кількість самих набоїв";
          values[] = {0,1,3,5,10,15,20,25,30};
          texts[] = {"None","1","3","5","10","15","20","25","30"};
          default = 20;
     };
     class Spacer3
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateExplosiveTypeMax
     {
          title = "Максимальна кількість типів вибухівки";
          values[] = {0,2,4,9};
          texts[] = {"1","3","5","10"};
          default = 2;
     };
     class crateExplosiveNumMax
     {
          title = "Максимальна кількість вибухівки";
          values[] = {0,1,3,5,10,15};
          texts[] = {"None","1","3","5","10","15"};
          default = 3;
     };
     class Spacer4
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateAttachmentTypeMax
     {
          title = "Максимальна кількість примочок до зброї";
          values[] = {0,2,4,6,9,12,15,19};
          texts[] = {"1","3","5","7","10","13","16","20"};
          default = 4;
     };
     class crateAttachmentNumMax
     {
          title = "Максимальна кількість їх самих";
          values[] = {0,1,3,5,7,10,15,20,30};
          texts[] = {"None","1","3","5","7","10","15","20","30"};
          default = 3;
     };
     class Spacer5
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateBackpackTypeMax
     {
          title = "Максимальна кількість типів рюкзаків";
          values[] = {0,2,4,9};
          texts[] = {"1","3","5","10"};
          default = 0;
     };
     class crateBackpackNumMax
     {
          title = "Максимальна кількість їх самих";
          values[] = {0,1,3,5,10,15};
          texts[] = {"None","1","3","5","10","15"};
          default = 3;
     };
     class Spacer6
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateVestTypeMax
     {
          title = "Максимальна кількість типів жилетів";
          values[] = {0,2,4,9};
          texts[] = {"1","3","5","10"};
          default = 0;
     };
     class crateVestNumMax
     {
          title = "Максимальна кількість жилетів";
          values[] = {0,1,3,5,10,15};
          texts[] = {"None","1","3","5","10","15"};
          default = 0;
     };
     class Spacer7
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateHelmetTypeMax
     {
          title = "Максимальна кількість типів шоломів";
          values[] = {0,2,4,9};
          texts[] = {"1","3","5","10"};
          default = 0;
     };
     class crateHelmetNumMax
     {
          title = "Максимальна кількість шоломів";
          values[] = {0,1,3,5,10,15};
          texts[] = {"None","1","3","5","10","15"};
          default = 0;
     };
     class Spacer8
     {
          title = "";
          values[] = {""};
          texts[] = {""};
          default = "";
     };
     class crateDeviceTypeMax
     {
          title = "Максимальна кількість типів рюкзакових девайсів (дрони, міномети, кулемети,...)";
          values[] = {0,2,4,9};
          texts[] = {"1","3","5","10"};
          default = 0;
     };
     class crateDeviceNumMax
     {
          title = "Максимальна кількість їх самих";
          values[] = {0,1,3,5,10,15};
          texts[] = {"None","1","3","5","10","15"};
          default = 1;
     };
};
