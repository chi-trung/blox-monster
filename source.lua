--[[
    GnurtHub x Blox Monster
    source.lua — main script logic
    Load via: loadstring(game:HttpGet("https://raw.githubusercontent.com/chi-trung/blox-monster/main/source.lua"))()
]]

if GnurtHub and GnurtHub.Unload then
    GnurtHub.Unload()
end

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

--// Knit / Controllers
local Knit = require(ReplicatedStorage.Packages.Knit)

local Controllers = {
    AutoCatch = nil, Mob = nil, Egg = nil, EggOpen = nil, Ball = nil,
    PetInv = nil, Tower = nil, Dungeon = nil, Data = nil, Skill = nil,
}

for name, _ in pairs(Controllers) do
    local ok, ctrl = pcall(function()
        return Knit.GetController(name)
    end)
    if ok and ctrl then
        Controllers[name] = ctrl
    end
end

--// Helpers
local MobHelper  = require(ReplicatedStorage.Helpers.MobHelper)
local BallHelper = require(ReplicatedStorage.Helpers.BallHelper)
local EggHelper  = require(ReplicatedStorage.Helpers.EggHelper)

--// State
local State = {
    AutoCatch      = false,
    AutoHatch      = false,
    AutoBestBall   = false,
    SelectedArea   = nil,
    SelectedEgg    = nil,
    HatchAmount    = 1,
    TeleportLoop   = false,
}

--// ============================================================
--// UI  (GnurtHub-style minimal)
--// ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnurtHub_BloxMonster"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 80, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -16, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "GnurtHub  •  Blox Monster"
TitleLabel.TextColor3 = Color3.fromRGB(235, 235, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Close button (hide GUI)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -60, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -32, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- container for toggles
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, -16, 1, -44)
Body.Position = UDim2.new(0, 8, 0, 36)
Body.BackgroundTransparency = 1
Body.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Body

local function AddToggle(labelText, order, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(32, 32, 46)
    row.LayoutOrder = order
    row.Parent = Body
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -48, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            btn.Text = "ON"
            btn.TextColor3 = Color3.fromRGB(100, 255, 140)
            btn.BackgroundColor3 = Color3.fromRGB(40, 90, 60)
        else
            btn.Text = "OFF"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        if callback then callback(toggled) end
    end)

    return row
end

--// ============================================================
--// Feature logic
--// ============================================================

-- Auto Catch: hook into AutoCatchController or simulate click on native button
local function getAutoCatchButton()
    local hud = PlayerGui:FindFirstChild("HUD")
    if not hud then return nil end
    local right = hud:FindFirstChild("Right")
    if not right then return nil end
    local panel = right:FindFirstChild("AutoPanel")
    if not panel then return nil end
    local btn = panel:FindFirstChild("Button")
    if not btn then return nil end
    local auto = btn:FindFirstChild("Auto")
    if not auto then return nil end
    return auto:FindFirstChild("Catch")
end

task.spawn(function()
    while true do
        if State.AutoCatch then
            local btn = getAutoCatchButton()
            if btn and (btn:IsA("ImageButton") or btn:IsA("TextButton")) then
                pcall(function()
                    btn:Activate()
                end)
            end
        end
        task.wait(0.25)
    end
end)

-- Auto Hatch: loop AccelerateHatch on HatcherController
task.spawn(function()
    while true do
        if State.AutoHatch and Controllers.AutoCatch then
            pcall(function()
                Controllers.AutoCatch:AccelerateHatch(State.SelectedEgg or nil, State.HatchAmount or 1)
            end)
        end
        task.wait(0.4)
    end
end)

-- Auto Best Ball: pick highest catch multiplier ball from inventory
task.spawn(function()
    while true do
        if State.AutoBestBall and Controllers.Ball then
            pcall(function()
                local bestName, bestMult = nil, -math.huge
                for _, ball in pairs(BallHelper.GetAll and BallHelper.GetAll() or {}) do
                    local mult = ball.CatchChance or 1
                    if mult > bestMult then
                        bestMult = mult
                        bestName = ball.Name
                    end
                end
                if bestName then
                    Controllers.Ball:Equip(bestName)
                end
            end)
        end
        task.wait(1.5)
    end
end)

-- Teleport to area mobs
task.spawn(function()
    while true do
        if State.TeleportLoop and State.SelectedArea then
            pcall(function()
                local live = Workspace:FindFirstChild("Live")
                if live then
                    for _, mob in pairs(live:GetDescendants()) do
                        if mob:IsA("Model") and mob:GetAttribute("Area") == State.SelectedArea then
                            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
                            if hrp and mobRoot then
                                hrp.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 4)
                                return
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.6)
    end
end)

--// ============================================================
--// Build menu
--// ============================================================
AddToggle("Auto Catch", 1, function(v) State.AutoCatch = v end)
AddToggle("Auto Hatch", 2, function(v) State.AutoHatch = v end)
AddToggle("Auto Best Ball", 3, function(v) State.AutoBestBall = v end)
AddToggle("Teleport to Area Mobs", 4, function(v) State.TeleportLoop = v end)

-- area selector
local areaRow = AddToggle("Area: None", 5, function() end)
areaRow.LayoutOrder = 5
-- cycle areas on click
local areas = {"Area1","Area2","Area3","Area4","Area5","Area6","Area7","Area8"}
local areaIdx = 1
areaRow:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
    areaIdx = (areaIdx % #areas) + 1
    State.SelectedArea = areas[areaIdx]
    areaRow:FindFirstChildOfClass("TextLabel").Text = "Area: " .. State.SelectedArea
end)

--// ============================================================
--// Keybind + Unload
--// ============================================================
local ToggleConnection = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift and MainFrame then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Close button: hide GUI (can reopen with RightShift)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Minimize button: collapse body
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Body.Visible = not minimized
    MainFrame.Size = minimized
        and UDim2.new(0, 420, 0, 32)
        or UDim2.new(0, 420, 0, 320)
    MinBtn.Text = minimized and "+" or "−"
end)

GnurtHub = {
    State = State,  -- expose for testing
    Unload = function()
        for k, _ in pairs(State) do State[k] = false end
        if ToggleConnection then
            pcall(function() ToggleConnection:Disconnect() end)
            ToggleConnection = nil
        end
        if ScreenGui and ScreenGui.Parent then
            pcall(function() ScreenGui:Destroy() end)
        end
        ScreenGui = nil
        MainFrame = nil
        GnurtHub = nil
    end,
}

print("[GnurtHub] Blox Monster loaded. Press RightShift to toggle menu.")
