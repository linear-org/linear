local TestService = game:GetService("TestService")

if not getgenv().Linear then
    getgenv().Linear = {}
end

local Linear = getgenv().Linear

local folders = {"linear", "linear/audios", "linear/videos", "linear/images"}

for _, folder in ipairs(folders) do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

Linear.Language = Linear.Language or "English"
Linear.Loaded = Linear.Loaded or false
Linear.UI = Linear.UI or nil

Linear.Tabs = Linear.Tabs or {}
Linear.Utils = Linear.Utils or {}

Linear.Prefix = "linear |"

function Linear:Print(...)
    print(self.Prefix, ...)
end

function Linear:Warn(...)
    warn(self.Prefix, ...)
end

function Linear:Error(...)
    error(self.Prefix .. " " .. table.concat({...}, " "), 2)
end

function Linear:Inform(...)
    TestService:Message(self.Prefix .. " " .. table.concat({...}, " "))
end

function Linear:Banner(...)
    print(...)
end

Linear.Utils.Maid = Linear.Utils.Maid or safeloadstring("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua")
Linear.Utils.Fertilizer = Linear.Utils.Fertilizer or safeloadstring("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/fertilizer.lua")
Linear.Utils.Translator = Linear.Utils.Translator or safeloadstring("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/translator.lua")
Linear.Utils.Renderer = Linear.Utils.Renderer or safeloadstring("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/rendering.lua")
Linear.Utils.Scrambler = Linear.Utils.Scrambler or safeloadstring("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/scrambler.lua")
Linear.Utils.Intro = Linear.Utils.Intro or safeloadstring("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/intro.lua")

return Linear
