--[[
    [ Switch Hub | Blox Fruits ]
    - Cấu hình: Nút trắng (60% opaque / 40% transparent), Chữ đen.
    - Trạng thái: Cố định (Không di chuyển), Không Stop Tween.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Xóa UI cũ nếu tồn tại
local uiName = "SwitchHub_Final_UI"
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
local s, e = pcall(function() ScreenGui.Parent = CoreGui end)
if not s then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
ToggleButton.Position = UDim2.new(0.5, 0, 0, 20) -- Cố định ở giữa phía trên
ToggleButton.Size = UDim2.new(0, 220, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14

-- THIẾT LẬP MÀU SẮC THEO YÊU CẦU
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Màu trắng
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Chữ màu đen
ToggleButton.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Nội dung chữ
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
