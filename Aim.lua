--[[
    ╔══════════════════════════════════════════════╗
    ║           ZZ HUB - v8 REDESIGN              ║
    ║     Desenvolvedor: Silva Modz               ║
    ║     Redesign UI: Melhorado                  ║
    ║     Jogo: Roblox (Rivals/Outros)            ║
    ║     Key: monite                             ║
    ╚══════════════════════════════════════════════╝
    
    MELHORIAS DE UI:
    - KeyFrame com brilho animado e subtítulo
    - Header com logo + título + botão fechar/minimizar
    - Sidebar mais larga com texto nos botões de tab
    - Toggles com animação suave de deslize (Tween)
    - Seções com título separador visual
    - Notificações toast no canto da tela
    - Slider redesenhado com thumb arredondado e valor em badge
    - Botão flutuante com pulse ring animado
    - Blood Mode com transição de cor suave em toda UI
    - FPS badge colorido (verde/amarelo/vermelho)
    - Info tab com créditos e versão
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================================
--              CONFIGURAÇÕES E ESTADO
-- ================================================

local CORRECT_KEY   = "monite"
local VERSION       = "v8"
local RGBMode       = true
local BloodMode     = false
local AimbotEnabled     = false
local SilentAimEnabled  = false
local MagnetEnabled     = false
local UpPlayerEnabled   = false
local FlyEnabled        = false
local AimbotFOV         = 100
local ShowFOV           = false
local SpinBotEnabled    = false
local SpinSpeed         = 100
local NoclipEnabled     = false
local DoubleJumpEnabled = false
local CurrentLang       = "PT"
local FPS               = 0
local MenuVisible       = false

local ESPSettings = {
    Box3D    = false,
    Linha    = false,
    Vida     = false,
    Esqueleto = false,
    Nome     = false,
    Distancia = false,
    LinhaRGB = false,
}

local LangData = {
    PT = {Main="Principal", Visual="Visual", Menu="Menu", Full="Config", Info="Info",
          Aimbot="Aimbot Head", Silent="Silent Aim", Magnet="Magnet", ShowFOV="Exibir FOV",
          FOVRadius="Raio do FOV", ESPBox="ESP Box 3D", ESPLine="ESP Linha (Topo)",
          ESPHealth="ESP Vida", ESPSkeleton="ESP Esqueleto", ESPName="ESP Nome",
          ESPDist="ESP Distância", ESPRGB="ESP Linha RGB", SpinBot="Spin Bot (100)",
          Noclip="Noclip", Jump="Pulo Duplo", Lang="Idioma", FPS="FPS",
          Up="Up Player", Fly="Voar (Fly)"},
    EN = {Main="Main", Visual="Visual", Menu="Menu", Full="Settings", Info="Info",
          Aimbot="Aimbot Head", Silent="Silent Aim", Magnet="Magnet", ShowFOV="Show FOV",
          FOVRadius="FOV Radius", ESPBox="ESP Box 3D", ESPLine="ESP Line (Top)",
          ESPHealth="ESP Health", ESPSkeleton="ESP Skeleton", ESPName="ESP Name",
          ESPDist="ESP Distance", ESPRGB="ESP Line RGB", SpinBot="Spin Bot (100)",
          Noclip="Noclip", Jump="Double Jump", Lang="Language", FPS="FPS",
          Up="Up Player", Fly="Fly Mode"},
    ES = {Main="Principal", Visual="Visual", Menu="Menu", Full="Ajustes", Info="Info",
          Aimbot="Aimbot Cabeza", Silent="Silent Aim", Magnet="Magnet", ShowFOV="Mostrar FOV",
          FOVRadius="Radio del FOV", ESPBox="ESP Box 3D", ESPLine="ESP Línea (Arriba)",
          ESPHealth="ESP Vida", ESPSkeleton="ESP Esqueleto", ESPName="ESP Nombre",
          ESPDist="ESP Distancia", ESPRGB="ESP Línea RGB", SpinBot="Spin Bot (100)",
          Noclip="Noclip", Jump="Salto Doble", Lang="Idioma", FPS="FPS",
          Up="Up Player", Fly="Volar (Fly)"},
}

-- ================================================
--              PALETA DE CORES
-- ================================================

local C = {
    MainBG     = Color3.fromRGB(12, 12, 15),
    SidebarBG  = Color3.fromRGB(18, 18, 22),
    CardBG     = Color3.fromRGB(22, 22, 28),
    CardHover  = Color3.fromRGB(28, 28, 36),
    Accent     = Color3.fromRGB(210, 35, 35),
    AccentDark = Color3.fromRGB(150, 20, 20),
    Blood      = Color3.fromRGB(139, 0, 0),
    BloodDark  = Color3.fromRGB(100, 0, 0),
    Text       = Color3.fromRGB(240, 240, 245),
    TextMuted  = Color3.fromRGB(140, 140, 155),
    ToggleOff  = Color3.fromRGB(45, 45, 55),
    Separator  = Color3.fromRGB(35, 35, 42),
    White      = Color3.fromRGB(255, 255, 255),
    Green      = Color3.fromRGB(80, 220, 100),
    Yellow     = Color3.fromRGB(255, 200, 50),
    Red        = Color3.fromRGB(220, 60, 60),
}

local function GetAccent()     return BloodMode and C.Blood or C.Accent end
local function GetAccentDark() return BloodMode and C.BloodDark or C.AccentDark end

-- ================================================
--              UTILITÁRIOS
-- ================================================

local function Create(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    TweenService:Create(obj, info, props):Play()
end

local function MakeDraggable(frame, handle)
    local drag, dStart, sPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; dStart = i.Position; sPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dStart
            frame.Position = UDim2.new(
                sPos.X.Scale, sPos.X.Offset + d.X,
                sPos.Y.Scale, sPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
end

-- ================================================
--              SISTEMA DE ESP & FOV
-- ================================================

local ESP_Objects = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 120
FOVCircle.Radius = AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

local function CreateESP(player)
    local objects = {
        Box3D = {},
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBarBG = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Skeleton = {}
    }
    for i = 1, 12 do
        local l = Drawing.new("Line"); l.Thickness = 1.5
        objects.Box3D[i] = l
    end
    objects.Line.Thickness = 1.5
    objects.Name.Size = 14; objects.Name.Center = true; objects.Name.Outline = true
    objects.Distance.Size = 12; objects.Distance.Center = true; objects.Distance.Outline = true
    objects.HealthBarBG.Filled = true; objects.HealthBarBG.Color = Color3.fromRGB(0,0,0)
    objects.HealthBar.Filled = true
    for i = 1, 15 do
        local l = Drawing.new("Line"); l.Thickness = 2.5
        objects.Skeleton[i] = l
    end
    ESP_Objects[player] = objects
end

local function UpdateESP()
    FOVCircle.Visible = ShowFOV
    FOVCircle.Radius = AimbotFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local hue = tick() % 5 / 5
    local rgbColor = Color3.fromHSV(hue, 1, 1)
    local espMainColor = ESPSettings.LinhaRGB and rgbColor or Color3.fromRGB(255, 255, 255)

    for player, objects in pairs(ESP_Objects) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if char and hrp and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                -- Box 3D
                if ESPSettings.Box3D then
                    local size = Vector3.new(2, 3, 2)
                    local cf = hrp.CFrame
                    local corners = {
                        Vector3.new( size.X,  size.Y,  size.Z),
                        Vector3.new(-size.X,  size.Y,  size.Z),
                        Vector3.new(-size.X, -size.Y,  size.Z),
                        Vector3.new( size.X, -size.Y,  size.Z),
                        Vector3.new( size.X,  size.Y, -size.Z),
                        Vector3.new(-size.X,  size.Y, -size.Z),
                        Vector3.new(-size.X, -size.Y, -size.Z),
                        Vector3.new( size.X, -size.Y, -size.Z),
                    }
                    local points = {}
                    for _, c in pairs(corners) do
                        local p = Camera:WorldToViewportPoint((cf * CFrame.new(c)).Position)
                        table.insert(points, p)
                    end
                    local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                    for i, edge in pairs(edges) do
                        objects.Box3D[i].Visible = true
                        objects.Box3D[i].From = Vector2.new(points[edge[1]].X, points[edge[1]].Y)
                        objects.Box3D[i].To   = Vector2.new(points[edge[2]].X, points[edge[2]].Y)
                        objects.Box3D[i].Color = espMainColor
                    end
                else
                    for _, l in pairs(objects.Box3D) do l.Visible = false end
                end

                -- Linha (Topo)
                objects.Line.Visible = ESPSettings.Linha
                if ESPSettings.Linha then
                    objects.Line.From  = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    objects.Line.To    = Vector2.new(pos.X, pos.Y)
                    objects.Line.Color = espMainColor
                end

                -- Barra de vida
                objects.HealthBarBG.Visible = ESPSettings.Vida
                objects.HealthBar.Visible   = ESPSettings.Vida
                if ESPSettings.Vida then
                    local headPos = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                    local legPos  = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height  = math.abs(headPos.Y - legPos.Y)
                    local width   = height / 2
                    local hp      = hum.Health / hum.MaxHealth
                    objects.HealthBarBG.Size     = Vector2.new(3, height)
                    objects.HealthBarBG.Position = Vector2.new(pos.X - width / 2 - 8, pos.Y - height / 2)
                    objects.HealthBar.Size       = Vector2.new(3, height * hp)
                    objects.HealthBar.Position   = Vector2.new(pos.X - width / 2 - 8, pos.Y + height / 2 - (height * hp))
                    objects.HealthBar.Color       = Color3.fromRGB(255 - (255 * hp), 255 * hp, 0)
                end

                -- Esqueleto
                local parts = hum.RigType == Enum.HumanoidRigType.R15 and {
                    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
                    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
                    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},
                    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
                    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},
                } or {
                    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
                    {"Torso","Left Leg"},{"Torso","Right Leg"},
                }
                for i, p in pairs(parts) do
                    local line = objects.Skeleton[i]
                    if ESPSettings.Esqueleto and char:FindFirstChild(p[1]) and char:FindFirstChild(p[2]) then
                        local p1, v1 = Camera:WorldToViewportPoint(char[p[1]].Position)
                        local p2, v2 = Camera:WorldToViewportPoint(char[p[2]].Position)
                        line.Visible = v1 and v2
                        line.From    = Vector2.new(p1.X, p1.Y)
                        line.To      = Vector2.new(p2.X, p2.Y)
                        line.Color   = espMainColor
                    else
                        line.Visible = false
                    end
                end

                -- Nome e Distância
                objects.Name.Visible = ESPSettings.Nome
                objects.Name.Text     = player.Name
                objects.Name.Position = Vector2.new(pos.X, pos.Y - 42)
                objects.Name.Color    = Color3.fromRGB(255, 255, 255)

                objects.Distance.Visible = ESPSettings.Distancia
                if ESPSettings.Distancia and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local d = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    objects.Distance.Text     = "[" .. d .. "m]"
                    objects.Distance.Position = Vector2.new(pos.X, pos.Y + 42)
                    objects.Distance.Color    = Color3.fromRGB(255, 210, 50)
                end
            else
                for _, v in pairs(objects) do
                    if type(v) == "table" then for _, l in pairs(v) do l.Visible = false end
                    else v.Visible = false end
                end
            end
        else
            for _, v in pairs(objects) do
                if type(v) == "table" then for _, l in pairs(v) do l.Visible = false end
                else v.Visible = false end
            end
        end
    end
end

-- ================================================
--              INTERFACE PRINCIPAL
-- ================================================

local ScreenGui = Create("ScreenGui", {
    Name = "ZZHubProV8",
    Parent = game.CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    ResetOnSpawn = false,
})

-- ================================================
--         SISTEMA DE NOTIFICAÇÕES TOAST
-- ================================================

local ToastContainer = Create("Frame", {
    Size = UDim2.new(0, 280, 1, 0),
    Position = UDim2.new(1, -295, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 200,
    Parent = ScreenGui,
})
Create("UIListLayout", {
    Parent = ToastContainer,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

local function ShowToast(text, icon, color)
    local toast = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(22, 22, 28),
        BackgroundTransparency = 0.1,
        ZIndex = 201,
        Parent = ToastContainer,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = toast})
    Create("UIStroke", {Thickness = 1.5, Color = color or GetAccent(), Parent = toast})

    -- Barra colorida à esquerda
    local bar = Create("Frame", {
        Size = UDim2.new(0, 4, 1, -12),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundColor3 = color or GetAccent(),
        ZIndex = 202,
        Parent = toast,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bar})

    Create("TextLabel", {
        Text = (icon or "•") .. "  " .. text,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 202,
        Parent = toast,
    })

    -- Animação de entrada
    toast.Size = UDim2.new(1, 0, 0, 0)
    toast.BackgroundTransparency = 1
    Tween(toast, {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 0.1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(2.5, function()
        Tween(toast, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.delay(0.35, function() toast:Destroy() end)
    end)
end

-- ================================================
--         KEY FRAME — TELA DE LOGIN
-- ================================================

local KeyFrame = Create("Frame", {
    Size = UDim2.new(0, 380, 0, 240),
    Position = UDim2.new(0.5, -190, 0.5, -120),
    BackgroundColor3 = C.MainBG,
    ZIndex = 100,
    Parent = ScreenGui,
})
Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = KeyFrame})

-- Borda animada (UIStroke)
local KeyBorder = Create("UIStroke", {
    Thickness = 2,
    Color = C.Accent,
    Parent = KeyFrame,
})

-- Brilho de fundo sutil
local KeyGlow = Create("Frame", {
    Size = UDim2.new(1, 40, 0, 6),
    Position = UDim2.new(0, -20, 0, -3),
    BackgroundColor3 = C.Accent,
    BackgroundTransparency = 0.7,
    ZIndex = 99,
    Parent = KeyFrame,
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = KeyGlow})

-- Título e ícone
Create("TextLabel", {
    Text = "⬡  ZZ HUB",
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 18),
    BackgroundTransparency = 1,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    ZIndex = 101,
    Parent = KeyFrame,
})
Create("TextLabel", {
    Text = "Insira a chave de acesso para continuar",
    Size = UDim2.new(1, -40, 0, 20),
    Position = UDim2.new(0, 20, 0, 62),
    BackgroundTransparency = 1,
    TextColor3 = C.TextMuted,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ZIndex = 101,
    Parent = KeyFrame,
})

-- Caixa de input estilizada
local InputBG = Create("Frame", {
    Size = UDim2.new(0.82, 0, 0, 44),
    Position = UDim2.new(0.09, 0, 0, 100),
    BackgroundColor3 = C.SidebarBG,
    ZIndex = 101,
    Parent = KeyFrame,
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = InputBG})
Create("UIStroke", {Thickness = 1.5, Color = C.Separator, Parent = InputBG})

Create("TextLabel", {
    Text = "🔑",
    Size = UDim2.new(0, 36, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = C.TextMuted,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 102,
    Parent = InputBG,
})

local KeyInput = Create("TextBox", {
    PlaceholderText = "Digite a key aqui...",
    Size = UDim2.new(1, -44, 1, 0),
    Position = UDim2.new(0, 40, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = C.Text,
    PlaceholderColor3 = C.TextMuted,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false,
    ZIndex = 102,
    Parent = InputBG,
})

-- Botão de entrar
local KeyBtn = Create("TextButton", {
    Text = "ACESSAR  →",
    Size = UDim2.new(0.82, 0, 0, 42),
    Position = UDim2.new(0.09, 0, 0, 158),
    BackgroundColor3 = C.Accent,
    TextColor3 = C.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 14,
    ZIndex = 101,
    Parent = KeyFrame,
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = KeyBtn})

-- Hover effect no botão
KeyBtn.MouseEnter:Connect(function()
    Tween(KeyBtn, {BackgroundColor3 = C.AccentDark}, 0.15)
end)
KeyBtn.MouseLeave:Connect(function()
    Tween(KeyBtn, {BackgroundColor3 = C.Accent}, 0.15)
end)

-- Label de versão
Create("TextLabel", {
    Text = "ZZ HUB  " .. VERSION .. "  •  by Silva Modz",
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 1, -22),
    BackgroundTransparency = 1,
    TextColor3 = C.TextMuted,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    ZIndex = 101,
    Parent = KeyFrame,
})

-- ================================================
--         MENU PRINCIPAL
-- ================================================

local MainFrame = Create("Frame", {
    Size = UDim2.new(0, 560, 0, 380),
    Position = UDim2.new(0.5, -280, 0.5, -190),
    BackgroundColor3 = C.MainBG,
    Visible = false,
    ZIndex = 10,
    Parent = ScreenGui,
})
Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = MainFrame})
MakeDraggable(MainFrame, MainFrame)

local MainBorder = Create("UIStroke", {
    Thickness = 2,
    Color = C.Accent,
    Parent = MainFrame,
})

-- Brilho superior
local TopGlow = Create("Frame", {
    Size = UDim2.new(0.6, 0, 0, 5),
    Position = UDim2.new(0.2, 0, 0, -2),
    BackgroundColor3 = C.Accent,
    BackgroundTransparency = 0.5,
    ZIndex = 9,
    Parent = MainFrame,
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = TopGlow})

-- ================================================
--              HEADER
-- ================================================

local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = C.SidebarBG,
    ZIndex = 11,
    Parent = MainFrame,
})
Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Header})

