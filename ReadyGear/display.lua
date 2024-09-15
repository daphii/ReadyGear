--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Display = {}; -- adds Display table to addon namespace

local Display = core.Display;
local ReadyGearDisplay;

--------------------------------------
-- References
--------------------------------------

local frameHeight = 450;
local frameWidth = 800;

local gearOrder = { 1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17 }


--------------------------------------
--- Display Functions
--------------------------------------
function Display:Toggle()
    local display = ReadyGearDisplay;
    if display:IsShown() then
        display:Hide();
    else
        Display:GenerateAndFillPersonalGearData();
        display:Show();
    end
end

function DEBUG_FRAME_SIZE(frame)
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetColorTexture(0, 0, 0, 0.6)
end

local function SetupPersonalGearDisplayPanels()
    ReadyGearDisplay.PersonalGearDisplay.ailvl = ReadyGearDisplay.PersonalGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.PersonalGearDisplay.ailvl:SetPoint("TOPLEFT", ReadyGearDisplay.PersonalGearDisplay, "TOPLEFT", 3, 0);
    ReadyGearDisplay.PersonalGearDisplay.ailvl:SetText("999");

    ReadyGearDisplay.PersonalGearDisplay.playerName = ReadyGearDisplay.PersonalGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.PersonalGearDisplay.playerName:SetPoint("TOPLEFT", ReadyGearDisplay.PersonalGearDisplay, "TOPLEFT", 40, 0);
    ReadyGearDisplay.PersonalGearDisplay.playerName:SetText(string.format(core.Text.PersonalGearDisplayTitle, UnitName("player")));

    ReadyGearDisplay.PersonalGearDisplay.enchantHeader = ReadyGearDisplay.PersonalGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.PersonalGearDisplay.enchantHeader:SetPoint("TOPRIGHT", ReadyGearDisplay.PersonalGearDisplay, "TOPRIGHT", 50, 0);
    ReadyGearDisplay.PersonalGearDisplay.enchantHeader:SetText("Enchants");

    ReadyGearDisplay.PersonalGearDisplay.gemHeader = ReadyGearDisplay.PersonalGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.PersonalGearDisplay.gemHeader:SetPoint("TOPLEFT", ReadyGearDisplay.PersonalGearDisplay.enchantHeader, "TOPRIGHT", 10, 0);
    ReadyGearDisplay.PersonalGearDisplay.gemHeader:SetText("Gems");

    for i = 1, #gearOrder do
        local gearFrame = CreateFrame("Frame", "Slot"..gearOrder[i], ReadyGearDisplay.PersonalGearDisplay);
        gearFrame:SetSize(frameWidth - 45, 20);
        gearFrame:SetPoint("TOPLEFT", 0, (-22 * (i - 1)) - 22);

            gearFrame.ilvl = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.ilvl:SetPoint("LEFT", gearFrame, "LEFT", 3, 0);

            gearFrame.link = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.link:SetPoint("LEFT", gearFrame, "LEFT", 40, 0);

            gearFrame.enchant = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.enchant:SetPoint("RIGHT", gearFrame, "RIGHT", -250, 0);

            gearFrame.gem = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.gem:SetPoint("LEFT", gearFrame.enchant, "RIGHT", 10, 0);

        ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]] = gearFrame;
    end
end

