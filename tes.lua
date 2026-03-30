-- ================================================================
-- VICTORIA HUB | VIOLENCE DISTRICT
-- BASE: yaya.lua (ESP + Highlight + Billboard)
-- PATCHED: Third Person, Auto Attack (firesignal), Parry FOV Circle
-- AIMBOT: Custom smooth aimbot (CFrame:Lerp + Prediction)
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
    while not Drawing and waited < 5 do task.wait(0.1); waited = waited + 0.1 end
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
    ESP_Offscreen    = false,
    ESP_ClosestHook  = false,
    ESP_MaxDist      = 200,
    ESP_Names        = true,
    ESP_Distance     = true,
    ESP_Health       = false,
    ESP_Skeleton     = false,
    ESP_Velocity     = false,
    ESP_PlayerChams  = true,
    ESP_ObjectChams  = true,
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
    AUTO_Generator   = false,
    AUTO_GenMode     = "Fast",
    AUTO_LeaveDist   = 18,
    RADAR_Enabled    = false,
    RADAR_Size       = 120,
    RADAR_Circle     = false,
    RADAR_Killer     = false,
    RADAR_Survivor   = false,
    RADAR_Generator  = false,
    RADAR_Pallet     = false,
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
}

-- ================================================================
-- ESP COLORS
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
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, character}
    local ray = workspace:Raycast(origin, dir, params)
    return ray == nil
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
-- HIGHLIGHT HELPERS (from yaya.lua)
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
-- NAMETAG (Billboard di atas kepala)
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
    b.StudsOffset = Vector3.new(0, 3.2, 0)
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
-- GENERATOR PROGRESS (dengan warna HIJAU saat 100%)
-- ================================================================
local ESPGenerators  = {}

local function UpdateGeneratorProgress(gen)
    if not gen or not gen.Parent then return true end
    local pv = gen:FindFirstChild("RepairProgress")
        or gen:GetAttribute("RepairProgress")
        or gen:FindFirstChild("Progress")
        or gen:GetAttribute("Progress")
    local p = pv and (typeof(pv) == "Instance" and pv.Value or pv) or 0

    if p >= 100 then
        if Config.ESP_Generator then
            ApplyHighlight(gen, ESPColors.GeneratorDone, 0.45, 0)
        end
        local old = gen:FindFirstChild("_VHGenTag")
        if old then old:Destroy() end
        return true
    end

    if not Config.ESP_Generator then
        RemoveHighlight(gen)
        local old = gen:FindFirstChild("_VHGenTag")
        if old then old:Destroy() end
        return false
    end

    local cl = math.clamp(p, 0, 100)
    local genColor = cl < 50
        and ESPColors.Generator:Lerp(Color3.fromRGB(200,200,0), cl/50)
        or Color3.fromRGB(200,200,0):Lerp(ESPColors.GeneratorDone, (cl-50)/50)

    ApplyHighlight(gen, genColor, 0.5, 0)

    local adornee = gen:FindFirstChild("defaultMaterial", true) or gen:FindFirstChildWhichIsA("BasePart") or gen
    local b = gen:FindFirstChild("_VHGenTag")
    if not b then
        b = Instance.new("BillboardGui")
        b.Name="_VHGenTag"; b.AlwaysOnTop=true
        b.Size=UDim2.new(0,90,0,22); b.StudsOffset=Vector3.new(0,3,0)
        b.Adornee=adornee; b.Parent=gen
        local t = Instance.new("TextLabel")
        t.Name="_VHGenLabel"; t.Size=UDim2.new(1,0,1,0)
        t.BackgroundTransparency=1; t.Font=Enum.Font.GothamBold
        t.TextSize=11; t.TextStrokeTransparency=0
        t.TextStrokeColor3=Color3.new(0,0,0); t.Parent=b
    end
    local lbl = b:FindFirstChild("_VHGenLabel")
    if lbl then
        lbl.Text=string.format("%.1f%%", p)
        lbl.TextColor3=genColor
    end

    return false
end

-- ================================================================
-- ESP REFRESH MAP (event-based, no flicker)
-- ================================================================
local function ESPRefreshMap()
    ESPGenerators = {}
    local Map = Workspace:FindFirstChild("Map")

    -- Windows
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
            table.insert(ESPGenerators, obj)
            if Config.ESP_Generator then ApplyHighlight(obj, ESPColors.Generator, 0.5, 0)
            else RemoveHighlight(obj) end

        elseif n == "Hook" then
            local m = obj:FindFirstChild("Model")
            if m then
                for _, p in ipairs(m:GetDescendants()) do
                    if p:IsA("MeshPart") then
                        if Config.ESP_Hook then ApplyHighlight(p, ESPColors.Hook, 0.5, 0)
                        else RemoveHighlight(p) end
                    end
                end
            else
                if Config.ESP_Hook then ApplyHighlight(obj, ESPColors.Hook, 0.5, 0)
                else RemoveHighlight(obj) end
            end

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
    if not Config.ESP_Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local killer = IsKiller(player)

        local shouldShow = (killer and Config.ESP_Killer) or (not killer and Config.ESP_Survivor)
        local espColor   = killer and ESPColors.Killer or ESPColors.Survivor

        if shouldShow then
            local hooked  = char:GetAttribute("IsHooked")
                or (char:FindFirstChild("IsHooked") and char.IsHooked.Value)
            local knocked = char:GetAttribute("Knocked")
                or (char:FindFirstChild("Knocked") and char.Knocked.Value)
            if hooked then
                espColor = Color3.fromRGB(255, 182, 193)
            elseif hum and hum.Health < hum.MaxHealth then
                espColor = knocked and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(230, 220, 0)
            end

            ApplyHighlight(char, espColor, 0.6, 0)
            UpdatePlayerNametag(player)
        else
            RemoveHighlight(char)
            if hrp then
                local t = hrp:FindFirstChild("_VHTag")
                if t then t:Destroy() end
            end
        end
    end
