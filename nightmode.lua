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

-- Lighting ayarları (ay ışığı efekti)
Lighting.Ambient = Color3.fromRGB(30, 30, 50)         -- Ortam rengi
Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 70)  -- Dış mekan aydınlatması
Lighting.Brightness = 1
Lighting.ClockTime = 0                               -- Gece
Lighting.FogColor = Color3.fromRGB(20, 20, 30)
Lighting.FogEnd = 500
Lighting.FogStart = 100
Lighting.GlobalShadows = true
Lighting.ExposureCompensation = 0.1
