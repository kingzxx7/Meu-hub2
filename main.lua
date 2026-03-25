local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

_G.Active = true

local function ServerHop()
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

local function CollectAndStore()
    pcall(function()
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name:find("Chest") or v:IsA("Tool") then
                Player.Character.HumanoidRootPart.CFrame = v:IsA("Tool") and v.Handle.CFrame or v.CFrame
                task.wait(0.5)
                if v:IsA("Tool") then
                    game:GetService("ReplicatedStorage").Remotes.StoreFruit:InvokeServer(v.Name)
                end
            end
        end
    end)
end

task.spawn(function()
    while _G.Active do
        local found = false
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name == "Sea King" or v.Name == "Hydra") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                found = true
                while v.Humanoid.Health > 0 and _G.Active do
                    Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    for _, key in pairs({"Z", "X", "C", "V"}) do
                        VIM:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        VIM:SendKeyEvent(false, key, false, game)
                    end
                    task.wait(0.1)
                end
                CollectAndStore()
                task.wait(2)
                ServerHop()
            end
        end
        if not found then task.wait(5) ServerHop() end
        task.wait(1)
    end
end)

local sg = Instance.new("ScreenGui", Player.PlayerGui)
local t = Instance.new("TextLabel", sg)
t.Size = UDim2.new(0, 200, 0, 50)
t.Position = UDim2.new(0.5, -100, 0.1, 0)
t.Text = "VICTOR HUB: ATIVO"
t.BackgroundColor3 = Color3.new(0,0,0)
t.TextColor3 = Color3.new(0,1,0)
