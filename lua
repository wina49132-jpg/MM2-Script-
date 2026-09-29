-- โค้ดเมนูสคริปต์ MM2 สำหรับทดสอบ
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "MM2 Test Script by Arceus X", HidePremium = false, SaveConfig = true, ConfigFolder = "MM2Test"})

local Tab = Window:MakeTab({
	Name = "หน้าหลัก",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "กดเพื่อเทสระบบแจ้งเตือน",
	Callback = function()
      game.StarterGui:SetCore("SendNotification", {
          Title = "MM2 Success",
          Text = "เย้! รันสคริปต์ผ่าน Arceus X สำเร็จแล้ว!",
          Duration = 4
      })
	end
})

Tab:AddButton({
	Name = "พิมพ์ข้อความในแชท",
	Callback = function()
      print("สคริปต์ MM2 ทำงานปกติไม่มีสะดุด")
	end
})

OrionLib:Init()
