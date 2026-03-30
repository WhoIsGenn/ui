--[[
    Victoria Hub | Violence District
    FIXED VERSION - Only bug fixes, no rewrite
]]

-- =====================================================================
-- SERVICES
-- =====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- =====================================================================
-- DRAWING CHECK
-- =====================================================================
if not Drawing or not Drawing.new then
    local waited = 0
    while not Drawing and waited < 5 do
        task.wait(0.1)
        waited = waited + 0.1
    end
    if not Drawing then
        warn("[Victoria] Drawing library not available.")
        return
    end
end

-- =====================================================================
-- STATE (DEFINED FIRST!)
-- =====================================================================
local State = {
    Unloaded = false,
    LastESPUpdate = 0,
    LastVisCheck = 0,
    LastCacheUpdate = 0,
    LastGenUpdate = 0,
    OriginalSpeed = 16,
    AimTarget = nil,
}

-- =====================================================================
-- CONFIGURATION
-- =====================================================================
local Config = {
    -- ESP Settings
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
    ESP_MaxDist = 200,
    ESP_PlayerChams = true,
    ESP_ObjectChams = true,
    
    -- Survivor Features
    AUTO_Generator = false,
    AUTO_GenMode = "Fast",
    AUTO_LeaveDist = 18,
    ANTI_SkillCheck = false,
    PERFECT_SkillCheck = false,
    SURV_NoFall = false,
    SURV_GodMode = false,
    AUTO_Parry = false,
    PARRY_Mode = "With Animation",
    PARRY_Dist = 13,
    PARRY_FOV = false,
    
    -- Killer Features
    AUTO_Attack = false,
    AUTO_AttackRange = 12,
    HITBOX_Enabled = false,
    HITBOX_Size = 15,
    KILLER_AutoHook = false,
    KILLER_AntiBlind = false,
    KILLER_NoSlowdown = false,
    KILLER_DoubleTap = false,
    KILLER_InfiniteLunge = false,
    
    -- Movement
    SPEED_Enabled = false,
    SPEED_Value = 32,
    NOCLIP_Enabled = false,
    FLY_Enabled = false,
    FLY_Speed = 50,
    JUMP_Power = 50,
    JUMP_Infinite = false,
    
    -- Visual
    NO_Fog = false,
    FULLBRIGHT = false,
    CAM_ThirdPerson = false,
    
    -- Teleport
    TP_Offset = 3,
    KEY_TP_Gen = Enum.KeyCode.G,
    KEY_TP_Gate = Enum.KeyCode.T,
    KEY_TP_Hook = Enum.KeyCode.H,
    KEY_LeaveGen = Enum.KeyCode.Q,
    KEY_StopGen = Enum.KeyCode.X,
    KEY_Speed = Enum.KeyCode.C,
    KEY_Noclip = Enum.KeyCode.V,
    KEY_Fly = Enum.KeyCode.F,
    KEY_Menu = Enum.KeyCode.Insert,
    KEY_Panic = Enum.KeyCode.Home,
}

-- =====================================================================
-- COLORS
-- =====================================================================
local Colors = {
    Killer = Color3.fromRGB(255, 65, 65),
    Survivor = Color3.fromRGB(65, 220, 130),
    Generator = Color3.fromRGB(255, 180, 50),
    GeneratorDone = Color3.fromRGB(100, 255, 130),  -- HIJAU untuk selesai
    Gate = Color3.fromRGB(200, 200, 220),
    Hook = Color3.fromRGB(255, 100, 100),
    Pallet = Color3.fromRGB(220, 180, 100),
    Window = Color3.fromRGB(100, 180, 255),
}

-- =====================================================================
-- HELPER FUNCTIONS
-- =====================================================================
local function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Spectator"
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

local function GetDistance(pos)
    local root = GetCharacterRoot()
    if not root then return math.huge end
    return (pos - root.Position).Magnitude
end

local function WorldToScreen(pos)
    local cam = workspace.CurrentCamera
    if not cam then return Vector2.new(), false, 0 end
    local screen, onScreen = cam:WorldToViewportPoint(pos)
    return Vector2.new(screen.X, screen.Y), onScreen, screen.Z
end

