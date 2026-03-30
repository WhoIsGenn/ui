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
    ESP_Enabled = true,
    ESP_Killer = false,
    ESP_Survivor = false,
    ESP_Generator = false,
    ESP_Gate = false,
    ESP_Hook = false,
    ESP_Pallet = false,
    ESP_Window = false,
    ESP_Offscreen = true,
    ESP_ClosestHook = false,
    ESP_MaxDist = 200,
    
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
    AUTO_GenMode = "Fast",
    AUTO_LeaveGen = false,
    AUTO_LeaveDist = 18,
    AUTO_Attack = false,
    AUTO_AttackRange = 12,
    HITBOX_Enabled = false,
    HITBOX_Size = 15,
    AUTO_TeleAway = false,
    AUTO_TeleAwayDist = 40,
    
    AUTO_Parry = false,
    PARRY_Mode = "With Animation",  -- "With Animation" or "No Animation"
    PARRY_Dist = 13,
    PARRY_FOV = false,
    ANTI_SkillCheck = false,  -- disable Skillcheck-gen + Skillcheck-player
    PERFECT_SkillCheck = false,
    SURV_NoFall = false,
    SURV_GodMode = false,
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
    SPEED_Value = 32,
    SPEED_Method = "Attribute",
    KEY_Speed = Enum.KeyCode.C,
    NOCLIP_Enabled = false,
    KEY_Noclip = Enum.KeyCode.V,
    FLY_Enabled = false,
    FLY_Speed = 50,
    FLY_Method = "CFrame",
    KEY_Fly = Enum.KeyCode.F,
    JUMP_Power = 50,
    JUMP_Infinite = false,
    
    NO_Fog = false,
    FULLBRIGHT = false,
    CAM_FOVEnabled = false,
    CAM_FOV = 90,
    CAM_ThirdPerson = false,
    FLING_Enabled = false,
    FLING_Strength = 10000,
    
    BEAT_Survivor = false,
    BEAT_Killer = false,
    
    TP_Offset = 3,
    
    MENU_Open = true,
    MENU_Tab = 1,
    
    KEY_Menu = Enum.KeyCode.Insert,
    KEY_Panic = Enum.KeyCode.Home,
    KEY_LeaveGen = Enum.KeyCode.Q,
    KEY_StopGen = Enum.KeyCode.X,
    KEY_TP_Gen = Enum.KeyCode.G,
    KEY_TP_Gate = Enum.KeyCode.T,
    KEY_TP_Hook = Enum.KeyCode.H,
    
    AIM_Enabled = false,
    AIM_AutoMode = false,
    AIM_TargetMode = "Auto", -- Auto, Killer, Survivor, Closest
    AIM_FOV = 120,
    AIM_Smooth = 0.3,
    AIM_TargetPart = "Left Arm",
    AIM_VisCheck = true,
    AIM_ShowFOV = false,
    AIM_Crosshair = false,
    AIM_Predict = true,
    
    
    SPEAR_Aimbot = false,
    SPEAR_Gravity = 50,
    SPEAR_Speed = 100
}

