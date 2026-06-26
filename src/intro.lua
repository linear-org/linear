local intro = {}
local fertilizer = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/fertilizer.lua"))()
local tweenservice = game:GetService("TweenService")

local Linear = getgenv().Linear

function intro:Start()
	local audio = Instance.new("Sound")
	audio.Name = "audio"
	audio.Parent = game:GetService("SoundService")

	fertilizer.CustomAudio({
		link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/audio/booting.mp3",
		path = audio,
		looped = false,
		volume = 1
	})

	audio.Ended:Once(function()
		audio:Destroy()
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "intro"
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 9998
	gui.Parent = gethui and gethui() or game:GetService("CoreGui")

	local bg = Instance.new("Frame")
	bg.Name = "bg"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.ZIndex = 9999
	bg.Parent = gui

	local fadeinfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local bgfadein = tweenservice:Create(bg, fadeinfo, {BackgroundTransparency = 0})
	bgfadein:Play()

	task.wait(0.18)
	
	local startvideo = Instance.new("VideoFrame")
	startvideo.Name = "start"
	startvideo.Size = UDim2.new(0.15, 0, 0.15, 0)
	startvideo.Position = UDim2.new(0.5, 0, 0.5, 0)
	startvideo.AnchorPoint = Vector2.new(0.5, 0.5)
	startvideo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	startvideo.BackgroundTransparency = 0
	startvideo.BorderSizePixel = 0
	startvideo.ZIndex = 10002
	startvideo.Parent = bg

	local c1 = Instance.new("UIAspectRatioConstraint")
	c1.AspectRatio = 1
	c1.Parent = startvideo

	local icon = Instance.new("ImageLabel")
	icon.Name = "infinite"
	icon.Size = UDim2.new(0.15, 0, 0.15, 0)
	icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	icon.BackgroundTransparency = 0
	icon.ImageTransparency = 0
	icon.BorderSizePixel = 0
	icon.ZIndex = 10001
	icon.Parent = bg
	
	icon.Image = fertilizer.CustomImage({link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/image/icon.png"})

	local c2 = Instance.new("UIAspectRatioConstraint")
	c2.AspectRatio = 1
	c2.Parent = icon

	local endvideo = Instance.new("VideoFrame")
	endvideo.Name = "end"
	endvideo.Size = UDim2.new(0.15, 0, 0.15, 0)
	endvideo.Position = UDim2.new(0.5, 0, 0.5, 0)
	endvideo.AnchorPoint = Vector2.new(0.5, 0.5)
	endvideo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	endvideo.BackgroundTransparency = 0
	endvideo.BorderSizePixel = 0
	endvideo.ZIndex = 10000
	endvideo.Parent = bg

	local c3 = Instance.new("UIAspectRatioConstraint")
	c3.AspectRatio = 1
	c3.Parent = endvideo

	startvideo.Visible = true
	icon.Visible = true
	endvideo.Visible = true

	bgfadein.Completed:Wait()

	fertilizer.CustomVideo({
		link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/video/intro.webm",
		path = startvideo,
		looped = false,
		volume = 1
	})

	repeat task.wait() until startvideo.TimeLength > 0
	while startvideo.TimePosition < (startvideo.TimeLength - 0.05) do
		task.wait()
	end

	repeat task.wait() until Linear.Loaded == true

	endvideo.TimePosition = 0
	
	fertilizer.CustomVideo({
		link = "https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/assets/video/outro.webm",
		path = endvideo,
		looped = false,
		volume = 1
	})

	local outrovideo = endvideo:FindFirstChildOfClass("VideoFrame") or endvideo
	repeat task.wait() until outrovideo.TimePosition > 0

	startvideo.Visible = false
	icon.Visible = false

	task.wait(1.5)

	if startvideo and startvideo.Parent then startvideo:Destroy() end
	if icon and icon.Parent then icon:Destroy() end
	if endvideo and endvideo.Parent then endvideo:Destroy() end

	local fadeout = tweenservice:Create(bg, fadeinfo, {BackgroundTransparency = 1})
	fadeout:Play()
	fadeout.Completed:Wait()

	gui:Destroy()
end

return intro
