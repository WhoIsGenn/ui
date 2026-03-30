-- ================================================================
-- VICTORIA HUB | VIOLENCE DISTRICT
-- Rebuilt: ESP base from esp.lua + All features from tesvide.lua
-- ================================================================

-- ================================================================
-- DRAWING SAFETY
-- ================================================================
local function SafeDrawing(t)
    local ok, r = pcall(function() return Drawing.new(t) end)
    return ok and r or nil
end

local function SafeRemove(obj)
    if obj and obj.Remove then pcall(function() obj:Remove() end) end
end

if not Drawing or not Drawing.new then
    local waited = 0
    while not Drawing and waited < 5 do task.wait(0.1); waited += 0.1 end
    if not Drawing then warn("[VH] Drawing not available."); return end
end

-- ================================================================
-- SERVICES
-- ================================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")
local GuiService       = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer      = Players.LocalPlayer

-- ================================================================
-- CONFIG
-- ================================================================
local Config = {
    ESP_Enabled      = true,
    ESP_Killer       = false,
    ESP_Survivor     = false,
    ESP_Generator    = false,
    ESP_Gate         = false,
    ESP_Hook         = false,
    ESP_Pallet       = false,
    ESP_Window       = false,
    ESP_Offscreen    = true,
    ESP_ClosestHook  = false,
    ESP_MaxDist      = 200,
    ESP_Names        = true,
    ESP_Distance     = true,
    ESP_Health       = false,
    ESP_Skeleton     = false,
    ESP_Velocity     = false,
    ESP_PlayerChams  = true,
    ESP_ObjectChams  = true,
    RADAR_Enabled    = false,
    RADAR_Size       = 120,
    RADAR_Circle     = false,
    RADAR_Killer     = false,
    RADAR_Survivor   = false,
    RADAR_Generator  = false,
    RADAR_Pallet     = false,
    AUTO_Generator   = false,
    AUTO_GenMode     = "Fast",
    AUTO_LeaveGen    = false,
    AUTO_LeaveDist   = 18,
    AUTO_Attack      = false,
    AUTO_AttackRange = 12,
    HITBOX_Enabled   = false,
    HITBOX_Size      = 15,
    AUTO_TeleAway    = false,
    AUTO_TeleAwayDist= 40,
    AUTO_Parry       = false,
    PARRY_Mode       = "With Animation",
    PARRY_Dist       = 13,
    PARRY_FOV        = false,
    ANTI_SkillCheck  = false,
    PERFECT_SkillCheck = false,
    SURV_NoFall      = false,
    SURV_GodMode     = false,
    SURV_AutoWiggle  = false,
    KILLER_DestroyPallets  = false,
    KILLER_FullGenBreak    = false,
    KILLER_NoPalletStun    = false,
    KILLER_AutoHook        = false,
    KILLER_AntiBlind       = false,
    KILLER_NoSlowdown      = false,
    KILLER_DoubleTap       = false,
    KILLER_InfiniteLunge   = false,
    SPEED_Enabled    = false,
    SPEED_Value      = 32,
    SPEED_Method     = "Attribute",
    NOCLIP_Enabled   = false,
    FLY_Enabled      = false,
    FLY_Speed        = 50,
    FLY_Method       = "CFrame",
    JUMP_Power       = 50,
    JUMP_Infinite    = false,
    NO_Fog           = false,
    FULLBRIGHT       = false,
    CAM_FOVEnabled   = false,
    CAM_FOV          = 90,
    CAM_ThirdPerson  = false,
    FLING_Enabled    = false,
    FLING_Strength   = 10000,
    BEAT_Survivor    = false,
    BEAT_Killer      = false,
    TP_Offset        = 3,
    MENU_Open        = true,
    MENU_Tab         = 1,
    KEY_Menu         = Enum.KeyCode.Insert,
    KEY_Panic        = Enum.KeyCode.Home,
    KEY_LeaveGen     = Enum.KeyCode.Q,
    KEY_StopGen      = Enum.KeyCode.X,
    KEY_TP_Gen       = Enum.KeyCode.G,
    KEY_TP_Gate      = Enum.KeyCode.T,
    KEY_TP_Hook      = Enum.KeyCode.H,
    KEY_Speed        = Enum.KeyCode.C,
    KEY_Noclip       = Enum.KeyCode.V,
    KEY_Fly          = Enum.KeyCode.F,
    AIM_Enabled      = false,
    AIM_AutoMode     = false,
    AIM_TargetMode   = "Auto",
    AIM_FOV          = 120,
    AIM_Smooth       = 0.3,
    AIM_TargetPart   = "Left Arm",
    AIM_VisCheck     = true,
    AIM_ShowFOV      = false,
    AIM_Crosshair    = false,
    AIM_Predict      = true,
    SPEAR_Aimbot     = false,
    SPEAR_Gravity    = 50,
    SPEAR_Speed      = 100,
}

local Tuning = {
    ESP_RefreshRate  = 0.05,
    ESP_VisCheckRate = 0.15,
    Gen_RefreshRate  = 0.2,
    CacheRefreshRate = 1.0,
    Offscreen_Edge   = 50,
    Offscreen_Size   = 12,
    Skel_Thickness   = 1,
    RadarRange       = 150,
    RadarDotSize     = 5,
    RadarArrowSize   = 8,
}

-- ================================================================
-- ESP COLORS
-- GENE: OREN | DONE: HIJAU | PALLET: KUNING | KILLER: MERAH
-- SURVIVOR: HIJAU/BIRU | WINDOW: ABU | HOOK: MERAH | GATE: PUTIH
-- ================================================================
local ESPColors = {
    Killer        = Color3.fromRGB(255, 60, 60),
    Survivor      = Color3.fromRGB(64, 224, 128),
    Generator     = Color3.fromRGB(255, 140, 0),
    GeneratorDone = Color3.fromRGB(0, 220, 80),
    Gate          = Color3.fromRGB(240, 240, 240),
    Hook          = Color3.fromRGB(220, 50, 50),
    Pallet        = Color3.fromRGB(230, 200, 40),
    Window        = Color3.fromRGB(170, 170, 175),
}

-- ================================================================
-- STATE & CACHE
-- ================================================================
local State = {
    Unloaded           = false,
    OriginalSpeed      = 16,
    LastTeleAway       = 0,
    LastCacheUpdate    = 0,
    LastVisCheck       = 0,
    LastESPUpdate      = 0,
    LastFogState       = nil,
    KillerTarget       = nil,
    AimHolding         = false,
    AimTarget          = nil,
    BeatSurvivorDone   = false,
    LastFinishPos      = nil,
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
-- UTILITY
-- ================================================================
local function GetCharacterRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetRole()
    local team = LocalPlayer.Team
    if team then
        local n = team.Name:lower()
        if n:find("killer")    then return "Killer"   end
        if n:find("survivor")  then return "Survivor" end
        if n:find("spectator") then return "Spectator" end
    end
    local char = LocalPlayer.Character
    if char then
        local attr = char:GetAttribute("Role") or char:GetAttribute("Team")
        if attr then return attr end
    end
    return "Spectator"
end

local function IsKiller(player)
    if not player then return false end
    local team = player.Team
    if team then
        local n = team.Name:lower()
        if n:find("killer")   then return true end
        if n:find("survivor") then return false end
    end
    local char = player.Character
    if char then
        local attr = char:GetAttribute("Role") or char:GetAttribute("Team")
        if attr then return attr == "Killer" end
    end
    return false
end

local function IsSurvivor(player)
    if not player or player == LocalPlayer then return false end
    return not IsKiller(player)
end

local function IsVisible(character)
    if not character then return false end
    local root   = character:FindFirstChild("HumanoidRootPart")
    local myRoot = GetCharacterRoot()
    if not root or not myRoot then return false end
    local cam = Workspace.CurrentCamera
    if not cam then return false end
    local origin = myRoot.Position
    local dir    = root.Position - origin
    local ray    = Ray.new(origin, dir.Unit * math.min(dir.Magnitude, 600))
    local hit    = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, character})
    return hit == nil
end

local function WorldToScreen(pos)
    local cam = Workspace.CurrentCamera
    if not cam then return Vector2.new(0,0), false end
    local sp, onScreen = cam:WorldToScreenPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen and sp.Z > 0
end

local function GetHealthPercent(hum)
    if not hum or hum.MaxHealth <= 0 then return 0 end
    return hum.Health / hum.MaxHealth
end

local function IsPlayerDowned(hum)
    local p = GetHealthPercent(hum)
    return p <= 0.25 and p > 0
end

local function IsPlayerAlive(hum)
    return GetHealthPercent(hum) > 0.25
end

-- ================================================================
-- HIGHLIGHT HELPERS
-- ================================================================
local function ApplyHighlight(obj, color, fillTrans, outTrans)
    if not obj or not obj.Parent then return end
    fillTrans = fillTrans or 0.65
    outTrans  = outTrans  or 0.0
    local h = obj:FindFirstChild("_VHLight")
    if not h then
        h = Instance.new("Highlight")
        h.Name    = "_VHLight"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = obj
        h.Parent  = obj
    end
    h.FillColor         = color
    h.OutlineColor      = color
    h.FillTransparency  = fillTrans
    h.OutlineTransparency = outTrans
end

local function RemoveHighlight(obj)
    if not obj then return end
    local h = obj:FindFirstChild("_VHLight")
    if h then h:Destroy() end
end

local function ESPClearAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            local h = obj:FindFirstChild("_VHLight");  if h then h:Destroy() end
            local t = obj:FindFirstChild("_VHTag");    if t then t:Destroy() end
            local g = obj:FindFirstChild("_VHGenTag"); if g then g:Destroy() end
        end)
    end
end

