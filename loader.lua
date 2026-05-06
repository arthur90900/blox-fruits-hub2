-- Blox Fruits Premium Hub - Versão Completa
-- Compatível com Xeno Executor
-- Funções: Auto Level Farm, Mastery Farm, Auto Stats, Bring Mobs, NoClip, etc.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Variáveis de Estado
local Features = {
    AutoFarm = false,
    AutoQuest = false,
    AutoStats = false,
    AutoMastery = false,
    BringMobs = false,
    NoClip = false,
    InfiniteJump = false,
    AutoTravel = false,
    SelectedStat = "Melee"
}

-- Criar Hub Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Blox Fruits Premium Hub - v2.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Função para Encontrar Inimigo Ideal
local function getEnemyByLevel(level)
    local target = nil
    local minDiff = 99999
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("Level") then
            local enemyLevel = v.Level.Value or 0
            local diff = math.abs(enemyLevel - level)
            if diff < 20 and diff < minDiff then
                minDiff = diff
                target = v
            end
        end
    end
    return target
end

-- Auto Stats Function
local function autoStats()
    if not Features.AutoStats then return end
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("Points") then
        local points = data.Points.Value
        if points > 0 then
            pcall(function()
                local Remotes = ReplicatedStorage:WaitForChild("Remotes")
                local CommF = Remotes:WaitForChild("CommF_")
                CommF:InvokeServer("AddPlayerPoints", Features.SelectedStat, points)
            end)
        end
    end
end

-- Loop Principal
RunService.Heartbeat:Connect(function()
    if Features.AutoFarm then
        local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if human and human.Health > 0 then
            local enemy = getEnemyByLevel(LocalPlayer.Data.Level.Value)
            if enemy then
                local rootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                TweenService:Create(rootPart, TweenInfo.new(0.3, Enum.EasingStyle.Quadratic), {
                    CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                }):Play()
                wait(0.2)
                pcall(function()
                    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
                    local CommF = Remotes:WaitForChild("CommF_")
                    CommF:InvokeServer("Attack")
                end)
            end
        end
    end

    if Features.AutoStats then
        autoStats()
    end
end)

-- Função para Criar Botões de Toggle
local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Font = Enum.Font.Gotham
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextSize = 14

    btn.MouseButton1Click:Connect(function()
        local isOn = btn.Text:find("ON")
        btn.Text = text .. ": " .. (isOn and "OFF" or "ON")
        callback(not isOn)
    end)
    return btn
end

-- Criar Botão de Seleção de Stat
local function createStatButton(parent, statName)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Font = Enum.Font.Gotham
    btn.Text = statName
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextSize = 14

    btn.MouseButton1Click:Connect(function()
        Features.SelectedStat = statName
        -- Atualiza texto dos outros botões (simplificado)
        for _, v in ipairs(parent:GetChildren()) do
            if v:IsA("TextButton") and v ~= btn then
                v
