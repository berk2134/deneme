-- norecoil değişkeni başlangıçta false
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