-- ================================================================
-- NAMETAG (di atas kepala - StudsOffset ke atas dari HRP)
-- ================================================================
local function UpdatePlayerNametag(player)
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hrp then return end

    local old = hrp:FindFirstChild("_VHTag")
    if old then old:Destroy() end

    local killer    = IsKiller(player)
    local baseColor = killer and ESPColors.Killer or ESPColors.Survivor

    local knocked = player.Character:GetAttribute("Knocked")
        or (player.Character:FindFirstChild("Knocked") and player.Character.Knocked.Value)
    local hooked  = player.Character:GetAttribute("IsHooked")
        or (player.Character:FindFirstChild("IsHooked") and player.Character.IsHooked.Value)

    local displayColor = baseColor
    if hooked then
        displayColor = Color3.fromRGB(255, 182, 193)
    elseif hum and hum.Health < hum.MaxHealth then
        displayColor = knocked and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(230, 220, 0)
    end

    local dist = 0
    local myRoot = GetCharacterRoot()
    if myRoot then
        dist = math.floor((hrp.Position - myRoot.Position).Magnitude)
    end

    local lines = {}
    if Config.ESP_Names    then table.insert(lines, player.Name) end
    if Config.ESP_Distance then table.insert(lines, "[" .. dist .. "m]") end
    if Config.ESP_Health and hum then
        table.insert(lines, "HP: " .. math.floor(GetHealthPercent(hum)*100) .. "%")
    end

    if #lines == 0 then return end

    local b = Instance.new("BillboardGui")
    b.Name        = "_VHTag"
    b.AlwaysOnTop = true
    b.Size        = UDim2.new(0, 130, 0, 36)
    b.StudsOffset = Vector3.new(0, 3.2, 0)  -- Di atas kepala
    b.Adornee     = hrp
    b.Parent      = hrp

    local t = Instance.new("TextLabel")
    t.Size                   = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text                   = table.concat(lines, "\n")
    t.TextColor3             = displayColor
    t.TextStrokeTransparency = 0
    t.TextStrokeColor3       = Color3.new(0,0,0)
    t.Font                   = Enum.Font.GothamBold
    t.TextSize               = 11
    t.TextWrapped            = true
    t.Parent                 = b
end

-- ================================================================
-- GENERATOR PROGRESS (warna oren->hijau, done = full hijau)
-- ================================================================
local ESPGenerators  = {}

local function UpdateGeneratorProgress(gen)
    if not gen or not gen.Parent then return true end
    local pv = gen:FindFirstChild("RepairProgress")
        or gen:GetAttribute("RepairProgress")
        or gen:FindFirstChild("Progress")
        or gen:GetAttribute("Progress")
    local p = pv and (typeof(pv) == "Instance" and pv.Value or pv) or 0

    local old = gen:FindFirstChild("_VHGenTag")
    if old then old:Destroy() end

    if p >= 100 then
        -- Generator selesai: highlight HIJAU
        if Config.ESP_Generator then
            ApplyHighlight(gen, ESPColors.GeneratorDone, 0.45, 0)
        end
        return true
    end

    -- Warna interpolasi: OREN (0%) -> HIJAU (100%)
    local cl = math.clamp(p, 0, 100)
    local genColor = cl < 50
        and ESPColors.Generator:Lerp(Color3.fromRGB(200, 200, 0), cl / 50)
        or Color3.fromRGB(200, 200, 0):Lerp(ESPColors.GeneratorDone, (cl - 50) / 50)

    if Config.ESP_Generator then
        ApplyHighlight(gen, genColor, 0.5, 0)
    end

    -- Billboard progress label
    local adornee = gen:FindFirstChild("defaultMaterial", true) or gen:FindFirstChildWhichIsA("BasePart") or gen
    local b = Instance.new("BillboardGui")
    b.Name        = "_VHGenTag"
    b.AlwaysOnTop = true
    b.Size        = UDim2.new(0, 90, 0, 22)
    b.StudsOffset = Vector3.new(0, 3, 0)
    b.Adornee     = adornee
    b.Parent      = gen

    local t = Instance.new("TextLabel")
    t.Size                   = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text                   = string.format("%.1f%%", p)
    t.TextColor3             = genColor
    t.TextStrokeTransparency = 0
    t.TextStrokeColor3       = Color3.new(0,0,0)
    t.Font                   = Enum.Font.GothamBold
    t.TextSize               = 11
    t.Parent                 = b

    return false
end

-- ================================================================
-- ESP REFRESH MAP
-- ================================================================
local function ESPRefreshMap()
    ESPGenerators = {}
    local Map = workspace:FindFirstChild("Map")

    -- Windows (seluruh workspace)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Window" then
            if Config.ESP_Window then ApplyHighlight(obj, ESPColors.Window, 0.55, 0)
            else RemoveHighlight(obj) end
        end
    end

    if not Map then return end

    for _, obj in ipairs(Map:GetDescendants()) do
        local n = obj.Name
        if n == "Generator" then
            if Config.ESP_Generator then ApplyHighlight(obj, ESPColors.Generator, 0.5, 0)
            else RemoveHighlight(obj) end
            table.insert(ESPGenerators, obj)

        elseif n == "Hook" then
            if Config.ESP_Hook then
                local m = obj:FindFirstChild("Model")
                if m then
                    for _, p in ipairs(m:GetDescendants()) do
                        if p:IsA("MeshPart") then ApplyHighlight(p, ESPColors.Hook, 0.5, 0) end
                    end
                else
                    ApplyHighlight(obj, ESPColors.Hook, 0.5, 0)
                end
            else RemoveHighlight(obj) end

        elseif n == "Palletwrong" or n == "Pallet" then
            if Config.ESP_Pallet then ApplyHighlight(obj, ESPColors.Pallet, 0.55, 0)
            else RemoveHighlight(obj) end

        elseif n == "Gate" then
            if Config.ESP_Gate then ApplyHighlight(obj, ESPColors.Gate, 0.6, 0)
            else RemoveHighlight(obj) end
        end
    end
end

-- ================================================================
-- ESP UPDATE PLAYERS
-- ================================================================
local function ESPUpdatePlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local killer = IsKiller(player)

        if killer then
            if Config.ESP_Killer then
                ApplyHighlight(char, ESPColors.Killer, 0.6, 0)
                UpdatePlayerNametag(player)
            else
                RemoveHighlight(char)
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then local t=hrp:FindFirstChild("_VHTag"); if t then t:Destroy() end end
            end
        else
            if Config.ESP_Survivor then
                ApplyHighlight(char, ESPColors.Survivor, 0.6, 0)
                UpdatePlayerNametag(player)
            else
                RemoveHighlight(char)
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then local t=hrp:FindFirstChild("_VHTag"); if t then t:Destroy() end end
            end
        end
    end
end

-- ================================================================
-- SCAN MAP
-- ================================================================
local function ScanMap()
    local newG, newGa, newH, newP, newW = {}, {}, {}, {}, {}
    local Map = Workspace:FindFirstChild("Map")
    if not Map then
        Cache.Generators=newG; Cache.Gates=newGa; Cache.Hooks=newH; Cache.Pallets=newP; Cache.Windows=newW
        return
    end
    for _, obj in ipairs(Map:GetDescendants()) do
        local n = obj.Name
        if n == "Generator" and obj:IsA("Model") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(newG, {model=obj, part=part}) end
        elseif n == "Gate" and obj:IsA("Model") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(newGa, {model=obj, part=part}) end
        elseif n == "Hook" then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(newH, {model=obj, part=part}) end
        elseif n == "Pallet" or n == "Palletwrong" then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(newP, {model=obj, part=part}) end
        elseif n == "Window" then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(newW, {model=obj, part=part}) end
        end
    end
    Cache.Generators=newG; Cache.Gates=newGa; Cache.Hooks=newH; Cache.Pallets=newP; Cache.Windows=newW
    local root = GetCharacterRoot()
    if root and #newH > 0 then
        local closest, cd = nil, math.huge
        for _, hook in ipairs(newH) do
            if hook.part then
                local d = (hook.part.Position - root.Position).Magnitude
                if d < cd then cd=d; closest=hook end
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

-- ================================================================
-- PERFECT SKILL CHECK
-- ================================================================
local PerfectSC_HBConn  = nil
local PerfectSC_VisConn = nil
local touchId    = 8822
local ActionPath = "Survivor-mob.Controls.action.check"

local function GetActionTarget(PG)
    local cur = PG
    for s in string.gmatch(ActionPath, "[^%.]+") do cur = cur and cur:FindFirstChild(s) end
    return cur
end

local function TriggerMobileButton(PG)
    local b = GetActionTarget(PG)
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, GuiService:GetGuiInset()
        local cx, cy = p.X + s.X/2 + i.X, p.Y + s.Y/2 + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(touchId, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(touchId, 2, cx, cy)
        end)
    end
end

local function PerfectSC_Setup()
    task.spawn(function()
        local PG = LocalPlayer:WaitForChild("PlayerGui", 10)
        local CG = PG and PG:WaitForChild("SkillCheckPromptGui", 10)
        local C  = CG and CG:WaitForChild("Check")
        if not C then return end
        local L, G = C:WaitForChild("Line"), C:WaitForChild("Goal")

        local function inGoal()
            local lr, gr = L.Rotation%360, G.Rotation%360
            local gs, ge = (gr+101)%360, (gr+115)%360
            return gs > ge and (lr >= gs or lr <= ge) or (lr >= gs and lr <= ge)
        end

        local function onHB()
            if not Config.PERFECT_SkillCheck then
                if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn=nil end; return
            end
            if LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors" then
                if inGoal() then
                    TriggerMobileButton(PG)
                    if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn=nil end
                end
            else
                if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn=nil end
            end
        end

        if PerfectSC_VisConn then PerfectSC_VisConn:Disconnect() end
        PerfectSC_VisConn = C:GetPropertyChangedSignal("Visible"):Connect(function()
            if not Config.PERFECT_SkillCheck then return end
            if LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors" then
                if C.Visible then
                    if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect() end
                    PerfectSC_HBConn = RunService.Heartbeat:Connect(onHB)
                elseif PerfectSC_HBConn then
                    PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn=nil
                end
            end
        end)
    end)
