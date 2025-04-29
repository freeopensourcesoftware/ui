local UILibrary = {}

-- Service Imports
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local TWEEN_SPEED = 0.25
local FONT = Enum.Font.SourceSansBold
local TEXT_SIZE = 14
local PRIMARY_COLOR = Color3.fromRGB(36, 36, 36)
local SECONDARY_COLOR = Color3.fromRGB(46, 46, 46)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255)
local HOVER_COLOR = Color3.fromRGB(60, 60, 60)
local TRANSPARENCY = 0.05

-- Utility functions
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or TWEEN_SPEED, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    return tween
end

local function onHover(button, hovered)
    local targetColor = hovered and HOVER_COLOR or SECONDARY_COLOR
    createTween(button, {BackgroundColor3 = targetColor}, 0.2):Play()
end

local function dragify(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Clean up any existing UI with the same name to prevent duplicates
local function cleanUpExistingUI(uiName)
    for _, instance in pairs(CoreGui:GetChildren()) do
        if instance.Name == uiName then
            instance:Destroy()
        end
    end
    
    -- Also check PlayerGui just in case
    if Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui") then
        for _, instance in pairs(Players.LocalPlayer.PlayerGui:GetChildren()) do
            if instance.Name == uiName then
                instance:Destroy()
            end
        end
    end
end

-- Create the main button that appears next to microphone icon
local function createToggleButton()
    -- Try to use CoreGui or fallback to PlayerGui
    local parent = CoreGui
    
    -- Create ScreenGui
    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "RobloxUIButtonGui"
    buttonGui.ResetOnSpawn = false
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    buttonGui.Parent = parent
    
    -- Create the toggle button (position it next to where the microphone typically is)
    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.BackgroundColor3 = ACCENT_COLOR
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0, 110, 0, 10) -- Position it near the top of the screen near the microphone icon
    toggleButton.Size = UDim2.new(0, 32, 0, 32)
    toggleButton.Image = "rbxassetid://6031225816" -- Gear icon
    toggleButton.BackgroundTransparency = 0.2
    toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.AnchorPoint = Vector2.new(0, 0)
    
    -- Make the button circular
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = toggleButton
    
    -- Add a shadow effect
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(20, 20, 20)
    uiStroke.Thickness = 1.2
    uiStroke.Parent = toggleButton
    
    toggleButton.Parent = buttonGui
    
    return toggleButton, buttonGui
end

-- Create the main Window class
local Window = {}
Window.__index = Window

