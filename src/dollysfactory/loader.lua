local paths = {
    "src/Library.lua",
    "src/dollysfactory/tabs/Init.lua",
    "src/dollysfactory/tabs/Main.lua",
    "src/dollysfactory/tabs/Player.lua",
    "src/dollysfactory/tabs/Automation.lua",
    "src/dollysfactory/tabs/InitFinal.lua"
}

local base = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/"
for fart, path in ipairs(paths) do
    loadstring(game:HttpGet(base .. path, true))()
end

local Linear = getgenv().Linear
Linear:Inform("Loaded successfully.")