end

local function PerfectSC_Stop()
    if PerfectSC_HBConn  then PerfectSC_HBConn:Disconnect();  PerfectSC_HBConn=nil end
    if PerfectSC_VisConn then PerfectSC_VisConn:Disconnect(); PerfectSC_VisConn=nil end
end

-- ================================================================
-- ANTI SKILL CHECK
-- ================================================================
local AntiSCConns = {}
local function AntiScript_Apply(char)
    for _, c in pairs(AntiSCConns) do pcall(function() c:Disconnect() end) end
    AntiSCConns = {}
    local PG = LocalPlayer:FindFirstChild("PlayerGui")
    if not PG then return end
    local CG = PG:FindFirstChild("SkillCheckPromptGui")
    if not CG then return end
    local C = CG:FindFirstChild("Check")
    if not C then return end
    table.insert(AntiSCConns, C:GetPropertyChangedSignal("Visible"):Connect(function()
        if Config.ANTI_SkillCheck and C.Visible then C.Visible = false end
    end))
end

local function AntiScript_Restore()
    for _, c in pairs(AntiSCConns) do pcall(function() c:Disconnect() end) end
    AntiSCConns = {}
end

-- ================================================================
-- FOG
-- ================================================================
local FogCache = {}
local function RemoveFog()
    local L = game:GetService("Lighting")
    for _, obj in ipairs(L:GetChildren()) do
        if obj:IsA("Atmosphere") or obj:IsA("FogEffect") or obj:IsA("BlurEffect") then
            FogCache[obj] = {Parent=obj.Parent}; obj.Parent=nil
        end
    end
    pcall(function()
        if L.FogEnd < 9e8 then FogCache._FogEnd=L.FogEnd; FogCache._FogStart=L.FogStart end
        L.FogEnd=9e8; L.FogStart=9e8
    end)
end

local function RestoreFog()
    local L = game:GetService("Lighting")
    for obj, data in pairs(FogCache) do
        if typeof(obj) == "Instance" then pcall(function() obj.Parent=data.Parent end) end
    end
    if FogCache._FogEnd then
        pcall(function() L.FogEnd=FogCache._FogEnd; L.FogStart=FogCache._FogStart end)
    end
    FogCache = {}
end

-- ================================================================
-- FULLBRIGHT
-- ================================================================
local OrigAmbient, OrigOutdoor, OrigBrightness
local function Fullbright_On()
    local L=game:GetService("Lighting")
    OrigAmbient=L.Ambient; OrigOutdoor=L.OutdoorAmbient; OrigBrightness=L.Brightness
    L.Ambient=Color3.new(1,1,1); L.OutdoorAmbient=Color3.new(1,1,1); L.Brightness=2
end
local function Fullbright_Off()
    local L=game:GetService("Lighting")
    if OrigAmbient    then L.Ambient=OrigAmbient end
    if OrigOutdoor    then L.OutdoorAmbient=OrigOutdoor end
    if OrigBrightness then L.Brightness=OrigBrightness end
end

-- ================================================================
-- TELEPORT
-- ================================================================
local function TeleportToGenerator(index)
    local root=GetCharacterRoot(); if not root then return end
    if #Cache.Generators==0 then return end
    local g = Cache.Generators[math.clamp(index or 1, 1, #Cache.Generators)]
    if g and g.part then root.CFrame=CFrame.new(g.part.Position+Vector3.new(0,Config.TP_Offset,0)) end
end

local function TeleportToGate()
    local root=GetCharacterRoot(); if not root then return end
    if #Cache.Gates==0 then return end
    local g=Cache.Gates[1]
    if g and g.part then root.CFrame=CFrame.new(g.part.Position+Vector3.new(0,Config.TP_Offset,0)) end
end

local function TeleportToHook()
    local root=GetCharacterRoot(); if not root then return end
    if Cache.ClosestHook and Cache.ClosestHook.part then
        root.CFrame=CFrame.new(Cache.ClosestHook.part.Position+Vector3.new(0,Config.TP_Offset,0))
    end
end

local function LeaveGenerator()
    local root=GetCharacterRoot(); if not root then return end
    root.CFrame = root.CFrame * CFrame.new(0,0,-Config.AUTO_LeaveDist)
end

local function StopAutoGen() Config.AUTO_Generator=false end

-- ================================================================
-- MOVEMENT
-- ================================================================
local FlyBodyVelocity, FlyBodyGyro
local OriginalJumpPower = 50
local InfiniteJumpConnection = nil

local function UpdateSpeed()
    if not Config.SPEED_Enabled then return end
    local char=LocalPlayer.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    if Config.SPEED_Method=="Attribute" then
        pcall(function() char:SetAttribute("WalkSpeed",Config.SPEED_Value) end)
    end
    hum.WalkSpeed=Config.SPEED_Value
end

local function UpdateNoclip()
    local char=LocalPlayer.Character; if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not Config.NOCLIP_Enabled end
    end
end

local function UpdateFly()
    local char=LocalPlayer.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if Config.FLY_Enabled then
        hum.PlatformStand=true
        if not FlyBodyVelocity then
            FlyBodyVelocity=Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce=Vector3.new(1e9,1e9,1e9)
            FlyBodyVelocity.Parent=root
        end
        if not FlyBodyGyro then
            FlyBodyGyro=Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque=Vector3.new(1e9,1e9,1e9)
            FlyBodyGyro.P=1e4; FlyBodyGyro.Parent=root
        end
        local cam=Workspace.CurrentCamera
        local dir=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)      then dir=dir+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)  then dir=dir-Vector3.new(0,1,0) end
        FlyBodyVelocity.Velocity=dir.Magnitude>0 and dir.Unit*Config.FLY_Speed or Vector3.zero
        FlyBodyGyro.CFrame=cam.CFrame
    else
        if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity=nil end
        if FlyBodyGyro     then FlyBodyGyro:Destroy();     FlyBodyGyro=nil end
        pcall(function() hum.PlatformStand=false end)
    end
end

local function UpdateJumpPower()
    local char=LocalPlayer.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.JumpPower=Config.JUMP_Power
end

