
local Library={
Version="1.0.0",
Flags={}
}

local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local CoreGui=game:GetService("CoreGui")
local LocalPlayer=Players.LocalPlayer
local Mouse=LocalPlayer:GetMouse()
local Debris=game:GetService("Debris")

local function Create(instance,properties)
local obj=Instance.new(instance)
for i,v in pairs(properties or{})do
obj[i]=v
end
return obj
end

function Library:Tween(instance,properties,duration)
local tween=TweenService:Create(instance,TweenInfo.new(duration or 0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties)
tween:Play()
return tween
end

function Library:Window(options)
options=options or{}
local WindowName=options.Name or"Window"
local WindowColor=options.Color or Color3.fromRGB(0,120,255)
local WindowSize=options.Size or UDim2.new(0,500,0,350)
local ToggleKey=options.Key or Enum.KeyCode.RightShift
local WindowObj={}

local ScreenGui=Create("ScreenGui",{
Name="ModernUI",
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
ResetOnSpawn=false,
Parent=CoreGui
})

local MainFrame=Create("Frame",{
Name="MainFrame",
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=Color3.fromRGB(25,25,25),
BorderSizePixel=0,
ClipsDescendants=true,
Position=UDim2.new(0.5,0,0.5,0),
Size=WindowSize
})

local TopBar=Create("Frame",{
Name="TopBar",
BackgroundColor3=Color3.fromRGB(30,30,30),
BorderSizePixel=0,
Size=UDim2.new(1,0,0,36),
Parent=MainFrame
})

local WindowTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
Size=UDim2.new(0,200,0,20),
Font=Enum.Font.GothamBold,
Text=WindowName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=TopBar
})

local CloseButton=Create("TextButton",{
Name="Close",
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Position=UDim2.new(1,-10,0.5,0),
Size=UDim2.new(0,20,0,20),
Font=Enum.Font.GothamBold,
Text="X",
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
Parent=TopBar
})

local MinimizeButton=Create("TextButton",{
Name="Minimize",
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Position=UDim2.new(1,-40,0.5,0),
Size=UDim2.new(0,20,0,20),
Font=Enum.Font.GothamBold,
Text="-",
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
Parent=TopBar
})

local Container=Create("Frame",{
Name="Container",
BackgroundColor3=Color3.fromRGB(25,25,25),
BorderSizePixel=0,
Position=UDim2.new(0,0,0,36),
Size=UDim2.new(1,0,1,-36),
Parent=MainFrame
})

local TabHolder=Create("Frame",{
Name="TabHolder",
BackgroundColor3=Color3.fromRGB(20,20,20),
BorderSizePixel=0,
Size=UDim2.new(0,130,1,0),
Parent=Container
})

local TabButtonHolder=Create("ScrollingFrame",{
Name="TabButtonHolder",
Active=true,
BackgroundTransparency=1,
BorderSizePixel=0,
Position=UDim2.new(0,0,0,10),
Size=UDim2.new(1,0,1,-10),
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
Parent=TabHolder
})

local TabButtonPadding=Create("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingTop=UDim.new(0,4),
Parent=TabButtonHolder
})

local TabButtonList=Create("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,5),
Parent=TabButtonHolder
})

local TabContainerFrame=Create("Frame",{
Name="TabContainer",
BackgroundTransparency=1,
BorderSizePixel=0,
Position=UDim2.new(0,130,0,0),
Size=UDim2.new(1,-130,1,0),
Parent=Container
})

local Shadow=Create("ImageLabel",{
Name="Shadow",
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(1,30,1,30),
ZIndex=-1,
Image="rbxassetid://7912134082",
ImageColor3=Color3.fromRGB(0,0,0),
ImageTransparency=0.2,
Parent=MainFrame
})

MainFrame.Parent=ScreenGui

local Dragging=false
local DragInput
local DragStart
local StartPos

local function UpdateDrag(input)
local Delta=input.Position-DragStart
MainFrame.Position=UDim2.new(StartPos.X.Scale,StartPos.X.Offset+Delta.X,StartPos.Y.Scale,StartPos.Y.Offset+Delta.Y)
end

TopBar.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
Dragging=true
DragStart=input.Position
StartPos=MainFrame.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
Dragging=false
end
end)
end
end)