-- Cobre os cantos inferiores do header
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = C.SidebarBG,
    ZIndex = 11,
    Parent = Header,
})

-- Logo hexágono + título
Create("TextLabel", {
    Text = "⬡",
    Size = UDim2.new(0, 36, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = C.Accent,
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    ZIndex = 12,
    Parent = Header,
})
Create("TextLabel", {
    Text = "ZZ HUB",
    Size = UDim2.new(0, 100, 1, 0),
    Position = UDim2.new(0, 46, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
    Parent = Header,
})
Create("TextLabel", {
    Text = VERSION,
    Size = UDim2.new(0, 40, 0, 18),
    Position = UDim2.new(0, 146, 0.5, -9),
    BackgroundColor3 = GetAccent(),
    TextColor3 = C.White,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    ZIndex = 12,
    Parent = Header,
    Name = "VersionBadge",
})
do
    local badge = Header:FindFirstChild("VersionBadge")
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = badge})
end

-- Botão Blood Mode (🌙)
local MoonBtn = Create("TextButton", {
    Text = "🌙",
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(1, -82, 0.5, -18),
    BackgroundColor3 = C.CardBG,
    TextColor3 = C.TextMuted,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 12,
    Parent = Header,
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MoonBtn})

-- Botão Fechar / minimizar
local CloseBtn = Create("TextButton", {
    Text = "✕",
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(1, -42, 0.5, -18),
    BackgroundColor3 = C.CardBG,
    TextColor3 = C.TextMuted,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 12,
    Parent = Header,
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})
CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3 = C.Red}, 0.15) end)
CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3 = C.CardBG}, 0.15) end)

