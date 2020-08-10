private ["_typeX","_textX"];

_typeX = typeOf player;
_textX = "";
switch (_typeX) do
	{
	//case "I_C_Soldier_Para_7_F": {player setUnitTrait ["UAVHacker",true]}; //opted as we use units which automatically have the trait - 8th January 2020, Bob Murphy
	//case "I_C_Soldier_Para_8_F": {player setUnitTrait ["engineer",true]; player setUnitTrait ["explosiveSpecialist",true]}; //opted as we use units which automatically have the trait - 8th January 2020, Bob Murphy
	//case "I_C_Soldier_Para_3_F": {player setUnitTrait ["medic",true]}; //opted as we use units which automatically have the trait - 8th January 2020, Bob Murphy
	case typePetros: {player setUnitTrait ["UAVHacker",true]};
	//cases for greenfor missions
	case "I_G_medic_F":  {_textX = "Медик.\n\nМедики не мають якигось бонусів чи штрафів,\n зато, як можна здогадатись з назви, вони вміють лікувати."};
	case "I_G_Soldier_TL_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Командир.\n\nЦе ті породження пекла, які вміють усе. \nМають трохи краще маскування."};
	case "I_G_Soldier_F":  {player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.2]; _textX = "Стрілець.\n\nСтрільці вміють добре крастись, але можуть носити менше."};
	case "I_G_Soldier_GL_F": {player setUnitTrait ["camouflageCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Гренадер.\n\nГренадери можуть напхати собі в кишені значно більше всякого барахла. \nАле іх легше помітити."};
	case "I_G_Soldier_AR_F": {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Кулеметник.\n\nКулеметники можуть напхати собі в кишені значно більше всякого барахла. \nАле то барахло буде так гриміти, що ворог вас почує за кілометр."};
	case "I_G_engineer_F":  {_textX = "Інженер.\n\nІнженери не мають якигось бонусів чи штрафів, \nале вони зато вміють відрізняти болта від гайки.\nМожуть змусити навіть відро з гайками їздити і стріляти."};
	//cases for blufor missions - added - 8th January 2020, Bob Murphy
	case "B_G_medic_F":  {_textX = "Медик.\n\nМедики не мають якигось бонусів чи штрафів,\n зато, як можна здогадатись з назви, вони вміють лікувати."};
	case "B_G_Soldier_TL_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Командир.\n\nЦе ті породження пекла, які вміють усе. \nМають трохи краще маскування."};
	case "B_G_Soldier_F":  {player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.2]; _textX = "Стрілець.\n\nСтрільці вміють добре крастись, але можуть носити менше."};
	case "B_G_Soldier_GL_F": {player setUnitTrait ["camouflageCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Гренадер.\n\nГренадери можуть напхати собі в кишені значно більше всякого барахла. \nАле іх легше помітити."};
	case "B_G_Soldier_AR_F": {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Кулеметник.\n\nКулеметники можуть напхати собі в кишені значно більше всякого барахла. \nАле то барахло буде так гриміти, що ворог вас почує за кілометр."};
	case "B_G_engineer_F":  {_textX = "Інженер.\n\nІнженери не мають якигось бонусів чи штрафів, \nале вони зато вміють відрізняти болта від гайки.\nМожуть змусити навіть відро з гайками їздити і стріляти."}; //added - 8th January 2020, Bob Murphy
	//cases for pvp green - added - 9th January 2020, Bob Murphy
	case "I_medic_F":  {_textX = "Медик.\n\nМедики не мають якигось бонусів чи штрафів,\n зато, як можна здогадатись з назви, вони вміють лікувати."};
	case "I_Soldier_TL_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Командир.\n\nЦе ті породження пекла, які вміють усе. \nМають трохи краще маскування."};
	case "I_Soldier_M_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Влучний стрілець.\n\nМарксмени добре крадуться, але можуть менше носити."};
	case "I_Soldier_AR_F": {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Кулеметник.\n\nКулеметники можуть напхати собі в кишені значно більше всякого барахла. \nАле то барахло буде так гриміти, що ворог вас почує за кілометр."};
	case "I_Soldier_LAT_F":  {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Стрілець ПТ.\n\nМожуть більше носити.\nАле то барахло в рюкзаку буде так гриміти, що ворог вас почує за кілометр."};
	//cases for pvp blue - added - 9th January 2020, Bob Murphy
	case "B_recon_medic_F":  {_textX = "Медик.\n\nМедики не мають якигось бонусів чи штрафів,\n зато, як можна здогадатись з назви, вони вміють лікувати."};
	case "B_recon_TL_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Командир.\n\nЦе ті породження пекла, які вміють усе. \nМають трохи краще маскування."};
	case "B_recon_M_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Влучний стрілець.\n\nМарксмени добре крадуться, але можуть менше носити."};
	case "B_Patrol_Soldier_MG_F": {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Кулеметник.\n\nКулеметники можуть напхати собі в кишені значно більше всякого барахла. \nАле то барахло буде так гриміти, що ворог вас почує за кілометр."};
	case "B_recon_LAT_F":  {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Antitank role.\n\nAntitanks have a slight bonus on carry capacity, but make too much noise when they move"};
	//cases for pvp red - added - 9th January 2020, Bob Murphy
	case "O_T_Recon_Medic_F":  {_textX = "Медик.\n\nМедики не мають якигось бонусів чи штрафів,\n зато, як можна здогадатись з назви, вони вміють лікувати."};
	case "O_T_Recon_TL_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Командир.\n\nЦе ті породження пекла, які вміють усе. \nМають трохи краще маскування."};
	case "O_T_Recon_M_F": {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _textX = "Влучний стрілець.\n\nМарксмени добре крадуться, але можуть менше носити."};
	case "O_Soldier_AR_F": {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Кулеметник.\n\nКулеметники можуть напхати собі в кишені значно більше всякого барахла. \nАле то барахло буде так гриміти, що ворог вас почує за кілометр."};
	case "O_T_Recon_LAT_F":  {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _textX = "Стрілець ПТ.\n\nМожуть більше носити.\nАле то барахло в рюкзаку буде так гриміти, що ворог вас почує за кілометр."};
	};

if (isMultiPlayer) then
	{
	sleep 5;
	hint format ["Тепер ви %1",_textX];
	};
