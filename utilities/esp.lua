local Maid = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua"))()

local ESP = {}
local Actives = {}

local Settings = {
	FrameSize = 1,
	Highlights = true,
	HighlightOutlineTransparency = 0.2,
	HighlightFillTransparency = 0.6,
	Billboards = true,
	DefaultColor = Color3.fromRGB(0, 0, 0)
}

local function CanDivider(Active)
	local Count = 0
	for fart in pairs(Active.Tags) do
		Count = Count + 1
	end
	if Active.Divider then
		Active.Divider.Visible = (Count > 0)
	end
end

function ESP:Add(Data)
	local TargetInstance = Data.Instance
	if not TargetInstance then return end
	ESP:Remove({ InstanceOrFlag = TargetInstance })
	local ActiveMaid = Maid.new()
	local Active = {
		Instance = TargetInstance,
		Flag = Data.Flag,
		Color = Data.Color or Settings.DefaultColor,
		Tags = {},
		CustomName = Data.CustomName or TargetInstance.Name,
		Maid = ActiveMaid
	}
	
	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "linear's billboard"
	Billboard.AlwaysOnTop = true
	Billboard.Brightness = 1
	Billboard.StudsOffset = -3
	Billboard.LightInfluence = 0
	Billboard.MaxDistance = math.huge
	Billboard.ResetOnSpawn = true
	Billboard.Size = UDim2.new(0, 2000, 0, 2000)
	Billboard.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Billboard.Enabled = Settings.Billboards
	Billboard.Adornee = TargetInstance
	Billboard.Parent = TargetInstance
	ActiveMaid:GiveTask(Billboard)
	Active.Billboard = Billboard
	
	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.BackgroundTransparency = 1
	Container.AnchorPoint = Vector2.new(0.5, 0.5)
	Container.Position = UDim2.new(0.5, 0, 0.5, 0)
	Container.Size = UDim2.new(1, 0, 1, 0)
	Container.Style = Enum.FrameStyle.Custom
	Container.Parent = Billboard
	Active.Container = Container
	
	local UiScale = Instance.new("UIScale")
	UiScale.Name = "UIScale"
	UiScale.Scale = Settings.FrameSize
	UiScale.Parent = Container
	Active.UIScale = UiScale

	local UiListLayout = Instance.new("UIListLayout")
	UiListLayout.Name = "UIListLayout"
	UiListLayout.FillDirection = Enum.FillDirection.Vertical
	UiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UiListLayout.Padding = UDim.new(0, 0)
	UiListLayout.Parent = Container
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.SourceSansSemibold
	Title.LayoutOrder = 0
	Title.Size = UDim2.new(0, 0, 0, 20)
	Title.AutomaticSize = Enum.AutomaticSize.X
	Title.Text = Active.CustomName
	Title.TextColor3 = Active.Color
	Title.TextScaled = false
	Title.TextSize = 22
	Title.TextWrapped = false
	Title.TextXAlignment = Enum.TextXAlignment.Center
	Title.TextYAlignment = Enum.TextYAlignment.Center
	Title.TextStrokeColor3 = Color3.new(0, 0, 0)
	Title.TextStrokeTransparency = 0
	Title.Parent = Container
	Active.Title = Title
	
	local Divider = Instance.new("Frame")
	Divider.Name = "Divider"
	Divider.BackgroundColor3 = Active.Color
	Divider.BorderSizePixel = 0
	Divider.LayoutOrder = 1
	Divider.AnchorPoint = Vector2.new(0.5, 1)
	Divider.Position = UDim2.new(0.55, 0, 1.1, 0)
	Divider.Size = UDim2.new(1.1, 0, 0.059, 0)
	Divider.Style = Enum.FrameStyle.Custom
	Divider.Visible = false
	Divider.Parent = Title
	Active.Divider = Divider
	
	local UiStroke = Instance.new("UIStroke")
	UiStroke.Name = "UIStroke"
	UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	UiStroke.Color = Color3.new(0, 0, 0)
	UiStroke.Thickness = 0.5
	UiStroke.LineJoinMode = Enum.LineJoinMode.Round
	UiStroke.Parent = Divider
	
	local TagsFrame = Instance.new("Frame")
	TagsFrame.Name = "Tags"
	TagsFrame.BackgroundTransparency = 1
	TagsFrame.Size = UDim2.new(1, 0, 0, 0)
	TagsFrame.AutomaticSize = Enum.AutomaticSize.Y
	TagsFrame.LayoutOrder = 4
	TagsFrame.Style = Enum.FrameStyle.Custom
	TagsFrame.Parent = Container
	Active.TagsFrame = TagsFrame

	local TagsListLayout = Instance.new("UIListLayout")
	TagsListLayout.Name = "UIListLayout"
	TagsListLayout.FillDirection = Enum.FillDirection.Vertical
	TagsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TagsListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	TagsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TagsListLayout.Padding = UDim.new(0, -3)
	TagsListLayout.Parent = TagsFrame

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "linear's highlight"
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.FillColor = Active.Color
	Highlight.OutlineColor = Active.Color
	Highlight.FillTransparency = Settings.HighlightFillTransparency
	Highlight.OutlineTransparency = Settings.HighlightOutlineTransparency
	Highlight.Enabled = Settings.Highlights
	Highlight.Adornee = TargetInstance
	Highlight.Parent = TargetInstance
	ActiveMaid:GiveTask(Highlight)
	Active.Highlight = Highlight
	
	table.insert(Actives, Active)
