--[[
    [ Switch Hub | Blox Fruits ]
    - Giao diện: Nền Trắng, Chữ Đen (Không trong suốt)
    - Trạng thái: Cố định ở giữa phía trên, Không Stop Tween
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Xóa UI cũ nếu đã chạy trước đó
local uiName = "SwitchHub_White_Fixed_UI"
pcall(function()
    if CoreGui:FindFirstChild(uiName) then CoreGui[uiName]:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild(uiName) then LocalPlayer.PlayerGui[uiName]:Destroy() end
end)

--=========================================
-- TẠO GIAO DIỆN (UI) CỐ ĐỊNH
--=========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uiName
ScreenGui.ResetOnSpawn = false

-- Ưu tiên chèn vào CoreGui để không bị mất khi chết (nếu Executor hỗ trợ)
local s, e = pcall(function() ScreenGui.Parent = CoreGui end)
if not s then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
ToggleButton.Position = UDim2.new(0.5, 0, 0, 20) -- Cố định giữa phía trên
ToggleButton.Size = UDim2.new(0, 220, 0, 45)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14

-- THIẾT LẬP MÀU SẮC: TRẮNG CHỮ ĐEN (KHÔNG TRONG SUỐT)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Màu trắng
ToggleButton.BackgroundTransparency = 0 -- KHÔNG TRONG SUỐT
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Chữ đen
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Viền đen mảnh cho rõ nét

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ToggleButton

-- Nội dung chữ ban đầu
ToggleButton.Text = "[ Switch Hub | Blox Fruits ]\nFast Attack: OFF"

--=========================================
-- LOGIC BẬT / TẮT
--=========================================
_G.AutoAttack = false

ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoAttack = not _G.AutoAttack
    if _G.AutoAttack then
        ToggleButton.Text = "[ Switch Hub🇻🇳 | Blox Fruits ]\nFast Attack: ON"
    else
        ToggleButton.Text = "[ Switch Hub🇻🇳 | Blox Fruits ]\nFast Attack: OFF"
    end
end)

--=========================================
-- CORE SCRIPT FAST ATTACK
--=========================================
local v1 = next
local v2 = {
    game:GetService("ReplicatedStorage").Util,
    game:GetService("ReplicatedStorage").Common,
    game:GetService("ReplicatedStorage").Remotes,
    game:GetService("ReplicatedStorage").Assets,
    game:GetService("ReplicatedStorage").FX,
}
local v3, u4, u5 = nil, nil, nil

-- Lấy RemoteID
task.spawn(function()
    while true do
        local v6
        v3, v6 = v1(v2, v3)
        if v3 == nil then break end
        for _, v10 in pairs(v6:GetChildren()) do
            if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then
                u5 = v10:GetAttribute('Id')
                u4 = v10
            end
        end
    end
end)

-- Vòng lặp tấn công
task.spawn(function()
    while task.wait(0.0001) do
        if _G.AutoAttack then
            local _Character = LocalPlayer.Character
            local v13 = _Character and _Character:FindFirstChild('HumanoidRootPart')

            if v13 then
                local u17 = {}
                local targets = {workspace.Enemies, workspace.Characters}
                
                for _, folder in pairs(targets) do
                    for _, v22 in pairs(folder:GetChildren()) do
                        local _Humanoid = v22:FindFirstChild('Humanoid')
                        local _HRP = v22:FindFirstChild('HumanoidRootPart')
                        
                        if v22 ~= _Character and _HRP and _Humanoid and _Humanoid.Health > 0 then
                            local dist = (_HRP.Position - v13.Position).Magnitude
                            if dist <= 60 then
                                for _, part in pairs(v22:GetChildren()) do
                                    if part:IsA('BasePart') then
                                        table.insert(u17, {v22, part})
                                    end
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
                            game.ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                            u4:FireServer(string.gsub('RE/RegisterHit', '.', function(p31)
                                return string.char(bit32.bxor(string.byte(p31), math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1))
                            end), bit32.bxor(u5 + 909090, game.ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17)
                        end
                    end)
                end
            end
        end
    end
end)
