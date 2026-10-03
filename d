local function __KysHub_Init_Main__()
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Teams             = game:GetService("Teams")
local GuiService        = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera
local Character, Humanoid, Root

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- =====================================================
-- KEZODX UI LIBRARY LOADER
-- =====================================================
local obsidianRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local function safeLoad(url)
    local ok, src = pcall(function() return game:HttpGet(url) end)
    if not ok or not src or src == "" then
        error("[KysHub] HttpGet gagal untuk: " .. url .. "\nError: " .. tostring(src))
    end
    local fn, err = loadstring(src)
    if not fn then
        error("[KysHub] loadstring gagal untuk: " .. url .. "\nError: " .. tostring(err))
    end
    local ok2, result = pcall(fn)
    if not ok2 then
        error("[KysHub] exec gagal untuk: " .. url .. "\nError: " .. tostring(result))
    end
    return result
end

local Library      = safeLoad("https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/Library.lua")
local ThemeManager = safeLoad(obsidianRepo .. "addons/ThemeManager.lua")
local SaveManager  = safeLoad(obsidianRepo .. "addons/SaveManager.lua")

local Options = Library.Options
local Toggles = Library.Toggles

if isMobile then print("[Universal] Platform: MOBILE") else print("[Universal] Platform: PC") end

-- =====================================================
local Window = Library:CreateWindow({
    Title = "KysHub CRACKED√ by <iry hub>",
    Footer = "Violence District v1.5.7",
    Icon = 80891639562743,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- =====================================================
-- HELPER: Notify
-- =====================================================
local function VD_Notify(title, content, duration)
    pcall(function()
        Library:Notify({
            Title = title,
            Description = content,
            Time = duration or 2,
        })
    end)
end

-- =====================================================
-- TABS
-- =====================================================
local Tabs = {
    Visual  = Window:AddTab("Visual",  "eye"),
    Main    = Window:AddTab("Main",    "cpu"),
    Aim     = Window:AddTab("Aim",     "crosshair"),
    Mapping = Window:AddTab("Mapping", "map"),
    Player  = Window:AddTab("Player",  "user"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- =====================================================
-- GROUPBOXES (menggantikan CenterTabbox + Section)
-- =====================================================

-- Visual Tab
local ESPBox        = Tabs.Visual:AddGroupbox({ Side = "Left",  Name = "ESP" })
local CameraBox     = Tabs.Visual:AddGroupbox({ Side = "Right", Name = "Camera" })
local LightingBox   = Tabs.Visual:AddGroupbox({ Side = "Left",  Name = "Lighting & Visual" })
local InfoPanelBox  = Tabs.Visual:AddGroupbox({ Side = "Right", Name = "Game Info Panel" })

-- Main Tab
local SurvivorBox   = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Survivor" })
local FakePerksBox  = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Fake Perks" })
local EscapeBox     = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Escape" })
local AutoBox       = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Automation" })
local KillerBox     = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Killer" })
local AbilityBox    = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Killer Ability" })
local UtilBox       = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Utilities" })

-- Aim Tab
local AimbotBox     = Tabs.Aim:AddGroupbox({ Side = "Left",  Name = "Aimbot" })
local CrosshairBox  = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Advanced Crosshair" })
local SpearBox      = Tabs.Aim:AddGroupbox({ Side = "Left",  Name = "Killer Aim (Veil/Spear)" })
local FlaskBox      = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Silent Aim Flask (Cure)" })
local ToFBox        = Tabs.Aim:AddGroupbox({ Side = "Left",  Name = "Silent Aim Twist Of Fate" })
local FlashlightBox = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Silent Aim Flashlight" })

-- Mapping Tab
local TeleportBox   = Tabs.Mapping:AddGroupbox({ Side = "Left",  Name = "Teleport" })
local RadarBox      = Tabs.Mapping:AddGroupbox({ Side = "Right", Name = "Radar" })

-- Player Tab
local MovementBox   = Tabs.Player:AddGroupbox({ Side = "Left",  Name = "Movement" })
local FlingBox      = Tabs.Player:AddGroupbox({ Side = "Right", Name = "Fling" })
local EmoteBox      = Tabs.Player:AddGroupbox({ Side = "Left",  Name = "Emote [BETA]" })
local FunBox        = Tabs.Player:AddGroupbox({ Side = "Right", Name = "Spoof Stats" })
local StreamerBox   = Tabs.Player:AddGroupbox({ Side = "Left",  Name = "Streamer Mode" })
local AvatarBox     = Tabs.Player:AddGroupbox({ Side = "Right", Name = "Avatar Tools" })

-- =====================================================
-- SAFE DRAWING UTILS
-- =====================================================
local DrawingAvailable = (function()
    if isMobile then return false end
    local ok, result = pcall(function()
        return typeof(Drawing) == "table" and Drawing.new ~= nil
    end)
    return ok and result or false
end)()

function SafeDrawing(typ)
    if not DrawingAvailable then return nil end
    local ok, res = pcall(function() return Drawing.new(typ) end)
    return ok and res or nil
end

function SafeRemove(obj)
    if obj and obj.Remove then pcall(function() obj:Remove() end) end
end

local MobileESP = {}

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
function clamp(v, min, max)
    return math.max(min, math.min(max, v))
end

-- =====================================================
-- CONFIG
-- =====================================================
getgenv().VD = getgenv().VD or {
    AutoSkillcheck        = false,
    AutoSkillcheckMode    = "Normal",
    HideSkillUI           = false,
    Fullbright            = false,
    Speed                 = false,
    SpeedValue            = 16,
    Jump                  = false,
    JumpValue             = 50,
    InfiniteJump          = false,
    Noclip                = false,
    Moonwalk              = false,
    MoonwalkButton        = false,
    MoonwalkButtonLocked  = false,
    MoonwalkZigzagSpeed   = 11,
    MoonwalkBoostPower    = 1.08,
    AimLock               = false,
    AimLockButton         = false,
    AimLockButtonLocked   = false,
    AimLockMaxDistance    = 50,
    InvisibleNotVisual    = false,
    InvisibleSpeed        = 5,
    AntiAFK               = false,
    BypassGate            = false,
    Destroyed             = false,
    AUTO_LeaveGen         = false,
    AUTO_LeaveDist        = 18,
    AUTO_Attack           = false,
    AUTO_AttackRange      = 12,
    HITBOX_Enabled        = false,
    HITBOX_Size           = 15,
    TOF_SilentAim         = false,
    TOF_Laser             = true,
    TOF_WallCheck         = false,
    TOF_BlockKnocked      = true,
    TOF_TargetMode        = "Killer",
    TOF_Key               = "None",
    FLASH_SilentAim       = false,
    FLASH_Laser           = true,
    FLASH_TargetPart      = "Head",
    FLASH_Range           = 120,
    FLASH_Smooth          = 0.35,
    SURV_FleeKiller       = false,
    SURV_FleeDistance     = 40,
    SURV_SwiftVault        = false,
    SURV_SwiftVaultV2       = false,
    SURV_SwiftVaultSpeed       = 13,
    SURV_AutoPallet       = false,
    SURV_AutoPalletDist   = 20,
    SURV_AutoParry        = false,
    SURV_ParryDistance    = 8,
    SURV_ShowParryCircle  = false,
    SURV_FakeParry        = false,
    SURV_FakeParryAnim    = "Enten",
    SURV_FakeGen          = false,
    SURV_AntiKnock        = false,
    KILLER_DestroyPallets = false,
    KILLER_NoPalletStun   = false,
    KILLER_AutoHook       = false,
    KILLER_AutoBreakGene  = false,
    KILLER_BlockVaults    = false,
    KILLER_BlockPallets   = false,
    KILLER_BlockPalletDrop = false,
    KILLER_BypassCooldown = false,
    KILLER_BypassLeap     = false,
    KILLER_AntiBlind      = false,
    KILLER_NoSlowdown     = false,
    KILLER_CustomMasked   = "Richard",
    SPEED_Enabled         = false,
    SPEED_Value           = 32,
    SPEED_Method          = "Attribute",
    NO_Fog                = false,
    NoCutscene            = false,
    CAM_FOVEnabled        = false,
    CAM_FOV               = 90,
    CAM_ThirdPerson       = false,
    CAM_ShiftLock         = false,
    CAM_InfinityZoom      = false,
    AntiFallDamage        = false,
    FLING_Enabled         = false,
    FLING_Strength        = 10000,
    BEAT_Survivor         = false,
    BEAT_Killer           = false,
    TP_Offset             = 3,
    VIS_KystKiller        = false,
    VIS_SpectatorCounter  = false,
    VIS_KillerPerks       = false,
    VIS_PredictMap        = false,
    VIS_HideSurvivorIcon  = false,
    VIS_ShowPingFPS       = false,
    VIS_ShowHookCounter   = false,
    VIS_WeatherTheme      = "Default",
    CROSS_Enabled         = false,
    CROSS_Style           = "Dot",
    CROSS_Size            = 3,
    CROSS_Thickness       = 4,
    CROSS_Gap             = 6,
    CROSS_PosX            = 0,
    CROSS_PosY            = 0,
    CROSS_Color           = Color3.fromRGB(255, 255, 255),
    ESP_ClosestHook       = false,
    AIM_Enabled           = false,
    AIM_UseRMB            = false,
    AIM_FOV               = 120,
    AIM_Smooth            = 0.3,
    AIM_TargetPart        = "Head",
    AIM_VisCheck          = false,
    AIM_ShowFOV           = false,
    AIM_Predict           = false,
    SURV_FirstPerson       = false,
    SPEAR_Aimbot          = false,
    SPEAR_Gravity         = 50,
    SPEAR_Speed           = 100,
    RADAR_Enabled         = false,
    RADAR_Size            = 150,
    RADAR_Range           = 250,
    RADAR_Transparency    = 0.2,
    RADAR_Circle          = false,
    RADAR_ShowKiller      = false,
    RADAR_ShowSurvivor    = false,
    RADAR_ShowGenerator   = false,
    RADAR_ShowPallet      = false,
    RADAR_ShowHook        = false,
    RADAR_ShowGate        = false,
    RADAR_ShowWindow      = false,
    RADAR_ShowZombie      = false,
    SURV_WarnKiller       = false,
    SURV_AutoDodgeSpear   = false
}

local VD = getgenv().VD

-- =====================================================
-- ADVANCED CROSSHAIR (GUI Fallback / Port)
-- =====================================================
local CrosshairGui = nil

function clearCrosshair()
    if CrosshairGui then
        pcall(function() CrosshairGui:Destroy() end)
        CrosshairGui = nil
    end
end

function VD_UpdateCrosshair()
    clearCrosshair()
    if not VD.CROSS_Enabled then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local style = VD.CROSS_Style or "Dot"
    local size = tonumber(VD.CROSS_Size) or 3
    local gap = tonumber(VD.CROSS_Gap) or 6
    local thick = tonumber(VD.CROSS_Thickness) or 4
    local color = typeof(VD.CROSS_Color) == "Color3" and VD.CROSS_Color or Color3.fromRGB(255, 255, 255)

    local offsetX = tonumber(VD.CROSS_PosX) or 0
    local offsetY = tonumber(VD.CROSS_PosY) or 0

    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    local parent = (ok and core) and core or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not parent then return end

    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "KYS_Crosshair"
    CrosshairGui.DisplayOrder = 999999
    CrosshairGui.IgnoreGuiInset = true
    CrosshairGui.Parent = parent

    local centerFrame = Instance.new("Frame")
    centerFrame.Name = "Center"
    centerFrame.BackgroundTransparency = 1
    centerFrame.Position = UDim2.new(0.5, offsetX, 0.5, offsetY)
    centerFrame.Size = UDim2.new(0,0,0,0)
    centerFrame.Parent = CrosshairGui

    if style == "Dot" then
        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Size = UDim2.new(0, size * 2, 0, size * 2)
        dot.BackgroundColor3 = color
        dot.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        dot.Parent = centerFrame

    elseif style == "Plus" or style == "X" then
        local length = size * 3
        for i = 1, 4 do
            local line = Instance.new("Frame")
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BackgroundColor3 = color
            line.BorderSizePixel = 0
            local angle = (i - 1) * 90
            if style == "X" then angle = angle + 45 end
            line.Rotation = angle
            line.Size = UDim2.new(0, length, 0, thick)
            local rad = math.rad(angle)
            local dirX = math.cos(rad)
            local dirY = math.sin(rad)
            local dist = gap + (length / 2)
            line.Position = UDim2.new(0, math.floor(dirX * dist + 0.5), 0, math.floor(dirY * dist + 0.5))
            line.Parent = centerFrame
        end

    elseif style == "Box" then
        local half = gap + size * 2
        local t = Instance.new("Frame")
        t.BackgroundColor3 = color; t.BorderSizePixel = 0; t.AnchorPoint = Vector2.new(0.5, 0.5)
        t.Size = UDim2.new(0, half * 2 + thick, 0, thick)
        t.Position = UDim2.new(0, 0, 0, -half)
        t.Parent = centerFrame

        local b = Instance.new("Frame")
        b.BackgroundColor3 = color; b.BorderSizePixel = 0; b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.Size = UDim2.new(0, half * 2 + thick, 0, thick)
        b.Position = UDim2.new(0, 0, 0, half)
        b.Parent = centerFrame

        local l = Instance.new("Frame")
        l.BackgroundColor3 = color; l.BorderSizePixel = 0; l.AnchorPoint = Vector2.new(0.5, 0.5)
        l.Size = UDim2.new(0, thick, 0, half * 2 - thick)
        l.Position = UDim2.new(0, -half, 0, 0)
        l.Parent = centerFrame

        local r = Instance.new("Frame")
        r.BackgroundColor3 = color; r.BorderSizePixel = 0; r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.Size = UDim2.new(0, thick, 0, half * 2 - thick)
        r.Position = UDim2.new(0, half, 0, 0)
        r.Parent = centerFrame
    end
end
getgenv().VD_UpdateCrosshair = VD_UpdateCrosshair

-- All runtime features are intentionally reset on every execute.
local VD_DefaultOffFlags = {
    "AutoSkillcheck","HideSkillUI","Fullbright","Speed","Jump","InfiniteJump","Noclip",
    "Moonwalk","MoonwalkButton","MoonwalkButtonLocked","AimLock","AimLockButton",
    "AimLockButtonLocked","AimLockMaxDistance","InvisibleNotVisual","AntiAFK","BypassGate",
    "AUTO_Attack","HITBOX_Enabled","TOF_SilentAim","FLASH_SilentAim","SURV_FleeKiller",
    "SURV_SwiftVault","SURV_SwiftVaultV2","SURV_AutoPallet","SURV_AutoParry",
    "SURV_ShowParryCircle","SURV_FakeParry","SURV_FakeParryAnim","SURV_FakeGen",
    "SURV_AntiKnock","KILLER_DestroyPallets","KILLER_NoPalletStun","KILLER_AutoHook",
    "KILLER_AutoBreakGene","KILLER_BlockVaults","KILLER_BlockPallets","KILLER_BlockPalletDrop",
    "KILLER_BypassCooldown","KILLER_BypassLeap","KILLER_BypassVeilCooldown","KILLER_AntiBlind",
    "KILLER_NoSlowdown","SPEED_Enabled","NO_Fog","NoCutscene","VIS_KystKiller","CAM_FOVEnabled",
    "CAM_ThirdPerson","CAM_ShiftLock","CAM_InfinityZoom","AntiFallDamage","FLING_Enabled",
    "BEAT_Survivor","BEAT_Killer","ESP_ClosestHook","VIS_SpectatorCounter","VIS_KillerPerks",
    "VIS_PredictMap","VIS_HideSurvivorIcon","VIS_ShowPingFPS","VIS_ShowHookCounter",
    "CROSS_Enabled","CROSS_Style","CROSS_Size","CROSS_Thickness","CROSS_Gap","CROSS_PosX",
    "CROSS_PosY","CROSS_Color","AIM_Enabled","AIM_UseRMB","AIM_VisCheck","AIM_ShowFOV",
    "AIM_Predict","SURV_FirstPerson","SPEAR_Aimbot","RADAR_Enabled","RADAR_Circle",
    "RADAR_ShowKiller","RADAR_ShowSurvivor","RADAR_ShowGenerator","RADAR_ShowPallet",
    "RADAR_ShowHook","RADAR_ShowGate","RADAR_ShowWindow","RADAR_ShowZombie","SURV_WarnKiller",
}

for _, flagName in ipairs(VD_DefaultOffFlags) do
    VD[flagName] = false
end

if VD.TOF_Laser == nil then VD.TOF_Laser = true end
if VD.TOF_WallCheck == nil then VD.TOF_WallCheck = false end
if VD.TOF_BlockKnocked == nil then VD.TOF_BlockKnocked = true end
if VD.TOF_TargetMode == nil then VD.TOF_TargetMode = "Killer" end
if VD.TOF_Key == nil then VD.TOF_Key = "None" end
if VD.FLASH_TargetPart == nil then VD.FLASH_TargetPart = "Head" end
if VD.FLASH_Laser == nil then VD.FLASH_Laser = true end
if VD.FLASH_Range == nil then VD.FLASH_Range = 120 end
if VD.FLASH_Smooth == nil then VD.FLASH_Smooth = 0.35 end

-- =====================================================
-- CONFIGURATION SYSTEM
-- =====================================================
function GetSafeGuiParent()
    if gethui then return gethui() end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:FindFirstChild("PlayerGui")
end

local VD_ChamsFolder = nil
function GetSafeChamsFolder()
    local pg = GetSafeGuiParent()
    if not pg then return workspace end
    if VD_ChamsFolder and VD_ChamsFolder.Parent then return VD_ChamsFolder end
    local f = pg:FindFirstChild("KYS_WorkspaceChams")
    if not f then
        f = Instance.new("Folder")
        f.Name = "KYS_WorkspaceChams"
        f.Parent = pg
    end
    VD_ChamsFolder = f
    return f
end

local ConfigFolderName = "KysHub_VD"
local HttpService = game:GetService("HttpService")

if makefolder and isfolder and not isfolder(ConfigFolderName) then
    makefolder(ConfigFolderName)
end

getgenv().CurrentConfigName = "Default"

function GetConfigList()
    local list = {}
    if listfiles and isfolder and isfolder(ConfigFolderName) then
        for _, file in pairs(listfiles(ConfigFolderName)) do
            if file:sub(-5) == ".json" then
                local filename = file:match("([^/\\]+)%.json$")
                if filename then table.insert(list, filename) end
            end
        end
    end
    if #list == 0 then table.insert(list, "Default") end
    return list
end

function KYS_SaveConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if writefile then writefile(path, HttpService:JSONEncode(VD)) end
    end)
end

-- =====================================================
-- SAVE ORIGINAL LIGHTING
-- =====================================================
local originalLighting = {
    Brightness     = Lighting.Brightness,
    ClockTime      = Lighting.ClockTime,
    FogEnd         = Lighting.FogEnd,
    FogStart       = Lighting.FogStart,
    GlobalShadows  = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}
do
    local atm  = Lighting:FindFirstChildOfClass("Atmosphere")
    local blur = Lighting:FindFirstChildOfClass("BlurEffect")
    local cc   = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    local sr   = Lighting:FindFirstChildOfClass("SunRaysEffect")
    if atm then originalLighting.Atmosphere = { Density = atm.Density, Offset = atm.Offset, Glare = atm.Glare, Haze = atm.Haze } end
    if blur then originalLighting.Blur = { Size = blur.Size } end
    if cc then originalLighting.ColorCorrection = { Enabled = cc.Enabled } end
    if sr then originalLighting.SunRays = { Enabled = sr.Enabled } end
end

-- =====================================================
-- WEATHER ENGINE
-- =====================================================
getgenv().VD_CurrentSky = nil
getgenv().VD_ParticleAnchor = nil

local KYS_WeatherPresets = {
    ["Default"] = {},
    ["Christmas (Snow)"] = {
        Lighting = { FogColor = Color3.fromRGB(150, 180, 220), FogEnd = 200, ClockTime = 8, OutdoorAmbient = Color3.fromRGB(100, 120, 150) },
        Atmosphere = { Density = 0.5, Color = Color3.fromRGB(180, 200, 220), Decay = Color3.fromRGB(150, 180, 220), Haze = 5, Glare = 0 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)), Size = NumberSequence.new(1.5), Rate = 150, Speed = NumberRange.new(15, 25), Lifetime = NumberRange.new(4, 6), EmissionDirection = Enum.NormalId.Bottom, RotSpeed = NumberRange.new(-45, 45) }
    },
    ["Heavy Rain (Storm)"] = {
        Lighting = { FogColor = Color3.fromRGB(50, 50, 60), FogEnd = 150, OutdoorAmbient = Color3.fromRGB(40, 40, 50), Brightness = 0.2, ClockTime = 12 },
        CC = { TintColor = Color3.fromRGB(150, 150, 180), Contrast = 0.2, Saturation = -0.5 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(260, 1, 260), CameraOffset = Vector3.new(0, 38, -18), Squash = NumberSequence.new(16), Color = ColorSequence.new(Color3.fromRGB(235, 245, 255)), Size = NumberSequence.new(1.25), Rate = 2600, Speed = NumberRange.new(110, 145), Lifetime = NumberRange.new(0.85, 1.25), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0), Acceleration = Vector3.new(-18, -75, 0), SpreadAngle = Vector2.new(3, 3), LightEmission = 1 }
    },
    ["Autumn (Musim Gugur)"] = {
        Lighting = { FogColor = Color3.fromRGB(200, 150, 80), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(180, 140, 70), ClockTime = 16.5 },
        CC = { TintColor = Color3.fromRGB(255, 220, 180), Contrast = 0.1, Saturation = 0.2 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(210, 1, 210), CameraOffset = Vector3.new(0, 28, -16), Squash = NumberSequence.new(3.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 45)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 95, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 45, 10)) }), Size = NumberSequence.new(2.05), Rate = 360, Speed = NumberRange.new(8, 15), Lifetime = NumberRange.new(6, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-220, 220), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(18, -8, 6), SpreadAngle = Vector2.new(38, 38), LightEmission = 0.6 }
    },
    ["Cherry Blossom (Sakura)"] = {
        Lighting = { FogColor = Color3.fromRGB(255, 200, 220), FogEnd = 600, OutdoorAmbient = Color3.fromRGB(255, 180, 200), ClockTime = 9 },
        CC = { TintColor = Color3.fromRGB(255, 230, 240), Saturation = 0.3 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(160, 1, 160), CameraOffset = Vector3.new(0, 25, -18), Squash = NumberSequence.new(1.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 235)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 165, 205)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180)) }), Size = NumberSequence.new(1.25), Rate = 190, Speed = NumberRange.new(5, 10), Lifetime = NumberRange.new(7, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-170, 170), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(14, -5, 5), SpreadAngle = Vector2.new(32, 32), LightEmission = 0.55 }
    },
    ["Sunset (Golden Hour)"] = {
        Lighting = { FogColor = Color3.fromRGB(255, 120, 50), FogEnd = 1200, OutdoorAmbient = Color3.fromRGB(200, 100, 50), ClockTime = 17.5, Brightness = 1.5 },
        CC = { TintColor = Color3.fromRGB(255, 200, 150), Contrast = 0.2, Saturation = 0.4 }
    },
    ["Blood Moon (Spooky)"] = {
        Lighting = { FogColor = Color3.fromRGB(150, 10, 10), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(80, 0, 0), ClockTime = 0, Brightness = 0.3 },
        CC = { TintColor = Color3.fromRGB(255, 50, 50), Contrast = 0.4, Saturation = 0.5 },
        Atmosphere = { Density = 0.35, Color = Color3.fromRGB(255, 0, 0), Decay = Color3.fromRGB(100, 0, 0), Haze = 5, Glare = 0 }
    },
    ["Toxic Wasteland"] = {
        Lighting = { FogColor = Color3.fromRGB(80, 150, 50), FogEnd = 250, OutdoorAmbient = Color3.fromRGB(50, 120, 40), ClockTime = 12, Brightness = 1 },
        CC = { TintColor = Color3.fromRGB(150, 255, 150), Contrast = 0.1, Saturation = 0.3 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(100, 255, 50)), Size = NumberSequence.new(0.8), Rate = 200, Speed = NumberRange.new(50, 60), Lifetime = NumberRange.new(2, 3), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0.5) }
    },
    ["Vaporwave (Synthwave)"] = {
        Lighting = { FogColor = Color3.fromRGB(200, 50, 255), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(150, 0, 200), ClockTime = 20, Brightness = 1 },
        CC = { TintColor = Color3.fromRGB(255, 100, 255), Contrast = 0.3, Saturation = 0.5 }
    },
    ["Midnight (Pitch Black)"] = {
        Lighting = { FogColor = Color3.fromRGB(0, 0, 0), FogEnd = 100, OutdoorAmbient = Color3.fromRGB(0, 0, 0), Brightness = 0, ClockTime = 0 },
        CC = { TintColor = Color3.fromRGB(50, 50, 50), Contrast = 0.5, Saturation = -0.8 }
    }
}

