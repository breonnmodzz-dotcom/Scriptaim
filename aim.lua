local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG
local AIM_RADIUS = 200
local AIM_STRENGTH = 0.35
local HITBOX_EXPAND_SIZE = 8
local aimEnabled = false
local espEnabled = false
local hitboxEnabled = false
local fovCircleEnabled = false
local currentHitboxSize = 8

local hitboxCache = {}
local espCache = {}

-- [Hitbox functions, wallcheck, aim assist, ESP permanecem iguais...]

-- CÍRCULO FOV (NOVA)
local fovCircle = nil

local function createFOVCircle()
\tif fovCircle then return end
\t
\tfovCircle = Instance.new("Frame")
\tfovCircle.Name = "FOVCircle"
\tfovCircle.Size = UDim2.new(0, AIM_RADIUS*4, 0, AIM_RADIUS*4)
\tfovCircle.Position = UDim2.new(0.5, -AIM_RADIUS*2, 0.5, -AIM_RADIUS*2)
\tfovCircle.BackgroundTransparency = 1
\tfovCircle.Parent = gui
\t
\tlocal circle = Instance.new("ImageLabel")
\tcircle.Size = UDim2.new(1, 0, 1, 0)
\tcircle.BackgroundTransparency = 1
\tcircle.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
\tcircle.ImageColor3 = Color3.fromRGB(255, 100, 0)
\tcircle.ImageTransparency = 0.7
\tcircle.ScaleType = Enum.ScaleType.Fit
\tcircle.Parent = fovCircle
\t
\t-- Círculo customizado com UICircle
\tlocal uiCircle = Instance.new("UICircle")
\tuiCircle.CornerRadius = UDim.new(1, 0)
\tuiCircle.Parent = circle
\t
\t-- Stroke pra borda
\tlocal stroke = Instance.new("UIStroke")
\tstroke.Color = Color3.fromRGB(255, 255, 0)
\tstroke.Thickness = 3
\tstroke.Transparency = 0.3
\tstroke.Parent = circle
end

local function toggleFOVCircle(state)
\tif state then
\t\tcreateFOVCircle()
\t\tfovCircle.Visible = true
\telse
\t\tif fovCircle then
\t\t\tfovCircle.Visible = false
\t\tend
\tend
end

-- UPDATE FOV CIRCLE (sincroniza com slider)
local function updateFOVCircle()
\tif fovCircle then
\t\tfovCircle.Size = UDim2.new(0, AIM_RADIUS*4, 0, AIM_RADIUS*4)
\t\tfovCircle.Position = UDim2.new(0.5, -AIM_RADIUS*2, 0.5, -AIM_RADIUS*2)
\tend
end

-- GUI ATUALIZADA (frame maior)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 450) -- Ainda maior
frame.Position = UDim2.new(0.5, -175, 0.5, -225)
-- [resto da GUI igual...]

-- TOGGLES
createToggle("Aim Assist Rage", 50, function(state) 
\taimEnabled = state 
end)

createToggle("ESP Box + Vida", 100, function(state)
\tespEnabled = state
\tupdateAllHitboxes()
end)

createToggle("Hitbox Expander", 150, function(state)
\thitboxEnabled = state
\tupdateAllHitboxes()
end)

createToggle("FOV Circle", 200, function(state)  -- NOVO BOTÃO ✅
\tfovCircleEnabled = state
\ttoggleFOVCircle(state)
end)

createSlider("Hitbox Size", 4, 20, 8, 270, function(value)
\tcurrentHitboxSize = value
\tif hitboxEnabled then updateAllHitboxes() end
end)

createSlider("Aim Radius", 50, 300, 200, 350, function(value)  -- MELHORADO
\tAIM_RADIUS = value
\tupdateFOVCircle() -- Atualiza círculo
end)

createSlider("Camera FOV", 60, 120, 70, 430, function(value)
\tCamera.FieldOfView = value
end)

-- UPDATE CIRCLE ON RADIUS CHANGE
-- Já incluso no slider de Aim Radius acima

-- Player events [igual antes...]