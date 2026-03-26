local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

local autoHopEnabled = true
local targetBossNames = {"Boss1", "Boss2", "SeaEventBoss"}
local hopHeight = 50
local attackRange = 10

local function hop()
    if humanoidRootPart then
        humanoidRootPart.Velocity = Vector3.new(0, hopHeight, 0)
    end
end

local function getNearestTarget()
    local nearest = nil
    local shortestDist = math.huge
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and table.find(targetBossNames, model.Name) then
            local targetRoot = model:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - humanoidRootPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    nearest = targetRoot
                end
            end
        end
    end
    return nearest, shortestDist
end

RunService.RenderStepped:Connect(function()
    if not autoHopEnabled then return end

    local target, distance = getNearestTarget()
    if target and distance <= attackRange then
        mouse.Target = target
        fireclickdetector(target.Parent:FindFirstChildOfClass("ClickDetector"))
    else
        hop()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        autoHopEnabled = not autoHopEnabled
    end
end)
