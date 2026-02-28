local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimEnabled = false
local AIM_STRENGTH = 0.4
local AIM_RADIUS = 150

-- SUPER SIMPLES - SEM NENHUMA GUI
game:GetService("UserInputService").InputBegan:Connect(function(input)
\tif input.KeyCode == Enum.KeyCode.RightControl then
\t\taimEnabled = not aimEnabled
\t\tprint("Aim Assist:", aimEnabled and "ATIVADO" or "DESATIVADO")
\tend
end)

-- AIM LOOP MÍNIMO
RunService.RenderStepped:Connect(function()
\tif aimEnabled then
\t\tlocal closestPlayer = nil
\t\tlocal shortestDistance = AIM_RADIUS
\t\t
\t\tfor _, otherPlayer in pairs(Players:GetPlayers()) do
\t\t\tif otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
\t\t\t\tlocal head = otherPlayer.Character.Head
\t\t\t\tlocal screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
\t\t\t\t
\t\t\t\tif onScreen then
\t\t\t\t\tlocal screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
\t\t\t\t\tlocal distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
\t\t\t\t\t
\t\t\t\t\tif distance < shortestDistance then
\t\t\t\t\t\tshortestDistance = distance
\t\t\t\t\t\tclosestPlayer = otherPlayer
\t\t\t\t\tend
\t\t\t\tend
\t\t\tend
\t\tend
\t\t
\t\tif closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
\t\t\tlocal headPos = closestPlayer.Character.Head.Position
\t\t\tlocal targetCFrame = CFrame.lookAt(Camera.CFrame.Position, headPos)
\t\t\tCamera.CFrame = Camera.CFrame:Lerp(targetCFrame, AIM_STRENGTH)
\t\tend
\tend
end)

print("=== AIM ASSIST DELTA ===")
print("APERTE RIGHT CONTROL pra ligar/desligar")
print("Status no F12 (console)")