function UILibrary:CreateWindow(title)
    cleanUpExistingUI("RobloxUILibrary")
    cleanUpExistingUI("RobloxUIButtonGui")
    
    local toggleButton, buttonGui = createToggleButton()
    
    local windowInstance = {}
    setmetatable(windowInstance, Window)
    
    -- Create ScreenGui
    windowInstance.ScreenGui = Instance.new("ScreenGui")
    windowInstance.ScreenGui.Name = "RobloxUILibrary"
    windowInstance.ScreenGui.ResetOnSpawn = false
    windowInstance.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    windowInstance.ScreenGui.Enabled = false
    windowInstance.ScreenGui.Parent = CoreGui
    
    -- Main Frame
    windowInstance.MainFrame = Instance.new("Frame")
    windowInstance.MainFrame.Name = "MainFrame"
    windowInstance.MainFrame.BackgroundColor3 = PRIMARY_COLOR
    windowInstance.MainFrame.BorderSizePixel = 0
    windowInstance.MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    windowInstance.MainFrame.Size = UDim2.new(0, 300, 0, 350)
    windowInstance.MainFrame.Parent = windowInstance.ScreenGui
    
    -- Add shadow and rounded corners to main frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = windowInstance.MainFrame
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(60, 60, 60)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = windowInstance.MainFrame
    
    -- Title Bar
    windowInstance.TitleBar = Instance.new("Frame")
    windowInstance.TitleBar.Name = "TitleBar"
    windowInstance.TitleBar.BackgroundColor3 = ACCENT_COLOR
    windowInstance.TitleBar.BorderSizePixel = 0
    windowInstance.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    windowInstance.TitleBar.Parent = windowInstance.MainFrame
    
    -- Add rounded corners just to top corners of title bar
    local UICornerTitle = Instance.new("UICorner")
    UICornerTitle.CornerRadius = UDim.new(0, 8)
    UICornerTitle.Parent = windowInstance.TitleBar
    
    -- Title Text
    windowInstance.TitleText = Instance.new("TextLabel")
    windowInstance.TitleText.Name = "TitleText"
    windowInstance.TitleText.BackgroundTransparency = 1
    windowInstance.TitleText.Position = UDim2.new(0.02, 0, 0, 0)
    windowInstance.TitleText.Size = UDim2.new(0.96, 0, 1, 0)
    windowInstance.TitleText.Font = FONT
    windowInstance.TitleText.Text = title or "UI Library"
    windowInstance.TitleText.TextColor3 = TEXT_COLOR
    windowInstance.TitleText.TextSize = 16
    windowInstance.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    windowInstance.TitleText.Parent = windowInstance.TitleBar
    
    -- Close button
    windowInstance.CloseButton = Instance.new("TextButton")
    windowInstance.CloseButton.Name = "CloseButton"
    windowInstance.CloseButton.BackgroundTransparency = 1
    windowInstance.CloseButton.Position = UDim2.new(0.93, 0, 0.1, 0)
    windowInstance.CloseButton.Size = UDim2.new(0, 24, 0, 24)
    windowInstance.CloseButton.Font = FONT
    windowInstance.CloseButton.Text = "✕"
    windowInstance.CloseButton.TextColor3 = TEXT_COLOR
    windowInstance.CloseButton.TextSize = 16
    windowInstance.CloseButton.Parent = windowInstance.TitleBar
    
    -- Content Frame
    windowInstance.ContentFrame = Instance.new("ScrollingFrame")
    windowInstance.ContentFrame.Name = "ContentFrame"
    windowInstance.ContentFrame.BackgroundTransparency = 1
    windowInstance.ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    windowInstance.ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    windowInstance.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    windowInstance.ContentFrame.ScrollBarThickness = 4
    windowInstance.ContentFrame.ScrollBarImageColor3 = ACCENT_COLOR
    windowInstance.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    windowInstance.ContentFrame.Parent = windowInstance.MainFrame
    
    -- Content Layout
    windowInstance.ContentLayout = Instance.new("UIListLayout")
    windowInstance.ContentLayout.Padding = UDim.new(0, 5)
    windowInstance.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    windowInstance.ContentLayout.Parent = windowInstance.ContentFrame
    
    -- Content Padding
    windowInstance.ContentPadding = Instance.new("UIPadding")
    windowInstance.ContentPadding.PaddingLeft = UDim.new(0, 10)
    windowInstance.ContentPadding.PaddingRight = UDim.new(0, 10)
    windowInstance.ContentPadding.PaddingTop = UDim.new(0, 10)
    windowInstance.ContentPadding.PaddingBottom = UDim.new(0, 10)
    windowInstance.ContentPadding.Parent = windowInstance.ContentFrame
    
    -- Configure Toggle Button
    toggleButton.MouseButton1Click:Connect(function()
        windowInstance.ScreenGui.Enabled = not windowInstance.ScreenGui.Enabled
        
        -- Animation for the button
        local rotation = windowInstance.ScreenGui.Enabled and 180 or 0
        createTween(toggleButton, {Rotation = rotation}, 0.3):Play()
        
        if windowInstance.ScreenGui.Enabled then
            -- Animate window appearing
            windowInstance.MainFrame.Position = UDim2.new(0.5, -150, 0.45, -175)
            windowInstance.MainFrame.BackgroundTransparency = 1
            
            for _, child in pairs(windowInstance.MainFrame:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("ScrollingFrame") then
                    child.BackgroundTransparency = 1
                end
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    child.TextTransparency = 1
                end
                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    child.ImageTransparency = 1
                end
            end
            
            createTween(windowInstance.MainFrame, {Position = UDim2.new(0.5, -150, 0.5, -175), BackgroundTransparency = 0}, 0.3):Play()
            
            for _, child in pairs(windowInstance.MainFrame:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("ScrollingFrame") then
                    if not (child.Name == "ContentFrame") then  -- Keep ScrollingFrame transparent
                        createTween(child, {BackgroundTransparency = 0}, 0.3):Play()
                    end
                end
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    createTween(child, {TextTransparency = 0}, 0.3):Play()
                end
                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    createTween(child, {ImageTransparency = 0}, 0.3):Play()
                end
            end
        end
    end)
    
    -- Button hover effect
    toggleButton.MouseEnter:Connect(function()
        createTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(0, 190, 255)}, 0.2):Play()
    end)
    
    toggleButton.MouseLeave:Connect(function()
        createTween(toggleButton, {BackgroundColor3 = ACCENT_COLOR}, 0.2):Play()
    end)
    
    -- Close button handler
    windowInstance.CloseButton.MouseButton1Click:Connect(function()
        windowInstance.ScreenGui.Enabled = false
        createTween(toggleButton, {Rotation = 0}, 0.3):Play()
    end)
    
    -- Make the window draggable
    dragify(windowInstance.MainFrame)
    
    windowInstance.ElementIndex = 0
    
    return windowInstance
