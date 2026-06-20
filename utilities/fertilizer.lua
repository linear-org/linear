local fertilizer = {}

local folders = {"linear", "linear/audios", "linear/videos", "linear/images"}
for fart, path in ipairs(folders) do
	if not isfolder(path) then makefolder(path) end
end

local function load(config, folder, prefix, ext)
	local link = config.link or config.Link
	local name = link:match("([^/]+)$") or (prefix .. "." .. ext)
	local file = "linear/" .. folder .. "/" .. name
	if not isfile(file) then
		local success, body = pcall(game.HttpGet, game, link)
		if success and body then
			writefile(file, body)
		end
	end
	return getcustomasset(file)
end

function fertilizer.CustomAudio(config)
	local element = config.path or config.Path
	local looped = config.looped or config.Looped
	local volume = config.volume or config.Volume
	local asset = load(config, "audios", "faudio", "mp3")
	if not element then return asset end
	element.SoundId = asset
	element.Looped = looped
	element.Volume = volume
	element:Play()
	return asset
end

function fertilizer.CustomVideo(config)
	local element = config.path or config.Path
	local looped = config.looped or config.Looped
	local volume = config.volume or config.Volume
	local asset = load(config, "videos", "fvideo", "webm")
	if not element then return asset end
	element.Video = asset
	element.Looped = looped
	element.Volume = volume
	element:Play()
	return asset
end

function fertilizer.CustomImage(config)
	local element = config.path or config.Path
	local transparency = config.transparency or config.Transparency
	local asset = load(config, "images", "fimage", "png")
	if not element then return asset end
	if element:IsA("Decal") or element:IsA("Texture") then
		element.Texture = asset
		element.Transparency = transparency
	else
		element.Image = asset
		element.ImageTransparency = transparency
	end
	return asset
end

return fertilizer
