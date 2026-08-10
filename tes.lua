-- LOAD LIB
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- =======================================
Library.Scheme.AccentColor     = Color3.fromRGB(90, 120, 210)
Library.Scheme.BackgroundColor = Color3.fromRGB(15, 15, 20)
Library.Scheme.MainColor       = Color3.fromRGB(55, 60, 80)
Library.Scheme.OutlineColor    = Color3.fromRGB(70, 85, 130)
Library.Scheme.FontColor       = Color3.fromRGB(200, 215, 255)

-- =======================================
-- SERVICES
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local Workspace      = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting       = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats          = game:GetService("Stats")
local TweenService   = game:GetService("TweenService")
local StarterGui     = game:GetService("StarterGui")

local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")
local Camera       = workspace.CurrentCamera
local Terrain      = Workspace:FindFirstChildOfClass("Terrain")

local AttackEvent
local SkillCheckRemote
pcall(function()
    AttackEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack", 5)
end)
pcall(function()
    SkillCheckRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent", 5)
end)

-- =======================================
-- FULLBRIGHT SYSTEM (RINGAN)
-- =======================================

local FULLBRIGHT_CONFIG = {
    Enabled = false
}

local function ApplyFullbright()
    if not FULLBRIGHT_CONFIG.Enabled then
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        return
    end
    
    Lighting.Ambient = Color3.fromRGB(120, 120, 120)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    Lighting.Brightness = 1.6
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.FogStart = 9e9
    Lighting.FogEnd = 9e9
end

-- =======================================
-- NO FOG SYSTEM (BARU)
-- =======================================

local NoFog = {
    Enabled = false
}

local function ApplyNoFog()
    if not NoFog.Enabled then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.fromRGB(127, 127, 127)
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0.4
            atmosphere.Haze = 0
        end
        return
    end
    
    Lighting.FogStart = 9e9
    Lighting.FogEnd = 9e9
    Lighting.FogColor = Color3.fromRGB(0, 0, 0)
    
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        atmosphere.Density = 0
        atmosphere.Haze = 0
        atmosphere.Offset = 0
    end
    
    for _, child in pairs(Lighting:GetDescendants()) do
        if child:IsA("ParticleEmitter") or child:IsA("Smoke") or child:IsA("Fire") then
            pcall(function() child.Enabled = false end)
        end
    end
end

-- =======================================
-- FUNGSI NEXT KILLER
-- =======================================

local function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    
    local child = obj:FindFirstChild(name)
    if child then
        local success, val = pcall(function() return child.Value end)
        if success then return val end
    end
    return nil
end

-- =======================================
-- MAPPING NAMA KILLER
-- =======================================
local KillerNames = {
    ["Slasher"] = "The Jason",
    ["Stalker"] = "The Michael Myers",
    ["Masked"] = "The Jacket",
    ["Killer"] = "The Jeff",
    ["Hidden"] = "The Hidden",
    ["Abysswalker"] = "The Abysswalker",
    ["Veil"] = "The Veil",
    ["Cure"] = "The Cure",
}

local function GetKillerName(player)
    if not player then return "Unknown" end
    
    local selected = GetGameValue(player, "SelectedKiller")
    if selected and selected ~= "" then
        local name = tostring(selected)
        if KillerNames[name] then
            return KillerNames[name]
        end
        return name
    end
    
    local mask = GetGameValue(player, "Mask") or GetGameValue(player.Character, "Mask")
    if mask and mask ~= "" then
        local name = tostring(mask)
        if KillerNames[name] then
            return KillerNames[name] .. " (Masked)"
        end
        return name .. " (Masked)"
    end
    
    return player.Name
end

-- ============== CONFIG TABLES =================

local ESP = {
    Survivor  = false,
    Killer    = false,
    Generator = false,
    Pallet    = false,
    Window    = false,
    SCP       = false,
    Distance  = 100
}

local ESPStatus = {
    Enabled      = false,
    ShowName     = true,
    ShowDistance = true,
    ShowHealth   = false,
    ShowItem     = true,
    Radius       = 100
}

local ESPItems = {
    ["Twist of Fate"]   = true,
    ["Bandage"]         = true,
    ["Motion Tracker"]  = true,
    ["Gate"]            = true,
    ["Shadow Clone"]    = true,
    ["Parrying Dagger"] = true
}

local TeamColors = {
    Killer   = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120)
}

local Auto = {
    SkillCheck       = false,
    Parry            = false,
    ParryDelay       = 0,
    ParryCooldown    = 1,
    ParryDistance    = 15,
    FaceSensitivity  = 0.7,
    RequireFacing    = false
}

local Moonwalk = {
    Enabled   = false,
    ShowButton = false,
    SpamSpeed = 30,
    Intensity = 35,
    SlowSpeed = 13,
    UseSlow   = true
}

local FakeParry = {
    Enabled   = false,
    Animation = "Parry",
    Keybind   = Enum.KeyCode.V
}

local FakeParryAnimations = {
    Enten     = "rbxassetid://127096285501517",
    Stopwatch = "rbxassetid://81793464499285"
}

local AutoFlee = {
    Enabled        = false,
    DetectDistance = 50,
    Cooldown       = 0.1
}

local GunAim = {
    Enabled         = false,
    Holding         = false,
    TargetMode      = "Killer",
    Strength        = 1,
    Predict         = true,
    PredictStrength = 0.12,
    FOV             = 250,
    VisibilityCheck = true,
    Target          = nil,
    AimPart         = "HumanoidRootPart"
}

local AttackAim = {
    Enabled         = false,
    Holding         = false,
    Strength        = 1,
    Predict         = true,
    PredictStrength = 0.12,
    FOV             = 250,
    VisibilityCheck = true,
    AimPart         = "HumanoidRootPart"
}

local SpearAim = {
    Enabled = false,
    Gravity = 50,
    Speed   = 100,
    FOV     = 250,
    AimPart = "HumanoidRootPart"
}

local SilentAim = {
    Enabled    = false,
    Range      = 0,
    TargetMode = "Killer"
}

-- =======================================
-- SILENT AIM VEIL (BARU)
-- =======================================
local SilentAimVeil = {
    Enabled = false,
    TargetMode = "Survivor",
    FOV = 250,
    AimPart = "HumanoidRootPart",
    Predict = false,
    PredictStrength = 0.15
}

-- =======================================

local Killer = {
    KillAll   = false,
    KillRange = 500
}

local Masked = {
    Enabled      = false,
    CurrentPower = "Cobra"
}

local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

local CameraZoom = {
    UnlimitedZoom = false,
    MaxDistance   = 1000,
    MinDistance   = 0,
    FOVEnabled    = false,
    FOV           = 70,
    DefaultFOV    = workspace.CurrentCamera.FieldOfView
}

local AutoStalk = {
    Enabled    = false,
    StalkRange = 150,
    Target     = nil
}

local PlayerMods = {
    GodMode = false
}

local Movement = {
    WalkSpeedEnabled  = false,
    WalkSpeedValue    = 17.6,
    OriginalWalkSpeed = 16,
    NoClip            = false
}

local AvatarStealer = {
    Enabled              = true,
    TargetUsername       = "",
    OriginalDescription  = nil,
    CurrentStealedUserId = nil,
    BlockyBody           = true
}

local FastVault = {
    Enabled    = false,
    Speed      = 1.2,
    ReplaceMap = {
        ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779"
    }
}

local ParryRangeVisual = {
    Enabled      = false,
    Color        = Color3.fromRGB(255, 80, 80),
    Transparency = 0.9
}

local Crosshair = {
    Enabled   = false,
    Size      = 8,
    Thickness = 2,
    Color     = Color3.fromRGB(255, 255, 255),
    Style     = "Plus",
    OffsetX   = 0,
    OffsetY   = 0
}

local Visual = {
    LowGraphics     = false,
    LowRender       = false,
    NoFog           = false,
    NoScreenEffects = false
}

local FPSLock = {
    Enabled = false,
    TargetFPS = 100
}

local Emote = {
    Selected = "Mannrobics"
}

local EmoteButton = {
    Show        = false,
    GuiInstance = nil
}

-- ============== GROUPED STATE / CONNECTIONS ==============

local Connections = {
    Moonwalk      = nil,
    WalkSpeed     = nil,
    NoClip        = nil,
    GunAim        = nil,
    AttackAim     = nil,
    Stalk         = nil,
    SkillHeartbeat = nil
}

local State = {
    MoonwalkButton      = nil,
    FakeParryButton     = nil,
    FakeParryTrack      = nil,
    ParryCircle         = nil,
    KillerTarget        = nil,
    GunAimButtonConn    = nil,
    CurrentGunButton    = nil,
    CurrentAttackButton = nil,
    busy                = false,
    ParryActive         = false,
    AttackAimMode       = "Normal",
    LastFlee            = 0,
    lastParry           = 0,
    FPS                 = 0,
    Frames              = 0,
    LastTick            = tick(),
    created             = false,
    LastCrosshairStyle  = nil,
    SilentAimCacheConn  = nil,
    SilentAimInputConn  = nil,
    SilentAimHook       = nil,
    SAcachedRedirect    = false,
    SAcachedDir         = nil,
    -- Untuk Silent Aim Veil
    VeilHook            = false,
    VeilHookOld         = nil,
    VeilRemote          = nil
}

local Timers = {
    lastESPUpdate    = 0,
    lastKillerUpdate = 0,
    lastGodMode      = 0
}

local ESPCache = {
    Objects    = {},
    Status     = {},
    SCP        = {},
    Generators = {},
    Windows    = {},
    Pallets    = {}
}

local LastOptimizationState = {
    LowGraphics = nil,
    LowRender   = nil,
    CleanSky    = nil
}

