-- SkidzWare UI Library (Updated, Fixed & Slider + Minimize)
local SkidzWare = {}
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Creation Helper
local function create(class, props, children)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    for _,child in pairs(children or {}) do child.Parent = obj end
    return obj
end

-- LOADING SCREEN
do
    local LoadGui = create("ScreenGui", {Name="SkidzWare_Load", Parent=LocalPlayer:WaitForChild("PlayerGui")})
    local LoadFrame = create("Frame", {
        Size = UDim2.new(0,300,0,140),
        Position = UDim2.new(0.5,-150,0.5,-70),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        BorderSizePixel = 0,
        Parent = LoadGui
    }, {
        create("UICorner", {CornerRadius = UDim.new(0,12)}),
        create("UIStroke", {Color = Color3.fromRGB(50,50,50)})
    })

    local pfp = create("ImageLabel", {
        Name = "PFP",
        Size = UDim2.new(0,60,0,60),
        Position = UDim2.new(0.5,-30,0,10),
        BackgroundTransparency = 1,
        Parent = LoadFrame,
    })
    create("UICorner",{CornerRadius=UDim.new(0.5,0), Parent=pfp})

    task.spawn(function()
        local success, url = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if success and url then pfp.Image = url
        else pfp.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png" end
    end)

    local Label = create("TextLabel", {
        Text="Welcome! Thank You for Using SkidzUiLib!",
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,30),
        Position=UDim2.new(0,0,0,80),
        Parent = LoadFrame,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local BarBG = create("Frame", {
        Size=UDim2.new(1,-20,0,20),
        Position=UDim2.new(0,10,0,115),
        BackgroundColor3=Color3.fromRGB(40,40,40),
        Parent=LoadFrame
    }, {create("UICorner", {CornerRadius=UDim.new(0,8)})})

    local Bar = create("Frame", {
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=Color3.fromRGB(0,200,100),
        Parent=BarBG
    }, {create("UICorner", {CornerRadius=UDim.new(0,8)})})

    TweenService:Create(Bar, TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)}):Play()
    task.wait(3.2)
    Label.Text = "Made by Tyrone_darealest"
    task.wait(0.8)
    LoadGui:Destroy()
end

-- MAIN SCREEN
local ScreenGui = create("ScreenGui", {Name="SkidzWare", Parent=LocalPlayer:WaitForChild("PlayerGui")})
local MainFrame = create("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 500, 0, 360),
    Position = UDim2.new(0.5, -250, 0.5, -180),
    AnchorPoint = Vector2.new(0.5,0.5),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    BorderSizePixel = 0,
    Parent = ScreenGui
}, {
    create("UICorner", {CornerRadius = UDim.new(0,16)}),
    create("UIStroke", {Color = Color3.fromRGB(60,60,60), Thickness = 2})
})

-- TOPBAR
local Topbar = create("Frame", {
    Size = UDim2.new(1,0,0,32),
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    Parent = MainFrame,
    BorderSizePixel = 0
})
create("UICorner", {CornerRadius = UDim.new(0,16), Parent=Topbar})
local Title = create("TextLabel", {
    Text = "SkidzWare",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundTransparency = 1,
    Size = UDim2.new(1,-10,1,0),
    Position = UDim2.new(0,10,0,0),
    Parent = Topbar,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- MINIMIZE BUTTON
do
    local MinimizeButton = create("TextButton", {
        Size = UDim2.new(0,32,0,32),
        Position = UDim2.new(1,-38,0,0),
        BackgroundColor3 = Color3.fromRGB(50,50,50),
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255,255,255),
        Parent = Topbar
    }, {create("UICorner",{CornerRadius=UDim.new(0,8)})})

    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 32)}):Play()
            for _, tab in ipairs(Tabs) do tab.Frame.Visible = false end
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0,500,0,360)}):Play()
            if #Tabs > 0 then Tabs[1].Frame.Visible = true end
        end
    end)
end

-- DRAGGING
do
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- NOTIFICATIONS
local NotificationsFrame = create("Frame", {
    Size = UDim2.new(0, 300, 0, 500),
    Position = UDim2.new(1, -310, 1, -510),
    BackgroundTransparency = 1,
    Parent = ScreenGui
})

