
-- ========================================
-- SHADOW HUB MM2
-- Version: 2.0 (Draggable + Menu Toggle)
-- Developer: ShadowHub6618
-- ========================================

print("Loading Shadow Hub MM2...")

-- ====== Load Rayfield UI ======
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sirius-fr/Rayfield/main/source.lua"))()
local Window = Library:CreateWindow({
    Title = "Shadow Hub MM2",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    Draggable = true,
    Keybind = Enum.KeyCode.F5,
    Size = UDim2.new(0, 500, 0, 400)
})

-- ====== Variables ======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Feature states
local ESPEnabled = false
local ESPConnections = {}
local FarmEnabled = false
local KillAuraEnabled = false
local SilentAimEnabled = false
local SpeedEnabled = false
local FlyEnabled = false
local MenuVisible = true

-- ========================================
-- Menu Toggle (F5 + Button)
-- ========================================
local function ToggleMenu()
    MenuVisible = not MenuVisible
    if MenuVisible then
        Window:SetVisible(true)
        print("Menu opened!")
    else
        Window:SetVisible(false)
        print("Menu closed!")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        ToggleMenu()
    end
end)

-- ========================================
-- Feature 1: ESP
-- ========================================
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = rootPart
    billboard.Parent = character
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.6
    frame.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = frame
    
    local roleText = ""
    local color = Color3.fromRGB(255, 255, 255)
    
    if character:FindFirstChild("Murderer") then
        roleText = "Murderer"
        color = Color3.fromRGB(255, 0, 0)
    elseif character:FindFirstChild("Sheriff") then
        roleText = "Sheriff"
        color = Color3.fromRGB(0, 150, 255)
    else
        roleText = "Innocent"
        color = Color3.fromRGB(100, 255, 100)
    end
    
    nameLabel.Text = player.Name .. " | " .. roleText
    nameLabel.TextColor3 = color
    
    table.insert(ESPConnections, {
        Billboard = billboard,
        Frame = frame,
        Label = nameLabel,
        Player = player
    })
end

local function ClearESP()
    for _, data in pairs(ESPConnections) do
        if data.Billboard and data.Billboard.Parent then
            data.Billboard:Destroy()
        end
    end
    ESPConnections = {}
end

local function ToggleESP(state)
    if state then
        ClearESP()
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        ESPConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                task.wait(1)
                CreateESP(player)
            end)
        end)
        ESPEnabled = true
        print("ESP enabled!")
    else
        ClearESP()
        if ESPConnections.PlayerAdded then
            ESPConnections.PlayerAdded:Disconnect()
            ESPConnections.PlayerAdded = nil
        end
        ESPEnabled = false
        print("ESP disabled!")
    end
end

-- ========================================
-- Feature 2: Auto Farm
-- ========================================
local FarmConnection = nil

local function AutoFarm()
    if not FarmEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                LocalPlayer.Character:SetPrimaryPartCFrame(root.CFrame + Vector3.new(0, 0, 3))
                task.wait(0.1)
            end
        end
    end
end

local function ToggleFarm(state)
    FarmEnabled = state
    if state then
        print("Auto Farm started!")
        FarmConnection = RunService.Heartbeat:Connect(AutoFarm)
    else
        print("Auto Farm stopped!")
        if FarmConnection then
            FarmConnection:Disconnect()
            FarmConnection = nil
        end
    end
end

-- ========================================
-- Feature 3: Kill Aura + Silent Aim
-- ========================================
local function GetClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    local character = LocalPlayer.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (root.Position - targetRoot.Position).Magnitude
                if dist < shortestDist and dist < 50 then
                    closest = player
                    shortestDist = dist
                end
            end
        end
    end
    return closest
end

local function UpdateSilentAim()
    if not SilentAimEnabled then return end
    
    local target = GetClosestPlayer()
    if target and target.Character then
        local targetHead = target.Character:FindFirstChild("Head")
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end

local function KillAura()
    if not KillAuraEnabled then return end
    
    local target = GetClosestPlayer()
    if target and target.Character then
        local targetHead = target.Character:FindFirstChild("Head")
        if targetHead then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                task.wait(0.1)
                tool:Deactivate()
            end
        end
    end
end

local KillAuraConnection = nil
local SilentAimConnection = nil

local function ToggleKillAura(state)
    KillAuraEnabled = state
    if state then
        print("Kill Aura enabled!")
        KillAuraConnection = RunService.Heartbeat:Connect(KillAura)
    else
        print("Kill Aura disabled!")
        if KillAuraConnection then
            KillAuraConnection:Disconnect()
            KillAuraConnection = nil
        end
    end
