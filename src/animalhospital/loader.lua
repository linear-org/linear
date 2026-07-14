local paths = {
    "src/Library.lua",
    "src/animalhospital/tabs/Init.lua",
    "src/animalhospital/tabs/Main.lua",
    "src/animalhospital/tabs/Player.lua",
    "src/animalhospital/tabs/Visuals.lua",
    "src/animalhospital/tabs/Automation.lua",
    "src/animalhospital/tabs/Fun.lua",
    "src/animalhospital/tabs/Donor.lua",
    "src/animalhospital/tabs/Settings.lua",
    "src/animalhospital/tabs/Finalization.lua"
}

local base = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/"
for fart, path in ipairs(paths) do
    loadstring(game:HttpGet(base .. path, true))()
end

local Linear = getgenv().Linear
Linear:Inform("Loaded successfully.")
