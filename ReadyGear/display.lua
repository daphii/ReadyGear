--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Display = {}; -- adds Display table to addon namespace

local Display = core.Display;
local ReadyGearDisplay;

--------------------------------------
-- Namespaces
--------------------------------------

local gearOrder = { 1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17 }

--------------------------------------
--- Display Functions
--------------------------------------
function Display:Toggle()
   local display = ReadyGearDisplay or Display:CreateDisplay();
    display:SetShown(not display:IsShown());
end

function DEBUG_FRAME_SIZE(frame)
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetColorTexture(0, 0, 0, 0.6)
end

local function DrawPersonalGearDisplay()

    local unit = "player";

    ReadyGearDisplay.PersonalGearDisplay.title = ReadyGearDisplay.PersonalGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.PersonalGearDisplay.title:SetPoint("TOPLEFT", ReadyGearDisplay.TitleBg, "TOPLEFT", 20, -40);
    ReadyGearDisplay.PersonalGearDisplay.title:SetText(string.format(core.Text.PersonalGearDisplayTitle, UnitName("player")));
    ReadyGearDisplay.PersonalGearDisplay.title:SetFontObject("GameFontHighlight");
    ReadyGearDisplay.PersonalGearDisplay.title:SetTextColor(1, 1, 1, 1);
    
    local armor = core.Tools:GetEquippedArmor(unit);
    
    for i = 1, #gearOrder do
        local gearFrame = CreateFrame("Frame", "Slot"..gearOrder[i], ReadyGearDisplay.PersonalGearDisplay);
        gearFrame:SetSize(455, 20);
        gearFrame:SetPoint("TOPLEFT", 0, (-22 * (i - 1)) - 22);
        -- DEBUG_FRAME_SIZE(gearFrame);

        if (armor[gearOrder[i]] ~= nil) then
            -- print("Armor Slot:", gearOrder[i], armor[gearOrder[i]].link);
            gearFrame.link = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.link:SetPoint("LEFT", gearFrame, "LEFT", 3, 0);
            gearFrame.link:SetText(armor[gearOrder[i]].link);

            gearFrame.comment = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.comment:SetPoint("RIGHT", gearFrame, "RIGHT", -3, 0);
            gearFrame.comment:SetText(core.Tools:GetGearComment(armor[gearOrder[i]].link, unit, gearOrder[i]));
        else
            gearFrame.link = gearFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            gearFrame.link:SetPoint("LEFT", gearFrame, "LEFT", 3, 0);
            gearFrame.link:SetText("No "..core.Text.GearSlotNamesByID[gearOrder[i]].." Equipped!");
            gearFrame.link:SetTextColor(0.929, 0.373, 0.373, 1);
        end



        ReadyGearDisplay.PersonalGearDisplay[gearOrder[i]] = gearFrame;

        -- print("EquipmentSlot:", gearOrder[i])
        -- if (armor[gearOrder[i]] ~= nil) then
        --     for subKey, SubValue in pairs(armor[gearOrder[i]]) do
        --         print(subKey..": "..SubValue);
        --     end
        -- end
        -- print("\n");
        
    end

end

function Display:CreateDisplay()
    ReadyGearDisplay = CreateFrame("Frame", "ReadyGearDisplay", UIParent, "BasicFrameTemplateWithInset");
    ReadyGearDisplay:SetSize(500, 500);
    ReadyGearDisplay:SetPoint("CENTER");

    ReadyGearDisplay:SetMovable(true)
    ReadyGearDisplay:EnableMouse(true)
    ReadyGearDisplay:RegisterForDrag("LeftButton")
    ReadyGearDisplay:SetScript("OnDragStart", ReadyGearDisplay.StartMoving)
    ReadyGearDisplay:SetScript("OnDragStop", ReadyGearDisplay.StopMovingOrSizing)

    ReadyGearDisplay.title = ReadyGearDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    ReadyGearDisplay.title:SetPoint("CENTER", ReadyGearDisplay.TitleBg, "CENTER", 0, 0);
    ReadyGearDisplay.title:SetText(core.Text.AddonName.." Display");
    ReadyGearDisplay.title:SetFontObject("GameFontHighlight");
    ReadyGearDisplay.title:SetTextColor(1, 1, 1, 1);

    ReadyGearDisplay.PersonalGearDisplay = CreateFrame("Frame", "PersonalGearDisplay", ReadyGearDisplay);
    ReadyGearDisplay.PersonalGearDisplay:SetSize(455, 435);
    ReadyGearDisplay.PersonalGearDisplay:SetPoint("TOPLEFT", 20, -40)

    -- DEBUG_FRAME_SIZE(ReadyGearDisplay.PersonalGearDisplay);

    DrawPersonalGearDisplay();



    ReadyGearDisplay:Hide();


    return ReadyGearDisplay;
end


