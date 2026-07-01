loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Midnight-intro.lua"))()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Optimization: Central connection manager
local connections = {}
local function addConnection(name, connection)
    if connections[name] then
        connections[name]:Disconnect()
    end
    connections[name] = connection
end
local function disconnectAll()
    for name, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    connections = {}
end



WindUI:SetNotificationLower(true)

WindUI:AddTheme({
    Name = "Midnight",

    Accent = WindUI:Gradient({                                                  
        ["0"] = { Color = Color3.fromHex("#2e004f"), Transparency = 0.2 },        
        ["100"]   = { Color = Color3.fromHex("#8d09b5"), Transparency = 0.2 },    
    }, {                                                                        
        Rotation = 45,                                                           
    }),  
    Accent = "#a855f7",
    Dialog = "#2E004F",
    Outline = "#6b21a8",
    Text = "#f3e8ff",
    Placeholder = "#d8b4fe",
    Background = "#2e004f",
    Button = "#9333ea",
    Icon = "#e9d5ff",
})

local Window = WindUI:CreateWindow({
    Title = "Midnight Hub",
    Icon = "moon",
    Author = "Gennskie Development",
    Folder = "Midnight Hub",
    Size = UDim2.fromOffset(580, 360),
    Transparent = true,
    Theme = "Midnight",
    Resizable = true,
    SideBarWidth = 200,
    Background = "",
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
   
})

Window:EditOpenButton({
    Enabled = false
})

local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("MidnightHub")

local gui = Instance.new("ScreenGui")
gui.Name = "StrikeXMenuGUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local button = Instance.new("ImageButton")
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(0, 70, 0, 70)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.Image = "rbxassetid://119615372248548"
button.Name = "StrikeXToggle"
button.AutoButtonColor = true
button.Parent = gui

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(20, 0, 54)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
}
gradient.Rotation = 45
gradient.Parent = stroke

local dragging, dragInput, dragStart, startPos
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local opened = true
button.MouseButton1Click:Connect(function()
    opened = not opened
    if opened then
        if typeof(Window.Open) == "function" then
            Window:Open()
        end
    else
        if typeof(Window.Close) == "function" then
            Window:Close()
        end
    end
end)

Window:OnDestroy(function()
    gui:Destroy()
end)

Window:Tag({
    Title = "Free",
    Color = Color3.fromHex("#663399")
})

Window:Tag({
    Title = "V1.6.2",
    Color = Color3.fromHex("#663399")
})




local Tab = Window:Tab({
    Title = "Home",
    Icon = "house",
    Locked = false,
})




local function getExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Unknown Executor"
    end
end

local Paragraph = Tab:Paragraph({
    Title = "Executor Information",
    Desc = "Executor: " .. getExecutor(),
    Color = Color3.fromRGB(147, 51, 234),
    Transparency = 0.42, 
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false
})

local Keybind = Tab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Flag = "KeybindElement",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})
myConfig:Register("KeybindElement", Keybind)

local Button = Tab:Button({
    Title = "Open Roblox Console",
    Desc = "Opens the developer console",
    Locked = false,
    Callback = function()
        pcall(function()
            StarterGui:SetCore("DevConsoleVisible", true)
        end)
    end
})

local Button = Tab:Button({
    Title = "Unc Test",
    Desc = "Take the UNC test to see capabilities of your executor!",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://github.com/ltseverydayyou/uuuuuuu/blob/main/UNC%20test?raw=true"))()
            WindUI:Notify({
    Title = "UNC test results",
    Content = "Type /console in chat or press F9 to view results.",
    Duration = 5, 
    Icon = "list-checks",
})
    end
})

local Button = Tab:Button({
    Title = "Discord",
    Desc = "Copy Discord Server Link",
    Locked = false,
    Callback = function()
         setclipboard("https://discord.gg/Yqak7y7DYT")
            WindUI:Notify({
    Title = "Copied!",
    Content = "Discord link copied to clipboard",
    Duration = 2, 
    Icon = "check",
})
    end
})

local Button = Tab:Button({
    Title = "Tiktok",
    Desc = "Copy Tiktok profile Link",
    Locked = false,
    Callback = function()
         setclipboard("https://www.tiktok.com/@yeahblxr")
            WindUI:Notify({
    Title = "Copied!",
    Content = "Tiktok link copied to clipboard",
    Duration = 2, 
    Icon = "check",
})
    end
})

local Button = Tab:Button({
    Title = "Github",
    Desc = "Copy Github Link",
    Locked = false,
    Callback = function()
         setclipboard("https://github.com/yeahblxr/-Midnight-hub/blob/main/Midnight%20Hub")
            WindUI:Notify({
    Title = "Copied!",
    Content = "Github link copied to clipboard",
    Duration = 2,
    Icon = "check",
})
    end
})

local Tab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

-- Already defined at top of script
local speedValue = 16
local jumpValue = 50

local speedConnection = nil
local jumpConnection = nil


local WalkspeedSlider = Tab:Slider({
    Title = "Walkspeed",
    Step = 2,
    Flag = "WalkspeedSlider",
    Value = {
        Min = 1,
        Max = 500,
        Default = 16,
    },
    Callback = function(value)
        speedValue = value
    end
})



local WalkspeedToggle = Tab:Toggle({
    Title = "Enable Walkspeed",
    Desc = "Loop set WalkSpeed",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)

        if state then
            speedConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = speedValue
                end
            end)
            addConnection("WalkspeedLoop", speedConnection)
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
        end
    end
})

Tab:Divider()

