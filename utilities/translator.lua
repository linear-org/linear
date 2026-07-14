local url = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/translations/"

local Linear = getgenv().Linear
local language = Linear.Language

local english = {}
local fbsuccess, fboutput = pcall(function()
    return loadstring(game:HttpGet(url .. "English.lua"))()
end)

if fbsuccess and type(fboutput) == "table" then
    english = fboutput
end

local selected = {}
local success, output = pcall(function()
    return loadstring(game:HttpGet(url .. language .. ".lua"))()
end)

if success and type(output) == "table" then
    selected = output
end

local translator = {}

function translator:Translate(key)
    if selected[key] ~= nil then
        return selected[key]
    end
    if english[key] ~= nil then
        return english[key]
    end
    return key
end

return translator
