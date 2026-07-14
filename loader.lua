local textchatservice = game:GetService("TextChatService")
local rbxsystem = textchatservice:WaitForChild("TextChannels"):WaitForChild("RBXSystem")

local function chat(from, what, fromcolor, whatcolor)
    local msg = string.format("<font color='rgb(%.0f,%.0f,%.0f)'>[%s]:</font> <font color='rgb(%.0f,%.0f,%.0f)'>%s</font>", fromcolor.R * 255, fromcolor.G * 255, fromcolor.B * 255, from, whatcolor.R * 255, whatcolor.G * 255, whatcolor.B * 255, what)
    rbxsystem:DisplaySystemMessage(msg)
end

if game.PlaceId == 78515283254292 or game.PlaceId == 104522435597696 then -- Animal hospital; Lobby, Run
    chat("linear", "I have recognized this game. I am now loading the script.", Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 255, 255))
    loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/src/animalhospital/loader.lua"))()
else
    chat("linear", "I couldn't recognize this game. I reject to load the script.", Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 255, 255))
end
