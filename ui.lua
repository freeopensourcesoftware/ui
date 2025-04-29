local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Utility = {}

function Utility:Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    
    return instance
end

function Utility:Tween(instance, properties, duration, easingStyle, easingDirection, repeatCount, reverses, delay)
    local info = TweenInfo.new(
        duration or 0.5,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out,
        repeatCount or 0,
        reverses or false,
        delay or 0
    )
    
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    
    return tween
end

function Utility:GetTextSize(text, fontSize, font, frameSize)
    return TextService:GetTextSize(text, fontSize, font, frameSize)
end

function Utility:Ripple(button, x, y)
    local ripple = Utility:Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = 10,
        Parent = button,
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple,
    })
    
    local buttonSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    local tweenGoal = {Size = UDim2.new(0, buttonSize, 0, buttonSize), BackgroundTransparency = 1}
    local tween = Utility:Tween(ripple, tweenGoal, 0.5)
    
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local Toast = {}
Toast.__index = Toast

function Toast.new(title, message, duration, type)
    local self = setmetatable({}, Toast)
    
    self.Title = title or "Notification"
    self.Message = message or ""
    self.Duration = duration or 3
    self.Type = type or "Info"
    
    self:Create()
    
    return self
end

function Toast:GetColor()
    local colors = {
        Info = Color3.fromRGB(66, 135, 245),
        Success = Color3.fromRGB(80, 180, 120),
        Warning = Color3.fromRGB(245, 193, 66),
        Error = Color3.fromRGB(245, 87, 87)
    }
    
    return colors[self.Type] or colors.Info
end

function Toast:Create()
    local container = CoreGui:FindFirstChild("ToastContainer")
    
    if not container then
        container = Utility:Create("ScreenGui", {
            Name = "ToastContainer",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
        
        local holder = Utility:Create("Frame", {
            Name = "NotificationHolder",
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.new(0, 300, 1, -40),
            Parent = container
        })
        
        Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Parent = holder
        })
    end
    
    local holder = container:FindFirstChild("NotificationHolder")
    
    local notification = Utility:Create("Frame", {
        Name = "Notification",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 300, 0, 0),
        ClipsDescendants = true,
        Parent = holder
    })
    
    local textSize = Utility:GetTextSize(
        self.Message,
        14,
        Enum.Font.Gotham,
        Vector2.new(280, math.huge)
    )
    local height = math.max(80, textSize.Y + 60)
    
    notification.Size = UDim2.new(0, 300, 0, 0)
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notification
    })
    
    local accent = Utility:Create("Frame", {
        Name = "Accent",
        BackgroundColor3 = self:GetColor(),
        Size = UDim2.new(0, 4, 1, 0),
        Parent = notification
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = accent
    })
    
    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    local messageLabel = Utility:Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -30, 1, -45),
        Font = Enum.Font.Gotham,
        Text = self.Message,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notification
    })
    
    local closeButton = Utility:Create("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -5, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 20,
        Parent = notification
    })
    
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    Utility:Tween(notification, {Size = UDim2.new(0, 300, 0, height)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.delay(self.Duration, function()
        self:Close()
    end)
    
    self.Frame = notification
end

function Toast:Close()
    if not self.Frame or self.Closing then return end
    self.Closing = true
    
    Utility:Tween(self.Frame, {Size = UDim2.new(0, 300, 0, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out).Completed:Connect(function()
        self.Frame:Destroy()
    end)
end

local Library = {
    Name = "Smooth UI",
    Theme = {
        Background = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(66, 135, 245),
        LightContrast = Color3.fromRGB(35, 35, 40),
        DarkContrast = Color3.fromRGB(20, 20, 25),
        TextColor = Color3.fromRGB(255, 255, 255),
        SubTextColor = Color3.fromRGB(200, 200, 200)
    },
    Flags = {},
    Pages = {},
    ActivePage = nil
}

function Library:SetTheme(theme)
    for key, value in pairs(theme) do
        if self.Theme[key] then
            self.Theme[key] = value
        end
    end
    
    if self.GUI then
    end
end

function Library:Toast(title, message, duration, type)
    return Toast.new(title, message, duration, type)
end

function Library:Validate(defaults, options)
    options = options or {}
    
    for key, value in pairs(defaults) do
        if options[key] == nil then
            options[key] = value
        end
    end
    
    return options
end

function Library:Create(options)
    options = self:Validate({
        Name = "Smooth UI",
        Size = UDim2.new(0, 600, 0, 400),
        Draggable = true,
        ToggleKey = Enum.KeyCode.RightShift
    }, options)
    
    if self.GUI then
        self.GUI:Destroy()
    end
    
    local gui = Utility:Create("ScreenGui", {
        Name = "SmoothUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    local main = Utility:Create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = options.Size,
        Parent = gui
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = main
    })
    
    local shadow = Utility:Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = main
    })
    
    local titleBar = Utility:Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.DarkContrast,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = main
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = titleBar
    })
    
    local bottomFrame = Utility:Create("Frame", {
        Name = "BottomFrame",
        BackgroundColor3 = self.Theme.DarkContrast,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        Parent = titleBar
    })
    
    local title = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = options.Name,
        TextColor3 = self.Theme.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    local closeButton = Utility:Create("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.SubTextColor,
        TextSize = 24,
        Parent = titleBar
    })
    
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = self.Theme.TextColor
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = self.Theme.SubTextColor
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)
    
    local container = Utility:Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        Parent = main
    })
    
    local sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = self.Theme.LightContrast,
        Size = UDim2.new(0, 150, 1, 0),
        Parent = container
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = sidebar
    })
    
    local sidebarFix = Utility:Create("Frame", {
        Name = "SidebarFix",
        BackgroundColor3 = self.Theme.LightContrast,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Parent = sidebar
    })
    
    local pageButtons = Utility:Create("ScrollingFrame", {
        Name = "PageButtons",
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Parent = sidebar
    })
    
    Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = pageButtons
    })
    
    Utility:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = pageButtons
    })
    
    local pageContainer = Utility:Create("Frame", {
        Name = "PageContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 0),
        Size = UDim2.new(1, -150, 1, 0),
        Parent = container
    })
    
    if options.Draggable then
        local dragging, dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == options.ToggleKey then
            gui.Enabled = not gui.Enabled
        end
    end)
    
    self.GUI = gui
    self.Main = main
    self.Container = container
    self.PageButtons = pageButtons
    self.PageContainer = pageContainer
    
    return self
