local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("NNScript Ultimate game", "RJTheme3")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("ESP")

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer

-- Переменные для ESP
local espEnabled = false
local espConnections = {}
local espObjects = {}  -- Хранит все Drawing объекты для каждого игрока

-- Настройки ESP (можно потом вынести в UI)
local showName = true
local showDistance = true
local showHealth = true
local showBox = true
local showTracer = true
local teamCheck = true  -- Не показывать тиммейтов

-- Цвета ESP
local enemyColor = Color3.fromRGB(255, 0, 0)
local teamColor = Color3.fromRGB(0, 255, 0)

-- Функция создания ESP для одного игрока
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    if espObjects[targetPlayer] then return end

    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1

    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Transparency = 1

    local nameText = Drawing.new("Text")
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true

    local distanceText = Drawing.new("Text")
    distanceText.Size = 13
    distanceText.Center = true
    distanceText.Outline = true

    local healthText = Drawing.new("Text")
    healthText.Size = 13
    healthText.Center = true
    healthText.Outline = true

    espObjects[targetPlayer] = {
        Box = box,
        Tracer = tracer,
        Name = nameText,
        Distance = distanceText,
        Health = healthText,
        Character = nil,
        Humanoid = nil
    }
end

-- Удаление ESP игрока
local function removeESP(targetPlayer)
    if espObjects[targetPlayer] then
        for _, obj in pairs(espObjects[targetPlayer]) do
            if typeof(obj) == "Instance" and obj.Remove then
                obj:Remove()
            end
        end
        espObjects[targetPlayer] = nil
    end
end

-- Основная функция обновления ESP
local function updateESP()
    if not espEnabled then return end

    for targetPlayer, esp in pairs(espObjects) do
        local character = targetPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        if character and humanoid and rootPart and humanoid.Health > 0 then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos = character:FindFirstChild("Head")
            local headScreenPos = headPos and Camera:WorldToViewportPoint(headPos.Position + Vector3.new(0, 1, 0)) or rootPos
            local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3.5, 0))

            local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) and 
                (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude or 0

            local isTeamMate = teamCheck and targetPlayer.Team == player.Team

            local color = isTeamMate and teamColor or enemyColor

            -- Бокс
            if showBox and onScreen then
                local topY = headScreenPos.Y
                local bottomY = legPos.Y
                local sizeY = math.abs(topY - bottomY)
                local sizeX = sizeY * 0.7

                esp.Box.Size = Vector2.new(sizeX, sizeY)
                esp.Box.Position = Vector2.new(rootPos.X - sizeX/2, topY)
                esp.Box.Color = color
                esp.Box.Visible = true
            else
                esp.Box.Visible = false
            end

            -- Трейсер
            if showTracer and onScreen then
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                esp.Tracer.Color = color
                esp.Tracer.Visible = true
            else
                esp.Tracer.Visible = false
            end

            -- Имя
            if showName and onScreen then
                esp.Name.Text = targetPlayer.DisplayName or targetPlayer.Name
                esp.Name.Position = Vector2.new(rootPos.X, headScreenPos.Y - 25)
                esp.Name.Color = color
                esp.Name.Visible = true
            else
                esp.Name.Visible = false
            end

            -- Расстояние
            if showDistance and onScreen then
                esp.Distance.Text = math.floor(distance) .. "m"
                esp.Distance.Position = Vector2.new(rootPos.X, legPos.Y + 10)
                esp.Distance.Color = color
                esp.Distance.Visible = true
            else
                esp.Distance.Visible = false
            end

            -- Здоровье
            if showHealth and onScreen then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                esp.Health.Text = math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
                esp.Health.Position = Vector2.new(rootPos.X, legPos.Y - 10)
                esp.Health.Color = Color3.fromHSV(healthPercent > 0.5 and (1 - healthPercent) * 0.33 or 0.33, 1, 1)
                esp.Health.Visible = true
            else
                esp.Health.Visible = false
            end

        else
            -- Игрок мёртв или персонаж пропал
            for _, obj in pairs(esp) do
                if typeof(obj) == "Instance" then
                    obj.Visible = false
                end
            end
        end
    end
end

-- Включение/выключение ESP
local function toggleESP(state)
    espEnabled = state

    if state then
        -- Создаём ESP для всех текущих игроков
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end

        -- Подписываемся на обновление каждый кадр
        if not espConnections.update then
            espConnections.update = RunService.RenderStepped:Connect(updateESP)
        end

        -- Новые игроки
        if not espConnections.playerAdded then
            espConnections.playerAdded = Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Wait()
                task.wait(1)
                if espEnabled then
                    createESP(plr)
                end
            end)
        end

        -- Удаление при выходе
        if not espConnections.playerRemoving then
            espConnections.playerRemoving = Players.PlayerRemoving:Connect(removeESP)
        end

    else
        -- Выключаем всё
        for _, esp in pairs(espObjects) do
            for _, obj in pairs(esp) do
                if typeof(obj) == "Instance" then
                    obj.Visible = false
                    obj:Remove()
                end
            end
        end
        espObjects = {}

        for name, conn in pairs(espConnections) do
            if conn then
                conn:Disconnect()
                espConnections[name] = nil
            end
        end
    end
