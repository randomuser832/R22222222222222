-- SkidzWare UI Library (Full Version)
local SkidzWare = {}
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Creation Helper
local function create(class, props, children)
    local ok, obj = pcall(function()
        local instance = Instance.new(class)
        for k,v in pairs(props or {}) do instance[k] = v end
        for _,child in pairs(children or {}) do child.Parent = instance end
        return instance
    end)
    if not ok then warn("Failed to create "..class..": "..tostring(obj)) end
    return obj
end

-- LOADING SCREEN

    local ok, err = pcall(function()
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

        -- Player PFP
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

        -- Loading Text
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

        -- Loading Bar
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
    end)
    if not ok then warn("Loading screen failed: "..tostring(err)) end


-- MAIN SCREEN
local ok, err = pcall(function()
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




 -- DRAGGING LOGIC
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






    -- NOTIFICATIONS
    local NotificationsFrame = create("Frame", {
        Size = UDim2.new(0, 300, 0, 500),
        Position = UDim2.new(1, -310, 1, -510),
        BackgroundTransparency = 1,
        Parent = ScreenGui
    })

    function SkidzWare.Notify(text,duration)
        local ok, err = pcall(function()
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
        end)
        if not ok then warn("Notification failed: "..tostring(err)) end
    end

    -- TABS
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
    local ok, tab = pcall(function()
        local tabObj = {Name=name, Components={}}

        -- Scrollable frame inside tab
        local tabFrame = create("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarThickness = 6,
            Parent = TabContentFrame,
            Visible = (#Tabs == 0)
        })

        tabFrame.ClipsDescendants = true

        -- UIListLayout for vertical stacking
        local listLayout = create("UIListLayout", {Parent=tabFrame, Padding=UDim.new(0,8), FillDirection=Enum.FillDirection.Vertical})
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y + 10)
        end)

        tabObj.Frame = tabFrame

        -- Create the tab button
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
            for _, t in ipairs(Tabs) do
                t.Frame.Visible = false
            end
            tabObj.Frame.Visible = true
        end)

        tabObj.Button = btn
        table.insert(Tabs, tabObj)

        -- Reposition tab buttons
        for i,t in ipairs(Tabs) do
            t.Button.Position = UDim2.new(0,(i-1)*110,0,0)
        end

        -- Add element wrappers for this tab
        tabObj.CreateButton = function(text, callback)
            return SkidzWare.CreateButton(tabObj.Frame, text, callback)
        end
        tabObj.CreateToggle = function(text, callback)
            return SkidzWare.CreateToggle(tabObj.Frame, text, callback)
        end
        tabObj.CreateTextbox = function(placeholder, callback)
            return SkidzWare.CreateTextbox(tabObj.Frame, placeholder, callback)
        end
        tabObj.CreateSlider = function(text, min, max, callback)
            return SkidzWare.CreateSlider(tabObj.Frame, text, min, max, callback)
        end

        return tabObj
    end)
    if not ok then warn("CreateTab failed: "..tostring(tab)) end
    return tab
end



    -- FUNCTION WRAPPERS
    local function safeCall(funcName, func)
        return function(...)
            local ok, result = pcall(func,...)
            if not ok then warn(funcName.." failed: "..tostring(result)) end
            return result
        end
    end

    -- BUTTON
    SkidzWare.CreateButton = safeCall("CreateButton", function(parent,text,callback)
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
    end)

    -- TOGGLE
    SkidzWare.CreateToggle = safeCall("CreateToggle", function(parent,text,callback)
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
    end)

    -- TEXTBOX
 SkidzWare.CreateTextbox = safeCall("CreateTextbox", function(parent, placeholder, callback)
    if not parent then
        warn("CreateTextbox failed: parent is nil")
        return nil
    end

    local BoxFrame = create("Frame", {
        Size = UDim2.new(1, -10, 0, 28),
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        Parent = parent
    })

    if not BoxFrame then return nil end

    create("UICorner", {CornerRadius = UDim.new(0,6), Parent = BoxFrame})
    create("UIStroke", {Color = Color3.fromRGB(80,80,80), Parent = BoxFrame})

    local Label = create("TextLabel", {
        Text = placeholder or "",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, -6, 1, 0),
        Position = UDim2.new(0,6,0,0),
        Parent = BoxFrame,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Box = create("TextBox", {
        Size = UDim2.new(0.34, 0, 1, 0),
        Position = UDim2.new(0.66, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        TextColor3 = Color3.fromRGB(255,255,255),
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = BoxFrame
    })

    if Box then
        create("UICorner",{CornerRadius=UDim.new(0,4), Parent=Box})
        create("UIStroke",{Color=Color3.fromRGB(100,100,100), Parent=Box})

        Box.FocusLost:Connect(function(enter)
            if enter and typeof(callback) == "function" then
                pcall(callback, Box.Text)
            end
        end)
    end

    return BoxFrame
end)



    -- SLIDER
    SkidzWare.CreateSlider = safeCall("CreateSlider", function(parent,text,min,max,callback)
        local SliderFrame = create("Frame",{Size = UDim2.new(1,-10,0,32), BackgroundColor3 = Color3.fromRGB(45,45,45), Parent = parent}, {create("UICorner",{CornerRadius=UDim.new(0,8)}), create("UIStroke",{Color=Color3.fromRGB(80,80,80)})})
        local Label = create("TextLabel",{Text=text, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1, Size=UDim2.new(0.4,0,1,0), Parent=SliderFrame, TextXAlignment=Enum.TextXAlignment.Left})
        local BarBG = create("Frame",{Size=UDim2.new(0.55,0,0.3,0), Position=UDim2.new(0.45,0,0.35,0), BackgroundColor3=Color3.fromRGB(30,30,30), Parent=SliderFrame}, {create("UICorner",{CornerRadius=UDim.new(0,4)})})
        local Bar = create("Frame",{Size=UDim2.new(0,0,1,0), BackgroundColor3=Color3.fromRGB(0,200,100), Parent=BarBG}, {create("UICorner",{CornerRadius=UDim.new(0,4)})})
        local dragging=false
        local function update(input)
            local pos = math.clamp(input.Position.X - BarBG.AbsolutePosition.X,0,BarBG.AbsoluteSize.X)
            Bar.Size = UDim2.new(pos/BarBG.AbsoluteSize.X,0,1,0)
            local val = min + (pos/BarBG.AbsoluteSize.X)*(max-min)
            pcall(callback,val)
        end
        BarBG.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=true
                update(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then update(input) end
        end)
        BarBG.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
        end)
        return SliderFrame
    end)

end)
if not ok then warn("Main GUI failed: "..tostring(err)) end

return SkidzWare
