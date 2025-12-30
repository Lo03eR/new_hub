-- [[ FLICK ELITE | COMBAT MODULE ]] --
local Combat = {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Поиск цели
function Combat.GetClosestTarget()
    local target = nil
    local closest = _G.FOV or 150

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
            -- Проверка на команду и здоровье
            if p.Team ~= LP.Team and p.Character.Humanoid.Health > 0 then
                local pos, onscreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                
                if onscreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if dist < closest then
                        -- Проверка видимости (Wall Check)
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {LP.Character, p.Character}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local ray = workspace:Raycast(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500, rayParams)
                        
                        if not ray then -- Если луч ни обо что не ударился (путь чист)
                            closest = dist
                            target = p
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Хук на выстрел
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.Silent and not checkcaller() and method == "FireServer" then
        if self.Name:lower():find("hit") or self.Name:lower():find("fire") then
            local target = Combat.GetClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                for i, arg in ipairs(args) do
                    if typeof(arg) == "Vector3" then
                        args[i] = target.Character.Head.Position
                    elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then
                        args[i] = target.Character.Head
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

return Combat