-- ================================================================
-- DRAWING SAFETY
-- ================================================================
if not Drawing or not Drawing.new then
    local waited = 0
    while not Drawing and waited < 5 do task.wait(0.1); waited = waited + 0.1 end
    if not Drawing then warn("[VH] Drawing not available."); return end
end

-- ================================================================
-- SERVICES
-- ================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- ================================================================
-- CONFIG
-- ================================================================
local Config = {
    ESP_Killer = false,
    ESP_Survivor = false,
    ESP_Generator = false,
    ESP_Gate = false,
    ESP_Hook = false,
    ESP_Pallet = false,
    ESP_Window = false,
    ESP_Distance = false,
    ESP_Names = true,
    ESP_Health = false,
    ESP_MaxDist = 200,
    AUTO_Attack = false,
    AUTO_AttackRange = 12,
    HITBOX_Enabled = false,
    HITBOX_Size = 15,
    AUTO_Parry = false,
    PARRY_Mode = "With Animation",
    PARRY_Dist = 13,
    PARRY_FOV  = false,
    ANTI_SkillCheck = false,
    PERFECT_SkillCheck = false,
    SURV_NoFall = false,
    SURV_GodMode = false,
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
    NOCLIP_Enabled = false,
    FLY_Enabled = false,
    FLY_Speed = 50,
    NO_Fog = false,
    FULLBRIGHT = false,
    CAM_ThirdPerson = false,
    FLING_Enabled = false,
    FLING_Strength = 10000,
    BEAT_Survivor = false,
    BEAT_Killer = false,
    TP_Offset = 3,
    KEY_Panic = Enum.KeyCode.Home,
    KEY_LeaveGen = Enum.KeyCode.Q,
    KEY_TP_Gen = Enum.KeyCode.G,
    KEY_TP_Gate = Enum.KeyCode.T,
    KEY_TP_Hook = Enum.KeyCode.H,
    KEY_Speed = Enum.KeyCode.C,
    KEY_Noclip = Enum.KeyCode.V,
    KEY_Fly = Enum.KeyCode.F,
    AIM_Enabled = false,
    AIM_AutoMode = false,
    AIM_TargetMode = "Auto",
    AIM_FOV = 120,
    AIM_Smooth = 0.3,
    AIM_TargetPart = "Left Arm",
    AIM_VisCheck = true,
    AIM_ShowFOV = false,
    AIM_Crosshair = false,
    AIM_Predict = true,
    SPEAR_Aimbot = false,
    SPEAR_Gravity = 50,
    SPEAR_Speed = 100,
}

local Tuning = {
    ESP_RefreshRate = 0.05,
    ESP_VisCheckRate = 0.15,
    Gen_RefreshRate = 0.2,
    CacheRefreshRate = 1.0,
}

-- ================================================================
-- COLORS
-- ================================================================
local ESPColors = {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(64, 224, 128),
    Generator = Color3.fromRGB(255, 140, 0),
    GeneratorDone = Color3.fromRGB(0, 220, 80),
    Gate = Color3.fromRGB(240, 240, 240),
    Hook = Color3.fromRGB(220, 50, 50),
    Pallet = Color3.fromRGB(230, 200, 40),
    Window = Color3.fromRGB(170, 170, 175),
}

-- ================================================================
-- STATE
-- ================================================================
local State = {
    Unloaded = false,
    LastCacheUpdate = 0,
    LastVisCheck = 0,
    LastESPUpdate = 0,
    AimTarget = nil,
    OriginalSpeed = 16,
    LastFogState = false,
    KillerTarget = nil,
    LastBeatTP = 0,
    LastFinishPos = nil,
    BeatSurvivorDone = false
}

local Cache = {
    Generators = {},
    Gates = {},
    Hooks = {},
    Pallets = {},
    Windows = {},
    ClosestHook = nil,
    Visibility = {},
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
        if n:find("killer") then return "Killer" end
        if n:find("survivor") then return "Survivor" end
        if n:find("spectator") then return "Spectator" end
    end
    return "Spectator"
end

local function IsKiller(player)
    if not player then return false end
    local team = player.Team
    if team then
        local n = team.Name:lower()
        if n:find("killer") then return true end
        if n:find("survivor") then return false end
    end
    return false
end

local function IsSurvivor(player)
    if not player or player == LocalPlayer then return false end
    return not IsKiller(player)
end

local function IsVisible(character)
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    local myRoot = GetCharacterRoot()
    if not root or not myRoot then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, character}
    local ray = workspace:Raycast(myRoot.Position, (root.Position - myRoot.Position), params)
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

-- ================================================================
-- HIGHLIGHT HELPERS
-- ================================================================
local function ApplyHighlight(obj, color, fillTrans, outTrans)
    if not obj or not obj.Parent then return end
    fillTrans = fillTrans or 0.65
    outTrans = outTrans or 0.3  -- outline lebih keliatan
    local h = obj:FindFirstChild("_VHLight")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "_VHLight"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = obj
        h.Parent = obj
    end
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.8
    h.OutlineTransparency = 0.3
end

local function RemoveHighlight(obj)
    if not obj then return end
    local h = obj:FindFirstChild("_VHLight")
    if h then h:Destroy() end
end

-- ================================================================
-- NAMETAG
-- ================================================================
local function GetOrCreateNametag(hrp)
    if not hrp then return nil end
    local tag = hrp:FindFirstChild("_VHTag")
    if not tag then
        tag = Instance.new("BillboardGui")
        tag.Name = "_VHTag"
        tag.AlwaysOnTop = true
        tag.Size = UDim2.new(0, 130, 0, 36)
        tag.StudsOffset = Vector3.new(0, 3.2, 0)
        tag.Adornee = hrp
        tag.Parent = hrp
        
        local lbl = Instance.new("TextLabel")
        lbl.Name = "_VHTagLabel"
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextWrapped = true
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0,0,0)
        lbl.Parent = tag
    end
    return tag
end