TopBar.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement then
DragInput=input
end
end)

UserInputService.InputChanged:Connect(function(input)
if input==DragInput and Dragging then
UpdateDrag(input)
end
end)

CloseButton.MouseButton1Click:Connect(function()
ScreenGui:Destroy()
end)

local Minimized=false
MinimizeButton.MouseButton1Click:Connect(function()
Minimized=not Minimized
if Minimized then
MainFrame:TweenSize(UDim2.new(0,WindowSize.X.Offset,0,36),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)
else
MainFrame:TweenSize(WindowSize,Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)
end
end)

local UIHidden=false
UserInputService.InputBegan:Connect(function(input)
if input.KeyCode==ToggleKey then
UIHidden=not UIHidden
ScreenGui.Enabled=not UIHidden
end
end)

local ActiveTab=nil
local Tabs={}

function WindowObj:Tab(name)
local TabObj={}
local TabButton=Create("TextButton",{
Name=name,
BackgroundColor3=Color3.fromRGB(30,30,30),
Size=UDim2.new(1,-16,0,32),
Font=Enum.Font.Gotham,
Text="",
TextColor3=Color3.fromRGB(255,255,255),
AutoButtonColor=false
})

local TabButtonTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Size=UDim2.new(1,-10,1,0),
Position=UDim2.new(0,10,0,0),
Font=Enum.Font.Gotham,
Text=name,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=TabButton
})

local TabButtonCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=TabButton
})

local TabPage=Create("ScrollingFrame",{
Name=name,
Active=true,
BackgroundTransparency=1,
BorderSizePixel=0,
Size=UDim2.new(1,0,1,0),
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollBarThickness=3,
Visible=false,
Parent=TabContainerFrame
})

local TabPagePadding=Create("UIPadding",{
PaddingLeft=UDim.new(0,15),
PaddingRight=UDim.new(0,15),
PaddingTop=UDim.new(0,15),
PaddingBottom=UDim.new(0,15),
Parent=TabPage
})

local TabPageList=Create("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,8),
Parent=TabPage
})

TabButton.Parent=TabButtonHolder
local TabData={
Button=TabButton,
Page=TabPage
}
table.insert(Tabs,TabData)

TabButton.MouseButton1Click:Connect(function()
for _,tab in pairs(Tabs)do
tab.Button.BackgroundColor3=Color3.fromRGB(30,30,30)
tab.Page.Visible=false
end
TabButton.BackgroundColor3=WindowColor
TabPage.Visible=true
ActiveTab=TabData
end)

function TabObj:Section(name)
local SectionObj={}
local Section=Create("Frame",{
Name=name,
BackgroundColor3=Color3.fromRGB(30,30,30),
BorderSizePixel=0,
Size=UDim2.new(1,0,0,36),
AutomaticSize=Enum.AutomaticSize.Y,
Parent=TabPage
})

local SectionCorner=Create("UICorner",{
CornerRadius=UDim.new(0,6),
Parent=Section
})

local SectionTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,0),
Size=UDim2.new(1,-20,0,36),
Font=Enum.Font.GothamBold,
Text=name,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=Section
})

local Container=Create("Frame",{
Name="Container",
BackgroundTransparency=1,
Position=UDim2.new(0,0,0,36),
Size=UDim2.new(1,0,1,-36),
AutomaticSize=Enum.AutomaticSize.Y,
Parent=Section
})

local ContainerList=Create("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,8),
Parent=Container
})

local ContainerPadding=Create("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
Parent=Container
})

function SectionObj:Button(options)
options=options or{}
local ButtonText=options.Name or"Button"
local ButtonCallback=options.Callback or function()end

local Button=Create("Frame",{
Name=ButtonText,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,32),
Parent=Container
})

local ButtonInner=Create("TextButton",{
Name="Button",
BackgroundColor3=Color3.fromRGB(40,40,40),
Size=UDim2.new(1,0,1,0),
Font=Enum.Font.Gotham,
Text=ButtonText,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
AutoButtonColor=false,
Parent=Button
})

local ButtonCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ButtonInner
})

ButtonInner.MouseButton1Click:Connect(ButtonCallback)
ButtonInner.MouseEnter:Connect(function()
Library:Tween(ButtonInner,{BackgroundColor3=Color3.fromRGB(50,50,50)})
end)
ButtonInner.MouseLeave:Connect(function()
Library:Tween(ButtonInner,{BackgroundColor3=Color3.fromRGB(40,40,40)})
end)
end

