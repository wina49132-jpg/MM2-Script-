local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local weaponsFolder = ReplicatedStorage:FindFirstChild("Weapons") or ReplicatedStorage
local knifeTemplate = weaponsFolder:FindFirstChild("Knife")
local gunTemplate = weaponsFolder:FindFirstChild("Gun")

local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "Remotes"
    remotes.Parent = ReplicatedStorage
end

local updateTimerEvent = remotes:FindFirstChild("UpdateTimer")
if not updateTimerEvent then
    updateTimerEvent = Instance.new("RemoteEvent")
    updateTimerEvent.Name = "UpdateTimer"
    updateTimerEvent.Parent = remotes
end

local function applyRoleAndGear(player, character, role)
    if not character then return end
    
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then item:Destroy() end
    end
    
    local oldHighlight = character:FindFirstChild("RoleHighlight")
    if oldHighlight then oldHighlight:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "RoleHighlight"
    highlight.Adornee = character
    highlight.Parent = character
    
    if role == "Murderer" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
        if knifeTemplate then
            local knife = knifeTemplate:Clone()
            knife.Parent = player.Backpack
        end
    elseif role == "Sheriff" then
        highlight.FillColor = Color3.fromRGB(0, 150, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 100, 200)
        if gunTemplate then
            local gun = gunTemplate:Clone()
            gun.Parent = player.Backpack
        end
    else
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
    end
end

local function assignRoles()
    local players = Players:GetPlayers()
    if #players < 1 then return end
    
    local murderer, sheriff
    
    if #players >= 2 then
        local mIndex = math.random(1, #players)
        murderer = players[mIndex]
        table.remove(players, mIndex)
        
        local sIndex = math.random(1, #players)
        sheriff = players[sIndex]
        table.remove(players, sIndex)
    else
        murderer = players[1]
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        local char = p.Character
        if char then
            if p == murderer then
                applyRoleAndGear(p, char, "Murderer")
            elseif p == sheriff then
                applyRoleAndGear(p, char, "Sheriff")
            else
                applyRoleAndGear(p, char, "Innocent")
            end
        end
    end
end

task.spawn(function()
    while true do
        assignRoles()
        for i = 180, 0, -1 do
            updateTimerEvent:FireAllClients(i)
            task.wait(1)
        end
        task.wait(5)
    end
end)