-- =====================================================================
-- ESP SYSTEM (YANG DULU JALAN)
-- =====================================================================
local generators = {}
local lastFullRefresh = 0

local function CreateBillboard(text, color)
    local b = Instance.new("BillboardGui")
    b.Name = "VictoriaESP"
    b.AlwaysOnTop = true
    b.Size = UDim2.new(0, 120, 0, 30)
    local t = Instance.new("TextLabel")
    t.Name = "Label"
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color
    t.TextStrokeTransparency = 0.2
    t.TextStrokeColor3 = Color3.new(0, 0, 0)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextWrapped = true
    t.Parent = b
    return b
end

local function AddHighlight(obj, color, transparency)
    transparency = transparency or 0.7
    local h = obj:FindFirstChild("VictoriaHighlight")
    if h then 
        h.FillColor = color
        h.OutlineColor = color
        return 
    end
    h = Instance.new("Highlight")
    h.Name = "VictoriaHighlight"
    h.Adornee = obj
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = transparency
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
end

local function RemoveESP(obj)
    if not obj then return end
    local tag = obj:FindFirstChild("VictoriaESP")
    if tag then tag:Destroy() end
    local highlight = obj:FindFirstChild("VictoriaHighlight")
    if highlight then highlight:Destroy() end
end

local function UpdatePlayerESP(player)
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local isKiller = IsKiller(player)
    local show = (isKiller and Config.ESP_Killer) or (not isKiller and Config.ESP_Survivor)
    
    -- Hapus ESP dulu
    RemoveESP(hrp)
    RemoveESP(player.Character)
    
    if not show then return end
    
    local color = isKiller and Colors.Killer or Colors.Survivor
    
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        local knocked = player.Character:GetAttribute("Knocked")
        local hooked = player.Character:GetAttribute("IsHooked")
        if hooked then 
            color = Color3.fromRGB(255, 182, 193)
        elseif knocked then
            color = Color3.fromRGB(200, 100, 0)
        elseif hum.Health < hum.MaxHealth then
            color = Color3.fromRGB(200, 200, 0)
        end
    end
    
    local dist = 0
    local myRoot = GetCharacterRoot()
    if myRoot then
        dist = math.floor((hrp.Position - myRoot.Position).Magnitude)
    end
    
    local text = player.Name
    if Config.ESP_Distance then
        text = text .. "\n[" .. dist .. "m]"
    end
    if Config.ESP_Health and hum then
        local pct = math.floor((hum.Health / hum.MaxHealth) * 100)
        text = text .. "\n❤️ " .. pct .. "%"
    end
    
    local billboard = CreateBillboard(text, color)
    billboard.Adornee = hrp
    billboard.Parent = hrp
    
    -- Chams pake highlight
    AddHighlight(player.Character, color, 0.7)
end

-- UPDATE GENERATOR DENGAN WARNA HIJAU KALAU 100%
local function UpdateGeneratorESP(gen)
    if not gen or not gen.Parent then return false end
    
    -- Get progress
    local progress = 0
    local pv = gen:FindFirstChild("RepairProgress") or gen:GetAttribute("RepairProgress") 
    pv = pv or gen:FindFirstChild("Progress") or gen:GetAttribute("Progress")
    if pv then
        progress = typeof(pv) == "Instance" and pv.Value or pv
    end
    
    if not Config.ESP_Generator then
        RemoveESP(gen)
        return false
    end
    
    RemoveESP(gen)
    
    -- CEK: Generator selesai? pake warna HIJAU
    local isComplete = progress >= 100
    local color = isComplete and Colors.GeneratorDone or Colors.Generator
    local text = isComplete and "✅ GENERATOR DONE" or string.format("🔧 Generator [%.1f%%]", progress)
    
    local billboard = CreateBillboard(text, color)
    billboard.Name = "VictoriaESP"
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    local attach = gen:FindFirstChild("defaultMaterial", true) or gen:FindFirstChildWhichIsA("BasePart") or gen
    billboard.Adornee = attach
    billboard.Parent = gen
    
    AddHighlight(gen, color, isComplete and 0.3 or 0.5)
    
    return isComplete
end

