local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Ayarlar
local BoxColor = Color3.fromRGB(255, 0, 0) -- Box renk
local TracerColor = Color3.fromRGB(0, 255, 0) -- Tracer çizgisi rengi
local BoxThickness = 2
local eTeamCheck = false
local ShowNames = false
local ShowTracers = true  -- Tracer'ları aktif etmek için
local Box = true  -- Box'ı aktif edebilmek için

-- ESP tabloları
local espBoxes = {}
local nameTags = {}
local tracers = {}

local function removeESP(player)
    if espBoxes[player] then
        espBoxes[player]:Remove()
        espBoxes[player] = nil
    end
    if nameTags[player] then
        nameTags[player]:Remove()
        nameTags[player] = nil
    end
    if tracers[player] then
        tracers[player]:Remove()
        tracers[player] = nil
    end
end

local function UpdateESP(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Head") then
        removeESP(player)
        return
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        removeESP(player)
        return
    end

    if eTeamCheck and player.Team == LocalPlayer.Team then
        removeESP(player)
        return
    end

    local hrp = char.HumanoidRootPart
    local head = char.Head

    local headPos, onScreen1 = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.3, 0))
    local footPos, onScreen2 = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.8, 0))

    if onScreen1 and onScreen2 then
        local height = math.abs(headPos.Y - footPos.Y)
        local width = height / 2
        local x = headPos.X - width / 2
        local y = headPos.Y

        -- Box'ı çizme işlemi sadece Box değişkeni aktifse yapılır
        if Box then
            if not espBoxes[player] then
                local box = Drawing.new("Quad")
                box.Thickness = BoxThickness
                box.Color = BoxColor
                box.Transparency = 1
                box.Filled = false
                box.Visible = true
                espBoxes[player] = box
            end

            local box = espBoxes[player]
            box.PointA = Vector2.new(x, y)
            box.PointB = Vector2.new(x + width, y)
            box.PointC = Vector2.new(x + width, y + height)
            box.PointD = Vector2.new(x, y + height)
            box.Visible = true
        end

        -- İsimler gösterilsin mi?
        if ShowNames then
            if not nameTags[player] then
                local tag = Drawing.new("Text")
                tag.Size = 14
                tag.Center = true
                tag.Outline = true
                tag.Color = Color3.new(1, 1, 1)
                tag.OutlineColor = Color3.new(0, 0, 0)
                tag.Visible = true
                nameTags[player] = tag
            end
            local tag = nameTags[player]
            tag.Position = Vector2.new(x + width / 2, y - 14)
            tag.Text = player.Name
            tag.Visible = true
        end

        -- Tracerlar gösterilsin mi?
        if ShowTracers then
            if not tracers[player] then
                local tracer = Drawing.new("Line")
                tracer.Thickness = 1
                tracer.Color = TracerColor  -- Tracer rengini burada belirliyoruz
                tracer.Transparency = 1
                tracer.Visible = true
                tracers[player] = tracer
            end
            local tracer = tracers[player]
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(x + width / 2, y + height)
            tracer.Visible = true
        end
    else
        removeESP(player)
    end
end

-- Render loop
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            UpdateESP(player)
        end
    end
end)

-- Oyuncu eklenince karakter geldiğinde ESP başlat
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        UpdateESP(player)
    end)
end)

-- Oyuncu çıkarsa kutuyu kaldır
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)
