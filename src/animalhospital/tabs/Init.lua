-- Getting the global references
local Linear = getgenv().Linear

local Intro = Linear.Utils.Intro
local Fertilizer = Linear.Utils.Fertilizer

-- Getting services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Getting variables
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

-- Fixing solara & xeno
local exec = string.lower(identifyexecutor and identifyexecutor() or "bro which shit ur using that has no identify executor 🙏🙏")
if string.find(exec, "xeno") or string.find(exec, "solara") then
    getgenv().fireproximityprompt = function(p)
        local old = p.HoldDuration
        p.HoldDuration = 0
        p:InputHoldBegin()
        task.wait()
        p:InputHoldEnd()
        p.HoldDuration = old
    end
end

-- Logging info
task.spawn(function()
if request then
    pcall(function()
        local jobid = game.JobId or "?"
        local currentplayers = #Players:GetPlayers()
        local maxplayers = Players.MaxPlayers
        local serversize = tostring(currentplayers) .. "/" .. tostring(maxplayers)
        local username = LocalPlayer.Name or "?"
        local isdonor = "False"
        local executionsval = "0 time(s)"
        executionsval = tostring(Linear.GetExecutions()) .. " time(s)"
        if Linear.IsDonor then isdonor = "True" end
        local gamename = "?"
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info and info.Name then
            gamename = info.Name
        end
        request({
            Url = "https://discord.com/api/webhooks/1526048260584771647/KU4ZFgOFXJ2jKTGl-96QdzAlKWV_m_n1FpbMchf_XkDFYwkeqzwb-q9p6wrayMLv1FkN",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                embeds = {
                    {
                        title = "A human just executed Linear.",
                        description = "-# Use the `/total-executions` command to know total executions since release.",
                        color = 1,
                        fields = {
                            {name = "Job ID", value = "`" .. jobid .. "`"},
                            {name = "Server Size", value = "`" .. serversize .. "`"},
                            {name = "Username", value = "`" .. username .. "`"},
                            {name = "Donor", value = "`" .. isdonor .. "`"},
                            {name = "Executions", value = "`" .. executionsval .. "`"},
                            {name = "Game", value = "`" .. gamename .. "`"}
                        }
                    },
                    {
                        color = 1,
                        image = {
                            url = "https://cdn.discordapp.com/attachments/1446170000896294992/1526047009340133426/Baslksz77_20260628183736.png?ex=6a559987&is=6a544807&hm=426cea45b06ea274a4cc343eb1ffe8c4737f37c37aae4a2b62442f8a90a54fd6&"
                        }
                    }
                }
            })
        })
    end)
end
end)

-- Creating more global references, though those are special for animal hospital
Linear.DetectorCounter1 = Instance.new("Part")
Linear.DetectorCounter1.Name = "linear's first counter area detector, DO NOT DELETE"
Linear.DetectorCounter1.Position = Vector3.new(-103.12, 3.64, -8.3)
Linear.DetectorCounter1.Color = Color3.fromRGB(0, 0, 0)
Linear.DetectorCounter1.Size = Vector3.new(7, 7, 7)
Linear.DetectorCounter1.Transparency = 1
Linear.DetectorCounter1.CanCollide = false
Linear.DetectorCounter1.Anchored = true
Linear.DetectorCounter1.Parent = workspace

Linear.DetectorCounter2 = Instance.new("Part")
Linear.DetectorCounter2.Name = "linear's second counter area detector, DO NOT DELETE"
Linear.DetectorCounter2.Position = Vector3.new(-92.1, 3.64, 7.7)
Linear.DetectorCounter2.Color = Color3.fromRGB(0, 0, 0)
Linear.DetectorCounter2.Size = Vector3.new(7, 7, 7)
Linear.DetectorCounter2.Transparency = 1
Linear.DetectorCounter2.CanCollide = false
Linear.DetectorCounter2.Anchored = true
Linear.DetectorCounter2.Parent = workspace

Linear.DetectorRoom6 = Instance.new("Part")
Linear.DetectorRoom6.Name = "linear's room6 area detector, DO NOT DELETE"
Linear.DetectorRoom6.Position = Vector3.new(-182.4, 2.2, 54.7)
Linear.DetectorRoom6.Color = Color3.fromRGB(0, 0, 0)
Linear.DetectorRoom6.Size = Vector3.new(4, 8, 4)
Linear.DetectorRoom6.Transparency = 1
Linear.DetectorRoom6.CanCollide = false
Linear.DetectorRoom6.Anchored = true
Linear.DetectorRoom6.Parent = workspace

