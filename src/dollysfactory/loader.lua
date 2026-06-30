local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/Library.lua"))()
local init = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/dollysfactory/tabs/Init.lua"))()
local main = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/dollysfactory/tabs/Main.lua"))()
local player = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/dollysfactory/tabs/Player.lua"))()
local automation = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/dollysfactory/tabs/Automation.lua"))()
local initfinal = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/dollysfactory/tabs/InitFinal.lua"))()

local Linear = getgenv().Linear
Linear:Inform("Loaded successfully.")
