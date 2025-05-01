local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Ana Menü
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 600, 0, 430)
menuFrame.Position = UDim2.new(0.5, -300, 0.5, -215)
menuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui

-- Header (Vortex Premium)
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 30)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
header.Text = "Vortex Premium"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.TextStrokeTransparency = 0.8
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = menuFrame

local contentOffsetY = 30

-- Sol Panel (tam 4 buton kaplayacak şekilde)
local totalButtons = 4
local buttonHeight = 100
local leftPanelHeight = totalButtons * buttonHeight

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 100, 0, leftPanelHeight)
leftPanel.Position = UDim2.new(0, 0, 0, contentOffsetY)
leftPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
leftPanel.Parent = menuFrame

-- Sağ Panel
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -100, 1, -contentOffsetY)
rightPanel.Position = UDim2.new(0, 100, 0, contentOffsetY)
rightPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rightPanel.BackgroundTransparency = 0.8
rightPanel.Parent = menuFrame

-- Sekmeler ve içerikler
local tabs = {
    {icon = "🎯", label = "Aimbot"},
    {icon = "👁", label = "Wallhack"},
    {icon = "👟", label = "Movement"},
    {icon = "⚙", label = "Misc"},
}

local tabLabels = {}

for i, tabInfo in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, buttonHeight)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * buttonHeight)
    button.Text = tabInfo.icon
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBlack
    button.TextSize = 30
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.2
    button.Parent = leftPanel

    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, 0, 1, 0)
    tabLabel.Text = tabInfo.label .. " Section"
    tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabLabel.Font = Enum.Font.Gotham
    tabLabel.TextSize = 25
    tabLabel.BackgroundTransparency = 1
    tabLabel.Visible = false
    tabLabel.Parent = rightPanel

    tabLabels[i] = tabLabel

    button.MouseButton1Click:Connect(function()
        for _, l in pairs(tabLabels) do
            l.Visible = false
        end
        tabLabel.Visible = true
    end)
end

tabLabels[1].Visible = true

-- Gökkuşağı Kenarlıklar
local borders = {}

for i = 1, 4 do
    local border = Instance.new("Frame")
    border.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    border.BorderSizePixel = 0
    border.ZIndex = 2
    border.Parent = menuFrame

    if i == 1 then -- üst
        border.Size = UDim2.new(1, 0, 0, 2)
        border.Position = UDim2.new(0, 0, 0, 0)
    elseif i == 2 then -- alt
        border.Size = UDim2.new(1, 0, 0, 2)
        border.Position = UDim2.new(0, 0, 1, -2)
    elseif i == 3 then -- sol
        border.Size = UDim2.new(0, 2, 1, 0)
        border.Position = UDim2.new(0, 0, 0, 0)
    elseif i == 4 then -- sağ
        border.Size = UDim2.new(0, 2, 1, 0)
        border.Position = UDim2.new(1, -2, 0, 0)
    end

    table.insert(borders, border)
end

-- Gökkuşağı animasyonu
local function rainbowCycle()
    local hue = 0
    while true do
        local color = Color3.fromHSV(hue, 1, 1)
        for _, b in pairs(borders) do
            b.BackgroundColor3 = color
        end
        hue = (hue + 0.01) % 1
        wait(0.03)
    end
end

spawn(rainbowCycle)
