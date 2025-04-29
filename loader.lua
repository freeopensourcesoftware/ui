local SmoothUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Animation presets
local AnimationPresets = {
    FastFade = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SlowFade = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    PopIn = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SmoothSlide = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
}

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    return instance
end

-- Create a notification system
function SmoothUI:CreateNotification(title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "Info" -- Info, Success, Error, Warning
    
    local colors = {
        Info = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(0, 180, 0),
        Warning = Color3.fromRGB(255, 180, 0),
        Error = Color3.fromRGB(255, 50, 50)
    }
    
    local NotifGui = CreateInstance("ScreenGui", {
        Name = "SmoothUINotification",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local NotifFrame = CreateInstance("Frame", {
        Name = "NotifFrame",
        Parent = NotifGui,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(1, 5, 0.8, 0),
        Size = UDim2.new(0, 280, 0, 80),
        AnchorPoint = Vector2.new(1, 1)
    })
    
    local UICornerNotif = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = NotifFrame
    })
    
    local NotifBar = CreateInstance("Frame", {
        Name = "NotifBar",
        Parent = NotifFrame,
        BackgroundColor3 = colors[notifType],
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    local UICornerBar = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = NotifBar
    })
    
    local NotifTitle = CreateInstance("TextLabel", {
        Name = "NotifTitle",
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = colors[notifType],
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local NotifMessage = CreateInstance("TextLabel", {
        Name = "NotifMessage",
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -20, 0, 40),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Color3.fromRGB(230, 230, 230),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    local ProgressBar = CreateInstance("Frame", {
        Name = "ProgressBar",
        Parent = NotifFrame,
        BackgroundColor3 = colors[notifType],
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2)
    })
    
    -- Entrance animation
    NotifFrame:TweenPosition(
        UDim2.new(1, -20, 0.8, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    -- Progress bar animation
    TweenService:Create(
        ProgressBar, 
        TweenInfo.new(duration, Enum.EasingStyle.Linear), 
        {Size = UDim2.new(0, 0, 0, 2)}
    ):Play()
    
    -- Exit animation and cleanup
    task.delay(duration, function()
        local exitTween = TweenService:Create(
            NotifFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 
            {Position = UDim2.new(1, 5, 0.8, 0)}
        )
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            NotifGui:Destroy()
        end)
    end)
end

function SmoothUI:CreateWindow(title)
    local Window = {}
    
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "SmoothUI",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -200, 0.5, -175),
        Size = UDim2.new(0, 400, 0, 350),
        AnchorPoint = Vector2.new(0, 0)
    })
    
    local DropShadow = CreateInstance("ImageLabel", {
        Name = "DropShadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
    
    local UICorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local UICornerTop = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    })
    
    local TopBarGradient = CreateInstance("UIGradient", {
        Parent = TopBar,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
        },
        Rotation = 90
    })
    
    local TopFix = CreateInstance("Frame", {
        Name = "TopFix",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    })
    
    local TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title or "SmoothUI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(255, 200, 0),
        Position = UDim2.new(1, -55, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    local UICornerMinimize = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = MinimizeButton
    })
    
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Position = UDim2.new(1, -30, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    local UICornerClose = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = CloseButton
    })
    
    local ContentFrame = CreateInstance("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -90),
        ClipsDescendants = true
    })
    
    local TabsFrame = CreateInstance("Frame", {
        Name = "TabsFrame",
        Parent = ContentFrame,
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.25, 0, 1, 0)
    })
    

    local Separator = CreateInstance("Frame", {
        Name = "Separator",
        Parent = ContentFrame,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Position = UDim2.new(0.25, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0)
    })
    
    local TabsContainer = CreateInstance("ScrollingFrame", {
        Name = "TabsContainer",
        Parent = TabsFrame,
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local UIListLayoutTabs = CreateInstance("UIListLayout", {
        Parent = TabsContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local UIPaddingTabs = CreateInstance("UIPadding", {
        Parent = TabsContainer,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })
    
    local TabContent = CreateInstance("Frame", {
        Name = "TabContent",
        Parent = ContentFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.25, 0, 0, 0),
        Size = UDim2.new(0.75, 0, 1, 0)
    })
    

    local UserProfileFrame = CreateInstance("Frame", {
        Name = "UserProfileFrame",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -50),
        Size = UDim2.new(1, 0, 0, 50)
    })
    
    local ProfileCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = UserProfileFrame
    })
    

    local BottomFix = CreateInstance("Frame", {
        Name = "BottomFix",
        Parent = UserProfileFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    })
    

    local UserThumbnail = CreateInstance("ImageLabel", {
        Name = "UserThumbnail",
        Parent = UserProfileFrame,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0.5, -18),
        Size = UDim2.new(0, 36, 0, 36),
        Image = ""
    })
    
    local ThumbnailCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = UserThumbnail
    })
    

    local UserNameLabel = CreateInstance("TextLabel", {
        Name = "UserNameLabel",
        Parent = UserProfileFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0.5, -10),
        Size = UDim2.new(0.7, -55, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = LocalPlayer.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local userId = LocalPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    UserThumbnail.Image = content
    

    local minimized = false
    local originalSize = MainFrame.Size
    local originalContentPos = ContentFrame.Position
    local minimizedSize = UDim2.new(0, originalSize.X.Offset, 0, 40)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        local targetSize = minimized and minimizedSize or originalSize
        local targetContentPos = minimized and UDim2.new(0, 0, 1, 0) or originalContentPos
        
        local sizeTween = TweenService:Create(MainFrame, AnimationPresets.SmoothSlide, {Size = targetSize})
        local contentTween = TweenService:Create(ContentFrame, AnimationPresets.SmoothSlide, {Position = targetContentPos})
        
        sizeTween:Play()
        contentTween:Play()
        
        UserProfileFrame.Visible = not minimized
    end)
    
    local tabs = {}
    local selectedTab = nil
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainFrame, AnimationPresets.FastFade, {
            Position = UDim2.new(0.5, -200, 1.5, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    

    MainFrame.Position = UDim2.new(0.5, -200, -0.5, 0)
    MainFrame.BackgroundTransparency = 1

    TweenService:Create(MainFrame, AnimationPresets.PopIn, {
        Position = UDim2.new(0.5, -200, 0.5, -175),
        BackgroundTransparency = 0
    }):Play()
    
    function Window:CreateTab(tabName)
        local Tab = {}
        
        local tabId = #tabs + 1
        local TabButton = CreateInstance("TextButton", {
            Name = tabName,
            Parent = TabsContainer,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            AutoButtonColor = false
        })
        
        local UICornerTab = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        local TabIndicator = CreateInstance("Frame", {
            Name = "TabIndicator",
            Parent = TabButton,
            BackgroundColor3 = Color3.fromRGB(0, 150, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 3, 1, 0),
            Visible = false
        })
        
        local UICornerIndicator = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 2),
            Parent = TabIndicator
        })
        
        local TabPage = CreateInstance("ScrollingFrame", {
            Name = tabName .. "Page",
            Parent = TabContent,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        
        local UIListLayoutElements = CreateInstance("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        local UIPaddingElements = CreateInstance("UIPadding", {
            Parent = TabPage,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        table.insert(tabs, {
            Button = TabButton,
            Page = TabPage,
            Indicator = TabIndicator
        })
        
        TabButton.MouseButton1Click:Connect(function()
            if selectedTab then
                selectedTab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                selectedTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                selectedTab.Indicator.Visible = false

                TweenService:Create(selectedTab.Page, AnimationPresets.SmoothSlide, {
                    Position = UDim2.new(-1, 0, 0, 0)
                }):Play()
                task.delay(0.2, function()
                    selectedTab.Page.Visible = false
                end)
            end
            

            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIndicator.Visible = true
            
            TabPage.Position = UDim2.new(1, 0, 0, 0)
            TabPage.Visible = true

            TweenService:Create(TabPage, AnimationPresets.SmoothSlide, {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            selectedTab = tabs[tabId]
        end)
        
        if #tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIndicator.Visible = true
            TabPage.Position = UDim2.new(0, 0, 0, 0)
            TabPage.Visible = true
            selectedTab = tabs[tabId]
        end
        
        function Tab:AddButton(text, callback)
            local Button = CreateInstance("Frame", {
                Name = text .. "Button",
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36)
            })
            
            local UICornerButton = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            
            local ButtonGradient = CreateInstance("UIGradient", {
                Parent = Button,
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                },
                Rotation = 90
            })
            
            local ButtonLabel = CreateInstance("TextLabel", {
                Name = "ButtonLabel",
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ButtonIcon = CreateInstance("ImageLabel", {
                Name = "ButtonIcon",
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, -7),
                Size = UDim2.new(0, 14, 0, 14),
                Image = "rbxassetid://6031229361",
                ImageColor3 = Color3.fromRGB(180, 180, 180)
            })
            
            local ButtonClickArea = CreateInstance("TextButton", {
                Name = "ClickArea",
                Parent = Button,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                AutoButtonColor = false
            })
            
            ButtonClickArea.MouseButton1Click:Connect(function()
                local Ripple = CreateInstance("Frame", {
                    Name = "Ripple",
                    Parent = Button,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.8,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 2,
                    Size = UDim2.new(0, 0, 0, 0)
                })
                
                local UICornerRipple = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Ripple
                })
                
                TweenService:Create(Ripple, TweenInfo.new(0.5), {
                    Size = UDim2.new(1.5, 0, 1.5, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                task.delay(0.5, function()
                    Ripple:Destroy()
                end)
                
                TweenService:Create(Button, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(ButtonIcon, AnimationPresets.FastFade, {Position = UDim2.new(1, -25, 0.5, -7)}):Play()
                
                task.spawn(function()
                    callback()
                end)
                
                task.delay(0.2, function()
                    TweenService:Create(Button, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    TweenService:Create(ButtonIcon, AnimationPresets.FastFade, {Position = UDim2.new(1, -30, 0.5, -7)}):Play()
                end)
            end)
            
            ButtonClickArea.MouseEnter:Connect(function()
                TweenService:Create(Button, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(ButtonIcon, AnimationPresets.FastFade, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end)
            
            ButtonClickArea.MouseLeave:Connect(function()
                TweenService:Create(Button, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(ButtonIcon, AnimationPresets.FastFade, {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end)
            
            return Button
        end
        
        function Tab:AddToggle(text, default, callback)
            local toggled = default or false
            
            local Toggle = CreateInstance("Frame", {
                Name = text .. "Toggle",
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36)
            })
            
            local UICornerToggle = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Toggle
            })
            
            local ToggleGradient = CreateInstance("UIGradient", {
                Parent = Toggle,
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                },
                Rotation = 90
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Name = "ToggleLabel",
                Parent = Toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ToggleIndicator = CreateInstance("Frame", {
                Name = "Indicator",
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20),
                BorderSizePixel = 0
            })
            
            local UICornerIndicator = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleIndicator
            })
            
            local ToggleCircle = CreateInstance("Frame", {
                Name = "Circle",
                Parent = ToggleIndicator,
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Position = UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                BorderSizePixel = 0
            })
            
            local UICornerCircle = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle
            })
            
            local CircleShadow = CreateInstance("ImageLabel", {
                Name = "CircleShadow",
                Parent = ToggleCircle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, -2, 0, -2),
                Size = UDim2.new(1, 4, 1, 4),
                ZIndex = -1,
                Image = "rbxassetid://6014261993",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.7,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450)
            })
            
            local ToggleClickArea = CreateInstance("TextButton", {
                Name = "ClickArea",
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                AutoButtonColor = false
            })
            
            local function updateToggle()
                if toggled then
                    TweenService:Create(ToggleIndicator, AnimationPresets.FastFade, {
                        BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    }):Play()
                    
                    TweenService:Create(ToggleCircle, AnimationPresets.FastFade, {
                        Position = UDim2.new(0, 22, 0.5, -8), 
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                else
                    TweenService:Create(ToggleIndicator, AnimationPresets.FastFade, {
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    }):Play()
                    
                    TweenService:Create(ToggleCircle, AnimationPresets.FastFade, {
                        Position = UDim2.new(0, 2, 0.5, -8), 
                        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    }):Play()
                end
                
                callback(toggled)
            end
            
            if toggled then
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                ToggleCircle.Position = UDim2.new(0, 22, 0.5, -8)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            ToggleClickArea.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
                
                local Ripple = CreateInstance("Frame", {
                    Name = "Ripple",
                    Parent = ToggleIndicator,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.8,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 2,
                    Size = UDim2.new(0, 0, 0, 0)
                })
                
                local UICornerRipple = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Ripple
                })
                
                TweenService:Create(Ripple, TweenInfo.new(0.5), {
                    Size = UDim2.new(2, 0, 2, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                task.delay(0.5, function()
                    Ripple:Destroy()
                end)
            end)
            
            ToggleClickArea.MouseEnter:Connect(function()
                TweenService:Create(Toggle, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)
            
            ToggleClickArea.MouseLeave:Connect(function()
                TweenService:Create(Toggle, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end)
            
            return {
                Instance = Toggle,
                SetValue = function(self, value)
                    toggled = value
                    updateToggle()
                end,
                GetValue = function(self)
                    return toggled
                end
            }
        end
        
        function Tab:AddSlider(text, min, max, default, callback)
            local Slider = CreateInstance("Frame", {
                Name = text .. "Slider",
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 60)
            })
            
            local UICornerSlider = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Slider
            })
            
            -- Add subtle gradient
            local SliderGradient = CreateInstance("UIGradient", {
                Parent = Slider,
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                },
                Rotation = 90
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Name = "SliderLabel",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Name = "ValueLabel",
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BackgroundTransparency = 0,
                Position = UDim2.new(1, -60, 0, 8),
                Size = UDim2.new(0, 50, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(default),
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 12
            })
            
            local ValueCorner = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = ValueLabel
            })
            
            local SliderBG = CreateInstance("Frame", {
                Name = "SliderBG",
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 38),
                Size = UDim2.new(1, -20, 0, 6)
            })
            
            local UICornerSliderBG = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBG
            })
            
            local SliderFill = CreateInstance("Frame", {
                Name = "SliderFill",
                Parent = SliderBG,
                BackgroundColor3 = Color3.fromRGB(0, 150, 255),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 1, 0)
            })
            
            local UICornerSliderFill = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill
            })
            
            local SliderKnob = CreateInstance("Frame", {
                Name = "SliderKnob",
                Parent = SliderBG,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0, -6, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                BorderSizePixel = 0
            })
            
            local UICornerSliderKnob = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderKnob
            })
            

            local KnobShadow = CreateInstance("ImageLabel", {
                Name = "KnobShadow",
                Parent = SliderKnob,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, -2, 0, -2),
                Size = UDim2.new(1, 4, 1, 4),
                ZIndex = -1,
                Image = "rbxassetid://6014261993",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.7,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450)
            })
            
            local SliderClickArea = CreateInstance("TextButton", {
                Name = "ClickArea",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 30),
                Size = UDim2.new(1, 0, 0, 24),
                Text = ""
            })
            
            local defaultValue = default or min
            local minValue = min or 0
            local maxValue = max or 100
            
            local function updateSlider(value, noCallback)
                value = math.clamp(value, minValue, maxValue)
                
                local roundedValue = math.floor(value * 10) / 10
                
                local percent = (roundedValue - minValue) / (maxValue - minValue)
                
                TweenService:Create(SliderFill, AnimationPresets.FastFade, {
                    Size = UDim2.new(percent, 0, 1, 0)
                }):Play()
                
                TweenService:Create(SliderKnob, AnimationPresets.FastFade, {
                    Position = UDim2.new(percent, -6, 0.5, -6)
                }):Play()
                
                ValueLabel.Text = tostring(roundedValue)
                
                if not noCallback then
                    callback(roundedValue)
                end
            end
            
            local isDragging = false
            
            SliderClickArea.MouseButton1Down:Connect(function()
                isDragging = true
                
                local relativeX = math.clamp(UserInputService:GetMouseLocation().X - SliderBG.AbsolutePosition.X, 0, SliderBG.AbsoluteSize.X)
                local value = minValue + (relativeX / SliderBG.AbsoluteSize.X) * (maxValue - minValue)
                updateSlider(value)
                
                local clickPos = UserInputService:GetMouseLocation() - SliderBG.AbsolutePosition
                local Ripple = CreateInstance("Frame", {
                    Name = "Ripple",
                    Parent = SliderBG,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.8,
                    Position = UDim2.new(0, clickPos.X, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 2,
                    Size = UDim2.new(0, 0, 0, 0)
                })
                
                local UICornerRipple = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Ripple
                })
                
                TweenService:Create(Ripple, TweenInfo.new(0.5), {
                    Size = UDim2.new(0, 30, 0, 30),
                    BackgroundTransparency = 1
                }):Play()
                
                task.delay(0.5, function()
                    Ripple:Destroy()
                end)
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relativeX = math.clamp(input.Position.X - SliderBG.AbsolutePosition.X, 0, SliderBG.AbsoluteSize.X)
                    local value = minValue + (relativeX / SliderBG.AbsoluteSize.X) * (maxValue - minValue)
                    updateSlider(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            SliderClickArea.MouseEnter:Connect(function()
                TweenService:Create(Slider, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(SliderKnob, AnimationPresets.FastFade, {Size = UDim2.new(0, 14, 0, 14), Position = SliderKnob.Position + UDim2.new(0, -1, 0, -1)}):Play()
            end)
            
            SliderClickArea.MouseLeave:Connect(function()
                TweenService:Create(Slider, AnimationPresets.FastFade, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(SliderKnob, AnimationPresets.FastFade, {Size = UDim2.new(0, 12, 0, 12), Position = SliderKnob.Position + UDim2.new(0, 1, 0, 1)}):Play()
            end)
            
            updateSlider(defaultValue, true)
            
            return {
                Instance = Slider,
                SetValue = function(self, value)
                    updateSlider(value)
                end,
                GetValue = function(self)
                    return tonumber(ValueLabel.Text)
                end
            }
        end
        
        function Tab:AddLabel(text)
            local Label = CreateInstance("Frame", {
                Name = "Label",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            local LabelText = CreateInstance("TextLabel", {
                Name = "LabelText",
                Parent = Label,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14
            })
            
            return Label
        end
        
        function Tab:AddSeparator()
            local Separator = CreateInstance("Frame", {
                Name = "Separator",
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1)
            })
            
            return Separator
        end
        
        return Tab
    end
    
    function Window:Notify(title, message, duration, notifType)
        SmoothUI:CreateNotification(title, message, duration, notifType)
    end
    
    return Window
end

return SmoothUI
