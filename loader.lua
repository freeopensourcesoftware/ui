local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local SmoothUI = {
    Version = "1.0.0",
    OpenFrames = {},
    Elements = {},
    Connections = {},
    Theme = {
        Primary = Color3.fromRGB(32, 32, 42),
        Secondary = Color3.fromRGB(24, 24, 32),
        Accent = Color3.fromRGB(114, 137, 218),
        TextColor = Color3.fromRGB(255, 255, 255),
        DarkTextColor = Color3.fromRGB(175, 175, 175),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(240, 71, 71)
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        SemiBold = Enum.Font.GothamSemibold,
        Bold = Enum.Font.GothamBold
    }
}

local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function tween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function makeUICorner(instance, radius)
    local corner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 4)
    })
    corner.Parent = instance
    return corner
end

local function makeUIStroke(instance, color, thickness)
    local stroke = createInstance("UIStroke", {
        Color = color or SmoothUI.Theme.Accent,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    stroke.Parent = instance
    return stroke
end

local function makeUIPadding(instance, top, right, bottom, left)
    local padding = createInstance("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0)
    })
    padding.Parent = instance
    return padding
end

local function isDragging(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
end

local function makeDraggable(frame, handleFrame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    handleFrame = handleFrame or frame
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    handleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handleFrame.InputChanged:Connect(function(input)
        if isDragging(input) and dragging then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
end

function SmoothUI:Toast(message, type, duration)
    duration = duration or 3
    type = type or "info"
    
    local colors = {
        info = self.Theme.Accent,
        success = self.Theme.Success,
        warning = self.Theme.Warning,
        error = self.Theme.Error
    }
    
    local toastColor = colors[type:lower()] or self.Theme.Accent
    
    local screenGui = createInstance("ScreenGui", {
        Name = HttpService:GenerateGUID(false),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local container = createInstance("Frame", {
        Name = "ToastContainer",
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(0, 280, 0, 70),
        Position = UDim2.new(1, 10, 0.85, 0),
        AnchorPoint = Vector2.new(1, 1),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    makeUICorner(container, 6)
    makeUIStroke(container, toastColor, 1)
    
    local accentBar = createInstance("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = toastColor,
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Parent = container
    })
    makeUICorner(accentBar, 6)
    
    local textLabel = createInstance("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = message,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        Font = self.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        Parent = container
    })
    
    tween(container, {Position = UDim2.new(1, -20, 0.85, 0)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(duration, function()
        tween(container, {Position = UDim2.new(1, 10, 0.85, 0)}, 0.3).Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    return screenGui
end

function SmoothUI:CreateWindow(title, options)
    options = options or {}
    local windowSize = options.size or UDim2.new(0, 600, 0, 400)
    local draggable = options.draggable ~= nil and options.draggable or true
    
    local window = {}
    window.Pages = {}
    window.CurrentPage = nil
    
    local screenGui = createInstance("ScreenGui", {
        Name = HttpService:GenerateGUID(false),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local mainFrame = createInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = self.Theme.Secondary,
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    window.MainFrame = mainFrame
    makeUICorner(mainFrame, 8)
    makeUIStroke(mainFrame, self.Theme.Accent, 1)
    
    if draggable then
        makeDraggable(mainFrame)
    end
    
    local titleBar = createInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    makeUICorner(titleBar, 8)
    
    local titleBottomFrame = createInstance("Frame", {
        Name = "TitleBottomFrame",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -5),
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    local titleLabel = createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = title or "SmoothUI Window",
        TextColor3 = self.Theme.TextColor,
        TextSize = 16,
        Font = self.Fonts.SemiBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = titleBar
    })
    
    local closeButton = createInstance("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Text = "✕",
        TextColor3 = self.Theme.TextColor,
        TextSize = 16,
        Font = self.Fonts.SemiBold,
        Parent = titleBar
    })
    
    closeButton.MouseButton1Click:Connect(function()
        tween(mainFrame, {Position = UDim2.new(1.5, 0, 0.5, 0)}, 0.3).Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    local sideBar = createInstance("Frame", {
        Name = "SideBar",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(0, 120, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    
    local sideBarCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = sideBar
    })
    
    local sideBarRightFrame = createInstance("Frame", {
        Name = "SideBarRightFrame",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -5, 0, 0),
        BorderSizePixel = 0,
        Parent = sideBar
    })
    
    local tabsContainer = createInstance("ScrollingFrame", {
        Name = "TabsContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sideBar
    })
    makeUIPadding(tabsContainer, 10, 0, 10, 0)
    
    local tabsLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabsContainer
    })
    
    local tabsUIScaleFactor = createInstance("UIScale", {
        Scale = 1,
        Parent = tabsContainer
    })
    
    local contentContainer = createInstance("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -130, 1, -45),
        Position = UDim2.new(0, 125, 0, 40),
        ClipsDescendants = true,
        Parent = mainFrame
    })
    
    function window:AddPage(name)
        local page = {}
        local pageOrder = #self.Pages + 1
        
        local tabButton = createInstance("TextButton", {
            Name = name .. "Tab",
            BackgroundColor3 = SmoothUI.Theme.Secondary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 32),
            BorderSizePixel = 0,
            Text = "",
            Parent = tabsContainer
        })
        makeUICorner(tabButton, 6)
        
        local tabContent = createInstance("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Text = name,
            TextColor3 = SmoothUI.Theme.DarkTextColor,
            TextSize = 14,
            Font = SmoothUI.Fonts.Regular,
            Parent = tabButton
        })
        
        local pageContainer = createInstance("ScrollingFrame", {
            Name = name .. "Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = SmoothUI.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentContainer
        })
        makeUIPadding(pageContainer, 5, 5, 5, 5)
        
        local elementsLayout = createInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = pageContainer
        })
        
        elementsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pageContainer.CanvasSize = UDim2.new(0, 0, 0, elementsLayout.AbsoluteContentSize.Y + 10)
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            if window.CurrentPage then
                tween(window.CurrentPage.Button, {BackgroundTransparency = 1}, 0.2)
                tween(window.CurrentPage.Label, {TextColor3 = SmoothUI.Theme.DarkTextColor}, 0.2)
                window.CurrentPage.Container.Visible = false
            end
            
            tween(tabButton, {BackgroundTransparency = 0}, 0.2)
            tween(tabContent, {TextColor3 = SmoothUI.Theme.TextColor}, 0.2)
            pageContainer.Visible = true
            window.CurrentPage = {
                Button = tabButton,
                Label = tabContent,
                Container = pageContainer
            }
        end)
        
        function page:AddButton(text, callback)
            callback = callback or function() end
            
            local button = createInstance("TextButton", {
                Name = text .. "Button",
                BackgroundColor3 = SmoothUI.Theme.Primary,
                Size = UDim2.new(1, 0, 0, 36),
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = pageContainer
            })
            makeUICorner(button, 6)
            
            local buttonText = createInstance("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Text = text,
                TextColor3 = SmoothUI.Theme.TextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = button
            })
            
            button.MouseEnter:Connect(function()
                tween(button, {BackgroundColor3 = SmoothUI.Theme.Accent}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                tween(button, {BackgroundColor3 = SmoothUI.Theme.Primary}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                tween(button, {BackgroundColor3 = Color3.fromRGB(
                    SmoothUI.Theme.Accent.R * 0.8,
                    SmoothUI.Theme.Accent.G * 0.8,
                    SmoothUI.Theme.Accent.B * 0.8
                )}, 0.1).Completed:Connect(function()
                    tween(button, {BackgroundColor3 = SmoothUI.Theme.Accent}, 0.1)
                end)
                
                callback()
            end)
            
            return button
        end
        
        function page:AddToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            
            local toggled = default
            
            local toggleContainer = createInstance("Frame", {
                Name = text .. "Toggle",
                BackgroundColor3 = SmoothUI.Theme.Primary,
                Size = UDim2.new(1, 0, 0, 36),
                BorderSizePixel = 0,
                Parent = pageContainer
            })
            makeUICorner(toggleContainer, 6)
            
            local toggleText = createInstance("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Text = text,
                TextColor3 = SmoothUI.Theme.TextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = toggleContainer
            })
            
            local toggleButton = createInstance("Frame", {
                Name = "ToggleButton",
                BackgroundColor3 = toggled and SmoothUI.Theme.Accent or SmoothUI.Theme.Secondary,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BorderSizePixel = 0,
                Parent = toggleContainer
            })
            makeUICorner(toggleButton, 10)
            
            local toggleCircle = createInstance("Frame", {
                Name = "Circle",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(toggled and 1 or 0, toggled and -18 or 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BorderSizePixel = 0,
                Parent = toggleButton
            })
            makeUICorner(toggleCircle, 10)
            
            local toggleHitbox = createInstance("TextButton", {
                Name = "Hitbox",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = "",
                Parent = toggleContainer
            })
            
            local function toggle()
                toggled = not toggled
                tween(toggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
                tween(toggleButton, {BackgroundColor3 = toggled and SmoothUI.Theme.Accent or SmoothUI.Theme.Secondary}, 0.2)
                callback(toggled)
            end
            
            toggleHitbox.MouseButton1Click:Connect(toggle)
            
            toggleContainer.MouseEnter:Connect(function()
                tween(toggleContainer, {BackgroundColor3 = Color3.fromRGB(
                    SmoothUI.Theme.Primary.R * 1.2,
                    SmoothUI.Theme.Primary.G * 1.2,
                    SmoothUI.Theme.Primary.B * 1.2
                )}, 0.2)
            end)
            
            toggleContainer.MouseLeave:Connect(function()
                tween(toggleContainer, {BackgroundColor3 = SmoothUI.Theme.Primary}, 0.2)
            end)
            
            local toggleFunctions = {}
            
            function toggleFunctions:Set(value)
                if value ~= toggled then
                    toggle()
                end
            end
            
            function toggleFunctions:Get()
                return toggled
            end
            
            return toggleFunctions
        end
        
        function page:AddSlider(text, options, callback)
            options = options or {}
            local min = options.min or 0
            local max = options.max or 100
            local default = math.clamp(options.default or min, min, max)
            local decimals = options.decimals or 0
            callback = callback or function() end
            
            local value = default
            local sliding = false
            
            local sliderContainer = createInstance("Frame", {
                Name = text .. "Slider",
                BackgroundColor3 = SmoothUI.Theme.Primary,
                Size = UDim2.new(1, 0, 0, 50),
                BorderSizePixel = 0,
                Parent = pageContainer
            })
            makeUICorner(sliderContainer, 6)
            
            local sliderText = createInstance("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -80, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                Text = text,
                TextColor3 = SmoothUI.Theme.TextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = sliderContainer
            })
            
            local valueText = createInstance("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -70, 0, 5),
                Text = tostring(value),
                TextColor3 = SmoothUI.Theme.TextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = sliderContainer
            })
            
            local sliderFrame = createInstance("Frame", {
                Name = "SliderFrame",
                BackgroundColor3 = SmoothUI.Theme.Secondary,
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 1, -15),
                BorderSizePixel = 0,
                Parent = sliderContainer
            })
            makeUICorner(sliderFrame, 3)
            
            local sliderFill = createInstance("Frame", {
                Name = "Fill",
                BackgroundColor3 = SmoothUI.Theme.Accent,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BorderSizePixel = 0,
                Parent = sliderFrame
            })
            makeUICorner(sliderFill, 3)
            
            local sliderButton = createInstance("TextButton", {
                Name = "SliderButton",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, -7),
                Text = "",
                Parent = sliderFrame
            })
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                local newValue = math.floor((min + (max - min) * sizeX) * 10^decimals) / 10^decimals
                
                if newValue ~= value then
                    value = newValue
                    valueText.Text = tostring(value)
                    tween(sliderFill, {Size = UDim2.new(sizeX, 0, 1, 0)}, 0.1)
                    callback(value)
                end
            end
            
            sliderButton.MouseButton1Down:Connect(function(input)
                sliding = true
                updateSlider({Position = Vector2.new(input.X, input.Y)})
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and sliding then
                    sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
                    updateSlider({Position = Vector2.new(input.Position.X, input.Position.Y)})
                end
            end)
            
            local sliderFunctions = {}
            
            function sliderFunctions:Set(newValue)
                newValue = math.clamp(newValue, min, max)
                if newValue ~= value then
                    value = newValue
                    valueText.Text = tostring(value)
                    tween(sliderFill, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)}, 0.1)
                    callback(value)
                end
            end
            
            function sliderFunctions:Get()
                return value
            end
            
            return sliderFunctions
        end
        
        function page:AddTextbox(text, placeholder, callback)
            placeholder = placeholder or "Enter text..."
            callback = callback or function() end
            
            local textboxContainer = createInstance("Frame", {
                Name = text .. "Textbox",
                BackgroundColor3 = SmoothUI.Theme.Primary,
                Size = UDim2.new(1, 0, 0, 60),
                BorderSizePixel = 0,
                Parent = pageContainer
            })
            makeUICorner(textboxContainer, 6)
            
            local textboxLabel = createInstance("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                Text = text,
                TextColor3 = SmoothUI.Theme.TextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = textboxContainer
            })
            
            local textboxFrame = createInstance("Frame", {
                Name = "TextboxFrame",
                BackgroundColor3 = SmoothUI.Theme.Secondary,
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 10, 1, -30),
                BorderSizePixel = 0,
                Parent = textboxContainer
            })
            makeUICorner(textboxFrame, 4)
            
            local textbox = createInstance("TextBox", {
                Name = "Textbox",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Text = "",
                PlaceholderText = placeholder,
                TextColor3 = SmoothUI.Theme.TextColor,
                PlaceholderColor3 = SmoothUI.Theme.DarkTextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                ClearTextOnFocus = false,
                Parent = textboxFrame
            })
            
            textbox.Focused:Connect(function()
                tween(textboxFrame, {BorderSizePixel = 1}, 0.1)
                makeUIStroke(textboxFrame, SmoothUI.Theme.Accent, 1)
            end)
            
            textbox.FocusLost:Connect(function(enterPressed)
                textboxFrame:FindFirstChildOfClass("UIStroke"):Destroy()
                tween(textboxFrame, {BorderSizePixel = 0}, 0.1)
                if enterPressed then
                    callback(textbox.Text)
                end
            end)
            
            local textboxFunctions = {}
            
            function textboxFunctions:Set(value)
                textbox.Text = value
                callback(value)
            end
            
            function textboxFunctions:Get()
                return textbox.Text
            end
            
            return textboxFunctions
        end
        
        function page:AddLabel(text)
            local labelFrame = createInstance("Frame", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = pageContainer
            })
            
            local label = createInstance("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = text,
                TextColor3 = SmoothUI.Theme.TextColor,
                TextSize = 14,
                Font = SmoothUI.Fonts.SemiBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = labelFrame
            })
            
            local labelFunctions = {}
            
            function labelFunctions:Set(value)
                label.Text = value
            end
            
            return labelFunctions
        end
        
        self.Pages[pageOrder] = {
            Name = name,
            Button = tabButton,
            Label = tabContent,
            Container = pageContainer
        }
        
        if pageOrder == 1 then
            tabButton.BackgroundTransparency = 0
            tabContent.TextColor3 = SmoothUI.Theme.TextColor
            pageContainer.Visible = true
            window.CurrentPage = {
                Button = tabButton,
                Label = tabContent,
                Container = pageContainer
            }
        end
        
        return page
    end
    
    return window
end

local ui = SmoothUI

return ui
