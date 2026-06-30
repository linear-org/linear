local textchatservice = game:GetService("TextChatService")
local rbxsystem = textchatservice:WaitForChild("TextChannels"):WaitForChild("RBXSystem")

local function chat(from, what, fromcolor, whatcolor)
    local msg = string.format("<font color='rgb(%.0f,%.0f,%.0f)'>[%s]:</font> <font color='rgb(%.0f,%.0f,%.0f)'>%s</font>", fromcolor.R * 255, fromcolor.G * 255, fromcolor.B * 255, from, whatcolor.R * 255, whatcolor.G * 255, whatcolor.B * 255, what)
    rbxsystem:DisplaySystemMessage(msg)
end

if game.PlaceId == 72515936648142 then
    chat("linear", "This game is supported! ‘Dolly's Factory: In-Game’, loading the script..", Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 255, 255))
    loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/dollysfactory/loader.lua"))()
else
    chat("linear", "This game isn't supported..", Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 255, 255))
end
