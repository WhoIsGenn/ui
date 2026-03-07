local function SafeDrawing(type)
    local success, result = pcall(function()
        return Drawing.new(type)
    end)
    if success then return result end
    return nil
end

local function SafeRemove(obj)
    if obj and obj.Remove then
        pcall(function() obj:Remove() end)
    end
end

if not Drawing or not Drawing.new then
    local waited = 0
    while not Drawing and waited < 5 do
        task.wait(0.1)
        waited = waited + 0.1
    end
    
    if not Drawing then
        warn("[Violence] Drawing library not available.")
        return
    end
end

local ExecutorName = "Unknown"
pcall(function()
    if identifyexecutor then
        ExecutorName = identifyexecutor()
    elseif getexecutorname then
        ExecutorName = getexecutorname()
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Config = {
    -- ESP (semua off saat pertama kali)
    ESP_Killer = false,
    ESP_Survivor = false,
    ESP_Generator = false,
    ESP_Gate = false,
    ESP_Hook = false,
    ESP_Pallet = false,
    ESP_Window = false,
    ESP_Distance = false,
    ESP_Names = false,
    ESP_Health = false,
    ESP_Skeleton = false,
    ESP_Offscreen = false,
    ESP_Velocity = false,
    ESP_ClosestHook = false,
    ESP_MaxDist = 500,

    ESP_PlayerChams = true,
    ESP_ObjectChams = true,

    RADAR_Enabled = false,
    RADAR_Size = 120,
    RADAR_Circle = false,
    RADAR_Killer = false,
    RADAR_Survivor = false,
    RADAR_Generator = false,
    RADAR_Pallet = false,

    AUTO_Generator = false,
    AUTO_Attack = false,
    AUTO_AttackRange = 12,
    HITBOX_Enabled = false,
    HITBOX_Size = 15,
    AUTO_TeleAway = false,
    AUTO_TeleAwayDist = 40,

    AUTO_Parry = false,
    PARRY_Dist      = 20,
    GUN_SilentAim   = false,
    GUN_AimPart     = "HumanoidRootPart",
    GODMODE         = false,
    ANTI_FailGen    = false,
    ANTI_SkillCheck = false,  -- disable Skillcheck-player script di karakter
    SURV_NoFall = false,
    SURV_AutoWiggle = false,
    KILLER_DestroyPallets = false,
    KILLER_FullGenBreak = false,
    KILLER_NoPalletStun = false,
    KILLER_AutoHook = false,
    KILLER_AntiBlind = false,
    KILLER_NoSlowdown = false,
    KILLER_DoubleTap = false,
    KILLER_InfiniteLunge = false,
    SPEED_Enabled = false,
    SPEED_Value = 16,
    SPEED_Method = "Attribute",
    NOCLIP_Enabled = false,
    FLY_Enabled = false,
    FLY_Speed = 50,
    FLY_Method = "CFrame",
    JUMP_Power = 50,
    JUMP_Infinite = false,

    NO_Fog = false,
    CAM_FOVEnabled = false,
    CAM_FOV = 90,
    CAM_ThirdPerson = false,
    CAM_ShiftLock = false,
    FLING_Enabled = false,
    FLING_Strength = 10000,

    BEAT_Survivor = false,
    BEAT_Killer = false,

    TP_Offset = 3,

    MENU_Open = true,
    MENU_Tab = 1,


    AIM_Enabled = false,
    AIM_TargetRole = "Killer",  -- "Killer" or "Survivor"
    AIM_FOV = 120,
    AIM_Smooth = 0.15,
    AIM_TargetPart = "Head",
    AIM_VisCheck = false,
    AIM_ShowFOV = true,
    AIM_Predict = false,

    SPEAR_Aimbot = false,
    SPEAR_Gravity = 50,
    SPEAR_Speed = 100
}

local Tuning = {
    ESP_RefreshRate = 0.08,
    ESP_VisCheckRate = 0.15,
    Gen_RefreshRate = 0.2,
    CacheRefreshRate = 1.0,
    
    Box_WidthRatio = 0.55,
    Name_Offset = 18,
    Dist_Offset = 5,
    Health_Width = 4,
    Health_Offset = 6,
    
    Offscreen_Edge = 50,
    Offscreen_Size = 12,
    
    Skel_Thickness = 1,
    Box_Thickness = 1,
    
    RadarRange = 150,
    RadarDotSize = 5,
    RadarArrowSize = 8
}


local Colors = {
    Killer = Color3.fromRGB(255, 65, 65),
    KillerVis = Color3.fromRGB(255, 120, 120),
    Survivor = Color3.fromRGB(65, 220, 130),
    SurvivorVis = Color3.fromRGB(120, 255, 170),
    Generator = Color3.fromRGB(255, 180, 50),
    GeneratorDone = Color3.fromRGB(100, 255, 130),
    Gate = Color3.fromRGB(200, 200, 220),
    Hook = Color3.fromRGB(255, 100, 100),
    HookClose = Color3.fromRGB(255, 230, 80),
    Pallet = Color3.fromRGB(220, 180, 100),
    Window = Color3.fromRGB(100, 180, 255),
    Skeleton = Color3.fromRGB(255, 255, 255),
    SkeletonVis = Color3.fromRGB(150, 255, 150),
    Offscreen = Color3.fromRGB(255, 255, 255),
    HealthHigh = Color3.fromRGB(100, 255, 100),
    HealthMid = Color3.fromRGB(255, 220, 60),
    HealthLow = Color3.fromRGB(255, 70, 70),
    HealthBg = Color3.fromRGB(25, 25, 25),
    
    UI_Bg = Color3.fromRGB(12, 12, 16),
    UI_Card = Color3.fromRGB(20, 20, 26),
    UI_CardHover = Color3.fromRGB(30, 30, 40),
    UI_Border = Color3.fromRGB(45, 45, 55),
    UI_Accent = Color3.fromRGB(0, 170, 255),
    UI_AccentDim = Color3.fromRGB(0, 110, 180),
    UI_Text = Color3.fromRGB(235, 235, 240),
    UI_TextDim = Color3.fromRGB(130, 130, 145),
    UI_On = Color3.fromRGB(90, 220, 120),
    UI_Off = Color3.fromRGB(60, 60, 75),
    UI_Sidebar = Color3.fromRGB(16, 16, 20),
    UI_TabActive = Color3.fromRGB(0, 170, 255),
    UI_TabInactive = Color3.fromRGB(85, 85, 100),
    
    RadarBg = Color3.fromRGB(20, 20, 20),
    RadarBorder = Color3.fromRGB(0, 170, 255),
    RadarYou = Color3.fromRGB(0, 255, 0)
}


local ChamsColors = {
    Killer = {fill = Color3.fromRGB(180, 40, 40), outline = Color3.fromRGB(255, 80, 80), fillTrans = 0.6},
    Survivor = {fill = Color3.fromRGB(40, 160, 80), outline = Color3.fromRGB(80, 255, 130), fillTrans = 0.6},
    Generator = {fill = Color3.fromRGB(200, 140, 30), outline = Color3.fromRGB(255, 200, 80), fillTrans = 0.5},
    Gate = {fill = Color3.fromRGB(150, 150, 170), outline = Color3.fromRGB(220, 220, 255), fillTrans = 0.5},
    Hook = {fill = Color3.fromRGB(180, 60, 60), outline = Color3.fromRGB(255, 100, 100), fillTrans = 0.5},
    HookClose = {fill = Color3.fromRGB(200, 180, 40), outline = Color3.fromRGB(255, 240, 100), fillTrans = 0.4},
    Pallet = {fill = Color3.fromRGB(180, 140, 70), outline = Color3.fromRGB(255, 210, 130), fillTrans = 0.5},
    Window = {fill = Color3.fromRGB(60, 140, 200), outline = Color3.fromRGB(120, 200, 255), fillTrans = 0.5}
}


local Bones_R15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local Bones_R6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}


local State = {
    Unloaded = false,
    LastESPUpdate = 0,
    LastVisCheck = 0,
    LastGenUpdate = 0,
    LastCacheUpdate = 0,
    LastTeleAway = 0,
    AimTarget = nil,
    OriginalSpeed = 16,
    LastFogState = false,
    KillerTarget = nil,
    LastBeatTP = 0,
    LastFinishPos = nil,
    BeatSurvivorDone = false
}

local Cache = {
    Players = {},
    Generators = {},
    Gates = {},
    Hooks = {},
    Pallets = {},
    Windows = {},
    Visibility = {},
    ClosestHook = nil
}

local Connections = {}


local Unload

local function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Lobby"
end

local function IsKiller(player)
    return player and player.Team and player.Team.Name == "Killer"
end

local function IsSurvivor(player)
    return player and player.Team and player.Team.Name == "Survivors"
end

local function GetCharacterRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function IsR6(char)
    return char:FindFirstChild("Torso") ~= nil
end

local function GetDistance(pos)
    local root = GetCharacterRoot()
    if not root then return math.huge end
    return (pos - root.Position).Magnitude
end

local function IsVisible(char)
    if not char then return false end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    
    local origin = cam.CFrame.Position
    local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {cam, LocalPlayer.Character, char}
    
    for _, partName in ipairs(parts) do
        local part = char:FindFirstChild(partName)
        if part then
            local dir = part.Position - origin
            local ray = workspace:Raycast(origin, dir, params)
            if not ray then return true end
        end
    end
    return false
end

