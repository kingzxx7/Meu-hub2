local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local function antiLag()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = "SmoothPlastic"
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
            v:Destroy()
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
end
task.spawn(antiLag)

getgenv().v_Config = {
    ["Tool"] = "Sword",
    ["Auto Farm Level"] = false,
    ["Auto Farm Mob Near"] = false,
    ["Distance Value"] = 10,
    ["Anti-Lag"] = true,
    ["Specific Boss Farm"] = false,
    ["Material Farm"] = false,
    ["Item Farm"] = false,
    ["Dungeon Farm"] = false,
    ["ESP Mob"] = false,
    ["ESP Player"] = false,
    ["ESP Chest"] = false,
    ["Auto Click"] = false,
    ["Auto Stats"] = false,
    ["Stat Type"] = "Melee",
    ["WalkSpeed"] = 16,
    ["JumpPower"] = 50
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VictorNTTHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Text = "NTT"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 20
OpenBtn.Parent = ScreenGui
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 5)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 5)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -10)
Content.Position = UDim2.new(0, 115, 0, 5)
Content.BackgroundTransparency = 1
Content.Parent = Main

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local function addTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (order - 1) * 33 + 5)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 5, 0)
    page.ScrollBarThickness = 2
    page.Parent = Content
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Content:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        page.Visible = true
    end)
    return page
end

local function addSection(parent, name)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(0.95, 0, 0, 25)
    header.Text = name
    header.TextColor3 = Color3.fromRGB(200, 200, 200)
    header.Font = Enum.Font.SourceSansBold
    header.TextSize = 14
    header.BackgroundTransparency = 1
    header.Parent = parent
end

local function addToggle(parent, name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    frame.Parent = parent
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.Text = "OFF"
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        getgenv().v_Config[name] = not getgenv().v_Config[name]
        btn.Text = getgenv().v_Config[name] and "ON" or "OFF"
        btn.BackgroundColor3 = getgenv().v_Config[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    end)
end

local function addSlider(parent, name, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    frame.Parent = parent
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.Parent = frame

    local slide = Instance.new("TextButton")
    slide.Size = UDim2.new(0.8, 0, 0, 10)
    slide.Position = UDim2.new(0.1, 0, 0, 25)
    slide.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slide.Text = ""
    slide.Parent = frame
    Instance.new("UICorner", slide)

    slide.MouseButton1Click:Connect(function()
        getgenv().v_Config[name] = math.random(min, max)
        label.Text = name .. ": " .. getgenv().v_Config[name]
    end)
end

local function addInput(parent, name, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    frame.Parent = parent
    Instance.new("UICorner", frame)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.PlaceholderText = name
    input.Text = default
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.BackgroundTransparency = 1
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = frame

    input.FocusLost:Connect(function()
        getgenv().v_Config[name] = input.Text
    end)
end

local mainP = addTabButton("Main", 1)
addSection(mainP, "Main Farm")
addInput(mainP, "Tool", "Sword")
addToggle(mainP, "Auto Farm Level")
addToggle(mainP, "Auto Farm Mob Near")
addSlider(mainP, "Distance Value", 5, 100, 10)
addSection(mainP, "Others")
addToggle(mainP, "Anti-Lag")

local bossP = addTabButton("Boss", 2)
addToggle(bossP, "Specific Boss Farm")
addToggle(bossP, "Material Farm")

local itemP = addTabButton("Item", 3)
addToggle(itemP, "Item Farm")

local dungeonP = addTabButton("Dungeon", 4)
addToggle(dungeonP, "Dungeon Farm")

local espP = addTabButton("Esp/Fish", 5)
addToggle(espP, "ESP Mob")
addToggle(espP, "ESP Player")

local combatP = addTabButton("Combat", 6)
addToggle(combatP, "Auto Click")

local playerP = addTabButton("Player", 7)
addSlider(playerP, "WalkSpeed", 16, 100, 16)

local shopP = addTabButton("Shop", 8)
addToggle(shopP, "Auto Buy")

local serverP = addTabButton("Server Live", 9)
local hop = Instance.new("TextButton")
hop.Size = UDim2.new(0.95, 0, 0, 35)
hop.Text = "Server Hop"
hop.Parent = serverP
hop.MouseButton1Click:Connect(function()
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TS:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
        end
    end
end)

RunService.Stepped:Connect(function()
    if getgenv().v_Config["Auto Farm Mob Near"] then
        pcall(function()
            local char = Player.Character
            local hrp = char.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Health > 0 and v.Parent.Name ~= Player.Name and v.Parent:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = v.Parent.HumanoidRootPart
                    if (targetHrp.Position - hrp.Position).Magnitude < 100 then
                        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, getgenv().v_Config["Distance Value"], 0)
                        local tool = Player.Backpack:FindFirstChild(getgenv().v_Config["Tool"]) or char:FindFirstChild(getgenv().v_Config["Tool"])
                        if tool then char.Humanoid:EquipTool(tool) end
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        break
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().v_Config["Auto Click"] then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)