local KillerAnims = {
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"]  = true,
    ["rbxassetid://74968262036854"]  = true,
    ["rbxassetid://78432063483146"]  = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"]  = true,
    ["rbxassetid://98163597193511"]  = true,
    ["rbxassetid://82666958311998"]  = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://117070354890871"] = true,
    ["rbxassetid://106871536134254"] = true,
    ["rbxassetid://138720291317243"] = true,
    ["rbxassetid://121571390309073"] = true,
    ["rbxassetid://126626340093785"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://139830743437188"] = true,
    ["rbxassetid://104682704142865"] = true,
    ["rbxassetid://117070354890871"] = true,
    ["rbxassetid://115244153053858"] = true
}

local hookedKillers = {}
local VaultTracks   = {}
local CrosshairDrawings = {}
local DisabledEffects   = {}
local ScreenEffectTypes = {
    "ColorCorrectionEffect",
    "DepthOfFieldEffect",
    "BlurEffect",
    "SunRaysEffect",
    "BloomEffect"
}

local AttackPaths = {
    "Slasher-mob.Controls.attack",
    "Masked-mob.Controls.attack",
    "Killer-mob.Controls.attack"
}

local EmoteList = {
    "Mannrobics", "Arm Swing", "Schadenfreude", "Kyoufuu",
    "Backflip", "Griddy", "Friday Night", "Floating Rest",
    "OnePlays", "Quick Combo", "WarCry", "Wave"
}

local GeneratorColor = Color3.fromRGB(255, 170, 0)
local PalletColor    = Color3.fromRGB(74, 255, 181)
local WindowColor    = Color3.fromRGB(74, 255, 181)
local SCPColor       = Color3.fromRGB(255, 0, 0)

local PARRY_DEBOUNCE = 0.5
local TouchID        = 8822
local ActionPath     = "Survivor-mob.Controls.action.check"

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local EmoteRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EmoteHandler")

-- =======================================
-- FUNGSI VISUAL COMPATIBILITY
-- =======================================

local function applyVisual()
end

local function applyNoScreenEffects()
    if Visual.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then DisabledEffects[v] = v.Enabled; v.Enabled = false end
            end
        end
    else
        for obj, s in pairs(DisabledEffects) do
            if obj and obj.Parent then obj.Enabled = s end
        end
        DisabledEffects = {}
    end
end

local function applyOptimization()
    pcall(function()
        settings().Rendering.QualityLevel = Visual.LowGraphics
            and Enum.QualityLevel.Level01
            or Enum.QualityLevel.Automatic
    end)
end

-- =======================================
-- TOGGLE MENU
local function CreateFionzyVDToggleMenu(IconId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FionzyVDToggle"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainButton = Instance.new("TextButton")
    MainButton.Name = "ToggleButton"
    MainButton.Text = ""
    MainButton.AutoButtonColor = false
    MainButton.Size = UDim2.fromOffset(53, 53)
    MainButton.Position = UDim2.fromOffset(15, 120)
    MainButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainButton.BackgroundTransparency = 0.05
    MainButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = MainButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(70, 85, 130)
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = MainButton

    local Glow = Instance.new("UIStroke")
    Glow.Color = Color3.fromRGB(45, 75, 145)
    Glow.Thickness = 5
    Glow.Transparency = 0.7
    Glow.Parent = MainButton

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.fromScale(.8, .8)
    IconFrame.Position = UDim2.fromScale(.1, .1)
    IconFrame.BackgroundTransparency = 1
    IconFrame.Parent = MainButton

    local Icon = Library:GetCustomIcon(IconId)
    if Icon then
        local Image = Instance.new("ImageLabel")
        Image.BackgroundTransparency = 1
        Image.Image = Icon.Url
        Image.ImageRectOffset = Icon.ImageRectOffset
        Image.ImageRectSize = Icon.ImageRectSize
        Image.Size = UDim2.fromScale(1, 1)
        Image.Parent = IconFrame
    end

    local TweenService = game:GetService("TweenService")

    MainButton.MouseEnter:Connect(function()
        TweenService:Create(MainButton, TweenInfo.new(.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}):Play()
    end)

    MainButton.MouseLeave:Connect(function()
        TweenService:Create(MainButton, TweenInfo.new(.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 22)}):Play()
    end)

    MainButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainButton, TweenInfo.new(.08), {Size = UDim2.fromOffset(40, 40)}):Play()
        task.wait(.08)
        TweenService:Create(MainButton, TweenInfo.new(.08), {Size = UDim2.fromOffset(53, 53)}):Play()
        Library:Toggle()
    end)

    Library:MakeDraggable(MainButton, MainButton, true)
    return MainButton, ScreenGui
end

CreateFionzyVDToggleMenu(101853760583071)

-- =======================================
-- WINDOW
local Window = Library:CreateWindow({
    Title            = "PREMIUM",
    Footer           = "NEXT KILLER : Loading...",
    Icon             = 101853760583071,
    IconSize         = UDim2.fromOffset(40, 40),
    CornerRadius     = 20,
    NotifySide       = "Right",
    ShowCustomCursor = true,
    ShowMobileButtons = false,
    ToggleKeybind    = Enum.KeyCode.LeftControl,
    Size             = UDim2.fromOffset(400, 300),
    EnableSidebarResize = false,
    EnableCompacting = true,
    SidebarCompacted = true,
})

-- TABS
local Tabs = {
    Info       = Window:AddTab("Info",        "info"),
    ESP        = Window:AddTab("ESP",         "eye"),
    Player     = Window:AddTab("Player",      "user"),
    Misc       = Window:AddTab("Misc",        "sliders-horizontal"),
    Visual     = Window:AddTab("Visual",      "sparkles"),
    UISettings = Window:AddTab("UI Settings", "settings-2")
}

-- GROUPBOXES
local InfoBox      = Tabs.Info:AddLeftGroupbox("Script Info", "info")
local CreditsBox   = Tabs.Info:AddRightGroupbox("Credits", "user")
local ESPBox       = Tabs.ESP:AddLeftGroupbox("ESP Cham", "scan-eye")
local ESPStatusBox = Tabs.ESP:AddRightGroupbox("ESP Status", "scan-eye")

local RightTabBox  = Tabs.Player:AddRightTabbox()
local AbilityTab   = RightTabBox:AddTab("Survivor", "user")
local KillerTab    = RightTabBox:AddTab("Killer", "skull")
local AimlockBox   = Tabs.Player:AddLeftGroupbox("AimBot", "crosshair")
local ParryBox     = Tabs.Player:AddLeftGroupbox("Parry", "swords")
local CrosshairBox = Tabs.Player:AddLeftGroupbox("Crosshair", "crosshair")
local MovementBox  = Tabs.Misc:AddLeftGroupbox("Movement", "move")
local EmoteBox     = Tabs.Misc:AddRightGroupbox("Emote", "music")
local VisualBox    = Tabs.Visual:AddLeftGroupbox("Graphics", "sun")
local MorphAvaBox  = Tabs.Visual:AddLeftGroupbox("Morph Avatar", "user")
local TimeBox      = Tabs.Visual:AddRightGroupbox("Clock & Ambient", "alarm-clock-check")
local ZoomBox      = Tabs.Visual:AddRightGroupbox("Zoom Out", "fullscreen")
local SettingBox   = Tabs.UISettings:AddLeftGroupbox("Menu", "wrench")

-- =======================================
-- SILENT AIM VEIL GROUPBOX (BARU)
-- =======================================
local VeilAimBox = Tabs.Killer:AddLeftGroupbox("Silent Aim Veil", "crosshair")

-- ============== HELPER =================

local function GetNil(Name, DebugId)
    if not getnilinstances then return nil end
    for _, Object in pairs(getnilinstances()) do
        if Object.Name == Name then
            if not DebugId or Object:GetDebugId() == DebugId then
                return Object
            end
        end
    end
end

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getAnimId(id)
    return tostring(id):match("%d+")
end

local function isDowned()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
end

local function shouldDisableWalkSpeed()
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim and anim.AnimationId then
                    if anim.AnimationId == "rbxassetid://127096285501517" then return true end
                    if anim.AnimationId == "rbxassetid://112166042383605" then return true end
                    if anim.AnimationId == "http://www.roblox.com/asset/?id=126965695851149" then return true end
                    if anim.AnimationId == "http://www.roblox.com/asset/?id=135084204086504" then return true end
                    if anim.AnimationId == "rbxassetid://123047897844134" then return true end
                    local id = anim.AnimationId:match("%d+")
                    if id and KillerAnims["rbxassetid://" .. id] then return true end
                end
            end
        end

        if hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true then
            return true
        end
    end
    return false
end

local function applyWalkSpeed()
    if Connections.WalkSpeed then
        Connections.WalkSpeed:Disconnect()
        Connections.WalkSpeed = nil
    end

    Connections.WalkSpeed = RunService.Heartbeat:Connect(function()
        if not Movement.WalkSpeedEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if shouldDisableWalkSpeed() then return end
        if hum.WalkSpeed ~= Movement.WalkSpeedValue then
            hum.WalkSpeed = Movement.WalkSpeedValue
        end
    end)
end

local function applyNoClip()
    local char = LocalPlayer.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = not Movement.NoClip
        end
    end
end

local function toggleNoClip(state)
    Movement.NoClip = state
    if state then
        if Connections.NoClip then Connections.NoClip:Disconnect() end
        Connections.NoClip = RunService.RenderStepped:Connect(function()
            if Movement.NoClip then applyNoClip() end
        end)
    else
        if Connections.NoClip then
            Connections.NoClip:Disconnect()
            Connections.NoClip = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end

local function applyGodMode()
    if not PlayerMods.GodMode then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.Health < hum.MaxHealth then
        pcall(function() hum.Health = hum.MaxHealth end)
    end
    local s = hum:GetState()
    if s == Enum.HumanoidStateType.Dead
    or s == Enum.HumanoidStateType.FallingDown
    or s == Enum.HumanoidStateType.Ragdoll then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

-- =======================================
-- TELEPORT FUNCTIONS
-- =======================================

local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        return false
    end
    
    local myRoot = getRoot()
    if not myRoot then
        return false
    end
    
    myRoot.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    return true
end

local function GetAllSurvivors()
    local survivors = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Team and plr.Team.Name == "Survivors" then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(survivors, plr)
            end
        end
    end
    return survivors
end

-- =======================================
-- REFRESH ESP
-- =======================================

local function RefreshESP()
    for obj, highlight in pairs(ESPCache.Objects) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
        ESPCache.Objects[obj] = nil
    end
    
    for char, billboard in pairs(ESPCache.Status) do
        if billboard and billboard.Parent then
            billboard:Destroy()
        end
        ESPCache.Status[char] = nil
    end
    
    for gen in pairs(ESPCache.Generators) do
        if gen then
            local old = gen:FindFirstChild("GenESP")
            if old then old:Destroy() end
            local h = gen:FindFirstChild("GenHighlight")
            if h then h:Destroy() end
        end
    end
end

-- ============= ESP SYSTEM ==============