local function WorldToScreen(pos)
    local cam = workspace.CurrentCamera
    if not cam then return Vector2.new(), false, 0 end
    local screen, onScreen = cam:WorldToViewportPoint(pos)
    return Vector2.new(screen.X, screen.Y), onScreen, screen.Z
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function LerpColor(c1, c2, t)
    return Color3.new(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end



local Chams = {
    Objects = {},
    Labels = {}
}

function Chams.Create(target, colorData, label)
    if not target or not target:IsA("Instance") then return nil end
    
    local existing = target:FindFirstChild("_ViolenceChams")
    if existing then existing:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "_ViolenceChams"
    highlight.Adornee = target
    highlight.FillColor = colorData.fill
    highlight.OutlineColor = colorData.outline
    highlight.FillTransparency = colorData.fillTrans
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target
    
    local data = {highlight = highlight, target = target}
    
    if label then
        local rootPart = target:IsA("Model") and (target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")) or target
        if rootPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "_ViolenceLabel"
            billboard.Size = UDim2.new(0, 80, 0, 18)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Adornee = rootPart
            billboard.Parent = target
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = colorData.outline
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.TextStrokeTransparency = 0.2
            textLabel.Font = Enum.Font.Gotham
            textLabel.TextSize = 10
            textLabel.TextScaled = false
            textLabel.Text = label
            textLabel.Parent = billboard
            
            data.billboard = billboard
            data.textLabel = textLabel
            data.rootPart = rootPart
        end
    end
    
    Chams.Objects[target] = data
    return data
end

function Chams.Update(target, newLabel, newDist)
    local data = Chams.Objects[target]
    if not data then return end
    
    if data.textLabel and newLabel then
        local text = newLabel
        if newDist and Config.ESP_Distance then
            text = text .. "\n" .. math.floor(newDist) .. "m"
        end
        data.textLabel.Text = text
    end
end

function Chams.SetColor(target, colorData)
    local data = Chams.Objects[target]
    if not data or not data.highlight then return end
    
    data.highlight.FillColor = colorData.fill
    data.highlight.OutlineColor = colorData.outline
    data.highlight.FillTransparency = colorData.fillTrans
    
    if data.textLabel then
        data.textLabel.TextColor3 = colorData.outline
    end
end

function Chams.Remove(target)
    local data = Chams.Objects[target]
    if data then
        if data.highlight and data.highlight.Parent then
            data.highlight:Destroy()
        end
        if data.billboard and data.billboard.Parent then
            data.billboard:Destroy()
        end
        Chams.Objects[target] = nil
    end
    
    if target then
        local existing = target:FindFirstChild("_ViolenceChams")
        if existing then existing:Destroy() end
        local existingLabel = target:FindFirstChild("_ViolenceLabel")
        if existingLabel then existingLabel:Destroy() end
    end
end

function Chams.ClearAll()
    for target, _ in pairs(Chams.Objects) do
        Chams.Remove(target)
    end
    Chams.Objects = {}
end



local ESP = {
    cache = {},
    objectCache = {},
    velocityData = {}
}

function ESP.create()
    local skel = {}
    for i = 1, 14 do
        skel[i] = Drawing.new("Line")
        skel[i].Thickness = 1
        skel[i].Visible = false
    end
    
    local box = {}
    for i = 1, 4 do
        box[i] = Drawing.new("Line")
        box[i].Thickness = 1
        box[i].Visible = false
    end
    
    return {
        Box = box,
        Name = Drawing.new("Text"),
        Dist = Drawing.new("Text"),
        Skel = skel,
        HealthBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Offscreen = Drawing.new("Triangle"),
        VelLine = Drawing.new("Line"),
        VelArrow = Drawing.new("Triangle")
    }
end

function ESP.setup(esp)
    for _, l in ipairs(esp.Box) do
        l.Thickness = 1
        l.Visible = false
    end
    
    esp.Name.Size = 14
    esp.Name.Font = Drawing.Fonts.Monospace
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Visible = false
    
    esp.Dist.Size = 12
    esp.Dist.Font = Drawing.Fonts.Monospace
    esp.Dist.Center = true
    esp.Dist.Outline = true
    esp.Dist.Color = Color3.fromRGB(180, 180, 180)
    esp.Dist.Visible = false
    
    for _, l in ipairs(esp.Skel) do
        l.Thickness = 1
        l.Visible = false
    end
    
    esp.HealthBg.Filled = true
    esp.HealthBg.Color = Colors.HealthBg
    esp.HealthBg.Visible = false
    
    esp.HealthBar.Filled = true
    esp.HealthBar.Visible = false
    
    esp.Offscreen.Filled = true
    esp.Offscreen.Visible = false
    
    esp.VelLine.Thickness = 2
    esp.VelLine.Color = Color3.fromRGB(0, 255, 255)
    esp.VelLine.Visible = false
    
    esp.VelArrow.Filled = true
    esp.VelArrow.Color = Color3.fromRGB(0, 255, 255)
    esp.VelArrow.Visible = false
end

function ESP.hide(esp)
    if not esp then return end
    for _, l in ipairs(esp.Box) do l.Visible = false end
    esp.Name.Visible = false
    esp.Dist.Visible = false
    for _, l in ipairs(esp.Skel) do l.Visible = false end
    esp.HealthBg.Visible = false
    esp.HealthBar.Visible = false
    esp.Offscreen.Visible = false
    esp.VelLine.Visible = false
    esp.VelArrow.Visible = false
end

function ESP.destroy(esp)
    if not esp then return end
    pcall(function()
        for _, l in ipairs(esp.Box) do l:Remove() end
        esp.Name:Remove()
        esp.Dist:Remove()
        for _, l in ipairs(esp.Skel) do l:Remove() end
        esp.HealthBg:Remove()
        esp.HealthBar:Remove()
        esp.Offscreen:Remove()
        esp.VelLine:Remove()
        esp.VelArrow:Remove()
    end)
end

function ESP.hideAll()
    for _, esp in pairs(ESP.cache) do
        ESP.hide(esp)
    end
end

function ESP.cleanup()
    local validPlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        validPlayers[p] = true
    end
    for player, esp in pairs(ESP.cache) do
        if not validPlayers[player] then
            ESP.hide(esp)
            ESP.destroy(esp)
            ESP.cache[player] = nil
            ESP.velocityData[player] = nil
        end
    end
end

function ESP.createObject()
    local box = {}
    for i = 1, 4 do
        box[i] = Drawing.new("Line")
        box[i].Thickness = 1
        box[i].Visible = false
    end
    
    return {
        Box = box,
        Label = Drawing.new("Text"),
        Dist = Drawing.new("Text")
    }
end

function ESP.setupObject(esp)
    for _, l in ipairs(esp.Box) do
        l.Thickness = 1
        l.Visible = false
    end
    
    esp.Label.Size = 13
    esp.Label.Font = Drawing.Fonts.Monospace
    esp.Label.Center = true
    esp.Label.Outline = true
    esp.Label.Visible = false
    
    esp.Dist.Size = 11
    esp.Dist.Font = Drawing.Fonts.Monospace
    esp.Dist.Center = true
    esp.Dist.Outline = true
    esp.Dist.Color = Color3.fromRGB(160, 160, 160)
    esp.Dist.Visible = false
end

function ESP.hideObject(esp)
    if not esp then return end
    for _, l in ipairs(esp.Box) do l.Visible = false end
    esp.Label.Visible = false
    esp.Dist.Visible = false
end

function ESP.destroyObject(esp)
    if not esp then return end
    pcall(function()
        for _, l in ipairs(esp.Box) do l:Remove() end
        esp.Label:Remove()
        esp.Dist:Remove()
    end)
end

function ESP.render(esp, player, char, cam, screenSize, screenCenter)
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if not root or not head then
        ESP.hide(esp)
        return
    end
    
    local myRoot = GetCharacterRoot()
    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
    
    if dist > Config.ESP_MaxDist then
        ESP.hide(esp)
        return
    end
    
    local isKillerPlayer = IsKiller(player)
    local visible = Cache.Visibility[player]
    local col = isKillerPlayer and (visible and Colors.KillerVis or Colors.Killer) or (visible and Colors.SurvivorVis or Colors.Survivor)
    local skelCol = visible and Colors.SkeletonVis or Colors.Skeleton
    
    local headPos = head.Position + Vector3.new(0, 0.5, 0)
    local feetPos = root.Position - Vector3.new(0, 3, 0)
    
    local rs = cam:WorldToViewportPoint(root.Position)
    local hs = cam:WorldToViewportPoint(headPos)
    local fs = cam:WorldToViewportPoint(feetPos)
    
    local onScreen = rs.Z > 0 and rs.X > 0 and rs.X < screenSize.X and rs.Y > 0 and rs.Y < screenSize.Y
    
    if not onScreen then
        for _, l in ipairs(esp.Box) do l.Visible = false end
        esp.Name.Visible = false
        esp.Dist.Visible = false
        for _, l in ipairs(esp.Skel) do l.Visible = false end
        esp.HealthBg.Visible = false
        esp.HealthBar.Visible = false
        esp.VelLine.Visible = false
        esp.VelArrow.Visible = false
        
        if Config.ESP_Offscreen and visible then
            local dx = rs.X - screenCenter.X
            local dy = rs.Y - screenCenter.Y
            local angle = math.atan2(dy, dx)
            local edge = 50
            local arrowX = math.clamp(screenCenter.X + math.cos(angle) * (screenSize.X/2 - edge), edge, screenSize.X - edge)
            local arrowY = math.clamp(screenCenter.Y + math.sin(angle) * (screenSize.Y/2 - edge), edge, screenSize.Y - edge)
            local fwd = Vector2.new(math.cos(angle), math.sin(angle))
            local right = Vector2.new(-fwd.Y, fwd.X)
            local pos = Vector2.new(arrowX, arrowY)
            local arrowSize = 12
            esp.Offscreen.PointA = pos + fwd * arrowSize
            esp.Offscreen.PointB = pos - fwd * arrowSize/2 - right * arrowSize/2
            esp.Offscreen.PointC = pos - fwd * arrowSize/2 + right * arrowSize/2
            esp.Offscreen.Color = col
            esp.Offscreen.Visible = true
        else
            esp.Offscreen.Visible = false
        end
        return
    end
    
    esp.Offscreen.Visible = false
    
    local boxTop = hs.Y
    local boxBottom = fs.Y
    local boxHeight = math.abs(boxBottom - boxTop)
    local boxWidth = boxHeight * 0.6
    local cx = rs.X
    
    esp.Box[1].From = Vector2.new(cx - boxWidth/2, boxTop)
    esp.Box[1].To = Vector2.new(cx + boxWidth/2, boxTop)
    esp.Box[2].From = Vector2.new(cx + boxWidth/2, boxTop)
    esp.Box[2].To = Vector2.new(cx + boxWidth/2, boxBottom)
    esp.Box[3].From = Vector2.new(cx + boxWidth/2, boxBottom)
    esp.Box[3].To = Vector2.new(cx - boxWidth/2, boxBottom)
    esp.Box[4].From = Vector2.new(cx - boxWidth/2, boxBottom)
    esp.Box[4].To = Vector2.new(cx - boxWidth/2, boxTop)
    for _, l in ipairs(esp.Box) do
        l.Color = col
        l.Visible = true
    end
    
    if Config.ESP_Names then
        esp.Name.Text = player.Name
        esp.Name.Position = Vector2.new(cx, boxTop - 18)
        esp.Name.Color = col
        esp.Name.Visible = true
    else
        esp.Name.Visible = false
    end
    
    if Config.ESP_Distance then
        esp.Dist.Text = math.floor(dist) .. "m"
        esp.Dist.Position = Vector2.new(cx, boxBottom + 4)
        esp.Dist.Visible = true
    else
        esp.Dist.Visible = false
    end
    
    if Config.ESP_Health and hum then
        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local barX = cx - boxWidth/2 - 6
        local barH = boxHeight * pct
        
        esp.HealthBg.Position = Vector2.new(barX - 1, boxTop - 1)
        esp.HealthBg.Size = Vector2.new(5, boxHeight + 2)
        esp.HealthBg.Visible = true
        
        esp.HealthBar.Position = Vector2.new(barX, boxBottom - barH)
        esp.HealthBar.Size = Vector2.new(3, barH)
        esp.HealthBar.Color = pct > 0.6 and Colors.HealthHigh or pct > 0.3 and Colors.HealthMid or Colors.HealthLow
        esp.HealthBar.Visible = true
    else
        esp.HealthBg.Visible = false
        esp.HealthBar.Visible = false
    end
    
    if Config.ESP_Skeleton then
        local bones = IsR6(char) and Bones_R6 or Bones_R15
        for i, b in ipairs(bones) do
            if esp.Skel[i] then
                local p1 = char:FindFirstChild(b[1])
                local p2 = char:FindFirstChild(b[2])
                if p1 and p2 then
                    local s1 = cam:WorldToViewportPoint(p1.Position)
                    local s2 = cam:WorldToViewportPoint(p2.Position)
                    if s1.Z > 0 and s2.Z > 0 then
                        esp.Skel[i].From = Vector2.new(s1.X, s1.Y)
                        esp.Skel[i].To = Vector2.new(s2.X, s2.Y)
                        esp.Skel[i].Color = skelCol
                        esp.Skel[i].Visible = true
                    else
                        esp.Skel[i].Visible = false
                    end
                else
                    esp.Skel[i].Visible = false
                end
            end
        end
        for i = #bones + 1, #esp.Skel do
            if esp.Skel[i] then esp.Skel[i].Visible = false end
        end
    else
        for _, l in ipairs(esp.Skel) do l.Visible = false end
    end
    
    local vd = ESP.velocityData[player]
    if not vd then
        vd = {pos = root.Position, vel = Vector3.zero, time = tick()}
        ESP.velocityData[player] = vd
    end
    local now = tick()
    local dt = now - vd.time
    if dt > 0.03 then
        local rawVel = (root.Position - vd.pos) / dt
        vd.vel = vd.vel * 0.7 + rawVel * 0.3
        vd.pos = root.Position
        vd.time = now
    end
    
    if Config.ESP_Velocity then
        local velFlat = Vector3.new(vd.vel.X, 0, vd.vel.Z)
        local velMag = velFlat.Magnitude
        if velMag > 2 then
            local futurePos = root.Position + velFlat.Unit * math.clamp(velMag * 0.4, 5, 20)
            local futureScreen, futureOn = cam:WorldToViewportPoint(futurePos)
            if futureOn and futureScreen.Z > 0 then
                esp.VelLine.From = Vector2.new(rs.X, rs.Y)
                esp.VelLine.To = Vector2.new(futureScreen.X, futureScreen.Y)
                esp.VelLine.Visible = true
                local dx, dy = futureScreen.X - rs.X, futureScreen.Y - rs.Y
                local len = math.sqrt(dx*dx + dy*dy)
                if len > 5 then
                    local fx, fy = dx/len, dy/len
                    esp.VelArrow.PointA = Vector2.new(futureScreen.X, futureScreen.Y)
                    esp.VelArrow.PointB = Vector2.new(futureScreen.X - fx*10 + fy*5, futureScreen.Y - fy*10 - fx*5)
                    esp.VelArrow.PointC = Vector2.new(futureScreen.X - fx*10 - fy*5, futureScreen.Y - fy*10 + fx*5)
                    esp.VelArrow.Visible = true
                else
                    esp.VelArrow.Visible = false
                end
            else
                esp.VelLine.Visible = false
                esp.VelArrow.Visible = false
            end
        else
            esp.VelLine.Visible = false
            esp.VelArrow.Visible = false
        end
    else
        esp.VelLine.Visible = false
        esp.VelArrow.Visible = false
    end
end

function ESP.renderObject(esp, pos, label, color, cam)
    local myRoot = GetCharacterRoot()
    local dist = myRoot and (pos - myRoot.Position).Magnitude or 0
    
    if dist > Config.ESP_MaxDist then
        ESP.hideObject(esp)
        return
    end
    
    local screen = cam:WorldToViewportPoint(pos)
    if screen.Z <= 0 then
        ESP.hideObject(esp)
        return
    end
    
    local size = math.clamp(800 / screen.Z, 16, 60)
    
    esp.Box[1].From = Vector2.new(screen.X - size/2, screen.Y - size/2)
    esp.Box[1].To = Vector2.new(screen.X + size/2, screen.Y - size/2)
    esp.Box[2].From = Vector2.new(screen.X + size/2, screen.Y - size/2)
    esp.Box[2].To = Vector2.new(screen.X + size/2, screen.Y + size/2)
    esp.Box[3].From = Vector2.new(screen.X + size/2, screen.Y + size/2)
    esp.Box[3].To = Vector2.new(screen.X - size/2, screen.Y + size/2)
    esp.Box[4].From = Vector2.new(screen.X - size/2, screen.Y + size/2)
    esp.Box[4].To = Vector2.new(screen.X - size/2, screen.Y - size/2)
    for _, l in ipairs(esp.Box) do
        l.Color = color
        l.Visible = true
    end
    
    esp.Label.Text = label
    esp.Label.Position = Vector2.new(screen.X, screen.Y - size/2 - 14)
    esp.Label.Color = color
    esp.Label.Visible = true
    
    if Config.ESP_Distance then
        esp.Dist.Text = math.floor(dist) .. "m"
        esp.Dist.Position = Vector2.new(screen.X, screen.Y + size/2 + 2)
        esp.Dist.Visible = true
    else
        esp.Dist.Visible = false
    end
end

function ESP.step(cam, screenSize, screenCenter)
    -- ESP controlled per-toggle (Killer ESP / Survivor ESP / Objects)
    -- No global enable needed
    ESP.cleanup()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                if ESP.cache[player] then ESP.hide(ESP.cache[player]) end
            else
                local isKillerPlayer = IsKiller(player)
                local shouldShow = (isKillerPlayer and Config.ESP_Killer) or (not isKillerPlayer and Config.ESP_Survivor)
                
                if not shouldShow then
                    if ESP.cache[player] then ESP.hide(ESP.cache[player]) end
                    Chams.Remove(char)
                else
                    if not Config.ESP_PlayerChams then
                        if not ESP.cache[player] then
                            ESP.cache[player] = ESP.create()
                            ESP.setup(ESP.cache[player])
                        end
                        ESP.render(ESP.cache[player], player, char, cam, screenSize, screenCenter)
                        Chams.Remove(char)
                    else
                        if ESP.cache[player] then ESP.hide(ESP.cache[player]) end
                        local colorData = isKillerPlayer and ChamsColors.Killer or ChamsColors.Survivor
                        local root = char:FindFirstChild("HumanoidRootPart")
                        local dist = root and GetDistance(root.Position) or 0
                        if not Chams.Objects[char] then
                            Chams.Create(char, colorData, player.Name)
                        else
                            Chams.SetColor(char, colorData)
                        end
                        Chams.Update(char, player.Name, dist)
                    end
                end
            end
        end
    end
end


local Radar = {
    bg = Drawing.new("Square"),
    circleBg = Drawing.new("Circle"),
    border = Drawing.new("Square"),
    circleBorder = Drawing.new("Circle"),
    cross1 = Drawing.new("Line"),
    cross2 = Drawing.new("Line"),
    center = Drawing.new("Triangle"),
    dots = {},
    objectDots = {},
    palletSquares = {}
}

do
    Radar.bg.Filled = true
    Radar.bg.Color = Colors.RadarBg
    Radar.bg.Transparency = 0.8
    Radar.circleBg.Filled = true
    Radar.circleBg.Color = Colors.RadarBg
    Radar.circleBg.Transparency = 0.8
    Radar.circleBg.NumSides = 64
    Radar.border.Filled = false
    Radar.border.Color = Colors.RadarBorder
    Radar.border.Thickness = 2
    Radar.circleBorder.Filled = false
    Radar.circleBorder.Color = Colors.RadarBorder
    Radar.circleBorder.Thickness = 2
    Radar.circleBorder.NumSides = 64
    Radar.cross1.Color = Color3.fromRGB(40, 40, 40)
    Radar.cross1.Thickness = 1
    Radar.cross2.Color = Color3.fromRGB(40, 40, 40)
    Radar.cross2.Thickness = 1
    Radar.center.Filled = true
    Radar.center.Color = Colors.RadarYou
    for i = 1, 100 do
        local d = Drawing.new("Triangle")
        d.Filled = true
        d.Visible = false
        Radar.dots[i] = d
    end
    for i = 1, 100 do
        local d = Drawing.new("Circle")
        d.Filled = true
        d.Visible = false
        d.NumSides = 16
        Radar.objectDots[i] = d
    end
    for i = 1, 100 do
        local d = Drawing.new("Square")
        d.Filled = true
        d.Visible = false
        Radar.palletSquares[i] = d
    end
end

function Radar.hideAll()
    Radar.bg.Visible = false
    Radar.circleBg.Visible = false
    Radar.border.Visible = false
    Radar.circleBorder.Visible = false
    Radar.center.Visible = false
    Radar.cross1.Visible = false
    Radar.cross2.Visible = false
    for _, d in pairs(Radar.dots) do d.Visible = false end
    for _, d in pairs(Radar.objectDots) do d.Visible = false end
    for _, d in pairs(Radar.palletSquares) do d.Visible = false end
end

function Radar.step(cam)
    if not Config.RADAR_Enabled then
        Radar.hideAll()
        return
    end
    
    local size = Config.RADAR_Size
    local pos = Vector2.new(cam.ViewportSize.X - size - 20, 20)
    local center = pos + Vector2.new(size/2, size/2)
    
    if Config.RADAR_Circle then
        Radar.bg.Visible = false
        Radar.border.Visible = false
        Radar.circleBg.Position = center
        Radar.circleBg.Radius = size/2
        Radar.circleBg.Visible = true
        Radar.circleBorder.Position = center
        Radar.circleBorder.Radius = size/2
        Radar.circleBorder.Visible = true
    else
        Radar.circleBg.Visible = false
        Radar.circleBorder.Visible = false
        Radar.bg.Position = pos
        Radar.bg.Size = Vector2.new(size, size)
        Radar.bg.Visible = true
        Radar.border.Position = pos
        Radar.border.Size = Vector2.new(size, size)
        Radar.border.Visible = true
    end
    
    Radar.cross1.From = Vector2.new(center.X, pos.Y + 10)
    Radar.cross1.To = Vector2.new(center.X, pos.Y + size - 10)
    Radar.cross1.Visible = true
    Radar.cross2.From = Vector2.new(pos.X + 10, center.Y)
    Radar.cross2.To = Vector2.new(pos.X + size - 10, center.Y)
    Radar.cross2.Visible = true
    
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myLook = cam.CFrame.LookVector
    if not myRoot then
        Radar.center.Visible = false
        for _, d in pairs(Radar.dots) do d.Visible = false end
        for _, d in pairs(Radar.objectDots) do d.Visible = false end
        for _, d in pairs(Radar.palletSquares) do d.Visible = false end
        return
    end
    
    local myAngle = math.atan2(-myLook.X, -myLook.Z)
    local cosA, sinA = math.cos(myAngle), math.sin(myAngle)
    local scale = (size/2 - 10) / Tuning.RadarRange
    local idx = 1
    local objIdx = 1
    local palletIdx = 1
    
    if Config.RADAR_Killer then
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if idx > #Radar.dots then break end
            if not IsKiller(player) then continue end
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local rx, rz = root.Position.X - myRoot.Position.X, root.Position.Z - myRoot.Position.Z
                    local dist2D = math.sqrt(rx^2 + rz^2)
                    if dist2D < Tuning.RadarRange then
                        local rotX = rx * cosA - rz * sinA
                        local rotZ = rx * sinA + rz * cosA
                        local radarX, radarY = rotX * scale, rotZ * scale
                        local maxD = size/2 - 8
                        local rDist = math.sqrt(radarX^2 + radarY^2)
                        if rDist > maxD then
                            radarX, radarY = radarX/rDist*maxD, radarY/rDist*maxD
                        end
                        local dotPos = center + Vector2.new(radarX, radarY)
                        local dot = Radar.dots[idx]
                        local head = char:FindFirstChild("Head")
                        local eAngle = head and math.atan2(-head.CFrame.LookVector.X, -head.CFrame.LookVector.Z) - myAngle or 0
                        local eFwd = Vector2.new(-math.sin(eAngle), -math.cos(eAngle))
                        local eRight = Vector2.new(-eFwd.Y, eFwd.X)
                        dot.PointA = dotPos + eFwd * Tuning.RadarDotSize
                        dot.PointB = dotPos - eFwd * Tuning.RadarDotSize/2 + eRight * Tuning.RadarDotSize/2
                        dot.PointC = dotPos - eFwd * Tuning.RadarDotSize/2 - eRight * Tuning.RadarDotSize/2
                        dot.Color = Colors.Killer
                        dot.Visible = true
                        idx = idx + 1
                    end
                end
            end
        end
    end
    
    if Config.RADAR_Survivor then
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if idx > #Radar.dots then break end
            if not IsSurvivor(player) then continue end
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local rx, rz = root.Position.X - myRoot.Position.X, root.Position.Z - myRoot.Position.Z
                    local dist2D = math.sqrt(rx^2 + rz^2)
                    if dist2D < Tuning.RadarRange then
                        local rotX = rx * cosA - rz * sinA
                        local rotZ = rx * sinA + rz * cosA
                        local radarX, radarY = rotX * scale, rotZ * scale
                        local maxD = size/2 - 8
                        local rDist = math.sqrt(radarX^2 + radarY^2)
                        if rDist > maxD then
                            radarX, radarY = radarX/rDist*maxD, radarY/rDist*maxD
                        end
                        local dotPos = center + Vector2.new(radarX, radarY)
                        local dot = Radar.dots[idx]
                        local head = char:FindFirstChild("Head")
                        local eAngle = head and math.atan2(-head.CFrame.LookVector.X, -head.CFrame.LookVector.Z) - myAngle or 0
                        local eFwd = Vector2.new(-math.sin(eAngle), -math.cos(eAngle))
                        local eRight = Vector2.new(-eFwd.Y, eFwd.X)
                        dot.PointA = dotPos + eFwd * Tuning.RadarDotSize
                        dot.PointB = dotPos - eFwd * Tuning.RadarDotSize/2 + eRight * Tuning.RadarDotSize/2
                        dot.PointC = dotPos - eFwd * Tuning.RadarDotSize/2 - eRight * Tuning.RadarDotSize/2
                        dot.Color = Colors.Survivor
                        dot.Visible = true
                        idx = idx + 1
                    end
                end
            end
        end
    end
    
    if Config.RADAR_Generator then
        for _, gen in ipairs(Cache.Generators) do
            if objIdx > #Radar.objectDots then break end
            if gen.part and gen.part.Parent then
                local rx, rz = gen.part.Position.X - myRoot.Position.X, gen.part.Position.Z - myRoot.Position.Z
                local dist2D = math.sqrt(rx^2 + rz^2)
                if dist2D < Tuning.RadarRange then
                    local rotX = rx * cosA - rz * sinA
                    local rotZ = rx * sinA + rz * cosA
                    local radarX, radarY = rotX * scale, rotZ * scale
                    local maxD = size/2 - 8
                    local rDist = math.sqrt(radarX^2 + radarY^2)
                    if rDist > maxD then
                        radarX, radarY = radarX/rDist*maxD, radarY/rDist*maxD
                    end
                    local dotPos = center + Vector2.new(radarX, radarY)
                    local dot = Radar.objectDots[objIdx]
                    dot.Position = dotPos
                    dot.Radius = 3
                    dot.Color = Colors.Generator
                    dot.Visible = true
                    objIdx = objIdx + 1
                end
            end
        end
    end
    
    if Config.RADAR_Pallet then
        for _, pallet in ipairs(Cache.Pallets) do
            if palletIdx > #Radar.palletSquares then break end
            if pallet.part and pallet.part.Parent then
                local rx, rz = pallet.part.Position.X - myRoot.Position.X, pallet.part.Position.Z - myRoot.Position.Z
                local dist2D = math.sqrt(rx^2 + rz^2)
                if dist2D < Tuning.RadarRange then
                    local rotX = rx * cosA - rz * sinA
                    local rotZ = rx * sinA + rz * cosA
                    local radarX, radarY = rotX * scale, rotZ * scale
                    local maxD = size/2 - 8
                    local rDist = math.sqrt(radarX^2 + radarY^2)
                    if rDist > maxD then
                        radarX, radarY = radarX/rDist*maxD, radarY/rDist*maxD
                    end
                    local dotPos = center + Vector2.new(radarX, radarY)
                    local square = Radar.palletSquares[palletIdx]
                    local squareSize = 5
                    square.Position = dotPos - Vector2.new(squareSize/2, squareSize/2)
                    square.Size = Vector2.new(squareSize, squareSize)
                    square.Color = Colors.Pallet
                    square.Visible = true
                    palletIdx = palletIdx + 1
                end
            end
        end
    end
    
    for i = idx, #Radar.dots do Radar.dots[i].Visible = false end
    for i = objIdx, #Radar.objectDots do Radar.objectDots[i].Visible = false end
    for i = palletIdx, #Radar.palletSquares do Radar.palletSquares[i].Visible = false end
    
    Radar.center.PointA = center + Vector2.new(0, -Tuning.RadarArrowSize)
    Radar.center.PointB = center + Vector2.new(-Tuning.RadarArrowSize/2, Tuning.RadarArrowSize/2)
    Radar.center.PointC = center + Vector2.new(Tuning.RadarArrowSize/2, Tuning.RadarArrowSize/2)
    Radar.center.Visible = true
end


local Aimbot = {}

function Aimbot.GetTargetPart(char)
    if not char then return nil end
    local partName = Config.AIM_TargetPart
    if partName == "Head" then
        return char:FindFirstChild("Head")
    elseif partName == "Torso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("HumanoidRootPart")
    end
end

function Aimbot.GetClosestTarget(cam, screenCenter)
    if not cam then return nil end
    
    local myRole = GetRole()
    local closestPlayer = nil
    local closestDist = Config.AIM_FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team then
           
            local shouldTarget = false
            local targetRole = Config.AIM_TargetRole or "Killer"
            if targetRole == "Killer" and IsKiller(player) then
                shouldTarget = true
            elseif targetRole == "Survivor" and IsSurvivor(player) then
                shouldTarget = true
            end
            
            if shouldTarget then
                local targetPart = Aimbot.GetTargetPart(player.Character)
                if targetPart then
               
                    local passVisCheck = true
                    if Config.AIM_VisCheck and not Cache.Visibility[player] then
                        passVisCheck = false
                    end
                    
                    if passVisCheck then
                        local screenPos, onScreen, depth = WorldToScreen(targetPart.Position)
                        if onScreen and depth > 0 then
                            local dist = (screenPos - screenCenter).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

function Aimbot.GetPredictedPosition(target, targetPart)
    if not target or not targetPart then return nil end
    
    local pos = targetPart.Position
    
    if Config.AIM_Predict then
        local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local velocity = root.Velocity
            
            pos = pos + velocity * 0.1
        end
    end
    
    return pos
end

function Aimbot.AimAt(cam, targetPos)
    if not cam or not targetPos then return end
    local currentCF = cam.CFrame
    local camPos    = currentCF.Position
    local targetCF  = CFrame.new(camPos, targetPos)
    local smooth    = Config.AIM_Smooth
    -- Direct CFrame set tanpa ubah CameraType
    -- Game akan override balik tiap frame tapi kita juga set tiap frame di RenderStepped
    -- Net effect: camera terus-menerus di-nudge ke arah target
    pcall(function()
        cam.CFrame = CFrame.new(camPos) * (currentCF - camPos):Lerp((targetCF - camPos), smooth)
    end)
end

function Aimbot.Update(cam, screenSize, screenCenter)
    if not Config.AIM_Enabled then
        State.AimTarget = nil
        return
    end
    local target = Aimbot.GetClosestTarget(cam, screenCenter)
    State.AimTarget = target
    if target and target.Character then
        local targetPart = Aimbot.GetTargetPart(target.Character)
        if targetPart then
            local predictedPos = Aimbot.GetPredictedPosition(target, targetPart)
            if predictedPos then
                Aimbot.AimAt(cam, predictedPos)
            end
        end
    end
end


local function ScanMap()
    -- Cari container map: bisa "Map", "Level", "World", atau langsung di Workspace
    local map = Workspace:FindFirstChild("Map")
             or Workspace:FindFirstChild("Level")
             or Workspace:FindFirstChild("World")
             or Workspace
    
    local newGenerators = {}
    local newGates = {}
    local newHooks = {}
    local newPallets = {}
    local newWindows = {}
    
    -- Batasi depth scan agar tidak freeze (max 6 level deep)
    local function scanDescendants(parent, depth)
        if depth > 6 then return end
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("Model") then
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local n = obj.Name
                    if n == "Generator" then
                        table.insert(newGenerators, {model = obj, part = part})
                    elseif n == "Gate" or n:lower():find("gate") then
                        table.insert(newGates, {model = obj, part = part})
                    elseif n == "Hook" then
                        table.insert(newHooks, {model = obj, part = part})
                    elseif n:lower():find("pallet") then
                        table.insert(newPallets, {model = obj, part = part})
                    elseif n == "Window" then
                        table.insert(newWindows, {model = obj, part = part})
                    end
                end
            end
            if obj:IsA("Model") or obj:IsA("Folder") then
                scanDescendants(obj, depth + 1)
            end
        end
    end
    scanDescendants(map, 0)
    
    Cache.Generators = newGenerators
    Cache.Gates = newGates
    Cache.Hooks = newHooks
    Cache.Pallets = newPallets
    Cache.Windows = newWindows
    
    local root = GetCharacterRoot()
    if root and #Cache.Hooks > 0 then
        local closest, closestDist = nil, math.huge
        for _, hook in ipairs(Cache.Hooks) do
            if hook.part then
                local d = (hook.part.Position - root.Position).Magnitude
                if d < closestDist then
                    closestDist = d
                    closest = hook
                end
            end
        end
        Cache.ClosestHook = closest
    end
end

local function UpdateVisibility()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            Cache.Visibility[player] = IsVisible(player.Character)
        end
    end
end


local function UpdateObjectESP(cam)
    
    for _, esp in pairs(ESP.objectCache) do
        ESP.hideObject(esp)
    end
    
 
    for _, obj in ipairs(Cache.Generators) do
        local target = obj.model or obj.part
        if Config.ESP_Generator and obj.part and obj.part.Parent then
            if Config.ESP_ObjectChams then
                if not Chams.Objects[target] then
                    Chams.Create(target, ChamsColors.Generator, "GEN")
                end
                Chams.Update(target, "GEN", GetDistance(obj.part.Position))
            else
                local key = tostring(target)
                if not ESP.objectCache[key] then
                    ESP.objectCache[key] = ESP.createObject()
                    ESP.setupObject(ESP.objectCache[key])
                end
                ESP.renderObject(ESP.objectCache[key], obj.part.Position, "GEN", Colors.Generator, cam)
                Chams.Remove(target)
            end
        else
            Chams.Remove(target)
        end
    end
    
   
    for _, obj in ipairs(Cache.Gates) do
        local target = obj.model or obj.part
        if Config.ESP_Gate and obj.part and obj.part.Parent then
            if Config.ESP_ObjectChams then
                if not Chams.Objects[target] then
                    Chams.Create(target, ChamsColors.Gate, "GATE")
                end
                Chams.Update(target, "GATE", GetDistance(obj.part.Position))
            else
                local key = tostring(target)
                if not ESP.objectCache[key] then
                    ESP.objectCache[key] = ESP.createObject()
                    ESP.setupObject(ESP.objectCache[key])
                end
                ESP.renderObject(ESP.objectCache[key], obj.part.Position, "GATE", Colors.Gate, cam)
                Chams.Remove(target)
            end
        else
            Chams.Remove(target)
        end
    end
    
   
    for _, obj in ipairs(Cache.Hooks) do
        local target = obj.model or obj.part
        local isClosest = Config.ESP_ClosestHook and obj == Cache.ClosestHook
        if Config.ESP_Hook and obj.part and obj.part.Parent then
            local useColor = isClosest and Colors.HookClose or Colors.Hook
            local useChams = isClosest and ChamsColors.HookClose or ChamsColors.Hook
            local useLabel = isClosest and "HOOK!" or "HOOK"
            if Config.ESP_ObjectChams then
                if not Chams.Objects[target] then
                    Chams.Create(target, useChams, useLabel)
                else
                    Chams.SetColor(target, useChams)
                end
                Chams.Update(target, useLabel, GetDistance(obj.part.Position))
            else
                local key = tostring(target)
                if not ESP.objectCache[key] then
                    ESP.objectCache[key] = ESP.createObject()
                    ESP.setupObject(ESP.objectCache[key])
                end
                ESP.renderObject(ESP.objectCache[key], obj.part.Position, useLabel, useColor, cam)
                Chams.Remove(target)
            end
        else
            Chams.Remove(target)
        end
    end
    
  
    for _, obj in ipairs(Cache.Pallets) do
        local target = obj.model or obj.part
        if Config.ESP_Pallet and obj.part and obj.part.Parent then
            if Config.ESP_ObjectChams then
                if not Chams.Objects[target] then
                    Chams.Create(target, ChamsColors.Pallet, "PALLET")
                end
                Chams.Update(target, "PALLET", GetDistance(obj.part.Position))
            else
                local key = tostring(target)
                if not ESP.objectCache[key] then
                    ESP.objectCache[key] = ESP.createObject()
                    ESP.setupObject(ESP.objectCache[key])
                end
                ESP.renderObject(ESP.objectCache[key], obj.part.Position, "PALLET", Colors.Pallet, cam)
                Chams.Remove(target)
            end
        else
            Chams.Remove(target)
        end
    end
    
  
    for _, obj in ipairs(Cache.Windows) do
        local target = obj.model or obj.part
        if Config.ESP_Window and obj.part and obj.part.Parent then
            if Config.ESP_ObjectChams then
                if not Chams.Objects[target] then
                    Chams.Create(target, ChamsColors.Window, "WINDOW")
                end
                Chams.Update(target, "WINDOW", GetDistance(obj.part.Position))
            else
                local key = tostring(target)
                if not ESP.objectCache[key] then
                    ESP.objectCache[key] = ESP.createObject()
                    ESP.setupObject(ESP.objectCache[key])
                end
                ESP.renderObject(ESP.objectCache[key], obj.part.Position, "WINDOW", Colors.Window, cam)
                Chams.Remove(target)
            end
        else
            Chams.Remove(target)
        end
    end
end


local function StopAutoGen()
    Config.AUTO_Generator = false
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        -- Game anchor root saat repair - paksa unanchor
        if root then
            root.Anchored = false
            root.AssemblyLinearVelocity  = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end

        if hum then
            hum.PlatformStand = false
            hum.Sit           = false
            hum.WalkSpeed     = State.OriginalSpeed or 16
            hum.JumpPower     = OriginalJumpPower or 50
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function LeaveGenerator()
    Config.AUTO_Generator = false
    local char = LocalPlayer.Character
    if not char then return false end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end

    -- Paksa unanchor dulu (game anchor saat repair)
    root.Anchored = false
    root.AssemblyLinearVelocity  = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    -- Restore humanoid
    hum.PlatformStand = false
    hum.Sit           = false
    hum.WalkSpeed     = State.OriginalSpeed or 16
    hum.JumpPower     = OriginalJumpPower or 50
    hum:ChangeState(Enum.HumanoidStateType.GettingUp)

    -- Cari gen terdekat untuk TP menjauhi
    local nearestGen, nearestDist = nil, math.huge
    for _, gen in ipairs(Cache.Generators) do
        if gen.part and gen.part.Parent then
            local d = (gen.part.Position - root.Position).Magnitude
            if d < nearestDist then
                nearestDist = d
                nearestGen  = gen
            end
        end
    end

    if nearestGen then
        local dir = (root.Position - nearestGen.part.Position)
        dir = Vector3.new(dir.X, 0, dir.Z)
        if dir.Magnitude < 0.01 then dir = Vector3.new(1, 0, 0) end
        local escapePos = nearestGen.part.Position + dir.Unit * 20 + Vector3.new(0, 3, 0)
        -- Tunggu 1 frame biar unanchor ke-apply dulu
        task.defer(function()
            if root and root.Parent then
                root.CFrame = CFrame.new(escapePos)
            end
        end)
    end

    return true
end

local function TeleportToGenerator(index)
    if #Cache.Generators == 0 then return false end
    
    local sorted = {}
    for _, gen in ipairs(Cache.Generators) do
        table.insert(sorted, {gen = gen, dist = GetDistance(gen.part.Position)})
    end
    table.sort(sorted, function(a, b) return a.dist < b.dist end)
    
    local target = sorted[index or 1]
    if not target then return false end
    
    local root = GetCharacterRoot()
    if not root then return false end
    
    if true then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    root.CFrame = target.gen.part.CFrame + Vector3.new(0, Config.TP_Offset, 0)
    
    if true then
        task.delay(0.3, function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
    
    return true
end

local function TeleportToGate()
    if #Cache.Gates == 0 then return false end
    
    local closest, closestDist = nil, math.huge
    for _, gate in ipairs(Cache.Gates) do
        local dist = GetDistance(gate.part.Position)
        if dist < closestDist then
            closestDist = dist
            closest = gate
        end
    end
    
    if not closest then return false end
    
    local root = GetCharacterRoot()
    if not root then return false end
    
    if true then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    root.CFrame = closest.part.CFrame + Vector3.new(0, Config.TP_Offset, 0)
    
    if true then
        task.delay(0.3, function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
    
    return true
end

local function TeleportToHook()
    if not Cache.ClosestHook then return false end
    
    local root = GetCharacterRoot()
    if not root then return false end
    
    if true then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    root.CFrame = Cache.ClosestHook.part.CFrame + Vector3.new(0, Config.TP_Offset, 0)
    
    if true then
        task.delay(0.3, function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
    
    return true
end

local function GetKillerDistance()
    local root = GetCharacterRoot()
    if not root then return math.huge end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) then
            local killerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if killerRoot then
                return (killerRoot.Position - root.Position).Magnitude, killerRoot.Position
            end
        end
    end
    return math.huge, nil
end

local function TeleportAway()
    if not Config.AUTO_TeleAway then return end
    if GetRole() == "Killer" then return end 
    
   
    local now = tick()
    if now - State.LastTeleAway < 3 then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    local killerDist, killerPos = GetKillerDistance()
    if killerDist > Config.AUTO_TeleAwayDist then return end 
    
    State.LastTeleAway = now
    
   
    local bestSpot = nil
    local bestDist = 0
    
   
    for _, gate in ipairs(Cache.Gates) do
        if gate.part and killerPos then
            local gatePos = gate.part.Position
            local distFromKiller = (gatePos - killerPos).Magnitude
            if distFromKiller > bestDist then
                bestDist = distFromKiller
                bestSpot = gatePos
            end
        end
    end
    
    
    if not bestSpot or bestDist < 50 then
        for _, gen in ipairs(Cache.Generators) do
            if gen.part and killerPos then
                local genPos = gen.part.Position
                local distFromKiller = (genPos - killerPos).Magnitude
                if distFromKiller > bestDist then
                    bestDist = distFromKiller
                    bestSpot = genPos
                end
            end
        end
    end
    
  
    if not bestSpot and killerPos then
        local direction = (root.Position - killerPos).Unit
        bestSpot = root.Position + direction * 80
    end
    
    if bestSpot then
        if true then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        
        root.CFrame = CFrame.new(bestSpot + Vector3.new(0, Config.TP_Offset, 0))
        
        if true then
            task.delay(0.3, function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
    end
end



local OriginalHitboxSizes = {}

local function UpdateHitboxes()
    if GetRole() ~= "Killer" then
       
        for player, originalSize in pairs(OriginalHitboxSizes) do
            if player and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Size = originalSize
                    root.Transparency = 1
                    root.CanCollide = true
                end
            end
        end
        OriginalHitboxSizes = {}
        return
    end
    
    if not Config.HITBOX_Enabled then
     
        for player, originalSize in pairs(OriginalHitboxSizes) do
            if player and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Size = originalSize
                    root.Transparency = 1
                    root.CanCollide = true
                end
            end
        end
        OriginalHitboxSizes = {}
        return
    end
    
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                if root and hum and hum.Health > 0 then
                  
                    if not OriginalHitboxSizes[player] then
                        OriginalHitboxSizes[player] = root.Size
                    end
                    
                  
                    local size = Config.HITBOX_Size
                    root.Size = Vector3.new(size, size, size)
                    root.CanCollide = false
                    root.Transparency = 0.7
                elseif root then
                    
                    if OriginalHitboxSizes[player] then
                        root.Size = OriginalHitboxSizes[player]
                        root.Transparency = 1
                        root.CanCollide = true
                        OriginalHitboxSizes[player] = nil
                    end
                end
            end
        end
    end
end


Players.PlayerRemoving:Connect(function(player)
    OriginalHitboxSizes[player] = nil
end)

local function AutoAttack()
    if not Config.AUTO_Attack then return end
    if GetRole() ~= "Killer" then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist <= Config.AUTO_AttackRange then
                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if remotes then
                            local attacks = remotes:FindFirstChild("Attacks")
                            if attacks then
                                local basicAttack = attacks:FindFirstChild("BasicAttack")
                                if basicAttack then
                                    basicAttack:FireServer(false)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end
end


-- AUTO PARRY (sama dengan base code VD2, dipanggil dari AutoLoop tiap 0.1s)
-- ================================================================
-- AUTO PARRY
-- Smart proximity: fire 1x saat killer BARU masuk range (edge trigger)
-- Tidak spam, tidak butuh event/animation hook yang tidak reliable
-- Mode Distance: paling reliable karena tidak butuh hook yang mungkin tidak ada
-- ================================================================
local ParryRemote  = nil
local ParryConn    = nil  -- Heartbeat connection

local ParrySlowRemote = nil  -- Mechanics.Slow BindableEvent

local function AutoParry_GetRemote()
    if ParryRemote and ParryRemote.Parent then return ParryRemote end
    local r = ReplicatedStorage:FindFirstChild("Remotes")
    if not r then return nil end
    local items  = r:FindFirstChild("Items")
    if not items then return nil end
    local dagger = items:FindFirstChild("Parrying Dagger")
    if not dagger then return nil end
    local raw = dagger:FindFirstChild("parry")
    if not raw then return nil end
    ParryRemote = cloneref(raw)
    -- Cache Slow BindableEvent juga
    if not ParrySlowRemote then
        local mech = r:FindFirstChild("Mechanics")
        if mech then
            local slow = mech:FindFirstChild("Slow")
            if slow and slow:IsA("BindableEvent") then
                ParrySlowRemote = slow
            end
        end
    end
    return ParryRemote
end

local function AutoParry_FireParry()
    local remote = AutoParry_GetRemote()
    if not remote then return false end
    -- Fire persis seperti game script: Slow:Fire dulu, lalu parry:FireServer
    if ParrySlowRemote then
        pcall(function() ParrySlowRemote:Fire(0, 1, 0) end)
    end
    task.wait(0.05)
    pcall(function() remote:FireServer() end)
    return true
end

local ParryOnCooldown = false
local ParryGuiBtn     = nil  -- cache Gui-mob button

local function AutoParry_FindBtn()
    if ParryGuiBtn and ParryGuiBtn.Parent then return ParryGuiBtn end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, gui in ipairs(pg:GetChildren()) do
        local controls = gui:FindFirstChild("Controls", true)
        if controls then
            local btn = controls:FindFirstChild("Gui-mob")
            if btn then
                ParryGuiBtn = btn
                return btn
            end
        end
    end
    return nil
end

local ParryTimer = 0
local function AutoParry_Tick(dt)
    ParryTimer = ParryTimer + dt
    if ParryTimer < 0.1 then return end
    ParryTimer = 0

    if not Config.AUTO_Parry then return end
    if ParryOnCooldown then return end
    local team = LocalPlayer.Team
    if not team or team.Name ~= "Survivors" then return end

    local root = GetCharacterRoot()
    if not root then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local kr = player.Character:FindFirstChild("HumanoidRootPart")
            if kr and (kr.Position - root.Position).Magnitude <= Config.PARRY_Dist then
                local btn = AutoParry_FindBtn()
                if btn then
                    -- firesignal trigger MouseButton1Down persis seperti tap manual
                    pcall(function() firesignal(btn.MouseButton1Down) end)
                    ParryOnCooldown = true
                    task.delay(51, function()
                        ParryOnCooldown = false
                        ParryGuiBtn = nil  -- refresh cache
                    end)
                end
                return
            end
        end
    end
end

local function AutoParry() end  -- dummy, logic di AutoParry_Tick via Heartbeat

local function AutoParry_Setup()
    ParryRemote      = nil
    ParrySlowRemote  = nil
    ParryTimer       = 0
    ParryOnCooldown  = false
    if ParryConn then pcall(function() ParryConn:Disconnect() end) end
    ParryConn = RunService.Heartbeat:Connect(AutoParry_Tick)
end

local function AutoParry_Cleanup()
    ParryRemote = nil
    if ParryConn then
        pcall(function() ParryConn:Disconnect() end)
        ParryConn = nil
    end
end

local LastWiggleTime = 0
local function AutoWiggle()
    if not Config.SURV_AutoWiggle then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - LastWiggleTime < 0.3 then return end
    
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local carry = remotes:FindFirstChild("Carry")
                if carry then
                    local selfUnhook = carry:FindFirstChild("SelfUnHookEvent")
                    if selfUnhook then
                        selfUnhook:FireServer()
                    LastWiggleTime = tick()
                    end
                end
            end
        end)
end

-- =========================================================
-- SKILL CHECK SYSTEM

-- ================================================================
-- GODMODE
-- ================================================================
local GodmodeConn = nil
local GodmodeLoop = nil

local function Godmode_Apply()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if GodmodeConn then pcall(function() GodmodeConn:Disconnect() end) end
    if GodmodeLoop then pcall(function() GodmodeLoop:Disconnect() end) end
    GodmodeConn = hum.HealthChanged:Connect(function(h)
        if not Config.GODMODE then return end
        if h < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
    GodmodeLoop = RunService.Heartbeat:Connect(function()
        if not Config.GODMODE then return end
        if not hum or not hum.Parent then return end
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        pcall(function() char:SetAttribute("IsDown", false) end)
        pcall(function() char:SetAttribute("IsCarried", false) end)
    end)
end

local function Godmode_Remove()
    if GodmodeConn then pcall(function() GodmodeConn:Disconnect() end); GodmodeConn = nil end
    if GodmodeLoop then pcall(function() GodmodeLoop:Disconnect() end); GodmodeLoop = nil end
end

local SkillcheckGenScript = nil

local SkillcheckPlayerScript = nil
local SkillcheckDescConn     = nil

local function AntiScript_Disable(scr)
    if not scr then return end
    if scr.Name == "Skillcheck-gen" and Config.ANTI_FailGen then
        pcall(function() scr.Enabled = false end)
        SkillcheckGenScript = scr
    end
    if scr.Name == "Skillcheck-player" and Config.ANTI_SkillCheck then
        pcall(function() scr.Enabled = false end)
        SkillcheckPlayerScript = scr
    end
end

local function AntiScript_Apply(char)
    if not char then return end
    if SkillcheckDescConn then
        pcall(function() SkillcheckDescConn:Disconnect() end)
        SkillcheckDescConn = nil
    end
    -- Disable yang sudah ada
    for _, scr in ipairs(char:GetChildren()) do
        AntiScript_Disable(scr)
    end
    -- Hook DescendantAdded untuk round baru
    SkillcheckDescConn = char.DescendantAdded:Connect(function(desc)
        AntiScript_Disable(desc)
    end)
end

-- Wrapper untuk AntiFailGen (backward compat)
local function AntiFailGen_Apply(char)
    AntiScript_Apply(char)
end

local function AntiFailGen_Restore()
    if SkillcheckDescConn then
        pcall(function() SkillcheckDescConn:Disconnect() end)
        SkillcheckDescConn = nil
    end
    if SkillcheckGenScript and SkillcheckGenScript.Parent then
        pcall(function() SkillcheckGenScript.Enabled = true end)
    end
    if SkillcheckPlayerScript and SkillcheckPlayerScript.Parent then
        pcall(function() SkillcheckPlayerScript.Enabled = true end)
    end
    SkillcheckGenScript    = nil
    SkillcheckPlayerScript = nil
end

local function DestroyAllPallets()
    if not Config.KILLER_DestroyPallets then return end
    if GetRole() ~= "Killer" then return end
    
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local pallet = remotes:FindFirstChild("Pallet")
            if pallet then
                local jason = pallet:FindFirstChild("Jason")
                if jason then
                   
                    local destroyGlobal = jason:FindFirstChild("Destroy-Global")
                    if destroyGlobal then
                        destroyGlobal:FireServer()
                    end
                    
                    local destroy = jason:FindFirstChild("Destroy")
                    if destroy then
                        local map = workspace:FindFirstChild("Map")
                        if map then
                            for _, obj in ipairs(map:GetDescendants()) do
                                if obj.Name:lower():find("pallet") and obj:IsA("Model") then
                                    destroy:FireServer(obj)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end


local LastGenBreakTime = 0
local function FullGenBreak()
    if not Config.KILLER_FullGenBreak then return end
    if GetRole() ~= "Killer" then return end
    if tick() - LastGenBreakTime < 0.3 then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local generator = remotes:FindFirstChild("Generator")
            if generator then
                local breakEvent = generator:FindFirstChild("BreakGenEvent")
                if breakEvent then
                  
                    local map = workspace:FindFirstChild("Map")
                    if map then
                        for _, obj in ipairs(map:GetDescendants()) do
                            if obj.Name:lower():find("generator") or obj.Name:lower():find("gen") then
                                local genPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if genPart then
                                    local dist = (genPart.Position - root.Position).Magnitude
                                    if dist <= 15 then
                                        breakEvent:FireServer(obj)
                                        LastGenBreakTime = tick()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local SpeedWasOn = false

local function UpdateSpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if Config.SPEED_Enabled then
        -- Simpan speed asli sekali saat pertama aktif
        if not SpeedWasOn then
            State.OriginalSpeed = hum.WalkSpeed
            SpeedWasOn = true
        end
        hum.WalkSpeed = Config.SPEED_Value
    elseif SpeedWasOn then
        -- Restore sekali saat dimatiin, lalu biarkan game yang atur
        hum.WalkSpeed = State.OriginalSpeed
        SpeedWasOn = false
        -- Setelah restore, JANGAN lagi touch WalkSpeed -- game/ability killer boleh ubah sesuka hati
    end
    -- Kalau SPEED_Enabled = false dan SpeedWasOn = false: tidak lakukan apa-apa
end

local NoclipWasOn = false

local function UpdateNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    
    if Config.NOCLIP_Enabled then
       
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        NoclipWasOn = true
    elseif NoclipWasOn then
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        NoclipWasOn = false
    end
    
end

local FogCache = {}

local function RemoveFog()
    
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name:lower():find("fog") or obj:IsA("Atmosphere") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                    if not FogCache[obj] then
                        FogCache[obj] = {enabled = obj:IsA("PostEffect") and obj.Enabled or true, parent = obj.Parent}
                    end
                    if obj:IsA("PostEffect") then
                        obj.Enabled = false
                    else
                        obj.Parent = nil
                    end
                end
            end
        end
    end)
    
    
    pcall(function()
        local lighting = game:GetService("Lighting")
        for _, obj in ipairs(lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj.Name:lower():find("fog") then
                if not FogCache[obj] then
                    FogCache[obj] = {enabled = obj:IsA("Atmosphere") or true, parent = obj.Parent}
                end
                if obj:IsA("Atmosphere") then
                    obj.Density = 0
                else
                    obj.Parent = nil
                end
            end
        end
        
        lighting.FogEnd = 100000
        lighting.FogStart = 0
    end)
end

local function RestoreFog()
    pcall(function()
        for obj, data in pairs(FogCache) do
            if obj and data.parent then
                if obj:IsA("PostEffect") then
                    obj.Enabled = data.enabled
                else
                    obj.Parent = data.parent
                end
            end
        end
        FogCache = {}
        
        
        local lighting = game:GetService("Lighting")
        lighting.FogEnd = 1000
    end)
end

local function UpdateNoFall()
    if not Config.SURV_NoFall then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end
end

local function SetupAntiBlind()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end
        local items = remotes:FindFirstChild("Items")
        if not items then return end
        local flashlight = items:FindFirstChild("Flashlight")
        if not flashlight then return end
        local gotBlinded = flashlight:FindFirstChild("GotBlinded")
        
        if gotBlinded and gotBlinded:IsA("RemoteEvent") then
            local oldFire = gotBlinded.FireServer
            gotBlinded.FireServer = function(self, ...)
                if Config.KILLER_AntiBlind and GetRole() == "Killer" then
                    return nil 
                end
                return oldFire(self, ...)
            end
        end
    end)
end


local NoSlowdownReady = false  -- flag: tunggu 1.5s setelah spawn baru track

local function UpdateNoSlowdown()
    if not Config.KILLER_NoSlowdown then return end
    if GetRole() ~= "Killer" then return end
    if not NoSlowdownReady then return end  -- belum siap, masih nunggu delay

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if not State.KillerBaseSpeed then
        -- Ambil speed setelah delay, harusnya sudah di-set game
        State.KillerBaseSpeed = hum.WalkSpeed
    else
        if hum.WalkSpeed > State.KillerBaseSpeed then
            State.KillerBaseSpeed = hum.WalkSpeed
        end
        if hum.WalkSpeed < State.KillerBaseSpeed * 0.8 then
            hum.WalkSpeed = State.KillerBaseSpeed
        end
    end
end


local LastDoubleTapTime = 0
local function DoubleTap()
    if not Config.KILLER_DoubleTap then return end
    if GetRole() ~= "Killer" then return end
    if tick() - LastDoubleTapTime < 0.5 then return end
    
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end
        local attacks = remotes:FindFirstChild("Attacks")
        if not attacks then return end
        local basicAttack = attacks:FindFirstChild("BasicAttack")
        if basicAttack then
            basicAttack:FireServer(false)
            task.wait(0.05)
            basicAttack:FireServer(false)
            LastDoubleTapTime = tick()
        end
    end)
end


local function InfiniteLunge()
    if not Config.KILLER_InfiniteLunge then return end
    if GetRole() ~= "Killer" then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        local lookVector = root.CFrame.LookVector
        root.Velocity = lookVector * 100 + Vector3.new(0, 10, 0)
    end
end


local function SetupNoPalletStun()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end
        
        
        local pallet = remotes:FindFirstChild("Pallet")
        if pallet then
            local jason = pallet:FindFirstChild("Jason")
            if jason then
                local stun = jason:FindFirstChild("Stun")
                local stunDrop = jason:FindFirstChild("StunDrop")
                
                if stun and stun:IsA("RemoteEvent") then
                    local mt = getrawmetatable(game)
                    if mt and setreadonly then
                        setreadonly(mt, false)
                        local oldIndex = mt.__namecall
                        mt.__namecall = newcclosure(function(self, ...)
                            if Config.KILLER_NoPalletStun and GetRole() == "Killer" then
                                if self == stun or self == stunDrop then
                                    return nil
                                end
                            end
                            return oldIndex(self, ...)
                        end)
                        setreadonly(mt, true)
                    end
                end
            end
        end
        
        
        local mechanics = remotes:FindFirstChild("Mechanics")
        if mechanics then
            local palletStun = mechanics:FindFirstChild("PalletStun")
            if palletStun and palletStun:IsA("RemoteEvent") then
                
            end
        end
    end)
end

local OriginalCameraType = nil
local ThirdPersonWasActive = false

local function UpdateThirdPerson()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local isKiller = GetRole() == "Killer"
    local shouldBeActive = Config.CAM_ThirdPerson and isKiller

    if shouldBeActive and not ThirdPersonWasActive then
        -- Aktifkan sekali saja
        OriginalCameraType = cam.CameraType
        cam.CameraType = Enum.CameraType.Custom
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.CameraOffset = Vector3.new(2, 1, 8) end
        end
        ThirdPersonWasActive = true

    elseif not shouldBeActive and ThirdPersonWasActive then
        -- Matikan sekali saja
        if OriginalCameraType then
            cam.CameraType = OriginalCameraType
            OriginalCameraType = nil
        end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
        end
        ThirdPersonWasActive = false
    end
end


local ShiftLockWasOn = false
local ShiftLockRenderConn = nil

local function UpdateShiftLock()
    local shouldOn = Config.CAM_ShiftLock

    if shouldOn and not ShiftLockWasOn then
        -- Aktifkan: pasang RenderStepped connection yang ringan
        ShiftLockWasOn = true
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = false end
        end
        if ShiftLockRenderConn then ShiftLockRenderConn:Disconnect() end
        ShiftLockRenderConn = RunService.RenderStepped:Connect(function()
            if not Config.CAM_ShiftLock then return end
            local c = LocalPlayer.Character
            if not c then return end
            local root = c:FindFirstChild("HumanoidRootPart")
            local cam  = workspace.CurrentCamera
            if not root or not cam then return end
            local flat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            if flat.Magnitude > 0.01 then
                root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit)
            end
        end)

    elseif not shouldOn and ShiftLockWasOn then
        -- Matikan: restore AutoRotate, disconnect
        ShiftLockWasOn = false
        if ShiftLockRenderConn then
            ShiftLockRenderConn:Disconnect()
            ShiftLockRenderConn = nil
        end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end
end


local OriginalFOV = nil
local function UpdateCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    if not OriginalFOV then
        OriginalFOV = cam.FieldOfView
    end
    
    if Config.CAM_FOVEnabled then
        cam.FieldOfView = Config.CAM_FOV
    elseif OriginalFOV then
        cam.FieldOfView = OriginalFOV
    end
end


local FlyConnection = nil
local FlyBodyVelocity = nil
local FlyBodyGyro = nil

local function UpdateFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    if Config.FLY_Enabled then
        hum.PlatformStand = true
        
        
        if not FlyBodyVelocity then
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyVelocity.Velocity = Vector3.zero
            FlyBodyVelocity.Parent = root
        end
        
        if not FlyBodyGyro then
            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyGyro.P = 9e4
            FlyBodyGyro.Parent = root
        end
        
        
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * Config.FLY_Speed
        end
        
        if Config.FLY_Method == "Velocity" then
            FlyBodyVelocity.Velocity = moveDir
        else 
            FlyBodyVelocity.Velocity = Vector3.zero
            if moveDir.Magnitude > 0 then
                root.CFrame = root.CFrame + moveDir * 0.05
            end
        end
        
        FlyBodyGyro.CFrame = cam.CFrame
    else
        
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
        if FlyBodyGyro then
            FlyBodyGyro:Destroy()
            FlyBodyGyro = nil
        end
        if hum then
            hum.PlatformStand = false
        end
    end
end


local InfiniteJumpConnection = nil
local function SetupInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    
    InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if not Config.JUMP_Infinite then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end


local OriginalJumpPower = nil
local function UpdateJumpPower()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if not OriginalJumpPower then
        OriginalJumpPower = hum.JumpPower
    end
    
    if Config.JUMP_Power ~= 50 then
        hum.JumpPower = Config.JUMP_Power
        hum.UseJumpPower = true
    end
end


local function FlingNearest()
    if not Config.FLING_Enabled then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    
    if closest and closest.Character then
        local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
           
            local originalPos = root.CFrame
            for i = 1, 10 do
                root.CFrame = targetRoot.CFrame
                root.Velocity = Vector3.new(Config.FLING_Strength, Config.FLING_Strength/2, Config.FLING_Strength)
                root.RotVelocity = Vector3.new(9999, 9999, 9999)
                task.wait()
            end
            root.CFrame = originalPos
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
    end
end

local function FlingAll()
    if not Config.FLING_Enabled then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    local originalPos = root.CFrame
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                for i = 1, 5 do
                    root.CFrame = targetRoot.CFrame
                    root.Velocity = Vector3.new(Config.FLING_Strength, Config.FLING_Strength/2, Config.FLING_Strength)
                    root.RotVelocity = Vector3.new(9999, 9999, 9999)
                    task.wait()
                end
            end
        end
    end
    
    root.CFrame = originalPos
    root.Velocity = Vector3.zero
    root.RotVelocity = Vector3.zero
end

local function SpearAimbot(targetPos)
    if not Config.SPEAR_Aimbot then return nil end
    if GetRole() ~= "Killer" then return nil end
    
    local root = GetCharacterRoot()
    if not root then return nil end
    
    
    local startPos = root.Position + Vector3.new(0, 2, 0) 
    local distance = (targetPos - startPos).Magnitude
    local gravity = Config.SPEAR_Gravity
    local speed = Config.SPEAR_Speed
    
  
    local time = distance / speed
    
  
    local gravityDrop = 0.5 * gravity * time * time
    local aimPos = targetPos + Vector3.new(0, gravityDrop, 0)
    
    return aimPos
end

local function UpdateSpearAim()
    if not Config.SPEAR_Aimbot then return end
    if GetRole() ~= "Killer" then return end
    
    
    local root = GetCharacterRoot()
    if not root then return end
    
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist < closestDist and Cache.Visibility[player] then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    
    if closest and closest.Character then
        local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local aimPos = SpearAimbot(targetRoot.Position)
            if aimPos then
                
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos)
                end
            end
        end
    end