local function notify(text,duration)
    local notif = create("Frame", {
        Size = UDim2.new(0, 300, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        Parent = NotificationsFrame
    }, {
        create("UICorner",{CornerRadius=UDim.new(0,8)}),
        create("UIStroke",{Color=Color3.fromRGB(80,80,80)}),
        create("TextLabel",{
            Text=text,
            Font=Enum.Font.Gotham,
            TextSize=14,
            TextColor3=Color3.fromRGB(255,255,255),
            BackgroundTransparency=1,
            Size=UDim2.new(1,-10,1,0),
            Position=UDim2.new(0,5,0,0),
            TextXAlignment=Enum.TextXAlignment.Left
        })
    })
    for _, child in ipairs(NotificationsFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= notif then
            TweenService:Create(child, TweenInfo.new(0.3), {Position = child.Position - UDim2.new(0,0,0,50)}):Play()
        end
    end
    notif.Position = UDim2.new(0,0,1,0)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0,0,1,-50)}):Play()
    task.delay(duration or 3,function()
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = notif.Position + UDim2.new(0,0,0,50)}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end
SkidzWare.Notify = notify

-- TAB SYSTEM
local TabButtonsFrame = create("Frame", {
    Size = UDim2.new(1,0,0,32),
    Position = UDim2.new(0,0,0,32),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

local TabContentFrame = create("Frame", {
    Size = UDim2.new(1,0,1,-64),
    Position = UDim2.new(0,0,0,64),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

local Tabs = {}
function SkidzWare:CreateTab(name)
    local tab = {Name=name, Components={}, Frame=create("Frame",{Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Parent=TabContentFrame})}
    tab.Frame.Visible = (#Tabs == 0)
    local btn = create("TextButton",{
        Size=UDim2.new(0,100,1,0),
        BackgroundColor3=Color3.fromRGB(50,50,50),
        Text=name,
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold,
        TextSize=14,
        Parent=TabButtonsFrame
    }, {create("UICorner",{CornerRadius=UDim.new(0,8)})})
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Frame.Visible = false end
        tab.Frame.Visible = true
    end)
    table.insert(Tabs,tab)
    for i,t in ipairs(Tabs) do
        t.Button = t.Button or btn
        t.Button.Position = UDim2.new(0,(i-1)*110,0,0)
    end
    tab.Button = btn
    return tab
end

-- SCROLLING CONTENT
local function createScrollingFrame(parent)
    local sf = create("ScrollingFrame",{
        Size=UDim2.new(1,-10,1,-10),
        Position=UDim2.new(0,5,0,5),
        CanvasSize=UDim2.new(0,0,0,0),
        ScrollBarThickness=6,
        BackgroundTransparency=1,
        Parent=parent
    })
    local layout = create("UIListLayout",{Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder})
    layout.Parent = sf
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sf.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)
    return sf
end

-- ELEMENT CREATION
function SkidzWare:CreateButton(parent,text,callback)
    local Button = create("TextButton", {
        Size = UDim2.new(1,-10,0,32),
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        Text=text,
        Font=Enum.Font.Gotham,
        TextSize=14,
        TextColor3=Color3.fromRGB(255,255,255),
        Parent=parent
    }, {
        create("UICorner",{CornerRadius=UDim.new(0,8)}),
        create("UIStroke",{Color=Color3.fromRGB(80,80,80)})
    })
    Button.MouseButton1Click:Connect(function() pcall(callback) end)
    return Button
end

function SkidzWare:CreateToggle(parent,text,callback)
    local Toggle = create("Frame",{Size=UDim2.new(1,-10,0,32), BackgroundColor3 = Color3.fromRGB(45,45,45), Parent=parent})
    create("UICorner",{CornerRadius=UDim.new(0,8), Parent=Toggle})
    create("UIStroke",{Color=Color3.fromRGB(80,80,80), Parent=Toggle})
    local Label = create("TextLabel", {Text=text, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1, Size=UDim2.new(1,-40,1,0), Parent=Toggle, TextXAlignment=Enum.TextXAlignment.Left})
    local Box = create("Frame", {Size=UDim2.new(0,24,0,24), Position=UDim2.new(1,-30,0.5,-12), BackgroundColor3=Color3.fromRGB(30,30,30), Parent=Toggle}, {create("UICorner",{CornerRadius=UDim.new(0,4)}), create("UIStroke",{Color=Color3.fromRGB(100,100,100)})})
    local State=false
    Box.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            State = not State
            Box.BackgroundColor3 = State and Color3.fromRGB(0,200,100) or Color3.fromRGB(30,30,30)
            callback(State)
        end
    end)
    return Toggle
end

function SkidzWare:CreateTextbox(parent,placeholder,callback)
    local BoxFrame = create("Frame",{Size = UDim2.new(1,-10,0,32), BackgroundColor3 = Color3.fromRGB(45,45,45), Parent = parent}, {create("UICorner",{CornerRadius=UDim.new(0,8)}), create("UIStroke",{Color=Color3.fromRGB(80,80,80)})})
    local Label = create("TextLabel", {Text = placeholder, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(0.6, -10, 1, 0), Position = UDim2.new(0,8,0,0), Parent = BoxFrame, TextXAlignment = Enum.TextXAlignment.Left})
    local TextBox = create("TextBox", {BackgroundColor3 = Color3.fromRGB(30,30,30), Size = UDim2.new(0.35, -8, 0.8, 0), Position = UDim2.new(0.65, 0, 0.1, 0), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), PlaceholderText = "Type...", BorderSizePixel = 0, Parent = BoxFrame}, {create("UICorner",{CornerRadius=UDim.new(0,6)})})
    TextBox.FocusLost:Connect(function(enter) if enter then callback(TextBox.Text) end end)
    return BoxFrame
end

function SkidzWare:CreateKeybind(parent,text,callback)
    local KeybindFrame = create("Frame",{Size=UDim2.new(1,-10,0,32), BackgroundColor3 = Color3.fromRGB(45,45,45), Parent=parent}, {create("UICorner",{CornerRadius=UDim.new(0,8)}), create("UIStroke",{Color=Color3.fromRGB(80,80,80)})})
    local Label = create("TextLabel",{Text = text.." [None]", Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1, Size=UDim2.new(1,-10,1,0), Parent=KeybindFrame, TextXAlignment=Enum.TextXAlignment.Left})
    local waiting = false
    KeybindFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            waiting = true
            Label.Text = text.." [Press key]"
        elseif waiting and input.UserInputType == Enum.UserInputType.Keyboard then
            Label.Text = text.." ["..input.KeyCode.Name.."]"
            callback(input.KeyCode)
            waiting = false
        end
    end)
    return KeybindFrame