for _, obj in ipairs(workspace:GetDescendants()) do
    if string.find(string.lower(obj.Name), "scp") then
        ESPCache.SCP[obj] = true
    end
end

workspace.DescendantAdded:Connect(function(obj)
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then ESPCache.SCP[obj] = true end
    if obj.Name == "Generator" then ESPCache.Generators[obj] = true
    elseif obj.Name == "Window" then ESPCache.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then ESPCache.Pallets[obj] = true
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    ESPCache.SCP[obj] = nil
    ESPCache.Generators[obj] = nil
    ESPCache.Windows[obj] = nil
    ESPCache.Pallets[obj] = nil
    if ESPCache.Objects[obj] then
        ESPCache.Objects[obj]:Destroy()
        ESPCache.Objects[obj] = nil
    end
end)

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj.Name == "Generator" then ESPCache.Generators[obj] = true
    elseif obj.Name == "Window" then ESPCache.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then ESPCache.Pallets[obj] = true
    end
end

local function removeESP(obj)
    if ESPCache.Objects[obj] then
        ESPCache.Objects[obj]:Destroy()
        ESPCache.Objects[obj] = nil
    end
end

local function createESP(obj, color)
    if not obj then return end
    if ESPCache.Objects[obj] then
        ESPCache.Objects[obj].FillColor = color
        ESPCache.Objects[obj].OutlineColor = color
        return
    end
    
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 1
    h.OutlineTransparency = 0.1
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    
    ESPCache.Objects[obj] = h
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

local function removeStatusESP(char)
    if ESPCache.Status[char] then
        ESPCache.Status[char]:Destroy()
        ESPCache.Status[char] = nil
    end
end

local function GetHeldItem(char)
    if not char then return nil end
    for _, obj in ipairs(char:GetChildren()) do
        if ESPItems[obj.Name] then return obj.Name end
        if obj:IsA("Tool") and ESPItems[obj.Name] then return obj.Name end
    end
    return nil
end

local function ApplyGenHighlight(object, color)
    local h = object:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = object
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = object
end

local function CreateBillboard(text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GenESP"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = billboard
    return billboard
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end
    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenESP")
    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = GeneratorColor:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
    local text = string.format("[%.0f%%]", percent)
    if not billboard then
        billboard = CreateBillboard(text, color)
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.Text = text; lbl.TextColor3 = color end
    end
    ApplyGenHighlight(generator, color)
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end
    local pos
    if obj:IsA("Model") then pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then pos = obj.Position end
    if not pos then return end
    local distance = (pos - root.Position).Magnitude
    if obj.Name == "Window" then
        if ESP.Window and distance <= ESP.Distance then createESP(obj, WindowColor)
        else removeESP(obj) end
    end
    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet and distance <= ESP.Distance then createESP(obj, PalletColor)
        else removeESP(obj) end
    end
end

local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char); return end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude
    if dist > ESPStatus.Radius then removeStatusESP(char); return end

    local text = ""
    if isDown then text = "🔻 DOWN\n" end
    if ESPStatus.ShowName then
        text = text .. player.Name
        if ESPStatus.ShowItem then
            local item = GetHeldItem(char)
            if item then text = text .. " [" .. item .. "]" end
        end
        text = text .. "\n"
    end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist : %.0f\n", dist) end
    if ESPStatus.ShowHealth    then text = text .. string.format("HP : %.0f\n", hum.Health) end
    if text == "" then removeStatusESP(char); return end

    local teamColor = Color3.new(1, 1, 1)
    if player.Team then
        if player.Team.Name == "Killer" then teamColor = TeamColors.Killer
        elseif player.Team.Name == "Survivors" then teamColor = TeamColors.Survivor end
    end
    if isDown then teamColor = Color3.fromRGB(255, 0, 0) end

    local billboard = ESPCache.Status[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Text = text
        label.Parent = billboard
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = char
        ESPCache.Status[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then label.Text = text; label.TextColor3 = teamColor end
    end
end

local function UpdateSCPEsp(root)
    if not ESP.SCP then
        for obj in pairs(ESPCache.SCP) do removeESP(obj) end
        return
    end
    for obj in pairs(ESPCache.SCP) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then pos = obj.Position end
            if pos then
                if (pos - root.Position).Magnitude <= ESP.Distance then
                    createESP(obj, SCPColor)
                else
                    removeESP(obj)
                end
            end
        end
    end
end

-- ===== SILENT AIM SYSTEM =====

local function GetHRP(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetSilentAimTarget()
    local myHRP = GetHRP(LocalPlayer.Character)
    if not myHRP then return nil end
    local closest, shortest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local validTeam = (SilentAim.TargetMode == "Killer"   and p.Team and p.Team.Name == "Killer")
                           or (SilentAim.TargetMode == "Survivor" and p.Team and p.Team.Name == "Survivors")
            if validTeam then
                local hrp = GetHRP(p.Character)
                if hrp then
                    local dist = (hrp.Position - myHRP.Position).Magnitude
                    if dist < shortest then shortest = dist; closest = hrp end
                end
            end
        end
    end
    if SilentAim.TargetMode == "SCP" then
        for obj in pairs(ESPCache.SCP) do
            if obj and obj.Parent then
                local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if part then
                    local dist = (part.Position - myHRP.Position).Magnitude
                    if dist < shortest then shortest = dist; closest = part end
                end
            end
        end
    end
    return closest
end

local function UpdateSilentAimCache()
    if not SilentAim.Enabled then
        State.SAcachedRedirect = false
        return
    end
    local myHRP    = GetHRP(LocalPlayer.Character)
    local targetPart = GetSilentAimTarget()
    if not myHRP or not targetPart then
        State.SAcachedRedirect = false
        return
    end
    local range = SilentAim.Range
    if range > 0 and (myHRP.Position - targetPart.Position).Magnitude > range then
        State.SAcachedRedirect = false
        return
    end
    State.SAcachedRedirect = true
    State.SAcachedDir = (targetPart.Position - myHRP.Position).Unit
end

local function StartSilentAimCache()
    if State.SilentAimCacheConn then return end
    State.SilentAimCacheConn = RunService.Heartbeat:Connect(UpdateSilentAimCache)
end

local function StopSilentAimCache()
    if State.SilentAimCacheConn then
        State.SilentAimCacheConn:Disconnect()
        State.SilentAimCacheConn = nil
    end
    State.SAcachedRedirect = false
    State.SAcachedDir = nil
end

local function HookTwistOfFate()
    if State.SilentAimHook then return end
    local ok, remote = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes", 5)
            :WaitForChild("Items", 5)
            :WaitForChild("Twist of Fate", 5)
            :WaitForChild("Fire", 5)
    end)
    if not ok or not remote then
        warn("[SilentAim] Remote Twist of Fate tidak ditemukan")
        return
    end
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self == remote
        and State.SAcachedRedirect and State.SAcachedDir then
            local args = {...}
            args[2] = State.SAcachedDir
            return oldNamecall(self, table.unpack(args, 1, 2))
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    State.SilentAimHook = oldNamecall
end

local function UnhookTwistOfFate()
    if not State.SilentAimHook then return end
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = State.SilentAimHook
    setreadonly(mt, true)
    State.SilentAimHook = nil
end

local function StartSilentAim()
    HookTwistOfFate()
    StartSilentAimCache()
    if State.SilentAimInputConn then return end
    State.SilentAimInputConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local char = LocalPlayer.Character
            if char then char:SetAttribute("Aiming", true) end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local char = LocalPlayer.Character
            if char then char:SetAttribute("Aiming", false) end
        end
    end)
end

local function StopSilentAim()
    UnhookTwistOfFate()
    StopSilentAimCache()
    if State.SilentAimInputConn then
        State.SilentAimInputConn:Disconnect()
        State.SilentAimInputConn = nil
    end
end

-- =======================================
-- SILENT AIM VEIL SYSTEM (BARU)
-- =======================================

local function GetVeilRemote()
    if State.VeilRemote and State.VeilRemote.Parent then return State.VeilRemote end
    
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    
    local killers = remotes:FindFirstChild("Killers")
    if not killers then return nil end
    
    local veil = killers:FindFirstChild("Veil")
    if not veil then return nil end
    
    local fireRemote = veil:FindFirstChild("FireVeil")
    if not fireRemote then
        for _, child in pairs(veil:GetChildren()) do
            if string.find(string.lower(child.Name), "fire") or string.find(string.lower(child.Name), "throw") then
                fireRemote = child
                break
            end
        end
    end
    
    State.VeilRemote = fireRemote
    return State.VeilRemote
end

local function GetVeilTarget()
    local myHRP = GetHRP(LocalPlayer.Character)
    if not myHRP then return nil end
    
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, SilentAimVeil.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local validTeam = (SilentAimVeil.TargetMode == "Survivor" and p.Team and p.Team.Name == "Survivors")
                           or (SilentAimVeil.TargetMode == "Killer" and p.Team and p.Team.Name == "Killer")
            if validTeam then
                local hrp = p.Character:FindFirstChild(SilentAimVeil.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

local function HookVeilRemote()
    local remote = GetVeilRemote()
    if not remote then
        warn("[SilentAimVeil] Remote tidak ditemukan")
        return false
    end
    
    local mt = getrawmetatable(game)
    if not mt then return false end
    
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self == remote and SilentAimVeil.Enabled then
            local target = GetVeilTarget()
            if target then
                local args = {...}
                local myRoot = GetHRP(LocalPlayer.Character)
                if myRoot then
                    local dir = (target.Position - myRoot.Position).Unit
                    if SilentAimVeil.Predict then
                        local vel = target.AssemblyLinearVelocity
                        dir = (target.Position + (vel * SilentAimVeil.PredictStrength) - myRoot.Position).Unit
                    end
                    if #args >= 1 then
                        args[1] = dir
                        return oldNamecall(self, table.unpack(args))
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    State.VeilHookOld = oldNamecall
    return true
end

local function StartSilentAimVeil()
    if State.VeilHook then return end
    
    local success = HookVeilRemote()
    if success then
        State.VeilHook = true
        Library:Notify({
            Time = 2,
            Title = "Silent Aim Veil",
            Description = "✅ Aktif!"
        })
    else
        Library:Notify({
            Time = 2,
            Title = "Silent Aim Veil",
            Description = "❌ Gagal hook remote"
        })
    end
end

local function StopSilentAimVeil()
    if not State.VeilHook then return end
    
    local mt = getrawmetatable(game)
    if mt and State.VeilHookOld then
        setreadonly(mt, false)
        mt.__namecall = State.VeilHookOld
        setreadonly(mt, true)
    end
    
    State.VeilHook = false
    State.VeilHookOld = nil
    
    Library:Notify({
        Time = 2,
        Title = "Silent Aim Veil",
        Description = "⛔ Nonaktif"
    })
end

-- ==========AUTO SYSTEM=================

local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team and plr.Team.Name == "Killer" and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < shortest then shortest = dist; closest = hrp end
            end
        end
    end
    return closest, shortest
end

local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, farthestDistance = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthestDistance then farthestDistance = dist; bestPoint = obj end
        end
    end
    return bestPoint
end

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local function GetParryButton()
    local current = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function GetAttackButtonForParry()
    for _, path in ipairs(AttackPaths) do
        local current = PlayerGui
        for segment in string.gmatch(path, "[^%.]+") do
            current = current and current:FindFirstChild(segment)
        end
        if current and current:IsA("GuiObject") then return current end
    end
    return nil
end

local function GetGunAimButton()
    local current = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function GetAttackAimButton()
    for _, path in ipairs(AttackPaths) do
        local current = PlayerGui
        for segment in string.gmatch(path, "[^%.]+") do
            current = current and current:FindFirstChild(segment)
        end
        if current and current:IsA("GuiObject") then return current end
    end
    return nil
end

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos  = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        end
    else
        pressRightClick()
    end
end

local function PlayFakeParry()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
    if State.FakeParryTrack then State.FakeParryTrack:Stop(); State.FakeParryTrack = nil end
    local anim = Instance.new("Animation")
    anim.AnimationId = FakeParryAnimations[FakeParry.Animation]
    State.FakeParryTrack = animator:LoadAnimation(anim)
    State.FakeParryTrack.Priority = Enum.AnimationPriority.Action
    State.FakeParryTrack:Play()
end

local function doParry()
    local now = tick()
    if now - State.lastParry < PARRY_DEBOUNCE then return end
    State.lastParry = now
    State.ParryActive = true
    
    task.spawn(function()
        pressParryButton()
    end)
    
    task.delay(0.3, function() State.ParryActive = false end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= Auto.ParryDistance
end

local function isFacingTarget(targetChar)
    if not Auto.RequireFacing then return true end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myRoot    = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local enemyForward  = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    if Auto.FaceSensitivity <= -1 then return true end
    return dot >= Auto.FaceSensitivity
end

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not Auto.Parry then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        if KillerAnims["rbxassetid://" .. id] then
            if not isInParryRange(char) then return end
            if not isFacingTarget(char) then return end
            doParry()
        end
    end)
end

local function isVisible(part)
    RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local cam = workspace.CurrentCamera
    local origin = cam.CFrame.Position
    local direction = part.Position - origin
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestGunTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, GunAim.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = (GunAim.TargetMode == "Killer" and p.Team.Name == "Killer")
                       or (GunAim.TargetMode == "Survivor" and p.Team.Name == "Survivors")
            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            if GunAim.VisibilityCheck and not isVisible(hrp) then continue end
                            shortest = dist; closest = hrp
                        end
                    end
                end
            end
        end
    end

    if GunAim.TargetMode == "SCP" then
        for obj in pairs(ESPCache.SCP) do
            if obj and obj.Parent then
                local part
                if obj:IsA("Model") then part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                elseif obj:IsA("BasePart") then part = obj end
                if part then
                    local pos, visible = cam:WorldToViewportPoint(part.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then shortest = dist; closest = part end
                    end
                end
            end
        end
    end

    return closest
end

local function getClosestAttackTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, AttackAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local hrp = p.Character:FindFirstChild(AttackAim.AimPart)
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then shortest = dist; closest = hrp end
                end
            end
        end
    end
    return closest
end

local function SpearAimbotCalc(targetPos)
    local root = getRoot()
    if not root then return nil end
    local startPos = root.Position + Vector3.new(0, 2, 0)
    local distance = (targetPos - startPos).Magnitude
    local time     = distance / SpearAim.Speed
    local drop     = 0.5 * SpearAim.Gravity * time * time
    return targetPos + Vector3.new(0, drop, 0)
end

local function getClosestSpearTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, SpearAim.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local hrp = p.Character:FindFirstChild(SpearAim.AimPart)
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then shortest = dist; closest = hrp end
                end
            end
        end
    end
    return closest
end

local function startGunAim()
    if Connections.GunAim then return end
    Connections.GunAim = RunService.RenderStepped:Connect(function()
        if not GunAim.Enabled then GunAim.Target = nil; return end
        if not GunAim.Holding then GunAim.Target = nil; return end
        local cam    = workspace.CurrentCamera
        local target = getClosestGunTarget()
        if not target then return end
        local pos = target.Position
        if GunAim.Predict then pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength) end
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), GunAim.Strength)
    end)
