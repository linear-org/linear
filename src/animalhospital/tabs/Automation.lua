-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

local Maid = Linear.Utils.Maid
local Elements = Linear.Elements
local Values = Linear.Values

-- Getting services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Getting variables 
local NPCs = Workspace.NPCs
local LocalPlayer = Players.LocalPlayer

-- Building the tab
Linear.Tabs.Automation = Window:Tab({
    Title = "Automation",
    Icon = "gravity:power",
    Border = true,
})

-- Creating the esp groupbox
Linear.Sections.Autofarm = Linear.Tabs.Automation:Section({
    Title = "Autofarm",
    Icon = "gravity:arrows-3-rotate-right",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

local AutofarmSpeed = Linear.Sections.Autofarm:Dropdown({
    Title = "Autofarm Speed",
    Values = {"Normal", "Fast"},
    Value = "Fast",
    Multi = false,
    AllowNone = false,
    Callback = function(selected)
        Values.AutofarmSpeed = selected
    end
})

local function IsTouching(part1, part2)
    if not part1 or not part2 then return false end
    local size1 = part1.Size / 2
    local size2 = part2.Size / 2
    local pos1 = part1.Position
    local pos2 = part2.Position
    return math.abs(pos1.X - pos2.X) < (size1.X + size2.X) and
           math.abs(pos1.Y - pos2.Y) < (size1.Y + size2.Y) and
           math.abs(pos1.Z - pos2.Z) < (size1.Z + size2.Z)
end

Linear.Sections.Autofarm:Toggle({
    Title = "Toggle Autofarm",
    Desc = "Starts autofarming This is still in beta, you may encounter some bugs.",
    Callback = function(state)
        if state then
            Elements.DisableHiders:Set(true)
            Elements.DisableEyeMass:Set(true)
            Elements.DisableBedMonster:Set(true)
            Elements.DisableFirePatients:Set(true)
            Elements.DisableSlimes:Set(true)
            Elements.DisableHospitalDeaths:Set(true)
            Elements.DisableSanity:Set(true)
            AutofarmSpeed:Lock()
            Maid.Autofarming = task.spawn(function()
                task.wait()
                while Maid.Autofarming do
                    task.wait(0.1)                 
                    local speed = Values.AutofarmSpeed or "Fast"
                    local checkin1 = Workspace.Misc:FindFirstChild("CheckIn")
                    local checkin2 = Workspace.Misc:FindFirstChild("CheckIn2")
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")                    
                    for fart, npc in ipairs(NPCs:GetChildren()) do
                        local dummy = npc:FindFirstChild("RagdollDummy")
                        if dummy then
                            local npcroot = npc:FindFirstChild("HumanoidRootPart")
                            if npcroot then
                                local spine = npcroot:FindFirstChild("spine")
                                local s1 = spine and spine:FindFirstChild("spine.001")
                                local s2 = s1 and s1:FindFirstChild("spine.002")
                                local faintedprompt = s2 and s2:FindFirstChild("FaintedPP")
                                
                                if faintedprompt and root then
                                    root.CFrame = s2.CFrame
                                    task.wait(0.15)
                                    for i = 1, 5 do
                                        fireproximityprompt(faintedprompt)
                                        task.wait(0.03)
                                    end
                                    
                                    local trash = Workspace:FindFirstChild("Trash")
                                    if trash then
                                        local trashprompt = trash:FindFirstChild("PP") or trash:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if trashprompt then
                                            root.CFrame = trash.CFrame
                                            task.wait(0.15)
                                            fireproximityprompt(trashprompt)
                                            task.wait(0.05)
                                        end
                                    end
                                end
                            end
                        end
                    end                   
                    local shutterbutton = Workspace.Misc:FindFirstChild("ShutterButton")
                    if shutterbutton then
                        local prompt = shutterbutton:FindFirstChild("PP") or shutterbutton:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            local theresspeicalnpc = false
                            for fart, npc in ipairs(NPCs:GetChildren()) do
                                if npc.Name == "Liz" or npc.Name == "Barney" then
                                    local npcroot = npc:FindFirstChild("HumanoidRootPart")
                                    if npcroot then
                                        local detector1 = Linear.DetectorCounter1
                                        local detector2 = Linear.DetectorCounter2                                 
                                        local in1 = false
                                        if detector1 then
                                            in1 = IsTouching(npcroot, detector1)
                                        end                                      
                                        local in2 = false
                                        if detector2 then
                                            in2 = IsTouching(npcroot, detector2)
                                        end                                        
                                        if in1 or in2 then
                                            theresspeicalnpc = true
                                            break
                                        end
                                    end
                                end
                            end                            
                            local actiontext = prompt.ActionText
                            if theresspeicalnpc then
                                if actiontext == "Close" and root then
                                    root.CFrame = shutterbutton.CFrame
                                    task.wait(0.2)
                                    fireproximityprompt(prompt)
                                    task.wait(0.1)
                                end
                            else
                                if actiontext == "Open" and root then
                                    root.CFrame = shutterbutton.CFrame
                                    task.wait(0.2)
                                    fireproximityprompt(prompt)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end                   
                    local npcon1 = nil
                    local npcon2 = nil               
                    for fart, npc in ipairs(NPCs:GetChildren()) do
                        if npc:GetAttribute("AssignedRoom") then
                            local npcroot = npc:FindFirstChild("HumanoidRootPart")
                            if npcroot then
                                if Linear.DetectorCounter1 then
                                    if IsTouching(npcroot, Linear.DetectorCounter1) then
                                        npcon1 = npc
                                    end
                                end
                                if checkin2 and Linear.DetectorCounter2 then
                                    if IsTouching(npcroot, Linear.DetectorCounter2) then
                                        npcon2 = npc
                                    end
                                end
                            end
                        end
                    end                   
                    if npcon1 and npcon2 and root then
                        local photo1 = nil
                        local photo2 = nil
                        local starttime = os.time()                     
                        while active and not (photo1 and photo2) do
                            if os.time() - starttime > 6 then break end                           
                            if not photo1 then
                                local cam1 = checkin1:FindFirstChild("Camera")
                                local prompt1 = cam1 and cam1:FindFirstChild("PP")
                                if prompt1 then
                                    root.CFrame = cam1.CFrame
                                    task.wait(0.1)
                                    for i = 1, 5 do
                                        fireproximityprompt(prompt1)
                                        task.wait(0.03)
                                    end
                                end
                                photo1 = checkin1:FindFirstChild("Photo")
                            end                            
                            if not photo2 then
                                local cam2 = checkin2:FindFirstChild("Camera")
                                local prompt2 = cam2 and cam2:FindFirstChild("PP")
                                if prompt2 then
                                    root.CFrame = cam2.CFrame
                                    task.wait(0.1)
                                    for i = 1, 5 do
                                        fireproximityprompt(prompt2)
                                        task.wait(0.03)
                                    end
                                end
                                photo2 = checkin2:FindFirstChild("Photo")
                            end
                            task.wait(0.05)
                        end                    
                        for i = 1, 2 do
                            local currentcheck = i == 1 and checkin1 or checkin2
                            local computer = currentcheck:FindFirstChild("Computer")
                            local prompt = computer and computer:FindFirstChild("PP")
                            if prompt then
                                root.CFrame = computer.CFrame
                                local waitstart = os.time()
                                while active and not currentcheck:FindFirstChild("Form") do
                                    if os.time() - waitstart > 3 then break end
                                    fireproximityprompt(prompt)
                                    task.wait(0.03)
                                end
                                for j = 1, 20 do
                                    fireproximityprompt(prompt)
                                    task.wait(0.03)
                                end
                            end
                        end                       
                        for i = 1, 2 do
                            local currentcheck = i == 1 and checkin1 or checkin2
                            local printer = currentcheck:FindFirstChild("Printer")
                            local prompt = printer and printer:FindFirstChild("PP")
                            if prompt then
                                root.CFrame = printer.CFrame
                                local waitstart = os.time()
                                while active and not currentcheck:FindFirstChild("PrintedBadge") do
                                    if os.time() - waitstart > 3 then break end
                                    fireproximityprompt(prompt)
                                    task.wait(0.03)
                                end
                                for j = 1, 20 do
                                    fireproximityprompt(prompt)
                                    task.wait(0.03)
                                end
                            end
                        end                        
                        for i = 1, 2 do
                            local currentcheck = i == 1 and checkin1 or checkin2
                            local badge = currentcheck:FindFirstChild("PrintedBadge")
                            if badge then
                                local prompt = badge:FindFirstChild("PP") or badge:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then
                                    root.CFrame = badge.CFrame
                                    while active and badge:IsDescendantOf(Workspace) do
                                        fireproximityprompt(prompt)
                                        task.wait(0.03)
                                    end
                                end
                            end
                        end                      
                        local npctotarget = {npcon1, npcon2}
                        for fart, npc in ipairs(npctotarget) do
                            if npc and npc:IsDescendantOf(NPCs) then
                                local prompt = npc:FindFirstChild("PP") or npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then
                                    root.CFrame = npc:GetPivot()
                                    task.wait(0.1)
                                    for j = 1, 5 do
                                        fireproximityprompt(prompt)
                                        task.wait(0.03)
                                    end
                                end
                            end
                        end                    
                    elseif npcon1 and root then
                        local cam = checkin1:FindFirstChild("Camera")
                        local prompt = cam and cam:FindFirstChild("PP")
                        if prompt then
                            root.CFrame = cam.CFrame
                            local waitstart = os.time()
                            while active and not checkin1:FindFirstChild("Photo") do
                                if os.time() - waitstart > 3 then break end
                                fireproximityprompt(prompt)
                                task.wait(0.03)
                            end
                        end                     
                        local computer = checkin1:FindFirstChild("Computer")
                        local compprompt = computer and computer:FindFirstChild("PP")
                        if compprompt then
                            root.CFrame = computer.CFrame
                            local waitstart = os.time()
                            while active and not checkin1:FindFirstChild("Form") do
                                if os.time() - waitstart > 3 then break end
                                fireproximityprompt(compprompt)
                                task.wait(0.03)
                            end
                            for i = 1, 20 do
                                fireproximityprompt(compprompt)
                                task.wait(0.03)
                            end
                        end                        
                        local printer = checkin1:FindFirstChild("Printer")
                        local printprompt = printer and printer:FindFirstChild("PP")
                        if printprompt then
                            root.CFrame = printer.CFrame
                            local waitstart = os.time()
                            while active and not checkin1:FindFirstChild("PrintedBadge") do
                                if os.time() - waitstart > 3 then break end
                                fireproximityprompt(printprompt)
                                task.wait(0.03)
                            end
                            for i = 1, 20 do
                                fireproximityprompt(printprompt)
                                task.wait(0.03)
                            end
                        end                        
                        local badge = checkin1:FindFirstChild("PrintedBadge")
                        if badge then
                            local badgeprompt = badge:FindFirstChild("PP") or badge:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if badgeprompt then
                                root.CFrame = badge.CFrame
                                while active and badge:IsDescendantOf(Workspace) do
                                    fireproximityprompt(badgeprompt)
                                    task.wait(0.03)
                                end
                            end
                        end                     
                        if npcon1 and npcon1:IsDescendantOf(NPCs) then
                            local npcprompt = npcon1:FindFirstChild("PP") or npcon1:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if npcprompt then
                                root.CFrame = npcon1:GetPivot()
                                task.wait(0.1)
                                for i = 1, 5 do
                                    fireproximityprompt(npcprompt)
                                    task.wait(0.03)
                                end
                            end
                        end                      
                    elseif npcon2 and checkin2 and root then
                        local cam = checkin2:FindFirstChild("Camera")
                        local prompt = cam and cam:FindFirstChild("PP")
                        if prompt then
                            root.CFrame = cam.CFrame
                            local waitstart = os.time()
                            while active and not checkin2:FindFirstChild("Photo") do
                                if os.time() - waitstart > 3 then break end
                                fireproximityprompt(prompt)
                                task.wait(0.03)
                            end
                        end                        
                        local computer = checkin2:FindFirstChild("Computer")
                        local compprompt = computer and computer:FindFirstChild("PP")
                        if compprompt then
                            root.CFrame = computer.CFrame
                            local waitstart = os.time()
                            while active and not checkin2:FindFirstChild("Form") do
                                if os.time() - waitstart > 3 then break end
                                fireproximityprompt(compprompt)
                                task.wait(0.03)
                            end
                            for i = 1, 20 do
                                fireproximityprompt(compprompt)
                                task.wait(0.03)
                            end
                        end                     
                        local printer = checkin2:FindFirstChild("Printer")
                        local printprompt = printer and printer:FindFirstChild("PP")
                        if printprompt then
                            root.CFrame = printer.CFrame
                            local waitstart = os.time()
                            while active and not checkin2:FindFirstChild("PrintedBadge") do
                                if os.time() - waitstart > 3 then break end
                                fireproximityprompt(printprompt)
                                task.wait(0.03)
                            end
                            for i = 1, 20 do
                                fireproximityprompt(printprompt)
                                task.wait(0.03)
                            end
                        end                      
                        local badge = checkin2:FindFirstChild("PrintedBadge")
                        if badge then
                            local badgeprompt = badge:FindFirstChild("PP") or badge:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if badgeprompt then
                                root.CFrame = badge.CFrame
                                while active and badge:IsDescendantOf(Workspace) do
                                    fireproximityprompt(badgeprompt)
                                    task.wait(0.03)
                                end
                            end
                        end                        
                        if npcon2 and npcon2:IsDescendantOf(NPCs) then
                            local npcprompt = npcon2:FindFirstChild("PP") or npcon2:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if npcprompt then
                                root.CFrame = npcon2:GetPivot()
                                task.wait(0.1)
                                for i = 1, 5 do
                                    fireproximityprompt(npcprompt)
                                    task.wait(0.03)
                                end
                            end
                        end
                    end                  
                    for fart, npc in ipairs(NPCs:GetChildren()) do
                        if not active then break end                        
                        local isroom6touching = false
                        if Linear.DetectorRoom6 then
                            local npcroot = npc:FindFirstChild("HumanoidRootPart")
                            if npcroot then
                                isroom6touching = IsTouching(npcroot, Linear.DetectorRoom6)
                            end
                        end                     
                        if isroom6touching and root then
                            local room6 = Linear.Rooms:FindFirstChild("Room6")
                            if room6 then
                                local monitor = room6:FindFirstChild("Minigame") and room6.Minigame:FindFirstChild("Monitor")
                                local monitorprompt = monitor and monitor:FindFirstChild("PP2")
                                if monitorprompt then
                                    root.CFrame = monitor.CFrame
                                    task.wait(0.2)
                                    for i = 1, 5 do
                                        fireproximityprompt(monitorprompt)
                                        task.wait(0.02)
                                    end                                  
                                    local waitstart = os.time()
                                    while active do
                                        if os.time() - waitstart > 5 then break end
                                        local xray = room6.Minigame:FindFirstChild("PrintedXRay")
                                        if xray then
                                            local xrayprompt = xray:FindFirstChild("PP") or xray:FindFirstChildWhichIsA("ProximityPrompt", true)
                                            if xrayprompt then
                                                root.CFrame = xray.CFrame
                                                while active and xray:IsDescendantOf(Workspace) do
                                                    fireproximityprompt(xrayprompt)
                                                    task.wait(0.05)
                                                end
                                            end
                                            break
                                        end
                                        task.wait(0.1)
                                    end                                   
                                    if speed == "Fast" then
                                        local scissors = Linear.Items:FindFirstChild("Scissors")
                                        if scissors then
                                            local prompt = scissors:FindFirstChild("PP") or scissors:FindFirstChildWhichIsA("ProximityPrompt", true)
                                            if prompt then
                                                root.CFrame = scissors:IsA("Model") and scissors:GetPivot() or scissors.CFrame
                                                while active and not LocalPlayer.Backpack:FindFirstChild("Scissors") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Scissors")) do
                                                    fireproximityprompt(prompt)
                                                    task.wait(0.1)
                                                end                                               
                                                local npcprompt = npc:FindFirstChild("PP") or npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                if npcprompt then
                                                    root.CFrame = npc:GetPivot()
                                                    while active and (npc:GetAttribute("Strikes") or 0) == 0 do
                                                        if npcprompt.ActionText == "Treat Patient" then
                                                            fireproximityprompt(npcprompt)
                                                        end
                                                        task.wait(0.05)
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        local tv = room6.Minigame:FindFirstChild("TV")
                                        local reportinv = tv and tv:FindFirstChild("Screen") and tv.Screen:FindFirstChild("UI") and tv.Screen.UI:FindFirstChild("Report") and tv.Screen.UI.Report:FindFirstChild("inv")
                                        if reportinv then
                                            for fart, item in ipairs(reportinv:GetChildren()) do
                                                local itemname = item.Name
                                                local gameitem = Linear.Items:FindFirstChild(itemname)
                                                if gameitem then
                                                    local itemprompt = gameitem:FindFirstChild("PP") or gameitem:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                    if itemprompt then
                                                        root.CFrame = gameitem:IsA("Model") and gameitem:GetPivot() or gameitem.CFrame
                                                        while active and not LocalPlayer.Backpack:FindFirstChild(itemname) and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(itemname)) do
                                                            fireproximityprompt(itemprompt)
                                                            task.wait(0.1)
                                                        end                                                        
                                                        local npcprompt = npc:FindFirstChild("PP") or npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                        if npcprompt then
                                                            root.CFrame = npc:GetPivot()
                                                            while active and (LocalPlayer.Backpack:FindFirstChild(itemname) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(itemname))) do
                                                                if npcprompt.ActionText == "Treat Patient" then
                                                                    fireproximityprompt(npcprompt)
                                                                end
                                                                task.wait(0.02)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end                          
                        elseif npc:GetAttribute("InBed") and root then
                            local roomname = npc:GetAttribute("AssignedRoom")
                            local room = roomname and Linear.Rooms:FindFirstChild(roomname)
                            local minigame = room and room:FindFirstChild("Minigame")                        
                            if minigame then
                                if speed == "Fast" then
                                    local scissors = Linear.Items:FindFirstChild("Scissors")
                                    if scissors then
                                        local prompt = scissors:FindFirstChild("PP") or scissors:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if prompt then
                                            root.CFrame = scissors:IsA("Model") and scissors:GetPivot() or scissors.CFrame
                                            while active and not LocalPlayer.Backpack:FindFirstChild("Scissors") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Scissors")) do
                                                fireproximityprompt(prompt)
                                                task.wait(0.1)
                                            end                                         
                                            local bed = minigame:FindFirstChild("Bed")
                                            local inbed = bed and bed:FindFirstChild("InBed")
                                            local inbedprompt = inbed and inbed:FindFirstChild("PP")
                                            if inbedprompt then
                                                root.CFrame = inbed.CFrame
                                                while active and (npc:GetAttribute("Strikes") or 0) == 0 do
                                                    fireproximityprompt(inbedprompt)
                                                    task.wait(0.05)
                                                end
                                            end
                                        end
                                    end
                                else
                                    if roomname == "Room7" then
                                        local monitor = minigame:FindFirstChild("Monitor")
                                        local prompt = monitor and monitor:FindFirstChild("PP2")
                                        if prompt then
                                            root.CFrame = monitor.CFrame
                                            task.wait(0.1)
                                            for i = 1, 5 do
                                                fireproximityprompt(prompt)
                                                task.wait(0.02)
                                            end
                                        end                                      
                                        local printer = minigame:FindFirstChild("Printer")
                                        local printprompt = printer and printer:FindFirstChild("PP")
                                        if printprompt then
                                            root.CFrame = printer.CFrame
                                            local waitstart = os.time()
                                            while active do
                                                if os.time() - waitstart > 5 then break end
                                                local xray = minigame:FindFirstChild("PrintedXRay")
                                                if xray then
                                                    local xrayprompt = xray:FindFirstChild("PP") or xray:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                    if xrayprompt then
                                                        root.CFrame = xray.CFrame
                                                        while active and xray:IsDescendantOf(Workspace) do
                                                            fireproximityprompt(xrayprompt)
                                                            task.wait(0.05)
                                                        end
                                                    end
                                                    break
                                                end
                                                fireproximityprompt(printprompt)
                                                task.wait(0.1)
                                            end
                                        end                                    
                                    elseif roomname == "Room8" then
                                        local bed = minigame:FindFirstChild("Bed")
                                        local inbed = bed and bed:FindFirstChild("InBed")
                                        local prompt2 = inbed and inbed:FindFirstChild("PP2")
                                        if prompt2 then
                                            root.CFrame = inbed.CFrame
                                            task.wait(0.2)
                                            fireproximityprompt(prompt2)
                                            task.wait(0.1)
                                        end
                                    else
                                        local monitor = minigame:FindFirstChild("Monitor")
                                        local prompt = monitor and monitor:FindFirstChild("PP2")
                                        if prompt then
                                            root.CFrame = monitor.CFrame
                                            task.wait(0.1)
                                            for i = 1, 5 do
                                                fireproximityprompt(prompt)
                                                task.wait(0.02)
                                            end
                                        end
                                    end                                 
                                    local tv = minigame:FindFirstChild("TV")
                                    local reportinv = tv and tv:FindFirstChild("Screen") and tv.Screen:FindFirstChild("UI") and tv.Screen.UI:FindFirstChild("Report") and tv.Screen.UI.Report:FindFirstChild("inv")
                                    if reportinv then
                                        for fart, item in ipairs(reportinv:GetChildren()) do
                                            local itemname = item.Name
                                            local gameitem = Linear.Items:FindFirstChild(itemname)
                                            if gameitem then
                                                local itemprompt = gameitem:FindFirstChild("PP") or gameitem:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                if itemprompt then
                                                    root.CFrame = gameitem:IsA("Model") and gameitem:GetPivot() or gameitem.CFrame
                                                    while active and not LocalPlayer.Backpack:FindFirstChild(itemname) and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(itemname)) do
                                                        fireproximityprompt(itemprompt)
                                                        task.wait(0.1)
                                                    end                                                
                                                    local bed = minigame:FindFirstChild("Bed")
                                                    local inbed = bed and bed:FindFirstChild("InBed")
                                                    local inbedprompt = inbed and inbed:FindFirstChild("PP")
                                                    if inbedprompt then
                                                        root.CFrame = inbed.CFrame
                                                        while active and (LocalPlayer.Backpack:FindFirstChild(itemname) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(itemname))) do
                                                            fireproximityprompt(inbedprompt)
                                                            task.wait(0.02)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)           
        else
            Maid.Autofarming = nil
            AutofarmSpeed:Unlock()
        end
    end
})

Linear:Print("Automation tab loaded.")
