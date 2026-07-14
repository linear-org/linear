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
Linear.Tabs.Fun = Window:Tab({
    Title = "Fun",
    Icon = "gravity:face-smile",
    Border = true,
})

-- Creating the annoying groupbox
Linear.Sections.Trolls = Linear.Tabs.Fun:Section({
    Title = "Trolls",
    Icon = "gravity:eyes-look-right",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

Linear.Elements.PlayLoudSound = Linear.Sections.Trolls:Button({
    Title = "Play Loud Sound",
    Desc = "Plays a very loud laughing sound that everybody can hear.",
    Callback = function()
        local doll = workspace:FindFirstChild("BrokenBabyDoll", true)
        if doll then
            Linear.Elements.PlayLoudSound:Lock()
            local prompt = doll:FindFirstChild("ProximityPrompt")
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")            
            if root and prompt then
                local oldposition = root.CFrame
                root.CFrame = doll.CFrame
                while prompt.Enabled  do
                    fireproximityprompt(prompt)
                    task.wait()
                end             
                root.CFrame = oldposition              
            end
        end
    end
})

Linear.Sections.Trolls:Toggle({
    Title = "Spam Clanking Noises",
    Desc = "Spams clanking noises that everybody can hear.",
    Callback = function(state)
        if state then
            Maid.SpamClanking = RunService.Heartbeat:Connect(function()
                Linear.Remotes.HeartbeatMinigameComplete:FireServer(Linear.Rooms.Room7, true)
            end)
        else
                Maid.SpamClanking = nil
        end
    end
})

-- if everything checks out, informs that the fun tab is done
Linear:Print("Fun tab loaded.")