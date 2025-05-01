-- Tüm silahların yayılma (Spread) değerini sıfırlamak
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
