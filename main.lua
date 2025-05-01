-- Menü kodları
local url = "https://raw.githubusercontent.com/berk2134/deneme/main/wallhack.lua"
local wallhackCode = game:HttpGet(url, true)  -- Dosyayı URL'den alır

if not wallhackCode then
    print("Wallhack kodu yüklenemedi!")
else
    print("Wallhack kodu başarıyla yüklendi!")
end

local wallhackEnabled = false -- Başlangıçta wallhack kapalı

-- Wallhack'ı etkinleştir veya devre dışı bırak
local function toggleWallHack()
    if wallhackEnabled then
        -- Wallhack devre dışı bırakılacaksa, kodu durdurun
        print("Wallhack devre dışı bırakıldı.")
        -- Burada Wallhack'i kapatacak bir kod ekleyin (örneğin, transparanlık veya kollizyon ayarlarını geri alabilirsiniz)
    else
        -- Wallhack etkinleştir
        loadstring(wallhackCode)()  -- wallhack.lua'yi çalıştır
        print("Wallhack etkinleştirildi.")
    end
    wallhackEnabled = not wallhackEnabled  -- Durum değiştirilir
end

-- Menü ve Butonların Oluşturulması
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 600, 0, 430)
menuFrame.Position = UDim2.new(0.5, -300, 0.5, -215)
menuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui

-- Wallhack Toggle Butonu
local wallhackToggle = Instance.new("TextButton")
wallhackToggle.Size = UDim2.new(1, 0, 0, 50)
wallhackToggle.Position = UDim2.new(0, 0, 0, 0)
wallhackToggle.Text = "Toggle Wallhack"
wallhackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallhackToggle.Font = Enum.Font.GothamBold
wallhackToggle.TextSize = 20
wallhackToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
wallhackToggle.BackgroundTransparency = 0.2
wallhackToggle.Parent = menuFrame -- Menüye eklendi

-- Toggle işlevi
wallhackToggle.MouseButton1Click:Connect(function()
    toggleWallHack()  -- Butona tıklandığında wallhack fonksiyonu çalışacak
end)