local function UpdateNametag(player, color, dist)
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    local tag = GetOrCreateNametag(hrp)
    if not tag then return end
    
    local lines = {}
    if Config.ESP_Names then table.insert(lines, player.Name) end
    if Config.ESP_Distance then table.insert(lines, "[" .. dist .. "m]") end
    if Config.ESP_Health and hum then
        local pct = math.floor(GetHealthPercent(hum)*100)
        table.insert(lines, "HP: " .. pct .. "%")
    end
    
    local lbl = tag:FindFirstChild("_VHTagLabel")
    if lbl then
        lbl.Text = table.concat(lines, "\n")
        lbl.TextColor3 = color
    end
    
    tag.Enabled = (#lines > 0)
end

-- ================================================================
-- UPDATE PLAYER ESP
-- ================================================================
local function UpdatePlayerESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        
        local isKiller = IsKiller(player)
        local shouldShow = (isKiller and Config.ESP_Killer) or (not isKiller and Config.ESP_Survivor)
        
        if not shouldShow then
            RemoveHighlight(char)
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tag = hrp:FindFirstChild("_VHTag")
                if tag then tag.Enabled = false end
            end
        else
            local myRoot = GetCharacterRoot()
            local dist = 0
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if myRoot and hrp then
                dist = math.floor((hrp.Position - myRoot.Position).Magnitude)
            end
            
            local color = isKiller and ESPColors.Killer or ESPColors.Survivor
            local hum = char:FindFirstChildOfClass("Humanoid")
            local knocked = char:GetAttribute("Knocked")
            local hooked = char:GetAttribute("IsHooked")
            
            if hooked then
                color = Color3.fromRGB(255, 182, 193)
            elseif hum and hum.Health < hum.MaxHealth then
                color = knocked and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(230, 220, 0)
            end
            
            ApplyHighlight(char, color, 0.6, 0)
            UpdateNametag(player, color, dist)
        end
    end
end

-- ================================================================
-- GENERATOR ESP
-- ================================================================
local ESPGenerators = {}

local function GetOrCreateGenTag(gen, adornee)
    local tag = gen:FindFirstChild("_VHGenTag")
    if not tag then
        tag = Instance.new("BillboardGui")
        tag.Name = "_VHGenTag"
        tag.AlwaysOnTop = true
        tag.Size = UDim2.new(0, 100, 0, 38)
        tag.StudsOffset = Vector3.new(0, 3, 0)
        tag.Adornee = adornee
        tag.Parent = gen

        -- Label persen (atas)
        local lbl = Instance.new("TextLabel")
        lbl.Name = "_VHGenLabel"
        lbl.Size = UDim2.new(1, 0, 0.55, 0)
        lbl.Position = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Parent = tag

        -- Background bar (bawah)
        local barBg = Instance.new("Frame")
        barBg.Name = "_VHGenBarBg"
        barBg.Size = UDim2.new(0.9, 0, 0, 5)
        barBg.Position = UDim2.new(0.05, 0, 0.72, 0)
        barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        barBg.BorderSizePixel = 0
        barBg.Parent = tag
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = barBg

        -- Fill bar
        local barFill = Instance.new("Frame")
        barFill.Name = "_VHGenBarFill"
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        barFill.BorderSizePixel = 0
        barFill.Parent = barBg
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = barFill
    end
    return tag
end

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
        and ESPColors.Generator:Lerp(Color3.fromRGB(200, 200, 0), cl/50)
        or Color3.fromRGB(200, 200, 0):Lerp(ESPColors.GeneratorDone, (cl-50)/50)

    ApplyHighlight(gen, genColor, 0.5, 0)

    local adornee = gen:FindFirstChild("defaultMaterial", true) or gen:FindFirstChildWhichIsA("BasePart") or gen
    local tag = GetOrCreateGenTag(gen, adornee)

    local lbl = tag:FindFirstChild("_VHGenLabel")
    if lbl then
        lbl.Text = string.format("%.1f%%", p)
        lbl.TextColor3 = genColor
    end

    -- Update fill bar
    local barBg   = tag:FindFirstChild("_VHGenBarBg")
    local barFill = barBg and barBg:FindFirstChild("_VHGenBarFill")
    if barFill then
        barFill.Size = UDim2.new(cl / 100, 0, 1, 0)
        barFill.BackgroundColor3 = genColor
    end

    tag.Enabled = true
    return false
end

-- ================================================================
-- ESP REFRESH MAP
-- ================================================================
local function ESPRefreshMap()
    ESPGenerators = {}
    local Map = Workspace:FindFirstChild("Map")
    
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

-- ================================================================
-- ================================================================
-- PERFECT SKILL CHECK (QTE - clean implementation)
-- ================================================================
local QTEHandler = {
    Monitoring = false,
    FrameConn  = nil,
    UIConn     = nil,
    Elements   = nil,
    Active     = false,
    CharConn   = nil,
}

local function QTE_SimulateInput()
    -- Space key (PC)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Space, false, game)
        task.defer(function()
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end)
    -- firesignal pada action button (mobile)
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, gui in ipairs(pg:GetChildren()) do
            local controls = gui:FindFirstChild("Controls", true)
            if controls then
                local btn = controls:FindFirstChild("action", true)
                if btn then
                    firesignal(btn.MouseButton1Down)
                    task.defer(function() pcall(function() firesignal(btn.MouseButton1Up) end) end)
                    return
                end
            end
        end
    end)
    -- SendTouchEvent fallback
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, gui in ipairs(pg:GetChildren()) do
            local controls = gui:FindFirstChild("Controls", true)
            if controls then
                local btn = controls:FindFirstChild("action", true) or controls:FindFirstChild("Action", true)
                if btn then
                    local pos = btn.AbsolutePosition + btn.AbsoluteSize * 0.5
                    local ins = GuiService:GetGuiInset()
                    VirtualInputManager:SendTouchEvent(8822, 0, pos.X + ins.X, pos.Y + ins.Y)
                    task.defer(function()
                        VirtualInputManager:SendTouchEvent(8822, 2, pos.X + ins.X, pos.Y + ins.Y)
                    end)
                    return
                end
            end
        end
    end)
end

local function QTE_GetUIElements()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local prompt = pg:FindFirstChild("SkillCheckPromptGui")
    if not prompt then return nil end
    local frame = prompt:FindFirstChild("Check")
    if not frame then return nil end
    local needle = frame:FindFirstChild("Line")
    local target = frame:FindFirstChild("Goal")
    if not needle or not target then return nil end
    return { frame = frame, needle = needle, target = target }
end

local function QTE_IsNeedleInZone(needleAngle, targetAngle)
    local needle = needleAngle % 360
    local target = targetAngle % 360
    local sweetSpotStart = (target + 104) % 360
    local sweetSpotEnd   = (target + 114) % 360
    if sweetSpotStart > sweetSpotEnd then
        return needle >= sweetSpotStart or needle <= sweetSpotEnd
    end
    return needle >= sweetSpotStart and needle <= sweetSpotEnd
end

local function QTE_StopMonitoring()
    if QTEHandler.FrameConn then
        QTEHandler.FrameConn:Disconnect()
        QTEHandler.FrameConn = nil
    end
    QTEHandler.Monitoring = false
end

local function QTE_FrameUpdate()
    if not Config.PERFECT_SkillCheck or GetRole() ~= "Survivor" then
        QTE_StopMonitoring(); return
    end
    local ui = QTEHandler.Elements
    if not ui or not ui.needle or not ui.target or not ui.frame.Visible then
        QTE_StopMonitoring(); return
    end
    if QTE_IsNeedleInZone(ui.needle.Rotation, ui.target.Rotation) then
        QTE_SimulateInput()
        QTE_StopMonitoring()
    end
end

local function QTE_StartMonitoring()
    if QTEHandler.Monitoring then return end
    QTEHandler.Monitoring = true
    QTEHandler.FrameConn = RunService.Heartbeat:Connect(QTE_FrameUpdate)
end

local function QTE_OnVisibilityChange()
    if not Config.PERFECT_SkillCheck or GetRole() ~= "Survivor" then
        QTE_StopMonitoring(); return
    end
    local ui = QTEHandler.Elements
    if ui and ui.frame and ui.frame.Visible then
        QTE_StartMonitoring()
    else
        QTE_StopMonitoring()
    end
end

local function SetupSkillCheckMonitor()
    pcall(function()
        QTE_StopMonitoring()
        if QTEHandler.UIConn then QTEHandler.UIConn:Disconnect(); QTEHandler.UIConn = nil end

        local ui = QTE_GetUIElements()
        if not ui then return end

        QTEHandler.Elements = ui
        QTEHandler.UIConn = ui.frame:GetPropertyChangedSignal("Visible"):Connect(QTE_OnVisibilityChange)

        -- Kalau frame sudah visible saat setup
        if ui.frame.Visible then QTE_StartMonitoring() end
    end)
end

-- Watch PlayerGui untuk reconnect kalau GUI di-recreate
local function PerfectSC_Setup()
    QTEHandler.Active = true
    SetupSkillCheckMonitor()

    -- Watch SkillCheckPromptGui di-recreate
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        if QTEHandler.CharConn then QTEHandler.CharConn:Disconnect() end
        QTEHandler.CharConn = pg.ChildAdded:Connect(function(child)
            if not QTEHandler.Active then return end
            if child.Name == "SkillCheckPromptGui" then
                task.wait(0.1)
                SetupSkillCheckMonitor()
            end
        end)
    end
end

local function PerfectSC_Stop()
    QTEHandler.Active = false
    QTE_StopMonitoring()
    if QTEHandler.UIConn  then QTEHandler.UIConn:Disconnect();  QTEHandler.UIConn = nil end
    if QTEHandler.CharConn then QTEHandler.CharConn:Disconnect(); QTEHandler.CharConn = nil end
    QTEHandler.Elements = nil
end

-- ================================================================
-- ANTI SKILL CHECK (DARI TESVIDE.LUA - BISA RESTORE)
-- ================================================================
local AntiScriptDescConn = nil
local AntiScriptGenScr = nil
local AntiScriptPlrScr = nil
local AntiScriptOriginalStates = {}  -- Simpan state asli script

local function AntiScript_DisableOne(scr)
    if not scr then return end
    if not Config.ANTI_SkillCheck then return end
    if scr.Name == "Skillcheck-gen" then
        if not AntiScriptOriginalStates[scr] then
            AntiScriptOriginalStates[scr] = scr.Disabled
        end
        pcall(function() scr.Disabled = true end)
        AntiScriptGenScr = scr
    end
    if scr.Name == "Skillcheck-player" then
        if not AntiScriptOriginalStates[scr] then
            AntiScriptOriginalStates[scr] = scr.Disabled
        end
        pcall(function() scr.Disabled = true end)
        AntiScriptPlrScr = scr
    end
