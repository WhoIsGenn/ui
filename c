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

local UI = {}

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager= loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

if isMobile then UI.Mobile = true end
print("[Universal] Platform:", isMobile and "MOBILE" or "PC")

-- =====================================================
local HttpService = game:GetService("HttpService")

local Window = Library:CreateWindow({
    Title = "KysHub VD v1.5.7",
    Footer = "Violence District",
    Icon = 80891639562743,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Visual   = Window:AddTab("Visual",  "eye"),
    Main     = Window:AddTab("Main",    "cpu"),
    Aim      = Window:AddTab("Aim",     "crosshair"),
    Mapping  = Window:AddTab("Mapping", "map"),
    Player   = Window:AddTab("Player",  "user"),
    Settings = Window:AddTab("Settings","settings"),
}


-- =====================================================
-- PC CURSOR UNLOCK (ALT key toggle)
-- Hanya aktif di PC, tidak mengganggu mobile
-- =====================================================
if not isMobile then
    local _cursorOn = false
    local _cursorManual = false

    local function _setCursor(state)
        _cursorOn = state
        _cursorManual = true
        pcall(function()
            UserInputService.MouseIconEnabled = state
            UserInputService.MouseBehavior = state
                and Enum.MouseBehavior.Default
                or Enum.MouseBehavior.LockCenter
        end)

        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = not state
        end
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
-- SAFE DRAWING UTILS
-- =====================================================
local DrawingAvailable = (function()
    if isMobile then return false end  --
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

    -- Generator / Healing
    AutoSkillcheck        = false,
    AutoSkillcheckMode    = "Normal",
    -- Visual / UI
    HideSkillUI           = false,
    Fullbright            = false,
    -- Movement
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
    -- Internal
    Destroyed             = false,
    -- Auto features

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
    SURV_SwiftVault        = false,  -- Auto Vault saat dekat window
    SURV_SwiftVaultV2       = false,  -- Custom vault speed
    SURV_SwiftVaultSpeed       = 13,
    SURV_AutoPallet       = false,  -- Auto Pallet Drop saat killer dekat
    SURV_AutoPalletDist   = 20,     -- Jarak killer (studs) untuk trigger pallet drop
    SURV_AutoParry        = false,
    SURV_ParryDistance    = 8,
    SURV_ShowParryCircle  = false,
    SURV_FakeParry        = false,
    SURV_FakeParryAnim    = "Enten",
    SURV_FakeGen          = false,
    SURV_AntiKnock        = false,
    -- Killer features
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
    -- Speed
    SPEED_Enabled         = false,
    SPEED_Value           = 32,
    SPEED_Method          = "Attribute",
    -- Visual extras
    NO_Fog                = false,
    NoCutscene            = false,
    CAM_FOVEnabled        = false,
    CAM_FOV               = 90,
    CAM_ThirdPerson       = false,
    CAM_ShiftLock         = false,
    CAM_InfinityZoom      = false,
    -- Config
    AntiFallDamage        = false,
    FLING_Enabled         = false,
    FLING_Strength        = 10000,
    -- Beat game
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

    ESP_ClosestHook       = false,    -- Aimbot
    AIM_Enabled           = false,

    AIM_UseRMB            = false,
    AIM_FOV               = 120,
    AIM_Smooth            = 0.3,
    AIM_TargetPart        = "Head",
    AIM_VisCheck          = false,
    AIM_ShowFOV           = false,
    AIM_Predict           = false,
    SURV_FirstPerson       = false,
    -- Spear aimbot
    SPEAR_Aimbot          = false,
    SPEAR_Gravity         = 50,
    SPEAR_Speed           = 100,
    -- Radar
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
            -- Snap values to avoid weird float sub-pixel rendering blur
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
-- This prevents stale getgenv/config/UI state from enabling anything
-- before the user turns it on manually.
local VD_DefaultOffFlags = {
    "AutoSkillcheck",
    "HideSkillUI",
    "Fullbright",
    "Speed",
    "Jump",
    "InfiniteJump",
    "Noclip",
    "Moonwalk",
    "MoonwalkButton",
    "MoonwalkButtonLocked",
    "AimLock",
    "AimLockButton",
    "AimLockButtonLocked",
    "AimLockMaxDistance",
    "InvisibleNotVisual",
    "AntiAFK",
    "BypassGate",
    "AUTO_Attack",
    "HITBOX_Enabled",
    "TOF_SilentAim",
    "FLASH_SilentAim",
    "SURV_FleeKiller",
    "SURV_SwiftVault",
    "SURV_SwiftVaultV2",
    "SURV_AutoPallet",
    "SURV_AutoParry",
    "SURV_ShowParryCircle",
    "SURV_FakeParry",
    "SURV_FakeParryAnim",
    "SURV_FakeGen",
    "SURV_AntiKnock",
    "KILLER_DestroyPallets",
    "KILLER_NoPalletStun",
    "KILLER_AutoHook",
    "KILLER_AutoBreakGene",
    "KILLER_BlockVaults",
    "KILLER_BlockPallets",
    "KILLER_BlockPalletDrop",
    "KILLER_BypassCooldown",
    "KILLER_BypassLeap",
    "KILLER_BypassVeilCooldown",
    "KILLER_AntiBlind",
    "KILLER_NoSlowdown",
    "SPEED_Enabled",
    "NO_Fog",
    "NoCutscene",
    "VIS_KystKiller",
    "CAM_FOVEnabled",
    "CAM_ThirdPerson",
    "CAM_ShiftLock",
    "CAM_InfinityZoom",
    "AntiFallDamage",
    "FLING_Enabled",
    "BEAT_Survivor",
    "BEAT_Killer",
    "ESP_ClosestHook",
    "VIS_SpectatorCounter",
    "VIS_KillerPerks",
    "VIS_PredictMap",
    "VIS_HideSurvivorIcon",
    "VIS_ShowPingFPS",
    "VIS_ShowHookCounter",
    "CROSS_Enabled",
    "CROSS_Style",
    "CROSS_Size",
    "CROSS_Thickness",
    "CROSS_Gap",
    "CROSS_PosX",
    "CROSS_PosY",
    "CROSS_Color",
    "AIM_Enabled",

    "AIM_UseRMB",
    "AIM_VisCheck",
    "AIM_ShowFOV",
    "AIM_Predict",
    "SURV_FirstPerson",
    "SPEAR_Aimbot",
    "RADAR_Enabled",
    "RADAR_Circle",
    "RADAR_ShowKiller",
    "RADAR_ShowSurvivor",
    "RADAR_ShowGenerator",
    "RADAR_ShowPallet",
    "RADAR_ShowHook",
    "RADAR_ShowGate",
    "RADAR_ShowWindow",
    "RADAR_ShowZombie",
    "SURV_WarnKiller",
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
-- CONFIGURATION SYSTEM (Save & Load)
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
                if filename then
                    table.insert(list, filename)
                end
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
        if writefile then
            writefile(path, HttpService:JSONEncode(VD))
        end
    end)
end

local VD_To_Flag = {
    InfiniteJump = "Infinite Jump",
    KILLER_AntiBlind = "Anti Blind (Flashlight)",
    Fullbright = "Fullbright (lighting preset)",
    AIM_VisCheck = "Visibility Check",
    AutoSkillcheck = "Auto Skillcheck",
    AutoSkillcheckMode = "Skillcheck Mode",
    HideSkillUI = "Hide Skillcheck UI",
    SpeedValue = "Speed Value",
    AIM_Enabled = "Enable Aimbot",
    HITBOX_Size = "Hitbox Size",
    SURV_FleeKiller = "Flee Killer",
    SURV_FleeDistance = "Flee Distance",
    SURV_AutoVault      = "SwiftVault",
    SURV_FastVault      = "SwiftVaultV2",
    SURV_VaultSpeed     = "SwiftVaultSpeed",
    SURV_AutoPallet     = "Pallet Reflex",
    SURV_AutoPalletDist = "Pallet Trigger Range",
    SURV_AutoParry      = "Auto Parry",
    SURV_ParryDistance  = "Parry Distance Trigger",
    SURV_ShowParryCircle = "Show Parry Range Circle",
    SURV_FakeParry      = "Fake Parry (Press V)",
    SURV_FakeParryAnim  = "Fake Parry Animation",
    SURV_FakeGen        = "Fake Generator (Press B)",
    SURV_AntiKnock = "Anti Knock",
    KILLER_DestroyPallets = "Destroy Pallets",
    KILLER_AutoBreakGene  = "Auto Kick Generator",
    KILLER_BlockVaults    = "Block All Vaults",
    KILLER_BlockPallets   = "Auto Drop All Pallets",
    KILLER_BlockPalletDrop = "Break All Pallet",
    KILLER_BypassCooldown = "Infinite Abyssal Burst (Abyss)",
    KILLER_BypassLeap     = "Infinite Skill (Hidden)",
    KILLER_FakeAttack     = "Fake Attack (Counter Parry)",
    KILLER_BypassVeilCooldown = "Bypass Cooldown (Veil)",
    KILLER_CustomMasked = "Custom Masked",
    Speed = "Speed Hack",
    CAM_FOV = "Camera FOV",
    CAM_FOVEnabled = "Enable Camera FOV override",
    FLING_Strength = "Fling Strength",
    Noclip = "Noclip",
    Moonwalk = "Moonwalk",
    MoonwalkButton = "Moonwalk",
    MoonwalkButtonLocked = "Lock Moonwalk Button",
    MoonwalkZigzagSpeed = "Moonwalk Zigzag Speed",
    MoonwalkBoostPower = "Moonwalk Boost Power",
    AimLock = "Target Lock",
    AimLockButton = "Target Lock",
    AimLockButtonLocked = "Lock Target Lock Button",
    AimLockMaxDistance = "Target Lock Max Distance",
    BEAT_Killer = "Beat Killer (auto kill)",
    AIM_Predict = "Prediction",
    AIM_ShowFOV = "Show FOV Circle",
    KILLER_AutoHook = "Auto Hook",
    Jump = "Jump Hack",
    KILLER_NoSlowdown = "No Slowdown",
    SPEAR_Gravity = "Spear Gravity",
    AIM_UseRMB = "Use RMB to aim",
    CAM_ShiftLock = "Shift Lock (auto face camera)",
    Destroyed = "Solid UI Mode (No Transparency)",
    AUTO_AttackRange = "Attack Range",
    AIM_FOV = "FOV Size (aim radius on screen)",
    KILLER_NoPalletStun = "Remove Palletwrong (All)",
    CAM_ThirdPerson = "Third Person (Killer only)",
    CAM_InfinityZoom = "Infinity Zoom Out",
    AntiFallDamage = "Anti Fall Damage",
    InvisibleNotVisual = "Invisible Not Visual",
    InvisibleSpeed = "Invisible Speed",
    AntiAFK = "Anti AFK",
    BypassGate = "Bypass Gate",
    HITBOX_Enabled = "Hitbox Expand",
    TOF_SilentAim = "Silent Aim Twist Of Fate",
    TOF_Laser = "ToF Laser",
    TOF_WallCheck = "ToF Wall Check",
    TOF_BlockKnocked = "ToF Block When Knocked",
    TOF_TargetMode = "ToF Target Mode",
    TOF_Key = "Silent Aim Key",
    FLASH_SilentAim = "Silent Aim Flashlight",
    FLASH_Laser = "Flashlight Laser",
    FLASH_TargetPart = "Flashlight Target Part",
    FLASH_Range = "Flashlight Range",
    FLASH_Smooth = "Flashlight Smoothness",
    NO_Fog = "No Fog (remove fog/post effects)",
    NoCutscene = "No Cutscene",
    FLING_Enabled = "Enable Fling",
    AIM_Smooth = "Smoothness",
    SPEAR_Speed = "Spear Speed",
    SPEAR_Aimbot = "Spear Aimbot",
    SURV_FirstPerson = "First Person Camera (Survivor)",
    JumpValue = "Jump Power",
    AUTO_Attack = "Auto Attack",
    BEAT_Survivor = "Beat Survivor (auto exit)",
    SURV_WarnKiller = "Survivor Killer Warning",
    VIS_KystKiller = "Kyst Killer Display",
    VIS_SpectatorCounter = "Enable Spectator Counter",
    VIS_KillerPerks = "Killer Perks Display",
    VIS_PredictMap = "Predict Map",
    VIS_HideSurvivorIcon = "Hide Survivor Icon",
    VIS_ShowPingFPS = "Show Ping & FPS",
    VIS_ShowHookCounter = "Show Hook Counter",
}

function KYS_LoadConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if readfile and isfile and isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for key, value in pairs(data) do
                VD[key] = value
                -- Sync to UI visual state if mapping exists
                local flagName = VD_To_Flag[key]
                if flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName] then
                    pcall(function()
                        local elem = Window.ConfigElements[flagName]
                        if elem.Set then elem:Set(value) end
                    end)
                end
            end
            if getgenv().KYS_SyncLoadedFeatures then pcall(getgenv().KYS_SyncLoadedFeatures) end
        end
    end)
end

function KYS_DeleteConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" or name == "Default" then return end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if isfile and isfile(path) and delfile then
            delfile(path)
            print("[VD Config] Deleted:", name)
        end
    end)
end

-- Auto-load dimatikan: config hanya dimuat saat user memilih Load manual dari UI.

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
    if atm then
        originalLighting.Atmosphere = {
            Density = atm.Density,
            Offset = atm.Offset,
            Glare = atm.Glare,
            Haze = atm
                .Haze
        }
    end
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
    
    -- Cleanup old sky, cc, atm
    if getgenv().VD_CurrentSky and getgenv().VD_CurrentSky.Parent then getgenv().VD_CurrentSky:Destroy() end
    getgenv().VD_CurrentSky = nil
    
    if getgenv().VD_WeatherCC and getgenv().VD_WeatherCC.Parent then getgenv().VD_WeatherCC:Destroy() end
    getgenv().VD_WeatherCC = nil
    
    if getgenv().VD_WeatherAtmosphere and getgenv().VD_WeatherAtmosphere.Parent then getgenv().VD_WeatherAtmosphere:Destroy() end
    getgenv().VD_WeatherAtmosphere = nil
    
    -- Apply Atmosphere
    if theme.Atmosphere then
        local atm = Instance.new("Atmosphere")
        atm.Name = "VD_WeatherAtmosphere"
        for k, v in pairs(theme.Atmosphere) do pcall(function() atm[k] = v end) end
        atm.Parent = Lighting
        getgenv().VD_WeatherAtmosphere = atm
    end
    
    -- Apply ColorCorrection
    if theme.CC then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "VD_WeatherCC"
        for k, v in pairs(theme.CC) do pcall(function() cc[k] = v end) end
        cc.Parent = Lighting
        getgenv().VD_WeatherCC = cc
    end
    
    -- Apply Lighting
    if theme.Lighting then
        for k, v in pairs(theme.Lighting) do
            pcall(function() Lighting[k] = v end)
        end
    else
        -- Restore original lighting if no specific lighting is set, but respect Fullbright & NoFog
        if not VD.Fullbright and not VD.NO_Fog then
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        end
    end
    
    -- Re-apply Fullbright & NoFog if they are on
    if VD.Fullbright then pcall(VD_SetFullbright, true) end
    if VD.NO_Fog then pcall(VD_SetNoFog, true) end

    -- Setup Particles
    if getgenv().VD_ParticleAnchor and getgenv().VD_ParticleAnchor.Parent then
        getgenv().VD_ParticleAnchor:Destroy()
    end
    getgenv().VD_ParticleAnchor = nil
    
    if theme.Particle then
        local anchor = Instance.new("Part")
        anchor.Name = "VD_WeatherAnchor"
        anchor.Transparency = 0.99 -- Almost invisible but guarantees rendering
        anchor.CanCollide = false
        anchor.Anchored = true
        anchor.Size = theme.Particle.AnchorSize or Vector3.new(120, 1, 120)
        anchor:SetAttribute("VD_CameraOffsetX", theme.Particle.CameraOffset and theme.Particle.CameraOffset.X or 0)
        anchor:SetAttribute("VD_CameraOffsetY", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Y or 30)
        anchor:SetAttribute("VD_CameraOffsetZ", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Z or 0)
        
        local pe = Instance.new("ParticleEmitter")
        pe.Name = "VD_WeatherEmitter"
        
        -- Default important settings for Weather Emitters
        pe.Enabled = true
        pe.EmissionDirection = Enum.NormalId.Bottom
        pe.LockedToPart = false
        pe.ZOffset = 2 -- Make it render over most things
        pe.LightEmission = 0.25
        pe.SpreadAngle = Vector2.new(10, 10)
        pcall(function() pe.Shape = Enum.ParticleEmitterShape.Box end)
        pcall(function() pe.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
        
        for k, v in pairs(theme.Particle) do
            if k ~= "AnchorSize" and k ~= "CameraOffset" then
                pcall(function() pe[k] = v end)
            end
        end
        
        pe.Parent = anchor
        if themeName == "Heavy Rain (Storm)" then
            local nearRain = Instance.new("ParticleEmitter")
            nearRain.Name = "VD_WeatherRainNearEmitter"
            nearRain.Enabled = true
            nearRain.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            nearRain.Color = ColorSequence.new(Color3.fromRGB(230, 240, 255))
            nearRain.Transparency = NumberSequence.new(0)
            nearRain.Size = NumberSequence.new(1.65)
            nearRain.Squash = NumberSequence.new(20)
            nearRain.Rate = 1800
            nearRain.Speed = NumberRange.new(70, 95)
            nearRain.Lifetime = NumberRange.new(0.75, 1.05)
            nearRain.EmissionDirection = Enum.NormalId.Bottom
            nearRain.Acceleration = Vector3.new(-24, -90, 0)
            nearRain.SpreadAngle = Vector2.new(2, 2)
            nearRain.LockedToPart = false
            nearRain.ZOffset = 6
            nearRain.LightEmission = 1
            pcall(function() nearRain.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() nearRain.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            nearRain.Parent = anchor

            local rainSheet = Instance.new("ParticleEmitter")
            rainSheet.Name = "VD_WeatherRainSheetEmitter"
            rainSheet.Enabled = true
            rainSheet.Texture = "rbxasset://textures/particles/smoke_main.dds"
            rainSheet.Color = ColorSequence.new(Color3.fromRGB(170, 195, 225))
            rainSheet.Transparency = NumberSequence.new(0.45)
            rainSheet.Size = NumberSequence.new(3.2)
            rainSheet.Squash = NumberSequence.new(7)
            rainSheet.Rate = 650
            rainSheet.Speed = NumberRange.new(45, 65)
            rainSheet.Lifetime = NumberRange.new(1.0, 1.5)
            rainSheet.EmissionDirection = Enum.NormalId.Bottom
            rainSheet.Acceleration = Vector3.new(-14, -55, 0)
            rainSheet.SpreadAngle = Vector2.new(8, 8)
            rainSheet.LockedToPart = false
            rainSheet.ZOffset = 3
            rainSheet.LightEmission = 0.35
            pcall(function() rainSheet.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() rainSheet.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            rainSheet.Parent = anchor
        elseif themeName == "Autumn (Musim Gugur)" then
            local bigLeaves = Instance.new("ParticleEmitter")
            bigLeaves.Name = "VD_WeatherAutumnBigLeavesEmitter"
            bigLeaves.Enabled = true
            bigLeaves.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            bigLeaves.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 55)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(230, 95, 25)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(165, 65, 20)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 40, 8))
            })
            bigLeaves.Transparency = NumberSequence.new(0)
            bigLeaves.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2.4),
                NumberSequenceKeypoint.new(0.5, 3.1),
                NumberSequenceKeypoint.new(1, 1.8)
            })
            bigLeaves.Squash = NumberSequence.new(4.5)
            bigLeaves.Rate = 150
            bigLeaves.Speed = NumberRange.new(5, 10)
            bigLeaves.Lifetime = NumberRange.new(8, 12)
            bigLeaves.EmissionDirection = Enum.NormalId.Bottom
            bigLeaves.Rotation = NumberRange.new(0, 360)
            bigLeaves.RotSpeed = NumberRange.new(-280, 280)
            bigLeaves.Acceleration = Vector3.new(24, -5, 10)
            bigLeaves.SpreadAngle = Vector2.new(45, 45)
            bigLeaves.LockedToPart = false
            bigLeaves.ZOffset = 5
            bigLeaves.LightEmission = 0.65
            pcall(function() bigLeaves.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() bigLeaves.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            bigLeaves.Parent = anchor
        end
        anchor.Parent = workspace
        getgenv().VD_ParticleAnchor = anchor
        
        -- FORCE PRELOAD FOR MOBILE CLIENTS
        if theme.Particle.Texture then
            task.spawn(function()
                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({pe})
                end)
            end)
        end
        
        -- Initial position
        pcall(VD_UpdateWeatherAnchor)
    end
end

function VD_UpdateWeatherAnchor()
    local anchor = getgenv().VD_ParticleAnchor
    if not anchor then return end
    
    -- Keep the emitter in Workspace; ParticleEmitters under CurrentCamera can be culled on some clients.
    if anchor.Parent ~= workspace then
        pcall(function() anchor.Parent = workspace end)
    end
    
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
        local head = char.Head
        anchor.CFrame = CFrame.new(head.Position + Vector3.new(0, 30, 0))
    end
end

-- =====================================================
-- CHARACTER REFS
-- =====================================================
-- Character, Humanoid, and Root are declared at the top of __KysHub_Init_Main__

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
            if not Remotes then
                warn("AntiFail: Remotes not found")
                return
            end
