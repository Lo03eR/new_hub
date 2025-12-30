-- [[ FLICK ELITE | COMBAT MODULE ]] --
local Combat = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки по умолчанию (будут управляться из меню)
_G.Silent = _G.Silent or false
_G.FOV = _G.FOV or 150
_G.WallCheck = true

-- Функция поиска ближайшего игрока к курсору
function Combat.GetClosestTarget()
    local target = nil
    local closest = _G.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
            -- Проверка на команду и на то, что игрок жив
            if p.Team ~= LP.Team and p.Character.Humanoid.Health > 0 then
                local pos, onscreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                
                if onscreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if dist < closest then
                        -- Проверка на стены (Wall Check)
                        local pass = true
                        if _G.WallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LP.Character, p.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            
                            local ray = workspace:Raycast(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500, rayParams)
                            if ray then pass = false end
                        end

                        if pass then
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

-- Основная логика Silent Aim (Перехват выстрела)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Проверяем, что включен Silent и идет попытка выстрела
    if _G.Silent and not checkcaller() then
        -- Flick Shooter использует RemoteEvent для регистрации попаданий/выстрелов
        -- Мы перехватываем отправку данных и подменяем позицию на голову цели
        if method == "FireServer" and (self.Name:lower():find("hit") or self.Name:lower():find("fire")) then
            local target = Combat.GetClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                -- В зависимости от игры, аргументы могут быть разными (позиция или объект)
                -- Мы подменяем позицию попадания на позицию головы цели
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

print("[FLICK ELITE] Combat Module Loaded!")
return Combat