local UILibrary = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Library = {
    Tabs = {},
    SelectedTab = nil,
    ToggleUI = Enum.KeyCode.RightControl,
    WindowOpened = false,
    Elements = {}
}

function UILibrary:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Parent = MainFrame
    
    local UICornerTopBar = Instance.new("UICorner")
    UICornerTopBar.CornerRadius = UDim.new(0, 8)
    UICornerTopBar.Parent = TopBar
    
    local BottomFrame = Instance.new("Frame")
    BottomFrame.Name = "BottomFrame"
    BottomFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    BottomFrame.BorderSizePixel = 0
    BottomFrame.Position = UDim2.new(0, 0, 1, -5)
    BottomFrame.Size = UDim2.new(1, 0, 0, 5)
    BottomFrame.ZIndex = 0
    BottomFrame.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "UI Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Parent = TopBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
        Library.WindowOpened = false
    end)
    
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Position = UDim2.new(0, 10, 0, 50)
    TabsFrame.Size = UDim2.new(0, 150, 1, -110)
    TabsFrame.Parent = MainFrame
    
    local UICornerTabs = Instance.new("UICorner")
    UICornerTabs.CornerRadius = UDim.new(0, 8)
    UICornerTabs.Parent = TabsFrame
    
    local TabsList = Instance.new("ScrollingFrame")
    TabsList.Name = "TabsList"
    TabsList.BackgroundTransparency = 1
    TabsList.Position = UDim2.new(0, 0, 0, 10)
    TabsList.Size = UDim2.new(1, 0, 1, -20)
    TabsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsList.ScrollBarThickness = 2
    TabsList.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    TabsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsList.Parent = TabsFrame
    
    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 5)
    TabsListLayout.Parent = TabsList
    
    local TabsListPadding = Instance.new("UIPadding")
    TabsListPadding.PaddingTop = UDim.new(0, 5)
    TabsListPadding.PaddingBottom = UDim.new(0, 5)
    TabsListPadding.Parent = TabsList
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 170, 0, 50)
    ContentFrame.Size = UDim2.new(1, -180, 1, -110)
    ContentFrame.Parent = MainFrame
    
    local UICornerContent = Instance.new("UICorner")
    UICornerContent.CornerRadius = UDim.new(0, 8)
    UICornerContent.Parent = ContentFrame
    
    local UserProfileFrame = Instance.new("Frame")
    UserProfileFrame.Name = "UserProfileFrame"
    UserProfileFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    UserProfileFrame.BorderSizePixel = 0
    UserProfileFrame.Position = UDim2.new(0, 10, 1, -50)
    UserProfileFrame.Size = UDim2.new(0, 150, 0, 40)
    UserProfileFrame.Parent = MainFrame
    
    local UICornerUserProfile = Instance.new("UICorner")
    UICornerUserProfile.CornerRadius = UDim.new(0, 8)
    UICornerUserProfile.Parent = UserProfileFrame
    
    local UserAvatar = Instance.new("ImageLabel")
    UserAvatar.Name = "UserAvatar"
    UserAvatar.BackgroundTransparency = 1
    UserAvatar.Position = UDim2.new(0, 5, 0.5, -15)
    UserAvatar.Size = UDim2.new(0, 30, 0, 30)
    UserAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    UserAvatar.Parent = UserProfileFrame
    
    local UICornerAvatar = Instance.new("UICorner")
    UICornerAvatar.CornerRadius = UDim.new(1, 0)
    UICornerAvatar.Parent = UserAvatar
    
    local UserName = Instance.new("TextLabel")
    UserName.Name = "UserName"
    UserName.BackgroundTransparency = 1
    UserName.Position = UDim2.new(0, 40, 0, 0)
    UserName.Size = UDim2.new(1, -45, 1, 0)
    UserName.Font = Enum.Font.GothamSemibold
    UserName.Text = LocalPlayer.DisplayName
    UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserName.TextSize = 14
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.TextTruncate = Enum.TextTruncate.AtEnd
    UserName.Parent = UserProfileFrame
    
    local function updateUserProfile()
        UserName.Text = LocalPlayer.DisplayName
        
        local userId = LocalPlayer.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        
        local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        UserAvatar.Image = content
    end
    
    updateUserProfile()
    
    local Window = {}
    
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Parent = TabsList
        
        local UICornerTabButton = Instance.new("UICorner")
        UICornerTabButton.CornerRadius = UDim.new(0, 6)
        UICornerTabButton.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentFrame
        
        local ElementList = Instance.new("UIListLayout")
        ElementList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ElementList.SortOrder = Enum.SortOrder.LayoutOrder
        ElementList.Padding = UDim.new(0, 8)
        ElementList.Parent = TabContent
        
        local ElementPadding = Instance.new("UIPadding")
        ElementPadding.PaddingTop = UDim.new(0, 5)
        ElementPadding.PaddingBottom = UDim.new(0, 5)
        ElementPadding.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Library.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            Library.SelectedTab = name
        end)
        
        local Tab = {
            Name = name,
            Content = TabContent,
            Button = TabButton
        }
        
        table.insert(Library.Tabs, Tab)
        
        if #Library.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            Library.SelectedTab = name
        end
        
        local TabElements = {}
        
        function TabElements:CreateButton(btnText, callback)
            callback = callback or function() end
            
            local ButtonElement = Instance.new("Frame")
            ButtonElement.Name = btnText .. "Button"
            ButtonElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            ButtonElement.Size = UDim2.new(1, 0, 0, 35)
            ButtonElement.Parent = TabContent
            
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.CornerRadius = UDim.new(0, 6)
            UICornerButton.Parent = ButtonElement
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
            Button.Position = UDim2.new(0, 10, 0.5, -12)
            Button.Size = UDim2.new(0, 120, 0, 25)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = btnText
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.AutoButtonColor = false
            Button.Parent = ButtonElement
            
            local UICornerActionButton = Instance.new("UICorner")
            UICornerActionButton.CornerRadius = UDim.new(0, 4)
            UICornerActionButton.Parent = Button
            
            local ButtonDescription = Instance.new("TextLabel")
            ButtonDescription.Name = "Description"
            ButtonDescription.BackgroundTransparency = 1
            ButtonDescription.Position = UDim2.new(0, 140, 0.5, -10)
            ButtonDescription.Size = UDim2.new(1, -150, 0, 20)
            ButtonDescription.Font = Enum.Font.Gotham
            ButtonDescription.Text = btnText
            ButtonDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonDescription.TextSize = 14
            ButtonDescription.TextXAlignment = Enum.TextXAlignment.Left
            ButtonDescription.Parent = ButtonElement
            
            Button.MouseButton1Click:Connect(function()
                callback()
                
                local ClickAnimation = TweenService:Create(
                    Button,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(30, 60, 150)}
                )
                ClickAnimation:Play()
                
                wait(0.15)
                
                local ReturnAnimation = TweenService:Create(
                    Button,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(50, 100, 255)}
                )
                ReturnAnimation:Play()
            end)
            
            return ButtonElement
        end
        
        function TabElements:CreateToggle(toggleText, default, callback)
            default = default or false
            callback = callback or function() end
            
            local ToggleValue = default
            
            local ToggleElement = Instance.new("Frame")
            ToggleElement.Name = toggleText .. "Toggle"
            ToggleElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            ToggleElement.Size = UDim2.new(1, 0, 0, 35)
            ToggleElement.Parent = TabContent
            
            local UICornerToggle = Instance.new("UICorner")
            UICornerToggle.CornerRadius = UDim.new(0, 6)
            UICornerToggle.Parent = ToggleElement
            
            local ToggleBG = Instance.new("Frame")
            ToggleBG.Name = "ToggleBG"
            ToggleBG.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            ToggleBG.Position = UDim2.new(0, 10, 0.5, -10)
            ToggleBG.Size = UDim2.new(0, 40, 0, 20)
            ToggleBG.Parent = ToggleElement
            
            local UICornerToggleBG = Instance.new("UICorner")
            UICornerToggleBG.CornerRadius = UDim.new(1, 0)
            UICornerToggleBG.Parent = ToggleBG
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleButton.Position = default and UDim2.new(0.5, 0, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            ToggleButton.Size = UDim2.new(0, 14, 0, 14)
            ToggleButton.Parent = ToggleBG
            
            local UICornerToggleButton = Instance.new("UICorner")
            UICornerToggleButton.CornerRadius = UDim.new(1, 0)
            UICornerToggleButton.Parent = ToggleButton
            
            local ToggleDescription = Instance.new("TextLabel")
            ToggleDescription.Name = "Description"
            ToggleDescription.BackgroundTransparency = 1
            ToggleDescription.Position = UDim2.new(0, 60, 0.5, -10)
            ToggleDescription.Size = UDim2.new(1, -70, 0, 20)
            ToggleDescription.Font = Enum.Font.Gotham
            ToggleDescription.Text = toggleText
            ToggleDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleDescription.TextSize = 14
            ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDescription.Parent = ToggleElement
            
            if default then
                ToggleBG.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
                ToggleButton.Position = UDim2.new(1, -17, 0.5, -7)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                callback(true)
            end
            
            local Toggling = false
            
            ToggleBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not Toggling then
                    Toggling = true
                    ToggleValue = not ToggleValue
                    
                    if ToggleValue then
                        local ToggleOnAnim = TweenService:Create(
                            ToggleButton,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
                        )
                        local BGOnAnim = TweenService:Create(
                            ToggleBG,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(50, 100, 255)}
                        )
                        ToggleOnAnim:Play()
                        BGOnAnim:Play()
                    else
                        local ToggleOffAnim = TweenService:Create(
                            ToggleButton,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}
                        )
                        local BGOffAnim = TweenService:Create(
                            ToggleBG,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}
                        )
                        ToggleOffAnim:Play()
                        BGOffAnim:Play()
                    end
                    
                    callback(ToggleValue)
                    wait(0.15)
                    Toggling = false
                end
            end)
            
            ToggleDescription.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not Toggling then
                    Toggling = true
                    ToggleValue = not ToggleValue
                    
                    if ToggleValue then
                        local ToggleOnAnim = TweenService:Create(
                            ToggleButton,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
                        )
                        local BGOnAnim = TweenService:Create(
                            ToggleBG,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(50, 100, 255)}
                        )
                        ToggleOnAnim:Play()
                        BGOnAnim:Play()
                    else
                        local ToggleOffAnim = TweenService:Create(
                            ToggleButton,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}
                        )
                        local BGOffAnim = TweenService:Create(
                            ToggleBG,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}
                        )
                        ToggleOffAnim:Play()
                        BGOffAnim:Play()
                    end
                    
                    callback(ToggleValue)
                    wait(0.15)
                    Toggling = false
                end
            end)
            
            return ToggleElement
        end
        
        function TabElements:CreateSlider(sliderText, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            local SliderElement = Instance.new("Frame")
            SliderElement.Name = sliderText .. "Slider"
            SliderElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            SliderElement.Size = UDim2.new(1, 0, 0, 55)
            SliderElement.Parent = TabContent
            
            local UICornerSlider = Instance.new("UICorner")
            UICornerSlider.CornerRadius = UDim.new(0, 6)
            UICornerSlider.Parent = SliderElement
            
            local SliderDescription = Instance.new("TextLabel")
            SliderDescription.Name = "Description"
            SliderDescription.BackgroundTransparency = 1
            SliderDescription.Position = UDim2.new(0, 10, 0, 5)
            SliderDescription.Size = UDim2.new(1, -20, 0, 20)
            SliderDescription.Font = Enum.Font.Gotham
            SliderDescription.Text = sliderText
            SliderDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderDescription.TextSize = 14
            SliderDescription.TextXAlignment = Enum.TextXAlignment.Left
            SliderDescription.Parent = SliderElement
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "Value"
            SliderValue.BackgroundTransparency = 1
            SliderValue.Position = UDim2.new(1, -40, 0, 5)
            SliderValue.Size = UDim2.new(0, 30, 0, 20)
            SliderValue.Font = Enum.Font.GothamSemibold
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderElement
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Name = "SliderBG"
            SliderBG.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            SliderBG.Position = UDim2.new(0, 10, 0, 30)
            SliderBG.Size = UDim2.new(1, -20, 0, 5)
            SliderBG.Parent = SliderElement
            
            local UICornerSliderBG = Instance.new("UICorner")
            UICornerSliderBG.CornerRadius = UDim.new(1, 0)
            UICornerSliderBG.Parent = SliderBG
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.Parent = SliderBG
            
            local UICornerSliderFill = Instance.new("UICorner")
            UICornerSliderFill.CornerRadius = UDim.new(1, 0)
            UICornerSliderFill.Parent = SliderFill
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            SliderKnob.Size = UDim2.new(0, 12, 0, 12)
            SliderKnob.ZIndex = 2
            SliderKnob.Parent = SliderBG
            
            local UICornerSliderKnob = Instance.new("UICorner")
            UICornerSliderKnob.CornerRadius = UDim.new(1, 0)
            UICornerSliderKnob.Parent = SliderKnob
            
            callback(default)
            
            local dragging = false
            
            SliderBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderBG.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local sliderPos = SliderBG.AbsolutePosition.X
                    local sliderWidth = SliderBG.AbsoluteSize.X
                    
                    local position = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
                    local value = math.floor(min + (position * (max - min)))
                    
                    SliderFill.Size = UDim2.new(position, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(position, -6, 0.5, -6)
                    SliderValue.Text = tostring(value)
                    
                    callback(value)
                end
            end)
            
            return SliderElement
        end
        
        function TabElements:CreateRadial(radialText, options, default, callback)
            options = options or {}
            default = default or 1
            callback = callback or function() end
            
            local RadialElement = Instance.new("Frame")
            RadialElement.Name = radialText .. "Radial"
            RadialElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            RadialElement.Size = UDim2.new(1, 0, 0, 60)
            RadialElement.Parent = TabContent
            
            local UICornerRadial = Instance.new("UICorner")
            UICornerRadial.CornerRadius = UDim.new(0, 6)
            UICornerRadial.Parent = RadialElement
            
            local RadialDescription = Instance.new("TextLabel")
            RadialDescription.Name = "Description"
            RadialDescription.BackgroundTransparency = 1
            RadialDescription.Position = UDim2.new(0, 10, 0, 5)
            RadialDescription.Size = UDim2.new(1, -20, 0, 20)
            RadialDescription.Font = Enum.Font.Gotham
            RadialDescription.Text = radialText
            RadialDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            RadialDescription.TextSize = 14
            RadialDescription.TextXAlignment = Enum.TextXAlignment.Left
            RadialDescription.Parent = RadialElement
            
            local OptionsHolder = Instance.new("Frame")
            OptionsHolder.Name = "OptionsHolder"
            OptionsHolder.BackgroundTransparency = 1
            OptionsHolder.Position = UDim2.new(0, 10, 0, 30)
            OptionsHolder.Size = UDim2.new(1, -20, 0, 25)
            OptionsHolder.Parent = RadialElement
            
            local OptionsList = Instance.new("UIListLayout")
            OptionsList.FillDirection = Enum.FillDirection.Horizontal
            OptionsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsList.Padding = UDim.new(0, 5)
            OptionsList.Parent = OptionsHolder
            
            local selectedOption = nil
            
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.BackgroundColor3 = i == default and Color3.fromRGB(50, 100, 255) or Color3.fromRGB(25, 25, 35)
                OptionButton.Size = UDim2.new(0, 80, 1, 0)
                OptionButton.Font = Enum.Font.GothamSemibold
                OptionButton.Text = option
                OptionButton.TextColor3 = i == default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 14
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = OptionsHolder
                
                local UICornerOption = Instance.new("UICorner")
                UICornerOption.CornerRadius = UDim.new(0, 4)
                UICornerOption.Parent = OptionButton
                
                if i == default then
                    selectedOption = OptionButton
                    callback(option)
                end
                
                OptionButton.MouseButton1Click:Connect(function()
                    if selectedOption == OptionButton then
                        return
                    end
                    
                    if selectedOption then
                        local DeselectAnimation = TweenService:Create(
                            selectedOption,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(25, 25, 35), TextColor3 = Color3.fromRGB(200, 200, 200)}
                        )
                        DeselectAnimation:Play()
                    end
                    
                    selectedOption = OptionButton
                    
                    local SelectAnimation = TweenService:Create(
                        OptionButton,
                        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(50, 100, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}
                    )
                    SelectAnimation:Play()
                    
                    callback(option)
                end)
            end
            
            return RadialElement
        end
        
        function TabElements:CreateDropdown(dropdownText, options, default, callback)
            options = options or {}
            default = default or ""
            callback = callback or function() end
            
            local DropdownElement = Instance.new("Frame")
            DropdownElement.Name = dropdownText .. "Dropdown"
            DropdownElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            DropdownElement.Size = UDim2.new(1, 0, 0, 35)
            DropdownElement.ClipsDescendants = true
            DropdownElement.Parent = TabContent
            
            local UICornerDropdown = Instance.new("UICorner")
            UICornerDropdown.CornerRadius = UDim.new(0, 6)
            UICornerDropdown.Parent = DropdownElement
            
            local DropdownMain = Instance.new("Frame")
            DropdownMain.Name = "DropdownMain"
            DropdownMain.BackgroundTransparency = 1
            DropdownMain.Size = UDim2.new(1, 0, 0, 35)
            DropdownMain.Parent = DropdownElement
            
            local DropdownDescription = Instance.new("TextLabel")
            DropdownDescription.Name = "Description"
            DropdownDescription.BackgroundTransparency = 1
            DropdownDescription.Position = UDim2.new(0, 10, 0, 0)
            DropdownDescription.Size = UDim2.new(0.5, -15, 0, 35)
            DropdownDescription.Font = Enum.Font.Gotham
            DropdownDescription.Text = dropdownText
            DropdownDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownDescription.TextSize = 14
            DropdownDescription.TextXAlignment = Enum.TextXAlignment.Left
            DropdownDescription.Parent = DropdownMain
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            DropdownButton.Position = UDim2.new(0.5, 5, 0.5, -12)
            DropdownButton.Size = UDim2.new(0.5, -15, 0, 24)
            DropdownButton.Font = Enum.Font.GothamSemibold
            DropdownButton.Text = default ~= "" and default or "Select"
            DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.TextSize = 14
            DropdownButton.Parent = DropdownMain
            
            local UICornerDropdownButton = Instance.new("UICorner")
            UICornerDropdownButton.CornerRadius = UDim.new(0, 4)
            UICornerDropdownButton.Parent = DropdownButton
            
            local DropdownArrow = Instance.new("ImageLabel")
            DropdownArrow.Name = "Arrow"
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Position = UDim2.new(1, -20, 0.5, -4)
            DropdownArrow.Size = UDim2.new(0, 8, 0, 8)
            DropdownArrow.Image = "rbxassetid://7072706620"
            DropdownArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
            DropdownArrow.Parent = DropdownButton
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "OptionsFrame"
            OptionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            OptionsFrame.Position = UDim2.new(0, 5, 0, 40)
            OptionsFrame.Size = UDim2.new(1, -10, 0, 0)
            OptionsFrame.Visible = false
            OptionsFrame.Parent = DropdownElement
            
            local UICornerOptionsFrame = Instance.new("UICorner")
            UICornerOptionsFrame.CornerRadius = UDim.new(0, 4)
            UICornerOptionsFrame.Parent = OptionsFrame
            
            local OptionsList = Instance.new("UIListLayout")
            OptionsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsList.Padding = UDim.new(0, 5)
            OptionsList.Parent = OptionsFrame
            
            local OptionsListPadding = Instance.new("UIPadding")
            OptionsListPadding.PaddingTop = UDim.new(0, 5)
            OptionsListPadding.PaddingBottom = UDim.new(0, 5)
            OptionsListPadding.Parent = OptionsFrame
            
            local dropdownOpened = false
            local optionsHeight = 0
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                OptionButton.Size = UDim2.new(1, -10, 0, 25)
                OptionButton.Font = Enum.Font.GothamSemibold
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 14
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = OptionsFrame
                
                local UICornerOption = Instance.new("UICorner")
                UICornerOption.CornerRadius = UDim.new(0, 4)
                UICornerOption.Parent = OptionButton
                
                optionsHeight = optionsHeight + 30
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    
                    DropdownElement:TweenSize(
                        UDim2.new(1, 0, 0, 35),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.15,
                        true
                    )
                    
                    local ArrowTween = TweenService:Create(
                        DropdownArrow,
                        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = 0}
                    )
                    ArrowTween:Play()
                    
                    dropdownOpened = false
                    
                    wait(0.15)
                    OptionsFrame.Visible = false
                    
                    callback(option)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                if dropdownOpened then
                    DropdownElement:TweenSize(
                        UDim2.new(1, 0, 0, 35),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.15,
                        true
                    )
                    
                    local ArrowTween = TweenService:Create(
                        DropdownArrow,
                        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = 0}
                    )
                    ArrowTween:Play()
                    
                    dropdownOpened = false
                    
                    wait(0.15)
                    OptionsFrame.Visible = false
                else
                    OptionsFrame.Visible = true
                    
                    DropdownElement:TweenSize(
                        UDim2.new(1, 0, 0, 45 + optionsHeight),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.15,
                        true
                    )
                    
                    local ArrowTween = TweenService:Create(
                        DropdownArrow,
                        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = 180}
                    )
                    ArrowTween:Play()
                    
                    dropdownOpened = true
                end
            end)
            
            if default ~= "" then
                callback(default)
            end
            
            return DropdownElement
        end
        
        function TabElements:CreateColorPicker(colorText, default, callback)
            default = default or Color3.fromRGB(255, 255, 255)
            callback = callback or function() end
            
            local ColorPickerElement = Instance.new("Frame")
            ColorPickerElement.Name = colorText .. "ColorPicker"
            ColorPickerElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            ColorPickerElement.Size = UDim2.new(1, 0, 0, 35)
            ColorPickerElement.Parent = TabContent
            
            local UICornerColorPicker = Instance.new("UICorner")
            UICornerColorPicker.CornerRadius = UDim.new(0, 6)
            UICornerColorPicker.Parent = ColorPickerElement
            
            local ColorDescription = Instance.new("TextLabel")
            ColorDescription.Name = "Description"
            ColorDescription.BackgroundTransparency = 1
            ColorDescription.Position = UDim2.new(0, 10, 0, 0)
            ColorDescription.Size = UDim2.new(1, -60, 0, 35)
            ColorDescription.Font = Enum.Font.Gotham
            ColorDescription.Text = colorText
            ColorDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorDescription.TextSize = 14
            ColorDescription.TextXAlignment = Enum.TextXAlignment.Left
            ColorDescription.Parent = ColorPickerElement
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Name = "ColorDisplay"
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.Position = UDim2.new(1, -45, 0.5, -10)
            ColorDisplay.Size = UDim2.new(0, 35, 0, 20)
            ColorDisplay.Parent = ColorPickerElement
            
            local UICornerColorDisplay = Instance.new("UICorner")
            UICornerColorDisplay.CornerRadius = UDim.new(0, 4)
            UICornerColorDisplay.Parent = ColorDisplay
            
            callback(default)
            
            ColorDisplay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local ColorPickerPopup = Instance.new("Frame")
                    ColorPickerPopup.Name = "ColorPickerPopup"
                    ColorPickerPopup.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                    ColorPickerPopup.Position = UDim2.new(0.5, -125, 0.5, -100)
                    ColorPickerPopup.Size = UDim2.new(0, 250, 0, 200)
                    ColorPickerPopup.ZIndex = 10
                    ColorPickerPopup.Parent = ScreenGui
                    
                    local UICornerPopup = Instance.new("UICorner")
                    UICornerPopup.CornerRadius = UDim.new(0, 6)
                    UICornerPopup.Parent = ColorPickerPopup
                    
                    local ColorPickerTitle = Instance.new("TextLabel")
                    ColorPickerTitle.Name = "Title"
                    ColorPickerTitle.BackgroundTransparency = 1
                    ColorPickerTitle.Position = UDim2.new(0, 10, 0, 5)
                    ColorPickerTitle.Size = UDim2.new(1, -20, 0, 25)
                    ColorPickerTitle.ZIndex = 11
                    ColorPickerTitle.Font = Enum.Font.GothamBold
                    ColorPickerTitle.Text = "Color Picker"
                    ColorPickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ColorPickerTitle.TextSize = 16
                    ColorPickerTitle.Parent = ColorPickerPopup
                    
                    local CloseButton = Instance.new("TextButton")
                    CloseButton.Name = "CloseButton"
                    CloseButton.BackgroundTransparency = 1
                    CloseButton.Position = UDim2.new(1, -30, 0, 0)
                    CloseButton.Size = UDim2.new(0, 30, 0, 30)
                    CloseButton.ZIndex = 11
                    CloseButton.Font = Enum.Font.GothamBold
                    CloseButton.Text = "X"
                    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    CloseButton.TextSize = 16
                    CloseButton.Parent = ColorPickerPopup
                    
                    local Separator = Instance.new("Frame")
                    Separator.Name = "Separator"
                    Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    Separator.Position = UDim2.new(0, 10, 0, 35)
                    Separator.Size = UDim2.new(1, -20, 0, 1)
                    Separator.ZIndex = 11
                    Separator.Parent = ColorPickerPopup
                    
                    local ApplyButton = Instance.new("TextButton")
                    ApplyButton.Name = "ApplyButton"
                    ApplyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
                    ApplyButton.Position = UDim2.new(0, 10, 1, -35)
                    ApplyButton.Size = UDim2.new(1, -20, 0, 25)
                    ApplyButton.ZIndex = 11
                    ApplyButton.Font = Enum.Font.GothamSemibold
                    ApplyButton.Text = "Apply"
                    ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ApplyButton.TextSize = 14
                    ApplyButton.Parent = ColorPickerPopup
                    
                    local UICornerApply = Instance.new("UICorner")
                    UICornerApply.CornerRadius = UDim.new(0, 4)
                    UICornerApply.Parent = ApplyButton
                    
                    local function RemoveColorPicker()
                        ColorPickerPopup:Destroy()
                    end
                    
                    CloseButton.MouseButton1Click:Connect(RemoveColorPicker)
                    
                    local ColorH = 0
                    local ColorS = 0
                    local ColorV = 0
                    
                    local ColorRGB = default
                    
                    local ColorHue = Instance.new("ImageLabel")
                    ColorHue.Name = "ColorHue"
                    ColorHue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ColorHue.Position = UDim2.new(0, 10, 0, 45)
                    ColorHue.Size = UDim2.new(0, 20, 0, 100)
                    ColorHue.ZIndex = 11
                    ColorHue.Image = "rbxassetid://6523286724"
                    ColorHue.Parent = ColorPickerPopup
                    
                    local UICornerHue = Instance.new("UICorner")
                    UICornerHue.CornerRadius = UDim.new(0, 4)
                    UICornerHue.Parent = ColorHue
                    
                    local HueSelection = Instance.new("Frame")
                    HueSelection.Name = "HueSelection"
                    HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    HueSelection.BorderSizePixel = 0
                    HueSelection.Position = UDim2.new(0, 0, 0, 0)
                    HueSelection.Size = UDim2.new(1, 0, 0, 3)
                    HueSelection.ZIndex = 12
                    HueSelection.Parent = ColorHue
                    
                    local ColorArea = Instance.new("ImageLabel")
                    ColorArea.Name = "ColorArea"
                    ColorArea.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    ColorArea.Position = UDim2.new(0, 40, 0, 45)
                    ColorArea.Size = UDim2.new(0, 100, 0, 100)
                    ColorArea.ZIndex = 11
                    ColorArea.Image = "rbxassetid://6523291212"
                    ColorArea.Parent = ColorPickerPopup
                    
                    local UICornerArea = Instance.new("UICorner")
                    UICornerArea.CornerRadius = UDim.new(0, 4)
                    UICornerArea.Parent = ColorArea
                    
                    local ColorSelection = Instance.new("Frame")
                    ColorSelection.Name = "ColorSelection"
                    ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ColorSelection.BorderSizePixel = 0
                    ColorSelection.Position = UDim2.new(0, 0, 0, 0)
                    ColorSelection.Size = UDim2.new(0, 7, 0, 7)
                    ColorSelection.ZIndex = 12
                    ColorSelection.Parent = ColorArea
                    
                    local UICornerColorSel = Instance.new("UICorner")
                    UICornerColorSel.CornerRadius = UDim.new(1, 0)
                    UICornerColorSel.Parent = ColorSelection
                    
                    local PreviewFrame = Instance.new("Frame")
                    PreviewFrame.Name = "Preview"
                    PreviewFrame.BackgroundColor3 = default
                    PreviewFrame.Position = UDim2.new(0, 150, 0, 45)
                    PreviewFrame.Size = UDim2.new(0, 80, 0, 80)
                    PreviewFrame.ZIndex = 11
                    PreviewFrame.Parent = ColorPickerPopup
                    
                    local UICornerPreview = Instance.new("UICorner")
                    UICornerPreview.CornerRadius = UDim.new(0, 4)
                    UICornerPreview.Parent = PreviewFrame
                    
                    local function UpdateColor()
                        PreviewFrame.BackgroundColor3 = ColorRGB
                    end
                    
                    local draggingHue = false
                    local draggingSV = false
                    
                    local function UpdateHue(input)
                        local sizeY = math.clamp((input.Position.Y - ColorHue.AbsolutePosition.Y) / ColorHue.AbsoluteSize.Y, 0, 1)
                        HueSelection.Position = UDim2.new(0, 0, sizeY, 0)
                        ColorH = 1 - sizeY
                        
                        ColorArea.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
                        ColorRGB = Color3.fromHSV(ColorH, ColorS, ColorV)
                        UpdateColor()
                    end
                    
                    local function UpdateSV(input)
                        local posX = math.clamp((input.Position.X - ColorArea.AbsolutePosition.X) / ColorArea.AbsoluteSize.X, 0, 1)
                        local posY = math.clamp((input.Position.Y - ColorArea.AbsolutePosition.Y) / ColorArea.AbsoluteSize.Y, 0, 1)
                        
                        ColorSelection.Position = UDim2.new(posX, -3, posY, -3)
                        
                        ColorS = posX
                        ColorV = 1 - posY
                        
                        ColorRGB = Color3.fromHSV(ColorH, ColorS, ColorV)
                        UpdateColor()
                    end
                    
                    ColorHue.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingHue = true
                            UpdateHue(input)
                        end
                    end)
                    
                    ColorHue.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingHue = false
                        end
                    end)
                    
                    ColorArea.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSV = true
                            UpdateSV(input)
                        end
                    end)
                    
                    ColorArea.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSV = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateHue(input)
                        elseif draggingSV and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSV(input)
                        end
                    end)
                    
                    local H, S, V = default:ToHSV()
                    ColorH, ColorS, ColorV = H, S, V
                    
                    ColorArea.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    HueSelection.Position = UDim2.new(0, 0, 1 - H, 0)
                    ColorSelection.Position = UDim2.new(S, -3, 1 - V, -3)
                    
                    ApplyButton.MouseButton1Click:Connect(function()
                        ColorDisplay.BackgroundColor3 = ColorRGB
                        callback(ColorRGB)
                        RemoveColorPicker()
                    end)
                end
            end)
            
            return ColorPickerElement
        end
        
        function TabElements:CreateTextBox(boxText, placeholderText, callback)
            placeholderText = placeholderText or "Enter text..."
            callback = callback or function() end
            
            local TextBoxElement = Instance.new("Frame")
            TextBoxElement.Name = boxText .. "TextBox"
            TextBoxElement.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            TextBoxElement.Size = UDim2.new(1, 0, 0, 35)
            TextBoxElement.Parent = TabContent
            
            local UICornerTextBox = Instance.new("UICorner")
            UICornerTextBox.CornerRadius = UDim.new(0, 6)
            UICornerTextBox.Parent = TextBoxElement
            
            local BoxDescription = Instance.new("TextLabel")
            BoxDescription.Name = "Description"
            BoxDescription.BackgroundTransparency = 1
            BoxDescription.Position = UDim2.new(0, 10, 0, 0)
            BoxDescription.Size = UDim2.new(0.5, -15, 0, 35)
            BoxDescription.Font = Enum.Font.Gotham
            BoxDescription.Text = boxText
            BoxDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
            BoxDescription.TextSize = 14
            BoxDescription.TextXAlignment = Enum.TextXAlignment.Left
            BoxDescription.Parent = TextBoxElement
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "InputBox"
            InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            InputBox.Position = UDim2.new(0.5, 5, 0.5, -12)
            InputBox.Size = UDim2.new(0.5, -15, 0, 24)
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = placeholderText
            InputBox.Text = ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 14
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = TextBoxElement
            
            local UICornerInputBox = Instance.new("UICorner")
            UICornerInputBox.CornerRadius = UDim.new(0, 4)
            UICornerInputBox.Parent = InputBox
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(InputBox.Text)
                end
            end)
            
            return TextBoxElement
        end
        
        return TabElements
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Library.ToggleUI then
            Library.WindowOpened = not Library.WindowOpened
            ScreenGui.Enabled = Library.WindowOpened
        end
    end)
    
    return Window
end

getgenv().UILibrary = UILibrary
return UILibrary
