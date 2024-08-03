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
        core:Print("List of Slash Commands:")
        core:Print("|cFF008080/rg config|r - shows config menu");
        core:Print("|cFF008080/rg help|r - shows help info");
        print(" ")
    end,

    ["example"] = {
        ["test"] = function (...)
            core:Print("My Value:", tostringall(...));
        end
    }
}

local function HandleSlashCommands(str)	
	if (#str == 0) then	
		-- User just entered "/at" with no additional args.
		core.commands.help();
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

function core:Print(...)
    local hex = select(4, self.Config.GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "ReadyGear:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, tostringall(...)))
end
--------------------------------------------

function core:init(event, name)
    if (name ~= "ReadyGear") then return end

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

    core:Print("Welcome back to ReadyGear,", UnitName("player").."!", "Use /rg to get started!");

end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);