local Morpher = {}

Morpher.Maid = {}
Morpher.States = {}

function Morpher.Unmorph(player)
	Morpher.Maid[player] = nil
	local state = Morpher.States[player]
	if state then
		for part, data in pairs(state) do
			if part and part.Parent then
				part.Transparency = data.transparency
				if part.Name ~= "HumanoidRootPart" then
					part.CanCollide = data.cancollide
				end
			end
		end
		Morpher.States[player] = nil
	end
end

function Morpher.Morph(player, npc)
	Morpher.Unmorph(player)
	local character = player.Character
	if not character then return end
	local model = character:FindFirstChild("CharacterModel")
	if not model then return end
	local controller = model:FindFirstChildOfClass("AnimationController")
	if not controller then return end
	local animator = controller:FindFirstChildOfClass("Animator") or controller
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local playermaid = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/maid.lua"))().new()
	Morpher.Maid[player] = playermaid
	local state = {}
	Morpher.States[player] = state
	for fart, object in ipairs(model:GetDescendants()) do
		if object:IsA("BasePart") then
			state[object] = {
				transparency = object.Transparency,
				cancollide = object.CanCollide
			}
			object.Transparency = 1
			object.CanCollide = false
		elseif object:IsA("Decal") or object:IsA("Texture") then
			state[object] = {
				transparency = object.Transparency
			}
			object.Transparency = 1
		end
	end
	local clone = npc:Clone()
	playermaid:GiveTask(clone)
	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:Destroy()
	end
	local targetcontroller = clone:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController", clone)
	local targetanimator = targetcontroller:FindFirstChildOfClass("Animator") or Instance.new("Animator", targetcontroller)
	local cloneroot = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
	if not cloneroot then clone:Destroy() return end
	clone.Parent = character
	cloneroot.CFrame = root.CFrame
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = cloneroot
	weld.Parent = cloneroot
	for fart, part in ipairs(clone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Anchored = false
		end
	end
	local anims = {}
	local function sync(anim)
		if anims[anim] then return end
		local animation = Instance.new("Animation")
		animation.AnimationId = anim.Animation.AnimationId
		local success, morphanim = pcall(function()
			return targetanimator:LoadAnimation(animation)
		end)
		if success and morphanim then
			anims[anim] = morphanim
			if anim.IsPlaying then
				morphanim:Play(0, anim.WeightTarget, anim.Speed)
				morphanim.TimePosition = anim.TimePosition
			end
			playermaid:GiveTask(anim:GetPropertyChangedSignal("Speed"):Connect(function()
				morphanim:AdjustSpeed(anim.Speed)
			end))
			playermaid:GiveTask(anim:GetPropertyChangedSignal("WeightTarget"):Connect(function()
				morphanim:AdjustWeight(anim.WeightTarget)
			end))
			playermaid:GiveTask(anim.Stopped:Connect(function()
				morphanim:Stop()
				anims[anim] = nil
			end))
		end
	end
	for fart, anim in ipairs(animator:GetPlayingAnimationTracks()) do
		sync(anim)
	end
	playermaid:GiveTask(animator.AnimationPlayed:Connect(sync))
end

return Morpher