local function SetupInfiniteJump()
    if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
    InfiniteJumpConnection=UserInputService.JumpRequest:Connect(function()
        if not Config.JUMP_Infinite then return end
        local char=LocalPlayer.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

-- ================================================================
-- COMBAT / MISC FEATURES
-- ================================================================
local function AutoAttack()
    if not Config.AUTO_Attack then return end
    local root=GetCharacterRoot(); if not root then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart")
            if tr and (tr.Position-root.Position).Magnitude <= Config.AUTO_AttackRange then
                pcall(function()
                    local r=ReplicatedStorage:FindFirstChild("Remotes")
                    local a=r and r:FindFirstChild("Attacks")
                    local ba=a and a:FindFirstChild("BasicAttack")
                    if ba then ba:FireServer(false) end
                end)
            end
        end
    end
end

local function TeleportAway()
    if not Config.AUTO_TeleAway then return end
    if GetRole()~="Survivor" then return end
    local now=tick()
    if now-State.LastTeleAway<3 then return end
    local root=GetCharacterRoot(); if not root then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsKiller(p) and p.Character then
            local kr=p.Character:FindFirstChild("HumanoidRootPart")
            if kr and (kr.Position-root.Position).Magnitude < Config.AUTO_TeleAwayDist then
                root.CFrame=root.CFrame*CFrame.new(0,0,-Config.AUTO_TeleAwayDist)
                State.LastTeleAway=now; break
            end
        end
    end
end

local function UpdateNoFall()
    if not Config.SURV_NoFall then return end
    local char=LocalPlayer.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower=Config.JUMP_Power end
end

local GodModeConn=nil
local function GodMode_Start()
    if GodModeConn then GodModeConn:Disconnect() end
    GodModeConn=RunService.Heartbeat:Connect(function()
        if not Config.SURV_GodMode then GodModeConn:Disconnect(); GodModeConn=nil; return end
        local char=LocalPlayer.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
    end)
end

local function GodMode_Stop()
    if GodModeConn then GodModeConn:Disconnect(); GodModeConn=nil end
end

local function UpdateNoSlowdown()
    if not Config.KILLER_NoSlowdown then return end
    local char=LocalPlayer.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed<16 then hum.WalkSpeed=16 end
end

local OriginalHitboxSizes={}
local function UpdateHitboxes()
    if not Config.HITBOX_Enabled then
        for player, sizes in pairs(OriginalHitboxSizes) do
            pcall(function()
                if player and player.Character then
                    local r=player.Character:FindFirstChild("HumanoidRootPart")
                    if r then r.Size=sizes end
                end
            end)
        end
        OriginalHitboxSizes={}; return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r=p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                if not OriginalHitboxSizes[p] then OriginalHitboxSizes[p]=r.Size end
                r.Size=Vector3.new(Config.HITBOX_Size,Config.HITBOX_Size,Config.HITBOX_Size)
            end
        end
    end
end

local function FlingNearest()
    local root=GetCharacterRoot(); if not root then return end
    local closest,cd=nil,math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local pr=p.Character:FindFirstChild("HumanoidRootPart")
            if pr then
                local d=(pr.Position-root.Position).Magnitude
                if d<cd then cd=d; closest=p end
            end
        end
    end
    if not closest then return end
    local orig=root.CFrame
    local tr=closest.Character:FindFirstChild("HumanoidRootPart")
    if tr then
        for i=1,5 do
            root.CFrame=tr.CFrame
            root.Velocity=Vector3.new(Config.FLING_Strength,Config.FLING_Strength/2,Config.FLING_Strength)
            root.RotVelocity=Vector3.new(9999,9999,9999)
            task.wait()
        end
    end
    root.CFrame=orig; root.Velocity=Vector3.zero; root.RotVelocity=Vector3.zero
end

local function FlingAll()
    local root=GetCharacterRoot(); if not root then return end
    local orig=root.CFrame
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                for i=1,3 do
                    root.CFrame=tr.CFrame
                    root.Velocity=Vector3.new(Config.FLING_Strength,Config.FLING_Strength/2,Config.FLING_Strength)
                    root.RotVelocity=Vector3.new(9999,9999,9999)
                    task.wait()
                end
            end
        end
    end
    root.CFrame=orig; root.Velocity=Vector3.zero; root.RotVelocity=Vector3.zero
end

local LastDoubleTapTime=0
local function DoubleTap()
    if not Config.KILLER_DoubleTap then return end
    if GetRole()~="Killer" then return end
    if tick()-LastDoubleTapTime<0.3 then return end
    pcall(function()
        local r=ReplicatedStorage:FindFirstChild("Remotes")
        local a=r and r:FindFirstChild("Attacks")
        local ba=a and a:FindFirstChild("BasicAttack")
        if ba then ba:FireServer(false); task.wait(0.05); ba:FireServer(false); LastDoubleTapTime=tick() end
    end)
end

local function SetupAntiBlind()
    pcall(function()
        local mt=getrawmetatable and getrawmetatable(game)
        if not mt or not setreadonly then return end
        setreadonly(mt,false)
        local oldNI=mt.__newindex
        mt.__newindex=newcclosure(function(self,key,val)
            if Config.KILLER_AntiBlind and GetRole()=="Killer" then
                if key=="BlackoutEnabled" or key=="Blinded" then return end
            end
            return oldNI(self,key,val)
        end)
        setreadonly(mt,true)
    end)
end

local function SetupNoPalletStun()
    pcall(function()
        local remotes=ReplicatedStorage:FindFirstChild("Remotes"); if not remotes then return end
        local pallet=remotes:FindFirstChild("Pallet"); if not pallet then return end
        local jason=pallet:FindFirstChild("Jason"); if not jason then return end
        local stun=jason:FindFirstChild("Stun"); local stunDrop=jason:FindFirstChild("StunDrop")
        if not stun then return end
        local mt=getrawmetatable and getrawmetatable(game)
        if not mt or not setreadonly then return end
        setreadonly(mt,false)
        local old=mt.__namecall
        mt.__namecall=newcclosure(function(self,...)
            if Config.KILLER_NoPalletStun and GetRole()=="Killer" then
                if self==stun or self==stunDrop then return nil end
            end
            return old(self,...)
        end)
        setreadonly(mt,true)
    end)
end

-- ================================================================
-- AUTO PARRY
-- ================================================================
local KillerHitConns={}
local ParryOnCooldown=false
local AttackAnimIDs={
    ["507766388"]=true,["507766666"]=true,["507766662"]=true,
    ["507766951"]=true,["522635514"]=true,
}

local function AutoParry_FireNoAnim()
    pcall(function()
        local r=ReplicatedStorage:FindFirstChild("Remotes")
        local s=r and r:FindFirstChild("Survivor")
        local pe=s and s:FindFirstChild("ParryEvent")
        if pe then pe:FireServer() end
    end)
    ParryOnCooldown=true
    task.delay(1.2, function() ParryOnCooldown=false end)
end

local function AutoParry_Cleanup()
    for _, c in pairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns={}
end

local function AutoParry_Setup()
    AutoParry_Cleanup()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsKiller(p) and p.Character then
            local char=p.Character
            local hum=char:FindFirstChildOfClass("Humanoid")
            local animator=char:FindFirstChildOfClass("Animator")
                or (hum and hum:FindFirstChildOfClass("Animator"))
            if animator then
                local conn=RunService.Heartbeat:Connect(function()
                    if not Config.AUTO_Parry or ParryOnCooldown then return end
                    if not IsKiller(p) then return end
                    local myRoot=GetCharacterRoot()
                    local kr=char:FindFirstChild("HumanoidRootPart")
                    if not myRoot or not kr then return end
                    if (kr.Position-myRoot.Position).Magnitude > Config.PARRY_Dist then return end
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track.IsPlaying then
                            local numId=track.Animation.AnimationId:match("%d+$") or ""
                            if AttackAnimIDs[numId] then AutoParry_FireNoAnim(); break end
                        end
                    end
                end)
                table.insert(KillerHitConns, conn)
            end
        end
    end
end

-- ================================================================
-- THIRD PERSON
-- ================================================================
local OriginalCameraType=nil
local ThirdPersonCharConn=nil
local ThirdPersonRenderConn=nil
local ThirdPersonDisabledScripts={}

local function ThirdPerson_Remove()
    local cam=workspace.CurrentCamera
    if OriginalCameraType and cam then pcall(function() cam.CameraType=OriginalCameraType end) end
    local char=LocalPlayer.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset=Vector3.new(0,0,0) end
    end
    if ThirdPersonRenderConn then ThirdPersonRenderConn:Disconnect(); ThirdPersonRenderConn=nil end
    for _, scr in ipairs(ThirdPersonDisabledScripts) do pcall(function() scr.Disabled=false end) end
    ThirdPersonDisabledScripts={}
end

local function UpdateThirdPerson()
    if not Config.CAM_ThirdPerson then ThirdPerson_Remove(); return end
    local cam=workspace.CurrentCamera
    local char=LocalPlayer.Character
    if not char or not cam then return end
    if not OriginalCameraType then OriginalCameraType=cam.CameraType end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.CameraOffset=Vector3.new(2,1,8) end
end

-- ================================================================
-- BEAT GAME
-- ================================================================
local function BeatGameSurvivor()
    if not Config.BEAT_Survivor then State.BeatSurvivorDone=false; State.LastFinishPos=nil; return end
    if GetRole()~="Survivor" then return end
    local root=GetCharacterRoot(); if not root then return end
    local map=Workspace:FindFirstChild("Map"); if not map then return end
    local exitPos=nil
    pcall(function()
        if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then
            exitPos=Vector3.new(3098.16,454.04,-4918.74); return end
        if map:FindFirstChild("HooksMeat") then
            exitPos=Vector3.new(1546.12,152.21,-796.72); return end
        if map:FindFirstChild("churchbell") then
            exitPos=Vector3.new(760.98,-20.14,-78.48); return end
        local finish=map:FindFirstChild("Finishline") or map:FindFirstChild("FinishLine") or map:FindFirstChild("Fininshline")
        if finish then
            if finish:IsA("BasePart") then exitPos=finish.Position
            elseif finish:IsA("Model") then
                local p=finish:FindFirstChildWhichIsA("BasePart"); if p then exitPos=p.Position end
            end; return
        end
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name:lower():find("finish") then
                if obj:IsA("BasePart") then exitPos=obj.Position; break
                elseif obj:IsA("Model") then
                    local p=obj:FindFirstChildWhichIsA("BasePart"); if p then exitPos=p.Position; break end
                end
            end
        end
    end)
    if not exitPos or State.BeatSurvivorDone then return end
    root.CFrame=CFrame.new(exitPos+Vector3.new(0,3,0))
    State.BeatSurvivorDone=true; State.LastFinishPos=exitPos
end

local function BeatGameKiller()
    if not Config.BEAT_Killer then State.KillerTarget=nil; return end
    if GetRole()~="Killer" then State.KillerTarget=nil; return end
    local root=GetCharacterRoot(); if not root then return end
    local target=State.KillerTarget
    if not (target and target.Character) then
        local best,bd=nil,math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and IsSurvivor(p) and p.Character then
                local pr=p.Character:FindFirstChild("HumanoidRootPart")
                local ph=p.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and IsPlayerAlive(ph) then
                    local d=(pr.Position-root.Position).Magnitude
                    if d<bd then bd=d; best=p end
                end
            end
        end
        State.KillerTarget=best; target=best
    end
    if not target or not target.Character then return end
    local tr=target.Character:FindFirstChild("HumanoidRootPart")
    if not tr then State.KillerTarget=nil; return end
    for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=false end
    end
    local dir=(root.Position-tr.Position).Unit
    root.CFrame=CFrame.new(tr.Position+dir*3+Vector3.new(0,1,0), tr.Position)
    pcall(function()
        local r=ReplicatedStorage:FindFirstChild("Remotes")
        local a=r and r:FindFirstChild("Attacks")
        local ba=a and a:FindFirstChild("BasicAttack")
        if ba then ba:FireServer(false) end
    end)
end

-- ================================================================
-- AUTO HOOK
-- ================================================================
local LastAutoHookTime=0
local AutoHookState={phase=0,target=nil,startTime=0,spamCount=0}

local function AutoHook_SpamSpace(duration)
    task.spawn(function()
        local vim2=game:GetService("VirtualInputManager")
        local endTime=tick()+duration
        while tick()<endTime do
            pcall(function()
                vim2:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
                task.wait(0.05)
                vim2:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
            end)
            task.wait(0.08)
        end
    end)
end

local function AutoHook_LookAt(tp)
    local cam=workspace.CurrentCamera; local root=GetCharacterRoot()
    if cam and root then cam.CFrame=CFrame.new(cam.CFrame.Position,tp) end
end

local function AutoHook_IsHookOccupied(hook)
    if not hook or not hook.part then return true end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsSurvivor(p) and p.Character then
            local pr=p.Character:FindFirstChild("HumanoidRootPart")
            if pr and (pr.Position-hook.part.Position).Magnitude<8 then return true end
        end
    end
    return false
end

local function AutoHook_FindBestHook()
    local root=GetCharacterRoot(); if not root then return nil end
    local best,bd=nil,math.huge
    for _, hook in ipairs(Cache.Hooks) do
        if hook.part and hook.part.Parent and not AutoHook_IsHookOccupied(hook) then
            local d=(hook.part.Position-root.Position).Magnitude
            if d<bd then bd=d; best=hook end
        end
    end
    return best
end

local function AutoHook()
    if not Config.KILLER_AutoHook then AutoHookState.phase=0; AutoHookState.target=nil; return end
    if GetRole()~="Killer" then AutoHookState.phase=0; AutoHookState.target=nil; return end
    local root=GetCharacterRoot(); if not root then return end
    local char=LocalPlayer.Character; if not char then return end

    if AutoHookState.phase==3 then
        if tick()-AutoHookState.startTime>2 then AutoHookState.phase=0; AutoHookState.target=nil; LastAutoHookTime=tick() end
        return
    end
    if AutoHookState.phase==2 then
        local hook=AutoHook_FindBestHook()
        if hook and hook.part then
            for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
            local hp=hook.part.Position
            root.CFrame=CFrame.new(hp+Vector3.new(0,2,0),hp)
            AutoHook_LookAt(hp); AutoHook_SpamSpace(1.5)
            task.delay(0.3,function()
                if LocalPlayer.Character then
                    for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=true end
                    end
                end
            end)
            AutoHookState.phase=3; AutoHookState.startTime=tick()
        else AutoHookState.phase=0; AutoHookState.target=nil end
        return
    end
    if AutoHookState.phase==1 then
        if tick()-AutoHookState.startTime>1.5 then AutoHookState.phase=2 end; return
    end
    if tick()-LastAutoHookTime<0.5 then return end
    local closestDowned,cd2=nil,math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsSurvivor(p) and p.Character then
            local pr=p.Character:FindFirstChild("HumanoidRootPart")
            local ph=p.Character:FindFirstChildOfClass("Humanoid")
            if pr and ph and IsPlayerDowned(ph) then
                local d=(pr.Position-root.Position).Magnitude
                if d<cd2 then cd2=d; closestDowned={player=p,root=pr} end
            end
        end
    end
    if closestDowned then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        local tp=closestDowned.root.Position
        root.CFrame=CFrame.new(tp+Vector3.new(0,3,0),tp+Vector3.new(0,-5,0))
        AutoHook_LookAt(tp); AutoHook_SpamSpace(1.5)
        AutoHookState.phase=1; AutoHookState.target=closestDowned.player; AutoHookState.startTime=tick()
        task.delay(0.5,function()
            if LocalPlayer.Character then
                for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=true end
                end
            end
        end)
    end
end

-- ================================================================
-- SPEAR AIMBOT
-- ================================================================
local function SpearAimbot(targetPos)
    if not Config.SPEAR_Aimbot then return nil end
    local root=GetCharacterRoot(); if not root then return nil end
    local dist=(targetPos-(root.Position+Vector3.new(0,2,0))).Magnitude
    local t2=dist/Config.SPEAR_Speed
    return targetPos+Vector3.new(0, 0.5*Config.SPEAR_Gravity*t2*t2, 0)
end

local function UpdateSpearAim()
    if not Config.SPEAR_Aimbot then return end
    if GetRole()~="Killer" then return end
    local root=GetCharacterRoot(); if not root then return end
    local closest,cd3=nil,math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsSurvivor(p) and p.Character then
            local pr=p.Character:FindFirstChild("HumanoidRootPart")
            if pr and Cache.Visibility[p] then
                local d=(pr.Position-root.Position).Magnitude
                if d<cd3 then cd3=d; closest=p end
            end
        end
    end
    if closest and closest.Character then
        local pr=closest.Character:FindFirstChild("HumanoidRootPart")
        if pr then
            local aimPos=SpearAimbot(pr.Position)
            local cam=workspace.CurrentCamera
            if aimPos and cam then cam.CFrame=CFrame.new(cam.CFrame.Position,aimPos) end
        end
    end
end

local function UpdateFog()
    if Config.NO_Fog~=State.LastFogState then
        State.LastFogState=Config.NO_Fog
        if Config.NO_Fog then RemoveFog() else RestoreFog() end
    end
end

-- ================================================================
-- ROLE MANAGER
-- ================================================================
local RoleManagerConn,RoleCharConn=nil,nil
local LastRole=GetRole()

local function SuspendAllFeatures()
    pcall(ThirdPerson_Remove)
    pcall(function()
        local char=LocalPlayer.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed=State.OriginalSpeed or 16; hum.JumpPower=OriginalJumpPower or 50; hum.CameraOffset=Vector3.new(0,0,0) end
    end)
    pcall(GodMode_Stop); pcall(AntiScript_Restore); pcall(PerfectSC_Stop); pcall(AutoParry_Cleanup)
end

local function RehookForRole(role)
    if State.Unloaded or role=="Spectator" then return end
    task.delay(2,function()
        if State.Unloaded or GetRole()~=role then return end
        if Config.AUTO_Parry then pcall(AutoParry_Cleanup); pcall(AutoParry_Setup) end
        if Config.ANTI_SkillCheck and LocalPlayer.Character then pcall(AntiScript_Apply,LocalPlayer.Character) end
        if Config.PERFECT_SkillCheck then pcall(PerfectSC_Stop); pcall(PerfectSC_Setup) end
        if Config.KILLER_AntiBlind then pcall(SetupAntiBlind) end
        if Config.KILLER_NoPalletStun then pcall(SetupNoPalletStun) end
        if Config.FULLBRIGHT then pcall(Fullbright_On) end
        if Config.NO_Fog then FogCache={}; State.LastFogState=nil; pcall(RemoveFog) end
        if Config.SURV_GodMode and role=="Survivor" then pcall(GodMode_Stop); pcall(GodMode_Start) end
    end)
end

local function RoleManager_Start()
    if RoleManagerConn then pcall(function() RoleManagerConn:Disconnect() end) end
    if RoleCharConn    then pcall(function() RoleCharConn:Disconnect() end) end
    RoleCharConn=LocalPlayer.CharacterAdded:Connect(function()
        local role=GetRole(); if role~="Spectator" then RehookForRole(role) end
    end)
    RoleManagerConn=LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        local newRole=GetRole(); if newRole==LastRole then return end
        LastRole=newRole
        if newRole=="Spectator" then task.spawn(SuspendAllFeatures) else RehookForRole(newRole) end
    end)
