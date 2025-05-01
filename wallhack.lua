local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Box ESP fonksiyonu
local function createBoxESP(character)
    -- Önce eski box'ı kaldır (varsa)
    if character:FindFirstChild("ESPBox") then
        character.ESPBox:Destroy()
    end

    -- Yeni bir box oluşturuluyor
    local box = Instance.new("Part")
    box.Name = "ESPBox"
    box.Size = Vector3.new(4, 6, 2)  -- Boyutlarını karakterin büyüklüğüne göre ayarlayın
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 0.5
    box.BrickColor = BrickColor.new("Bright red")
    box.Parent = character

    -- Box'ı oyuncunun karakterine göre yerleştir
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    box.CFrame = humanoidRootPart.CFrame

    -- Box'ın sürekli olarak oyuncunun etrafında kalmasını sağla
    RunService.RenderStepped:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            box.CFrame = humanoidRootPart.CFrame
        end
    end)
end

-- Oyuncu karakteri eklendiğinde box ESP'yi etkinleştir
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Wallhack ve Box ESP'yi uygulama
        createBoxESP(character)
    end)
end)

-- Her karede karakterlerin etrafındaki kutuların güncellenmesi
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local character = player.Character
            if character:FindFirstChild("HumanoidRootPart") and not character:FindFirstChild("ESPBox") then
                -- Yeni oyuncu eklendiyse, kutuyu oluştur
                createBoxESP(character)
            end
        end
    end
end)