end

local function AntiScript_RestoreOne(scr)
    if not scr then return end
    local originalState = AntiScriptOriginalStates[scr]
    if originalState ~= nil then
        pcall(function() scr.Disabled = originalState end)
    else
        pcall(function() scr.Disabled = false end)
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
    
    -- Restore script Skillcheck-gen
    if AntiScriptGenScr and AntiScriptGenScr.Parent then
        AntiScript_RestoreOne(AntiScriptGenScr)
    end
    
    -- Restore script Skillcheck-player
    if AntiScriptPlrScr and AntiScriptPlrScr.Parent then
        AntiScript_RestoreOne(AntiScriptPlrScr)
    end
    
    AntiScriptGenScr = nil
    AntiScriptPlrScr = nil
    AntiScriptOriginalStates = {}
end

-- ================================================================
-- AUTO ATTACK
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
-- AIMBOT (DENGAN TARGET PART DROPDOWN)
-- ================================================================
local AimTarget = nil

local function Aimbot_GetTargetPart(char)
    if not char then return nil end
    local targetPartName = Config.AIM_TargetPart
    local part = char:FindFirstChild(targetPartName)
    if part then return part end
    if targetPartName == "Left Arm" then
        part = char:FindFirstChild("LeftArm")
        if part then return part end
    end
    if targetPartName == "Torso" then
        part = char:FindFirstChild("Torso")
        if part then return part end
    end
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

local function Aimbot_Update(cam, screenCenter)
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
-- AUTO PARRY + PARRY FOV
-- FOV: 32 world-space line segments di lantai (circle outline putih + glow biru)
-- ================================================================
local ParryRemote     = nil
local ParryOnCooldown = false
local KillerHitConns  = {}
local ParryGuiBtn     = nil

-- PARRY FOV: Drawing Circle projected dari world space
-- Radius dihitung dari jarak kamera ke karakter dan PARRY_Dist
-- Hasilnya konsisten di semua sudut kamera (tidak oval/ngambang)
local ParryCircle = Drawing.new("Circle")
ParryCircle.Filled       = false
ParryCircle.Thickness    = 2
ParryCircle.NumSides     = 64
ParryCircle.Color        = Color3.fromRGB(0, 170, 255)
ParryCircle.Transparency = 1
ParryCircle.Visible      = false

-- Dummy compat
local PFOV_N = 1
local PFOVLines = {}
local function ParrySphere_Remove() ParryCircle.Visible = false end
local function ParryDisk_Remove()   ParryCircle.Visible = false end

local function UpdateParryFOV()
    if not Config.AUTO_Parry or not Config.PARRY_FOV then
        ParryCircle.Visible = false; return
    end
    local myRoot = GetCharacterRoot()
    if not myRoot then ParryCircle.Visible = false; return end

    local cam = workspace.CurrentCamera
    if not cam then ParryCircle.Visible = false; return end

    -- Project titik tengah karakter ke screen
    local centerSP, onScreen = WorldToScreen(myRoot.Position)
    if not onScreen then ParryCircle.Visible = false; return end

    -- Hitung radius screen dari jarak kamera dan PARRY_Dist (world units)
    -- Pakai titik di sisi kanan karakter sejauh PARRY_Dist
    local sidePos = myRoot.Position + cam.CFrame.RightVector * Config.PARRY_Dist
    local sideSP, _ = WorldToScreen(sidePos)
    local screenRadius = (sideSP - centerSP).Magnitude

    screenRadius = math.clamp(screenRadius, 10, 600)

    ParryCircle.Position     = centerSP
    ParryCircle.Radius       = screenRadius
    ParryCircle.Color        = ParryOnCooldown and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 170, 255)
    ParryCircle.Visible      = true
end

local AttackAnimIDs = {
    -- jason
    ["110355011987939"] = true, -- lungehold
    ["139369275981139"] = true, -- attack
    -- ayam
    ["105374834496520"] = true, -- lungehold
    ["106871536134254"] = true, -- attackalex
    ["109402730355822"] = true, -- attackalexdone
    ["111920872708571"] = true, -- attack
    ["115244153053858"] = true, -- lungeholdcobra
    ["117070354890871"] = true, -- lungeholdalex
    ["130593238885843"] = true, -- attackcobra
    ["138720291317243"] = true, -- attacktony + lungeholdtony
    -- hidden
    ["113255068724446"] = true, -- lungehold
    ["74968262036854"] = true, -- attack
    -- myers
    ["117042998468241"] = true, -- lungehold
    ["129918027564423"] = true, -- stage3lungehold
    ["133963973694098"] = true, -- attack
    ["95934119190708"] = true, -- stage3attack
    -- abys
    ["118907603246885"] = true, -- lungehold
    ["77081789642514"] = true, -- kick
    ["78432063483146"] = true, -- attack
    ["80411309607666"] = true, -- slash
    -- veil
    ["122812055447896"] = true, -- lungehold
    ["78935059863801"] = true, -- attack
    -- jeff
    ["129784271201071"] = true, -- lungehold
    ["132817836308238"] = true, -- attack
    ["82666958311998"] = true, -- attackfr
}

