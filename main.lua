local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorHubV9"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.Text = "V"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 25
ToggleBtn.Parent = ScreenGui
ToggleBtn.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    ToggleBtn.Text = Main.Visible and "X" or "V"
    ToggleBtn.BackgroundColor3 = Main.Visible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 255)
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.Parent = Main

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -110, 1, -10)
Container.Position = UDim2.new(0, 105, 0, 5)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Tabs = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, (order-1)*38)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = Sidebar
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 5, 0) 
    page.ScrollBarThickness = 4
    page.Parent = Container
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Tabs) do p.Visible = false end
        page.Visible = true
    end)
    Tabs[name] = page
    return page
end

local mainPage = CreateTab("🏠 Farm", 1)
local bossPage = CreateTab("👹 Bosses", 2)
local tpPage = CreateTab("📍 Teleport", 3)
local statsPage = CreateTab("📊 Stats", 4)
local miscPage = CreateTab("⚙️ Misc", 5)

_G.Config = {Farm = false, Boss = false, SelectedBoss = "None", Weapon = "Sword", AutoEquip = false, Skills = false, Sea = false, AutoStats = false, StatType = "Melee"}

local function AddToggle(parent, text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        _G.Config[key] = not _G.Config[key]
        btn.Text = text .. ": " .. (_G.Config[key] and "ON" or "OFF")
        btn.BackgroundColor3 = _G.Config[key] and Color3.fromRGB(20, 80, 20) or Color3.fromRGB(60, 20, 20)
    end)
end

local weaponInput = Instance.new("TextBox")
weaponInput.Size = UDim2.new(0.95, 0, 0, 30)
weaponInput.PlaceholderText = "Nome da Arma"
weaponInput.Parent = mainPage
weaponInput.FocusLost:Connect(function() _G.Config.Weapon = weaponInput.Text end)

AddToggle(mainPage, "Auto Equip", "AutoEquip")
AddToggle(mainPage, "Auto Farm Level", "Farm")
AddToggle(mainPage, "Auto Skills", "Skills")

local bossList = {"Monkey King", "Clown Pirate", "Expert Swordsman", "Chef Ship", "Sea Beast", "Hydra", "Lucifer", "Dark Beard", "Sally", "Sea Dragon"}
for _, name in pairs(bossList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 25)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = bossPage
    btn.MouseButton1Click:Connect(function() _G.Config.SelectedBoss = name end)
end
AddToggle(bossPage, "Kill Selected Boss", "Boss")

local islands = {["Sea 1"] = Vector3.new(-496, 20, 400), ["Sea 2"] = Vector3.new(-400, 50, 1000), ["Sea 3"] = Vector3.new(1000, 100, 500)}
for name, pos in pairs(islands) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.Text = "Ir para " .. name
    btn.Parent = tpPage
    btn.MouseButton1Click:Connect(function() Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos) end)
end

AddToggle(statsPage, "Auto Stats", "AutoStats")
local statBox = Instance.new("TextBox")
statBox.Size = UDim2.new(0.95, 0, 0, 30)
statBox.PlaceholderText = "Tipo (Melee, Defense, Sword, Fruit)"
statBox.Parent = statsPage
statBox.FocusLost:Connect(function() _G.Config.StatType = statBox.Text end)

local fpsBtn = Instance.new("TextButton")
fpsBtn.Size = UDim2.new(0.95, 0, 0, 35)
fpsBtn.Text = "🚀 FPS BOOSTER"
fpsBtn.Parent = miscPage
fpsBtn.MouseButton1Click:Connect(function()
    for i, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = "SmoothPlastic" v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)

RunService.Stepped:Connect(function()
    local target
    if _G.Config.Farm then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("Level") then target = v.Parent break end
        end
    elseif _G.Config.Boss then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == _G.Config.SelectedBoss and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then target = v break end
        end
    end
    if target and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.Config.AutoEquip and Player.Backpack:FindFirstChild(_G.Config.Weapon) then
            Player.Character.Humanoid:EquipTool(Player.Backpack[_G.Config.Weapon])
        end
        if _G.Config.Skills then
            for _, k in pairs({"Z", "X", "C", "V"}) do VIM:SendKeyEvent(true, k, false, game) end
        end
        if _G.Config.AutoStats then
            game:GetService("ReplicatedStorage").Remotes.Stats:FireServer(_G.Config.StatType, 1)
        end
    end
end)

Player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
