-- [[ FLICK ELITE CORE ]] --
local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main",
    Key = "ROBKEY" -- Твой ключ
}

local function GetRaw(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Config.Owner, Config.Repo, Config.Branch, path)
    return loadstring(game:HttpGet(url))()
end

-- 1. СИСТЕМА КЛЮЧЕЙ (Стиль ROBScript)
local function LoadKeySystem()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local gui = (gethui and gethui()) or game:GetService("CoreGui")

    local ScreenGui = Instance.new("ScreenGui", gui)
    ScreenGui.Name = "EliteKeySystem"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 350, 0, 180)
    Main.Position = UDim2.new(0.5, -175, 0.5, -90)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "FLICK ELITE ACCESS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1

    local KeyBox = Instance.new("TextBox", Main)
    KeyBox.Size = UDim2.new(0.9, 0, 0, 35)
    KeyBox.Position = UDim2.new(0.05, 0, 0.4, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyBox.PlaceholderText = "Enter License Key..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.white
    Instance.new("UICorner", KeyBox)

    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = UDim2.new(0.05, 0, 0.7, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    Btn.Text = "LOGIN"
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn)

    -- Эффект тряски при ошибке
    local function Shake()
        local orig = Main.Position
        for i = 1, 6 do
            Main.Position = orig + UDim2.new(0, i%2==0 and 5 or -5, 0, 0)
            task.wait(0.02)
        end
        Main.Position = orig
    end

    Btn.MouseButton1Click:Connect(function()
        if KeyBox.Text == Config.Key then
            ScreenGui:Destroy()
            StartLoading() -- Переход к загрузке
        else
            Shake()
            Btn.Text = "WRONG KEY!"
            task.wait(1)
            Btn.Text = "LOGIN"
        end
    end)
end

-- 2. АНИМАЦИЯ ЗАГРУЗКИ (Стиль UNXHub)
function StartLoading()
    local Screen = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    local BarBG = Instance.new("Frame", Screen)
    BarBG.Size = UDim2.new(0, 300, 0, 4)
    BarBG.Position = UDim2.new(0.5, -150, 0.5, 0)
    BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local Fill = Instance.new("Frame", BarBG)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(169, 112, 255) -- Фиолетовый как у UNX

    local Status = Instance.new("TextLabel", Screen)
    Status.Position = UDim2.new(0.5, -150, 0.5, -25)
    Status.Size = UDim2.new(0, 300, 0, 20)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.white
    Status.Font = Enum.Font.Code
    Status.Text = "Initializing Engine..."

    local stages = {"Bypassing Anti-Cheat...", "Loading Obsidian Modules...", "Finalizing UI...", "Welcome, " .. game.Players.LocalPlayer.Name}
    
    for i, msg in ipairs(stages) do
        Status.Text = msg
        game:GetService("TweenService"):Create(Fill, TweenInfo.new(0.8), {Size = UDim2.new(i/#stages, 0, 1, 0)}):Play()
        task.wait(1)
    end
    
    Screen:Destroy()
    MainHub() -- Запуск основного чита
end

-- 3. ОСНОВНОЙ ХАБ (Движок Obsidian)
function MainHub()
    -- Сюда мы подключаем библиотеку Obsidian, которую ты нашел
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
    local Window = Library:CreateWindow({ Title = "FLICK ELITE | PRIVATE", Footer = "Build: 2025" })
    
    local Main = Window:AddTab("Main", "user")
    
    -- Подключаем наши модули с GitHub
    local Combat = GetRaw("modules/combat.lua")
    
    Main:AddToggle("SilentAim", { Text = "Silent Aim (Bypass)", Default = false, Callback = function(v)
        _G.Silent = v
    end})
    
    -- Главный цикл работы аима
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Silent and Combat then
            local target = Combat.GetClosest(150, true) -- 150 FOV + Wallcheck
            if target then
                -- Логика выстрела (мы ее допишем в модуле)
            end
        end
    end)
end

-- СТАРТ
LoadKeySystem()