end


-- GUI stub (Drawing overlays only, full UI handled by VictUI)
local GUI = { Drawings = {} }

-- Crosshair + di tengah layar (independent Heartbeat loop)
task.spawn(function()
    local lineH = Drawing.new("Line")
    lineH.Thickness = 2; lineH.Transparency = 1
    lineH.Color = Color3.fromRGB(255,255,255); lineH.Visible = false

    local lineV = Drawing.new("Line")
    lineV.Thickness = 2; lineV.Transparency = 1
    lineV.Color = Color3.fromRGB(255,255,255); lineV.Visible = false

    local dot = Drawing.new("Circle")
    dot.Thickness = 0; dot.NumSides = 12; dot.Filled = true
    dot.Radius = 2; dot.Transparency = 1
    dot.Color = Color3.fromRGB(255,255,255); dot.Visible = false

    RunService.Heartbeat:Connect(function()
        if State.Unloaded then
            lineH.Visible = false; lineV.Visible = false; dot.Visible = false
            return
        end
        local show = Config.AIM_ShowFOV
        local cam = workspace.CurrentCamera
        if show and cam then
            local cx = cam.ViewportSize.X / 2
            local cy = cam.ViewportSize.Y / 2
            local s = 10
            lineH.From = Vector2.new(cx-s, cy); lineH.To = Vector2.new(cx+s, cy); lineH.Visible = true
            lineV.From = Vector2.new(cx, cy-s); lineV.To = Vector2.new(cx, cy+s); lineV.Visible = true
            dot.Position = Vector2.new(cx, cy); dot.Visible = true
        else
            lineH.Visible = false; lineV.Visible = false; dot.Visible = false
        end
    end)
end)

