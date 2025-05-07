--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// ReGui with improved loading
local ReGui
local success, err = pcall(function()
    ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua'))()
end)

if not success or not ReGui then
    error("Failed to load ReGui: " .. tostring(err))
    return
end

--// Theme Configuration
local Accent = {
    Blue = Color3.fromRGB(0, 100, 255),
    DarkBlue = Color3.fromRGB(0, 60, 150),
    LightBlue = Color3.fromRGB(100, 150, 255)
}

ReGui:DefineTheme("SpeedTheme", {
    WindowBg = Color3.fromRGB(30, 30, 40),
    TitleBarBg = Accent.DarkBlue,
    TitleBarBgActive = Accent.Blue,
    ResizeGrab = Accent.DarkBlue,
    FrameBg = Color3.fromRGB(40, 40, 50),
    FrameBgActive = Accent.LightBlue,
    CollapsingHeaderBg = Accent.DarkBlue,
    ButtonsBg = Accent.Blue,
    CheckMark = Accent.Blue,
    SliderGrab = Accent.Blue,
})

--// Initialize ReGui
ReGui:Init()

--// Global Variables
local lastWalkSpeed = 16
local noClipEnabled = false

--// Create Window
local Window = ReGui:Window({
    Title = "Player Speed Controller",
    Theme = "SpeedTheme",
    Size = UDim2.fromOffset(300, 250),
    Draggable = true,
    Closable = true,
    Center = true
})

--// Movement Tab
local MovementTab = Window:Tab({
    Title = "Movement Settings",
    Icon = ""
})

--// WalkSpeed Controls
local walkSpeedLabel = MovementTab:Label({
    Title = "Current WalkSpeed: 16",
    Description = ""
})

MovementTab:Slider({
    Title = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(value)
        -- Update label
        walkSpeedLabel:Update({
            Title = "Current WalkSpeed: " .. tostring(value)
        })
        
        -- Apply to player
        lastWalkSpeed = value
        applyWalkSpeed(value)
    end
})

--// NoClip Toggle
MovementTab:Checkbox({
    Title = "NoClip",
    Default = false,
    Callback = function(value)
        noClipEnabled = value
    end
})

--// Apply Button
MovementTab:Button({
    Title = "Apply Settings",
    Callback = function()
        applyWalkSpeed(lastWalkSpeed)
        if LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        end
    end
})

--// Function to apply walk speed
local function applyWalkSpeed(value)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
end

--// Handle character respawns
local function onCharacterAdded(character)
    local humanoid = character:WaitForChildOfClass("Humanoid")
    humanoid.WalkSpeed = lastWalkSpeed
    
    -- Reconnect the NoClip loop
    if noClipEnabled then
        RunService.Stepped:Connect(noclipLoop)
    end
end

--// NoClip loop
local function noclipLoop()
    if not noClipEnabled then return end
    if not LocalPlayer.Character then return end
    
    for _, part in LocalPlayer.Character:GetDescendants() do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

--// Initial setup
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
RunService.Stepped:Connect(noclipLoop)

-- Apply default settings
applyWalkSpeed(lastWalkSpeed)