end

-- SLIDER CREATION
function SkidzWare:CreateSlider(parent, text, min, max, callback)
    local SliderFrame = create("Frame", {
        Size = UDim2.new(1, -10, 0, 32),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Parent = parent
    }, {
        create("UICorner",{CornerRadius=UDim.new(0,8)}),
        create("UIStroke",{Color=Color3.fromRGB(80,80,80)})
    })

    local Label = create("TextLabel", {
        Text = text.." ["..min.."]",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-10,1,0),
        Position = UDim2.new(0,5,0,0),
        Parent = SliderFrame,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local BarBG = create("Frame", {
        Size = UDim2.new(1,-20,0,6),
        Position = UDim2.new(0,10,1,-10),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Parent = SliderFrame
    }, {create("UICorner",{CornerRadius=UDim.new(0,3)})})

    local Bar = create("Frame", {
        Size = UDim2.new(0,0,1,0),
        BackgroundColor3 = Color3.fromRGB(0,200,100),
        Parent = BarBG
    }, {create("UICorner",{CornerRadius=UDim.new(0,3)})})

    local dragging = false
    BarBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    BarBG.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X - BarBG.AbsolutePosition.X
            mousePos = math.clamp(mousePos, 0, BarBG.AbsoluteSize.X)
            Bar.Size = UDim2.new(mousePos/BarBG.AbsoluteSize.X, 0, 1, 0)
            local value = math.floor(min + (max - min) * (mousePos / BarBG.AbsoluteSize.X))
            Label.Text = text.." ["..value.."]"
            pcall(function() callback(value) end)
        end
    end)

    return SliderFrame
end

return SkidzWare