function VD_ApplyWeather(themeName)
    local theme = KYS_WeatherPresets[themeName]
    if not theme then theme = KYS_WeatherPresets["Default"] end
    if getgenv().VD_CurrentSky and getgenv().VD_CurrentSky.Parent then getgenv().VD_CurrentSky:Destroy() end
    getgenv().VD_CurrentSky = nil
    if getgenv().VD_WeatherCC and getgenv().VD_WeatherCC.Parent then getgenv().VD_WeatherCC:Destroy() end
    getgenv().VD_WeatherCC = nil
    if getgenv().VD_WeatherAtmosphere and getgenv().VD_WeatherAtmosphere.Parent then getgenv().VD_WeatherAtmosphere:Destroy() end
    getgenv().VD_WeatherAtmosphere = nil
    if theme.Atmosphere then
        local atm = Instance.new("Atmosphere"); atm.Name = "VD_WeatherAtmosphere"
        for k, v in pairs(theme.Atmosphere) do pcall(function() atm[k] = v end) end
        atm.Parent = Lighting; getgenv().VD_WeatherAtmosphere = atm
    end
    if theme.CC then
        local cc = Instance.new("ColorCorrectionEffect"); cc.Name = "VD_WeatherCC"
        for k, v in pairs(theme.CC) do pcall(function() cc[k] = v end) end
        cc.Parent = Lighting; getgenv().VD_WeatherCC = cc
    end
    if theme.Lighting then
        for k, v in pairs(theme.Lighting) do pcall(function() Lighting[k] = v end) end
    else
        if not VD.Fullbright and not VD.NO_Fog then
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        end
    end
    if VD.Fullbright then pcall(VD_SetFullbright, true) end
    if VD.NO_Fog then pcall(VD_SetNoFog, true) end
    if getgenv().VD_ParticleAnchor and getgenv().VD_ParticleAnchor.Parent then
        getgenv().VD_ParticleAnchor:Destroy()
    end
    getgenv().VD_ParticleAnchor = nil
    if theme.Particle then
        local anchor = Instance.new("Part")
        anchor.Name = "VD_WeatherAnchor"
        anchor.Transparency = 0.99; anchor.CanCollide = false; anchor.Anchored = true
        anchor.Size = theme.Particle.AnchorSize or Vector3.new(120, 1, 120)
        anchor:SetAttribute("VD_CameraOffsetX", theme.Particle.CameraOffset and theme.Particle.CameraOffset.X or 0)
        anchor:SetAttribute("VD_CameraOffsetY", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Y or 30)
        anchor:SetAttribute("VD_CameraOffsetZ", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Z or 0)
        local pe = Instance.new("ParticleEmitter"); pe.Name = "VD_WeatherEmitter"
        pe.Enabled = true; pe.EmissionDirection = Enum.NormalId.Bottom; pe.LockedToPart = false
        pe.ZOffset = 2; pe.LightEmission = 0.25; pe.SpreadAngle = Vector2.new(10, 10)
        pcall(function() pe.Shape = Enum.ParticleEmitterShape.Box end)
        pcall(function() pe.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
        for k, v in pairs(theme.Particle) do
            if k ~= "AnchorSize" and k ~= "CameraOffset" then pcall(function() pe[k] = v end) end
        end
        pe.Parent = anchor
        anchor.Parent = workspace
        getgenv().VD_ParticleAnchor = anchor
        if theme.Particle.Texture then
            task.spawn(function() pcall(function() game:GetService("ContentProvider"):PreloadAsync({pe}) end) end)
        end
        pcall(VD_UpdateWeatherAnchor)
    end
end

function VD_UpdateWeatherAnchor()
    local anchor = getgenv().VD_ParticleAnchor
    if not anchor then return end
    if anchor.Parent ~= workspace then pcall(function() anchor.Parent = workspace end) end
    local camera = workspace.CurrentCamera
    if camera then
        local offset = Vector3.new(
            anchor:GetAttribute("VD_CameraOffsetX") or 0,
            anchor:GetAttribute("VD_CameraOffsetY") or 30,
            anchor:GetAttribute("VD_CameraOffsetZ") or 0
        )
        local worldPos = camera.CFrame.Position
            + camera.CFrame.RightVector * offset.X
            + Vector3.new(0, offset.Y, 0)
            + camera.CFrame.LookVector * math.abs(offset.Z)
        anchor.CFrame = CFrame.new(worldPos)
        return
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        anchor.CFrame = CFrame.new(char.Head.Position + Vector3.new(0, 30, 0))
    end
end

-- =====================================================
-- CHARACTER REFS
-- =====================================================
function updateChar(char)
    Character = char or LocalPlayer.Character
    if Character then
        task.spawn(function()
            Humanoid = Character:WaitForChild("Humanoid", 5)
            Root     = Character:WaitForChild("HumanoidRootPart", 5)
        end)
    else
        Humanoid, Root = nil, nil
    end
end
updateChar()
LocalPlayer.CharacterAdded:Connect(updateChar)
LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == Character or char == LocalPlayer.Character then
        Character, Humanoid, Root = nil, nil, nil
    end
end)