end

function Library:Page(name, icon)
    local page = {
        Name = name,
        Icon = icon or "rbxassetid://3926305904",
        Sections = {},
        Active = false
    }
    
    local button = Utility:Create("TextButton", {
        Name = name .. "Button",
        BackgroundColor3 = self.Theme.DarkContrast,
        Size = UDim2.new(1, 0, 0, 36),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        AutoButtonColor = false,
        Parent = self.PageButtons
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })
    
    local iconImage = Utility:Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(0, 20, 0, 20),
        Image = icon or "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(764, 244),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = self.Theme.SubTextColor,
        Parent = button
    })
    
    local title = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -36, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.Theme.SubTextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })
    
    local pageFrame = Utility:Create("ScrollingFrame", {
        Name = name .. "Page",
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Visible = false,
        Parent = self.PageContainer
    })
    
    Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = pageFrame
    })
    
    Utility:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingTop = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15),
        Parent = pageFrame
    })
    
    button.MouseButton1Click:Connect(function()
        self:SelectPage(name)
    end)
    
    button.MouseEnter:Connect(function()
        if not page.Active then
            Utility:Tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
            Utility:Tween(title, {TextColor3 = self.Theme.TextColor}, 0.2)
            Utility:Tween(iconImage, {ImageColor3 = self.Theme.TextColor}, 0.2)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not page.Active then
            Utility:Tween(button, {BackgroundColor3 = self.Theme.DarkContrast}, 0.2)
            Utility:Tween(title, {TextColor3 = self.Theme.SubTextColor}, 0.2)
            Utility:Tween(iconImage, {ImageColor3 = self.Theme.SubTextColor}, 0.2)
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        if not page.Active then
            Utility:Ripple(button, Mouse.X - button.AbsolutePosition.X, Mouse.Y - button.AbsolutePosition.Y)
        end
    end)
    
    page.Button = button
    page.Container = pageFrame
    page.Title = title
    page.Icon = iconImage
    
    table.insert(self.Pages, page)
    
    if #self.Pages == 1 then
        self:SelectPage(name)
    end
    
    local pageMethods = {}
    
    function pageMethods:Section(name)
        local section = {
            Name = name,
            Elements = {}
        }
        
        local sectionFrame = Utility:Create("Frame", {
            Name = name .. "Section",
            BackgroundColor3 = self.Theme.LightContrast,
            Size = UDim2.new(1, 0, 0, 36),
            Parent = pageFrame
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = sectionFrame
        })
        
        local sectionTitle = Utility:Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 8),
            Size = UDim2.new(1, -24, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = self.Theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sectionFrame
        })
        
        local container = Utility:Create("Frame", {
            Name = "Container",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 36),
            Size = UDim2.new(1, 0, 0, 0),
            Parent = sectionFrame
        })
        
        Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = container
        })
        
        Utility:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 8),
            Parent = container
        })
        
        local function updateSectionSize()
            local contentSize = container.UIListLayout.AbsoluteContentSize.Y
            container.Size = UDim2.new(1, 0, 0, contentSize + 13)
            sectionFrame.Size = UDim2.new(1, 0, 0, contentSize + 36 + 13)
            
            local totalSize = pageFrame.UIListLayout.AbsoluteContentSize.Y + 30
            pageFrame.CanvasSize = UDim2.new(0, 0, 0, totalSize)
        end
        
        container:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSectionSize)
        container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
        
        section.Container = container
        section.Frame = sectionFrame
        section.UpdateSize = updateSectionSize
        
        table.insert(page.Sections, section)
        
        function section:Button(options)
            options = Library:Validate({
                Name = "Button",
                Callback = function() end
            }, options)
            
            local buttonFrame = Utility:Create("Frame", {
                Name = options.Name .. "ButtonContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                Parent = section.Container
            })
            
            local button = Utility:Create("TextButton", {
                Name = "Button",
                BackgroundColor3 = Library.Theme.DarkContrast,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = options.Name,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                AutoButtonColor = false,
                ClipsDescendants = true,
                Parent = buttonFrame
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = button
            })
            
            button.MouseEnter:Connect(function()
                Utility:Tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utility:Tween(button, {BackgroundColor3 = Library.Theme.DarkContrast}, 0.2)
            end)
            
            button.MouseButton1Down:Connect(function()
                Utility:Ripple(button, Mouse.X - button.AbsolutePosition.X, Mouse.Y - button.AbsolutePosition.Y)
                options.Callback()
            end)
            
            section.UpdateSize()
            
            local buttonMethods = {}
            
            function buttonMethods:SetText(text)
                button.Text = text
            end
            
            function buttonMethods:SetCallback(callback)
                options.Callback = callback
            end
            
            return buttonMethods
        end
        
        function section:Toggle(options)
            options = Library:Validate({
                Name = "Toggle",
                Default = false,
                Callback = function() end,
                Flag = nil
            }, options)
            
            local toggle = Utility:Create("Frame", {
                Name = options.Name .. "ToggleContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                Parent = section.Container
            })
            
            local toggleButton = Utility:Create("TextButton", {
                Name = "ToggleButton",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = toggle
            })
            
            local title = Utility:Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -56, 1, 0),
                Font = Enum.Font.Gotham,
                Text = options.Name,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggle
            })
            
            local toggleBackground = Utility:Create("Frame", {
                Name = "Background",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Library.Theme.DarkContrast,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 46, 0, 22),
                Parent = toggle
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = toggleBackground
            })
            
            local toggleIndicator = Utility:Create("Frame", {
                Name = "Indicator",
                BackgroundColor3 = Library.Theme.TextColor,
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = toggleBackground
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = toggleIndicator
            })
            
            local value = options.Default
            
            local function updateToggle()
                if value then
                    Utility:Tween(toggleBackground, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    Utility:Tween(toggleIndicator, {Position = UDim2.new(1, -19, 0.5, 0)}, 0.2)
                else
                    Utility:Tween(toggleBackground, {BackgroundColor3 = Library.Theme.DarkContrast}, 0.2)
                    Utility:Tween(toggleIndicator, {Position = UDim2.new(0, 3, 0.5, 0)}, 0.2)
                end
                
                options.Callback(value)
                
                if options.Flag then
                    Library.Flags[options.Flag] = value
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                value = not value
                updateToggle()
            end)
            
            value = options.Default
            updateToggle()
            section.UpdateSize()
            
            local toggleMethods = {}
            
            function toggleMethods:Set(newValue)
                value = newValue
                updateToggle()
            end
            
            function toggleMethods:GetValue()
                return value
            end
            
            return toggleMethods
        end
        
        function section:Slider(options)
            options = Library:Validate({
                Name = "Slider",
                Min = 0,
                Max = 100,
                Default = 50,
                Increment = 1,
                Callback = function() end,
                Flag = nil
            }, options)
            
            local slider = Utility:Create("Frame", {
                Name = options.Name .. "SliderContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                Parent = section.Container
            })
            
            local title = Utility:Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = options.Name,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = slider
            })
            
            local valueDisplay = Utility:Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 50, 0, 20),
                Font = Enum.Font.Gotham,
                Text = options.Default,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                Parent = slider
            })
            
            local sliderBackground = Utility:Create("Frame", {
                Name = "Background",
                BackgroundColor3 = Library.Theme.DarkContrast,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 8),
                Parent = slider
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderBackground
            })
            
            local sliderFill = Utility:Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new(0.5, 0, 1, 0),
                Parent = sliderBackground
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderFill
            })
            
            local sliderThumb = Utility:Create("Frame", {
                Name = "Thumb",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Library.Theme.TextColor,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                ZIndex = 3,
                Parent = sliderBackground
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderThumb
            })
            
            local value = options.Default
            local dragging = false
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
                local newValue = math.floor((options.Min + (options.Max - options.Min) * sizeX) / options.Increment + 0.5) * options.Increment
                
                value = math.clamp(newValue, options.Min, options.Max)
                valueDisplay.Text = value
                
                sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                sliderThumb.Position = UDim2.new(sizeX, 0, 0.5, 0)
                
                options.Callback(value)
                
                if options.Flag then
                    Library.Flags[options.Flag] = value
                end
            end
            
            sliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            sliderBackground.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            local initialSize = ((value - options.Min) / (options.Max - options.Min))
            sliderFill.Size = UDim2.new(initialSize, 0, 1, 0)
            sliderThumb.Position = UDim2.new(initialSize, 0, 0.5, 0)
            valueDisplay.Text = value
            
            section.UpdateSize()
            
            local sliderMethods = {}
            
            function sliderMethods:Set(newValue)
                value = math.clamp(newValue, options.Min, options.Max)
                valueDisplay.Text = value
                
                local sizeX = (value - options.Min) / (options.Max - options.Min)
                sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                sliderThumb.Position = UDim2.new(sizeX, 0, 0.5, 0)
                
                options.Callback(value)
                
                if options.Flag then
                    Library.Flags[options.Flag] = value
                end
            end
            
            function sliderMethods:GetValue()
                return value
            end
            
            return sliderMethods
        end
        
        function section:TextBox(options)
            options = Library:Validate({
                Name = "Text Box",
                Default = "",
                PlaceholderText = "Enter text...",
                Callback = function() end,
                Flag = nil
            }, options)
            
            local textbox = Utility:Create("Frame", {
                Name = options.Name .. "TextBoxContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                Parent = section.Container
            })
            
            local title = Utility:Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = options.Name,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = textbox
            })
            
            local inputBox = Utility:Create("TextBox", {
                Name = "InputBox",
                BackgroundColor3 = Library.Theme.DarkContrast,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.Gotham,
                Text = options.Default,
                PlaceholderText = options.PlaceholderText,
                TextColor3 = Library.Theme.TextColor,
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 14,
                TextWrapped = true,
                ClearTextOnFocus = false,
                Parent = textbox
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = inputBox
            })
            
            inputBox.FocusLost:Connect(function(enterPressed)
                options.Callback(inputBox.Text)
                
                if options.Flag then
                    Library.Flags[options.Flag] = inputBox.Text
                end
            end)
            
            section.UpdateSize()
            
            local textBoxMethods = {}
            
            function textBoxMethods:Set(newValue)
                inputBox.Text = newValue
                options.Callback(newValue)
                
                if options.Flag then
                    Library.Flags[options.Flag] = newValue
                end
            end
            
            function textBoxMethods:GetValue()
                return inputBox.Text
            end
            
            return textBoxMethods
        end
        
        function section:Dropdown(options)
            options = Library:Validate({
                Name = "Dropdown",
                Default = nil,
                Options = {},
                Callback = function() end,
                Flag = nil
            }, options)
            
            local dropdown = Utility:Create("Frame", {
                Name = options.Name .. "DropdownContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true,
                Parent = section.Container
            })
            
            local title = Utility:Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = options.Name,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdown
            })
            
            local selected = Utility:Create("TextButton", {
                Name = "Selected",
                BackgroundColor3 = Library.Theme.DarkContrast,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = options.Default or "Select...",
                TextColor3 = Library.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdown
            })
            
            Utility:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                Parent = selected
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = selected
            })
            
            local icon = Utility:Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -5, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://3926307971",
                ImageRectOffset = Vector2.new(324, 364),
                ImageRectSize = Vector2.new(36, 36),
                Parent = selected
            })
            
            local itemContainer = Utility:Create("ScrollingFrame", {
                Name = "ItemContainer",
                BackgroundColor3 = Library.Theme.DarkContrast,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 60),
                Size = UDim2.new(1, 0, 0, 100),
                Visible = false,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Library.Theme.Accent,
                Parent = dropdown
            })
            
            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = itemContainer
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = itemContainer
            })
            
            local isOpen = false
            local selectedOption = options.Default
            
            local function toggleDropdown()
                isOpen = not isOpen
                
                if isOpen then
                    Utility:Tween(dropdown, {Size = UDim2.new(1, 0, 0, 160)}, 0.2)
                    itemContainer.Visible = true
                    Utility:Tween(icon, {Rotation = 180}, 0.2)
                else
                    Utility:Tween(dropdown, {Size = UDim2.new(1, 0, 0, 55)}, 0.2)
                    itemContainer.Visible = false
                    Utility:Tween(icon, {Rotation = 0}, 0.2)
                end
                
                section.UpdateSize()
            end
            
            selected.MouseButton1Click:Connect(toggleDropdown)
            
            for i, optionValue in ipairs(options.Options) do
                local item = Utility:Create("TextButton", {
                    Name = "Item_" .. i,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = tostring(optionValue),
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    Parent = itemContainer
                })
                
                Utility:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = item
                })
                
                item.MouseEnter:Connect(function()
                    Utility:Tween(item, {BackgroundTransparency = 0.9}, 0.2)
                end)
                
                item.MouseLeave:Connect(function()
                    Utility:Tween(item, {BackgroundTransparency = 1}, 0.2)
                end)
                
                item.MouseButton1Click:Connect(function()
                    selectedOption = optionValue
                    selected.Text = tostring(optionValue)
                    toggleDropdown()
                    options.Callback(optionValue)
                    
                    if options.Flag then
                        Library.Flags[options.Flag] = optionValue
                    end
                end)
            end
            
            itemContainer.CanvasSize = UDim2.new(0, 0, 0, #options.Options * 30)
            
            section.UpdateSize()
            
            local dropdownMethods = {}
            
            function dropdownMethods:Set(newValue)
                for i, optionValue in ipairs(options.Options) do
                    if optionValue == newValue then
                        selectedOption = newValue
                        selected.Text = tostring(newValue)
                        options.Callback(newValue)
                        
                        if options.Flag then
                            Library.Flags[options.Flag] = newValue
                        end
                        
                        break
                    end
                end
            end
            
            function dropdownMethods:GetValue()
                return selectedOption
            end
            
            function dropdownMethods:Refresh(newOptions)
                for _, child in pairs(itemContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                options.Options = newOptions
                
                for i, optionValue in ipairs(options.Options) do
                    local item = Utility:Create("TextButton", {
                        Name = "Item_" .. i,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = tostring(optionValue),
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        Parent = itemContainer
                    })
                    
                    Utility:Create("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = item
                    })
                    
                    item.MouseEnter:Connect(function()
                        Utility:Tween(item, {BackgroundTransparency = 0.9}, 0.2)
                    end)
                    
                    item.MouseLeave:Connect(function()
                        Utility:Tween(item, {BackgroundTransparency = 1}, 0.2)
                    end)
                    
                    item.MouseButton1Click:Connect(function()
                        selectedOption = optionValue
                        selected.Text = tostring(optionValue)
                        toggleDropdown()
                        options.Callback(optionValue)
                        
                        if options.Flag then
                            Library.Flags[options.Flag] = optionValue
                        end
                    end)
                end
                
                itemContainer.CanvasSize = UDim2.new(0, 0, 0, #options.Options * 30)
            end
            
            return dropdownMethods
        end
        
        return section
    end
    
    return pageMethods
end

function Library:SelectPage(pageName)
    for _, page in pairs(self.Pages) do
        if page.Name == pageName then
            if self.ActivePage then
                self.ActivePage.Container.Visible = false
                
                Utility:Tween(self.ActivePage.Button, {BackgroundColor3 = self.Theme.DarkContrast}, 0.2)
                Utility:Tween(self.ActivePage.Title, {TextColor3 = self.Theme.SubTextColor}, 0.2)
                Utility:Tween(self.ActivePage.Icon, {ImageColor3 = self.Theme.SubTextColor}, 0.2)
                
                self.ActivePage.Active = false
            end
            
            page.Container.Visible = true
            
            Utility:Tween(page.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            Utility:Tween(page.Title, {TextColor3 = self.Theme.TextColor}, 0.2)
            Utility:Tween(page.Icon, {ImageColor3 = self.Theme.TextColor}, 0.2)
            
            page.Active = true
            self.ActivePage = page
            
            break
        end
    end
end

function Library:GetFlag(flag)
    return self.Flags[flag]
end

function Library:SetFlag(flag, value)
    self.Flags[flag] = value
end

return Library
