-- Advanced Universal Roblox Script with Cross-PlaceId Support

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local CurrentPlaceId = game.PlaceId
local CurrentGameId = game.GameId

-- Settings & Configuration
local settings = {
    version = "1.0",
    espEnabled = false,
    speedEnabled = false,
    speedMultiplier = 3,
    infJumpEnabled = false,
    noclipEnabled = false,
    currentTheme = "Dark",
    uiPosition = UDim2.new(0.5, -150, 0.5, -125),
    favoriteGames = {},
    lastUsedFeatures = {}
}

-- Cross-Place Persistence System
local persistentStorageKey = "UniversalScriptData_" .. LocalPlayer.UserId
local gameConfigs = {
    -- Adopt Me
    [920587237] = {
        speedMultiplier = 2,
        autoFarm = true,
        gameName = "Adopt Me",
        customFeatures = {"Pet Farm", "Auto-Tasks"}
    },
    -- Jailbreak
    [606849621] = {
        speedMultiplier = 4,
        autoFarm = true,
        gameName = "Jailbreak",
        customFeatures = {"Auto-Rob", "No Cell"}
    },
    -- Phantom Forces
    [292439477] = {
        speedMultiplier = 1.5,
        aimbot = true,
        gameName = "Phantom Forces",
        customFeatures = {"Silent Aim", "Wallbang"}
    },
    -- Royale High
    [735030788] = {
        speedMultiplier = 2,
        autoFarm = true,
        gameName = "Royale High",
        customFeatures = {"Diamond Farm", "Auto-Dress"}
    },
    -- Murder Mystery 2
    [142823291] = {
        speedMultiplier = 2.5,
        gameName = "Murder Mystery 2",
        customFeatures = {"Role ESP", "Coin Farm"}
    }
}

-- Get current game config or default
local currentGameConfig = gameConfigs[CurrentPlaceId] or {
    speedMultiplier = 3,
    gameName = game.Name,
    customFeatures = {}
}

-- Save settings function
local function saveSettings()
    pcall(function()
        -- Convert table to JSON string
        local jsonSettings = HttpService:JSONEncode(settings)
        
        -- Save to registry
        if writefile then
            writefile("UniversalScriptSettings.json", jsonSettings)
        end
        
        -- Also save to global environment for cross-place teleports
        getgenv().UniversalScriptSettings = settings
    end)
end

-- Load settings function
local function loadSettings()
    pcall(function()
        local success = false
        
        -- Try to load from global environment first (for teleports)
        if getgenv().UniversalScriptSettings then
            settings = getgenv().UniversalScriptSettings
            success = true
        end
        
        -- Try reading from file system
        if not success and readfile and isfile and isfile("UniversalScriptSettings.json") then
            local content = readfile("UniversalScriptSettings.json")
            settings = HttpService:JSONDecode(content)
            success = true
        end
    end)
end

-- Try loading settings
loadSettings()

-- Setup cross-teleport hook
local function setupTeleportHook()
    if syn and syn.queue_on_teleport then
        -- Create script to run after teleport
        local teleportScript = [[
            -- Wait for game to load
            repeat wait() until game:IsLoaded()
            
            -- Execute script again with loadstring
            loadstring(game:HttpGet('https://raw.githubusercontent.com/freeopensourcesoftware/ui/refs/heads/main/UniversalScript.lua'))()
        ]]
        
        -- Queue the script to run after teleport
        syn.queue_on_teleport(teleportScript)
    elseif queue_on_teleport then
        queue_on_teleport([[
            -- Wait for game to load
            repeat wait() until game:IsLoaded()
            
            -- Execute script again via HttpGet to avoid file path issues
            loadstring(game:HttpGet('https://raw.githubusercontent.com/freeopensourcesoftware/ui/refs/heads/main/UniversalScript.lua'))()
        ]])
    end
end

-- Simplified teleport handling to avoid errors
pcall(function()
    -- Set up teleport hook before any teleport happens
    saveSettings()
    setupTeleportHook()
end)

-- UI Creation
local UniversalGui = Instance.new("ScreenGui")
UniversalGui.Name = "UniversalScriptGui_" .. math.random(1000, 9999) -- Random name to avoid detection
UniversalGui.ResetOnSpawn = false
UniversalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UniversalGui.DisplayOrder = 999

-- Try to put the GUI in CoreGui (more hidden) but fall back to PlayerGui
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(UniversalGui)
        UniversalGui.Parent = CoreGui
    elseif gethui then
        UniversalGui.Parent = gethui()
    elseif CoreGui:FindFirstChild("RobloxGui") then
        UniversalGui.Parent = CoreGui.RobloxGui
    else
        UniversalGui.Parent = CoreGui
    end
end)

if not UniversalGui.Parent then
    UniversalGui.Parent = LocalPlayer.PlayerGui
end