end

-- Methods for Window class

function Window:CreateLabel(text)
    self.ElementIndex = self.ElementIndex + 1
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "Label"..self.ElementIndex
    labelFrame.BackgroundTransparency = 1
    labelFrame.Size = UDim2.new(1, 0, 0, 25)
    labelFrame.LayoutOrder = self.ElementIndex
    labelFrame.Parent = self.ContentFrame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = FONT
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.TextSize = TEXT_SIZE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = labelFrame
    
    return labelFrame
end

function Window:CreateButton(text, callback)
    self.ElementIndex = self.ElementIndex + 1
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "Button"..self.ElementIndex
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Size = UDim2.new(1, 0, 0, 32)
    buttonFrame.LayoutOrder = self.ElementIndex
    buttonFrame.Parent = self.ContentFrame
    
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = SECONDARY_COLOR
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Font = FONT
    button.Text = text
    button.TextColor3 = TEXT_COLOR
    button.TextSize = TEXT_SIZE
    button.AutoButtonColor = false
    button.Parent = buttonFrame
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = button
    
    -- Click effect
    button.MouseButton1Click:Connect(function()
        createTween(button, {BackgroundColor3 = ACCENT_COLOR}, 0.1):Play()
        if callback then callback() end
        task.wait(0.1)
        createTween(button, {BackgroundColor3 = SECONDARY_COLOR}, 0.1):Play()
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        onHover(button, true)
    end)
    
    button.MouseLeave:Connect(function()
        onHover(button, false)
    end)
    
    return buttonFrame
end

function Window:CreateToggle(text, default, callback)
    self.ElementIndex = self.ElementIndex + 1
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"..self.ElementIndex
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Size = UDim2.new(1, 0, 0, 32)
    toggleFrame.LayoutOrder = self.ElementIndex
    toggleFrame.Parent = self.ContentFrame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = FONT
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.TextSize = TEXT_SIZE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.BackgroundColor3 = default and ACCENT_COLOR or SECONDARY_COLOR
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0.85, 0, 0.5, -10)
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Parent = toggleFrame
    
    -- Rounded corners for toggle background
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = toggleButton
    
    -- Toggle knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "Knob"
    toggleKnob.BackgroundColor3 = TEXT_COLOR
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Position = default and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleKnob.Parent = toggleButton
    
    -- Rounded corners for knob
    local UICornerKnob = Instance.new("UICorner")
    UICornerKnob.CornerRadius = UDim.new(1, 0)
    UICornerKnob.Parent = toggleKnob
    
    -- Click detection
    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = toggleFrame
    
    -- State
    local toggled = default or false
    
    -- Toggle function
    local function toggle()
        toggled = not toggled
        local targetPosition = toggled and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
        local targetColor = toggled and ACCENT_COLOR or SECONDARY_COLOR
        
        createTween(toggleKnob, {Position = targetPosition}, 0.2):Play()
        createTween(toggleButton, {BackgroundColor3 = targetColor}, 0.2):Play()
        
        if callback then callback(toggled) end
    end
    
    button.MouseButton1Click:Connect(toggle)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        createTween(toggleButton, {BackgroundTransparency = 0.2}, 0.2):Play()
    end)
    
    button.MouseLeave:Connect(function()
        createTween(toggleButton, {BackgroundTransparency = 0}, 0.2):Play()
    end)
    
    return toggleFrame
end

