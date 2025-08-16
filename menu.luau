-- ModernUILibrary.lua
-- Roblox için sade, modüler ve kolay kullanılabilen bir UI kütüphanesi

local ModernUILibrary = {}
ModernUILibrary.__index = ModernUILibrary

local function create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

function ModernUILibrary:CreateWindow(settings)
    local self = setmetatable({}, ModernUILibrary)
    self.ScreenGui = create("ScreenGui", {Name = settings.Title or "ModernUI"}, game.Players.LocalPlayer.PlayerGui)
    self.Main = create("Frame", {
        Size = UDim2.new(0, 640, 0, 460),
        Position = UDim2.new(0.5, -320, 0.5, -230),
        BackgroundColor3 = Color3.fromRGB(28,28,28),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5,0.5)
    }, self.ScreenGui)

    self.PageBar = create("Frame", {
        Size = UDim2.new(0, 60, 1, 0),
        BackgroundColor3 = Color3.fromRGB(22,22,22),
        BorderSizePixel = 0,
    }, self.Main)

    -- Logo için alan
    self.Logo = create("ImageLabel", {
        Size = UDim2.new(0, 42, 0, 42),
        Position = UDim2.new(0.5, -21, 0, 12),
        BackgroundTransparency = 1,
        Image = settings.LogoAsset or "",
    }, self.PageBar)

    -- Logo altı çizgi
    create("Frame", {
        Size = UDim2.new(0.7, 0, 0, 2),
        Position = UDim2.new(0.15, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(56,56,56),
        BorderSizePixel = 0,
    }, self.PageBar)

    self.Pages = {}
    self.PageButtons = {}
    self.VisiblePage = 1
    return self
end

function ModernUILibrary:CreatePage(settings)
    local page = {Sections = {}, SectionCount = 0}
    page.Icon = settings.Icon or ""
    local idx = #self.Pages + 1

    -- Sol bardaki ikon
    local btn = create("ImageButton", {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0.5, -18, 0, 70 + (idx-1)*46),
        BackgroundTransparency = 1,
        Image = page.Icon,
        ImageColor3 = (idx==1) and Color3.fromRGB(0,180,255) or Color3.fromRGB(140,140,140)
    }, self.PageBar)

    btn.MouseButton1Click:Connect(function()
        for i,pg in ipairs(self.Pages) do
            pg.Frame.Visible = false
            self.PageButtons[i].ImageColor3 = Color3.fromRGB(140,140,140)
        end
        page.Frame.Visible = true
        btn.ImageColor3 = Color3.fromRGB(0,180,255)
        self.VisiblePage = idx
    end)
    self.PageButtons[idx] = btn

    -- Ana Page Frame
    page.Frame = create("Frame", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 60, 0, 0),
        BackgroundTransparency = 1,
        Visible = idx == 1
    }, self.Main)

    self.Pages[idx] = page
    return setmetatable(page, {__index = ModernUILibrary})
end

function ModernUILibrary:CreateSection(settings)
    local section = {Controls = {}}
    self.SectionCount = self.SectionCount and (self.SectionCount + 1) or 1
    local x = (settings.Side == "Right") and 325 or 15
    local y = 20 + ((self.SectionCount-1) * ((settings.Size or 200) + 20))
    section.Frame = create("Frame", {
        Size = UDim2.new(0, settings.Size or 300, 0, 30),
        Position = UDim2.new(0, x, 0, y),
        BackgroundColor3 = Color3.fromRGB(36,36,36),
        BorderSizePixel = 0
    }, self.Frame)

    local title = create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 24),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = settings.Name or "Section",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    }, section.Frame)

    self.Sections = self.Sections or {}
    table.insert(self.Sections, section)
    return setmetatable(section, {__index = ModernUILibrary})
end

-- Toggle
function ModernUILibrary:CreateToggle(settings)
    local toggle = {State = settings.State or false}
    self.Controls = self.Controls or {}
    local count = #self.Controls + 1
    local frame = create("Frame", {
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, 26 * count),
        BackgroundTransparency = 1,
    }, self.Frame)

    create("TextLabel", {
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = settings.Name or "Toggle",
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local btn = create("TextButton", {
        Size = UDim2.new(0, 36, 0, 20),
        Position = UDim2.new(1, -36, 0.5, -10),
        BackgroundColor3 = toggle.State and Color3.fromRGB(0,180,255) or Color3.fromRGB(44,44,44),
        Text = "",
        BorderSizePixel = 0
    }, frame)

    local dot = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = toggle.State and UDim2.new(0, 18, 0, 3) or UDim2.new(0, 4, 0, 3),
        BackgroundColor3 = Color3.fromRGB(220,220,220),
        BorderSizePixel = 0
    }, btn)
    create("UICorner", {CornerRadius = UDim.new(0.5, 0)}, btn)
    create("UICorner", {CornerRadius = UDim.new(0.5, 0)}, dot)

    btn.MouseButton1Click:Connect(function()
        toggle.State = not toggle.State
        btn.BackgroundColor3 = toggle.State and Color3.fromRGB(0,180,255) or Color3.fromRGB(44,44,44)
        dot:TweenPosition(toggle.State and UDim2.new(0, 18, 0, 3) or UDim2.new(0, 4, 0, 3), "Out", "Quad", 0.1, true)
        if settings.Callback then settings.Callback(toggle.State) end
    end)

    table.insert(self.Controls, toggle)
    return toggle
