-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

local Maid = Linear.Utils.Maid
local Visualizer = Linear.Utils.Visualizer
local Values = Linear.Values
local Elements = Linear.Elements

-- Getting services
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Getting variables 
local NPCs = Workspace.NPCs
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer.Backpack

-- Building the tab
Linear.Tabs.Player = Window:Tab({
    Title = "Player",
    Icon = "gravity:person",
    Border = true,
})

-- Creating the sanity groupbox
Linear.Sections.Sanity = Linear.Tabs.Player:Section({
    Title = "Sanity",
    Icon = "lucide:brain",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

-- Infinite/NaN sanity toggle
Elements.DisableSanity = Linear.Sections.Sanity:Toggle({
    Title = "Disable Sanity",
    Desc = "Completely disables sanity, also prevents skinwalkets from spawning somehow, this feature cannot be reversed once fired.",
    Callback = function(state)
        if state then
	        Linear.Remotes.Sanity:FireServer(math.acos(2), "_LINEAR", true)
        end
    end
})

-- Creating the utility groupbox
Linear.Sections.Utility = Linear.Tabs.Player:Section({
    Title = "Utility",
    Icon = "gravity:wrench",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

Linear.Sections.Utility:Button({
    Title = "Kill All Hiders",
    Desc = "Kills every hider that spawned for everyone, without needing the fire extinguisher.",
    Callback = function()
        for fart, child in ipairs(NPCs:GetChildren()) do
            if child.Name == "Hider" then
                for i = 1, 10 do
                    Linear.Remotes.ExtHider:FireServer(child)
                end
            end
        end
    end
})

Linear.Sections.Utility:Button({
    Title = "Unfire Patients",
    Desc = "Instantly removes fire effect from burning patients that spawned without in the need of a fire extinguisher or an ointment.",
    Callback = function()
        for fart, child in ipairs(NPCs:GetChildren()) do
            if child:FindFirstChild("FirePP") then
                for i = 1, 10 do
                    Linear.Remotes.ExtNPC:FireServer(child)
                end
            end
        end
    end
})

Linear.Sections.Utility:Button({
    Title = "Show Ghosts",
    Desc = "Shows every ghost that spawned for everyone for a short time, without needing the fire extinguisher.",
    Callback = function()
        for fart, child in ipairs(NPCs:GetChildren()) do
            if child.Name == "Ghost" then
                for i = 1, 10 do
                    Linear.Remotes.ExtHider:FireServer(child)
                end
            end
        end
    end
})

Linear.Sections.Utility:Button({
    Title = "Skip Heartbeat Minigame",
    Desc = "Instantly processes the results for room 7.",
    Callback = function()
        Linear.Remotes.HeartbeatMinigameComplete:FireServer(workspace.Rooms.Emergency.Room7, true)
    end
})

Linear.Sections.Utility:Button({
    Title = "Get Second Coffee Machine",
    Desc = "Gives you the second coffee machine without needing Barney, thank you riddance for this method. 🙏",
    Callback = function()
        ReplicatedStorage.Misc.CoffeeMachine2.Parent = Workspace.Misc
    end
})

Linear.Sections.Utility:Divider()

-- Disable hiders toggle
Elements.DisableHiders = Linear.Sections.Utility:Toggle({
    Title = "Disable Hiders",
    Desc = "Prevents hiders from spawning in the hospital for everyone.",
    Callback = function(state)
        if state then
            for fart, child in ipairs(NPCs:GetChildren()) do
                if child.Name == "Hider" then
                    for i = 1, 10 do Linear.Remotes.ExtHider:FireServer(child) end
                end
            end
            Maid.DisableHiders = NPCs.ChildAdded:Connect(function(child)
                if child.Name == "Hider" then
                    for i = 1, 10 do Linear.Remotes.ExtHider:FireServer(child) end
                end
            end)
        else
            Maid.DisableHiders = nil
        end
    end
})

-- Disable eyes toggle
Elements.DisableEyeMass = Linear.Sections.Utility:Toggle({
    Title = "Disable Eye Mass",
    Desc = "Prevents eye masses from spawning on the ceilings for you.",
    Callback = function(state)
        if state then
            local connections = {}
            for fart, room in pairs(Linear.Rooms) do
                for fart, child in ipairs(room:GetChildren()) do
                    if child.Name == "EyeMass" then child:Destroy() end
                end
                table.insert(connections, room.ChildAdded:Connect(function(child)
                    if child.Name == "EyeMass" then child:Destroy() end
                end))
            end
            Maid.DisableEyes = function()
                for fart, connection in ipairs(connections) do connection:Disconnect() end
            end
        else
            Maid.DisableEyes = nil
        end
    end
})

-- Disable bed monster toggle
Elements.DisableBedMonster = Linear.Sections.Utility:Toggle({
    Title = "Disable Bed Monster",
    Desc = "Prevents bed monsters from spawning under the beds for you.",
    Callback = function(state)
        if state then
            local connections = {}
            for fart, room in pairs(Linear.Rooms) do
                for fart, child in ipairs(room:GetChildren()) do
                    if child.Name == "MonsterBed" or child.Name == "MonsterBedLarge" then child:Destroy() end
                end
                table.insert(connections, room.ChildAdded:Connect(function(child)
                    if child.Name == "MonsterBed" or child.Name == "MonsterBedLarge" then child:Destroy() end
                end))
            end
            Maid.DisableBedMonster = function()
                for fart, connection in ipairs(connections) do connection:Disconnect() end
            end
        else
            Maid.DisableBedMonster = nil
        end
    end
})

-- Disable stalker toggle
Linear.Sections.Utility:Toggle({
    Title = "Disable Stalker",
    Desc = "Prevents stalker from spawning behind walls for you.",
    Callback = function(state)
        if state then
            for fart, child in ipairs(NPCs:GetChildren()) do
                if child.Name == "TallMonster" then child:Destroy() end
            end
            Maid.DisableStalker = NPCs.ChildAdded:Connect(function(child)
                if child.Name == "TallMonster" then child:Destroy() end
            end)
        else
            Maid.DisableStalker = nil
        end
    end
})

-- Disable Shadow toggle
Linear.Originals.ShadowCheck = Linear.Modules.Shadow.CheckAnomalyInCamView
Linear.Originals.ShadowApply = Linear.Modules.Shadow.ApplyAnomalyToCam
Linear.Sections.Utility:Toggle({
    Title = "Disable Shadow",
    Desc = "Prevents shadow from spawning during cameras for you.",
    Callback = function(state)
        if state then
            Linear.Modules.Shadow.CheckAnomalyInCamView = function()
                return false
            end

            ShadowCamera.ApplyAnomalyToCam = function()
                return
            end
        else
            Linear.Modules.Shadow.CheckAnomalyInCamView = Linear.Originals.ShadowCheck
            ShadowCamera.ApplyAnomalyToCam = Linear.Originals.ShadowApply
        end
    end
})

-- Disable fired up patients toggle
Elements.DisableFirePatients = Linear.Sections.Utility:Toggle({
    Title = "Disable Patients On Fire",
    Desc = "Prevents patients that are on fire from spawning for everyone.",
    Callback = function(state)
        if state then
            local connections = {}
            local function func(child)
                if child:FindFirstChild("FirePP") then
                    for i = 1, 10 do Linear.Remotes.ExtNPC:FireServer(child) end
                end
                table.insert(connections, child.ChildAdded:Connect(function(subChild)
                    if subChild.Name == "FirePP" then
                        for i = 1, 10 do Linear.Remotes.ExtNPC:FireServer(child) end
                    end
                end))
            end
            for fart, child in ipairs(NPCs:GetChildren()) do
                func(child)
            end
            table.insert(connections, NPCs.ChildAdded:Connect(func))
            Maid.DisableFirePatients = function()
                for fart, connection in ipairs(connections) do connection:Disconnect() end
            end
        else
            Maid.DisableFirePatients = nil
        end
    end
})

-- Disable fire rooms toggle
Linear.Sections.Utility:Toggle({
    Title = "Disable Rooms On Fire",
    Desc = "Prevents rooms from caughting on fire.",
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
                        task.wait(.05)
                            for fart, firechild in ipairs(fire:GetChildren()) do
                                for fart = 1, 10 do
                                    Linear.Remotes.ExtFire:FireServer(firechild)
                                end
                            end
                        end
                    end
                end
            end))           
            Maid.AntiFireRoom = connections
        else
            if Maid.AntiFireRoom then
                for fart, connection in ipairs(Maid.AntiFireRoom) do
                    connection:Disconnect()
                end
                Maid.AntiFireRoom = nil
            end
        end
    end
})

-- Disable slimes toggle
Elements.DisableSlimes = Linear.Sections.Utility:Toggle({
    Title = "Disable Slimes",
    Desc = "Prevents patients from shitting slimes for everyone.",
    Callback = function(state)
        if state then
            local connections = {}
            local misc = Workspace:WaitForChild("Misc")          
            table.insert(connections, Linear.FireNowAndOnChildAdded(misc, function(child)
                local targets = child and {child} or misc:GetChildren()
                for fart, target in ipairs(targets) do
                    if target.Name == "Slime" and target:IsA("Model") then
                        for fart = 1, 10 do
                            Linear.Remotes.ExtSlime:FireServer(target)
                        end
                    end
                end
            end))            
            Maid.DisableSlimes = connections
        else
            if Maid.DisableSlimes then
                for fart, connection in ipairs(Maid.DisableSlimes) do
                    connection:Disconnect()
                end
                Maid.DisableSlimes = nil
            end
        end
    end
})

-- Disable deaths toggle
Linear.Originals.EndingPatients = Linear.Modules.Cutscenes.ThreePatientsDiedEnding
Elements.DisableHospitalDeaths = Linear.Sections.Utility:Toggle({
    Title = "Disable Hospital Deaths",
    Desc = "The game will no longer record hospital deaths.",
    Callback = function(state)
        if state then
            task.spawn(function()
                for i = 1, 3 do
                    Players:SetAttribute("DeathCount", i)
                    task.wait(1.8)
                end
            end)
            Linear.Modules.Cutscenes.ThreePatientsDiedEnding = function(...)
                return
            end
            Maid.DisableDeaths = function()
                Linear.Modules.Cutscenes.ThreePatientsDiedEnding = Linear.Originals.EndingPatients
            end
        else
            Maid.DisableDeaths = nil
        end
    end
})

-- Make ghosts visible toggle
Linear.Sections.Utility:Toggle({
    Title = "Visible Ghosts",
    Desc = "Prevents ghosts being invisible for everyone.",
    Callback = function(state)
        if state then
            Maid.VisibleGhosts = task.spawn(function()
                while task.wait(1.5) do
                    for fart, child in ipairs(NPCs:GetChildren()) do
                        if child.Name == "Ghost" then
                            for i = 1, 10 do Linear.Remotes.ExtHider:FireServer(child) end
                        end
                    end
                end
            end)
        else
            Maid.VisibleGhosts = nil
        end
    end
})

-- Skip minigames toggle
Linear.Sections.Utility:Toggle({
    Title = "Skip Minigames",
    Desc = "Let's you use the monitors without having to deal with the minigame, does not work for Room 8.",
    Callback = function(state)
        if state then
            local connections = {}
            local original = {}
            for name, room in pairs(Linear.Rooms) do
                if name ~= "Room8" then
                    local minigame = room:FindFirstChild("Minigame")
                    local monitor = minigame and minigame:FindFirstChild("Monitor")
                    local pp2 = monitor and monitor:FindFirstChild("PP2")
                    if pp2 then
                        original[pp2] = pp2.Enabled
                        pp2.Enabled = true
                        table.insert(connections, pp2:GetPropertyChangedSignal("Enabled"):Connect(function()
                            original[pp2] = pp2.Enabled
                            if not pp2.Enabled then
                                pp2.Enabled = true
                                original[pp2] = false
                            end
                        end))
                    end
                end
            end
            Maid.SkipMinigames = function()
                for fart, connection in ipairs(connections) do connection:Disconnect() end
                for pp2, oldstate in pairs(original) do
                    pp2.Enabled = oldstate
                end
            end
        else
            Maid.SkipMinigames = nil
        end
    end
})

Linear.Sections.Utility:Toggle({
    Title = "Ghost Immunity",
    Desc = "Prevents ghost damage for you.",
    Callback = function(state)
        if state then
            local connections = {}          
            table.insert(connections, Linear.FireNowAndOnChildAdded(NPCs, function(child)
                local targets = child and {child} or NPCs:GetChildren()                
                for fart, target in ipairs(targets) do
                    if target.Name == "Ghost" then
                        local primary = target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            local ball = Instance.new("Part")
                            ball.Size = Vector3.new(18, 18, 18)
                            ball.Shape = Enum.PartType.Ball
                            ball.Color = Color3.fromRGB(0, 0, 0)
                            ball.CanCollide = true
                            ball.Position = primary.Position                            
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = ball
                            weld.Part1 = primary
                            weld.Parent = ball                            
                            ball.Parent = target
                        end
                    end
                end
            end))          
            Maid.GhostImmunity = connections
        else
            if Maid.GhostImmunity then
                for fart, connection in ipairs(Maid.GhostImmunity) do
                    connection:Disconnect()
                end
                Maid.GhostImmunity = nil
            end
        end
    end
})

Linear.Sections.Utility:Divider()

Linear.Sections.Utility:Toggle({
    Title = "No Door Collision",
    Desc = "Makes the doors passable through for you.",
    Callback = function(state)
        if state then
            local connections = {}
            local doors = Workspace:FindFirstChild("Doors")            
            if doors then
                for fart, door in ipairs(doors:GetChildren()) do
                    for fart, part in ipairs(door:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            table.insert(connections, part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                                if part.CanCollide then
                                    part.CanCollide = false
                                end
                            end))
                        end
                    end
                end
            end           
            Maid.DoorCollision = connections
        else
            if Maid.DoorCollision then
                for fart, connection in ipairs(Maid.DoorCollision) do
                    connection:Disconnect()
                end
                Maid.DoorCollision = nil
            end           
            local doors = Workspace:FindFirstChild("Doors")
            if doors then
                for fart, door in ipairs(doors:GetChildren()) do
                    for fart, part in ipairs(door:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

Linear.Sections.Utility:Toggle({
    Title = "Infinite Extinguisher Charge",
    Desc = "Makes the fire extinguisher never run out for you.",
    Callback = function(state)
        if state then 
            local connections = {}
            local activetools = {}
            local lib = Linear.Modules.Lib
            
            local dostuff = function(target)
                if not target or activetools[target] then return end          if target.Name == "FireExtenguisher" then
                    activetools[target] = true
                    local bubblescript = target:FindFirstChild("BubbleScript")
                    if bubblescript then
                        bubblescript.Enabled = false
                    end
                    
                    local chargesgui = target:WaitForChild("charges")
                    local userinputservice = game:GetService("UserInputService")
                    local ismobile = userinputservice.TouchEnabled
                    if ismobile then
                        ismobile = userinputservice.KeyboardEnabled == false
                    end
                    
                    table.insert(connections, target.Equipped:Connect(function(mouse)
                        local chargesframe = chargesgui:WaitForChild("black", 1)
                        if chargesframe then 
                            chargesframe.charges.Text = "Charge: " .. (target:GetAttribute("Charges") or "100") .. "%" 
                        end    
                        chargesgui.Parent = LocalPlayer:WaitForChild("PlayerGui")   
                        
                        if not ismobile and mouse then
                            table.insert(connections, mouse.Button1Down:Connect(function()
                                for fart, descendant in ipairs(target:GetDescendants()) do
                                    if descendant:IsA("ImageLabel") then
                                        descendant:SetAttribute("OriginalImage", descendant:GetAttribute("OriginalImage") or descendant.Image)
                                        descendant.Image = "http://www.roblox.com/asset/?id=131211622936404"
                                    end
                                end
                                if (target:GetAttribute("Charges") or 0) > 0 then
                                    target:AddTag("SprayingBubbles")
                                end
                            end))       
                            
                            table.insert(connections, mouse.Button1Up:Connect(function()
                                for fart, descendant in ipairs(target:GetDescendants()) do
                                    if descendant:IsA("ImageLabel") then
                                        descendant.Image = descendant:GetAttribute("OriginalImage")
                                    end
                                end
                                target:RemoveTag("SprayingBubbles")
                            end))
                        end
                    end))
                    
                    table.insert(connections, target.Unequipped:Connect(function()
                        for fart, descendant in ipairs(target:GetDescendants()) do
                            if descendant:IsA("ImageLabel") then
                                descendant.Image = descendant:GetAttribute("OriginalImage") or descendant.Image
                            end
                        end
                        local handle = target:FindFirstChild("Handle")
                        local foamsound = handle and handle:FindFirstChild("FoamSound")
                        if foamsound then
                            foamsound:Stop()
                        end
                        chargesgui.Parent = target
                    end))
                    
                    table.insert(connections, target:GetAttributeChangedSignal("Charges"):Connect(function()
                        local chargesframe = chargesgui:WaitForChild("black", 1)
                        if chargesframe then
                            chargesframe.charges.Text = "Charge: " .. (target:GetAttribute("Charges") or "100") .. "%"
                        end
                    end))
                    
                    if ismobile then
                        local black = chargesgui:WaitForChild("black")
                        local spraybutton = black and black:WaitForChild("fire")
                        if spraybutton then
                            local ismobilespraying = false
                            local mobiledebounce = false    
                            spraybutton.Visible = true
                            
                            table.insert(connections, spraybutton.MouseButton1Up:Connect(function()
                                if not mobiledebounce then
                                    mobiledebounce = true
                                    ismobilespraying = not ismobilespraying
                                    
                                    if ismobilespraying then
                                        spraybutton.Text = "Stop Spray"
                                        for fart, descendant in ipairs(target:GetDescendants()) do
                                            if descendant:IsA("ImageLabel") then
                                                descendant:SetAttribute("OriginalImage", descendant:GetAttribute("OriginalImage") or descendant.Image)
                                                descendant.Image = "http://www.roblox.com/asset/?id=131211622936404"
                                            end
                                        end
                                        if (target:GetAttribute("Charges") or 0) > 0 then
                                            target:AddTag("SprayingBubbles")
                                        end
                                    else
                                        spraybutton.Text = "Tap to Spray"
                                        lib.Network:FireServer("FireExtinguisherStopped")
                                        for fart, descendant in ipairs(target:GetDescendants()) do
                                            if descendant:IsA("ImageLabel") then
                                                descendant.Image = descendant:GetAttribute("OriginalImage")
                                            end
                                        end
                                        target:RemoveTag("SprayingBubbles")
                                    end
                                    
                                    task.wait(0.1)
                                    mobiledebounce = false
                                end
                            end))
                        end
                    end
                    
                    table.insert(connections, target.Destroying:Connect(function()
                        chargesgui:Destroy()
                    end))
                end
            end
            
            table.insert(connections, Linear.FireNowAndOnChildAdded(Backpack, function(child)
                local targets = child and {child} or Backpack:GetChildren()
                for fart, target in ipairs(targets) do
                    dostuff(target)
                end
            end))
            
            table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(char)
                table.insert(connections, Linear.FireNowAndOnChildAdded(char, function(child)
                    local targets = child and {child} or char:GetChildren()
                    for fart, target in ipairs(targets) do
                        dostuff(target)
                    end
                end))
            end))
            
            if LocalPlayer.Character then
                local char = LocalPlayer.Character
                table.insert(connections, Linear.FireNowAndOnChildAdded(char, function(child)
                    local targets = child and {child} or char:GetChildren()
                    for fart, target in ipairs(targets) do
                        dostuff(target)
                    end
                end))
            end
            
            Maid.Extinguisher = connections
        else
            if Maid.Extinguisher then
                for fart, connection in ipairs(Maid.Extinguisher) do
                    connection:Disconnect()
                end
                Maid.Extinguisher = nil
            end           
            
            for fart, tool in ipairs(Backpack:GetChildren()) do
                if tool.Name == "FireExtenguisher" then
                    local bubblescript = tool:FindFirstChild("BubbleScript")
                    if bubblescript then
                        bubblescript.Enabled = true
                    end               
                    local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    local chargesgui = playergui and playergui:FindFirstChild("charges")
                    if chargesgui then
                        chargesgui.Parent = tool
                    end
                end
            end
            
            if LocalPlayer.Character then
                for fart, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if tool.Name == "FireExtenguisher" then
                        local bubblescript = tool:FindFirstChild("BubbleScript")
                        if bubblescript then
                            bubblescript.Enabled = true
                        end               
                        local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                        local chargesgui = playergui and playergui:FindFirstChild("charges")
                        if chargesgui then
                            chargesgui.Parent = tool
                        end
                    end
                end
            end
        end
    end
})

Linear.Sections.Utility:Divider()

Linear.Sections.Utility:Input({
    Title = "Shadow Jumpscare Damage",
    Desc = "Supports decimals, putting negative numbers won't work.",
    Icon = "solar:pencil-to-line",
    Placeholder = "20",
    Value = "20",
    Callback = function(value)
        local num = tonumber(value)   
        if num then
            if num < 0 then
                Values.ShadowDmg = 0
            else
                Values.ShadowDmg = num
            end
        else
            Values.ShadowDmg = 20
            Linear.Notify("The value was defaulted to 20 because this isn't a valid number.", 5)
        end
    end
})

Linear.Sections.Utility:Input({
    Title = "Stalker Jumpscare Damage",
    Desc = "Supports decimals, putting negative numbers won't work.",
    Icon = "solar:pencil-to-line",
    Placeholder = "20",
    Value = "20",
    Callback = function(value)
        local num = tonumber(value)   
        if num then
            if num < 0 then
                Values.StalkerDmg = 0
            else
                Values.StalkerDmg = num
            end
        else
            Values.StalkerDmg = 10
            Linear.Notify("The value was defaulted to 10 because this isn't a valid number.", 5)
        end
    end
})

Linear.Sections.Utility:Button({
    Title = "Apply Shadow Jumpscare Damage",
    Desc = "When you encounter a shadow, it will damage you the value instead.",
    Callback = function()
        Linear.Modules.Shadow.SanityDamage = Values.ShadowDmg or 20
    end
})

local original = Linear.Modules.Lib.PlayerLostSanity
Linear.Sections.Utility:Button({
    Title = "Apply Stalker Jumpscare Damage",
    Desc = "When you encounter a stalker, it will damage you the value instead.",
    Callback = function()
        Linear.Modules.Lib.PlayerLostSanity = function(amount, source)
            if amount == 10 and source == "Stalker" then
                amount = Values.StalkerDmg or 10
            end
            return original(amount, source)
        end
    end
})

-- Creating the aimbot groupbox
Linear.Sections.Aimbot = Linear.Tabs.Player:Section({
    Title = "Aimbot",
    Icon = "gravity:wrench",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

Linear.Sections.Aimbot:Paragraph({
    Title = "Thank you",
    Desc = "Credits to riddance for helping a ton with this feature!",
})

Linear.Sections.Aimbot:Dropdown({
    Title = "Taser Aimbot Priority",
    Values = {"NPC", "Player", "Both"},
    Value = "NPC",
    Multi = false,
    AllowNone = false,
    Callback = function(selected)
        Values.TaserPriority = selected
    end
})

Linear.Sections.Aimbot:Dropdown({
    Title = "Gun Aimbot Priority",
    Values = {"NPC", "Player", "Both"},
    Value = "NPC",
    Multi = false,
    AllowNone = false,
    Callback = function(selected)
        Values.GunPriority = selected
    end
})

Linear.Sections.Aimbot:Toggle({
    Title = "Toggle Taser Aimbot",
    Desc = "When this is on, no matter where you aim your taser at, you will have a 100% success rate to hit the nearest target.",
    Callback = function(state)
        if state then
            local connections = {}
            local activetools = {}
            local lib = Linear.Modules.Lib           
            local dostuff = function(target)
                if not target or activetools[target] then return end          if target.Name == "Taser" then
                    activetools[target] = true
                    local taserlocal = target:FindFirstChild("TaserLocal")
                    if taserlocal then
                        taserlocal.Enabled = false
                    end                  
                    local originaltexture = nil
                    table.insert(connections, target.Activated:Connect(function()
                        if target.Enabled then
                            target.Enabled = false                            
                            local handle = target:FindFirstChild("Handle")
                            local shoot = handle and handle:FindFirstChild("Shoot")
                            if shoot then
                                shoot:Play()
                            end                            
                            for fart, descendant in ipairs(target:GetDescendants()) do
                                if descendant:IsA("ImageLabel") then
                                    originaltexture = originaltexture or descendant.Image
                                    descendant.Image = target.TextureId
                                end
                            end                            
                            local closest, targettype = GameLibrary.GetClosestCharacter()
                            if closest then
                                local priority = Values.TaserPriority or "NPC"                              
                                if priority == "Both" or priority == targettype then
                                    lib.Network:FireServer("TaserFired", closest)
                                end
                            end                          
                            task.wait(1)
                            target.Enabled = true                            
                            for fart, descendant in ipairs(target:GetDescendants()) do
                                if descendant:IsA("ImageLabel") then
                                    descendant.Image = originaltexture
                                end
                            end
                        end
                    end))                    
                elseif target.Name == "X-Taser" then
                    activetools[target] = true
                    local xtaserlocal = target:FindFirstChild("XTaserLocal")
                    if xtaserlocal then
                        xtaserlocal.Enabled = false
                    end                    
                    local chargesgui = target:WaitForChild("charges")
                    local originaltexture = nil                    
                    table.insert(connections, target.Activated:Connect(function()
                        if target.Enabled then
                            target.Enabled = false                          
                            local handle = target:FindFirstChild("Handle")
                            local shoot = handle and handle:FindFirstChild("Shoot")
                            if shoot then
                                shoot:Play()
                            end                            
                            for fart, descendant in ipairs(target:GetDescendants()) do
                                if descendant:IsA("ImageLabel") then
                                    originaltexture = originaltexture or descendant.Image
                                    descendant.Image = target.TextureId
                                end
                            end                           
                            local closest, targettype = GameLibrary.GetClosestCharacter()
                            if closest then
                                local priority = Values.TaserPriority or "NPC"                                
                                if priority == "Both" or priority == targettype then
                                    lib.Network:FireServer("TaserFired", closest)
                                    task.wait(2.5)
                                end
                            end                            
                            task.wait(1)
                            target.Enabled = true                            
                            for fart, descendant in ipairs(target:GetDescendants()) do
                                if descendant:IsA("ImageLabel") then
                                    descendant.Image = originaltexture
                                end
                            end
                        end
                    end))                    
                    table.insert(connections, target.Equipped:Connect(function()
                        chargesgui.black.charges.Text = "Uses: " .. (target:GetAttribute("Charges") or "")
                        chargesgui.Parent = LocalPlayer:WaitForChild("PlayerGui")
                    end))                    
                    table.insert(connections, target.Unequipped:Connect(function()
                        chargesgui.Parent = target
                    end))                    
                    table.insert(connections, target:GetAttributeChangedSignal("Charges"):Connect(function()
                        chargesgui.black.charges.Text = "Uses: " .. (target:GetAttribute("Charges") or "")
                    end))
                end
            end            
            table.insert(connections, Linear.FireNowAndOnChildAdded(Backpack, function(child)
                local targets = child and {child} or Backpack:GetChildren()
                for fart, target in ipairs(targets) do
                    dostuff(target)
                end
            end))            
            table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(char)
                table.insert(connections, Linear.FireNowAndOnChildAdded(char, function(child)
                    local targets = child and {child} or char:GetChildren()
                    for fart, target in ipairs(targets) do
                        dostuff(target)
                    end
                end))
            end))           
            if LocalPlayer.Character then
                local char = LocalPlayer.Character
                table.insert(connections, Linear.FireNowAndOnChildAdded(char, function(child)
                    local targets = child and {child} or char:GetChildren()
                    for fart, target in ipairs(targets) do
                        dostuff(target)
                    end
                end))
            end            
            Maid.TaserAimbot = connections
        else
            if Maid.TaserAimbot then
                for fart, connection in ipairs(Maid.TaserAimbot) do
                    connection:Disconnect()
                end
                Maid.TaserAimbot = nil
            end            
            for fart, tool in ipairs(Backpack:GetChildren()) do
                if tool.Name == "Taser" and tool:FindFirstChild("TaserLocal") then
                    tool.TaserLocal.Enabled = true
                elseif tool.Name == "X-Taser" and tool:FindFirstChild("XTaserLocal") then
                    tool.XTaserLocal.Enabled = true
                    local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    local chargesgui = playergui and playergui:FindFirstChild("charges")
                    if chargesgui then
                        chargesgui.Parent = tool
                    end
                end
            end            
            if LocalPlayer.Character then
                for fart, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if tool.Name == "Taser" and tool:FindFirstChild("TaserLocal") then
                        tool.TaserLocal.Enabled = true
                    elseif tool.Name == "X-Taser" and tool:FindFirstChild("XTaserLocal") then
                        tool.XTaserLocal.Enabled = true
                        local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                        local chargesgui = playergui and playergui:FindFirstChild("charges")
                        if chargesgui then
                            chargesgui.Parent = tool
                        end
                    end
                end
            end
        end
    end
})

Linear.Sections.Aimbot:Toggle({
    Title = "Toggle Gun Aimbot",
    Desc = "When this is on, no matter where you aim your gun at, you will have a 100% success rate to hit the nearest target.",
    Callback = function(state)
        if state then
            local connections = {}
            local activetools = {}
            local lib = Linear.Modules.Lib            
            local dostuff = function(target)
                if not target or activetools[target] then return end          if target.Name == "Gun" then
                    activetools[target] = true
                    local gunhandlerlocal = target:FindFirstChild("GunHandlerLocal")
                    if gunhandlerlocal then
                        gunhandlerlocal.Enabled = false
                    end                    
                    local chargesgui = target:WaitForChild("charges")
                    local isreloading = false
                    local shootconnection = nil                    
                    table.insert(connections, target.Equipped:Connect(function(mouse)
                        chargesgui.black.charges.Text = "Uses: " .. (target:GetAttribute("Charges") or "")
                        chargesgui.Parent = LocalPlayer:WaitForChild("PlayerGui")                        
                        shootconnection = mouse.Button1Down:Connect(function()
                            if isreloading then
                                return
                            end                            
                            local charges = target:GetAttribute("Charges") or 0
                            if charges > 0 then
                                target:SetAttribute("Charges", charges - 1)
                                target.Handle.GunSound:Play()                         
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                                    local closest, targettype = GameLibrary.GetClosestCharacter()
                                    local priority = Values.GunPriority or "NPC"                                  
                                    if closest and (priority == "Both" or priority == targettype) then
                                        local targetroot = closest:FindFirstChild("HumanoidRootPart")
                                        if targetroot then
                                            local dispenserpos = target.Dispenser.CFrame.Position
                                            local effectorigin, effecttarget = lib.GunsLocal.ShootEffect(dispenserpos, targetroot.Position)
                                            lib.Network:FireServer("PlayShootEffect", effectorigin, targetroot)
                                        end
                                    else
                                        local dispenserpos = target.Dispenser.CFrame.Position
                                        local effectorigin, effecttarget = lib.GunsLocal.ShootEffect(dispenserpos, mouse.Hit.Position)
                                        lib.Network:FireServer("PlayShootEffect", effectorigin, effecttarget)
                                    end
                                end                              
                                isreloading = true
                                target.Handle.Reload:Play()
                                task.wait(0.75)
                                isreloading = false
                            end
                        end)
                        table.insert(connections, shootconnection)
                    end))                    
                    table.insert(connections, target.Unequipped:Connect(function()
                        chargesgui.Parent = target
                        if shootconnection then
                            shootconnection:Disconnect()
                            shootconnection = nil
                        end
                    end))                    
                    table.insert(connections, target:GetAttributeChangedSignal("Charges"):Connect(function()
                        chargesgui.black.charges.Text = "Uses: " .. (target:GetAttribute("Charges") or "")
                    end))
                end
            end            
            table.insert(connections, Linear.FireNowAndOnChildAdded(Backpack, function(child)
                local targets = child and {child} or Backpack:GetChildren()
                for fart, target in ipairs(targets) do
                    dostuff(target)
                end
            end))            
            table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(char)
                table.insert(connections, Linear.FireNowAndOnChildAdded(char, function(child)
                    local targets = child and {child} or char:GetChildren()
                    for fart, target in ipairs(targets) do
                        dostuff(target)
                    end
                end))
            end))            
            if LocalPlayer.Character then
                local char = LocalPlayer.Character
                table.insert(connections, Linear.FireNowAndOnChildAdded(char, function(child)
                    local targets = child and {child} or char:GetChildren()
                    for fart, target in ipairs(targets) do
                        dostuff(target)
                    end
                end))
            end            
            Maid.GunAimbot = connections
        else
            if Maid.GunAimbot then
                for fart, connection in ipairs(Maid.GunAimbot) do
                    connection:Disconnect()
                end
                Maid.GunAimbot = nil
            end            
            for fart, tool in ipairs(Backpack:GetChildren()) do
                if tool.Name == "Gun" and tool:FindFirstChild("GunHandlerLocal") then
                    tool.GunHandlerLocal.Enabled = true
                    local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    local chargesgui = playergui and playergui:FindFirstChild("charges")
                    if chargesgui then
                        chargesgui.Parent = tool
                    end
                end
            end          
            if LocalPlayer.Character then
                for fart, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if tool.Name == "Gun" and tool:FindFirstChild("GunHandlerLocal") then
                        tool.GunHandlerLocal.Enabled = true
                        local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                        local chargesgui = playergui and playergui:FindFirstChild("charges")
                        if chargesgui then
                            chargesgui.Parent = tool
                        end
                    end
                end
            end
        end
    end
})

Linear.Sections.Aimbot:Divider()

Linear.Sections.Aimbot:Toggle({
    Title = "Visualize Taser Aimbot",
    Desc = "Visualizes what the taser aimbot is targeting at. (in yellow)",
    Callback = function(state)
        if state then
            local taserclass = Visualizer.new()
            local connections = {}      
            table.insert(connections, RunService.RenderStepped:Connect(function()
                local target, targettype = GameLibrary.GetClosestCharacter()
                if target then
                    local priority = Values.TaserPriority or "NPC"                    
                    if priority == "Both" or priority == targettype then
                        taserclass.Visualize({
                            Instance = target,
                            Color = Color3.fromRGB(255, 255, 0)
                        })
                    end
                end
            end))            
            connections.ClassIns = taserclass
            Maid.TaserVisualizer = connections
        else
            if Maid.TaserVisualizer then
                if Maid.TaserVisualizer.ClassIns then
                    Maid.TaserVisualizer.ClassIns.Destroy()
                end
                for fart, connection in ipairs(Maid.TaserVisualizer) do
                    if typeof(connection) == "RBXScriptConnection" then
                        connection:Disconnect()
                    end
                end
                Maid.TaserVisualizer = nil
            end
        end
    end
})

Linear.Sections.Aimbot:Toggle({
    Title = "Visualize Gun Aimbot",
    Desc = "Visualizes what the gun aimbot is targeting at. (in red)",
    Callback = function(state)
        if state then
            local gunclass = Visualizer.new()
            local connections = {}       
            table.insert(connections, RunService.RenderStepped:Connect(function()
                local target, targettype = GameLibrary.GetClosestCharacter()
                if target then
                    local priority = Values.GunPriority or "NPC"                  
                    if priority == "Both" or priority == targettype then
                        gunclass.Visualize({
                            Instance = target,
                            Color = Color3.fromRGB(255, 0, 0)
                        })
                    end
                end
            end))            
            connections.ClassIns = gunclass
            Maid.GunVisualizer = connections
        else
            if Maid.GunVisualizer then
                if Maid.GunVisualizer.ClassIns then
                    Maid.GunVisualizer.ClassIns.Destroy()
                end
                for fart, connection in ipairs(Maid.GunVisualizer) do
                    if typeof(connection) == "RBXScriptConnection" then
                        connection:Disconnect()
                    end
                end
                Maid.GunVisualizer = nil
            end
        end
    end
})

-- if everything checks out, informs that the player tab is done
Linear:Print("Player tab loaded.")