local workspace = game:GetService("Workspace")

-- Tüm partları saydam yapma fonksiyonu
local function makeAllPartsTransparent()
    -- Workspace'teki tüm parçaları kontrol et
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("Part") then
            -- Tüm parçaların saydamlık seviyesini ayarla
            part.Transparency = 0.5 -- 0.5 değeri yarı saydam yapar, 1 tam saydam
            part.CanCollide = false -- Geçilebilir kıl
        end
    end
end

-- Tüm partları saydam yapma
makeAllPartsTransparent()

-- İstenirse tüm partları tekrar opak hale getirmek için:
local function resetAllParts()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("Part") then
            -- Tüm parçaların saydamlık seviyesini geri al
            part.Transparency = 0
            part.CanCollide = true -- Çarpışmayı aktif tut
        end
    end
end

-- Bu fonksiyonu istediğiniz zaman çağırarak saydamlık seviyesini sıfırlayabilirsiniz.
