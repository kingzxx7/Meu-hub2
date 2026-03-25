local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

_G.Active = true

local function ServerHop()
    task.wait(3)
    local success, servers = pcall(function()
        return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and servers then
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                break
            end
        end
    end
end

local function KillAndLoot(target)
    while target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 and _G.Active do
        pcall(function()
            Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            for _, key in pairs({"Z", "X", "C", "V"}) do
                VIM:SendKeyEvent(true, key, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, key, false, game)
            end
        end)
        task.wait(0.1)
    end
    
    for i = 1, 15 do
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name:find("Chest") or v:IsA("Tool") then
                Player.Character.HumanoidRootPart.CFrame = v:IsA("Tool") and v.Handle.CFrame or v.CFrame
                if v:IsA("Tool") then game:GetService("ReplicatedStorage").Remotes.StoreFruit:InvokeServer(v.Name) end
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
    ServerHop()
end

task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    task.wait(8)

    while _G.Active do
        local foundBoss = nil
        
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name == "Sea King" or v.Name == "Hydra" or v.Name == "Ghost Ship") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                foundBoss = v
                break
            end
        end

        if foundBoss then
            KillAndLoot(foundBoss)
        else
            task.wait(20)
            ServerHop()
        end
    end
end)

local sg = Instance.new("ScreenGui", Player.PlayerGui)
local t = Instance.new("TextLabel", sg)
t.Size = UDim2.new(0, 280, 0, 60)
t.Position = UDim2.new(0.5, -140, 0.05, 0)
t.Text = "VICTOR HUB: PROCURANDO EVENTO ATIVO..."
t.BackgroundColor3 = Color3.new(0,0,0)
t.TextColor3 = Color3.new(0,1,1)
Instance.new("UICorner", t)