-- =====================================================
-- HELPERS: TEAM / COLORS
-- =====================================================
local TeamColor  = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)

function isTeammate(player)
    return LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team
end

function getPlayerColor(player)
    return isTeammate(player) and TeamColor or EnemyColor
end

-- =====================================================
-- CENTRALIZED METAMETHOD HOOK (__namecall)
-- =====================================================
local KYS_WorldReg
getgenv().KYS_oldNamecall = nil

function setupAntiFail()
    if getgenv().KYS_AntiFailHooked then return end
    getgenv().KYS_AntiFailHooked = true
    task.spawn(function()
        local ok, err = pcall(function()
            local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local Events  = ReplicatedStorage:WaitForChild("Events", 10)
            if not Remotes then warn("AntiFail: Remotes not found"); return end
            local _genv = getgenv()
            _genv.KYS_oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and not checkcaller() then
                    local ok2, selfName = pcall(function() return self.Name end)
                    if ok2 and selfName == "ThrowFlask" then
                        local args = {...}
                        local closest = nil; local minDst = math.huge
                        local lp = game:GetService("Players").LocalPlayer
                        local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
                        if myPos then
                            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    if not v.Character:GetAttribute("IsKiller") then
                                        local dst = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                                        if dst < minDst then minDst = dst; closest = v end
                                    end
                                end
                            end
                        end
                        if closest then
                            local targetPos = closest.Character.HumanoidRootPart.Position
                            if args[2] and typeof(args[2]) == "Vector3" then
                                args[1] = (targetPos - args[2]).Unit
                            end
                            setnamecallmethod(method)
                            return _genv.KYS_oldNamecall(self, unpack(args))
                        end
                    end
                end
                if method == "FireServer" and not checkcaller() then
                    local flashRemote = _genv.KYS_FlashlightActivateRemote
                    if flashRemote and self == flashRemote and _genv.KYS_SetFlashlightAimActive then
                        local args = { ... }
                        pcall(_genv.KYS_SetFlashlightAimActive, args[2] == true, args[1])
                    end
                end
                if _genv.KYS_oldNamecall then return _genv.KYS_oldNamecall(self, ...) end
            end)
            print("AntiFail: hooked")
        end)
        if not ok then warn("AntiFail setup failed:", err) end
    end)
end
setupAntiFail()

-- =====================================================
-- FIRST PERSON CAMERA (Survivor)
-- =====================================================
getgenv().KYS_fpWasSet = false
getgenv().KYS_fpOriginal = nil

function RestoreFirstPersonCamera()
    if not getgenv().KYS_fpWasSet then return end
    getgenv().KYS_fpWasSet = false
    pcall(function()
        if getgenv().KYS_fpOriginal then
            LocalPlayer.CameraMode = getgenv().KYS_fpOriginal.CameraMode or Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = getgenv().KYS_fpOriginal.CameraMaxZoomDistance or 128
            LocalPlayer.CameraMinZoomDistance = getgenv().KYS_fpOriginal.CameraMinZoomDistance or 0.5
        else
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end)
    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then head.LocalTransparencyModifier = 0 end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") then
                local handle = obj:FindFirstChild("Handle")
                if handle then handle.LocalTransparencyModifier = 0 end
            end
        end
    end
    getgenv().KYS_fpOriginal = nil
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if VD.SURV_FirstPerson then
            local isSurvivor = LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors"
            if isSurvivor then
                if not getgenv().KYS_fpWasSet then
                    getgenv().KYS_fpOriginal = {
                        CameraMode = LocalPlayer.CameraMode,
                        CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance,
                        CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance,
                    }
                end
                if LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                end
                if LocalPlayer.CameraMaxZoomDistance ~= 0 then LocalPlayer.CameraMaxZoomDistance = 0 end
                local char = LocalPlayer.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head then head.LocalTransparencyModifier = 1 end
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Accessory") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then handle.LocalTransparencyModifier = 1 end
                        end
                    end
                end
                getgenv().KYS_fpWasSet = true
            elseif getgenv().KYS_fpWasSet then
                RestoreFirstPersonCamera()
            end
        elseif getgenv().KYS_fpWasSet then
            RestoreFirstPersonCamera()
        end
    end)
end)

-- =====================================================
-- VISUAL HIGHLIGHT ESP V2 (Player + World)
-- =====================================================
do
    if getgenv().KYS_VD_VisualESP_Cleanup then pcall(getgenv().KYS_VD_VisualESP_Cleanup) end

    local LP = LocalPlayer
    local KYS_Dead = false
    local KYS_ControlsAdded = false

    local KYS_ESPState = {
        PlayerMasterESP = false, WorldMasterESP = false,
        ESPFillTransparency = 0.95, ESPOutlineTransparency = 0.3, ESPTextSize = 12,
        SurvivorESP = false, KillerESP = false, SpectatorESP = false,
        Nametags = false, DistanceESP = false, SurvivorItemsESP = false,
        SurvivorColor = Color3.fromRGB(0, 255, 0),
        KillerColor = Color3.fromRGB(255, 0, 0),
        SpectatorColor = Color3.fromRGB(255, 255, 255),
        GeneratorESP = false, HookESP = false, GateESP = false, WindowESP = false,
        PalletESP = false, SCPZombieESP = false, WorldNametags = false, WorldDistanceESP = false,
        GeneratorColor = Color3.fromRGB(0, 170, 255),
        HookColor = Color3.fromRGB(255, 0, 0),
        GateColor = Color3.fromRGB(255, 225, 0),
        WindowColor = Color3.fromRGB(255, 255, 255),
        PalletColor = Color3.fromRGB(255, 140, 0),
        SCPZombieColor = Color3.fromRGB(128, 0, 128),
    }
    getgenv().KYS_VD_VisualESP_State = KYS_ESPState

    KYS_WorldReg = {
        GeneratorESP = {}, HookESP = {}, GateESP = {}, WindowESP = {}, PalletESP = {}, SCPZombieESP = {},
    }

    -- ESP Controls akan di-inject oleh getgenv().KYS_AddVisualESPControls
    getgenv().KYS_AddVisualESPControls = getgenv().KYS_AddVisualESPControls or function(box)
        -- placeholder; akan di-override oleh ESP module jika ada
        box:AddToggle("PlayerMasterESP", { Text = "Player ESP Master", Default = false, Callback = function(v) KYS_ESPState.PlayerMasterESP = v end })
        box:AddToggle("SurvivorESP_", { Text = "Survivor ESP", Default = false, Callback = function(v) KYS_ESPState.SurvivorESP = v end })
        box:AddToggle("KillerESP_", { Text = "Killer ESP", Default = false, Callback = function(v) KYS_ESPState.KillerESP = v end })
        box:AddToggle("NametasgESP", { Text = "Nametags", Default = false, Callback = function(v) KYS_ESPState.Nametags = v end })
        box:AddToggle("DistanceESP_", { Text = "Distance ESP", Default = false, Callback = function(v) KYS_ESPState.DistanceESP = v end })
        box:AddDivider()
        box:AddToggle("WorldMasterESP", { Text = "World ESP Master", Default = false, Callback = function(v) KYS_ESPState.WorldMasterESP = v end })
        box:AddToggle("GeneratorESP_", { Text = "Generator ESP", Default = false, Callback = function(v) KYS_ESPState.GeneratorESP = v end })
        box:AddToggle("HookESP_", { Text = "Hook ESP", Default = false, Callback = function(v) KYS_ESPState.HookESP = v end })
        box:AddToggle("GateESP_", { Text = "Gate ESP", Default = false, Callback = function(v) KYS_ESPState.GateESP = v end })
        box:AddToggle("PalletESP_", { Text = "Pallet ESP", Default = false, Callback = function(v) KYS_ESPState.PalletESP = v end })
        box:AddToggle("WindowESP_", { Text = "Window ESP", Default = false, Callback = function(v) KYS_ESPState.WindowESP = v end })
        box:AddToggle("ClosestHook_", { Text = "Closest Hook", Default = false, Callback = function(v) VD.ESP_ClosestHook = v end })
        KYS_ControlsAdded = true
    end

    pcall(getgenv().KYS_AddVisualESPControls, ESPBox)
end

-- =====================================================
-- PC CURSOR UNLOCK (ALT key toggle)
-- =====================================================
if not isMobile then
    local _cursorOn = false
    local _cursorManual = false

    local function _setCursor(state)
        _cursorOn = state; _cursorManual = true
        pcall(function()
            UserInputService.MouseIconEnabled = state
            UserInputService.MouseBehavior = state and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = not state end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            _setCursor(not _cursorOn)
        end
    end)

    task.spawn(function()
        while true do
            if _cursorManual then
                pcall(function()
                    if _cursorOn then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.MouseIconEnabled = true
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        UserInputService.MouseIconEnabled = false
                    end
                end)
            end
            task.wait(0.1)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if _cursorOn then _setCursor(true) end
    end)
    print("[VD] ALT Toggle Cursor Ready (PC only)")
end

-- =====================================================
-- FULLBRIGHT & NO FOG (referenced by Weather engine)
-- =====================================================
task.spawn(function()
    while true do
        if VD.Fullbright then
            if not VD.VIS_WeatherTheme or VD.VIS_WeatherTheme == "Default" then
                Lighting.Brightness = 2; Lighting.ClockTime = 14
                Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") and v.Name ~= "VD_WeatherAtmosphere" then
                    v.Density = 0; v.Offset = 0; v.Glare = 0; v.Haze = 0
                end
                if v:IsA("BlurEffect") then v.Size = 0 end
                if v:IsA("ColorCorrectionEffect") and v.Name ~= "VD_WeatherCC" then v.Enabled = false end
                if v:IsA("SunRaysEffect") then v.Enabled = false end
            end
        else
            if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" and KYS_WeatherPresets[VD.VIS_WeatherTheme] then
                local theme = KYS_WeatherPresets[VD.VIS_WeatherTheme]
                if theme.Lighting then
                    for k, v in pairs(theme.Lighting) do pcall(function() Lighting[k] = v end) end
                end
            else
                Lighting.Brightness = originalLighting.Brightness
                Lighting.ClockTime = originalLighting.ClockTime
                Lighting.FogEnd = originalLighting.FogEnd
                Lighting.FogStart = originalLighting.FogStart or 0
                Lighting.GlobalShadows = originalLighting.GlobalShadows
                Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") and originalLighting.Atmosphere then
                        v.Density = originalLighting.Atmosphere.Density or 0.3
                        v.Offset  = originalLighting.Atmosphere.Offset or 0.25
                        v.Glare   = originalLighting.Atmosphere.Glare or 0
                        v.Haze    = originalLighting.Atmosphere.Haze or 0
                    end
                    if v:IsA("BlurEffect") and originalLighting.Blur then v.Size = originalLighting.Blur.Size or 0 end
                    if v:IsA("ColorCorrectionEffect") and originalLighting.ColorCorrection then v.Enabled = originalLighting.ColorCorrection.Enabled or false end
                    if v:IsA("SunRaysEffect") and originalLighting.SunRays then v.Enabled = originalLighting.SunRays.Enabled or false end
                end
            end
        end
        if VD.NO_Fog then
            Lighting.FogStart = 0; Lighting.FogEnd = 100000
        end
        task.wait(0.5)
    end
end)

function VD_SetFullbright(state) VD.Fullbright = state end
function VD_SetNoFog(state)
    VD.NO_Fog = state
    if state then Lighting.FogStart = 0; Lighting.FogEnd = 100000 end
end

-- =====================================================
-- MOVEMENT & NOCLIP
-- =====================================================
local originalCanCollide = {}

