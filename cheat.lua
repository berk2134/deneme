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
local visibility = false -- 👈 GÖRÜNÜRLÜK KONTROLÜ BURADA

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
local function isPartVisibleOnScreen(part)
	local partPos, onScreen = Camera:WorldToViewportPoint(part.Position)
	if not onScreen then return false end

	local origin = Camera.CFrame.Position
	local direction = (part.Position - origin)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, rayParams)

	if result and result.Instance and part:IsDescendantOf(result.Instance.Parent) then
		return true
	end
	return false
end

-- 📷 Ekran tabanlı tarama: Görünen herhangi bir parça varsa true döner
local function isVisibleOnScreen(character)
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			if isPartVisibleOnScreen(part) then
				return true
			end
		end
	end
	return false
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

			local character = player.Character
			local head = character.Head
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 then
				if isInAimBotFOV(head.Position) then
					if visibility and not isVisibleBody(character) then
						continue
					end

					local screenPoint = Camera:WorldToViewportPoint(head.Position)
					local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude

					if distance < shortestDistance then
						shortestDistance = distance
						closest = head -- 🎯 Her zaman kafaya kilitleniyoruz
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

-- GUI kütüphanesi yükleniyor
local rawLibrary = game:GetObjects("rbxassetid://7657867786")[1].Source
rawLibrary = rawLibrary:gsub("ImageLabel.*Logo.*", "") -- Logo kaldırıldı
local library = loadstring(rawLibrary)()

-- UI kurulumu
local PepsisWorld = library:CreateWindow({
	Name = "Vortex Premium - https://discord.gg/B2FAHtRufp",
	Themeable = { Info = "" }
})

local AimbotTab = PepsisWorld:CreateTab({ Name = "Aimbot" })
local AimbotSection = AimbotTab:CreateSection({ Name = "Aimbot Toggles" })
local AimbotSettingsSection = AimbotTab:CreateSection({ Name = "Aimbot Settings" })

-- UI kontrolleri
AimbotSection:AddToggle({
	Name = "Aimbot",
	Flag = "Aimbot_Enabled",
	Callback = function(state)
		aimbot = state
		print("Aimbot:", aimbot and "Aktif" or "Pasif")
	end
})

AimbotSection:AddToggle({
	Name = "TeamCheck",
	Flag = "Aimbot_TeamCheck",
	Callback = function(state)
		TeamCheck = state
		print("TeamCheck:", TeamCheck and "Aktif" or "Pasif")
	end
})

AimbotSection:AddToggle({
	Name = "Visibility Check",
	Flag = "Aimbot_Visibility",
	Callback = function(state)
		visibility = state
		print("Visibility Check:", visibility and "Aktif" or "Pasif")
	end
})

AimbotSection:AddToggle({
	Name = "Draw FOV",
	Flag = "Aimbot_DrawFOV",
	Callback = function(state)
		Show_VisualFOV = state
		drawVisualFOV()
	end
})

AimbotSection:AddColorPicker({
	Name = "FOV Renk",
	Flag = "Aimbot_FOVColor",
	Value = VisualFOV_Color,
	Callback = function(color)
		VisualFOV_Color = color
		if fovCircle then fovCircle.Color = color end
	end
})

AimbotSettingsSection:AddSlider({
	Name = "FOV Yarıçapı",
	Flag = "Aimbot_FOVRadius",
	Value = VisualFOV_Radius,
	Min = 10,
	Max = 360,
	Callback = function(value)
		VisualFOV_Radius = value
		AimBot_FOV_Radius = value
	end,
	Format = function(value)
		return "FOV Radius: " .. tostring(value)
	end
})
