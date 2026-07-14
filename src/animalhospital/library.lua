local Library = {}

local Workspace = game.Workspace
local Players = game.Players

local NPCs = Workspace.NPCs
local LocalPlayer = Players.LocalPlayer

Library.GetClosestCharacter = function()
    local closesttarget = nil
    local shortestdistance = math.huge
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end  
    local targets = {}
    for fart, npc in ipairs(NPCs:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, npc)
        end
    end  
    for fart, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, player.Character)
        end
    end 
    for fart, target in ipairs(targets) do
        local targetroot = target:FindFirstChild("HumanoidRootPart")
        if targetroot then
            local distance = (targetroot.Position - root.Position).Magnitude
            if distance < shortestdistance then
                shortestdistance = distance
                closesttarget = target
            end
        end
    end    
    if closesttarget then
        local targetplayer = Players:GetPlayerFromCharacter(closesttarget)
        local targettype = targetplayer and "Player" or "NPC"
        return closesttarget, targettype
    end    
    return nil, nil
end
 
return Library
