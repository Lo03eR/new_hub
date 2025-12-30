local Visuals = {}
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

function Visuals.InitESP(enabled)
    if not enabled then 
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
        return 
    end

    RunService.RenderStepped:Connect(function()
        if not enabled then return end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                -- Проверка на команду
                if p.Team ~= LP.Team then
                    local high = char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", char)
                    high.FillColor = Color3.fromRGB(255, 0, 50)
                    high.OutlineColor = Color3.fromRGB(255, 255, 255)
                    high.FillTransparency = 0.6
                end
            end
        end
    end)
end

return Visuals