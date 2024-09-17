--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Colors = {}; -- adds Display table to addon namespace

local Colors = core.Colors;

--------------------------------------
--- Colors
--------------------------------------

Theme = {
    -- Display Window
    red = "FFADAD",
    orange = "FFD6A5",
    yellow = "FDFFB6",
    green = "CAFFBF",
    cyan = "9BF6FF",
    blue = "A0C4FF",
    purple = "BDB2FF",
    pink = "FFC6FF",
    gray = "71716F",

    -- Chat Box
	ivory = "F2ECD8",
	coral = "F08080"
}

Messages = {
    highlight = Theme.ivory,
    text = Theme.gray,
    error = Theme.red,
    warning = Theme.yellow,
    success = Theme.green,
}

Stats = {
    stamina = Theme.purple,
    strength = Theme.red,
    intellect = Theme.cyan,
    agility = Theme.yellow,
    versatility = Theme.pink,
    haste = Theme.orange,
    crit = Theme.green,
    mastery = Theme.blue,
    primary = Theme.ivory
}

Armor = {
    ok = Theme.gray,
    critical = Theme.yellow,
    broken = Theme.red
}

function Colors:GetThemeColor(name)
    return "|cFF"..Theme[name].."%s|r";
end

function Colors:GetStatColor(name)
    return "|cFF"..Stats[name].."%s|r";
end

function Colors:GetArmorColor(name)
    return "|cFF"..Armor[name].."%s|r";
end

function Colors:GetMessageColor(name)
    return "|cFF"..Messages[name].."%s|r";
end