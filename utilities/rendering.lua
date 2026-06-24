local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Maid = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua"))().new()

local Rendering = {}
local activeids = {}

function Rendering:Set(bool, id)
	if bool then
		activeids[id] = true
	else
		activeids[id] = nil
	end

	local hasactive = next(activeids) ~= nil
	pcall(function() RunService:Set3dRenderingEnabled(not hasactive) end)

	if hasactive then
		local parent = (gethui and gethui()) or CoreGui
		if not Maid.screengui or Maid.screengui.Parent ~= parent or not Maid.frame or Maid.frame.Parent ~= Maid.screengui then
			Maid:Clean()

			local screengui = Instance.new("ScreenGui")
			screengui.ScreenInsets = Enum.ScreenInsets.None
			screengui.DisplayOrder = -1
			screengui.Name = "linear, no render"
			screengui.ResetOnSpawn = false

			local frame = Instance.new("Frame")
			frame.Name = "linear"
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.new(0, 0, 0)
			frame.BorderSizePixel = 0
			frame.Parent = screengui

			Maid.screengui = screengui
			Maid.frame = frame

			Maid.scra = screengui.AncestryChanged:Connect(function()
				if next(activeids) and screengui.Parent ~= parent then
					Rendering:Set(true, next(activeids))
				end
			end)

			Maid.fma = frame.AncestryChanged:Connect(function()
				if next(activeids) and frame.Parent ~= screengui then
					Rendering:Set(true, next(activeids))
				end
			end)

			Maid.scre = screengui:GetPropertyChangedSignal("Enabled"):Connect(function()
				if next(activeids) and not screengui.Enabled then
					screengui.Enabled = true
				end
			end)

			Maid.fmv = frame:GetPropertyChangedSignal("Visible"):Connect(function()
				if next(activeids) and not frame.Visible then
					frame.Visible = true
				end
			end)

			Maid.fms = frame:GetPropertyChangedSignal("Size"):Connect(function()
				if next(activeids) and frame.Size ~= UDim2.new(1, 0, 1, 0) then
					frame.Size = UDim2.new(1, 0, 1, 0)
				end
			end)

			Maid.fmc = frame:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
				if next(activeids) and frame.BackgroundColor3 ~= Color3.new(0, 0, 0) then
					frame.BackgroundColor3 = Color3.new(0, 0, 0)
				end
			end)

			screengui.Parent = parent
		end
	else
		Maid:Clean()
	end
end

return Rendering
