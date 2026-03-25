local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

getgenv().Config = {
    ["Tool"] = "Sword",
    ["AutoFarm"] = false,
    ["Distance"] = 10,
    ["AutoClick"] = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorHubV18"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -10)
Content.Position = UDim2.new(0, 115, 0, 5)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function CreateTab(name, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = UDim2.new(0, 5, 0, (order-1)*33 + 5)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Parent = Sidebar
    Instance.new("UICorner", b)

    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = (order == 1)
    p.BackgroundTransparency = 1
    p.CanvasSize = UDim2.new(0, 0, 5, 0)
    p.Parent = Content
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)

    b.MouseButton1Click:Connect(function()
        for _, page in pairs(Content:GetChildren()) do if page:IsA("ScrollingFrame") then page.Visible = false end end
        p.Visible = true
    end)
    return p
end

local function AddToggle(parent, text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        getgenv().Config[key] = not getgenv().Config[key]
        btn.Text = text .. ": " .. (getgenv().Config[key] and "ON" or "OFF")
        btn.TextColor3 = getgenv().Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    end)
end

local mainPage = CreateTab("Main", 1)
AddToggle(mainPage, "Auto Farm", "AutoFarm")
AddToggle(mainPage, "Auto Click", "AutoClick")

for i=2,9 do CreateTab("Aba "..i, i) end -- Cria as outras abas vazias para manter o visual

-- MOTOR DE ALTA PERFORMANCE (O SEGREDO DO NTT)
local TargetNPC = nil
task.spawn(function()
    while task.wait(0.5) do -- Checa o alvo apenas 2 vezes por segundo (Economiza CPU)
        if getgenv().Config.AutoFarm then
            local minDist = 500
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("Level") then
                    local dist = (v.Parent.PrimaryPart.Position - Player.Character.PrimaryPart.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        TargetNPC = v.Parent
                    end
                end
            end
        else
            TargetNPC = nil
        end
    end
end)

RunService.Heartbeat:Connect(function() -- Teleporte suave no frame do jogo
    if getgenv().Config.AutoFarm and TargetNPC and TargetNPC:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = TargetNPC.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Config.Distance, 0)
    end
end)

task.spawn(function()
    while task.wait(0.1) do -- Ataque rápido mas controlado
        if getgenv().Config.AutoFarm or getgenv().Config.AutoClick then
            local tool = Player.Backpack:FindFirstChild(getgenv().Config.Tool) or Player.Character:FindFirstChild(getgenv().Config.Tool)
            if tool then Player.Character.Humanoid:EquipTool(tool) end
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)