end

local function ToggleSilentAim(state)
    SilentAimEnabled = state
    if state then
        print("Silent Aim enabled!")
        SilentAimConnection = RunService.RenderStepped:Connect(UpdateSilentAim)
    else
        print("Silent Aim disabled!")
        if SilentAimConnection then
            SilentAimConnection:Disconnect()
            SilentAimConnection = nil
        end
    end
end

-- ========================================
-- Extra Features: Speed + Fly
-- ========================================
local function ToggleSpeed(state)
    SpeedEnabled = state
    if state then
        print("Speed enabled! (2x)")
        Humanoid.WalkSpeed = 32
    else
        print("Speed disabled!")
        Humanoid.WalkSpeed = 16
    end
end

local FlyConnection = nil
local function ToggleFly(state)
    FlyEnabled = state
    if state then
        print("Fly enabled! (WASD + Space/Shift)")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = Character:WaitForChild("HumanoidRootPart")
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled then return end
            local root = Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            
            if moveDirection.Magnitude > 0 then
                bodyVelocity.Velocity = moveDirection.Unit * 50
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        print("Fly disabled!")
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        local root = Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("BodyVelocity")
            if bv then bv:Destroy() end
        end
    end
end

-- ========================================
-- UI Creation
-- ========================================
local MainTab = Window:CreateTab("Main", true)
local MovementTab = Window:CreateTab("Movement", false)
local SettingsTab = Window:CreateTab("Settings", false)

-- ===== Main Tab =====
MainTab:CreateLabel("SHADOW HUB MM2")
MainTab:CreateLabel("Select features below")
MainTab:CreateLabel("--------------------")

MainTab:CreateToggle({
    Name = "ESP (Show Name + Role)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        ToggleESP(Value)
    end
})

MainTab:CreateToggle({
    Name = "Auto Farm (Coin Farm)",
    CurrentValue = false,
    Flag = "Farm",
    Callback = function(Value)
        ToggleFarm(Value)
    end
})

MainTab:CreateToggle({
    Name = "Kill Aura (Auto Attack)",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        ToggleKillAura(Value)
    end
})

MainTab:CreateToggle({
    Name = "Silent Aim (Auto Aim)",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value)
        ToggleSilentAim(Value)
    end
})

-- ===== Movement Tab =====
MovementTab:CreateLabel("MOVEMENT CONTROLS")
MovementTab:CreateLabel("--------------------")

MovementTab:CreateToggle({
    Name = "Speed (2x Faster)",
    CurrentValue = false,
    Flag = "Speed",
    Callback = function(Value)
        ToggleSpeed(Value)
    end
})

MovementTab:CreateToggle({
    Name = "Fly Mode (Free Flight)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        ToggleFly(Value)
    end
})

MovementTab:CreateLabel("--------------------")
MovementTab:CreateLabel("Flight Controls:")
MovementTab:CreateLabel("  W/A/S/D = Move")
MovementTab:CreateLabel("  Space = Ascend")
MovementTab:CreateLabel("  Shift = Descend")

-- ===== Settings Tab =====
SettingsTab:CreateLabel("SETTINGS")
SettingsTab:CreateLabel("--------------------")

SettingsTab:CreateButton({
    Name = "Toggle Menu (F5)",
    Callback = function()
        ToggleMenu()
    end
})

SettingsTab:CreateButton({
    Name = "Disable All Features",
    Callback = function()
        ToggleESP(false)
        ToggleFarm(false)
        ToggleKillAura(false)
        ToggleSilentAim(false)
        ToggleSpeed(false)
        ToggleFly(false)
        print("All features disabled!")
    end
})

SettingsTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            print("Teleported to spawn!")
        end
    end
})

SettingsTab:CreateLabel("--------------------")
SettingsTab:CreateLabel("Shadow Hub MM2 v2.0")
SettingsTab:CreateLabel("Developer: ShadowHub6618")
SettingsTab:CreateLabel("Use at your own risk!")
SettingsTab:CreateLabel("--------------------")
SettingsTab:CreateLabel("How to use:")
SettingsTab:CreateLabel("  • Press F5 = Toggle Menu")
SettingsTab:CreateLabel("  • Drag Title = Move Menu")
SettingsTab:CreateLabel("  • Click Toggle = Enable/Disable")

print("Shadow Hub MM2 v2.0 loaded successfully!")
print("Press F5 to toggle menu")
print("Drag the title to move menu")
