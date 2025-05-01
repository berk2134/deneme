-- Wall hack için gerekli olan kod
-- Bu kod, oyuncuların karakterlerini duvarların arkasında bile görünür hale getirecek

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Wall hack fonksiyonu
local function enableWallHack(character)
    -- Her parça üzerinde gezin
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Şeffaflığı 0 yaparak tüm parçaları görünür hale getir
            part.Transparency = 0  -- Tam görünür
            part.CanCollide = false  -- Çarpışmayı devre dışı bırak, duvarlardan geçebilmesi için

            -- Eğer parça iskelet parçasıysa (örneğin, oyuncunun kolu, bacağı, vb.)
            if part.Name == "Head" or part.Name == "Torso" or part.Name:match("Left") or part.Name:match("Right") then
                -- İskelet parçalarını da aynı şekilde şeffaf yap
                part.Transparency = 0
            end
        end
    end
end

-- Oyuncu karakteri eklendiğinde, wall hack'i etkinleştir
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Wall hack uygulama
        enableWallHack(character)
    end)
end)

-- Oyuncu karakterleri her karede kontrol edilerek wall hack'in sürekli olarak etkin kalması sağlanır
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            enableWallHack(player.Character)
        end
    end
end)
