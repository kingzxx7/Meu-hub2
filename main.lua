local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

_G.Active = true -- Deixe como true para começar automático

local function ServerHop()
    local PlaceID = game.PlaceId
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TS:TeleportToPlaceInstance(PlaceID, s.id, Player)
            break
        end
    end
end

local function CollectAndStore()
    -- Coleta baús e guarda frutas automaticamente
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:find("Chest") or v:IsA("Tool") then
            Player.Character.HumanoidRootPart.CFrame = v.Handle.CFrame rescue v.CFrame
            task.wait(0.5)
            if v:IsA("Tool") then
                game:GetService("ReplicatedStorage").Remotes.StoreFruit:InvokeServer(v.Name)
            end
        end
    end
end

task.spawn(function()
    while _G.Active do
        local eventFound = false
        -- Busca por Sea King ou Hydra
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name == "Sea King" or v.Name == "Hydra") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                eventFound = true
                -- Mata o evento
                while v.Humanoid.Health > 0 do
                    Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait()
                end
                -- Após matar, limpa o loot
                task.wait(1)
                CollectAndStore()
                task.wait(2)
                ServerHop() -- Pula após completar
            end
        end
        
        -- Se não achar nada no server em 5 segundos, pula
        if not eventFound then
            task.wait(5)
            ServerHop()
        end
        task.wait(1)
    end
end)

-- Interface Minimalista (Apenas para saber que está rodando)
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
local Status = Instance.new("TextLabel", ScreenGui)
Status.Size = UDim2.new(0, 200, 0, 50)
Status.Position = UDim2.new(0.5, -100, 0, 50)
Status.Text = "VICTOR HUB: BUSCANDO EVENTOS..."
Status.BackgroundColor3 = Color3.fromRGB(0,0,0)
Status.TextColor3 = Color3.fromRGB(0,255,0)
