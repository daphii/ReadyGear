--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Text = {}; -- adds Strings table to addon namespace
local Text = core.Text;

--------------------------------------
--- Strings
--------------------------------------

Text.AddonName = "ReadyGear";

Text.WelcomeMessage = "Welcome back to ReadyGear, %s! Use /rg to get started!";

Text.PersonalGearDisplayTitle = "%s's Gear";

Text.ReadMe = "World of Warcraft addon which checks gear readiness for raid. Simple UI, with set filters. Current scope is your character\'s gear. Future scope is to include other players in your party / raid group.\
\
The addon will check and warn/tattle:\
- Enchants\
- Gems\
- Durability\
- Missing gear\
\
Built off of the tutorial from Mayron @ https://www.youtube.com/@MayronDev";

Text.Author = "Created by daphii in 2024."

Text.GearMissingWarning = "No %s item equipped!";

Text.EnchantMissingMessage = "Missing Enchant!";
Text.NotEnchantableMessage = "Not Enchantable.";
Text.EnchantIssueMessage = "Enchant Issue!";
Text.EnchantsReadyMessage = "Enchants Ready.";

Text.GemMissingMessage = "Missing Gem!";
Text.NoGemSlotMessage = "No Gem Slot.";
Text.GemIssueMessage = "Gem Issue!";
Text.GemsReadyMessage = "Gems Ready.";
Text.AddNerGemMessage = "*Add Socket with Nerubian Gemweaver.";
Text.AddMagGemMessage = "*Add Socket with Magnificent Jeweler's Setting.";

--------------------------------------
--- Tables
--------------------------------------

Text.GearSlotNamesByID = {
    "Head",
    "Neck",
    "Shoulder",
    "Shirt",
    "Chest",
    "Belt",
    "Legs",
    "Feet",
    "Wrist",
    "Gloves",
    "Finger 1",
    "Finger 2",
    "Trinket 1",
    "Trinket 2",
    "Cloak",
    "Main Hand",
    "Off Hand"
}

Text.QualityIcons = {
    Explorer = "   ",
    Adventurer = "|A:Professions-ChatIcon-Quality-Tier1:20:20:0:0|a",
    Veteran = "|A:Professions-ChatIcon-Quality-Tier2:20:20:0:0|a",
    Champion = "|A:Professions-ChatIcon-Quality-Tier3:20:20:0:0|a",
    Hero = "|A:Professions-ChatIcon-Quality-Tier4:20:20:0:0|a",
    Myth = "|A:Professions-ChatIcon-Quality-Tier5:20:20:0:0|a"
}

Text.CommandsList = {
    "Available commands:",
    "|cFFBAD9D0/rg|r - toggles the main window",
    "|cFFBAD9D0/rg config|r - toggles the config window",
    "|cFFBAD9D0/rg help|r - shows the help window"
}

Text.ChangeLog = "\
0.1.3\
- Added support for Magnificent Jeweler's Setting.\
\
0.1.3\
- Display will now open when joining a group.\
- Average item level will now update when changing gear.\
- Display window will update when changing gear, enchanting or socketing.\
- Added Durability display.\
- Added Upgrade display, using crafting quality icons to indicate tracks.\
- Added slot name display for easier reference.\
\
0.1.2\
- Frames now close with escape key.\
- Added new colour scheme to the personal gear display.\
- Added new stat colours.\
- Added support for socketable items via Nerubian Gemweaver.\
- Reworked gem display.\
- Changed \'Not Enchantable\' and \'No Gem Slot\' messages to gray.\
- Fixed Bug causing gems to be marked ready when missing a gem!\
\
0.1.1\
- Removed the old tutorial code.\
- Removed dummy config buttons.\
- Added personal gear display, use /rg\
- Personal gear display refreshes when you open the window.\
- Added average item level to the personal gear display.\
- Added summary messages to the personal gear display.\
- fixed overlapping windows.\
\
0.1.0\
- Started conversion from tutorial addon to planned addon.\
- Added config, about, and changelog tabs to the config window.\
- Moved all text strings to a separate file.\
- Added unit gear scanning to Tools.\
- Added ItemLink parsing to Tools.\
- Windows are now movable.\
"