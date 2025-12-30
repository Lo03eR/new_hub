local Visuals = {}
local LP = game.Players.LocalPlayer

function Visuals.ApplyESP(player, state)
    local function Create(char)
        if not char then return end
        task.wait(0.5)
        local h = char:FindFirstChild("EliteHighlight") or Instance.new("Highlight")
        h.Name = "EliteHighlight"
        h.Parent = char
        h.FillColor = (player.Team == LP.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
        h.Enabled = state
    end
    player.CharacterAdded:Connect(Create)
    if player.Character then Create(player.Character) end
end

return Visuals