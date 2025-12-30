-- [[ CONFIGURATION ]] --
local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main"
}

-- Функция для получения кода модулей
local function GetRaw(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Config.Owner, Config.Repo, Config.Branch, path)
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success then
        local func, err = loadstring(result)
        if func then return func() end
        warn("Ошибка компиляции модуля " .. path .. ": " .. tostring(err))
    else
        warn("Не удалось скачать модуль: " .. path)
    end
end

-- [[ LOADING ASSETS ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Keys = GetRaw("keys.lua") -- Твой список ключей

-- [[ KEY SYSTEM ]] --
local Window = Rayfield:CreateWindow({
   Name = "FLICK ELITE | PRIVATE",
   LoadingTitle = "Authenticating...",
   KeySystem = true,
   KeySettings = {
      Title = "Elite Access",
      Subtitle = "Enter Key",
      Note = "Contact Lo03eR for access",
      FileName = "FlickEliteKey",
      SaveKey = true,
      Key = {"FREE-ACCESS-123", "ELITE-USER-999", "TEST-KEY-000"} -- Можно заменить на проверку через таблицу Keys
   }
})

-- [[ MODULES INITIALIZATION ]] --
-- Эти переменные теперь содержат функции из твоих файлов в папке modules
local Combat = GetRaw("modules/combat.lua")
local Visuals = GetRaw("modules/visuals.lua")
local Misc = GetRaw("modules/misc.lua")

-- [[ GUI TABS ]] --
local MainTab = Window:CreateTab("Combat", 4483345998)

MainTab:CreateToggle({
   Name = "Silent Aim",
   Default = false,
   Callback = function(Value)
       -- Допустим, в модуле combat.lua у тебя есть функция ToggleSilent
       if Combat and Combat.ToggleSilent then
           Combat.ToggleSilent(Value)
       end
   end,
})

-- Аналогично для Visuals
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
VisualsTab:CreateToggle({
    Name = "ESP Highlights",
    Default = false,
    Callback = function(Value)
        if Visuals and Visuals.ToggleESP then
            Visuals.ToggleESP(Value)
        end
    end
})

Rayfield:Notify({Title = "Loaded!", Content = "Elite Hub is ready for use", Duration = 5})