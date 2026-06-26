local library = {}
library.Items = {}
library.Machines = {}

local vfx = workspace:FindFirstChild("VFX")
local interacts = workspace:FindFirstChild("Interacts")
local players = game:GetService("Players")
local rst = game:GetService("ReplicatedStorage")
local player = players.LocalPlayer

local toolcontroller = require(player.PlayerScripts.Client.ToolClient)
local toolpackets = require(rst.Shared.ByteNetPackets.ToolPackets)

function library.Items.GetItemsOnFloor()
	if not vfx then return {} end
	local items = {}
	local children = vfx:GetChildren()
	for fart, child in ipairs(children) do
		if child:IsA("Part") then
			local prompt = child:FindFirstChildOfClass("ProximityPrompt")
			if prompt then
				table.insert(items, {
					Name = prompt.ActionText,
					Path = child,
					Rarity = child.Name
				})
			end
		end
	end
	if #items == 0 then
		warn("linear DF library | couldn't find any items on the floor")
	end
	return items
end

function library.Items.PickItem(obj)
	if not obj or not obj:IsA("Part") then return end
	local part = obj
	local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
	if not prompt then
		warn("linear DF library | couldn't find a prompt for the item: " .. tostring(obj.Name))
		return
	end
	if part and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = part.CFrame
			task.wait(0.2)
			if fireproximityprompt then
				fireproximityprompt(prompt)
			else
				warn("linear DF library | fireproximityprompt is not supported..")
			end
		end
	end
end

function library.Items.PickItemByName(name)
	if not vfx then return end
	local children = vfx:GetChildren()
	for fart, child in ipairs(children) do
		if child:IsA("Part") then
			local prompt = child:FindFirstChildOfClass("ProximityPrompt")
			if prompt and prompt.ActionText == name then
				library.Items.PickItem(child)
				break
			end
		end
	end
end

function library.Items.OnItemAdded(callback)
	if not vfx then return end
	return vfx.ChildAdded:Connect(function(child)
		if child:IsA("Part") then
			local prompt = child:FindFirstChildOfClass("ProximityPrompt") or child:WaitForChild("ProximityPrompt", 1)
			local Name = prompt and prompt.ActionText or "Unknown Item"
			local Rarity = child.Name
			local Path = child			
			callback(Name, Path, Rarity)
		end
	end)
end

function library.Items.EquipSlot(num)
	if not toolcontroller then return end
	if toolcontroller.equippedSlot ~= num then
		toolcontroller.ToggleEquipTool(num)
	end
end

function library.Items.DropEquipped()
	if not toolcontroller then return end
	toolcontroller.DropEquippedTool()
end

function library.Items.DropSlot(num)
	if toolpackets then
		local success, res = pcall(require, toolpackets)
		if success and res and res.dropTool then
			res.dropTool.send({
				slot = num
			})
		end
	end
end

function library.Items.UnequipEquipped()
	if not toolcontroller then return end
	local equipped = toolcontroller.equippedSlot
	if equipped then
		toolcontroller.ToggleEquipTool(equipped)
	end
end

function library.Machines.GetMachinesOnFloor()
	local machines = {}
	if not interacts then return machines end
	local children = interacts:GetChildren()
	for fart, child in ipairs(children) do
		if child:IsA("Model") then
			local machinetype = "Unknown Machine"
			if child.Name == "Plushie" then
				machinetype = "Default"
			elseif child.Name == "Drone" then
				machinetype = "Drone"
			end
			table.insert(machines, {
				Path = child,
				Type = machinetype
			})
		end
	end
	return machines
end

function library.Machines.IsMachineCompleted(mach)
	if not mach then return false end
	local progress = mach:GetAttribute("Progress")
	local maxprogress = mach:GetAttribute("MaxProgress")
	return progress == maxprogress
end

function library.Machines.IsMachineIncomplete(mach)
	return not library.Machines.IsMachineCompleted(mach)
end

function library.Machines.GetClosestMachine()
	if not interacts or not player.Character then return nil end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closestmachine = nil
	local shortestdistance = math.huge
	local children = interacts:GetChildren()
	for fart, child in ipairs(children) do
		if child:IsA("Model") then
			local part = child:FindFirstChildWhichIsA("BasePart")
			if part then
				local distance = (root.Position - part.Position).Magnitude
				if distance < shortestdistance then
					shortestdistance = distance
					closestmachine = child
				end
			end
		end
	end
	return closestmachine
end

function library.Machines.ExtractMachine(mach)
	if not mach then return end
	if library.Machines.IsMachineCompleted(mach) then
		warn("linear DF library | this machine is complete already.")
		return nil
	end
	local interact = mach:FindFirstChild("Interact")
	if interact then
		local prompt = interact:FindFirstChildWhichIsA("ProximityPrompt")
		if prompt then
			if fireproximityprompt then
				fireproximityprompt(prompt)
			else
				warn("linear DF library | fireproximityprompt is not supported..")
			end
		end
	end
end

function library.Machines.OnMachineAdded(callback)
	if not interacts then return end
	return interacts.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			local machinetype = "Unknown Machine"
			if child.Name == "Plushie" then
				machinetype = "Default"
			elseif child.Name == "Drone" then
				machinetype = "Drone"
			end
			callback(child, machinetype)
		end
	end)
end

return library
