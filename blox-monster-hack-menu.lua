-- Blox Monster Hack Menu
-- Sử dụng MCP và các công cụ có sẵn

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Tạo GUI menu
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxMonsterHackMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0, 20, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 100, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Title.BackgroundTransparency = 0.3
Title.Text = "Blox Monster Hack Menu v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

local DragFrame = Instance.new("Frame")
DragFrame.Name = "DragFrame"
DragFrame.Size = UDim2.new(1, 0, 0, 40)
DragFrame.Position = UDim2.new(0, 0, 0, 0)
DragFrame.BackgroundTransparency = 1
DragFrame.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

-- Biến toàn cục
local EspEnabled = false
local EspConnections = {}
local EspBillboards = {}
local AutoFarmEnabled = false
local AutoFarmConnection = nil
local AutoSellEnabled = false
local AutoRankUpEnabled = false
local AutoHatchEnabled = false
local AntiAfkEnabled = false
local AutoRejoinEnabled = false
local AutoRejoinTimer = nil

-- Biến theo dõi thời tiết
local CurrentWeather = "Clear"
local WeatherBossMapping = {
    Fog = "Neo",
    Thunder = "Kylin", 
    Windy = "Sword Barry"
}

-- Tạo các phần GUI
local function createSection(title)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    section.BackgroundTransparency = 0.5
    section.BorderSizePixel = 0
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 5)
    sectionCorner.Parent = section
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, -20, 1, 0)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    sectionTitle.TextSize = 16
    sectionTitle.Font = Enum.Font.Gotham
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section
    
    return section
end

local function createToggle(name, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = toggleButton
    
    toggleButton.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
        toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
        toggleButton.Text = defaultValue and "ON" or "OFF"
        if callback then
            callback(defaultValue)
        end
    end)
    
    return toggleFrame
end

local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Tạo các phần menu
local autoFarmSection = createSection("Auto Farm")
autoFarmSection.Parent = ScrollingFrame

local espSection = createSection("ESP & Display")
espSection.Parent = ScrollingFrame

local autoFeaturesSection = createSection("Auto Features")
autoFeaturesSection.Parent = ScrollingFrame

local miscSection = createSection("Miscellaneous")
miscSection.Parent = ScrollingFrame

-- Auto Farm
local autoFarmToggle = createToggle("Auto Farm", AutoFarmEnabled, function(value)
    AutoFarmEnabled = value
    if AutoFarmEnabled then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)
autoFarmToggle.Parent = autoFarmSection

local autoFarmType = Instance.new("TextLabel")
autoFarmType.Name = "FarmType"
autoFarmType.Size = UDim2.new(1, -20, 0, 20)
autoFarmType.Position = UDim2.new(0, 10, 1, 5)
autoFarmType.BackgroundTransparency = 1
autoFarmType.Text = "Target: Normal Monsters"
autoFarmType.TextColor3 = Color3.fromRGB(180, 180, 255)
autoFarmType.TextSize = 12
autoFarmType.Font = Enum.Font.Gotham
autoFarmType.Parent = autoFarmSection
autoFarmSection.Size = UDim2.new(1, 0, 0, 80)

-- ESP
local espToggle = createToggle("ESP (Billboard)", EspEnabled, function(value)
    EspEnabled = value
    if EspEnabled then
        startESP()
    else
        stopESP()
    end
end)
espToggle.Parent = espSection

local espColorsInfo = Instance.new("TextLabel")
espColorsInfo.Name = "ColorsInfo"
espColorsInfo.Size = UDim2.new(1, -20, 0, 40)
espColorsInfo.Position = UDim2.new(0, 10, 1, 5)
espColorsInfo.BackgroundTransparency = 1
espColorsInfo.Text = "Red: Normal\nYellow: Hidden\nPurple: Boss"
espColorsInfo.TextColor3 = Color3.fromRGB(180, 180, 255)
espColorsInfo.TextSize = 12
espColorsInfo.Font = Enum.Font.Gotham
espColorsInfo.TextXAlignment = Enum.TextXAlignment.Left
espColorsInfo.TextYAlignment = Enum.TextYAlignment.Top
espColorsInfo.Parent = espSection
espSection.Size = UDim2.new(1, 0, 0, 100)

-- Auto Features
local autoSellToggle = createToggle("Auto Sell Pets", AutoSellEnabled, function(value)
    AutoSellEnabled = value
    if AutoSellEnabled then
        startAutoSell()
    else
        stopAutoSell()
    end
end)
autoSellToggle.Parent = autoFeaturesSection

