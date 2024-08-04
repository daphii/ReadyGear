--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

--------------------------------------
-- Defaults (usually a database!)
--------------------------------------
Config.Defaults = {
	theme = {
		r = 0, 
		g = 0.8, -- 204/255
		b = 1,
		hex = "F08080"
	},

	colors = {
		white = "F2F2F2",
		ivory = "F2ECD8",
		coral = "F08080",
		pink = "F2BBBB",
		green = "BAD9D0",

	}
}

--------------------------------------
-- Config functions
--------------------------------------
function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu();
	menu:SetShown(not menu:IsShown());
end

function Config:GetThemeColor()
	local c = Config.Defaults.theme;
	return c.r, c.g, c.b, c.hex;
end

function DEBUG_FRAME_SIZE(frame)
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetColorTexture(0, 0, 0, 0.6)
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
	local btn = CreateFrame("Button", nil, relativeFrame, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
	btn:SetSize(140, 40);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	return btn;
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

local function Tab_OnClick(self)
	PanelTemplates_SetTab(self:GetParent(), self:GetID());
	
	local scrollChild = UIConfig.ScrollFrame:GetScrollChild();
	if (scrollChild) then
		scrollChild:Hide();
	end
	
	UIConfig.ScrollFrame:SetScrollChild(self.content);
	self.content:Show();	
end

local function SetTabs(frame, tabNames)
    frame.numTabs = #tabNames;
    
    -- Initialize an empty table to hold the content frames
    local contents = {};
    local frameName = frame:GetName();
    
    -- for each tab name, Create a tab button attached to the parent frame, Set Name/ID, Assign OnClick.
    for i = 1, frame.numTabs do
        -- 
        local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabTemplate");
        tab:SetID(i);
        tab:SetText(tabNames[i]);
        tab:SetScript("OnClick", Tab_OnClick);
        
        -- Create a content frame attached to the tab, set size and hide.
        tab.content = CreateFrame("Frame", nil, UIConfig.ScrollFrame);
        tab.content:SetSize(308, 500);
        tab.content:Hide();
        
        --[[ -- Add a random background color to the content frame for demonstration
        tab.content.bg = tab.content:CreateTexture(nil, "BACKGROUND");
        tab.content.bg:SetAllPoints(true);
        tab.content.bg:SetColorTexture(math.random(), math.random(), math.random(), 0.6); ]]
        
        -- Insert the content frame into the contents table
        table.insert(contents, tab.content);
        
        -- Position the tab relative to the previous tab or the parent frame
        if (i == 1) then
            tab:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 7);
        else
            tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", 0, 0);
        end
	end
	
	-- Sets the first tab to be visible
	Tab_OnClick(_G[frameName.."Tab1"]);
	
	return unpack(contents);
end


