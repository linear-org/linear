local Intro = {}

local fertilizer = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/fertilizer.lua"))()
local tweenservice = game:GetService("TweenService")

local linear = getgenv().Linear

local function waitfor(condition, timeout)
    local t = 0
    while not condition() do
        task.wait(0.05)
        t += 0.05
        if timeout and t >= timeout then
            linear:Warn("waitfor timeout")
            return false
        end
    end
    return true
end

function Intro:Start()
    local audio = Instance.new("Sound")
    audio.Name = "audio"
    audio.Parent = game:GetService("SoundService")

    local audioasset = fertilizer.CustomAudio({
        link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/audio/booting.mp3",
        path = audio,
        looped = false,
        volume = 1
    })

    if not audioasset then
        linear:Warn("audio failed to load")
    end

    audio.Ended:Once(function()
        audio:Destroy()
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "Intro"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9998
    gui.Parent = gethui and gethui() or game:GetService("CoreGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.ZIndex = 9999
    bg.Parent = gui

    tweenservice:Create(
        bg,
        TweenInfo.new(0.2),
        {BackgroundTransparency = 0}
    ):Play()

    task.wait(0.2)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0.15, 0, 0.15, 0)
    icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.ZIndex = 10001
    icon.Parent = bg

    icon.Image = fertilizer.CustomImage({
        link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/image/icon.png",
        path = icon
    }) or ""

    Instance.new("UIAspectRatioConstraint", icon).AspectRatio = 1

    local startvideo = Instance.new("VideoFrame")
    startvideo.Size = UDim2.new(0.15, 0, 0.15, 0)
    startvideo.Position = UDim2.new(0.5, 0, 0.5, 0)
    startvideo.AnchorPoint = Vector2.new(0.5, 0.5)
    startvideo.BackgroundTransparency = 1
    startvideo.ZIndex = 10002
    startvideo.Parent = bg

    Instance.new("UIAspectRatioConstraint", startvideo).AspectRatio = 1

    local startasset = fertilizer.CustomVideo({
        link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/video/Intro.webm",
        path = startvideo,
        looped = false
    })

    if not startasset then
        linear:Warn("start video failed")
        startvideo:Destroy()
    else
        waitfor(function()
            return startvideo.TimeLength and startvideo.TimeLength > 0
        end, 5)

        waitfor(function()
            return startvideo.TimePosition >= (startvideo.TimeLength - 0.1)
        end)
    end

    waitfor(function()
        return linear.Loaded == true
    end, 9)

    local endvideo = Instance.new("VideoFrame")
    endvideo.Size = UDim2.new(0.15, 0, 0.15, 0)
    endvideo.Position = UDim2.new(0.5, 0, 0.5, 0)
    endvideo.AnchorPoint = Vector2.new(0.5, 0.5)
    endvideo.BackgroundTransparency = 1
    endvideo.ZIndex = 10003
    endvideo.Parent = bg

    Instance.new("UIAspectRatioConstraint", endvideo).AspectRatio = 1

    local endasset = fertilizer.CustomVideo({
        link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/video/outro.webm",
        path = endvideo,
        looped = false
    })

    if not endasset then
        linear:Warn("outro video failed")
        endvideo:Destroy()
    else
        waitfor(function()
            return endvideo.TimePosition > 0
        end, 5)
    end

    startvideo.Visible = false
    icon.Visible = false

    task.wait(1)

    if startvideo then startvideo:Destroy() end
    if icon then icon:Destroy() end
    if endvideo then endvideo:Destroy() end

    local fadeOutTween = tweenservice:Create(bg, TweenInfo.new(0.3), {
        BackgroundTransparency = 1
    })
    fadeOutTween:Play()
    fadeOutTween.Completed:Wait()

    gui:Destroy()
end

return Intro