end

-- ================================================================
-- VELARIS UI LOAD
-- ================================================================
local VelarisUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/tesui.lua"))()

local Window = VelarisUI:Window({
    Title="Victoria Hub | Violence District", Footer="By Victoria", Content="Violence District",
    Color="Blue", Version=1.0, ["Tab Width"]=110, Image="96751490485303",
    Configname="VictoriaHub_VD", Uitransparent=0.15, ShowUser=false, Search=false,
    Animation=true, TypeDelay=0.07, TypePause=2.5,
    Config={AutoSave=false,AutoLoad=false},
    KeySystem={
        Title="Victoria Hub", Icon="lucide:key", Placeholder="Masukkan key disini",
        Default="VD-KEYLESS", DiscordText="Join Discord", DiscordUrl="https://discord.gg/xxxxx",
        Links={{Name="Linkvertise",Icon="lucide:link",Url="https://linkvertise.com/xxxxx"},{Name="LootLabs",Icon="lucide:gift",Url="https://lootlabs.gg/xxxxx"}},
        Steps={"1. Pilih metode verifikasi","2. Selesaikan ads (2 checkpoint)","3. Copy dan paste key dibawah"},
        Callback=function(key)
            local valid={"VICTORIA2025","VD-FREE-KEY","VD-KEYLESS"}
            for _, v in ipairs(valid) do if key==v then return true end end
            return false
        end,
    },
})

Window:Tag({Title="v1.0",Color=Color3.fromRGB(0,170,255)})

local function notif(name,state)
    VelarisUI:MakeNotify({Title=name,Description=state and "Enabled" or "Disabled",Content="",
        Color=state and "Success" or "Error",Time=2,Icon=state and "lucide:check" or "lucide:x"})
end

-- ================================================================
-- TABS
-- ================================================================
local Tabs={
    ESP      = Window:AddTab({Name="ESP",      Icon="lucide:eye"}),
    AIM      = Window:AddTab({Name="Aim",      Icon="lucide:crosshair"}),
    SURVIVOR = Window:AddTab({Name="Survivor", Icon="lucide:user"}),
    KILLER   = Window:AddTab({Name="Killer",   Icon="lucide:sword"}),
    MOVEMENT = Window:AddTab({Name="Movement", Icon="lucide:gamepad-2"}),
    MISC     = Window:AddTab({Name="Misc",     Icon="lucide:settings"}),
    CONFIG   = Window:AddTab({Name="Config",   Icon="lucide:folder"}),
}

-- ===== ESP TAB =====
local SecESPPlayers=Tabs.ESP:AddSection({Title="Players",Open=true})

local function clearPlayerESP(killerOnly)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (killerOnly == nil or IsKiller(p) == killerOnly) and p.Character then
            RemoveHighlight(p.Character)
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then local t=hrp:FindFirstChild("_VHTag"); if t then t:Destroy() end end
        end
    end
end

SecESPPlayers:AddToggle({Title="Killer ESP",Default=Config.ESP_Killer,
    Callback=function(v) Config.ESP_Killer=v; if not v then clearPlayerESP(true) end; notif("Killer ESP",v) end})
SecESPPlayers:AddToggle({Title="Survivor ESP",Default=Config.ESP_Survivor,
    Callback=function(v) Config.ESP_Survivor=v; if not v then clearPlayerESP(false) end; notif("Survivor ESP",v) end})