local function UpdateObjectESP(obj, color, label, offset)
    if not obj or not obj.Parent then return end
    
    -- CEK TOGGLE masing2 object
    local shouldShow = false
    if label == "GEN" and Config.ESP_Generator then shouldShow = true end
    if label == "GATE" and Config.ESP_Gate then shouldShow = true end
    if label == "HOOK" and Config.ESP_Hook then shouldShow = true end
    if label == "PALLET" and Config.ESP_Pallet then shouldShow = true end
    if label == "WINDOW" and Config.ESP_Window then shouldShow = true end
    
    if not shouldShow then
        RemoveESP(obj)
        return
    end
    
    RemoveESP(obj)
    
    local billboard = CreateBillboard(label, color)
    billboard.Name = "VictoriaESP"
    billboard.StudsOffset = offset or Vector3.new(0, 1.5, 0)
    local attach = obj:FindFirstChildWhichIsA("BasePart") or obj
    billboard.Adornee = attach
    billboard.Parent = obj
    
    AddHighlight(obj, color, 0.5)
end

local function ScanMap()
    -- Bersihkan ESP lama
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "VictoriaESP" or obj.Name == "VictoriaHighlight" then
            obj:Destroy()
        end
    end
    
    generators = {}
    local map = Workspace:FindFirstChild("Map")
    
    -- Windows (di workspace)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Window" then
            UpdateObjectESP(obj, Colors.Window, "WINDOW", Vector3.new(0, 1, 0))
        end
    end
    
    if not map then return end
    
    for _, obj in ipairs(map:GetDescendants()) do
        local name = obj.Name
        if name == "Generator" then
            UpdateObjectESP(obj, Colors.Generator, "GEN", Vector3.new(0, 2, 0))
            table.insert(generators, obj)
        elseif name == "Gate" then
            UpdateObjectESP(obj, Colors.Gate, "GATE", Vector3.new(0, 2, 0))
        elseif name == "Hook" then
            local model = obj:FindFirstChild("Model")
            if model then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("MeshPart") then
                        UpdateObjectESP(part, Colors.Hook, "HOOK", Vector3.new(0, 1, 0))
                    end
                end
            else
                UpdateObjectESP(obj, Colors.Hook, "HOOK", Vector3.new(0, 1.5, 0))
            end
        elseif name == "Palletwrong" or name == "Pallet" then
            UpdateObjectESP(obj, Colors.Pallet, "PALLET", Vector3.new(0, 1, 0))
        end
    end
end

-- =====================================================================
-- PERFECT SKILL CHECK
-- =====================================================================
local PerfectSCActive = false
local PerfectSCConns = {}
local PerfectSCGuiWatchConn = nil

local function SkillCheck_Fire()
    pcall(function()
        local checkObj = LocalPlayer:FindFirstChild("CheckInterractable")
        if checkObj then
            checkObj:SetAttribute("action", true)
            task.defer(function() pcall(function() checkObj:SetAttribute("action", false) end) end)
        end
    end)
    
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, gui in ipairs(pg:GetChildren()) do
            local controls = gui:FindFirstChild("Controls", true)
            if controls then
                local btn = controls:FindFirstChild("action", true) or controls:FindFirstChild("Action", true)
                if btn then
                    local pos = btn.AbsolutePosition + btn.AbsoluteSize * 0.5
                    VirtualInputManager:SendTouchEvent(0, pos.X, pos.Y)
                    task.defer(function() VirtualInputManager:SendTouchEvent(2, pos.X, pos.Y) end)
                    return
                end
            end
        end
    end)
end