Linear.Modules = {
	Cutscenes = require(PlayerScripts.UI.Cutscenes),
	Lib = require(ReplicatedStorage.Lib),
	Shadow = require(ReplicatedStorage.AnomalyEvents.Local.ShadowCamera)
}

Linear.Items = {}

for fart, descendant in ipairs(Workspace:GetDescendants()) do
	for fart, name in ipairs({"Bandages", "Ointment", "Thermo", "Medkit", "IV Drops", "Eye Drops", "Herbs", "Medicine", "Cough Syrup", "Maple Syrup", "Transplant", "Scissors", "Scalpel", "Organ"}) do
		if descendant.Name == name and not Linear.Items[name] then
			if descendant:IsA("Model") or descendant:IsA("BasePart") then
				Linear.Items[name] = descendant
			end
		end
	end
end

Linear.Remotes = {
	Sanity = ReplicatedStorage.Util.Net["RE/PlayerLostSanity"],
	ExtNPC = ReplicatedStorage.Util.Net["RE/ExtinguisherBubbleHitFireNPC"],
	ExtGhost = ReplicatedStorage.Util.Net["RE/ExtinguisherBubbleHitGhost"],
	ExtHider = ReplicatedStorage.Util.Net["RE/ExtinguisherBubbleHitHider"],
	ExtFire = ReplicatedStorage.Util.Net["RE/ExtinguisherBubbleHit"],
	ExtSlime = ReplicatedStorage.Util.Net["RE/ExtinguisherBubbleHitGrime"],
	HeartbeatMinigameComplete = ReplicatedStorage.Util.Net["RE/HeartbeatMinigameComplete"]
}

Linear.Rooms = {
	Room1 = workspace.Rooms.Medical.Room1,
	Room2 = workspace.Rooms.Medical.Room2,
	Room3 = workspace.Rooms.Medical.Room3,
	Room4 = workspace.Rooms.Medical.Room4,
	Room5 = workspace.Rooms.Medical.Room5,
	Room6 = workspace.Rooms.Emergency.Room6,
	Room7 = workspace.Rooms.Emergency.Room7,
	Room8 = workspace.Rooms.Emergency.Room8
}

Linear.Utils.GameLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/animalhospital/library.lua"))()

-- Creating more global references for the ui
Linear.WindUI = loadstring(game:HttpGet("https://pastefy.app/5GJr5qXw/raw"))()

--[[ Old theme !!
Linear.WindUI:AddTheme({
    Name = "Tone",
    Accent = Color3.fromHex("#000000"),
    Background = Color3.fromHex("#111111"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#101010"),
    Icon = Color3.fromHex("#a1a1aa"),
})
]]

Linear.Window = Linear.WindUI:CreateWindow({
    Title = "linear | Animal Hospital",
    Icon = Fertilizer.CustomImage({link = "https://raw.githubusercontent.com/christmas-cookie/linear/refs/heads/main/assets/image/icon.png"}),
    Folder = "linear",
    NewElements = true,
    SearchBar = true,
    Size = UDim2.fromOffset(550, 320),
    Transparent = true, 
    Theme = "Plant",
    User = {
        Enabled = true,
        Anonymous = false, 
    }, 
    OpenButton = {
		Title = "Open linear",
		CornerRadius = UDim.new(1, 0),
		StrokeThickness = 2,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.67,
		Color = ColorSequence.new(
			Color3.fromHex("#1B362F"),
			Color3.fromHex("#13A777")
		),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},    
})

-- creating the version tag
Linear.Window:Tag({
    Title = "LINEAR_TESTER_2",
    Icon = "github",
})

Linear.Notify = function(desc, duration, icon)
	Linear.WindUI:Notify({
	    Title = "linear",
	    Content = desc or "Oops! something was meant to be in this notification, but there isn't, please report this to a developer!",
	    Icon = icon or "bell",
	    Duration = duration or 5,
	})
end

-- Running the intro 
task.spawn(Intro.Start, Intro)

Linear:Print("Initialization loaded.")