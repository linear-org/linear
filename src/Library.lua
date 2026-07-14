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

Linear.Loaded = Linear.Loaded or false
Linear.Prefix = "linear ."

local executions = "linear/executions"
local count = isfile(executions) and tonumber(readfile(executions)) or 0
writefile(executions, tostring(count + 1))

function Linear.GetExecutions()
    return isfile(executions) and tonumber(readfile(executions)) or 0
end

function Linear:Print(...)
    print(self.Prefix, ...)
end

function Linear:Warn(...)
    warn(self.Prefix, ...)
end

function Linear:Error(...)
    error(self.Prefix .. " " .. table.concat({...}, " "), 2)
end

Linear.FireNowAndOnAttributeChanged = function(instance, attribute, callback)
    callback()
    return instance:GetAttributeChangedSignal(attribute):Connect(callback)
end

Linear.FireNowAndOnChildAdded = function(instance, callback)
    callback()
    return instance.ChildAdded:Connect(callback)
end

Linear.ToTable = function(input)
    if type(input) == "table" then
        return input
    end
    return {input}
end

Linear.Utils = {}
Linear.Utils.Maid = Linear.Utils.Maid or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua"))().new()
Linear.Utils.Fertilizer = Linear.Utils.Fertilizer or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/fertilizer.lua"))()
Linear.Utils.Translator = Linear.Utils.Translator or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/translator.lua"))()
Linear.Utils.Renderer = Linear.Utils.Renderer or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/rendering.lua"))()
Linear.Utils.Scrambler = Linear.Utils.Scrambler or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/scrambler.lua"))()
Linear.Utils.Intro = Linear.Utils.Intro or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/intro.lua"))()
Linear.Utils.Esp = Linear.Utils.Esp or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/esp.lua"))()
Linear.Utils.Visualizer = Linear.Utils.Visualizer or loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/visualizer.lua"))()

Linear.Originals = {}
Linear.Values = {}
Linear.Sections = {}
Linear.Tabs = {}
Linear.Elements = {}

Linear.FreeDonorDay = false
Linear.IsDonor = false

if loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/values/freedonorday.lua"))() == true then
	Linear.FreeDonorDay = true
end

return Linear