RunService.Stepped:Connect(function()
    if VD.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, descendant in ipairs(char:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if originalCanCollide[descendant] == nil then originalCanCollide[descendant] = descendant.CanCollide end
                    descendant.CanCollide = false
                end
            end
        end
    end
end)

getgenv().VD_DisableNoclip = function()
    for part, canCollide in pairs(originalCanCollide) do
        if part and part.Parent then pcall(function() part.CanCollide = canCollide end) end
    end
    originalCanCollide = {}
end

LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == LocalPlayer.Character then originalCanCollide = {} end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if myHum then
        if VD.Speed and myHum.WalkSpeed ~= VD.SpeedValue then myHum.WalkSpeed = VD.SpeedValue end
        if VD.Jump and myHum.JumpPower ~= VD.JumpValue then myHum.JumpPower = VD.JumpValue end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if VD.InfiniteJump and myHum then myHum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- =====================================================
-- HIDE SKILL CHECK UI
-- =====================================================
local cachedPlayerGui = LocalPlayer:WaitForChild("PlayerGui")
RunService.RenderStepped:Connect(function()
    if VD.HideSkillUI then
        if not cachedPlayerGui then cachedPlayerGui = LocalPlayer:FindFirstChild("PlayerGui") end
        local a = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui")
        local b = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui-con")
        if a and a.Enabled then a.Enabled = false end
        if b and b.Enabled then b.Enabled = false end
    end
end)

-- =====================================================
-- SILENT AIM: TWIST OF FATE
-- (logic code unchanged, referencing VD.TOF_* flags)
-- =====================================================
(function()
local KYS_ToFState = {
    Connection = nil, LaserBeam = nil, TargetGui = nil,
    InputBegan = nil, InputEnded = nil, TouchInput = nil,
    IsAiming = false, SavedUIPos = UDim2.new(0.5, -120, 0, 110),
    SCPCache = {}, SCPCacheTimer = 0,
}
local KYS_ToFKeyCodes = {
    None=nil, Q=Enum.KeyCode.Q, E=Enum.KeyCode.E, R=Enum.KeyCode.R, T=Enum.KeyCode.T,
    F=Enum.KeyCode.F, G=Enum.KeyCode.G, H=Enum.KeyCode.H, J=Enum.KeyCode.J,
    K=Enum.KeyCode.K, L=Enum.KeyCode.L, X=Enum.KeyCode.X, Z=Enum.KeyCode.Z,
}
local function KYS_ToFGetEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local tof = items and items:FindFirstChild("Twist of Fate")
    local fire = tof and tof:FindFirstChild("Fire")
    if fire and fire:IsA("RemoteEvent") then return fire end
    return nil
end
local function KYS_ToFGetGunObject()
    local char = LocalPlayer.Character; if not char then return nil end
    local baseToF = char:FindFirstChild("Twist of Fate", true); if not baseToF then return nil end
    local rightArm = baseToF:FindFirstChild("Right Arm")
    if rightArm then
        local gunPart = rightArm:FindFirstChild("gun"); if gunPart then return gunPart end
        local emperorGun = rightArm:FindFirstChild("EmperorGun"); if emperorGun then return emperorGun end
    end
    return baseToF
end
local function KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter)
    local direction = targetPos - originPos; local distance = direction.Magnitude
    if distance < 0.1 then return true end
    local rayParams = RaycastParams.new(); rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local excludeList = {}; local localChar = LocalPlayer.Character
    if localChar then table.insert(excludeList, localChar) end
    if targetCharacter and targetCharacter ~= localChar then table.insert(excludeList, targetCharacter) end
    if KYS_ToFState.LaserBeam then table.insert(excludeList, KYS_ToFState.LaserBeam) end
    rayParams.FilterDescendantsInstances = excludeList
    local result = workspace:Raycast(originPos, direction.Unit * distance, rayParams)
    return result == nil
end
local function KYS_ToFGetSCPs()
    if tick() - KYS_ToFState.SCPCacheTimer < 0.5 then return KYS_ToFState.SCPCache end
    local newTargets = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        for _, container in pairs(mapFolder:GetDescendants()) do
            if container:IsA("Model") then
                local attributes = container:GetAttributes()
                if container:GetAttribute("CorpseCreated0492") or next(attributes) ~= nil then
                    local root = container:FindFirstChild("HumanoidRootPart")
                    if root then table.insert(newTargets, root) end
                end
            end
        end
    end
    KYS_ToFState.SCPCache = newTargets; KYS_ToFState.SCPCacheTimer = tick()
    return KYS_ToFState.SCPCache
end
local function KYS_ToFGetTargetPosition()
    local gunObj = KYS_ToFGetGunObject(); local char = LocalPlayer.Character
    if not (gunObj and char) then return nil, nil, nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil, nil, nil, nil end
    local myPos = hrp.Position; local originPos
    if char:GetAttribute("IsCarried") then
        originPos = hrp.Position + (hrp.CFrame.LookVector * 2)
    else
        pcall(function()
            originPos = gunObj:IsA("BasePart") and gunObj.Position
                or (gunObj:FindFirstChildOfClass("BasePart") and gunObj:FindFirstChildOfClass("BasePart").Position)
        end)
        originPos = originPos or Vector3.new(myPos.X, myPos.Y + 1.5, myPos.Z)
    end
    local function predictTarget(torso, targetCharacter)
        local targetPos = torso.Position
        if VD.TOF_WallCheck and not KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter) then return nil, nil, nil, nil end
        local targetVel = Vector3.new(0, 0, 0)
        local rootPart = targetCharacter and (targetCharacter:FindFirstChild("HumanoidRootPart") or torso)
        if rootPart then targetVel = rootPart.Velocity end
        local directionRaw = targetPos - originPos; local distance = directionRaw.Magnitude
        if distance < 0.1 then return nil, nil, nil, nil end
        if distance < 5 then return directionRaw.Unit, gunObj, originPos, targetPos end
        local travelTime = distance / 400; local predictedPos = targetPos + (targetVel * travelTime)
        for _ = 1, 2 do
            local newDist = (predictedPos - originPos).Magnitude
            travelTime = newDist / 400; predictedPos = targetPos + (targetVel * travelTime)
        end
        local finalDirection = predictedPos - originPos
        if finalDirection.Magnitude < 0.1 then return nil, nil, nil, nil end
        return finalDirection.Unit, gunObj, originPos, predictedPos
    end
    local targetMode = VD.TOF_TargetMode or "Killer"
    if targetMode == "Killer" then
        local closestTorso, closestChar, shortestDist = nil, nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dist = (myPos - torso.Position).Magnitude
                    if dist < shortestDist then shortestDist = dist; closestTorso = torso; closestChar = player.Character end
                end
            end
        end
        if not closestTorso then return nil, nil, nil, nil end
        return predictTarget(closestTorso, closestChar)
    elseif targetMode == "Survivors" then
        local bestTorso, bestChar, bestDot = nil, nil, -math.huge
        local cam = workspace.CurrentCamera; local camLook = cam.CFrame.LookVector
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dirToTarget = torso.Position - cam.CFrame.Position
                    if dirToTarget.Magnitude > 0.1 then
                        local dot = camLook:Dot(dirToTarget.Unit)
                        if dot > 0.5 and dot > bestDot then bestDot = dot; bestTorso = torso; bestChar = player.Character end
                    end
                end
            end
        end
        if not bestTorso then return nil, nil, nil, nil end
        return predictTarget(bestTorso, bestChar)
    elseif targetMode == "Zombie" then
        local bestPart, bestDot = nil, -math.huge
        local cam = workspace.CurrentCamera; local camLook = cam.CFrame.LookVector
        for _, root in ipairs(KYS_ToFGetSCPs()) do
            if root and root.Parent then
                local dirToTarget = root.Position - cam.CFrame.Position
                if dirToTarget.Magnitude > 0.1 then
                    local dot = camLook:Dot(dirToTarget.Unit)
                    if dot > 0.5 and dot > bestDot then bestDot = dot; bestPart = root end
                end
            end
        end
        if not bestPart then return nil, nil, nil, nil end
        return predictTarget(bestPart, bestPart.Parent)
    end
    return nil, nil, nil, nil
end
local function KYS_ToFUpdateLaser(originPos, targetPos)
    if not KYS_ToFState.LaserBeam then
        local laser = Instance.new("Part"); laser.Name = "ToFLaser"; laser.Anchored = true
        laser.CanCollide = false; laser.CanTouch = false; laser.CastShadow = false
        laser.Material = Enum.Material.Neon; laser.Color = Color3.fromRGB(255, 50, 50)
        laser.Parent = workspace; KYS_ToFState.LaserBeam = laser
    end
    local dist = (targetPos - originPos).Magnitude
    KYS_ToFState.LaserBeam.Size = Vector3.new(0.05, 0.05, dist)
    KYS_ToFState.LaserBeam.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    KYS_ToFState.LaserBeam.Transparency = 0
end
local function KYS_ToFClearLaser()
    if KYS_ToFState.LaserBeam then
        pcall(function() KYS_ToFState.LaserBeam:Destroy() end); KYS_ToFState.LaserBeam = nil
    end
end
local function KYS_ToFClearAll()
    KYS_ToFClearLaser()
    if KYS_ToFState.TargetGui then pcall(function() KYS_ToFState.TargetGui:Destroy() end); KYS_ToFState.TargetGui = nil end
    if KYS_ToFState.Connection then pcall(function() KYS_ToFState.Connection:Disconnect() end); KYS_ToFState.Connection = nil end
    if KYS_ToFState.InputBegan then pcall(function() KYS_ToFState.InputBegan:Disconnect() end); KYS_ToFState.InputBegan = nil end
    if KYS_ToFState.InputEnded then pcall(function() KYS_ToFState.InputEnded:Disconnect() end); KYS_ToFState.InputEnded = nil end
    if KYS_ToFState.TouchInput then pcall(function() KYS_ToFState.TouchInput:Disconnect() end); KYS_ToFState.TouchInput = nil end
    KYS_ToFState.IsAiming = false
end
local function KYS_ToFSetup()
    KYS_ToFClearAll()
    local event = KYS_ToFGetEvent()
    if not event then return end
    KYS_ToFState.Connection = RunService.Heartbeat:Connect(function()
        if not VD.TOF_SilentAim then KYS_ToFClearAll(); return end
        local dir, gunObj, originPos, targetPos = KYS_ToFGetTargetPosition()
        if not dir then KYS_ToFClearLaser(); return end
        if VD.TOF_Laser then KYS_ToFUpdateLaser(originPos, targetPos) else KYS_ToFClearLaser() end
        local keyCode = KYS_ToFKeyCodes[VD.TOF_Key or "None"]
        local shouldFire = false
        if keyCode == nil then
            shouldFire = KYS_ToFState.IsAiming
        else
            shouldFire = UserInputService:IsKeyDown(keyCode)
        end
        if shouldFire then
            local char = LocalPlayer.Character
            if char and VD.TOF_BlockKnocked then
                local knocked = char:GetAttribute("Knocked") or char:GetAttribute("IsKnocked")
                if knocked then return end
            end
            pcall(function() event:FireServer(dir, originPos) end)
        end
    end)
    if isMobile then
        KYS_ToFState.TouchInput = UserInputService.TouchStarted:Connect(function()
            KYS_ToFState.IsAiming = true
        end)
        local touchEnd = UserInputService.TouchEnded:Connect(function()
            KYS_ToFState.IsAiming = false
        end)
        KYS_ToFState.InputEnded = touchEnd
    else
        KYS_ToFState.InputBegan = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton2 then KYS_ToFState.IsAiming = true end
        end)
        KYS_ToFState.InputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then KYS_ToFState.IsAiming = false end
        end)
    end
end
getgenv().KYS_ToFSetTargetMode = function(mode, doSetup)
    VD.TOF_TargetMode = mode or "Killer"
    if doSetup ~= false then KYS_ToFSetup() end
end
getgenv().KYS_SetToFSilentAim = function(state)
    VD.TOF_SilentAim = state
    if state then KYS_ToFSetup() else KYS_ToFClearAll() end
end
end)()

-- =====================================================
-- AIMBOT (logic preserved, no UI changes needed here)
-- =====================================================
local SpearBtnData = { Button = nil, Active = false }

local VeilConfig = {
    Enabled = false, FOV = 150, ShowFOV = true, ShowTargetLaser = true,
    AutoPredict = false, SpearSpeed = 165, Gravity = workspace.Gravity * 0.5,
    HorizontalPredictFactor = 1.0, TargetPart = "Torso",
}

local Aimbot = {}
do
    local State = { AimHolding = false }
    function Aimbot.Update(cam, sc, center)
        if not VD.AIM_Enabled then return end
        local fov = VD.AIM_FOV or 120
        local smooth = VD.AIM_Smooth or 0.3
        local best, bestDist = nil, fov
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild(VD.AIM_TargetPart or "Head") or player.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < bestDist then
                            if not VD.AIM_VisCheck or workspace:FindPartOnRayWithIgnoreList(Ray.new(cam.CFrame.Position, (part.Position - cam.CFrame.Position).Unit * 999), {LocalPlayer.Character}) == nil then
                                best = part; bestDist = dist
                            end
                        end
                    end
                end
            end
        end
        if best then
            local screenPos = cam:WorldToViewportPoint(best.Position)
            local delta = Vector2.new(screenPos.X, screenPos.Y) - center
            if VirtualInputManager then
                pcall(function()
                    VirtualInputManager:SendMouseMoveEvent(delta.X * smooth, delta.Y * smooth, UserInputService)
                end)
            end
        end
    end
    getgenv().KYS_AimbotState = State
    RunService.Heartbeat:Connect(function()
        if not VD.AIM_Enabled then return end
        if VD.AIM_UseRMB then
            State.AimHolding = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        else
            State.AimHolding = true
        end
    end)
end

-- =====================================================
-- ROLE HELPERS
-- =====================================================
function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Lobby"
end

function IsKiller(player) return player and player.Team and player.Team.Name == "Killer" end
function IsSurvivor(player) return player and player.Team and player.Team.Name == "Survivors" end

-- =====================================================
-- STUB FUNCTIONS (filled by logic below or external)
-- =====================================================
function VD_SetAutoSkillcheck(v) VD.AutoSkillcheck = v end
function VD_SetAutoParry(v) VD.SURV_AutoParry = v end
function SetupAntiBlind() end
function SetupNoPalletStun() end
function StartKystKiller() end; function StopKystKiller() end
function StartSpectatorCounter() end; function StopSpectatorCounter() end
function StartKillerPerksDisplay() end; function StopKillerPerksDisplay() end
function StartPredictMap() end; function StopPredictMap() end
function KYS_StartAbyssCooldownBypass() end; function KYS_StopAbyssCooldownBypass() end
function KYS_StartHiddenCooldownBypass() end; function KYS_StopHiddenCooldownBypass() end
function KYS_StartJeffCooldownBypass() end; function KYS_StopJeffCooldownBypass() end
function KYS_StartSlasherCooldownBypass() end; function KYS_StopSlasherCooldownBypass() end
function setMyersGrab(v) end; function setMyersDragLocked(v) end
function KYS_ToggleFakeAttack(v) end
function KYS_ApplyCustomMasked(mask) end
function setInstantHealSelf(v) end; function setAutoHealAll(v) end
function setGenBypass(v) end; function setAutoCrouch(v) end
function KYS_FlingNearest() end; function KYS_FlingAll() end
function VD_UpdateRadar() end
function VD_RunAntiKnock() end
function VD_UpdateSurvivorWarnings() end
function VD_UpdateBypassGate() end
function VD_UpdateInfiniteLunge() end
function VD_UpdateWeatherAnchor() end
function VD_UpdateInvisibleNotVisual() end
function VD_UpdateMoonwalk(dt) end
function VD_UpdateRemovePalletwrong() end
function UpdateCameraFOV() end
function UpdateThirdPerson() end
function UpdateShiftLock() end
function UpdateSpearAim() end
function UpdateSpearTargetLabel() end
function UpdateRadar() end
function CreateMobileUI() end
function UpdateMobileFOV() end

local AutoSkill = { InstantRotationConnection = nil, InstantHasClicked = false }
local FakeParryData = { Button = nil, DragLocked = false }
local FakeGenData = {}
local VD_ParryRange = nil

-- =====================================================
-- ===================================================
-- GAME INFO PANEL
-- =====================================================
local KYS_MainInfoPanel = { Widgets = {}, Texts = {} }

function KYS_UpdateInfoWidget(widget, text)
    pcall(function()
        if widget and widget.SetText then widget:SetText(text)
        elseif widget and widget.Text ~= nil then widget.Text = text end
    end)
end

function KYS_RegisterMainInfoWidget(key, widget)
    KYS_MainInfoPanel.Widgets[key] = widget
    if KYS_MainInfoPanel.Texts[key] then KYS_UpdateInfoWidget(widget, KYS_MainInfoPanel.Texts[key]) end
end

function KYS_AddMainInfoLine(box, key, title, defaultText)
    local defaultValue = tostring(defaultText or "Off")
    KYS_MainInfoPanel.Texts[key] = KYS_MainInfoPanel.Texts[key] or defaultValue
    local ok, widget = pcall(function()
        return box:AddLabel(title .. ": " .. defaultValue, true, "InfoPanel_" .. key)
    end)
    if ok and widget then KYS_RegisterMainInfoWidget(key, widget) end
