local nightmode = false  -- Gece modunu aktif etmek için bu değeri true yapabilirsiniz

local Lighting = game:GetService("Lighting")

-- Skybox oluştur (dolunay havası için mavi-gri tonlar)
local sky = Instance.new("Sky")
sky.SkyboxBk = "http://www.roblox.com/asset/?id=159454299"
sky.SkyboxDn = "http://www.roblox.com/asset/?id=159454296"
sky.SkyboxFt = "http://www.roblox.com/asset/?id=159454293"
sky.SkyboxLf = "http://www.roblox.com/asset/?id=159454300"
sky.SkyboxRt = "http://www.roblox.com/asset/?id=159454297"
sky.SkyboxUp = "http://www.roblox.com/asset/?id=159454294"
sky.MoonAngularSize = 11
sky.StarCount = 3000
sky.Parent = Lighting

-- Gece modunu aktif etme fonksiyonu
local function activateNightMode()
    Lighting.Ambient = Color3.fromRGB(30, 30, 50)         -- Ortam rengi
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 70)  -- Dış mekan aydınlatması
    Lighting.Brightness = 1
    Lighting.ClockTime = 0                               -- Gece
    Lighting.FogColor = Color3.fromRGB(20, 20, 30)
    Lighting.FogEnd = 500
    Lighting.FogStart = 100
    Lighting.GlobalShadows = true
    Lighting.ExposureCompensation = 0.1
end

-- Gece modunu devre dışı bırakma fonksiyonu
local function deactivateNightMode()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)       -- Ortam rengi
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) -- Dış mekan aydınlatması
    Lighting.Brightness = 2
    Lighting.ClockTime = 12                               -- Gündüz
    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = 1000
    Lighting.FogStart = 500
    Lighting.GlobalShadows = false
    Lighting.ExposureCompensation = 0
end

-- Eğer nightmode true ise gece modunu aktif et, false ise devre dışı bırak
if nightmode then
    activateNightMode()
else
    deactivateNightMode()
end

-- Gece modunu değiştirecek bir Toggle eklemek isterseniz:
Tabs.Others:AddToggle("NightMode", {
    Title = "Gece Modu",
    Default = nightmode
}):OnChanged(function(value)
    nightmode = value
    if nightmode then
        activateNightMode()
    else
        deactivateNightMode()
    end
end)
