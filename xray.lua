local Workspace = game:GetService("Workspace")

for _, part in ipairs(Workspace:GetDescendants()) do
    if part:IsA("Part") then
        -- Eğer duvar benzeri bir şeyse (dilersen boyut veya isimle filtreleyebilirsin)
        if part.Size.Y > 6 then -- örnek olarak uzun parçaları 'duvar' sayıyoruz
            part.Transparency = 1      -- tamamen görünmez yap
            part.CanCollide = true     -- geçilmesin (istersen false yapabilirsin)

            -- Zaten SelectionBox varsa tekrar oluşturma
            if not part:FindFirstChild("XRayOutline") then
                local outline = Instance.new("SelectionBox")
                outline.Name = "XRayOutline"
                outline.Adornee = part
                outline.LineThickness = 0.02 -- Daha ince çizgi kalınlığı (değeri küçülttük)
                outline.Color3 = Color3.fromRGB(0, 0, 0) -- Siyah outline
                outline.SurfaceColor3 = Color3.new(0, 0, 0)
                outline.SurfaceTransparency = 1 -- içi tamamen saydam
                outline.Parent = part
            end
        end
    end
end