-- PENTING: Cache getgenv() sekali saja sebagai upvalue lokal.
-- Memanggil getgenv() di dalam __namecall hook bisa trigger namecall lagi
-- leads to infinite recursion -> stack overflow -> force close.
            local _genv = getgenv()

            _genv.KYS_oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()

                if VD.AntiFallDamage and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name:lower() end)
                    if ok and (name:find("falldamage") or name:find("fall") or name:find("ragdollfall")) then
                        return
                    end
                end

                if VD.KILLER_InfFrenzy and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and (name == "Deactivatefromclient" or name == "PowerDoneDeactivating") then
                        return
                    end
                end

                if VD.KILLER_SilentAimFlask and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and name == "ThrowFlask" then
                        local args = {...}
                        local closest = nil
                        local minDst = math.huge
                        local lp = game:GetService("Players").LocalPlayer
                        local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
                        
                        if myPos then
                            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    if not v.Character:GetAttribute("IsKiller") then
                                        local dst = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                                        if dst < minDst then
                                            minDst = dst
                                            closest = v
                                        end
                                    end
                                end
                            end
                        end
                        
                        if closest then
                            local targetPos = closest.Character.HumanoidRootPart.Position
                            -- args[1] = LookVector, args[2] = OriginPosition
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

                if _genv.KYS_oldNamecall then
                    return _genv.KYS_oldNamecall(self, ...)
                end
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

                -- Paksa LockFirstPerson hanya saat toggle aktif agar game tidak bisa override
                if LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                end
                if LocalPlayer.CameraMaxZoomDistance ~= 0 then
                    LocalPlayer.CameraMaxZoomDistance = 0
                end

                -- Sembunyikan kepala & aksesoris wajah agar tidak menghalangi pandangan
                -- (LocalTransparencyModifier hanya berlaku untuk kita sendiri, orang lain tetap melihat kepala kita)
                local char = LocalPlayer.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        head.LocalTransparencyModifier = 1
                    end
                    -- Sembunyikan juga aksesoris yang menempel di kepala (hat, face, hair)
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Accessory") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then
                                handle.LocalTransparencyModifier = 1
                            end
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
-- Stabil, anti double nametag, anti duplicate highlight, dan safe re-execute.
-- Kontrol ditambahkan ke tab Visual lewat getgenv().KYS_AddVisualESPControls.
-- =====================================================
do
    if getgenv().KYS_VD_VisualESP_Cleanup then
        pcall(getgenv().KYS_VD_VisualESP_Cleanup)
    end

    local LP = LocalPlayer
    local KYS_Dead = false
    local KYS_ControlsAdded = false

    local KYS_ESPState = {
        PlayerMasterESP = false,
        WorldMasterESP = false,
        ESPFillTransparency = 0.95,
        ESPOutlineTransparency = 0.3,
        ESPTextSize = 12,

        SurvivorESP = false,
        KillerESP = false,
        SpectatorESP = false,
        Nametags = false,
        DistanceESP = false,
        SurvivorItemsESP = false,

        SurvivorColor = Color3.fromRGB(0, 255, 0),
        KillerColor = Color3.fromRGB(255, 0, 0),
        SpectatorColor = Color3.fromRGB(255, 255, 255),

        GeneratorESP = false,
        HookESP = false,
        GateESP = false,
        WindowESP = false,
        PalletESP = false,
        SCPZombieESP = false,
        WorldNametags = false,
        WorldDistanceESP = false,

        GeneratorColor = Color3.fromRGB(0, 170, 255),
        HookColor = Color3.fromRGB(255, 0, 0),
        GateColor = Color3.fromRGB(255, 225, 0),
        WindowColor = Color3.fromRGB(255, 255, 255),
        PalletColor = Color3.fromRGB(255, 140, 0),
        SCPZombieColor = Color3.fromRGB(128, 0, 128),
    }

    getgenv().KYS_VD_VisualESP_State = KYS_ESPState

    KYS_WorldReg = {
        Generator = {},
        Hook = {},
        Gate = {},
        Window = {},
        Palletwrong = {},
        SCPZombie = {},
    }

    local KYS_MapAdd, KYS_MapRem = {}, {}
    local KYS_PlayerConns = {}
    local KYS_Connections = {}
    local KYS_PalletState = setmetatable({}, { __mode = "k" })
    local KYS_WindowState = setmetatable({}, { __mode = "k" })
    local KYS_InstanceIds = setmetatable({}, { __mode = "k" })
    local KYS_KystId = 0
    local KYS_PlayerLoopThread = nil
    local KYS_WorldLoopThread = nil
    local KYS_ESPFolder = nil

    local KYS_DisplayNames = {
        ["Motion Tracker"] = true,
        ["Gate"] = true,
        ["Flashlight"] = true,
        ["Bandage"] = true,
        ["Parrying Dagger"] = true,
        ["Adrenaline Shot"] = true,
        ["Twist of Fate"] = true,
        ["Shadow Clone"] = true,
        ["Holy Water"] = true,
        ["WaxBound Candle"] = true,
        ["Riot Shield"] = true,
        ["Emperor"] = true,
        ["AWP"] = true,
    }

    local function KYS_Alive(inst)
        if not inst then return false end
        local ok, parent = pcall(function() return inst.Parent end)
        return ok and parent ~= nil
    end

    local function KYS_Clamp(n, lo, hi)
        n = tonumber(n) or lo
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function KYS_PlayerKey(player)
        local id = player and player.UserId
        if id and id ~= 0 then return tostring(id) end
        return tostring(player and player.Name or "Unknown")
    end

    local function KYS_EspId(inst)
        if not inst then return "nil" end
        local id = KYS_InstanceIds[inst]
        if id then return id end
        KYS_KystId = KYS_KystId + 1
        id = tostring(KYS_KystId)
        KYS_InstanceIds[inst] = id
        return id
    end

    local function KYS_GetESPParent()
        local okCore, core = pcall(function() return game:GetService("CoreGui") end)
        if okCore and core then return core end
        if gethui then
            local okHui, hui = pcall(gethui)
            if okHui and hui then return hui end
        end
        local playerGui = LP and LP:FindFirstChildOfClass("PlayerGui")
        if playerGui then return playerGui end
        return Workspace
    end

    local function KYS_GetESPFolder()
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            return KYS_ESPFolder
        end

        local parent = KYS_GetESPParent()
        local old = parent:FindFirstChild("KysHub_VisualESP") or parent:FindFirstChild("ZiaanHub_ESP")
        if old then old:Destroy() end

        local folder = Instance.new("Folder")
        folder.Name = "KysHub_VisualESP"
        folder.Parent = parent
        KYS_ESPFolder = folder
        return folder
    end

    local function KYS_ClearPrefix(prefix, keepName)
        local folder = KYS_GetESPFolder()
        local keptExact = false
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name:sub(1, #prefix) == prefix then
                if child.Name == keepName and not keptExact then
                    keptExact = true
                else
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_SafeNotify(title, content, duration)
        pcall(function()
            Library:Notify({
                Title = title,
                Description = content,
                Time = duration or 2,
            })
        end)
    end

    local function KYS_ValidPart(part)
        return part and KYS_Alive(part) and part:IsA("BasePart")
    end

    local function KYS_FirstBasePart(inst)
        if not KYS_Alive(inst) then return nil end
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then
            if inst.PrimaryPart and inst.PrimaryPart:IsA("BasePart") and KYS_Alive(inst.PrimaryPart) then
                return inst.PrimaryPart
            end
            local part = inst:FindFirstChildWhichIsA("BasePart", true)
            if KYS_ValidPart(part) then return part end
        end
        if inst:IsA("Tool") then
            local handle = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
            if KYS_ValidPart(handle) then return handle end
        end
        return nil
    end

    local function KYS_GetRole(player)
        local teamName = player.Team and player.Team.Name and player.Team.Name:lower() or ""
        if teamName:find("killer") then return "Killer" end
        if teamName:find("survivor") then return "Survivor" end
        if teamName:find("spect") then return "Spectator" end
        return "Survivor"
    end

    local function KYS_PlayerRoleEnabled(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerESP end
        if role == "Spectator" then return KYS_ESPState.SpectatorESP end
        return KYS_ESPState.SurvivorESP
    end

    local function KYS_PlayerColor(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerColor end
        if role == "Spectator" then return KYS_ESPState.SpectatorColor end
        return KYS_ESPState.SurvivorColor
    end

    getgenv().KYS_VD_VisualESP_HasPlayerText = function(player)
        if not player or player == LP then return false end
        return KYS_ESPState.PlayerMasterESP
            and KYS_PlayerRoleEnabled(player)
            and (KYS_ESPState.Nametags or KYS_ESPState.DistanceESP)
    end

    local function KYS_EnsureHighlight(name, adornee, color, isPlayer)
        if not (adornee and KYS_Alive(adornee)) then return nil end
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(name, name)

        local hl = folder:FindFirstChild(name)
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = name
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = folder
        end

        hl.Adornee = adornee
        hl.FillColor = color
        hl.OutlineColor = color
        if isPlayer then
            hl.FillTransparency = KYS_ESPState.ESPFillTransparency
            hl.OutlineTransparency = KYS_ESPState.ESPOutlineTransparency
        else
            hl.FillTransparency = 0.98
            hl.OutlineTransparency = 0.5
        end
        hl.Enabled = true
        return hl
    end

    local function KYS_DestroyChild(name)
        local folder = KYS_GetESPFolder()
        local child = folder:FindFirstChild(name)
        if child then child:Destroy() end
    end

    local function KYS_ClearPlayerESP(player)
        if not player or player == LP then return end
        local key = KYS_PlayerKey(player)
        KYS_DestroyChild("KYS_PlayerHL_" .. key)
        KYS_DestroyChild("KYS_PlayerTag_" .. key)
        KYS_DestroyChild("KYS_PlayerItem_" .. key)
    end

    local function KYS_ClearAllPlayerESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                KYS_ClearPlayerESP(player)
            end
        end
    end

    local function KYS_GetSurvivorItem(player)
        local character = player.Character
        if not character then return nil end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Accessory") or obj:IsA("Model") then
                if KYS_DisplayNames[obj.Name] then
                    return obj.Name
                end
            end
        end
        return nil
    end

    local function KYS_GetItemImageId(itemName)
        local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
        if not itemsFolder then return nil end
        local itemObj = itemsFolder:FindFirstChild(itemName)
        if not itemObj then return nil end

        if itemObj:IsA("Decal") or itemObj:IsA("Texture") then return itemObj.Texture end
        local texture = itemObj:FindFirstChildWhichIsA("Decal", true) or itemObj:FindFirstChildWhichIsA("Texture", true)
        if texture then return texture.Texture end
        local namedTexture = itemObj:FindFirstChild("Texture", true)
        if namedTexture and (namedTexture:IsA("Decal") or namedTexture:IsA("Texture")) then
            return namedTexture.Texture
        end
        return nil
    end

    local function KYS_SetBillboardLine(parent, index, count, data)
        local label = parent:FindFirstChild("Line" .. index)
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "Line" .. index
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Font = Enum.Font.Gotham
            label.TextStrokeTransparency = 0.65
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Parent = parent
        end
        label.Size = UDim2.new(1, 0, 1 / count, 0)
        label.Position = UDim2.new(0, 0, (index - 1) / count, 0)
        label.TextSize = KYS_ESPState.ESPTextSize
        label.TextColor3 = data.Color
        label.Text = data.Text
    end

    local function KYS_PruneBillboardLines(parent, count)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") then
                local index = tonumber(child.Name:match("%d+"))
                if index and index > count then
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_UpdatePlayerTag(player, character, head, color)
        local key = KYS_PlayerKey(player)
        local tagName = "KYS_PlayerTag_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerTag_" .. key, tagName)

        if not KYS_ValidPart(head) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.DistanceESP and root and targetRoot then
            distanceText = "[" .. tostring(math.floor((root.Position - targetRoot.Position).Magnitude)) .. "m]"
        end

        local nameText = KYS_ESPState.Nametags and player.Name or ""
        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = color })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = head
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.65, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_UpdatePlayerItemIcon(player, torso)
        local key = KYS_PlayerKey(player)
        local iconName = "KYS_PlayerItem_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerItem_" .. key, iconName)

        if not KYS_ValidPart(torso) then
            KYS_DestroyChild(iconName)
            return
        end

        local itemName = KYS_GetSurvivorItem(player)
        local imageId = itemName and KYS_GetItemImageId(itemName) or nil
        if not imageId then
            KYS_DestroyChild(iconName)
            return
        end

        local icon = folder:FindFirstChild(iconName)
        if not icon then
            icon = Instance.new("BillboardGui")
            icon.Name = iconName
            icon.AlwaysOnTop = true
            icon.LightInfluence = 0
            icon.MaxDistance = 0
            icon.Size = UDim2.fromOffset(20, 20)
            icon.StudsOffset = Vector3.new(0, 0, -1.6)
            icon.Parent = folder

            local image = Instance.new("ImageLabel")
            image.Name = "ImageLabel"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1, 1)
            image.Parent = icon
        end

        icon.Adornee = torso
        icon.Enabled = true
        local image = icon:FindFirstChild("ImageLabel")
        if image then image.Image = imageId end
    end

    local KYS_ApplyPlayerESP
    KYS_ApplyPlayerESP = function(player)
        if KYS_Dead or not player or player == LP then return end
        local character = player.Character
        if not (character and KYS_Alive(character)) then
            KYS_ClearPlayerESP(player)
            return
        end

        local key = KYS_PlayerKey(player)
        local enabled = KYS_ESPState.PlayerMasterESP and KYS_PlayerRoleEnabled(player)
        if not enabled then
            KYS_ClearPlayerESP(player)
            return
        end

        local color = KYS_PlayerColor(player)
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

        KYS_EnsureHighlight("KYS_PlayerHL_" .. key, character, color, true)
        KYS_UpdatePlayerTag(player, character, head, color)

        if KYS_GetRole(player) == "Survivor" and KYS_ESPState.SurvivorItemsESP then
            KYS_UpdatePlayerItemIcon(player, torso)
        else
            KYS_DestroyChild("KYS_PlayerItem_" .. key)
        end
    end

    local function KYS_RefreshAllPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                pcall(KYS_ApplyPlayerESP, player)
            end
        end
    end

    local function KYS_StartPlayerLoop()
        if KYS_PlayerLoopThread then return end
        KYS_PlayerLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_ESPState.PlayerMasterESP do
                KYS_RefreshAllPlayers()
                task.wait(0.25)
            end
            KYS_PlayerLoopThread = nil
        end)
    end

    local function KYS_WatchPlayer(player)
        if player == LP then return end
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end

        KYS_PlayerConns[player] = {}
        table.insert(KYS_PlayerConns[player], player.CharacterAdded:Connect(function(char)
            KYS_ClearPlayerESP(player)
            task.delay(0.15, function()
                if not KYS_Dead then pcall(KYS_ApplyPlayerESP, player) end
            end)
        end))
        table.insert(KYS_PlayerConns[player], player.CharacterRemoving:Connect(function()
            KYS_ClearPlayerESP(player)
        end))
        table.insert(KYS_PlayerConns[player], player:GetPropertyChangedSignal("Team"):Connect(function()
            KYS_ClearPlayerESP(player)
            pcall(KYS_ApplyPlayerESP, player)
        end))

        if player.Character then
            pcall(KYS_ApplyPlayerESP, player)
        end
    end

    local function KYS_UnwatchPlayer(player)
        KYS_ClearPlayerESP(player)
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        KYS_PlayerConns[player] = nil
    end

    local function KYS_PickWorldPart(model, cat)
        if not (model and KYS_Alive(model)) then return nil end
        if cat == "Generator" then
            local hitbox = model:FindFirstChild("HitBox", true) or model:FindFirstChild("GeneratorPoint", true)
            if KYS_ValidPart(hitbox) then return hitbox end
        elseif cat == "Palletwrong" then
            local candidates = {
                model:FindFirstChild("HumanoidRootPart", true),
                model:FindFirstChild("PrimaryPartPallet", true),
                model:FindFirstChild("Primary1", true),
                model:FindFirstChild("Primary2", true),
                model:FindFirstChild("PalletPoint", true),
                model:FindFirstChild("PalletPointSlide", true),
            }
            for _, part in ipairs(candidates) do
                if KYS_ValidPart(part) then return part end
            end
        elseif cat == "Window" then
            local vault = model:FindFirstChild("VaultPoint", true) or model:FindFirstChild("VaultTrigger", true)
            if KYS_ValidPart(vault) then return vault end
        elseif cat == "SCPZombie" then
            local root = model:FindFirstChild("HumanoidRootPart", true)
            if KYS_ValidPart(root) then return root end
            local torso = model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("Torso", true)
            if KYS_ValidPart(torso) then return torso end
            return nil
        end
        return KYS_FirstBasePart(model)
    end

    local function KYS_GeneratorLabel(model)
        local pct = tonumber(model:GetAttribute("RepairProgress")) or 0
        if pct >= 0 and pct <= 1.001 then pct = pct * 100 end
        pct = KYS_Clamp(pct, 0, 100)

        local repairers = tonumber(model:GetAttribute("PlayersRepairingCount")) or 0
        local paused = model:GetAttribute("ProgressPaused") == true
        local kickcount = tonumber(model:GetAttribute("kickcount")) or 0
        local abyss50 = model:GetAttribute("Abyss50Triggered") == true

        local parts = { "Gen " .. tostring(math.floor(pct + 0.5)) .. "%" }
        if repairers > 0 then table.insert(parts, "(" .. repairers .. "p)") end
        if paused then table.insert(parts, "Pause") end
        if abyss50 then table.insert(parts, "Warn") end
        if kickcount > 0 then table.insert(parts, "K:" .. kickcount) end

        local hue = KYS_Clamp((pct / 100) * 0.33, 0, 0.33)
        return table.concat(parts, " "), Color3.fromHSV(hue, 1, 1)
    end

    local function KYS_HasBasePart(model)
        if not (model and KYS_Alive(model)) then return false end
        return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
    end

    local function KYS_IsPalletGone(model)
        if not KYS_Alive(model) then return true end
        if not model:IsDescendantOf(Workspace) then return true end
        if KYS_PalletState[model] == "DEST" then return true end
        local ok, destroyed = pcall(function() return model:GetAttribute("Destroyed") end)
        if ok and destroyed == true then return true end
        return not KYS_HasBasePart(model)
    end

    local function KYS_WorldKey(cat, model)
        return "KYS_World_" .. cat .. "_" .. KYS_EspId(model)
    end

    local function KYS_ClearWorldVisual(cat, model)
        if not model then return end
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_HL")
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_Tag")
    end

    local function KYS_RemoveWorldEntry(cat, model)
        if not KYS_WorldReg[cat] or not KYS_WorldReg[cat][model] then return end
        KYS_ClearWorldVisual(cat, model)
        KYS_WorldReg[cat][model] = nil
    end

    local function KYS_EnsureWorldEntry(cat, model)
        if not KYS_Alive(model) or not KYS_WorldReg[cat] or KYS_WorldReg[cat][model] then return end
        if cat == "Palletwrong" and KYS_IsPalletGone(model) then return end
        local part = KYS_PickWorldPart(model, cat)
        if not KYS_ValidPart(part) then return end
        KYS_WorldReg[cat][model] = { part = part }
    end

    local function KYS_RegisterWorldDescendant(obj)
        if not KYS_Alive(obj) then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_EnsureWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_EnsureWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") then
                    if validCats[parent.Name] then
                        KYS_EnsureWorldEntry(parent.Name, parent)
                        return
                    end
                    local lower = parent.Name:lower()
                    if lower:find("scp") or lower:find("zombie") then
                        KYS_EnsureWorldEntry("SCPZombie", parent)
                        return
                    end
                end
                parent = parent.Parent
            end
        end
    end

    local function KYS_UnregisterWorldDescendant(obj)
        if not obj then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_RemoveWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_RemoveWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            for cat, models in pairs(KYS_WorldReg) do
                for model, entry in pairs(models) do
                    if entry.part == obj then
                        KYS_RemoveWorldEntry(cat, model)
                    end
                end
            end
        end
    end

    local function KYS_AttachESPRoot(root)
        if not root or KYS_MapAdd[root] then return end
        KYS_MapAdd[root] = root.DescendantAdded:Connect(KYS_RegisterWorldDescendant)
        KYS_MapRem[root] = root.DescendantRemoving:Connect(KYS_UnregisterWorldDescendant)
        for _, descendant in ipairs(root:GetDescendants()) do
            KYS_RegisterWorldDescendant(descendant)
        end
    end

    local function KYS_RefreshESPRoots()
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        KYS_MapAdd, KYS_MapRem = {}, {}

        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
            KYS_WorldReg[cat] = {}
        end

        local map = Workspace:FindFirstChild("Map")
        local map1 = Workspace:FindFirstChild("Map1")
        if map then KYS_AttachESPRoot(map) end
        if map1 then KYS_AttachESPRoot(map1) end
    end

    local function KYS_LabelForPallet(model)
        local state = KYS_PalletState[model] or "UP"
        if state == "DOWN" then return "Pallet (down)" end
        if state == "DEST" then return "Pallet (destroyed)" end
        if state == "SLIDE" then return "Pallet (slide)" end
        return "Pallet"
    end

    local function KYS_LabelForWindow(model)
        local state = KYS_WindowState[model] or "READY"
        if state == "BUSY" then return "Window (busy)" end
        return "Window"
    end

    local function KYS_AnyWorldEnabled()
        return KYS_ESPState.WorldMasterESP and (
            KYS_ESPState.GeneratorESP or
            KYS_ESPState.HookESP or
            KYS_ESPState.GateESP or
            KYS_ESPState.WindowESP or
            KYS_ESPState.PalletESP or
            KYS_ESPState.SCPZombieESP
        )
    end

    local function KYS_WorldCategoryData(cat)
        if cat == "Generator" then return KYS_ESPState.GeneratorESP, KYS_ESPState.GeneratorColor end
        if cat == "Hook" then return KYS_ESPState.HookESP, KYS_ESPState.HookColor end
        if cat == "Gate" then return KYS_ESPState.GateESP, KYS_ESPState.GateColor end
        if cat == "Window" then return KYS_ESPState.WindowESP, KYS_ESPState.WindowColor end
        if cat == "Palletwrong" then return KYS_ESPState.PalletESP, KYS_ESPState.PalletColor end
        if cat == "SCPZombie" then return KYS_ESPState.SCPZombieESP, KYS_ESPState.SCPZombieColor end
        return false, Color3.new(1, 1, 1)
    end

    local function KYS_UpdateWorldTag(cat, model, part, color)
        local key = KYS_WorldKey(cat, model)
        local tagName = key .. "_Tag"
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(tagName, tagName)

        if not KYS_ValidPart(part) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.WorldDistanceESP and root then
            distanceText = "[" .. tostring(math.floor((root.Position - part.Position).Magnitude)) .. "m]"
        end

        local nameText = ""
        local labelColor = color
        if KYS_ESPState.WorldNametags then
            if cat == "Generator" then
                local txt, genColor = KYS_GeneratorLabel(model)
                nameText = txt
                labelColor = genColor
            elseif cat == "Palletwrong" then
                nameText = KYS_LabelForPallet(model)
            elseif cat == "Window" then
                nameText = KYS_LabelForWindow(model)
            elseif cat == "SCPZombie" then
                nameText = model.Name
            else
                nameText = cat
            end
        end

        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = labelColor })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = part
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.5, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_ClearAllWorldESP()
        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
        end
    end

    local function KYS_StartWorldLoop()
        if KYS_WorldLoopThread then return end
        KYS_WorldLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_AnyWorldEnabled() do
                for cat, models in pairs(KYS_WorldReg) do
                    local enabled, color = KYS_WorldCategoryData(cat)
                    if enabled and KYS_ESPState.WorldMasterESP then
                        local n = 0
                        for model, entry in pairs(models) do
                            if cat == "Palletwrong" and KYS_IsPalletGone(model) then
                                KYS_RemoveWorldEntry(cat, model)
                            elseif model and KYS_Alive(model) then
                                local part = entry.part
                                if not KYS_ValidPart(part) or (model:IsA("Model") and not part:IsDescendantOf(model)) then
                                    entry.part = KYS_PickWorldPart(model, cat)
                                    part = entry.part
                                end

                                if KYS_ValidPart(part) then
                                    local key = KYS_WorldKey(cat, model)
                                    KYS_EnsureHighlight(key .. "_HL", model, color, false)
                                    KYS_UpdateWorldTag(cat, model, part, color)
                                else
                                    KYS_RemoveWorldEntry(cat, model)
                                end
                            else
                                KYS_RemoveWorldEntry(cat, model)
                            end

                            n = n + 1
                            if n % 60 == 0 then task.wait() end
                        end
                    else
                        for model in pairs(models) do
                            KYS_ClearWorldVisual(cat, model)
                        end
                    end
                end
                task.wait(0.25)
            end
            KYS_WorldLoopThread = nil
        end)
    end

    local function KYS_Selected(selected, name)
        if type(selected) ~= "table" then return false end
        if selected[name] ~= nil then return selected[name] == true end
        for _, value in pairs(selected) do
            if value == name then return true end
        end
        return false
    end

    getgenv().KYS_AddVisualESPControls = function(VisualTabRef)
        if not VisualTabRef or KYS_ControlsAdded then return end
        KYS_ControlsAdded = true

        local settingsSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "Highlight ESP Settings",
            Icon = "solar:settings-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        settingsSection:AddSlider({
            Name = "ESP Fill Transparency",
            Flag = "KYS ESP Fill Transparency",
            Min = 0,
            Max = 1,
            Default = KYS_ESPState.ESPFillTransparency,
            Increment = 0.01,
            Callback = function(value)
                KYS_ESPState.ESPFillTransparency = value
                KYS_RefreshAllPlayers()
            end,
        })

        settingsSection:AddSlider({
            Name = "ESP Outline Transparency",
            Flag = "KYS ESP Outline Transparency",
            Min = 0,
            Max = 1,
            Default = KYS_ESPState.ESPOutlineTransparency,
            Increment = 0.01,
            Callback = function(value)
                KYS_ESPState.ESPOutlineTransparency = value
                KYS_RefreshAllPlayers()
            end,
        })

        settingsSection:AddSlider({
            Name = "ESP Text Size",
            Flag = "KYS ESP Text Size",
            Min = 8,
            Max = 22,
            Default = KYS_ESPState.ESPTextSize,
            Increment = 1,
            Callback = function(value)
                KYS_ESPState.ESPTextSize = value
                KYS_RefreshAllPlayers()
            end,
        })

        local playerSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "Player Highlight ESP",
            Icon = "solar:users-group-rounded-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        playerSection:AddToggle({
            Name = "Enable Player ESP",
            Flag = "KYS Enable Player ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.PlayerMasterESP = state
                if state then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddDropdown({
            Name = "Select Player ESP",
            Flag = "KYS Select Player ESP",
            Values = { "Survivor ESP", "Killer ESP", "Spectator ESP", "Survivor Items ESP" },
            Multi = true,
            AllowNone = true,
            Default = {},
            Callback = function(selected)
                KYS_ESPState.SurvivorESP = KYS_Selected(selected, "Survivor ESP")
                KYS_ESPState.KillerESP = KYS_Selected(selected, "Killer ESP")
                KYS_ESPState.SpectatorESP = KYS_Selected(selected, "Spectator ESP")
                KYS_ESPState.SurvivorItemsESP = KYS_Selected(selected, "Survivor Items ESP")

                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Player Nametags",
            Flag = "KYS Player Nametags",
            Default = false,
            Callback = function(state)
                KYS_ESPState.Nametags = state
                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Player Distance ESP",
            Flag = "KYS Player Distance ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.DistanceESP = state
                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Survivor Killer Warning (!)",
            Flag = "Survivor Killer Warning",
            Default = false,
            Callback = function(state)
                VD.SURV_WarnKiller = state
            end,
        })

        pcall(function() playerSection:AddDivider({ Text = "Colors" }) end)
        playerSection:AddColorPicker({ Name = "Survivor Color", Flag = "KYS Survivor Color", Default = KYS_ESPState.SurvivorColor, Callback = function(color) KYS_ESPState.SurvivorColor = color; KYS_RefreshAllPlayers() end })
        playerSection:AddColorPicker({ Name = "Killer Color", Flag = "KYS Killer Color", Default = KYS_ESPState.KillerColor, Callback = function(color) KYS_ESPState.KillerColor = color; KYS_RefreshAllPlayers() end })
        playerSection:AddColorPicker({ Name = "Spectator Color", Flag = "KYS Spectator Color", Default = KYS_ESPState.SpectatorColor, Callback = function(color) KYS_ESPState.SpectatorColor = color; KYS_RefreshAllPlayers() end })

        local worldSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "World Highlight ESP",
            Icon = "solar:map-point-wave-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        worldSection:AddToggle({
            Name = "Enable World ESP",
            Flag = "KYS Enable World ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldMasterESP = state
                if state then
                    KYS_RefreshESPRoots()
                    if KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
                else
                    KYS_ClearAllWorldESP()
                end
            end,
        })

        worldSection:AddDropdown({
            Name = "Select World Objects",
            Flag = "KYS Select World Objects",
            Values = { "Generators", "Hooks", "Gates", "Windows", "Pallets", "SCP / Zombie" },
            Multi = true,
            AllowNone = true,
            Default = {},
            Callback = function(selected)
                KYS_ESPState.GeneratorESP = KYS_Selected(selected, "Generators")
                KYS_ESPState.HookESP = KYS_Selected(selected, "Hooks")
                KYS_ESPState.GateESP = KYS_Selected(selected, "Gates")
                KYS_ESPState.WindowESP = KYS_Selected(selected, "Windows")
                KYS_ESPState.PalletESP = KYS_Selected(selected, "Pallets")
                KYS_ESPState.SCPZombieESP = KYS_Selected(selected, "SCP / Zombie")

                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then
                    KYS_RefreshESPRoots()
                    KYS_StartWorldLoop()
                else
                    KYS_ClearAllWorldESP()
                end
            end,
        })

        worldSection:AddToggle({
            Name = "World Nametags",
            Flag = "KYS World Nametags",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldNametags = state
                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() else KYS_ClearAllWorldESP() end
            end,
        })

        worldSection:AddToggle({
            Name = "World Distance ESP",
            Flag = "KYS World Distance ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldDistanceESP = state
                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() else KYS_ClearAllWorldESP() end
            end,
        })

        pcall(function() worldSection:AddDivider({ Text = "Colors" }) end)
        worldSection:AddColorPicker({ Name = "Generator Color", Flag = "KYS Generator Color", Default = KYS_ESPState.GeneratorColor, Callback = function(color) KYS_ESPState.GeneratorColor = color end })
        worldSection:AddColorPicker({ Name = "Hook Color", Flag = "KYS Hook Color", Default = KYS_ESPState.HookColor, Callback = function(color) KYS_ESPState.HookColor = color end })
        worldSection:AddColorPicker({ Name = "Gate Color", Flag = "KYS Gate Color", Default = KYS_ESPState.GateColor, Callback = function(color) KYS_ESPState.GateColor = color end })
        worldSection:AddColorPicker({ Name = "Window Color", Flag = "KYS Window Color", Default = KYS_ESPState.WindowColor, Callback = function(color) KYS_ESPState.WindowColor = color end })
        worldSection:AddColorPicker({ Name = "Pallet Color", Flag = "KYS Pallet Color", Default = KYS_ESPState.PalletColor, Callback = function(color) KYS_ESPState.PalletColor = color end })
        worldSection:AddColorPicker({ Name = "SCP / Zombie Color", Flag = "KYS SCP Zombie Color", Default = KYS_ESPState.SCPZombieColor, Callback = function(color) KYS_ESPState.SCPZombieColor = color end })
    end

    for _, player in ipairs(Players:GetPlayers()) do
        KYS_WatchPlayer(player)
    end

    table.insert(KYS_Connections, Players.PlayerAdded:Connect(KYS_WatchPlayer))
    table.insert(KYS_Connections, Players.PlayerRemoving:Connect(KYS_UnwatchPlayer))
    table.insert(KYS_Connections, Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" or child.Name == "Map1" then
            KYS_AttachESPRoot(child)
            if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
        end
    end))
    table.insert(KYS_Connections, Workspace.ChildRemoved:Connect(function(child)
        if child.Name == "Map" or child.Name == "Map1" then
            KYS_RefreshESPRoots()
        end
    end))

    KYS_RefreshESPRoots()

    getgenv().KYS_VD_VisualESP_Cleanup = function()
        KYS_Dead = true
        KYS_ClearAllPlayerESP()
        KYS_ClearAllWorldESP()

        for _, conn in ipairs(KYS_Connections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conns in pairs(KYS_PlayerConns) do
            for _, conn in ipairs(conns) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            KYS_ESPFolder:Destroy()
        end
    end

    KYS_SafeNotify("Visual ESP", "Highlight ESP V2 loaded. Anti double nametag aktif.", 3)
end



-- =====================================================
-- FULLBRIGHT
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if VD.Fullbright then
            local weatherTheme = VD.VIS_WeatherTheme and KYS_WeatherPresets[VD.VIS_WeatherTheme]
            local keepWeatherLighting = VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" and weatherTheme and weatherTheme.Lighting
            if keepWeatherLighting then
                for k, v in pairs(weatherTheme.Lighting) do
                    pcall(function() Lighting[k] = v end)
                end
                Lighting.Brightness = math.max(Lighting.Brightness, 2)
                Lighting.GlobalShadows = false
                if VD.NO_Fog then
                    Lighting.FogStart = 0
                    Lighting.FogEnd = 100000
                end
            else
                Lighting.Brightness     = 2
                Lighting.ClockTime      = 14
                Lighting.GlobalShadows  = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                Lighting.FogStart       = 0
                Lighting.FogEnd         = 100000
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
                    for k, v in pairs(theme.Lighting) do
                        pcall(function() Lighting[k] = v end)
                    end
                end
            else
                Lighting.Brightness     = originalLighting.Brightness
                Lighting.ClockTime      = originalLighting.ClockTime
                Lighting.FogEnd         = originalLighting.FogEnd
                Lighting.FogStart       = originalLighting.FogStart or 0
                Lighting.GlobalShadows  = originalLighting.GlobalShadows
                Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") and originalLighting.Atmosphere then
                        v.Density = originalLighting.Atmosphere.Density or 0.3
                        v.Offset  = originalLighting.Atmosphere.Offset or 0.25
                        v.Glare   = originalLighting.Atmosphere.Glare or 0
                        v.Haze    = originalLighting.Atmosphere.Haze or 0
                    end
                    if v:IsA("BlurEffect") and originalLighting.Blur then v.Size = originalLighting.Blur.Size or 0 end
                    if v:IsA("ColorCorrectionEffect") and originalLighting.ColorCorrection then
                        v.Enabled = originalLighting
                            .ColorCorrection.Enabled or false
                    end
                    if v:IsA("SunRaysEffect") and originalLighting.SunRays then
                        v.Enabled = originalLighting.SunRays.Enabled or
                            false
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- =====================================================-- =====================================================
-- MOVEMENT & NOCLIP
-- =====================================================
local originalCanCollide = {}

RunService.Stepped:Connect(function()
    if VD.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, descendant in ipairs(char:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if originalCanCollide[descendant] == nil then
                        originalCanCollide[descendant] = descendant.CanCollide
                    end
                    descendant.CanCollide = false
                end
            end
        end
    end
end)

getgenv().VD_DisableNoclip = function()
    for part, canCollide in pairs(originalCanCollide) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    originalCanCollide = {}
end

LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == LocalPlayer.Character then
        originalCanCollide = {}
    end
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
    if VD.InfiniteJump and myHum then
        myHum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
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
-- AUTO PARRY + AUTO SKILLCHECK (ported from survivor)
-- =====================================================
function VD_Notify(title, content, duration)
    pcall(function()
        Library:Notify({
            Title   = title,
            Description = content,
            Time    = duration or 2,
        })
    end)
end

end

-- =====================================================
-- SILENT AIM: TWIST OF FATE
-- =====================================================
(function()
local KYS_ToFState = {
    Connection = nil,
    LaserBeam = nil,
    TargetGui = nil,
    InputBegan = nil,
    InputEnded = nil,
    TouchInput = nil,
    IsAiming = false,
    SavedUIPos = UDim2.new(0.5, -120, 0, 110),
    SCPCache = {},
    SCPCacheTimer = 0,
}

local KYS_ToFKeyCodes = {
    None = nil,
    Q = Enum.KeyCode.Q,
    E = Enum.KeyCode.E,
    R = Enum.KeyCode.R,
    T = Enum.KeyCode.T,
    F = Enum.KeyCode.F,
    G = Enum.KeyCode.G,
    H = Enum.KeyCode.H,
    J = Enum.KeyCode.J,
    K = Enum.KeyCode.K,
    L = Enum.KeyCode.L,
    X = Enum.KeyCode.X,
    Z = Enum.KeyCode.Z,
}

local function KYS_ToFGetEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local tof = items and items:FindFirstChild("Twist of Fate")
    local fire = tof and tof:FindFirstChild("Fire")
    if fire and fire:IsA("RemoteEvent") then
        return fire
    end
    return nil
end

local function KYS_ToFGetGunObject()
    local char = LocalPlayer.Character
    if not char then return nil end

    local baseToF = char:FindFirstChild("Twist of Fate", true)
    if not baseToF then return nil end

    local rightArm = baseToF:FindFirstChild("Right Arm")
    if rightArm then
        local gunPart = rightArm:FindFirstChild("gun")
        if gunPart then return gunPart end

        local emperorGun = rightArm:FindFirstChild("EmperorGun")
        if emperorGun then return emperorGun end
    end

    return baseToF
end

local function KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter)
    local direction = targetPos - originPos
    local distance = direction.Magnitude
    if distance < 0.1 then return true end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local excludeList = {}
    local localChar = LocalPlayer.Character
    if localChar then table.insert(excludeList, localChar) end
    if targetCharacter and targetCharacter ~= localChar then table.insert(excludeList, targetCharacter) end
    if KYS_ToFState.LaserBeam then table.insert(excludeList, KYS_ToFState.LaserBeam) end

    rayParams.FilterDescendantsInstances = excludeList

    local result = workspace:Raycast(originPos, direction.Unit * distance, rayParams)
    return result == nil
end

local function KYS_ToFGetSCPs()
    if tick() - KYS_ToFState.SCPCacheTimer < 0.5 then
        return KYS_ToFState.SCPCache
    end

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

    KYS_ToFState.SCPCache = newTargets
    KYS_ToFState.SCPCacheTimer = tick()
    return KYS_ToFState.SCPCache
end

local function KYS_ToFGetTargetPosition()
    local gunObj = KYS_ToFGetGunObject()
    local char = LocalPlayer.Character
    if not (gunObj and char) then return nil, nil, nil, nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil, nil, nil end

    local myPos = hrp.Position
    local originPos
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
        if VD.TOF_WallCheck and not KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter) then
            return nil, nil, nil, nil
        end

        local targetVel = Vector3.new(0, 0, 0)
        local rootPart = targetCharacter and (targetCharacter:FindFirstChild("HumanoidRootPart") or torso)
        if rootPart then targetVel = rootPart.Velocity end

        local directionRaw = targetPos - originPos
        local distance = directionRaw.Magnitude
        if distance < 0.1 then return nil, nil, nil, nil end
        if distance < 5 then return directionRaw.Unit, gunObj, originPos, targetPos end

        local travelTime = distance / 400
        local predictedPos = targetPos + (targetVel * travelTime)
        for _ = 1, 2 do
            local newDist = (predictedPos - originPos).Magnitude
            travelTime = newDist / 400
            predictedPos = targetPos + (targetVel * travelTime)
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
                local torso = player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dist = (myPos - torso.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTorso = torso
                        closestChar = player.Character
                    end
                end
            end
        end
        if not closestTorso then return nil, nil, nil, nil end
        return predictTarget(closestTorso, closestChar)
    elseif targetMode == "Survivors" then
        local bestTorso, bestChar, bestDot = nil, nil, -math.huge
        local cam = workspace.CurrentCamera
        local camLook = cam.CFrame.LookVector

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local torso = player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dirToTarget = torso.Position - cam.CFrame.Position
                    if dirToTarget.Magnitude > 0.1 then
                        local dot = camLook:Dot(dirToTarget.Unit)
                        if dot > 0.5 and dot > bestDot then
                            bestDot = dot
                            bestTorso = torso
                            bestChar = player.Character
                        end
                    end
                end
            end
        end
        if not bestTorso then return nil, nil, nil, nil end
        return predictTarget(bestTorso, bestChar)
    elseif targetMode == "Zombie" then
        local bestPart, bestDot = nil, -math.huge
        local cam = workspace.CurrentCamera
        local camLook = cam.CFrame.LookVector

        for _, root in ipairs(KYS_ToFGetSCPs()) do
            if root and root.Parent then
                local dirToTarget = root.Position - cam.CFrame.Position
                if dirToTarget.Magnitude > 0.1 then
                    local dot = camLook:Dot(dirToTarget.Unit)
                    if dot > 0.5 and dot > bestDot then
                        bestDot = dot
                        bestPart = root
                    end
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
        local laser = Instance.new("Part")
        laser.Name = "ToFLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.CanTouch = false
        laser.CastShadow = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 50, 50)
        laser.Parent = workspace
        KYS_ToFState.LaserBeam = laser
    end

    local dist = (targetPos - originPos).Magnitude
    KYS_ToFState.LaserBeam.Size = Vector3.new(0.05, 0.05, dist)
    KYS_ToFState.LaserBeam.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    KYS_ToFState.LaserBeam.Transparency = 0
end

local function KYS_ToFClearLaser()
    if KYS_ToFState.LaserBeam then
        pcall(function() KYS_ToFState.LaserBeam:Destroy() end)
        KYS_ToFState.LaserBeam = nil
    end
end

local AimConfig = {
    Pistol_BlockKnocked = true,
}

local function IsDowned(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local state = char:GetAttribute("State")
    return state == "Downed" or state == "Dead"
end

local function KYS_ToFGetMobileShootButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local survivorMob = playerGui and playerGui:FindFirstChild("Survivor-mob")
    local controls = survivorMob and survivorMob:FindFirstChild("Controls")
    local guiMob = controls and controls:FindFirstChild("Gui-mob")
    if not guiMob then return nil end

    local directNames = { "attack", "Attack", "shoot", "Shoot", "fire", "Fire" }
    for _, name in ipairs(directNames) do
        local btn = guiMob:FindFirstChild(name, true)
        if btn and btn:IsA("GuiObject") then return btn end
    end

    for _, obj in ipairs(guiMob:GetDescendants()) do
        if obj:IsA("GuiButton") and obj.Visible then
            return obj
        end
    end

    return guiMob:IsA("GuiObject") and guiMob or nil
end

local function KYS_ToFIsTouchOnShootButton(input)
    local shootButton = KYS_ToFGetMobileShootButton()
    if not (shootButton and shootButton.Visible) then return false end

    local pos = input.Position
    local absPos = shootButton.AbsolutePosition
    local absSize = shootButton.AbsoluteSize

    return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

local function KYS_ToFDoShoot()
    if not VD.TOF_SilentAim then return end

    AimConfig.Pistol_BlockKnocked = VD.TOF_BlockKnocked ~= false
    local char = LocalPlayer.Character
    if char then
        if AimConfig.Pistol_BlockKnocked and IsDowned(char) then
            return
        end
    end

    local targetDirection, gunObject, originPos, targetPos = KYS_ToFGetTargetPosition()
    if not (targetDirection and gunObject and targetPos and originPos) then return end

    local tofEvent = KYS_ToFGetEvent()
    if not tofEvent then return end

    local freshDirection = targetPos - originPos
    if freshDirection.Magnitude < 0.1 then return end

    pcall(function()
        tofEvent:FireServer(gunObject, freshDirection.Unit)
    end)
end

local KYS_ToFModeButtons = {}
local function KYS_ToFRefreshTargetButtons()
    local modes = {
        Killer = { Color3.fromRGB(180, 45, 45), Color3.fromRGB(255, 180, 180) },
        Survivors = { Color3.fromRGB(25, 80, 150), Color3.fromRGB(160, 210, 255) },
        Zombie = { Color3.fromRGB(120, 80, 10), Color3.fromRGB(255, 210, 100) },
    }

    for modeName, btn in pairs(KYS_ToFModeButtons) do
        if btn and btn.Parent then
            local active = modeName == (VD.TOF_TargetMode or "Killer")
            local colors = modes[modeName]
            btn.BackgroundColor3 = active and colors[1] or Color3.fromRGB(30, 32, 40)
            btn.TextColor3 = active and colors[2] or Color3.fromRGB(155, 160, 175)
        end
    end
end

local function KYS_ToFSetTargetMode(modeName, notify)
    if modeName ~= "Killer" and modeName ~= "Survivors" and modeName ~= "Zombie" then return end
    VD.TOF_TargetMode = modeName
    KYS_ToFRefreshTargetButtons()
    if notify then VD_Notify("Target Mode", modeName, 1) end
end

local function KYS_ToFCreateTargetSelectorUI()
    local parent = GetSafeGuiParent()
    if not parent then return end
    if KYS_ToFState.TargetGui and KYS_ToFState.TargetGui.Parent then return end

    local old = parent:FindFirstChild("ToFTargetSelector")
    if old then pcall(function() old:Destroy() end) end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ToFTargetSelector"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 180, 0, 126)
    frame.Position = KYS_ToFState.SavedUIPos
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(96, 72, 160)
    stroke.Thickness = 1

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    header.BorderSizePixel = 0
    header.Parent = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerDiv = Instance.new("Frame")
    headerDiv.Size = UDim2.new(1, 0, 0, 1)
    headerDiv.Position = UDim2.new(0, 0, 1, -1)
    headerDiv.BackgroundColor3 = Color3.fromRGB(48, 42, 72)
    headerDiv.BorderSizePixel = 0
    headerDiv.Parent = header

    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, -34, 1, 0)
    dragArea.BackgroundTransparency = 1
    dragArea.Parent = header

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(185, 190, 205)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    minimizeBtn.Parent = header

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Size = UDim2.new(1, -44, 1, 0)
    headerLbl.Position = UDim2.new(0, 10, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = "TOF TARGET MODE"
    headerLbl.TextColor3 = Color3.fromRGB(210, 215, 230)
    headerLbl.Font = Enum.Font.GothamBold
    headerLbl.TextSize = 10
    headerLbl.TextXAlignment = Enum.TextXAlignment.Left
    headerLbl.Parent = header

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -16, 0, 86)
    btnContainer.Position = UDim2.new(0, 8, 0, 34)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = frame

    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        minimizeBtn.Text = isMinimized and "+" or "-"
        btnContainer.Visible = not isMinimized
        frame.Size = isMinimized and UDim2.new(0, 180, 0, 28) or UDim2.new(0, 180, 0, 126)
    end)

    local modes = {
        { Internal = "Killer", Display = "KILLER        K" },
        { Internal = "Survivors", Display = "SURVIVOR      J" },
        { Internal = "Zombie", Display = "ZOMBIE        L" },
    }

    KYS_ToFModeButtons = {}
    for i, mode in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Text = mode.Display
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.LayoutOrder = i
        btn.Parent = btnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(58, 62, 78)
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            KYS_ToFSetTargetMode(mode.Internal, false)
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                KYS_ToFSetTargetMode(mode.Internal, false)
            end
        end)

        KYS_ToFModeButtons[mode.Internal] = btn
    end
    KYS_ToFRefreshTargetButtons()

    local dragging = false
    local dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
            dragging = true
        end
    end)
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            frame.Position = newPos
            KYS_ToFState.SavedUIPos = newPos
        end
    end)

    KYS_ToFState.TargetGui = gui