-- ================================================
--              SIDEBAR (TABS)
-- ================================================

local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 78, 1, -56),
    Position = UDim2.new(0, 0, 0, 56),
    BackgroundColor3 = C.SidebarBG,
    ZIndex = 11,
    Parent = MainFrame,
})
-- Cobre canto superior da sidebar
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 0, -8),
    BackgroundColor3 = C.SidebarBG,
    ZIndex = 11,
    Parent = Sidebar,
})
-- Cobre canto inferior esquerdo da sidebar (visual)
Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Sidebar})

local IconContainer = Create("Frame", {
    Size = UDim2.new(1, 0, 1, -20),
    Position = UDim2.new(0, 0, 0, 10),
    BackgroundTransparency = 1,
    ZIndex = 12,
    Parent = Sidebar,
})
Create("UIListLayout", {
    Parent = IconContainer,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 8),
})

-- Área de conteúdo
local Container = Create("ScrollingFrame", {
    Size = UDim2.new(1, -90, 1, -66),
    Position = UDim2.new(0, 86, 0, 58),
    BackgroundTransparency = 1,
    ZIndex = 11,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Accent,
    Parent = MainFrame,
})
Create("UIListLayout", {
    Parent = Container,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
})
Create("UIPadding", {
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
    Parent = Container,
})