function SectionObj:Toggle(options)
options=options or{}
local ToggleName=options.Name or"Toggle"
local ToggleDefault=options.Default or false
local ToggleCallback=options.Callback or function()end
local Flag=options.Flag or(ToggleName.."Toggle")

local Toggle=Create("Frame",{
Name=ToggleName,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,32),
Parent=Container
})

local ToggleInner=Create("Frame",{
Name="Toggle",
BackgroundColor3=Color3.fromRGB(40,40,40),
Size=UDim2.new(1,0,1,0),
Parent=Toggle
})

local ToggleCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ToggleInner
})

local ToggleTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,0),
Size=UDim2.new(1,-60,1,0),
Font=Enum.Font.Gotham,
Text=ToggleName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=ToggleInner
})

local ToggleIndicator=Create("Frame",{
Name="Indicator",
AnchorPoint=Vector2.new(1,0.5),
BackgroundColor3=Color3.fromRGB(20,20,20),
Position=UDim2.new(1,-10,0.5,0),
Size=UDim2.new(0,40,0,20),
Parent=ToggleInner
})

local ToggleIndicatorCorner=Create("UICorner",{
CornerRadius=UDim.new(1,0),
Parent=ToggleIndicator
})

local ToggleDot=Create("Frame",{
Name="Dot",
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.fromRGB(255,255,255),
Position=UDim2.new(0,2,0.5,0),
Size=UDim2.new(0,16,0,16),
Parent=ToggleIndicator
})

local ToggleDotCorner=Create("UICorner",{
CornerRadius=UDim.new(1,0),
Parent=ToggleDot
})

local Toggled=ToggleDefault
Library.Flags[Flag]=Toggled

local function UpdateToggle(value)
Toggled=value
Library.Flags[Flag]=Toggled
if Toggled then
Library:Tween(ToggleDot,{Position=UDim2.new(1,-18,0.5,0)})
Library:Tween(ToggleIndicator,{BackgroundColor3=WindowColor})
else
Library:Tween(ToggleDot,{Position=UDim2.new(0,2,0.5,0)})
Library:Tween(ToggleIndicator,{BackgroundColor3=Color3.fromRGB(20,20,20)})
end
ToggleCallback(Toggled)
end

ToggleInner.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
UpdateToggle(not Toggled)
end
end)

UpdateToggle(Toggled)

function SectionObj:Slider(options)
options=options or{}
local SliderName=options.Name or"Slider"
local SliderMin=options.Min or 0
local SliderMax=options.Max or 100
local SliderDefault=options.Default or SliderMin
local SliderIncrement=options.Increment or 1
local SliderUnit=options.Unit or""
local SliderCallback=options.Callback or function()end
local Flag=options.Flag or(SliderName.."Slider")

SliderDefault=math.clamp(SliderDefault,SliderMin,SliderMax)
SliderDefault=math.floor((SliderDefault/SliderIncrement)+0.5)*SliderIncrement
if SliderIncrement<1 then
local DecimalPlaces=string.len(string.split(tostring(SliderIncrement),".")[2])
SliderDefault=tonumber(string.format("%."..DecimalPlaces.."f",SliderDefault))
else
SliderDefault=math.floor(SliderDefault)
end

local Slider=Create("Frame",{
Name=SliderName,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,50),
Parent=Container
})

local SliderInner=Create("Frame",{
Name="Slider",
BackgroundColor3=Color3.fromRGB(40,40,40),
Size=UDim2.new(1,0,1,0),
Parent=Slider
})

local SliderCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=SliderInner
})

local SliderTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,0),
Size=UDim2.new(1,-20,0,20),
Font=Enum.Font.Gotham,
Text=SliderName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=SliderInner
})

local SliderValue=Create("TextLabel",{
Name="Value",
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,-10,0,0),
Size=UDim2.new(0,60,0,20),
Font=Enum.Font.Gotham,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Right,
Parent=SliderInner
})

local SliderBack=Create("Frame",{
Name="Back",
BorderSizePixel=0,
Position=UDim2.new(0,10,0,25),
Size=UDim2.new(1,-20,0,10),
BackgroundColor3=Color3.fromRGB(25,25,25),
Parent=SliderInner
})

local SliderBackCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=SliderBack
})

local SliderFill=Create("Frame",{
Name="Fill",
BorderSizePixel=0,
Size=UDim2.new(0,0,1,0),
BackgroundColor3=WindowColor,
Parent=SliderBack
})

local SliderFillCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=SliderFill
})

local SliderDot=Create("Frame",{
Name="Dot",
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=Color3.fromRGB(255,255,255),
Position=UDim2.new(1,0,0.5,0),
Size=UDim2.new(0,12,0,12),
ZIndex=2,
Parent=SliderFill
})

local SliderDotCorner=Create("UICorner",{
CornerRadius=UDim.new(1,0),
Parent=SliderDot
})

local Value=SliderDefault
Library.Flags[Flag]=Value

local function UpdateSlider(value)
Value=value
Library.Flags[Flag]=Value
local Percent=(Value-SliderMin)/(SliderMax-SliderMin)
SliderFill:TweenSize(UDim2.new(Percent,0,1,0),"Out","Quad",0.05,true)
SliderValue.Text=tostring(Value)..SliderUnit
SliderCallback(Value)
end

local function RoundNumber(num,increment)
return math.floor((num/increment)+0.5)*increment
end

local Dragging=false
SliderBack.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
Dragging=true
local MousePosition=UserInputService:GetMouseLocation().X
local SliderPosition=SliderBack.AbsolutePosition.X
local SliderWidth=SliderBack.AbsoluteSize.X
local Percent=math.clamp((MousePosition-SliderPosition)/SliderWidth,0,1)
local NewValue=SliderMin+(Percent*(SliderMax-SliderMin))
NewValue=RoundNumber(NewValue,SliderIncrement)
if SliderIncrement<1 then
local DecimalPlaces=string.len(string.split(tostring(SliderIncrement),".")[2])
NewValue=tonumber(string.format("%."..DecimalPlaces.."f",NewValue))
else
NewValue=math.floor(NewValue)
end
UpdateSlider(NewValue)
end
end)

SliderBack.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
Dragging=false
end
end)

UserInputService.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement and Dragging then
local MousePosition=UserInputService:GetMouseLocation().X
local SliderPosition=SliderBack.AbsolutePosition.X
local SliderWidth=SliderBack.AbsoluteSize.X
local Percent=math.clamp((MousePosition-SliderPosition)/SliderWidth,0,1)
local NewValue=SliderMin+(Percent*(SliderMax-SliderMin))
NewValue=RoundNumber(NewValue,SliderIncrement)
if SliderIncrement<1 then
local DecimalPlaces=string.len(string.split(tostring(SliderIncrement),".")[2] or"0")
NewValue=tonumber(string.format("%."..DecimalPlaces.."f",NewValue))
else
NewValue=math.floor(NewValue)
end
UpdateSlider(NewValue)
end
end)

UpdateSlider(SliderDefault)
end

function SectionObj:Dropdown(options)
options=options or{}
local DropdownName=options.Name or"Dropdown"
local DropdownItems=options.Items or{}
local DropdownDefault=options.Default or""
local DropdownCallback=options.Callback or function()end
local Flag=options.Flag or(DropdownName.."Dropdown")

local Dropdown=Create("Frame",{
Name=DropdownName,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,40),
Parent=Container
})

local DropdownInner=Create("Frame",{
Name="Dropdown",
BackgroundColor3=Color3.fromRGB(40,40,40),
Size=UDim2.new(1,0,0,40),
ClipsDescendants=true,
Parent=Dropdown
})

local DropdownCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=DropdownInner
})

local DropdownTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,0),
Size=UDim2.new(1,-40,0,40),
Font=Enum.Font.Gotham,
Text=DropdownName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=DropdownInner
})

local DropdownButton=Create("TextButton",{
Name="Button",
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
Size=UDim2.new(0,40,0,40),
Font=Enum.Font.GothamBold,
Text="▼",
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
Parent=DropdownInner
})

local DropdownContainer=Create("Frame",{
Name="Container",
BackgroundTransparency=1,
Position=UDim2.new(0,0,0,40),
Size=UDim2.new(1,0,0,120),
Visible=false,
Parent=DropdownInner
})