end

local function startAttackAim()
    if Connections.AttackAim then return end
    Connections.AttackAim = RunService.RenderStepped:Connect(function()
        if not AttackAim.Enabled then return end
        if not AttackAim.Holding then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        if State.AttackAimMode == "Spear" then
            local target = getClosestSpearTarget()
            if not target then return end
            local aimPos = SpearAimbotCalc(target.Position)
            if not aimPos then return end
            cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos)
        else
            local target = getClosestAttackTarget()
            if not target then return end
            local pos = target.Position
            if AttackAim.Predict then pos = pos + (target.AssemblyLinearVelocity * AttackAim.PredictStrength) end
            cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true; AttackAim.Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false; AttackAim.Holding = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if FakeParry.Enabled and input.KeyCode == FakeParry.Keybind then
        PlayFakeParry()
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        local btn = GetGunAimButton()
        if not btn then State.CurrentGunButton = nil; continue end
        if btn ~= State.CurrentGunButton then
            State.CurrentGunButton = btn
            if State.GunAimButtonConn then State.GunAimButtonConn:Disconnect(); State.GunAimButtonConn = nil end
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    GunAim.Holding = true
                end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    GunAim.Holding = false
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        local btn = GetAttackAimButton()
        if btn and btn ~= State.CurrentAttackButton then
            State.CurrentAttackButton = btn
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then AttackAim.Holding = true end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then AttackAim.Holding = false end
            end)
        end
    end
end)

-- MOONWALK
local function startMoonwalk()
    if Connections.Moonwalk then Connections.Moonwalk:Disconnect(); Connections.Moonwalk = nil end
    Connections.Moonwalk = RunService.RenderStepped:Connect(function()
        if not Moonwalk.Enabled or State.ParryActive or isDowned() then return end
        local char = LocalPlayer.Character
        if not char or not char.Parent then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not humanoid or not hrp or not cam then return end
        if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
            humanoid.WalkSpeed = Moonwalk.SlowSpeed
        end
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
            local baseCF = CFrame.new(hrp.Position, hrp.Position + flatLook)
            local angle  = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
            hrp.CFrame   = baseCF * CFrame.Angles(0, math.rad(angle), 0)
            humanoid:Move(Vector3.new(0, 0, 1), true)
        end
    end)
end

local function createMoonwalkButton()
    if not PlayerGui or not PlayerGui.Parent then return end
    if State.MoonwalkButton then State.MoonwalkButton:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"; gui.ResetOnSpawn = false; gui.Parent = PlayerGui
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 53, 0, 53)
    btn.Position = UDim2.new(0.67, 0, 0.77, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://101853760583071"
    btn.ImageTransparency = 0.1
    btn.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1,0); corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.8
    stroke.Parent = btn
    btn.MouseButton1Click:Connect(function()
        Moonwalk.Enabled = not Moonwalk.Enabled
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(170, 0, 255)
            if not Connections.Moonwalk then startMoonwalk() end
        else
            stroke.Color = Color3.fromRGB(255, 255, 255)
            if hum then
                hum.WalkSpeed = Movement.WalkSpeedEnabled and Movement.WalkSpeedValue or 16
            end
        end
    end)
    State.MoonwalkButton = gui
end

local function removeMoonwalkButton()
    if State.MoonwalkButton then State.MoonwalkButton:Destroy(); State.MoonwalkButton = nil end
end

local function CreateFakeParryButton()
    if State.FakeParryButton then State.FakeParryButton:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "FakeParryGui"; gui.ResetOnSpawn = false; gui.Parent = PlayerGui
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.65, 0, 0.60, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://73705354917255"
    btn.ImageTransparency = 0.1
    btn.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1,0); corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.8
    stroke.Parent = btn
    btn.MouseButton1Click:Connect(function()
        if FakeParry.Enabled then PlayFakeParry() end
    end)
    State.FakeParryButton = gui
end

local function RemoveFakeParryButton()
    if State.FakeParryButton then State.FakeParryButton:Destroy(); State.FakeParryButton = nil end
end

-- AUTO SKILL CHECK
local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function GetActionTarget()
    local current = PlayerGui
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s = b.AbsolutePosition, b.AbsoluteSize
        local i = game:GetService("GuiService"):GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

local function startSkillCheck()
    if Connections.SkillHeartbeat then Connections.SkillHeartbeat:Disconnect() end
    Connections.SkillHeartbeat = RunService.RenderStepped:Connect(function()
        if not Auto.SkillCheck or State.busy then return end
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end
        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
        local startRange = (gr + 108) % 360
        local endRange   = (gr + 120) % 360
        local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
                     or (lr >= startRange and lr <= endRange)
        if success then
            State.busy = true
            task.spawn(function()
                if UserInputService.TouchEnabled then TriggerMobileButton()
                else pressSpace() end
                task.wait(0.03)
                State.busy = false
            end)
        end
    end)
end

-- AUTO STALK
local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AutoStalk.StalkRange and dist < shortest then
                    shortest = dist; closest = plr
                end
            end
        end
    end
    return closest
end

local function startAutoStalk()
    if Connections.Stalk then return end
    Connections.Stalk = RunService.Heartbeat:Connect(function()
        if not AutoStalk.Enabled then return end
        local target = getClosestSurvivorForStalk()
        if not target or not target.Character then return end
        local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
            and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
        if stalkEvent then pcall(function() stalkEvent:FireServer(target) end) end
    end)
end

local function stopAutoStalk()
    if Connections.Stalk then Connections.Stalk:Disconnect(); Connections.Stalk = nil end
end