-- ================================================
--              BOTÃO FLUTUANTE
-- ================================================

local FloatingBtn = Create("TextButton", {
    Size = UDim2.new(0, 52, 0, 52),
    Position = UDim2.new(0, 12, 0.5, -26),
    BackgroundColor3 = C.Accent,
    Text = "ZZ",
    TextColor3 = C.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 15,
    Visible = false,
    ZIndex = 20,
    Parent = ScreenGui,
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = FloatingBtn})
Create("UIStroke", {Thickness = 2, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.6, Parent = FloatingBtn})

-- Pulse ring
local PulseRing = Create("Frame", {
    Size = UDim2.new(1, 14, 1, 14),
    Position = UDim2.new(0, -7, 0, -7),
    BackgroundTransparency = 1,
    ZIndex = 19,
    Parent = FloatingBtn,
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = PulseRing})
local PulseStroke = Create("UIStroke", {
    Thickness = 2,
    Color = C.Accent,
    Transparency = 0.5,
    Parent = PulseRing,
})

-- Animação de pulse
task.spawn(function()
    while true do
        Tween(PulseStroke, {Transparency = 0.1}, 0.7, Enum.EasingStyle.Sine)
        task.wait(0.7)
        Tween(PulseStroke, {Transparency = 0.9}, 0.7, Enum.EasingStyle.Sine)
        task.wait(0.7)
    end
end)