local NonAttackAnimIDs = {
    -- veil
    ["101784373049485"] = true, -- spearlungevm
    ["104239995665623"] = true, -- parriedvm
    ["109066149291691"] = true, -- knifeequipvm
    ["110953720370369"] = true, -- carryvm
    ["111427918159250"] = true, -- attackvm
    ["117224999672195"] = true, -- parriedvm (duplicate)
    ["118699522268698"] = true, -- wallhitstunvm
    ["122986861455212"] = true, -- spearlungeopvm
    ["123782306962803"] = true, -- lungeholdvm
    ["124191224140066"] = true, -- spearthrow1vm
    ["136859656743697"] = true, -- spearthrow2vm
    ["137688077908355"] = true, -- spearlunge2op
    ["137846825408335"] = true, -- takeoutspear2
    ["138045669415653"] = true, -- spearlunge1op
    ["139198068127517"] = true, -- spearequipvm
    ["139610361987372"] = true, -- stunnedvm
    ["139928639611415"] = true, -- idlespearon2
    ["75258958842388"] = true, -- takeoutspear1
    ["80105342981313"] = true, -- vaultvm
    ["84093948968516"] = true, -- spearlunge2
    ["86266790353635"] = true, -- spearthrow2
    ["90249435310475"] = true, -- breakvm
    ["92098503722633"] = true, -- spearlunge1
    ["93136435416899"] = true, -- spearthrow1
    ["94067810090105"] = true, -- hitvm
    ["96744338559260"] = true, -- idlespearon1
    -- jeff
    ["102182386301796"] = true, -- frenzyvaultvm
    ["113499071528107"] = true, -- lungeholdvm
    ["126100203042329"] = true, -- carryvm
    ["128387952281975"] = true, -- frenzyattackvm
    ["131476715474323"] = true, -- stunnedvm
    ["138125499040825"] = true, -- attackvm
    ["70746483345907"] = true, -- frenzywipevm
    ["76294518257930"] = true, -- breakvm
    ["79376988328260"] = true, -- frenzyendvm
    ["89642871504538"] = true, -- vaultvm
    ["90374658251379"] = true, -- wallhitvm
    ["91224543667492"] = true, -- wipevm
    -- myers
    ["84440437648153"] = true, -- stage3idle
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
            for _, btnName in ipairs({"Gui-mob"}) do
                local btn = controls:FindFirstChild(btnName)
                if btn then ParryGuiBtn = btn; return btn end
            end
        end
    end
    return nil
end

local function AutoParry_Fire()
    if Config.PARRY_Mode == "With Animation" then
        local btn = AutoParry_FindBtn()
        if btn then
            pcall(function()
                firesignal(btn.MouseButton1Down)
                firesignal(btn.MouseButton1Up)
            end)
            return true
        end
        return false
    else
        local remote = AutoParry_GetRemote()
        if remote then
            pcall(function() remote:FireServer() end)
            return true
        end
        return false
    end
end

local LastParryFireTime = 0

local function AutoParry_TryFire()
    if not Config.AUTO_Parry then return end
    if ParryOnCooldown then return end
    if GetRole() ~= "Survivor" then return end
    
    local now = tick()
    if now - LastParryFireTime < 0.5 then return end
    
    if AutoParry_Fire() then
        ParryOnCooldown = true
        LastParryFireTime = now
        task.delay(1.2, function() ParryOnCooldown = false end)
    end
end

-- HOOK KILLER DENGAN HEARTBEAT + ANIMATIONPLAYED (DOBEL AGAR TIDAK MISS)
local function AutoParry_HookKillerChar(char, player)
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
        
        -- METHOD 1: AnimationPlayed Event
        local conn1 = animator.AnimationPlayed:Connect(function(track)
            if not Config.AUTO_Parry then return end
            if not IsKiller(player) then return end

            local id = track.Animation.AnimationId
            local numId = id:match("%d+$") or id:match("id=(%d+)") or ""

            if NonAttackAnimIDs[numId] then return end
            if not AttackAnimIDs[numId] then return end

            local myRoot = GetCharacterRoot()
            local kr = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not kr then return end

            local dist = (kr.Position - myRoot.Position).Magnitude
            if dist > Config.PARRY_Dist then return end

            -- Direction check: pakai right arm/weapon hand killer
            -- Cek apakah right arm killer mengarah ke kita
            local rightArm = char:FindFirstChild("Right Arm")
                or char:FindFirstChild("RightHand")
                or char:FindFirstChild("RightUpperArm")
            if rightArm then
                local toMe = (myRoot.Position - rightArm.Position).Unit
                local armDir = rightArm.CFrame.LookVector
                local dot = armDir:Dot(toMe)
                -- dot > 0.2 = arm mengarah ke kita (dalam ~78 derajat)
                if dot > 0.2 then
                    AutoParry_TryFire()
                end
            else
                -- Fallback: HRP facing check jika arm tidak ditemukan
                local toMe = (myRoot.Position - kr.Position).Unit
                local dot = kr.CFrame.LookVector:Dot(toMe)
                if dot > 0.3 then
                    AutoParry_TryFire()
                end
            end
        end)
        table.insert(KillerHitConns, conn1)

        -- METHOD 2: Heartbeat GetPlayingAnimationTracks
        local lastFiredTrack = ""
        local conn2 = RunService.Heartbeat:Connect(function()
            if not Config.AUTO_Parry then return end
            if ParryOnCooldown then return end
            if not IsKiller(player) then return end

            local myRoot = GetCharacterRoot()
            local kr = char:FindFirstChild("HumanoidRootPart")
            if not myRoot or not kr then return end

            local dist = (kr.Position - myRoot.Position).Magnitude
            if dist > Config.PARRY_Dist then return end

            -- Direction check pakai right arm
            local rightArm = char:FindFirstChild("Right Arm")
                or char:FindFirstChild("RightHand")
                or char:FindFirstChild("RightUpperArm")
            local dirOk = false
            if rightArm then
                local toMe = (myRoot.Position - rightArm.Position).Unit
                dirOk = rightArm.CFrame.LookVector:Dot(toMe) > 0.2
            else
                dirOk = kr.CFrame.LookVector:Dot((myRoot.Position - kr.Position).Unit) > 0.3
            end
            if not dirOk then return end

            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if track.IsPlaying then
                    local numId = track.Animation.AnimationId:match("%d+$") or ""
                    if AttackAnimIDs[numId] and numId ~= lastFiredTrack then
                        lastFiredTrack = numId
                        task.delay(0.3, function() lastFiredTrack = "" end)
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
end

local function AutoParry_Cleanup()
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}
    ParryOnCooldown = false
    ParryGuiBtn = nil
    ParryCircle.Visible = false
end

-- ================================================================
-- THIRD PERSON (DARI TESVIDE.LUA - WORKING)
-- ================================================================
local OriginalCameraType = nil
local ThirdPersonWasActive = false
local ThirdPersonCharConn = nil
local ThirdPersonRenderConn = nil
local ThirdPersonDisabledScripts = {}

local function ThirdPerson_DisableOverrides(char)
    if not char then return end
    -- Disable script Firstperson
    local fp = char:FindFirstChild("Firstperson")
    if fp and not fp.Disabled then
        pcall(function() fp.Disabled = true end)
        table.insert(ThirdPersonDisabledScripts, fp)
    end
    -- Set zoom distance
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 20
        LocalPlayer.CameraMinZoomDistance = 7
    end)
    -- Paksa CameraSubject ke Humanoid
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
        -- Disable Firstperson
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

    -- Zoom out
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
    local inGame = role == "Killer" or role == "Survivor"
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

-- ================================================================
-- MOVEMENT FEATURES
-- ================================================================
local SpeedWasOn = false
local OriginalSpeedStore = nil

local function UpdateSpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if Config.SPEED_Enabled then
        -- Simpan speed asli hanya satu kali saat pertama aktif
        if not SpeedWasOn then
            OriginalSpeedStore = hum.WalkSpeed
            SpeedWasOn = true
        end
        hum.WalkSpeed = Config.SPEED_Value
    else
        -- Kembalikan dan jangan sentuh lagi
        if SpeedWasOn and OriginalSpeedStore then
            hum.WalkSpeed = OriginalSpeedStore
            OriginalSpeedStore = nil
        end
        SpeedWasOn = false
        -- PENTING: jangan set WalkSpeed apapun saat disabled
        -- biarkan game/server yang kontrol
    end
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


local function UpdateNoSlowdown()
    if not Config.KILLER_NoSlowdown then return end
    if GetRole() ~= "Killer" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- Hanya restore kalau speed di-force ke 0 (stun total), bukan saat sprint normal
    -- Speed < 4 = kemungkinan besar stun dari pallet/survivor ability
    if hum.WalkSpeed > 0 and hum.WalkSpeed < 4 then
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
        local cam = Workspace.CurrentCamera
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



