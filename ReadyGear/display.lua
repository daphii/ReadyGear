--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Display = {}; -- adds Display table to addon namespace

local Display = core.Display;
local ReadyGearDisplay;


--------------------------------------
--- Display Functions
--------------------------------------
function Display:Toggle()
   local display = ReadyGearDisplay or Display:CreateDisplay();
    display:SetShown(not display:IsShown());
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
    
    ReadyGearDisplay:Hide();
    return ReadyGearDisplay;
end