local DropdownItemList=Create("ScrollingFrame",{
Name="ItemList",
Active=true,
BackgroundTransparency=1,
BorderSizePixel=0,
Size=UDim2.new(1,0,1,0),
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=3,
AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
Parent=DropdownContainer
})

local ItemListLayout=Create("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Parent=DropdownItemList
})

local ItemListPadding=Create("UIPadding",{
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingTop=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
Parent=DropdownItemList
})

local Selected=DropdownDefault
Library.Flags[Flag]=Selected
DropdownTitle.Text=DropdownName..": "..Selected
local MaxHeight=120
local Open=false

local function CloseDropdown()
Open=false
DropdownButton.Text="▼"
DropdownContainer.Visible=false
Library:Tween(DropdownInner,{Size=UDim2.new(1,0,0,40)})
end

local function OpenDropdown()
Open=true
DropdownButton.Text="▲"
DropdownContainer.Visible=true
Library:Tween(DropdownInner,{Size=UDim2.new(1,0,0,40+MaxHeight)})
end

local function UpdateDropdown(value)
Selected=value
Library.Flags[Flag]=Selected
DropdownTitle.Text=DropdownName..": "..Selected
CloseDropdown()
DropdownCallback(Selected)
end

local function RefreshDropdown(items)
for _,v in pairs(DropdownItemList:GetChildren())do
if v:IsA("TextButton")then
v:Destroy()
end
end

for _,item in pairs(items)do
local ItemButton=Create("TextButton",{
Name=item,
BackgroundColor3=Color3.fromRGB(35,35,35),
Size=UDim2.new(1,0,0,30),
Font=Enum.Font.Gotham,
Text=item,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
AutoButtonColor=false,
Parent=DropdownItemList
})

local ItemCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ItemButton
})

ItemButton.MouseButton1Click:Connect(function()
UpdateDropdown(item)
end)

ItemButton.MouseEnter:Connect(function()
Library:Tween(ItemButton,{BackgroundColor3=Color3.fromRGB(45,45,45)})
end)

ItemButton.MouseLeave:Connect(function()
Library:Tween(ItemButton,{BackgroundColor3=Color3.fromRGB(35,35,35)})
end)
end
end

RefreshDropdown(DropdownItems)

DropdownButton.MouseButton1Click:Connect(function()
if Open then
CloseDropdown()
else
OpenDropdown()
end
end)

function SectionObj:ColorPicker(options)
options=options or{}
local ColorPickerName=options.Name or"Color Picker"
local ColorPickerDefault=options.Default or Color3.fromRGB(255,255,255)
local ColorPickerCallback=options.Callback or function()end
local Flag=options.Flag or(ColorPickerName.."ColorPicker")

local ColorPicker=Create("Frame",{
Name=ColorPickerName,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,40),
Parent=Container
})

local ColorPickerInner=Create("Frame",{
Name="ColorPicker",
BackgroundColor3=Color3.fromRGB(40,40,40),
Size=UDim2.new(1,0,1,0),
Parent=ColorPicker
})

local ColorPickerCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ColorPickerInner
})

local ColorPickerTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,0),
Size=UDim2.new(1,-60,1,0),
Font=Enum.Font.Gotham,
Text=ColorPickerName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=ColorPickerInner
})

local ColorDisplay=Create("Frame",{
Name="ColorDisplay",
AnchorPoint=Vector2.new(1,0.5),
BackgroundColor3=ColorPickerDefault,
Position=UDim2.new(1,-10,0.5,0),
Size=UDim2.new(0,30,0,30),
Parent=ColorPickerInner
})

local ColorDisplayCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ColorDisplay
})

local SelectedColor=ColorPickerDefault
Library.Flags[Flag]=SelectedColor

local function UpdateColorPicker(color)
SelectedColor=color
Library.Flags[Flag]=SelectedColor
ColorDisplay.BackgroundColor3=SelectedColor
ColorPickerCallback(SelectedColor)
end

ColorPickerInner.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
local ColorPickerFrame=Create("Frame",{
Name="ColorPickerFrame",
BackgroundColor3=Color3.fromRGB(30,30,30),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Size=UDim2.new(0,300,0,300),
Parent=ScreenGui
})

