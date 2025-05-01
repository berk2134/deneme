local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Scripti çalıştıran kişi
local localPlayer = game.Players.LocalPlayer

-- Box ESP için gerekli GUI elemanlarını oluşturuyoruz
local function create2DESPBox(player)
    -- Eğer oyuncunun karakteri varsa
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Player GUI'sine bir ekran kutusu ekliyoruz
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = localPlayer.PlayerGui
        
        -- 2D Box (Kutu) eklemek için
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 100, 0, 100)  -- Kutu boyutunu ayarlıyoruz
        box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Kutu rengini kırmızı yapıyoruz
        box.BorderSizePixel = 2
        box.Parent = screenGui

        -- Box'ın pozisyonunu karakterin pozisyonuna göre ayarlıyoruz
        local function updateBoxPosition()
            local playerCharacter = player.Character
            if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = game:GetService("Players").LocalPlayer:FindPartOnScreen(playerCharacter.HumanoidRootPart)
                if onScreen then
                    -- Box'ı ekran koordinatlarına göre hareket ettiriyoruz
                    box.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                else
                    -- Eğer ekranın dışında ise kutuyu gizliyoruz
                    box.Visible = false
                end
            end
        end
        
        -- Her karede kutuyu güncelle
        RunService.RenderStepped:Connect(function()
            updateBoxPosition()
        end)
    end
end

-- Her oyuncu eklenince, onun için ESP kutusunu oluşturuyoruz
Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then
        create2DESPBox(player)
    end
end)

-- Oyun başladığında (veya script yüklendiğinde), var olan tüm oyuncular için 2D kutuları ekle
for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        create2DESPBox(player)
    end
end)