-- AUTO FLEE
task.spawn(function()
    while task.wait(0.2) do
        if not AutoFlee.Enabled then continue end
        local root = getRoot()
        if not root then continue end
        local killerRoot, distance = GetNearestKiller()
        if killerRoot and distance <= AutoFlee.DetectDistance
        and tick() - State.LastFlee > AutoFlee.Cooldown then
            local point = GetFarthestGeneratorPoint(killerRoot)
            if point then
                State.LastFlee = tick()
                root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end)

local function GetNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d; closest = plr.Character end
            end
        end
    end
    return closest
end

local function applyUnlimitedZoom()
    if CameraZoom.UnlimitedZoom then
        LocalPlayer.CameraMaxZoomDistance = CameraZoom.MaxDistance
        LocalPlayer.CameraMinZoomDistance = CameraZoom.MinDistance
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end

local function applyCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    cam.FieldOfView = CameraZoom.FOVEnabled and CameraZoom.FOV or CameraZoom.DefaultFOV
end

local function setFPSLimit(limit)
    if limit <= 0 then
        pcall(function() settings().Rendering.FPSCap = 0 end)
        pcall(function() setfpscap(9999) end)
        pcall(function() game:GetService("RunService"):SetFPSCap(0) end)
        pcall(function()
            local gs = UserSettings():GetService("UserGameSettings")
            gs.FrameRateManager = 0
        end)
        return
    end

    pcall(function() settings().Rendering.FPSCap = limit end)
    pcall(function() setfpscap(limit) end)
    pcall(function() game:GetService("RunService"):SetFPSCap(limit) end)
    pcall(function()
        local gs = UserSettings():GetService("UserGameSettings")
        gs.FrameRateManager = limit
    end)
end

-- AVATAR STEALER
local function saveOriginalAppearance()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then AvatarStealer.OriginalDescription = hum:GetAppliedDescription() end
end

local function applyBlockyBody(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local desc = Instance.new("HumanoidDescription")
    desc.BodyTypeScale = 1; desc.DepthScale = 1; desc.HeadScale = 1
    desc.HeightScale = 1; desc.ProportionScale = 0; desc.WidthScale = 1
    hum:ApplyDescriptionClientServer(desc)
end

local function removeAllClothingAndAccessories(character)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Clothing")
        or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
end

local function copyAvatar(username)
    if not username or username == "" then return end
    saveOriginalAppearance()
    local success, userId = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if not success then return end
    AvatarStealer.CurrentStealedUserId = userId
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)
        if AvatarStealer.BlockyBody then applyBlockyBody(char); task.wait(0.3) end
        removeAllClothingAndAccessories(char); task.wait(0.2)
        hum:ApplyDescriptionClientServer(desc)
    end)
end

local function resetAvatar()
    if not AvatarStealer.OriginalDescription then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        removeAllClothingAndAccessories(char)
        hum:ApplyDescriptionClientServer(AvatarStealer.OriginalDescription)
        AvatarStealer.CurrentStealedUserId = nil
    end
end

local function teleportToFinishLine()
    local root = getRoot()
    if not root then return end
    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
            found = obj; break
        end
    end
    if not found then warn("fininshline not found"); return end
    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
end

-- CROSSHAIR
local function clearCrosshair()
    for _, v in pairs(CrosshairDrawings) do if v.Remove then v:Remove() end end
    CrosshairDrawings = {}
end

local function drawCrosshair()
    if not Crosshair.Enabled then
        for _, v in pairs(CrosshairDrawings) do if v then v.Visible = false end end
        return
    end
    if State.LastCrosshairStyle ~= Crosshair.Style then
        clearCrosshair(); State.created = false
        State.LastCrosshairStyle = Crosshair.Style
    end
    local cam = workspace.CurrentCamera
    local center = Vector2.new(
        cam.ViewportSize.X / 2 + Crosshair.OffsetX,
        cam.ViewportSize.Y / 2 + Crosshair.OffsetY
    )
    if not State.created then
        State.created = true
        if Crosshair.Style == "Plus" then
            for i = 1, 4 do
                local line = Drawing.new("Line"); line.Visible = true
                table.insert(CrosshairDrawings, line)
            end
        elseif Crosshair.Style == "Dot" then
            local dot = Drawing.new("Circle"); dot.Filled = true; dot.Visible = true
            table.insert(CrosshairDrawings, dot)
        elseif Crosshair.Style == "Circle" then
            local circle = Drawing.new("Circle"); circle.Filled = false; circle.Visible = true
            table.insert(CrosshairDrawings, circle)
        end
    end
    if Crosshair.Style == "Plus" then
        for _, line in pairs(CrosshairDrawings) do line.Color = Crosshair.Color; line.Thickness = Crosshair.Thickness end
        CrosshairDrawings[1].From = center + Vector2.new(-Crosshair.Size, 0); CrosshairDrawings[1].To = center + Vector2.new(-2, 0)
        CrosshairDrawings[2].From = center + Vector2.new(Crosshair.Size, 0);  CrosshairDrawings[2].To = center + Vector2.new(2, 0)
        CrosshairDrawings[3].From = center + Vector2.new(0, -Crosshair.Size); CrosshairDrawings[3].To = center + Vector2.new(0, -2)
        CrosshairDrawings[4].From = center + Vector2.new(0, Crosshair.Size);  CrosshairDrawings[4].To = center + Vector2.new(0, 2)
    elseif Crosshair.Style == "Dot" then
        local dot = CrosshairDrawings[1]
        dot.Position = center; dot.Radius = Crosshair.Size / 2; dot.Color = Crosshair.Color
    elseif Crosshair.Style == "Circle" then
        local circle = CrosshairDrawings[1]
        circle.Position = center; circle.Radius = Crosshair.Size
        circle.Color = Crosshair.Color; circle.Thickness = Crosshair.Thickness
    end
end

local function updateParryCircle()
    local root = getRoot()
    if not ParryRangeVisual.Enabled or not root then
        if State.ParryCircle then State.ParryCircle:Destroy(); State.ParryCircle = nil end
        return
    end
    if not State.ParryCircle then
        State.ParryCircle = Instance.new("Part")
        State.ParryCircle.Shape = Enum.PartType.Cylinder
        State.ParryCircle.Anchored = true
        State.ParryCircle.CanCollide = false
        State.ParryCircle.Material = Enum.Material.Neon
        State.ParryCircle.Name = "ParryRangeCircle"
        State.ParryCircle.Parent = workspace
    end
    local size    = Auto.ParryDistance * 2
    local yOffset = root.Size.Y / 2 + 1.5
    State.ParryCircle.Size  = Vector3.new(0.2, size, size)
    State.ParryCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, yOffset, 0)) * CFrame.Angles(0, 0, math.rad(90))
    State.ParryCircle.Color  = ParryRangeVisual.Color
    State.ParryCircle.Transparency = ParryRangeVisual.Transparency
end

-- EMOTE
local function playEmote(name)
    pcall(function() EmoteRemote:FireServer(name) end)
end

local function createEmoteButton()
    if EmoteButton.GuiInstance then EmoteButton.GuiInstance:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "EmoteButtonGui"; gui.ResetOnSpawn = false; gui.Parent = PlayerGui
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0,50,0,50); btn.Position = UDim2.new(0.55,0,0.75,0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255); btn.BackgroundTransparency = 0.9
    btn.Image = "rbxassetid://101853760583071"; btn.ImageTransparency = 0.1; btn.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1,0); corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2; stroke.Color = Color3.fromRGB(255,255,255); stroke.Transparency = 0.8; stroke.Parent = btn
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0,80,0,20); label.Position = UDim2.new(0.5,-40,-0.6,0)
    label.BackgroundTransparency = 1; label.Text = Emote.Selected
    label.TextColor3 = Color3.fromRGB(255,255,255); label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold; label.TextSize = 11; label.Parent = btn
    btn.MouseButton1Click:Connect(function()
        playEmote(Emote.Selected)
        stroke.Color = Color3.fromRGB(90,120,210)
        task.delay(0.3, function() stroke.Color = Color3.fromRGB(255,255,255) end)
    end)
    EmoteButton.GuiInstance = gui
    EmoteButton.LabelRef    = label
end

local function removeEmoteButton()
    if EmoteButton.GuiInstance then EmoteButton.GuiInstance:Destroy(); EmoteButton.GuiInstance = nil; EmoteButton.LabelRef = nil end
end

-- FAST VAULT
local function normalizeId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://" .. num)
end

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not FastVault.Enabled then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end
        local id = normalizeId(anim.AnimationId)
        if not id then return end
        local replaceId = FastVault.ReplaceMap[id]
        if not replaceId then return end
        if VaultTracks[track] then return end
        VaultTracks[track] = true
        track:Stop()
        local newAnim = Instance.new("Animation"); newAnim.AnimationId = replaceId
        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play(); newTrack:AdjustSpeed(FastVault.Speed)
        newTrack.Stopped:Connect(function() VaultTracks[track] = nil end)
    end)
end

-- CHARACTER EVENTS
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    applyWalkSpeed()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    if Movement.NoClip then task.wait(0.3); toggleNoClip(true) end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid"); task.wait(0.5)
    if State.ParryCircle then State.ParryCircle:Destroy(); State.ParryCircle = nil end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    GunAim.Target = nil; GunAim.Holding = false
    applyCameraFOV()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyUnlimitedZoom()
    hookVault(char)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if AvatarStealer.CurrentStealedUserId then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local desc = Players:GetHumanoidDescriptionFromUserId(AvatarStealer.CurrentStealedUserId)
            if AvatarStealer.BlockyBody then applyBlockyBody(char) end
            removeAllClothingAndAccessories(char)
            hum:ApplyDescriptionClientServer(desc)
        end
    end
end)