-- ==================== VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

local Window = Vict:Window({
    Title = "Victoria Hub | VD",
    Footer = " ",
    Color = Color3.fromRGB(0, 170, 255),
    ["Tab Width"] = 110,
    Version = "2.0",
    Icon = "rbxassetid://96751490485303",
    Image = "96751490485303"
})

-- ==================== HELPER ====================
local function notifToggle(name, state)
    notif(name .. ": " .. (state and "ON" or "OFF"), 2,
        state and Color3.fromRGB(0, 220, 120) or Color3.fromRGB(130, 130, 145))
end

-- ==================== TAB 1: ESP ====================
local TabESP = Window:AddTab({ Name = "ESP", Icon = "eyes" })

-- Players section: toggle langsung aktif chams, no general enable
local secESPPlayers = TabESP:AddSection("Players")
secESPPlayers:AddToggle({
    Title = "Killer ESP",
    Default = Config.ESP_Killer,
    Callback = function(v)
        Config.ESP_Killer = v
        if not v then ESP.hideAll() end
        notifToggle("Killer ESP", v)
    end
})
secESPPlayers:AddSlider({
    Title = "Killer Max Distance",
    Min = 100, Max = 1000, Default = Config.ESP_MaxDist,
    Callback = function(v) Config.ESP_MaxDist = v end
})
secESPPlayers:AddToggle({
    Title = "Survivor ESP",
    Default = Config.ESP_Survivor,
    Callback = function(v)
        Config.ESP_Survivor = v
        if not v then ESP.hideAll() end
        notifToggle("Survivor ESP", v)
    end
})

