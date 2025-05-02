-- Menü + HttpGet ile aimbot scripti import ve kontrol sistemi

-- Aimbot kodunu çek ve çalıştır
local aimbotScriptUrl = "https://raw.githubusercontent.com/berk2134/deneme/refs/heads/main/aimbot.lua?token=GHSAT0AAAAAADDGVMT2XZKSTNXQHVPU76YQ2AVKVQQ"
loadstring(game:HttpGet(aimbotScriptUrl))()

-- GUI Oluşturma
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Open = true

-- Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ZIndex = 1000

-- Aimbot Toggle
local aimbotToggle = Instance.new("TextButton", Frame)
aimbotToggle.Size = UDim2.new(1, -20, 0, 30)
aimbotToggle.Position = UDim2.new(0, 10, 0, 10)
aimbotToggle.Text = "Aimbot: Kapalı"
aimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
aimbotToggle.MouseButton1Click:Connect(function()
    getgenv().aimbot = not getgenv().aimbot
    aimbotToggle.Text = "Aimbot: " .. (getgenv().aimbot and "Açık" or "Kapalı")
end)

-- Team Check Toggle
local teamToggle = aimbotToggle:Clone()
teamToggle.Parent = Frame
teamToggle.Position = UDim2.new(0, 10, 0, 50)
teamToggle.Text = "TeamCheck: Açık"
teamToggle.MouseButton1Click:Connect(function()
    getgenv().TeamCheck = not getgenv().TeamCheck
    teamToggle.Text = "TeamCheck: " .. (getgenv().TeamCheck and "Açık" or "Kapalı")
end)

-- Show FOV Toggle
local fovToggle = teamToggle:Clone()
fovToggle.Parent = Frame
fovToggle.Position = UDim2.new(0, 10, 0, 90)
fovToggle.Text = "Show FOV: Açık"
fovToggle.MouseButton1Click:Connect(function()
    getgenv().Show_VisualFOV = not getgenv().Show_VisualFOV
    fovToggle.Text = "Show FOV: " .. (getgenv().Show_VisualFOV and "Açık" or "Kapalı")
end)

-- Smoothness Slider (basit input)
local smoothInput = Instance.new("TextBox", Frame)
smoothInput.Size = UDim2.new(1, -20, 0, 30)
smoothInput.Position = UDim2.new(0, 10, 0, 130)
smoothInput.PlaceholderText = "Smoothness (sayi gir)"
smoothInput.Text = ""
smoothInput.FocusLost:Connect(function()
    local num = tonumber(smoothInput.Text)
    if num then
        getgenv().Smoothness = num
    end
end)

-- FOV Radius Slider
local fovRadius = smoothInput:Clone()
fovRadius.Parent = Frame
fovRadius.Position = UDim2.new(0, 10, 0, 170)
fovRadius.PlaceholderText = "FOV Radius (sayi gir)"
fovRadius.FocusLost:Connect(function()
    local num = tonumber(fovRadius.Text)
    if num then
        getgenv().VisualFOV_Radius = num
    end
end)

-- Color Picker (RGB textbox)
local colorBox = fovRadius:Clone()
colorBox.Parent = Frame
colorBox.Position = UDim2.new(0, 10, 0, 210)
colorBox.PlaceholderText = "RGB renk (255,0,0)"
colorBox.FocusLost:Connect(function()
    local r, g, b = string.match(colorBox.Text, "(%d+),%s*(%d+),%s*(%d+)")
    if r and g and b then
        getgenv().VisualFOV_Color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
end)

-- INS tuşuyla menü göster/gizle
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Insert then
        Open = not Open
        Frame.Visible = Open
    end
end)
