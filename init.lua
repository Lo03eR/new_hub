local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main",
    Key = "ROBKEY"
}

-- Глобальные переменные для работы модулей
_G.Silent = false
_G.FOV = 150
_G.ESP_Enabled = false
_G.ESP_Color = Color3.fromRGB(255, 0, 50)

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Функция загрузки модулей с GitHub
local function GetModule(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Config.Owner, Config.Repo, Config.Branch, path)
    local success, res = pcall(function() return game:HttpGet(url) end)
    if success and res ~= "404: Not Found" then
        local fn, err = loadstring(res)
        if fn then return fn() end
        warn("Error in module " .. path .. ": " .. tostring(err))
    end
    return nil
end

local Window = Rayfield:CreateWindow({
   Name = "FLICK ELITE | PRIVATE",
   LoadingTitle = "Checking Authorization...",
   LoadingSubtitle = "by Lo03eR",
   ConfigurationSaving = { Enabled = false }
})

local LoginTab = Window:CreateTab("Login", "lock")

LoginTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Key here...",
   Callback = function(Text) _G.EnteredKey = Text end,
})

LoginTab:CreateButton({
   Name = "Verify & Load Hub",
   Callback = function()
      if _G.EnteredKey == Config.Key then
         Rayfield:Notify({
            Title = "ACCESS GRANTED",
            Content = "Welcome, " .. game.Players.LocalPlayer.Name,
            Duration = 3,
            Image = "check"
         })

         -- 1. Загружаем логику из файлов (Combat и Visual)
         local CombatMod = GetModule("modules/combat.lua")
         local VisualMod = GetModule("modules/visual.lua")

         -- 2. Создаем вкладку COMBAT
         local CombatTab = Window:CreateTab("Combat", "crosshair")
         CombatTab:CreateSection("Silent Aim")

         CombatTab:CreateToggle({
            Name = "Enable Silent Aim",
            CurrentValue = false,
            Callback = function(Value) _G.Silent = Value end,
         })

         CombatTab:CreateSlider({
            Name = "FOV Radius",
            Min = 50, Max = 600, DefaultValue = 150, Increment = 10,
            Callback = function(Value) _G.FOV = Value end,
         })

         -- 3. Создаем вкладку VISUALS
         local VisualTab = Window:CreateTab("Visuals", "eye")
         VisualTab:CreateSection("ESP Settings")

         VisualTab:CreateToggle({
            Name = "Player Highlights",
            CurrentValue = false,
            Callback = function(Value) _G.ESP_Enabled = Value end,
         })

         VisualTab:CreateColorPicker({
            Name = "Highlight Color",
            Color = _G.ESP_Color,
            Callback = function(Value) _G.ESP_Color = Value end,
         })

         -- 4. Скрываем вкладку логина (опционально)
         Rayfield:Notify({
            Title = "Ready!",
            Content = "All features are now unlocked.",
            Duration = 5
         })
      else
         Rayfield:Notify({
            Title = "INVALID KEY",
            Content = "Please check the key and try again.",
            Duration = 3,
            Image = "x"
         })
      end
   end,
})