MakeDraggable(FloatingBtn, FloatingBtn)

-- ================================================
--              COMPONENTES DE UI
-- ================================================

local TabFrames = {}
local Toggles = {}
local AllAccentObjects = {} -- Para atualizar cor ao trocar Blood Mode

-- Separador de seção com título
local function AddSection(parent, title, order)
    local section = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        ZIndex = 14,
        LayoutOrder = order or 0,
        Parent = parent,
    })
    Create("TextLabel", {
        Text = string.upper(title),
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = C.TextMuted,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = section,
    })
    local line = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 1),
        Position = UDim2.new(0, 5, 0.5, 8),
        BackgroundColor3 = C.Separator,
        ZIndex = 14,
        Parent = section,
    })
    return section
end

-- Botão de Tab na Sidebar
local function AddTab(name, icon, label, order)
    local isFirst = (order == 1)

    local btn = Create("TextButton", {
        Text = "",
        Size = UDim2.new(0, 62, 0, 58),
        BackgroundColor3 = isFirst and GetAccent() or C.CardBG,
        ZIndex = 13,
        Parent = IconContainer,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = btn})

    Create("TextLabel", {
        Text = icon,
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = isFirst and C.White or C.TextMuted,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        ZIndex = 14,
        Name = "Icon",
        Parent = btn,
    })
    Create("TextLabel", {
        Text = label,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundTransparency = 1,
        TextColor3 = isFirst and C.White or C.TextMuted,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        ZIndex = 14,
        Name = "Label",
        Parent = btn,
    })

    -- Frame de conteúdo (ScrollingFrame individual por aba)
    local frame = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = isFirst,
        ZIndex = 13,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Accent,
        Parent = Container,
    })
    Create("UIListLayout", {
        Parent = frame,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    Create("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        Parent = frame,
    })

    TabFrames[name] = {frame = frame, btn = btn}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(TabFrames) do
            t.frame.Visible = false
            Tween(t.btn, {BackgroundColor3 = C.CardBG}, 0.2)
            t.btn:FindFirstChild("Icon").TextColor3 = C.TextMuted
            t.btn:FindFirstChild("Label").TextColor3 = C.TextMuted
        end
        frame.Visible = true
        Tween(btn, {BackgroundColor3 = GetAccent()}, 0.2)
        btn:FindFirstChild("Icon").TextColor3 = C.White
        btn:FindFirstChild("Label").TextColor3 = C.White
    end)

    return frame
end