local function PerfectSC_Connect()
    for _, c in ipairs(PerfectSCConns) do pcall(function() c:Disconnect() end) end
    PerfectSCConns = {}
    
    task.spawn(function()
        if not PerfectSCActive then return end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then pg = LocalPlayer:WaitForChild("PlayerGui", 10) end
        if not pg or not PerfectSCActive then return end
        
        local checkGui = pg:FindFirstChild("SkillCheckPromptGui")
        local waited = 0
        while not checkGui and waited < 30 and PerfectSCActive do
            task.wait(0.1)
            waited = waited + 0.1
            checkGui = pg:FindFirstChild("SkillCheckPromptGui")
        end
        if not checkGui or not PerfectSCActive then return end
        
        local check = checkGui:FindFirstChild("Check")
        if not check then check = checkGui:WaitForChild("Check", 10) end
        if not check or not PerfectSCActive then return end
        
        local line = check:FindFirstChild("Line") or check:WaitForChild("Line", 5)
        local goal = check:FindFirstChild("Goal") or check:WaitForChild("Goal", 5)
        if not line or not goal then return end
        
        local hbConn = nil
        local function startHB()
            if hbConn then hbConn:Disconnect(); hbConn = nil end
            hbConn = RunService.Heartbeat:Connect(function()
                if not check.Visible or not PerfectSCActive then
                    if hbConn then hbConn:Disconnect(); hbConn = nil end
                    return
                end
                local lr = line.Rotation % 360
                local gr = goal.Rotation % 360
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
        
        if check.Visible then startHB() end
        
        local visConn = check:GetPropertyChangedSignal("Visible"):Connect(function()
            if not PerfectSCActive then return end
            if check.Visible then startHB() else if hbConn then hbConn:Disconnect(); hbConn = nil end end
        end)
        table.insert(PerfectSCConns, visConn)
    end)
end

local function PerfectSC_Setup()
    PerfectSCActive = true
    PerfectSC_Connect()
    if PerfectSCGuiWatchConn then PerfectSCGuiWatchConn:Disconnect() end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        PerfectSCGuiWatchConn = pg.ChildAdded:Connect(function(child)
            if not PerfectSCActive then return end
            if child.Name == "SkillCheckPromptGui" then
                task.wait(0.3)
                PerfectSC_Connect()
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

-- =====================================================================
-- ANTI SKILL CHECK
-- =====================================================================
local AntiScriptDescConn = nil

local function AntiScript_DisableOne(scr)
    if not scr then return end
    if not Config.ANTI_SkillCheck then return end
    if scr.Name == "Skillcheck-gen" or scr.Name == "Skillcheck-player" then
        pcall(function() scr.Disabled = true end)
    end
end

local function AntiScript_Apply(char)
    if not char or GetRole() ~= "Survivor" then return end
    if not Config.ANTI_SkillCheck then return end
    if AntiScriptDescConn then pcall(function() AntiScriptDescConn:Disconnect() end); AntiScriptDescConn = nil end
    for _, scr in ipairs(char:GetDescendants()) do AntiScript_DisableOne(scr) end
    AntiScriptDescConn = char.DescendantAdded:Connect(function(desc)
        if GetRole() == "Survivor" then AntiScript_DisableOne(desc) end
    end)
end

local function AntiScript_Restore()
    if AntiScriptDescConn then pcall(function() AntiScriptDescConn:Disconnect() end); AntiScriptDescConn = nil end
end

-- =====================================================================
-- AUTO ATTACK
-- =====================================================================
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

-- =====================================================================
-- AUTO PARRY (dengan mode dropdown)
-- =====================================================================
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
        local controls = gui:FindFirstChild("Controls")
        if controls then
            for _, btnName in ipairs({"Gui-mob", "parry", "Parry", "action", "Action"}) do
                local btn = controls:FindFirstChild(btnName)
                if btn then 
                    ParryGuiBtn = btn
                    return btn 
                end
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
                task.wait(0.05)
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

local function AutoParry_TryFire()
    if not Config.AUTO_Parry then return end
    if ParryOnCooldown then return end
    if GetRole() ~= "Survivor" then return end
    
    if AutoParry_Fire() then
        ParryOnCooldown = true
        task.delay(1.5, function() ParryOnCooldown = false end)
    end
end

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

local function AutoParry_HookKiller(char, player)
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
        
        local conn = animator.AnimationPlayed:Connect(function(track)
            if not Config.AUTO_Parry then return end
            if not IsKiller(player) then return end
            local id = track.Animation.AnimationId:match("%d+$") or ""
            if AttackAnimIDs[id] then
                local myRoot = GetCharacterRoot()
                local kr = char:FindFirstChild("HumanoidRootPart")
                if myRoot and kr then
                    local dist = (kr.Position - myRoot.Position).Magnitude
                    if dist <= Config.PARRY_Dist then
                        AutoParry_TryFire()
                    end
                end
            end
        end)
        table.insert(KillerHitConns, conn)
    end)
end

local function AutoParry_Setup()
    for _, c in ipairs(KillerHitConns) do pcall(function() c:Disconnect() end) end
    KillerHitConns = {}
    
    local function watchPlayer(p)
        if p == LocalPlayer then return end
        local function hookChar(char) AutoParry_HookKiller(char, p) end
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

-- =====================================================================
-- THIRD PERSON
-- =====================================================================
local ThirdPersonWasActive = false
local ThirdPersonCharConn = nil
local ThirdPersonRenderConn = nil

local function ThirdPerson_Apply()
    local char = LocalPlayer.Character
    if not char then return end
    
    local fp = char:FindFirstChild("Firstperson")
    if fp and not fp.Disabled then
        pcall(function() fp.Disabled = true end)
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

-- =====================================================================
-- MOVEMENT FEATURES
-- =====================================================================
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

-- =====================================================================
-- TELEPORT FUNCTIONS
-- =====================================================================
local function TeleportToGenerator()
    if #generators == 0 then return end
    local root = GetCharacterRoot()
    if not root then return end
    local target = generators[1]
    local part = target:FindFirstChildWhichIsA("BasePart") or target
    root.CFrame = CFrame.new(part.Position + Vector3.new(0, Config.TP_Offset, 0))
end

local function TeleportToGate()
    local map = Workspace:FindFirstChild("Map")
    if not map then return end
    local root = GetCharacterRoot()
    if not root then return end
    for _, obj in ipairs(map:GetDescendants()) do
        if obj.Name == "Gate" then
            local part = obj:FindFirstChildWhichIsA("BasePart") or obj
            root.CFrame = CFrame.new(part.Position + Vector3.new(0, Config.TP_Offset, 0))
            break
        end
    end
end

local function TeleportToHook()
    local map = Workspace:FindFirstChild("Map")
    if not map then return end
    local root = GetCharacterRoot()
    if not root then return end
    for _, obj in ipairs(map:GetDescendants()) do
        if obj.Name == "Hook" then
            local part = obj:FindFirstChildWhichIsA("BasePart") or obj
            root.CFrame = CFrame.new(part.Position + Vector3.new(0, Config.TP_Offset, 0))
            break
        end
    end
end

local function LeaveGenerator()
    local root = GetCharacterRoot()
    if not root then return end
    local closest, closestDist = nil, math.huge
    for _, gen in ipairs(generators) do
        local part = gen:FindFirstChildWhichIsA("BasePart") or gen
        local dist = (part.Position - root.Position).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = part
        end
    end
    if closest and closestDist < Config.AUTO_LeaveDist then
        local direction = (root.Position - closest.Position).Unit
        root.CFrame = CFrame.new(root.Position + direction * 20 + Vector3.new(0, 3, 0))
    end
end

local function StopAutoGen()
    Config.AUTO_Generator = false
end

-- =====================================================================
-- AUTO GENERATOR LOOP (FIXED: State sudah didefinisikan)
-- =====================================================================
local function AutoGenLoop()
    while not State.Unloaded do
        if Config.AUTO_Generator and GetRole() == "Survivor" then
            local repairRemote, skillRemote
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local g = r and r:FindFirstChild("Generator")
                repairRemote = g and g:FindFirstChild("RepairEvent")
                skillRemote = g and g:FindFirstChild("SkillCheckResultEvent")
            end)
            if repairRemote and skillRemote then
                local mode = Config.AUTO_GenMode == "Fast"
                for _, gen in ipairs(generators) do
                    for _, pt in ipairs(gen:GetChildren()) do
                        if pt.Name:match("GeneratorPoint") then
                            pcall(function() repairRemote:FireServer(pt, true) end)
                            pcall(function() skillRemote:FireServer(mode and "success" or "neutral", mode and 1 or 0, gen, pt) end)
                        end
                    end
                end
            end
        end
        task.wait(0.15)
    end
