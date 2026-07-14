-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

local Maid = Linear.Utils.Maid
local Values = Linear.Values

-- Building the tab
Linear.Tabs.Settings = Window:Tab({
    Title = "Settings",
    Icon = "gravity:gear",
    Border = true,
})

-- Creating the other groupbox
Linear.Sections.Other = Linear.Tabs.Settings:Section({
    Title = "Other",
    Icon = "gravity:ellipsis",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

Linear.Elements.LoadArchives = Linear.Sections.Other:Button({
    Title = "LINEAR_LOAD_ARCHIVES",
    Callback = function()
        Linear.Elements.LoadArchives:Lock()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/animalhospital/tabs/Archived.lua"))()
    end
})

Linear.Tabs.Settings:Divider()

for i = 1, 25 do
    Linear.Tabs.Settings:Button({
        Title = "WYN_ANTI_TAMPER",
        Callback = function()
            LocalPlayer:Kick("WYN_TAMPER_DETECTED")
        end
    })
end


-- if everything checks out, informs that the player tab is done
Linear:Print("Settings tab loaded.")