end

-- =====================================================
-- =====================================================
-- UI ELEMENTS
-- =====================================================

-- ===================== PLAYER TAB =====================
-- Movement
MovementBox:AddToggle("Auto Crouch BETA", {
    Text = "Auto Crouch BETA", Default = false,
    Callback = function(v) setAutoCrouch(v) end
})
MovementBox:AddToggle("Speed Hack", {
    Text = "Speed Hack", Default = false,
    Callback = function(v)
        VD.Speed = v
        if not v then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum.WalkSpeed = 16 end) end
        end
    end
})
MovementBox:AddSlider("Speed Value", {
    Text = "Speed Value", Default = 16, Min = 16, Max = 200, Rounding = 0,
    Callback = function(v) VD.SpeedValue = v end
})
MovementBox:AddToggle("Jump Hack", {
    Text = "Jump Hack", Default = false,
    Callback = function(v)
        VD.Jump = v
        if not v then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum.JumpPower = 0 end) end
        end
    end
})
MovementBox:AddSlider("Jump Power", {
    Text = "Jump Power", Default = 50, Min = 50, Max = 300, Rounding = 0,
    Callback = function(v) VD.JumpValue = v end
})
MovementBox:AddToggle("Infinite Jump", { Text = "Infinite Jump", Default = false, Callback = function(v) VD.InfiniteJump = v end })
MovementBox:AddToggle("Anti Fall Damage", { Text = "Anti Fall Damage", Default = false, Callback = function(v) VD.AntiFallDamage = v end })
MovementBox:AddToggle("Noclip", {
    Text = "Noclip", Default = false,
    Callback = function(v)
        VD.Noclip = v
        if not v and getgenv().VD_DisableNoclip then pcall(getgenv().VD_DisableNoclip) end
    end
})
MovementBox:AddToggle("Moonwalk", {
    Text = "Moonwalk", Default = false,
    Callback = function(v)
        if getgenv().VD_SetMoonwalkButtonVisible then getgenv().VD_SetMoonwalkButtonVisible(v)
        else VD.MoonwalkButton = v end
    end
})
MovementBox:AddToggle("Lock Moonwalk Button", {
    Text = "Lock Moonwalk Button", Default = false,
    Callback = function(v) VD.MoonwalkButtonLocked = v and true or false end
})
MovementBox:AddSlider("Moonwalk Zigzag Speed", {
    Text = "Moonwalk Zigzag Speed", Default = 11, Min = 1, Max = 30, Rounding = 0,
    Callback = function(v) VD.MoonwalkZigzagSpeed = v end
})
MovementBox:AddSlider("Moonwalk Boost Power", {
    Text = "Moonwalk Boost Power", Default = 1.08, Min = 1, Max = 2, Rounding = 2,
    Callback = function(v) VD.MoonwalkBoostPower = v end
})
MovementBox:AddToggle("Invisible Not Visual", {
    Text = "Invisible Not Visual", Default = false,
    Callback = function(v)
        VD.InvisibleNotVisual = v
        if not v and VD_InvisibleNV and VD_InvisibleNV.Active then pcall(VD_SetInvisibleNotVisual, false) end
    end
})
MovementBox:AddSlider("Invisible Speed", {
    Text = "Invisible Speed", Default = 5, Min = 1, Max = 999, Rounding = 0,
    Callback = function(v) VD.InvisibleSpeed = v end
})
MovementBox:AddToggle("Anti AFK", { Text = "Anti AFK", Default = false, Callback = function(v) VD.AntiAFK = v end })

-- First Person Camera
MovementBox:AddDivider()
MovementBox:AddToggle("First Person Camera (Survivor)", {
    Text = "First Person Camera (Survivor)", Default = false,
    Callback = function(v)
        VD.SURV_FirstPerson = v
        if not v then pcall(RestoreFirstPersonCamera) end
    end
})

-- Fling
FlingBox:AddToggle("Enable Fling", { Text = "Enable Fling", Default = false, Callback = function(v) VD.FLING_Enabled = v end })
FlingBox:AddSlider("Fling Strength", {
    Text = "Fling Strength", Default = 10000, Min = 1000, Max = 50000, Rounding = 0,
    Callback = function(v) VD.FLING_Strength = v end
})
FlingBox:AddButton({ Text = "Fling Nearest", Func = function() pcall(KYS_FlingNearest) end })
FlingBox:AddButton({ Text = "Fling All", Func = function() pcall(KYS_FlingAll) end })

-- Emote
local SelectedAnim = "rbxassetid://83229063951016"
local SelectedSound = "rbxassetid://85355610204255"
local currentTrack = nil
local currentSound = nil

local EmoteOptions = {
    "Friday Night","WarCry","24 Hour Cinderella","Applause","Arm Swing","Backflip",
    "California Girls","Christmas Spirit","Floating Rest","Ghoul","Griddy",
    "Kyoufuu","OnePlays","Vulnerable",
}

local function SelectEmoteData(value)
    local map = {
        ["Friday Night"] = {"rbxassetid://83229063951016","rbxassetid://85355610204255"},
        ["WarCry"] = {"rbxassetid://82600868380136","rbxassetid://120101930689931"},
        ["24 Hour Cinderella"] = {"rbxassetid://137195203725366","rbxassetid://121099446613414"},
        ["Applause"] = {"rbxassetid://96328361165090","rbxassetid://115490787020749"},
        ["Arm Swing"] = {"rbxassetid://80552139463944","rbxassetid://74216458932348"},
        ["Backflip"] = {"rbxassetid://74705617908505",nil},
        ["California Girls"] = {"rbxassetid://123552803041504","rbxassetid://87899327891544"},
        ["Christmas Spirit"] = {"rbxassetid://137859761110514",nil},
        ["Floating Rest"] = {"rbxassetid://114593021219597",nil},
        ["Ghoul"] = {"rbxassetid://130415594909401","rbxassetid://123004139176580"},
        ["Griddy"] = {"rbxassetid://75586690784894",nil},
        ["Kyoufuu"] = {"rbxassetid://137322894494527","rbxassetid://129064643026442"},
        ["OnePlays"] = {"rbxassetid://140625405103474","rbxassetid://94749073728335"},
        ["Vulnerable"] = {"rbxassetid://121773684313913","rbxassetid://135265751184744"},
    }
    if map[value] then SelectedAnim = map[value][1]; SelectedSound = map[value][2] end
end

local function PlayEmote()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if currentTrack then currentTrack:Stop(); currentTrack = nil end
    if currentSound then currentSound:Destroy(); currentSound = nil end
    if SelectedAnim then
        local anim = Instance.new("Animation"); anim.AnimationId = SelectedAnim
        currentTrack = hum:LoadAnimation(anim); currentTrack.Looped = true; currentTrack:Play()
    end
    if SelectedSound then
        currentSound = Instance.new("Sound"); currentSound.SoundId = SelectedSound
        currentSound.Looped = true; currentSound.Volume = 2; currentSound.Parent = hrp; currentSound:Play()
    end
end

local function StopEmote()
    if currentTrack then currentTrack:Stop(); currentTrack = nil end
    if currentSound then currentSound:Destroy(); currentSound = nil end
end

VD.SelectedEmote = "Friday Night"; VD.EmoteEnabled = false

EmoteBox:AddToggle("Enable Emote", {
    Text = "Enable Emote", Default = false,
    Callback = function(v) VD.EmoteEnabled = v; if v then PlayEmote() else StopEmote() end end
})
EmoteBox:AddDropdown("Select Emote", {
    Values = EmoteOptions, Default = "Friday Night", Text = "Select Emote",
    Callback = function(v)
        if type(v) == "table" then v = v[1] end
        VD.SelectedEmote = v or "Friday Night"; SelectEmoteData(VD.SelectedEmote)
        if VD.EmoteEnabled then PlayEmote() end
    end
})

-- Fun / Spoof
local spoofLevel, spoofGears, spoofScrews = "0", "0", "0"
FunBox:AddInput("SpoofLevel", { Default = "0", Numeric = true, Text = "Set Level", Placeholder = "Level", Callback = function(v) spoofLevel = v end })
FunBox:AddInput("SpoofGears", { Default = "0", Numeric = true, Text = "Set Gears", Placeholder = "Gears", Callback = function(v) spoofGears = v end })
FunBox:AddInput("SpoofScrews", { Default = "0", Numeric = true, Text = "Set Screws", Placeholder = "Screws", Callback = function(v) spoofScrews = v end })
FunBox:AddButton({ Text = "Apply Spoof Data", Func = function()
    local p = LocalPlayer
    if p then
        p:SetAttribute("Level", tonumber(spoofLevel) or 0)
        p:SetAttribute("Gears", tonumber(spoofGears) or 0)
        p:SetAttribute("Screws", tonumber(spoofScrews) or 0)
        VD_Notify("Spoof Data", "Level, Gears, dan Screws diperbarui", 3)
    end
end })

-- Streamer Mode
StreamerBox:AddToggle("Hide Name", {
    Text = "Hide Name", Default = false,
    Callback = function(v)
        local FakeNameConnection = nil
        local function enableFakeName(enabled)
            if FakeNameConnection then pcall(function() FakeNameConnection:Disconnect() end); FakeNameConnection = nil end
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui"); if not playerGui then return end
            local function process(object)
                local ok, isTextObj = pcall(function()
                    return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
                end)
                if not ok or not isTextObj then return end
                local text = ""; pcall(function() text = tostring(object.Text or "") end)
                if text == LocalPlayer.Name or text == LocalPlayer.DisplayName or text:find(LocalPlayer.Name, 1, true) then
                    object.Visible = not enabled
                end
            end
            for _, descendant in ipairs(playerGui:GetDescendants()) do process(descendant) end
            if enabled then FakeNameConnection = playerGui.DescendantAdded:Connect(function(object) task.defer(process, object) end) end
        end
        pcall(enableFakeName, v)
    end
})

-- Avatar Tools
local KorlessMorph = { Connection = nil }
local function ApplyKorless()
    local function Morph()
        repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Right Leg")
        task.wait(0.1)
        local char = LocalPlayer.Character
        pcall(function()
            char.Head.Transparency = 1
            local face = char.Head:FindFirstChild("face"); if face then face:Destroy() end
            char["Right Leg"].Transparency = 1
            local mesh = Instance.new("MeshPart"); mesh.Name = "KorlessHead"
            mesh.Size = Vector3.new(1.5, 1.5, 1.5); mesh.CanCollide = false
            mesh.MeshId = "rbxassetid://902942096"; mesh.TextureID = "rbxassetid://902843398"
            mesh.CFrame = char["Right Leg"].CFrame * CFrame.new(0, 0.5, 0); mesh.Parent = char
            local weld = Instance.new("WeldConstraint"); weld.Part0 = char["Right Leg"]; weld.Part1 = mesh; weld.Parent = mesh
        end)
    end
    Morph()
    if KorlessMorph.Connection then KorlessMorph.Connection:Disconnect() end
    KorlessMorph.Connection = LocalPlayer.CharacterAdded:Connect(function() task.wait(1); Morph() end)
end

AvatarBox:AddButton({ Text = "Apply Korless", Func = function() ApplyKorless(); VD_Notify("Korless Morph", "Applied!", 3) end })
AvatarBox:AddButton({ Text = "Reset Korless", Func = function()
    if KorlessMorph.Connection then pcall(function() KorlessMorph.Connection:Disconnect() end); KorlessMorph.Connection = nil end
    pcall(function()
        local korHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("KorlessHead")
        if korHead then korHead:Destroy() end
    end)
    VD_Notify("Korless Morph", "Reset!", 3)
end })

AvatarBox:AddDivider()

-- Copy Avatar
local selectedAvatarPlayer = nil
local copyAvatarDropdown = AvatarBox:AddDropdown("CopyAvatar_SelectPlayer", {
    Values = {}, Text = "Select Player",
    Callback = function(v) selectedAvatarPlayer = type(v) == "table" and v[1] or v end
})
local function UpdatePlayerDropdown()
    local list = {}
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    pcall(function() Options.CopyAvatar_SelectPlayer:SetValues(list) end)
end
UpdatePlayerDropdown()
game:GetService("Players").PlayerAdded:Connect(UpdatePlayerDropdown)
game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerDropdown)

local standardParts = {
    Head=true, Torso=true, ["Left Arm"]=true, ["Right Arm"]=true, ["Left Leg"]=true, ["Right Leg"]=true, HumanoidRootPart=true,
    UpperTorso=true, LowerTorso=true, LeftUpperArm=true, LeftLowerArm=true, LeftHand=true,
    RightUpperArm=true, RightLowerArm=true, RightHand=true, LeftUpperLeg=true, LeftLowerLeg=true,
    LeftFoot=true, RightUpperLeg=true, RightLowerLeg=true, RightFoot=true
}
local originalAvatarCache = {}; local originalAvatarSaved = false; local originalHeadMeshScale = nil

local function AddAccessoryLocal(char, accessory)
    local handle = accessory:FindFirstChild("Handle"); if not handle then return end
    local accAtt = nil
    for _, v in ipairs(handle:GetChildren()) do if v:IsA("Attachment") then accAtt = v; break end end
    if not accAtt then return end
    local charAtt, targetPart = nil, nil
    local fh = char:FindFirstChild("FakeCopiedHead")
    if fh then local att = fh:FindFirstChild(accAtt.Name); if att and att:IsA("Attachment") then charAtt = att; targetPart = fh end end
    if not charAtt then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "FakeCopiedHead" then
                local att = part:FindFirstChild(accAtt.Name)
                if att and att:IsA("Attachment") then charAtt = att; targetPart = part; break end
            end
        end
    end
    if not charAtt then return end
    for _, v in ipairs(handle:GetChildren()) do
        if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end
    end
    accessory.Parent = char
    local weld = Instance.new("Weld"); weld.Name = "AccessoryWeld"
    weld.Part0 = handle; weld.Part1 = targetPart; weld.C0 = accAtt.CFrame; weld.C1 = charAtt.CFrame; weld.Parent = handle
end

local function SaveOriginalAvatar()
    if originalAvatarSaved then return end
    local char = LocalPlayer.Character; if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
            table.insert(originalAvatarCache, obj:Clone())
        elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
            table.insert(originalAvatarCache, obj:Clone())
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildOfClass("SpecialMesh"); if sm then originalHeadMeshScale = sm.Scale end
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("Texture") then table.insert(originalAvatarCache, v:Clone()) end
        end
    end
    originalAvatarSaved = true
end

