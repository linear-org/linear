local Maid = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua"))()
local Visualizer = {}

function Visualizer.new()
	local Self = {}
	local SelfMaid = Maid.new()
	local Highlight = nil
	local Billboard = nil
	local Label = nil
	
	function Self.Visualize(Data)
		local target = Data.Instance
		if not target then return end
		local color = Data.color or Color3.fromRGB(255, 0, 0)		
		if not Highlight or not Billboard then
			Self.Stop()
			Highlight = Instance.new("Highlight")
			Highlight.Name = "linear's visualizer highlight"
			Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			Highlight.FillColor = color
			Highlight.OutlineColor = color
			Highlight.FillTransparency = 0.5
			Highlight.OutlineTransparency = 0
			Highlight.Adornee = target
			Highlight.Parent = workspace
			SelfMaid:GiveTask(Highlight)
			Billboard = Instance.new("BillboardGui")
			Billboard.Name = "linear's visualizer billboard"
			Billboard.AlwaysOnTop = true
			Billboard.Brightness = 1
			Billboard.LightInfluence = 0
			Billboard.MaxDistance = math.huge
			Billboard.ResetOnSpawn = false
			Billboard.Size = UDim2.new(4, 0, 3, 0)
			Billboard.ZIndexBehavior = Enum.ZIndexBehavior.Global
			Billboard.Adornee = target
			Billboard.StudsOffset = Vector3.new(0, 5, 0)
			Billboard.Parent = workspace
			SelfMaid:GiveTask(Billboard)			
			local TargetLabel = Instance.new("TextLabel")
			TargetLabel.Name = "target"
			TargetLabel.BackgroundTransparency = 1
			TargetLabel.Size = UDim2.new(1, 0, 1, 0)
			TargetLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			TargetLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			TargetLabel.Font = Enum.Font.Arcade
			TargetLabel.Text = "TARGET\nV"
			TargetLabel.TextColor3 = color
			TargetLabel.TextScaled = true
			TargetLabel.TextWrapped = true
			TargetLabel.TextXAlignment = Enum.TextXAlignment.Center
			TargetLabel.TextYAlignment = Enum.TextYAlignment.Center
			TargetLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			TargetLabel.TextStrokeTransparency = 0
			TargetLabel.Parent = Billboard
			Label = TargetLabel
		else
			Highlight.Adornee = target
			Highlight.FillColor = color
			Highlight.OutlineColor = color
			Billboard.Adornee = target
			Label.TextColor3 = color
		end
	end

	function Self.Stop()
		SelfMaid:Clean()
		Highlight = nil
		Billboard = nil
		Label = nil
	end

	function Self.Destroy()
		Self.Stop()
		table.clear(Self)
	end

	return Self
end

return Visualizer