local secESPObjects = TabESP:AddSection("Objects")
secESPObjects:AddToggle({
    Title = "Generator",
    Default = Config.ESP_Generator,
    Callback = function(v) Config.ESP_Generator = v end
})
secESPObjects:AddToggle({
    Title = "Gate",
    Default = Config.ESP_Gate,
    Callback = function(v) Config.ESP_Gate = v end
})
secESPObjects:AddToggle({
    Title = "Hook",
    Default = Config.ESP_Hook,
    Callback = function(v) Config.ESP_Hook = v end
})
secESPObjects:AddToggle({
    Title = "Closest Hook Highlight",
    Default = Config.ESP_ClosestHook,
    Callback = function(v) Config.ESP_ClosestHook = v end
})
secESPObjects:AddToggle({
    Title = "Pallet",
    Default = Config.ESP_Pallet,
    Callback = function(v) Config.ESP_Pallet = v end
})
secESPObjects:AddToggle({
    Title = "Window",
    Default = Config.ESP_Window,
    Callback = function(v) Config.ESP_Window = v end
})

local secRadar = TabESP:AddSection("Radar")
secRadar:AddToggle({
    Title = "Enable Radar",
    Default = Config.RADAR_Enabled,
    Callback = function(v) Config.RADAR_Enabled = v; notifToggle("Radar", v) end
})
secRadar:AddSlider({
    Title = "Radar Size",
    Min = 80, Max = 200, Default = Config.RADAR_Size,
    Callback = function(v) Config.RADAR_Size = v end
})
secRadar:AddToggle({
    Title = "Circle Shape",
    Default = Config.RADAR_Circle,
    Callback = function(v) Config.RADAR_Circle = v end
})
secRadar:AddToggle({
    Title = "Show Killer",
    Default = Config.RADAR_Killer,
    Callback = function(v) Config.RADAR_Killer = v end
})
secRadar:AddToggle({
    Title = "Show Survivor",
    Default = Config.RADAR_Survivor,
    Callback = function(v) Config.RADAR_Survivor = v end
})
secRadar:AddToggle({
    Title = "Show Generator",
    Default = Config.RADAR_Generator,
    Callback = function(v) Config.RADAR_Generator = v end
})
secRadar:AddToggle({
    Title = "Show Pallet",
    Default = Config.RADAR_Pallet,
    Callback = function(v) Config.RADAR_Pallet = v end
})