local JumppowerSlider = Tab:Slider({
    Title = "Jumppower",
    Step = 10,
    Flag = "JumppowerSlider",
    Value = {
        Min = 1,
        Max = 1000,
        Default = 50,
    },
    Callback = function(value)
        jumpValue = value
    end
})




local JumppowerToggle = Tab:Toggle({
    Title = "Enable Jumppower",
    Desc = "Loop set JumpPower",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)

        if state then
            jumpConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.JumpPower = jumpValue
                end
            end)
            addConnection("JumppowerLoop", jumpConnection)
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end
})

Tab:Divider()

local infiniteJumpConnection

local Toggle = Tab:Toggle({
    Title = "Infinite Jump",
    Desc = "Allows you jump in the air",
    Icon = "infinity",
    Type = "Checkbox",
    Default = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(enabled) 
        if enabled then
            if infiniteJumpConnection then return end

            infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if not character then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            addConnection("InfiniteJump", infiniteJumpConnection)
        else
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
        end
    end,
})
myConfig:Register("InfiniteJumpToggle", Toggle)

local Button = Tab:Button({
    Title = "Fly Gui",
    Desc = "Custom-made fly GUI to match the theme of Midnight Hub (inspired by fly GUI V3)",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/-Midnight-hub/refs/heads/main/Midnighthub_Fly.lua"))()
    end
})

local floatName = nil 

local Toggle = Tab:Toggle({
    Title = "Noclip",
    Desc = "Toggle for noclip (after disable jump to fully diable noclip)",
    Icon = "brick-wall",
    Type = "Checkbox",
    Default = false,
    Flag = "NoclipToggle",
    Callback = function(Value) 
        local noclipConnection = nil
        local noclipParts = {}

        local function enableNoclip()
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            local function setupNoclip()
                noclipParts = {}
                local player = game.Players.LocalPlayer
                local character = player and player.Character
                if character then
                    for _, v in pairs(character:GetDescendants()) do
                        if v:IsA("BasePart") and (not floatName or v.Name ~= floatName) then
                            table.insert(noclipParts, v)
                        end
                    end
                end
            end

            setupNoclip()
            
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, v in ipairs(noclipParts) do
                    if v and v.Parent and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end)
            
            addConnection("Noclip", noclipConnection)
        end

        local function disableNoclip()
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            noclipParts = {}
        end

        if Value then
            enableNoclip()
        else
            disableNoclip()
        end
    end,
})
myConfig:Register("NoclipToggle", Toggle)

local originalJumpPower
local originalGravity = Workspace.Gravity

local function toggleMoonGravity(state)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    if state then
        originalJumpPower = humanoid.JumpPower
        Workspace.Gravity = 50
    else
        Workspace.Gravity = originalGravity
        humanoid.JumpPower = originalJumpPower or 50
    end
end

local Toggle = Tab:Toggle({
    Title = "Moon Gravity",
    Desc = "Lowers gravity to make it look like your on the moon",
    Icon = "moon",
    Type = "Checkbox",
    Default = false,
    Flag = "MoonGravityToggle",
    Callback = function(value)
        toggleMoonGravity(value)
    end,
})
myConfig:Register("MoonGravityToggle", Toggle)

local Tab = Window:Tab({
    Title = "Combat",
    Icon = "swords",
    Locked = false,
})


local AimbotEnabled = false
local ShowFOV = false
local UnlockFOV = false
local TeamCheckEnabled = false
local WallCheckEnabled = false

local FOVRadius = 150
local AimPart = "Head"


local FOVPosition = Vector2.new(
    Camera.ViewportSize.X / 2,
    Camera.ViewportSize.Y / 2
)


local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Thickness = 2
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(255, 255, 0)


local AimPartMap = {
    Head = { "Head" },

    Torso = {
        "UpperTorso",
        "LowerTorso",
        "Torso"
    },

    Arms = {
        "LeftUpperArm",
        "RightUpperArm",
        "LeftArm",
        "RightArm"
    },

    Legs = {
        "LeftUpperLeg",
        "RightUpperLeg",
        "LeftLeg",
        "RightLeg"
    }
}

local function GetAimPartFromCharacter(character)
    local parts = AimPartMap[AimPart]
    if not parts then return nil end

    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            return part
        end
    end

    return nil
end


local function IsVisible(targetPart, character)
    if not WallCheckEnabled then
        return true
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {
        LocalPlayer.Character,
        character,
        Camera
    }

    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)

    local result = Workspace:Raycast(origin, direction, rayParams)
    return result == nil
end


local function GetClosestTarget()
    local closestPart = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then

            if TeamCheckEnabled and player.Team == LocalPlayer.Team then
                continue
            end

            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local part = GetAimPartFromCharacter(player.Character)
                if not part then continue end

                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - FOVPosition).Magnitude
                    if distance <= FOVRadius and distance < shortestDistance then
                        if IsVisible(part, player.Character) then
                            shortestDistance = distance
                            closestPart = part
                        end
                    end
                end
            end
        end
    end

    return closestPart
end


-- Optimization: Merged render connection for Aimbot (lazy-loaded)
local aimbotConnection = nil
local function startAimbotRender()
    if aimbotConnection then return end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        local viewport = Camera.ViewportSize
        local mousePos = UserInputService:GetMouseLocation()

        if UnlockFOV then
            FOVPosition = mousePos
        else
            FOVPosition = Vector2.new(viewport.X / 2, viewport.Y / 2)
        end

        FOVCircle.Position = FOVPosition
        FOVCircle.Radius = FOVRadius
        FOVCircle.Visible = ShowFOV

        if not AimbotEnabled then return end

        local target = GetClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end)
    addConnection("AimbotRender", aimbotConnection)
