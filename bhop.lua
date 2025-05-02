local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local bunnyHopping = false
local speed = 50  -- Hareket hızı
local jumpPower = 100  -- Zıplama gücü

local canJump = true  -- Zıplama kontrolü için değişken

local function onJumpRequest()
    if bunnyHopping and canJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            return  -- Havada zıplamayı engelle
        end

        humanoid.JumpPower = jumpPower
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        canJump = false  -- Zıpladıktan sonra tekrar zıplamayı engelle
    end
end

userInputService.JumpRequest:Connect(onJumpRequest)

local function onTouchGround(hit)
    if hit:IsA("BasePart") then
        if bunnyHopping and userInputService:IsKeyDown(Enum.KeyCode.Space) then
            player.Character.Humanoid.JumpPower = jumpPower
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        canJump = true  -- Yere değdiğinde zıplamaya izin ver
    end
end

local function update()
    if bunnyHopping and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local moveDirection = Vector3.new(0, 0, 0)
        
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * speed
            player.Character.HumanoidRootPart.Velocity = Vector3.new(moveDirection.X, player.Character.HumanoidRootPart.Velocity.Y, moveDirection.Z)
        end
    end
end

-- Yere değdiğinde zıplama fonksiyonu
player.Character.HumanoidRootPart.Touched:Connect(onTouchGround)

local movementGroup = {}  -- Bu grup, menü veya toggle için kullanılabilir
movementGroup.addToggle = function(params)
    -- Toggle fonksiyonu burada tanımlanabilir
    if params.flag == "bunny_hop" then
        bunnyHopping = not bunnyHopping
    end
end

runService.RenderStepped:Connect(update)