-- Toggle melhorado com animação Tween
local function AddToggle(parent, textKey, callback, desc, order)
    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, desc and 58 or 48),
        BackgroundColor3 = C.CardBG,
        ZIndex = 14,
        LayoutOrder = order or 0,
        Parent = parent,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = row})

    -- Hover
    row.MouseEnter:Connect(function() Tween(row, {BackgroundColor3 = C.CardHover}, 0.15) end)
    row.MouseLeave:Connect(function() Tween(row, {BackgroundColor3 = C.CardBG}, 0.15) end)

    local label = Create("TextLabel", {
        Text = LangData[CurrentLang][textKey] or textKey,
        Size = UDim2.new(0.65, 0, 0, 22),
        Position = UDim2.new(0, 14, 0, desc and 10 or 13),
        BackgroundTransparency = 1,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = row,
    })

    if desc then
        Create("TextLabel", {
            Text = desc,
            Size = UDim2.new(0.72, 0, 0, 16),
            Position = UDim2.new(0, 14, 0, 32),
            BackgroundTransparency = 1,
            TextColor3 = C.TextMuted,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15,
            Parent = row,
        })
    end

    -- Trilho do toggle
    local track = Create("Frame", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = C.ToggleOff,
        ZIndex = 15,
        Parent = row,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

    -- Thumb (bolinha)
    local thumb = Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = C.White,
        ZIndex = 16,
        Parent = track,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = thumb})

    -- Botão invisível sobre tudo
    local hitbox = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 17,
        Parent = row,
    })

    local tObj = {state = false, track = track, thumb = thumb, label = label, key = textKey}
    table.insert(Toggles, tObj)

    hitbox.MouseButton1Click:Connect(function()
        tObj.state = not tObj.state
        if tObj.state then
            Tween(track, {BackgroundColor3 = GetAccent()}, 0.2)
            Tween(thumb, {Position = UDim2.new(0, 25, 0.5, -8)}, 0.2, Enum.EasingStyle.Back)
        else
            Tween(track, {BackgroundColor3 = C.ToggleOff}, 0.2)
            Tween(thumb, {Position = UDim2.new(0, 3, 0.5, -8)}, 0.2, Enum.EasingStyle.Back)
        end
        callback(tObj.state)
    end)

    return tObj
end

-- Slider redesenhado
local function AddSlider(parent, textKey, min, max, default, callback, order)
    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = C.CardBG,
        ZIndex = 14,
        LayoutOrder = order or 0,
        Parent = parent,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = row})

    Create("TextLabel", {
        Text = LangData[CurrentLang][textKey] or textKey,
        Size = UDim2.new(0.6, 0, 0, 20),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = row,
    })

    -- Badge de valor
    local valBadge = Create("TextLabel", {
        Text = tostring(default),
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -56, 0, 8),
        BackgroundColor3 = C.CardHover,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 15,
        Parent = row,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = valBadge})

    -- Trilha do slider
    local sliderBg = Create("Frame", {
        Size = UDim2.new(1, -28, 0, 6),
        Position = UDim2.new(0, 14, 0, 44),
        BackgroundColor3 = C.ToggleOff,
        ZIndex = 15,
        Parent = row,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderBg})

    -- Preenchimento
    local sliderFill = Create("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = GetAccent(),
        ZIndex = 16,
        Parent = sliderBg,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderFill})

    -- Thumb do slider
    local sliderThumb = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
        BackgroundColor3 = C.White,
        ZIndex = 17,
        Parent = sliderBg,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderThumb})
    Create("UIStroke", {Thickness = 2, Color = GetAccent(), Parent = sliderThumb})

    -- Hitbox
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 3, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 18,
        Parent = sliderBg,
    })
    btn.MouseButton1Down:Connect(function()
        local conn; conn = RunService.RenderStepped:Connect(function()
            local mouseX = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
            sliderThumb.Position = UDim2.new(rel, 0, 0.5, 0)
            local val = math.floor(min + (max - min) * rel)
            valBadge.Text = tostring(val)
            callback(val)
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
        end)
    end)
end

-- Botão de ação simples
local function AddButton(parent, text, icon, callback, order)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = C.CardBG,
        Text = (icon and (icon .. "  ") or "") .. text,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        ZIndex = 14,
        LayoutOrder = order or 0,
        Parent = parent,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = btn})
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = C.CardHover}, 0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = C.CardBG}, 0.15) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ================================================
--              PREENCHIMENTO DAS ABAS
-- ================================================

-- ABA: PRINCIPAL
local MainTab = AddTab("Main", "🎯", "MIRA", 1)
AddSection(MainTab, "Aimbot", 0)
AddToggle(MainTab, "Aimbot",  function(v) AimbotEnabled = v;    ShowToast("Aimbot " .. (v and "ativado" or "desativado"), "🎯") end, "Trava a câmera na cabeça", 1)
AddToggle(MainTab, "Silent",  function(v) SilentAimEnabled = v; ShowToast("Silent Aim " .. (v and "ativado" or "desativado"), "👻") end, "Acerto silencioso sem mover câmera", 2)
AddToggle(MainTab, "Magnet",  function(v) MagnetEnabled = v;    ShowToast("Magnet " .. (v and "ativado" or "desativado"), "🧲") end, "Puxa o alvo em sua direção", 3)
AddSection(MainTab, "FOV", 10)
AddToggle(MainTab, "ShowFOV", function(v) ShowFOV = v end, nil, 11)
AddSlider(MainTab, "FOVRadius", 10, 500, 100, function(v) AimbotFOV = v end, 12)