end



Tab:Toggle({
    Title = "Enable Aimbot",
    Desc = "Toggle aimlock",
    Icon = "target",
    Type = "Checkbox",
    Value = false,
    Flag = "AimbotToggle",
    Callback = function(state)
        AimbotEnabled = state
        if state then
            startAimbotRender() -- Lazy-load on enable
        end
    end
})
myConfig:Register("AimbotToggle", AimbotToggle)

local ShowFOVToggle = Tab:Toggle({
    Title = "Show FOV",
    Desc = "Toggle FOV circle",
    Icon = "circle",
    Type = "Checkbox",
    Value = false,
    Flag = "ShowFOVToggle",
    Callback = function(state)
        ShowFOV = state
    end
})
myConfig:Register("ShowFOVToggle", ShowFOVToggle)

local FOVColorInput = Tab:Input({
    Title = "FOV Color (RGB)",
    Desc = "Example: 255, 255, 0",
    Value = "255, 255, 0",
    InputIcon = "palette",
    Type = "Input",
    Placeholder = "R, G, B",
    Flag = "FOVColorInput",
    Callback = function(input)
        local r, g, b = input:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b then
            FOVCircle.Color = Color3.fromRGB(
                math.clamp(r, 0, 255),
                math.clamp(g, 0, 255),
                math.clamp(b, 0, 255)
            )
        end
    end
})
myConfig:Register("FOVColorInput", FOVColorInput)

local UnlockFOVToggle = Tab:Toggle({
    Title = "Unlock FOV",
    Desc = "Move FOV with mouse/finger",
    Icon = "move",
    Type = "Checkbox",
    Value = false,
    Flag = "UnlockFOVToggle",
    Callback = function(state)
        UnlockFOV = state
    end
})
myConfig:Register("UnlockFOVToggle", UnlockFOVToggle)

local TeamCheckToggle = Tab:Toggle({
    Title = "Team Check",
    Desc = "Ignore teammates",
    Icon = "users",
    Type = "Checkbox",
    Value = false,
    Flag = "TeamCheckToggle",
    Callback = function(state)
        TeamCheckEnabled = state
    end
})
myConfig:Register("TeamCheckToggle", TeamCheckToggle)

local WallCheckToggle = Tab:Toggle({
    Title = "Wall Check",
    Desc = "Only visible targets",
    Icon = "eye",
    Type = "Checkbox",
    Value = false,
    Flag = "WallCheckToggle",
    Callback = function(state)
        WallCheckEnabled = state
    end
})
myConfig:Register("WallCheckToggle", WallCheckToggle)

local FOVSizeInput = Tab:Input({
    Title = "FOV Size",
    Desc = "Change FOV radius",
    Value = tostring(FOVRadius),
    InputIcon = "ruler",
    Type = "Input",
    Placeholder = "Enter number...",
    Flag = "FOVSizeInput",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            FOVRadius = math.clamp(num, 10, 1000)
        end
    end
})
myConfig:Register("FOVSizeInput", FOVSizeInput)

local AimPartDropdown = Tab:Dropdown({
    Title = "Aim Part",
    Desc = "Select body group",
    Values = { "Head", "Torso", "Arms", "Legs" },
    Value = "Head",
    Flag = "AimPartDropdown",
    Callback = function(option)
        AimPart = option
    end
})
myConfig:Register("AimPartDropdown", AimPartDropdown)

Tab:Divider()


-- ===== UNIFIED CHAMS + ESP =====

local ESP_Objects = {}
local Chams_Enabled = false
local ESP_Enabled = false

local function getPlayerColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255) -- default white
end

local function createHighlight(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end

    -- destroy old highlight if exists
    if ESP_Objects[player] then
        if ESP_Objects[player].highlight and ESP_Objects[player].highlight.Parent then
            ESP_Objects[player].highlight:Destroy()
        end
        if ESP_Objects[player].textBillboard and ESP_Objects[player].textBillboard.Parent then
            ESP_Objects[player].textBillboard:Destroy()
        end
    end

    -- Create Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.Adornee = character
    highlight.FillColor = getPlayerColor(player)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.Enabled = Chams_Enabled or ESP_Enabled
    highlight.Parent = character

    -- Create Text Billboard (only shown when ESP enabled)
    local textBillboard = Instance.new("BillboardGui")
    textBillboard.Name = "ESP_Text"
    textBillboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    textBillboard.Size = UDim2.new(0, 250, 0, 20)
    textBillboard.StudsOffset = Vector3.new(0, 3, 0)
    textBillboard.AlwaysOnTop = true
    textBillboard.Enabled = ESP_Enabled

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = getPlayerColor(player)
    textLabel.TextSize = 14
    textLabel.Parent = textBillboard

    textBillboard.Parent = CoreGui

    ESP_Objects[player] = {
        highlight = highlight,
        textBillboard = textBillboard,
        textLabel = textLabel,
        character = character
    }
end

-- Apply highlights to existing players (DEFERRED TO REDUCE INIT CPU SPIKE)
local function initializeExistingPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        createHighlight(p)
        p.CharacterAdded:Connect(function()
            task.wait(1)
            createHighlight(p)
        end)
    end
end

task.defer(initializeExistingPlayers)

-- Apply highlights to new players joining
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        createHighlight(player)
    end)
end)

