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

Text.ReadMe = "World of Warcraft addon which checks gear readiness for raid. Simple UI, with set filters. Current scope is your character's gear. Future scope is to include other players in your party and raid group.\
\
The addon will check and warn/tattle:\
\
- Enchants\
- Gems\
- Durablility\
- Missing gear";

Text.Author = "Created by daphii in 2024."

Text.ChangeLog = "0.1.0\
- Started conversion from tutorial addon to planned addon.\
- Added config, about, and changelog tabs to the config window.\
- Moved all text strings to a separate file.\
- Added unit gear scanning to Tools.\
- Added ItemLink parsing to Tools."

--------------------------------------
--- Tables
--------------------------------------

-- will set order for GetEquippedArmor return value
Text.EquipmentSlotNames = {
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