-- Menü + HttpGet ile aimbot scripti import ve kontrol sistemi

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Ayarlar
local Smoothness = 1
local VisualFOV_Radius = 10  -- Görsel FOV çapı (piksel cinsinden) sadece gösterim amaçlı
local VisualFOV_Color = Color3.fromRGB(255, 0, 0) -- FOV rengini buradan değiştirebilirsiniz (örnek: kırmızı)
local Show_VisualFOV = false -- Görsel FOV dairesi görünür mü? (true/false)

-- Hayali FOV çapı da görsel FOV ile aynı büyüklükte olmalı
local AimBot_FOV_Radius = VisualFOV_Radius  -- Gerçek kilitleme için kullanılan hayali FOV çapı, görsel FOV ile aynı

local aimbot = false -- Aimbot başlangıçta aktif
local isLeftClicking = false
local TeamCheck = false  -- Takım arkadaşı koruması

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

-- GUI Oluşturma
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Open = true

-- Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ZIndex = 1000

-- Aimbot Toggle
local aimbotToggle = Instance.new("TextButton", Frame)
aimbotToggle.Size = UDim2.new(1, -20, 0, 30)
aimbotToggle.Position = UDim2.new(0, 10, 0, 10)
aimbotToggle.Text = "Aimbot: Kapalı"
aimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
aimbotToggle.MouseButton1Click:Connect(function()
    getgenv().aimbot = not getgenv().aimbot
    aimbotToggle.Text = "Aimbot: " .. (getgenv().aimbot and "Açık" or "Kapalı")
end)

-- Team Check Toggle
local teamToggle = aimbotToggle:Clone()
teamToggle.Parent = Frame
teamToggle.Position = UDim2.new(0, 10, 0, 50)
teamToggle.Text = "TeamCheck: Açık"
teamToggle.MouseButton1Click:Connect(function()
    getgenv().TeamCheck = not getgenv().TeamCheck
    teamToggle.Text = "TeamCheck: " .. (getgenv().TeamCheck and "Açık" or "Kapalı")
end)

-- Show FOV Toggle
local fovToggle = teamToggle:Clone()
fovToggle.Parent = Frame
fovToggle.Position = UDim2.new(0, 10, 0, 90)
fovToggle.Text = "Show FOV: Açık"
fovToggle.MouseButton1Click:Connect(function()
    getgenv().Show_VisualFOV = not getgenv().Show_VisualFOV
    fovToggle.Text = "Show FOV: " .. (getgenv().Show_VisualFOV and "Açık" or "Kapalı")
end)

-- Smoothness Slider (basit input)
local smoothInput = Instance.new("TextBox", Frame)
smoothInput.Size = UDim2.new(1, -20, 0, 30)
smoothInput.Position = UDim2.new(0, 10, 0, 130)
smoothInput.PlaceholderText = "Smoothness (sayi gir)"
smoothInput.Text = ""
smoothInput.FocusLost:Connect(function()
    local num = tonumber(smoothInput.Text)
    if num then
        getgenv().Smoothness = num
    end
end)

-- FOV Radius Slider
local fovRadius = smoothInput:Clone()
fovRadius.Parent = Frame
fovRadius.Position = UDim2.new(0, 10, 0, 170)
fovRadius.PlaceholderText = "FOV Radius (sayi gir)"
fovRadius.FocusLost:Connect(function()
    local num = tonumber(fovRadius.Text)
    if num then
        getgenv().VisualFOV_Radius = num
    end
end)

-- Color Picker (RGB textbox)
local colorBox = fovRadius:Clone()
colorBox.Parent = Frame
colorBox.Position = UDim2.new(0, 10, 0, 210)
colorBox.PlaceholderText = "RGB renk (255,0,0)"
colorBox.FocusLost:Connect(function()
    local r, g, b = string.match(colorBox.Text, "(%d+),%s*(%d+),%s*(%d+)")
    if r and g and b then
        getgenv().VisualFOV_Color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
end)

-- INS tuşuyla menü göster/gizle
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Insert then
        Open = not Open
        Frame.Visible = Open
    end
end)