-- Optimization: Update ESP text with lazy-loading (only runs when enabled)
local espUpdateCounter = 0
local espConnection = nil

local function startESPRender()
    if espConnection then return end
    espConnection = RunService.RenderStepped:Connect(function()
        espUpdateCounter = espUpdateCounter + 1
        if espUpdateCounter < 3 then return end -- Only update every 3 frames
        espUpdateCounter = 0
        
        local localCharacter = LocalPlayer.Character
        local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
        
        for player, obj in pairs(ESP_Objects) do
            if obj.highlight and obj.highlight.Parent then
                -- Update highlight color in case team changed
                obj.highlight.FillColor = getPlayerColor(player)
                obj.textLabel.TextColor3 = getPlayerColor(player)
            end

            if ESP_Enabled and obj.textBillboard and obj.textBillboard.Parent and localRoot then
                local character = player.Character
                if character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if root then
                        local distance = (root.Position - localRoot.Position).Magnitude
                        obj.textBillboard.Adornee = root
                        obj.textLabel.Text = string.format("%s | HP: %.0f | Dist: %.1f",
                            player.Name,
                            humanoid and humanoid.Health or 0,
                            distance
                        )
                    end
                end
            end
        end
    end)
    addConnection("ESPRender", espConnection)
end

local function stopESPRender()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
end

-- Chams Toggle
local Chams_Toggle = Tab:Toggle({
    Title = "Chams",
    Desc = "Highlight players with team color",
    Icon = "eye",
    Type = "Checkbox",
    Value = false,
    Flag = "ChamsToggle",
    Callback = function(state)
        Chams_Enabled = state
        if state then
            startESPRender() -- Start render if not already running
        elseif not ESP_Enabled then
            stopESPRender() -- Stop if both disabled
        end
        
        if state and ESP_Enabled then
            ESP_Enabled = false
            for _, obj in pairs(ESP_Objects) do
                if obj.textBillboard then
                    obj.textBillboard.Enabled = false
                end
            end
        end
        for _, obj in pairs(ESP_Objects) do
            if obj.highlight then
                obj.highlight.Enabled = Chams_Enabled or ESP_Enabled
            end
        end
    end
})
myConfig:Register("ChamsToggle", Chams_Toggle)

local ESP_Toggle = Tab:Toggle({
    Title = "ESP",
    Desc = "Highlight players + show name, HP, distance",
    Icon = "eye",
    Type = "Checkbox",
    Value = false,
    Flag = "ESPToggle",
    Callback = function(state)
        ESP_Enabled = state
        if state then
            startESPRender() -- Start render if not already running
        elseif not Chams_Enabled then
            stopESPRender() -- Stop if both disabled
        end
        
        if state and Chams_Enabled then
            Chams_Enabled = false
            for _, obj in pairs(ESP_Objects) do
                if obj.highlight then
                    obj.highlight.Enabled = false
                end
            end
        end
        for _, obj in pairs(ESP_Objects) do
            if obj.highlight then
                obj.highlight.Enabled = Chams_Enabled or ESP_Enabled
            end
            if obj.textBillboard then
                obj.textBillboard.Enabled = ESP_Enabled
            end
        end
    end
})
myConfig:Register("ESPToggle", ESP_Toggle)

Tab:Divider()


local HITBOX_ENABLED = false
local HITBOX_SIZE = 10
local HITBOX_TRANSPARENCY = 0.5
local HITBOX_COLOR = Color3.fromRGB(255, 0, 0)
local HITBOX_PART = "Body" 

local modified = {}


local function getTargetPart(character)
	if HITBOX_PART == "Head" then
		return character:FindFirstChild("Head")
	else
		return character:FindFirstChild("HumanoidRootPart")
	end
end


local function applyHitbox(player)
	if player == LocalPlayer then return end
	if not player.Character then return end

	local part = getTargetPart(player.Character)
	if not part then return end

	if not modified[player] then
		modified[player] = {}
	end

	if not modified[player][part] then
		modified[player][part] = {
			Size = part.Size,
			Transparency = part.Transparency,
			Color = part.Color,
			Material = part.Material,
			CanCollide = part.CanCollide
		}
	end

	part.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
	part.Transparency = HITBOX_TRANSPARENCY
	part.Color = HITBOX_COLOR
	part.Material = Enum.Material.Neon
	part.CanCollide = false
end


local function removeHitbox(player)
	if not modified[player] then return end
	if not player.Character then return end

	for part, old in pairs(modified[player]) do
		if part and part.Parent then
			part.Size = old.Size
			part.Transparency = old.Transparency
			part.Color = old.Color
			part.Material = old.Material
			part.CanCollide = old.CanCollide
		end
	end

	modified[player] = nil
end


-- Optimization: Debounced hitbox update
local hitboxUpdatePending = false
local function updateAll()
	if hitboxUpdatePending then return end
	hitboxUpdatePending = true
	
	task.spawn(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if HITBOX_ENABLED then
				removeHitbox(player)
				applyHitbox(player)
			else
				removeHitbox(player)
			end
		end
		hitboxUpdatePending = false
	end)
end


Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		if HITBOX_ENABLED then
			applyHitbox(player)
		end
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterAdded:Connect(function()
		task.wait(1)
		if HITBOX_ENABLED then
			applyHitbox(player)
		end
	end)
end


Tab:Toggle({
	Title = "Hitbox Expander",
	Desc = "Enable expanded hitboxes",
	Icon = "target",
	Type = "Checkbox",
	Value = false,
	Flag = "HitboxExpanderToggle",
	Callback = function(state)
		HITBOX_ENABLED = state
		updateAll()
	end
})
myConfig:Register("HitboxExpanderToggle", HitboxToggle)

