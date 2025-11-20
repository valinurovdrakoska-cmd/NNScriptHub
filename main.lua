-- NNScriptHub Premium | Один файл — ВСЁ РАБОТАЕТ НАВСЕГДА | 20.11.2025
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera

local premiumKey = "NNPREMIUM-XAI2025"

-- === KEYSYSTEM ===
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.ResetOnSpawn = false

local keyframe = Instance.new("Frame", sg)
keyframe.Size = UDim2.new(0,460,0,420)
keyframe.Position = UDim2.new(0.5,-230,0.5,-210)
keyframe.BackgroundColor3 = Color3.fromRGB(5,0,25)
keyframe.Active = true
keyframe.Draggable = true
Instance.new("UICorner",keyframe).CornerRadius = UDim.new(0,20)

local rgbStroke = Instance.new("UIStroke", keyframe)
rgbStroke.Thickness = 8
rgbStroke.Transparency = 0.3
spawn(function()
    while keyframe.Parent do
        for i = 0,1,0.002 do
            rgbStroke.Color = Color3.fromHSV(i,1,1)
            wait(0.005)
        end
    end
end)

local keytitle = Instance.new("TextLabel",keyframe)
keytitle.Size = UDim2.new(1,0,0.2,0)
keytitle.BackgroundTransparency = 1
keytitle.Text = "NNScriptHub Premium"
keytitle.Font = Enum.Font.GothamBlack
keytitle.TextSize = 38
spawn(function()
    while keytitle.Parent do
        for i = 0,1,0.002 do
            keytitle.TextColor3 = Color3.fromHSV(i,1,1)
            wait(0.005)
        end
    end
end)

local keytb = Instance.new("TextBox",keyframe)
keytb.Size = UDim2.new(0.84,0,0.13,0)
keytb.Position = UDim2.new(0.08,0,0.35,0)
keytb.PlaceholderText = "введи ключ"
keytb.BackgroundColor3 = Color3.fromRGB(20,0,40)
keytb.TextColor3 = Color3.new(1,1,1)
keytb.Font = Enum.Font.GothamBold
keytb.TextSize = 28
Instance.new("UICorner",keytb).CornerRadius = UDim.new(0,14)

local keyenter = Instance.new("TextButton",keyframe)
keyenter.Size = UDim2.new(0.84,0,0.18,0)
keyenter.Position = UDim2.new(0.08,0,0.68,0)
keyenter.Text = "АКТИВИРОВАТЬ PREMIUM"
keyenter.BackgroundColor3 = Color3.fromRGB(200,0,255)
keyenter.TextColor3 = Color3.new(1,1,1)
keyenter.Font = Enum.Font.GothamBlack
keyenter.TextSize = 36
keyenter.AutoButtonColor = false
Instance.new("UICorner",keyenter).CornerRadius = UDim.new(0,18)
local estroke = Instance.new("UIStroke",keyenter)
estroke.Thickness = 5
estroke.Color = Color3.fromRGB(255,100,255)
keyenter.MouseButton1Click:Connect(function()
    if keytb.Text == premiumKey then
        keyframe:Destroy()
        openHub()
    else
        game.StarterGui:SetCore("SendNotification",{Title="Ошибка",Text="Ключ не тот",Duration=5})
    end
end)

-- === ПЕРЕМЕННЫЕ ===
local flying = false
local flyBV = nil
local noclipOn = false
local espOn = false
local infJump = false
local vgod = false

local function noti666()
    game.StarterGui:SetCore("SendNotification",{Title="OMG!",Text="осуждаю но уважаю 😈",Duration=6})
end

-- === ФЛАЙ ===
local function startFly()
    if flying then return end
    flying = true
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBV.Velocity = Vector3.new(0,0,0)
    spawn(function()
        while flying do
            local move = Vector3.new(0,0,0)
            if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0,-1,0) end
            flyBV.Velocity = move * 120
            rs.Heartbeat:Wait()
        end
    end)
end

local function stopFly()
    flying = false
    if flyBV then flyBV:Destroy() end
end