end

-- ================================================================
-- SCAN MAP (for cache)
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

-- ================================================================
-- PERFECT SKILL CHECK (from yaya.lua)
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
-- AUTO ATTACK KILLER (firesignal ke button - from tesvide.lua)
-- ================================================================
local lastAttackTime = 0

local function FindAttackButton()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, gui in ipairs(pg:GetChildren()) do
        local controls = gui:FindFirstChild("Controls")
        if controls then
            local attackBtn = controls:FindFirstChild("attack")
            if attackBtn then return attackBtn end
        end
    end
    return nil
end

local function TriggerAttack()
    local btn = FindAttackButton()
    if not btn then return false end
    pcall(function()
        firesignal(btn.MouseButton1Down)
        task.wait(0.05)
        firesignal(btn.MouseButton1Up)
    end)
    return true
end

local function AutoAttack()
    if not Config.AUTO_Attack then return end
    if GetRole() ~= "Killer" then return end
    if tick() - lastAttackTime < 0.3 then return end
    
    local root = GetCharacterRoot()
    if not root then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist <= Config.AUTO_AttackRange then
                    TriggerAttack()
                    lastAttackTime = tick()
                    break
                end
            end
        end
    end
end

-- ================================================================
-- AIMBOT (Custom smooth aimbot - ga kedut)
-- ================================================================
local AimTarget = nil

local function Aimbot_GetTargetPart(char)
    if not char then return nil end
    local part = char:FindFirstChild(Config.AIM_TargetPart)
    if part then return part end
    return char:FindFirstChild("HumanoidRootPart")
end

local function Aimbot_GetClosestTarget(cam, screenCenter)
    if not cam then return nil end
    local myRole = GetRole()
    local closestPlayer = nil
    local closestDist = Config.AIM_FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local shouldTarget = false
            local mode = Config.AIM_TargetMode
            if mode == "Auto" then
                if myRole == "Survivor" and IsKiller(player) then shouldTarget = true
                elseif myRole == "Killer" and IsSurvivor(player) then shouldTarget = true end
            elseif mode == "Killer" then shouldTarget = IsKiller(player)
            elseif mode == "Survivor" then shouldTarget = IsSurvivor(player)
            elseif mode == "Closest" then shouldTarget = true end
            
            if shouldTarget then
                local targetPart = Aimbot_GetTargetPart(player.Character)
                if targetPart then
                    local visible = IsVisible(player.Character)
                    if (not Config.AIM_VisCheck) or visible then
                        local screenPos, onScreen = WorldToScreen(targetPart.Position)
                        if onScreen then
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

local function Aimbot_Update(cam, screenSize, screenCenter)
    if not Config.AIM_Enabled then
        AimTarget = nil
        return
    end
    
    local shouldAim = false
    if Config.AIM_AutoMode then
        local char = LocalPlayer.Character
        shouldAim = char and char:GetAttribute("Aiming") == true
    else
        shouldAim = true
    end
    
    if not shouldAim then
        AimTarget = nil
        return
    end
    
    local target = Aimbot_GetClosestTarget(cam, screenCenter)
    AimTarget = target
    
    if target and target.Character then
        local targetPart = Aimbot_GetTargetPart(target.Character)
        if targetPart then
            local targetPos = targetPart.Position
            if Config.AIM_Predict then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                if root then targetPos = targetPos + root.Velocity * 0.1 end
            end
            local currentCF = cam.CFrame
            local targetCF = CFrame.new(currentCF.Position, targetPos)
            cam.CFrame = currentCF:Lerp(targetCF, Config.AIM_Smooth)
        end
    end
end

-- ================================================================
-- PARRY FOV CIRCLE (Drawing Circle di bawah kaki - from tesvide.lua)
-- ================================================================
local ParryRemote = nil
local ParryOnCooldown = false
local KillerHitConns = {}
local ParryFOVCircle = nil
local ParryGuiBtn = nil

local function CreateParryFOVCircle()
    if ParryFOVCircle then return end
    ParryFOVCircle = Drawing.new("Circle")
    ParryFOVCircle.Filled = false
    ParryFOVCircle.Thickness = 2
    ParryFOVCircle.Color = Color3.fromRGB(0, 255, 0)
    ParryFOVCircle.Transparency = 1
    ParryFOVCircle.NumSides = 32
    ParryFOVCircle.Visible = false
end