local Tuning = {
    ESP_RefreshRate = 0.05,
    ESP_VisCheckRate = 0.15,
    Gen_RefreshRate = 0.2,
    CacheRefreshRate = 1.0,
    
    
    Offscreen_Edge = 50,
    Offscreen_Size = 12,
    
    Skel_Thickness = 1,
    
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

-- ================================================================
-- STATE (wajib ada sebelum semua fungsi lain)
-- ================================================================

local State = {
    Unloaded        = false,
    OriginalSpeed   = 16,
    LastTeleAway    = 0,
    LastCacheUpdate = 0,
    LastVisCheck    = 0,
    LastESPUpdate   = 0,
    LastFogState    = nil,
    KillerTarget    = nil,
    AimHolding      = false,
    AimTarget       = nil,
}

local Cache = {
    Generators  = {},
    Gates       = {},
    Hooks       = {},
    Pallets     = {},
    Windows     = {},
    ClosestHook = nil,
    Visibility  = {},
}

local Connections = {}

-- ================================================================
-- ESP MODULE
-- ================================================================
local ESP = {
    cache = {},
    objectCache = {},
}

function ESP.hide(data)
    if not data then return end
    for _, d in pairs(data) do
        if type(d) == "table" then
            for _, v in pairs(d) do pcall(function() v.Visible = false end) end
        else
            pcall(function() d.Visible = false end)
        end
    end
end

function ESP.hideAll()
    for _, data in pairs(ESP.cache) do ESP.hide(data) end
end

function ESP.destroy(data)
    if not data then return end
    for _, d in pairs(data) do
        if type(d) == "table" then
            for _, v in pairs(d) do pcall(function() SafeRemove(v) end) end
        else
            pcall(function() SafeRemove(d) end)
        end
    end
end

function ESP.destroyObject(data)
    ESP.destroy(data)
end

function ESP.step(cam, screenSize, screenCenter)
    if not Config.ESP_Enabled then ESP.hideAll(); return end
    pcall(ESPUpdatePlayers)
end

-- ================================================================
-- RADAR MODULE
-- ================================================================
local Radar = {
    bg           = SafeDrawing("Square"),
    circleBg     = SafeDrawing("Circle"),
    border       = SafeDrawing("Square"),
    circleBorder = SafeDrawing("Circle"),
    cross1       = SafeDrawing("Line"),
    cross2       = SafeDrawing("Line"),
    center       = SafeDrawing("Circle"),
    dots         = {},
    objectDots   = {},
    palletSquares= {},
}

function Radar.step(cam)
    if not Config.RADAR_Enabled then
        if Radar.bg then Radar.bg.Visible = false end
        if Radar.circleBg then Radar.circleBg.Visible = false end
        if Radar.border then Radar.border.Visible = false end
        if Radar.circleBorder then Radar.circleBorder.Visible = false end
        if Radar.cross1 then Radar.cross1.Visible = false end
        if Radar.cross2 then Radar.cross2.Visible = false end
        if Radar.center then Radar.center.Visible = false end
        for _, d in pairs(Radar.dots) do if d then d.Visible = false end end
        return
    end
    -- Radar rendering sederhana (opsional dikembangkan)
end

-- ================================================================
-- AIMBOT MODULE
-- ================================================================
local Aimbot = {}

function Aimbot.Update(cam, screenSize, screenCenter)
    if not Config.AIM_Enabled then
        State.AimTarget = nil
        return
    end
    -- Aimbot logic placeholder
    pcall(function()
        local bestTarget, bestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            if not char then continue end
            local part = char:FindFirstChild(Config.AIM_TargetPart) or char:FindFirstChild("HumanoidRootPart")
            if not part then continue end
            local screenPos, onScreen = cam:WorldToScreenPoint(part.Position)
            if not onScreen then continue end
            local sv = Vector2.new(screenPos.X, screenPos.Y)
            local dist = (sv - screenCenter).Magnitude
            if dist < Config.AIM_FOV / 2 and dist < bestDist then
                bestDist = dist
                bestTarget = {player = player, part = part}
            end
        end
        State.AimTarget = bestTarget
        if bestTarget and Config.AIM_AutoMode then
            local screenPos = cam:WorldToScreenPoint(bestTarget.part.Position)
            local targetV2 = Vector2.new(screenPos.X, screenPos.Y)
            local current = screenCenter
            local smooth = Config.AIM_Smooth
            -- Mouse move tidak bisa di Roblox tanpa executor support
        end
    end)
end

-- ================================================================
-- UTILITY FUNCTIONS (wajib ada sebelum fungsi lain)
-- ================================================================

local function GetCharacterRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetRole()
    -- Cek via Team
    local team = LocalPlayer.Team
    if team then
        local name = team.Name:lower()
        if name:find("killer") then return "Killer" end
        if name:find("survivor") then return "Survivor" end
        if name:find("spectator") then return "Spectator" end
    end
    -- Cek via Character Attribute
    local char = LocalPlayer.Character
    if char then
        local attr = char:GetAttribute("Role") or char:GetAttribute("Team")
        if attr then return attr end
    end
    -- Cek via leaderstats atau PlayerData di ReplicatedStorage
    local pd = ReplicatedStorage:FindFirstChild("PlayerData")
    if pd then
        local myData = pd:FindFirstChild(LocalPlayer.Name)
        if myData then
            local roleVal = myData:FindFirstChild("Role") or myData:FindFirstChild("Team")
            if roleVal then return roleVal.Value end
        end
    end
    return "Spectator"
end

local function IsKiller(player)
    if not player then return false end
    local team = player.Team
    if team then
        return team.Name:lower():find("killer") ~= nil
    end
    -- Cek via character attribute
    local char = player.Character
    if char then
        local attr = char:GetAttribute("Role") or char:GetAttribute("Team")
        if attr then return attr == "Killer" end
    end
    return false
end

local function IsVisible(character)
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    local myRoot = GetCharacterRoot()
    if not root or not myRoot then return false end
    local cam = Workspace.CurrentCamera
    if not cam then return false end
    local ray = Ray.new(myRoot.Position, (root.Position - myRoot.Position).Unit * 500)
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    if not hit then return true end
    return hit:IsDescendantOf(character)
end

-- ESP via Highlight (ringan, tidak pakai Drawing)
local ESPColors = {
    Killer   = Color3.fromRGB(255, 93, 108),
    Survivor = Color3.fromRGB(64, 224, 255),
    Generator = Color3.fromRGB(150, 0, 200),
    Gate     = Color3.fromRGB(255, 255, 255),
    Pallet   = Color3.fromRGB(74, 255, 181),
    Window   = Color3.fromRGB(74, 255, 181),
    Hook     = Color3.fromRGB(132, 255, 169),
}

local function ApplyHighlight(obj, color)
    if not obj or not obj.Parent then return end
    local h = obj:FindFirstChild("_VDHighlight")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "_VDHighlight"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Adornee = obj
        h.Parent = obj
    end
    h.FillColor = color
    h.OutlineColor = color
end

local function RemoveHighlight(obj)
    if not obj then return end
    local h = obj:FindFirstChild("_VDHighlight")
    if h then h:Destroy() end
end

local ESPGenerators = {}
local ESPLastRefresh = 0

local function ESPRefreshMap()
    ESPGenerators = {}
    local map = Workspace:FindFirstChild("Map")
    if not map then return end
    for _, obj in ipairs(map:GetDescendants()) do
        local n = obj.Name
        if n == "Generator" and Config.ESP_Generator then
            ApplyHighlight(obj, ESPColors.Generator)
            table.insert(ESPGenerators, obj)
        elseif n == "Hook" and Config.ESP_Hook then
            ApplyHighlight(obj, ESPColors.Hook)
        elseif (n == "Pallet" or n == "Palletwrong") and Config.ESP_Pallet then
            ApplyHighlight(obj, ESPColors.Pallet)
        elseif n == "Gate" and Config.ESP_Gate then
            ApplyHighlight(obj, ESPColors.Gate)
        end
    end
    -- Window scan
    if Config.ESP_Window then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "Window" then ApplyHighlight(obj, ESPColors.Window) end
        end
    end
end

local function ESPUpdatePlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local isKiller = IsKiller(player)
        if isKiller and Config.ESP_Killer then
            ApplyHighlight(char, ESPColors.Killer)
        elseif not isKiller and Config.ESP_Survivor then
            ApplyHighlight(char, ESPColors.Survivor)
        elseif not isKiller and not Config.ESP_Survivor then
            RemoveHighlight(char)
        elseif isKiller and not Config.ESP_Killer then
            RemoveHighlight(char)
        end
    end
end

local function ESPClearAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then RemoveHighlight(player.Character) end
    end
    local map = Workspace:FindFirstChild("Map")
    if map then
        for _, obj in ipairs(map:GetDescendants()) do
            RemoveHighlight(obj)
        end
    end
end

-- Legacy cache untuk ScanMap (AutoGen, AutoHook, dll masih butuh ini)
local Cache = {
    Generators = {}, Gates = {}, Hooks = {}, Pallets = {}, Windows = {},
    Visibility = {}, ClosestHook = nil,
}

local function ScanMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then 
        Cache.Generators = {}
        Cache.Gates = {}
        Cache.Hooks = {}
        Cache.Pallets = {}
        Cache.Windows = {}
        return 
    end
    
    local newGenerators = {}
    local newGates = {}
    local newHooks = {}
    local newPallets = {}
    local newWindows = {}
    
    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                if obj.Name == "Generator" then
                    table.insert(newGenerators, {model = obj, part = part})
                elseif obj.Name == "Gate" then
                    table.insert(newGates, {model = obj, part = part})
                elseif obj.Name == "Hook" then
                    table.insert(newHooks, {model = obj, part = part})
                elseif obj.Name == "Palletwrong" or obj.Name:lower():find("pallet") then
                    table.insert(newPallets, {model = obj, part = part})
                elseif obj.Name == "Window" then
                    table.insert(newWindows, {model = obj, part = part})
                end
            end
        end
    end
    
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
    -- ESP sudah dihandle via Highlight, tidak perlu drawing
end


local function StopAutoGen()
    Config.AUTO_Generator = false
    
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        
        if root then
            local map = Workspace:FindFirstChild("Map")
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Generator" then
                        local genPart = obj:FindFirstChildWhichIsA("BasePart")
                        if genPart then
                            local dist = (genPart.Position - root.Position).Magnitude
                            if dist < 25 then
                                local dir = (root.Position - genPart.Position).Unit
                                if dir.Magnitude ~= dir.Magnitude then dir = Vector3.new(1, 0, 0) end
                                root.CFrame = CFrame.new(root.Position + dir * 20 + Vector3.new(0, 3, 0))
                                break
                            end
                        end
                    end
                end
            end
        end
        
        
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid.WalkSpeed = State.OriginalSpeed or 16
            humanoid.JumpPower = 50
        end
        
       
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
        end
        
       
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        
        
        if root then
            root.Velocity = Vector3.new(0, 30, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function LeaveGenerator()
    local root = GetCharacterRoot()
    if not root then return false end
    
    local nearestGen, nearestDist = nil, math.huge
    for _, gen in ipairs(Cache.Generators) do
        local dist = GetDistance(gen.part.Position)
        if dist < nearestDist then
            nearestDist = dist
            nearestGen = gen
        end
    end
    
    if not nearestGen or nearestDist > Config.AUTO_LeaveDist then return false end
    
    local direction = (root.Position - nearestGen.part.Position).Unit
    local escapePos = root.Position + direction * (Config.AUTO_LeaveDist + 10)
    
    if true then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    root.CFrame = CFrame.new(escapePos + Vector3.new(0, Config.TP_Offset, 0))
    
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


local OriginalLighting = {}

local function Fullbright_On()
    local Lighting = game:GetService("Lighting")
    OriginalLighting.Ambient        = Lighting.Ambient
    OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    OriginalLighting.Brightness     = Lighting.Brightness
    OriginalLighting.ShadowSoftness = Lighting.ShadowSoftness
    OriginalLighting.GlobalShadows  = Lighting.GlobalShadows
    Lighting.Ambient        = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness     = 2
    Lighting.ShadowSoftness = 0
    Lighting.GlobalShadows  = false
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or
           v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or
           v:IsA("BloomEffect") then
            pcall(function() v.Enabled = false end)
        end
    end
end

local function Fullbright_Off()
    local Lighting = game:GetService("Lighting")
    if OriginalLighting.Ambient then
        Lighting.Ambient        = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness     = OriginalLighting.Brightness
        Lighting.ShadowSoftness = OriginalLighting.ShadowSoftness
        Lighting.GlobalShadows  = OriginalLighting.GlobalShadows
    end
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or
           v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or
           v:IsA("BloomEffect") then
            pcall(function() v.Enabled = true end)
        end
    end
end

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
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    if pg then
                        for _, gui in ipairs(pg:GetChildren()) do
                            local controls = gui:FindFirstChild("Controls")
                            if controls then
                                local btn = controls:FindFirstChild("attack")
                                if btn then
                                    pcall(function() firesignal(btn.MouseButton1Down) end)
                                    task.delay(0.05, function()
                                        pcall(function() firesignal(btn.MouseButton1Up) end)
                                    end)
                                    break
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end


-- ================================================================
-- AUTO PARRY SYSTEM
-- Dua mode: With Animation (firesignal GUI button) / No Animation (FireServer)
-- Detection: CheckInterractable attribute + proximity + lunge velocity
-- ================================================================
local ParryRemote          = nil
local ParrySlowRemote      = nil
local ParryConn            = nil
local ParryOnCooldown      = false
local ParryGuiBtn          = nil
local KillerAttackDetected = false
local KillerHitConns       = {}
local KillerLastPos        = {}
local LastHealth           = 100

local AttackAnimIDs = {
    ["110355011987939"] = true, -- jason:lungehold
    ["139369275981139"] = true, -- jason:attack
    ["105374834496520"] = true, -- ayam:lungehold
    ["106871536134254"] = true, -- ayam:attackalex
    ["109402730355822"] = true, -- ayam:attackalexdone
    ["111920872708571"] = true, -- ayam:attack
    ["113255068724446"] = true, -- hidden:lungehold
    ["115244153053858"] = true, -- ayam:lungeholdcobra
    ["117042998468241"] = true, -- myers:lungehold
    ["117070354890871"] = true, -- ayam:lungeholdalex
    ["118907603246885"] = true, -- abys:lungehold
    ["122812055447896"] = true, -- veil:lungehold
    ["129784271201071"] = true, -- jeff:lungehold
    ["129918027564423"] = true, -- myers:stage3lungehold
    ["130593238885843"] = true, -- ayam:attackcobra
    ["132817836308238"] = true, -- jeff:attack
    ["133963973694098"] = true, -- myers:attack
    ["138720291317243"] = true, -- ayam:attacktony+lungeholdtony
    ["74968262036854"] = true, -- hidden:attack
    ["77081789642514"] = true, -- abys+veil:kick
    ["78432063483146"] = true, -- abys:attack
    ["78935059863801"] = true, -- veil:attack
    ["80411309607666"] = true, -- abys+veil:slash
    ["82666958311998"] = true, -- jeff+hidden:attackfr
    ["95934119190708"] = true, -- myers:stage3attack
}
local NonAttackAnimIDs = {
    ["101784373049485"] = true, -- veil:spearlungevm
    ["102182386301796"] = true, -- jeff:frenzyvaultvm
    ["104239995665623"] = true, -- veil:parriedvm
    ["109066149291691"] = true, -- veil:knifeequipvm
    ["110953720370369"] = true, -- veil:carryvm
    ["111427918159250"] = true, -- veil:attackvm
    ["113499071528107"] = true, -- jeff:lungeholdvm
    ["117224999672195"] = true, -- jeff:parriedvm
    ["118699522268698"] = true, -- veil:wallhitstunvm
    ["122986861455212"] = true, -- veil:spearlungeopvm
    ["123782306962803"] = true, -- veil:lungeholdvm
    ["124191224140066"] = true, -- veil:spearthrow1vm
    ["126100203042329"] = true, -- jeff:carryvm
    ["128387952281975"] = true, -- jeff:frenzyattackvm
    ["131476715474323"] = true, -- jeff:stunnedvm
    ["136859656743697"] = true, -- veil:spearthrow2vm
    ["137688077908355"] = true, -- veil:spearlunge2op
    ["137846825408335"] = true, -- veil:takeoutspear2
    ["138045669415653"] = true, -- veil:spearlunge1op
    ["138125499040825"] = true, -- jeff:attackvm
    ["139198068127517"] = true, -- veil:spearequipvm
    ["139610361987372"] = true, -- veil:stunnedvm
    ["139928639611415"] = true, -- veil:idlespearon2
    ["70746483345907"] = true, -- jeff:frenzywipevm
    ["75258958842388"] = true, -- veil:takeoutspear1
    ["76294518257930"] = true, -- jeff:breakvm
    ["79376988328260"] = true, -- jeff:frenzyendvm
    ["80105342981313"] = true, -- veil:vaultvm
    ["84093948968516"] = true, -- veil:spearlunge2
    ["84440437648153"] = true, -- myers:stage3idle
    ["86266790353635"] = true, -- veil:spearthrow2
    ["89642871504538"] = true, -- jeff:vaultvm
    ["90249435310475"] = true, -- veil:breakvm
    ["90374658251379"] = true, -- jeff:wallhitvm
    ["91224543667492"] = true, -- jeff:wipevm
    ["92098503722633"] = true, -- veil:spearlunge1
    ["93136435416899"] = true, -- veil:spearthrow1
    ["94067810090105"] = true, -- veil:hitvm
    ["96744338559260"] = true, -- veil:idlespearon1
}

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
    pcall(function() ParryRemote = cloneref(raw) end)
    if not ParryRemote then ParryRemote = raw end
    if not ParrySlowRemote then
        local mech = r:FindFirstChild("Mechanics")
        if mech then
            local slow = mech:FindFirstChild("Slow")
            if slow and slow:IsA("BindableEvent") then ParrySlowRemote = slow end
        end
    end
    return ParryRemote
end

local function AutoParry_FindBtn()
    if ParryGuiBtn and ParryGuiBtn.Parent then return ParryGuiBtn end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, gui in ipairs(pg:GetChildren()) do
        local function findControls(parent, depth)
            if depth > 4 then return nil end
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name == "Controls" then return child end
                local found = findControls(child, depth + 1)
                if found then return found end
            end
            return nil
        end
        local controls = findControls(gui, 0)
        if controls then
            for _, btnName in ipairs({"Gui-mob", "parry", "Parry", "action", "Action"}) do
                local btn = controls:FindFirstChild(btnName)
                if btn then ParryGuiBtn = btn; return btn end
            end
        end
    end
    return nil
end

local function AutoParry_FireNoAnim()
    local remote = AutoParry_GetRemote()
    if not remote then return false end
    pcall(function() remote:FireServer() end)
    return true
end

local function AutoParry_FireWithAnim()
    local btn = AutoParry_FindBtn()
    if not btn then return false end
    pcall(function() firesignal(btn.MouseButton1Down) end)
    return true
end

local LastParryFireTime = 0

local function AutoParry_TryFire()
    if not Config.AUTO_Parry then return end
    if ParryOnCooldown then return end
    local team = LocalPlayer.Team
    if not team or team.Name ~= "Survivors" then return end
    -- Debounce: tidak fire lebih dari sekali per 0.3s
    local now = tick()
    if now - LastParryFireTime < 0.3 then return end
    LastParryFireTime = now

    local fired = false
    if Config.PARRY_Mode == "With Animation" then
        fired = AutoParry_FireWithAnim()
    else
        fired = AutoParry_FireNoAnim()
    end

    if fired then
        KillerAttackDetected = false
        ParryOnCooldown = true
        task.delay(2, function()
            ParryOnCooldown = false
            ParryGuiBtn = nil
        end)
    end
end

local ParryNamecallConn = nil  

local function AutoParry_HookKillerChar(char, p)
    if not char then return end

    task.spawn(function()
        if not char or not char.Parent then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then
            local w = 0
            repeat task.wait(0.1); w = w + 0.1; hum = char:FindFirstChildOfClass("Humanoid")
            until hum or w >= 2
        end
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            local w = 0
            repeat task.wait(0.1); w = w + 0.1; animator = hum:FindFirstChildOfClass("Animator")
            until animator or w >= 2
        end
        if not animator then return end

        -- Method 1: AnimationPlayed event
        local conn1 = animator.AnimationPlayed:Connect(function(track)
            if not Config.AUTO_Parry then return end
            if not IsKiller(p) then return end
            local id = track.Animation.AnimationId
            local numId = id:match("%d+$") or id:match("id=(%d+)") or ""
            if NonAttackAnimIDs[numId] then return end
            local isConfirmed = AttackAnimIDs[numId]
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local kr = char:FindFirstChild("HumanoidRootPart")
            if myRoot and kr then
                local dist = (kr.Position - myRoot.Position).Magnitude
                local threshold = isConfirmed and Config.PARRY_Dist or 5
                if dist <= threshold then
                    if isConfirmed then
                        if dist <= 5 then
                            AutoParry_FireNoAnim()
                        else
                            AutoParry_TryFire()
                        end
                    else
                        KillerAttackDetected = true
                        task.delay(0.6, function() KillerAttackDetected = false end)
                    end
                end
            end
        end)
        table.insert(KillerHitConns, conn1)

        -- Method 2: Heartbeat GetPlayingAnimationTracks - lebih responsif dari AnimationPlayed
        -- Detect di frame yang sama saat anim mulai, bukan nunggu event
        local lastFiredTrack = ""
        local conn2 = RunService.Heartbeat:Connect(function()
            if not Config.AUTO_Parry then return end
            if ParryOnCooldown then return end
            if not IsKiller(p) then return end
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local kr = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not kr then return end
            local dist = (kr.Position - myRoot.Position).Magnitude
            if dist > Config.PARRY_Dist then return end
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if track.IsPlaying then
                    local numId = track.Animation.AnimationId:match("%d+$") or ""
                    if AttackAnimIDs[numId] and numId ~= lastFiredTrack then
                        lastFiredTrack = numId
                        task.delay(0.5, function() lastFiredTrack = "" end)
                        if dist <= 5 then
                            AutoParry_FireNoAnim()
                        else
                            AutoParry_TryFire()
                        end
                        return
                    end
                end
            end
        end)
        table.insert(KillerHitConns, conn2)
    end)
end

local function AutoParry_HookAttackRemote()
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}

    -- Hook semua killer yang ada
    local function watchPlayer(p)
        if p == LocalPlayer then return end
        local function hookChar(char)
            if not char then return end
            AutoParry_HookKillerChar(char, p)
        end
        local c1 = p.CharacterAdded:Connect(hookChar)
        table.insert(KillerHitConns, c1)
        if p.Character then hookChar(p.Character) end
    end
    for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
    local c2 = Players.PlayerAdded:Connect(watchPlayer)
    table.insert(KillerHitConns, c2)

end

local function AutoParry_Setup()
    ParryRemote          = nil
    ParrySlowRemote      = nil
    ParryOnCooldown      = false
    KillerAttackDetected = false
    LastHealth           = 100
    KillerLastPos        = {}
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}
    if ParryConn then pcall(function() ParryConn:Disconnect() end) end
    AutoParry_HookAttackRemote()