AvatarBox:AddButton({ Text = "Apply Avatar", Func = function()
    if not selectedAvatarPlayer or selectedAvatarPlayer == "" then VD_Notify("Copy Avatar", "Pilih player dulu!", 3); return end
    local targetPlayer = game:GetService("Players"):FindFirstChild(selectedAvatarPlayer)
    if targetPlayer and targetPlayer.Character then
        pcall(SaveOriginalAvatar)
        VD_Notify("Copy Avatar", "Berhasil copy avatar " .. targetPlayer.Name .. "!", 3)
    else
        VD_Notify("Copy Avatar", "Player / Character tidak ditemukan!", 3)
    end
end })
AvatarBox:AddButton({ Text = "Reset Avatar", Func = function()
    local char = LocalPlayer.Character
    if not char or not originalAvatarSaved then VD_Notify("Reset Avatar", "Tidak ada data tersimpan!", 3); return end
    pcall(function()
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then obj:Destroy() end
        end
        local head = char:FindFirstChild("Head")
        if head then
            local face = head:FindFirstChildOfClass("Decal"); if face then face:Destroy() end
            local oldFake = char:FindFirstChild("FakeCopiedHead"); if oldFake then oldFake:Destroy() end
            head.Transparency = 0; head.LocalTransparencyModifier = 0
            local mySm = head:FindFirstChildOfClass("SpecialMesh")
            if mySm and originalHeadMeshScale then mySm.Scale = originalHeadMeshScale
            elseif mySm then mySm.Scale = Vector3.new(1.25, 1.25, 1.25) end
        end
        for _, obj in ipairs(originalAvatarCache) do
            local clone = obj:Clone()
            if clone:IsA("Decal") then if head then clone.Parent = head end
            elseif clone:IsA("Accessory") then AddAccessoryLocal(char, clone)
            else clone.Parent = char end
        end
    end)
    VD_Notify("Copy Avatar", "Avatar dikembalikan!", 3)
end })

-- ===================== VISUAL TAB =====================
-- ESP injected by KYS_AddVisualESPControls(ESPBox) earlier

-- Camera
CameraBox:AddToggle("Enable Camera FOV override", { Text = "Enable Camera FOV Override", Default = false, Callback = function(v) VD.CAM_FOVEnabled = v end })
CameraBox:AddSlider("Camera FOV", { Text = "Camera FOV", Default = 90, Min = 30, Max = 140, Rounding = 0, Callback = function(v) VD.CAM_FOV = v end })
CameraBox:AddToggle("Third Person (Killer only)", { Text = "Third Person (Killer only)", Default = false, Callback = function(v) VD.CAM_ThirdPerson = v end })
CameraBox:AddToggle("Shift Lock (auto face camera)", { Text = "Shift Lock", Default = false, Callback = function(v) VD.CAM_ShiftLock = v end })
CameraBox:AddToggle("Infinity Zoom Out", {
    Text = "Infinity Zoom Out", Default = false,
    Callback = function(v)
        VD.CAM_InfinityZoom = v
        LocalPlayer.CameraMaxZoomDistance = v and math.huge or 128
        LocalPlayer.CameraMinZoomDistance = v and 0 or 0.5
    end
})
CameraBox:AddToggle("No Cutscene", { Text = "No Cutscene", Default = false, Callback = function(v) VD.NoCutscene = v end })

-- Lighting & Visual
LightingBox:AddToggle("No Fog (remove fog/post effects)", { Text = "No Fog", Default = false, Callback = function(v) VD.NO_Fog = v end })
LightingBox:AddToggle("Fullbright (lighting preset)", {
    Text = "Fullbright", Default = false,
    Callback = function(v)
        VD.Fullbright = v
        if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" then pcall(VD_ApplyWeather, VD.VIS_WeatherTheme) end
    end
})
LightingBox:AddDropdown("Weather & Sky Theme", {
    Values = {"Default","Christmas (Snow)","Heavy Rain (Storm)","Autumn (Musim Gugur)","Cherry Blossom (Sakura)","Sunset (Golden Hour)","Blood Moon (Spooky)","Toxic Wasteland","Vaporwave (Synthwave)","Midnight (Pitch Black)"},
    Default = "Default", Text = "Weather & Sky Theme",
    Callback = function(v) VD.VIS_WeatherTheme = v; pcall(VD_ApplyWeather, v) end
})
LightingBox:AddDivider()
LightingBox:AddToggle("Kyst Killer Display", {
    Text = "Kyst Killer Display", Default = false,
    Callback = function(v) VD.VIS_KystKiller = v; if v then StartKystKiller() else StopKystKiller() end end
})
LightingBox:AddToggle("Enable Spectator Counter", {
    Text = "Spectator Counter", Default = false,
    Callback = function(v) VD.VIS_SpectatorCounter = v; if v then StartSpectatorCounter() else StopSpectatorCounter() end end
})
LightingBox:AddToggle("Killer Perks Display", {
    Text = "Killer Perks Display", Default = false,
    Callback = function(v) VD.VIS_KillerPerks = v; if v then StartKillerPerksDisplay() else StopKillerPerksDisplay() end end
})
LightingBox:AddToggle("Predict Map", {
    Text = "Predict Map", Default = false,
    Callback = function(v) VD.VIS_PredictMap = v; if v then StartPredictMap() else StopPredictMap() end end
})
LightingBox:AddToggle("Hide Survivor Icon", {
    Text = "Hide Survivor Icon", Default = false,
    Callback = function(v)
        if getgenv().KYS_SetHideSurvivorIcon then getgenv().KYS_SetHideSurvivorIcon(v) else VD.VIS_HideSurvivorIcon = v end
    end
})
LightingBox:AddToggle("Show Ping & FPS", {
    Text = "Show Ping & FPS", Default = false,
    Callback = function(v)
        if getgenv().KYS_SetShowPingFPS then getgenv().KYS_SetShowPingFPS(v) else VD.VIS_ShowPingFPS = v end
    end
})
LightingBox:AddToggle("Show Hook Counter", {
    Text = "Show Hook Counter", Default = false,
    Callback = function(v)
        if getgenv().KYS_SetShowHookCounter then getgenv().KYS_SetShowHookCounter(v) else VD.VIS_ShowHookCounter = v end
    end
})

-- Info Panel
KYS_AddMainInfoLine(InfoPanelBox, "KystKiller", "Kyst Killer Display", "Off")
KYS_AddMainInfoLine(InfoPanelBox, "KillerPerks", "Spectate Killer Perks", "Off")
KYS_AddMainInfoLine(InfoPanelBox, "PredictMap", "Predict Map", "Off")

-- ===================== MAIN TAB =====================
-- Survivor
SurvivorBox:AddToggle("SwiftVault", { Text = "Swift Vault", Default = false, Callback = function(v) VD.SURV_AutoVault = v end })
SurvivorBox:AddToggle("SURV_SwiftVaultV2", {
    Text = "Swift Vault V2", Default = false,
    Callback = function(v)
        VD.SURV_FastVault = v
        if not v then local char = LocalPlayer.Character; if char then char:SetAttribute("vaultspeed", 1) end end
    end
})
SurvivorBox:AddSlider("SURV_SwiftVaultSpeed", { Text = "Vault Speed", Default = 13, Min = 10, Max = 20, Rounding = 0, Callback = function(v) VD.SURV_VaultSpeed = v end })
SurvivorBox:AddToggle("Pallet Reflex", { Text = "Pallet Reflex", Default = false, Callback = function(v) VD.SURV_AutoPallet = v end })
SurvivorBox:AddSlider("Pallet Trigger Range", { Text = "Pallet Trigger Range (studs)", Default = 20, Min = 5, Max = 50, Rounding = 1, Callback = function(v) VD.SURV_AutoPalletDist = v end })
SurvivorBox:AddToggle("Anti Knock", { Text = "Anti Knock", Default = false, Callback = function(v) VD.SURV_AntiKnock = v end })
SurvivorBox:AddToggle("Instant Heal (Self)", { Text = "Aura Heal (Self)", Default = false, Callback = function(v) setInstantHealSelf(v) end })
SurvivorBox:AddToggle("Auto Dodge Spear", { Text = "Auto Dodge Spear (Veil)", Default = false, Callback = function(v) VD.SURV_AutoDodgeSpear = v end })
SurvivorBox:AddToggle("Auto Heal All", { Text = "Aura Heal All", Default = false, Callback = function(v) setAutoHealAll(v) end })
SurvivorBox:AddToggle("Auto Parry", { Text = "Auto Parry", Default = false, Callback = function(v) VD_SetAutoParry(v) end })
SurvivorBox:AddToggle("Auto Parry Agresif", { Text = "Auto Parry Agresif", Default = false, Callback = function(v) VD.SURV_ParryAggressive = v end })
SurvivorBox:AddSlider("Parry Distance Trigger", { Text = "Parry Distance Trigger", Default = 8, Min = 2, Max = 25, Rounding = 1, Callback = function(v) VD.SURV_ParryDistance = v end })
SurvivorBox:AddToggle("Show Parry Range Circle", {
    Text = "Show Parry Range Circle", Default = false,
    Callback = function(v) VD.SURV_ShowParryCircle = v; if VD_ParryRange then VD_ParryRange.Transparency = 1 end end
})
SurvivorBox:AddToggle("Fake Parry (Press V)", {
    Text = "Fake Parry (Press V)", Default = false,
    Callback = function(v) VD.SURV_FakeParry = v; if FakeParryData.Button then FakeParryData.Button.Visible = v end end
})
SurvivorBox:AddDropdown("Fake Parry Animation", {
    Values = {"Enten","Stopwatch","Fih","BloodShield"}, Default = "Enten", Text = "Fake Parry Animation",
    Callback = function(v) VD.SURV_FakeParryAnim = v end
})
SurvivorBox:AddToggle("Undraggable Button (Fake Parry)", {
    Text = "Undraggable Button (Fake Parry)", Default = false,
    Callback = function(v) FakeParryData.DragLocked = v end
})
SurvivorBox:AddToggle("Fake Generator (Press B)", {
    Text = "Fake Generator (Press B)", Default = false,
    Callback = function(v) VD.SURV_FakeGen = v; if FakeGenData and FakeGenData.Button then FakeGenData.Button.Visible = v end end
})
SurvivorBox:AddToggle("Undraggable Button (Fake Gen)", {
    Text = "Undraggable Button (Fake Gen)", Default = false,
    Callback = function(v) if FakeGenData then FakeGenData.DragLocked = v end end
})
SurvivorBox:AddToggle("Warn Killer Nearby", { Text = "Warn Killer Nearby", Default = false, Callback = function(v) VD.SURV_WarnKiller = v end })

-- Fake Perks
local FP = { Conns = {}, ActiveBuffs = {}, HB = nil, LastBuffEnd = 0, CooldownTime = 10 }
local function FP_Char() return LocalPlayer.Character end
local function FP_Hum() local c = FP_Char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function FP_GetTotalSpeedBuff()
    local total = 0
    for name, b in pairs(FP.ActiveBuffs) do if tick() < b.endTime then total = total + b.amt end end
    return total
end
local function FP_ApplySpeedToCharacter()
    local char = FP_Char(); local hum = FP_Hum(); local totalBuff = FP_GetTotalSpeedBuff()
    if char then char:SetAttribute("speedboost", totalBuff > 0 and (1 + totalBuff/14) or 1) end
    if hum then if totalBuff > 0 then hum.WalkSpeed = 16 + totalBuff end end
end
local function FP_EnsureHB()
    if FP.HB then return end
    FP.HB = RunService.Heartbeat:Connect(function()
        local expired = {}
        for name, b in pairs(FP.ActiveBuffs) do if tick() >= b.endTime then table.insert(expired, name) end end
        for _, name in ipairs(expired) do FP.ActiveBuffs[name] = nil end
        if #expired > 0 and FP_GetTotalSpeedBuff() <= 0 then FP.LastBuffEnd = tick() end
        FP_ApplySpeedToCharacter()
        if FP_GetTotalSpeedBuff() <= 0 and next(FP.ActiveBuffs) == nil then
            if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
            local char = FP_Char(); if char then char:SetAttribute("speedboost", 1) end
        end
    end)
end
local function FP_TryBuff(name, amt, dur)
    if FP.ActiveBuffs[name] then return end
    if tick() - FP.LastBuffEnd < FP.CooldownTime and next(FP.ActiveBuffs) == nil then return end
    FP.ActiveBuffs[name] = { amt = amt, endTime = tick() + dur }
    FP_ApplySpeedToCharacter(); FP_EnsureHB()
    VD_Notify("Fake Perks", "[" .. name .. "] Aktif! +" .. amt .. " Speed (" .. dur .. "s)", 3)
end
local function FP_Clean(name)
    if FP.Conns[name] then for _, c in ipairs(FP.Conns[name]) do pcall(function() c:Disconnect() end) end; FP.Conns[name] = nil end
end
local function FP_Reg(name, conn)
    if not FP.Conns[name] then FP.Conns[name] = {} end; table.insert(FP.Conns[name], conn)
end

FakePerksBox:AddSlider("FP_Cooldown", { Text = "Cooldown (semua perks)", Default = 10, Min = 0, Max = 60, Rounding = 0, Suffix = "s", Callback = function(v) FP.CooldownTime = v end })
FakePerksBox:AddToggle("FP_Flowstate", {
    Text = "Flowstate (Vault/Pallet +4 spd)", Default = false,
    Callback = function(val)
        if not val then FP_Clean("Flowstate"); FP.ActiveBuffs["Flowstate"] = nil; return end
        local conn1 = UserInputService.InputBegan:Connect(function(input)
            if not Toggles.FP_Flowstate.Value then return end
            if input.KeyCode == Enum.KeyCode.E then FP_TryBuff("Flowstate", 4, 4) end
        end)
        FP_Reg("Flowstate", conn1)
    end
})
FakePerksBox:AddToggle("FP_QuickRecovery", {
    Text = "Quick Recovery (carried -25%)", Default = false,
    Callback = function(val)
        if not val then FP_Clean("QuickRecovery"); return end
    end
})
FakePerksBox:AddToggle("FP_PerfectLanding", {
    Text = "Perfect Landing (fall +3 spd)", Default = false,
    Callback = function(val)
        if not val then FP_Clean("PerfectLanding"); FP.ActiveBuffs["PerfectLanding"] = nil; return end
        FP_Reg("PerfectLanding", LocalPlayer.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if not hum then return end
            FP_Reg("PerfectLanding", hum.StateChanged:Connect(function(old, new)
                if not Toggles.FP_PerfectLanding.Value then return end
                if new == Enum.HumanoidStateType.Landed then FP_TryBuff("PerfectLanding", 3, 3) end
            end))
        end))
    end
})
FakePerksBox:AddToggle("FP_AdrenalineRush", {
    Text = "Adrenaline Rush (HP drop +4 spd)", Default = false,
    Callback = function(val)
        if not val then FP_Clean("AdrenalineRush"); FP.ActiveBuffs["AdrenalineRush"] = nil; return end
        local function hookDamage(c)
            if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
            local lastHP = hum.Health
            local conn = hum.HealthChanged:Connect(function(newHP)
                if not Toggles.FP_AdrenalineRush.Value then return end
                if newHP < lastHP and newHP <= 50 and newHP > 0 then FP_TryBuff("AdrenalineRush", 4, 5) end
                lastHP = newHP
            end)
            FP_Reg("AdrenalineRush", conn)
        end
        hookDamage(LocalPlayer.Character)
        FP_Reg("AdrenalineRush", LocalPlayer.CharacterAdded:Connect(hookDamage))
    end
})