local function UpdateParryFOV()
    if not Config.AUTO_Parry or not Config.PARRY_FOV then
        if ParryFOVCircle then ParryFOVCircle.Visible = false end
        return
    end
    
    local root = GetCharacterRoot()
    if not root then 
        if ParryFOVCircle then ParryFOVCircle.Visible = false end
        return 
    end
    
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    -- Circle di BAWAH KAKI player (Y - 3)
    local circlePos = root.Position + Vector3.new(0, -3, 0)
    local screenPos, onScreen = WorldToScreen(circlePos)
    
    if onScreen then
        local dist = (cam.CFrame.Position - circlePos).Magnitude
        local radius = (Config.PARRY_Dist * 50) / math.max(dist, 1)
        radius = math.clamp(radius, 10, 200)
        
        ParryFOVCircle.Position = screenPos
        ParryFOVCircle.Radius = radius
        ParryFOVCircle.Visible = true
        
        if ParryOnCooldown then
            ParryFOVCircle.Color = Color3.fromRGB(255, 100, 100)
        else
            ParryFOVCircle.Color = Color3.fromRGB(0, 255, 100)
        end
    else
        ParryFOVCircle.Visible = false
    end
end

-- ================================================================
-- AUTO PARRY (from yaya.lua - keep as is, it's complete)
-- ================================================================
local AttackAnimIDs = {
    ["110355011987939"] = true, ["139369275981139"] = true, ["105374834496520"] = true,
    ["106871536134254"] = true, ["109402730355822"] = true, ["111920872708571"] = true,
    ["113255068724446"] = true, ["115244153053858"] = true, ["117042998468241"] = true,
    ["117070354890871"] = true, ["118907603246885"] = true, ["122812055447896"] = true,
    ["129784271201071"] = true, ["129918027564423"] = true, ["130593238885843"] = true,
    ["132817836308238"] = true, ["133963973694098"] = true, ["138720291317243"] = true,
    ["74968262036854"] = true, ["77081789642514"] = true, ["78432063483146"] = true,
    ["78935059863801"] = true, ["80411309607666"] = true, ["82666958311998"] = true,
    ["95934119190708"] = true,
}

local NonAttackAnimIDs = {
    ["101784373049485"] = true, ["102182386301796"] = true, ["104239995665623"] = true,
    ["109066149291691"] = true, ["110953720370369"] = true, ["111427918159250"] = true,
    ["113499071528107"] = true, ["117224999672195"] = true, ["118699522268698"] = true,
    ["122986861455212"] = true, ["123782306962803"] = true, ["124191224140066"] = true,
    ["126100203042329"] = true, ["128387952281975"] = true, ["131476715474323"] = true,
    ["136859656743697"] = true, ["137688077908355"] = true, ["137846825408335"] = true,
    ["138045669415653"] = true, ["138125499040825"] = true, ["139198068127517"] = true,
    ["139610361987372"] = true, ["139928639611415"] = true, ["70746483345907"] = true,
    ["75258958842388"] = true, ["76294518257930"] = true, ["79376988328260"] = true,
    ["80105342981313"] = true, ["84093948968516"] = true, ["84440437648153"] = true,
    ["86266790353635"] = true, ["89642871504538"] = true, ["90249435310475"] = true,
    ["90374658251379"] = true, ["91224543667492"] = true, ["92098503722633"] = true,
    ["93136435416899"] = true, ["94067810090105"] = true, ["96744338559260"] = true,
}

local function AutoParry_GetRemote()
    if ParryRemote and ParryRemote.Parent then return ParryRemote end
    local r = ReplicatedStorage:FindFirstChild("Remotes")
    if not r then return nil end
    local items = r:FindFirstChild("Items")
    if not items then return nil end
    local dagger = items:FindFirstChild("Parrying Dagger")
    if not dagger then return nil end
    local raw = dagger:FindFirstChild("parry")
    if not raw then return nil end
    ParryRemote = raw
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
        ParryOnCooldown = true
        task.delay(2, function()
            ParryOnCooldown = false
            ParryGuiBtn = nil
        end)
    end
end

local function AutoParry_HookKillerChar(char, p)
    if not char then return end
    task.spawn(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then
            local w = 0
            repeat task.wait(0.1); w = w + 0.1; hum = char:FindFirstChildOfClass("Humanoid") until hum or w >= 2
        end
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            local w = 0
            repeat task.wait(0.1); w = w + 0.1; animator = hum:FindFirstChildOfClass("Animator") until animator or w >= 2
        end
        if not animator then return end

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
                if dist <= Config.PARRY_Dist then
                    AutoParry_TryFire()
                end
            end
        end)
        table.insert(KillerHitConns, conn1)

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
                        AutoParry_TryFire()
                        return
                    end
                end
            end
        end)
        table.insert(KillerHitConns, conn2)
    end)
end

local function AutoParry_Setup()
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}
    
    local function watchPlayer(p)
        if p == LocalPlayer then return end
        local function hookChar(char) AutoParry_HookKillerChar(char, p) end
        local c1 = p.CharacterAdded:Connect(hookChar)
        table.insert(KillerHitConns, c1)
        if p.Character then hookChar(p.Character) end
    end
    for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
    local c2 = Players.PlayerAdded:Connect(watchPlayer)
    table.insert(KillerHitConns, c2)
    
    CreateParryFOVCircle()
end

local function AutoParry_Cleanup()
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}
    ParryOnCooldown = false
    if ParryFOVCircle then ParryFOVCircle.Visible = false end
end

-- ================================================================
-- THIRD PERSON (from tesvide.lua - WORKING)
-- ================================================================
local ThirdPersonWasActive = false
local ThirdPersonCharConn = nil
local ThirdPersonRenderConn = nil
local ThirdPersonDisabledScripts = {}