-- MAIN LOOPS
RunService.Heartbeat:Connect(function()
    local now = tick()

    if now - Timers.lastGodMode >= 0.1 then
        Timers.lastGodMode = now
        applyGodMode()
    end

    if now - Timers.lastKillerUpdate >= 0.05 then
        Timers.lastKillerUpdate = now

        if Killer.KillAll then
            local root = getRoot()
            if root then
                if not State.KillerTarget
                or not State.KillerTarget:FindFirstChild("Humanoid")
                or State.KillerTarget.Humanoid.Health <= 35 then
                    State.KillerTarget = GetNearestAliveSurvivor()
                end
                if State.KillerTarget then
                    local targetHRP = State.KillerTarget:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local velocity = targetHRP.AssemblyLinearVelocity
                        local predict  = velocity * 0.15
                        local targetPos = targetHRP.Position + predict
                        local behind    = targetHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                    end
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end

        if Movement.WalkSpeedEnabled then
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if shouldDisableWalkSpeed() then
                    if hum.WalkSpeed == Movement.WalkSpeedValue then
                        hum.WalkSpeed = Movement.OriginalWalkSpeed
                    end
                else
                    if hum.WalkSpeed ~= Movement.WalkSpeedValue then
                        hum.WalkSpeed = Movement.WalkSpeedValue
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local root = getRoot()
    if not root then return end
    local now = tick()

    if now - Timers.lastESPUpdate >= 0.05 then
        Timers.lastESPUpdate = now

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - root.Position).Magnitude
                        if distance <= ESP.Distance then
                            if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                                createESP(char, TeamColors.Survivor)
                            elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                                createESP(char, TeamColors.Killer)
                            else
                                removeESP(char)
                            end
                        else
                            removeESP(char)
                        end
                    end
                    createStatusESP(p, char, root)
                else
                    removeESP(char)
                end
            end
        end

        if ESP.Generator then
            for gen in pairs(ESPCache.Generators) do UpdateGenerator(gen) end
        end

        for obj in pairs(ESPCache.Windows) do UpdateMapESP(obj, root) end
        for obj in pairs(ESPCache.Pallets) do UpdateMapESP(obj, root) end

        UpdateSCPEsp(root)
        applyNoScreenEffects()
        updateParryCircle()
        
        -- No Fog di RenderStepped biar selalu apply
        if NoFog.Enabled then
            ApplyNoFog()
        end
    end

    drawCrosshair()
end)

RunService.RenderStepped:Connect(function()
    if CameraZoom.FOVEnabled then
        local cam = workspace.CurrentCamera
        if cam and cam.FieldOfView ~= CameraZoom.FOV then
            cam.FieldOfView = CameraZoom.FOV
        end
    end
end)

-- INIT
if LocalPlayer.Character then
    hookVault(LocalPlayer.Character)
    startGunAim()
end

task.spawn(function()
    while true do
        task.wait(0.8)
        if Auto.Parry then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                    hookKiller(p.Character)
                end
            end
        end
    end
end)

if Moonwalk.ShowButton then createMoonwalkButton() end

ApplyFullbright()
ApplyNoFog() -- Init No Fog

-- Init Silent Aim Veil
if SilentAimVeil.Enabled then
    StartSilentAimVeil()
end

-- ================= UI =================
InfoBox:AddLabel("Script: Premium")
InfoBox:AddLabel("Version: 2.1.0")
InfoBox:AddLabel("Game: Violence District")
InfoBox:AddLabel("Dev: •༶Fionzy-VD༶•")
InfoBox:AddLabel("Join discord for more info")
InfoBox:AddLabel("Discord:")
InfoBox:AddButton("Copy Discord Link", function()
    setclipboard("https://discord.gg/6gvB8RCwx")
end)

CreditsBox:AddLabel("Developer:")
CreditsBox:AddLabel("• Fionzy-VD")
CreditsBox:AddDivider()
CreditsBox:AddLabel("Library:")
CreditsBox:AddLabel("• Obsidian UI")
CreditsBox:AddDivider()
CreditsBox:AddLabel("Support the dev:")
CreditsBox:AddButton("Copy Support Link", function()
    setclipboard("https://sociabuzz.com/bilalaryaa/tribe")
end)

-- ESP UI
local SurvivorESP = ESPBox:AddCheckbox("SurvivorESP", {
    Text = "ESP Survivor", Default = false,
    Callback = function(v) ESP.Survivor = v end
})
SurvivorESP:AddColorPicker("SurvivorESPColor", {
    Default = TeamColors.Survivor, Title = "Survivor Color",
    Callback = function(color) TeamColors.Survivor = color end
})

local KillerESP = ESPBox:AddCheckbox("KillerESP", {
    Text = "ESP Killer", Default = false,
    Callback = function(v) ESP.Killer = v end
})
KillerESP:AddColorPicker("KillerESPColor", {
    Default = TeamColors.Killer, Title = "Killer Color",
    Callback = function(color) TeamColors.Killer = color end
})

local ESPGeneratorToggle = ESPBox:AddCheckbox("ESPGenerator", {
    Text = "Generator", Default = false,
    Callback = function(v) ESP.Generator = v end
})
ESPGeneratorToggle:AddColorPicker("GeneratorColor", {
    Default = GeneratorColor, Title = "Generator Color",
    Callback = function(v) GeneratorColor = v end
})

local ESPSCPToggle = ESPBox:AddCheckbox("ESPSCP", {
    Text = "SCP", Default = false,
    Callback = function(v) ESP.SCP = v end
})
ESPSCPToggle:AddColorPicker("SCPColor", {
    Default = SCPColor, Title = "SCP Color",
    Callback = function(v) SCPColor = v end
})

local ESPPalletToggle = ESPBox:AddCheckbox("ESPPallet", {
    Text = "Pallet", Default = false,
    Callback = function(v) ESP.Pallet = v end
})
ESPPalletToggle:AddColorPicker("PalletColor", {
    Default = PalletColor, Title = "Pallet Color",
    Callback = function(v) PalletColor = v end
})

local ESPWindowToggle = ESPBox:AddCheckbox("ESPWindow", {
    Text = "Window", Default = false,
    Callback = function(v) ESP.Window = v end
})
ESPWindowToggle:AddColorPicker("WindowColor", {
    Default = WindowColor, Title = "Window Color",
    Callback = function(v) WindowColor = v end
})

ESPBox:AddSlider("ESPDistance", {
    Text = "ESP Radius", Default = 100, Min = 10, Max = 1000, Rounding = 0,
    Callback = function(v) ESP.Distance = v end
})
ESPBox:AddButton({Text = "Refresh ESP", Func = function()
    RefreshESP()
end})
ESPStatusBox:AddCheckbox("EnableStatus", {
    Text = "Enable Status ESP", Default = false,
    Callback = function(v) ESPStatus.Enabled = v end
})
ESPStatusBox:AddCheckbox("ShowName", {
    Text = "Show Name", Default = true,
    Callback = function(v) ESPStatus.ShowName = v end
})
ESPStatusBox:AddCheckbox("ShowItemESP", {
    Text = "Show Item", Default = true,
    Callback = function(v) ESPStatus.ShowItem = v end
})
ESPStatusBox:AddCheckbox("ShowDistance", {
    Text = "Show Distance", Default = true,
    Callback = function(v) ESPStatus.ShowDistance = v end
})
ESPStatusBox:AddCheckbox("ShowHealth", {
    Text = "Show Health", Default = false,
    Callback = function(v) ESPStatus.ShowHealth = v end
})
ESPStatusBox:AddSlider("StatusRadius", {
    Text = "Status Radius", Default = 100, Min = 20, Max = 500, Rounding = 0,
    Callback = function(v) ESPStatus.Radius = v end
})

-- CROSSHAIR UI
local CrosshairToggle = CrosshairBox:AddCheckbox("CrosshairEnabled", {
    Text = "Enable Crosshair", Default = false,
    Callback = function(v) Crosshair.Enabled = v end
})
CrosshairToggle:AddColorPicker("CrosshairColor", {
    Default = Color3.fromRGB(255,255,255), Title = "Crosshair Color", Transparency = 0,
    Callback = function(color) Crosshair.Color = color end
})
CrosshairBox:AddDropdown("Style", {
    Values = {"Plus","Dot","Circle"}, Default = 1, Multi = false, Text = "Style",
    Callback = function(v) Crosshair.Style = v end
})
CrosshairBox:AddSlider("CrosshairPosX", {
    Text = "Position X", Default = 0, Min = -100, Max = 100, Rounding = 0,
    Callback = function(v) Crosshair.OffsetX = v end
})
CrosshairBox:AddSlider("CrosshairPosY", {
    Text = "Position Y", Default = 0, Min = -100, Max = 100, Rounding = 0,
    Callback = function(v) Crosshair.OffsetY = v end
})

-- =======================================
-- PLAYER UI (SURVIVOR TAB)
-- =======================================
AbilityTab:AddCheckbox("Skill", {
    Text = "Auto Skill Check", Default = false,
    Callback = function(v) Auto.SkillCheck = v; if v then startSkillCheck() end end
})
AbilityTab:AddCheckbox("AutoFleeKiller", {
    Text = "Auto Flee Killer", Default = false,
    Callback = function(v) AutoFlee.Enabled = v end
})
AbilityTab:AddCheckbox("GodMode", {
    Text = "Anti KnockDown", Default = false,
    Callback = function(v) PlayerMods.GodMode = v end
})
AbilityTab:AddCheckbox("FastVault", {
    Text = "Fast Vault", Default = false,
    Callback = function(v) FastVault.Enabled = v end
})
AbilityTab:AddSlider("VaultSpeed", {
    Text = "Animation Speed", Default = 1.2, Min = 1, Max = 5, Rounding = 1,
    Callback = function(v) FastVault.Speed = v end
})
AbilityTab:AddCheckbox("MoonwalkButton", {
    Text = "MoonwalkButton", Default = false,
    Callback = function(v)
        Moonwalk.ShowButton = v
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end
})
AbilityTab:AddLabel("Moonwalk Keybind"):AddKeyPicker("MoonwalkKey", {
    Default = "V", Mode = "Toggle", Text = "Moonwalk (pc)",
    Callback = function(state)
        Moonwalk.Enabled = state
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if state then
            startMoonwalk()
        else
            if Connections.Moonwalk then Connections.Moonwalk:Disconnect(); Connections.Moonwalk = nil end
            if hum then hum.WalkSpeed = Movement.WalkSpeedEnabled and Movement.WalkSpeedValue or 16 end
        end
    end
})
AbilityTab:AddSlider("MoonwalkSpamSpeed", {
    Text = "Spam Speed", Default = Moonwalk.SpamSpeed, Min = 1, Max = 50, Rounding = 0,
    Callback = function(v) Moonwalk.SpamSpeed = v end
})
AbilityTab:AddSlider("MoonwalkIntensity", {
    Text = "Intensity", Default = Moonwalk.Intensity, Min = 1, Max = 50, Rounding = 1,
    Callback = function(v) Moonwalk.Intensity = v end
})
AbilityTab:AddDivider()
AbilityTab:AddButton({Text = "Instan Escape", Func = function() teleportToFinishLine() end})