end

-- =====================================================================
-- ESP UPDATE LOOP
-- =====================================================================
local lastUpdate = 0
local lastGenCheck = 0

local function UpdateESP()
    local now = tick()
    
    if now - lastFullRefresh > 5 then
        lastFullRefresh = now
        ScanMap()
    end
    
    -- Update players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            UpdatePlayerESP(player)
        end
    end
    
    -- Update generators progress
    if now - lastGenCheck >= 0.2 then
        lastGenCheck = now
        for i = #generators, 1, -1 do
            local gen = generators[i]
            if gen and gen.Parent then
                UpdateGeneratorESP(gen)  -- Update progress, generator selesai jadi hijau
            else
                table.remove(generators, i)
            end
        end
    end
end

-- =====================================================================
-- VISUAL EFFECTS
-- =====================================================================
local function UpdateFullbright()
    local lighting = game:GetService("Lighting")
    if Config.FULLBRIGHT then
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
        lighting.GlobalShadows = false
    else
        lighting.Ambient = Color3.fromRGB(0, 0, 0)
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.Brightness = 1
        lighting.GlobalShadows = true
    end
end

local function UpdateNoFog()
    local lighting = game:GetService("Lighting")
    if Config.NO_Fog then
        lighting.FogEnd = 100000
        lighting.FogStart = 0
    else
        lighting.FogEnd = 1000
        lighting.FogStart = 0
    end