SecESPPlayers:AddToggle({Title="Names",    Default=Config.ESP_Names,    Callback=function(v) Config.ESP_Names=v end})
SecESPPlayers:AddToggle({Title="Distance", Default=Config.ESP_Distance, Callback=function(v) Config.ESP_Distance=v end})
SecESPPlayers:AddToggle({Title="Health",   Default=Config.ESP_Health,   Callback=function(v) Config.ESP_Health=v end})
SecESPPlayers:AddToggle({Title="Offscreen Arrow",Default=Config.ESP_Offscreen,Callback=function(v) Config.ESP_Offscreen=v end})

local SecESPObjects=Tabs.ESP:AddSection({Title="Objects",Open=false})
SecESPObjects:AddToggle({Title="Generator",Default=Config.ESP_Generator,Callback=function(v) Config.ESP_Generator=v; pcall(ESPRefreshMap) end})
SecESPObjects:AddToggle({Title="Gate",     Default=Config.ESP_Gate,    Callback=function(v) Config.ESP_Gate=v;      pcall(ESPRefreshMap) end})
SecESPObjects:AddToggle({Title="Hook",     Default=Config.ESP_Hook,    Callback=function(v) Config.ESP_Hook=v;      pcall(ESPRefreshMap) end})
SecESPObjects:AddToggle({Title="Pallet",   Default=Config.ESP_Pallet,  Callback=function(v) Config.ESP_Pallet=v;    pcall(ESPRefreshMap) end})
SecESPObjects:AddToggle({Title="Window",   Default=Config.ESP_Window,  Callback=function(v) Config.ESP_Window=v;    pcall(ESPRefreshMap) end})

local SecRadar=Tabs.ESP:AddSection({Title="Radar",Open=false})
SecRadar:AddToggle({Title="Enable Radar",Default=Config.RADAR_Enabled,Callback=function(v) Config.RADAR_Enabled=v; notif("Radar",v) end})
SecRadar:AddSlider({Title="Radar Size",Min=80,Max=200,Default=Config.RADAR_Size,Callback=function(v) Config.RADAR_Size=v end})
SecRadar:AddToggle({Title="Show Killer",   Default=Config.RADAR_Killer,   Callback=function(v) Config.RADAR_Killer=v end})
SecRadar:AddToggle({Title="Show Survivor", Default=Config.RADAR_Survivor, Callback=function(v) Config.RADAR_Survivor=v end})
SecRadar:AddToggle({Title="Show Generator",Default=Config.RADAR_Generator,Callback=function(v) Config.RADAR_Generator=v end})
SecRadar:AddToggle({Title="Show Pallet",   Default=Config.RADAR_Pallet,   Callback=function(v) Config.RADAR_Pallet=v end})

-- ===== AIM TAB =====
local SecAimbot=Tabs.AIM:AddSection({Title="Camera Aimbot",Open=true})
SecAimbot:AddToggle({Title="Enable Aimbot",Default=Config.AIM_Enabled,Callback=function(v) Config.AIM_Enabled=v; notif("Aimbot",v) end})
SecAimbot:AddToggle({Title="Auto Mode (Mobile)",Default=Config.AIM_AutoMode,Callback=function(v) Config.AIM_AutoMode=v end})
SecAimbot:AddDropdown({Title="Target Mode",Options={"Auto","Killer","Survivor","Closest"},Default=Config.AIM_TargetMode,Callback=function(v) Config.AIM_TargetMode=v end})
SecAimbot:AddToggle({Title="Show FOV",   Default=Config.AIM_ShowFOV,  Callback=function(v) Config.AIM_ShowFOV=v end})
SecAimbot:AddToggle({Title="Crosshair",  Default=Config.AIM_Crosshair,Callback=function(v) Config.AIM_Crosshair=v end})
SecAimbot:AddSlider({Title="FOV Size",   Min=50,Max=400,Default=Config.AIM_FOV,    Callback=function(v) Config.AIM_FOV=v end})
SecAimbot:AddSlider({Title="Smoothness", Min=1, Max=20, Default=math.floor(Config.AIM_Smooth*20),Callback=function(v) Config.AIM_Smooth=v/20 end})
SecAimbot:AddToggle({Title="Visibility Check",Default=Config.AIM_VisCheck,Callback=function(v) Config.AIM_VisCheck=v end})
SecAimbot:AddToggle({Title="Prediction", Default=Config.AIM_Predict,  Callback=function(v) Config.AIM_Predict=v end})

local SecSpear=Tabs.AIM:AddSection({Title="Spear Aimbot (Veil)",Open=false})
SecSpear:AddToggle({Title="Spear Aimbot",Default=Config.SPEAR_Aimbot,Callback=function(v) Config.SPEAR_Aimbot=v; notif("Spear Aimbot",v) end})
SecSpear:AddSlider({Title="Gravity",Min=10,Max=200,Default=Config.SPEAR_Gravity,Callback=function(v) Config.SPEAR_Gravity=v end})
SecSpear:AddSlider({Title="Speed",  Min=50,Max=300,Default=Config.SPEAR_Speed,  Callback=function(v) Config.SPEAR_Speed=v end})

-- ===== SURVIVOR TAB =====
local SecGen=Tabs.SURVIVOR:AddSection({Title="Generator",Open=true})
SecGen:AddToggle({Title="Auto Generator",Default=Config.AUTO_Generator,Callback=function(v) Config.AUTO_Generator=v; notif("Auto Gen",v) end})
SecGen:AddDropdown({Title="Gen Speed",Options={"Fast","Slow"},Default=Config.AUTO_GenMode,Callback=function(v) Config.AUTO_GenMode=v end})
SecGen:AddSlider({Title="Leave Dist",Min=10,Max=30,Default=Config.AUTO_LeaveDist,Callback=function(v) Config.AUTO_LeaveDist=v end})

local SecSurv=Tabs.SURVIVOR:AddSection({Title="Survivor",Open=true})
SecSurv:AddToggle({Title="Remove Skill Check",Default=Config.ANTI_SkillCheck,Callback=function(v)
    Config.ANTI_SkillCheck=v
    if v and LocalPlayer.Character then AntiScript_Apply(LocalPlayer.Character) else AntiScript_Restore() end
    notif("Remove Skill Check",v)
end})
SecSurv:AddToggle({Title="Perfect Skill Check",Default=Config.PERFECT_SkillCheck,Callback=function(v)
    Config.PERFECT_SkillCheck=v; if v then PerfectSC_Setup() else PerfectSC_Stop() end; notif("Perfect SC",v)
end})
SecSurv:AddToggle({Title="God Mode",Default=Config.SURV_GodMode,Callback=function(v)
    Config.SURV_GodMode=v; if v then task.spawn(GodMode_Start) else GodMode_Stop() end; notif("God Mode",v)
end})
SecSurv:AddToggle({Title="No Fall Damage",Default=Config.SURV_NoFall,Callback=function(v) Config.SURV_NoFall=v; notif("No Fall",v) end})
SecSurv:AddToggle({Title="Auto Tele Away",Default=Config.AUTO_TeleAway,Callback=function(v) Config.AUTO_TeleAway=v; notif("Auto Tele Away",v) end})
SecSurv:AddSlider({Title="Tele Away Dist",Min=10,Max=80,Default=Config.AUTO_TeleAwayDist,Callback=function(v) Config.AUTO_TeleAwayDist=v end})

local SecParry=Tabs.SURVIVOR:AddSection({Title="Auto Parry",Open=false})
SecParry:AddToggle({Title="Auto Parry",Default=Config.AUTO_Parry,Callback=function(v)
    Config.AUTO_Parry=v; if v then AutoParry_Setup() else AutoParry_Cleanup() end; notif("Auto Parry",v)
end})
SecParry:AddDropdown({Title="Parry Mode",Options={"With Animation","No Animation"},Default=Config.PARRY_Mode,Callback=function(v) Config.PARRY_Mode=v end})
SecParry:AddSlider({Title="Parry Distance",Min=5,Max=40,Default=Config.PARRY_Dist,Callback=function(v) Config.PARRY_Dist=v end})
SecParry:AddToggle({Title="Show Parry FOV",Default=Config.PARRY_FOV,Callback=function(v) Config.PARRY_FOV=v end})

local SecBeatSurv=Tabs.SURVIVOR:AddSection({Title="Beat Game",Open=false})
SecBeatSurv:AddToggle({Title="Beat As Survivor",Default=Config.BEAT_Survivor,Callback=function(v) Config.BEAT_Survivor=v end})

-- ===== KILLER TAB =====
local SecCombat=Tabs.KILLER:AddSection({Title="Combat",Open=true})
SecCombat:AddToggle({Title="Auto Attack",Default=Config.AUTO_Attack,Callback=function(v) Config.AUTO_Attack=v; notif("Auto Attack",v) end})
SecCombat:AddSlider({Title="Attack Range",Min=5,Max=20,Default=Config.AUTO_AttackRange,Callback=function(v) Config.AUTO_AttackRange=v end})
SecCombat:AddToggle({Title="Double Tap (Instant Kill)",Default=Config.KILLER_DoubleTap,Callback=function(v) Config.KILLER_DoubleTap=v end})
SecCombat:AddToggle({Title="Infinite Lunge",Default=Config.KILLER_InfiniteLunge,Callback=function(v) Config.KILLER_InfiniteLunge=v end})
SecCombat:AddToggle({Title="Auto Hook",Default=Config.KILLER_AutoHook,Callback=function(v) Config.KILLER_AutoHook=v end})

local SecHitbox=Tabs.KILLER:AddSection({Title="Hitbox",Open=false})
SecHitbox:AddToggle({Title="Hitbox Expander",Default=Config.HITBOX_Enabled,Callback=function(v) Config.HITBOX_Enabled=v end})
SecHitbox:AddSlider({Title="Hitbox Size",Min=5,Max=30,Default=Config.HITBOX_Size,Callback=function(v) Config.HITBOX_Size=v end})