-- ==================== TAB 2: AIMBOT ====================
local TabAIM = Window:AddTab({ Name = "Aimbot", Icon = "crosshair" })

local secAimCamera = TabAIM:AddSection("Camera Aimbot")
secAimCamera:AddToggle({
    Title = "Enable Aimbot",
    Default = Config.AIM_Enabled,
    Callback = function(v) Config.AIM_Enabled = v; notifToggle("Aimbot", v) end
})
secAimCamera:AddToggle({
    Title = "Show FOV Circle",
    Default = Config.AIM_ShowFOV,
    Callback = function(v) Config.AIM_ShowFOV = v end
})
secAimCamera:AddDropdown({
    Title = "Target Role",
    Options = {"Killer", "Survivor"},
    Default = Config.AIM_TargetRole,
    Callback = function(v) Config.AIM_TargetRole = v end
})
secAimCamera:AddSlider({
    Title = "FOV Size",
    Min = 50, Max = 400, Default = Config.AIM_FOV,
    Callback = function(v) Config.AIM_FOV = v end
})
secAimCamera:AddSlider({
    Title = "Smoothness",
    Min = 1, Max = 20, Default = math.floor(Config.AIM_Smooth * 20),
    Callback = function(v) Config.AIM_Smooth = v / 20 end
})
secAimCamera:AddDropdown({
    Title = "Target Part",
    Options = {"Head", "Torso", "Root"},
    Default = Config.AIM_TargetPart,
    Callback = function(v) Config.AIM_TargetPart = v end
})
secAimCamera:AddToggle({
    Title = "Visibility Check",
    Default = Config.AIM_VisCheck,
    Callback = function(v) Config.AIM_VisCheck = v end
})
secAimCamera:AddToggle({
    Title = "Prediction",
    Default = Config.AIM_Predict,
    Callback = function(v) Config.AIM_Predict = v end
})

