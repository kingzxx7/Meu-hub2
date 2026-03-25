local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

_G.Active = true

local function ServerHop()
    local PlaceID = game.PlaceId
    local success, servers = pcall(function()
        return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and servers then
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TS:TeleportToPlaceInstance(PlaceID, s.id, Player)
                break
            end
        end
    end
end

local function CollectAndStore()
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:find("Chest") or v:IsA("Tool") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = v:IsA("Tool") and v:FindFirstChild("Handle") and v.Handle.CFrame or v:IsA("BasePart") and v.CFrame
                if pos then
                    Player.Character.HumanoidRootPart.CFrame = pos
                    task.wait(0.5)
                    if v:IsA("Tool") then
                        game:GetService("ReplicatedStorage").Remotes.StoreFruit:InvokeServer(v.Name)
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while _G.Active do
        local eventFound = false
        local targets = {"Sea King", "Hydra", "Ghost Ship"}
        
        for _, v in pairs(workspace:GetDescendants()) do
            local isTarget = false
            for _, name in pairs(targets) do
                if v.Name == name then isTarget = true break end
            end

            if isTarget and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                eventFound = true
                while v.Humanoid.Health > 0 and _G.Active do
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                        local tool = Player.Backpack:FindFirstChild("Sword") or Player.Character:FindFirstChild("Sword")
                        if tool then Player.Character.Humanoid:EquipTool(tool) end
                        
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        
                        for _, key in pairs({"Z", "X", "C", "V"}) do
                            VIM:SendKeyEvent(true, key, false, game)
                            task.wait(0.05)
                            VIM:SendKeyEvent(false, key, false, game)
                        end
                    end
                    task.wait(0.1)
                end
                task.wait(1)
                CollectAndStore()
                task.wait(2)
                ServerHop()
            end
        end
        
        if not eventFound then
            task.wait(5)
            ServerHop()
        end
        task.wait(1)
    end
end)

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
local Status = Instance.new("TextLabel", ScreenGui)
Status.Size = UDim2.new(0, 250, 0, 50)
Status.Position = UDim2.new(0.5, -125, 0, 30)
Status.Text = "VICTOR HUB: FULL AUTO SKILLS"
Status.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Status.TextColor3 = Color3.fromRGB(0, 255, 150)
Status.BorderSizePixel = 0
Instance.new("UICorner", Status)
