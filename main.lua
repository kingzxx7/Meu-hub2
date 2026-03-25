local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Http = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorHubV15"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

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
    btn.Parent = Sidebar
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 6, 0)
    page.Parent = Container
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Tabs) do p.Visible = false end
        page.Visible = true
    end)
    Tabs[name] = page
    return page
end

local farmTab = CreateTab("Auto Farm", 1)
local bossTab = CreateTab("Bosses", 2)
local serverTab = CreateTab("Server Live", 3)

_G.Config = {Farm = false, Boss = false, SelectedBoss = "None", Weapon = "None", AutoEquip = false, Skills = false}

local function AddToggle(parent, text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.Text = text .. ": OFF"
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        _G.Config[key] = not _G.Config[key]
        btn.Text = text .. ": " .. (_G.Config[key] and "ON" or "OFF")
    end)
end

-- FUNÇÃO SERVER HOP (SERVER LIVE LOGIC)
local function ServerHop()
    local PlaceID = game.PlaceId
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceID, s.id, Player)
            break
        end
    end
end

local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(0.95, 0, 0, 40)
hopBtn.Text = "🚀 PROCURAR NOVO SERVIDOR"
hopBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Parent = serverTab
hopBtn.MouseButton1Click:Connect(ServerHop)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.95, 0, 0, 60)
infoLabel.Text = "Status: Monitorando...\nJogadores: " .. #Players:GetPlayers() .. "\nTempo: " .. math.floor(workspace.DistributedGameTime/60) .. " min"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.BackgroundTransparency = 1
infoLabel.Parent = serverTab

-- REFRESH BOSSES (SEA 1, 2 e 3)
local realBosses = {"Monkey King", "Clown Pirate", "Expert Swordsman", "Chef Ship", "Sea Beast", "Hydra", "Lucid", "Dark Beard", "Sally", "Sea Dragon"}
for _, name in pairs(realBosses) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.95, 0, 0, 25)
    b.Text = name
    b.Parent = bossTab
    b.MouseButton1Click:Connect(function() _G.Config.SelectedBoss = name end)
end
AddToggle(bossTab, "KILL BOSS", "Boss")

AddToggle(farmTab, "AUTO FARM LEVEL", "Farm")
AddToggle(farmTab, "AUTO SKILLS", "Skills")

-- LÓGICA DE EXECUÇÃO
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
        Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    end
end)

task.spawn(function()
    while task.wait(0.7) do
        if _G.Config.Skills then
            for _, k in pairs({"Z", "X", "C", "V"}) do VIM:SendKeyEvent(true, k, false, game) end
        end
    end
end)