end

local function AutoParry_Cleanup()
    ParryRemote = nil
    if ParryConn then pcall(function() ParryConn:Disconnect() end); ParryConn = nil end
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}
    KillerAttackDetected = false
end

local function AutoParry() end  -- dummy, logic di Heartbeat via AutoParry_Setup

local VirtualInputManager = game:GetService("VirtualInputManager")

local AntiScriptDescConn = nil
local AntiScriptGenScr   = nil
local AntiScriptPlrScr   = nil

local function AntiScript_DisableOne(scr)
    if not scr then return end
    if not Config.ANTI_SkillCheck then return end
   
    if scr.Name == "Skillcheck-gen" then
        pcall(function() scr.Disabled = true end)
        AntiScriptGenScr = scr
    end
    if scr.Name == "Skillcheck-player" then
        pcall(function() scr.Disabled = true end)
        AntiScriptPlrScr = scr
    end
end

local function AntiScript_Apply(char)
    if not char then return end
    if GetRole() ~= "Survivor" then return end
    if not Config.ANTI_SkillCheck then return end
    if AntiScriptDescConn then
        pcall(function() AntiScriptDescConn:Disconnect() end)
        AntiScriptDescConn = nil
    end
    for _, scr in ipairs(char:GetDescendants()) do
        AntiScript_DisableOne(scr)
    end
    AntiScriptDescConn = char.DescendantAdded:Connect(function(desc)
        if GetRole() ~= "Survivor" then return end
        AntiScript_DisableOne(desc)
    end)
end

local function AntiScript_Restore()
    if AntiScriptDescConn then
        pcall(function() AntiScriptDescConn:Disconnect() end)
        AntiScriptDescConn = nil
    end
    if AntiScriptGenScr and AntiScriptGenScr.Parent then
        pcall(function() AntiScriptGenScr.Disabled = false end)
    end
    if AntiScriptPlrScr and AntiScriptPlrScr.Parent then
        pcall(function() AntiScriptPlrScr.Disabled = false end)
    end
    AntiScriptGenScr = nil
    AntiScriptPlrScr = nil
end

--  Perfect Skill Check 
local SKILLCHECK_DEBUG = false  -- set true untuk debug

-- Fire skill check via semua method
local function SkillCheck_Fire()
    -- Method 1: CheckInterractable attribute
    pcall(function()
        local checkObj = LocalPlayer:FindFirstChild("CheckInterractable")
        if checkObj then
            checkObj:SetAttribute("action", true)
            task.defer(function() pcall(function() checkObj:SetAttribute("action", false) end) end)
        end
    end)
    -- Method 2: SendTouchEvent (mobile tap)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, gui in ipairs(pg:GetChildren()) do
            local controls = gui:FindFirstChild("Controls", true)
            if controls then
                local btn = controls:FindFirstChild("action", true) or controls:FindFirstChild("Action", true)
                if btn then
                    local pos = btn.AbsolutePosition + btn.AbsoluteSize * 0.5
                    pcall(function() vim:SendTouchEvent(pos.X, pos.Y, true) end)
                    task.defer(function() pcall(function() vim:SendTouchEvent(pos.X, pos.Y, false) end) end)
                    return
                end
            end
        end
    end)
    -- Method 3: firesignal fallback
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, gui in ipairs(pg:GetChildren()) do
            local controls = gui:FindFirstChild("Controls", true)
            if controls then
                local btn = controls:FindFirstChild("action", true) or controls:FindFirstChild("Action", true)
                if btn then
                    pcall(function() firesignal(btn.MouseButton1Down) end)
                    break
                end
            end
        end
    end)
end

local PerfectSCConns        = {}
local PerfectSCActive       = false
local PerfectSCGuiWatchConn = nil

local function PerfectSC_ConnectGui()
    -- Cleanup koneksi lama
    for _, c in ipairs(PerfectSCConns) do pcall(function() c:Disconnect() end) end
    PerfectSCConns = {}

    task.spawn(function()
        pcall(function()
            if not PerfectSCActive then return end

            -- Tunggu PlayerGui
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if not PlayerGui then
                PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
            end
            if not PlayerGui or not PerfectSCActive then return end

            -- Poll SkillCheckPromptGui sampai muncul (interval 0.1s lebih cepat)
            local CheckGui = PlayerGui:FindFirstChild("SkillCheckPromptGui")
            local waited   = 0
            while not CheckGui and waited < 30 and PerfectSCActive do
                task.wait(0.1); waited = waited + 0.1
                CheckGui = PlayerGui:FindFirstChild("SkillCheckPromptGui")
            end
            if not CheckGui or not PerfectSCActive then return end

            -- Tunggu Check frame
            local Check = CheckGui:FindFirstChild("Check")
            if not Check then Check = CheckGui:WaitForChild("Check", 10) end
            if not Check or not PerfectSCActive then
                if SKILLCHECK_DEBUG then
                    print("[SC] Check frame not found. Children:")
                    for _, c in ipairs(CheckGui:GetChildren()) do print("  " .. c.Name) end
                end
                return
            end

            local Line = Check:FindFirstChild("Line") or Check:WaitForChild("Line", 5)
            local Goal = Check:FindFirstChild("Goal") or Check:WaitForChild("Goal", 5)
            if not Line or not Goal then
                if SKILLCHECK_DEBUG then
                    print("[SC] Line/Goal not found. Check children:")
                    for _, c in ipairs(Check:GetChildren()) do print("  " .. c.Name) end
                end
                return
            end

            if SKILLCHECK_DEBUG then print("[SC] Connected! Check.Visible=" .. tostring(Check.Visible)) end

            -- Kalau frame sudah visible sekarang, langsung start heartbeat
            local hbConn = nil

            local function startHB()
                if hbConn then hbConn:Disconnect(); hbConn = nil end
                hbConn = RunService.Heartbeat:Connect(function()
                    if not Check.Visible or not PerfectSCActive then
                        if hbConn then hbConn:Disconnect(); hbConn = nil end
                        return
                    end
                    local lr = Line.Rotation % 360
                    local gr = Goal.Rotation % 360
                    local gs = (gr + 104) % 360
                    local ge = (gr + 114) % 360
                    local inGoal = (gs > ge) and (lr >= gs or lr <= ge) or (lr >= gs and lr <= ge)
                    if inGoal then
                        SkillCheck_Fire()
                        if hbConn then hbConn:Disconnect(); hbConn = nil end
                    end
                end)
                table.insert(PerfectSCConns, hbConn)
            end

            -- Start langsung kalau sudah visible
            if Check.Visible then startHB() end

            -- Listen visibility change
            local visConn = Check:GetPropertyChangedSignal("Visible"):Connect(function()
                if not PerfectSCActive then return end
                if Check.Visible then
                    startHB()
                else
                    if hbConn then hbConn:Disconnect(); hbConn = nil end
                end
            end)
            table.insert(PerfectSCConns, visConn)
        end)
    end)
end

local function PerfectSC_Setup()
    for _, c in ipairs(PerfectSCConns) do pcall(function() c:Disconnect() end) end
    PerfectSCConns = {}
    if PerfectSCGuiWatchConn then pcall(function() PerfectSCGuiWatchConn:Disconnect() end) end
    PerfectSCActive = true
    PerfectSC_ConnectGui()
    -- Watch top-level PlayerGui: kalau SkillCheckPromptGui di-recreate, reconnect
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        PerfectSCGuiWatchConn = PlayerGui.ChildAdded:Connect(function(child)
            if not PerfectSCActive then return end
            if child.Name == "SkillCheckPromptGui" then
                task.wait(0.3)
                PerfectSC_ConnectGui()
            end
        end)
    end
end

local function PerfectSC_Stop()
    PerfectSCActive = false
    for _, c in ipairs(PerfectSCConns) do pcall(function() c:Disconnect() end) end
    PerfectSCConns = {}
    if PerfectSCGuiWatchConn then pcall(function() PerfectSCGuiWatchConn:Disconnect() end); PerfectSCGuiWatchConn = nil end
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
    local role = GetRole()
    -- Jangan pernah touch WalkSpeed di Spectator
    if role == "Spectator" then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if Config.SPEED_Enabled then
        -- Simpan original sekali saat pertama aktif
        if not SpeedWasOn then
            State.OriginalSpeed = hum.WalkSpeed
            SpeedWasOn = true
        end
        hum.WalkSpeed = Config.SPEED_Value
    elseif SpeedWasOn then
        -- Restore sekali, lalu biarkan game yang atur
        hum.WalkSpeed = State.OriginalSpeed
        SpeedWasOn = false
    end
    -- Kalau SPEED_Enabled=false dan SpeedWasOn=false: TIDAK sentuh WalkSpeed sama sekali
    -- Game killer bebas atur speed via attribute
end

local NoclipWasOn = false

local function UpdateNoclip()
    if GetRole() == "Spectator" then return end
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
        local lighting = game:GetService("Lighting")
        -- Simpan original
        FogCache.FogEnd   = lighting.FogEnd
        FogCache.FogStart = lighting.FogStart
        -- Set fog ke max agar tidak kelihatan
        lighting.FogEnd   = 100000
        lighting.FogStart = 0
        -- Disable Atmosphere
        for _, obj in ipairs(lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then
                FogCache.AtmDensity = obj.Density
                obj.Density = 0
            end
        end
    end)
end

local function RestoreFog()
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.FogEnd   = FogCache.FogEnd   or 1000
        lighting.FogStart = FogCache.FogStart or 0
        for _, obj in ipairs(lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then
                obj.Density = FogCache.AtmDensity or 0.3
            end
        end
        FogCache = {}
    end)
end

local GodModeConn = nil
local GodModeConn2 = nil

