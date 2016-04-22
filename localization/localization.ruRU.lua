
if ( GetLocale() ~= "ruRU" ) then
  return ;
end
print("Localization ruRU")

_L = {};

_L["Drektar"		] = "Дрек'Тар"
_L["Vandar"			] = "Вандар Грозовая Вершина"
_L["UnderAttack"	] = "Атакован"

_L["Alliance"	] = "Альянс"
_L["Horde"	] = "Орда"

_L["IoCAlliance"	] = "Альянса"
_L["IoCHorde"	] = "Орды"

_L.Marks = { [ "skull" ] = "{rt8}",
			 [ "circle" ] = "{rt2}",
			 [ "diamond" ] = "{rt3}", -- ромб
			 [ "moon" ] = "{rt5}", -- Луна
			 [ "triangle" ] = "{rt4}", -- Зелёный треугольник
			 [ "square" ] = "{rt6}", -- Синий квадрат
			};
-- English локаль
--[[BG_STAT_COLUMN = { [ "Bases Assaulted"       ] = "Base Assaulted",
                      [ "Bases Defended"        ] = "Base Defended",
                      [ "Demolishers Destroyed" ] = "Demolisher Destroyed",
                      [ "Flag Captures"         ] = "Flag Captured",
                      [ "Flag Returns"          ] = "Flag Returned",
                      [ "Gates Destroyed"       ] = "Gate Destroyed",
                      [ "Graveyards Assaulted"  ] = "Graveyard Assaulted",
                      [ "Graveyards Defended"   ] = "Graveyard Defended",
                      [ "Towers Assaulted"      ] = "Tower Assaulted",
                      [ "Towers Defended"       ] = "Tower Defended",
} ;]]--

-- Русская локаль         
--_L.BaseStates =	{ [ "База атакована"        ] = "База атакована",
--                  [ "База защищена"         ] = "База защищена",
--                  [ "Разрушитель уничтожен" ] = "Разрушитель уничтожен",
--                  [ "Флаг захвачен"         ] = "Флаг захвачен",
--                  [ "Флаг возвращен"        ] = "Флаг возвращен",
--                  [ "Врат разрушены"        ] = "Врата разрушены",
--                  [ "Кладбище атаковано"    ] = "Кладбище атаковано",
--                  [ "Кладбище защищено"     ] = "Кладбище защищено",
--                  [ "Башня атакованы"       ] = "Башня атакована",
--                  [ "Башня защищена"        ] = "Башня защищена",
--                } ;

_L.BaseStates =	{ 
				  -- IoC
				  [ "Баз атаковано"        ] = _L.Marks["square"],
                  [ "Баз защищено"         ] = _L.Marks["square"],
				  -- AV
				  [ "Штурмы кладбищ"    ] = _L.Marks["diamond"],
                  [ "Оборона кладбищ"   ] = _L.Marks["diamond"],
                  [ "Оборона башен"     ] = _L.Marks["square"],
                  [ "Штурмы башен"      ] = _L.Marks["square"],
                } ;

-- Class talent specs
local DK    = { ["Кровь"]              = "Tank",
                ["Лед"]                = "Melee",
                ["Нечестивость"]       = "Melee",
              } ;
local DRUID = { ["Баланс"]             = "Knockback",
                ["Сила зверя"]         = "Melee",
                ["Исцеление"]          = "Healer",
                ["Страж"]              = "Tank",
              } ;
local HUNTER = {
                ["Повелитель зверей"]  = "Knockback",
                ["Стрельба"]           = "Ranged",
                ["Выживание"]          = "Ranged",
               } ;
local MAGE = {  ["Тайная магия"]       = "Knockback",
                ["Огонь"]              = "Ranged",
                ["Лед"]                = "Ranged",
             } ; 
local MONK = {  ["Хмелевар"]           = "Tank",
                ["Ткач туманов"]       = "Healer",
                ["Танцующий с ветром"] = "Melee",
             } ; 
local PALADIN = { ["Свет"]             = "Healer",
                  ["Защита"]           = "Tank",
                  ["Воздаяние"]        = "Melee",
                } ; 
local PRIEST = { ["Послушание"]        = "Healer",
                 ["Свет"]              = "Healer",
                 ["Тьма"]              = "Ranged",
               } ; 
local ROGUE = { ["Ликвидация"]         = "Melee",
                ["Бой"]                = "Melee",
                ["Скрытность"]         = "Melee",
              } ; 
local SHAMAN = { ["Стихии"]            = "Knockback",
                 ["Совершенствование"] = "Melee",
                 ["Исцеление"]         = "Healer",
               } ; 
local WARLOCK = { ["Колдовство"]       = "Knockback",
                  ["Демонология"]      = "Knockback",
                  ["Разрушение"]       = "Knockback",
                } ; 
local WARRIOR = { ["Оружие"]           = "Melee",
                  ["Неистовство"]      = "Melee",
                  ["Защита"]           = "Tank",
                } ; 

_L.BgRoles = {}
_L.BgRoles["DEATHKNIGHT" ] = DK ;
_L.BgRoles["DRUID"       ] = DRUID ;
_L.BgRoles["HUNTER"      ] = HUNTER ;
_L.BgRoles["MAGE"        ] = MAGE ;
_L.BgRoles["MONK"        ] = MONK ;
_L.BgRoles["PALADIN"     ] = PALADIN ;
_L.BgRoles["PRIEST"      ] = PRIEST ;
_L.BgRoles["ROGUE"       ] = ROGUE ;
_L.BgRoles["SHAMAN"      ] = SHAMAN ;
_L.BgRoles["WARLOCK"     ] = WARLOCK ;
_L.BgRoles["WARRIOR"     ] = WARRIOR ;