-- ================================================================
-- TELEPORT FUNCTIONS
-- ================================================================
local function TeleportToGenerator(index)
    local root = GetCharacterRoot()
    if not root then return end
    if #Cache.Generators == 0 then return end
    local g = Cache.Generators[math.clamp(index or 1, 1, #Cache.Generators)]
    if g and g.part then
        root.CFrame = CFrame.new(g.part.Position + Vector3.new(0, Config.TP_Offset, 0))
    end
end

local function TeleportToGate()
    local root = GetCharacterRoot()
    if not root then return end
    if #Cache.Gates == 0 then return end
    local g = Cache.Gates[1]
    if g and g.part then
        root.CFrame = CFrame.new(g.part.Position + Vector3.new(0, Config.TP_Offset, 0))
    end
end

local function TeleportToHook()
    local root = GetCharacterRoot()
    if not root then return end
    if Cache.ClosestHook and Cache.ClosestHook.part then
        root.CFrame = CFrame.new(Cache.ClosestHook.part.Position + Vector3.new(0, Config.TP_Offset, 0))
    end
end

-- ================================================================
-- GOD MODE
-- ================================================================
local GodModeConn = nil

local function GodMode_Start()
    if GodModeConn then GodModeConn:Disconnect() end
    GodModeConn = RunService.Heartbeat:Connect(function()
        if not Config.SURV_GodMode then 
            if GodModeConn then GodModeConn:Disconnect(); GodModeConn = nil end
            return 
        end
        if GetRole() ~= "Survivor" then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end)
end

local function GodMode_Stop()
    if GodModeConn then GodModeConn:Disconnect(); GodModeConn = nil end
end

-- ================================================================
-- FULLBRIGHT & NO FOG (DARI TESVIDE.LUA)
-- ================================================================
local OriginalLighting = {}

local function Fullbright_On()
    local Lighting = game:GetService("Lighting")
    
    -- Simpan nilai asli (cuma sekali, pas pertama kali ON)
    if not OriginalLighting.Saved then
        OriginalLighting.Ambient = Lighting.Ambient
        OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        OriginalLighting.Brightness = Lighting.Brightness
        OriginalLighting.ShadowSoftness = Lighting.ShadowSoftness
        OriginalLighting.GlobalShadows = Lighting.GlobalShadows
        OriginalLighting.Saved = true
    end
    
    -- Set ke fullbright
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.ShadowSoftness = 0
    Lighting.GlobalShadows = false
    
    -- Matiin effect
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
    
    -- Balikin ke nilai asli
    if OriginalLighting.Saved then
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ShadowSoftness = OriginalLighting.ShadowSoftness
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
    
    -- Hidupin lagi effect
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or
           v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or
           v:IsA("BloomEffect") then
            pcall(function() v.Enabled = true end)
        end
    end
end

-- NO FOG (dari tesvide.lua)
local function RemoveFog()
    pcall(function()
        local lighting = game:GetService("Lighting")
        -- Simpan original
        FogCache.FogEnd = lighting.FogEnd
        FogCache.FogStart = lighting.FogStart
        -- Set fog ke max agar tidak kelihatan
        lighting.FogEnd = 100000
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
        lighting.FogEnd = FogCache.FogEnd or 1000
        lighting.FogStart = FogCache.FogStart or 0
        for _, obj in ipairs(lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then
                obj.Density = FogCache.AtmDensity or 0.3
            end
        end
        FogCache = {}
    end)
end

local function UpdateVisuals()
    if Config.FULLBRIGHT then
        Fullbright_On()
    else
        Fullbright_Off()
    end
    
    if Config.NO_Fog then
        RemoveFog()
    else
        RestoreFog()
    end
end

-- ================================================================
-- FOV & CROSSHAIR DRAWINGS
-- ================================================================
local FOV_SEGMENTS = 48
local FOVLines = {}
for i = 1, FOV_SEGMENTS do
    local l = Drawing.new("Line")
    l.Thickness = 1.5
    l.Color = Color3.fromRGB(0, 170, 255)
    l.Transparency = 1
    l.Visible = false
    FOVLines[i] = l
end

local CrossLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 2
    l.Color = Color3.fromRGB(255, 255, 255)
    l.Transparency = 1
    l.Visible = false
    CrossLines[i] = l
end

local function UpdateDrawings(cam, screenCenter)
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
-- ROLE MANAGER (AUTO REAPPLY FITUR)
-- ================================================================
local CurrentRole = GetRole()
local RoleManagerConn = nil
local RoleCharConn = nil

local function ReapplyFeaturesForRole(role)
    if State.Unloaded then return end
    
    if role == "Spectator" then
        if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
        if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = OriginalSpeedStore
                hum.PlatformStand = false
            end
        end
        return
    end
    
    task.delay(1.5, function()
        if State.Unloaded or GetRole() ~= role then return end
        
        ScanMap()
        ESPRefreshMap()
        
        if Config.AUTO_Parry then
            pcall(AutoParry_Cleanup)
            pcall(AutoParry_Setup)
        end
        
        if Config.PERFECT_SkillCheck then
            pcall(PerfectSC_Stop)
            pcall(PerfectSC_Setup)
        end
        
        if Config.ANTI_SkillCheck and LocalPlayer.Character then
            pcall(AntiScript_Apply, LocalPlayer.Character)
        end
        
        if Config.SURV_GodMode and role == "Survivor" then
            pcall(GodMode_Start)
        elseif role ~= "Survivor" then
            pcall(GodMode_Stop)
        end
        
        pcall(UpdateThirdPerson)
        pcall(UpdateVisuals)
        
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and not Config.SPEED_Enabled then
                hum.WalkSpeed = OriginalSpeedStore
            end
        end
    end)
end

local function SetupRoleManager()
    if RoleManagerConn then RoleManagerConn:Disconnect() end
    if RoleCharConn then RoleCharConn:Disconnect() end
    
    RoleManagerConn = LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        local newRole = GetRole()
        if newRole == CurrentRole then return end
        CurrentRole = newRole
        ReapplyFeaturesForRole(newRole)
    end)
    
    RoleCharConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        local newRole = GetRole()
        CurrentRole = newRole
        ReapplyFeaturesForRole(newRole)
    end)
end

-- ================================================================
-- MAIN LOOP
-- ================================================================
local lastUpdate = 0
local lastGenCheck = 0

local function MainLoop()
    if State.Unloaded then return end
    
    local cam = Workspace.CurrentCamera
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
        UpdatePlayerESP()
        
        if now - lastGenCheck >= 0.2 then
            lastGenCheck = now
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
    end
    
    Aimbot_Update(cam, screenCenter)
    UpdateDrawings(cam, screenCenter)
    UpdateParryFOV()
end

-- ================================================================
-- MISSING FUNCTIONS (dari sourcevd.lua)
-- ================================================================

-- State vars yang dibutuhkan
local OriginalHitboxSizes = {}
local OriginalJumpPower = nil
local LastAutoHookTime = 0
local AutoHookState = { phase = 0, target = nil, startTime = 0 }

local function IsPlayerDowned(hum)
    if not hum or hum.MaxHealth <= 0 then return false end
    local pct = hum.Health / hum.MaxHealth
    return pct <= 0.25 and pct > 0
end

local function IsPlayerAlive(hum)
    if not hum or hum.MaxHealth <= 0 then return false end
    local pct = hum.Health / hum.MaxHealth
    return pct > 0.25
end

-- HITBOX EXPANDER
local function UpdateHitboxes()
    if GetRole() ~= "Killer" or not Config.HITBOX_Enabled then
        for player, originalSize in pairs(OriginalHitboxSizes) do
            if player and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then root.Size = originalSize; root.Transparency = 1; root.CanCollide = true end
            end
        end
        OriginalHitboxSizes = {}
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum  = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                if not OriginalHitboxSizes[player] then OriginalHitboxSizes[player] = root.Size end
                local s = Config.HITBOX_Size
                root.Size = Vector3.new(s, s, s); root.CanCollide = false; root.Transparency = 0.7
            end
        end
    end
end

-- JUMP POWER
local function UpdateJumpPower()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    if not OriginalJumpPower then OriginalJumpPower = hum.JumpPower end
    if Config.JUMP_Infinite then
        hum.JumpPower = Config.JUMP_Power; hum.UseJumpPower = true
    end
end

-- AUTO HOOK helpers
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
    local cam = workspace.CurrentCamera; if not cam then return end
    local root = GetCharacterRoot(); if not root then return end
    cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
end

local function AutoHook_IsHookOccupied(hook)
    if not hook or not hook.part then return true end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if pRoot and (pRoot.Position - hook.part.Position).Magnitude < 8 then return true end
        end
    end
    return false
end

local function AutoHook_FindBestHook()
    local root = GetCharacterRoot(); if not root then return nil end
    local bestHook, bestDist = nil, math.huge
    for _, hook in ipairs(Cache.Hooks) do
        if hook.part and hook.part.Parent and not AutoHook_IsHookOccupied(hook) then
            local d = (hook.part.Position - root.Position).Magnitude
            if d < bestDist then bestDist = d; bestHook = hook end
        end
    end
    return bestHook
end

local function AutoHook()
    if not Config.KILLER_AutoHook then AutoHookState.phase=0; AutoHookState.target=nil; return end
    if GetRole() ~= "Killer" then AutoHookState.phase=0; AutoHookState.target=nil; return end
    local root = GetCharacterRoot(); if not root then return end
    local char = LocalPlayer.Character; if not char then return end

    if AutoHookState.phase == 3 then
        if tick() - AutoHookState.startTime > 2 then AutoHookState.phase=0; AutoHookState.target=nil; LastAutoHookTime=tick() end
        return
    end
    if AutoHookState.phase == 2 then
        local hook = AutoHook_FindBestHook()
        if hook and hook.part then
            for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
            local hp = hook.part.Position
            root.CFrame = CFrame.new(hp + Vector3.new(0,2,0), hp)
            AutoHook_LookAt(hp); AutoHook_SpamSpace(1.5)
            task.delay(0.3, function()
                if LocalPlayer.Character then
                    for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide=true end
                    end
                end
            end)
            AutoHookState.phase=3; AutoHookState.startTime=tick()
        else AutoHookState.phase=0; AutoHookState.target=nil end
        return
    end
    if AutoHookState.phase == 1 then
        if tick() - AutoHookState.startTime > 1.5 then AutoHookState.phase=2 end
        return
    end
    if tick() - LastAutoHookTime < 0.5 then return end

    local closestDowned, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local tHum  = player.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and IsPlayerDowned(tHum) then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < closestDist then closestDist=d; closestDowned={player=player, root=tRoot} end
            end
        end
    end
    if closestDowned then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        local tp = closestDowned.root.Position
        root.CFrame = CFrame.new(tp + Vector3.new(0,3,0), tp + Vector3.new(0,-5,0))
        AutoHook_LookAt(tp); AutoHook_SpamSpace(1.5)
        AutoHookState.phase=1; AutoHookState.target=closestDowned.player; AutoHookState.startTime=tick()
        task.delay(0.5, function()
            if LocalPlayer.Character then
                for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide=true end
                end
            end
        end)
    end
end

-- BEAT GAME SURVIVOR
local function BeatGameSurvivor()
    if not Config.BEAT_Survivor then State.BeatSurvivorDone=false; State.LastFinishPos=nil; return end
    if GetRole() ~= "Survivor" then return end
    local root = GetCharacterRoot(); if not root then return end
    local map = Workspace:FindFirstChild("Map"); if not map then return end
    local exitPos = nil
    pcall(function()
        if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then exitPos=Vector3.new(3098.16,454.04,-4918.74); return end
        if map:FindFirstChild("HooksMeat") then exitPos=Vector3.new(1546.12,152.21,-796.72); return end
        if map:FindFirstChild("churchbell") then exitPos=Vector3.new(760.98,-20.14,-78.48); return end
        local finish = map:FindFirstChild("Finishline") or map:FindFirstChild("FinishLine") or map:FindFirstChild("Fininshline")
        if finish then
            if finish:IsA("BasePart") then exitPos=finish.Position
            elseif finish:IsA("Model") then local p=finish:FindFirstChildWhichIsA("BasePart"); if p then exitPos=p.Position end end
            return
        end
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name:lower():find("finish") then
                if obj:IsA("BasePart") then exitPos=obj.Position; break
                elseif obj:IsA("Model") then local p=obj:FindFirstChildWhichIsA("BasePart"); if p then exitPos=p.Position; break end end
            end
        end
    end)
    if not exitPos then return end
    if State.LastFinishPos and (exitPos-State.LastFinishPos).Magnitude > 50 then State.BeatSurvivorDone=false end
    if State.BeatSurvivorDone then return end
    root.CFrame = CFrame.new(exitPos + Vector3.new(0,3,0))
    State.BeatSurvivorDone=true; State.LastFinishPos=exitPos
end

-- BEAT GAME KILLER
local function BeatGameKiller()
    if not Config.BEAT_Killer then State.KillerTarget=nil; return end
    if GetRole() ~= "Killer" then State.KillerTarget=nil; return end
    local root = GetCharacterRoot(); if not root then return end
    local target = State.KillerTarget
    if target and target.Character then
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local tHum  = target.Character:FindFirstChildOfClass("Humanoid")
        if not (tRoot and tHum and IsPlayerAlive(tHum)) then State.KillerTarget=nil; target=nil end
    end
    if not target then
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and IsSurvivor(p) and p.Character then
                local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                local pHum  = p.Character:FindFirstChildOfClass("Humanoid")
                if pRoot and pHum and IsPlayerAlive(pHum) then
                    local d = (pRoot.Position - root.Position).Magnitude
                    if d < bd then bd=d; best=p end
                end
            end
        end
        State.KillerTarget=best; target=best
    end
    if not target or not target.Character then return end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local tHum  = target.Character:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or not IsPlayerAlive(tHum) then State.KillerTarget=nil; return end
    for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    local dir = (root.Position - tRoot.Position).Unit
    if dir ~= dir then dir = Vector3.new(1,0,0) end
    root.CFrame = CFrame.new(tRoot.Position + dir*3 + Vector3.new(0,1,0), tRoot.Position)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes"); if not remotes then return end
        local attacks = remotes:FindFirstChild("Attacks"); if not attacks then return end
        local ba = attacks:FindFirstChild("BasicAttack"); if ba then ba:FireServer(false) end
    end)