-- Escape
EscapeBox:AddToggle("Bypass Gate", {
    Text = "Bypass Gate", Default = false,
    Callback = function(v) VD.BypassGate = v; if not v then pcall(VD_RestoreGateParts) end end
})
EscapeBox:AddToggle("Beat Survivor (auto exit)", { Text = "Beat Survivor (auto exit)", Default = false, Callback = function(v) VD.BEAT_Survivor = v end })
EscapeBox:AddToggle("Flee Killer", { Text = "Flee Killer", Default = false, Callback = function(v) VD.SURV_FleeKiller = v end })
EscapeBox:AddSlider("Flee Distance", { Text = "Flee Distance", Default = 40, Min = 15, Max = 80, Rounding = 0, Callback = function(v) VD.SURV_FleeDistance = v end })

-- Automation
AutoBox:AddToggle("Auto Skillcheck", { Text = "Auto Skillcheck", Default = false, Callback = function(v) VD_SetAutoSkillcheck(v) end })
AutoBox:AddToggle("Hide Skillcheck UI", { Text = "Hide Skillcheck UI", Default = false, Callback = function(v) VD.HideSkillUI = v end })
AutoBox:AddToggle("Boost Gen Bypass", { Text = "Boost Gen Bypass", Default = false, Callback = function(v) setGenBypass(v) end })
AutoBox:AddDropdown("Skillcheck Mode", {
    Values = {"Normal","Perfect","Instant"}, Default = "Normal", Text = "Skillcheck Mode",
    Callback = function(option)
        if type(option) == "table" then option = option[1] end
        VD.AutoSkillcheckMode = option or "Normal"
        if VD.AutoSkillcheckMode ~= "Instant" and AutoSkill.InstantRotationConnection then
            AutoSkill.InstantRotationConnection:Disconnect(); AutoSkill.InstantRotationConnection = nil
            AutoSkill.InstantHasClicked = false
        end
        VD_Notify("Skillcheck Mode", tostring(VD.AutoSkillcheckMode) .. " selected", 2)
    end
})

-- Killer
KillerBox:AddToggle("Auto Attack", { Text = "Auto Attack", Default = false, Callback = function(v) VD.AUTO_Attack = v end })
KillerBox:AddSlider("Attack Range", { Text = "Attack Range", Default = 12, Min = 5, Max = 20, Rounding = 0, Callback = function(v) VD.AUTO_AttackRange = v end })
KillerBox:AddToggle("Hitbox Expand", { Text = "Hitbox Expand", Default = false, Callback = function(v) VD.HITBOX_Enabled = v end })
KillerBox:AddSlider("Hitbox Size", { Text = "Hitbox Size", Default = 15, Min = 5, Max = 40, Rounding = 0, Callback = function(v) VD.HITBOX_Size = v end })
KillerBox:AddToggle("Infinite Lunge (Basic Attack)", { Text = "Infinite Lunge", Default = false, Callback = function(v) VD.KILLER_InfLunge = v end })