local SecProtection=Tabs.KILLER:AddSection({Title="Protection",Open=false})
SecProtection:AddToggle({Title="No Pallet Stun",Default=Config.KILLER_NoPalletStun,Callback=function(v) Config.KILLER_NoPalletStun=v end})
SecProtection:AddToggle({Title="Anti Blind",Default=Config.KILLER_AntiBlind,Callback=function(v) Config.KILLER_AntiBlind=v end})
SecProtection:AddToggle({Title="No Slowdown",Default=Config.KILLER_NoSlowdown,Callback=function(v) Config.KILLER_NoSlowdown=v end})

local SecDestruction=Tabs.KILLER:AddSection({Title="Destruction",Open=false})
SecDestruction:AddToggle({Title="Full Gen Break",Default=Config.KILLER_FullGenBreak,Callback=function(v) Config.KILLER_FullGenBreak=v end})
SecDestruction:AddToggle({Title="Destroy All Pallets",Default=Config.KILLER_DestroyPallets,Callback=function(v) Config.KILLER_DestroyPallets=v end})

local SecBeatKill=Tabs.KILLER:AddSection({Title="Beat Game",Open=false})
SecBeatKill:AddToggle({Title="Beat As Killer",Default=Config.BEAT_Killer,Callback=function(v) Config.BEAT_Killer=v end})

-- ===== MOVEMENT TAB =====
local SecSpeed=Tabs.MOVEMENT:AddSection({Title="Speed",Open=true})
SecSpeed:AddToggle({Title="Speed Hack",Default=Config.SPEED_Enabled,Callback=function(v) Config.SPEED_Enabled=v; notif("Speed",v) end})
SecSpeed:AddSlider({Title="Speed Value",Min=16,Max=150,Default=Config.SPEED_Value,Callback=function(v) Config.SPEED_Value=v end})
SecSpeed:AddDropdown({Title="Speed Method",Options={"Attribute","TP"},Default=Config.SPEED_Method,Callback=function(v) Config.SPEED_Method=v end})

local SecFly=Tabs.MOVEMENT:AddSection({Title="Flight",Open=false})
SecFly:AddToggle({Title="Fly",Default=Config.FLY_Enabled,Callback=function(v) Config.FLY_Enabled=v end})
SecFly:AddSlider({Title="Fly Speed",Min=10,Max=200,Default=Config.FLY_Speed,Callback=function(v) Config.FLY_Speed=v end})
SecFly:AddDropdown({Title="Fly Method",Options={"CFrame","Velocity"},Default=Config.FLY_Method,Callback=function(v) Config.FLY_Method=v end})

local SecJump=Tabs.MOVEMENT:AddSection({Title="Jump",Open=false})
SecJump:AddSlider({Title="Jump Power",Min=50,Max=200,Default=Config.JUMP_Power,Callback=function(v) Config.JUMP_Power=v end})
SecJump:AddToggle({Title="Infinite Jump",Default=Config.JUMP_Infinite,Callback=function(v) Config.JUMP_Infinite=v end})

local SecCollision=Tabs.MOVEMENT:AddSection({Title="Collision",Open=false})
SecCollision:AddToggle({Title="Noclip",Default=Config.NOCLIP_Enabled,Callback=function(v) Config.NOCLIP_Enabled=v end})

local SecTeleport=Tabs.MOVEMENT:AddSection({Title="Teleport",Open=false})
SecTeleport:AddSlider({Title="TP Height Offset",Min=0,Max=10,Default=Config.TP_Offset,Callback=function(v) Config.TP_Offset=v end})
SecTeleport:AddButton({Title="TP to Generator",Callback=function() TeleportToGenerator(1) end})
SecTeleport:AddButton({Title="TP to Gate",     Callback=function() TeleportToGate() end})
SecTeleport:AddButton({Title="TP to Hook",     Callback=function() TeleportToHook() end})

-- ===== MISC TAB =====
local SecVisual=Tabs.MISC:AddSection({Title="Visual",Open=true})
SecVisual:AddToggle({Title="No Fog",Default=Config.NO_Fog,Callback=function(v) Config.NO_Fog=v; notif("No Fog",v) end})
SecVisual:AddToggle({Title="Fullbright",Default=Config.FULLBRIGHT,Callback=function(v)
    Config.FULLBRIGHT=v; if v then Fullbright_On() else Fullbright_Off() end; notif("Fullbright",v)
end})

local SecFling=Tabs.MISC:AddSection({Title="Fling",Open=false})
SecFling:AddToggle({Title="Fling Enable",Default=Config.FLING_Enabled,Callback=function(v) Config.FLING_Enabled=v; notif("Fling",v) end})
SecFling:AddSlider({Title="Fling Strength",Min=1000,Max=50000,Default=Config.FLING_Strength,Callback=function(v) Config.FLING_Strength=v end})
SecFling:AddButton({Title="Fling Nearest",Callback=function() FlingNearest() end})
SecFling:AddButton({Title="Fling All",    Callback=function() FlingAll() end})

local SecKeybinds=Tabs.MISC:AddSection({Title="Keybinds",Open=false})
SecKeybinds:AddParagraph({Title="Info",Content="Menu: INSERT | Panic: HOME\nSpeed: C | Fly: F | Noclip: V\nTP Gen: G | TP Gate: T | TP Hook: H\nLeave Gen: Q | Stop Gen: X"})

local SecSystem=Tabs.MISC:AddSection({Title="System",Open=false})
SecSystem:AddButton({Title="Unload Script",Callback=function()
    VelarisUI:MakeNotify({Title="System",Description="Unloading...",Content="",Color="Default",Time=2})
    task.delay(0.5,function() Unload() end)
end})

VelarisUI:AddConfigSection(Tabs.CONFIG,{Name="Configuration"})

VelarisUI:MakeNotify({Title="Victoria Hub",Description="Loaded Successfully!",Content="Violence District",Color="Success",Time=3,Icon="lucide:check"})

-- ================================================================
-- DRAWING ELEMENTS
-- ================================================================
local FOV_SEGMENTS=20
local FOVLines={}
for i=1,FOV_SEGMENTS do
    local l=Drawing.new("Line"); l.Thickness=1; l.Color=Color3.fromRGB(0,170,255); l.Transparency=1; l.Visible=false
    FOVLines[i]=l
end

local CrossLines,CrossOutlines={},{}
for i=1,4 do
    local l=Drawing.new("Line"); l.Thickness=1.5; l.Color=Color3.fromRGB(255,255,255); l.Transparency=1; l.Visible=false; CrossLines[i]=l
    local o=Drawing.new("Line"); o.Thickness=3;   o.Color=Color3.fromRGB(0,0,0);       o.Transparency=0.5; o.Visible=false; CrossOutlines[i]=o
end
local CrossDot=Drawing.new("Circle"); CrossDot.Radius=2; CrossDot.Filled=true; CrossDot.Color=Color3.fromRGB(0,0,0); CrossDot.Transparency=1; CrossDot.Visible=false

local PFOV_N=24
local PFOVLines={}
for i=1,PFOV_N do
    local ln=Drawing.new("Line"); ln.Thickness=1.5; ln.Color=Color3.fromRGB(0,170,255); ln.Transparency=1; ln.Visible=false
    PFOVLines[i]=ln
end

local AutoGenHint=Drawing.new("Text")
AutoGenHint.Size=16; AutoGenHint.Font=Drawing.Fonts.UI; AutoGenHint.Center=true
AutoGenHint.Outline=true; AutoGenHint.Color=Color3.fromRGB(0,170,255); AutoGenHint.Visible=false

-- ================================================================
-- MAIN LOOP
-- ================================================================
local function MainLoop()
    if State.Unloaded then return end
    local cam=workspace.CurrentCamera; if not cam then return end
    local screenSize=cam.ViewportSize
    local screenCenter=Vector2.new(screenSize.X/2,screenSize.Y/2)
    local now=tick()

    if now-State.LastCacheUpdate>=Tuning.CacheRefreshRate then
        State.LastCacheUpdate=now; ScanMap()
        if Config.ESP_Enabled then pcall(ESPRefreshMap) end
    end

    if now-State.LastVisCheck>=Tuning.ESP_VisCheckRate then
        State.LastVisCheck=now; UpdateVisibility()
    end

    if now-State.LastESPUpdate>=Tuning.ESP_RefreshRate then
        State.LastESPUpdate=now
        if Config.ESP_Enabled then
            pcall(ESPUpdatePlayers)
            for i=#ESPGenerators,1,-1 do
                local g=ESPGenerators[i]
                if g and g.Parent then if UpdateGeneratorProgress(g) then table.remove(ESPGenerators,i) end
                else table.remove(ESPGenerators,i) end
            end
        end
    end

    -- Auto gen hint
    if Config.AUTO_Generator then
        AutoGenHint.Text="AUTO GEN  |  [Q] Leave  [X] Stop"
        AutoGenHint.Position=Vector2.new(screenSize.X/2,30)
        AutoGenHint.Visible=true
    else AutoGenHint.Visible=false end

    -- Parry FOV
    if Config.AUTO_Parry and Config.PARRY_FOV then
        local myRoot=GetCharacterRoot()
        if myRoot then
            local r=Config.PARRY_Dist; local baseY=myRoot.Position.Y-3
            local ox,oz=myRoot.Position.X,myRoot.Position.Z
            for i=1,PFOV_N do
                local a1=(i-1)/PFOV_N*math.pi*2; local a2=i/PFOV_N*math.pi*2
                local s1,on1=WorldToScreen(Vector3.new(ox+math.cos(a1)*r,baseY,oz+math.sin(a1)*r))
                local s2,on2=WorldToScreen(Vector3.new(ox+math.cos(a2)*r,baseY,oz+math.sin(a2)*r))
                if on1 and on2 then PFOVLines[i].From=s1; PFOVLines[i].To=s2; PFOVLines[i].Visible=true
                else PFOVLines[i].Visible=false end
            end
        else for i=1,PFOV_N do PFOVLines[i].Visible=false end end
    else for i=1,PFOV_N do PFOVLines[i].Visible=false end end

    -- FOV Circle
    if Config.AIM_Enabled and Config.AIM_ShowFOV then
        local r=Config.AIM_FOV
        local fovColor=State.AimTarget and Color3.fromRGB(90,220,120) or Color3.fromRGB(220,70,70)
        for i=1,FOV_SEGMENTS do
            local a1=(i-1)/FOV_SEGMENTS*math.pi*2; local a2=i/FOV_SEGMENTS*math.pi*2
            FOVLines[i].From=Vector2.new(screenCenter.X+math.cos(a1)*r,screenCenter.Y+math.sin(a1)*r)
            FOVLines[i].To=Vector2.new(screenCenter.X+math.cos(a2)*r,screenCenter.Y+math.sin(a2)*r)
            FOVLines[i].Color=fovColor; FOVLines[i].Visible=true
        end
    else for i=1,FOV_SEGMENTS do FOVLines[i].Visible=false end end

    -- Crosshair
    if Config.AIM_Crosshair then
        local cx,cy=screenCenter.X,screenCenter.Y; local sz,gap=10,3
        local segs={
            {Vector2.new(cx-sz-gap,cy),Vector2.new(cx-gap,cy)},
            {Vector2.new(cx+gap,cy),   Vector2.new(cx+sz+gap,cy)},
            {Vector2.new(cx,cy-sz-gap),Vector2.new(cx,cy-gap)},
            {Vector2.new(cx,cy+gap),   Vector2.new(cx,cy+sz+gap)},
        }
        for i=1,4 do
            CrossOutlines[i].From=segs[i][1]; CrossOutlines[i].To=segs[i][2]; CrossOutlines[i].Visible=true
            CrossLines[i].From=segs[i][1];    CrossLines[i].To=segs[i][2];    CrossLines[i].Visible=true
        end
        CrossDot.Position=Vector2.new(cx,cy); CrossDot.Visible=true
    else
        for i=1,4 do CrossLines[i].Visible=false; CrossOutlines[i].Visible=false end
        CrossDot.Visible=false
    end