end
local function UpdateSpearAim()
    if not Config.SPEAR_Aimbot then return end
    if GetRole() ~= "Killer" then return end
    local root = GetCharacterRoot()
    if not root then return end
    local closest, cd = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsSurvivor(p) and p.Character then
            local pr = p.Character:FindFirstChild("HumanoidRootPart")
            if pr then
                local vis = Cache.Visibility and Cache.Visibility[p]
                if Config_SpearThrough or vis then
                    local d = (pr.Position - root.Position).Magnitude
                    if d < cd then cd = d; closest = p end
                end
            end
        end
    end
    if closest and closest.Character then
        local pr = closest.Character:FindFirstChild("HumanoidRootPart")
        if pr then
            local startPos = root.Position + Vector3.new(0, 2, 0)
            local dist     = (pr.Position - startPos).Magnitude
            local t        = dist / math.max(Config.SPEAR_Speed, 1)
            local drop     = 0.5 * Config.SPEAR_Gravity * t * t
            local aimPos   = pr.Position + Vector3.new(0, drop, 0)
            local cam      = workspace.CurrentCamera
            if cam then
                cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos)
            end
        end
    end
end

local function AutoLoop()
    while not State.Unloaded do
        AutoAttack()
        UpdateSpeed()
        BeatGameSurvivor()
        BeatGameKiller()
        UpdateHitboxes()
        DoubleTap()
        UpdateNoSlowdown()
        AutoHook()
        UpdateNoclip()
        UpdateFly()
        UpdateNoFall()
        UpdateThirdPerson()
        UpdateVisuals()
        UpdateSpearAim()
        task.wait(0.1)
    end
end

-- ================================================================
-- UNLOAD FUNCTION
-- ================================================================
local function Unload()
    State.Unloaded = true
    
    -- Cleanup FOV dan Crosshair lines (yang masih dipake)
    for i = 1, FOV_SEGMENTS do pcall(function() FOVLines[i]:Remove() end) end
    for i = 1, 4 do pcall(function() CrossLines[i]:Remove() end) end
    pcall(function() ParryCircle:Remove() end)
    
    pcall(AntiScript_Restore)
    pcall(PerfectSC_Stop)
    pcall(AutoParry_Cleanup)
    ParryCircle.Visible = false
    pcall(ThirdPerson_Remove)
    pcall(Fullbright_Off)    
    pcall(RestoreFog)
    pcall(GodMode_Stop)
    
    -- ... lanjutkan kode Unload lainnya (cleanup ESP, dll) ...
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "_VHLight" or obj.Name == "_VHTag" or obj.Name == "_VHGenTag" then
            obj:Destroy()
        end
    end
    
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
    if RoleManagerConn then RoleManagerConn:Disconnect() end
    if RoleCharConn then RoleCharConn:Disconnect() end
    
    pcall(function() Window:Destroy() end)
    print("[Victoria] Unloaded")
end

local VelarisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/dist/main.lua", true))()

-- ================================================================
-- WINDOW
-- ================================================================
local Window = VelarisUI:Window({
    Title          = "Victoria Hub",
    Footer         =  " ",
    Content        = "Violence District",
    Color          = "Blue",
    Version        = "1.0",
    ["Tab Width"]  = 110,
    Image          = "96751490485303",
    Uitransparent  = 0.15,
    ShowUser       = true,
    Search         = true,
    Config = {
        AutoSave   = true,
        AutoLoad   = true
    },
    KeySystem = {
        Title    = "Victoria Hub",
        Default  = "VD-KEYLESS",
        Callback = function(key) 
            return key == "VD-KEYLESS" or key == "VICTORIA2025" 
        end
    }
})

Window:Tag({
    Title = "v1.0",
    Color = Color3.fromRGB(66, 135, 245),
})

-- ================================================================
-- TABS
-- ================================================================
local Tabs = {
    ESP       = Window:AddTab({ Name = "ESP",       Icon = "lucide:eye"        }),
    AIM       = Window:AddTab({ Name = "Aim",       Icon = "lucide:crosshair"  }),
    SURVIVOR  = Window:AddTab({ Name = "Survivor",  Icon = "lucide:user"       }),
    KILLER    = Window:AddTab({ Name = "Killer",    Icon = "lucide:sword"      }),
    MOVEMENT  = Window:AddTab({ Name = "Movement",  Icon = "lucide:gamepad-2"  }),
    MISC      = Window:AddTab({ Name = "Misc",      Icon = "lucide:settings"   }),
    CONFIG    = Window:AddTab({ Name = "Config",    Icon = "lucide:folder"     }),
}

