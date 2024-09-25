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

-- slots that can be enchanted
local enchantableSlots = {5,7,8,9,11,12,15,16}

-- slots that you can add a socket to with Nerubian Gemweaver.
local socketableSlots = {1,6,9}

-- slots that you can add a socket to with Magnificent Jeweler's Setting
local magnificentSocketableSlots = {2,11,12}

-- string signatures for gems
local gemSignatures = {
    -- Empty Socket
    "Prismatic Socket",
    -- Pure Stat
    "+141 ",
    "+159 ",
    "+176 ",
    -- Hybrid Stat
    "+118 ",
    "+132 ",
    "+147 ",
    "+175 ",
    "+190 ",
    "+205 ",
    -- Stamina
    "+225 ",
    "+250 ",
    "+275 ",
    -- Diamond
    "+136 ",
    "+159 ",
    "+181 ",
}

local statAbbreviations = {
    ["Stamina"] = string.format(core.Colors:GetStatColor("stamina"), "STA"),
    ["Strength"] = string.format(core.Colors:GetStatColor("strength"), "STR"),
    ["Intellect"] = string.format(core.Colors:GetStatColor("intellect"), "INT"),
    ["Agility"] = string.format(core.Colors:GetStatColor("agility"), "AGI"),
    ["Versatility"] = string.format(core.Colors:GetStatColor("versatility"), "VRS"),
    ["Haste"] = string.format(core.Colors:GetStatColor("haste"), "HST"),
    ["Critical Strike"] = string.format(core.Colors:GetStatColor("crit"), "CRT"),
    ["Mastery"] = string.format(core.Colors:GetStatColor("mastery"), "MST"),
    ["Primary Stat"] = string.format(core.Colors:GetStatColor("primary"), "PRM")
}

local gemAbbreviations = {
    ["Critical Effect per unique Algari gem color"] = "CRTE",
    ["Movement Speed per unique Algari gem color"] = "MVMT",
    ["Maximum Mana per unique Algari gem color"] = "MANA",
    ["opponent's failed interrupt attempts grant Precognition"] = "PRCG",
    ["Damage Reduction when affected by Crowd Control"] = "CCDR",
    ["getting snared increases damage of your next attack by 25578 per stack"] = "SNRD"
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

function core:Print(...)
    local prefix = string.format(core.Colors:GetThemeColor("coral"), core.Text.AddonName..":");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, tostringall(...)))
end

function Tools:DEBUG_FRAME_SIZE(frame)
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetColorTexture(0, 0, 0, 0.6)
end

-- Return a table which contains a label as a keys, and a subtable with all the link info as values.
function Tools:GetEquippedArmor(unit)
    local Armor = {};
    for i = 1, 19 do
        local itemLink = GetInventoryItemLink(unit, i);
        if itemLink then
            local infoTable = HyperLinkReader(itemLink);
            Armor[i] = infoTable;
            --print("Added infoTable to slot", i);
        else
            Armor[i] = nil;
            --print("Adding nil to slot", i);
        end
    end
    return Armor;
end

function Tools:GetGearComments(itemLink, unit, slotID)
    local enchantComment = "";
    local gemComment = "";
    local ilvlComment = "";
    local upgradeTrack = "";
    local durabilityComment = "";

    if ItemIsEnchantable(slotID) then
        local enchant = self:GetEnchantComment(unit, slotID);
        if enchant then
            enchantComment = enchant;
        else
            enchantComment = string.format(core.Colors:GetMessageColor("error"), core.Text.EnchantMissingMessage);
        end
    else
        enchantComment = string.format(core.Colors:GetMessageColor("text"), core.Text.NotEnchantableMessage);
    end

    local gem = self:GetGemComment(unit, slotID);
    if gem == gemSignatures[1] then
        gemComment = string.format(core.Colors:GetMessageColor("error"), core.Text.GemMissingMessage);
    elseif not gem then
        if ItemIsSocketable(slotID) then
            gemComment = string.format(core.Colors:GetMessageColor("text"), core.Text.AddNerGemMessage);
        elseif ItemIsMagnificentSocketable(slotID) then
            gemComment = string.format(core.Colors:GetMessageColor("text"), core.Text.AddMagGemMessage);
        else
            gemComment = string.format(core.Colors:GetMessageColor("text"), core.Text.NoGemSlotMessage);
        end
        
    else
        gemComment = gem;
    end

    ilvlComment = self:GetIlvlComments(unit, slotID);

    upgradeTrack = Tools:GetUpgradeTrackIcon(unit, slotID);
    durabilityComment = Tools:GetDurabilityComment(unit, slotID); -- use slotID to get durability

    return enchantComment, gemComment, ilvlComment, upgradeTrack, durabilityComment;
end


function Tools:GetGemComment(unit, slotID)
    local data = C_TooltipInfo.GetInventoryItem(unit, slotID)
    local gems = {}
    for i = 1, #data.lines do
        local leftText = data.lines[i].leftText
        for _, signature in ipairs(gemSignatures) do
            if string.find(leftText, signature) then
                table.insert(gems, leftText)
            end
        end
    end
    
    local gemComment = ""
    
    if #gems > 0 then
        for i = 1, #gems do
            gemComment = gemComment..FormatGemForComment(gems[i]);
        end
    else
        return nil;
    end
    
    return gemComment;
end