end

local function KYS_ToFDestroyTargetSelectorUI()
    if KYS_ToFState.TargetGui then
        pcall(function() KYS_ToFState.TargetGui:Destroy() end)
        KYS_ToFState.TargetGui = nil
    end
    KYS_ToFModeButtons = {}
end

local function KYS_ToFStartConnection()
    if KYS_ToFState.Connection then return end
    KYS_ToFState.Connection = RunService.Heartbeat:Connect(function()
        if not VD.TOF_SilentAim or not KYS_ToFState.IsAiming then
            if KYS_ToFState.LaserBeam then KYS_ToFState.LaserBeam.Transparency = 1 end
            return
        end

        local _, _, originPos, targetPos = KYS_ToFGetTargetPosition()
        if originPos and targetPos then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and not char:GetAttribute("IsCarried") then
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                end
            end)

            if VD.TOF_Laser then
                KYS_ToFUpdateLaser(originPos, targetPos)
            elseif KYS_ToFState.LaserBeam then
                KYS_ToFState.LaserBeam.Transparency = 1
            end
        elseif KYS_ToFState.LaserBeam then
            KYS_ToFState.LaserBeam.Transparency = 1
        end
    end)
end

local function KYS_ToFStopConnection()
    if KYS_ToFState.Connection then
        pcall(function() KYS_ToFState.Connection:Disconnect() end)
        KYS_ToFState.Connection = nil
    end
    KYS_ToFState.IsAiming = false
    KYS_ToFClearLaser()
end

local function KYS_ToFDisconnectInputs()
    if KYS_ToFState.InputBegan then pcall(function() KYS_ToFState.InputBegan:Disconnect() end) end
    if KYS_ToFState.InputEnded then pcall(function() KYS_ToFState.InputEnded:Disconnect() end) end
    KYS_ToFState.InputBegan = nil
    KYS_ToFState.InputEnded = nil
end

local KYS_SetToFSilentAim

local function KYS_ToFEnsureInputs()
    if not KYS_ToFState.InputBegan then
        KYS_ToFState.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            local keyCode = KYS_ToFKeyCodes[VD.TOF_Key or "None"]
            if keyCode and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode then
                KYS_SetToFSilentAim(not VD.TOF_SilentAim)
                return
            end

            if not VD.TOF_SilentAim then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or (input.UserInputType == Enum.UserInputType.Touch and KYS_ToFIsTouchOnShootButton(input)) then
                KYS_ToFState.IsAiming = true
                if input.UserInputType == Enum.UserInputType.Touch then
                    KYS_ToFState.TouchInput = input
                end
                KYS_ToFDoShoot()
                return
            end

            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.K then
                    KYS_ToFSetTargetMode("Killer", true)
                elseif input.KeyCode == Enum.KeyCode.J then
                    KYS_ToFSetTargetMode("Survivors", true)
                elseif input.KeyCode == Enum.KeyCode.L then
                    KYS_ToFSetTargetMode("Zombie", true)
                end
            end
        end)
    end
    if not KYS_ToFState.InputEnded then
        KYS_ToFState.InputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or (input.UserInputType == Enum.UserInputType.Touch and input == KYS_ToFState.TouchInput) then
                KYS_ToFState.IsAiming = false
                if input == KYS_ToFState.TouchInput then KYS_ToFState.TouchInput = nil end
                if KYS_ToFState.LaserBeam then KYS_ToFState.LaserBeam.Transparency = 1 end
            end
        end)
    end
end