function Display:GenerateAndFillPersonalGearData()
    local unit = "player";
    local enchantIssues = false;
    local gemIssues = false;
    local armor = core.Tools:GetEquippedArmor(unit);

    for i = 1, #gearOrder do

        if (armor[gearOrder[i]] ~= nil) then
            local enchant, gem, ilvl = core.Tools:GetGearComments(armor[gearOrder[i]].link, unit, gearOrder[i]);

            if string.find(enchant, "Missing") then
                enchantIssues = true
            end
            
            if string.find(gem, "Missing") then
                gemIssues = true
            end

            ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]].ilvl:SetText(ilvl);

            ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]].link:SetText(armor[gearOrder[i]].link);

            ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]].enchant:SetText(enchant);

            ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]].gem:SetText(gem);
        else
            ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]].link:SetText(string.format(core.Text.GearSlotNamesByID[gearOrder[i]], core.Text.GearMissingWarning));
            ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]].link:SetTextColor(0.929, 0.373, 0.373, 1);
        end

    end

    if enchantIssues then
        ReadyGearDisplay.PersonalGearDisplay.enchantHeader:SetText(string.format(core.Colors.FormatStrings.red, core.Text.EnchantIssueMessage));
    else
        ReadyGearDisplay.PersonalGearDisplay.enchantHeader:SetText(string.format(core.Colors.FormatStrings.green,  core.Text.EnchantsReadyMessage));
    end

    if gemIssues then
        ReadyGearDisplay.PersonalGearDisplay.gemHeader:SetText(string.format(core.Colors.FormatStrings.red, core.Text.GemIssueMessage));
    else
        ReadyGearDisplay.PersonalGearDisplay.gemHeader:SetText(string.format(core.Colors.FormatStrings.green, core.Text.GemsReadyMessage));
    end

    ReadyGearDisplay.PersonalGearDisplay.ailvl:SetText(string.format("%d", math.floor(core.Tools:GetAverageIlvl(unit))));
    ReadyGearDisplay.title:SetText(core.Text.AddonName.." Personal Display - "..UnitName("player"));
end

function Display:CreateDisplay()
    ReadyGearDisplay = CreateFrame("Frame", "ReadyGearDisplay", UIParent, "BasicFrameTemplateWithInset");
    
    _G[ReadyGearDisplay:GetName()] = ReadyGearDisplay;
    tinsert(UISpecialFrames, ReadyGearDisplay:GetName());

    ReadyGearDisplay.events = CreateFrame("Frame");
    local events = ReadyGearDisplay.events;

    function events:GROUP_JOINED(...)
        if not ReadyGearDisplay:IsShown() then
            Display:GenerateAndFillPersonalGearData();
            ReadyGearDisplay:Show();
        end
    end

    function events:COMBAT_RATING_UPDATE(...)
        if ReadyGearDisplay:IsShown() then
            Display:GenerateAndFillPersonalGearData();
        end
    end

    ReadyGearDisplay:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...); -- call one of the functions above
    end);

    for k, _ in pairs(events) do
        if k ~= 0 then
            ReadyGearDisplay:RegisterEvent(k); -- Register all events for which handlers have been defined
        end
    end

    ReadyGearDisplay:SetSize(frameWidth, frameHeight);
    ReadyGearDisplay:SetPoint("CENTER");

    ReadyGearDisplay:SetMovable(true);
    ReadyGearDisplay:EnableMouse(true);
    ReadyGearDisplay:RegisterForDrag("LeftButton");
    ReadyGearDisplay:SetScript("OnDragStart", ReadyGearDisplay.StartMoving);
    ReadyGearDisplay:SetScript("OnDragStop", ReadyGearDisplay.StopMovingOrSizing);

    ReadyGearDisplay.title = ReadyGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.title:SetPoint("CENTER", ReadyGearDisplay.TitleBg, "CENTER", 0, 0);
    ReadyGearDisplay.title:SetText(core.Text.AddonName.." Display");
    ReadyGearDisplay.title:SetFontObject("GameFontHighlight");
    ReadyGearDisplay.title:SetTextColor(1, 1, 1, 1);

    ReadyGearDisplay.PersonalGearDisplay = CreateFrame("Frame", "PersonalGearDisplay", ReadyGearDisplay);
    ReadyGearDisplay.PersonalGearDisplay:SetSize(455, 435);
    ReadyGearDisplay.PersonalGearDisplay:SetPoint("TOPLEFT", 20, -50)

    -- DEBUG_FRAME_SIZE(ReadyGearDisplay.PersonalGearDisplay);

    SetupPersonalGearDisplayPanels();
    self:GenerateAndFillPersonalGearData();


    ReadyGearDisplay:Hide();


    return ReadyGearDisplay;
end

ReadyGearDisplay = Display:CreateDisplay();