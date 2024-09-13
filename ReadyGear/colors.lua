--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Colors = {}; -- adds Display table to addon namespace

local Colors = core.Colors;

--------------------------------------
--- Colors
--------------------------------------

Colors.Theme = {
    red = "FFADAD",
    orange = "FFD6A5",
    yellow = "FDFFB6",
    green = "CAFFBF",
    cyan = "9BF6FF",
    blue = "A0C4FF",
    purple = "BDB2FF",
    pink = "FFC6FF",
    gray = "71716F"
}

Colors.FormatStrings = {
    red = "|cFF"..Colors.Theme.red.."%s|r",
    orange = "|cFF"..Colors.Theme.orange.."%s|r",
    yellow = "|cFF"..Colors.Theme.yellow.."%s|r",
    green = "|cFF"..Colors.Theme.green.."%s|r",
    cyan = "|cFF"..Colors.Theme.cyan.."%s|r",
    blue = "|cFF"..Colors.Theme.blue.."%s|r",
    purple = "|cFF"..Colors.Theme.purple.."%s|r",
    pink = "|cFF"..Colors.Theme.pink.."%s|r",
    gray = "|cFF"..Colors.Theme.gray.."%s|r"
}

Colors.Armor = {
    broken = Colors.Theme.red,
    critical = Colors.Theme.yellow
}

Colors.Stats = {
    stamina = Colors.FormatStrings.purple,
    strength = Colors.FormatStrings.red,
    intellect = Colors.FormatStrings.cyan,
    agility = Colors.FormatStrings.yellow,
    versatility = Colors.FormatStrings.pink,
    haste = Colors.FormatStrings.orange,
    crit = Colors.FormatStrings.green,
    mastery = Colors.FormatStrings.blue
}