local function GodMode_Start()
    if GodModeConn then return end
    task.spawn(function()
        -- Tunggu karakter dan humanoid siap
        local char = LocalPlayer.Character
        if not char then
            LocalPlayer.CharacterAdded:Wait()
            char = LocalPlayer.Character
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if not Config.SURV_GodMode then return end

        -- Method 1: Humanoid MaxHealth = huge, restore health tiap berubah
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end)
        GodModeConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not Config.SURV_GodMode then return end
            if hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
        end)

        -- Method 2: IntValue di workspace sebagai backup
        local plrFolder = workspace:FindFirstChild(LocalPlayer.Name)
        local healthVal = plrFolder and plrFolder:FindFirstChild("Health")
        if healthVal and healthVal:IsA("IntValue") then
            local waited = 0
            while healthVal.Value <= 0 and waited < 5 do
                task.wait(0.3); waited = waited + 0.3
            end
            local maxHp = math.max(healthVal.Value, 1)
            GodModeConn2 = healthVal:GetPropertyChangedSignal("Value"):Connect(function()
                if not Config.SURV_GodMode then return end
                if healthVal.Value < maxHp then
                    pcall(function() healthVal.Value = maxHp end)
                end
            end)
        end
    end)
end

local function GodMode_Stop()
    if GodModeConn then
        pcall(function() GodModeConn:Disconnect() end)
        GodModeConn = nil
    end
    if GodModeConn2 then
        pcall(function() GodModeConn2:Disconnect() end)
        GodModeConn2 = nil
    end
    -- Restore MaxHealth ke normal
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum.MaxHealth = 100
            hum.Health = hum.Health < 100 and hum.Health or 100
        end)
    end
end

local function UpdateNoFall()
    if not Config.SURV_NoFall then return end
    if GetRole() ~= "Survivor" then return end  -- Hanya Survivor
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


local function UpdateNoSlowdown()
    if not Config.KILLER_NoSlowdown then return end
    if GetRole() ~= "Killer" then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    
    if hum.WalkSpeed < 16 then
        hum.WalkSpeed = State.OriginalSpeed or 16
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

local function GetRole()
    local char = LocalPlayer.Character
    if not char then return "Spectator" end
    
    -- Cek apakah player adalah Killer
    local killerFolder = game:GetService("ReplicatedStorage"):FindFirstChild("KillerData")
        or Workspace:FindFirstChild("Killer")
    
    -- Cara paling umum di DBD-style game: cek team atau attribute
    local team = LocalPlayer.Team
    if team then
        local teamName = team.Name:lower()
        if teamName:find("killer") then return "Killer" end
        if teamName:find("survivor") then return "Survivor" end
        if teamName:find("spectator") then return "Spectator" end
    end
    
    -- Fallback: cek via attribute di character
    if char:GetAttribute("Role") then
        return char:GetAttribute("Role")
    end
    
    return "Spectator"
end

-- ================================================================
-- ROLE MANAGER
-- Spectator = Spectator  suspend semua fitur aktif
-- Masuk match (Killer/Survivor)  rehook semua yang perlu
-- CharacterAdded dalam match  rehook juga (GUI/script di-recreate game)
-- ================================================================
local RoleManagerConn = nil
local RoleCharConn    = nil
local LastRole        = GetRole()  -- snapshot saat load

local function SuspendAllFeatures()
    -- Matikan fitur tanpa ubah Config (state config tetap tersimpan)
    pcall(ThirdPerson_Remove)
    pcall(function()
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = State.OriginalSpeed or 16
            hum.JumpPower = OriginalJumpPower or 50
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end)
    pcall(Heal_Cleanup)
    pcall(GodMode_Stop)
    pcall(AntiScript_Restore)
    pcall(PerfectSC_Stop)
    pcall(QTE_Stop)
    pcall(AutoParry_Cleanup)
end

local function RehookForRole(role)
    if State.Unloaded then return end
    if role == "Spectator" then return end

    -- Rehook semua yang bergantung pada GUI/script yang di-recreate game tiap match
    task.delay(2, function()
        if State.Unloaded or GetRole() ~= role then return end

        -- AutoParry: rehook anim detection ke char baru
        if Config.AUTO_Parry then
            pcall(AutoParry_Cleanup)
            pcall(AutoParry_Setup)
        end

        -- Remove Skill Check (disable Skillcheck-gen + Skillcheck-player)
        if Config.ANTI_SkillCheck then
            local char = LocalPlayer.Character
            if char then pcall(AntiScript_Apply, char) end
        end

        -- Perfect Skill Check VIM
        if Config.PERFECT_SkillCheck then
            pcall(PerfectSC_Stop)
            pcall(PerfectSC_Setup)
        end
        -- Perfect Skill Check QTE
        if Config.AUTO_SkillCheck then
            pcall(QTE_Stop)
            pcall(QTE_Setup)
        end

        -- SetupAntiBlind
        if Config.KILLER_AntiBlind then
            pcall(SetupAntiBlind)
        end

        -- SetupNoPalletStun
        if Config.KILLER_NoPalletStun then
            pcall(SetupNoPalletStun)
        end

        -- Third Person: re-apply offset ke char baru
        if Config.CAM_ThirdPerson and role ~= "Spectator" then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.CameraOffset = Vector3.new(2, 1, 8) end
            end
        end
        if Config.FULLBRIGHT then pcall(Fullbright_On) end
        if Config.NO_Fog then
            FogCache = {}
            State.LastFogState = nil
            pcall(RemoveFog)
        end
        if Config.SURV_GodMode and role == "Survivor" then
            pcall(GodMode_Stop); pcall(GodMode_Start)
        end
    end)
end

local function RoleManager_Start()
    if RoleManagerConn then pcall(function() RoleManagerConn:Disconnect() end) end
    if RoleCharConn    then pcall(function() RoleCharConn:Disconnect() end) end

    -- CharacterAdded: rehook setiap respawn di dalam match
    RoleCharConn = LocalPlayer.CharacterAdded:Connect(function(char)
        local role = GetRole()
        if role == "Spectator" then return end
        RehookForRole(role)
    end)

    -- Team change: Spectator  Killer/Survivor
    RoleManagerConn = LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        local newRole = GetRole()
        if newRole == LastRole then return end
        LastRole = newRole

        if newRole == "Spectator" then
            task.spawn(SuspendAllFeatures)
        else
            -- Masuk match, tunggu char + GUI siap lalu rehook
            RehookForRole(newRole)
        end
    end)
end
local OriginalCameraType    = nil
local ThirdPersonWasActive  = false
local ThirdPersonCharConn   = nil  -- re-apply offset saat respawn, tanpa loop

local ThirdPersonRenderConn = nil

-- Scripts yang perlu di-disable untuk third person
local ThirdPersonDisabledScripts = {}

local function ThirdPerson_DisableOverrides(char)
    if not char then return end
    -- Disable semua script yang override camera
    local scriptNames = {
        "Firstperson", "CamShake",
    }
    for _, name in ipairs(scriptNames) do
        local scr = char:FindFirstChild(name)
        if scr and not scr.Disabled then
            pcall(function() scr.Disabled = true end)
            table.insert(ThirdPersonDisabledScripts, scr)
        end
    end
    -- Juga cek di workspace (SmoothCamera bisa ada di workspace.character)
    local cam = workspace.CurrentCamera
    if cam then
        for _, scr in ipairs(cam:GetChildren()) do
            if scr:IsA("LocalScript") or scr:IsA("Script") then
                if not scr.Disabled then
                    pcall(function() scr.Disabled = true end)
                    table.insert(ThirdPersonDisabledScripts, scr)
                end
            end
        end
    end
    -- Set zoom distance
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 20
        LocalPlayer.CameraMinZoomDistance = 5
    end)
    -- Paksa CameraSubject ke Humanoid (bukan CameraBlock dari SmoothCamera)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
    end
end

local function ThirdPerson_RestoreOverrides()
    for _, scr in ipairs(ThirdPersonDisabledScripts) do
        pcall(function()
            if scr and scr.Parent then scr.Disabled = false end
        end)
    end
    ThirdPersonDisabledScripts = {}
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 7
        LocalPlayer.CameraMinZoomDistance = 7
    end)
    -- Restore CameraSubject ke Humanoid
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
        end
    end
end

local function ThirdPerson_Apply()
    local cam = workspace.CurrentCamera
    if not cam then return end
    OriginalCameraType = cam.CameraType

    local char = LocalPlayer.Character
    if char then
        -- Hanya disable Firstperson - biarkan SmoothCamera jalan (itu yang bikin TP bagus)
        local fp = char:FindFirstChild("Firstperson")
        if fp and not fp.Disabled then
            pcall(function() fp.Disabled = true end)
            table.insert(ThirdPersonDisabledScripts, fp)
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.AutoRotate = true
        end
    end

    -- Zoom out lebih jauh agar keliatan third person
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 20
        LocalPlayer.CameraMinZoomDistance = 7
    end)

    -- Heartbeat: maintain zoom dan re-disable Firstperson kalau muncul lagi
    if ThirdPersonRenderConn then ThirdPersonRenderConn:Disconnect() end
    ThirdPersonRenderConn = RunService.Heartbeat:Connect(function()
        if not Config.CAM_ThirdPerson then return end
        local c = LocalPlayer.Character
        if not c then return end
        local fp = c:FindFirstChild("Firstperson")
        if fp and not fp.Disabled then
            pcall(function() fp.Disabled = true end)
            table.insert(ThirdPersonDisabledScripts, fp)
        end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h and not h.AutoRotate then h.AutoRotate = true end
        -- Maintain zoom
        if LocalPlayer.CameraMaxZoomDistance ~= 20 then
            pcall(function() LocalPlayer.CameraMaxZoomDistance = 20 end)
        end
    end)

    -- Re-apply saat respawn
    if ThirdPersonCharConn then ThirdPersonCharConn:Disconnect() end
    ThirdPersonCharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if not Config.CAM_ThirdPerson then return end
        task.wait(1)
        local fp = newChar:FindFirstChild("Firstperson")
        if fp and not fp.Disabled then
            pcall(function() fp.Disabled = true end)
            table.insert(ThirdPersonDisabledScripts, fp)
        end
        local hum = newChar:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        pcall(function() LocalPlayer.CameraMaxZoomDistance = 20 end)
    end)
    ThirdPersonWasActive = true
end
local function ThirdPerson_Remove()
    if ThirdPersonRenderConn then
        ThirdPersonRenderConn:Disconnect()
        ThirdPersonRenderConn = nil
    end
    
    local role = GetRole()
    local inGame = role == "Killer"
    local char = LocalPlayer.Character
    if char and inGame then
        local fp = char:FindFirstChild("Firstperson")
        if fp then
            pcall(function() fp.Disabled = false end)
        end
    end
    ThirdPersonDisabledScripts = {}
    -- Restore zoom ke default
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 7
        LocalPlayer.CameraMinZoomDistance = 7
    end)
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
    if ThirdPersonCharConn then
        ThirdPersonCharConn:Disconnect()
        ThirdPersonCharConn = nil
    end
    ThirdPersonWasActive = false
end


local function UpdateThirdPerson()
    local role = GetRole()
    local shouldBeActive = Config.CAM_ThirdPerson and role ~= "Spectator"
    if shouldBeActive and not ThirdPersonWasActive then
        ThirdPerson_Apply()
    elseif not shouldBeActive and ThirdPersonWasActive then
        ThirdPerson_Remove()
    end
end


local FlyConnection = nil
local FlyBodyVelocity = nil
local FlyBodyGyro = nil

local function UpdateFly()
    if GetRole() == "Spectator" then return end
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

-- ==================== VELARIS UI LIBRARY ====================
local VelarisUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/tesui.lua"))()

