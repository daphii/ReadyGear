--[[ 
    Will allow us to create timers to track buff and debuff durations.
    Timers can be set to icon or timer bar mode.
--]]

------------------------------
--- Namespaces
------------------------------
local _, core = ...;
core.Timer = {};

local Timer = core.Timer;

------------------------------
--- Timer Functions
------------------------------
--[[ 
    Should return an instance of a time (using metatables).
    A static function.
-- ]]
function Timer:Create()

end

--[[ 
    Should update the timer using events
-- ]]
function Timer:Update()

end

--[[ 
    Destroy the timer after it has expired (recycle it).
--]]
function Timer:Destroy()

end