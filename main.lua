local CorrectKey = "VICTOR-HUB-2026"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorKeySystem"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 260, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.BorderSizePixel = 2
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "VICTOR HUB - KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Parent = KeyFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0, 40)
TextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
TextBox.PlaceholderText = "Digite a Key..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Parent = KeyFrame

local Submit = Instance.new("TextButton")
Submit.Size = UDim2.new(0.8, 0, 0, 40)
Submit.Position = UDim2.new(0.1, 0, 0.65, 0)
Submit.Text = "VERIFICAR"
Submit.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
Submit.Parent = KeyFrame

local function MainScript()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local VIM = game:GetService("VirtualInputManager")
    local TS = game:GetService("TeleportService")
    local Http = game:GetService("HttpService")

    local HubGui = Instance.new("ScreenGui")
    HubGui.Name = "VictorHubMain"
    HubGui.Parent = ScreenGui.Parent
    
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 240, 0, 320)
    Main.Position = UDim2.new(0.5, -120, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.Active = true
    Main.Draggable = true
    Main.Parent = HubGui

    local HubTitle = Instance.new("TextLabel")
    HubTitle.Size = UDim2.new(1, 0, 0, 35)
    HubTitle.Text = "VICTOR HUB V3"
    HubTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
    HubTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    HubTitle.Parent = Main

    local function CreateToggle(name, pos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = pos
        btn.Text = name .. ": OFF"
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Parent = Main
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
            btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 0, 0)
            callback(enabled)
        end)
    end

    _G.Farm = false
    _G.Skills = false
    _G.Sea = false

    CreateToggle("Auto Farm Level", UDim2.new(0.05, 0, 0.15, 0), function(v) _G.Farm = v end)
    CreateToggle("Auto Skills", UDim2.new(0.05, 0, 0.30, 0), function(v) _G.Skills = v end)
    CreateToggle("Auto Sea Events", UDim2.new(0.05, 0, 0.45, 0), function(v) _G.Sea = v end)

    local HopBtn = Instance.new("TextButton")
    HopBtn.Size = UDim2.new(0.9, 0, 0, 40)
    HopBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    HopBtn.Text = "Pular Servidor"
    HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    HopBtn.Parent = Main

    local function DoHop()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"
        local success, result = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
        if success and result.data then
            for _, s in ipairs(result.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TS:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                    return
                end
            end
        end
        TS:Teleport(game.PlaceId, Player)
    end

    HopBtn.MouseButton1Click:Connect(DoHop)

    game:GetService("RunService").Stepped:Connect(function()
        if _G.Farm or _G.Sea then
            local target
            if _G.Sea then
                target = workspace:FindFirstChild("SeaEvents") and workspace.SeaEvents:FindFirstChildWhichIsA("Model")
            else
                for _, v in pairs(workspace:FindFirstChild("Mobs") and workspace.Mobs:GetChildren() or {}) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then target = v break end
                end
            end
            if target and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if _G.Skills then
                VIM:SendKeyEvent(true, "Z", false, game)
                VIM:SendKeyEvent(true, "X", false, game)
                VIM:SendKeyEvent(true, "C", false, game)
            end
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Chest" or child.Name == "Treasure" then
            task.wait(2)
            DoHop()
        end
    end)
end

Submit.MouseButton1Click:Connect(function()
    if TextBox.Text == CorrectKey then
        KeyFrame:Destroy()
        MainScript()
    else
        Submit.Text = "SENHA ERRADA!"
        task.wait(1)
        Submit.Text = "VERIFICAR"
    end
end)