local autoRankUpToggle = createToggle("Auto Rank Up", AutoRankUpEnabled, function(value)
    AutoRankUpEnabled = value
    if AutoRankUpEnabled then
        startAutoRankUp()
    else
        stopAutoRankUp()
    end
end)
autoRankUpToggle.Parent = autoFeaturesSection

local autoHatchToggle = createToggle("Auto Hatch Eggs", AutoHatchEnabled, function(value)
    AutoHatchEnabled = value
    if AutoHatchEnabled then
        startAutoHatch()
    else
        stopAutoHatch()
    end
end)
autoHatchToggle.Parent = autoFeaturesSection

autoFeaturesSection.Size = UDim2.new(1, 0, 0, 120)

-- Miscellaneous
local antiAfkToggle = createToggle("Anti AFK", AntiAfkEnabled, function(value)
    AntiAfkEnabled = value
    if AntiAfkEnabled then
        startAntiAfk()
    else
        stopAntiAfk()
    end
end)
antiAfkToggle.Parent = miscSection

local autoRejoinToggle = createToggle("Auto Rejoin (10 min)", AutoRejoinEnabled, function(value)
    AutoRejoinEnabled = value
    if AutoRejoinEnabled then
        startAutoRejoin()
    else
        stopAutoRejoin()
    end
end)
autoRejoinToggle.Parent = miscSection

local checkWeatherButton = createButton("Check Current Weather", function()
    checkCurrentWeather()
end)
checkWeatherButton.Parent = miscSection

local teleportBossButton = createButton("Teleport to Weather Boss", function()
    teleportToWeatherBoss()
end)
teleportBossButton.Parent = miscSection

miscSection.Size = UDim2.new(1, 0, 0, 180)

-- Kéo thả GUI
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DragFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Các hàm chức năng
local function getWeatherController()
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage").GameAnalytics.GameAnalytics
    end)
    
    if success then
        return result
    end
    
    -- Thử tìm controller thời tiết khác
    success, result = pcall(function()
        return require(game:GetService("ReplicatedStorage").Helpers.WeatherHelper)
    end)
    
    return success and result or nil
end

function checkCurrentWeather()
    local weatherController = getWeatherController()
    if weatherController then
        local workspace = game:GetService("Workspace")
        local weatherId = workspace:GetAttribute("CurrentWeatherId")
        
        if weatherId then
            local weatherName = "Unknown"
            if weatherId == 1 then weatherName = "Clear"
            elseif weatherId == 2 then weatherName = "Rain"
            elseif weatherId == 3 then weatherName = "Storm"
            elseif weatherId == 4 then weatherName = "Fog"
            elseif weatherId == 5 then weatherName = "Snow"
            elseif weatherId == 6 then weatherName = "Strong Wind"
            end
            
            CurrentWeather = weatherName
            autoFarmType.Text = "Weather: " .. weatherName
            
            if WeatherBossMapping[weatherName] then
                autoFarmType.Text = autoFarmType.Text .. " | Boss: " .. WeatherBossMapping[weatherName]
            end
        else
            CurrentWeather = "Clear"
            autoFarmType.Text = "Weather: Clear"
        end
    else
        autoFarmType.Text = "Weather: Unknown (Controller not found)"
    end
end

function getPetInvController()
    local success, result = pcall(function()
        return require(game:GetService("ReplicatedStorage").ClientModules.Controllers.AfterLoad.PetInvController)
    end)
    
    return success and result or nil
end

function getHatcherController()
    local success, result = pcall(function()
        return require(game:GetService("ReplicatedStorage").ClientModules.Controllers.AfterLoad.HatcherController)
    end)
    
    return success and result or nil
end

function startAutoFarm()
    if AutoFarmConnection then
        AutoFarmConnection:Disconnect()
    end
    
    AutoFarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
        -- Tự động tấn công quái vật gần nhất
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Tìm quái vật gần nhất
        local closestMonster = nil
        local closestDistance = math.huge
        
        -- Tìm trong workspace.Live.Monsters hoặc workspace.Live
        local liveFolder = Workspace:FindFirstChild("Live")
        if liveFolder then
            local monstersFolder = liveFolder:FindFirstChild("Monsters")
            local targetFolder = monstersFolder or liveFolder
            
            for _, monster in pairs(targetFolder:GetChildren()) do
                if monster:IsA("Model") and monster:FindFirstChild("HumanoidRootPart") then
                    local monsterRoot = monster.HumanoidRootPart
                    local distance = (humanoidRootPart.Position - monsterRoot.Position).Magnitude
                    
                    if distance < closestDistance and distance < 50 then
                        closestDistance = distance
                        closestMonster = monster
                    end
                end
            end
        end
        
        -- Tự động tấn công
        if closestMonster then
            -- Di chuyển đến quái vật
            character:SetPrimaryPartCFrame(CFrame.new(closestMonster.HumanoidRootPart.Position + Vector3.new(0, 0, 5)))
            
            -- Sử dụng remote event để tấn công (nếu có)
            local attackRemote = ReplicatedStorage:FindFirstChild("AttackRemote")
            if attackRemote then
                attackRemote:FireServer(closestMonster)
            end
        end
    end)
