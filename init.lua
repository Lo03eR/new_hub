-- [[ FLICK ELITE | FINAL FIXED CORE ]] --

local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main",
    Key = "ROBKEY" -- Твой ключ для входа
}

-- Улучшенная функция загрузки модулей
local function GetRaw(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Config.Owner, Config.Repo, Config.Branch, path)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result ~= "404: Not Found" then
        local fn, err = loadstring(result)
        if fn then return fn() end
    end
    return nil
end

-- [[ 1. СИСТЕМА ЗАГРУЗКИ (ПОСЛЕ ВВОДА КЛЮЧА) ]] --
local function StartLoading()
    local gui = (gethui and gethui()) or game:GetService("CoreGui")
    local Screen = Instance.new("ScreenGui", gui)
    Screen.Name = "EliteLoader"

    local BarBG = Instance.new("Frame", Screen)
    BarBG.Size = UDim2.new(0, 300, 0, 8)
    BarBG.Position = UDim2.new(0.5, -150, 0.5, 0)
    BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BarBG.BorderSizePixel = 0
    Instance.new("UICorner", BarBG)
    Instance.new("UIStroke", BarBG).Color = Color3.fromRGB(100, 100, 100)

    local Fill = Instance.new("Frame", BarBG)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(169, 112, 255)
    Instance.new("UICorner", Fill)

    local Status = Instance.new("TextLabel", Screen)
    Status.Position = UDim2.new(0.5, -150, 0.5, -35)
    Status.Size = UDim2.new(0, 300, 0, 25)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.white
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 16
    Status.Text = "Starting Elite Hub..."

    local stages = {"Bypassing Anti-Cheat...", "Loading Combat Modules...", "Injecting Visuals...", "Welcome, " .. game.Players.LocalPlayer.Name}
    
    for i, msg in ipairs(stages) do
        Status.Text = msg
        game:GetService("TweenService"):Create(Fill, TweenInfo.new(0.7), {Size = UDim2.new(i/#stages, 0, 1, 0)}):Play()
        task.wait(0.8)
    end
    
    Screen:Destroy()
    
    -- ЗАПУСК ОСНОВНОГО МЕНЮ (Obsidian Library)
    local lib_url = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
    local Library = loadstring(game:HttpGet(lib_url))()
    local Window = Library:CreateWindow({ Title = "FLICK ELITE | PRIVATE", Footer = "Build: 2025" })
    
    local MainTab = Window:AddTab("Combat", "crosshair")
    
    -- Подгружаем боевой модуль
    local Combat = GetRaw("modules/combat.lua")
    
    MainTab:AddToggle("SilentAim", { Text = "Silent Aim (OP)", Default = false, Callback = function(v) _G.Silent = v end })
    MainTab:AddSlider("FOV", { Text = "FOV Size", Default = 150, Min = 50, Max = 600, Callback = function(v) _G.FOV = v end })
end

-- [[ 2. ИСПРАВЛЕННАЯ СИСТЕМА КЛЮЧЕЙ ]] --
local function LoadKeySystem()
    local gui = (gethui and gethui()) or game:GetService("CoreGui")
    
    -- Удаляем старое окно если есть
    if gui:FindFirstChild("EliteKeySystem") then gui.EliteKeySystem:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", gui)
    ScreenGui.Name = "EliteKeySystem"
    ScreenGui.DisplayOrder = 999 -- Поверх всего остального
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 210)
    Main.Position = UDim2.new(0.5, -180, 0.5, -105)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true -- Теперь окно можно таскать
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 55)
    Title.BackgroundTransparency = 1
    Title.Text = "FLICK ELITE ACCESS"
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.ZIndex = 5

    local KeyBox = Instance.new("TextBox", Main)
    KeyBox.Name = "KeyInput"
    KeyBox.Size = UDim2.new(0, 300, 0, 45)
    KeyBox.Position = UDim2.new(0.5, -150, 0.45, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyBox.PlaceholderText = "Enter License Key..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.white
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 16
    KeyBox.ZIndex = 10 -- Важно
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)
    local KeyStroke = Instance.new("UIStroke", KeyBox)
    KeyStroke.Color = Color3.fromRGB(60, 60, 60)

    local Btn = Instance.new("TextButton", Main)
    Btn.Name = "LoginBtn"
    Btn.Size = UDim2.new(0, 300, 0, 45)
    Btn.Position = UDim2.new(0.5, -150, 0.73, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Btn.Text = "LOGIN"
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 18
    Btn.ZIndex = 10 -- Важно
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    -- Анимация при клике
    Btn.MouseButton1Click:Connect(function()
        if KeyBox.Text == Config.Key then
            ScreenGui:Destroy()
            StartLoading()
        else
            -- Тряска (из ROBScript)
            local orig = Main.Position
            for i = 1, 6 do
                Main.Position = orig + UDim2.new(0, i%2==0 and 6 or -6, 0, 0)
                task.wait(0.02)
            end
            Main.Position = orig
            Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            Btn.Text = "INVALID KEY"
            task.wait(1.5)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            Btn.Text = "LOGIN"
        end
    end)
end

-- ЗАПУСК
LoadKeySystem()