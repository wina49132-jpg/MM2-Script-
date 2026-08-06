-- MM2 Script
local p=game.Players.LocalPlayer
local g=Instance.new("ScreenGui",p.PlayerGui)
local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,200,0,250)
f.Position=UDim2.new(0.5,-100,0.5,-125)
f.BackgroundColor3=Color3.new(0.1,0.1,0.15)
f.Active=true
f.Draggable=true

local function b(t,y,c,a)
 local x=Instance.new("TextButton",f)
 x.Size=UDim2.new(0,180,0,35)
 x.Position=UDim2.new(0,10,0,y)
 x.Text=t
 x.BackgroundColor3=c
 x.TextColor3=Color3.new(1,1,1)
 x.BorderSizePixel=0
 x.MouseButton1Click:Connect(a)
end

b("Speed",20,Color3.new(0.3,0.3,0.8),function()
 p.Character.Humanoid.WalkSpeed=50
end)

b("KillAura",65,Color3.new(0.8,0.2,0.2),function()
 game:GetService("RunService").Heartbeat:Connect(function()
  for _,v in pairs(game.Players:GetPlayers())do
   if v~=p and v.Character and v.Character:FindFirstChild("Humanoid")then
    if(v.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude<25 then
     v.Character.Humanoid.Health=0
    end
   end
  end
 end)
end)

b("ESP",110,Color3.new(0.2,0.8,0.2),function()
 for _,v in pairs(game.Players:GetPlayers())do
  if v~=p and v.Character then
   local h=Instance.new("BillboardGui",v.Character)
   h.Size=UDim2.new(0,100,0,30)
   local l=Instance.new("TextLabel",h)
   l.Size=UDim2.new(1,0,1,0)
   l.Text=v.Name
   l.TextColor3=Color3.new(1,1,0)
   l.BackgroundTransparency=1
  end
 end
end)

b("Fly",155,Color3.new(0.8,0.6,0.2),function()
 p.Character.Humanoid.PlatformStand=true
 local bv=Instance.new("BodyVelocity",p.Character.HumanoidRootPart)
 bv.MaxForce=Vector3.new(1,1,1)*10000
 game:GetService("UserInputService").InputChanged:Connect(function(i)
  if i.IsKeyboard then
   local d=Vector3.new(0,0,0)
   if i.KeyCode==Enum.KeyCode.W then d=d+Vector3.new(0,0,-1)end
   if i.KeyCode==Enum.KeyCode.S then d=d+Vector3.new(0,0,1)end
   if i.KeyCode==Enum.KeyCode.A then d=d+Vector3.new(-1,0,0)end
   if i.KeyCode==Enum.KeyCode.D then d=d+Vector3.new(1,0,0)end
   if i.KeyCode==Enum.KeyCode.Space then d=d+Vector3.new(0,1,0)end
   if i.KeyCode==Enum.KeyCode.LeftShift then d=d+Vector3.new(0,-1,0)end
   bv.Velocity=d*50
  end
 end)
end)

local c=Instance.new("TextButton",f)
c.Size=UDim2.new(0,30,0,30)
c.Position=UDim2.new(1,-35,0,5)
c.Text="X"
c.BackgroundColor3=Color3.new(0.8,0,0)
c.TextColor3=Color3.new(1,1,1)
c.BorderSizePixel=0
c.MouseButton1Click:Connect(function()g:Destroy()end)

print("MM2 Script Loaded")