function Config:CreateMenu()
	UIConfig = CreateFrame("Frame", "ReadyGearConfig", UIParent, "UIPanelDialogTemplate");
	UIConfig:SetSize(350, 400);
	UIConfig:SetPoint("CENTER"); -- Doesn't need to be ("CENTER", UIParent, "CENTER")

	UIConfig:SetMovable(true)
    UIConfig:EnableMouse(true)
    UIConfig:RegisterForDrag("LeftButton")
    UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
    UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)
	
    UIConfig.Title:ClearAllPoints();
	UIConfig.Title:SetFontObject("GameFontHighlight");
	UIConfig.Title:SetPoint("LEFT", ReadyGearConfigTitleBG, "LEFT", 6, 1);
	UIConfig.Title:SetText("Ready Gear Config");
	
	UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate");
	UIConfig.ScrollFrame:SetPoint("TOPLEFT", ReadyGearConfigDialogBG, "TOPLEFT", 4, -8);
	UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", ReadyGearConfigDialogBG, "BOTTOMRIGHT", -3, 4);
	UIConfig.ScrollFrame:SetClipsChildren(true);
	UIConfig.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
	
	UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
    UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18);
    UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18);
	
	local configuration, about, changelog = SetTabs(UIConfig, {"Configuration", "About", "Changelog"});
	
	
	----------------------------------
	-- Configuration
	----------------------------------

	-- Save Button:
	configuration.saveBtn = self:CreateButton("CENTER", configuration, "TOP", -70, "Save");

	-- Reset Button:	
	configuration.resetBtn = self:CreateButton("TOP", configuration.saveBtn, "BOTTOM", -10, "Reset");

	-- Load Button:	
	configuration.loadBtn = self:CreateButton("TOP", configuration.resetBtn, "BOTTOM", -10, "Load");

	-- Slider 1:
	configuration.slider1 = CreateFrame("SLIDER", nil, configuration, "OptionsSliderTemplate");
	configuration.slider1:SetPoint("TOP", configuration.loadBtn, "BOTTOM", 0, -20);
	configuration.slider1:SetMinMaxValues(1, 100);
	configuration.slider1:SetValue(50);
	configuration.slider1:SetValueStep(30);
	configuration.slider1:SetObeyStepOnDrag(true);

	-- Slider 2:
	configuration.slider2 = CreateFrame("SLIDER", nil, configuration, "OptionsSliderTemplate");
	configuration.slider2:SetPoint("TOP", configuration.slider1, "BOTTOM", 0, -20);
	configuration.slider2:SetMinMaxValues(1, 100);
	configuration.slider2:SetValue(40);
	configuration.slider2:SetValueStep(30);
	configuration.slider2:SetObeyStepOnDrag(true);

	-- Check Button 1:
	configuration.checkBtn1 = CreateFrame("CheckButton", nil, configuration, "UICheckButtonTemplate");
	configuration.checkBtn1:SetPoint("TOPLEFT", configuration.slider1, "BOTTOMLEFT", -10, -40);
	configuration.checkBtn1.text:SetText("My Check Button!");

	-- Check Button 2:
	configuration.checkBtn2 = CreateFrame("CheckButton", nil, configuration, "UICheckButtonTemplate");
	configuration.checkBtn2:SetPoint("TOPLEFT", configuration.checkBtn1, "BOTTOMLEFT", 0, -10);
	configuration.checkBtn2.text:SetText("Another Check Button!");
	configuration.checkBtn2:SetChecked(true);

	----------------------------------
	-- About
	----------------------------------
	
	about.readme = CreateFrame("Frame", nil, about)
	about.readme:SetSize(280, 200)  -- Set the size of the frame
	about.readme:SetPoint("TOPLEFT", 10, -10)  -- Position the frame within the parent frame

	-- DEBUG_FRAME_SIZE(about.readme);
    
    -- Create a FontString for the paragraph text
    about.readme.text = about.readme:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    about.readme.text:SetPoint("TOPLEFT", 10, -10)  -- Position the text within the frame
    about.readme.text:SetWidth(280)  -- Set the width of the text area
    about.readme.text:SetJustifyH("LEFT")  -- Align text to the left
    about.readme.text:SetText(core.Text.ReadMe)  -- Set the text of the FontString

	about.author = CreateFrame("Frame", nil, about)
	about.author:SetSize(280, 50)
	about.author:SetPoint("TOPLEFT", about.readme, "BOTTOMLEFT", 0, -10)

	-- DEBUG_FRAME_SIZE(about.author);

	about.author.text = about.author:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	about.author.text:SetPoint("TOPLEFT", 10, -10)
	about.author.text:SetWidth(280)
	about.author.text:SetJustifyH("LEFT")
	about.author.text:SetText(core.Text.Author)

	----------------------------------
	-- Change Log
	----------------------------------
	
	changelog.text = CreateFrame("Frame", nil, changelog)
	changelog.text:SetSize(280, 200)
	changelog.text:SetPoint("TOPLEFT", 10, -10)

	-- DEBUG_FRAME_SIZE(changelog.text);

	changelog.text.text = changelog.text:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	changelog.text.text:SetPoint("TOPLEFT", 10, -10)
	changelog.text.text:SetWidth(280)
	changelog.text.text:SetJustifyH("LEFT")
	changelog.text.text:SetText(core.Text.ChangeLog)
	
	UIConfig:Hide();
	return UIConfig;
end