-- ==================== WINDOW ====================
local Window = VelarisUI:Window({
    Title          = "Victoria Hub | Violence District",
    Footer         = "By Victoria",
    Content        = "Violence District",
    Color          = "Blue",
    Version        = 1.0,
    ["Tab Width"]  = 110,
    Image          = "96751490485303",
    Configname     = "VictoriaHub_VD",
    Uitransparent  = 0.15,
    ShowUser       = false,
    Search         = false,
    Animation      = true,
    TypeDelay      = 0.07,
    TypePause      = 2.5,
    Config = {
        AutoSave   = false,
        AutoLoad   = false
    },
    KeySystem = {
        Title      = "Victoria Hub",
        Icon       = "lucide:key",
        Placeholder = "Masukkan key disini",
        Default    = "VD-KEYLESS",
        DiscordText = "Join Discord",
        DiscordUrl  = "https://discord.gg/xxxxx",
        Links = {
            { Name = "Linkvertise", Icon = "lucide:link", Url = "https://linkvertise.com/xxxxx" },
            { Name = "LootLabs",    Icon = "lucide:gift", Url = "https://lootlabs.gg/xxxxx" },
        },
        Steps = {
            "1. Pilih metode verifikasi",
            "2. Selesaikan ads (2 checkpoint)",
            "3. Copy dan paste key dibawah",
        },
        Callback = function(key)
            local validKeys = { "VICTORIA2025", "VD-FREE-KEY", "VD-KEYLESS" }
            for _, v in ipairs(validKeys) do
                if key == v then return true end
            end
            return false
        end,
    },
})

Window:Tag({
    Title = "v1.0",
    Color = Color3.fromRGB(0, 170, 255),
})

-- ==================== HELPER ====================
local function notifToggle(name, state)
    VelarisUI:MakeNotify({
        Title       = name,
        Description = state and "Enabled" or "Disabled",
        Content     = "",
        Color       = state and "Success" or "Error",
        Time        = 2,
        Icon        = state and "lucide:check" or "lucide:x"
    })
end

-- ==================== TAB DEFINITIONS ====================
local Tabs = {
    ESP      = Window:AddTab({ Name = "ESP",      Icon = "lucide:eye" }),
    AIM      = Window:AddTab({ Name = "Aim",      Icon = "lucide:crosshair" }),
    SURVIVOR = Window:AddTab({ Name = "Survivor", Icon = "lucide:user" }),
    KILLER   = Window:AddTab({ Name = "Killer",   Icon = "lucide:sword" }),
    MOVEMENT = Window:AddTab({ Name = "Movement", Icon = "lucide:gamepad-2" }),
    MISC     = Window:AddTab({ Name = "Misc",     Icon = "lucide:settings" }),
    CONFIG     = Window:AddTab({ Name = "Config",     Icon = "lucide:folder" }),
}

-- =====================================================================
-- TAB 1: ESP
-- =====================================================================

-- ---------------------------------------------------------------------
-- Players Section
-- ---------------------------------------------------------------------
local SecESPPlayers = Tabs.ESP:AddSection({
    Title = "Players",
    Open  = true
})

SecESPPlayers:AddToggle({
    Title    = "Killer ESP",
    Default  = Config.ESP_Killer,
    Callback = function(v)
        Config.ESP_Killer = v
        if not v then ESP.hideAll() end
        notifToggle("Killer ESP", v)
    end
})

SecESPPlayers:AddToggle({
    Title    = "Survivor ESP",
    Default  = Config.ESP_Survivor,
    Callback = function(v)
        Config.ESP_Survivor = v
        if not v then ESP.hideAll() end
        notifToggle("Survivor ESP", v)
    end
})

SecESPPlayers:AddDropdown({
    Title    = "Player Mode",
    Options  = { "Chams", "Box" },
    Default  = Config.ESP_PlayerChams and "Chams" or "Box",
    Callback = function(v)
        Config.ESP_PlayerChams = (v == "Chams")
    end
})

SecESPPlayers:AddToggle({
    Title    = "Names",
    Default  = Config.ESP_Names,
    Callback = function(v) Config.ESP_Names = v end
})

SecESPPlayers:AddToggle({
    Title    = "Distance",
    Default  = Config.ESP_Distance,
    Callback = function(v) Config.ESP_Distance = v end
})

SecESPPlayers:AddToggle({
    Title    = "Health",
    Default  = Config.ESP_Health,
    Callback = function(v) Config.ESP_Health = v end
})

SecESPPlayers:AddToggle({
    Title    = "Skeleton",
    Default  = Config.ESP_Skeleton,
    Callback = function(v) Config.ESP_Skeleton = v end
})

SecESPPlayers:AddToggle({
    Title    = "Offscreen Arrow",
    Default  = Config.ESP_Offscreen,
    Callback = function(v) Config.ESP_Offscreen = v end
})

SecESPPlayers:AddToggle({
    Title    = "Velocity",
    Default  = Config.ESP_Velocity,
    Callback = function(v) Config.ESP_Velocity = v end
})

-- ---------------------------------------------------------------------
-- Objects Section
-- ---------------------------------------------------------------------
local SecESPObjects = Tabs.ESP:AddSection({
    Title = "Objects",
    Open  = false
})

SecESPObjects:AddToggle({
    Title    = "Generator",
    Default  = Config.ESP_Generator,
    Callback = function(v) Config.ESP_Generator = v end
})

SecESPObjects:AddToggle({
    Title    = "Gate",
    Default  = Config.ESP_Gate,
    Callback = function(v) Config.ESP_Gate = v end
})

SecESPObjects:AddToggle({
    Title    = "Hook",
    Default  = Config.ESP_Hook,
    Callback = function(v) Config.ESP_Hook = v end
})

SecESPObjects:AddToggle({
    Title    = "Pallet",
    Default  = Config.ESP_Pallet,
    Callback = function(v) Config.ESP_Pallet = v end
})

SecESPObjects:AddToggle({
    Title    = "Window",
    Default  = Config.ESP_Window,
    Callback = function(v) Config.ESP_Window = v end
})

SecESPObjects:AddDropdown({
    Title    = "Object Mode",
    Options  = { "Box", "Chams" },
    Default  = Config.ESP_ObjectChams and "Chams" or "Box",
    Callback = function(v)
        Config.ESP_ObjectChams = (v == "Chams")
    end
})

-- ---------------------------------------------------------------------
-- Radar Section
-- ---------------------------------------------------------------------
local SecRadar = Tabs.ESP:AddSection({
    Title = "Radar",
    Open  = false
})

SecRadar:AddToggle({
    Title    = "Enable Radar",
    Default  = Config.RADAR_Enabled,
    Callback = function(v)
        Config.RADAR_Enabled = v
        notifToggle("Radar", v)
    end
})

SecRadar:AddSlider({
    Title    = "Radar Size",
    Min      = 80,
    Max      = 200,
    Default  = Config.RADAR_Size,
    Callback = function(v) Config.RADAR_Size = v end
})

SecRadar:AddToggle({
    Title    = "Circle Shape",
    Default  = Config.RADAR_Circle,
    Callback = function(v) Config.RADAR_Circle = v end
})

SecRadar:AddToggle({
    Title    = "Show Killer",
    Default  = Config.RADAR_Killer,
    Callback = function(v) Config.RADAR_Killer = v end
})

SecRadar:AddToggle({
    Title    = "Show Survivor",
    Default  = Config.RADAR_Survivor,
    Callback = function(v) Config.RADAR_Survivor = v end
})

SecRadar:AddToggle({
    Title    = "Show Generator",
    Default  = Config.RADAR_Generator,
    Callback = function(v) Config.RADAR_Generator = v end
})

SecRadar:AddToggle({
    Title    = "Show Pallet",
    Default  = Config.RADAR_Pallet,
    Callback = function(v) Config.RADAR_Pallet = v end
})

-- =====================================================================
-- TAB 2: AIM
-- =====================================================================

-- ---------------------------------------------------------------------
-- Camera Aimbot Section
-- ---------------------------------------------------------------------
local SecAimbot = Tabs.AIM:AddSection({
    Title = "Camera Aimbot",
    Open  = true
})

SecAimbot:AddToggle({
    Title    = "Enable Aimbot",
    Default  = Config.AIM_Enabled,
    Callback = function(v)
        Config.AIM_Enabled = v
        notifToggle("Aimbot", v)
    end
})

SecAimbot:AddToggle({
    Title    = "Auto Mode (Mobile)",
    Default  = Config.AIM_AutoMode,
    Callback = function(v) Config.AIM_AutoMode = v end
})

SecAimbot:AddDropdown({
    Title    = "Target Mode",
    Options  = { "Auto", "Killer", "Survivor", "Closest" },
    Default  = Config.AIM_TargetMode,
    Callback = function(v) Config.AIM_TargetMode = v end
})

SecAimbot:AddToggle({
    Title    = "Show FOV",
    Default  = Config.AIM_ShowFOV,
    Callback = function(v) Config.AIM_ShowFOV = v end
})

SecAimbot:AddToggle({
    Title    = "Crosshair",
    Default  = Config.AIM_Crosshair,
    Callback = function(v) Config.AIM_Crosshair = v end
})

SecAimbot:AddSlider({
    Title    = "FOV Size",
    Min      = 50,
    Max      = 400,
    Default  = Config.AIM_FOV,
    Callback = function(v) Config.AIM_FOV = v end
})

SecAimbot:AddSlider({
    Title    = "Smoothness",
    Min      = 1,
    Max      = 20,
    Default  = math.floor(Config.AIM_Smooth * 20),
    Callback = function(v) Config.AIM_Smooth = v / 20 end
})

SecAimbot:AddDropdown({
    Title    = "Target Part",
    Options  = { "Torso", "HumanoidRootPart", "Left Arm" },
    Default  = Config.AIM_TargetPart,
    Callback = function(v) Config.AIM_TargetPart = v end
})

SecAimbot:AddToggle({
    Title    = "Visibility Check",
    Default  = Config.AIM_VisCheck,
    Callback = function(v) Config.AIM_VisCheck = v end
})

SecAimbot:AddToggle({
    Title    = "Prediction",
    Default  = Config.AIM_Predict,
    Callback = function(v) Config.AIM_Predict = v end
})

-- ---------------------------------------------------------------------
-- Spear Aimbot Section
-- ---------------------------------------------------------------------
local SecSpear = Tabs.AIM:AddSection({
    Title = "Spear Aimbot (Veil)",
    Open  = false
})

SecSpear:AddToggle({
    Title    = "Spear Aimbot",
    Default  = Config.SPEAR_Aimbot,
    Callback = function(v)
        Config.SPEAR_Aimbot = v
        notifToggle("Spear Aimbot", v)
    end
})

SecSpear:AddSlider({
    Title    = "Gravity",
    Min      = 10,
    Max      = 200,
    Default  = Config.SPEAR_Gravity,
    Callback = function(v) Config.SPEAR_Gravity = v end
})

SecSpear:AddSlider({
    Title    = "Speed",
    Min      = 50,
    Max      = 300,
    Default  = Config.SPEAR_Speed,
    Callback = function(v) Config.SPEAR_Speed = v end
})

-- =====================================================================
-- TAB 3: SURVIVOR
-- =====================================================================

-- ---------------------------------------------------------------------
-- Generator Section
-- ---------------------------------------------------------------------
local SecGen = Tabs.SURVIVOR:AddSection({
    Title = "Generator",
    Open  = true
})

SecGen:AddToggle({
    Title    = "Auto Generator",
    Default  = Config.AUTO_Generator,
    Callback = function(v)
        Config.AUTO_Generator = v
        notifToggle("Auto Gen", v)
    end
})

SecGen:AddDropdown({
    Title    = "Gen Speed",
    Options  = { "Fast", "Slow" },
    Default  = Config.AUTO_GenMode,
    Callback = function(v) Config.AUTO_GenMode = v end
})

SecGen:AddSlider({
    Title    = "Leave Dist",
    Min      = 10,
    Max      = 30,
    Default  = Config.AUTO_LeaveDist,
    Callback = function(v) Config.AUTO_LeaveDist = v end
})

-- ---------------------------------------------------------------------
-- Survivor Section
-- ---------------------------------------------------------------------
local SecSurv = Tabs.SURVIVOR:AddSection({
    Title = "Survivor",
    Open  = true
})

SecSurv:AddToggle({
    Title    = "Remove Skill Check",
    Default  = Config.ANTI_SkillCheck,
    Callback = function(v)
        Config.ANTI_SkillCheck = v
        if v and LocalPlayer.Character then
            AntiScript_Apply(LocalPlayer.Character)
        else
            AntiScript_Restore()
        end
        notifToggle("Remove Skill Check", v)
    end
})

