local p=game:GetService("Players").LocalPlayer
local cam=workspace.CurrentCamera
local aim= false
game:GetService("UserInputService").InputBegan:Connect(function(k)
if k.KeyCode==Enum.KeyCode.RightControl then aim=not aim print("Aim:",aim and"ON"or"OFF")end
end)
game:GetService("RunService").RenderStepped:Connect(function()
if aim then
local t=nil;d=150;c=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
for _,p2 in p:GetPlayers()do
if p2~=p and p2.Character and p2.Character.Head then
local s,on=cam:WorldToViewportPoint(p2.Character.Head.Position)
if on and(s.Vector2-s-c).Magnitude<d then d=(s.Vector2-s-c).Magnitude t=p2 end
end end
if t and t.Character.Head then
cam.CFrame=cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position,t.Character.Head.Position),.4)
end end end)
print("Ctrl Direito=Toggle")