end

-- Dropdown
function ModernUILibrary:CreateDropdown(settings)
    local dd = {Value = settings.Options[settings.Default or 1]}
    self.Controls = self.Controls or {}
    local count = #self.Controls + 1
    local frame = create("Frame", {
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, 26 * count),
        BackgroundTransparency = 1,
    }, self.Frame)

    create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = settings.Name or "Dropdown",
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local btn = create("TextButton", {
        Size = UDim2.new(0, 56, 1, 0),
        Position = UDim2.new(1, -56, 0, 0),
        BackgroundColor3 = Color3.fromRGB(44,44,44),
        Text = dd.Value,
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        BorderSizePixel = 0
    }, frame)

    btn.MouseButton1Click:Connect(function()
        local idx = table.find(settings.Options, dd.Value) or 0
        idx = idx + 1
        if idx > #settings.Options then idx = 1 end
        dd.Value = settings.Options[idx]
        btn.Text = dd.Value
        if settings.Callback then settings.Callback(dd.Value) end
    end)

    table.insert(self.Controls, dd)
    return dd
end

-- Slider
function ModernUILibrary:CreateSlider(settings)
    local slider = {Value = settings.Default or settings.Min or 0}
    self.Controls = self.Controls or {}
    local count = #self.Controls + 1
    local frame = create("Frame", {
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, 26 * count),
        BackgroundTransparency = 1,
    }, self.Frame)

    create("TextLabel", {
        Size = UDim2.new(0.5,-4,1,0),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text=settings.Name or "Slider",
        Font=Enum.Font.Gotham,
        TextColor3=Color3.fromRGB(255,255,255),
        TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left
    }, frame)
    local sliderBar = create("Frame",{
        Size=UDim2.new(0,80,0,6),
        Position=UDim2.new(0.5,0,0.5,-3),
        BackgroundColor3=Color3.fromRGB(60,60,60),
        BorderSizePixel=0
    }, frame)
    local fill = create("Frame",{
        Size=UDim2.new((slider.Value-settings.Min)/(settings.Max-settings.Min),0,1,0),
        Position=UDim2.new(0,0,0,0),
        BackgroundColor3=Color3.fromRGB(0,180,255),
        BorderSizePixel=0
    }, sliderBar)
    local amountLbl = create("TextLabel",{
        Size=UDim2.new(0,40,1,0),
        Position=UDim2.new(1,4,0,0),
        BackgroundTransparency=1,
        Text=tostring(slider.Value),
        Font=Enum.Font.Gotham,
        TextColor3=Color3.fromRGB(255,255,255),
        TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left
    }, frame)
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            local conn
            conn = game:GetService("UserInputService").InputChanged:Connect(function(changed)
                if changed.UserInputType==Enum.UserInputType.MouseMovement then
                    local relX = (changed.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                    relX = math.clamp(relX,0,1)
                    local val = settings.Min + (settings.Max-settings.Min)*relX
                    if settings.Decimals then
                        val = math.floor(val/settings.Decimals+0.5)*settings.Decimals
                    else
                        val = math.floor(val+0.5)
                    end
                    slider.Value = val
                    fill.Size = UDim2.new(relX,0,1,0)
                    amountLbl.Text = tostring(val)
                    if settings.Callback then settings.Callback(val) end
                end
            end)
            game:GetService("UserInputService").InputEnded:Connect(function(ended)
                if ended.UserInputType==Enum.UserInputType.MouseButton1 then
                    if conn then conn:Disconnect() end
                end
            end)
        end
    end)
    table.insert(self.Controls, slider)
    return slider
end

-- Button
function ModernUILibrary:CreateButton(settings)
    local btn = {}
    self.Controls = self.Controls or {}
    local count = #self.Controls + 1
    local frame = create("Frame", {
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, 26 * count),
        BackgroundTransparency = 1,
    }, self.Frame)

    local button = create("TextButton", {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = Color3.fromRGB(44,44,44),
        Text = settings.Text or settings.Name or "Button",
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BorderSizePixel = 0
    }, frame)
    button.MouseButton1Click:Connect(function()
        if settings.Callback then settings.Callback() end
    end)
    table.insert(self.Controls, btn)
    return btn
end

return ModernUILibrary