end

-- =====================================================================
-- UNLOAD FUNCTION
-- =====================================================================
local function Unload()
    State.Unloaded = true
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "VictoriaESP" or obj.Name == "VictoriaHighlight" then
            pcall(function() obj:Destroy() end)
        end
    end
    
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
    if ParryFOVCircle then ParryFOVCircle:Remove() end
    
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.fromRGB(0, 0, 0)
    lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    lighting.Brightness = 1
    lighting.FogEnd = 1000
    lighting.FogStart = 0
    
    pcall(function() Window:Destroy() end)
    print("[Victoria] Unloaded")
end

-- =====================================================================
-- VELARIS UI
-- =====================================================================
local VelarisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/tesui.lua"))()

local Window = VelarisUI:Window({
    Title = "Victoria Hub | Violence District",
    Footer = "Fixed: Generator Green, Auto Parry Mode",
    Content = "Violence District",
    Color = "Blue",
    Version = 2.2,
    KeySystem = {
        Title = "Victoria Hub",
        Default = "VD-KEYLESS",
        Callback = function(key) return key == "VD-KEYLESS" or key == "VICTORIA2025" end
    }
})

-- TABS
local TabESP = Window:AddTab({ Name = "ESP", Icon = "lucide:eye" })
local TabSurvivor = Window:AddTab({ Name = "Survivor", Icon = "lucide:user" })
local TabKiller = Window:AddTab({ Name = "Killer", Icon = "lucide:sword" })
local TabMovement = Window:AddTab({ Name = "Movement", Icon = "lucide:gamepad-2" })
local TabMisc = Window:AddTab({ Name = "Misc", Icon = "lucide:settings" })

-- ESP TAB
local secPlayers = TabESP:AddSection({ Title = "Players", Open = true })
secPlayers:AddToggle({ Title = "Killer ESP", Default = Config.ESP_Killer, Callback = function(v) Config.ESP_Killer = v end })
secPlayers:AddToggle({ Title = "Survivor ESP", Default = Config.ESP_Survivor, Callback = function(v) Config.ESP_Survivor = v end })
secPlayers:AddToggle({ Title = "Names", Default = Config.ESP_Names, Callback = function(v) Config.ESP_Names = v end })
secPlayers:AddToggle({ Title = "Distance", Default = Config.ESP_Distance, Callback = function(v) Config.ESP_Distance = v end })
secPlayers:AddToggle({ Title = "Health", Default = Config.ESP_Health, Callback = function(v) Config.ESP_Health = v end })

local secObjects = TabESP:AddSection({ Title = "Objects", Open = false })
secObjects:AddToggle({ Title = "Generator", Default = Config.ESP_Generator, Callback = function(v) Config.ESP_Generator = v; ScanMap() end })
secObjects:AddToggle({ Title = "Gate", Default = Config.ESP_Gate, Callback = function(v) Config.ESP_Gate = v; ScanMap() end })
secObjects:AddToggle({ Title = "Hook", Default = Config.ESP_Hook, Callback = function(v) Config.ESP_Hook = v; ScanMap() end })
secObjects:AddToggle({ Title = "Pallet", Default = Config.ESP_Pallet, Callback = function(v) Config.ESP_Pallet = v; ScanMap() end })
secObjects:AddToggle({ Title = "Window", Default = Config.ESP_Window, Callback = function(v) Config.ESP_Window = v; ScanMap() end })

