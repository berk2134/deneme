local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Ayarlar
local Smoothness = 1
local VisualFOV_Radius = 100  -- Görsel FOV çapı (piksel cinsinden) sadece gösterim amaçlı
local VisualFOV_Color = Color3.fromRGB(255, 0, 0) -- FOV rengini buradan değiştirebilirsiniz (örnek: kırmızı)
local Show_VisualFOV = true -- Görsel FOV dairesi görünür mü? (true/false)

-- Hayali FOV çapı da görsel FOV ile aynı büyüklükte olmalı
local AimBot_FOV_Radius = VisualFOV_Radius  -- Gerçek kilitleme için kullanılan hayali FOV çapı, görsel FOV ile aynı

local aimbot = true -- Aimbot başlangıçta aktif
local isLeftClicking = false
local TeamCheck = true  -- Takım arkadaşı koruması

-- Görsel FOV dairesi için Drawing objesi
local fovCircle -- Görsel FOV dairesi

-- Görsel FOV çizme fonksiyonu
local function drawVisualFOV()
    if not Show_VisualFOV then
        if fovCircle then
            fovCircle.Visible = false  -- FOV görünür değilse daireyi gizle
        end
        return
    end

    if not fovCircle then
        fovCircle = Drawing.new("Circle")
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)  -- Ekranın tam ortası
        fovCircle.Radius = VisualFOV_Radius -- Görsel FOV büyüklüğü
        fovCircle.Color = VisualFOV_Color -- FOV rengini buradan ayarlıyoruz
        fovCircle.Thickness = 1
        fovCircle.Transparency = 0.5
        fovCircle.Visible = true
    else
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)  -- Ekranın tam ortası
        fovCircle.Radius = VisualFOV_Radius -- Görsel FOV büyüklüğü
    end
end

-- Hayali FOV içindeki hedefi kontrol et (kilitleme alanı)
local function isInAimBotFOV(targetPosition)
    local centerX, centerY = Mouse.X, Mouse.Y
    local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)
    local distance = (Vector2.new(centerX, centerY) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude

    -- Hayali FOV sınırları içinde olup olmadığını kontrol et
    return distance <= AimBot_FOV_Radius
end

-- En yakın hedefi bul
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- Takım arkadaşı kontrolü
            if TeamCheck and player.Team == LocalPlayer.Team then
                continue -- Aynı takımdan ise geç
            end

            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                -- Eğer hedef Hayali FOV dairesinin içinde ise, o oyuncuya kilitlen
                if isInAimBotFOV(head.Position) then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
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
    if aimbot and isLeftClicking then
        local target = getClosestPlayer()

        if target then
            -- Aimbot aktif olacak
            local camPos = Camera.CFrame.Position
            local newLook = (target.Position - camPos).Unit
            local currentLook = Camera.CFrame.LookVector
            local lerpedLook = currentLook:Lerp(newLook, math.clamp(1 / Smoothness, 0, 1))
            Camera.CFrame = CFrame.new(camPos, camPos + lerpedLook)
        end
    end

    -- Görsel FOV dairesini her render adımında çiz
    drawVisualFOV()
end)