end

function ESP:Remove(Data)
	local Target = Data.InstanceOrFlag
	if not Target then return end
	for Index = #Actives, 1, -1 do
		local Active = Actives[Index]
		if Active.Instance == Target or Active.Flag == Target then
			Active.Maid:Clean()
			table.remove(Actives, Index)
		end
	end
end

function ESP:Tag(Data)
	local Target = Data.InstanceOrFlag
	if not Target then return end
	for fart, Active in ipairs(Actives) do
		if Active.Instance == Target or Active.Flag == Target then
			if Active.Tags[Data.Flag] then
				Active.Tags[Data.Flag]:Destroy()
			end
			local TagLabel = Instance.new("TextLabel")
			TagLabel.Name = "Tag_Example"
			TagLabel.BackgroundTransparency = 1
			TagLabel.Font = Enum.Font.SourceSans
			TagLabel.LayoutOrder = 3
			TagLabel.Size = UDim2.new(0, 700, 0, 20)
			TagLabel.Text = Data.Name
			TagLabel.TextColor3 = Active.Color
			TagLabel.TextScaled = true
			TagLabel.TextWrapped = true
			TagLabel.TextXAlignment = Enum.TextXAlignment.Center
			TagLabel.TextYAlignment = Enum.TextYAlignment.Center
			TagLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			TagLabel.TextStrokeTransparency = 0
			TagLabel.Parent = Active.TagsFrame
			Active.Maid:GiveTask(TagLabel)
			Active.Tags[Data.Flag] = TagLabel
			CanDivider(Active)
		end
	end
end

function ESP:UpdateTag(Data)
	local TagFlag = Data.Tag
	if not TagFlag then return end
	for fart, Active in ipairs(Actives) do
		local TagLabel = Active.Tags[TagFlag]
		if TagLabel then
			TagLabel.Text = Data.Update
		end
	end
end

function ESP:DeleteTag(Data)
	local TagFlag = Data.Tag
	if not TagFlag then return end
	for fart, Active in ipairs(Actives) do
		local TagLabel = Active.Tags[TagFlag]
		if TagLabel then
			TagLabel:Destroy()
			Active.Tags[TagFlag] = nil
			CanDivider(Active)
		end
	end
end

function ESP:Recolor(Data)
	local Target = Data.InstanceOrFlag
	local NewColor = Data.Color
	if not Target or not NewColor then return end
	for fart, Active in ipairs(Actives) do
		if Active.Instance == Target or Active.Flag == Target then
			Active.Color = NewColor
			if Active.Title then Active.Title.TextColor3 = NewColor end
			if Active.Divider then Active.Divider.BackgroundColor3 = NewColor end
			if Active.Highlight then
				Active.Highlight.FillColor = NewColor
				Active.Highlight.OutlineColor = NewColor
			end
			for fart, TagLabel in pairs(Active.Tags) do
				TagLabel.TextColor3 = NewColor
			end
		end
	end
end

function ESP:Settings(Data)
	if Data.FrameSize ~= nil then Settings.FrameSize = Data.FrameSize end
	if Data.Highlights ~= nil then Settings.Highlights = Data.Highlights end
	if Data.HighlightOutlineTransparency ~= nil then Settings.HighlightOutlineTransparency = Data.HighlightOutlineTransparency end
	if Data.HighlightFillTransparency ~= nil then Settings.HighlightFillTransparency = Data.HighlightFillTransparency end
	if Data.Billboards ~= nil then Settings.Billboards = Data.Billboards end
	for fart, Active in ipairs(Actives) do
		if Active.UIScale then Active.UIScale.Scale = Settings.FrameSize end
		if Active.Billboard then Active.Billboard.Enabled = Settings.Billboards end
		if Active.Highlight then
			Active.Highlight.Enabled = Settings.Highlights
			Active.Highlight.OutlineTransparency = Settings.HighlightOutlineTransparency
			Active.Highlight.FillTransparency = Settings.HighlightFillTransparency
		end
	end
end

return ESP
