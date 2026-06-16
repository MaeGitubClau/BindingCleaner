-- BindingCleaner
-- Removes all SHIFT/ALT/CTRL bindings except Action Bars 1-8

-- Action bar command prefixes to protect (bars 1-8)
local PROTECTED = {
    "ACTIONBUTTON",        -- Bar 1
    "MULTIACTIONBAR3BUTTON", -- Bar 2
    "MULTIACTIONBAR4BUTTON", -- Bar 3
    "MULTIACTIONBAR2BUTTON", -- Bar 4
    "MULTIACTIONBAR1BUTTON", -- Bar 5
    "MULTIACTIONBAR5BUTTON", -- Bar 6
    "MULTIACTIONBAR6BUTTON", -- Bar 7
    "MULTIACTIONBAR7BUTTON", -- Bar 8
}

local function IsProtectedAction(action)
    for _, prefix in ipairs(PROTECTED) do
        if action:find("^" .. prefix) then
            return true
        end
    end
    return false
end

local function IsModifierKey(key)
    return key:find("^SHIFT%-") or key:find("^ALT%-") or key:find("^CTRL%-")
end

local function CleanBindings()
    local removed = 0
    local numBindings = GetNumBindings()

    for i = 1, numBindings do
        local action, key1, key2 = GetBinding(i)
        if action and not IsProtectedAction(action) then
            for _, key in ipairs({ key1, key2 }) do
                if key and IsModifierKey(key) then
                    SetBinding(key)
                    removed = removed + 1
                end
            end
        end
    end

    SaveBindings(GetCurrentBindingSet())
    print(string.format("|cff00ff00BindingCleaner:|r Done. Removed %d modifier binding(s). Action Bars 1-8 untouched.", removed))
end

local function PrintHelp()
    print("|cff00ff00BindingCleaner:|r /bc run  — remove all SHIFT/ALT/CTRL bindings except Action Bars 1-8")
    print("|cff00ff00BindingCleaner:|r /bc help  — show this message")
end

SLASH_BINDINGCLEANER1 = "/bc"
SlashCmdList["BINDINGCLEANER"] = function(msg)
    msg = msg and msg:lower():trim() or ""
    if msg == "run" then
        CleanBindings()
    else
        PrintHelp()
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    print("|cff00ff00BindingCleaner:|r Loaded. Type |cffffff00/bc run|r to clean modifier bindings.")
end)
