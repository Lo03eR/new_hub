local Combat = {}
local RS = game:GetService("ReplicatedStorage")
local GunShot = RS:FindFirstChild("GunShot", true)
local QW = RS:FindFirstChild("qw", true)

function Combat.Fire(target)
    if target and GunShot then
        local headPos = target.Character.Head.Position
        local origin = game.Players.LocalPlayer.Character.Head.Position
        local dir = (headPos - origin).Unit
        pcall(function()
            GunShot:FireServer(headPos, target.Character.Head, dir, (headPos - origin).Magnitude)
        end)
    end
end

function Combat.AuraHit(target)
    if target and QW then
        pcall(function() QW:FireServer(target.Character.Head) end)
    end
end

return Combat