end

function stopAutoFarm()
    if AutoFarmConnection then
        AutoFarmConnection:Disconnect()
        AutoFarmConnection = nil
    end
end

function startESP()
    stopESP()
    
    local function updateESP()
        local liveFolder = Workspace:FindFirstChild("Live")
        if not liveFolder then return end
        
        -- Xóa billboard cũ
        for _, billboard in pairs(EspBillboards) do
            billboard:Destroy()
        end
        EspBillboards = {}
        
        -- Thêm ESP cho monsters
        local monstersFolder = liveFolder:FindFirstChild("Monsters")
        if monstersFolder then
            for _, monster in pairs(monstersFolder:GetChildren()) do
                if monster:IsA("Model") and monster:FindFirstChild("HumanoidRootPart") then
                    createMonsterBillboard(monster)
                end
            end
        end
        
        -- Thêm ESP cho bosses (nếu có folder riêng)
        local bossesFolder = liveFolder:FindFirstChild("Bosses") or monstersFolder
        if bossesFolder then
            for _, boss in pairs(bossesFolder:GetChildren()) do
                if boss:IsA("Model") and boss:FindFirstChild("HumanoidRootPart") then
                    if string.find(string.lower(boss.Name), "boss") or string.find(string.lower(boss.Name), "neo") or 
                       string.find(string.lower(boss.Name), "kylin") or string.find(string.lower(boss.Name), "sword") then
                        createBossBillboard(boss)
                    end
                end
            end
        end
    end
    
    EspConnections.heartbeat = game:GetService("RunService").Heartbeat:Connect(updateESP)
    
    -- Cập nhật ngay lập tức
    updateESP()
end

function stopESP()
    for _, connection in pairs(EspConnections) do
        connection:Disconnect()
    end
    EspConnections = {}
    
    for _, billboard in pairs(EspBillboards) do
        billboard:Destroy()
    end
    EspBillboards = {}
end

function createMonsterBillboard(monster)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local monsterRoot = monster:FindFirstChild("HumanoidRootPart")
    if not monsterRoot then return end
    
    -- Kiểm tra xem đã có billboard chưa
    for _, existing in pairs(EspBillboards) do
        if existing.Adornee == monsterRoot then
            return
        end
    end
    
    local distance = (character.HumanoidRootPart.Position - monsterRoot.Position).Magnitude
    
    -- Tạo billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Adornee = monsterRoot
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.Parent = monsterRoot
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = monster.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red cho quái thường
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = string.format("%.1f studs", distance)
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = frame
    
    table.insert(EspBillboards, billboard)
end

function createBossBillboard(boss)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local bossRoot = boss:FindFirstChild("HumanoidRootPart")
    if not bossRoot then return end
    
    -- Kiểm tra xem đã có billboard chưa
    for _, existing in pairs(EspBillboards) do
        if existing.Adornee == bossRoot then
            return
        end
    end
    
    local distance = (character.HumanoidRootPart.Position - bossRoot.Position).Magnitude
    
    -- Tạo billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BossESPBillboard"
    billboard.Adornee = bossRoot
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.Parent = bossRoot
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "BOSS: " .. boss.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 100, 255) -- Purple cho boss
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = string.format("%.1f studs", distance)
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 14
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = frame
    
    table.insert(EspBillboards, billboard)
end

function startAutoSell()
    local petInvController = getPetInvController()
    if not petInvController then
        autoFarmType.Text = "PetInvController not found"
        return
    end
    
    -- Sử dụng chức năng bán tự động của game
    local function autoSellPets()
        -- Kiểm tra và bán thú cưng thông qua PetInvController
        if petInvController.EnterDeleteMode then
            petInvController:EnterDeleteMode()
            
            -- Chọn tất cả thú cưng có rank thấp để bán
            -- (Cần điều chỉnh theo logic cụ thể của game)
            
            -- Giả sử có function để xác nhận bán
            if petInvController.ConfirmDelete then
                petInvController:ConfirmDelete()
            end
        end
    end
    
    EspConnections.autoSell = game:GetService("RunService").Heartbeat:Connect(function()
        -- Bán mỗi 30 giây
        if tick() % 30 < 0.1 then
            autoSellPets()
        end
    end)