end

-- === ESP ТОГГЛЫ ===
Section:NewToggle("ESP Players", "Показывать игроков сквозь стены", function(state)
    toggleESP(state)
end)

Section:NewToggle("ESP Box", "Боксы вокруг игроков", function(state)
    showBox = state
end)

Section:NewToggle("ESP Tracer", "Линии от экрана к игрокам", function(state)
    showTracer = state
end)

Section:NewToggle("ESP Name", "Имена игроков", function(state)
    showName = state
end)

Section:NewToggle("ESP Distance", "Расстояние до игроков", function(state)
    showDistance = state
end)

Section:NewToggle("ESP Health", "Здоровье игроков", function(state)
    showHealth = state
end)

Section:NewToggle("ESP Team Check", "Не показывать тиммейтов", function(state)
    teamCheck = state
end)

local Section = Tab:NewSection("Cheats")

-- Переменные для бесконечных прыжков
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character
local humanoid
local isInfiniteJumpEnabled = false
local jumpConnection = nil

-- Переменные для полёта
local isFlying = false
local flySpeed = 100
local flyBodyVelocity
local flyBodyGyro
local flyConnection

-- Функция получения Humanoid
local function getHumanoid()
    if player.Character then
        character = player.Character
        humanoid = character:FindFirstChildOfClass("Humanoid")
        return humanoid
    end
    return nil
end

-- Обработчик бесконечных прыжков
local function handleInfiniteJumpInput(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Space and isInfiniteJumpEnabled then
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

-- Функция включения/выключения полёта
local function toggleFly(state)
    isFlying = state
    
    if not character or not humanoid then return end
    
    if isFlying then
        -- Создаём объекты для полёта
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9000
        flyBodyGyro.maxTorque = Vector3.new(9000, 9000, 9000)
        flyBodyGyro.CFrame = character.HumanoidRootPart.CFrame
        flyBodyGyro.Parent = character.HumanoidRootPart
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(90000, 90000, 90000)
        flyBodyVelocity.Parent = character.HumanoidRootPart
        
        humanoid.PlatformStand = true -- отключаем стандартную физику
        
        -- Управление полётом
        flyConnection = RunService.RenderStepped:Connect(function()
            if not isFlying or not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local moveDirection = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            flyBodyVelocity.Velocity = moveDirection * flySpeed
            flyBodyGyro.CFrame = camera.CFrame
        end)
        
    else
        -- Выключаем полёт
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
        
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- Обновление персонажа при респавне
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    
    -- Если полёт был включён — автоматически включаем его снова после респавна
    if isFlying then
        task.wait(0.5) -- небольшая задержка, чтобы всё прогрузилось
        toggleFly(true)
    end
end)

-- Инициализация при старте
getHumanoid()

-- === КНОПКИ И ТОГГЛЫ ===

Section:NewButton("ButtonText", "ButtonInfo", function()
    print("Clicked")
end)

Section:NewToggle("LongJump", "Очень высокий прыжок", function(state)
    if getHumanoid() then
        getHumanoid().JumpPower = state and 500 or 50
    end
end)

Section:NewToggle("InfiniteJump", "Бесконечные прыжки в воздухе", function(state)
    isInfiniteJumpEnabled = state
    if isInfiniteJumpEnabled then
        if not jumpConnection then
            jumpConnection = UserInputService.InputBegan:Connect(handleInfiniteJumpInput)
        end
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end)

-- ←←←← НОВАЯ КНОПКА ПОЛЁТА →→→→
Section:NewToggle("Fly", "Полёт (WASD + Space/Ctrl)", function(state)
    toggleFly(state)
end)

Section:NewSlider("Fly Speed", "Скорость полёта", 300, 16, function(value)
    flySpeed = value
end)

Section:NewSlider("Walkspeed", "Скорость ходьбы", 500, 16, function(s)
    if getHumanoid() then
        getHumanoid().WalkSpeed = s
    end
end)

Section:NewSlider("JumpPower", "Сила прыжка", 500, 30, function(s)
    if getHumanoid() then
        getHumanoid().JumpPower = s
    end
end)

Section:NewKeybind("LowGravity", "Низкая гравитация (F)", Enum.KeyCode.F, function()
    workspace.Gravity = 10
end)

Section:NewKeybind("NormalGravity", "Обычная гравитация (G)", Enum.KeyCode.G, function()
    workspace.Gravity = 196.2
end)