-- === ESP ===
local function addESP(p)
    if p == plr then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255,0,50)
    box.Filled = false
    box.Transparency = 1

    local name = Drawing.new("Text")
    name.Size = 16
    name.Color = Color3.fromRGB(255,100,100)
    name.Center = true
    name.Outline = true

    rs.RenderStepped:Connect(function()
        if espOn and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local headPos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local size = Vector2.new(1000 / headPos.Z, 1600 / headPos.Z)
                box.Size = size
                box.Position = Vector2.new(headPos.X - size.X/2, headPos.Y - size.Y/2)
                box.Visible = true
                name.Text = p.Name
                name.Position = Vector2.new(headPos.X, headPos.Y - size.Y/2 - 20)
                name.Visible = true
            else
                box.Visible = false
                name.Visible = false
            end
        else
            box.Visible = false
            name.Visible = false
        end
    end)
end
for _,p in game.Players:GetPlayers() do if p ~= plr then addESP(p) end end
game.Players.PlayerAdded:Connect(addESP)

-- === ХАБ ===
function openHub()
    local hub = Instance.new("ScreenGui", game.CoreGui)
    hub.ResetOnSpawn = false

    local main = Instance.new("Frame", hub)
    main.Size = UDim2.new(0,460,0,680)
    main.Position = UDim2.new(0.5,-230,0.5,-340)
    main.BackgroundColor3 = Color3.fromRGB(8,0,25)
    main.BackgroundTransparency = 0.05
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner",main).CornerRadius = UDim.new(0,22)

    -- RGB рамка
    local rgb = Instance.new("UIStroke", main)
    rgb.Thickness = 9
    rgb.Transparency = 0.3
    spawn(function()
        while main.Parent do
            for i = 0,1,0.002 do
                rgb.Color = Color3.fromHSV(i,1,1)
                wait(0.005)
            end
        end
    end)

    -- Заголовок RGB
    local header = Instance.new("TextLabel", main)
    header.Size = UDim2.new(1,0,0,50)
    header.BackgroundTransparency = 1
    header.Text = "NNScriptHub Premium"
    header.Font = Enum.Font.GothamBlack
    header.TextSize = 38
    spawn(function()
        while header.Parent do
            for i = 0,1,0.002 do
                header.TextColor3 = Color3.fromHSV(i,1,1)
                wait(0.005)
            end
        end
    end)

    -- Крестик
    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0,40,0,40)
    close.Position = UDim2.new(1,-48,0,8)
    close.BackgroundColor3 = Color3.fromRGB(255,0,0)
    close.Text = "X"
    close.TextColor3 = Color3.new(1,1,1)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 30
    Instance.new("UICorner",close).CornerRadius = UDim.new(0,50)
    close.MouseButton1Click:Connect(function() hub:Destroy() end)

    -- Сворачивание + NN
    local min = Instance.new("TextButton", main)
    min.Size = UDim2.new(0,40,0,40)
    min.Position = UDim2.new(1,-92,0,8)
    min.BackgroundColor3 = Color3.fromRGB(200,0,0)
    min.Text = "−"
    min.TextColor3 = Color3.new(1,1,1)
    min.Font = Enum.Font.GothamBlack
    min.TextSize = 40
    Instance.new("UICorner",min).CornerRadius = UDim.new(0,50)

    local nn = Instance.new("TextButton", hub)
    nn.Size = UDim2.new(0,80,0,80)
    nn.Position = UDim2.new(0,20,1,-100)
    nn.BackgroundColor3 = Color3.fromRGB(255,0,100)
    nn.Text = "NN"
    nn.TextColor3 = Color3.new(1,1,1)
    nn.Font = Enum.Font.GothamBlack
    nn.TextSize = 36
    nn.Visible = false
    nn.Active = true
    nn.Draggable = true
    Instance.new("UICorner",nn).CornerRadius = UDim.new(0,50)
    nn.MouseButton1Click:Connect(function() nn.Visible = false main.Visible = true end)
    min.MouseButton1Click:Connect(function() main.Visible = false nn.Visible = true end)

    local y = 0.08

    -- Fly
    local flyBtn = Instance.new("TextButton", main)
    flyBtn.Size = UDim2.new(0.86,0,0.08,0)
    flyBtn.Position = UDim2.new(0.07,0,y,0)
    flyBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    flyBtn.Text = "Fly OFF"
    flyBtn.TextColor3 = Color3.new(1,1,1)
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 30
    Instance.new("UICorner",flyBtn).CornerRadius = UDim.new(0,12)
    flyBtn.MouseButton1Click:Connect(function()
        if flying then stopFly() flyBtn.Text = "Fly OFF" flyBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        else startFly() flyBtn.Text = "Fly ON" flyBtn.BackgroundColor3 = Color3.fromRGB(0,200,0) end
    end)
    y = y + 0.09

    -- ESP
    local espBtn = Instance.new("TextButton", main)
    espBtn.Size = UDim2.new(0.86,0,0.08,0)
    espBtn.Position = UDim2.new(0.07,0,y,0)
    espBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    espBtn.Text = "ESP OFF"
    espBtn.TextColor3 = Color3.new(1,1,1)
    espBtn.Font = Enum.Font.GothamBold
    espBtn.TextSize = 30
    Instance.new("UICorner",espBtn).CornerRadius = UDim.new(0,12)
    espBtn.MouseButton1Click:Connect(function()
        espOn = not espOn
        espBtn.Text = espOn and "ESP ON" or "ESP OFF"
        espBtn.BackgroundColor3 = espOn and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    y = y + 0.09

    -- WalkSpeed
    local ws = Instance.new("TextBox", main)
    ws.Size = UDim2.new(0.86,0,0.08,0)
    ws.Position = UDim2.new(0.07,0,y,0)
    ws.PlaceholderText = "WalkSpeed"
    ws.BackgroundColor3 = Color3.fromRGB(40,0,40)
    ws.TextColor3 = Color3.new(1,1,1)
    ws.TextSize = 26
    Instance.new("UICorner",ws).CornerRadius = UDim.new(0,12)
    ws.FocusLost:Connect(function()
        local n = tonumber(ws.Text)
        if n and plr.Character then
            plr.Character.Humanoid.WalkSpeed = n
            if n == 666 then noti666() end
        end
    end)
    y = y + 0.09

    -- JumpPower
    local jp = Instance.new("TextBox", main)
    jp.Size = UDim2.new(0.86,0,0.08,0)
    jp.Position = UDim2.new(0.07,0,y,0)
    jp.PlaceholderText = "JumpPower"
    jp.BackgroundColor3 = Color3.fromRGB(40,0,40)
    jp.TextColor3 = Color3.new(1,1,1)
    jp.TextSize = 26
    Instance.new("UICorner",jp).CornerRadius = UDim.new(0,12)
    jp.FocusLost:Connect(function()
        local n = tonumber(jp.Text)
        if n and plr.Character then
            plr.Character.Humanoid.JumpPower = n
            if n == 666 then noti666() end
        end
    end)
    y = y + 0.09

    -- Noclip
    local ncBtn = Instance.new("TextButton", main)
    ncBtn.Size = UDim2.new(0.86,0,0.08,0)
    ncBtn.Position = UDim2.new(0.07,0,y,0)
    ncBtn.Text = "Noclip OFF"
    ncBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    ncBtn.TextColor3 = Color3.new(1,1,1)
    ncBtn.Font = Enum.Font.GothamBold
    ncBtn.TextSize = 30
    Instance.new("UICorner",ncBtn).CornerRadius = UDim.new(0,12)
    ncBtn.MouseButton1Click:Connect(function()
        noclipOn = not noclipOn
        ncBtn.Text = noclipOn and "Noclip ON" or "Noclip OFF"
        ncBtn.BackgroundColor3 = noclipOn and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    rs.Stepped:Connect(function()
        if noclipOn and plr.Character then
            for _,v in plr.Character:GetDescendants() do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    y = y + 0.09

    -- Infinite Jump
    local infBtn = Instance.new("TextButton", main)
    infBtn.Size = UDim2.new(0.86,0,0.08,0)
    infBtn.Position = UDim2.new(0.07,0,y,0)
    infBtn.Text = "Infinite Jump OFF"
    infBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    infBtn.TextColor3 = Color3.new(1,1,1)
    infBtn.Font = Enum.Font.GothamBold
    infBtn.TextSize = 30
    Instance.new("UICorner",infBtn).CornerRadius = UDim.new(0,12)
    infBtn.MouseButton1Click:Connect(function()
        infJump = not infJump
        infBtn.Text = infJump and "Infinite Jump ON" or "Infinite Jump OFF"
        infBtn.BackgroundColor3 = infJump and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
    uis.InputBegan:Connect(function(inp)
        if infJump and inp.KeyCode == Enum.KeyCode.Space then
            plr.Character.Humanoid:ChangeState("Jumping")
        end
    end)
    y = y + 0.09

    -- Gravity
    local grav = Instance.new("TextBox", main)
    grav.Size = UDim2.new(0.86,0,0.08,0)
    grav.Position = UDim2.new(0.07,0,y,0)
    grav.PlaceholderText = "Gravity (192)"
    grav.BackgroundColor3 = Color3.fromRGB(40,0,40)
    grav.TextColor3 = Color3.new(1,1,1)
    grav.TextSize = 26
    Instance.new("UICorner",grav).CornerRadius = UDim.new(0,12)
    grav.FocusLost:Connect(function()
        local n = tonumber(grav.Text)
        if n then workspace.Gravity = n end
    end)
    y = y + 0.09

    -- Visual GodMode
    local vgodBtn = Instance.new("TextButton", main)
    vgodBtn.Size = UDim2.new(0.86,0,0.08,0)
    vgodBtn.Position = UDim2.new(0.07,0,y,0)
    vgodBtn.Text = "Visual GodMode OFF"
    vgodBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    vgodBtn.TextColor3 = Color3.new(1,1,1)
    vgodBtn.Font = Enum.Font.GothamBold
    vgodBtn.TextSize = 30
    Instance.new("UICorner",vgodBtn).CornerRadius = UDim.new(0,12)
    vgodBtn.MouseButton1Click:Connect(function()
        vgod = not vgod
        vgodBtn.Text = vgod and "Visual GodMode ON" or "Visual GodMode OFF"
        vgodBtn.BackgroundColor3 = vgod and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        if vgod then
            spawn(function()
                while vgod do
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        plr.Character.Humanoid.Health = 100
                    end
                    wait()
                end
            end)
        end
    end)
    y = y + 0.09

    -- Instant Respawn
    local resp = Instance.new("TextButton", main)
    resp.Size = UDim2.new(0.86,0,0.08,0)
    resp.Position = UDim2.new(0.07,0,y,0)
    resp.Text = "Instant Respawn"
    resp.BackgroundColor3 = Color3.fromRGB(200,0,100)
    resp.TextColor3 = Color3.new(1,1,1)
    resp.Font = Enum.Font.GothamBold
    resp.TextSize = 30
    Instance.new("UICorner",resp).CornerRadius = UDim.new(0,12)
    resp.MouseButton1Click:Connect(function()
        if plr.Character then plr.Character.Humanoid.Health = 0 end
    end)
    y = y + 0.09

    -- Infinite Yield
    local iy = Instance.new("TextButton", main)
    iy.Size = UDim2.new(0.86,0,0.08,0)
    iy.Position = UDim2.new(0.07,0,y,0)
    iy.Text = "Infinite Yield"
    iy.BackgroundColor3 = Color3.fromRGB(255,100,0)
    iy.TextColor3 = Color3.new(1,1,1)
    iy.Font = Enum.Font.GothamBlack
    iy.TextSize = 32
    Instance.new("UICorner",iy).CornerRadius = UDim.new(0,14)
    iy.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    y = y + 0.09

    -- Сброс
    local reset = Instance.new("TextButton", main)
    reset.Size = UDim2.new(0.86,0,0.08,0)
    reset.Position = UDim2.new(0.07,0,y,0)
    reset.Text = "СБРОС НА ДЕФОЛТ"
    reset.BackgroundColor3 = Color3.fromRGB(150,0,0)
    reset.TextColor3 = Color3.new(1,1,1)
    reset.Font = Enum.Font.GothamBold
    reset.TextSize = 28
    Instance.new("UICorner",reset).CornerRadius = UDim.new(0,12)
    reset.MouseButton1Click:Connect(function()
        stopFly()
        if plr.Character then
            plr.Character.Humanoid.WalkSpeed = 16
            plr.Character.Humanoid.JumpPower = 50
, workspace.Gravity = 192
        end
        noclipOn = false
        infJump = false
        vgod = false
        espOn = false
        flyBtn.Text = "Fly OFF" flyBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        espBtn.Text = "ESP OFF" espBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        ncBtn.Text = "Noclip OFF" ncBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        infBtn.Text = "Infinite Jump OFF" infBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        vgodBtn.Text = "Visual GodMode OFF" vgodBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        ws.Text = ""
        jp.Text = ""
        grav.Text = ""
    end)
end