function Window:CreateSlider(text, min, max, default, callback)
    self.ElementIndex = self.ElementIndex + 1
    
    min = min or 0
    max = max or 100
    default = math.clamp(default or min, min, max)
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"..self.ElementIndex
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.LayoutOrder = self.ElementIndex
    sliderFrame.Parent = self.ContentFrame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = FONT
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.TextSize = TEXT_SIZE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "ValueDisplay"
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Position = UDim2.new(0.9, 0, 0, 0)
    valueDisplay.Size = UDim2.new(0.1, 0, 0, 20)
    valueDisplay.Font = FONT
    valueDisplay.Text = tostring(default)
    valueDisplay.TextColor3 = TEXT_COLOR
    valueDisplay.TextSize = TEXT_SIZE
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = sliderFrame
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.BackgroundColor3 = SECONDARY_COLOR
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Position = UDim2.new(0, 0, 0, 25)
    sliderBackground.Size = UDim2.new(1, 0, 0, 5)
    sliderBackground.Parent = sliderFrame
    
    -- Rounded corners for slider background
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.BackgroundColor3 = ACCENT_COLOR
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Parent = sliderBackground
    
    -- Rounded corners for slider fill
    local UICornerFill = Instance.new("UICorner")
    UICornerFill.CornerRadius = UDim.new(0, 3)
    UICornerFill.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.BackgroundColor3 = TEXT_COLOR
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, -7.5)
    sliderKnob.Size = UDim2.new(0, 15, 0, 15)
    sliderKnob.ZIndex = 2
    sliderKnob.Parent = sliderBackground
    
    -- Rounded corners for slider knob
    local UICornerKnob = Instance.new("UICorner")
    UICornerKnob.CornerRadius = UDim.new(1, 0)
    UICornerKnob.Parent = sliderKnob
    
    -- Click detection
    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = sliderBackground
    
    -- Value
    local value = default
    
    -- Update value function
    local function updateValue(mouseX)
        local sliderPosition = sliderBackground.AbsolutePosition.X
        local sliderWidth = sliderBackground.AbsoluteSize.X
        
        -- Calculate relative position
        local relativePosition = math.clamp((mouseX - sliderPosition) / sliderWidth, 0, 1)
        
        -- Calculate and update value
        value = min + relativePosition * (max - min)
        value = math.floor(value + 0.5) -- Round to nearest integer
        
        -- Update UI
        valueDisplay.Text = tostring(value)
        sliderFill.Size = UDim2.new(relativePosition, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativePosition, 0, 0.5, -7.5)
        
        -- Call the callback
        if callback then callback(value) end
    end
    
    -- Dragging
    local dragging = false
    
    button.MouseButton1Down:Connect(function()
        dragging = true
        updateValue(UserInputService:GetMouseLocation().X)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(UserInputService:GetMouseLocation().X)
        end
    end)
    
    return sliderFrame
end