end

function stopAutoSell()
    if EspConnections.autoSell then
        EspConnections.autoSell:Disconnect()
        EspConnections.autoSell = nil
    end
end

function startAutoRankUp()
    -- Tự động nâng cấp rank thú cưng
    EspConnections.autoRankUp = game:GetService("RunService").Heartbeat:Connect(function()
        -- Nâng cấp mỗi 60 giây
        if tick() % 60 < 0.1 then
            -- Tìm thú cưng có thể nâng cấp
            local petInvController = getPetInvController()
            if petInvController and petInvController.PerformRankUp then
                -- Cần có logic để xác định thú cưng nào có thể nâng cấp
                -- petInvController:PerformRankUp(petUid)
            end
        end
    end)
end

function stopAutoRankUp()
    if EspConnections.autoRankUp then
        EspConnections.autoRankUp:Disconnect()
        EspConnections.autoRankUp = nil
    end
end

function startAutoHatch()
    local hatcherController = getHatcherController()
    if not hatcherController then
        autoFarmType.Text = "HatcherController not found"
        return
    end
    
    -- Tự động ấp trứng
    EspConnections.autoHatch = game:GetService("RunService").Heartbeat:Connect(function()
        -- Ấp trứng mỗi 120 giây (nếu có trứng)
        if tick() % 120 < 0.1 then
            -- Sử dụng HatcherController để ấp trứng
            if hatcherController.HatchEgg then
                -- Cần xác định eggId cụ thể
                -- hatcherController:HatchEgg(eggId)
            end
        end
    end)
end

function stopAutoHatch()
    if EspConnections.autoHatch then
        EspConnections.autoHatch:Disconnect()
        EspConnections.autoHatch = nil
    end
end

function startAntiAfk()
    EspConnections.antiAfk = game:GetService("RunService").Heartbeat:Connect(function()
        -- Click button mỗi 30 giây để chống AFK
        if tick() % 30 < 0.1 then
            VirtualUser:ClickButton2(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end
    end)
end

function stopAntiAfk()
    if EspConnections.antiAfk then
        EspConnections.antiAfk:Disconnect()
        EspConnections.antiAfk = nil
    end
end

function startAutoRejoin()
    stopAutoRejoin()
    
    local rejoinTime = 600 -- 10 phút
    
    AutoRejoinTimer = game:GetService("RunService").Heartbeat:Connect(function()
        -- Kiểm tra mỗi giây
        if tick() % 1 < 0.1 then
            -- Kiểm tra nếu player đã AFK quá lâu
            if tick() % rejoinTime < 0.1 then
                -- Tự động rejoin game
                local TeleportService = game:GetService("TeleportService")
                local placeId = game.PlaceId
                
                pcall(function()
                    TeleportService:Teleport(placeId, LocalPlayer)
                end)
            end
        end
    end)
end

function stopAutoRejoin()
    if AutoRejoinTimer then
        AutoRejoinTimer:Disconnect()
        AutoRejoinTimer = nil
    end
end

function teleportToWeatherBoss()
    local targetBoss = WeatherBossMapping[CurrentWeather]
    if not targetBoss then
        autoFarmType.Text = "No boss for current weather"
        return
    end
    
    -- Tìm boss trên map
    local liveFolder = Workspace:FindFirstChild("Live")
    if not liveFolder then return end
    
    local bossesFolder = liveFolder:FindFirstChild("Bosses") or liveFolder:FindFirstChild("Monsters")
    if not bossesFolder then return end
    
    local boss = nil
    for _, monster in pairs(bossesFolder:GetChildren()) do
        if monster:IsA("Model") and string.find(string.lower(monster.Name), string.lower(targetBoss)) then
            boss = monster
            break
        end
    end
    
    if boss and boss:FindFirstChild("HumanoidRootPart") then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:SetPrimaryPartCFrame(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 5, 0)))
            autoFarmType.Text = "Teleported to " .. targetBoss
        end
    else
        autoFarmType.Text = "Boss " .. targetBoss .. " not found"
    end
end

-- Khởi tạo
checkCurrentWeather()

-- Thông báo
autoFarmType.Text = "Hack Menu Loaded! Check Weather for boss info"

print("Blox Monster Hack Menu loaded!")
print("Press button on top right to toggle menu")