-- Create themes
local themes = {
    Dark = {
        background = Color3.fromRGB(30, 30, 30),
        secondary = Color3.fromRGB(40, 40, 40),
        button = Color3.fromRGB(50, 50, 50),
        buttonHover = Color3.fromRGB(70, 70, 70),
        text = Color3.fromRGB(255, 255, 255),
        accent = Color3.fromRGB(0, 170, 255)
    },
    Light = {
        background = Color3.fromRGB(230, 230, 230),
        secondary = Color3.fromRGB(210, 210, 210),
        button = Color3.fromRGB(190, 190, 190),
        buttonHover = Color3.fromRGB(170, 170, 170),
        text = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(0, 120, 215)
    },
    Midnight = {
        background = Color3.fromRGB(20, 20, 30),
        secondary = Color3.fromRGB(30, 30, 45),
        button = Color3.fromRGB(40, 40, 60),
        buttonHover = Color3.fromRGB(50, 50, 80),
        text = Color3.fromRGB(220, 220, 255),
        accent = Color3.fromRGB(100, 100, 255)
    }
}

-- Current theme
local currentTheme = themes[settings.currentTheme] or themes.Dark

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = settings.uiPosition
MainFrame.BackgroundColor3 = currentTheme.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = UniversalGui

-- Corner radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = currentTheme.secondary
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleUICorner = Instance.new("UICorner")
TitleUICorner.CornerRadius = UDim.new(0, 8)
TitleUICorner.Parent = TitleBar

-- Make only top corners rounded
local TitleCornerFix = Instance.new("Frame")
TitleCornerFix.Name = "CornerFix"
TitleCornerFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleCornerFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleCornerFix.BackgroundColor3 = currentTheme.secondary
TitleCornerFix.BorderSizePixel = 0
TitleCornerFix.Parent = TitleBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = currentTheme.text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Text = "Universal Script v" .. settings.version
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Game Info
local GameInfo = Instance.new("TextLabel")
GameInfo.Name = "GameInfo"
GameInfo.Size = UDim2.new(0.3, 0, 1, 0)
GameInfo.Position = UDim2.new(0.7, 0, 0, 0)
GameInfo.BackgroundTransparency = 1
GameInfo.TextColor3 = currentTheme.text
GameInfo.TextSize = 14
GameInfo.Font = Enum.Font.Gotham
GameInfo.Text = currentGameConfig.gameName
GameInfo.TextXAlignment = Enum.TextXAlignment.Right
GameInfo.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 3)
CloseButton.BackgroundColor3 = currentTheme.button
CloseButton.BorderSizePixel = 0
CloseButton.TextColor3 = currentTheme.text
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.Parent = TitleBar

local CloseUICorner = Instance.new("UICorner")
CloseUICorner.CornerRadius = UDim.new(0, 6)
CloseUICorner.Parent = CloseButton

-- Main Content
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0.3, 0, 0.9, 0)
TabContainer.Position = UDim2.new(0, 10, 0.1, 0)
TabContainer.BackgroundColor3 = currentTheme.secondary
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabUICorner = Instance.new("UICorner")
TabUICorner.CornerRadius = UDim.new(0, 6)
TabUICorner.Parent = TabContainer

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.65, 0, 0.9, 0)
ContentFrame.Position = UDim2.new(0.33, 0, 0.1, 0)
ContentFrame.BackgroundColor3 = currentTheme.secondary
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentUICorner = Instance.new("UICorner")
ContentUICorner.CornerRadius = UDim.new(0, 6)
ContentUICorner.Parent = ContentFrame

-- Create tabs
local tabs = {
    {name = "Main", icon = "rbxassetid://3926305904"},
    {name = "Player", icon = "rbxassetid://3926307971"},
    {name = "Game", icon = "rbxassetid://3926305904"},
    {name = "ESP", icon = "rbxassetid://3926305904"},
    {name = "Teleport", icon = "rbxassetid://3926307971"},
    {name = "Settings", icon = "rbxassetid://3926305904"}
}

local tabButtons = {}
local tabFrames = {}
local selectedTab = "Main"

for i, tab in ipairs(tabs) do
    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tab.name .. "Tab"
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Position = UDim2.new(0, 5, 0, (i-1) * 45 + 5)
    TabButton.BackgroundColor3 = tab.name == selectedTab and currentTheme.accent or currentTheme.button
    TabButton.BorderSizePixel = 0
    TabButton.TextColor3 = currentTheme.text
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = "  " .. tab.name
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = TabContainer
    
    local TabUICorner = Instance.new("UICorner")
    TabUICorner.CornerRadius = UDim.new(0, 6)
    TabUICorner.Parent = TabButton
    
    -- Create tab content frame
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = tab.name .. "Frame"
    TabFrame.Size = UDim2.new(1, -10, 1, -10)
    TabFrame.Position = UDim2.new(0, 5, 0, 5)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 2
    TabFrame.Visible = tab.name == selectedTab
    TabFrame.Parent = ContentFrame
    TabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Store references
    tabButtons[tab.name] = TabButton
    tabFrames[tab.name] = TabFrame
    
    -- Tab button click
    TabButton.MouseButton1Click:Connect(function()
        -- Update selected tab
        selectedTab = tab.name
        
        -- Update tab button colors
        for tabName, button in pairs(tabButtons) do
            button.BackgroundColor3 = tabName == selectedTab and currentTheme.accent or currentTheme.button
        end
        
        -- Show/hide tab frames
        for tabName, frame in pairs(tabFrames) do
            frame.Visible = tabName == selectedTab
        end
    end)
