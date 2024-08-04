------------------------------
--- Namespaces
------------------------------
local _, core = ...;
core.Tools = {};

local Tools = core.Tools;

-- will set order for GetEquippedArmor return value
local EquipmentSlotNames = {
    "HeadSlot",
    "Neckslot",
    "ShoulderSlot",
    "BackSlot",
    "ChestSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "MainHandSlot",
    "SecondaryHandSlot"
}

-- Print info to chat when the addon is loaded.

--print('Ready Gear 0.1 Loaded.');
--print("Character Name: " .. UnitName("player"));
--print("Character Level: " .. UnitLevel("player"));

function HyperLinkReader(itemLink)
    local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(itemLink,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    local t = {
        link = itemLink,
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

-- Return a table which contains a label as a keys, and a subtable with all the link info as values.
function Tools:GetEquippedArmor(unit)
    local Armor = {};
    for i = 1, 19 do
        local itemLink = GetInventoryItemLink(unit, i);
        if itemLink then
            local infoTable = HyperLinkReader(itemLink);
            Armor[i] = infoTable;
            print("Added infoTable to slot", i);
        else
            Armor[i] = nil;
            print("Adding nil to slot", i);
        end
    end
    return Armor;
end

-- GetEquippedArmor("player");

local PlayerArmor = Tools:GetEquippedArmor("player");

for i = 1, 19 do
    print("EquipmentSlot:", i)
    if (PlayerArmor[i] ~= nil) then
        for subKey, SubValue in pairs(PlayerArmor[i]) do
            print(subKey..": "..SubValue);
        end
    else
        print("No Item Equipped.")
    end
    print("\n");
end

function Tools:DEBUG_FRAME_SIZE(frame)
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetColorTexture(0, 0, 0, 0.6)
end




