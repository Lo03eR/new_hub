local Config = {
    Key = "ROBKEY"
}

-- [[ БИБЛИОТЕКА RAYFIELD ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ ОКНО ]] --
local Window = Rayfield:CreateWindow({
   Name = "FLICK ELITE | PRIVATE",
   LoadingTitle = "Elite Hub Loading...",
   LoadingSubtitle = "All-in-One Edition",
   ConfigurationSaving = { Enabled = false }
})

local LoginTab = Window:CreateTab("Login", "lock")

-- [[ ЛОГИКА COMBAT (ВСТРОЕННАЯ) ]] --
local function StartCombat()
    local LP = game.Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local function GetClosest()
        local target, closest = nil, _G.FOV or 150
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
        return target
    end

    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if _G.Silent and method == "FireServer" and not checkcaller() then
            local t = GetClosest()
            if t then
                for i, arg in ipairs(args) do
                    if typeof(arg) == "Vector3" then args[i] = t.Character.Head.Position
                    elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then args[i] = t.Character.Head end
                end
            end
        end
        return old(self, unpack(args))
    end)
end

-- [[ ЛОГИКА VISUALS (ВСТРОЕННАЯ) ]] --
local function StartVisuals()
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("EliteHighlight")
                if _G.ESP_Enabled and p.Team ~= game.Players.LocalPlayer.Team then
                    if not hl then
                        hl = Instance.new("Highlight", p.Character)
                        hl.Name = "EliteHighlight"
                    end
                    hl.FillColor = _G.ESP_Color or Color3.fromRGB(255,0,0)
                    hl.Enabled = true
                elseif hl then
                    hl.Enabled = false
                end
            end
        end
    end)
end

-- [[ ИНТЕРФЕЙС ЛОГИНА ]] --
LoginTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Default: ROBKEY",
   Callback = function(Text) _G.EnteredKey = Text end,
})

LoginTab:CreateButton({
   Name = "Verify & Unlock",
   Callback = function()
      if _G.EnteredKey == Config.Key then
         Rayfield:Notify({Title = "SUCCESS", Content = "Access Granted!", Duration = 3})
         
         -- Запускаем функции
         StartCombat()
         StartVisuals()

         -- Создаем рабочие вкладки
         local CombatTab = Window:CreateTab("Combat", "crosshair")
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

         local VisualTab = Window:CreateTab("Visuals", "eye")
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
      else
         Rayfield:Notify({Title = "ERROR", Content = "Wrong Key!", Duration = 3})
      end
   end,
})