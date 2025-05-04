-- ReplicatedStorage'deki Weapons klasörünü alıyoruz
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponsFolder = ReplicatedStorage:WaitForChild("Weapons")

-- Sonsuz mermi sağlamak ve ateşleme sınırını kaldırmak için fonksiyon
local function removeFireLimit()
    -- Tüm silahları kontrol ediyoruz
    for _, weapon in pairs(WeaponsFolder:GetChildren()) do
        -- Silahın "Ammo" adında bir özelliği varsa
        local ammo = weapon:FindFirstChild("Ammo")
        local fireRate = weapon:FindFirstChild("FireRate") -- Ateşleme hızını kontrol et
        local maxFire = weapon:FindFirstChild("MaxFire") -- Eğer varsa, max ateşleme sınırını kontrol et

        -- Ammo, FireRate ve MaxFire varsa işlemleri uyguluyoruz
        if ammo then
            -- Ammo'yu sonsuza kadar yapıyoruz
            ammo.Value = 9999
        end

        if fireRate then
            -- FireRate'i değiştirebiliriz, ancak genellikle bu değer düşük tutulur. Sınırsız yapabiliriz.
            fireRate.Value = 0 -- Bu, kesintisiz ateş etme sağlar 
        end

        if maxFire then
            -- MaxFire'ı kaldırıyoruz, böylece ateşleme sınırlaması olmadan silah sıkabilir
            maxFire.Value = math.huge -- Sonsuz bir değere ayarlıyoruz
        end
    end
end

-- Sonsuz mermi ve ateşleme sınırını kaldırmak için sürekli olarak her 0.1 saniyede bir tekrar çalıştırıyoruz
while true do
    removeFireLimit()
    wait(0.1) -- 0.1 saniyede bir tekrar
end
