local Fertilizer = {}

local linear = getgenv().Linear

function safepcall(fn, ...)
    local args = { ... }
    local success, result = pcall(fn, table.unpack(args))
    if not success then
        linear:Warn("safepcall failed:", result)
    end
    return success, result
end

local function downloadfile(path, url)
    if not isfile(path) then
        local success, result = safepcall(game.HttpGet, game, url)
        if not success or not result then
            linear:Warn("download fail:", url)
            return false
        end
        local writesuccess = safepcall(writefile, path, result)
        if not writesuccess then
            linear:Error("file write fail:", path)
            return false
        end
    end
    return true
end

local function loadasset(config, folder, prefix, ext)
    local link = config.link or config.Link
    if not link then
        linear:Warn("config missing link")
        return nil
    end
    local name = link:match("([^/]+)$") or (prefix .. "." .. ext)
    local filepath = "linear/" .. folder .. "/" .. name
    local fileok = downloadfile(filepath, link)
    if not fileok then
        return nil
    end
    local ok, asset = safepcall(getcustomasset, filepath)
    if not ok then
        linear:Warn("getcustomasset fail:", filepath)
        return nil
    end
    return asset
end

function Fertilizer.CustomAudio(config)
    local element = config.path or config.Path
    local asset = loadasset(config, "audios", "audio", "mp3")
    if not asset then return false end
    if element then
        element.SoundId = asset
        element.Looped = config.looped or config.Looped
        element.Volume = config.volume or config.Volume
        safepcall(function()
            element:Play()
        end)
    end
    return asset
end

function Fertilizer.CustomVideo(config)
    local element = config.path or config.Path
    local asset = loadasset(config, "videos", "video", "webm")
    if not asset then return false end
    if element then
        element.Video = asset
        element.Looped = config.looped or config.Looped
        element.Volume = config.volume or config.Volume
        safepcall(function()
            element:Play()
        end)
    end
    return asset
end

function Fertilizer.CustomImage(config)
    local element = config.path or config.Path
    local asset = loadasset(config, "images", "image", "png")
    if not asset then return false end
    if element then
        if element:IsA("Decal") or element:IsA("Texture") then
            element.Texture = asset
            element.Transparency = config.transparency or config.Transparency
        else
            element.Image = asset
            element.ImageTransparency = config.transparency or config.Transparency
        end
    end
    return asset
end

return Fertilizer