local HitboxSizeInput = Tab:Input({
	Title = "Hitbox Size",
	Desc = "Recommended: 8 - 20",
	Value = tostring(HITBOX_SIZE),
	InputIcon = "maximize",
	Type = "Input",
	Placeholder = "Enter number",
	Flag = "HitboxSizeInput",
	Callback = function(input)
		local size = tonumber(input)
		if size then
			HITBOX_SIZE = math.clamp(size, 2, 50)
			if HITBOX_ENABLED then
				updateAll()
			end
		end
	end
})
myConfig:Register("HitboxSizeInput", HitboxSizeInput)

local HitboxTargetDropdown = Tab:Dropdown({
	Title = "Hitbox Target",
	Desc = "Choose which part to expand",
	Values = { "Body", "Head" },
	Value = "Body",
	Flag = "HitboxTargetDropdown",
	Callback = function(option)
		HITBOX_PART = option
		if HITBOX_ENABLED then
			updateAll()
		end
	end
})
myConfig:Register("HitboxTargetDropdown", HitboxTargetDropdown)

local HitboxTransparencySlider = Tab:Slider({
	Title = "Hitbox Transparency",
	Desc = "0 = visible | 1 = invisible",
	Step = 0.05,
	Flag = "HitboxTransparencySlider",
	Value = {
		Min = 0,
		Max = 1,
		Default = HITBOX_TRANSPARENCY
	},
	Callback = function(value)
		HITBOX_TRANSPARENCY = value
		if HITBOX_ENABLED then
			updateAll()
		end
	end
})
myConfig:Register("HitboxTransparencySlider", HitboxTransparencySlider)

local HitboxColorInput = Tab:Input({
	Title = "Hitbox Color (RGB)",
	Desc = "Format: R,G,B  (example: 255,0,0)",
	Value = "255,0,0",
	InputIcon = "palette",
	Type = "Input",
	Placeholder = "R,G,B",
	Flag = "HitboxColorInput",
	Callback = function(input)
		local r, g, b = input:match("(%d+),(%d+),(%d+)")
		if r and g and b then
			HITBOX_COLOR = Color3.fromRGB(
				math.clamp(tonumber(r), 0, 255),
				math.clamp(tonumber(g), 0, 255),
				math.clamp(tonumber(b), 0, 255)
			)
			if HITBOX_ENABLED then
				updateAll()
			end
		end
	end
})
myConfig:Register("HitboxColorInput", HitboxColorInput)

Tab:Divider()


local selectedPlayer = nil
local constantTP = false
local connection = nil

-- Get player names
local function getPlayerList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    return list
end

local function teleportToPlayer(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end


local selectedPlayer = nil

local Dropdown = Tab:Dropdown({
    Title = "Select Player",
    Desc = "Choose a player to teleport to",
    Values = getPlayerList(),
    Value = nil,
    Callback = function(option)
        selectedPlayer = option
        print("Selected player: " .. option)
    end
})

local function RefreshDropdown()
    local updatedList = getPlayerList()
    Dropdown:Refresh(updatedList, true)

    if selectedPlayer and table.find(updatedList, selectedPlayer) then
        Dropdown:Set(selectedPlayer)
    else
        selectedPlayer = nil
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(2)
    RefreshDropdown()
end)

Players.PlayerRemoving:Connect(function(player)
    task.wait(2)
    RefreshDropdown()

    if selectedPlayer == player.Name then
        selectedPlayer = nil
    end
end)

Players.PlayerAdded:Connect(function()
    Dropdown:Refresh(getPlayerList(), true)
end)

Players.PlayerRemoving:Connect(function()
    Dropdown:Refresh(getPlayerList(), true)
end)


local Button = Tab:Button({
    Title = "Teleport To Player",
    Desc = "Teleports once to selected player",
    Locked = false,
    Callback = function()
        if selectedPlayer then
            teleportToPlayer(selectedPlayer)
        end
    end
})