SecSurv:AddToggle({
    Title    = "Perfect Skill Check",
    Default  = Config.PERFECT_SkillCheck,
    Callback = function(v)
        Config.PERFECT_SkillCheck = v
        if v then PerfectSC_Setup() else PerfectSC_Stop() end
        notifToggle("Perfect SC", v)
    end
})

SecSurv:AddToggle({
    Title    = "God Mode",
    Default  = Config.SURV_GodMode,
    Callback = function(v)
        Config.SURV_GodMode = v
        if v then task.spawn(GodMode_Start) else GodMode_Stop() end
        notifToggle("God Mode", v)
    end
})

SecSurv:AddToggle({
    Title    = "No Fall Damage",
    Default  = Config.SURV_NoFall,
    Callback = function(v)
        Config.SURV_NoFall = v
        notifToggle("No Fall", v)
    end
})

-- ---------------------------------------------------------------------
-- Auto Parry Section
-- ---------------------------------------------------------------------
local SecParry = Tabs.SURVIVOR:AddSection({
    Title = "Auto Parry",
    Open  = false
})

SecParry:AddToggle({
    Title    = "Auto Parry",
    Default  = Config.AUTO_Parry,
    Callback = function(v)
        Config.AUTO_Parry = v
        if v then AutoParry_Setup() else AutoParry_Cleanup() end
        notifToggle("Auto Parry", v)
    end
})

SecParry:AddDropdown({
    Title    = "Parry Mode",
    Options  = { "With Animation", "No Animation" },
    Default  = Config.PARRY_Mode,
    Callback = function(v) Config.PARRY_Mode = v end
})

SecParry:AddSlider({
    Title    = "Parry Distance",
    Min      = 5,
    Max      = 40,
    Default  = Config.PARRY_Dist,
    Callback = function(v) Config.PARRY_Dist = v end
})

SecParry:AddToggle({
    Title    = "Show Parry FOV",
    Default  = Config.PARRY_FOV,
    Callback = function(v) Config.PARRY_FOV = v end
})

-- ---------------------------------------------------------------------
-- Beat Game Section
-- ---------------------------------------------------------------------
local SecBeatSurv = Tabs.SURVIVOR:AddSection({
    Title = "Beat Game",
    Open  = false
})

SecBeatSurv:AddToggle({
    Title    = "Beat As Survivor",
    Default  = Config.BEAT_Survivor,
    Callback = function(v) Config.BEAT_Survivor = v end
})

-- =====================================================================
-- TAB 4: KILLER
-- =====================================================================

-- ---------------------------------------------------------------------
-- Combat Section
-- ---------------------------------------------------------------------
local SecCombat = Tabs.KILLER:AddSection({
    Title = "Combat",
    Open  = true
})

SecCombat:AddToggle({
    Title    = "Auto Attack",
    Default  = Config.AUTO_Attack,
    Callback = function(v)
        Config.AUTO_Attack = v
        notifToggle("Auto Attack", v)
    end
})

SecCombat:AddSlider({
    Title    = "Attack Range",
    Min      = 5,
    Max      = 20,
    Default  = Config.AUTO_AttackRange,
    Callback = function(v) Config.AUTO_AttackRange = v end
})

SecCombat:AddToggle({
    Title    = "Double Tap (Instant Kill)",
    Default  = Config.KILLER_DoubleTap,
    Callback = function(v) Config.KILLER_DoubleTap = v end
})

SecCombat:AddToggle({
    Title    = "Infinite Lunge",
    Default  = Config.KILLER_InfiniteLunge,
    Callback = function(v) Config.KILLER_InfiniteLunge = v end
})

SecCombat:AddToggle({
    Title    = "Auto Hook",
    Default  = Config.KILLER_AutoHook,
    Callback = function(v) Config.KILLER_AutoHook = v end
})

-- ---------------------------------------------------------------------
-- Hitbox Section
-- ---------------------------------------------------------------------
local SecHitbox = Tabs.KILLER:AddSection({
    Title = "Hitbox",
    Open  = false
})

SecHitbox:AddToggle({
    Title    = "Hitbox Expander",
    Default  = Config.HITBOX_Enabled,
    Callback = function(v) Config.HITBOX_Enabled = v end
})

SecHitbox:AddSlider({
    Title    = "Hitbox Size",
    Min      = 5,
    Max      = 30,
    Default  = Config.HITBOX_Size,
    Callback = function(v) Config.HITBOX_Size = v end
})

-- ---------------------------------------------------------------------
-- Protection Section
-- ---------------------------------------------------------------------
local SecProtection = Tabs.KILLER:AddSection({
    Title = "Protection",
    Open  = false
})

SecProtection:AddToggle({
    Title    = "No Pallet Stun",
    Default  = Config.KILLER_NoPalletStun,
    Callback = function(v) Config.KILLER_NoPalletStun = v end
})

SecProtection:AddToggle({
    Title    = "Anti Blind",
    Default  = Config.KILLER_AntiBlind,
    Callback = function(v) Config.KILLER_AntiBlind = v end
})

SecProtection:AddToggle({
    Title    = "No Slowdown",
    Default  = Config.KILLER_NoSlowdown,
    Callback = function(v) Config.KILLER_NoSlowdown = v end
})

-- ---------------------------------------------------------------------
-- Destruction Section
-- ---------------------------------------------------------------------
local SecDestruction = Tabs.KILLER:AddSection({
    Title = "Destruction",
    Open  = false
})

SecDestruction:AddToggle({
    Title    = "Full Gen Break",
    Default  = Config.KILLER_FullGenBreak,
    Callback = function(v) Config.KILLER_FullGenBreak = v end
})

SecDestruction:AddToggle({
    Title    = "Destroy All Pallets",
    Default  = Config.KILLER_DestroyPallets,
    Callback = function(v) Config.KILLER_DestroyPallets = v end
})

-- ---------------------------------------------------------------------
-- Camera Section
-- ---------------------------------------------------------------------
local SecKillCamera = Tabs.KILLER:AddSection({
    Title = "Camera",
    Open  = false
})

SecKillCamera:AddToggle({
    Title    = "Third Person",
    Default  = Config.CAM_ThirdPerson,
    Callback = function(v) Config.CAM_ThirdPerson = v end
})

-- ---------------------------------------------------------------------
-- Beat Game Section
-- ---------------------------------------------------------------------
local SecBeatKill = Tabs.KILLER:AddSection({
    Title = "Beat Game",
    Open  = false
})

SecBeatKill:AddToggle({
    Title    = "Beat As Killer",
    Default  = Config.BEAT_Killer,
    Callback = function(v) Config.BEAT_Killer = v end
})

-- =====================================================================
-- TAB 5: MOVEMENT
-- =====================================================================

-- ---------------------------------------------------------------------
-- Speed Section
-- ---------------------------------------------------------------------
local SecSpeed = Tabs.MOVEMENT:AddSection({
    Title = "Speed",
    Open  = true
})

SecSpeed:AddToggle({
    Title    = "Speed Hack",
    Default  = Config.SPEED_Enabled,
    Callback = function(v)
        Config.SPEED_Enabled = v
        notifToggle("Speed", v)
    end
})

SecSpeed:AddSlider({
    Title    = "Speed Value",
    Min      = 16,
    Max      = 150,
    Default  = Config.SPEED_Value,
    Callback = function(v) Config.SPEED_Value = v end
})

SecSpeed:AddDropdown({
    Title    = "Speed Method",
    Options  = { "Attribute", "TP" },
    Default  = Config.SPEED_Method,
    Callback = function(v) Config.SPEED_Method = v end
})

-- ---------------------------------------------------------------------
-- Flight Section
-- ---------------------------------------------------------------------
local SecFly = Tabs.MOVEMENT:AddSection({
    Title = "Flight",
    Open  = false
})

SecFly:AddToggle({
    Title    = "Fly",
    Default  = Config.FLY_Enabled,
    Callback = function(v) Config.FLY_Enabled = v end
})

SecFly:AddSlider({
    Title    = "Fly Speed",
    Min      = 10,
    Max      = 200,
    Default  = Config.FLY_Speed,
    Callback = function(v) Config.FLY_Speed = v end
})

SecFly:AddDropdown({
    Title    = "Fly Method",
    Options  = { "CFrame", "Velocity" },
    Default  = Config.FLY_Method,
    Callback = function(v) Config.FLY_Method = v end
})

-- ---------------------------------------------------------------------
-- Jump Section
-- ---------------------------------------------------------------------
local SecJump = Tabs.MOVEMENT:AddSection({
    Title = "Jump",
    Open  = false
})

SecJump:AddSlider({
    Title    = "Jump Power",
    Min      = 50,
    Max      = 200,
    Default  = Config.JUMP_Power,
    Callback = function(v) Config.JUMP_Power = v end
})

SecJump:AddToggle({
    Title    = "Infinite Jump",
    Default  = Config.JUMP_Infinite,
    Callback = function(v) Config.JUMP_Infinite = v end
})

-- ---------------------------------------------------------------------
-- Collision Section
-- ---------------------------------------------------------------------
local SecCollision = Tabs.MOVEMENT:AddSection({
    Title = "Collision",
    Open  = false
})

SecCollision:AddToggle({
    Title    = "Noclip",
    Default  = Config.NOCLIP_Enabled,
    Callback = function(v) Config.NOCLIP_Enabled = v end
})

-- ---------------------------------------------------------------------
-- Teleport Section
-- ---------------------------------------------------------------------
local SecTeleport = Tabs.MOVEMENT:AddSection({
    Title = "Teleport",
    Open  = false
})

SecTeleport:AddSlider({
    Title    = "TP Height Offset",
    Min      = 0,
    Max      = 10,
    Default  = Config.TP_Offset,
    Callback = function(v) Config.TP_Offset = v end
})

SecTeleport:AddButton({
    Title    = "TP to Generator",
    Callback = function() TeleportToGenerator(1) end
})

SecTeleport:AddButton({
    Title    = "TP to Gate",
    Callback = function() TeleportToGate() end
})

SecTeleport:AddButton({
    Title    = "TP to Hook",
    Callback = function() TeleportToHook() end
})

-- =====================================================================
-- TAB 6: MISC
-- =====================================================================

-- ---------------------------------------------------------------------
-- Visual Section
-- ---------------------------------------------------------------------
local SecVisual = Tabs.MISC:AddSection({
    Title = "Visual",
    Open  = true
})

SecVisual:AddToggle({
    Title    = "No Fog",
    Default  = Config.NO_Fog,
    Callback = function(v)
        Config.NO_Fog = v
        notifToggle("No Fog", v)
    end
})

SecVisual:AddToggle({
    Title    = "Fullbright",
    Default  = Config.FULLBRIGHT,
    Callback = function(v)
        Config.FULLBRIGHT = v
        if v then Fullbright_On() else Fullbright_Off() end
        notifToggle("Fullbright", v)
    end
})

-- ---------------------------------------------------------------------
-- Fling Section
-- ---------------------------------------------------------------------
local SecFling = Tabs.MISC:AddSection({
    Title = "Fling",
    Open  = false
})

SecFling:AddToggle({
    Title    = "Fling Enable",
    Default  = Config.FLING_Enabled,
    Callback = function(v)
        Config.FLING_Enabled = v
        notifToggle("Fling", v)
    end
})

SecFling:AddSlider({
    Title    = "Fling Strength",
    Min      = 1000,
    Max      = 50000,
    Default  = Config.FLING_Strength,
    Callback = function(v) Config.FLING_Strength = v end
})

SecFling:AddButton({
    Title    = "Fling Nearest",
    Callback = function() FlingNearest() end
})

SecFling:AddButton({
    Title    = "Fling All",
    Callback = function() FlingAll() end
})

-- ---------------------------------------------------------------------
-- Keybinds Section
-- ---------------------------------------------------------------------
local SecKeybinds = Tabs.MISC:AddSection({
    Title = "Keybinds",
    Open  = false
})

SecKeybinds:AddParagraph({
    Title   = "Info",
    Content = "Menu: INSERT | Panic: HOME\n"
            .. "Speed: C | Fly: F | Noclip: V\n"
            .. "TP Gen: G | TP Gate: T | TP Hook: H\n"
            .. "Leave Gen: Q | Stop Gen: X"
})

