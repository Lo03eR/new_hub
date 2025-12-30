-- [[ FLICK ELITE | NO-KEY STABLE EDITION ]] --

-- Глобальные настройки
_G.Silent = false
_G.FOV = 150
_G.ESP_Enabled = false
_G.ESP_Color = Color3.fromRGB(255, 0, 50)

-- Загрузка библиотеки Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание основного окна
local Window = Rayfield:CreateWindow({
   Name = "FLICK ELITE | PRIVATE",
   LoadingTitle = "Elite Hub Loading...",
   LoadingSubtitle = "Direct Access Mode",
   ConfigurationSaving = { Enabled = false }
})

-- [[ ФУНКЦИИ ЧИТА ]] --

-- Silent Aim (Автоматическая наводка)
local function InitCombat()
    local LP = game.Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if _G.Silent and method == "FireServer" and not checkcaller() then
            local target = nil
            local closest = _G.FOV or 150
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                    if p.Team ~= LP.Team and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local pos, onscreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if onscreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                            if dist < closest then
                                closest = dist
                                target = p
                            end
                        end
                    end
                end
            end
            if target then
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then args[i] = target.Character.Head.Position end
                end
            end
        end
        return old(self, unpack(args))
    end)
end

-- ESP (Подсветка игроков)
local function InitVisuals()
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.ESP_Enabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    local hl = p.Character:FindFirstChild("EliteHighlight") or Instance.new("Highlight", p.Character)
                    hl.Name = "EliteHighlight"
                    hl.FillColor = _G.ESP_Color
                    hl.Enabled = true
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("EliteHighlight") then
                    p.Character.EliteHighlight.Enabled = false
                end
            end
        end
    end)
end

-- [[ ИНТЕРФЕЙС МЕНЮ ]] --

-- Вкладка COMBAT
local CombatTab = Window:CreateTab("Combat", "crosshair")
CombatTab:CreateSection("Silent Aim Settings")

CombatTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Callback = function(v) _G.Silent = v end,
})

CombatTab:CreateSlider({
   Name = "FOV Radius",
   Min = 50, Max = 600, DefaultValue = 150, Increment = 10,
   Callback = function(v) _G.FOV = v end,
})

-- Вкладка VISUALS
local VisualTab = Window:CreateTab("Visuals", "eye")
VisualTab:CreateSection("ESP Settings")

VisualTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(v) _G.ESP_Enabled = v end,
})

VisualTab:CreateColorPicker({
   Name = "ESP Color",
   Color = Color3.fromRGB(255, 0, 50),
   Callback = function(v) _G.ESP_Color = v end,
})

-- [[ ЗАПУСК ЛОГИКИ ]] --
InitCombat()
InitVisuals()

Rayfield:Notify({
    Title = "Flick Elite Loaded",
    Content = "Menu is ready for use!",
    Duration = 5
})