-- ================================================================
-- ESP TAB
-- ================================================================

local secPlayers = Tabs.ESP:AddSection({ Title = "Players", open = false })
secPlayers:AddToggle({ 
    Title = "Killer ESP", 
    Default = false, 
    Callback = function(v) Config.ESP_Killer = v end 
})
secPlayers:AddToggle({ 
    Title = "Survivor ESP", 
    Default = false, 
    Callback = function(v) Config.ESP_Survivor = v end 
})
secPlayers:AddToggle({ 
    Title = "Names", 
    Default = true, 
    Callback = function(v) Config.ESP_Names = v end 
})
secPlayers:AddToggle({ 
    Title = "Distance", 
    Default = true, 
    Callback = function(v) Config.ESP_Distance = v end 
})
secPlayers:AddToggle({ 
    Title = "Health", 
    Default = true, 
    Callback = function(v) Config.ESP_Health = v end 
})

local secObjects = Tabs.ESP:AddSection({ Title = "Objects", Open = false })
secObjects:AddToggle({ 
    Title = "Generator", 
    Default = false, 
    Callback = function(v) Config.ESP_Generator = v; ESPRefreshMap() end 
})
secObjects:AddToggle({ 
    Title = "Gate", 
    Default = false, 
    Callback = function(v) Config.ESP_Gate = v; ESPRefreshMap() end 
})
secObjects:AddToggle({ 
    Title = "Hook", 
    Default = false, 
    Callback = function(v) Config.ESP_Hook = v; ESPRefreshMap() end 
})
secObjects:AddToggle({ 
    Title = "Pallet", 
    Default = false, 
    Callback = function(v) Config.ESP_Pallet = v; ESPRefreshMap() end 
})
secObjects:AddToggle({ 
    Title = "Window", 
    Default = false, 
    Callback = function(v) Config.ESP_Window = v; ESPRefreshMap() end 
})

-- ================================================================
-- AIM TAB
-- ================================================================

local secAim = Tabs.AIM:AddSection({ Title = "Aimbot", open = false })
secAim:AddToggle({ 
    Title = "Enable Aimbot", 
    Default = false, 
    Callback = function(v) Config.AIM_Enabled = v end 
})
secAim:AddToggle({ 
    Title = "Aiming For Aimbot", 
    Default = true, 
    Callback = function(v) Config.AIM_AutoMode = v end 
})

secAim:AddDropdown({ 
    Title    = "Target Mode", 
    Options  = { "Auto", "Killer", "Survivor", "Closest" }, 
    Default  = "Auto", 
    Callback = function(v) Config.AIM_TargetMode = v end 
})

secAim:AddDropdown({ 
    Title    = "Target Part", 
    Options  = { "Left Arm", "Torso", "HumanoidRootPart" }, 
    Default  = "Left Arm", 
    Callback = function(v) Config.AIM_TargetPart = v end 
})

secAim:AddSlider({ 
    Title = "FOV Size", 
    Min = 50, Max = 400, Default = 120, 
    Callback = function(v) Config.AIM_FOV = v end 
})

secAim:AddSlider({ 
    Title = "Smoothness", 
    Min = 1, Max = 20, Default = 6, 
    Callback = function(v) Config.AIM_Smooth = v / 20 end 
})

secAim:AddToggle({ 
    Title = "Visibility Check", 
    Default = true, 
    Callback = function(v) Config.AIM_VisCheck = v end 
})

secAim:AddToggle({ 
    Title = "Prediction", 
    Default = true, 
    Callback = function(v) Config.AIM_Predict = v end 
})

secAim:AddToggle({ 
    Title = "Show FOV", 
    Default = false, 
    Callback = function(v) Config.AIM_ShowFOV = v end 
})

local secCrossh = Tabs.AIM:AddSection({ Title = "Crosshair", open = false })

secCrossh:AddToggle({ 
    Title = "Enable Crosshair", 
    Default = false, 
    Callback = function(v) Config.AIM_Crosshair = v end 
})

-- Spear Aimbot Section
local secSpear = Tabs.AIM:AddSection({ Title = "Spear Aimbot (Veil)", Open = false })
secSpear:AddToggle({ 
    Title = "Spear Aimbot", 
    Default = false, 
    Callback = function(v) Config.SPEAR_Aimbot = v end 
})

secSpear:AddSlider({ 
    Title = "Spear Gravity", 
    Min = 10, Max = 500, Default = 50, 
    Callback = function(v) Config.SPEAR_Gravity = v end 
})

secSpear:AddSlider({ 
    Title = "Spear Speed", 
    Min = 50, Max = 500, Default = 100, 
    Callback = function(v) Config.SPEAR_Speed = v end 
})

-- ================================================================
-- SURVIVOR TAB
-- ================================================================

local secSurv = Tabs.SURVIVOR:AddSection({ Title = "Survivor", open = false })

secSurv:AddToggle({ 
    Title = "Remove Skill Check", 
    Default = false, 
    Callback = function(v) 
        Config.ANTI_SkillCheck = v
        if v then 
            if LocalPlayer.Character then
                AntiScript_Apply(LocalPlayer.Character)
            end
        else 
            AntiScript_Restore()
        end
    end 
})

secSurv:AddToggle({ 
    Title = "Perfect Skill Check", 
    Default = false, 
    Callback = function(v) 
        Config.PERFECT_SkillCheck = v
        if v then 
            PerfectSC_Setup() 
        else 
            PerfectSC_Stop() 
        end
    end 
})

secSurv:AddToggle({ 
    Title = "God Mode", 
    Default = false, 
    Callback = function(v) 
        Config.SURV_GodMode = v
        if v then 
            GodMode_Start() 
        else 
            GodMode_Stop() 
        end
    end 
})

secSurv:AddToggle({ 
    Title = "No Fall Damage", 
    Default = false, 
    Callback = function(v) Config.SURV_NoFall = v end 
})

-- Auto Parry Section
local secParry = Tabs.SURVIVOR:AddSection({ Title = "Auto Parry", Open = false })

secParry:AddToggle({ 
    Title = "Auto Parry", 
    Default = false, 
    Callback = function(v) 
        Config.AUTO_Parry = v
        if v then 
            AutoParry_Setup() 
        else 
            AutoParry_Cleanup() 
        end
    end 
})

secParry:AddDropdown({ 
    Title    = "Parry Mode", 
    Options  = { "With Animation", "No Animation" }, 
    Default  = "With Animation", 
    Callback = function(v) Config.PARRY_Mode = v end 
})

secParry:AddSlider({ 
    Title = "Parry Distance", 
    Min = 5, Max = 40, Default = 13, 
    Callback = function(v) Config.PARRY_Dist = v end 
})

secParry:AddToggle({ 
    Title = "Show Parry FOV", 
    Default = false, 
    Callback = function(v) Config.PARRY_FOV = v end 
})

-- Beat Game Section
local secBeatSurv = Tabs.SURVIVOR:AddSection({ Title = "Beat Game", Open = false })
secBeatSurv:AddToggle({ 
    Title = "Beat As Survivor", 
    Default = false, 
    Callback = function(v) Config.BEAT_Survivor = v end 
})

-- ================================================================
-- KILLER TAB
-- ================================================================

local secCombat = Tabs.KILLER:AddSection({ Title = "Combat", open = false })

secCombat:AddToggle({ 
    Title = "Auto Attack", 
    Default = false, 
    Callback = function(v) Config.AUTO_Attack = v end 
})

secCombat:AddSlider({ 
    Title = "Attack Range", 
    Min = 5, Max = 20, Default = 12, 
    Callback = function(v) Config.AUTO_AttackRange = v end 
})

secCombat:AddToggle({ 
    Title = "Double Tap", 
    Default = false, 
    Callback = function(v) Config.KILLER_DoubleTap = v end 
})

secCombat:AddToggle({ 
    Title = "Infinite Lunge", 
    Default = false, 
    Callback = function(v) Config.KILLER_InfiniteLunge = v end 
})

secCombat:AddToggle({ 
    Title = "Auto Hook", 
    Default = false, 
    Callback = function(v) Config.KILLER_AutoHook = v end 
})

