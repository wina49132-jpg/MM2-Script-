-- Rez Script for MM2 (Thai UI)
-- Created for educational and entertainment purposes

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- ตั้งค่า ScreenGui
ScreenGui.Name = "RezScriptMM2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- หน้าต่างหลัก (UI เลื่อน/ลากได้)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ปุ่ม/เมนูเลื่อนได้

UICorner.Parent = MainFrame

-- ชื่อสคริปต์ Rez
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Rez - MM2 Hub (TH)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

-- Scrolling Frame สำหรับใส่ปุ่มฟังก์ชัน
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ฟังก์ชันสร้างปุ่มกด
local function createButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = ScrollingFrame
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.Font = Enum.Font.Gotham
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.Parent = btn
	
	btn.MouseButton1Click:Connect(callback)
end

-- ==================== ระบบฟังก์ชันต่างๆ ====================

-- 1. เก็บปืนอัตโนมัติ
createButton("เก็บปืนอัตโนมัติ (Auto Grab Gun)", function()
	task.spawn(function()
		while task.wait(0.5) do
			pcall(function()
				local droppedGun = workspace:FindFirstChild("GunDrop")
				if droppedGun and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = droppedGun.CFrame
				end
			end)
		end
	end)
end)

-- 2. ยิงอัตโนมัติ (ใส่ปืนแล้วยิงฆาตกร)
createButton("ยิงอัตโนมัติ (Auto Shoot Murderer)", function()
	task.spawn(function()
		while task.wait(0.5) do
			pcall(function()
				local player = game.Players.LocalPlayer
				if player.Character and player.Character:FindFirstChild("Gun") then
					for _, p in pairs(game.Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							-- เช็คว่าคนนั้นถือมีด (เป็นฆาตกร)
							if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
								local args = {
									[1] = p.Character.HumanoidRootPart.Position
								}
								player.Character.Gun.KnifeServer.Shoot:InvokeServer(unpack(args))
							end
						end
					end
				end
			end)
		end
	end)
end)

-- 3. ฆ่าทุกคนอัตโนมัติ (กรณีเป็นฆาตกร)
createButton("ฆ่าทุกคนอัตโนมัติ (Auto Kill All)", function()
	task.spawn(function()
		while task.wait(0.5) do
			pcall(function()
				local player = game.Players.LocalPlayer
				if player.Character and (player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")) then
					local knife = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
					player.Character.Humanoid:EquipTool(knife)
					for _, p in pairs(game.Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
							knife:Activate()
						end
					end
				end
			end)
		end
	end)
end)

-- 4. ฟาร์มเงินอัตโนมัติ (เก็บบอนซ์/Coins)
createButton("ฟาร์มเงินอัตโนมัติ (Auto Farm Coins)", function()
	task.spawn(function()
		while task.wait(0.2) do
			pcall(function()
				local coinContainer = workspace:FindFirstChild("CoinContainer")
				if coinContainer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					for _, coin in pairs(coinContainer:GetChildren()) do
						if coin:FindFirstChild("TouchInterest") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
							task.wait(0.1)
						end
					end
				end
			end)
		end
	end)
end)

-- 5. ESP (บริสุทธิ์=เขียว, นายอำเภอ=ฟ้า, ฆาตกร=แดง)
createButton("เปิด/ปิด ESP (Role Highlight)", function()
	task.spawn(function()
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= game.Players.LocalPlayer then
				p.CharacterAdded:Connect(function(char)
					task.wait(1)
					local highlight = Instance.new("Highlight", char)
					highlight.Name = "ESPRole"
					
					-- เช็คบทบาทเบื้องต้น
					if p.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife") then
						highlight.FillColor = Color3.fromRGB(255, 0, 0) -- ฆาตกร: แดง
					elseif p.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun") then
						highlight.FillColor = Color3.fromRGB(0, 150, 255) -- นายอำเภอ: ฟ้า
					else
						highlight.FillColor = Color3.fromRGB(0, 255, 0) -- บริสุทธิ์: เขียว
					end
				end)
			end
		end
	end)
end)

-- 6. วิ่งเร็ว / กระโดดสูง
createButton("ปรับความเร็ว & กระโดด (Speed/Jump)", function()
	pcall(function()
		local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 25
			humanoid.JumpPower = 70
		end
	end)
end)

-- 7. ทะลุกำแพง (Noclip)
createButton("ทะลุกำแพง (Noclip)", function()
	game:GetService("RunService").Stepped:Connect(function()
		pcall(function()
			for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
	end)
end)

-- 8. Fling ระบบป่วน (ฆาตกร / นายอำเภอ / ทุกคน)
createButton("Fling ฆาตกร (Troll Murderer)", function()
	pcall(function()
		local target = nil
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife")) then
				target = p.Character
			end
		end
		if target and target:FindFirstChild("HumanoidRootPart") then
			local lrp = game.Players.LocalPlayer.Character.HumanoidRootPart
			lrp.CFrame = target.HumanoidRootPart.CFrame
		end
	end)
end)

-- 9. วาป (ไปล็อบบี้ / ในแมพ)
createButton("วาปไปล็อบบี้ (Teleport to Lobby)", function()
	pcall(function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0) -- พิกัดล็อบบี้ทั่วไป
	end)
end)

-- 10. บินได้ (Fly)
createButton("เปิดระบบบิน (Fly)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/1p6m2f8f"))() -- สคริปต์บินมาตรฐาน
end)