-- ---------------------------------------------------------------------
-- System Section
-- ---------------------------------------------------------------------
local SecSystem = Tabs.MISC:AddSection({
    Title = "System",
    Open  = false
})

SecSystem:AddButton({
    Title = "Unload Script",
    Callback = function()
        VelarisUI:MakeNotify({
            Title       = "System",
            Description = "Unloading...",
            Content     = "",
            Color       = "Default",
            Time        = 2
        })
        task.delay(0.5, function() Unload() end)
    end
})

-- ---------------------------------------------------------------------
-- Config Section (Auto Save/Load)
-- ---------------------------------------------------------------------
VelarisUI:AddConfigSection(Tabs.CONFIG, {
    Name = "Configuration",
})

-- =====================================================================
-- NOTIF LOAD SUCCESS
-- =====================================================================
VelarisUI:MakeNotify({
    Title       = "Victoria Hub",
    Description = "Loaded Successfully!",
    Content     = "Violence District",
    Color       = "Success",
    Time        = 3,
    Icon        = "lucide:check"
})

-- FOV Circle Drawing (line-based, 32 segments)
local FOV_SEGMENTS = 20
local FOVLines = {}
for i = 1, FOV_SEGMENTS do
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Color = Color3.fromRGB(0, 170, 255)
    l.Transparency = 1
    l.Visible = false
    FOVLines[i] = l
end
-- Dummy FOVCircle agar tidak error di Unload
local FOVCircle = {Visible = false}

-- Crosshair (4 lines + dot)
local CrossLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 1.5
    l.Color = Color3.fromRGB(255, 255, 255)
    l.Transparency = 1
    l.Visible = false
    CrossLines[i] = l
end
-- Outline lines (hitam, sedikit lebih tebal)
local CrossOutlines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 3
    l.Color = Color3.fromRGB(0, 0, 0)
    l.Transparency = 0.5
    l.Visible = false
    CrossOutlines[i] = l
end
-- Dot tengah (hitam)
local CrossDot = Drawing.new("Circle")
CrossDot.Radius = 2
CrossDot.Filled = true
CrossDot.Color = Color3.fromRGB(0, 0, 0)
CrossDot.Transparency = 1
CrossDot.Visible = false
-- Dummy untuk compatibility
local CrossH = {Visible = false}
local CrossV = {Visible = false}

local PFOV_N = 24
local PFOVLines = {}
for i = 1, PFOV_N do
    local ln = Drawing.new("Line")
    ln.Thickness = 1.5
    ln.Color = Color3.fromRGB(0, 170, 255)
    ln.Transparency = 1
    ln.Visible = false
    PFOVLines[i] = ln
end



local AutoGenHint = Drawing.new("Text")
AutoGenHint.Size = 16
AutoGenHint.Font = Drawing.Fonts.UI
AutoGenHint.Center = true
AutoGenHint.Outline = true
AutoGenHint.Color = Color3.fromRGB(0, 170, 255)
AutoGenHint.Visible = false

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
        if Config.ESP_Enabled then
            ESPRefreshMap()
        end
    end
    
    if now - State.LastVisCheck >= Tuning.ESP_VisCheckRate then
        State.LastVisCheck = now
        UpdateVisibility()
    end

    -- ESP throttle: update tiap 0.05s (20fps) bukan tiap frame
    if now - State.LastESPUpdate >= Tuning.ESP_RefreshRate then
        State.LastESPUpdate = now
        ESP.step(cam, screenSize, screenCenter)
        UpdateObjectESP(cam)
        Radar.step(cam)
    end
    
    if Config.AUTO_Generator then
        AutoGenHint.Text = "AUTO GEN  |  [Q] Leave  [X] Stop"
        AutoGenHint.Position = Vector2.new(screenSize.X / 2, 30)
        AutoGenHint.Visible = true
    else
        AutoGenHint.Visible = false
    end
    
    Aimbot.Update(cam, screenSize, screenCenter)
    
    
    -- Parry FOV world-space circle di lantai bawah karakter
    if Config.AUTO_Parry and Config.PARRY_FOV then
        local myRoot = GetCharacterRoot()
        if myRoot then
            local r = Config.PARRY_Dist
            local baseY = myRoot.Position.Y - 3
            local ox, oz = myRoot.Position.X, myRoot.Position.Z
            -- Render outline
            for i = 1, PFOV_N do
                local a1 = (i-1)/PFOV_N * math.pi * 2
                local a2 = i/PFOV_N * math.pi * 2
                local s1, on1 = WorldToScreen(Vector3.new(ox+math.cos(a1)*r, baseY, oz+math.sin(a1)*r))
                local s2, on2 = WorldToScreen(Vector3.new(ox+math.cos(a2)*r, baseY, oz+math.sin(a2)*r))
                if on1 and on2 then
                    PFOVLines[i].From = s1; PFOVLines[i].To = s2; PFOVLines[i].Visible = true
                else
                    PFOVLines[i].Visible = false
                end
            end
        else
            for i = 1, PFOV_N do PFOVLines[i].Visible = false end
        end
    else
        for i = 1, PFOV_N do PFOVLines[i].Visible = false end
    end

    -- FOV Circle (line-based)
    if Config.AIM_Enabled and Config.AIM_ShowFOV then
        local r = Config.AIM_FOV
        local fovColor = State.AimTarget and Color3.fromRGB(90,220,120) or Color3.fromRGB(220,70,70)
        local cx2, cy2 = screenCenter.X, screenCenter.Y
        for i = 1, FOV_SEGMENTS do
            local a1 = (i - 1) / FOV_SEGMENTS * math.pi * 2
            local a2 = i / FOV_SEGMENTS * math.pi * 2
            FOVLines[i].From = Vector2.new(cx2 + math.cos(a1) * r, cy2 + math.sin(a1) * r)
            FOVLines[i].To   = Vector2.new(cx2 + math.cos(a2) * r, cy2 + math.sin(a2) * r)
            FOVLines[i].Color = fovColor
            FOVLines[i].Visible = true
        end
    else
        for i = 1, FOV_SEGMENTS do FOVLines[i].Visible = false end
    end

    -- Crosshair
    if Config.AIM_Crosshair then
        local cx, cy = screenCenter.X, screenCenter.Y
        local sz  = 10  -- panjang tiap sisi
        local gap = 3   -- gap di tengah
        -- [1]=kiri [2]=kanan [3]=atas [4]=bawah
        local segs = {
            {Vector2.new(cx-sz-gap, cy), Vector2.new(cx-gap, cy)},
            {Vector2.new(cx+gap, cy),    Vector2.new(cx+sz+gap, cy)},
            {Vector2.new(cx, cy-sz-gap), Vector2.new(cx, cy-gap)},
            {Vector2.new(cx, cy+gap),    Vector2.new(cx, cy+sz+gap)},
        }
        for i = 1, 4 do
            CrossOutlines[i].From = segs[i][1]; CrossOutlines[i].To = segs[i][2]; CrossOutlines[i].Visible = true
            CrossLines[i].From   = segs[i][1]; CrossLines[i].To   = segs[i][2]; CrossLines[i].Visible = true
        end
        CrossDot.Position = Vector2.new(cx, cy)
        CrossDot.Visible = true
    else
        for i = 1, 4 do CrossLines[i].Visible = false; CrossOutlines[i].Visible = false end
        CrossDot.Visible = false
    end
    
end

local function UpdateFog()
    if Config.NO_Fog ~= State.LastFogState then
        State.LastFogState = Config.NO_Fog
        if Config.NO_Fog then
            RemoveFog()
        else
            RestoreFog()
        end
    end
end

local function BeatGameSurvivor()
    if not Config.BEAT_Survivor then 
        State.BeatSurvivorDone = false
        State.LastFinishPos = nil
        return 
    end
    if GetRole() ~= "Survivor" then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    local map = Workspace:FindFirstChild("Map")
    if not map then return end
    
    
    local exitPos = nil
    
    pcall(function()
        
        if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then
            exitPos = Vector3.new(3098.16, 454.04, -4918.74)
            return
        end
        
        
        if map:FindFirstChild("HooksMeat") then
            exitPos = Vector3.new(1546.12, 152.21, -796.72)
            return
        end
        
      
        if map:FindFirstChild("churchbell") then
            exitPos = Vector3.new(760.98, -20.14, -78.48)
            return
        end
        
       
        local finish = map:FindFirstChild("Finishline") or map:FindFirstChild("FinishLine") or map:FindFirstChild("Fininshline")
        if finish then
            if finish:IsA("BasePart") then
                exitPos = finish.Position
            elseif finish:IsA("Model") then
                local part = finish:FindFirstChildWhichIsA("BasePart")
                if part then exitPos = part.Position end
            end
            return
        end
        
        
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name:lower():find("finish") then
                if obj:IsA("BasePart") then
                    exitPos = obj.Position
                    break
                elseif obj:IsA("Model") then
                    local part = obj:FindFirstChildWhichIsA("BasePart")
                    if part then 
                        exitPos = part.Position
                        break
                    end
                end
            end
        end
        
        
        if not exitPos then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj:IsA("MeshPart") and obj.Material == Enum.Material.Limestone then
                    exitPos = Vector3.new(-947.90, 152.12, -7579.52)
                    break
                end
            end
        end
        
       
        if not exitPos then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj:IsA("MeshPart") and obj.Material == Enum.Material.Leather then
                    exitPos = Vector3.new(1546.12, 152.21, -796.72)
                    break
                end
            end
        end
    end)
    
    if not exitPos then return end
    
    
    if State.LastFinishPos then
        local dist = (exitPos - State.LastFinishPos).Magnitude
        if dist > 50 then
            State.BeatSurvivorDone = false
        end
    end
    
    
    if State.BeatSurvivorDone then return end
    
    
    root.CFrame = CFrame.new(exitPos + Vector3.new(0, 3, 0))
    
   
    State.BeatSurvivorDone = true
    State.LastFinishPos = exitPos
end

local function GetHealthPercent(hum)
    if not hum or hum.MaxHealth <= 0 then return 0 end
    return hum.Health / hum.MaxHealth
end

local function IsPlayerDowned(hum)
    local pct = GetHealthPercent(hum)
    return pct <= 0.25 and pct > 0
end

local function IsPlayerAlive(hum)
    local pct = GetHealthPercent(hum)
    return pct > 0.25
end