local function ThirdPerson_Apply()
    local char = LocalPlayer.Character
    if not char then return end
    
    local fp = char:FindFirstChild("Firstperson")
    if fp and not fp.Disabled then
        pcall(function() fp.Disabled = true end)
        table.insert(ThirdPersonDisabledScripts, fp)
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.CameraOffset = Vector3.new(2, 1, 8)
        hum.AutoRotate = true
    end
    
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 20
        LocalPlayer.CameraMinZoomDistance = 7
    end)
    
    if ThirdPersonRenderConn then ThirdPersonRenderConn:Disconnect() end
    ThirdPersonRenderConn = RunService.RenderStepped:Connect(function()
        if not Config.CAM_ThirdPerson then return end
        local c = LocalPlayer.Character
        if not c then return end
        local fp2 = c:FindFirstChild("Firstperson")
        if fp2 and not fp2.Disabled then
            pcall(function() fp2.Disabled = true end)
        end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h and h.CameraOffset.Magnitude < 1 then
            h.CameraOffset = Vector3.new(2, 1, 8)
        end
    end)
    
    if ThirdPersonCharConn then ThirdPersonCharConn:Disconnect() end
    ThirdPersonCharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if not Config.CAM_ThirdPerson then return end
        task.wait(0.5)
        local fp = newChar:FindFirstChild("Firstperson")
        if fp and not fp.Disabled then
            pcall(function() fp.Disabled = true end)
        end
        local hum = newChar:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.CameraOffset = Vector3.new(2, 1, 8)
            hum.AutoRotate = true
        end
        pcall(function() LocalPlayer.CameraMaxZoomDistance = 20 end)
    end)
    
    ThirdPersonWasActive = true
end

local function ThirdPerson_Remove()
    if ThirdPersonRenderConn then
        ThirdPersonRenderConn:Disconnect()
        ThirdPersonRenderConn = nil
    end
    if ThirdPersonCharConn then
        ThirdPersonCharConn:Disconnect()
        ThirdPersonCharConn = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
    end
    
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 7
        LocalPlayer.CameraMinZoomDistance = 7
    end)
    
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

-- ================================================================
-- MOVEMENT FEATURES (from yaya.lua)
-- ================================================================
local SpeedWasOn = false
local OriginalSpeedStore = 16

local function UpdateSpeed()
    local role = GetRole()
    if role == "Spectator" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if Config.SPEED_Enabled then
        if not SpeedWasOn then
            OriginalSpeedStore = hum.WalkSpeed
            SpeedWasOn = true
        end
        hum.WalkSpeed = Config.SPEED_Value
    elseif SpeedWasOn then
        hum.WalkSpeed = OriginalSpeedStore
        SpeedWasOn = false
    end
end

local NoclipWasOn = false
local function UpdateNoclip()
    if GetRole() == "Spectator" then return end
    local char = LocalPlayer.Character
    if not char then return end
    if Config.NOCLIP_Enabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
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

local FlyBodyVelocity, FlyBodyGyro = nil, nil
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
            FlyBodyVelocity.Parent = root
        end
        if not FlyBodyGyro then
            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyGyro.Parent = root
        end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * Config.FLY_Speed end
        FlyBodyVelocity.Velocity = moveDir
        FlyBodyGyro.CFrame = cam.CFrame
    else
        if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
        if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
        hum.PlatformStand = false
    end
end

local OriginalJumpPower = 50
local InfiniteJumpConnection = nil

local function SetupInfiniteJump()
    if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
    InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if not Config.JUMP_Infinite then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function UpdateJumpPower()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.JumpPower = Config.JUMP_Power
end

