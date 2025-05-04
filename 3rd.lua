local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInput     = game:GetService("UserInputService")

local player        = Players.LocalPlayer
local camera        = workspace.CurrentCamera

-- Ayarlar
local toggleKey     = Enum.KeyCode.V             -- Geçiş tuşu
local thirdOffset   = Vector3.new(0, 3, 6)        -- Kamera karaktere olan offset (x, y, z)
local sensitivity   = 0.003                       -- Fare duyarlılığı
local minPitch      = math.rad(-60)               -- Minimum aşağı bakış (güncellenmiş)
local maxPitch      = math.rad(60)                -- Maksimum yukarı bakış
local minZoom       = 4                           -- Minimum uzaklık
local maxZoom       = 15                          -- Maksimum uzaklık
local zoomSpeed     = 2                           -- Tekerlek hassasiyeti

-- Durum
local isThirdPerson = false
local yaw, pitch    = 0, 0
local zoomDistance  = thirdOffset.Z               -- Başlangıçta belirlenen zoom mesafesi

-- 3rd modu kontrol etmek için eklenen değişken
local rd3 = false -- true yaparsanız, V tuşuyla geçiş aktif olacak

-- Yardımcı: Karakter hazır mı?
local function getCharacter()
    local c = player.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        return c
    end
end

-- Fare hareketi ile açıları güncelle
UserInput.InputChanged:Connect(function(inp)
    if isThirdPerson then
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            yaw   = yaw - inp.Delta.X * sensitivity
            pitch = math.clamp(pitch - inp.Delta.Y * sensitivity, minPitch, maxPitch)
        elseif inp.UserInputType == Enum.UserInputType.MouseWheel then
            -- Zoom işlemi
            zoomDistance = math.clamp(zoomDistance - inp.Position.Z * zoomSpeed, minZoom, maxZoom)
        end
    end
end)

-- Kamera güncelleme
local function updateCamera()
    local char = getCharacter()
    if not char then return end

    if isThirdPerson then
        camera.CameraType = Enum.CameraType.Scriptable

        local hrpPos = char.HumanoidRootPart.Position

        -- Hem pitch hem yaw içeren dönüş
        local rotation = CFrame.Angles(pitch, yaw, 0)
        local offset = rotation:VectorToWorldSpace(Vector3.new(0, thirdOffset.Y, zoomDistance))

        local camPos = hrpPos + offset
        local lookAt = hrpPos + Vector3.new(0, 2, 0)  -- Kafaya doğru bakması için

        camera.CFrame = CFrame.new(camPos, lookAt)
    else
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
    end
end

-- RenderStepped ile her frame güncelle
RunService.RenderStepped:Connect(updateCamera)

-- Tuş ile kamera modu geçişi
UserInput.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == toggleKey then
        if 3rd then  -- Eğer 3rd true ise, geçiş yapılabilir
            isThirdPerson = not isThirdPerson

            -- Fare imlecini gizle/göster
            UserInput.MouseBehavior = isThirdPerson and Enum.MouseBehavior.LockCenter
                                     or Enum.MouseBehavior.Default
        end
    end
end)

-- Karakter yeniden doğarsa sıfırla
player.CharacterAdded:Connect(function()
    isThirdPerson = false
    yaw, pitch    = 0, 0
    zoomDistance  = thirdOffset.Z
    UserInput.MouseBehavior = Enum.MouseBehavior.Default
end)

-- 3rd kontrolü: true olduğunda, geçiş aktif olacak
if 3rd then
    isThirdPerson = true
    UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
end
