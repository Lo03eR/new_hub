-- [[ FLICK ELITE | FULL CORE INITIALIZER ]] --

local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main",
    Key = "ROBKEY" -- Твой секретный ключ
}

-- Функция для подгрузки модулей с твоего GitHub
local function GetRaw(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Config.Owner, Config.Repo, Config.Branch, path)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local fn, err = loadstring(result)
        if fn then return fn() end
        warn("Error loading module: " .. path .. " | " .. tostring(err))
    end
    return nil
end

-- [[ СИСТЕМА ЗАГРУЗКИ (STYLE UNX) ]] --
local function StartLoading()
    local gui = (gethui and gethui()) or game:GetService("CoreGui")
    local Screen = Instance.new("ScreenGui", gui)
    Screen.Name = "EliteLoader"

    local BarBG = Instance.new("Frame", Screen)
    BarBG.Size = UDim2.new(0, 300, 0, 6)
    BarBG.Position = UDim2.new(0.5, -150, 0.5, 0)
    BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BarBG.BorderSizePixel = 0
    Instance.new("UICorner", BarBG)

    local Fill = Instance.new("Frame", BarBG)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(169, 112, 255)
    Instance.new("UICorner", Fill)

    local Status = Instance.new("TextLabel", Screen)
    Status.Position = UDim2.new(0.5, -150, 0.5, -30)
    Status.Size = UDim2.new(0, 300, 0, 20)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Font = Enum.Font.GothamMedium
    Status.TextSize = 14
    Status.Text = "Starting..."

    local stages = {
        {msg = "Checking Compatibility...", time = 0.8},
        {msg = "Fetching Combat Modules...", time = 1.2},
        {msg = "Injecting Visuals...", time = 1.0},
        {msg = "Finalizing Interface...", time = 0.5}
    }

    for i, stage in ipairs(stages) do
        Status.Text = stage.msg
        game:GetService("TweenService"):Create(Fill, TweenInfo.new(stage.time), {Size = UDim2.new(i/#stages, 0, 1, 0)}):Play()
        task.wait(stage.time)
    end

    Screen:Destroy()
    
    -- Запуск основного меню (Obsidian Library)
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
    local Window = Library:CreateWindow({ Title = "FLICK ELITE V1", Footer = "User: " .. game.Players.LocalPlayer.Name })
    
    local MainTab = Window:AddTab("Main", "crosshair")
    local VisualsTab = Window:AddTab("Visuals", "eye")

    -- Подключаем твои модули
    local CombatModule = GetRaw("modules/combat.lua")
    
    MainTab:AddToggle("SilentAim", { Text = "Silent Aim", Default = false, Callback = function(v) _G.Silent = v end })
    MainTab:AddSlider("FOV", { Text = "FOV Radius", Default = 150, Min = 50, Max = 500, Callback = function(v) _G.FOV = v end })
end

-- [[ СИСТЕМА КЛЮЧЕЙ (STYLE ROBSCRIPT) ]] --
local function LoadKeySystem()
    local gui = (gethui and gethui()) or game:GetService("CoreGui")
    if gui:FindFirstChild("EliteKeySystem") then gui.EliteKeySystem:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", gui)
    ScreenGui.Name = "EliteKeySystem"
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 350, 0, 200)
    Main.Position = UDim2.new(0.5, -175, 0.5, -100)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 1.5

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "FLICK ELITE ACCESS"
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20

    local KeyBox = Instance.new("TextBox", Main)
    KeyBox.Size = UDim2.new(0, 280, 0, 40)
    KeyBox.Position = UDim2.new(0.5, -140, 0.45, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyBox.PlaceholderText = "Enter Key..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.white
    Instance.new("UICorner", KeyBox)

    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 280, 0, 45)
    Btn.Position = UDim2.new(0.5, -140, 0.72, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Btn.Text = "LOGIN"
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        if KeyBox.Text == Config.Key then
            ScreenGui:Destroy()
            StartLoading()
        else
            -- Эффект тряски
            local orig = Main.Position
            for i = 1, 6 do
                Main.Position = orig + UDim2.new(0, i%2==0 and 5 or -5, 0, 0)
                task.wait(0.02)
            end
            Main.Position = orig
            Btn.Text = "WRONG KEY!"
            task.wait(1)
            Btn.Text = "LOGIN"
        end
    end)
end

-- СТАРТ ПРИЛОЖЕНИЯ
LoadKeySystem()