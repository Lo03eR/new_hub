local Config = {
    Owner = "Lo03eR",
    Repo = "new_hub",
    Branch = "main",
    Key = "ROBKEY"
}

local function StartLoading()
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 300, 0, 20)
    frame.Position = UDim2.new(0.5, -150, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(169, 112, 255)
    
    local txt = Instance.new("TextLabel", sg)
    txt.Size = UDim2.new(0, 300, 0, 20)
    txt.Position = UDim2.new(0.5, -150, 0.5, -30)
    txt.Text = "LOADING ELITE HUB..."
    txt.TextColor3 = Color3.white
    txt.BackgroundTransparency = 1

    for i = 1, 100 do
        bar.Size = UDim2.new(i/100, 0, 1, 0)
        task.wait(0.02)
    end
    sg:Destroy()
    
    -- Запуск основного меню
    loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
end

local function LoadKeySystem()
    local gui = game:GetService("CoreGui")
    if gui:FindFirstChild("EliteKey") then gui.EliteKey:Destroy() end

    local sg = Instance.new("ScreenGui", gui)
    sg.Name = "EliteKey"
    sg.DisplayOrder = 100

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 300, 0, 160)
    main.Position = UDim2.new(0.5, -150, 0.5, -80)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(255, 255, 255) -- Белая рамка, чтобы видеть границы

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "ENTER KEY"
    title.TextColor3 = Color3.white
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local input = Instance.new("TextBox", main)
    input.Size = UDim2.new(0, 260, 0, 40)
    input.Position = UDim2.new(0, 20, 0, 55)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.Text = ""
    input.PlaceholderText = "Type Here..."
    input.TextColor3 = Color3.white
    input.ClearTextOnFocus = false

    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 105)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Ярко-зеленая кнопка
    btn.Text = "LOGIN"
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18

    btn.MouseButton1Click:Connect(function()
        if input.Text == Config.Key then
            sg:Destroy()
            StartLoading()
        else
            btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            btn.Text = "WRONG!"
            task.wait(1)
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            btn.Text = "LOGIN"
        end
    end)
end

LoadKeySystem()