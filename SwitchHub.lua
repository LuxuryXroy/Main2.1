--========================================================================
-- Tên: [ Switch Hub | Blox Fruits ] - Fast Attack Standalone
-- Tính năng: Fast Attack + Nút Bật/Tắt trên màn hình + Hỗ trợ Dừng Tween
--========================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Xóa UI cũ nếu chạy lại script nhiều lần
local guiName = "SwitchHub_FastAttackUI"
local success = pcall(function()
    if CoreGui:FindFirstChild(guiName) then
        CoreGui[guiName]:Destroy()
    end
end)
if not success then
    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
        LocalPlayer.PlayerGui[guiName]:Destroy()
    end
end

--=========================================
-- TẠO GIAO DIỆN (UI) Ở GIỮA TRÊN MÀN HÌNH
--=========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false

-- Fallback nếu executor không hỗ trợ CoreGui
local s, e = pcall(function() ScreenGui.Parent = CoreGui end)
if not s then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
ToggleButton.Position = UDim2.new(0.5, 0, 0, 15) -- Giữa màn hình, cách mép trên 15px
ToggleButton.Size = UDim2.new(0, 250, 0, 45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Màu đỏ (Mặc định là TẮT)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "[ Switch Hub | Blox Fruits ]\nFast Attack: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Tính năng kéo thả UI (Drag)
local dragging, dragInput, dragStart, startPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--=========================================
-- HÀM DỪNG TẤT CẢ TWEEN/HOẠT ĐỘNG KHÁC
--=========================================
local function StopAllActivity()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        
        -- Dừng Tween bằng cách neo nhân vật lại trong khoảnh khắc
        hrp.Anchored = true
        task.wait(0.1)
        hrp.Anchored = false
        
        -- Xóa các BodyMover di chuyển nhân vật (thường được dùng bởi các Hub Auto Farm)
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyPosition") or v:IsA("LinearVelocity") or v:IsA("AlignPosition") then
                v:Destroy()
            end
        end
    end
end

--=========================================
-- LOGIC BẬT / TẮT
--=========================================
_G.AutoAttack = false

ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoAttack = not _G.AutoAttack
    
    if _G.AutoAttack then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Chuyển xanh
        ToggleButton.Text = "[ Switch Hub | Blox Fruits ]\nFast Attack: ON"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Chuyển đỏ
        ToggleButton.Text = "[ Switch Hub | Blox Fruits ]\nFast Attack: OFF"
        -- Gọi hàm dừng Tween khi tắt
        StopAllActivity()
    end
end)

--=========================================
-- CORE SCRIPT FAST ATTACK (TỪ CODE CỦA BẠN)
--=========================================
local v1 = next
local v2 = {
    game:GetService("ReplicatedStorage").Util,
    game:GetService("ReplicatedStorage").Common,
    game:GetService("ReplicatedStorage").Remotes,
    game:GetService("ReplicatedStorage").Assets,
    game:GetService("ReplicatedStorage").FX,
}
local v3 = nil
local u4 = nil
local u5 = nil

-- Cho vòng lặp lấy Remote vào task.spawn để không bị treo giao diện
task.spawn(function()
    while true do
        local v6
        v3, v6 = v1(v2, v3)

        if v3 == nil then
            break
        end

        local v7 = next
        local v8, v9 = v6:GetChildren()

        while true do
            local v10

            v9, v10 = v7(v8, v9)

            if v9 == nil then
                break
            end
            if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then
                u5 = v10:GetAttribute('Id')
                u4 = v10
            end
        end

        v6.ChildAdded:Connect(function(p11)
            if p11:IsA('RemoteEvent') and p11:GetAttribute('Id') then
                u5 = p11:GetAttribute('Id')
                u4 = p11
            end
        end)
    end
end)

-- Vòng lặp tấn công
task.spawn(function()
    while task.wait(0.0001) do
        -- Chỉ thực thi nếu bật UI
        if _G.AutoAttack then
            local _Character = game.Players.LocalPlayer.Character
            local v13

            if _Character then
                v13 = _Character:FindFirstChild('HumanoidRootPart')
            else
                v13 = _Character
            end

            local v14, v15, v16 = ipairs({
                workspace.Enemies,
                workspace.Characters,
            })
            local u17 = {}

            if v13 then -- Đảm bảo HRP tồn tại để tránh lỗi
                while true do
                    local v18
                    v16, v18 = v14(v15, v16)

                    if v16 == nil then
                        break
                    end

                    local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})

                    while true do
                        local v22
                        v21, v22 = v19(v20, v21)

                        if v21 == nil then
                            break
                        end

                        local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart')
                        local _Humanoid = v22:FindFirstChild('Humanoid')

                        if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60))) then
                            local v25, v26, v27 = ipairs(v22:GetChildren())

                            while true do
                                local v28
                                v27, v28 = v25(v26, v27)

                                if v27 == nil then
                                    break
                                end
                                if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60 then
                                    u17[#u17 + 1] = {v22, v28}
                                end
                            end
                        end
                    end
                end

                local _Tool = _Character:FindFirstChildOfClass('Tool')

                if #u17 > 0 and (_Tool and (_Tool:GetAttribute('WeaponType') == 'Melee' or _Tool:GetAttribute('WeaponType') == 'Sword')) then
                    pcall(function()
                        require(game.ReplicatedStorage.Modules.Net):RemoteEvent('RegisterHit', true)
                        game.ReplicatedStorage.Modules.Net['RE/RegisterAttack']:FireServer()

                        local _Head = u17[1][1]:FindFirstChild('Head')

                        if _Head and u4 and u5 then
                            game.ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(game.Players.LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                            cloneref(u4):FireServer(string.gsub('RE/RegisterHit', '.', function(p31)
                                return string.char(bit32.bxor(string.byte(p31), math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1))
                            end), bit32.bxor(u5 + 909090, game.ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17)
                        end
                    end)
                end
            end
        end
    end
end)
