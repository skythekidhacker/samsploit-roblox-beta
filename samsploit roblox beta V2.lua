-- Create the GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SamSploit Roblox Beta"
gui.ResetOnSpawn = false

-- Create the background frame
local background = Instance.new("Frame")
background.Name = "Background"
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BackgroundTransparency = 0.5
background.Position = UDim2.new(0.5, -125, 0.5, -75)
background.Size = UDim2.new(0, 250, 0, 150)
background.Active = true
background.Draggable = true
background.Parent = gui

-- Create the title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Text = "SamSploit Roblox Beta"
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 0, 0)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = background

-- Create the title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Text = "Esp enabled automatically"
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 0, 0)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = background

-- Create the Aim button
local aimButton = Instance.new("TextButton")
aimButton.Name = "AimButton"
aimButton.Text = "Aim"
aimButton.Size = UDim2.new(0, 100, 0, 50)
aimButton.Position = UDim2.new(0.5, -50, 0.5, 25)
aimButton.Font = Enum.Font.SourceSansBold
aimButton.TextSize = 18
aimButton.Parent = background

-- Function to toggle aim
local function toggleAim()
    local closestPlayer
    local closestDistance = math.huge
    
    while aimButton.Parent ~= nil and aimButton.BackgroundColor3 == Color3.new(0, 1, 0) do
        local mouse = game.Players.LocalPlayer:GetMouse()
        local ray = game.Workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
        
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team then
                local part = player.Character.HumanoidRootPart
                local distance = (part.Position - ray.Origin - (part.Position - ray.Origin):Dot(ray.Unit.Direction) * ray.Unit.Direction).Magnitude
                
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
        
        if closestPlayer then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.p, closestPlayer.Character.HumanoidRootPart.Position)
        end
        
        wait()
    end
end


-- Function to handle user input service events
local function onInputBegan(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.E then
        if aimButton.BackgroundColor3 == Color3.new(1, 0, 0) then
            aimButton.BackgroundColor3 = Color3.new(0, 1, 0)
            toggleAim()
        else
            aimButton.BackgroundColor3 = Color3.new(1, 0, 0)
        end
    end
end

-- Connect the button events
aimButton.MouseButton1Click:Connect(function()
    if aimButton.BackgroundColor3 == Color3.new(1, 0, 0) then
        aimButton.BackgroundColor3 = Color3.new(0, 1, 0)
        toggleAim()
    else
        aimButton.BackgroundColor3 = Color3.new(1, 0, 0)
    end
end)

-- Connect the user input service events
game:GetService("UserInputService").InputBegan:Connect(onInputBegan)

-- Add the GUI to the player's screen
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
gui.Parent = playerGui
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to create the ESP box
local function createESP(player)
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "ESPBox"
    Box.Adornee = player.Character.HumanoidRootPart
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Size = player.Character.HumanoidRootPart.Size + Vector3.new(0.1, 0.1, 0.1)
    Box.Color3 = Color3.fromRGB(255, 0, 0)
    Box.Transparency = 0.7
    Box.Parent = player.Character.HumanoidRootPart
end

-- Function to remove the ESP box
local function removeESP(player)
    local Box = player.Character.HumanoidRootPart:FindFirstChild("ESPBox")
    if Box then
        Box:Destroy()
    end
end

-- Function to update the ESP for all visible enemies
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            local onScreen, position = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                createESP(player)
            else
                removeESP(player)
            end
        else
            removeESP(player)
        end
    end
end

-- Call the updateESP function every frame
game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()
end)