local secSpear = TabAIM:AddSection("Spear Aimbot (Veil)")
secSpear:AddToggle({
    Title = "Spear Aimbot",
    Default = Config.SPEAR_Aimbot,
    Callback = function(v) Config.SPEAR_Aimbot = v; notifToggle("Spear Aimbot", v) end
})
secSpear:AddSlider({
    Title = "Spear Gravity",
    Min = 10, Max = 200, Default = Config.SPEAR_Gravity,
    Callback = function(v) Config.SPEAR_Gravity = v end
})
secSpear:AddSlider({
    Title = "Spear Speed",
    Min = 50, Max = 300, Default = Config.SPEAR_Speed,
    Callback = function(v) Config.SPEAR_Speed = v end
})

-- GUN AIMBOT
local function GunSilentAim_Setup() end  -- stub, logic via aimbot

local secGun = TabAIM:AddSection("Gun Aimbot (Twist of Fate)")
secGun:AddToggle({
    Title = "Gun Aimbot (hold button = auto aim)",
    Default = Config.GUN_SilentAim,
    Callback = function(v)
        Config.GUN_SilentAim = v
        notifToggle("Gun Aimbot", v)
    end
})
secGun:AddDropdown({
    Title = "Aim Part",
    Options = {"HumanoidRootPart", "Head", "Torso"},
    Default = Config.GUN_AimPart,
    Callback = function(v) Config.GUN_AimPart = v end
})

