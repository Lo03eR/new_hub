-- Замени ссылки на свои, когда зальешь на GitHub
local baseUrl = "https://raw.githubusercontent.com/ТВОЙ_НИК/FlickElite/main/"

local Visuals = loadstring(game:HttpGet(baseUrl .. "modules/visuals.lua"))()
local Combat = loadstring(game:HttpGet(baseUrl .. "modules/combat.lua"))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({Name = "FLICK ELITE | MODULAR"})
local Tab = Window:CreateTab("Main")

-- Пример использования модуля
Tab:CreateToggle({
    Name = "ESP Highlights",
    Default = true,
    Callback = function(v)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                Visuals.ApplyESP(p, v)
            end
        end
    end
})

-- Логика Аима в цикле
game:GetService("RunService").RenderStepped:Connect(function()
    -- Здесь вызываем Combat.Fire(target) если включен аим
end)