local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorHubV11"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
ToggleBtn.Text = "VH"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Parent = ScreenGui
ToggleBtn.Draggable = true
local Corner = Instance.new("UICorner", ToggleBtn)
Corner.CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.Visible = true
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "VICTOR HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -130, 1, -10)
Container.Position = UDim2.new(0, 125, 0, 5)
Container.BackgroundTransparency = 1
Container.Parent = Main

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Pages = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (order-1)*35 + 45)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans
    btn.Parent = Sidebar
    Instance.new("UICorner", btn)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 5, 0)
    page.ScrollBarThickness = 2
    page.Parent = Container
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
    Pages[name] = page
    return page
end

local farmPage = CreateTab("General", 1)
local bossPage = CreateTab("Combat", 2)
local statPage = CreateTab("Stats", 3)
local miscPage = CreateTab("Visuals", 4)

_G.Config = {Farm = false, Boss = false, SelectedBoss = "None", Weapon = "Sword", AutoEquip = false, Skills = false, Dist = 10}

local function AddToggle(parent, text, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Parent = parent
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.Text = ""
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        _G.Config[key] = not _G.Config[key]
        btn.BackgroundColor3 = _G.Config[key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 40)
    end)
end

AddToggle(farmPage, "Auto Farm Level", "Farm")
AddToggle(farmPage, "Auto Equip Weapon", "AutoEquip")
AddToggle(farmPage, "Auto Use Skills", "Skills")

AddToggle(bossPage, "Auto Kill Selected Boss", "Boss")

local fpsBtn = Instance.new("TextButton")
fpsBtn.Size = UDim2.new(0.95, 0, 0, 35)
fpsBtn.Text = "Remove Textures (FPS)"
fpsBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsBtn.Parent = miscPage
Instance.new("UICorner", fpsBtn)

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
    elseif _G.Config.Boss and _G.Config.SelectedBoss ~= "None" then
        target = workspace:FindFirstChild(_G.Config.SelectedBoss, true)
    end
    if target and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    end
end)

task.spawn(function()
    while task.wait(0.8) do
        if _G.Config.AutoEquip and Player.Backpack:FindFirstChild(_G.Config.Weapon) then
            Player.Character.Humanoid:EquipTool(Player.Backpack[_G.Config.Weapon])
        end
        if _G.Config.Skills then
            for _, k in pairs({"Z", "X", "C", "V"}) do VIM:SendKeyEvent(true, k, false, game) end
        end
    end
end)
