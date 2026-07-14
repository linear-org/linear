local Maid = {}

function Maid.new()
	return setmetatable({ _jobs = {} }, Maid)
end

function Maid:__index(key)
	return Maid[key] or self._jobs[key]
end

local function cleanJob(job)
	if typeof(job) == "RBXScriptConnection" then
		job:Disconnect()
	elseif typeof(job) == "Instance" then
		job:Destroy()
	elseif typeof(job) == "thread" then
		task.cancel(job)
	elseif typeof(job) == "function" then
		job()
	elseif typeof(job) == "table" then
		if typeof(job.Destroy) == "function" then      job:Destroy()
		elseif typeof(job.Disconnect) == "function" then job:Disconnect()
		elseif typeof(job.Clean) == "function" then      job:Clean() 
		end
	end
end

function Maid:__newindex(key, job)
	if Maid[key] then
		error(string.format("Cannot overwrite Maid method '%s'", tostring(key)), 2)
	end

	local oldJob = self._jobs[key]
	if oldJob then
		cleanJob(oldJob)
	end

	self._jobs[key] = job

	if job and typeof(job) == "Instance" then
		local destroyConnection
		destroyConnection = job.Destroying:Connect(function()
			destroyConnection:Disconnect()
			if self._jobs[key] == job then
				self._jobs[key] = nil
			end
		end)
	end

	if typeof(key) == "Instance" then
		local destroyConnection
		destroyConnection = key.Destroying:Connect(function()
			destroyConnection:Disconnect()
			local currentJob = self._jobs[key]
			if currentJob then
				cleanJob(currentJob)
				self._jobs[key] = nil
			end
		end)
	end
end

function Maid:GiveTask(job)
	if not job then return end
	local anonymousId = #self._jobs + 1
	self[anonymousId] = job
	return job
end

function Maid:Clean()
	for key, job in pairs(self._jobs) do
		self._jobs[key] = nil
		cleanJob(job)
	end
end

return Maid
