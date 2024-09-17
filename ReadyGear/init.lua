------------------------------
--- Namespaces
------------------------------
local _, core = ...;

------------------------------
--- Custom Slash Commands
------------------------------
core.commands = {
    ["config"] = core.Config.Toggle, -- note the use of . to point to the function, but not call it.

    ["help"] = function () -- lists available commands.
        print(" ");
        for i,v in ipairs(core.Text.CommandsList) do
            core:Print(v);
        end
        print(" ")
    end
}

local function HandleSlashCommands(str)	
	if (#str == 0) then
		-- User just entered "/rg" with no additional args.
		core.Display:Toggle();
		return;
	end

	local args = {};
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end
	
	local path = core.commands; -- required for updating found table.
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- if string length is greater than 0.
			arg = arg:lower();			
			if (path[arg]) then
				if (type(path[arg]) == "function") then				
					-- all remaining args passed to our function!
                    ---@diagnostic disable-next-line: deprecated
					path[arg](select(id + 1, unpack(args)));
					return;					
				elseif (type(path[arg]) == "table") then				
					path = path[arg]; -- another sub-table found!
				end
			else
				-- does not exist!
				core.commands.help();
				return;
			end
		end
	end
end
--------------------------------------------

function core:init(event, name)
    if (name ~= core.Text.AddonName) then return end

    -- to be able to use left and right arrows in the edit box
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
    end

    ------------------------------
    --- Register Commands
    ------------------------------

    SLASH_RELOADUI1 = "/rl" -- For quicker reloading
    SlashCmdList.RELOADUI = ReloadUI

    SLASH_FRAMESTK1 = "/fs" -- For faster framestack access
    SlashCmdList.FRAMESTK = function()
    ---@diagnostic disable-next-line: deprecated
        LoadAddOn("Blizzard_DebugTools")
        FrameStackTooltip_Toggle()
    end

    SLASH_ReadyGear1 = "/rg"
    SlashCmdList.ReadyGear = HandleSlashCommands;

    core:Print(string.format(core.Text.WelcomeMessage, UnitName("player")) )

end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);