KYS_SetToFSilentAim = function(enabled)
    VD.TOF_SilentAim = enabled and true or false
    KYS_ToFEnsureInputs()
    if VD.TOF_SilentAim then
        KYS_ToFCreateTargetSelectorUI()
        KYS_ToFStartConnection()
    else
        KYS_ToFDestroyTargetSelectorUI()
        KYS_ToFStopConnection()
    end
end

KYS_ToFEnsureInputs()
getgenv().KYS_SetToFSilentAim = KYS_SetToFSilentAim
getgenv().KYS_ToFClearLaser = KYS_ToFClearLaser
getgenv().KYS_ToFSetTargetMode = KYS_ToFSetTargetMode
end)();

-- =====================================================
-- HIDE SURVIVOR ICON
-- =====================================================
(function()
local KYS_HideSurvivorIconState = {
    Connection = nil,
    Originals = {},
}

local KYS_HideSurvivorIconImage = "rbxassetid://80891639562743"
local KYS_HideSurvivorIconText = "NxH"

local function KYS_GetSurvivorSlots()
    local slots = {}
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return slots end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if not (gui:IsA("ScreenGui") and gui.Name:match("%-mob$")) then
            continue
        end
        local frame = gui and gui:FindFirstChild("Frame")
        if frame then
            for i = 1, 5 do
                local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                local textLabel = survivorFrame and survivorFrame:FindFirstChild("TextLabel")
                if (imageLabel and imageLabel:IsA("ImageLabel")) or (textLabel and textLabel:IsA("TextLabel")) then
                    table.insert(slots, {
                        ImageLabel = imageLabel,
                        TextLabel = textLabel,
                    })
                end
            end
        end
    end

    return slots
end

local function KYS_ApplyHideSurvivorIcon()
    for _, slot in ipairs(KYS_GetSurvivorSlots()) do
        local imageLabel = slot.ImageLabel
        if imageLabel and imageLabel:IsA("ImageLabel") then
            if not KYS_HideSurvivorIconState.Originals[imageLabel] then
                KYS_HideSurvivorIconState.Originals[imageLabel] = {
                    Image = imageLabel.Image,
                    ImageColor3 = imageLabel.ImageColor3,
                    ImageTransparency = imageLabel.ImageTransparency,
                    ImageRectOffset = imageLabel.ImageRectOffset,
                    ImageRectSize = imageLabel.ImageRectSize,
                    ScaleType = imageLabel.ScaleType,
                }
            end

            imageLabel.Image = KYS_HideSurvivorIconImage
            imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
            imageLabel.ImageTransparency = 0
            imageLabel.ImageRectOffset = Vector2.new(0, 0)
            imageLabel.ImageRectSize = Vector2.new(0, 0)
            imageLabel.ScaleType = Enum.ScaleType.Crop
        end

        local textLabel = slot.TextLabel
        if textLabel and textLabel:IsA("TextLabel") then
            if not KYS_HideSurvivorIconState.Originals[textLabel] then
                KYS_HideSurvivorIconState.Originals[textLabel] = {
                    Text = textLabel.Text,
                    TextColor3 = textLabel.TextColor3,
                    TextTransparency = textLabel.TextTransparency,
                }
            end

            textLabel.Text = KYS_HideSurvivorIconText
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextTransparency = 0
        end
    end
end

local function KYS_RestoreSurvivorIcons()
    for object, original in pairs(KYS_HideSurvivorIconState.Originals) do
        if object and object.Parent and original then
            pcall(function()
                if original.Image ~= nil and object:IsA("ImageLabel") then
                    object.Image = original.Image
                    object.ImageColor3 = original.ImageColor3
                    object.ImageTransparency = original.ImageTransparency
                    object.ImageRectOffset = original.ImageRectOffset
                    object.ImageRectSize = original.ImageRectSize
                    object.ScaleType = original.ScaleType
                end
                if original.Text ~= nil and object:IsA("TextLabel") then
                    object.Text = original.Text
                    object.TextColor3 = original.TextColor3
                    object.TextTransparency = original.TextTransparency
                end
            end)
        end
    end
    KYS_HideSurvivorIconState.Originals = {}
end

local function KYS_SetHideSurvivorIcon(enabled)
    VD.VIS_HideSurvivorIcon = enabled and true or false

    if VD.VIS_HideSurvivorIcon then
        KYS_ApplyHideSurvivorIcon()
        if not KYS_HideSurvivorIconState.Connection then
            KYS_HideSurvivorIconState.Connection = RunService.Heartbeat:Connect(function()
                if VD.VIS_HideSurvivorIcon then
                    KYS_ApplyHideSurvivorIcon()
                end
            end)
        end
    else
        if KYS_HideSurvivorIconState.Connection then
            pcall(function() KYS_HideSurvivorIconState.Connection:Disconnect() end)
            KYS_HideSurvivorIconState.Connection = nil
        end
        KYS_RestoreSurvivorIcons()
    end
end

getgenv().KYS_SetHideSurvivorIcon = KYS_SetHideSurvivorIcon
end)();

-- =====================================================
-- SHOW HOOK COUNTER (SURVIVOR & KILLER)
-- =====================================================
(function()
local KYS_HookCounterState = {
    Connection = nil,
}

local function KYS_UpdateHookCounter(enabled)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
            local frame = gui:FindFirstChild("Frame")
            if frame then
                for i = 1, 5 do
                    local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                    local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                    local textLabel = survivorFrame and survivorFrame:FindFirstChild("TextLabel")
                    
                    if imageLabel and textLabel then
                        -- Handle original Counter if exists
                        local counter = imageLabel:FindFirstChild("Counter")
                        if counter then
                            pcall(function()
                                if counter.Visible ~= enabled then
                                    counter.Visible = enabled
                                end
                            end)
                        end

                        -- Handle Custom Text Hook Counter
                        local labelName = "KYS_CustomHookCounter"
                        local customLabel = imageLabel:FindFirstChild(labelName)
                        
                        if enabled then
                            local playerName = textLabel.Text
                            local player = nil
                            for _, p in ipairs(game.Players:GetPlayers()) do
                                if p.Name == playerName or p.DisplayName == playerName then
                                    player = p
                                    break
                                end
                            end

                            local hookCount = 0
                            if player then
                                hookCount = player:GetAttribute("HookCount") or (player.Character and player.Character:GetAttribute("HookCount")) or 0
                            end

                            if not customLabel then
                                customLabel = Instance.new("TextLabel")
                                customLabel.Name = labelName
                                customLabel.Size = UDim2.new(1, 0, 0.35, 0)
                                customLabel.Position = UDim2.new(0, 0, 0.65, 0)
                                customLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                customLabel.BackgroundTransparency = 0.5
                                customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                customLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                customLabel.TextStrokeTransparency = 0
                                customLabel.TextScaled = true
                                customLabel.Font = Enum.Font.SourceSansBold
                                customLabel.Parent = imageLabel
                            end

                            customLabel.Visible = true
                            if hookCount >= 3 then
                                customLabel.Text = "DEAD"
                                customLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
                            else
                                customLabel.Text = "Hooks: " .. tostring(hookCount)
                                if hookCount == 2 then
                                    customLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                                elseif hookCount == 1 then
                                    customLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                                else
                                    customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        else
                            if customLabel then
                                customLabel.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end

local function KYS_SetShowHookCounter(enabled)
    VD.VIS_ShowHookCounter = enabled and true or false

    if VD.VIS_ShowHookCounter then
        KYS_UpdateHookCounter(true)
        if not KYS_HookCounterState.Connection then
            KYS_HookCounterState.Connection = RunService.Heartbeat:Connect(function()
                if VD.VIS_ShowHookCounter then
                    KYS_UpdateHookCounter(true)
                end
            end)
        end
    else
        if KYS_HookCounterState.Connection then
            pcall(function() KYS_HookCounterState.Connection:Disconnect() end)
            KYS_HookCounterState.Connection = nil
        end
        KYS_UpdateHookCounter(false)
        -- Delete the custom label to keep GUI clean
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
                    local frame = gui:FindFirstChild("Frame")
                    if frame then
                        for i = 1, 5 do
                            local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                            local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                            customLabel = imageLabel and imageLabel:FindFirstChild("KYS_CustomHookCounter")
                            if customLabel then
                                pcall(function() customLabel:Destroy() end)
                            end
                        end
                    end
                end
            end
        end
    end
end

getgenv().KYS_SetShowHookCounter = KYS_SetShowHookCounter
end)();

-- =====================================================
-- SHOW PING & FPS
-- =====================================================
(function()
local KYS_PingFPSState = {
    Gui = nil,
    Connection = nil,
    Frames = 0,
    LastUpdate = 0,
}

local function KYS_GetPingValue()
    local ok, value = pcall(function()
        local stats = game:GetService("Stats")
        local network = stats and stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if dataPing and dataPing.GetValue then
            return math.floor(dataPing:GetValue() + 0.5)
        end
        if dataPing and dataPing.GetValueString then
            local raw = tostring(dataPing:GetValueString())
            return tonumber(raw:match("%d+"))
        end
    end)
    if ok and value then return value end
    return nil
end

local function KYS_CreatePingFPSGui()
    local parent = GetSafeGuiParent()
    if not parent then return nil end

    local old = parent:FindFirstChild("KYS_PingFPSGui")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_PingFPSGui"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 118, 0, 44)
    frame.Position = UDim2.new(0, 12, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = sg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(96, 72, 160)
    stroke.Thickness = 1

    local label = Instance.new("TextLabel")
    label.Name = "PingFPSLabel"
    label.Size = UDim2.new(1, -12, 1, -8)
    label.Position = UDim2.new(0, 6, 0, 4)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(230, 235, 245)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = "PING: --ms\nFPS: --"
    label.Parent = frame

    return sg
end

local function KYS_SetShowPingFPS(enabled)
    VD.VIS_ShowPingFPS = enabled and true or false

    if VD.VIS_ShowPingFPS then
        KYS_PingFPSState.Gui = KYS_PingFPSState.Gui or KYS_CreatePingFPSGui()
        KYS_PingFPSState.Frames = 0
        KYS_PingFPSState.LastUpdate = tick()

        if not KYS_PingFPSState.Connection then
            KYS_PingFPSState.Connection = RunService.RenderStepped:Connect(function()
                if not VD.VIS_ShowPingFPS then return end

                KYS_PingFPSState.Frames = KYS_PingFPSState.Frames + 1
                local now = tick()
                if now - KYS_PingFPSState.LastUpdate < 0.5 then return end

                local fps = math.floor(KYS_PingFPSState.Frames / (now - KYS_PingFPSState.LastUpdate) + 0.5)
                local ping = KYS_GetPingValue()
                KYS_PingFPSState.Frames = 0
                KYS_PingFPSState.LastUpdate = now

                if not (KYS_PingFPSState.Gui and KYS_PingFPSState.Gui.Parent) then
                    KYS_PingFPSState.Gui = KYS_CreatePingFPSGui()
                end

                local label = KYS_PingFPSState.Gui and KYS_PingFPSState.Gui:FindFirstChild("PingFPSLabel", true)
                if label then
                    label.Text = ("PING: %sms\nFPS: %d"):format(ping and tostring(ping) or "--", fps)
                end
            end)
        end
    else
        if KYS_PingFPSState.Connection then
            pcall(function() KYS_PingFPSState.Connection:Disconnect() end)
            KYS_PingFPSState.Connection = nil
        end
        if KYS_PingFPSState.Gui then
            pcall(function() KYS_PingFPSState.Gui:Destroy() end)
            KYS_PingFPSState.Gui = nil
        end
    end
end

getgenv().KYS_SetShowPingFPS = KYS_SetShowPingFPS
end)();

-- =====================================================
-- SILENT AIM: FLASHLIGHT
-- =====================================================
(function()
local KYS_FlashlightAimState = {
    Connection = nil,
    LaserBeam = nil,
    FlashlightPart = nil,
    Active = false,
}

local function KYS_GetFlashlightActivateRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local flashlight = items and items:FindFirstChild("Flashlight")
    local activate = flashlight and flashlight:FindFirstChild("Activate")
    if activate and activate:IsA("RemoteEvent") then
        return activate
    end
    return nil
end

local function KYS_GetFlashlightTargetPart(char)
    if not char then return nil end
    local preferred = VD.FLASH_TargetPart or "Head"
    local part = char:FindFirstChild(preferred)
    if part and part:IsA("BasePart") then return part end
    return char:FindFirstChild("Head")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function KYS_IsAliveCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local state = char:GetAttribute("State")
    return state ~= "Dead"
end

local function KYS_GetFlashlightTarget()
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    local maxRange = tonumber(VD.FLASH_Range) or 120
    local bestPart, bestScore = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and KYS_IsAliveCharacter(player.Character) then
            local isKiller = player.Team and player.Team.Name == "Killer"
            if isKiller then
                local part = KYS_GetFlashlightTargetPart(player.Character)
                if part then
                    local dist = (localRoot.Position - part.Position).Magnitude
                    if dist <= maxRange and dist < bestScore then
                        bestScore = dist
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPart
end

local function KYS_ClearFlashlightLaser()
    if KYS_FlashlightAimState.LaserBeam then
        pcall(function() KYS_FlashlightAimState.LaserBeam:Destroy() end)
        KYS_FlashlightAimState.LaserBeam = nil
    end
end

local function KYS_GetFlashlightOrigin(cam)
    local source = KYS_FlashlightAimState.FlashlightPart
    if typeof and typeof(source) == "Instance" then
        if source:IsA("BasePart") then
            return source.Position
        end
        local part = source:FindFirstChildWhichIsA("BasePart", true)
        if part then
            return part.Position
        end
    end

    local char = LocalPlayer.Character
    local hand = char and (
        char:FindFirstChild("RightHand")
        or char:FindFirstChild("Right Arm")
        or char:FindFirstChild("HumanoidRootPart")
    )
    if hand and hand:IsA("BasePart") then
        return hand.Position
    end

    return cam and cam.CFrame.Position or nil
end

local function KYS_UpdateFlashlightLaser(originPos, targetPos)
    if not KYS_FlashlightAimState.LaserBeam then
        local laser = Instance.new("Part")
        laser.Name = "FlashlightSilentAimLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.CanTouch = false
        laser.CastShadow = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(80, 220, 255)
        laser.Transparency = 0
        laser.Parent = workspace
        KYS_FlashlightAimState.LaserBeam = laser
    end

    local dist = (targetPos - originPos).Magnitude
    if dist < 0.1 then return end

    local laser = KYS_FlashlightAimState.LaserBeam
    laser.Size = Vector3.new(0.16, 0.16, dist)
    laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    laser.Transparency = 0
end

local function KYS_FlashlightAimStep()
    if false then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    if not (VD.FLASH_SilentAim and KYS_FlashlightAimState.Active) then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    local cam = workspace.CurrentCamera
    local targetPart = KYS_GetFlashlightTarget()
    if not (cam and targetPart) then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    local targetPos = targetPart.Position
    local smooth = math.clamp(tonumber(VD.FLASH_Smooth) or 0.35, 0.05, 1)
    local originPos = KYS_GetFlashlightOrigin(cam)

    if VD.FLASH_Laser and originPos then
        KYS_UpdateFlashlightLaser(originPos, targetPos)
    elseif KYS_FlashlightAimState.LaserBeam then
        KYS_FlashlightAimState.LaserBeam.Transparency = 1
    end

    pcall(function()
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), smooth)
    end)

    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        end
    end)
end

local function KYS_StartFlashlightSilentAim()
    getgenv().KYS_FlashlightActivateRemote = KYS_GetFlashlightActivateRemote()
    if KYS_FlashlightAimState.Connection then return end
    KYS_FlashlightAimState.Connection = RunService.RenderStepped:Connect(KYS_FlashlightAimStep)
end

local function KYS_StopFlashlightSilentAim()
    KYS_FlashlightAimState.Active = false
    KYS_FlashlightAimState.FlashlightPart = nil
    KYS_ClearFlashlightLaser()
    if KYS_FlashlightAimState.Connection then
        pcall(function() KYS_FlashlightAimState.Connection:Disconnect() end)
        KYS_FlashlightAimState.Connection = nil
    end
end

local function KYS_SetFlashlightSilentAim(enabled)
    if enabled and false then
        VD.FLASH_SilentAim = false
        KYS_StopFlashlightSilentAim()
        return
    end

    VD.FLASH_SilentAim = enabled and true or false
    if VD.FLASH_SilentAim then
        KYS_StartFlashlightSilentAim()
    else
        KYS_StopFlashlightSilentAim()
    end
end

getgenv().KYS_SetFlashlightSilentAim = KYS_SetFlashlightSilentAim
getgenv().KYS_ClearFlashlightLaser = KYS_ClearFlashlightLaser
getgenv().KYS_SetFlashlightAimActive = function(active, flashlightPart)
    KYS_FlashlightAimState.Active = active and true or false
    if KYS_FlashlightAimState.Active and flashlightPart then
        KYS_FlashlightAimState.FlashlightPart = flashlightPart
    elseif not KYS_FlashlightAimState.Active then
        KYS_FlashlightAimState.FlashlightPart = nil
    end
    if not KYS_FlashlightAimState.Active and KYS_FlashlightAimState.LaserBeam then
        KYS_FlashlightAimState.LaserBeam.Transparency = 1
    end
end
getgenv().KYS_FlashlightActivateRemote = KYS_GetFlashlightActivateRemote()
end)();

local VD_Parry = {
    PreciseDistanceEnabled = true,
    MaxDistance = 14,
    CanParry = true,
    IsParrying = false,
    CooldownEndTime = 0,
    KillerAnimator = nil,
    KillerChar = nil,
    KillerPlayer = nil,
    Connections = {},
    FiredTracks = {},
    RenderConnection = nil,
    LastStatus = "Off",
}

local VD_ParryAnimation = Instance.new("Animation")
VD_ParryAnimation.AnimationId = "rbxassetid://109133187196613"

local VD_ParryRange = Instance.new("CylinderHandleAdornment")
VD_ParryRange.Name = "KYS_ParryRange"
VD_ParryRange.Radius = VD.SURV_ParryDistance or 8
VD_ParryRange.InnerRadius = math.max(0.1, (VD.SURV_ParryDistance or 8) - 0.15)
VD_ParryRange.Height = 0.01
VD_ParryRange.Color3 = Color3.fromRGB(128, 128, 128)
VD_ParryRange.AlwaysOnTop = false
VD_ParryRange.Adornee = Workspace:FindFirstChildOfClass("Terrain")
VD_ParryRange.Transparency = 1
VD_ParryRange.Parent = GetSafeGuiParent()

local VD_ATTACK_ANIMS = {
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://138720291317243"] = true,
    ["rbxassetid://115244153053858"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
}

function VD_UpdateParryRange()
    if not VD.SURV_ShowParryCircle or not VD.SURV_AutoParry then
        VD_ParryRange.Transparency = 1
        return
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        VD_ParryRange.Transparency = 1
        return
    end

    local currentMaxDist = VD_Parry.PreciseDistanceEnabled and (VD.SURV_ParryDistance or 8) or VD_Parry.MaxDistance
    VD_ParryRange.Transparency = 0.4
    VD_ParryRange.Radius = currentMaxDist
    VD_ParryRange.InnerRadius = math.max(0.1, currentMaxDist - 0.15)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { char }
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ray = Workspace:Raycast(root.Position, Vector3.new(0, -15, 0), params)
    local groundPos = ray and ray.Position or (root.Position - Vector3.new(0, 3, 0))
    VD_ParryRange.CFrame = CFrame.new(groundPos + Vector3.new(0, 0.05, 0)) * CFrame.Angles(math.pi / 2, 0, 0)
end

function VD_GetParryRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local dagger = items and items:FindFirstChild("Parrying Dagger")
    return dagger and dagger:FindFirstChild("parry")
end

function VD_RefreshLocalCombatCache()
    local char = LocalPlayer.Character
    Root = char and char:FindFirstChild("HumanoidRootPart") or Root
    Humanoid = char and char:FindFirstChildOfClass("Humanoid") or Humanoid
end

local State = { ParryCooldown = false, ParryCooldownThread = nil }
local Attached = {}
function IsKiller(p) return p.Team and p.Team.Name == "Killer" end
function IsDowned(char) local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return true end; local state = char:GetAttribute("State"); return state == "Downed" or state == "Dead" end
function TriggerCrouch()
    local startT = tick()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        -- Toggle crouch ON: replicate mobile SurvivorAnimationsController logic
        pcall(function() char:SetAttribute("Crouching", true) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
        pcall(function() ReplicatedStorage.Remotes.Chase.Runevent:FireServer(char, false) end)
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Landed) end) end
        
        -- Also fire the mobile crouch button signal for visual sync
        pcall(function()
            local survMob = LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            if survMob then
                local controls = survMob:FindFirstChild("Controls")
                if controls then
                    local crouchBtn = controls:FindFirstChild("crouch")
                    if crouchBtn then
                        firesignal(crouchBtn.MouseButton1Click)
                    end
                end
            end
        end)
        
        while tick() - startT < 1.2 do
            pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
            task.wait(0.1)
        end
        
        -- Toggle crouch OFF
        pcall(function() char:SetAttribute("Crouching", false) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", false) end)
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Landed) end) end
        
        -- Fire crouch button again to toggle OFF visually
        pcall(function()
            local survMob = LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            if survMob then
                local controls = survMob:FindFirstChild("Controls")
                if controls then
                    local crouchBtn = controls:FindFirstChild("crouch")
                    if crouchBtn then
                        firesignal(crouchBtn.MouseButton1Click)
                    end
                end
            end
        end)
    end)
end
function IsSafeToParry(char) return not IsDowned(char) end
local player = LocalPlayer
-- ==================== AUTO PARRY SENSOR ====================
function tapMobileParryButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local survivorMob = playerGui:FindFirstChild("Survivor-mob")
    local parryBtn = survivorMob
        and survivorMob:FindFirstChild("Controls")
        and survivorMob.Controls:FindFirstChild("Gui-mob")

    if parryBtn and parryBtn.Visible then
        if firesignal then
            pcall(function()
                firesignal(parryBtn.MouseButton1Down)
                task.wait(0.01)
                firesignal(parryBtn.MouseButton1Up)
            end)
        end
    else
        pcall(function()
            if mouse2click then
                mouse2click()
                return
            end
            if mouse2press and mouse2release then
                mouse2press()
                task.wait(0.01)
                mouse2release()
                return
            end
            if MouseButton2Click then
                MouseButton2Click()
                return
            end
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

function ExecuteParry()
    if State.ParryCooldown then return end
    pcall(function()
        local parryRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Items"):FindFirstChild("Parrying Dagger"):FindFirstChild("parry")
        if parryRemote then
            for i = 1, 10 do parryRemote:FireServer() end
        end
        task.spawn(tapMobileParryButton)
    end)
end

function ListenToParryResult()
    task.spawn(function()
        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
        local dagger = remotes and remotes:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
        local parryResultRemote = dagger and dagger:WaitForChild("parryResult", 5)
        
        if parryResultRemote then
            parryResultRemote.OnClientEvent:Connect(function(arg1, arg2)
                local cdDur = tonumber(arg2) or ((arg1 == true) and 90 or 60)
                State.ParryCooldown = true
                if State.ParryCooldownThread then task.cancel(State.ParryCooldownThread) end
                State.ParryCooldownThread = task.delay(cdDur, function()
                    State.ParryCooldown = false
                end)
            end)
        end
    end)
end
ListenToParryResult()

function AttachParrySensor(kChar)
    if not kChar or Attached[kChar] then return end
    Attached[kChar] = true
    local humanoid = kChar:FindFirstChild("Humanoid")
    if not humanoid then
        humanoid = kChar:WaitForChild("Humanoid", 5)
        if not humanoid then return end
    end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 5)
        if not animator then return end
    end

    humanoid.ChildAdded:Connect(function(child)
        if child:IsA("Animator") then
            Attached[kChar] = nil
            AttachParrySensor(kChar)
        end
    end)

    kChar.AncestryChanged:Connect(function(_, parent)
        if not parent then
            Attached[kChar] = nil
        end
    end)

    animator.AnimationPlayed:Connect(function(track)
        local animId = track.Animation and track.Animation.AnimationId or ""
        local id = animId:match("%d+")
        
        -- Auto Crouch untuk Abyssal S1
        if id == "80411309607666" and VD.AutoCrouch then
            local myChar = LocalPlayer.Character
            if IsDowned(myChar) then return end
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local kHRP = kChar:FindFirstChild("HumanoidRootPart")
            if myHRP and kHRP then
                local dist = (myHRP.Position - kHRP.Position).Magnitude
                if dist <= 40 then
                    TriggerCrouch()
                end
            end
            return 
        end
        
        local attackName = VD_ATTACK_ANIMS[animId]
        if not attackName then return end
        
        if not VD.SURV_AutoParry then return end
        if State.ParryCooldown then return end 
        if VD.Ignored_Skills_List and VD.Ignored_Skills_List[attackName] then return end

        local myChar = LocalPlayer.Character
        if IsDowned(myChar) or not IsSafeToParry(myChar) then return end
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local kHRP = kChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not kHRP then return end
        
        local delta = myHRP.Position - kHRP.Position
        local startDistance = delta.Magnitude

        if VD.SURV_ParryAggressive then
            local aggressiveRadius = 12
            local detectionRadius = VD.SURV_ParryDistance + 5
            if startDistance > detectionRadius then return end
            if startDistance <= aggressiveRadius then
                ExecuteParry()
            else
                local tracker
                local startTime = os.clock()
                tracker = RunService.Heartbeat:Connect(function()
                    if os.clock() - startTime >= 1.5 or State.ParryCooldown or not myHRP or not kHRP or IsDowned(myChar) then
                        if tracker then tracker:Disconnect() end
                        return
                    end
                    local currentDist = (myHRP.Position - kHRP.Position).Magnitude
                    if currentDist <= aggressiveRadius then
                        ExecuteParry()
                        if tracker then tracker:Disconnect() end
                    end
                end)
            end
        else
            if startDistance > VD.SURV_ParryDistance then return end
            local myPosFlat = Vector3.new(myHRP.Position.X, 0, myHRP.Position.Z)
            local kPosFlat = Vector3.new(kHRP.Position.X, 0, kHRP.Position.Z)
            local flatDelta = myPosFlat - kPosFlat
            if flatDelta.Magnitude > 0 then
                local flatDirection = flatDelta.Unit
                local kLookFlat = Vector3.new(kHRP.CFrame.LookVector.X, 0, kHRP.CFrame.LookVector.Z).Unit
                local isFacing = kLookFlat:Dot(flatDirection)
                if isFacing < 0.6 then return end
            end
            ExecuteParry()
        end
    end)
