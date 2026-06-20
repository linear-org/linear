local maid = {}
maid.__index = maid

function maid.new()
	return setmetatable({tasks = {}}, maid)
end

function maid:GiveTask(task)
	if not task then return end
	table.insert(self.tasks, task)
	return task
end

function maid:Remove(task)
	if not task then return end
	local found = table.find(self.tasks, task)
	if not found then return end
	if typeof(task) == "RBXScriptConnection" then
		task:Disconnect()
	elseif typeof(task) == "Instance" then
		task:Destroy()
	elseif typeof(task) == "thread" then
		task.cancel(task)
	elseif typeof(task) == "function" then
		task.spawn(task)
	elseif typeof(task) == "table" then
		if typeof(task.Destroy) == "function" then
			task:Destroy()
		elseif typeof(task.Disconnect) == "function" then
			task:Disconnect()
		elseif typeof(task.Clean) == "function" then
			task:Clean()
		end
	end
	table.remove(self.tasks, found)
end

function maid:Clean()
	for fart = #self.tasks, 1, -1 do
		self:Remove(self.tasks[fart])
	end
	table.clear(self.tasks)
end

return maid