local Toggle = Tab:Toggle({
    Title = "Loop TP",
    Desc = "Continuously teleport to selected player",
    Icon = "repeat",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        constantTP = state

        if constantTP then
            connection = RunService.Heartbeat:Connect(function()
                if selectedPlayer then
                    teleportToPlayer(selectedPlayer)
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})

local Tab = Window:Tab({
    Title = "Fun",
    Icon = "joystick",
    Locked = false,
})

local Button = Tab:Button({
    Title = "No Fe Snake",
    Desc = "Gives you like a snake thing",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Avtor1zaTion/NO-FE-SNAKE/refs/heads/main/NO-FE-Snake.txt'))()
    end
})

local Button = Tab:Button({
    Title = "Fake Lag",
    Desc = "Makes you look laggy",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Biem6ondo/FAKELAG/refs/heads/main/Fakelag"))()
    end
})

local Button = Tab:Button({
    Title = "Jerk",
    Desc = "Gives goon item (FE)",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Edge.lua"))()
    end
})


Tab:Divider()

getgenv().FPDH = Workspace.FallenPartsDestroyHeight
getgenv().OldPos = nil

local Message = function(_Title, _Text, Time)
    StarterGui:SetCore("SendNotification", {
        Title = _Title,
        Text = _Text,
        Duration = Time
    })
end


local SkidFling = function(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    if not TCharacter then
        return Message("Error Occurred", "Target has no character", 5)
    end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = (Accessory and Accessory:FindFirstChild("Handle")) or nil

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return Message("Error Occurred", "Target is sitting", 5)
        end

        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end

        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    Angle += 100
                    FPos(BasePart, CFrame.new(0,1.5,0), CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity", RootPart)
        BV.Name = "EpixVel"
        BV.Velocity = Vector3.new(9e8,9e8,9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart then
            SFBasePart(THead or TRootPart)
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in pairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity = Vector3.new()
                    x.RotVelocity = Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25

        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Occurred", "Random error", 5)
    end
end


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetPlayerNames()
    local names = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end

    table.sort(names)
    table.insert(names, 1, "All")

    return names
end

local SelectedTarget = "All"

local Dropdown = Tab:Dropdown({
    Title = "Select Player to Fling",
    Values = GetPlayerNames(),
    Value = "All",
    Callback = function(selectedName)
        SelectedTarget = selectedName
    end
})

-- 🔹 Auto update function
local function RefreshDropdown()
    local currentSelection = SelectedTarget
    local updatedList = GetPlayerNames()

    Dropdown:Refresh(updatedList, true)

    -- Restore selection if still valid
    if table.find(updatedList, currentSelection) then
        Dropdown:Set(currentSelection)
    else
        SelectedTarget = "All"
        Dropdown:Set("All")
    end
end

-- 🔹 Auto update when players join
Players.PlayerAdded:Connect(function()
    task.wait(2)
    RefreshDropdown()
end)

-- 🔹 Auto update when players leave
Players.PlayerRemoving:Connect(function()
    task.wait(2)
    RefreshDropdown()
end)

Players.PlayerAdded:Connect(function(plr)
    local v = Dropdown.Values
    table.insert(v, plr.Name)
    table.sort(v)
    Dropdown.Values = v
end)

Players.PlayerRemoving:Connect(function(plr)
    local v = Dropdown.Values
    for i,n in ipairs(v) do
        if n == plr.Name then table.remove(v,i) break end
    end
    Dropdown.Values = v
end)

local Button = Tab:Button({
    Title = "Tap To Fling",
    Desc = "Fling the selected player",
    Locked = false,
    Callback = function()
        if not SelectedTarget then
            return Message("Error", "No player selected", 4)
        end

        if SelectedTarget == "All" then
            for _, tp in ipairs(Players:GetPlayers()) do
                if tp ~= LocalPlayer then
                    SkidFling(tp)
                end
            end
        else
            local tp = Players:FindFirstChild(SelectedTarget)
            if tp then
                SkidFling(tp)
            else
                Message("Error", "Player not found", 4)
            end
        end
    end
})

local AutoFlingEnabled = false

local Toggle = Tab:Toggle({
    Title = "Auto Fling",
    Desc = "Automatically fling the selected player repeatedly",
    Icon = "refresh-ccw", 
    Type = "Checkbox",
    Value = false,
    Flag = "AutoFlingToggle",
    Callback = function(state)
        AutoFlingEnabled = state

        task.spawn(function()
            while AutoFlingEnabled do
                if SelectedTarget then
                    if SelectedTarget == "All" then
                        for _, targetPlayer in ipairs(Players:GetPlayers()) do
                            if targetPlayer ~= LocalPlayer then
                                SkidFling(targetPlayer)
                            end
                        end
                    else
                        local tp = Players:FindFirstChild(SelectedTarget)
                        if tp then SkidFling(tp) end
                    end
                end
                task.wait(1.5)
            end
        end)
    end
})
myConfig:Register("AutoFlingToggle", Toggle)

Tab:Divider()


-- Get player names (excluding yourself)
local function getPlayerNames()
    local playerNames = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end

    if #playerNames == 0 then
        return {"No Players Available"}
    end

    return playerNames
end

local isSpectating = false
local originalSubject = nil
local currentSpectateTarget = nil
local SpectateDropdown = nil
local SpectateToggle = nil

-- Stop spectating
local function stopSpectating()
    if isSpectating then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end

        Camera.CameraType = Enum.CameraType.Custom

        isSpectating = false
        currentSpectateTarget = nil

        if SpectateToggle then
            SpectateToggle:Set(false)
        end

        print("Stopped spectating")
    end
end

-- Start spectating
local function spectatePlayer(playerName)
    if playerName == "No Players Available" then
        warn("No players available")
        return
    end

    local targetPlayer = Players:FindFirstChild(playerName)

    if targetPlayer 
        and targetPlayer.Character 
        and targetPlayer.Character:FindFirstChild("Humanoid") then

        Camera.CameraSubject = targetPlayer.Character.Humanoid
        Camera.CameraType = Enum.CameraType.Custom

        currentSpectateTarget = targetPlayer
        isSpectating = true

        print("Now spectating: " .. playerName)
    else
        warn("Could not spectate player")
        stopSpectating()
    end
end

-- Update dropdown
local function updatePlayerDropdown()
    local newPlayerNames = getPlayerNames()

    if SpectateDropdown then
        SpectateDropdown:Refresh(newPlayerNames, true)
    else
        SpectateDropdown = Tab:Dropdown({
            Title = "Spectate Player",
            Values = newPlayerNames,
            Value = nil,
            Callback = function(option)
                print("Selected: " .. option)
                -- Does NOT auto spectate anymore
            end
        })
    end
end

-- Create Toggle
SpectateToggle = Tab:Toggle({
    Title = "Spectate",
    Desc = "Toggle spectating selected player",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)

        if state then
            if SpectateDropdown and SpectateDropdown.Value then
                spectatePlayer(SpectateDropdown.Value)
            else
                warn("No player selected")
                SpectateToggle:Set(false)
            end
        else
            stopSpectating()
        end
    end
})

-- Refresh button
local RefreshButton = Tab:Button({
    Title = "Refresh Player List",
    Desc = "Update spectate dropdown",
    Locked = false,
    Callback = function()
        updatePlayerDropdown()
    end
})

-- Player joins
Players.PlayerAdded:Connect(function()
    task.wait(1)
    updatePlayerDropdown()
end)

-- Player leaves (auto disable if target leaves)
Players.PlayerRemoving:Connect(function(player)
    updatePlayerDropdown()

    if currentSpectateTarget and player == currentSpectateTarget then
        stopSpectating()
    end
end)

-- Initialize dropdown
updatePlayerDropdown()

local Tab = Window:Tab({
    Title = "Visuals",
    Icon = "eye",
    Locked = false,
})

local Button = Tab:Button({
    Title = "Fullbright",
    Desc = "Lets you see in the dark.",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Fullbright.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Remove fog",
    Desc = "Removes the fog.",
    Locked = false,
    Callback = function()
        local function removeFog()
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 1e10
            Lighting.FogColor = Color3.new(1, 1, 1)
        end

        removeFog()

        Lighting:GetPropertyChangedSignal("FogEnd"):Connect(removeFog)
        Lighting:GetPropertyChangedSignal("FogStart"):Connect(removeFog)
        Lighting:GetPropertyChangedSignal("FogColor"):Connect(removeFog)
        Lighting.Changed:Connect(removeFog)
    end
})

local Button = Tab:Button({
    Title = "Shiftlock",
    Desc = "Gives a shiftlock button",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MiniNoobie/ShiftLockx/main/Shiftlock-MiniNoobie",true))()
    end
})

local Button = Tab:Button({
    Title = "Short proximity prompt",
    Desc = "removes the hold duration for proximity prompts so you can spam it",
    Locked = false,
    Callback = function()
        local function SetupProximityPrompt(prompt)
    prompt.HoldDuration = 0
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        SetupProximityPrompt(descendant)
    end
end)

for _, prompt in ipairs(workspace:GetDescendants()) do
    if prompt:IsA("ProximityPrompt") then
        SetupProximityPrompt(prompt)
    end
end
    end
})

local Tab = Window:Tab({
    Title = "Performance",
    Icon = "zap",
    Locked = false,
})

local Button = Tab:Button({
    Title = "Fps Booster",
    Desc = "Removes things to boost performance.",
    Locked = false,
    Callback = function()
  _G.Settings = {
    Players = {
        ["Ignore Me"] = true, 
        ["Ignore Others"] = true 
    },
    Meshes = {
        Destroy = false, 
        LowDetail = true 
    },
    Images = {
        Invisible = true, 
        LowDetail = false, 
        Destroy = false, 
    },
    Other = {
        ["No Particles"] = true, 
        ["No Camera Effects"] = true,
        ["No Explosions"] = true, 
        ["No Clothes"] = true, 
        ["Low Water Graphics"] = true, 
        ["No Shadows"] = true, 
        ["Low Rendering"] = true, 
        ["Low Quality Parts"] = true 
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
   end,
})

local Input = Tab:Input({
    Title = "Set FPS Cap",
    Desc = "Lets you change the FPS cap of Roblox.",
    Value = "60",
    InputIcon = "square-pen",
    Type = "Input",
    Placeholder = "Enter FPS cap",
    Flag = "FPSCapInput",
    Callback = function(text) 
        local num = tonumber(text)
        if num then
            setfpscap(num)
        else
            WindUI:Notify({
                Title = "Invalid Value",
                Content = "Please enter a valid number for the FPS cap.",
                Duration = 2,
                Icon = "ban"
            })
        end
    end
})
myConfig:Register("FPSCapInput", FPSCapInput)

local Button = Tab:Button({
    Title = "Performance Stats",
    Desc = "Displays ping and fps in top left corner",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Fps_stats.lua"))()
    end
})

local Tab = Window:Tab({
    Title = "Server",
    Icon = "server",
    Locked = false,
})

local jobId = game.JobId or "Unknown"

local Button = Tab:Button({
    Title = "Copy Server Job ID",
    Desc = "Copies the current server Job ID to your clipboard",
    Locked = false,
    Callback = function()
        if setclipboard then
            setclipboard(jobId)
            WindUI:Notify({
    Title = "Copied",
    Content = "Jobid Copied to Clipboard",
    Duration = 3, 
    Icon = "clipboard-check",
})
        else
                        WindUI:Notify({
    Title = "Failed",
    Content = "Copy Failed",
    Duration = 3, 
    Icon = "clipboard-x",
})
        end
    end
})

local Input = Tab:Input({
    Title = "Join Server",
    Desc = "Join a server with a jobID",
    Value = "",     
    InputIcon = "id-card",
    Type = "Input", 
    Placeholder = "JobId",
    Flag = "JoinServerInput",
    Callback = function(Text) 
        local JobIdTextBoxValue = Text  
        
        local placeId = game.PlaceId
        
       
        if JobIdTextBoxValue ~= "" and JobIdTextBoxValue:lower() ~= "jobid" then
            local success, errorMessage = pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, JobIdTextBoxValue, LocalPlayer)
            end)
            if not success then
                warn("Teleport failed: " .. tostring(errorMessage))
            end
        else
            print("No valid JobId entered, teleport cancelled.")
        end
    end
})
myConfig:Register("JoinServerInput", JoinServerInput)

local Button = Tab:Button({
    Title = "Rejoin",
    Desc = "Rejoin same server",
    Locked = false,
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

local Button = Tab:Button({
    Title = "Server hop",
    Desc = "Changes your server",
    Locked = false,
    Callback = function()
        local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Server, Next = nil, nil
        local function ListServers(cursor)
            local Raw = game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or ""))
            return HttpService:JSONDecode(Raw)
        end

        repeat
            local ServerList = ListServers(Next)
            Server = ServerList.data[math.random(1, (#ServerList.data / 3))]
            Next = ServerList.nextPageCursor
        until Server

        if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
        end
    end
})

local Tab = Window:Tab({
    Title = "Tools",
    Icon = "wrench",
    Locked = false,
})

-- State
local antiAfkEnabled = false
local antiAfkConnection

local Toggle = Tab:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents you from getting kicked for being idle",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Flag = "AntiAFKToggle",
    Callback = function(state)
        antiAfkEnabled = state
        print("Anti AFK:", state)

        if state then
            -- Enable Anti-AFK
            antiAfkConnection = player.Idled:Connect(function()
                if not antiAfkEnabled then return end

                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        else
            -- Disable Anti-AFK
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end
})
myConfig:Register("AntiAFKToggle", Toggle)

local Button = Tab:Button({
    Title = "Keyboard",
    Desc = "Launches delta keyboard for the mobile players",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Ata/main/deltakeyboardcrack.txt", true))()
    end
})

local Button = Tab:Button({
    Title = "Infinite Yield",
    Desc = "Loads Ininite Yeild",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Window:Divider()

local Tab = Window:Tab({
    Title = "Settings",
    Icon = "cog", 
    Locked = true,
})

local pendingConfigName = ""

local ConfigNameInput = Tab:Input({
    Title = "Config Name",
    Desc = "Enter a name for the config",
    Locked = false,
    Value = "",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "MyConfig",
    Callback = function(input)
        pendingConfigName = input
    end
})

Tab:Button({
    Title = "Create Config",
    Desc = "Create a new config with this name",
    Locked = false,
    Callback = function()
        if pendingConfigName ~= "" then
            myConfig = ConfigManager:CreateConfig(pendingConfigName)
            ConfigManager:Save(pendingConfigName)
            WindUI:Notify({
                Title = "Created",
                Content = "Config '" .. pendingConfigName .. "' created successfully",
                Duration = 2,
                Icon = "check"
            })
            pendingConfigName = ""
            ConfigNameInput.Value = ""
            -- Refresh all dropdown lists
            SaveDropdown.Values = GetConfigs()
            DeleteDropdown.Values = GetConfigs()
            LoadDropdown.Values = GetConfigs()
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a config name",
                Duration = 2,
                Icon = "ban"
            })
        end
    end
})

local function GetConfigs()
    local list = {}
    for _, name in pairs(ConfigManager:AllConfigs()) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

local SaveDropdown
SaveDropdown = Tab:Dropdown({
    Title = "Save Config",
    Desc = "Select config to save",
    Locked = false,
    Values = GetConfigs(),
    Value = GetConfigs()[1] or "No Configs",
    Callback = function(option)
        SaveDropdown.Selected = option
    end
})

Tab:Button({
    Title = "Save",
    Desc = "Save selected config",
    Locked = false,
    Callback = function()
        if SaveDropdown.Selected and SaveDropdown.Selected ~= "No Configs" then
            ConfigManager:Save(SaveDropdown.Selected)
            SaveDropdown.Values = GetConfigs()
            WindUI:Notify({
                Title = "Saved",
                Content = "Config saved successfully",
                Duration = 2,
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a valid config",
                Duration = 2,
                Icon = "ban"
            })
        end
    end
})

local DeleteDropdown
DeleteDropdown = Tab:Dropdown({
    Title = "Delete Config",
    Desc = "Select config to delete",
    Locked = false,
    Values = GetConfigs(),
    Value = GetConfigs()[1] or "No Configs",
    Callback = function(option)
        DeleteDropdown.Selected = option
    end
})

Tab:Button({
    Title = "Delete",
    Desc = "Delete selected config",
    Locked = false,
    Callback = function()
        if DeleteDropdown.Selected and DeleteDropdown.Selected ~= "No Configs" then
            ConfigManager:Delete(DeleteDropdown.Selected)
            DeleteDropdown.Values = GetConfigs()
            SaveDropdown.Values = GetConfigs()
            LoadDropdown.Values = GetConfigs()
            WindUI:Notify({
                Title = "Deleted",
                Content = "Config deleted successfully",
                Duration = 2,
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a valid config",
                Duration = 2,
                Icon = "ban"
            })
        end
    end
})

local LoadDropdown
LoadDropdown = Tab:Dropdown({
    Title = "Load Config",
    Desc = "Select config to load",
    Locked = false,
    Values = GetConfigs(),
    Value = GetConfigs()[1] or "No Configs",
    Callback = function(option)
        LoadDropdown.Selected = option
    end
})

Tab:Button({
    Title = "Load",
    Desc = "Load selected config",
    Locked = false,
    Callback = function()
        if LoadDropdown.Selected and LoadDropdown.Selected ~= "No Configs" then
            ConfigManager:Load(LoadDropdown.Selected)
            WindUI:Notify({
                Title = "Loaded",
                Content = "Config loaded successfully",
                Duration = 2,
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a valid config",
                Duration = 2,
                Icon = "ban"
            })
        end
    end
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Notifications.lua"))()