function FormatGemForComment(gem)
    local formattedGemComment = gem
    
    
    
    -- Iterate over statAbbreviations and replace matches
    for key, value in pairs(statAbbreviations) do
        formattedGemComment = string.gsub(formattedGemComment, key, value)
    end
    
    -- Remove the "and"
    formattedGemComment = string.gsub(formattedGemComment, "and ", "/")
    
    -- Iterate over gemAbbreviations and replace matches
    for key, value in pairs(gemAbbreviations) do
        formattedGemComment = string.gsub(formattedGemComment, key, value)
    end
    
    -- Find the substring that starts with |A and ends with |a (Quality Icon)
    local qualityIcon = string.match(formattedGemComment, "|A.-|a")
    --print(string.gsub(qualityIcon, "|", "||"))
    
    if qualityIcon then
        -- Remove the qualityIcon from its original position
        formattedGemComment = string.gsub(formattedGemComment, "|A.-|a", "")
        
        -- Move the qualityIcon to the start of the string
        formattedGemComment = qualityIcon .. formattedGemComment
    end
    
    -- Remove Numbers
    formattedGemComment = string.gsub(formattedGemComment, "%+%S+", "")
    
    --local printable = gsub(formattedGemComment, "\124", "\124\124");
    --print(printable);
    
    return formattedGemComment;
end

function Tools:GetAverageIlvl(unit)
    local totalIlvl = 0;
    local equippedArmor = self:GetEquippedArmor(unit);
    for i = 1, 19 do
        if equippedArmor[i] then
            local data = C_TooltipInfo.GetHyperlink(equippedArmor[i].link);
            for j = 1, #data.lines do
                local leftText = data.lines[j].leftText
                local startPos, endPos = string.find(leftText, "Item Level ")
                if startPos then
                    local restOfLine = string.sub(leftText, endPos + 1)
                    if i == 16 then
                        if equippedArmor[17] then
                            totalIlvl = totalIlvl + tonumber(restOfLine);
                        else
                            totalIlvl = totalIlvl + (tonumber(restOfLine) * 2);
                        end
                    else
                        totalIlvl = totalIlvl + tonumber(restOfLine);
                    end
                end
            end
        end
    end
--[[     local totalPieces = 15; -- no offhand
    if equippedArmor[17] then
        totalPieces = 16; -- including offhand
    end ]]

    return totalIlvl / 16;
    
end

function Tools:GetIlvlComments(unit, slotID)
    local data = C_TooltipInfo.GetInventoryItem(unit, slotID)
    for i = 1, #data.lines do
        local leftText = data.lines[i].leftText
        local startPos, endPos = string.find(leftText, "Item Level ")
        if startPos then
            local restOfLine = string.sub(leftText, endPos + 1)
            return restOfLine
        end
    end
end

function Tools:GetEnchantComment(unit, slotID)
    local data = C_TooltipInfo.GetInventoryItem(unit, slotID)
    for i = 1, #data.lines do
        local leftText = data.lines[i].leftText
        local startPos, endPos = string.find(leftText, "Enchanted:")
        if startPos then
            local restOfLine = string.sub(leftText, endPos + 1)
            return restOfLine
        end
    end
end

function Tools:GetUpgradeTrackIcon(unit, slotID)
    local data = C_TooltipInfo.GetInventoryItem(unit, slotID)
    if not data or not data.lines then
        return ""
    end

    for i = 1, #data.lines do
        local leftText = data.lines[i].leftText
        if leftText then
            local startPos, endPos = string.find(leftText, "Upgrade Level: ")
            if startPos and endPos then
                local upgradeLevel = string.sub(leftText, endPos + 1)
                for key, value in pairs(core.Text.QualityIcons) do
                    upgradeLevel = string.gsub(upgradeLevel, key, value)
                end
                --core.Print(upgradeLevel)
                return upgradeLevel
            end
        end
    end
    --core.Print("No Upgrade Track Icon")
    return ""
end

function Tools:GetDurabilityComment(unit, slotID)
    local data = C_TooltipInfo.GetInventoryItem(unit, slotID)
    if not data or not data.lines then
        core:Print("No tooltip data found for unit: " .. tostring(unit) .. ", slotID: " .. tostring(slotID))
        return ""
    end

    local durability = "    "
    for i = 1, #data.lines do
        local leftText = data.lines[i].leftText
        if leftText then
            local startPos, endPos = string.find(leftText, "Durability ")
            if startPos then
                local restOfLine = string.sub(leftText, endPos + 1)
                local currentDurability, maxDurability = string.match(restOfLine, "(%d+) / (%d+)")
                if currentDurability and maxDurability then
                    currentDurability = tonumber(currentDurability)
                    maxDurability = tonumber(maxDurability)
                    local durabilityPercentage = math.floor((currentDurability / maxDurability) * 100)

                    if durabilityPercentage == 0 then
                        durability = string.format(core.Colors:GetArmorColor("broken"), durabilityPercentage .. "%")
                    elseif durabilityPercentage < 20 then
                        durability = string.format(core.Colors:GetArmorColor("critical"), durabilityPercentage .. "%")
                    else
                        durability = string.format(core.Colors:GetArmorColor("ok"), durabilityPercentage .. "%")
                    end
                else
                    core:Print("Failed to parse durability values from: " .. restOfLine)
                end
            end
        end
    end

    --core:Print(durability)
    return durability
end

function ItemIsEnchantable(slotID)
    for i = 1, #enchantableSlots do
        if slotID == enchantableSlots[i] then
            return true;
        end
    end
    return false;
end

function ItemIsSocketable(slotID)
    for i = 1, #socketableSlots do
        if slotID == socketableSlots[i] then
            return true;
        end
    end
    return false;
end

function ItemIsMagnificentSocketable(slotID)
    for i = 1, #magnificentSocketableSlots do
        if slotID == magnificentSocketableSlots[i] then
            return true;
        end
    end
    return false;
end

-- GetEquippedArmor("player");

--[[ local PlayerArmor = Tools:GetEquippedArmor("player");

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
end ]]


