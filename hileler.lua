local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Ayarlar
local BoxColor = Color3.fromRGB(255, 0, 0) -- Box renk
local TracerColor = Color3.fromRGB(0, 255, 0) -- Tracer çizgisi rengi
local BoxThickness = 2
local eTeamCheck = false
local ShowNames = false
local ShowTracers = false  -- Tracer'ları aktif etmek için
local Box = false  -- Box'ı aktif edebilmek için

-- ESP tabloları
local espBoxes = {}
local nameTags = {}
local tracers = {}

local function removeESP(player)
    if espBoxes[player] then
        espBoxes[player]:Remove()
        espBoxes[player] = nil
    end
    if nameTags[player] then
        nameTags[player]:Remove()
        nameTags[player] = nil
    end
    if tracers[player] then
        tracers[player]:Remove()
        tracers[player] = nil
    end
end

local function UpdateESP(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Head") then
        removeESP(player)
        return
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        removeESP(player)
        return
    end

    if eTeamCheck and player.Team == LocalPlayer.Team then
        removeESP(player)
        return
    end

    local hrp = char.HumanoidRootPart
    local head = char.Head

    local headPos, onScreen1 = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.3, 0))
    local footPos, onScreen2 = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.8, 0))

    if onScreen1 and onScreen2 then
        local height = math.abs(headPos.Y - footPos.Y)
        local width = height / 2
        local x = headPos.X - width / 2
        local y = headPos.Y

        -- Box'ı çizme işlemi sadece Box değişkeni aktifse yapılır
        if Box then
            if not espBoxes[player] then
                local box = Drawing.new("Quad")
                box.Thickness = BoxThickness
                box.Color = BoxColor
                box.Transparency = 1
                box.Filled = false
                box.Visible = true
                espBoxes[player] = box
            end

            local box = espBoxes[player]
            box.PointA = Vector2.new(x, y)
            box.PointB = Vector2.new(x + width, y)
            box.PointC = Vector2.new(x + width, y + height)
            box.PointD = Vector2.new(x, y + height)
            box.Visible = true
        end

        -- İsimler gösterilsin mi?
        if ShowNames then
            if not nameTags[player] then
                local tag = Drawing.new("Text")
                tag.Size = 14
                tag.Center = true
                tag.Outline = true
                tag.Color = Color3.new(1, 1, 1)
                tag.OutlineColor = Color3.new(0, 0, 0)
                tag.Visible = true
                nameTags[player] = tag
            end
            local tag = nameTags[player]
            tag.Position = Vector2.new(x + width / 2, y - 14)
            tag.Text = player.Name
            tag.Visible = true
        end

        -- Tracerlar gösterilsin mi?
        if ShowTracers then
            if not tracers[player] then
                local tracer = Drawing.new("Line")
                tracer.Thickness = 1
                tracer.Color = TracerColor  -- Tracer rengini burada belirliyoruz
                tracer.Transparency = 1
                tracer.Visible = true
                tracers[player] = tracer
            end
            local tracer = tracers[player]
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(x + width / 2, y + height)
            tracer.Visible = true
        end
    else
        removeESP(player)
    end
end

-- Render loop
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            UpdateESP(player)
        end
    end
end)

-- Oyuncu eklenince karakter geldiğinde ESP başlat
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        UpdateESP(player)
    end)
end)

-- Oyuncu çıkarsa kutuyu kaldır
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Ayarlar
local Smoothness = 1
local VisualFOV_Radius = 10
local VisualFOV_Color = Color3.fromRGB(255, 0, 0)
local Show_VisualFOV = false
local AimBot_FOV_Radius = VisualFOV_Radius

local aimbot = false
local isLeftClicking = false
local TeamCheck = false
local visibility = false

local fovCircle

local function drawVisualFOV()
	if not Show_VisualFOV then
		if fovCircle then
			fovCircle.Visible = false
		end
		return
	end

	if not fovCircle then
		fovCircle = Drawing.new("Circle")
		fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
		fovCircle.Radius = VisualFOV_Radius
		fovCircle.Color = VisualFOV_Color
		fovCircle.Thickness = 1
		fovCircle.Transparency = 0.5
		fovCircle.Visible = true
	else
		fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
		fovCircle.Radius = VisualFOV_Radius
	end
end

local function isInAimBotFOV(targetPosition)
	local centerX, centerY = Mouse.X, Mouse.Y
	local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)
	local distance = (Vector2.new(centerX, centerY) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
	return distance <= AimBot_FOV_Radius
end

-- 👁️ Görünürlük testi fonksiyonu
local function isVisible(targetPart)
	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin).Unit * 1000

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {LocalPlayer.Character}

	local result = workspace:Raycast(origin, direction, params)

	return result and result.Instance and targetPart:IsDescendantOf(result.Instance.Parent)
end

-- 🎯 En yakın hedefi bul
local function getClosestPlayer()
	local closest = nil
	local shortestDistance = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if TeamCheck and player.Team == LocalPlayer.Team then
				continue
			end

			local head = player.Character.Head
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 then
				if isInAimBotFOV(head.Position) then
					if visibility and not isVisible(head) then
						continue -- Görünür değilse atla
					end

					local screenPoint = Camera:WorldToViewportPoint(head.Position)
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

RunService.RenderStepped:Connect(function()
	if aimbot and isLeftClicking then
		local target = getClosestPlayer()

		if target then
			local camPos = Camera.CFrame.Position
			local newLook = (target.Position - camPos).Unit
			local currentLook = Camera.CFrame.LookVector
			local lerpedLook = currentLook:Lerp(newLook, math.clamp(1 / Smoothness, 0, 1))
			Camera.CFrame = CFrame.new(camPos, camPos + lerpedLook)
		end
	end

	drawVisualFOV()
end)