-- =======================================
-- KILLER TAB UI
-- =======================================
KillerTab:AddCheckbox("AutoStalk", {
    Text = "Auto Stalk (myers)", Default = false,
    Callback = function(v)
        AutoStalk.Enabled = v
        if v then startAutoStalk() else stopAutoStalk() end
    end
})
KillerTab:AddCheckbox("KillAll", {
    Text = "Auto Kill All", Default = false,
    Callback = function(v) Killer.KillAll = v end
})
KillerTab:AddCheckbox("AttackAim", {
    Text = "AimLock Attack", Default = false,
    Callback = function(v) AttackAim.Enabled = v; if v then startAttackAim() end end
})
KillerTab:AddDropdown("AttackAimMode", {
    Text = "Aimlock Mode", Values = {"Normal","Spear"}, Default = 1, Multi = false,
    Callback = function(v) State.AttackAimMode = v end
})
KillerTab:AddSlider("SpearGravity", {
    Text = "Spear Gravity", Default = 50, Min = 10, Max = 200, Rounding = 0,
    Callback = function(v) SpearAim.Gravity = v end
})
KillerTab:AddSlider("SpearSpeed", {
    Text = "Spear Speed", Default = 100, Min = 20, Max = 300, Rounding = 0,
    Callback = function(v) SpearAim.Speed = v end
})
KillerTab:AddDivider()
KillerTab:AddDropdown("MaskedPowerSelect", {
    Text = "Select Power", Values = MaskedPowers, Default = 1, Multi = false,
    Callback = function(val) Masked.CurrentPower = val end
})
KillerTab:AddButton("Activate Power", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
    if Event then Event:FireServer(Masked.CurrentPower) end
end)
KillerTab:AddButton("Deactivate Power", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
    if Event then Event:FireServer() end
end)

-- =======================================
-- SILENT AIM VEIL UI (BARU)
-- =======================================
VeilAimBox:AddToggle("VeilSilentAimToggle", {
    Text = "Enable Silent Aim Veil",
    Default = false,
    Callback = function(v)
        SilentAimVeil.Enabled = v
        if v then
            StartSilentAimVeil()
        else
            StopSilentAimVeil()
        end
    end
})

VeilAimBox:AddDropdown("VeilTargetMode", {
    Text = "Target Mode",
    Values = {"Survivor", "Killer"},
    Default = 1,
    Callback = function(v)
        SilentAimVeil.TargetMode = v
    end
})

VeilAimBox:AddSlider("VeilFOVSlider", {
    Text = "FOV Radius",
    Default = 250,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        SilentAimVeil.FOV = v
    end
})

VeilAimBox:AddToggle("VeilPredict", {
    Text = "Auto Predict",
    Default = false,
    Callback = function(v)
        SilentAimVeil.Predict = v
    end
})

VeilAimBox:AddSlider("VeilPredictStrength", {
    Text = "Predict Strength",
    Default = 0.15,
    Min = 0,
    Max = 0.5,
    Rounding = 2,
    Callback = function(v)
        SilentAimVeil.PredictStrength = v
    end
})

-- =======================================
-- PARRY UI
-- =======================================
local AutoParryToggle = ParryBox:AddCheckbox("AutoParry", {
    Text = "Auto Parry", Default = false,
    Callback = function(v) Auto.Parry = v; ParryRangeVisual.Enabled = v end
})
AutoParryToggle:AddColorPicker("ParryRangeColor", {
    Default = Color3.fromRGB(255,80,80), Transparency = 0, Title = "Parry Range Color",
    Callback = function(color)
        ParryRangeVisual.Color = color
        if State.ParryCircle then State.ParryCircle.Color = color end
    end
})
ParryBox:AddCheckbox("ShowParryRange", {
    Text = "Show Parry Range", Default = true,
    Callback = function(v)
        ParryRangeVisual.Enabled = v
        if not v and State.ParryCircle then State.ParryCircle:Destroy(); State.ParryCircle = nil end
    end
})
ParryBox:AddSlider("ParryDistance", {
    Text = "Distance", Default = 15, Min = 5, Max = 20, Rounding = 0,
    Callback = function(v) Auto.ParryDistance = v end
})
ParryBox:AddSlider("FaceSensitivity", {
    Text = "Face Sensitivity Killer", Default = 0.7, Min = -1, Max = 1, Rounding = 2,
    Callback = function(v) Auto.FaceSensitivity = v end
})
local FakeParryToggle = ParryBox:AddToggle("FakeParry", {
    Text = "Enable Fake Parry", Default = false,
    Callback = function(v)
        FakeParry.Enabled = v
        if UserInputService.TouchEnabled then
            if v then CreateFakeParryButton() else RemoveFakeParryButton() end
        end
    end
})
FakeParryToggle:AddKeyPicker("FakeParryKeybind", {
    Default = "G", SyncToggleState = false, Mode = "Toggle", Text = "Fake Parry Key",
    Callback = function()
        if FakeParry.Enabled then PlayFakeParry() end
    end,
    ChangedCallback = function(New) FakeParry.Keybind = New end
})
ParryBox:AddDropdown("FakeParryAnim", {
    Text = "Animation", Values = {"Enten","Stopwatch"}, Default = 1,
    Callback = function(v) FakeParry.Animation = v end
})

-- =======================================
-- AIMLOCK UI
-- =======================================
AimlockBox:AddToggle("GunAimEnabled", {
    Text = "Aim Lock", Default = false,
    Callback = function(v) GunAim.Enabled = v end
})
AimlockBox:AddDropdown("GunAimTarget", {
    Values = {"Killer","Survivor","SCP"}, Default = 1, Text = "Target",
    Callback = function(v) GunAim.TargetMode = v end
})
AimlockBox:AddDropdown("GunAimPart", {
    Text = "Aim Part", Values = {"Head","HumanoidRootPart","Torso"}, Default = 2,
    Callback = function(v) GunAim.AimPart = v end
})
AimlockBox:AddSlider("GunAimFOV", {
    Text = "FOV", Default = 250, Min = 50, Max = 1000, Rounding = 0,
    Callback = function(v) GunAim.FOV = v end
})
AimlockBox:AddSlider("GunAimPredict", {
    Text = "Prediction", Default = 0.12, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) GunAim.PredictStrength = v end
})

AimlockBox:AddDivider()
AimlockBox:AddToggle("SilentAimToggle", {
    Text = "Silent Aim (TOF)", Default = false, Disabled = false,
    Callback = function(v)
        SilentAim.Enabled = v
        if v then StartSilentAim() else StopSilentAim() end
    end
})
AimlockBox:AddDropdown("SilentAimTarget", {
    Text = "Silent Aim Target", Values = {"Killer","Survivor","SCP"}, Default = 1, Disabled = false,
    Callback = function(v) SilentAim.TargetMode = v end
})

-- =======================================
-- MOVEMENT UI
-- =======================================
MovementBox:AddCheckbox("WalkSpeedToggle", {
    Text = "Walk Speed", Default = false,
    Callback = function(v)
        Movement.WalkSpeedEnabled = v
        if v then applyWalkSpeed()
        else
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Movement.OriginalWalkSpeed end
        end
    end
})
MovementBox:AddSlider("WalkSpeedSlider", {
    Text = "Walk Speed Value", Default = 17.6, Min = 16, Max = 32, Rounding = 1,
    Callback = function(v) Movement.WalkSpeedValue = v; if Movement.WalkSpeedEnabled then applyWalkSpeed() end end
})
MovementBox:AddCheckbox("NoClipToggle", {
    Text = "No Clip", Default = false,
    Callback = function(v) toggleNoClip(v) end
})

local TeleportBox = Tabs.Misc:AddLeftGroupbox("Teleport", "move")

local playerNames = {}
local function UpdatePlayerList()
    playerNames = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(playerNames, plr.Name)
            end
        end
    end
    if #playerNames == 0 then
        table.insert(playerNames, "No players available")
    end
end

UpdatePlayerList()

local TeleportDropdown = TeleportBox:AddDropdown("TeleportToPlayerDropdown", {
    Text = "Select Player",
    Values = playerNames,
    Default = 1,
    Multi = false,
    Callback = function(val)
        TeleportBox._selectedPlayer = val
    end
})

TeleportBox:AddButton({Text = "Teleport To Player", Func = function()
    local selectedName = TeleportBox._selectedPlayer
    if not selectedName or selectedName == "No players available" then
        return
    end
    local target = Players:FindFirstChild(selectedName)
    if target then
        TeleportToPlayer(target)
    end
end})

TeleportBox:AddButton({Text = "Refresh Player List", Func = function()
    UpdatePlayerList()
    local newValues = playerNames
    if #newValues == 0 then
        newValues = {"No players available"}
    end
    TeleportDropdown:SetValues(newValues)
end})

-- =======================================
-- EMOTE UI
-- =======================================
EmoteBox:AddDropdown("SelectEmote", {
    Values = EmoteList, Default = 1, Multi = false, Text = "Select Emote",
    Callback = function(v)
        Emote.Selected = v
        if EmoteButton.LabelRef then EmoteButton.LabelRef.Text = v end
    end
})
EmoteBox:AddButton({Text = "Play Emote", Func = function() playEmote(Emote.Selected) end})
EmoteBox:AddToggle("ShowEmoteButton", {
    Text = "Show Emote Button", Default = false,
    Callback = function(v)
        EmoteButton.Show = v
        if v then createEmoteButton() else removeEmoteButton() end
    end
})

-- =======================================
-- SPOOFING UI
-- =======================================
local SpoofGroup = Tabs.Misc:AddRightGroupbox("SPOOFING", "wrench")

local SpoofData = {
    Gears = 0,
    Screws = 0,
    Level = 0,
}

local OriginalData = {
    Gears = nil,
    Screws = nil,
    Level = nil,
}

SpoofGroup:AddInput("SpoofGears", {
    Text = "Custom Gears",
    Placeholder = "Jumlah Gears...",
    Default = "",
    Callback = function(val)
        SpoofData.Gears = tonumber(val) or 0
    end
})

SpoofGroup:AddInput("SpoofScrews", {
    Text = "Custom Screws",
    Placeholder = "Jumlah Screws...",
    Default = "",
    Callback = function(val)
        SpoofData.Screws = tonumber(val) or 0
    end
})