local ColorPickerFrameCorner=Create("UICorner",{
CornerRadius=UDim.new(0,6),
Parent=ColorPickerFrame
})

local ColorPickerFrameTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,0),
Size=UDim2.new(1,-20,0,30),
Font=Enum.Font.GothamBold,
Text=ColorPickerName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=ColorPickerFrame
})

local CloseColorPicker=Create("TextButton",{
Name="Close",
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,-10,0,5),
Size=UDim2.new(0,20,0,20),
Font=Enum.Font.GothamBold,
Text="X",
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
Parent=ColorPickerFrame
})

local ColorArea=Create("Frame",{
Name="ColorArea",
BackgroundTransparency=1,
Position=UDim2.new(0,10,0,40),
Size=UDim2.new(1,-20,0,200),
Parent=ColorPickerFrame
})

local ColorPreview=Create("Frame",{
Name="ColorPreview",
BackgroundColor3=SelectedColor,
Position=UDim2.new(0,0,0,210),
Size=UDim2.new(1,0,0,40),
Parent=ColorPickerFrame
})

local ColorPreviewCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ColorPreview
})

local ConfirmButton=Create("TextButton",{
Name="Confirm",
BackgroundColor3=Color3.fromRGB(40,40,40),
Position=UDim2.new(0,10,1,-40),
Size=UDim2.new(1,-20,0,30),
Font=Enum.Font.Gotham,
Text="Confirm",
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
Parent=ColorPickerFrame
})

local ConfirmButtonCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=ConfirmButton
})

local H,S,V=Color3.toHSV(SelectedColor)
local Hue,Sat,Val=H,S,V

local HueFrame=Create("Frame",{
Name="Hue",
BackgroundColor3=Color3.fromHSV(0,1,1),
Position=UDim2.new(0,0,0,0),
Size=UDim2.new(1,0,0,20),
Parent=ColorArea
})

local HueCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=HueFrame
})

local HueGradient=Create("UIGradient",{
Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),
ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))
}),
Parent=HueFrame
})

local HueSelector=Create("Frame",{
Name="Selector",
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=Color3.fromRGB(255,255,255),
Position=UDim2.new(H,0,0.5,0),
Size=UDim2.new(0,5,1,0),
ZIndex=2,
Parent=HueFrame
})

local SVFrame=Create("Frame",{
Name="SV",
BackgroundColor3=Color3.fromHSV(H,1,1),
Position=UDim2.new(0,0,0,30),
Size=UDim2.new(1,0,0,160),
Parent=ColorArea
})

local SVCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=SVFrame
})

local SVGradientV=Create("UIGradient",{
Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(0,0,0)),
Rotation=90,
Parent=SVFrame
})

local SVGradientS=Create("UIGradient",{
Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255)),
Transparency=NumberSequence.new({
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1)
}),
Parent=SVFrame
})

local SVSelector=Create("Frame",{
Name="Selector",
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=0.5,
Position=UDim2.new(S,0,1-V,0),
Size=UDim2.new(0,10,0,10),
ZIndex=2,
Parent=SVFrame
})

local SVSelectorCorner=Create("UICorner",{
CornerRadius=UDim.new(1,0),
Parent=SVSelector
})

local function UpdateColor()
local NewColor=Color3.fromHSV(Hue,Sat,Val)
ColorPreview.BackgroundColor3=NewColor
SVFrame.BackgroundColor3=Color3.fromHSV(Hue,1,1)
end

local HueDragging=false
HueFrame.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
HueDragging=true
local MouseX=input.Position.X
local FrameX=HueFrame.AbsolutePosition.X
local FrameWidth=HueFrame.AbsoluteSize.X
Hue=math.clamp((MouseX-FrameX)/FrameWidth,0,1)
HueSelector.Position=UDim2.new(Hue,0,0.5,0)
UpdateColor()
end
end)

HueFrame.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
HueDragging=false
end
end)

local SVDragging=false
SVFrame.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
SVDragging=true
local MousePos=Vector2.new(input.Position.X,input.Position.Y)
local FramePos=Vector2.new(SVFrame.AbsolutePosition.X,SVFrame.AbsolutePosition.Y)
local FrameSize=Vector2.new(SVFrame.AbsoluteSize.X,SVFrame.AbsoluteSize.Y)
Sat=math.clamp((MousePos.X-FramePos.X)/FrameSize.X,0,1)
Val=1-math.clamp((MousePos.Y-FramePos.Y)/FrameSize.Y,0,1)
SVSelector.Position=UDim2.new(Sat,0,1-Val,0)
UpdateColor()
end
end)