end

-- Create Main tab content
local function createButton(parent, text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = currentTheme.button
    Button.BorderSizePixel = 0
    Button.TextColor3 = currentTheme.text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.Parent = parent
    
    local ButtonUICorner = Instance.new("UICorner")
    ButtonUICorner.CornerRadius = UDim.new(0, 6)
    ButtonUICorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- Create Toggle Button
local function createToggleButton(parent, text, position, defaultState, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Toggle"
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = defaultState and currentTheme.accent or currentTheme.button
    Button.BorderSizePixel = 0
    Button.TextColor3 = currentTheme.text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Text = text .. ": " .. (defaultState and "ON" or "OFF")
    Button.Parent = parent
    
    local ButtonUICorner = Instance.new("UICorner")
    ButtonUICorner.CornerRadius = UDim.new(0, 6)
    ButtonUICorner.Parent = Button
    
    local state = defaultState
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = text .. ": " .. (state and "ON" or "OFF")
        Button.BackgroundColor3 = state and currentTheme.accent or currentTheme.button
        callback(state)
    end)
    
    return Button, state
end

-- Fill Main tab
local speedButton, speedEnabled = createToggleButton(tabFrames.Main, "Speed Hack", UDim2.new(0, 5, 0, 5), settings.speedEnabled, function(state)
    settings.speedEnabled = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
    end
    saveSettings()
end)

local noclipButton, noclipEnabled = createToggleButton(tabFrames.Main, "Noclip", UDim2.new(0, 5, 0, 50), settings.noclipEnabled, function(state)
    settings.noclipEnabled = state
    saveSettings()
end)

local infJumpButton, infJumpEnabled = createToggleButton(tabFrames.Main, "Infinite Jump", UDim2.new(0, 5, 0, 95), settings.infJumpEnabled, function(state)
    settings.infJumpEnabled = state
    saveSettings()
end)

local espButton, espEnabled = createToggleButton(tabFrames.Main, "ESP", UDim2.new(0, 5, 0, 140), settings.espEnabled, function(state)
    settings.espEnabled = state
    if state then
        -- Enable ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    else
        -- Disable ESP
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeESP(player)
            end
        end
    end
    saveSettings()
end)

-- ESP functions
local espObjects = {}

function createESP(player)
    if player == LocalPlayer then return end
    
    removeESP(player) -- Remove existing ESP
    
    -- Use pcall to prevent errors
    pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        if player.Character then
            highlight.Parent = player.Character
            espObjects[player.Name] = highlight
        end
    end)
end

function removeESP(player)
    if espObjects[player.Name] then
        pcall(function()
            espObjects[player.Name]:Destroy()
        end)
        espObjects[player.Name] = nil
    end
end

-- Toggle UI visibility with Right Ctrl
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- Infinite Jump
    if settings.infJumpEnabled and input.KeyCode == Enum.KeyCode.Space then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Noclip functionality
RunService.Stepped:Connect(function()
    if settings.noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP Handling
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(1) -- Wait for character to load
            if espEnabled then
                createESP(player)
            end
        end)
    end
end)

-- Auto-reconnect ESP when character respawns
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    
    -- Reset speed if enabled
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

-- Notification on successful load
local function notify(text, duration)
    -- Use pcall to avoid property errors
    pcall(function()
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Size = UDim2.new(0, 250, 0, 50)
        Notification.Position = UDim2.new(0.5, -125, 0.05, 0)
        Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Notification.BorderSizePixel = 0
        Notification.Parent = UniversalGui
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Name = "NotifText"
        NotifText.Size = UDim2.new(1, -10, 1, 0)
        NotifText.Position = UDim2.new(0, 5, 0, 0)
        NotifText.BackgroundTransparency = 1
        NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifText.TextSize = 14
        NotifText.Font = Enum.Font.Gotham
        NotifText.Text = text
        NotifText.TextWrapped = true
        NotifText.Parent = Notification
        
        -- Animation
        Notification.BackgroundTransparency = 1
        NotifText.TextTransparency = 1
        
        TweenService:Create(Notification, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
        TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        
        delay(duration, function()
            pcall(function()
                TweenService:Create(Notification, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
                TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
                wait(0.5)
                Notification:Destroy()
            end)
        end)
    end)
end

-- Initial notification
notify("Universal Script loaded! Press Right Ctrl to toggle UI", 5)

-- Print to console (optional)
print("Universal Script loaded successfully")
