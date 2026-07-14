-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

local Maid = Linear.Utils.Maid
local Values = Linear.Values

-- Building the tab
Linear.Tabs.Donor = Window:Tab({
    Title = "Donor",
    Icon = "gravity:heart-pulse",
    Border = true,
})

Linear.Tabs.Donor:Paragraph({
    Title = "LINEAR_STATUS",
    Desc = "This tab was left incomplete by the owners so you guys can test the script earlier. It'll be finished next update."
})

-- if everything checks out, informs that the fun tab is done
Linear:Print("Donor tab loaded.")