-- Hitbox Section
local secHitbox = Tabs.KILLER:AddSection({ Title = "Hitbox", Open = false })

secHitbox:AddToggle({ 
    Title = "Hitbox Expander", 
    Default = false, 
    Callback = function(v) Config.HITBOX_Enabled = v end 
})

secHitbox:AddSlider({ 
    Title = "Hitbox Size", 
    Min = 5, Max = 30, Default = 15, 
    Callback = function(v) Config.HITBOX_Size = v end 
})

-- Protection Section
local secProtection = Tabs.KILLER:AddSection({ Title = "Protection", Open = false })

secProtection:AddToggle({ 
    Title = "No Pallet Stun", 
    Default = false, 
    Callback = function(v) Config.KILLER_NoPalletStun = v end 
})

secProtection:AddToggle({ 
    Title = "Anti Blind", 
    Default = false, 
    Callback = function(v) Config.KILLER_AntiBlind = v end 
})

secProtection:AddToggle({ 
    Title = "No Slowdown", 
    Default = false, 
    Callback = function(v) Config.KILLER_NoSlowdown = v end 
})

-- Destruction Section
local secDestruction = Tabs.KILLER:AddSection({ Title = "Destruction", Open = false })

secDestruction:AddToggle({ 
    Title = "Full Gen Break", 
    Default = false, 
    Callback = function(v) Config.KILLER_FullGenBreak = v end 
})

secDestruction:AddToggle({ 
    Title = "Destroy All Pallets", 
    Default = false, 
    Callback = function(v) Config.KILLER_DestroyPallets = v end 
})

-- Killer Camera Section
local secKillerCamera = Tabs.KILLER:AddSection({ Title = "Camera", Open = false })

secKillerCamera:AddToggle({ 
    Title = "Third Person", 
    Default = false, 
    Callback = function(v) 
        Config.CAM_ThirdPerson = v
        UpdateThirdPerson() 
    end 
})

-- Beat Game Section
local secBeatKill = Tabs.KILLER:AddSection({ Title = "Beat Game", Open = false })
secBeatKill:AddToggle({ 
    Title = "Beat As Killer", 
    Default = false, 
    Callback = function(v) Config.BEAT_Killer = v end 
})

-- ================================================================
-- MOVEMENT TAB
-- ================================================================

local secSpeed = Tabs.MOVEMENT:AddSection({ Title = "Speed", open = false })

secSpeed:AddToggle({ 
    Title = "Speed Hack", 
    Default = false, 
    Callback = function(v) Config.SPEED_Enabled = v end 
})

secSpeed:AddSlider({ 
    Title = "Speed Value", 
    Min = 16, Max = 150, Default = 32, 
    Callback = function(v) Config.SPEED_Value = v end 
})

-- Flight Section
local secFly = Tabs.MOVEMENT:AddSection({ Title = "Flight", Open = false })

secFly:AddToggle({ 
    Title = "Fly", 
    Default = false, 
    Callback = function(v) Config.FLY_Enabled = v end 
})

secFly:AddSlider({ 
    Title = "Fly Speed", 
    Min = 10, Max = 200, Default = 50, 
    Callback = function(v) Config.FLY_Speed = v end 
})

-- Collision Section
local secCollision = Tabs.MOVEMENT:AddSection({ Title = "Collision", Open = false })

secCollision:AddToggle({ 
    Title = "Noclip", 
    Default = false, 
    Callback = function(v) Config.NOCLIP_Enabled = v end 
})

-- Teleport Section
local secTeleport = Tabs.MOVEMENT:AddSection({ Title = "Teleport", Open = false })

secTeleport:AddSlider({ 
    Title = "TP Height Offset", 
    Min = 0, Max = 10, Default = 3, 
    Callback = function(v) Config.TP_Offset = v end 
})

secTeleport:AddButton({ 
    Title = "TP to Generator", 
    Callback = function() TeleportToGenerator(1) end 
})

secTeleport:AddButton({ 
    Title = "TP to Gate", 
    Callback = TeleportToGate 
})

secTeleport:AddButton({ 
    Title = "TP to Hook", 
    Callback = TeleportToHook 
})

-- ================================================================
-- MISC TAB
-- ================================================================

local secVisual = Tabs.MISC:AddSection({ Title = "Visual", open = false })

secVisual:AddToggle({ 
    Title = "No Fog", 
    Default = false, 
    Callback = function(v) 
        Config.NO_Fog = v
        UpdateVisuals() 
    end 
})

secVisual:AddToggle({ 
    Title = "Fullbright", 
    Default = false, 
    Callback = function(v) 
        Config.FULLBRIGHT = v
        UpdateVisuals() 
    end 
})

-- Fling Section
local secFling = Tabs.MISC:AddSection({ Title = "Fling", Open = false })

secFling:AddToggle({ 
    Title = "Fling Enable", 
    Default = false, 
    Callback = function(v) Config.FLING_Enabled = v end 
})

secFling:AddSlider({ 
    Title = "Fling Strength", 
    Min = 1000, Max = 50000, Default = 10000, 
    Callback = function(v) Config.FLING_Strength = v end 
})

-- Keybinds Section
local secKeybinds = Tabs.MISC:AddSection({ Title = "Keybinds", Open = false })

secKeybinds:AddParagraph({ 
    Title = "Info", 
    Content = "Panic: HOME\nSpeed: C | Fly: F | Noclip: V\nTP Gen: G | TP Gate: T | TP Hook: H" 
})

-- System Section
local secSystem = Tabs.MISC:AddSection({ Title = "System", Open = false })

secSystem:AddButton({ 
    Title = "Unload Script", 
    Callback = function()
        task.delay(0.5, function() Unload() end)
    end 
})

-- ================================================================
-- CONFIG TAB
-- ================================================================

local secConfig = Tabs.CONFIG:AddSection({ Title = "Configuration", open = false })

secConfig:AddParagraph({ 
    Title = "Settings", 
    Content = "Config settings will be here.\nSave and load your preferences." 
})

secConfig:AddButton({ 
    Title = "Save Config", 
    Callback = function()
        print("Config saved!")
    end 
})

secConfig:AddButton({ 
    Title = "Load Config", 
    Callback = function()
        print("Config loaded!")
    end 
})

secConfig:AddButton({ 
    Title = "Reset Defaults", 
    Callback = function()
        print("Defaults restored!")
    end 
})

-- ================================================================
-- INITIALIZATION
-- ================================================================
local function Init()
    OriginalAmbient = Lighting.Ambient
    OriginalOutdoorAmbient = Lighting.OutdoorAmbient
    OriginalBrightness = Lighting.Brightness
    
    ScanMap()
    ESPRefreshMap()
    PerfectSC_Setup()
    AutoParry_Setup()
    UpdateThirdPerson()
    UpdateVisuals()
    pcall(SetupAntiBlind)
    pcall(SetupNoPalletStun)
    SetupRoleManager()
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            ScanMap()
            ESPRefreshMap()
            UpdateVisuals()
        end
    end)
    
    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        ScanMap()
        ESPRefreshMap()
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if player.Character then
            RemoveHighlight(player.Character)
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        ScanMap()
        ESPRefreshMap()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if State.Unloaded then return end
        if input.KeyCode == Config.KEY_Panic then Unload(); return end
        if gp then return end
        if input.KeyCode == Config.KEY_TP_Gen then TeleportToGenerator(1) end
        if input.KeyCode == Config.KEY_TP_Gate then TeleportToGate() end
        if input.KeyCode == Config.KEY_TP_Hook then TeleportToHook() end
        if input.KeyCode == Config.KEY_Speed then Config.SPEED_Enabled = not Config.SPEED_Enabled end
        if input.KeyCode == Config.KEY_Noclip then Config.NOCLIP_Enabled = not Config.NOCLIP_Enabled end
        if input.KeyCode == Config.KEY_Fly then Config.FLY_Enabled = not Config.FLY_Enabled end
    end)
    
    Connections.Render = RunService.RenderStepped:Connect(MainLoop)
    task.spawn(AutoLoop)
    
    VelarisUI:MakeNotify({ Title = "Victoria Hub", Description = "Loaded Successfully!", Content = "Violence District", Color = "Success", Time = 3 })
end

Init()
