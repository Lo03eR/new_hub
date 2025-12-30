-- [[ FLICK ELITE | VISUAL MODULE ]] --
local Visuals = {}
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

-- Основной цикл отрисовки
RunService.RenderStepped:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local char = p.Character
            local highlight = char:FindFirstChild("EliteHighlight")

            if _G.ESP_Enabled and p.Team ~= LP.Team and char:FindFirstChild("HumanoidRootPart") then
                -- Если ESP включен и игрока надо подсветить
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "EliteHighlight"
                    highlight.Parent = char
                end
                
                highlight.FillColor = _G.ESP_Color or Color3.fromRGB(255, 0, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Enabled = true
            else
                -- Если выключен или это союзник — скрываем
                if highlight then
                    highlight.Enabled = false
                end
            end
        end
    end
end)

-- Удаление при выгрузке
function Visuals.Cleanup()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("EliteHighlight") then
            p.Character.EliteHighlight:Destroy()
        end
    end
end

return Visuals