-- ABA: VISUAL
local VisualTab = AddTab("Visual", "👁️", "ESP", 2)
AddSection(VisualTab, "Detecção Visual", 0)
AddToggle(VisualTab, "ESPBox",      function(v) ESPSettings.Box3D    = v end, "Caixa 3D ao redor do jogador", 1)
AddToggle(VisualTab, "ESPLine",     function(v) ESPSettings.Linha     = v end, "Linha do topo da tela", 2)
AddToggle(VisualTab, "ESPHealth",   function(v) ESPSettings.Vida      = v end, "Barra de vida lateral", 3)
AddToggle(VisualTab, "ESPSkeleton", function(v) ESPSettings.Esqueleto = v end, "Esqueleto do personagem", 4)
AddSection(VisualTab, "Informações", 10)
AddToggle(VisualTab, "ESPName",     function(v) ESPSettings.Nome      = v end, "Nome do jogador", 11)
AddToggle(VisualTab, "ESPDist",     function(v) ESPSettings.Distancia = v end, "Distância em metros", 12)
AddToggle(VisualTab, "ESPRGB",      function(v) ESPSettings.LinhaRGB  = v end, "Cor arco-íris animada", 13)

-- ABA: MENU (Movement)
local MenuTab = AddTab("Menu", "⚡", "MOVE", 3)
AddSection(MenuTab, "Movimento", 0)
AddToggle(MenuTab, "Fly",    function(v) FlyEnabled = v;    ShowToast("Fly " .. (v and "ativado" or "desativado"), "🦅") end, "Voar com tecla de movimento", 1)
AddToggle(MenuTab, "Noclip", function(v) NoclipEnabled = v; ShowToast("Noclip " .. (v and "ativado" or "desativado"), "👻") end, "Atravessa paredes", 2)
AddToggle(MenuTab, "Jump",   function(v) DoubleJumpEnabled = v end, "Pular duas vezes", 3)
AddSection(MenuTab, "Player", 10)
AddToggle(MenuTab, "SpinBot", function(v) SpinBotEnabled = v; ShowToast("SpinBot " .. (v and "ativado" or "desativado"), "🌀") end, "Gira o personagem (velocidade 100)", 11)
AddToggle(MenuTab, "Up",      function(v) UpPlayerEnabled = v end, "Arremessa alvo para cima", 12)

-- ABA: CONFIG
local FullTab = AddTab("Full", "⚙️", "CONFIG", 4)
AddSection(FullTab, "Idioma", 0)

local LangCycleBtn = AddButton(FullTab, "IDIOMA: PT", "🌍", function() end, 1)
LangCycleBtn.MouseButton1Click:Connect(function()
    if CurrentLang == "PT" then CurrentLang = "EN"
    elseif CurrentLang == "EN" then CurrentLang = "ES"
    else CurrentLang = "PT" end
    LangCycleBtn.Text = "🌍  IDIOMA: " .. CurrentLang
    for _, t in pairs(Toggles) do
        if LangData[CurrentLang][t.key] then
            t.label.Text = LangData[CurrentLang][t.key]
        end
    end
    ShowToast("Idioma alterado para " .. CurrentLang, "🌍")
end)

AddSection(FullTab, "Performance", 10)
local FPSFrame = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = C.CardBG,
    ZIndex = 14,
    LayoutOrder = 11,
    Parent = FullTab,
})
Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = FPSFrame})
Create("TextLabel", {
    Text = "FPS Monitor",
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = C.TextMuted,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 15,
    Parent = FPSFrame,
})
local FPSLabel = Create("TextLabel", {
    Text = "0",
    Size = UDim2.new(0, 56, 0, 26),
    Position = UDim2.new(1, -68, 0.5, -13),
    BackgroundColor3 = C.Green,
    TextColor3 = C.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 14,
    ZIndex = 15,
    Parent = FPSFrame,
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = FPSLabel})

-- ABA: INFO
local InfoTab = AddTab("Info", "ℹ️", "INFO", 5)
AddSection(InfoTab, "Sobre", 0)

local infoCard = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 110),
    BackgroundColor3 = C.CardBG,
    ZIndex = 14,
    LayoutOrder = 1,
    Parent = InfoTab,
})
Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = infoCard})

local infoLines = {
    {"⬡  ZZ HUB " .. VERSION, C.Accent, 16, true},
    {"by Silva Modz", C.TextMuted, 12, false},
    {"Roblox — Rivals e outros jogos", C.TextMuted, 11, false},
    {"Key: monite", C.Text, 12, true},
}
for i, info in ipairs(infoLines) do
    Create("TextLabel", {
        Text = info[1],
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 10, 0, (i - 1) * 24 + 6),
        BackgroundTransparency = 1,
        TextColor3 = info[2],
        Font = info[4] and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = info[3],
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = infoCard,
    })
end

-- ================================================
--              LÓGICA DOS BOTÕES GLOBAIS
-- ================================================

