------------------------------
--- Namespaces
------------------------------
local _, core = ...;
core.Tools = {};

local Tools = core.Tools;

-- Print info to chat when the addon is loaded.

--print('Ready Gear 0.1 Loaded.');
--print("Character Name: " .. UnitName("player"));
--print("Character Level: " .. UnitLevel("player"));

function HyperLinkReader(itemLink)
    local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    local t = {
        color = Color,
        linkType = Ltype,
        id = Id,
        enchant = Enchant,
        gem1 = Gem1,
        gem2 = Gem2,
        gem3 = Gem3,
        gem4 = Gem4,
        suffix = Suffix,
        unique = Unique,
        linkLevel = LinkLvl,
        name = Name
    }
    return t;
end

local function GetEquippedArmor(unit)
    for i = 1, 19 do
        local itemLink = GetInventoryItemLink(unit, i);
        if itemLink then
            print(itemLink);
            local infoTable = HyperLinkReader(itemLink);
            for key, value in pairs(infoTable) do
                if value ~= "" then
                    print(key, value);
                end
            end
        end
    end
end

-- GetEquippedArmor("player");