end

function TryAttach(p)
    if p ~= player and IsKiller(p) and p.Character then 
        AttachParrySensor(p.Character) 
    end
end

function SetupPlayer(p)
    if p == player then return end
    p.CharacterAdded:Connect(function() TryAttach(p) end)
    p:GetPropertyChangedSignal("Team"):Connect(function() TryAttach(p) end)
    if p.Character then TryAttach(p) end
end

-- Setup Parry Sensor
for _, p in pairs(Players:GetPlayers()) do 
    SetupPlayer(p) 
end
Players.PlayerAdded:Connect(SetupPlayer)

task.spawn(function()
    while true do 
        task.wait(5) 
        for _, p in pairs(Players:GetPlayers()) do 
            TryAttach(p) 
        end 
    end
end)


function VD_SetAutoParry(state)
    VD.SURV_AutoParry = state == true
    if VD.SURV_AutoParry then
        if not _G.VD_ParryRenderConnection then
            _G.VD_ParryRenderConnection = game:GetService('RunService').RenderStepped:Connect(function()
                if type(VD_UpdateParryRange) == 'function' then VD_UpdateParryRange() end
            end)
        end
    else
        if typeof(VD_ParryRange) == 'Instance' then VD_ParryRange.Transparency = 1 end
        if _G.VD_ParryRenderConnection then
            _G.VD_ParryRenderConnection:Disconnect()
            _G.VD_ParryRenderConnection = nil
        end
    end
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AutoSkill = {
    LastGoalRotation = nil,
    HasClickedThisGoal = false,
    LastLineRotation = nil,
    LastTick = nil,
    WasActive = false,
    PerfectLastGoalRotation = nil,
    PerfectHasClickedThisGoal = false,
    PerfectLastLineRotation = nil,
    PerfectLastTick = nil,
    PerfectWasActive = false,
    InstantLastTriggerTick = 0,
    InstantLastGoalRotation = 0,
    InstantLastGoalInstance = nil,
    InstantCurrentGoalID = 0,
    InstantHasClicked = false,
    InstantForcingRotation = false,
    InstantRotationConnection = nil,
}

function VD_PressSkill()
    if isMobile then
        local btn = PlayerGui:FindFirstChild("check", true)
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + (size.X / 2) + inset.X
            local y = pos.Y + (size.Y / 2) + inset.Y
            pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.Begin.Value, x, y) end)
            task.wait(0.01)
            pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.End.Value, x, y) end)
            pcall(function()
                if firesignal and btn.MouseButton1Click then
                    firesignal(btn.MouseButton1Click)
                end
            end)
        end
    else
        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end

function VD_GetSkillCheck()
    for _, guiName in ipairs({ "SkillCheckPromptGui", "SkillCheckPromptGui-con" }) do
        local gui = PlayerGui:FindFirstChild(guiName, true)
        if gui then
            local check = gui:FindFirstChild("Check", true)
            if check and check.Visible then
                local line = check:FindFirstChild("Line", true)
                local goal = check:FindFirstChild("Goal", true)
                if line and goal then return line, goal end
            end
        end
    end
end

function VD_AngularDelta(from, to)
    local d = to - from
    if d > 180 then d = d - 360 end
    if d < -180 then d = d + 360 end
    return d
end

function VD_CrossedZone(prevLr, lr, startPos, endPos)
    local function inZone(r)
        if startPos > endPos then
            return r >= startPos or r <= endPos
        end
        return r >= startPos and r <= endPos
    end
    if inZone(lr) then return true end
    if prevLr == nil then return false end
    local delta = VD_AngularDelta(prevLr, lr)
    local steps = math.abs(math.floor(delta))
    if steps < 2 then return false end
    local stepSize = delta / steps
    for i = 1, steps do
        if inZone((prevLr + stepSize * i) % 360) then return true end
    end
    return false
end

function VD_NormalSkillcheckUpdate()
    local line, goal = VD_GetSkillCheck()
    if not (line and goal) then
        AutoSkill.LastGoalRotation = nil
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
        AutoSkill.WasActive = false
        return
    end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    local now = os.clock()
    if not AutoSkill.WasActive then
        AutoSkill.WasActive = true
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastGoalRotation = gr
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
        return
    end
    if AutoSkill.LastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.LastGoalRotation, gr)) > 5 then
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
    end
    AutoSkill.LastGoalRotation = gr
    if AutoSkill.HasClickedThisGoal then
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
        return
    end
    if AutoSkill.LastLineRotation and AutoSkill.LastTick then
        local dt = now - AutoSkill.LastTick
        if dt > 0 then
            local lineSpeed = VD_AngularDelta(AutoSkill.LastLineRotation, lr) / dt
            local predicted = (lr + lineSpeed * dt * 0) % 360
            if VD_CrossedZone(AutoSkill.LastLineRotation, predicted, (gr + 104) % 360, (gr + 109) % 360) then
                AutoSkill.HasClickedThisGoal = true
                task.spawn(function()
                    task.wait(0.03)
                    VD_PressSkill()
                end)
            end
        end
    end
    AutoSkill.LastLineRotation = lr
    AutoSkill.LastTick = now
end

function VD_PerfectSkillcheckUpdate()
    local line, goal = VD_GetSkillCheck()
    if not (line and goal) then
        AutoSkill.PerfectLastGoalRotation = nil
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
        AutoSkill.PerfectWasActive = false
        return
    end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    local now = os.clock()
    if not AutoSkill.PerfectWasActive then
        AutoSkill.PerfectWasActive = true
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastGoalRotation = gr
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
        return
    end
    if AutoSkill.PerfectLastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.PerfectLastGoalRotation, gr)) > 5 then
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
    end
    AutoSkill.PerfectLastGoalRotation = gr
    if AutoSkill.PerfectHasClickedThisGoal then
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
        return
    end
    if AutoSkill.PerfectLastLineRotation and AutoSkill.PerfectLastTick then
        local dt = now - AutoSkill.PerfectLastTick
        if dt > 0 then
            local lineSpeed = VD_AngularDelta(AutoSkill.PerfectLastLineRotation, lr) / dt
            local predicted = (lr + lineSpeed * dt * 0) % 360
            if VD_CrossedZone(AutoSkill.PerfectLastLineRotation, predicted, (gr + 104) % 360, (gr + 108) % 360) then
                AutoSkill.PerfectHasClickedThisGoal = true
                VD_PressSkill()
            end
        end
    end
    AutoSkill.PerfectLastLineRotation = lr
    AutoSkill.PerfectLastTick = now
end

function VD_InstantSkillcheckUpdate()
    if AutoSkill.InstantHasClicked then return end

    -- Exact Fallens.lua logic: non-recursive FindFirstChild
    local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
    if not prompt then
        prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui-con")
    end
    if not prompt then return end

    local check = prompt:FindFirstChild("Check")
    if not check or not check.Visible then return end

    local line = check:FindFirstChild("Line")
    local goal = check:FindFirstChild("Goal")
    if not line or not goal then return end

    -- Exact Fallens.lua logic: raw rotation WITHOUT modulo
    line.Rotation = goal.Rotation + 109

    AutoSkill.InstantHasClicked = true
    task.spawn(function()
        VD_PressSkill()
        task.wait(0.2)
        AutoSkill.InstantHasClicked = false
    end)
end

RunService.RenderStepped:Connect(function()
    if not VD.AutoSkillcheck then return end
    if VD.AutoSkillcheckMode == "Perfect" then
        VD_PerfectSkillcheckUpdate()
    elseif VD.AutoSkillcheckMode == "Instant" then
        VD_InstantSkillcheckUpdate()
    else
        VD_NormalSkillcheckUpdate()
    end
end)

function VD_SetAutoSkillcheck(state)
    VD.AutoSkillcheck = state == true
    if not VD.AutoSkillcheck then
        if AutoSkill.InstantRotationConnection then
            AutoSkill.InstantRotationConnection:Disconnect()
            AutoSkill.InstantRotationConnection = nil
        end
        AutoSkill.InstantHasClicked = false
        AutoSkill.WasActive = false
        AutoSkill.PerfectWasActive = false
        VD_Notify("Auto Skillcheck", "Disabled", 2)
    else
        VD_Notify("Auto Skillcheck", "Enabled (" .. tostring(VD.AutoSkillcheckMode or "Normal") .. " Mode)", 2)
    end
end

-- =====================================================
-- INSTANT HEAL & AUTO HEAL ALL
-- =====================================================
InstantHealSelf = false
AutoHealAll = false
AutoSelfUnhook = false
AutoHealAllConnection = nil
InstantHealConnection = nil
AutoSelfUnhookConnection = nil

function doSelfHeal()
	local char = LocalPlayer.Character
	if not char then return end
	local skillCheckRemote = ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent
	pcall(function() skillCheckRemote:FireServer("success", 100, char) end)
end

function doSelfHealTrue()
	local char = LocalPlayer.Character
	if not char then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() healRemote:FireServer(hrp, true) end)
end

function doSelfHealFalse()
	local char = LocalPlayer.Character
	if not char then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() healRemote:FireServer(hrp, false) end)
end

function doOthersHealSkillCheck(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local skillCheckRemote = ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent
	pcall(function() skillCheckRemote:FireServer("success", 100, targetPlayer.Character) end)
end

function doOthersHealTrue(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	pcall(function() healRemote:FireServer(targetHRP, true) end)
end

function doOthersHealFalse(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	pcall(function() healRemote:FireServer(targetHRP, false) end)
end

function setInstantHealSelf(v)
    InstantHealSelf = v
    if v then
        local healActive = false
        if InstantHealConnection then InstantHealConnection:Disconnect() end
        InstantHealConnection = RunService.Heartbeat:Connect(function(dt)
            if not InstantHealSelf then return end
            local myChar = LocalPlayer.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHum then return end
            
            if myHum.Health >= myHum.MaxHealth * 0.9 then 
                -- Auto stop heal when HP is full
                if healActive then
                    healActive = false
                    doSelfHealFalse()
                end
                return 
            end
            
            -- Check if game cancelled our heal (e.g. player moved)
            if healActive then
                local checkScript = myChar:FindFirstChild("CheckInterractable")
                if checkScript and not checkScript:GetAttribute("isHealing") then
                    -- Game cancelled our heal, reset so we can restart
                    healActive = false
                end
            end
            
            -- Start heal (or restart after being cancelled)
            if not healActive then
                healActive = true
                doSelfHealTrue()
            end
        end)
    else
        if InstantHealConnection then InstantHealConnection:Disconnect(); InstantHealConnection = nil end
        -- Send stop heal just in case
        pcall(doSelfHealFalse)
    end
end

function setAutoHealAll(v)
    AutoHealAll = v
    if v then
        local activeHeals = {} -- [player] = true if we're currently healing them
        if AutoHealAllConnection then AutoHealAllConnection:Disconnect() end
        AutoHealAllConnection = RunService.Heartbeat:Connect(function(dt)
            if not AutoHealAll then return end
            for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					local hum = player.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 and hum.Health < hum.MaxHealth * 0.9 and hrp then
						-- Check if game cancelled our heal on this player (e.g. we or they moved)
						if activeHeals[player] then
							local myChar = LocalPlayer.Character
							local checkScript = myChar and myChar:FindFirstChild("CheckInterractable")
							if checkScript and not checkScript:GetAttribute("isHealing") then
								activeHeals[player] = nil
							end
						end
						-- Start healing this player if not already
						if not activeHeals[player] then
							activeHeals[player] = true
							doOthersHealTrue(player)
						end
					else
						-- Stop healing if HP is full or dead
						if activeHeals[player] then
							activeHeals[player] = nil
							doOthersHealFalse(player)
						end
					end
				else
					-- Player left or no character
					if activeHeals[player] then
						activeHeals[player] = nil
						pcall(function() doOthersHealFalse(player) end)
					end
				end
			end
        end)
    else
        if AutoHealAllConnection then AutoHealAllConnection:Disconnect(); AutoHealAllConnection = nil end
    end
end





-- =====================================================
-- GEN BOOST BYPASS
-- =====================================================
GenBypass = {
    Enabled     = false,
    Button      = nil,
    UI          = nil,
    Cache       = {},
    CacheTimer  = 0,
    Processed   = {},
    HotkeyCode  = Enum.KeyCode.G,
}

function GB_GetAllGenerators()
    local now = tick()
    if now - GenBypass.CacheTimer < 5 then return GenBypass.Cache end
    GenBypass.Cache = {}
    GenBypass.CacheTimer = now
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return GenBypass.Cache end
    pcall(function()
        for _, v in pairs(mapFolder:GetDescendants()) do
            if not v:IsA("Model") then continue end
            if v.Name ~= "Generator" then continue end
            local isReal = v:GetAttribute("RepairProgress") ~= nil
                or v:GetAttribute("kickcount") ~= nil
                or v:GetAttribute("ProgressRepair") ~= nil
            if isReal then table.insert(GenBypass.Cache, v) end
        end
    end)
    return GenBypass.Cache
end

function GB_GetPoints(genModel)
    local points = {}
    pcall(function()
        for _, obj in pairs(genModel:GetChildren()) do
            if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
                table.insert(points, obj)
            end
        end
    end)
    return points
end

function GB_WaitRepairing(point, timeout)
    local start = tick()
    while tick() - start < (timeout or 1) do
        if point:GetAttribute("IsRepairing") == true then return true end
        task.wait(0.05)
    end
    return false
end

function GB_DoRepair(targetPoint)
    local genModel = targetPoint.Parent
    if GenBypass.Processed[genModel] then return end
    GenBypass.Processed[genModel] = true

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then GenBypass.Processed[genModel] = nil return end

    local RepairEvent = ReplicatedStorage:FindFirstChild("Remotes")
        and ReplicatedStorage.Remotes:FindFirstChild("Generator")
        and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")

    local originalCFrame = hrp.CFrame
    pcall(function()
        for _, point in pairs(GB_GetPoints(genModel)) do
            if point ~= targetPoint and point.Parent then
                hrp.Anchored = true
                hrp.CFrame = point.CFrame
                task.wait(0.15)
                pcall(function() if RepairEvent then RepairEvent:FireServer(point, true) end end)
                if not GB_WaitRepairing(point, 0.8) then
                    pcall(function() if RepairEvent then RepairEvent:FireServer(point, false) end end)
                    task.wait(0.1)
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)
                    pcall(function() if RepairEvent then RepairEvent:FireServer(point, true) end end)
                    GB_WaitRepairing(point, 0.5)
                end
                hrp.Anchored = false
                task.wait(0.05)
            end
        end
    end)
    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.CFrame = originalCFrame
        end
    end)
    task.wait(0.1)
    pcall(function() if RepairEvent then RepairEvent:FireServer(targetPoint, false) end end)
end

function GB_GetNearestPoint()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bestPoint, bestDist = nil, math.huge
    for _, gen in pairs(GB_GetAllGenerators()) do
        for _, point in pairs(GB_GetPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then bestDist = d; bestPoint = point end
        end
    end
    return bestPoint, bestDist
end

function GB_IsPromptVisible()
    local ok, frame = pcall(function()
        return LocalPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
    end)
    return ok and frame and frame.Visible
end

function GB_UpdateButton()
    if GenBypass.Button then
        GenBypass.Button.Visible = GenBypass.Enabled and isMobile
    end
end

function GB_CreateButton()
    local oldUI = LocalPlayer.PlayerGui:FindFirstChild("BypassGenUI")
    if oldUI then oldUI:Destroy() end

    GenBypass.UI = Instance.new("ScreenGui")
    GenBypass.UI.Name = "BypassGenUI"
    GenBypass.UI.ResetOnSpawn = false
    GenBypass.UI.IgnoreGuiInset = true
    GenBypass.UI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    GenBypass.Button = Instance.new("ImageButton")
    GenBypass.Button.Name = "BypassGenButton"
    GenBypass.Button.Size = UDim2.new(0, 60, 0, 60)
    GenBypass.Button.Position = UDim2.new(0.88, 0, 0.55, 0)
    GenBypass.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    GenBypass.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GenBypass.Button.BackgroundTransparency = 0.15
    GenBypass.Button.AutoButtonColor = true
    GenBypass.Button.Visible = false
    GenBypass.Button.ZIndex = 10
    GenBypass.Button.Parent = GenBypass.UI
    Instance.new("UICorner", GenBypass.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", GenBypass.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", GenBypass.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "BYPASS"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)
        
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end
    
    applyShine(GenBypass.Button, Color3.fromRGB(20, 0, 30))
    applyShine(lbl, Color3.fromRGB(255, 0, 255))
    applyShine(s, Color3.fromRGB(255, 0, 255))

    GenBypass.Button.MouseButton1Click:Connect(function()
        if not GenBypass.Enabled then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if bestPoint and bestDist <= 8 then GB_DoRepair(bestPoint) end
    end)
end

GB_CreateButton()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    GB_CreateButton()
    GB_UpdateButton()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if isMobile then return end
    if input.KeyCode == GenBypass.HotkeyCode and GenBypass.Enabled then
        if not GB_IsPromptVisible() then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if not bestPoint or bestDist > 8 then return end
        if GenBypass.Processed[bestPoint.Parent] then return end
        GB_DoRepair(bestPoint)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not GenBypass.Enabled then return end
    if not GB_IsPromptVisible() then return end
    local bestPoint, bestDist = GB_GetNearestPoint()
    if not bestPoint or bestDist > 8 then return end
    if GenBypass.Processed[bestPoint.Parent] then return end
    GB_DoRepair(bestPoint)
end)

task.spawn(function()
    while true do
        task.wait(2)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for genModel in pairs(GenBypass.Processed) do
                if not genModel or not genModel.Parent then
                    GenBypass.Processed[genModel] = nil
                    continue
                end
                local nearAny = false
                for _, point in pairs(GB_GetPoints(genModel)) do
                    if point.Parent and (hrp.Position - point.Position).Magnitude <= 10 then
                        nearAny = true; break
                    end
                end
                if not nearAny then GenBypass.Processed[genModel] = nil end
            end
        end
    end
end)

function setGenBypass(v)
    GenBypass.Enabled = v
    GB_UpdateButton()
end

function setAutoCrouch(v) VD.AutoCrouch = v end

-- =====================================================
-- INF GRAB (MYERS)
-- =====================================================
MyersGrabData = {
    Enabled = false,
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil,
    HotkeyCode = Enum.KeyCode.H,
}

function getMyersTarget()
    local char = LocalPlayer.Character
    if not char then return nil end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local candidates = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                table.insert(candidates, {
                    player = player,
                    dist   = (hrp.Position - myHRP.Position).Magnitude,
                    health = hum.Health
                })
            end
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    for _, c in ipairs(candidates) do
        return c.player
    end
    return nil
end

function doMyersGrab()
    if not MyersGrabData.Enabled then return end
    local target = getMyersTarget()
    if not target or not target.Character then return end
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        ReplicatedStorage.Remotes.Killers.Stalker.grab:FireServer(target.Character)
    end)
end

function setupMyersGrabBtn()
    local oldUI = LocalPlayer.PlayerGui:FindFirstChild("MyersGrabUI")
    if oldUI then oldUI:Destroy() end

    MyersGrabData.UI = Instance.new("ScreenGui")
    MyersGrabData.UI.Name = "MyersGrabUI"
    MyersGrabData.UI.ResetOnSpawn = false
    MyersGrabData.UI.IgnoreGuiInset = true
    MyersGrabData.UI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MyersGrabData.Button = Instance.new("ImageButton")
    MyersGrabData.Button.Name = "MyersGrabButton"
    MyersGrabData.Button.Size = UDim2.new(0, 60, 0, 60)
    MyersGrabData.Button.Position = UDim2.new(0.7, 0, 0.75, 0)
    MyersGrabData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    MyersGrabData.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MyersGrabData.Button.BackgroundTransparency = 0.15
    MyersGrabData.Button.AutoButtonColor = true
    MyersGrabData.Button.Visible = false
    MyersGrabData.Button.ZIndex = 10
    MyersGrabData.Button.Parent = MyersGrabData.UI
    Instance.new("UICorner", MyersGrabData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", MyersGrabData.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", MyersGrabData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "GRAB"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)
        
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end
    
    applyShine(MyersGrabData.Button, Color3.fromRGB(20, 0, 30))
    applyShine(lbl, Color3.fromRGB(255, 0, 255))
    applyShine(s, Color3.fromRGB(255, 0, 255))

    MyersGrabData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if MyersGrabData.DragLocked then return end
            MyersGrabData.Dragging = true
            MyersGrabData.DragStart = input.Position
            MyersGrabData.DragStartPos = MyersGrabData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if MyersGrabData.Dragging and not MyersGrabData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - MyersGrabData.DragStart
            MyersGrabData.Button.Position = UDim2.new(
                MyersGrabData.DragStartPos.X.Scale, MyersGrabData.DragStartPos.X.Offset + delta.X, 
                MyersGrabData.DragStartPos.Y.Scale, MyersGrabData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    MyersGrabData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MyersGrabData.Dragging = false
        end
    end)

    MyersGrabData.Button.MouseButton1Click:Connect(doMyersGrab)
end

setupMyersGrabBtn()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    setupMyersGrabBtn()
    if MyersGrabData.Button then
        MyersGrabData.Button.Visible = MyersGrabData.Enabled
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == MyersGrabData.HotkeyCode and MyersGrabData.Enabled then
        doMyersGrab()
    end
end)

function setMyersGrab(v)
    MyersGrabData.Enabled = v
    if MyersGrabData.Button then
        MyersGrabData.Button.Visible = v
    end
end

function setMyersDragLocked(v)
    MyersGrabData.DragLocked = v
end

-- =====================================================
-- VEIL AIMBOT (PREDICTION)
-- =====================================================
VeilConfig = {
    Enabled              = false,
    ShowFOV              = true,
    ShowTargetLaser      = true,
    FOV                  = 150,
    SpearSpeed           = 165,
    Gravity              = workspace.Gravity * 0.5,
    MaxDist              = 200,
    AutoPredict          = false,
    TargetPart           = "Torso",
    HorizontalPredictFactor = 1.0,
}