SVFrame.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
SVDragging=false
end
end)

UserInputService.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement then
if HueDragging then
local MouseX=input.Position.X
local FrameX=HueFrame.AbsolutePosition.X
local FrameWidth=HueFrame.AbsoluteSize.X
Hue=math.clamp((MouseX-FrameX)/FrameWidth,0,1)
HueSelector.Position=UDim2.new(Hue,0,0.5,0)
UpdateColor()
elseif SVDragging then
local MousePos=Vector2.new(input.Position.X,input.Position.Y)
local FramePos=Vector2.new(SVFrame.AbsolutePosition.X,SVFrame.AbsolutePosition.Y)
local FrameSize=Vector2.new(SVFrame.AbsoluteSize.X,SVFrame.AbsoluteSize.Y)
Sat=math.clamp((MousePos.X-FramePos.X)/FrameSize.X,0,1)
Val=1-math.clamp((MousePos.Y-FramePos.Y)/FrameSize.Y,0,1)
SVSelector.Position=UDim2.new(Sat,0,1-Val,0)
UpdateColor()
end
end
end)

CloseColorPicker.MouseButton1Click:Connect(function()
ColorPickerFrame:Destroy()
end)

ConfirmButton.MouseButton1Click:Connect(function()
UpdateColorPicker(ColorPreview.BackgroundColor3)
ColorPickerFrame:Destroy()
end)
end
end)

UpdateColorPicker(ColorPickerDefault)
end

function SectionObj:TextBox(options)
options=options or{}
local TextBoxName=options.Name or"TextBox"
local TextBoxDefault=options.Default or""
local TextBoxPlaceholder=options.Placeholder or"Enter text..."
local TextBoxCallback=options.Callback or function()end
local Flag=options.Flag or(TextBoxName.."TextBox")

local TextBox=Create("Frame",{
Name=TextBoxName,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,40),
Parent=Container
})

local TextBoxInner=Create("Frame",{
Name="TextBox",
BackgroundColor3=Color3.fromRGB(40,40,40),
Size=UDim2.new(1,0,1,0),
Parent=TextBox
})

local TextBoxCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=TextBoxInner
})

local TextBoxTitle=Create("TextLabel",{
Name="Title",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,20),
Position=UDim2.new(0,10,0,0),
Font=Enum.Font.Gotham,
Text=TextBoxName,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=TextBoxInner
})

local TextBoxField=Create("TextBox",{
Name="Field",
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.fromRGB(30,30,30),
Position=UDim2.new(0,10,1,-5),
Size=UDim2.new(1,-20,0,20),
Font=Enum.Font.Gotham,
Text=TextBoxDefault,
PlaceholderText=TextBoxPlaceholder,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
ClearTextOnFocus=false,
Parent=TextBoxInner
})

local TextBoxFieldCorner=Create("UICorner",{
CornerRadius=UDim.new(0,4),
Parent=TextBoxField
})

local TextBoxValue=TextBoxDefault
Library.Flags[Flag]=TextBoxValue

TextBoxField.FocusLost:Connect(function(enterPressed)
TextBoxValue=TextBoxField.Text
Library.Flags[Flag]=TextBoxValue
TextBoxCallback(TextBoxValue)
end)

function SectionObj:Label(options)
options=options or{}
local LabelText=options.Text or"Label"

local Label=Create("Frame",{
Name="Label",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,20),
Parent=Container
})

local LabelText=Create("TextLabel",{
Name="Text",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Font=Enum.Font.Gotham,
Text=LabelText,
TextColor3=Color3.fromRGB(255,255,255),
TextSize=14,
Parent=Label
})

local LabelObj={Instance=Label}

function LabelObj:SetText(text)
LabelText.Text=text
end

return LabelObj
end

return SectionObj
end

return TabObj
end

if #Tabs>0 then
Tabs[1].Button.BackgroundColor3=WindowColor
Tabs[1].Page.Visible=true
ActiveTab=Tabs[1]
end

return WindowObj
end

return Library