end

-- ================================================================
-- AUTO LOOP
-- ================================================================
local function AutoLoop()
    while not State.Unloaded do
        pcall(AutoAttack); pcall(TeleportAway); pcall(UpdateNoFall); pcall(DoubleTap)
        pcall(UpdateNoSlowdown); pcall(AutoHook); pcall(UpdateSpeed); pcall(UpdateNoclip)
        pcall(UpdateFly); pcall(UpdateJumpPower); pcall(UpdateFog); pcall(UpdateThirdPerson)
        pcall(UpdateHitboxes); pcall(UpdateSpearAim); pcall(BeatGameSurvivor); pcall(BeatGameKiller)
        task.wait(0.1)
    end
end

-- ================================================================
-- UNLOAD
-- ================================================================
Unload = function()
    State.Unloaded=true
    for i=1,FOV_SEGMENTS do pcall(function() FOVLines[i]:Remove() end) end
    for i=1,PFOV_N do pcall(function() PFOVLines[i]:Remove() end) end
    for i=1,4 do pcall(function() CrossLines[i]:Remove() end); pcall(function() CrossOutlines[i]:Remove() end) end
    pcall(function() CrossDot:Remove() end)
    pcall(function() AutoGenHint:Remove() end)
    pcall(AntiScript_Restore); pcall(PerfectSC_Stop); pcall(AutoParry_Cleanup); pcall(GodMode_Stop); pcall(ThirdPerson_Remove)
    if Config.NO_Fog then pcall(RestoreFog) end
    if Config.FULLBRIGHT then pcall(Fullbright_Off) end
    for player, sizes in pairs(OriginalHitboxSizes) do
        pcall(function()
            if player and player.Character then
                local r=player.Character:FindFirstChild("HumanoidRootPart"); if r then r.Size=sizes end
            end
        end)
    end
    OriginalHitboxSizes={}
    pcall(function()
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed=State.OriginalSpeed or 16; hum.PlatformStand=false; hum.CameraOffset=Vector3.new(0,0,0) end
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        if FlyBodyGyro     then FlyBodyGyro:Destroy() end
    end)
    pcall(function() if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end end)
    if RoleManagerConn then pcall(function() RoleManagerConn:Disconnect() end); RoleManagerConn=nil end
    if RoleCharConn    then pcall(function() RoleCharConn:Disconnect() end);    RoleCharConn=nil end
    if ThirdPersonRenderConn then pcall(function() ThirdPersonRenderConn:Disconnect() end); ThirdPersonRenderConn=nil end
    if ThirdPersonCharConn   then pcall(function() ThirdPersonCharConn:Disconnect() end);   ThirdPersonCharConn=nil end
    for name, conn in pairs(Connections) do pcall(function() conn:Disconnect() end); Connections[name]=nil end
    ESPClearAll()
    Config.AUTO_Generator=false; Config.AUTO_Attack=false; Config.AUTO_TeleAway=false
    Config.SPEED_Enabled=false;  Config.NOCLIP_Enabled=false; Config.BEAT_Survivor=false
    Config.BEAT_Killer=false;    Config.HITBOX_Enabled=false; Config.FLY_Enabled=false
    Config.FLING_Enabled=false;  Config.KILLER_DoubleTap=false; Config.KILLER_AutoHook=false
    State.KillerTarget=nil; AutoHookState.phase=0; AutoHookState.target=nil
    pcall(function()
        local char=LocalPlayer.Character
        if char then for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=true end
        end end
    end)
end

-- ================================================================
-- INIT
-- ================================================================
local function Init()
    ScanMap(); ESPRefreshMap()
    pcall(SetupAntiBlind); pcall(SetupNoPalletStun); pcall(SetupInfiniteJump)
    task.spawn(AutoParry_Setup)

    Connections.Input=UserInputService.InputBegan:Connect(function(input,gp)
        if State.Unloaded then return end
        if input.UserInputType~=Enum.UserInputType.Keyboard then return end
        if input.KeyCode==Config.KEY_Panic then Unload(); return end
        if gp then return end
        if input.KeyCode==Config.KEY_LeaveGen then LeaveGenerator(); return end
        if input.KeyCode==Config.KEY_StopGen  then StopAutoGen(); return end
        if input.KeyCode==Config.KEY_TP_Gen   then TeleportToGenerator(1); return end
        if input.KeyCode==Config.KEY_TP_Gate  then TeleportToGate(); return end
        if input.KeyCode==Config.KEY_TP_Hook  then TeleportToHook(); return end
        if input.KeyCode==Config.KEY_Speed    then Config.SPEED_Enabled=not Config.SPEED_Enabled; return end
        if input.KeyCode==Config.KEY_Noclip   then Config.NOCLIP_Enabled=not Config.NOCLIP_Enabled; return end
        if input.KeyCode==Config.KEY_Fly      then Config.FLY_Enabled=not Config.FLY_Enabled; return end
    end)

    Connections.InputEnd=UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton2 then State.AimHolding=false; State.AimTarget=nil end
    end)

    Connections.Render=RunService.RenderStepped:Connect(MainLoop)

    RoleManager_Start()

    Workspace.ChildAdded:Connect(function(child)
        if child.Name=="Map" then
            task.wait(2)
            if Config.ESP_Enabled then pcall(ESPRefreshMap) end
            if Config.FULLBRIGHT  then pcall(Fullbright_On) end
            if Config.NO_Fog      then FogCache={}; State.LastFogState=nil; pcall(RemoveFog) end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.PERFECT_SkillCheck then pcall(PerfectSC_Stop); pcall(PerfectSC_Setup) end
        ScanMap(); if Config.ESP_Enabled then pcall(ESPRefreshMap) end
    end)

    -- Auto Gen loop
    task.spawn(function()
        local repairRemote,skillRemote; local lastScan,genPoints=0,{}
        while not State.Unloaded do
            if Config.AUTO_Generator then
                if not repairRemote then
                    local r=ReplicatedStorage:FindFirstChild("Remotes")
                    local g=r and r:FindFirstChild("Generator")
                    repairRemote=g and g:FindFirstChild("RepairEvent")
                    skillRemote=g and g:FindFirstChild("SkillCheckResultEvent")
                end
                if tick()-lastScan>2 then
                    genPoints={}
                    local m=Workspace:FindFirstChild("Map")
                    if m then
                        for _, v in ipairs(m:GetDescendants()) do
                            if v:IsA("Model") and v.Name=="Generator" then
                                for _, c in ipairs(v:GetChildren()) do
                                    if c.Name:match("GeneratorPoint") then table.insert(genPoints,{gen=v,pt=c}) end
                                end
                            end
                        end
                    end
                    lastScan=tick()
                end
                if repairRemote and skillRemote then
                    local mode=Config.AUTO_GenMode=="Fast"
                    for _, data in ipairs(genPoints) do
                        pcall(repairRemote.FireServer,repairRemote,data.pt,true)
                        pcall(skillRemote.FireServer,skillRemote,mode and "success" or "neutral",mode and 1 or 0,data.gen,data.pt)
                    end
                end
            end
            task.wait(0.15)
        end
    end)

    Connections.PlayerLeft=Players.PlayerRemoving:Connect(function(player)
        Cache.Visibility[player]=nil
        if player.Character then
            local hrp=player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then local t=hrp:FindFirstChild("_VHTag"); if t then t:Destroy() end end
            RemoveHighlight(player.Character)
        end
    end)

    Connections.PlayerAdded=Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function() task.wait(1); ScanMap() end)
    end)

    task.spawn(AutoLoop)
    pcall(PerfectSC_Setup)
end

Init()
