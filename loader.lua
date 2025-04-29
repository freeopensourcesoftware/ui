
local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local function Draggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragInput and dragging then
            local delta = dragInput.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(name)
    local Window = {}
    Window.__index = Window
    
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local Container = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
    
    ScreenGui.Name = name .. "_UI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.ClipsDescendants = true
    
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 0)
    CloseButton.Size = UDim2.new(0, 25, 1, 0)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 30)
    Container.Size = UDim2.new(1, 0, 1, -30)
    Container.ScrollBarThickness = 4
    Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    UIListLayout.Parent = Container
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    UIPadding.Parent = Container
    UIPadding.PaddingTop = UDim.new(0, 5)
    UIPadding.PaddingBottom = UDim.new(0, 5)
    
    Draggable(MainFrame)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    function Window:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text .. "Button"
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(0.9, 0, 0, 30)
        Button.Font = Enum.Font.SourceSansSemibold
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        return Button
    end
    
    function Window:CreateToggle(text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local ToggleButton = Instance.new("TextButton")
        local ToggleInner = Instance.new("Frame")
        
        local toggled = default or false
        
        ToggleFrame.Name = text .. "Toggle"
        ToggleFrame.Parent = Container
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
        
        Title.Name = "Title"
        Title.Parent = ToggleFrame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -50, 1, 0)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = text
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = UDim2.new(1, -40, 0.5, -8)
        ToggleButton.Size = UDim2.new(0, 30, 0, 16)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        
        ToggleInner.Name = "ToggleInner"
        ToggleInner.Parent = ToggleButton
        ToggleInner.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        ToggleInner.BorderSizePixel = 0
        ToggleInner.Position = UDim2.new(0, 2, 0.5, -5)
        ToggleInner.Size = UDim2.new(0, 12, 0, 10)
        
        local function UpdateToggle()
            if toggled then
                TweenService:Create(ToggleInner, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, -5), BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
            else
                TweenService:Create(ToggleInner, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
            callback(toggled)
        end
        
        if toggled then
            ToggleInner.Position = UDim2.new(1, -14, 0.5, -5)
            ToggleInner.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            UpdateToggle()
        end)
        
        return ToggleFrame
    end
    
    function Window:CreateSlider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local SliderBG = Instance.new("Frame")
        local SliderFill = Instance.new("Frame")
        local SliderButton = Instance.new("TextButton")
        local ValueLabel = Instance.new("TextLabel")
        
        local value = default or min
        
        SliderFrame.Name = text .. "Slider"
        SliderFrame.Parent = Container
        SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Size = UDim2.new(0.9, 0, 0, 45)
        
        Title.Name = "Title"
        Title.Parent = SliderFrame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -20, 0, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = text
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        SliderBG.Name = "SliderBG"
        SliderBG.Parent = SliderFrame
        SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        SliderBG.BorderSizePixel = 0
        SliderBG.Position = UDim2.new(0, 10, 0, 25)
        SliderBG.Size = UDim2.new(1, -85, 0, 10)
        
        SliderFill.Name = "SliderFill"
        SliderFill.Parent = SliderBG
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        
        SliderButton.Name = "SliderButton"
        SliderButton.Parent = SliderBG
        SliderButton.BackgroundTransparency = 1
        SliderButton.Size = UDim2.new(1, 0, 1, 0)
        SliderButton.Text = ""
        
        ValueLabel.Name = "ValueLabel"
        ValueLabel.Parent = SliderFrame
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -65, 0, 20)
        ValueLabel.Size = UDim2.new(0, 55, 0, 20)
        ValueLabel.Font = Enum.Font.SourceSansSemibold
        ValueLabel.Text = tostring(value)
        ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.TextSize = 14
        
        local function UpdateSlider(input)
            local sizeX = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
            
            value = math.floor(min + ((max - min) * sizeX))
            ValueLabel.Text = tostring(value)
            callback(value)
        end
        
        SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                UpdateSlider(input)
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        local mousePos = UserInputService:GetMouseLocation()
                        local inputObj = {Position = Vector2.new(mousePos.X, mousePos.Y)}
                        UpdateSlider(inputObj)
                    else
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        return SliderFrame
    end
    
    function Window:CreateDropdown(text, options, default, callback)
        local DropdownFrame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local DropdownButton = Instance.new("TextButton")
        local OptionsFrame = Instance.new("Frame")
        local OptionsLayout = Instance.new("UIListLayout")
        
        local selected = default or options[1] or ""
        local open = false
        
        DropdownFrame.Name = text .. "Dropdown"
        DropdownFrame.Parent = Container
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.Size = UDim2.new(0.9, 0, 0, 30)
        DropdownFrame.ClipsDescendants = true
        
        Title.Name = "Title"
        Title.Parent = DropdownFrame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -20, 0, 30)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = text .. ": " .. selected
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 0, 30)
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.Text = ""
        
        OptionsFrame.Name = "OptionsFrame"
        OptionsFrame.Parent = DropdownFrame
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Position = UDim2.new(0, 0, 0, 30)
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        OptionsFrame.Visible = false
        
        OptionsLayout.Parent = OptionsFrame
        OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsLayout.Padding = UDim.new(0, 0)
        
        local totalHeight = 0
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Parent = OptionsFrame
            OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            OptionButton.BorderSizePixel = 0
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Font = Enum.Font.SourceSans
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 14
            
            totalHeight = totalHeight + 25
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                selected = option
                Title.Text = text .. ": " .. selected
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0.9, 0, 0, 30)}):Play()
                OptionsFrame.Visible = false
                open = false
                callback(selected)
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            if open then
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0.9, 0, 0, 30)}):Play()
                OptionsFrame.Visible = false
            else
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0.9, 0, 0, 30 + totalHeight)}):Play()
                OptionsFrame.Visible = true
            end
            open = not open
        end)
        
        return DropdownFrame
    end
    
    function Window:CreateTextbox(text, placeholder, callback)
        local TextboxFrame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local Textbox = Instance.new("TextBox")
        
        TextboxFrame.Name = text .. "Textbox"
        TextboxFrame.Parent = Container
        TextboxFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        TextboxFrame.BorderSizePixel = 0
        TextboxFrame.Size = UDim2.new(0.9, 0, 0, 30)
        
        Title.Name = "Title"
        Title.Parent = TextboxFrame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(0.3, 0, 1, 0)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = text
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        Textbox.Name = "Textbox"
        Textbox.Parent = TextboxFrame
        Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Textbox.BorderSizePixel = 0
        Textbox.Position = UDim2.new(0.3, 10, 0.5, -10)
        Textbox.Size = UDim2.new(0.7, -20, 0, 20)
        Textbox.Font = Enum.Font.SourceSans
        Textbox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
        Textbox.PlaceholderText = placeholder
        Textbox.Text = ""
        Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        Textbox.TextSize = 14
        
        Textbox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(Textbox.Text)
            end
        end)
        
        return TextboxFrame
    end
    
    function Window:CreateLabel(text)
        local Label = Instance.new("TextLabel")
        
        Label.Name = "Label"
        Label.Parent = Container
        Label.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        Label.BorderSizePixel = 0
        Label.Size = UDim2.new(0.9, 0, 0, 25)
        Label.Font = Enum.Font.SourceSansSemibold
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 14
        
        return Label
    end

    return setmetatable(Window, Window)
end

return Library
