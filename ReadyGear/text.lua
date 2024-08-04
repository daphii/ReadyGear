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

Text.ReadMe = "World of Warcraft addon which checks gear readiness for raid. Simple UI, with set filters. Current scope is your character's gear. Future scope is to include other players in your party and raid group.\
\
The addon will check and warn/tattle:\
\
- Enchants\
- Gems\
- Durablility\
- Missing gear";

Text.Author = "Created by daphii in 2024."

Text.GearMissingWarning = "No %s item equipped!";


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

Text.CommandsList = {
    "Available commands:",
    "|cFFBAD9D0/rg|r - toggles the main window",
    "|cFFBAD9D0/rg config|r - toggles the config window",
    "|cFFBAD9D0/rg help|r - shows the help window"
}

Text.ChangeLog = "0.1.0\
- Started conversion from tutorial addon to planned addon.\
- Added config, about, and changelog tabs to the config window.\
- Moved all text strings to a separate file.\
- Added unit gear scanning to Tools.\
- Added ItemLink parsing to Tools."