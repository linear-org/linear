-- Getting the global references
local Linear = getgenv().Linear

local WindUI = Linear.WindUI
local Window = Linear.Window

-- Getting services
local Players = game:GetService("Players")

-- Getting variables 
local LocalPlayer = Players.LocalPlayer

-- Giving some tables
local Welcomes = {
	"Hello there!",
	"Greetings!",
	"Welcome, " .. LocalPlayer.DisplayName .. "!",
	"How's it going, " .. LocalPlayer.DisplayName .. "?",
	"Great to see you, " .. LocalPlayer.DisplayName .. "!"
}

local Greetings = {
	"Nice to see you!",
	"Happy to have you here!",
	"Great to see you!",
	"Thank you for using linear!",
	"Hope you're doing well!",
	"Good morning, good afternoon, good night!"
}

local Facts = {
	"Did you know that linear is the first script ever to have an autofarm for animal hospital?",
	"Did you know that the highest stud a roblox player can normally jump is about 16 studs?",
	"Did you know that back in the old times builderman would automatically be your first friend ever?",
	"Did you know that roblox recently tried to add a feature where you can draw anything on your roblox avatar for free? (this got scrapped for obvious reasons)",
	"Did you know that roblox once had a massive incident where they had to shutdown for 7 days straight?",
	"Did you know that roblox was originally named dynablocks during its early beta phases back in 2003?",
	"Did you know that there used to be a free currency called tix that got completely removed in 2016?",
	"Did you know that the iconic oof sound wasn't originally made for roblox but for a game called messiah?",
	"Did you know that the first ever catalog item uploaded to the site was a hat called helm of the gladiator?",
	"Did you know that the default walkspeed for a standard roblox character is exactly 16 studs per second?",
	"Did you know that the maximum friend limit on an account was capped at 200 until 2025?",
	"Did you know that the first ever roblox game to reach one billion visits was meepcity?",
	"Did you know that badges used to cost 100 robux to create before they became free for a limited amount per day?",
	"Did you know that the classic crossroads map was originally created by john shedletsky back in 2007?",
	"Did you know that the meshpart instance was introduced in 2016 which allowed for highly detailed custom 3d models?",
	"Did you know that roblox points were the original currency back in 2004 before robux was even implemented?",
	"Did you know that work at a pizza place is one of the oldest active games on the platform having been released in 2008?",
	"Did you know that the first official roblox egg hunt event happened all the way back in 2008?",
	"Did you know that the rare dominus series of hats started in 2010 with the release of dominus empyreus?",
	"Did you know that roblox officially rebranded the famous bloxy awards into the roblox innovation awards in 2022?",
	"Did you know that a standard roblox account username must be between 3 and 20 characters long?",
	"Did you know that the gear system allowed players to bring custom catalog items into any game that had them enabled?",
	"Did you know that r15 avatar type was introduced in 2016 which expanded character joints from 6 to 15?",
	"Did you know that the first ever user account created on the site wasn't david baszucki or builderman but an account named admin with user id 1?",
	"Did you know that for april fools in 2014 roblox released a video claiming they were going to replace every single game item with cats?",
	"Did you know that animal hospital was heavily inspired by other popular roblox games like dandy's world and scary shawarma kiosk?",
	"Did you know that picking up a cursed patient photo before it fully clears on the desk will instantly drain 10 sanity?",
	"Did you know that when a patient dies their ghost becomes invisible and will actively drain your sanity when nearby until exposed with a fire extinguisher?",
	"Did you know that the robux exclusive secret agent class starts each shift with a gun that has friendly fire enabled?",
	"Did you know that the surgeon class is widely considered the best free option because it restores sanity and gives a speed boost when healing?",
	"Did you know that there is an unpatched glitch in room 2 where aligning with the wall and shifting your camera lets you clip completely out of the map?",
	"Did you know that when a patient undergoes a death ritual they float above the bed and you must blow out the candles to save them?",
	"Did you know that the first patient to ever that comes to the hospital will always ask for herbs?",
	"Did you know that the second patient ever that comes to the hospital will always ask for eye drops?",
	"Did you know that if you accidentally got an anomaly inside, you can give them a wrong treatment to kill them?",
	"Did you know that you can give eye drops into eye mass to get rid of him?",
	"Did you know that you can clean the slime that the patients create with the fire extinguisher?",
	"Did you know that you won't be damaged when you're near a death ritual if you hold an eye drop?",
	"Did you know that you can kill hiders with a fire extinguisher?",
	"Did you know that you can throw fainted patients into the trash?",
	"Did you know that ratthew and ron from accounting will never be skinwalkers?",
	"Did you know that if you let a skinwalker in it has a chance to do a death ritual on one of the patients?",
	"Did you know that if a skinwalker starts eating a skinwalker the game thinks that it ate a patient and makes the hospital lose a heart?",
	"Did you know that the bed monster can eat a hider?"
}

-- Building the tab
Linear.Tabs.Main = Window:Tab({
    Title = "Main",
    Icon = "gravity:house",
    Border = true,
})

-- Creating the welcome groupbox
Linear.Sections.Welcome = Linear.Tabs.Main:Section({
    Title = "Welcome",
    Icon = "gravity:hand",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

-- Creating welcome message
Linear.Sections.Welcome:Paragraph({
	Title = Welcomes[math.random(1, #Welcomes)],
	Desc = Greetings[math.random(1, #Greetings)],
})

-- Divider so it looks juicy (it probably doesn't)
Linear.Sections.Welcome:Divider()

-- Creating funfact msg
local FunfactParagraph = Linear.Sections.Welcome:Paragraph({
	Title = "Random Funfact",
	Desc = Facts[math.random(1, #Facts)],
})

Linear.Sections.Welcome:Paragraph({
		Title = "Did you know?",
		Desc = "You executed the script " .. Linear.GetExecutions() .. " time(s) in total!"
	})

-- Creating subscription msg depending on current subscription 
if Linear.IsDonor then
	Linear.Sections.Welcome:Paragraph({
		Title = "Thank you for purchasing donor!",
		Desc = "Your support means a lot to us, thank you again!"
	})
elseif Linear.FreeDonorDay then
	Linear.Sections.Welcome:Paragraph({
		Title = "It's free donor day!",
		Desc = "Donor features have been made free temporarily, have fun!"
	})
else
	Linear.Sections.Welcome:Paragraph({
		Title = "You aren't a donor!",
		Desc = "You can purchase to be one in the donor tab, it's okay though, keep an eye out for the free donor days!"
	})
end

-- Selecting the tab as the default
Linear.Tabs.Main:Select()

-- Resetting funfact every 9s
task.spawn(function()
	while true do
		task.wait(9)
		FunfactParagraph:SetDesc(Facts[math.random(1, #Facts)])
	end
end)

-- Creating the credits section 
Linear.Sections.Credits = Linear.Tabs.Main:Section({
    Title = "Credits",
    Icon = "gravity:heart-pulse",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

-- Creating a group to align flawlessly 
local CreditsAligner = Linear.Sections.Credits:Group({})

-- Credit me 
CreditsAligner:Paragraph({
    Title = "@qwelver.",
    Desc = "The owner of linear, made most of the script.",
})

-- Credit not me
CreditsAligner:Paragraph({
    Title = "@deleted_user_d91dbdf28037",
    Desc = "The owner of riddance, they also help a lot with the script.",
})

-- if everything checks out, informs that the main tab is done
Linear:Print("Main tab loaded.")