VeilState = {
    chargingSpear    = false,
    touchInput       = nil,
    attackCooldown   = false,
    passiveCooldown  = false,
    remoteHooked     = false,
    lastPredictedPos = nil,
}

VeilVelocityCache = {}

VeilDraw = {
    FOVCircle = Drawing.new("Circle"),
    Highlight = Instance.new("Highlight"),
    Tracer    = Drawing.new("Circle"),
}

VeilDraw.FOVCircle.Color     = Color3.fromRGB(255, 0, 255)
VeilDraw.FOVCircle.Thickness = 1.5
VeilDraw.FOVCircle.Filled    = false
VeilDraw.FOVCircle.Visible   = false

VeilDraw.Highlight.Name                = "VD_VeilTarget"
VeilDraw.Highlight.FillColor           = Color3.fromRGB(255, 0, 0)
VeilDraw.Highlight.OutlineColor        = Color3.fromRGB(255, 255, 255)
VeilDraw.Highlight.FillTransparency    = 0.5
VeilDraw.Highlight.OutlineTransparency = 0

VeilDraw.Tracer.Thickness = 2
VeilDraw.Tracer.Radius    = 5
VeilDraw.Tracer.Color     = Color3.fromRGB(255, 0, 255)
VeilDraw.Tracer.Filled    = true
VeilDraw.Tracer.Visible   = false

function Veil_GetRealVelocity(part, playerName)
    if not part then return Vector3.zero end
    local currentPos = part.Position
    local currentTime = tick()
    if not VeilVelocityCache[playerName] then
        VeilVelocityCache[playerName] = {lastPos = currentPos, lastTime = currentTime, velocity = Vector3.zero}
        return Vector3.zero
    end
    local cache = VeilVelocityCache[playerName]
    local dt = currentTime - cache.lastTime
    if dt > 0.01 then
        local rawVelocity = (currentPos - cache.lastPos) / dt
        if rawVelocity.Magnitude < 100 then
            cache.velocity = cache.velocity:Lerp(rawVelocity, 0.4)
        end
    end
    cache.lastPos = currentPos
    cache.lastTime = currentTime
    return cache.velocity
end

function veil_getTargetPart(char)
    if VeilConfig.TargetPart == "Head" then
        return char:FindFirstChild("Head")
    elseif VeilConfig.TargetPart == "Root" then
        return char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("HumanoidRootPart")
    end
end

function veil_getClosestSurvivor()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local cam      = workspace.CurrentCamera
    local center   = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local bestDist = VeilConfig.FOV
    local bestTarget = nil

    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local char = p.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local part = veil_getTargetPart(char)
            if hum and hum.Health > 0 and part then
                local dist3D = (part.Position - myRoot.Position).Magnitude
                if dist3D <= VeilConfig.MaxDist then
                    local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist2D < bestDist then
                            bestDist   = dist2D
                            bestTarget = { Player = p, Part = part }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

function veil_setupInterceptor()
    if VeilState.remoteHooked then return end
    task.spawn(function()
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                if not checkcaller() then
                    if string.lower(method) == "kick" then
                        return nil
                    end

                    if method == "GetAttribute" then
                        if args[1] == "LakeMist" and VD.KILLER_InfLakeMist then
                            local caller = getcallingscript()
                            if caller and caller.Name == "AwardLog" then return 0 end
                            return false
                        end
                        if args[1] == "Pursuit" and VD.KILLER_InfPursuit then
                            local caller = getcallingscript()
                            if caller and caller.Name == "AwardLog" then return 0 end
                            return false
                        end
                    end

                    if method == "GetAttributes" then
                        if VD.KILLER_InfLakeMist or VD.KILLER_InfPursuit then
                            local attrs = oldNamecall(self, ...)
                            if type(attrs) == "table" then
                                local caller = getcallingscript()
                                if caller and caller.Name == "AwardLog" then
                                    if VD.KILLER_InfLakeMist then attrs.LakeMist = 0 end
                                    if VD.KILLER_InfPursuit then attrs.Pursuit = 0 end
                                else
                                    if VD.KILLER_InfLakeMist then attrs.LakeMist = false end
                                    if VD.KILLER_InfPursuit then attrs.Pursuit = false end
                                end
                                return attrs
                            end
                        end
                    end

                    if method == "FireServer" then
                        if self.Name == "Spearthrow" and VeilConfig.Enabled then
                            return nil
                        end

                        if VD.KILLER_InfLakeMist and self.Name == "LakeMist" then
                            local a1 = args[1]
                            if a1 == false then
                                return nil
                            elseif a1 == true then
                                task.delay(0.2, function()
                                    pcall(function()
                                        local c = game:GetService("Players").LocalPlayer.Character
                                        if c and c:GetAttribute("action") == true then
                                            c:SetAttribute("action", false)
                                        end
                                    end)
                                end)
                            end
                        end

                        if VD.KILLER_InfPursuit and self.Name == "Pursuit" then
                            local a1 = args[1]
                            if a1 == false then
                                return nil
                            elseif a1 == true then
                                task.delay(0.2, function()
                                    pcall(function()
                                        local c = game:GetService("Players").LocalPlayer.Character
                                        if c and c:GetAttribute("action") == true then
                                            c:SetAttribute("action", false)
                                        end
                                    end)
                                end)
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
            VeilState.remoteHooked = true
        end)
    end)
end
veil_setupInterceptor()

function veil_fire()
    if VeilState.attackCooldown then return end
    VeilState.attackCooldown = true
    task.delay(2, function() VeilState.attackCooldown = false end)

    local myChar    = LocalPlayer.Character
    local startPart = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
    if not startPart then return end

    local startPos   = startPart.Position
    local targetInfo = veil_getClosestSurvivor()
    local aimDir

    if targetInfo and targetInfo.Part then
        local targetPart = targetInfo.Part
        local targetPlayer = targetInfo.Player
        local targetPos = targetPart.Position

        local velocity = Veil_GetRealVelocity(targetPart, targetPlayer.Name)
        local horizontalVel = Vector3.new(velocity.X, 0, velocity.Z)
        local speed = horizontalVel.Magnitude

        local distance = (targetPos - startPos).Magnitude
        local timeToHit = distance / VeilConfig.SpearSpeed

        local horizontalPrediction = Vector3.zero
        if speed > 4 and VeilConfig.AutoPredict then
            local factor = VeilConfig.HorizontalPredictFactor
            horizontalPrediction = horizontalVel * timeToHit * factor
        end
        local predictedPos = targetPos + horizontalPrediction

        local autoGravity = math.max(0, distance - 8)
        local gravity = VeilConfig.AutoPredict and autoGravity or VeilConfig.Gravity
        local drop = 0.5 * gravity * (timeToHit ^ 2)
        local finalPos = predictedPos + Vector3.new(0, drop, 0)

        aimDir = (finalPos - startPos).Unit
        VeilState.lastPredictedPos = finalPos
    else
        aimDir = workspace.CurrentCamera.CFrame.LookVector
        VeilState.lastPredictedPos = nil
    end

    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remotes then
            local killers = remotes:FindFirstChild("Killers")
            if killers then
                local veil = killers:FindFirstChild("Veil")
                if veil and veil:FindFirstChild("Spearthrow") then
                    veil.Spearthrow:FireServer(aimDir, VeilConfig.SpearSpeed, startPos)
                end
            end
        end
    end)

    VeilDraw.FOVCircle.Color = Color3.fromRGB(255, 0, 255)
    if not VeilState.passiveCooldown then
        VeilState.passiveCooldown = true
        task.delay(30, function()
            VeilDraw.FOVCircle.Color = Color3.fromRGB(255, 0, 255)
            VeilState.passiveCooldown = false
        end)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    if gp and not isTouch then return end
    local char = LocalPlayer.Character
    local isSpearMode = char and char:GetAttribute("spearmode") == true
    if not VeilConfig.Enabled then return end
    if not isSpearMode then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        VeilState.chargingSpear = true
    elseif isTouch then
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local slasher = pGui:FindFirstChild("Slasher-mob")
            if slasher then
                local ctrl = slasher:FindFirstChild("Controls")
                if ctrl then
                    local attackBtn = ctrl:FindFirstChild("attack")
                    if attackBtn and attackBtn.Visible then
                        local pos     = input.Position
                        local absPos  = attackBtn.AbsolutePosition
                        local absSize = attackBtn.AbsoluteSize
                        if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
                        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
                            VeilState.chargingSpear = true
                            VeilState.touchInput    = input
                        end
                    end
                end
            end
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gp)
    if VeilState.chargingSpear
    and (input == VeilState.touchInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
        VeilState.chargingSpear = false
        if VeilState.touchInput == input then VeilState.touchInput = nil end
        veil_fire()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local cam         = workspace.CurrentCamera
    local myChar      = LocalPlayer.Character
    local isSpearMode = myChar and myChar:GetAttribute("spearmode") == true

    if VeilConfig.Enabled and VeilConfig.ShowFOV and isSpearMode then
        VeilDraw.FOVCircle.Visible  = true
        VeilDraw.FOVCircle.Radius   = VeilConfig.FOV
        VeilDraw.FOVCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    else
        VeilDraw.FOVCircle.Visible = false
    end

    if VeilState.chargingSpear and VeilConfig.Enabled and isSpearMode then
        local target = veil_getClosestSurvivor()
        if target and target.Part and target.Part.Parent then
            VeilDraw.Highlight.Parent = target.Part.Parent
            
            if VeilConfig.ShowTargetLaser then
                if not getgenv().KYS_SpearLaserPart then
                    local laser = Instance.new("Part")
                    laser.Name = "SpearSilentAimLaser"
                    laser.Anchored = true
                    laser.CanCollide = false
                    laser.CanTouch = false
                    laser.CastShadow = false
                    laser.Material = Enum.Material.Neon
                    laser.Color = Color3.fromRGB(255, 50, 50)
                    laser.Transparency = 0
                    laser.Parent = workspace
                    getgenv().KYS_SpearLaserPart = laser
                end
                
                local originPart = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
                if originPart then
                    local originPos = originPart.Position
                    local targetPos = target.Part.Position
                    local dist = (targetPos - originPos).Magnitude
                    if dist > 0.1 then
                        local laser = getgenv().KYS_SpearLaserPart
                        laser.Size = Vector3.new(0.16, 0.16, dist)
                        laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
                        laser.Transparency = 0.5
                    end
                end
            else
                if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
            end
        else
            VeilDraw.Highlight.Parent = nil
            if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
        end
    else
        VeilDraw.Highlight.Parent = nil
        if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
    end

    if VeilConfig.Enabled and isSpearMode and VeilState.lastPredictedPos then
        local screenPos, onScreen = cam:WorldToViewportPoint(VeilState.lastPredictedPos)
        local viewport = cam.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

        if onScreen then
            VeilDraw.Tracer.Position = Vector2.new(screenPos.X, screenPos.Y)
        else
            local dx = screenPos.X - center.X
            local dy = screenPos.Y - center.Y
            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                VeilDraw.Tracer.Position = center
            else
                local angle = math.atan2(dy, dx)
                local maxX = viewport.X / 2 - 10
                local maxY = viewport.Y / 2 - 10
                local scaleX = maxX / math.abs(dx)
                local scaleY = maxY / math.abs(dy)
                local scale = math.min(scaleX, scaleY)
                local borderPos = Vector2.new(
                    center.X + dx * scale,
                    center.Y + dy * scale
                )
                VeilDraw.Tracer.Position = borderPos
            end
        end
        VeilDraw.Tracer.Visible = true
    else
        VeilDraw.Tracer.Visible = false
    end
end)

-- =====================================================
-- UI TABS
-- =====================================================
local Main, ESPTab, MapTab, FOVTab
local SurvivorTab, KillerTab, GeneratorTab, FlingTab, SettingsTab, ResetTab
local VisualTab, MainTab, AimTab, MappingTab, PlayerTab
local VisualFeatureTabs, MainFeatureTabs, MainKillerFeatureTabs, AimFeatureTabs, MappingFeatureTabs, PlayerFeatureTabs, PlayerMiscFeatureTabs
local KYS_MainInfoPanel = {
    Widgets = {},
    Texts = {},
}

function KYS_InfoPlainText(text)
    text = tostring(text or "")
    text = text:gsub("<br%s*/?>", "\n")
    text = text:gsub("<[^>]->", "")
    text = text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&")
    return text
end

function KYS_UpdateInfoWidget(widget, text)
    if not widget then return end
    local title, content = tostring(text or ""):match("^(.-)\n(.*)$")
    title = title or tostring(text or "")
    content = content or ""
    pcall(function()
        if type(widget.Set) == "function" then
            pcall(function() widget:Set({ Name = title, Title = title, Content = content, Description = content, Text = content }) end)
            widget:Set(text)
        elseif type(widget.SetText) == "function" then
            widget:SetText(text)
        elseif type(widget.SetContent) == "function" then
            widget:SetContent(content)
        elseif type(widget.SetDescription) == "function" then
            widget:SetDescription(content)
        elseif type(widget.Update) == "function" then
            pcall(function() widget:Update({ Name = title, Title = title, Content = content, Description = content, Text = content }) end)
            widget:Update(text)
        elseif type(widget.SetValue) == "function" then
            widget:SetValue(text)
        end
    end)
    pcall(function()
        if widget.Text ~= nil then widget.Text = text end
        if widget.Name ~= nil and type(widget.Name) == "string" then widget.Name = title end
        if widget.TextLabel then widget.TextLabel.Text = content ~= "" and content or text end
        if widget.Label then widget.Label.Text = text end
        if widget.Title then widget.Title.Text = title end
        if widget.Content then widget.Content.Text = content ~= "" and content or text end
        if widget.Description then widget.Description.Text = content end
    end)
end

function KYS_SetMainInfoPanelText(key, title, text)
    local value = tostring(title or key) .. "\n" .. KYS_InfoPlainText(text)
    KYS_MainInfoPanel.Texts[key] = value
    KYS_UpdateInfoWidget(KYS_MainInfoPanel.Widgets[key], value)
end

function KYS_RegisterMainInfoWidget(key, widget)
    KYS_MainInfoPanel.Widgets[key] = widget
    if KYS_MainInfoPanel.Texts[key] then
        KYS_UpdateInfoWidget(widget, KYS_MainInfoPanel.Texts[key])
    end
end

