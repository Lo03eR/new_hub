local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main",
    Key = "ROBKEY"
}

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. ОКНО КЛЮЧА
local KeyWindow = Rayfield:CreateWindow({
   Name = "FLICK ELITE | LOGIN",
   LoadingTitle = "Security Check",
   LoadingSubtitle = "by Lo03eR",
   ConfigurationSaving = { Enabled = false }
})

local KeyTab = KeyWindow:CreateTab("License", "key")

KeyTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Type key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.EnteredKey = Text
   end,
})

KeyTab:CreateButton({
   Name = "Check Key & Load Hub",
   Callback = function()
      if _G.EnteredKey == Config.Key then
         Rayfield:Notify({
            Title = "Success!",
            Content = "Access Granted. Loading Modules...",
            Duration = 3,
            Image = "check"
         })
         task.wait(1)
         KeyWindow:Destroy() -- Закрываем окно ключа
         StartMainHub()      -- Запускаем основной чит
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Wrong Key! Try again.",
            Duration = 3,
            Image = "x"
         })
      end
   end,
})

-- 2. ОСНОВНОЙ ХАБ (Запустится после ключа)
function StartMainHub()
    local Window = Rayfield:CreateWindow({
       Name = "FLICK ELITE V1",
       LoadingTitle = "Welcome to Elite",
       LoadingSubtitle = "Private Build",
       ConfigurationSaving = { Enabled = true, Folder = "EliteHub" }
    })

    local MainTab = Window:CreateTab("Combat", "crosshair")

    -- Подгружаем твой комбат-модуль с Гитхаба
    local function GetRaw(path)
        return loadstring(game:HttpGet(string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Config.Owner, Config.Repo, Config.Branch, path)))()
    end
    
    local Combat = GetRaw("modules/combat.lua")

    MainTab:CreateToggle({
       Name = "Silent Aim",
       CurrentValue = false,
       Flag = "SilentToggle",
       Callback = function(Value)
          _G.Silent = Value
       end,
    })

    MainTab:CreateSlider({
       Name = "FOV Size",
       Min = 50,
       Max = 600,
       DefaultValue = 150,
       Increment = 10,
       Suffix = "px",
       Flag = "FOVSlider",
       Callback = function(Value)
          _G.FOV = Value
       end,
    })
end