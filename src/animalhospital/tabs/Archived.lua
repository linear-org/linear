-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

local Maid = Linear.Utils.Maid
local Visualizer = Linear.Utils.Visualizer
local Values = Linear.Values

-- Getting services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Getting variables 
local NPCs = Workspace.NPCs
local LocalPlayer = Players.LocalPlayer

-- Building the tab
Linear.Tabs.Archived = Window:Tab({
    Title = "Archived",
    Icon = "gravity:archive",
    Border = true,
})

Linear.Tabs.Archived:Paragraph({
	Title = "What is this?",
	Desc = "Seems like you clicked the button that loads this tab. When a feature gets patched, they get moved into this tab. This is so we can add those features back if they start working ever again, and it's also fun to see what the script offered you in the past I guess.",
})

Linear.Tabs.Archived:Divider()

Linear.Tabs.Archived:Toggle({
    Title = "Fire Immunity",
    Desc = "Prevents fire damage for you.\n(Archival Information): (07/14/26) “It was patched within the ‘Dr. Harlow's Favorite’ update.”",
    Callback = function(state)
        if state then
            local connections = {}          
            table.insert(connections, Linear.FireNowAndOnChildAdded(Workspace, function(child)
                local targets = child and {child} or Workspace:GetChildren()              
                for fart, target in ipairs(targets) do
                    local roomname = target.Name
                    local doubleroom = target:FindFirstChild(roomname)
                    if doubleroom then
                        local fire = doubleroom:FindFirstChild("Fire")
                        if fire then
                            for fart, firechild in ipairs(fire:GetChildren()) do
                                local transmitter = firechild:FindFirstChildWhichIsA("TouchTransmitter")
                                if transmitter then
                                    transmitter:Destroy()
                                end
                            end
                        end
                    end
                end
            end))           
            Maid.FireImmunity = connections
        else
            if Maid.FireImmunity then
                for fart, connection in ipairs(Maid.FireImmunity) do
                    connection:Disconnect()
                end
                Maid.FireImmunity = nil
            end
        end
    end
})

Linear.Tabs.Archived:Toggle({
    Title = "Infinite Sanity",
    Desc = "Keeps your sanity at 100%.\n(Archival Information): (06/29/26) “The developers got onto it and patched it, this still works visually.”",
    Callback = function(state)
        if state then
            Maid.Sanity = Linear.FireNowAndOnAttributeChanged(LocalPlayer, "Sanity", function()
                local sanity = LocalPlayer:GetAttribute("Sanity") or 100
                if sanity ~= 100 then
                    local value = -(100 - sanity)
                    Linear.Remotes.Sanity:FireServer(value, "_LINEAR", true)
                end
            end)
        else
            Maid.Sanity = nil
        end
    end
})
