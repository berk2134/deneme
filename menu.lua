local fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/SypherPK/FluentUI/main/source.lua"))()

-- Fluent menü penceresi
local Window = fluent.createWindow({
    name = "Vortex Premium",
    width = 600,
    height = 450,
    position = UDim2.new(0.5, -300, 0.5, -215),
    draggable = true,
    resizable = false,
    backgroundColor = Color3.fromRGB(25, 25, 25)
})

-- Sekme ekleme
local tabAimbot = Window:addTab("Aimbot")
tabAimbot:addButton("Enable Aimbot", function()
    print("Aimbot Enabled")
end)

tabAimbot:addToggle("Aimbot Toggle", false, function(state)
    if state then
        print("Aimbot Activated")
    else
        print("Aimbot Deactivated")
    end
end)

tabAimbot:addSlider("FOV Slider", 50, 180, 90, 1, function(value)
    print("FOV: " .. value)
end)
