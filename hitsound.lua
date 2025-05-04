local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- 🔧 Ayar: Hitsound aktif olsun mu?
local hitsound = true

if hitsound then
	-- 🔊 Daha güçlü skeet-style hitsound tanımı
	local hitSound = Instance.new("Sound")
	hitSound.Name = "HitSound"
	hitSound.SoundId = "rbxassetid://8255306220" -- Bu daha tok, skeet'e daha yakın bir "ding"
	hitSound.Volume = 14
	hitSound.PlayOnRemove = false
	hitSound.RollOffMaxDistance = 100000
	hitSound.EmitterSize = 100000
	hitSound.Parent = SoundService

	print("✅ Skeet hitsound aktif. RemoteEvent'ler taranıyor...")

	for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
		if remote:IsA("RemoteEvent") then
			remote.OnClientEvent:Connect(function(...)
				local args = {...}
				for _, v in ipairs(args) do
					if typeof(v) == "Instance" and v:IsA("Player") and v ~= LocalPlayer then
						local clonedSound = hitSound:Clone()
						clonedSound.Parent = SoundService
						clonedSound:Play()
						game.Debris:AddItem(clonedSound, 2)
						print("🔔 HitSound çaldı! Oyuncu: " .. v.Name)
					end
				end
			end)
		end
	end
else
	print("❌ Hitsound devre dışı bırakıldı.")
end
