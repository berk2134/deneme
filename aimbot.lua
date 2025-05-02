local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Ayarlar
local TeamCheck = false
local Smoothness = 1
local AutoShoot = false

local isShooting = false
local isLeftClicking = false

-- Görüş hattı kontrolü
local function isVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, rayParams)
    
    -- Eğer raycast'in sonucu yoksa (engelsizse) doğru, aksi takdirde yanlış
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

-- En yakın hedefi bul
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if TeamCheck and player.Team == LocalPlayer.Team then continue end

            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 and isVisible(head) then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = head
                    end
                end
            end
        end
    end

    return closest
end

-- Sol tıklama algılayıcı
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isLeftClicking = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isLeftClicking = false
    end
end)

-- Render döngüsü
RunService.RenderStepped:Connect(function()
    local target = getClosestPlayer()

    if target and (AutoShoot or isLeftClicking) then
        -- Aimbot aktif olacak
        local camPos = Camera.CFrame.Position
        local newLook = (target.Position - camPos).Unit
        local currentLook = Camera.CFrame.LookVector
        local lerpedLook = currentLook:Lerp(newLook, math.clamp(1 / Smoothness, 0, 1))
        Camera.CFrame = CFrame.new(camPos, camPos + lerpedLook)

        -- Otomatik ateş (sadece AutoShoot açıkken)
        if AutoShoot and not isShooting then
            isShooting = true
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end
    else
        -- Hedef yoksa ateşi bırak
        if isShooting then
            isShooting = false
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)