-- SURVIVOR TAB
local secGen = TabSurvivor:AddSection({ Title = "Generator", Open = true })
secGen:AddToggle({ Title = "Auto Generator", Default = Config.AUTO_Generator, Callback = function(v) Config.AUTO_Generator = v end })
secGen:AddDropdown({ Title = "Gen Speed", Options = { "Fast", "Slow" }, Default = Config.AUTO_GenMode, Callback = function(v) Config.AUTO_GenMode = v end })
secGen:AddSlider({ Title = "Leave Distance", Min = 10, Max = 30, Default = Config.AUTO_LeaveDist, Callback = function(v) Config.AUTO_LeaveDist = v end })

local secSurv = TabSurvivor:AddSection({ Title = "Survivor", Open = true })
secSurv:AddToggle({ Title = "Remove Skill Check", Default = Config.ANTI_SkillCheck, Callback = function(v) Config.ANTI_SkillCheck = v; if v then AntiScript_Apply(LocalPlayer.Character) else AntiScript_Restore() end end })
secSurv:AddToggle({ Title = "Perfect Skill Check", Default = Config.PERFECT_SkillCheck, Callback = function(v) Config.PERFECT_SkillCheck = v; if v then PerfectSC_Setup() else PerfectSC_Stop() end end })
secSurv:AddToggle({ Title = "No Fall Damage", Default = Config.SURV_NoFall, Callback = function(v) Config.SURV_NoFall = v end })
secSurv:AddToggle({ Title = "God Mode", Default = Config.SURV_GodMode, Callback = function(v) Config.SURV_GodMode = v end })

local secParry = TabSurvivor:AddSection({ Title = "Auto Parry", Open = false })
secParry:AddToggle({ Title = "Auto Parry", Default = Config.AUTO_Parry, Callback = function(v) Config.AUTO_Parry = v; if v then AutoParry_Setup() else AutoParry_Cleanup() end end })
secParry:AddDropdown({ Title = "Parry Mode", Options = { "With Animation", "No Animation" }, Default = Config.PARRY_Mode, Callback = function(v) Config.PARRY_Mode = v end })
secParry:AddSlider({ Title = "Parry Distance", Min = 5, Max = 40, Default = Config.PARRY_Dist, Callback = function(v) Config.PARRY_Dist = v end })
secParry:AddToggle({ Title = "Show Parry FOV", Default = Config.PARRY_FOV, Callback = function(v) Config.PARRY_FOV = v end })

-- KILLER TAB
local secKill = TabKiller:AddSection({ Title = "Combat", Open = true })
secKill:AddToggle({ Title = "Auto Attack", Default = Config.AUTO_Attack, Callback = function(v) Config.AUTO_Attack = v end })
secKill:AddSlider({ Title = "Attack Range", Min = 5, Max = 20, Default = Config.AUTO_AttackRange, Callback = function(v) Config.AUTO_AttackRange = v end })
secKill:AddToggle({ Title = "Double Tap", Default = Config.KILLER_DoubleTap, Callback = function(v) Config.KILLER_DoubleTap = v end })
secKill:AddToggle({ Title = "Infinite Lunge", Default = Config.KILLER_InfiniteLunge, Callback = function(v) Config.KILLER_InfiniteLunge = v end })
secKill:AddToggle({ Title = "Auto Hook", Default = Config.KILLER_AutoHook, Callback = function(v) Config.KILLER_AutoHook = v end })

local secHitbox = TabKiller:AddSection({ Title = "Hitbox", Open = false })
secHitbox:AddToggle({ Title = "Hitbox Expander", Default = Config.HITBOX_Enabled, Callback = function(v) Config.HITBOX_Enabled = v end })
secHitbox:AddSlider({ Title = "Hitbox Size", Min = 5, Max = 30, Default = Config.HITBOX_Size, Callback = function(v) Config.HITBOX_Size = v end })

