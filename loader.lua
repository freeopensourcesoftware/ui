
local SmoothUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    return instance
end

function SmoothUI:CreateWindow(title)
    local Window = {}
    
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "SmoothUI",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -200, 0.5, -150),
        Size = UDim2.new(0, 400, 0, 300),
        AnchorPoint = Vector2.new(0, 0)
    })
    
    local UICorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local UICornerTop = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar
    })
    
    local TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = title or "SmoothUI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
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
        Size = UDim2.new(1, 0, 1, -40),
        ClipsDescendants = true
    })
    
    local TabsFrame = CreateInstance("Frame", {
        Name = "TabsFrame",
        Parent = ContentFrame,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.25, 0, 1, 0)
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
        ScreenGui:Destroy()
    end)
    
    function Window:CreateTab(tabName)
        local Tab = {}
        
        local tabId = #tabs + 1
        local TabButton = CreateInstance("TextButton", {
            Name = tabName,
            Parent = TabsContainer,
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            AutoButtonColor = false
        })
        
        local UICornerTab = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        local TabPage = CreateInstance("ScrollingFrame", {
            Name = tabName .. "Page",
            Parent = TabContent,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
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
            Page = TabPage
        })
        
        TabButton.MouseButton1Click:Connect(function()
            if selectedTab then
                selectedTab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                selectedTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                selectedTab.Page.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabPage.Visible = true
            
            selectedTab = tabs[tabId]
        end)
        
        if #tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabPage.Visible = true
            selectedTab = tabs[tabId]
        end
        
        function Tab:AddButton(text, callback)
            local Button = CreateInstance("Frame", {
                Name = text .. "Button",
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36)
            })
            
            local UICornerButton = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            
            local ButtonLabel = CreateInstance("TextLabel", {
                Name = "ButtonLabel",
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
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
                local originalColor = Button.BackgroundColor3
                Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                
                spawn(function()
                    callback()
                end)
                
                wait(0.2)
                Button.BackgroundColor3 = originalColor
            end)
            
            ButtonClickArea.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            
            ButtonClickArea.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)
            
            return Button
        end
        
        function Tab:AddToggle(text, default, callback)
            local toggled = default or false
            
            local Toggle = CreateInstance("Frame", {
                Name = text .. "Toggle",
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36)
            })
            
            local UICornerToggle = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Toggle
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Name = "ToggleLabel",
                Parent = Toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ToggleIndicator = CreateInstance("Frame", {
                Name = "Indicator",
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Position = UDim2.new(1, -40, 0.5, -8),
                Size = UDim2.new(0, 30, 0, 16),
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
                Position = UDim2.new(0, 2, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                BorderSizePixel = 0
            })
            
            local UICornerCircle = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle
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
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 16, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
                
                callback(toggled)
            end
            
            if toggled then
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                ToggleCircle.Position = UDim2.new(0, 16, 0.5, -6)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            ToggleClickArea.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            ToggleClickArea.MouseEnter:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            
            ToggleClickArea.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
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
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 50)
            })
            
            local UICornerSlider = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Slider
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Name = "SliderLabel",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Name = "ValueLabel",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 5),
                Size = UDim2.new(0, 40, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(default),
                TextColor3 = Color3.fromRGB(230, 230, 230),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SliderBG = CreateInstance("Frame", {
                Name = "SliderBG",
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 5)
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
                Position = UDim2.new(0, -5, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                BorderSizePixel = 0
            })
            
            local UICornerSliderKnob = CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderKnob
            })
            
            local SliderClickArea = CreateInstance("TextButton", {
                Name = "ClickArea",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 20),
                Text = ""
            })
            
            local defaultValue = default or min
            local minValue = min or 0
            local maxValue = max or 100
            
            local function updateSlider(value)
                value = math.clamp(value, minValue, maxValue)
                
                local percent = (value - minValue) / (maxValue - minValue)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percent, -5, 0.5, -5)
                ValueLabel.Text = tostring(math.floor(value * 10) / 10)
                
                callback(value)
            end
            
            local isDragging = false
            
            SliderClickArea.MouseButton1Down:Connect(function()
                isDragging = true
                
                local relativeX = math.clamp(UserInputService:GetMouseLocation().X - SliderBG.AbsolutePosition.X, 0, SliderBG.AbsoluteSize.X)
                local value = minValue + (relativeX / SliderBG.AbsoluteSize.X) * (maxValue - minValue)
                updateSlider(value)
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
            
            updateSlider(defaultValue)
            
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
        
        return Tab
    end
    
    return Window
end

return SmoothUI
