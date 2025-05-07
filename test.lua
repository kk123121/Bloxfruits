local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
	Name = "Waine Hub",
	LoadingTitle = "Universal Hub",
	LoadingSubtitle = "by justarandomguy",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, 
		FileName = "WaineHub"
	},
        Discord = {
        	Enabled = false,
        	Invite = "5PNvG2XGtm", 
        	RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
	KeySystem = true, -- Set this to true to use our key system
	KeySettings = {
		Title = "Waine Hub",
		Subtitle = "Key System",
		Note = "Join the discord (https://discord.gg/5PNvG2XGtm)",
		FileName = "WaineKey",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "R2D2"
	}
})

local PlayerTab = Window:CreateTab("Player", 4483362458) -- Title, Image
local Slider = PlayerTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {10, 100},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 10,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
        game.Player.LocalPlayer.Character:SetAttribute("SpeedMultiplier", Value)
	end,
})
