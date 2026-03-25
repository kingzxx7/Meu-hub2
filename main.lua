local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorHubV10"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 5, 0.5, -22)
ToggleBtn.Text = "VH"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = ScreenGui
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 300)
Main.Position = UDim2.new(0.5, -230, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.Parent = Main

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -120, 1, -10)
Container.Position = UDim2.new(0, 115, 0, 5)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Tabs = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, (order-1)*38 + 5)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 4, 0)
    page.ScrollBarThickness = 2
    page.Parent = Container
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Tabs) do p.Visible = false end
        page.Visible = true
    end)
    Tabs[name] = page
    return page
end

local farmPage = CreateTab("Main", 1)
local bossPage = CreateTab("Boss", 2)
local statsPage = CreateTab("Stats", 3)
local miscPage = CreateTab("Settings", 4)

_G.Config = {Farm = false, Boss = false, SelectedBoss = "None", Weapon = "Sword", AutoEquip = false, Skills = false, Dist = 10}

local function AddToggle(parent, text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.Text = text .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        _G.Config[key] = not _G.Config[key]
        btn.Text = text .. (_G.Config[key] and " [ON]" or " [OFF]")
        btn.TextColor3 = _G.Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    end)
end

local function AddDropdown(parent, text, list, key)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.95, 0, 0, 20)
    label.Text = text .. ": " .. _G.Config[key]
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.BackgroundTransparency = 1
    label.Parent = parent

    local dropFrame = Instance.new("ScrollingFrame")
    dropFrame.Size = UDim2.new(0.95, 0, 0, 80)
    dropFrame.CanvasSize = UDim2.new(0, 0, 0, #list * 25)
    dropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    dropFrame.Parent = parent
    Instance.new("UIListLayout", dropFrame)

    for _, item in pairs(list) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 25)
        b.Text = item
        b.Parent = dropFrame
        b.MouseButton1Click:Connect(function()
            _G.Config[key] = item
            label.Text = text .. ": " .. item
        end)
    end
end

AddToggle(farmPage, "Auto Farm Level", "Farm")
AddToggle(farmPage, "Auto Equip Weapon", "AutoEquip")
AddDropdown(farmPage, "Select Weapon", {"Sword", "Fruit", "Melee"}, "Weapon")
AddToggle(farmPage, "Auto Skills", "Skills")

AddDropdown(bossPage, "Select Boss", {"Monkey King", "Clown Pirate", "Expert Swordsman", "Chef Ship", "Sea Beast", "Hydra", "Lucifer", "Dark Beard", "Sally", "Sea Dragon"}, "SelectedBoss")
AddToggle(bossPage, "Auto Farm Boss", "Boss")

local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0.95, 0, 0, 25)
distLabel.Text = "Distance: " .. _G.Config.Dist
distLabel.Parent = miscPage

local distSli = Instance.new("TextButton")
distSli.Size = UDim2.new(0.95, 0, 0, 10)
distSli.Text = ""
distSli.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
distSli.Parent = miscPage
distSli.MouseButton1Click:Connect(function()
    _G.Config.Dist = _G.Config.Dist == 10 and 15 or 10
    distLabel.Text = "Distance: " .. _G.Config.Dist
end)

RunService.Stepped:Connect(function()
    local target
    if _G.Config.Farm then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("Level") then target = v.Parent break end
        end
    elseif _G.Config.Boss and _G.Config.SelectedBoss ~= "None" then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == _G.Config.SelectedBoss and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then target = v break end
        end
    end
    if target and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Config.Dist, 0)
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    end
end)

task.spawn(function()
    while task.wait(0.7) do
        if _G.Config.AutoEquip then
            local t = Player.Backpack:FindFirstChild(_G.Config.Weapon) or Player.Character:FindFirstChild(_G.Config.Weapon)
            if t then Player.Character.Humanoid:EquipTool(t) end
        end
        if _G.Config.Skills then
            for _, k in pairs({"Z", "X", "C", "V"}) do VIM:SendKeyEvent(true, k, false, game) end
        end
    end
end)
