local library = {}
library.Items = {}

local vfx = workspace:FindFirstChild("VFX")
local players = game:GetService("Players")
local player = players.LocalPlayer

function library.Items.GetItemsOnFloor()
	local items = {}
	local children = vfx:GetChildren()
	local found = false
	for fart, child in ipairs(children) do
		if child:IsA("Model") then
			local prompt = child:FindFirstChildOfClass("ProximityPrompt")
			if prompt then
				found = true
				items[prompt.ActionText] = {
					Name = child.Name,
					Path = child
				}
			end
		end
	end
	if not found then
		warn("linear DF library | couldn't find any items on the floor")
	end
	return items
end

function library.Items.PickItem(obj)
	if not obj or not obj:IsA("Model") then return end
	local part = obj:FindFirstChildWhichIsA("BasePart")
	local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
	if not prompt then
		warn("linear DF library | couldn't find a prompt for the item: " .. tostring(obj.Name))
		return
	end
	if part and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = part.CFrame
			task.wait(0.1)
			if fireproximityprompt then
				fireproximityprompt(prompt)
			else
				warn("linear DF library | fireproximityprompt is not supported..")
			end
		end
	end
end

function library.Items.PickItemByName(name)
	local children = vfx:GetChildren()
	local found = false
	for fart, child in ipairs(children) do
		if child:IsA("Model") then
			local prompt = child:FindFirstChildOfClass("ProximityPrompt")
			if prompt and prompt.ActionText == name then
				found = true
				library.Items.PickItem(child)
				break
			end
		end
	ens
	if not found then
		warn("linear DF library | couldn't find any item with the name “" .. name .. "” on the floor.")
	end
end

function library.Items.OnItemAdded(callback)
	return vfx.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			local prompt = child:FindFirstChildOfClass("ProximityPrompt") or child:WaitForChild("ProximityPrompt", 1)
			local name = prompt and prompt.ActionText or "Unknown Item"
			local rarity = child.Name
			local path = child			
			callback(name, rarity, path)
		end
	end)
end

return library