local function BeatGameKiller()
    if not Config.BEAT_Killer then 
        State.KillerTarget = nil
        return 
    end
    if GetRole() ~= "Killer" then 
        State.KillerTarget = nil
        return 
    end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    local target = State.KillerTarget
    local needNewTarget = true
    
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
        if targetRoot and targetHum and IsPlayerAlive(targetHum) then
            needNewTarget = false
        else
            State.KillerTarget = nil
        end
    end
    
    if needNewTarget then
        local survivors = {}
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
                local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                if pRoot and pHum and IsPlayerAlive(pHum) then
                    table.insert(survivors, player)
                end
            end
        end
        
        if #survivors > 0 then
            local closestDist = math.huge
            local closest = nil
            
            for _, player in ipairs(survivors) do
                local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local dist = (pRoot.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                    closest = player
                    end
                end
            
            State.KillerTarget = closest
            target = closest
        else
            State.KillerTarget = nil
            return
        end
    end
    
    if not target or not target.Character then return end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
    if not targetRoot or not targetHum then 
        State.KillerTarget = nil
        return 
    end
    
    if not IsPlayerAlive(targetHum) then
        State.KillerTarget = nil
        return
    end
    
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    local targetPos = targetRoot.Position
    local direction = (root.Position - targetPos).Unit
    if direction.Magnitude ~= direction.Magnitude then 
        direction = Vector3.new(1, 0, 0)
    end
    local offsetPos = targetPos + direction * 3 + Vector3.new(0, 1, 0)
    
    root.CFrame = CFrame.new(offsetPos, targetPos)
    
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
end

local LastAutoHookTime = 0
local AutoHookState = {
    phase = 0,
    target = nil,
    startTime = 0,
    spamCount = 0
}

local function AutoHook_SpamSpace(duration)
    task.spawn(function()
        local vim = game:GetService("VirtualInputManager")
        local endTime = tick() + duration
        while tick() < endTime do
            pcall(function()
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
            task.wait(0.08)
        end
    end)
end

local function AutoHook_LookAt(targetPos)
    local cam = workspace.CurrentCamera
    if not cam then return end
    local root = GetCharacterRoot()
    if not root then return end
    cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
end

local function AutoHook_IsHookOccupied(hook)
    if not hook or not hook.part then return true end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if pRoot then
                local dist = (pRoot.Position - hook.part.Position).Magnitude
                if dist < 8 then
                    return true
                end
            end
        end
    end
    return false
end

local function AutoHook_FindBestHook()
    local root = GetCharacterRoot()
    if not root then return nil end
    
    local bestHook = nil
    local bestDist = math.huge
    
    for _, hook in ipairs(Cache.Hooks) do
        if hook.part and hook.part.Parent then
            if not AutoHook_IsHookOccupied(hook) then
                local dist = (hook.part.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    bestHook = hook
                end
            end
        end
    end
    
    return bestHook
end

local function AutoHook()
    if not Config.KILLER_AutoHook then 
        AutoHookState.phase = 0
        AutoHookState.target = nil
        return 
    end
    if GetRole() ~= "Killer" then 
        AutoHookState.phase = 0
        AutoHookState.target = nil
        return 
    end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    if AutoHookState.phase == 3 then
        if tick() - AutoHookState.startTime > 2 then
            AutoHookState.phase = 0
            AutoHookState.target = nil
            LastAutoHookTime = tick()
        end
        return
    end
    
    if AutoHookState.phase == 2 then
        local hook = AutoHook_FindBestHook()
        if hook and hook.part then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            
            local hookPos = hook.part.Position
            root.CFrame = CFrame.new(hookPos + Vector3.new(0, 2, 0), hookPos)
            AutoHook_LookAt(hookPos)
            AutoHook_SpamSpace(1.5)
            
            task.delay(0.3, function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end)
            
            AutoHookState.phase = 3
            AutoHookState.startTime = tick()
        else
            AutoHookState.phase = 0
            AutoHookState.target = nil
        end
        return
    end
    
    if AutoHookState.phase == 1 then
        if tick() - AutoHookState.startTime > 1.5 then
            AutoHookState.phase = 2
        end
        return
    end
    
    if tick() - LastAutoHookTime < 0.5 then return end
    
    local closestDowned = nil
    local closestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHum and IsPlayerDowned(targetHum) then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestDowned = {player = player, root = targetRoot}
                end
            end
        end
    end
    
    if closestDowned then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        
        local targetPos = closestDowned.root.Position
        root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0), targetPos + Vector3.new(0, -5, 0))
        
        AutoHook_LookAt(targetPos)
        AutoHook_SpamSpace(1.5)
        
        AutoHookState.phase = 1
        AutoHookState.target = closestDowned.player
        AutoHookState.startTime = tick()
        
        task.delay(0.5, function()
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

local function AutoLoop()
    while not State.Unloaded do
        AutoAttack()
        TeleportAway()
        UpdateNoFall()
        DoubleTap()
        UpdateNoSlowdown()
        AutoHook()
        
        UpdateSpeed()
        UpdateNoclip()
        UpdateFly()
        UpdateJumpPower()
        
       
        UpdateFog()
        UpdateThirdPerson()
      
        
       
        UpdateHitboxes()
        UpdateSpearAim()
        
        
        BeatGameSurvivor()
        BeatGameKiller()
        
        task.wait(0.1)
    end
end


Unload = function()
    State.Unloaded = true
    for i = 1, FOV_SEGMENTS do pcall(function() FOVLines[i]:Remove() end) end
    for i = 1, PFOV_N do pcall(function() PFOVLines[i]:Remove() end) end
    for i = 1, 4 do
        pcall(function() CrossLines[i]:Remove() end)
        pcall(function() CrossOutlines[i]:Remove() end)
    end
    pcall(function() CrossDot:Remove() end)
    pcall(function() AutoGenHint:Remove() end)
    pcall(AntiScript_Restore)
    pcall(PerfectSC_Stop)
    pcall(QTE_Stop)
    pcall(AutoParry_Cleanup)
    if ThirdPersonRenderConn then pcall(function() ThirdPersonRenderConn:Disconnect() end); ThirdPersonRenderConn = nil end
    -- Cleanup RoleManager connections
    if RoleManagerConn then pcall(function() RoleManagerConn:Disconnect() end); RoleManagerConn = nil end
    if RoleCharConn    then pcall(function() RoleCharConn:Disconnect() end);    RoleCharConn = nil end
    if ThirdPersonCharConn then pcall(function() ThirdPersonCharConn:Disconnect() end); ThirdPersonCharConn = nil end
    -- Cleanup ThirdPerson
    pcall(ThirdPerson_Remove)
    Config.AUTO_Generator = false
    Config.AUTO_Attack = false
    Config.AUTO_TeleAway = false
    Config.SPEED_Enabled = false
    Config.NOCLIP_Enabled = false
    Config.BEAT_Survivor = false
    Config.BEAT_Killer = false
    Config.HITBOX_Enabled = false
    Config.FLY_Enabled = false
    Config.FLING_Enabled = false
    Config.KILLER_DoubleTap = false
    Config.KILLER_InfiniteLunge = false
    Config.KILLER_AutoHook = false
    State.KillerTarget = nil
    AutoHookState.phase = 0
    AutoHookState.target = nil
    
    
    for player, originalSize in pairs(OriginalHitboxSizes) do
        pcall(function()
            if player and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Size = originalSize
                    root.Transparency = 1
                    root.CanCollide = true
                end
            end
        end)
    end
    OriginalHitboxSizes = {}
    
    
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = State.OriginalSpeed end
    end)
    
  
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and OriginalJumpPower then hum.JumpPower = OriginalJumpPower end
    end)
    
    
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam and OriginalFOV then cam.FieldOfView = OriginalFOV end
    end)
    
    
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
        local cam = workspace.CurrentCamera
        if cam and OriginalCameraType then cam.CameraType = OriginalCameraType end
    end)
    
    
    pcall(function()
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end)
    
    
    pcall(function()
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
    end)
    
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end)
    
   
    if Config.NO_Fog then
        RestoreFog()
    end
    
    
    for name, conn in pairs(Connections) do
        if conn then 
            pcall(function() conn:Disconnect() end)
            Connections[name] = nil
        end
    end
    
    
    for _, esp in pairs(ESP.cache) do
        ESP.destroy(esp)
    end
    ESP.cache = {}
    
    
    for _, esp in pairs(ESP.objectCache) do
        ESP.destroyObject(esp)
    end
    ESP.objectCache = {}
    
    
    ESPClearAll()
    
   
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "_ViolenceChams" or obj.Name == "_ViolenceLabel" then
                pcall(function() obj:Destroy() end)
            end
        end
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local c = player.Character:FindFirstChild("_ViolenceChams")
                if c then c:Destroy() end
                local l = player.Character:FindFirstChild("_ViolenceLabel")
                if l then l:Destroy() end
            end
        end
    end)
    
    pcall(function()
        Radar.bg:Remove()
        Radar.circleBg:Remove()
        Radar.border:Remove()
        Radar.circleBorder:Remove()
        Radar.cross1:Remove()
        Radar.cross2:Remove()
        Radar.center:Remove()
        for _, d in pairs(Radar.dots) do
            if d then d:Remove() end
        end
        for _, d in pairs(Radar.objectDots) do
            if d then d:Remove() end
        end
        for _, d in pairs(Radar.palletSquares) do
            if d then d:Remove() end
        end
    end)
    
    for _, drawing in pairs(GUI.Drawings) do
        if type(drawing) == "table" then
            for _, subDrawing in pairs(drawing) do
                if type(subDrawing) == "table" then
                    for _, d in pairs(subDrawing) do
                        SafeRemove(d)
                    end
                else
                    SafeRemove(subDrawing)
                end
            end
        else
            SafeRemove(drawing)
        end
    end
    GUI.Drawings = {}
end


local function Init()
    -- VictUI loaded above Init
    ScanMap()
    pcall(SetupAntiBlind)
    pcall(SetupNoPalletStun)
    pcall(SetupInfiniteJump)
    task.spawn(AutoParry_Setup)  -- start parry heartbeat
    -- QTE dipanggil saat toggle ON oleh user
    
    Connections.Input = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if State.Unloaded then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        if input.KeyCode == Config.KEY_Panic then
            Unload(); return
        end
        if gameProcessed then return end
        if input.KeyCode == Config.KEY_LeaveGen then
            LeaveGenerator(); return
        end
        if input.KeyCode == Config.KEY_StopGen then
            StopAutoGen(); return
        end
        if input.KeyCode == Config.KEY_TP_Gen then
            TeleportToGenerator(1); return
        end
        if input.KeyCode == Config.KEY_TP_Gate then
            TeleportToGate(); return
        end
        if input.KeyCode == Config.KEY_TP_Hook then
            TeleportToHook(); return
        end
        if input.KeyCode == Config.KEY_Speed then
            Config.SPEED_Enabled = not Config.SPEED_Enabled; return
        end
        if input.KeyCode == Config.KEY_Noclip then
            Config.NOCLIP_Enabled = not Config.NOCLIP_Enabled; return
        end
        if input.KeyCode == Config.KEY_Fly then
            Config.FLY_Enabled = not Config.FLY_Enabled; return
        end
    end)
    
    Connections.InputEnd = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            State.AimHolding = false
            State.AimTarget = nil
        end
    end)
    
    Connections.InputChanged = UserInputService.InputChanged:Connect(function(input)
        _ = input
    end)
    
    Connections.Render = RunService.RenderStepped:Connect(MainLoop)
    
    RoleManager_Start()  -- mulai listen team change & character spawn

    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(2)
            if Config.ESP_Enabled then pcall(ESPRefreshMap) end
            if Config.FULLBRIGHT then
                pcall(Fullbright_On)
            end
            if Config.NO_Fog then
                FogCache = {}
                State.LastFogState = nil
                pcall(RemoveFog)
            end
        end
    end)

    task.spawn(AutoLoop)
    
    task.spawn(function()
        local repairRemote, skillRemote
        local lastScan = 0
        local genPoints = {}
        
        while not State.Unloaded do
            if Config.AUTO_Generator then
              
                if not repairRemote then
                    local r = ReplicatedStorage:FindFirstChild("Remotes")
                    local g = r and r:FindFirstChild("Generator")
                    repairRemote = g and g:FindFirstChild("RepairEvent")
                    skillRemote = g and g:FindFirstChild("SkillCheckResultEvent")
                end
                
               
                if tick() - lastScan > 2 then
                    genPoints = {}
                    local m = Workspace:FindFirstChild("Map")
                    if m then
                        for _, v in ipairs(m:GetDescendants()) do
                            if v:IsA("Model") and v.Name == "Generator" then
                                for _, c in ipairs(v:GetChildren()) do
                                    if c.Name:match("GeneratorPoint") then
                                        table.insert(genPoints, {gen = v, pt = c})
                                    end
                                end
                            end
                        end
                    end
                    lastScan = tick()
                end
                
              
                if repairRemote and skillRemote then
                    local mode = Config.AUTO_GenMode == "Fast"
                    for _, data in ipairs(genPoints) do
                        pcall(repairRemote.FireServer, repairRemote, data.pt, true)
                        pcall(skillRemote.FireServer, skillRemote, mode and "success" or "neutral", mode and 1 or 0, data.gen, data.pt)
                    end
                end
            end
            task.wait(0.15)
        end
    end)
    
    Connections.PlayerLeft = Players.PlayerRemoving:Connect(function(player)
        if ESP.cache[player] then
            ESP.hide(ESP.cache[player])
            ESP.destroy(ESP.cache[player])
            ESP.cache[player] = nil
        end
        if player.Character then
            Chams.Remove(player.Character)
        end
        Cache.Visibility[player] = nil
    end)
    
    Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(1)
            ScanMap()
        end)
    end)
end

Init()