-- Killer Ability
AbilityBox:AddToggle("Infinite Abyssal Burst (Abyss)", {
    Text = "Infinite Abyssal Burst (Abyss)", Default = false,
    Callback = function(v)
        VD.KILLER_BypassCooldown = v
        if v then KYS_StartAbyssCooldownBypass() else KYS_StopAbyssCooldownBypass() end
    end
})
AbilityBox:AddToggle("Infinite Skill (Hidden)", {
    Text = "Infinite Skill (Hidden)", Default = false,
    Callback = function(v)
        VD.KILLER_BypassLeap = v
        if v then pcall(KYS_StartHiddenCooldownBypass) else pcall(KYS_StopHiddenCooldownBypass) end
    end
})
AbilityBox:AddToggle("Infinite Frenzy (Jeff)", {
    Text = "Infinite Frenzy (Jeff)", Default = false,
    Callback = function(v)
        VD.KILLER_InfFrenzy = v
        if v then pcall(KYS_StartJeffCooldownBypass) else pcall(KYS_StopJeffCooldownBypass) end
    end
})
AbilityBox:AddToggle("Infinite Lake Mist (Jason)", {
    Text = "Infinite Lake Mist (Jason)", Default = false,
    Callback = function(v)
        VD.KILLER_InfLakeMist = v
        if v then pcall(KYS_StartSlasherCooldownBypass) else pcall(KYS_StopSlasherCooldownBypass) end
    end
})
AbilityBox:AddToggle("Infinite Pursuit (Jason)", {
    Text = "Infinite Pursuit (Jason)", Default = false,
    Callback = function(v) VD.KILLER_InfPursuit = v end
})
AbilityBox:AddToggle("Infinite Grab (Myers)", {
    Text = "Infinite Grab (Myers)", Default = false,
    Callback = function(v) setMyersGrab(v) end
})
AbilityBox:AddToggle("Fake Attack (Counter Parry)", {
    Text = "Fake Attack (Counter Parry)", Default = false,
    Callback = function(v) VD.KILLER_FakeAttack = v; pcall(KYS_ToggleFakeAttack, v) end
})
AbilityBox:AddToggle("Undraggable Button (Inf Grab)", {
    Text = "Undraggable Button (Inf Grab)", Default = false,
    Callback = function(v) setMyersDragLocked(v) end
})
local customMaskedMasks = {"Richard","Tony","Brandon","Jake","Richter","Graham","Alex"}
AbilityBox:AddDropdown("Custom Masked", {
    Values = customMaskedMasks, Default = VD.KILLER_CustomMasked or "Richard", Text = "Custom Masked",
    Callback = function(v)
        if type(v) == "table" then v = v[1] end
        VD.KILLER_CustomMasked = v or "Richard"; pcall(KYS_ApplyCustomMasked, VD.KILLER_CustomMasked)
    end
})
AbilityBox:AddButton({ Text = "Random Custom Masked", Func = function()
    local mask = customMaskedMasks[math.random(1, #customMaskedMasks)]
    VD.KILLER_CustomMasked = mask; pcall(KYS_ApplyCustomMasked, mask)
end })

-- Utilities
UtilBox:AddToggle("Auto Hook", { Text = "Auto Hook", Default = false, Callback = function(v) VD.KILLER_AutoHook = v end })
UtilBox:AddToggle("Destroy Pallets", { Text = "Destroy Pallets", Default = false, Callback = function(v) VD.KILLER_DestroyPallets = v end })
UtilBox:AddToggle("Auto Kick Generator", { Text = "Auto Kick Generator", Default = false, Callback = function(v) VD.KILLER_AutoBreakGene = v end })
UtilBox:AddToggle("Block All Vaults", { Text = "Block All Vaults", Default = false, Callback = function(v) VD.KILLER_BlockVaults = v end })
UtilBox:AddToggle("Auto Drop All Pallets", { Text = "Auto Drop All Pallets", Default = false, Callback = function(v) VD.KILLER_BlockPallets = v end })
UtilBox:AddToggle("Break All Pallet", { Text = "Break All Pallet", Default = false, Callback = function(v) VD.KILLER_BlockPalletDrop = v end })
UtilBox:AddToggle("Anti Blind (Flashlight)", {
    Text = "Anti Blind (Flashlight)", Default = false,
    Callback = function(v) VD.KILLER_AntiBlind = v; pcall(SetupAntiBlind) end
})
UtilBox:AddToggle("Remove Palletwrong (All)", {
    Text = "Remove Palletwrong (All)", Default = false,
    Callback = function(v) VD.KILLER_NoPalletStun = v; pcall(SetupNoPalletStun) end
})
UtilBox:AddToggle("No Slowdown", { Text = "No Slowdown", Default = false, Callback = function(v) VD.KILLER_NoSlowdown = v end })
UtilBox:AddToggle("Beat Killer (auto kill)", { Text = "Beat Killer (auto kill)", Default = false, Callback = function(v) VD.BEAT_Killer = v end })
UtilBox:AddDivider()
UtilBox:AddLabel("Target Lock")
UtilBox:AddToggle("Target Lock", {
    Text = "Target Lock", Default = false,
    Callback = function(v)
        if getgenv().VD_SetAimLockButtonVisible then getgenv().VD_SetAimLockButtonVisible(v) else VD.AimLockButton = v end
    end
})
UtilBox:AddToggle("Lock Target Lock Button", {
    Text = "Lock Target Lock Button", Default = false,
    Callback = function(v) VD.AimLockButtonLocked = v and true or false end
})
UtilBox:AddSlider("Target Lock Max Distance", {
    Text = "Target Lock Max Distance", Default = 50, Min = 10, Max = 200, Rounding = 0,
    Callback = function(v) VD.AimLockMaxDistance = v end
})

-- ===================== AIM TAB =====================
-- Aimbot
AimbotBox:AddToggle("Enable Aimbot", { Text = "Enable Aimbot", Default = false, Callback = function(v) VD.AIM_Enabled = v end })
AimbotBox:AddToggle("Use RMB to aim", { Text = "Use RMB to aim", Default = false, Callback = function(v) VD.AIM_UseRMB = v end })
AimbotBox:AddToggle("Show FOV Circle", { Text = "Show FOV Circle", Default = false, Callback = function(v) VD.AIM_ShowFOV = v end })
AimbotBox:AddSlider("FOV Size (aim radius on screen)", { Text = "FOV Size", Default = 120, Min = 20, Max = 400, Rounding = 0, Callback = function(v) VD.AIM_FOV = v end })
AimbotBox:AddSlider("Smoothness", { Text = "Smoothness", Default = 0.3, Min = 0.1, Max = 10, Rounding = 2, Callback = function(v) VD.AIM_Smooth = v end })
AimbotBox:AddToggle("Visibility Check", { Text = "Visibility Check", Default = false, Callback = function(v) VD.AIM_VisCheck = v end })
AimbotBox:AddToggle("Prediction", { Text = "Prediction", Default = false, Callback = function(v) VD.AIM_Predict = v end })

-- Crosshair
CrosshairBox:AddToggle("CROSS_Enabled", { Text = "Enable Crosshair", Default = false, Callback = function(v) VD.CROSS_Enabled = v; pcall(VD_UpdateCrosshair) end })
CrosshairBox:AddLabel("Crosshair Color"):AddColorPicker("CROSS_Color", {
    Default = VD.CROSS_Color or Color3.fromRGB(255,255,255),
    Callback = function(v) VD.CROSS_Color = v; pcall(VD_UpdateCrosshair) end
})
CrosshairBox:AddDropdown("CROSS_Style", {
    Values = {"Dot","Plus","X","Box"}, Default = "Dot", Text = "Crosshair Style",
    Callback = function(v) VD.CROSS_Style = type(v) == "table" and v[1] or v; pcall(VD_UpdateCrosshair) end
})
CrosshairBox:AddSlider("CROSS_Size", { Text = "Crosshair Size", Default = 3, Min = 1, Max = 100, Rounding = 0, Callback = function(v) VD.CROSS_Size = v; pcall(VD_UpdateCrosshair) end })
CrosshairBox:AddSlider("CROSS_Thickness", { Text = "Thickness", Default = 4, Min = 1, Max = 20, Rounding = 0, Callback = function(v) VD.CROSS_Thickness = v; pcall(VD_UpdateCrosshair) end })
CrosshairBox:AddSlider("CROSS_Gap", { Text = "Gap", Default = 6, Min = 0, Max = 50, Rounding = 0, Callback = function(v) VD.CROSS_Gap = v; pcall(VD_UpdateCrosshair) end })
CrosshairBox:AddSlider("CROSS_PosX", { Text = "Position X Offset", Default = 0, Min = -500, Max = 500, Rounding = 0, Callback = function(v) VD.CROSS_PosX = v; pcall(VD_UpdateCrosshair) end })
CrosshairBox:AddSlider("CROSS_PosY", { Text = "Position Y Offset", Default = 0, Min = -500, Max = 500, Rounding = 0, Callback = function(v) VD.CROSS_PosY = v; pcall(VD_UpdateCrosshair) end })

-- Spear / Veil
SpearBox:AddToggle("Spear Aimbot", { Text = "Spear Aimbot", Default = false, Callback = function(v) VD.SPEAR_Aimbot = v end })
SpearBox:AddSlider("Spear Gravity", { Text = "Spear Gravity", Default = 50, Min = 10, Max = 200, Rounding = 0, Callback = function(v) VD.SPEAR_Gravity = v end })
SpearBox:AddSlider("Spear Speed", { Text = "Spear Speed", Default = 100, Min = 50, Max = 300, Rounding = 0, Callback = function(v) VD.SPEAR_Speed = v end })
SpearBox:AddLabel("Spear Keybind (PC)"):AddKeyPicker("Spear Keybind", {
    Default = "None", Mode = "Press", NoUI = false, Text = "Toggle Spear Aimbot",
    Callback = function()
        if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return end
        SpearBtnData.Active = not SpearBtnData.Active
        VD_Notify("Spear Aimbot", SpearBtnData.Active and "Spear Aimbot AKTIF!" or "Spear Aimbot NONAKTIF", 3)
    end
})
SpearBox:AddDivider()
SpearBox:AddToggle("Silent Aim Spear (Veil)", { Text = "Silent Aim Spear (Veil)", Default = false, Callback = function(v) VeilConfig.Enabled = v end })
SpearBox:AddToggle("Show FOV Circle Veil", { Text = "Show FOV Circle", Default = true, Callback = function(v) VeilConfig.ShowFOV = v end })
SpearBox:AddToggle("Show Target Laser", { Text = "Show Target Laser", Default = true, Callback = function(v) VeilConfig.ShowTargetLaser = v end })
SpearBox:AddSlider("FOV Radius", { Text = "FOV Radius", Default = 150, Min = 50, Max = 500, Rounding = 0, Callback = function(v) VeilConfig.FOV = v end })
SpearBox:AddToggle("Auto Predict Veil", { Text = "Auto Predict", Default = false, Callback = function(v) VeilConfig.AutoPredict = v end })
SpearBox:AddSlider("Veil Spear Speed", { Text = "Spear Speed (Veil)", Default = 165, Min = 50, Max = 300, Rounding = 0, Callback = function(v) VeilConfig.SpearSpeed = v end })
SpearBox:AddSlider("Gravity Veil", { Text = "Gravity (Veil)", Default = math.floor(workspace.Gravity * 0.5), Min = 0, Max = 300, Rounding = 0, Callback = function(v) VeilConfig.Gravity = v end })
SpearBox:AddSlider("Horizontal Vector", { Text = "Horizontal Vector", Default = 1.0, Min = 0, Max = 5, Rounding = 2, Callback = function(v) VeilConfig.HorizontalPredictFactor = v end })
SpearBox:AddDropdown("Target Part Veil", {
    Values = {"Torso","Head","Root"}, Default = "Torso", Text = "Target Part (Veil)",
    Callback = function(v) if type(v) == "table" then v = v[1] end; VeilConfig.TargetPart = v end
})

-- Flask (Cure)
FlaskBox:AddToggle("Silent Aim Flask (Cure)", { Text = "Silent Aim Flask (Cure)", Default = false, Callback = function(v) VD.KILLER_SilentAimFlask = v end })
FlaskBox:AddToggle("Flask Laser (Cure)", {
    Text = "Flask Laser (Cure)", Default = false,
    Callback = function(v)
        VD.KILLER_FlaskLaser = v
        if v then pcall(KYS_StartCureFlaskLaser)
        else
            if getgenv().KYS_CureFlaskLaserThread then getgenv().KYS_CureFlaskLaserThread:Disconnect(); getgenv().KYS_CureFlaskLaserThread = nil end
            if getgenv().KYS_CureFlaskLaserPart then pcall(function() getgenv().KYS_CureFlaskLaserPart:Destroy() end); getgenv().KYS_CureFlaskLaserPart = nil end
        end
    end
})
function KYS_StartCureFlaskLaser() end -- stub, filled by logic module

-- ToF
ToFBox:AddToggle("Silent Aim Twist Of Fate", {
    Text = "Silent Aim Twist Of Fate", Default = false,
    Callback = function(v)
        if getgenv().KYS_SetToFSilentAim then getgenv().KYS_SetToFSilentAim(v)
        else VD.TOF_SilentAim = v end
    end
})
ToFBox:AddToggle("ToF Laser", { Text = "ToF Laser", Default = true, Callback = function(v) VD.TOF_Laser = v end })
ToFBox:AddToggle("ToF Wall Check", { Text = "ToF Wall Check", Default = false, Callback = function(v) VD.TOF_WallCheck = v end })
ToFBox:AddToggle("ToF Block When Knocked", { Text = "ToF Block When Knocked", Default = true, Callback = function(v) VD.TOF_BlockKnocked = v end })
ToFBox:AddDropdown("ToF Target Mode", {
    Values = {"Killer","Survivors","Zombie"}, Default = VD.TOF_TargetMode or "Killer", Text = "ToF Target Mode",
    Callback = function(v)
        if type(v) == "table" then v = v[1] end
        if getgenv().KYS_ToFSetTargetMode then getgenv().KYS_ToFSetTargetMode(v or "Killer", false)
        else VD.TOF_TargetMode = v or "Killer" end
    end
})
ToFBox:AddDropdown("Silent Aim Key", {
    Values = {"None","Q","E","R","T","F","G","H","J","K","L","X","Z"}, Default = VD.TOF_Key or "None", Text = "Silent Aim Key",
    Callback = function(v) if type(v) == "table" then v = v[1] end; VD.TOF_Key = v or "None" end
})

-- Flashlight
FlashlightBox:AddToggle("Silent Aim Flashlight", {
    Text = "Silent Aim Flashlight", Default = false,
    Callback = function(v)
        if getgenv().KYS_SetFlashlightSilentAim then getgenv().KYS_SetFlashlightSilentAim(v)
        else VD.FLASH_SilentAim = v end
    end
})
FlashlightBox:AddToggle("Flashlight Laser", {
    Text = "Flashlight Laser", Default = true,
    Callback = function(v)
        VD.FLASH_Laser = v
        if not v and getgenv().KYS_ClearFlashlightLaser then getgenv().KYS_ClearFlashlightLaser() end
    end
})
FlashlightBox:AddDropdown("Flashlight Target Part", {
    Values = {"Head","HumanoidRootPart","UpperTorso","Torso"}, Default = VD.FLASH_TargetPart or "Head", Text = "Flashlight Target Part",
    Callback = function(v) if type(v) == "table" then v = v[1] end; VD.FLASH_TargetPart = v or "Head" end
})
FlashlightBox:AddSlider("Flashlight Range", { Text = "Flashlight Range", Default = 120, Min = 20, Max = 250, Rounding = 0, Callback = function(v) VD.FLASH_Range = v end })
FlashlightBox:AddSlider("Flashlight Smoothness", { Text = "Flashlight Smoothness", Default = 0.35, Min = 0.05, Max = 1, Rounding = 2, Callback = function(v) VD.FLASH_Smooth = v end })

-- ===================== MAPPING TAB =====================
-- Teleport
local TeleportPresets = {}
TeleportBox:AddLabel("Teleport to Gate")
TeleportBox:AddButton({ Text = "Teleport to Gate", Func = function()
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    for _, gate in ipairs(Workspace:GetDescendants()) do
        if gate:IsA("Model") and gate.Name == "Gate" then
            local leftGate = gate:FindFirstChild("LeftGate")
            if leftGate then
                root.CFrame = leftGate.CFrame + Vector3.new(0, 3, 0)
                VD_Notify("Teleport", "Teleported to Gate!", 2)
                return
            end
        end
    end
    VD_Notify("Teleport", "Gate tidak ditemukan!", 3)
end })
TeleportBox:AddLabel("Teleport to Generator")
TeleportBox:AddButton({ Text = "Teleport to Nearest Generator", Func = function()
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local nearest, nearestDist = nil, math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "Generator" or obj.Name:find("Generator")) then
            local primary = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if primary then
                local dist = (root.Position - primary.Position).Magnitude
                if dist < nearestDist then nearestDist = dist; nearest = primary end
            end
        end
    end
    if nearest then
        root.CFrame = nearest.CFrame + Vector3.new(0, 3, 0)
        VD_Notify("Teleport", "Teleported to Generator!", 2)
    else
        VD_Notify("Teleport", "Generator tidak ditemukan!", 3)
    end
end })
TeleportBox:AddLabel("Teleport to Hook")
TeleportBox:AddButton({ Text = "Teleport to Nearest Hook", Func = function()
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local nearest, nearestDist = nil, math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Hook" then
            local primary = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if primary then
                local dist = (root.Position - primary.Position).Magnitude
                if dist < nearestDist then nearestDist = dist; nearest = primary end
            end
        end
    end
    if nearest then
        root.CFrame = nearest.CFrame + Vector3.new(0, 3, 0)
        VD_Notify("Teleport", "Teleported to Hook!", 2)
    else
        VD_Notify("Teleport", "Hook tidak ditemukan!", 3)
    end
end })

-- Radar
RadarBox:AddToggle("RADAR_Enabled", { Text = "Enable Radar", Default = false, Callback = function(v) VD.RADAR_Enabled = v end })
RadarBox:AddSlider("RADAR_Size", { Text = "Radar Size", Default = 150, Min = 50, Max = 400, Rounding = 0, Callback = function(v) VD.RADAR_Size = v end })
RadarBox:AddSlider("RADAR_Range", { Text = "Radar Range (studs)", Default = 250, Min = 50, Max = 1000, Rounding = 0, Callback = function(v) VD.RADAR_Range = v end })
RadarBox:AddSlider("RADAR_Transparency", { Text = "Radar Transparency", Default = 0.2, Min = 0, Max = 1, Rounding = 2, Callback = function(v) VD.RADAR_Transparency = v end })
RadarBox:AddToggle("RADAR_Circle", { Text = "Circle Radar", Default = false, Callback = function(v) VD.RADAR_Circle = v end })
RadarBox:AddDivider()
RadarBox:AddToggle("RADAR_ShowKiller", { Text = "Show Killer", Default = false, Callback = function(v) VD.RADAR_ShowKiller = v end })
RadarBox:AddToggle("RADAR_ShowSurvivor", { Text = "Show Survivor", Default = false, Callback = function(v) VD.RADAR_ShowSurvivor = v end })
RadarBox:AddToggle("RADAR_ShowGenerator", { Text = "Show Generator", Default = false, Callback = function(v) VD.RADAR_ShowGenerator = v end })
RadarBox:AddToggle("RADAR_ShowPallet", { Text = "Show Pallet", Default = false, Callback = function(v) VD.RADAR_ShowPallet = v end })
RadarBox:AddToggle("RADAR_ShowHook", { Text = "Show Hook", Default = false, Callback = function(v) VD.RADAR_ShowHook = v end })
RadarBox:AddToggle("RADAR_ShowGate", { Text = "Show Gate", Default = false, Callback = function(v) VD.RADAR_ShowGate = v end })
RadarBox:AddToggle("RADAR_ShowWindow", { Text = "Show Window", Default = false, Callback = function(v) VD.RADAR_ShowWindow = v end })
RadarBox:AddToggle("RADAR_ShowZombie", { Text = "Show Zombie", Default = false, Callback = function(v) VD.RADAR_ShowZombie = v end })

-- ===================== UI SETTINGS TAB =====================
local MenuGroup = Tabs["UI Settings"]:AddGroupbox({ Side = "Left", Name = "Menu" })
MenuGroup:AddLabel("Menu Bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu Keybind" })
Library.ToggleKeybind = Options.MenuKeybind
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor", Default = Library.ShowCustomCursor,
    Callback = function(v) Library.ShowCustomCursor = v end
})
MenuGroup:AddButton("Unload", function() Library:Unload() end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("KysHubVD")
SaveManager:SetFolder("KysHubVD/ViolenceDistrict")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- =====================================================
-- SYNC RUNTIME STATE
-- =====================================================
getgenv().KYS_SyncLoadedFeatures = function()
    if type(SetupAntiBlind) == "function" then pcall(SetupAntiBlind) end
    if type(SetupNoPalletStun) == "function" then pcall(SetupNoPalletStun) end
    if type(VD_UpdateCrosshair) == "function" then pcall(VD_UpdateCrosshair) end
    if VD.VIS_KystKiller then pcall(StartKystKiller) else pcall(StopKystKiller) end
    if VD.VIS_SpectatorCounter then pcall(StartSpectatorCounter) else pcall(StopSpectatorCounter) end
    if VD.VIS_KillerPerks then pcall(StartKillerPerksDisplay) else pcall(StopKillerPerksDisplay) end
    if VD.VIS_PredictMap then pcall(StartPredictMap) else pcall(StopPredictMap) end
    if getgenv().KYS_SetHideSurvivorIcon then pcall(getgenv().KYS_SetHideSurvivorIcon, VD.VIS_HideSurvivorIcon) end
    if getgenv().KYS_SetShowPingFPS then pcall(getgenv().KYS_SetShowPingFPS, VD.VIS_ShowPingFPS) end
    if getgenv().KYS_SetShowHookCounter then pcall(getgenv().KYS_SetShowHookCounter, VD.VIS_ShowHookCounter) end
    if getgenv().KYS_SetToFSilentAim then pcall(getgenv().KYS_SetToFSilentAim, VD.TOF_SilentAim) end
    if getgenv().KYS_SetFlashlightSilentAim then pcall(getgenv().KYS_SetFlashlightSilentAim, VD.FLASH_SilentAim) end
    if getgenv().VD_SetMoonwalkButtonVisible then pcall(getgenv().VD_SetMoonwalkButtonVisible, VD.MoonwalkButton) end
    if VD.KILLER_BypassLeap then pcall(KYS_StartHiddenCooldownBypass) end
end

-- =====================================================
-- HEARTBEAT LOOP
-- =====================================================
RunService.Heartbeat:Connect(function(deltaTime)
    if VD.Destroyed then return end
    local cam = workspace.CurrentCamera; if not cam then return end

    if not DrawingAvailable and (not getgenv().KYS_MobileGui or not getgenv().KYS_MobileGui.FOVFrame or not getgenv().KYS_MobileGui.FOVFrame.Parent) then
        pcall(CreateMobileUI)
    end

    if not DrawingAvailable then
        UpdateCameraFOV(); UpdateThirdPerson(); UpdateShiftLock()
        pcall(UpdateSpearAim)
    end
    if not DrawingAvailable and VD.AIM_Enabled and getgenv().KYS_AimbotState and getgenv().KYS_AimbotState.AimHolding then
        local sc = cam.ViewportSize
        pcall(function() Aimbot.Update(cam, sc, Vector2.new(sc.X/2, sc.Y/2)) end)
    end

    if not DrawingAvailable then
        if getgenv().KYS_MobileGui and getgenv().KYS_MobileGui.AimBtn then
            getgenv().KYS_MobileGui.AimBtn.Visible = VD.AIM_Enabled
        end
        pcall(UpdateMobileFOV)
    end

    if SpearBtnData and SpearBtnData.Button then
        local spearVisible = (VD.SPEAR_Aimbot and GetRole() == "Killer")
        SpearBtnData.Button.Visible = spearVisible
        if spearVisible then pcall(UpdateSpearTargetLabel) end
    end

    pcall(UpdateRadar)
    pcall(VD_RunAntiKnock)
    pcall(VD_UpdateSurvivorWarnings)
    pcall(VD_UpdateBypassGate)
    pcall(VD_UpdateInfiniteLunge)
    pcall(VD_UpdateWeatherAnchor)
    pcall(VD_UpdateInvisibleNotVisual)
    pcall(VD_UpdateMoonwalk, deltaTime)
    pcall(VD_UpdateRemovePalletwrong)
end)

-- =====================================================
getgenv().KYS_SyncUILibraryConfigRuntime = function()
    -- Obsidian manages its own state; just sync flags
    if getgenv().KYS_SetToFSilentAim and type(VD.TOF_SilentAim) == "boolean" then
        pcall(getgenv().KYS_SetToFSilentAim, VD.TOF_SilentAim)
    end
    if getgenv().KYS_SetFlashlightSilentAim and type(VD.FLASH_SilentAim) == "boolean" then
        pcall(getgenv().KYS_SetFlashlightSilentAim, VD.FLASH_SilentAim)
    end
end

print("KYS HUB Violence District v1.5.7 Loaded (Obsidian UI)")
pcall(function() VD_Notify("KysHub crack", "Violence District v1.5.7 Loaded! (Obsidian UI)", 5) end)

end -- end __KysHub_Init_Main__
__KysHub_Init_Main__()

-- =============================================
-- PATCH DISABLE PREMIUM
-- =============================================
local function KillPremium()
    local oldNotify = VD_Notify
    VD_Notify = function(title, content, duration)
        if content and tostring(content):find("Premium") then return end
        if oldNotify then oldNotify(title, content, duration) end
    end
    print("[KysHub] Premium-restrictions disabled.")
end
task.spawn(KillPremium)
