-- PvP Script GUI V2 (Modern + Mobile + PS4 Ready)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Anti-Load Check
if getgenv().PvP_GUI_V2 then return end
getgenv().PvP_GUI_V2 = true

-- Variables
local ESP = {}
local aimbotEnabled = false
local espEnabled = false
local fov = 200
local smooth = 0.1

-- 🎨 Modern GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PvP_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = game.CoreGui

-- Main Frame (Draggable + Animated)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 380)
Frame.Position = UDim2.new(0.5, -160, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Gradient + Corner + Stroke
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 35))
}
Gradient.Rotation = 45
Gradient.Parent = Frame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 150, 255)
Stroke.Thickness = 2.5
Stroke.Parent = Frame

-- ✨ Header Animado
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ PvP V2 - Ultimate"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextStrokeTransparency = 0.7
Title.TextStrokeColor3 = Color3.fromRGB(100, 150, 255)
Title.Parent = Frame

-- Minimize Button (X flutuante)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 8)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 22
MinimizeBtn.Parent = Frame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Status Labels
local StatusESP = Instance.new("TextLabel")
StatusESP.Size = UDim2.new(0.45, 0, 0, 35)
StatusESP.Position = UDim2.new(0, 15, 0, 65)
StatusESP.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
StatusESP.Text = "👁️ ESP: OFF"
StatusESP.TextColor3 = Color3.new(1,0.6,0.6)
StatusESP.Font = Enum.Font.GothamSemibold
StatusESP.TextSize = 15
StatusESP.Parent = Frame

local StatusAim = Instance.new("TextLabel")
StatusAim.Size = UDim2.new(0.45, 0, 0, 35)
StatusAim.Position = UDim2.new(0.55, 0, 0, 65)
StatusAim.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
StatusAim.Text = "🎯 Aimbot: OFF"
StatusAim.TextColor3 = Color3.new(1,0.6,0.6)
StatusAim.Font = Enum.Font.GothamSemibold
StatusAim.TextSize = 15
StatusAim.Parent = Frame

local StatusCorner1 = Instance.new("UICorner")
StatusCorner1.CornerRadius = UDim.new(0, 8)
StatusCorner1.Parent = StatusESP

local StatusCorner2 = Instance.new("UICorner")
StatusCorner2.CornerRadius = UDim.new(0, 8)
StatusCorner2.Parent = StatusAim

-- 🎮 Modern Toggle Buttons
local function createToggle(name, posY, callback, statusLabel)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 50)
    frame.Position = UDim2.new(0, 20, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    frame.Parent = Frame
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 12)
    fCorner.Parent = frame
    
    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(70, 70, 90)
    fStroke.Thickness = 1
    fStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 32)
    toggle.Position = UDim2.new(1, -60, 0.5, -16)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.Parent = frame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 8)
    tCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        local enabled = not callback()
        callback(enabled)
        
        local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
        if enabled then
            TweenService:Create(toggle, tween, {
                BackgroundColor3 = Color3.fromRGB(80, 200, 80),
                Text = "ON"
            }):Play()
            TweenService:Create(statusLabel, tween, {
                BackgroundColor3 = Color3.fromRGB(80, 200, 80),
                TextColor3 = Color3.new(1,1,1)
            }):Play()
        else
            TweenService:Create(toggle, tween, {
                BackgroundColor3 = Color3.fromRGB(80, 40, 120),
                Text = "OFF"
            }):Play()
            TweenService:Create(statusLabel, tween, {
                BackgroundColor3 = Color3.fromRGB(80, 40, 120),
                TextColor3 = Color3.new(1,0.6,0.6)
            }):Play()
        end
    end)
    
    return frame
end

