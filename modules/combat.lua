local Combat = {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function Combat.GetClosest(fov, wallCheck)
    local target, closest = nil, fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            -- Проверка на команду и щит (из Obsidian)
            if p.Team ~= LP.Team then
                local pos, onscreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onscreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < closest then
                        -- Wall Check (Raycast)
                        if wallCheck then
                            local ray = workspace:Raycast(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500, RaycastParams.new())
                            if ray and not ray.Instance:IsDescendantOf(p.Character) then continue end
                        end
                        closest = dist
                        target = p
                    end
                end
            end
        end
    end
    return target
end

return Combat