function Window:CreateDropdown(text, options, default, callback)
    self.ElementIndex = self.ElementIndex + 1
    
    options = options or {}
    default = default or (options[1] or "")
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown"..self.ElementIndex
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Size = UDim2.new(1, 0, 0, 55) -- Start height
    dropdownFrame.LayoutOrder = self.ElementIndex
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Parent = self.ContentFrame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = FONT
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.TextSize = TEXT_SIZE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.BackgroundColor3 = SECONDARY_COLOR
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Position = UDim2.new(0, 0, 0, 25)
    dropdownButton.Size = UDim2.new(1, 0, 0, 30)
    dropdownButton.Font = FONT
    dropdownButton.Text = default
    dropdownButton.TextColor3 = TEXT_COLOR
    dropdownButton.TextSize = TEXT_SIZE
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = dropdownFrame
    
    -- Padding for dropdown text
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.Parent = dropdownButton
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = dropdownButton
    
    -- Arrow icon
    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Name = "ArrowIcon"
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Position = UDim2.new(0.95, 0, 0.5, -7)
    arrowIcon.Size = UDim2.new(0, 14, 0, 14)
    arrowIcon.Image = "rbxassetid://6034818379" -- Down arrow
    arrowIcon.ImageColor3 = TEXT_COLOR
    arrowIcon.Parent = dropdownButton
    
    -- Dropdown container
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "DropdownContainer"
    dropdownContainer.BackgroundColor3 = SECONDARY_COLOR
    dropdownContainer.BorderSizePixel = 0
    dropdownContainer.Position = UDim2.new(0, 0, 0, 60)
    dropdownContainer.Size = UDim2.new(1, 0, 0, 0) -- Start with 0 height
    dropdownContainer.Visible = false
    dropdownContainer.Parent = dropdownFrame
    
    -- Rounded corners for container
    local UICornerContainer = Instance.new("UICorner")
    UICornerContainer.CornerRadius = UDim.new(0, 4)
    UICornerContainer.Parent = dropdownContainer
    
    -- Options layout
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = dropdownContainer
    
    -- Populate options
    local selected = default
    local isOpen = false
    local optionButtons = {}
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option"..i
        optionButton.BackgroundTransparency = 1
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Font = FONT
        optionButton.Text = option
        optionButton.TextColor3 = TEXT_COLOR
        optionButton.TextSize = TEXT_SIZE - 1
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.LayoutOrder = i
        optionButton.Parent = dropdownContainer
        
        -- Padding for option text
        local UIPaddingOption = Instance.new("UIPadding")
        UIPaddingOption.PaddingLeft = UDim.new(0, 10)
        UIPaddingOption.Parent = optionButton
        
        -- Option selection
        optionButton.MouseButton1Click:Connect(function()
            selected = option
            dropdownButton.Text = selected
            
            -- Close dropdown
            isOpen = false
            createTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 55)}, 0.2):Play()
            createTween(arrowIcon, {Rotation = 0}, 0.2):Play()
            task.wait(0.2)
            dropdownContainer.Visible = false
            
            -- Callback
            if callback then callback(selected) end
        end)
        
        -- Hover effect
        optionButton.MouseEnter:Connect(function()
            createTween(optionButton, {BackgroundTransparency = 0.8}, 0.2):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            createTween(optionButton, {BackgroundTransparency = 1}, 0.2):Play()
        end)
        
        table.insert(optionButtons, optionButton)
    end
    
    -- Toggle dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            -- Calculate dropdown container height
            local containerHeight = #options * 25
            dropdownContainer.Visible = true
            createTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 55 + containerHeight)}, 0.2):Play()
            createTween(arrowIcon, {Rotation = 180}, 0.2):Play()
        else
            createTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 55)}, 0.2):Play()
            createTween(arrowIcon, {Rotation = 0}, 0.2):Play()
            task.wait(0.2)
            dropdownContainer.Visible = false
        end
    end)
    
    -- Hover effects
    dropdownButton.MouseEnter:Connect(function()
        onHover(dropdownButton, true)
    end)
    
    dropdownButton.MouseLeave:Connect(function()
        onHover(dropdownButton, false)
    end)
    
    return dropdownFrame
end

function Window:CreateTextbox(text, placeholder, callback)
    self.ElementIndex = self.ElementIndex + 1
    
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "Textbox"..self.ElementIndex
    textboxFrame.BackgroundTransparency = 1
    textboxFrame.Size = UDim2.new(1, 0, 0, 55)
    textboxFrame.LayoutOrder = self.ElementIndex
    textboxFrame.Parent = self.ContentFrame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = FONT
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.TextSize = TEXT_SIZE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = textboxFrame
    
    local textboxContainer = Instance.new("Frame")
    textboxContainer.Name = "TextboxContainer"
    textboxContainer.BackgroundColor3 = SECONDARY_COLOR
    textboxContainer.BorderSizePixel = 0
    textboxContainer.Position = UDim2.new(0, 0, 0, 25)
    textboxContainer.Size = UDim2.new(1, 0, 0, 30)
    textboxContainer.Parent = textboxFrame
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = textboxContainer
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "Textbox"
    textbox.BackgroundTransparency = 1
    textbox.Size = UDim2.new(1, 0, 1, 0)
    textbox.Font = FONT
    textbox.PlaceholderText = placeholder or "Type here..."
    textbox.Text = ""
    textbox.TextColor3 = TEXT_COLOR
    textbox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    textbox.TextSize = TEXT_SIZE
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = textboxContainer
    
    -- Padding for text
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.Parent = textbox
    
    -- Callback on focus lost
    textbox.FocusLost:Connect(function(enterPressed)
        if callback then callback(textbox.Text) end
    end)
    
    -- Hover effects
    textbox.MouseEnter:Connect(function()
        onHover(textboxContainer, true)
    end)
    
    textbox.MouseLeave:Connect(function()
        onHover(textboxContainer, false)
    end)
    
    return textboxFrame
end

-- Return the library
return UILibrary
