local TestService = game:GetService("TestService")

if not getgenv().Linear then
    getgenv().Linear = {}
end

local Linear = getgenv().Linear
local folders = {"linear", "linear/audios", "linear/videos", "linear/images"}

for fart, folder in ipairs(folders) do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

Linear.Language = Linear.Language or "English"
Linear.Version = Linear.Version or "1.6.64-fix"

Linear.Loaded = Linear.Loaded or false
Linear.Prefix = "linear ."

function Linear:Print(...)
    print(self.Prefix, ...)
end

function Linear:Warn(...)
    warn(self.Prefix, ...)
end

function Linear:Error(...)
    error(self.Prefix .. " " .. table.concat({...}, " "), 2)
end

function Linear:Inform(...) -- deprecated function because delta doesn't support
    print(self.Prefix, ...)
end

Linear.Utils = {}
Linear.Utils.Maid = Linear.Utils.Maid or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua"))()
Linear.Utils.Fertilizer = Linear.Utils.Fertilizer or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/fertilizer.lua"))()
Linear.Utils.Translator = Linear.Utils.Translator or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/translator.lua"))()
Linear.Utils.Renderer = Linear.Utils.Renderer or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/rendering.lua"))()
Linear.Utils.Scrambler = Linear.Utils.Scrambler or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/scrambler.lua"))()
Linear.Utils.Intro = Linear.Utils.Intro or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/intro.lua"))()

Linear.Elements = {
    Player = {},
    Automation = {}
}
Linear.Values = {}
Linear.Tabs = {}

return Linear
