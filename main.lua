local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorHubV4"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 350, 0, 250)
Main.Position = UDim2.new(0.5, -175, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 80, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.Parent = Main

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -90, 1, -10)
Container.Position = UDim2.new(0, 85, 0, 5)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Tabs = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (order-1)*45)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = Sidebar
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 2, 0)
    page.Parent = Container
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Tabs) do p.Visible = false end
        page.Visible = true
    end)
    Tabs[name] = page
    return page
end

local farmPage = CreateTab("Farm", 1)
local seaPage = CreateTab("Sea", 2)
local statsPage = CreateTab("Stats", 3)
local miscPage = CreateTab("Misc", 4)

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    
    local UIList = parent:FindFirstChild("UIListLayout") or Instance.new("UIListLayout", parent)
    UIList.Padding = UDim.new(0, 5)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(50, 20, 20)
        callback(state)
    end)
end

_G.Config = {Farm = false, Sea = false, Boss = false, Stats = false, Skills = false}

AddToggle(farmPage, "Auto Farm Level", function(v) _G.Config.Farm = v end)
AddToggle(farmPage, "Auto Farm Boss", function(v) _G.Config.Boss = v end)
AddToggle(farmPage, "Auto Skills", function(v) _G.Config.Skills = v end)

AddToggle(seaPage, "Auto Sea Events", function(v) _G.Config.Sea = v end)
AddToggle(seaPage, "Auto Collect Chest", function(v) _G.Config.Chest = v end)

AddToggle(statsPage, "Auto Stats (Fruit)", function(v) _G.Config.Stats = v end)

local function GetTarget(mode)
    local folder = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Monsters") or workspace
    for _, v in pairs(folder:GetDescendants()) do
        if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
            if mode == "Farm" and v.Parent:FindFirstChild("Level") then return v.Parent end
            if mode == "Boss" and v.MaxHealth > 50000 then return v.Parent end
            if mode == "Sea" and (v.Parent.Name:find("Sea") or v.Parent.Name:find("Hydra")) then return v.Parent end
        end
    end
end

RunService.Stepped:Connect(function()
    local target
    if _G.Config.Farm then target = GetTarget("Farm")
    elseif _G.Config.Boss then target = GetTarget("Boss")
    elseif _G.Config.Sea then target = GetTarget("Sea") end

    if target and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.Config.Skills then
            for _, key in pairs({"Z", "X", "C", "V"}) do VIM:SendKeyEvent(true, key, false, game) end
        end
        if _G.Config.Stats then
            game:GetService("ReplicatedStorage").Remotes.Stats:FireServer("Fruit", 1)
        end
    end
end)
