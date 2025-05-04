-- Ana ayarlar
local enabled = true

-- Özelleştirilebilir değerler
local enable_custom_ammo = true
local custom_ammo_value = 500

local enable_custom_fire_rate = true
local custom_fire_rate = 0.1

local no_fire_limit = true -- MaxFire özelliği kaldırılacak mı?

-- Silahlar klasörü
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponsFolder = ReplicatedStorage:WaitForChild("Weapons")

-- Uygulama fonksiyonu
local function applyWeaponMods()
	for _, weapon in pairs(WeaponsFolder:GetChildren()) do
		if weapon:IsA("Folder") or weapon:IsA("Model") then
			local ammo = weapon:FindFirstChild("Ammo")
			local fireRate = weapon:FindFirstChild("FireRate")
			local maxFire = weapon:FindFirstChild("MaxFire")

			if enable_custom_ammo and ammo then
				ammo.Value = custom_ammo_value
			end

			if enable_custom_fire_rate and fireRate then
				fireRate.Value = custom_fire_rate
			end

			if no_fire_limit and maxFire then
				maxFire.Value = math.huge
			end
		end
	end
end

-- Sürekli kontrol
while true do
	if enabled then
		applyWeaponMods()
	end
	task.wait(0.1)
end
