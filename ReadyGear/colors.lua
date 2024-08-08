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
}

Colors.FormatStrings = {
    red = "|cFF"..Colors.Theme.red.."%s",
    orange = "|cFF"..Colors.Theme.orange.."%s",
    yellow = "|cFF"..Colors.Theme.yellow.."%s",
    green = "|cFF"..Colors.Theme.green.."%s",
    cyan = "|cFF"..Colors.Theme.cyan.."%s",
    blue = "|cFF"..Colors.Theme.blue.."%s",
    purple = "|cFF"..Colors.Theme.purple.."%s",
    pink = "|cFF"..Colors.Theme.pink.."%s"
}

Colors.Armor = {
    broken = Colors.Theme.red,
    critical = Colors.Theme.yellow
}

Colors.Stats = {
    stamina = Colors.Theme.purple,
    strength = Colors.Theme.red,
    intellect = Colors.Theme.cyan,
    agility = Colors.Theme.yellow,
    versatility = Colors.Theme.pink,
    haste = Colors.Theme.orange,
    crit = Colors.Theme.green,
    mastery = Colors.Theme.blue
}