-- ================================================================
-- TELEPORT FUNCTIONS
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
    local root = GetCharacterRoot()
    if not root then return false end
    
    local nearestGen, nearestDist = nil, math.huge
    for _, gen in ipairs(Cache.Generators) do
        local dist = (gen.part.Position - root.Position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearestGen = gen
        end
    end
    
    if not nearestGen or nearestDist > Config.AUTO_LeaveDist then return false end
    
    local direction = (root.Position - nearestGen.part.Position).Unit
    local escapePos = root.Position + direction * (Config.AUTO_LeaveDist + 10)
    root.CFrame = CFrame.new(escapePos + Vector3.new(0, Config.TP_Offset, 0))
    return true
end

local function StopAutoGen()
    Config.AUTO_Generator = false
end

-- ================================================================
-- AUTO GENERATOR LOOP
-- ================================================================
local _AutoGenRemote = nil
local _AutoGenSkillRemote = nil
local _AutoGenPoints = {}

local function AutoGenLoop()
    while not State.Unloaded do
        if Config.AUTO_Generator and GetRole() == "Survivor" then
            if not _AutoGenRemote then
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local g = r and r:FindFirstChild("Generator")
                _AutoGenRemote = g and g:FindFirstChild("RepairEvent")
                _AutoGenSkillRemote = g and g:FindFirstChild("SkillCheckResultEvent")
            end
            if _AutoGenRemote and _AutoGenSkillRemote then
                for _, data in ipairs(_AutoGenPoints) do
                    pcall(_AutoGenRemote.FireServer, _AutoGenRemote, data.pt, true)
                    local mode = Config.AUTO_GenMode == "Fast"
                    pcall(_AutoGenSkillRemote.FireServer, _AutoGenSkillRemote, mode and "success" or "neutral", mode and 1 or 0, data.gen, data.pt)
                end
            end
        end
        task.wait(0.15)
    end
end

-- ================================================================
-- ESP UPDATE LOOP
-- ================================================================
local function UpdateESP()
    ESPUpdatePlayers()
    for i = #ESPGenerators, 1, -1 do
        local g = ESPGenerators[i]
        if g and g.Parent then
            if UpdateGeneratorProgress(g) then
                table.remove(ESPGenerators, i)
            end
        else
            table.remove(ESPGenerators, i)
        end
    end
end

-- ================================================================
-- FOV & CROSSHAIR DRAWINGS
-- ================================================================
local FOV_SEGMENTS = 32
local FOVLines = {}
for i = 1, FOV_SEGMENTS do
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Color = Color3.fromRGB(0, 170, 255)
    l.Transparency = 1
    l.Visible = false
    FOVLines[i] = l
end

local CrossLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 1.5
    l.Color = Color3.fromRGB(255, 255, 255)
    l.Transparency = 1
    l.Visible = false
    CrossLines[i] = l
end

local function UpdateDrawings(cam, screenCenter)
    -- FOV Circle
    if Config.AIM_Enabled and Config.AIM_ShowFOV then
        local r = Config.AIM_FOV
        local cx, cy = screenCenter.X, screenCenter.Y
        for i = 1, FOV_SEGMENTS do
            local a1 = (i - 1) / FOV_SEGMENTS * math.pi * 2
            local a2 = i / FOV_SEGMENTS * math.pi * 2
            FOVLines[i].From = Vector2.new(cx + math.cos(a1) * r, cy + math.sin(a1) * r)
            FOVLines[i].To = Vector2.new(cx + math.cos(a2) * r, cy + math.sin(a2) * r)
            FOVLines[i].Visible = true
        end
    else
        for i = 1, FOV_SEGMENTS do FOVLines[i].Visible = false end
    end
    
    -- Crosshair
    if Config.AIM_Crosshair then
        local cx, cy = screenCenter.X, screenCenter.Y
        local sz = 10
        local gap = 3
        CrossLines[1].From = Vector2.new(cx - sz - gap, cy)
        CrossLines[1].To = Vector2.new(cx - gap, cy)
        CrossLines[2].From = Vector2.new(cx + gap, cy)
        CrossLines[2].To = Vector2.new(cx + sz + gap, cy)
        CrossLines[3].From = Vector2.new(cx, cy - sz - gap)
        CrossLines[3].To = Vector2.new(cx, cy - gap)
        CrossLines[4].From = Vector2.new(cx, cy + gap)
        CrossLines[4].To = Vector2.new(cx, cy + sz + gap)
        for i = 1, 4 do CrossLines[i].Visible = true end
    else
        for i = 1, 4 do CrossLines[i].Visible = false end
    end
end

-- ================================================================
-- MAIN LOOP
-- ================================================================
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
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                Cache.Visibility[player] = IsVisible(player.Character)
            end
        end
    end
    
    if now - State.LastESPUpdate >= Tuning.ESP_RefreshRate then
        State.LastESPUpdate = now
        UpdateESP()
    end
    
    Aimbot_Update(cam, screenSize, screenCenter)
    UpdateParryFOV()
    UpdateDrawings(cam, screenCenter)
end

-- ================================================================
-- UNLOAD FUNCTION
-- ================================================================
local function Unload()
    State.Unloaded = true
    for i = 1, FOV_SEGMENTS do pcall(function() FOVLines[i]:Remove() end) end
    for i = 1, 4 do pcall(function() CrossLines[i]:Remove() end) end
    if ParryFOVCircle then ParryFOVCircle:Remove() end
    
    pcall(AntiScript_Restore)
    pcall(PerfectSC_Stop)
    pcall(AutoParry_Cleanup)
    pcall(ThirdPerson_Remove)
    
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then 
            hum.WalkSpeed = OriginalSpeedStore
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    
    ESPClearAll()
    
    pcall(function() Window:Destroy() end)
    print("[Victoria] Unloaded")
end

-- ================================================================
-- VELARIS UI
-- ================================================================
local VelarisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/tesui.lua"))()

local Window = VelarisUI:Window({
    Title = "Victoria Hub | Violence District",
    Footer = "Fixed: Third Person, Auto Attack, Parry FOV",
    Content = "Violence District",
    Color = "Blue",
    Version = 3.0,
    KeySystem = {
        Title = "Victoria Hub",
        Default = "VD-KEYLESS",
        Callback = function(key) return key == "VD-KEYLESS" or key == "VICTORIA2025" end
    }
})

-- TABS (dari yaya.lua asli)
local Tabs = {
    ESP      = Window:AddTab({ Name = "ESP",      Icon = "lucide:eye" }),
    AIM      = Window:AddTab({ Name = "Aim",      Icon = "lucide:crosshair" }),
    SURVIVOR = Window:AddTab({ Name = "Survivor", Icon = "lucide:user" }),
    KILLER   = Window:AddTab({ Name = "Killer",   Icon = "lucide:sword" }),
    MOVEMENT = Window:AddTab({ Name = "Movement", Icon = "lucide:gamepad-2" }),
    MISC     = Window:AddTab({ Name = "Misc",     Icon = "lucide:settings" }),
    CONFIG   = Window:AddTab({ Name = "Config",   Icon = "lucide:folder" }),
}

-- ESP TAB
local SecESPPlayers = Tabs.ESP:AddSection({ Title = "Players", Open = true })
SecESPPlayers:AddToggle({ Title = "Killer ESP", Default = Config.ESP_Killer, Callback = function(v) Config.ESP_Killer = v end })
SecESPPlayers:AddToggle({ Title = "Survivor ESP", Default = Config.ESP_Survivor, Callback = function(v) Config.ESP_Survivor = v end })
SecESPPlayers:AddToggle({ Title = "Names", Default = Config.ESP_Names, Callback = function(v) Config.ESP_Names = v end })
SecESPPlayers:AddToggle({ Title = "Distance", Default = Config.ESP_Distance, Callback = function(v) Config.ESP_Distance = v end })
SecESPPlayers:AddToggle({ Title = "Health", Default = Config.ESP_Health, Callback = function(v) Config.ESP_Health = v end })

local SecESPObjects = Tabs.ESP:AddSection({ Title = "Objects", Open = false })
SecESPObjects:AddToggle({ Title = "Generator", Default = Config.ESP_Generator, Callback = function(v) Config.ESP_Generator = v; ESPRefreshMap() end })
SecESPObjects:AddToggle({ Title = "Gate", Default = Config.ESP_Gate, Callback = function(v) Config.ESP_Gate = v; ESPRefreshMap() end })
SecESPObjects:AddToggle({ Title = "Hook", Default = Config.ESP_Hook, Callback = function(v) Config.ESP_Hook = v; ESPRefreshMap() end })
SecESPObjects:AddToggle({ Title = "Pallet", Default = Config.ESP_Pallet, Callback = function(v) Config.ESP_Pallet = v; ESPRefreshMap() end })
SecESPObjects:AddToggle({ Title = "Window", Default = Config.ESP_Window, Callback = function(v) Config.ESP_Window = v; ESPRefreshMap() end })

-- AIM TAB
local SecAim = Tabs.AIM:AddSection({ Title = "Aimbot", Open = true })
SecAim:AddToggle({ Title = "Enable Aimbot", Default = Config.AIM_Enabled, Callback = function(v) Config.AIM_Enabled = v end })
SecAim:AddToggle({ Title = "Auto Mode (Mobile)", Default = Config.AIM_AutoMode, Callback = function(v) Config.AIM_AutoMode = v end })
SecAim:AddDropdown({ Title = "Target Mode", Options = { "Auto", "Killer", "Survivor", "Closest" }, Default = Config.AIM_TargetMode, Callback = function(v) Config.AIM_TargetMode = v end })
SecAim:AddSlider({ Title = "FOV Size", Min = 50, Max = 400, Default = Config.AIM_FOV, Callback = function(v) Config.AIM_FOV = v end })
SecAim:AddSlider({ Title = "Smoothness", Min = 1, Max = 20, Default = math.floor(Config.AIM_Smooth * 20), Callback = function(v) Config.AIM_Smooth = v / 20 end })
SecAim:AddToggle({ Title = "Visibility Check", Default = Config.AIM_VisCheck, Callback = function(v) Config.AIM_VisCheck = v end })
SecAim:AddToggle({ Title = "Prediction", Default = Config.AIM_Predict, Callback = function(v) Config.AIM_Predict = v end })
SecAim:AddToggle({ Title = "Show FOV", Default = Config.AIM_ShowFOV, Callback = function(v) Config.AIM_ShowFOV = v end })
SecAim:AddToggle({ Title = "Crosshair", Default = Config.AIM_Crosshair, Callback = function(v) Config.AIM_Crosshair = v end })

-- SURVIVOR TAB
local SecSurv = Tabs.SURVIVOR:AddSection({ Title = "Survivor", Open = true })
SecSurv:AddToggle({ Title = "Remove Skill Check", Default = Config.ANTI_SkillCheck, Callback = function(v) Config.ANTI_SkillCheck = v; if v then AntiScript_Apply(LocalPlayer.Character) else AntiScript_Restore() end end })
SecSurv:AddToggle({ Title = "Perfect Skill Check", Default = Config.PERFECT_SkillCheck, Callback = function(v) Config.PERFECT_SkillCheck = v; if v then PerfectSC_Setup() else PerfectSC_Stop() end end })
SecSurv:AddToggle({ Title = "God Mode", Default = Config.SURV_GodMode, Callback = function(v) Config.SURV_GodMode = v end })
SecSurv:AddToggle({ Title = "No Fall Damage", Default = Config.SURV_NoFall, Callback = function(v) Config.SURV_NoFall = v end })
SecSurv:AddToggle({ Title = "Auto Tele Away", Default = Config.AUTO_TeleAway, Callback = function(v) Config.AUTO_TeleAway = v end })
SecSurv:AddSlider({ Title = "Tele Away Dist", Min = 10, Max = 80, Default = Config.AUTO_TeleAwayDist, Callback = function(v) Config.AUTO_TeleAwayDist = v end })

local SecParry = Tabs.SURVIVOR:AddSection({ Title = "Auto Parry", Open = false })
SecParry:AddToggle({ Title = "Auto Parry", Default = Config.AUTO_Parry, Callback = function(v) Config.AUTO_Parry = v; if v then AutoParry_Setup() else AutoParry_Cleanup() end end })
SecParry:AddDropdown({ Title = "Parry Mode", Options = { "With Animation", "No Animation" }, Default = Config.PARRY_Mode, Callback = function(v) Config.PARRY_Mode = v end })
SecParry:AddSlider({ Title = "Parry Distance", Min = 5, Max = 40, Default = Config.PARRY_Dist, Callback = function(v) Config.PARRY_Dist = v end })
SecParry:AddToggle({ Title = "Show Parry FOV", Default = Config.PARRY_FOV, Callback = function(v) Config.PARRY_FOV = v end })

local SecBeatSurv = Tabs.SURVIVOR:AddSection({ Title = "Beat Game", Open = false })
SecBeatSurv:AddToggle({ Title = "Beat As Survivor", Default = Config.BEAT_Survivor, Callback = function(v) Config.BEAT_Survivor = v end })

-- KILLER TAB
local SecCombat = Tabs.KILLER:AddSection({ Title = "Combat", Open = true })
SecCombat:AddToggle({ Title = "Auto Attack", Default = Config.AUTO_Attack, Callback = function(v) Config.AUTO_Attack = v end })
SecCombat:AddSlider({ Title = "Attack Range", Min = 5, Max = 20, Default = Config.AUTO_AttackRange, Callback = function(v) Config.AUTO_AttackRange = v end })
SecCombat:AddToggle({ Title = "Double Tap", Default = Config.KILLER_DoubleTap, Callback = function(v) Config.KILLER_DoubleTap = v end })
SecCombat:AddToggle({ Title = "Infinite Lunge", Default = Config.KILLER_InfiniteLunge, Callback = function(v) Config.KILLER_InfiniteLunge = v end })
SecCombat:AddToggle({ Title = "Auto Hook", Default = Config.KILLER_AutoHook, Callback = function(v) Config.KILLER_AutoHook = v end })

local SecHitbox = Tabs.KILLER:AddSection({ Title = "Hitbox", Open = false })
SecHitbox:AddToggle({ Title = "Hitbox Expander", Default = Config.HITBOX_Enabled, Callback = function(v) Config.HITBOX_Enabled = v end })
SecHitbox:AddSlider({ Title = "Hitbox Size", Min = 5, Max = 30, Default = Config.HITBOX_Size, Callback = function(v) Config.HITBOX_Size = v end })

local SecProtection = Tabs.KILLER:AddSection({ Title = "Protection", Open = false })
SecProtection:AddToggle({ Title = "No Pallet Stun", Default = Config.KILLER_NoPalletStun, Callback = function(v) Config.KILLER_NoPalletStun = v end })
SecProtection:AddToggle({ Title = "Anti Blind", Default = Config.KILLER_AntiBlind, Callback = function(v) Config.KILLER_AntiBlind = v end })
SecProtection:AddToggle({ Title = "No Slowdown", Default = Config.KILLER_NoSlowdown, Callback = function(v) Config.KILLER_NoSlowdown = v end })

local SecDestruction = Tabs.KILLER:AddSection({ Title = "Destruction", Open = false })
SecDestruction:AddToggle({ Title = "Full Gen Break", Default = Config.KILLER_FullGenBreak, Callback = function(v) Config.KILLER_FullGenBreak = v end })
SecDestruction:AddToggle({ Title = "Destroy All Pallets", Default = Config.KILLER_DestroyPallets, Callback = function(v) Config.KILLER_DestroyPallets = v end })

local SecKillerCamera = Tabs.KILLER:AddSection({ Title = "Camera", Open = false })
SecKillerCamera:AddToggle({ Title = "Third Person", Default = Config.CAM_ThirdPerson, Callback = function(v) Config.CAM_ThirdPerson = v; UpdateThirdPerson() end })

local SecBeatKill = Tabs.KILLER:AddSection({ Title = "Beat Game", Open = false })
SecBeatKill:AddToggle({ Title = "Beat As Killer", Default = Config.BEAT_Killer, Callback = function(v) Config.BEAT_Killer = v end })

-- MOVEMENT TAB
local SecSpeed = Tabs.MOVEMENT:AddSection({ Title = "Speed", Open = true })
SecSpeed:AddToggle({ Title = "Speed Hack", Default = Config.SPEED_Enabled, Callback = function(v) Config.SPEED_Enabled = v end })
SecSpeed:AddSlider({ Title = "Speed Value", Min = 16, Max = 150, Default = Config.SPEED_Value, Callback = function(v) Config.SPEED_Value = v end })

local SecFly = Tabs.MOVEMENT:AddSection({ Title = "Flight", Open = false })
SecFly:AddToggle({ Title = "Fly", Default = Config.FLY_Enabled, Callback = function(v) Config.FLY_Enabled = v end })
SecFly:AddSlider({ Title = "Fly Speed", Min = 10, Max = 200, Default = Config.FLY_Speed, Callback = function(v) Config.FLY_Speed = v end })

local SecJump = Tabs.MOVEMENT:AddSection({ Title = "Jump", Open = false })
SecJump:AddSlider({ Title = "Jump Power", Min = 50, Max = 200, Default = Config.JUMP_Power, Callback = function(v) Config.JUMP_Power = v end })
SecJump:AddToggle({ Title = "Infinite Jump", Default = Config.JUMP_Infinite, Callback = function(v) Config.JUMP_Infinite = v end })

local SecCollision = Tabs.MOVEMENT:AddSection({ Title = "Collision", Open = false })
SecCollision:AddToggle({ Title = "Noclip", Default = Config.NOCLIP_Enabled, Callback = function(v) Config.NOCLIP_Enabled = v end })

local SecTeleport = Tabs.MOVEMENT:AddSection({ Title = "Teleport", Open = false })
SecTeleport:AddSlider({ Title = "TP Height Offset", Min = 0, Max = 10, Default = Config.TP_Offset, Callback = function(v) Config.TP_Offset = v end })
SecTeleport:AddButton({ Title = "TP to Generator", Callback = function() TeleportToGenerator(1) end })
SecTeleport:AddButton({ Title = "TP to Gate", Callback = TeleportToGate })
SecTeleport:AddButton({ Title = "TP to Hook", Callback = TeleportToHook })

-- MISC TAB
local SecVisual = Tabs.MISC:AddSection({ Title = "Visual", Open = true })
SecVisual:AddToggle({ Title = "No Fog", Default = Config.NO_Fog, Callback = function(v) Config.NO_Fog = v end })
SecVisual:AddToggle({ Title = "Fullbright", Default = Config.FULLBRIGHT, Callback = function(v) Config.FULLBRIGHT = v end })

local SecFling = Tabs.MISC:AddSection({ Title = "Fling", Open = false })
SecFling:AddToggle({ Title = "Fling Enable", Default = Config.FLING_Enabled, Callback = function(v) Config.FLING_Enabled = v end })
SecFling:AddSlider({ Title = "Fling Strength", Min = 1000, Max = 50000, Default = Config.FLING_Strength, Callback = function(v) Config.FLING_Strength = v end })
SecFling:AddButton({ Title = "Fling Nearest", Callback = function() end })  -- Placeholder
SecFling:AddButton({ Title = "Fling All", Callback = function() end })      -- Placeholder

local SecKeybinds = Tabs.MISC:AddSection({ Title = "Keybinds", Open = false })
SecKeybinds:AddParagraph({ Title = "Info", Content = "Menu: INSERT | Panic: HOME\nSpeed: C | Fly: F | Noclip: V\nTP Gen: G | TP Gate: T | TP Hook: H\nLeave Gen: Q | Stop Gen: X" })

local SecSystem = Tabs.MISC:AddSection({ Title = "System", Open = false })
SecSystem:AddButton({ Title = "Unload Script", Callback = function()
    VelarisUI:MakeNotify({ Title = "System", Description = "Unloading...", Content = "", Color = "Default", Time = 2 })
    task.delay(0.5, function() Unload() end)
end })

-- ================================================================
-- INITIALIZATION
-- ================================================================
local function Init()
    ScanMap()
    ESPRefreshMap()
    PerfectSC_Setup()
    AutoParry_Setup()
    SetupInfiniteJump()
    UpdateThirdPerson()
    
    -- Auto refresh ESP when map changes
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            ScanMap()
            ESPRefreshMap()
        end
    end)
    
    -- Auto refresh ESP when character respawns
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        ScanMap()
        ESPRefreshMap()
    end)
    
    -- Keybinds
    Connections.Input = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if State.Unloaded then return end
        if input.KeyCode == Config.KEY_Panic then Unload(); return end
        if gameProcessed then return end
        if input.KeyCode == Config.KEY_LeaveGen then LeaveGenerator(); return end
        if input.KeyCode == Config.KEY_StopGen then StopAutoGen(); return end
        if input.KeyCode == Config.KEY_TP_Gen then TeleportToGenerator(1); return end
        if input.KeyCode == Config.KEY_TP_Gate then TeleportToGate(); return end
        if input.KeyCode == Config.KEY_TP_Hook then TeleportToHook(); return end
        if input.KeyCode == Config.KEY_Speed then Config.SPEED_Enabled = not Config.SPEED_Enabled; return end
        if input.KeyCode == Config.KEY_Noclip then Config.NOCLIP_Enabled = not Config.NOCLIP_Enabled; return end
        if input.KeyCode == Config.KEY_Fly then Config.FLY_Enabled = not Config.FLY_Enabled; return end
    end)
    
    -- Main loops
    Connections.Render = RunService.RenderStepped:Connect(MainLoop)
    task.spawn(AutoGenLoop)
    
    -- Auto gen points scanner
    task.spawn(function()
        while not State.Unloaded do
            task.wait(2)
            if Config.AUTO_Generator then
                _AutoGenPoints = {}
                local m = Workspace:FindFirstChild("Map")
                if m then
                    for _, v in ipairs(m:GetDescendants()) do
                        if v:IsA("Model") and v.Name == "Generator" then
                            for _, c in ipairs(v:GetChildren()) do
                                if c.Name:match("GeneratorPoint") then
                                    table.insert(_AutoGenPoints, {gen = v, pt = c})
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    VelarisUI:MakeNotify({ Title = "Victoria Hub", Description = "Loaded Successfully!", Content = "Violence District", Color = "Success", Time = 3, Icon = "lucide:check" })
end

Init()