-- MOVEMENT TAB
local secMove = TabMovement:AddSection({ Title = "Speed", Open = true })
secMove:AddToggle({ Title = "Speed Hack", Default = Config.SPEED_Enabled, Callback = function(v) Config.SPEED_Enabled = v end })
secMove:AddSlider({ Title = "Speed Value", Min = 16, Max = 150, Default = Config.SPEED_Value, Callback = function(v) Config.SPEED_Value = v end })

local secFly = TabMovement:AddSection({ Title = "Flight", Open = false })
secFly:AddToggle({ Title = "Fly", Default = Config.FLY_Enabled, Callback = function(v) Config.FLY_Enabled = v end })
secFly:AddSlider({ Title = "Fly Speed", Min = 10, Max = 200, Default = Config.FLY_Speed, Callback = function(v) Config.FLY_Speed = v end })

local secColl = TabMovement:AddSection({ Title = "Collision", Open = false })
secColl:AddToggle({ Title = "Noclip", Default = Config.NOCLIP_Enabled, Callback = function(v) Config.NOCLIP_Enabled = v end })

local secTP = TabMovement:AddSection({ Title = "Teleport", Open = false })
secTP:AddButton({ Title = "TP to Generator", Callback = TeleportToGenerator })
secTP:AddButton({ Title = "TP to Gate", Callback = TeleportToGate })
secTP:AddButton({ Title = "TP to Hook", Callback = TeleportToHook })
secTP:AddSlider({ Title = "TP Offset", Min = 0, Max = 10, Default = Config.TP_Offset, Callback = function(v) Config.TP_Offset = v end })

-- MISC TAB
local secVisual = TabMisc:AddSection({ Title = "Visual", Open = true })
secVisual:AddToggle({ Title = "No Fog", Default = Config.NO_Fog, Callback = function(v) Config.NO_Fog = v; UpdateNoFog() end })
secVisual:AddToggle({ Title = "Fullbright", Default = Config.FULLBRIGHT, Callback = function(v) Config.FULLBRIGHT = v; UpdateFullbright() end })
secVisual:AddToggle({ Title = "Third Person", Default = Config.CAM_ThirdPerson, Callback = function(v) Config.CAM_ThirdPerson = v; UpdateThirdPerson() end })

local secSystem = TabMisc:AddSection({ Title = "System", Open = false })
secSystem:AddButton({ Title = "Unload Script", Callback = Unload })
secSystem:AddButton({ Title = "Refresh ESP", Callback = ScanMap })

-- =====================================================================
-- INITIALIZATION
-- =====================================================================
local Connections = {}

local function Init()
    ScanMap()
    PerfectSC_Setup()
    AutoParry_Setup()
    UpdateThirdPerson()
    UpdateFullbright()
    UpdateNoFog()
    
    Connections.Input = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if State.Unloaded then return end
        if input.KeyCode == Config.KEY_Panic then Unload(); return end
        if gameProcessed then return end
        if input.KeyCode == Config.KEY_LeaveGen then LeaveGenerator(); return end
        if input.KeyCode == Config.KEY_StopGen then StopAutoGen(); return end
        if input.KeyCode == Config.KEY_TP_Gen then TeleportToGenerator(); return end
        if input.KeyCode == Config.KEY_TP_Gate then TeleportToGate(); return end
        if input.KeyCode == Config.KEY_TP_Hook then TeleportToHook(); return end
        if input.KeyCode == Config.KEY_Speed then Config.SPEED_Enabled = not Config.SPEED_Enabled; return end
        if input.KeyCode == Config.KEY_Noclip then Config.NOCLIP_Enabled = not Config.NOCLIP_Enabled; return end
        if input.KeyCode == Config.KEY_Fly then Config.FLY_Enabled = not Config.FLY_Enabled; return end
    end)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            ScanMap()
        end
    end)
    
    Connections.Render = RunService.RenderStepped:Connect(function()
        UpdateESP()
        UpdateSpeed()
        UpdateNoclip()
        UpdateFly()
        UpdateParryFOV()
        AutoAttack()
    end)
    
    task.spawn(AutoGenLoop)
    
    print("[Victoria] Loaded Successfully!")
end

Init()