SpoofGroup:AddInput("SpoofLevel", {
    Text = "Custom Level",
    Placeholder = "Angka Level...",
    Default = "",
    Callback = function(val)
        SpoofData.Level = tonumber(val) or 0
    end
})

SpoofGroup:AddDivider()

SpoofGroup:AddButton({
    Text = "Apply Spoof Data",
    Func = function()
        local p = game.Players.LocalPlayer
        if not p then return end

        local function GetCurrentValue(targetName)
            local targetLower = string.lower(targetName)
            
            local attr = p:GetAttribute(targetName)
            if attr ~= nil then return attr end
            attr = p:GetAttribute(targetName.."s")
            if attr ~= nil then return attr end
            
            for _, obj in ipairs(p:GetDescendants()) do
                if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
                    local n = string.lower(obj.Name)
                    if string.find(n, targetLower) then
                        local ok, val = pcall(function() return obj.Value end)
                        if ok then return val end
                    end
                end
            end
            
            local pGui = p:FindFirstChild("PlayerGui")
            if pGui then
                for _, ui in ipairs(pGui:GetDescendants()) do
                    if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                        local uiName = string.lower(ui.Name)
                        if string.find(uiName, targetLower) then
                            local ok, val = pcall(function() return ui.Text end)
                            if ok then return tonumber(val) or 0 end
                        end
                    end
                end
            end
            return nil
        end

        if OriginalData.Gears == nil then
            OriginalData.Gears = GetCurrentValue("Gear") or 0
            OriginalData.Screws = GetCurrentValue("Screw") or 0
            OriginalData.Level = GetCurrentValue("Level") or 0
        end

        local function InjectValue(targetName, amount)
            if not amount or amount <= 0 then return end
            
            local targetLower = string.lower(targetName)
            
            pcall(function() p:SetAttribute(targetName, amount) end)
            pcall(function() p:SetAttribute(targetName.."s", amount) end)
            
            for _, obj in ipairs(p:GetDescendants()) do
                if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
                    local n = string.lower(obj.Name)
                    if string.find(n, targetLower) then
                        if obj:IsA("StringValue") then
                            pcall(function() obj.Value = tostring(amount) end)
                        else
                            pcall(function() obj.Value = amount end)
                        end
                    end
                end
            end
            
            local pGui = p:FindFirstChild("PlayerGui")
            if pGui then
                for _, ui in ipairs(pGui:GetDescendants()) do
                    if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                        local uiName = string.lower(ui.Name)
                        if string.find(uiName, targetLower) then
                            pcall(function() ui.Text = tostring(amount) end)
                        end
                    end
                end
            end
        end

        InjectValue("Gear", SpoofData.Gears)
        InjectValue("Screw", SpoofData.Screws)
        InjectValue("Level", SpoofData.Level)
    end
})

SpoofGroup:AddButton({
    Text = "Reset All Spoof",
    Func = function()
        local p = game.Players.LocalPlayer
        if not p then return end
        
        local function ResetToOriginal(targetName, originalValue)
            if originalValue == nil then return end
            
            local targetLower = string.lower(targetName)
            
            pcall(function() p:SetAttribute(targetName, originalValue) end)
            pcall(function() p:SetAttribute(targetName.."s", originalValue) end)
            
            for _, obj in ipairs(p:GetDescendants()) do
                if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
                    local n = string.lower(obj.Name)
                    if string.find(n, targetLower) then
                        if obj:IsA("StringValue") then
                            pcall(function() obj.Value = tostring(originalValue) end)
                        else
                            pcall(function() obj.Value = originalValue end)
                        end
                    end
                end
            end
            
            local pGui = p:FindFirstChild("PlayerGui")
            if pGui then
                for _, ui in ipairs(pGui:GetDescendants()) do
                    if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                        local uiName = string.lower(ui.Name)
                        if string.find(uiName, targetLower) then
                            pcall(function() ui.Text = tostring(originalValue) end)
                        end
                    end
                end
            end
        end

        ResetToOriginal("Gear", OriginalData.Gears)
        ResetToOriginal("Screw", OriginalData.Screws)
        ResetToOriginal("Level", OriginalData.Level)
        
        SpoofData.Gears = 0
        SpoofData.Screws = 0
        SpoofData.Level = 0
    end
})

-- =======================================
-- AVATAR STEALER UI
-- =======================================
MorphAvaBox:AddInput("StealUsername", {
    Text = "Target Username", Default = "", Placeholder = "Ketik username target...",
    Callback = function(val) AvatarStealer.TargetUsername = val end
})
MorphAvaBox:AddButton("Copy Avatar", function() copyAvatar(AvatarStealer.TargetUsername) end)
MorphAvaBox:AddButton("Reset to Original Skin", function() resetAvatar() end)
MorphAvaBox:AddButton("Save Current as Original", function() saveOriginalAppearance() end)

-- =======================================
-- VISUAL UI
-- =======================================
local FullbrightToggle = VisualBox:AddCheckbox("FullbrightToggle", {
    Text = "Fullbright", Default = false,
    Callback = function(v)
        FULLBRIGHT_CONFIG.Enabled = v
        ApplyFullbright()
    end
})

-- =======================================
-- NO FOG UI (BARU)
-- =======================================
VisualBox:AddCheckbox("NoFogToggle", {
    Text = "No Fog",
    Default = false,
    Callback = function(v)
        NoFog.Enabled = v
        ApplyNoFog()
        if v then
            Library:Notify({
                Time = 2,
                Title = "No Fog",
                Description = "Kabut dihilangkan!"
            })
        end
    end
})

VisualBox:AddCheckbox("LowGraphics", {
    Text = "Low Graphics", Default = false,
    Callback = function(v) Visual.LowGraphics = v; applyOptimization() end
})
VisualBox:AddCheckbox("NoScreenEffects", {
    Text = "No Screen Effects", Default = false,
    Callback = function(v) Visual.NoScreenEffects = v; applyNoScreenEffects() end
})
ZoomBox:AddToggle("UnlimitedZoom", {
    Text = "Unlimited Zoom Out", Default = false,
    Callback = function(v) CameraZoom.UnlimitedZoom = v; applyUnlimitedZoom() end
})
ZoomBox:AddSlider("MaxZoomDistance", {
    Text = "Max Zoom Distance", Default = 1000, Min = 100, Max = 5000, Rounding = 0,
    Callback = function(v)
        CameraZoom.MaxDistance = v
        if CameraZoom.UnlimitedZoom then applyUnlimitedZoom() end
    end
})
ZoomBox:AddToggle("CustomFOV", {
    Text = "Custom FOV", Default = false,
    Callback = function(v) CameraZoom.FOVEnabled = v; applyCameraFOV() end
})
ZoomBox:AddSlider("CameraFOV", {
    Text = "Camera FOV", Default = 70, Min = 40, Max = 120, Rounding = 0,
    Callback = function(v)
        CameraZoom.FOV = v
        if CameraZoom.FOVEnabled then applyCameraFOV() end
    end
})

TimeBox:AddSlider("ClockTime", {
    Text = "Clock Time", Default = 14, Min = 0, Max = 24, Rounding = 0,
    Callback = function(v)
        Lighting.ClockTime = v
        if FULLBRIGHT_CONFIG.Enabled then
            ApplyFullbright()
        end
    end
})
TimeBox:AddSlider("Brightness", {
    Text = "Brightness", Default = 1.6, Min = 0, Max = 5, Rounding = 1,
    Callback = function(v)
        Lighting.Brightness = v
        if FULLBRIGHT_CONFIG.Enabled then
            ApplyFullbright()
        end
    end
})

-- =======================================
-- UI SETTINGS
-- =======================================
SettingBox:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor", Default = true,
    Callback = function(v) Library.ShowCustomCursor = v end
})
SettingBox:AddDropdown("NotificationSide", {
    Values = {"Left","Right"}, Default = "Right", Text = "Notification Side",
    Callback = function(v) Library:SetNotifySide(v) end
})
SettingBox:AddDropdown("DPIDropdown", {
    Values = {"50%","75%","85%","100%","125%","150%"}, Default = "85%%", Text = "DPI Scale",
    Callback = function(v)
        v = v:gsub("%%","")
        Library:SetDPIScale(tonumber(v))
    end
})
SettingBox:AddSlider("UICornerSlider", {
    Text = "Corner Radius", Default = Library.CornerRadius, Min = 0, Max = 20, Rounding = 0,
    Callback = function(value) Window:SetCornerRadius(value) end
})
SettingBox:AddToggle("WatermarkToggle", {
    Text = "Watermark", Default = true,
    Callback = function(v) -- Watermark.Visible = v 
    end
})
SettingBox:AddToggle("FPSLockToggle", {
    Text = "120 Fps Unlock", Default = false,
    Callback = function(v)
        if v then
            setFPSLimit(120)
        else
            setFPSLimit(0)
        end
    end
})
SettingBox:AddDivider()
SettingBox:AddButton("Join Discord", function()
    setclipboard("https://discord.gg/6gvB8RCwx")
end)
SettingBox:AddButton("Unload script", function() Library:Unload() end)

-- =======================================
-- CONFIG & THEME
-- =======================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("Fionzy-VD Vd")
SaveManager:SetFolder("Fionzy-VD/configs")
SaveManager:BuildConfigSection(Tabs.UISettings)

-- =======================================
-- UPDATE FOOTER NEXT KILLER
-- =======================================
local function UpdateFooterNextKiller()
    local players = Players:GetPlayers()
    if #players == 0 then 
        Window:SetFooter("NEXT KILLER : No players")
        return 
    end
    
    table.sort(players, function(a, b)
        local aA = GetGameValue(a, "AllowKiller") or false
        local bA = GetGameValue(b, "AllowKiller") or false
        if aA ~= bA then return aA == true end
        return (GetGameValue(a, "KillerChance") or 0) > (GetGameValue(b, "KillerChance") or 0)
    end)
    
    local nk = players[1]
    if not nk then 
        Window:SetFooter("NEXT KILLER : No killer found")
        return 
    end
    
    local playerName = nk == LocalPlayer and "YOU" or nk.Name
    local killerName = GetKillerName(nk)
    Window:SetFooter("NEXT KILLER : " .. playerName .. " (" .. killerName .. ")")
end

task.spawn(function()
    while true do
        task.wait(2)
        UpdateFooterNextKiller()
    end
end)