-- Blood Mode
MoonBtn.MouseButton1Click:Connect(function()
    BloodMode = not BloodMode
    local accent = GetAccent()
    local dark   = GetAccentDark()
    -- Atualizar bordas e glow
    Tween(MainBorder, {Color = accent}, 0.3)
    Tween(KeyBorder,  {Color = accent}, 0.3)
    Tween(KeyGlow,    {BackgroundColor3 = accent}, 0.3)
    Tween(TopGlow,    {BackgroundColor3 = accent}, 0.3)
    Tween(FloatingBtn, {BackgroundColor3 = accent}, 0.3)
    Tween(PulseStroke, {Color = accent}, 0.3)
    Tween(sliderFill or FloatingBtn, {BackgroundColor3 = accent}, 0.3) -- segurança
    -- Atualizar tab ativa
    for _, t in pairs(TabFrames) do
        if t.frame.Visible then
            Tween(t.btn, {BackgroundColor3 = accent}, 0.3)
        end
    end
    MoonBtn.TextColor3 = BloodMode and C.Blood or C.TextMuted
    ShowToast(BloodMode and "Blood Mode ativado" or "Blood Mode desativado", BloodMode and "🩸" or "🌙")
end)

-- Fechar menu
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Size = UDim2.new(0, 560, 0, 0), Position = UDim2.new(0.5, -280, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
    task.delay(0.3, function()
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 560, 0, 380)
        MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    end)
    FOVCircle.Visible = false
end)

-- Botão flutuante
FloatingBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        Tween(MainFrame, {Size = UDim2.new(0, 560, 0, 0), Position = UDim2.new(0.5, -280, 0.5, 0)}, 0.25, Enum.EasingStyle.Back)
        task.delay(0.25, function()
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, 560, 0, 380)
            MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
        end)
        FOVCircle.Visible = false
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 560, 0, 0)
        Tween(MainFrame, {Size = UDim2.new(0, 560, 0, 380)}, 0.3, Enum.EasingStyle.Back)
    end
end)

-- Sistema de Key
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        Tween(KeyFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 380, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.delay(0.3, function() KeyFrame.Visible = false end)
        task.delay(0.1, function()
            MainFrame.Visible = true
            FloatingBtn.Visible = true
            MainFrame.Size = UDim2.new(0, 560, 0, 0)
            Tween(MainFrame, {Size = UDim2.new(0, 560, 0, 380)}, 0.4, Enum.EasingStyle.Back)
            ShowToast("Bem-vindo ao ZZ HUB " .. VERSION .. "!", "✅", C.Green)
        end)
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "❌ Key incorreta!"
        Tween(KeyBorder, {Color = C.Red}, 0.1)
        task.delay(0.15, function() Tween(KeyBorder, {Color = GetAccent()}, 0.2) end)
        ShowToast("Key inválida. Tente novamente.", "❌", C.Red)
    end
end)

-- Enter no campo de key
KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then KeyBtn.MouseButton1Click:Fire() end
end)

-- ================================================
--              LÓGICA DE JOGO (RenderStepped)
-- ================================================

local function GetClosestPlayer()
    local target, closestDist = nil, AimbotFOV
    local center = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if d < closestDist then
                    closestDist = d
                    target = p
                end
            end
        end
    end
    return target
end

local fpsUpdateTimer = 0
RunService.RenderStepped:Connect(function(dt)
    -- Fly
    if FlyEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            hum.PlatformStand = true
            hrp.Velocity = (hum.MoveDirection * 50) + Vector3.new(0, 2, 0)
        end
    elseif LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end

    -- FPS (atualiza a cada 0.5s para não piscar)
    fpsUpdateTimer += dt
    if fpsUpdateTimer >= 0.5 then
        fpsUpdateTimer = 0
        FPS = math.floor(1 / dt)
        FPSLabel.Text = tostring(FPS)
        if FPS >= 55 then
            FPSLabel.BackgroundColor3 = C.Green
        elseif FPS >= 30 then
            FPSLabel.BackgroundColor3 = C.Yellow
        else
            FPSLabel.BackgroundColor3 = C.Red
        end
    end

    -- ESP
    UpdateESP()

    local target = GetClosestPlayer()

    -- Aimbot
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and target then
        local head = target.Character and target.Character:FindFirstChild("Head")
        if head then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), 0.15)
        end
    end

    -- Magnet & Up Player
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if MagnetEnabled and myHRP then
                target.Character.HumanoidRootPart.CFrame = myHRP.CFrame * CFrame.new(0, 0, -10)
            end
            if UpPlayerEnabled then
                target.Character.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
            end
        end
    end

    -- SpinBot
    if SpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame =
            LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
    end

    -- Noclip
    if NoclipEnabled and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- ================================================
--              INICIALIZAR ESP
-- ================================================

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then CreateESP(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        for _, v in pairs(ESP_Objects[p]) do
            if type(v) == "table" then for _, l in pairs(v) do l:Remove() end
            else v:Remove() end
        end
        ESP_Objects[p] = nil
    end
end)

-- ================================================
print("╔══════════════════════════════╗")
print("║  ZZ HUB " .. VERSION .. " LOADED ✓         ║")
print("║  UI Redesigned               ║")
print("╚══════════════════════════════╝")