-- ==================== TAB 3: SURVIVOR ====================
local TabSURV = Window:AddTab({ Name = "Survivor", Icon = "user" })

local secSurvival = TabSURV:AddSection("Survival")
secSurvival:AddToggle({
    Title = "Anti Fail Gen",
    Default = Config.ANTI_FailGen,
    Callback = function(v)
        Config.ANTI_FailGen = v
        -- Kalau karakter sudah ada (in match), apply sekarang
        -- Kalau di lobby, CharacterAdded akan handle saat masuk match
        local char = LocalPlayer.Character
        if v and char then
            AntiFailGen_Apply(char)
        elseif not v then
            AntiFailGen_Restore()
        end
        notifToggle("Anti Fail Gen", v)
    end
})
secSurvival:AddToggle({
    Title = "Anti Skill Check (remove QTE)",
    Default = Config.ANTI_SkillCheck,
    Callback = function(v)
        Config.ANTI_SkillCheck = v
        local char = LocalPlayer.Character
        if v and char then
            AntiScript_Apply(char)
        elseif not v then
            if SkillcheckPlayerScript and SkillcheckPlayerScript.Parent then
                pcall(function() SkillcheckPlayerScript.Enabled = true end)
            end
            SkillcheckPlayerScript = nil
        end
        notifToggle("Anti Skill Check", v)
    end
})
secSurvival:AddToggle({
    Title = "Godmode",
    Default = Config.GODMODE,
    Callback = function(v)
        Config.GODMODE = v
        if v then Godmode_Apply() else Godmode_Remove() end
        notifToggle("Godmode", v)
    end
})
secSurvival:AddToggle({
    Title = "Auto Parry",
    Default = Config.AUTO_Parry,
    Callback = function(v)
        Config.AUTO_Parry = v
        if v then AutoParry_Setup() end
        notifToggle("Auto Parry", v)
    end
})
secSurvival:AddSlider({
    Title = "Parry Distance",
    Min = 5, Max = 40, Default = Config.PARRY_Dist,
    Callback = function(v) Config.PARRY_Dist = v end
})
secSurvival:AddToggle({
    Title = "No Fall Damage",
    Default = Config.SURV_NoFall,
    Callback = function(v) Config.SURV_NoFall = v; notifToggle("No Fall Damage", v) end
})
secSurvival:AddToggle({
    Title = "Auto Wiggle",
    Default = Config.SURV_AutoWiggle,
    Callback = function(v) Config.SURV_AutoWiggle = v; notifToggle("Auto Wiggle", v) end
})

local secBeatSurv = TabSURV:AddSection("Beat Game")
secBeatSurv:AddToggle({
    Title = "Beat As Survivor",
    Default = Config.BEAT_Survivor,
    Callback = function(v) Config.BEAT_Survivor = v; notifToggle("Beat Survivor", v) end
})

-- ==================== TAB 4: KILLER ====================
local TabKILL = Window:AddTab({ Name = "Killer", Icon = "sword" })

local secCombat = TabKILL:AddSection("Combat")
secCombat:AddToggle({
    Title = "Auto Attack",
    Default = Config.AUTO_Attack,
    Callback = function(v) Config.AUTO_Attack = v; notifToggle("Auto Attack", v) end
})
secCombat:AddSlider({
    Title = "Attack Range",
    Min = 5, Max = 20, Default = Config.AUTO_AttackRange,
    Callback = function(v) Config.AUTO_AttackRange = v end
})
secCombat:AddToggle({
    Title = "Double Tap (Instant Kill)",
    Default = Config.KILLER_DoubleTap,
    Callback = function(v) Config.KILLER_DoubleTap = v; notifToggle("Double Tap", v) end
})
secCombat:AddToggle({
    Title = "Infinite Lunge",
    Default = Config.KILLER_InfiniteLunge,
    Callback = function(v) Config.KILLER_InfiniteLunge = v; notifToggle("Infinite Lunge", v) end
})
secCombat:AddToggle({
    Title = "Auto Hook",
    Default = Config.KILLER_AutoHook,
    Callback = function(v) Config.KILLER_AutoHook = v; notifToggle("Auto Hook", v) end
})

-- Hitbox digabung ke Combat section (sudah di atas)
secCombat:AddToggle({
    Title = "Hitbox Expander",
    Default = Config.HITBOX_Enabled,
    Callback = function(v) Config.HITBOX_Enabled = v; notifToggle("Hitbox", v) end
})
secCombat:AddSlider({
    Title = "Hitbox Size",
    Min = 5, Max = 30, Default = Config.HITBOX_Size,
    Callback = function(v) Config.HITBOX_Size = v end
})

local secProtection = TabKILL:AddSection("Protection")
secProtection:AddToggle({
    Title = "No Pallet Stun",
    Default = Config.KILLER_NoPalletStun,
    Callback = function(v) Config.KILLER_NoPalletStun = v; notifToggle("No Pallet Stun", v) end
})
secProtection:AddToggle({
    Title = "Anti Blind",
    Default = Config.KILLER_AntiBlind,
    Callback = function(v) Config.KILLER_AntiBlind = v; notifToggle("Anti Blind", v) end
})

local secDestruction = TabKILL:AddSection("Destruction")
secDestruction:AddToggle({
    Title = "Full Gen Break",
    Default = Config.KILLER_FullGenBreak,
    Callback = function(v) Config.KILLER_FullGenBreak = v; notifToggle("Gen Break", v) end
})
secDestruction:AddToggle({
    Title = "Destroy All Pallets",
    Default = Config.KILLER_DestroyPallets,
    Callback = function(v) Config.KILLER_DestroyPallets = v; notifToggle("Destroy Pallets", v) end
})

local secKillerCamera = TabKILL:AddSection("Camera")
secKillerCamera:AddToggle({
    Title = "Third Person",
    Default = Config.CAM_ThirdPerson,
    Callback = function(v) Config.CAM_ThirdPerson = v; notifToggle("Third Person", v) end
})
secKillerCamera:AddToggle({
    Title = "Shift Lock",
    Default = Config.CAM_ShiftLock,
    Callback = function(v) Config.CAM_ShiftLock = v; notifToggle("Shift Lock", v) end
})

local secBeatKill = TabKILL:AddSection("Beat Game")
secBeatKill:AddToggle({
    Title = "Beat As Killer",
    Default = Config.BEAT_Killer,
    Callback = function(v) Config.BEAT_Killer = v; notifToggle("Beat Killer", v) end
})

-- ==================== TAB 5: MOVEMENT ====================
local TabMOVE = Window:AddTab({ Name = "Movement", Icon = "gamepad" })

local secSpeed = TabMOVE:AddSection("Speed")
secSpeed:AddToggle({
    Title = "Speed Hack",
    Default = Config.SPEED_Enabled,
    Callback = function(v) Config.SPEED_Enabled = v; notifToggle("Speed Hack", v) end
})
secSpeed:AddSlider({
    Title = "Speed Value",
    Min = 16, Max = 150, Default = Config.SPEED_Value,
    Callback = function(v) Config.SPEED_Value = v end
})
secSpeed:AddDropdown({
    Title = "Speed Method",
    Options = {"Attribute", "TP"},
    Default = Config.SPEED_Method,
    Callback = function(v) Config.SPEED_Method = v end
})

local secFly = TabMOVE:AddSection("Flight")
secFly:AddToggle({
    Title = "Fly",
    Default = Config.FLY_Enabled,
    Callback = function(v) Config.FLY_Enabled = v; notifToggle("Fly", v) end
})
secFly:AddSlider({
    Title = "Fly Speed",
    Min = 10, Max = 200, Default = Config.FLY_Speed,
    Callback = function(v) Config.FLY_Speed = v end
})
secFly:AddDropdown({
    Title = "Fly Method",
    Options = {"CFrame", "Velocity"},
    Default = Config.FLY_Method,
    Callback = function(v) Config.FLY_Method = v end
})

local secJump = TabMOVE:AddSection("Jump")
secJump:AddSlider({
    Title = "Jump Power",
    Min = 50, Max = 200, Default = Config.JUMP_Power,
    Callback = function(v) Config.JUMP_Power = v end
})
secJump:AddToggle({
    Title = "Infinite Jump",
    Default = Config.JUMP_Infinite,
    Callback = function(v) Config.JUMP_Infinite = v; notifToggle("Infinite Jump", v) end
})

local secCollision = TabMOVE:AddSection("Collision")
secCollision:AddToggle({
    Title = "Noclip",
    Default = Config.NOCLIP_Enabled,
    Callback = function(v) Config.NOCLIP_Enabled = v; notifToggle("Noclip", v) end
})

local secTeleport = TabMOVE:AddSection("Teleport")
secTeleport:AddSlider({
    Title = "TP Height Offset",
    Min = 0, Max = 10, Default = Config.TP_Offset,
    Callback = function(v) Config.TP_Offset = v end
})
secTeleport:AddButton({
    Title = "TP to Generator",
    Callback = function() TeleportToGenerator(1) end
})
secTeleport:AddButton({
    Title = "TP to Gate",
    Callback = function() TeleportToGate() end
})
secTeleport:AddButton({
    Title = "TP to Hook",
    Callback = function() TeleportToHook() end
})

-- ==================== TAB 6: MISC ====================
local TabMISC = Window:AddTab({ Name = "Misc", Icon = "settings" })

local secVisual = TabMISC:AddSection("Visual")
secVisual:AddToggle({
    Title = "No Fog",
    Default = Config.NO_Fog,
    Callback = function(v) Config.NO_Fog = v; notifToggle("No Fog", v) end
})
secVisual:AddToggle({
    Title = "Custom FOV",
    Default = Config.CAM_FOVEnabled,
    Callback = function(v) Config.CAM_FOVEnabled = v; notifToggle("Custom FOV", v) end
})
secVisual:AddSlider({
    Title = "FOV Value",
    Min = 30, Max = 120, Default = Config.CAM_FOV,
    Callback = function(v) Config.CAM_FOV = v end
})

local secFling = TabMISC:AddSection("Fling")
secFling:AddToggle({
    Title = "Fling Enable",
    Default = Config.FLING_Enabled,
    Callback = function(v) Config.FLING_Enabled = v; notifToggle("Fling", v) end
})
secFling:AddSlider({
    Title = "Fling Strength",
    Min = 1000, Max = 50000, Default = Config.FLING_Strength,
    Callback = function(v) Config.FLING_Strength = v end
})
secFling:AddButton({
    Title = "Fling Nearest",
    Callback = function() FlingNearest() end
})
secFling:AddButton({
    Title = "Fling All",
    Callback = function() FlingAll() end
})

local secKeybinds = TabMISC:AddSection("Keybinds (Info)")
secKeybinds:AddParagraph({
    Title = "Keybind Info",
    Content = "Menu: INSERT | Panic (Unload): HOME\nSpeed: C | Fly: F | Noclip: V\nTP Gen: G | TP Gate: T | TP Hook: H\nLeave Gen: Q | Stop Gen: X"
})

local secSystem = TabMISC:AddSection("System")
secSystem:AddButton({
    Title = "Unload Script",
    Callback = function()
        notif("Unloading...", 2, Color3.fromRGB(130, 130, 145))
        task.delay(0.5, function() Unload() end)
    end
})

-- ==================== MAIN LOOP (adapted, no Drawing-GUI) ====================
local function MainLoop()
    if State.Unloaded then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local screenSize = cam.ViewportSize
    local screenCenter = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    local now = tick()

    if now - State.LastCacheUpdate >= Tuning.CacheRefreshRate then
        State.LastCacheUpdate = now
        ScanMap()
    end

    if now - State.LastVisCheck >= Tuning.ESP_VisCheckRate then
        State.LastVisCheck = now
        UpdateVisibility()
    end

    ESP.step(cam, screenSize, screenCenter)
    UpdateObjectESP(cam)
    Radar.step(cam)

    Aimbot.Update(cam, screenSize, screenCenter)
end