function KYS_AddMainInfoLine(section, key, title, defaultText)
    local defaultValue = tostring(title) .. "\n" .. tostring(defaultText or "Off")
    KYS_MainInfoPanel.Texts[key] = KYS_MainInfoPanel.Texts[key] or defaultValue

    local ok, widget = pcall(function()
        if section.AddParagraph then
            return section:AddParagraph({
                Name = title,
                Title = title,
                Content = tostring(defaultText or "Off"),
                Description = tostring(defaultText or "Off"),
                Text = tostring(defaultText or "Off"),
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end

    ok, widget = pcall(function()
        if section.AddLabel then
            return section:AddLabel({
                Name = defaultValue,
                Text = defaultValue,
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end

    ok, widget = pcall(function()
        if section.AddButton then
            return section:AddButton({
                Name = defaultValue,
                Callback = function() end,
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end
end


-- =====================================================
-- UI TABS (KezodX / Obsidian Library)
-- =====================================================

-- Info panel state (labels yang bisa di-update runtime)
local KYS_MainInfoPanel = {
    Widgets = {},
    Texts   = {},
}

function KYS_InfoPlainText(text)
    text = tostring(text or "")
    text = text:gsub("<br%s*/?>", "\n")
    text = text:gsub("<[^>]->", "")
    text = text:gsub("&lt;","<"):gsub("&gt;",">"):gsub("&amp;","&")
    return text
end

function KYS_SetMainInfoPanelText(key, title, text)
    local w = KYS_MainInfoPanel.Widgets[key]
    if w and w.SetText then
        pcall(function() w:SetText(tostring(title) .. ": " .. KYS_InfoPlainText(text)) end)
    end
end

-- =====================================================
-- GROUPBOXES
-- =====================================================
-- Visual tab
local GbESP      = Tabs.Visual:AddGroupbox({ Side = "Left",  Name = "Player Highlight ESP" })
local GbWorld    = Tabs.Visual:AddGroupbox({ Side = "Right", Name = "World Highlight ESP" })
local GbCamera   = Tabs.Visual:AddGroupbox({ Side = "Left",  Name = "Camera" })
local GbLighting = Tabs.Visual:AddGroupbox({ Side = "Right", Name = "Lighting & Visual" })
local GbInfoPanel= Tabs.Visual:AddGroupbox({ Side = "Right", Name = "Game Info Panel" })

-- Main tab
local GbSurvivor   = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Survivor" })
local GbFakePerks  = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Fake Perks" })
local GbEscape     = Tabs.Main:AddGroupbox({ Side = "Left",  Name = "Escape" })
local GbAutomation = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Automation" })
local GbKiller     = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Killer" })
local GbKillerAbi  = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Killer Ability" })
local GbKillerUtil = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Utilities" })

-- Aim tab
local GbAimbot      = Tabs.Aim:AddGroupbox({ Side = "Left",  Name = "Aimbot" })
local GbCrosshair   = Tabs.Aim:AddGroupbox({ Side = "Left",  Name = "Advanced Crosshair" })
local GbVeil        = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Silent Aim Spear (Veil)" })
local GbFlask       = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Silent Aim Flask (Cure)" })
local GbToF         = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Silent Aim Twist Of Fate" })
local GbFlashlight  = Tabs.Aim:AddGroupbox({ Side = "Right", Name = "Silent Aim Flashlight" })

-- Mapping tab
local GbRadar    = Tabs.Mapping:AddGroupbox({ Side = "Left",  Name = "Radar" })
local GbTeleport = Tabs.Mapping:AddGroupbox({ Side = "Right", Name = "Teleport" })

-- Player tab
local GbMovement = Tabs.Player:AddGroupbox({ Side = "Left",  Name = "Movement" })
local GbFling    = Tabs.Player:AddGroupbox({ Side = "Right", Name = "Fling" })
local GbFun      = Tabs.Player:AddGroupbox({ Side = "Right", Name = "Fun / Emote" })

-- Settings tab
local GbMenu     = Tabs.Settings:AddGroupbox({ Side = "Left",  Name = "Menu" })

-- =====================================================
-- VISUAL: PLAYER ESP
-- =====================================================
GbESP:AddToggle("KYS_Enable_Player_ESP", {
    Text = "Enable Player ESP",
    Default = false,
    Callback = function(v)
        KYS_ESPState.PlayerMasterESP = v
        if v then KYS_StartPlayerLoop(); KYS_RefreshAllPlayers()
        else KYS_ClearAllPlayerESP() end
    end,
})
GbESP:AddDropdown("KYS_Select_Player_ESP", {
    Text = "Player ESP Types",
    Values = { "Survivor ESP", "Killer ESP", "Spectator ESP", "Survivor Items ESP" },
    Multi = true,
    Default = {},
    Callback = function(sel)
        KYS_ESPState.SurvivorESP      = sel["Survivor ESP"] == true
        KYS_ESPState.KillerESP        = sel["Killer ESP"] == true
        KYS_ESPState.SpectatorESP     = sel["Spectator ESP"] == true
        KYS_ESPState.SurvivorItemsESP = sel["Survivor Items ESP"] == true
        if KYS_ESPState.PlayerMasterESP then
            KYS_StartPlayerLoop(); KYS_RefreshAllPlayers()
        else KYS_ClearAllPlayerESP() end
    end,
})
GbESP:AddToggle("KYS_Player_Nametags", {
    Text = "Player Nametags",
    Default = false,
    Callback = function(v)
        KYS_ESPState.Nametags = v
        if KYS_ESPState.PlayerMasterESP then KYS_StartPlayerLoop(); KYS_RefreshAllPlayers() end
    end,
})
GbESP:AddToggle("KYS_Player_DistESP", {
    Text = "Player Distance ESP",
    Default = false,
    Callback = function(v)
        KYS_ESPState.DistanceESP = v
        if KYS_ESPState.PlayerMasterESP then KYS_StartPlayerLoop(); KYS_RefreshAllPlayers() end
    end,
})
GbESP:AddToggle("SURV_WarnKiller_Toggle", {
    Text = "Survivor Killer Warning",
    Default = false,
    Callback = function(v) VD.SURV_WarnKiller = v end,
})
GbESP:AddDivider()
GbESP:AddSlider("KYS_ESP_FillTransp", {
    Text = "Fill Transparency",
    Default = 0.95, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v)
        KYS_ESPState.ESPFillTransparency = v
        KYS_RefreshAllPlayers()
    end,
})
GbESP:AddSlider("KYS_ESP_OutlineTransp", {
    Text = "Outline Transparency",
    Default = 0.3, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v)
        KYS_ESPState.ESPOutlineTransparency = v
        KYS_RefreshAllPlayers()
    end,
})
GbESP:AddSlider("KYS_ESP_TextSize", {
    Text = "Text Size",
    Default = 12, Min = 8, Max = 22, Rounding = 0,
    Callback = function(v)
        KYS_ESPState.ESPTextSize = v
        KYS_RefreshAllPlayers()
    end,
})
GbESP:AddDivider()
GbESP:AddLabel("Colors"):AddColorPicker("KYS_Surv_Color", {
    Default = KYS_ESPState.SurvivorColor,
    Title = "Survivor Color",
    Callback = function(c) KYS_ESPState.SurvivorColor = c; KYS_RefreshAllPlayers() end,
})
GbESP:AddLabel("Killer"):AddColorPicker("KYS_Kill_Color", {
    Default = KYS_ESPState.KillerColor,
    Title = "Killer Color",
    Callback = function(c) KYS_ESPState.KillerColor = c; KYS_RefreshAllPlayers() end,
})
GbESP:AddLabel("Spectator"):AddColorPicker("KYS_Spec_Color", {
    Default = KYS_ESPState.SpectatorColor,
    Title = "Spectator Color",
    Callback = function(c) KYS_ESPState.SpectatorColor = c; KYS_RefreshAllPlayers() end,
})

-- =====================================================
-- VISUAL: WORLD ESP
-- =====================================================
GbWorld:AddToggle("KYS_Enable_World_ESP", {
    Text = "Enable World ESP",
    Default = false,
    Callback = function(v)
        KYS_ESPState.WorldMasterESP = v
        if v then KYS_RefreshESPRoots(); if KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
        else KYS_ClearAllWorldESP() end
    end,
})
GbWorld:AddDropdown("KYS_Select_World_ESP", {
    Text = "World Objects",
    Values = { "Generators", "Hooks", "Gates", "Windows", "Pallets", "SCP / Zombie" },
    Multi = true,
    Default = {},
    Callback = function(sel)
        KYS_ESPState.GeneratorESP = sel["Generators"] == true
        KYS_ESPState.HookESP      = sel["Hooks"] == true
        KYS_ESPState.GateESP      = sel["Gates"] == true
        KYS_ESPState.WindowESP    = sel["Windows"] == true
        KYS_ESPState.PalletESP    = sel["Pallets"] == true
        KYS_ESPState.SCPZombieESP = sel["SCP / Zombie"] == true
        if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then
            KYS_RefreshESPRoots(); KYS_StartWorldLoop()
        else KYS_ClearAllWorldESP() end
    end,
})
GbWorld:AddToggle("KYS_World_Nametags", {
    Text = "World Nametags",
    Default = false,
    Callback = function(v)
        KYS_ESPState.WorldNametags = v
        if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
    end,
})
GbWorld:AddToggle("KYS_World_DistESP", {
    Text = "World Distance ESP",
    Default = false,
    Callback = function(v)
        KYS_ESPState.WorldDistanceESP = v
        if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
    end,
})
GbWorld:AddDivider()
GbWorld:AddLabel("Generator"):AddColorPicker("KYS_Gen_Color",  { Default = KYS_ESPState.GeneratorColor,  Title = "Generator Color",  Callback = function(c) KYS_ESPState.GeneratorColor  = c end })
GbWorld:AddLabel("Hook"):AddColorPicker("KYS_Hook_Color",      { Default = KYS_ESPState.HookColor,       Title = "Hook Color",       Callback = function(c) KYS_ESPState.HookColor       = c end })
GbWorld:AddLabel("Gate"):AddColorPicker("KYS_Gate_Color",      { Default = KYS_ESPState.GateColor,       Title = "Gate Color",       Callback = function(c) KYS_ESPState.GateColor       = c end })
GbWorld:AddLabel("Window"):AddColorPicker("KYS_Win_Color",     { Default = KYS_ESPState.WindowColor,     Title = "Window Color",     Callback = function(c) KYS_ESPState.WindowColor     = c end })
GbWorld:AddLabel("Pallet"):AddColorPicker("KYS_Pallet_Color",  { Default = KYS_ESPState.PalletColor,     Title = "Pallet Color",     Callback = function(c) KYS_ESPState.PalletColor     = c end })
GbWorld:AddLabel("SCP/Zombie"):AddColorPicker("KYS_SCP_Color", { Default = KYS_ESPState.SCPZombieColor,  Title = "SCP/Zombie Color", Callback = function(c) KYS_ESPState.SCPZombieColor  = c end })

-- =====================================================
-- VISUAL: CAMERA
-- =====================================================
GbCamera:AddToggle("CAM_FOVEnabled_Toggle", {
    Text = "Enable Camera FOV Override",
    Default = false,
    Callback = function(v) VD.CAM_FOVEnabled = v end,
})
GbCamera:AddSlider("CAM_FOV_Slider", {
    Text = "Camera FOV",
    Default = 90, Min = 30, Max = 140, Rounding = 0,
    Callback = function(v) VD.CAM_FOV = v end,
})
GbCamera:AddToggle("CAM_ThirdPerson_Toggle", {
    Text = "Third Person (Killer only)",
    Default = false,
    Callback = function(v) VD.CAM_ThirdPerson = v end,
})
GbCamera:AddToggle("CAM_ShiftLock_Toggle", {
    Text = "Shift Lock (auto face camera)",
    Default = false,
    Callback = function(v) VD.CAM_ShiftLock = v end,
})
GbCamera:AddToggle("CAM_InfinityZoom_Toggle", {
    Text = "Infinity Zoom Out",
    Default = false,
    Callback = function(v)
        VD.CAM_InfinityZoom = v
        LocalPlayer.CameraMaxZoomDistance = v and math.huge or 128
        LocalPlayer.CameraMinZoomDistance = v and 0 or 0.5
    end,
})
GbCamera:AddToggle("NoCutscene_Toggle", {
    Text = "No Cutscene",
    Default = false,
    Callback = function(v) VD.NoCutscene = v end,
})

-- =====================================================
-- VISUAL: LIGHTING & VISUAL
-- =====================================================
GbLighting:AddToggle("NO_Fog_Toggle", {
    Text = "No Fog",
    Default = false,
    Callback = function(v) VD.NO_Fog = v end,
})
GbLighting:AddToggle("Fullbright_Toggle", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v)
        VD.Fullbright = v
        if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" then
            pcall(VD_ApplyWeather, VD.VIS_WeatherTheme)
        end
    end,
})
GbLighting:AddDropdown("WeatherTheme_DD", {
    Text = "Weather & Sky Theme",
    Default = "Default",
    Values = {"Default","Christmas (Snow)","Heavy Rain (Storm)","Autumn (Musim Gugur)","Cherry Blossom (Sakura)","Sunset (Golden Hour)","Blood Moon (Spooky)","Toxic Wasteland","Vaporwave (Synthwave)","Midnight (Pitch Black)"},
    Callback = function(v)
        VD.VIS_WeatherTheme = v
        pcall(VD_ApplyWeather, v)
    end,
})
GbLighting:AddDivider()
GbLighting:AddToggle("VIS_KystKiller_Toggle",         { Text = "Kyst Killer Display",      Default = false, Callback = function(v) VD.VIS_KystKiller = v;         if v then StartKystKiller()         else StopKystKiller()         end end })
GbLighting:AddToggle("VIS_SpectatorCounter_Toggle",   { Text = "Spectator Counter",         Default = false, Callback = function(v) VD.VIS_SpectatorCounter = v;   if v then StartSpectatorCounter()   else StopSpectatorCounter()   end end })
GbLighting:AddToggle("VIS_KillerPerks_Toggle",        { Text = "Killer Perks Display",      Default = false, Callback = function(v) VD.VIS_KillerPerks = v;        if v then StartKillerPerksDisplay() else StopKillerPerksDisplay() end end })
GbLighting:AddToggle("VIS_PredictMap_Toggle",         { Text = "Predict Map",               Default = false, Callback = function(v) VD.VIS_PredictMap = v;         if v then StartPredictMap()         else StopPredictMap()         end end })
GbLighting:AddToggle("VIS_HideSurvivorIcon_Toggle",   { Text = "Hide Survivor Icon",        Default = false, Callback = function(v) if getgenv().KYS_SetHideSurvivorIcon then getgenv().KYS_SetHideSurvivorIcon(v) else VD.VIS_HideSurvivorIcon = v end end })
GbLighting:AddToggle("VIS_ShowPingFPS_Toggle",        { Text = "Show Ping & FPS",           Default = false, Callback = function(v) if getgenv().KYS_SetShowPingFPS    then getgenv().KYS_SetShowPingFPS(v)    else VD.VIS_ShowPingFPS = v    end end })
GbLighting:AddToggle("VIS_ShowHookCounter_Toggle",    { Text = "Show Hook Counter",         Default = false, Callback = function(v) if getgenv().KYS_SetShowHookCounter then getgenv().KYS_SetShowHookCounter(v) else VD.VIS_ShowHookCounter = v end end })

-- Info Panel labels
do
    local lKyst = GbInfoPanel:AddLabel("Kyst Killer: Off", true, "InfoLabel_KystKiller")
    local lPerk = GbInfoPanel:AddLabel("Killer Perks: Off", true, "InfoLabel_KillerPerks")
    local lMap  = GbInfoPanel:AddLabel("Predict Map: Off",  true, "InfoLabel_PredictMap")
    KYS_MainInfoPanel.Widgets["KystKiller"]  = lKyst
    KYS_MainInfoPanel.Widgets["KillerPerks"] = lPerk
    KYS_MainInfoPanel.Widgets["PredictMap"]  = lMap
end

-- =====================================================
-- MAIN: SURVIVOR
-- =====================================================
GbSurvivor:AddToggle("SURV_SwiftVault_Toggle",     { Text = "Swift Vault",              Default = false, Callback = function(v) VD.SURV_AutoVault = v end })
GbSurvivor:AddToggle("SURV_FastVault_Toggle",      { Text = "Swift Vault V2",           Default = false, Callback = function(v) VD.SURV_FastVault = v; if not v then local c=LocalPlayer.Character; if c then c:SetAttribute("vaultspeed",1) end end end })
GbSurvivor:AddSlider("SURV_VaultSpeed_Slider",     { Text = "Vault Speed",              Default = 13, Min = 10, Max = 20, Rounding = 0, Callback = function(v) VD.SURV_VaultSpeed = v end })
GbSurvivor:AddToggle("SURV_AutoPallet_Toggle",     { Text = "Pallet Reflex",            Default = false, Callback = function(v) VD.SURV_AutoPallet = v end })
GbSurvivor:AddSlider("SURV_AutoPalletDist_Slider", { Text = "Pallet Trigger Range",     Default = 20, Min = 5, Max = 50, Rounding = 1, Callback = function(v) VD.SURV_AutoPalletDist = v end })
GbSurvivor:AddToggle("SURV_AntiKnock_Toggle",      { Text = "Anti Knock",               Default = false, Callback = function(v) VD.SURV_AntiKnock = v end })
GbSurvivor:AddToggle("SURV_InstantHeal_Toggle",    { Text = "Aura Heal (Self)",         Default = false, Callback = function(v) setInstantHealSelf(v) end })
GbSurvivor:AddToggle("SURV_AutoDodgeSpear_Toggle", { Text = "Auto Dodge Spear (Veil)",  Default = false, Callback = function(v) VD.SURV_AutoDodgeSpear = v end })
GbSurvivor:AddToggle("SURV_AutoHealAll_Toggle",    { Text = "Aura Heal All",            Default = false, Callback = function(v) setAutoHealAll(v) end })
GbSurvivor:AddToggle("SURV_FirstPerson_Toggle",    { Text = "First Person Camera",      Default = false, Callback = function(v) VD.SURV_FirstPerson = v; if not v then pcall(RestoreFirstPersonCamera) end end })
GbSurvivor:AddToggle("SURV_AutoParry_Toggle",      { Text = "Auto Parry",               Default = false, Callback = function(v) VD_SetAutoParry(v) end })
GbSurvivor:AddToggle("SURV_ParryAggressive_Toggle",{ Text = "Auto Parry Aggressive",    Default = false, Callback = function(v) VD.SURV_ParryAggressive = v end })
GbSurvivor:AddSlider("SURV_ParryDist_Slider",      { Text = "Parry Distance Trigger",   Default = 8,  Min = 2, Max = 25, Rounding = 1, Callback = function(v) VD.SURV_ParryDistance = v end })
GbSurvivor:AddToggle("SURV_ShowParryCircle_Toggle",{ Text = "Show Parry Range Circle",  Default = false, Callback = function(v) VD.SURV_ShowParryCircle = v; if VD_ParryRange then VD_ParryRange.Transparency = 1 end end })
GbSurvivor:AddToggle("SURV_FakeParry_Toggle",      { Text = "Fake Parry (Press V)",     Default = false, Callback = function(v) VD.SURV_FakeParry = v; if FakeParryData.Button then FakeParryData.Button.Visible = v end end })
GbSurvivor:AddDropdown("SURV_FakeParryAnim_DD", {
    Text = "Fake Parry Animation",
    Values = {"Enten","Stopwatch","Fih","BloodShield"},
    Default = "Enten",
    Callback = function(v) VD.SURV_FakeParryAnim = v end,
})
GbSurvivor:AddToggle("SURV_FakeParryDragLock_Toggle",{ Text = "Lock Fake Parry Button", Default = false, Callback = function(v) FakeParryData.DragLocked = v end })
GbSurvivor:AddToggle("SURV_FakeGen_Toggle",        { Text = "Fake Generator (Press B)", Default = false, Callback = function(v) VD.SURV_FakeGen = v; if FakeGenData and FakeGenData.Button then FakeGenData.Button.Visible = v end end })
GbSurvivor:AddToggle("SURV_FakeGenDragLock_Toggle",{ Text = "Lock Fake Gen Button",     Default = false, Callback = function(v) if FakeGenData then FakeGenData.DragLocked = v end end })

-- =====================================================
-- MAIN: FAKE PERKS
-- =====================================================
do
    local FP = {
        Conns = {},
        ActiveBuffs = {},
        HB = nil,
        LastBuffEnd = 0,
        CooldownTime = 10,
    }

    local function FP_Char() return LocalPlayer.Character end
    local function FP_Hum() local c=FP_Char(); return c and c:FindFirstChildOfClass("Humanoid") end

    local function FP_GetTotalSpeedBuff()
        local total = 0
        for _, b in pairs(FP.ActiveBuffs) do
            if tick() < b.endTime then total = total + b.amt end
        end
        return total
    end

    local function FP_ApplySpeed()
        local char = FP_Char(); local hum = FP_Hum()
        local total = FP_GetTotalSpeedBuff()
        if char then char:SetAttribute("speedboost", total > 0 and (1 + total/14) or 1) end
        if hum and total > 0 then hum.WalkSpeed = 16 + total end
    end

    local function FP_EnsureHB()
        if FP.HB then return end
        FP.HB = RunService.Heartbeat:Connect(function()
            local expired = {}
            for name, b in pairs(FP.ActiveBuffs) do if tick() >= b.endTime then table.insert(expired, name) end end
            for _, n in ipairs(expired) do FP.ActiveBuffs[n] = nil end
            if #expired > 0 and FP_GetTotalSpeedBuff() <= 0 then FP.LastBuffEnd = tick() end
            FP_ApplySpeed()
            if FP_GetTotalSpeedBuff() <= 0 and next(FP.ActiveBuffs) == nil then
                if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
                local c = FP_Char(); if c then c:SetAttribute("speedboost",1) end
            end
        end)
    end

    local function FP_TryBuff(name, amt, dur)
        if FP.ActiveBuffs[name] then return end
        if tick() - FP.LastBuffEnd < FP.CooldownTime and next(FP.ActiveBuffs) == nil then return end
        FP.ActiveBuffs[name] = { amt = amt, endTime = tick() + dur }
        FP_ApplySpeed(); FP_EnsureHB()
        VD_Notify("Fake Perks", "["..name.."] Aktif! +"..amt.." Speed ("..dur.."s)", 3)
    end

    local function FP_Clean(name)
        if FP.Conns[name] then
            for _, c in ipairs(FP.Conns[name]) do pcall(function() c:Disconnect() end) end
            FP.Conns[name] = nil
        end
    end
    local function FP_Reg(name, conn)
        if not FP.Conns[name] then FP.Conns[name] = {} end
        table.insert(FP.Conns[name], conn)
    end

    GbFakePerks:AddSlider("FP_Cooldown_Slider", {
        Text = "Cooldown (semua perks)", Default = 10, Min = 0, Max = 60, Rounding = 0,
        Callback = function(v) FP.CooldownTime = v end,
    })

    -- Flowstate
    local flowstateOn = false
    GbFakePerks:AddToggle("FP_Flowstate_Toggle", {
        Text = "Flowstate",
        Default = false,
        Callback = function(val)
            flowstateOn = val
            local c = FP_Char(); if c then c:SetAttribute("Flowstate", val) end
            if val then
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local function onVaultAction()
                    if not flowstateOn then return end
                    task.delay(0.5, function() if flowstateOn then FP_TryBuff("Flowstate", 5, 3) end end)
                end
                local w = r and r:FindFirstChild("Window")
                local p = r and r:FindFirstChild("Pallet")
                if w then local vb=w:FindFirstChild("Vaultbindable"); if vb and vb:IsA("BindableEvent") then FP_Reg("Flowstate", vb.Event:Connect(onVaultAction)) end end
                if p then local sb=p:FindFirstChild("Slidebindable"); if sb and sb:IsA("BindableEvent") then FP_Reg("Flowstate", sb.Event:Connect(onVaultAction)) end end
                local function hookChar(c2)
                    if not c2 then return end
                    FP_Reg("Flowstate", c2:GetAttributeChangedSignal("__VaultFireCount"):Connect(function() if flowstateOn then onVaultAction() end end))
                end
                hookChar(LocalPlayer.Character)
                FP_Reg("Flowstate", LocalPlayer.CharacterAdded:Connect(function(c2)
                    if flowstateOn then c2:SetAttribute("Flowstate", true); hookChar(c2) end
                end))
                VD_Notify("Fake Perks", "Flowstate ON +5 speed selama 3 detik setelah vault/slide", 4)
            else
                FP_Clean("Flowstate"); FP.ActiveBuffs["Flowstate"] = nil
                local c2=FP_Char(); if c2 then c2:SetAttribute("Flowstate",false) end
                VD_Notify("Fake Perks", "Flowstate OFF", 3)
            end
        end,
    })

    -- Quick Recovery
    local quickRecOn = false
    GbFakePerks:AddToggle("FP_QuickRecovery_Toggle", {
        Text = "Quick Recovery",
        Default = false,
        Callback = function(val)
            quickRecOn = val
            if val then
                local function onHealed() if quickRecOn then FP_TryBuff("QuickRecovery", 6, 3) end end
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local hf = r and r:FindFirstChild("Healing")
                if hf then
                    local hd=hf:FindFirstChild("Healdone"); if hd and hd:IsA("BindableEvent") then FP_Reg("QuickRecovery", hd.Event:Connect(onHealed)) end
                    local sv=hf:FindFirstChild("Skillcheckvalidated"); if sv and sv:IsA("BindableEvent") then FP_Reg("QuickRecovery", sv.Event:Connect(onHealed)) end
                end
                local function hookHP(c2)
                    if not c2 then return end
                    local hum=c2:FindFirstChildOfClass("Humanoid"); if not hum then return end
                    local lastHP=hum.Health
                    FP_Reg("QuickRecovery", hum.HealthChanged:Connect(function(newHP)
                        if not quickRecOn then return end
                        if newHP > lastHP and (newHP >= hum.MaxHealth or (newHP-lastHP) >= 15) then onHealed() end
                        lastHP = newHP
                    end))
                    FP_Reg("QuickRecovery", c2:GetAttributeChangedSignal("IsBeingHealed"):Connect(function()
                        if not quickRecOn then return end
                        if c2:GetAttribute("IsBeingHealed") == false then onHealed() end
                    end))
                end
                hookHP(LocalPlayer.Character)
                FP_Reg("QuickRecovery", LocalPlayer.CharacterAdded:Connect(hookHP))
                VD_Notify("Fake Perks", "Quick Recovery ON +6 speed selama 3 detik setelah di-heal", 4)
            else
                FP_Clean("QuickRecovery"); FP.ActiveBuffs["QuickRecovery"] = nil
                VD_Notify("Fake Perks", "Quick Recovery OFF", 3)
            end
        end,
    })

    -- Perfect Landing
    local perfLandOn = false
    GbFakePerks:AddToggle("FP_PerfectLanding_Toggle", {
        Text = "Perfect Landing",
        Default = false,
        Callback = function(val)
            perfLandOn = val
            if val then
                local function hookFall(c2)
                    if not c2 then return end
                    local hum=c2:FindFirstChildOfClass("Humanoid"); if not hum then return end
                    local wasFalling,fallStart=false,0
                    FP_Reg("PerfectLanding", hum.StateChanged:Connect(function(old,new)
                        if not perfLandOn then return end
                        if new==Enum.HumanoidStateType.Freefall then wasFalling=true; fallStart=tick() end
                        if wasFalling and (new==Enum.HumanoidStateType.Landed or new==Enum.HumanoidStateType.Running) then
                            local ft=tick()-fallStart; wasFalling=false
                            if ft>=0.25 then FP_TryBuff("PerfectLanding",8,3) end
                        end
                    end))
                end
                hookFall(LocalPlayer.Character)
                FP_Reg("PerfectLanding", LocalPlayer.CharacterAdded:Connect(hookFall))
                VD_Notify("Fake Perks", "Perfect Landing ON +8 speed selama 3 detik setelah landing", 4)
            else
                FP_Clean("PerfectLanding"); FP.ActiveBuffs["PerfectLanding"] = nil
                VD_Notify("Fake Perks", "Perfect Landing OFF", 3)
            end
        end,
    })

    -- Adrenaline Rush
    local adrenalineOn = false
    GbFakePerks:AddToggle("FP_AdrenalineRush_Toggle", {
        Text = "Adrenaline Rush",
        Default = false,
        Callback = function(val)
            adrenalineOn = val
            if val then
                local function hookDmg(c2)
                    if not c2 then return end
                    local hum=c2:FindFirstChildOfClass("Humanoid"); if not hum then return end
                    local lastHP=hum.Health
                    FP_Reg("AdrenalineRush", hum.HealthChanged:Connect(function(newHP)
                        if not adrenalineOn then return end
                        if newHP < lastHP and newHP <= 50 and newHP > 0 then FP_TryBuff("AdrenalineRush",4,5) end
                        lastHP = newHP
                    end))
                end
                hookDmg(LocalPlayer.Character)
                FP_Reg("AdrenalineRush", LocalPlayer.CharacterAdded:Connect(hookDmg))
                VD_Notify("Fake Perks", "Adrenaline Rush ON +4 speed selama 5 detik saat HP drop ke 50", 4)
            else
                FP_Clean("AdrenalineRush"); FP.ActiveBuffs["AdrenalineRush"] = nil
                VD_Notify("Fake Perks", "Adrenaline Rush OFF", 3)
            end
        end,
    })
end

-- =====================================================
-- MAIN: ESCAPE
-- =====================================================
GbEscape:AddToggle("BypassGate_Toggle",    { Text = "Bypass Gate",            Default = false, Callback = function(v) VD.BypassGate = v; if not v then pcall(VD_RestoreGateParts) end end })
GbEscape:AddToggle("BEAT_Survivor_Toggle", { Text = "Beat Survivor (auto exit)", Default = false, Callback = function(v) VD.BEAT_Survivor = v end })
GbEscape:AddToggle("SURV_FleeKiller_Toggle",  { Text = "Flee Killer",          Default = false, Callback = function(v) VD.SURV_FleeKiller = v end })
GbEscape:AddSlider("SURV_FleeDist_Slider",    { Text = "Flee Distance",        Default = 40, Min = 15, Max = 80, Rounding = 0, Callback = function(v) VD.SURV_FleeDistance = v end })

-- =====================================================
-- MAIN: AUTOMATION
-- =====================================================
GbAutomation:AddToggle("AutoSkillcheck_Toggle",  { Text = "Auto Skillcheck",    Default = false, Callback = function(v) VD_SetAutoSkillcheck(v) end })
GbAutomation:AddToggle("HideSkillUI_Toggle",     { Text = "Hide Skillcheck UI", Default = false, Callback = function(v) VD.HideSkillUI = v end })
GbAutomation:AddToggle("GenBypass_Toggle",       { Text = "Boost Gen Bypass",   Default = false, Callback = function(v) setGenBypass(v) end })
GbAutomation:AddDropdown("SkillcheckMode_DD", {
    Text = "Skillcheck Mode",
    Values = {"Normal","Perfect","Instant"},
    Default = "Normal",
    Callback = function(v)
        VD.AutoSkillcheckMode = v or "Normal"
        if VD.AutoSkillcheckMode ~= "Instant" and AutoSkill.InstantRotationConnection then
            AutoSkill.InstantRotationConnection:Disconnect()
            AutoSkill.InstantRotationConnection = nil
            AutoSkill.InstantHasClicked = false
        end
        VD_Notify("Skillcheck Mode", tostring(VD.AutoSkillcheckMode).." selected", 2)
    end,
})

-- =====================================================
-- MAIN: KILLER
-- =====================================================
GbKiller:AddToggle("AUTO_Attack_Toggle",   { Text = "Auto Attack",          Default = false, Callback = function(v) VD.AUTO_Attack = v end })
GbKiller:AddSlider("AUTO_AttackRange_Slider",{ Text = "Attack Range",       Default = 12, Min = 5, Max = 20, Rounding = 0, Callback = function(v) VD.AUTO_AttackRange = v end })
GbKiller:AddToggle("HITBOX_Toggle",        { Text = "Hitbox Expand",        Default = false, Callback = function(v) VD.HITBOX_Enabled = v end })
GbKiller:AddSlider("HITBOX_Size_Slider",   { Text = "Hitbox Size",          Default = 15, Min = 5, Max = 40, Rounding = 0, Callback = function(v) VD.HITBOX_Size = v end })
GbKiller:AddToggle("KILLER_InfLunge_Toggle",{ Text = "Infinite Lunge",      Default = false, Callback = function(v) VD.KILLER_InfLunge = v end })

-- =====================================================
-- MAIN: KILLER ABILITY
-- =====================================================
GbKillerAbi:AddToggle("KILLER_BypassCooldown_Toggle", { Text = "Infinite Abyssal Burst (Abyss)", Default = false, Callback = function(v)
    VD.KILLER_BypassCooldown = v; if v then KYS_StartAbyssCooldownBypass() else KYS_StopAbyssCooldownBypass() end
end })
GbKillerAbi:AddToggle("KILLER_BypassLeap_Toggle", { Text = "Infinite Skill (Hidden)", Default = false, Callback = function(v)
    VD.KILLER_BypassLeap = v; if v then pcall(KYS_StartHiddenCooldownBypass) else pcall(KYS_StopHiddenCooldownBypass) end
end })
GbKillerAbi:AddToggle("KILLER_InfFrenzy_Toggle", { Text = "Infinite Frenzy (Jeff)", Default = false, Callback = function(v)
    VD.KILLER_InfFrenzy = v; if v then pcall(KYS_StartJeffCooldownBypass) else pcall(KYS_StopJeffCooldownBypass) end
end })
GbKillerAbi:AddToggle("KILLER_InfLakeMist_Toggle", { Text = "Infinite Lake Mist (Jason)", Default = false, Callback = function(v)
    VD.KILLER_InfLakeMist = v; if v then pcall(KYS_StartSlasherCooldownBypass) else pcall(KYS_StopSlasherCooldownBypass) end
end })
GbKillerAbi:AddToggle("KILLER_InfPursuit_Toggle", { Text = "Infinite Pursuit (Jason)", Default = false, Callback = function(v)
    VD.KILLER_InfPursuit = v; if v then pcall(KYS_StartSlasherCooldownBypass) else pcall(KYS_StopSlasherCooldownBypass) end
end })
GbKillerAbi:AddToggle("KILLER_InfGrab_Toggle", { Text = "Infinite Grab (Myers)", Default = false, Callback = function(v) setMyersGrab(v) end })
GbKillerAbi:AddToggle("KILLER_FakeAttack_Toggle", { Text = "Fake Attack (Counter Parry)", Default = false, Callback = function(v)
    VD.KILLER_FakeAttack = v; pcall(KYS_ToggleFakeAttack, v)
end })
GbKillerAbi:AddToggle("KILLER_InfGrabDragLock_Toggle", { Text = "Lock Inf Grab Button", Default = false, Callback = function(v) setMyersDragLocked(v) end })
GbKillerAbi:AddDropdown("KILLER_CustomMasked_DD", {
    Text = "Custom Masked",
    Values = {"Richard","Tony","Brandon","Jake","Richter","Graham","Alex"},
    Default = "Richard",
    Callback = function(v) VD.KILLER_CustomMasked = v or "Richard" end,
})
GbKillerAbi:AddButton({ Text = "Apply Custom Masked", Func = function() pcall(KYS_ApplyCustomMasked, VD.KILLER_CustomMasked) end })
GbKillerAbi:AddButton({ Text = "Random Custom Masked", Func = function()
    local masks = {"Richard","Tony","Brandon","Jake","Richter","Graham","Alex"}
    local m = masks[math.random(1,#masks)]; VD.KILLER_CustomMasked = m; pcall(KYS_ApplyCustomMasked, m)
end })

-- =====================================================
-- MAIN: KILLER UTILITIES
-- =====================================================
GbKillerUtil:AddToggle("KILLER_AutoHook_Toggle",      { Text = "Auto Hook",                    Default = false, Callback = function(v) VD.KILLER_AutoHook = v end })
GbKillerUtil:AddToggle("KILLER_DestroyPallets_Toggle",{ Text = "Destroy Pallets",              Default = false, Callback = function(v) VD.KILLER_DestroyPallets = v end })
GbKillerUtil:AddToggle("KILLER_AutoBreakGene_Toggle", { Text = "Auto Kick Generator",          Default = false, Callback = function(v) VD.KILLER_AutoBreakGene = v end })
GbKillerUtil:AddToggle("KILLER_BlockVaults_Toggle",   { Text = "Block All Vaults",             Default = false, Callback = function(v) VD.KILLER_BlockVaults = v end })
GbKillerUtil:AddToggle("KILLER_BlockPallets_Toggle",  { Text = "Auto Drop All Pallets",        Default = false, Callback = function(v) VD.KILLER_BlockPallets = v end })
GbKillerUtil:AddToggle("KILLER_BlockPalletDrop_Toggle",{Text = "Break All Pallet",             Default = false, Callback = function(v) VD.KILLER_BlockPalletDrop = v end })
GbKillerUtil:AddToggle("KILLER_AntiBlind_Toggle",     { Text = "Anti Blind (Flashlight)",      Default = false, Callback = function(v) VD.KILLER_AntiBlind = v; pcall(SetupAntiBlind) end })
GbKillerUtil:AddToggle("KILLER_NoPalletStun_Toggle",  { Text = "Remove Palletwrong (All)",     Default = false, Callback = function(v) VD.KILLER_NoPalletStun = v; pcall(SetupNoPalletStun) end })
GbKillerUtil:AddToggle("KILLER_NoSlowdown_Toggle",    { Text = "No Slowdown",                  Default = false, Callback = function(v) VD.KILLER_NoSlowdown = v end })
GbKillerUtil:AddToggle("BEAT_Killer_Toggle",          { Text = "Beat Killer (auto kill)",      Default = false, Callback = function(v) VD.BEAT_Killer = v end })
GbKillerUtil:AddDivider()
GbKillerUtil:AddToggle("AimLock_Toggle",              { Text = "Target Lock",                  Default = false, Callback = function(v) if getgenv().VD_SetAimLockButtonVisible then getgenv().VD_SetAimLockButtonVisible(v) else VD.AimLockButton = v end end })
GbKillerUtil:AddToggle("AimLockBtnLocked_Toggle",     { Text = "Lock Target Lock Button",      Default = false, Callback = function(v) VD.AimLockButtonLocked = v end })
GbKillerUtil:AddSlider("AimLockMaxDist_Slider",       { Text = "Target Lock Max Distance",     Default = 50, Min = 10, Max = 200, Rounding = 0, Callback = function(v) VD.AimLockMaxDistance = v end })

-- =====================================================
-- AIM: AIMBOT
-- =====================================================
GbAimbot:AddToggle("AIM_Enabled_Toggle",  { Text = "Enable Aimbot",      Default = false, Callback = function(v) VD.AIM_Enabled = v end })
GbAimbot:AddToggle("AIM_UseRMB_Toggle",   { Text = "Use RMB to Aim",     Default = false, Callback = function(v) VD.AIM_UseRMB = v end })
GbAimbot:AddToggle("AIM_ShowFOV_Toggle",  { Text = "Show FOV Circle",    Default = false, Callback = function(v) VD.AIM_ShowFOV = v end })
GbAimbot:AddSlider("AIM_FOV_Slider",      { Text = "FOV Size",           Default = 120, Min = 20, Max = 400, Rounding = 0, Callback = function(v) VD.AIM_FOV = v end })
GbAimbot:AddSlider("AIM_Smooth_Slider",   { Text = "Smoothness",         Default = 0.3, Min = 0.1, Max = 10, Rounding = 2, Callback = function(v) VD.AIM_Smooth = v end })
GbAimbot:AddToggle("AIM_VisCheck_Toggle", { Text = "Visibility Check",   Default = false, Callback = function(v) VD.AIM_VisCheck = v end })
GbAimbot:AddToggle("AIM_Predict_Toggle",  { Text = "Prediction",         Default = false, Callback = function(v) VD.AIM_Predict = v end })

-- =====================================================
-- AIM: CROSSHAIR
-- =====================================================
GbCrosshair:AddToggle("CROSS_Enabled_Toggle", { Text = "Enable Crosshair", Default = false, Callback = function(v) VD.CROSS_Enabled = v; pcall(VD_UpdateCrosshair) end })
GbCrosshair:AddLabel("Color"):AddColorPicker("CROSS_Color_Picker", {
    Default = VD.CROSS_Color or Color3.fromRGB(255,255,255),
    Title = "Crosshair Color",
    Callback = function(v) VD.CROSS_Color = v; pcall(VD_UpdateCrosshair) end,
})
GbCrosshair:AddDropdown("CROSS_Style_DD", {
    Text = "Crosshair Style", Values = {"Dot","Plus","X","Box"}, Default = "Dot",
    Callback = function(v) VD.CROSS_Style = v; pcall(VD_UpdateCrosshair) end,
})
GbCrosshair:AddSlider("CROSS_Size_Slider",      { Text = "Size",       Default = 3,  Min = 1,    Max = 100,  Rounding = 0, Callback = function(v) VD.CROSS_Size      = v; pcall(VD_UpdateCrosshair) end })
GbCrosshair:AddSlider("CROSS_Thick_Slider",     { Text = "Thickness",  Default = 4,  Min = 1,    Max = 20,   Rounding = 0, Callback = function(v) VD.CROSS_Thickness  = v; pcall(VD_UpdateCrosshair) end })
GbCrosshair:AddSlider("CROSS_Gap_Slider",       { Text = "Gap",        Default = 6,  Min = 0,    Max = 50,   Rounding = 0, Callback = function(v) VD.CROSS_Gap        = v; pcall(VD_UpdateCrosshair) end })
GbCrosshair:AddSlider("CROSS_PosX_Slider",      { Text = "Position X", Default = 0,  Min = -500, Max = 500,  Rounding = 0, Callback = function(v) VD.CROSS_PosX       = v; pcall(VD_UpdateCrosshair) end })
GbCrosshair:AddSlider("CROSS_PosY_Slider",      { Text = "Position Y", Default = 0,  Min = -500, Max = 500,  Rounding = 0, Callback = function(v) VD.CROSS_PosY       = v; pcall(VD_UpdateCrosshair) end })

-- =====================================================
-- AIM: VEIL SPEAR
-- =====================================================
GbVeil:AddToggle("SPEAR_Aimbot_Toggle",     { Text = "Spear Aimbot",           Default = false, Callback = function(v) VD.SPEAR_Aimbot = v end })
GbVeil:AddSlider("SPEAR_Gravity_Slider",    { Text = "Spear Gravity",          Default = 50,  Min = 10,  Max = 200, Rounding = 0, Callback = function(v) VD.SPEAR_Gravity = v end })
GbVeil:AddSlider("SPEAR_Speed_Slider",      { Text = "Spear Speed",            Default = 100, Min = 50,  Max = 300, Rounding = 0, Callback = function(v) VD.SPEAR_Speed  = v end })
GbVeil:AddDivider()
GbVeil:AddToggle("VeilSilentAim_Toggle",    { Text = "Silent Aim Spear (Veil)", Default = false, Callback = function(v) VeilConfig.Enabled = v end })
GbVeil:AddToggle("VeilShowFOV_Toggle",      { Text = "Show FOV Circle",         Default = true,  Callback = function(v) VeilConfig.ShowFOV = v end })
GbVeil:AddToggle("VeilShowLaser_Toggle",    { Text = "Show Target Laser",       Default = true,  Callback = function(v) VeilConfig.ShowTargetLaser = v end })
GbVeil:AddSlider("VeilFOV_Slider",          { Text = "FOV Radius",              Default = 150, Min = 50, Max = 500, Rounding = 0, Callback = function(v) VeilConfig.FOV = v end })
GbVeil:AddToggle("VeilAutoPredict_Toggle",  { Text = "Auto Predict",            Default = false, Callback = function(v) VeilConfig.AutoPredict = v end })
GbVeil:AddSlider("VeilSpeed_Slider",        { Text = "Spear Speed",             Default = 165, Min = 50, Max = 300, Rounding = 0, Callback = function(v) VeilConfig.SpearSpeed = v end })
GbVeil:AddSlider("VeilGravity_Slider",      { Text = "Gravity",                 Default = math.floor(workspace.Gravity*0.5), Min = 0, Max = 300, Rounding = 0, Callback = function(v) VeilConfig.Gravity = v end })
GbVeil:AddSlider("VeilHVec_Slider",         { Text = "Horizontal Vector",       Default = 1.0, Min = 0, Max = 5, Rounding = 2, Callback = function(v) VeilConfig.HorizontalPredictFactor = v end })
GbVeil:AddDropdown("VeilTargetPart_DD",     { Text = "Target Part", Values = {"Torso","Head","Root"}, Default = "Torso", Callback = function(v) VeilConfig.TargetPart = v end })

-- =====================================================
-- AIM: FLASK
-- =====================================================
GbFlask:AddToggle("KILLER_SilentAimFlask_Toggle", { Text = "Silent Aim Flask (Cure)", Default = false, Callback = function(v) VD.KILLER_SilentAimFlask = v end })
GbFlask:AddToggle("KILLER_FlaskLaser_Toggle", { Text = "Flask Laser (Cure)", Default = false, Callback = function(v)
    VD.KILLER_FlaskLaser = v
    if v then pcall(KYS_StartCureFlaskLaser)
    else
        if getgenv().KYS_CureFlaskLaserThread then getgenv().KYS_CureFlaskLaserThread:Disconnect(); getgenv().KYS_CureFlaskLaserThread = nil end
        if getgenv().KYS_CureFlaskLaserPart then pcall(function() getgenv().KYS_CureFlaskLaserPart:Destroy() end); getgenv().KYS_CureFlaskLaserPart = nil end
    end
end })

-- =====================================================
-- AIM: TWIST OF FATE
-- =====================================================
GbToF:AddToggle("TOF_SilentAim_Toggle", { Text = "Silent Aim ToF", Default = false, Callback = function(v)
    if getgenv().KYS_SetToFSilentAim then getgenv().KYS_SetToFSilentAim(v) end
end })
GbToF:AddToggle("TOF_Laser_Toggle",         { Text = "ToF Laser",           Default = true,  Callback = function(v) VD.TOF_Laser = v; if not v and getgenv().KYS_ToFClearLaser then getgenv().KYS_ToFClearLaser() end end })
GbToF:AddToggle("TOF_WallCheck_Toggle",     { Text = "ToF Wall Check",      Default = false, Callback = function(v) VD.TOF_WallCheck = v end })
GbToF:AddToggle("TOF_BlockKnocked_Toggle",  { Text = "Block When Knocked",  Default = true,  Callback = function(v) VD.TOF_BlockKnocked = v end })
GbToF:AddDropdown("TOF_TargetMode_DD", {
    Text = "Target Mode",
    Values = {"Killer","Survivors","Zombie"},
    Default = "Killer",
    Callback = function(v)
        if getgenv().KYS_ToFSetTargetMode then getgenv().KYS_ToFSetTargetMode(v or "Killer", false)
        else VD.TOF_TargetMode = v or "Killer" end
    end,
})
GbToF:AddDropdown("TOF_Key_DD", {
    Text = "Silent Aim Key",
    Values = {"None","Q","E","R","T","F","G","H","J","K","L","X","Z"},
    Default = "None",
    Callback = function(v) VD.TOF_Key = v or "None" end,
})

-- =====================================================
-- AIM: FLASHLIGHT
-- =====================================================
GbFlashlight:AddToggle("FLASH_SilentAim_Toggle", { Text = "Silent Aim Flashlight", Default = false, Callback = function(v)
    if getgenv().KYS_SetFlashlightSilentAim then getgenv().KYS_SetFlashlightSilentAim(v) else VD.FLASH_SilentAim = v end
end })
GbFlashlight:AddToggle("FLASH_Laser_Toggle", { Text = "Flashlight Laser", Default = true, Callback = function(v)
    VD.FLASH_Laser = v; if not v and getgenv().KYS_ClearFlashlightLaser then getgenv().KYS_ClearFlashlightLaser() end
end })
GbFlashlight:AddDropdown("FLASH_TargetPart_DD", {
    Text = "Target Part",
    Values = {"Head","HumanoidRootPart","UpperTorso","Torso"},
    Default = "Head",
    Callback = function(v) VD.FLASH_TargetPart = v or "Head" end,
})
GbFlashlight:AddSlider("FLASH_Range_Slider",  { Text = "Range",       Default = 120,  Min = 20,   Max = 250, Rounding = 0,  Callback = function(v) VD.FLASH_Range  = v end })
GbFlashlight:AddSlider("FLASH_Smooth_Slider", { Text = "Smoothness",  Default = 0.35, Min = 0.05, Max = 1,   Rounding = 2,  Callback = function(v) VD.FLASH_Smooth = v end })

-- =====================================================
-- MAPPING: RADAR
-- =====================================================
GbRadar:AddToggle("RADAR_Toggle",           { Text = "Enable Radar",       Default = false, Callback = function(v) VD.RADAR_Enabled = v end })
GbRadar:AddSlider("RADAR_Size_Slider",      { Text = "Radar Size",         Default = 150, Min = 50,  Max = 400, Rounding = 0, Callback = function(v) VD.RADAR_Size  = v end })
GbRadar:AddSlider("RADAR_Range_Slider",     { Text = "Radar Range",        Default = 250, Min = 50,  Max = 1000,Rounding = 0, Callback = function(v) VD.RADAR_Range = v end })
GbRadar:AddSlider("RADAR_Transp_Slider",    { Text = "Transparency",       Default = 0.2, Min = 0,   Max = 1,   Rounding = 2, Callback = function(v) VD.RADAR_Transparency = v end })
GbRadar:AddToggle("RADAR_Circle_Toggle",    { Text = "Circle Shape",       Default = false, Callback = function(v) VD.RADAR_Circle = v end })
GbRadar:AddDivider()
GbRadar:AddToggle("RADAR_Killer_Toggle",    { Text = "Show Killer",        Default = false, Callback = function(v) VD.RADAR_ShowKiller    = v end })
GbRadar:AddToggle("RADAR_Surv_Toggle",      { Text = "Show Survivor",      Default = false, Callback = function(v) VD.RADAR_ShowSurvivor  = v end })
GbRadar:AddToggle("RADAR_Gen_Toggle",       { Text = "Show Generator",     Default = false, Callback = function(v) VD.RADAR_ShowGenerator = v end })
GbRadar:AddToggle("RADAR_Pallet_Toggle",    { Text = "Show Pallet",        Default = false, Callback = function(v) VD.RADAR_ShowPallet    = v end })
GbRadar:AddToggle("RADAR_Hook_Toggle",      { Text = "Show Hook",          Default = false, Callback = function(v) VD.RADAR_ShowHook      = v end })
GbRadar:AddToggle("RADAR_Gate_Toggle",      { Text = "Show Gate",          Default = false, Callback = function(v) VD.RADAR_ShowGate      = v end })
GbRadar:AddToggle("RADAR_Window_Toggle",    { Text = "Show Window",        Default = false, Callback = function(v) VD.RADAR_ShowWindow    = v end })
GbRadar:AddToggle("RADAR_Zombie_Toggle",    { Text = "Show Zombie/SCP",    Default = false, Callback = function(v) VD.RADAR_ShowZombie    = v end })

-- =====================================================
-- PLAYER: MOVEMENT
-- =====================================================
GbMovement:AddToggle("AutoCrouch_Toggle",   { Text = "Auto Crouch BETA",     Default = false, Callback = function(v) setAutoCrouch(v) end })
GbMovement:AddToggle("Speed_Toggle",        { Text = "Speed Hack",           Default = false, Callback = function(v)
    VD.Speed = v; if not v then local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if h then pcall(function() h.WalkSpeed=16 end) end end
end })
GbMovement:AddSlider("SpeedValue_Slider",   { Text = "Speed Value",          Default = 16,  Min = 16, Max = 200, Rounding = 0, Callback = function(v) VD.SpeedValue = v end })
GbMovement:AddToggle("Jump_Toggle",         { Text = "Jump Hack",            Default = false, Callback = function(v)
    VD.Jump = v; if not v then local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if h then pcall(function() h.JumpPower=0 end) end end
end })
GbMovement:AddSlider("JumpValue_Slider",    { Text = "Jump Power",           Default = 50,  Min = 50, Max = 300, Rounding = 0, Callback = function(v) VD.JumpValue = v end })
GbMovement:AddToggle("InfiniteJump_Toggle", { Text = "Infinite Jump",        Default = false, Callback = function(v) VD.InfiniteJump = v end })
GbMovement:AddToggle("AntiFallDmg_Toggle",  { Text = "Anti Fall Damage",     Default = false, Callback = function(v) VD.AntiFallDamage = v end })
GbMovement:AddToggle("Noclip_Toggle",       { Text = "Noclip",               Default = false, Callback = function(v)
    VD.Noclip = v; if not v and getgenv().VD_DisableNoclip then pcall(getgenv().VD_DisableNoclip) end
end })
GbMovement:AddToggle("Moonwalk_Toggle",     { Text = "Moonwalk",             Default = false, Callback = function(v)
    if getgenv().VD_SetMoonwalkButtonVisible then getgenv().VD_SetMoonwalkButtonVisible(v) else VD.MoonwalkButton = v end
end })
GbMovement:AddToggle("MoonwalkLock_Toggle", { Text = "Lock Moonwalk Button", Default = false, Callback = function(v) VD.MoonwalkButtonLocked = v end })
GbMovement:AddSlider("MoonwalkZigzag_Slider",{ Text = "Moonwalk Zigzag Speed",Default = 11, Min = 1, Max = 30, Rounding = 0, Callback = function(v) VD.MoonwalkZigzagSpeed = v end })
GbMovement:AddSlider("MoonwalkBoost_Slider", { Text = "Moonwalk Boost Power", Default = 1.08, Min = 1, Max = 2, Rounding = 2, Callback = function(v) VD.MoonwalkBoostPower = v end })
GbMovement:AddToggle("Invisible_Toggle",    { Text = "Invisible Not Visual", Default = false, Callback = function(v)
    VD.InvisibleNotVisual = v; if not v and VD_InvisibleNV and VD_InvisibleNV.Active then pcall(VD_SetInvisibleNotVisual, false) end
end })
GbMovement:AddSlider("InvisibleSpeed_Slider",{ Text = "Invisible Speed",      Default = 5, Min = 1, Max = 999, Rounding = 0, Callback = function(v) VD.InvisibleSpeed = v end })
GbMovement:AddToggle("AntiAFK_Toggle",      { Text = "Anti AFK",             Default = false, Callback = function(v) VD.AntiAFK = v end })

-- =====================================================
-- PLAYER: FLING
-- =====================================================
GbFling:AddToggle("Fling_Toggle",    { Text = "Enable Fling", Default = false, Callback = function(v) VD.FLING_Enabled = v end })
GbFling:AddSlider("FlingStr_Slider", { Text = "Fling Strength", Default = 10000, Min = 1000, Max = 50000, Rounding = 0, Callback = function(v) VD.FLING_Strength = v end })
GbFling:AddButton({ Text = "Fling Nearest", Func = function() pcall(KYS_FlingNearest) end })
GbFling:AddButton({ Text = "Fling All",     Func = function() pcall(KYS_FlingAll) end })

-- =====================================================
-- SETTINGS: MENU
-- =====================================================
GbMenu:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu Keybind",
})
GbMenu:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame and Library.KeybindFrame.Visible or false,
    Text = "Open Keybind Menu",
    Callback = function(v) if Library.KeybindFrame then Library.KeybindFrame.Visible = v end end,
})
GbMenu:AddButton({ Text = "Unload", Func = function() Library:Unload() end })

Library.ToggleKeybind = Options.MenuKeybind

-- Addons
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("KysHubVD")
SaveManager:SetFolder("KysHubVD")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToGroupbox(Tabs.Settings:AddGroupbox({ Side = "Right", Name = "Theme" }))
SaveManager:LoadAutoloadConfig()

-- =============================================
-- PATCH: DISABLE PREMIUM LOCK (append to end)
-- =============================================
local function KillPremium()
    -- 1. Block all Premium notifications
    local oldNotify = VD_Notify
    VD_Notify = function(title, content, duration)
        if content and tostring(content):find("Premium") then return end
        if oldNotify then oldNotify(title, content, duration) end
    end

    -- 2. Hook UI element creation, remove Locked/TextLocked
    local mt = getrawmetatable(game)
    if mt then
        local oldIndex = mt.__index
        local oldNewIndex = mt.__newindex
        local blocked = { Locked = true, TextLocked = true }

        setreadonly(mt, false)
        mt.__index = function(t, k)
            if blocked[k] and type(t) == "table" and t.Name and t.Name:find("Premium") then
                return nil
            end
            return oldIndex(t, k)
        end

        mt.__newindex = function(t, k, v)
            if blocked[k] and type(t) == "table" then
                return -- block write
            end
            return oldNewIndex(t, k, v)
        end
        setreadonly(mt, true)
    end

    -- 3. Disable the check in handler functions
    --    (via __call metamethod hook - complex, not needed)
    print("[KysHub] Premium restrictions disabled.")
end


-- Runtime sync loop (ToF / Flashlight config sync)
task.spawn(function()
    local lastToF, lastFlash = nil, nil
    while getgenv().VD and not getgenv().VD.Destroyed do
        local tofVal   = Toggles.TOF_SilentAim_Toggle and Toggles.TOF_SilentAim_Toggle.Value
        local flashVal = Toggles.FLASH_SilentAim_Toggle and Toggles.FLASH_SilentAim_Toggle.Value

        if type(tofVal) == "boolean" and tofVal ~= lastToF then
            lastToF = tofVal
            if getgenv().KYS_SetToFSilentAim then pcall(getgenv().KYS_SetToFSilentAim, tofVal)
            else VD.TOF_SilentAim = tofVal end
        end

        if type(flashVal) == "boolean" and flashVal ~= lastFlash then
            lastFlash = flashVal
            if getgenv().KYS_SetFlashlightSilentAim then pcall(getgenv().KYS_SetFlashlightSilentAim, flashVal)
            else VD.FLASH_SilentAim = flashVal end
        end

        task.wait(1)
    end
end)
end

__KysHub_Init_Main__()
