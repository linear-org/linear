-- bro coded this with a potato 🥔 🥔 🤑🤝
-- needs immediate rework now
-- 4:50 am idk what im doing

local maid = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/main/utilities/maid.lua"))()
local run = game:GetService("RunService")

local esp = {}
local bnds = {}
local insts = {}
local hb
local sets = {
    enabled = true,
    highlight = true,
    billboard = true,
    fill = 0.65,
    outline = 0.7,
    size = 12
}

local function apply(data)
    local hi = data.hi
    local bb = data.bb
    if hi then
        hi.Enabled = sets.enabled and sets.highlight
        hi.FillTransparency = sets.fill
        hi.OutlineTransparency = sets.outline
    end
    if bb then
        bb.Enabled = sets.enabled and sets.billboard
        for fart, v in ipairs(bb:GetDescendants()) do
            if v:IsA("TextLabel") then
                v.TextSize = sets.size
            end
        end
    end
end

local function refresh()
    for fart, data in pairs(insts) do
        apply(data)
    end
end

local function render(obj, cfg, data)
    if not data or not data.bb then return end
    local name = cfg.Name or obj.Name
    if cfg.NamingMethods and typeof(cfg.NamingMethods) == "function" then
        local res = cfg.NamingMethods(obj)
        if res then name = res end
    end
    data.tl.Text = name
    if cfg.Stats then
        for k, scfg in pairs(cfg.Stats) do
            local lbl = data.lbls[k]
            if lbl then
                local val = scfg.Value
                if scfg.ValueMethods and typeof(scfg.ValueMethods) == "function" then
                    local res = scfg.ValueMethods(obj)
                    if res ~= nil then val = res end
                end
                if scfg.UpdateWith and typeof(scfg.UpdateWith) == "function" then
                    local res = scfg.UpdateWith(obj)
                    if res ~= nil then val = res end
                end
                
                if val == nil or val == "" then
                    lbl.Visible = false
                else
                    lbl.Visible = true
                    lbl.Text = string.format("%s: %s", scfg.Name or k, tostring(val))
                end
            end
        end
    end
end

local function updatehb()
    if sets.enabled and next(insts) then
        if not hb then
            hb = run.Heartbeat:Connect(function()
                for obj, d in pairs(insts) do
                    render(obj, d.cfg, d)
                end
            end)
        end
    elseif hb then
        hb:Disconnect()
        hb = nil
    end
end

local function remove(obj)
    local data = insts[obj]
    if not data then return end
    data.md:Clean()
    insts[obj] = nil
    updatehb()
end

local function create(obj, cfg)
    if not obj or insts[obj] then return end
    
    local hd = obj
    if obj:IsA("Model") then
        hd = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart", true) or obj
    end
    
    local col = cfg.Color or Color3.fromRGB(255, 80, 80)
    local md = maid.new()
    local data = {cfg = cfg, lbls = {}, md = md}
    
    local hi = Instance.new("Highlight")
    hi.Name = "[linear] hl"
    hi.Adornee = obj
    hi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hi.FillColor = col
    hi.OutlineColor = col
    hi.Parent = obj
    data.hi = hi
    md:GiveTask(hi)
    
    local bb = Instance.new("BillboardGui")
    bb.Name = "[linear] bb"
    bb.Adornee = hd
    bb.Size = UDim2.new(12, 0, 3.5, 0)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = obj
    data.bb = bb
    md:GiveTask(bb)
    
    local vl = Instance.new("UIListLayout")
    vl.SortOrder = Enum.SortOrder.LayoutOrder
    vl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    vl.Padding = UDim.new(0.05, 0)
    vl.Parent = bb
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 0.3, 0)
    tl.BackgroundTransparency = 1
    tl.Font = Enum.Font.FredokaOne
    tl.TextColor3 = col
    tl.TextStrokeTransparency = 0
    tl.TextScaled = true
    tl.LayoutOrder = 1
    tl.Parent = bb
    data.tl = tl
    
    local gf = Instance.new("Frame")
    gf.Size = UDim2.new(1, 0, 0.65, 0)
    gf.BackgroundTransparency = 1
    gf.LayoutOrder = 2
    gf.Parent = bb
    
    local gd = Instance.new("UIGridLayout")
    gd.CellSize = UDim2.new(0.48, 0, 0.48, 0)
    gd.SortOrder = Enum.SortOrder.LayoutOrder
    gd.FillDirection = Enum.FillDirection.Horizontal
    gd.Parent = gf
    
    if cfg.Stats then
        local sk = {}
        for k in pairs(cfg.Stats) do
            table.insert(sk, k)
        end
        table.sort(sk)
        
        for i, k in ipairs(sk) do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.FredokaOne
            lbl.TextColor3 = col
            lbl.TextStrokeTransparency = 0
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextScaled = true
            lbl.LayoutOrder = i
            lbl.Parent = gf
            data.lbls[k] = lbl
        end
    end
    
    insts[obj] = data
    apply(data)
    render(obj, cfg, data)
    updatehb()
    
    md:GiveTask(obj.AncestryChanged:Connect(function(fart, p)
        if not p then remove(obj) end
    end))
end

function esp:BindESP(cfg)
    if not cfg or not cfg.Object then return cfg end
    local root = cfg.Object
    local md = maid.new()
    bnds[cfg] = {md = md}
    
    local function check(targ)
        if cfg.Children and targ == root then return end
        create(targ, cfg)
    end
    
    if not cfg.Children then
        check(root)
    else
        for fart, c in ipairs(root:GetChildren()) do check(c) end
        if cfg.ListenChildren then
            md:GiveTask(root.ChildAdded:Connect(check))
        end
        md:GiveTask(root.ChildRemoved:Connect(remove))
    end
    return cfg
end

function esp:UnbindESP(cfg)
    local bnd = bnds[cfg]
    if not bnd then return end
    bnd.md:Clean()
    if not cfg.Children then
        remove(cfg.Object)
    else
        for fart, c in ipairs(cfg.Object:GetChildren()) do remove(c) end
    end
    bnds[cfg] = nil
end

function esp:UpdateStat(cfg, name, val)
    if not cfg or not cfg.Stats or not cfg.Stats[name] then return end
    cfg.Stats[name].Value = val
    if not cfg.Children then
        local d = insts[cfg.Object]
        if d then render(cfg.Object, cfg, d) end
    else
        for fart, c in ipairs(cfg.Object:GetChildren()) do
            local d = insts[c]
            if d then render(c, cfg, d) end
        end
    end
end

function esp:Toggle(state) sets.enabled = state refresh() updatehb() end
function esp:SetBillboard(state) sets.billboard = state refresh() end
function esp:SetHighlight(state) sets.highlight = state refresh() end
function esp:SetFillTransparency(val) sets.fill = val refresh() end
function esp:SetOutlineTransparency(val) sets.outline = val refresh() end
function esp:SetTextSize(val) sets.size = val refresh() end

function esp:ClearAll()
    for cfg, fart in pairs(bnds) do
        self:UnbindESP(cfg)
    end
end

return esp
