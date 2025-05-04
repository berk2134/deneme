local Workspace = game:GetService("Workspace")

-- XRay'i açıp kapatmak için burayı kullan
local xray = true

if xray then
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") then
            -- Örnek: uzun parçaları 'duvar' kabul ediyoruz
            if part.Size.Y > 6 then
                part.Transparency = 1      -- tamamen görünmez yap
                part.CanCollide = true     -- çarpışmayı açık bırak

                -- Eğer daha önce eklenmemişse SelectionBox oluştur
                if not part:FindFirstChild("XRayOutline") then
                    local outline = Instance.new("SelectionBox")
                    outline.Name = "XRayOutline"
                    outline.Adornee = part
                    outline.LineThickness = 0.02
                    outline.Color3 = Color3.fromRGB(0, 0, 0)
                    outline.SurfaceColor3 = Color3.new(0, 0, 0)
                    outline.SurfaceTransparency = 1
                    outline.Parent = part
                end
            end
        end
    end
end
