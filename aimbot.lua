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
local Show_VisualFOV = true
local AimBot_FOV_Radius = VisualFOV_Radius

local aimbot = true
local isLeftClicking = false
local TeamCheck = true
local visibility = true -- 👈 GÖRÜNÜRLÜK KONTROLÜ BURADA

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