local norecoil = false

-- Silahların yayılma (Spread) değerini sıfırlamak
if norecoil then
    for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
        -- Silahın "Spread" adında bir özelliği varsa
        if weapon:FindFirstChild("Spread") then
            -- Spread altındaki tüm bileşenleri sıfırlıyoruz
            for _, v in pairs(weapon:FindFirstChild("Spread"):GetChildren()) do
                v.Value = 0
            end
            print("Sekme (Spread) sıfırlandı.")
        end
    end
end

local nightmode = false  -- Gece modunu aktif etmek için bu değeri true yapabilirsiniz

local Lighting = game:GetService("Lighting")

-- Skybox oluştur (dolunay havası için mavi-gri tonlar)
local sky = Instance.new("Sky")
sky.SkyboxBk = "http://www.roblox.com/asset/?id=159454299"
sky.SkyboxDn = "http://www.roblox.com/asset/?id=159454296"
sky.SkyboxFt = "http://www.roblox.com/asset/?id=159454293"
sky.SkyboxLf = "http://www.roblox.com/asset/?id=159454300"
sky.SkyboxRt = "http://www.roblox.com/asset/?id=159454297"
sky.SkyboxUp = "http://www.roblox.com/asset/?id=159454294"
sky.MoonAngularSize = 11
sky.StarCount = 3000
sky.Parent = Lighting

-- Gece modunu aktif etme fonksiyonu
local function activateNightMode()
    Lighting.Ambient = Color3.fromRGB(30, 30, 50)         -- Ortam rengi
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 70)  -- Dış mekan aydınlatması
    Lighting.Brightness = 1
    Lighting.ClockTime = 0                               -- Gece
    Lighting.FogColor = Color3.fromRGB(20, 20, 30)
    Lighting.FogEnd = 500
    Lighting.FogStart = 100
    Lighting.GlobalShadows = true
    Lighting.ExposureCompensation = 0.1
end

-- Gece modunu devre dışı bırakma fonksiyonu
local function deactivateNightMode()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)       -- Ortam rengi
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) -- Dış mekan aydınlatması
    Lighting.Brightness = 2
    Lighting.ClockTime = 12                               -- Gündüz
    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = 1000
    Lighting.FogStart = 500
    Lighting.GlobalShadows = false
    Lighting.ExposureCompensation = 0
end

-- Eğer nightmode true ise gece modunu aktif et, false ise devre dışı bırak
if nightmode then
    activateNightMode()
else
    deactivateNightMode()
end

-- Ana ayarlar
local enabled = false

-- Özelleştirilebilir değerler
local enable_custom_ammo = false
local custom_ammo_value = 500

local enable_custom_fire_rate = false
local custom_fire_rate = 0.1

local no_fire_limit = false -- MaxFire özelliği kaldırılacak mı?

-- Silahlar klasörü
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponsFolder = ReplicatedStorage:WaitForChild("Weapons")



-- Uygulama fonksiyonu
local function applyWeaponMods()
	for _, weapon in pairs(WeaponsFolder:GetChildren()) do
		if weapon:IsA("Folder") or weapon:IsA("Model") then
			local ammo = weapon:FindFirstChild("Ammo")
			local fireRate = weapon:FindFirstChild("FireRate")
			local maxFire = weapon:FindFirstChild("MaxFire")

			if enable_custom_ammo and ammo then
				ammo.Value = custom_ammo_value
			end

			if enable_custom_fire_rate and fireRate then
				fireRate.Value = custom_fire_rate
			end

			if no_fire_limit and maxFire then
				maxFire.Value = math.huge
			end
		end
	end
end

-- Sürekli kontrol
while true do
	if enabled then
		applyWeaponMods()
	end
	task.wait(0.1)
end

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
        if rd3 then  -- Eğer 3rd true ise, geçiş yapılabilir
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
if rd3 then
    isThirdPerson = true
    UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
end


local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local bunnyHopping = false
local speed = 50  -- Hareket hızı
local jumpPower = 100  -- Zıplama gücü

local canJump = true  -- Zıplama kontrolü için değişken

local function onJumpRequest()
    if bunnyHopping and canJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            return  -- Havada zıplamayı engelle
        end

        humanoid.JumpPower = jumpPower
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        canJump = false  -- Zıpladıktan sonra tekrar zıplamayı engelle
    end
end

userInputService.JumpRequest:Connect(onJumpRequest)

local function onTouchGround(hit)
    if hit:IsA("BasePart") then
        if bunnyHopping and userInputService:IsKeyDown(Enum.KeyCode.Space) then
            player.Character.Humanoid.JumpPower = jumpPower
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        canJump = true  -- Yere değdiğinde zıplamaya izin ver
    end
end

local function update()
    if bunnyHopping and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local moveDirection = Vector3.new(0, 0, 0)
        
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * speed
            player.Character.HumanoidRootPart.Velocity = Vector3.new(moveDirection.X, player.Character.HumanoidRootPart.Velocity.Y, moveDirection.Z)
        end
    end
end

-- Yere değdiğinde zıplama fonksiyonu
player.Character.HumanoidRootPart.Touched:Connect(onTouchGround)

local movementGroup = {}  -- Bu grup, menü veya toggle için kullanılabilir
movementGroup.addToggle = function(params)
    -- Toggle fonksiyonu burada tanımlanabilir
    if params.flag == "bunny_hop" then
        bunnyHopping = not bunnyHopping
    end
end
