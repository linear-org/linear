-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

local Maid = Linear.Utils.Maid
local ESP = Linear.Utils.Esp
local Values = Linear.Values

-- Getting services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Getting variables 
local NPCs = Workspace.NPCs
local LocalPlayer = Players.LocalPlayer

-- Building the tab
Linear.Tabs.Visuals = Window:Tab({
    Title = "Visuals",
    Icon = "gravity:eye",
    Border = true,
})

-- Creating the esp groupbox
Linear.Sections.Esp = Linear.Tabs.Visuals:Section({
    Title = "ESP",
    Icon = "gravity:eye-dashed",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

-- ESP Patients toggle
Linear.Sections.Esp:Toggle({
    Title = "Patients ESP",
    Callback = function(state)
        if state then
            local connections = {}          
            table.insert(connections, Linear.FireNowAndOnChildAdded(NPCs, function(child)
                local targets = child and {child} or NPCs:GetChildren()                
                for fart, target in ipairs(targets) do
                    local roomname = target:GetAttribute("DesignatedRoom")
                    if not roomname then continue end                    
                    if target:GetAttribute("Skinwalker") then
                        ESP:Add({ Instance = target, Color = Color3.fromRGB(255, 60, 60), Flag = "Skinwalkers" })
                        ESP:Tag({ InstanceOrFlag = target, Name = "Skinwalker", Flag = "Tag_Patient_IsAnomaly_" .. target:GetFullName() })
                    elseif target:GetAttribute("Visitor") then
                        ESP:Add({ Instance = target, Color = Color3.fromRGB(210, 210, 210), Flag = "Visitors" })
                        ESP:Tag({ InstanceOrFlag = target, Name = "Visitor", Flag = "Tag_Patient_IsVisitor_" .. target:GetFullName() })
                    else
                        ESP:Add({ Instance = target, Color = Color3.fromRGB(60, 60, 255), Flag = "Patients" })
                        ESP:Tag({ InstanceOrFlag = target, Name = "Patient", Flag = "Tag_Patient_IsNormal_" .. target:GetFullName() })
                    end                    
                    local fullname = target:GetFullName()
                    local roomflag = "Tag_Patient_Room_" .. fullname
                    local treatmentflag = "Tag_Patient_Treatments_" .. fullname
                    local statusflag = "Tag_Patient_Status_" .. fullname                    
                    ESP:Tag({ InstanceOrFlag = target, Name = "Room " .. tostring(roomname), Flag = roomflag })
                    ESP:Tag({ InstanceOrFlag = target, Name = "()", Flag = treatmentflag })
                    ESP:Tag({ InstanceOrFlag = target, Name = "", Flag = statusflag })                    
                    table.insert(connections, Linear.FireNowAndOnAttributeChanged(target, "DesignatedRoom", function()
                        local currentroom = target:GetAttribute("DesignatedRoom")
                        if currentroom then
                            ESP:UpdateTag({ Tag = roomflag, Update = "Room " .. tostring(currentroom) })
                        end
                    end))                    
                    local roominst = Linear.Rooms:FindFirstChild(tostring(roomname))
                    local minigame = roominst and roominst:FindFirstChild("Minigame")
                    local tv = minigame and minigame:FindFirstChild("TV")
                    local screen = tv and tv:FindFirstChild("Screen")
                    local ui = screen and screen:FindFirstChild("UI")
                    local report = ui and ui:FindFirstChild("Report")
                    local inv = report and report:FindFirstChild("inv")
                    local healing = ui and ui:FindFirstChild("Healing")                    
                    if inv then
                        table.insert(connections, Linear.FireNowAndOnChildAdded(inv, function()
                            local list = {}
                            for fart, item in ipairs(inv:GetChildren()) do
                                table.insert(list, item.Name)
                            end
                            ESP:UpdateTag({ Tag = treatmentflag, Update = "(" .. table.concat(list, ", ") .. ")" })
                        end))
                        table.insert(connections, inv.ChildRemoved:Connect(function()
                            local list = {}
                            for fart, item in ipairs(inv:GetChildren()) do
                                table.insert(list, item.Name)
                            end
                            ESP:UpdateTag({ Tag = treatmentflag, Update = "(" .. table.concat(list, ", ") .. ")" })
                        end))
                    end                    
                    table.insert(connections, Linear.FireNowAndOnAttributeChanged(target, "InBed", function()
                        local text = ""
                        if healing and healing.Visible then
                            text = "Recovering"
                        elseif target:GetAttribute("InBed") then
                            text = "In Bed"
                        end
                        ESP:UpdateTag({ Tag = statusflag, Update = text })
                    end))                                    
                    if healing then
                        table.insert(connections, healing:GetPropertyChangedSignal("Visible"):Connect(function()
                            local text = ""
                            if healing.Visible then
                                text = "Recovering"
                            elseif target:GetAttribute("InBed") then
                                text = "In Bed"
                            end
                            ESP:UpdateTag({ Tag = statusflag, Update = text })
                        end))
                    end
                end
            end))            
            Maid.PatientsEsp = connections
        else
            if Maid.PatientsEsp then
                for fart, connection in ipairs(Maid.PatientsEsp) do
                    connection:Disconnect()
                end
                Maid.PatientsEsp = nil
            end
            ESP:Remove({ InstanceOrFlag = "Visitors" })
            ESP:Remove({ InstanceOrFlag = "Patients" })
            ESP:Remove({ InstanceOrFlag = "Skinwalkers" })
        end
    end
})

Linear.Sections.Esp:Toggle({
    Title = "Players ESP",
    Callback = function(state)
        if state then
            local connections = {}     
            table.insert(connections, Linear.FireNowAndOnChildAdded(Players, function(player)
                if player then
                    task.wait(1)
                end            
                local targets = player and {player} or Players:GetPlayers()                
                for fart, target in ipairs(targets) do
                    if target ~= LocalPlayer then
                        local character = target.Character
                        if character then
                            local sanityflag = "Tag" .. target.Name .. "Sanity"
                            local invflag = "Tag" .. target.Name .. "Inventory"                           
                            ESP:Add({ Instance = character, Color = Color3.fromRGB(60, 255, 60), Flag = "Players" })
                            ESP:Tag({ InstanceOrFlag = character, Name = "", Flag = sanityflag })                            
                            table.insert(connections, Linear.FireNowAndOnAttributeChanged(target, "Sanity", function()
                                local sanity = target:GetAttribute("Sanity") or 100
                                ESP:UpdateTag({ Tag = sanityflag, Update = tostring(sanity) .. " Sanity" })
                            end))                           
                            local bonus = target:GetAttribute("BonusCarryItems") or 0
                            local capacity = bonus + 3
                            ESP:Tag({ InstanceOrFlag = character, Name = tostring(capacity) .. " Item Capacity", Flag = invflag })
                        end
                    end
                end
            end))            
            Maid.PlayersEsp = connections
        else
            if Maid.PlayersEsp then
                for fart, connection in ipairs(Maid.PlayersEsp) do
                    connection:Disconnect()
                end
                Maid.PlayersEsp = nil
            end
            ESP:Remove({ InstanceOrFlag = "Players" })
        end
    end
})

Linear.Sections.Esp:Toggle({
    Title = "Hider ESP",
    Callback = function(state)
        if state then
            local connections = {}          
            table.insert(connections, Linear.FireNowAndOnChildAdded(NPCs, function(child)
                local targets = child and {child} or NPCs:GetChildren()              
                for fart, target in ipairs(targets) do
                    if target.Name == "Hider" then
                        ESP:Add({ Instance = target, Color = Color3.fromRGB(255, 60, 60), Flag = "Hiders" })
                        ESP:Tag({ InstanceOrFlag = target, Name = "Anomaly", Flag = "Tag_Hider_" .. target:GetFullName() })
                    end
                end
            end))           
            Maid.HiderEsp = connections
        else
            if Maid.HiderEsp then
                for fart, connection in ipairs(Maid.HiderEsp) do
                    connection:Disconnect()
                end
                Maid.HiderEsp = nil
            end
            ESP:Remove({ InstanceOrFlag = "Hiders" })
        end
    end
})

Linear.Sections.Esp:Toggle({
    Title = "Ghost ESP",
    Callback = function(state)
        if state then
            local connections = {}          
            table.insert(connections, Linear.FireNowAndOnChildAdded(NPCs, function(child)
                local targets = child and {child} or NPCs:GetChildren()              
                for fart, target in ipairs(targets) do
                    if target.Name == "Ghost" then
                        ESP:Add({ Instance = target, Color = Color3.fromRGB(255, 60, 60), Flag = "Ghosts" })
                        ESP:Tag({ InstanceOrFlag = target, Name = "Anomaly", Flag = "Tag_Ghost_" .. target:GetFullName() })
                    end
                end
            end))           
            Maid.GhostEsp = connections
        else
            if Maid.GhostEsp then
                for fart, connection in ipairs(Maid.GhostEsp) do
                    connection:Disconnect()
                end
                Maid.GhostEsp = nil
            end
            ESP:Remove({ InstanceOrFlag = "Ghosts" })
        end
    end
})

-- if everything checks out, informs that the player tab is done
Linear:Print("Visuals tab loaded.")