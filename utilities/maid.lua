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
end

function Maid:GiveTask(job)
	if not job then return end
	local anonymousId = #self._jobs + 1
	self[anonymousId] = job
	return job
end

function Maid:Clean()
	for key, job in pairs(self._jobs) do
		cleanJob(job)
		self._jobs[key] = nil
	end
end

return Maid
