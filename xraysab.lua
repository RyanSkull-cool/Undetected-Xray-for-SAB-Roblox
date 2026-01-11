local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "RyanSkullXray"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "RyanSkull's Undetected Xray 👁️"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 160, 0, 30)
toggle.Position = UDim2.new(0.5, -80, 0, 45)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.Text = "XRAY: OFF"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 200, 0, 8)
sliderBg.Position = UDim2.new(0.5, -100, 0, 95)
sliderBg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sliderBg.Parent = frame
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- default 0.5
sliderFill.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
sliderFill.Parent = sliderBg
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0, 20)
sliderLabel.Position = UDim2.new(0, 0, 0, 105)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Transparency: 0.5"
sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 12
sliderLabel.Parent = frame

local dragging, dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local enabled = false
local transparencyValue = 0.5
local affectedParts = {}

local function applyXray()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency == 0 then
            affectedParts[obj] = 0
            obj.Transparency = transparencyValue
        end
    end
end

local function updateXray()
    for part in pairs(affectedParts) do
        if part and part.Parent then
            part.Transparency = transparencyValue
        end
    end
end

local function disableXray()
    for part, original in pairs(affectedParts) do
        if part and part.Parent then
            part.Transparency = original
        end
    end
    affectedParts = {}
end

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggle.Text = "XRAY: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        applyXray()
    else
        toggle.Text = "XRAY: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        disableXray()
    end
end)

local sliding = false

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local rel = math.clamp(
            (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X,
            0,
            1
        )

        rel = math.floor(rel * 10 + 0.5) / 10

        transparencyValue = rel
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        sliderLabel.Text = "Transparency: " .. rel

        if enabled then
            updateXray()
        end
    end
end)