-- ESP System (Melhorado)
local function toggleESP(enabled)
    espEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if not plr.Character.Head:FindFirstChild("PvP_ESP") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "PvP_ESP"
                    billboard.Parent = plr.Character.Head
                    billboard.Size = UDim2.new(0, 120, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    
                    local stroke = Instance.new("UIStroke", billboard)
                    stroke.Thickness = 2
                    stroke.Color = Color3.fromRGB(255, 50, 50)
                    
                    local nameLabel = Instance.new("TextLabel", billboard)
                    nameLabel.Size = UDim2.new(1, -10, 0.6, 0)
                    nameLabel.Position = UDim2.new(0, 5, 0, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = plr.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextScaled = true
                    
                    local distLabel = Instance.new("TextLabel", billboard)
                    distLabel.Size = UDim2.new(1, -10, 0.4, 0)
                    distLabel.Position = UDim2.new(0, 5, 0.6, 0)
                    distLabel.BackgroundTransparency = 1
                    distLabel.Text = "0m"
                    distLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
                    distLabel.Font = Enum.Font.Gotham
                    distLabel.TextScaled = true
                end
            end
        end
        StatusESP.Text = "👁️ ESP: ON"
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("PvP_ESP") then
                plr.Character.Head.PvP_ESP:Destroy()
            end
        end
        StatusESP.Text = "👁️ ESP: OFF"
    end
end

-- Aimbot Melhorado (Smooth + FOV)
local function toggleAimbot(enabled)
    aimbotEnabled = enabled
    StatusAim.Text = "🎯 Aimbot: " .. (enabled and "ON" or "OFF")
end

local function getClosestPlayer()
    local closest, shortestDist = nil, fov
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            
            if onScreen and distance < shortestDist then
                shortestDist = distance
                closest = head
            end
        end
    end
    return closest
end

-- Update ESP Distance
RunService.Heartbeat:Connect(function()
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("PvP_ESP") then
                local esp = plr.Character.Head.PvP_ESP
                local distLabel = esp:FindFirstChild("TextLabel", true)
                if distLabel then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    distLabel.Text = math.floor(distance) .. "m"
                end
            end
        end
    end
end)

-- Smooth Aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
            Camera.CFrame = currentCFrame:lerp(targetCFrame, smooth)
        end
    end
end)

-- 🎮 Create Toggles
createToggle("👁️ ESP (Distance + Name)", 120, function() return espEnabled end, StatusESP)
createToggle("🎯 Aimbot (Smooth FOV)", 180, function() return aimbotEnabled end, StatusAim)
createToggle("🚀 Speed Hack", 240, function(enabled)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = enabled and 50 or 16
    end
end)

-- Sliders Modernos
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0, 280, 0, 45)
SliderFrame.Position = UDim2.new(0, 20, 0, 300)
SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
SliderFrame.Parent = Frame

local SCorner = Instance.new("UICorner")
SCorner.CornerRadius = UDim.new(0, 12)
SCorner.Parent = SliderFrame

local SLabel = Instance.new("TextLabel")
SLabel.Size = UDim2.new(0.4, 0, 1, 0)
SLabel.BackgroundTransparency = 1
SLabel.Text = "🎚️ FOV: 200"
SLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
SLabel.Font = Enum.Font.GothamSemibold
SLabel.TextSize = 15
SLabel.Parent = SliderFrame

local SBar = Instance.new("Frame")
SBar.Size = UDim2.new(0.55, 0, 0, 25)
SBar.Position = UDim2.new(0.42, 0, 0.5, -12.5)
SBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SBar.Parent = SliderFrame

local SFill = Instance.new("Frame")
SFill.Size = UDim2.new(0.7, 0, 1, 0)
SFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SFill.Parent = SBar

local SKnob = Instance.new("TextButton")
SKnob.Size = UDim2.new(0, 20, 0, 20)
SKnob.Position = UDim2.new(0.7, -10, 0, 2.5)
SKnob.BackgroundColor3 = Color3.new(1,1,1)
SKnob.Text = ""
SKnob.Parent = SBar

-- Slider Logic
local dragging = false
SKnob.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation()
        local relative = math.clamp((mousePos.X - SBar.AbsolutePosition.X) / SBar.AbsoluteSize.X, 0, 1)
        SFill.Size = UDim2.new(relative, 0, 1, 0)
        SKnob.Position = UDim2.new(relative, -10, 0, 2.5)
        fov = math.floor(relative * 400)
        SLabel.Text = "🎚️ FOV: " .. fov
    end
end)

-- Clear Button
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.9, 0, 0, 45)
ClearBtn.Position = UDim2.new(0.05, 0, 1, -65)
ClearBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
ClearBtn.Text = "🧹 CLEAR ALL"
ClearBtn.TextColor3 = Color3.new(1,1,1)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 18
ClearBtn.Parent = Frame

local CClear = Instance.new("UICorner")
CClear.CornerRadius = UDim.new(0, 12)
CClear.Parent = ClearBtn

ClearBtn.MouseButton1Click:Connect(function()
    toggleESP(false)
    toggleAimbot(false)
    ScreenGui:Destroy()
end)

-- Minimize Animation
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 45, 0, 45) or UDim2.new(0, 320, 0, 380)
    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = targetSize,
        Position = minimized and UDim2.new(0, 20, 0, 20) or UDim2.new(0.5, -160, 0.5, -190)
    }):Play()
    MinimizeBtn.Text = minimized and "+" or "−"
end)

-- M Key Toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        MinimizeBtn.MouseButton1Click:Fire()
    end
end)

-- Auto Animation
TweenService:Create(Frame, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 320, 0, 380),
    Position = UDim2.new(0.5, -160, 0.5, -190)
}):Play()

print("⚔️ PvP V2 Carregado! Pressione M para toggle!")
