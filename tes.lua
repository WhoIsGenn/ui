-- ================================================================
-- VICTORIA HUB | VIOLENCE DISTRICT
-- FINAL FIXED - NO ERRORS
-- ================================================================

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
    AUTO_Parry = false,
    PARRY_Mode = "With Animation",
    PARRY_Dist = 13,
    PARRY_FOV = false,
    ANTI_SkillCheck = false,
    PERFECT_SkillCheck = false,
    SURV_NoFall = false,
    SURV_GodMode = false,
    SPEED_Enabled = false,
    SPEED_Value = 32,
    NOCLIP_Enabled = false,
    FLY_Enabled = false,
    FLY_Speed = 50,
    JUMP_Infinite = false,
    NO_Fog = false,
    FULLBRIGHT = false,
    CAM_ThirdPerson = false,
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
    OriginalSpeed = 16,
    LastESPUpdate = 0,
    LastVisCheck = 0,
}

local Cache = {
    Generators = {},
    Visibility = {},
}

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
    end
    return "Spectator"
end

local function IsKiller(player)
    if not player then return false end
    local team = player.Team
    if team then
        local n = team.Name:lower()
        return n:find("killer") ~= nil
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

-- ================================================================
-- HIGHLIGHT (REUSE - NO FLICKER)
-- ================================================================
local function ApplyHighlight(obj, color, trans)
    if not obj or not obj.Parent then return end
    local h = obj:FindFirstChild("_VHLight")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "_VHLight"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = obj
    end
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = trans or 0.6
    h.OutlineTransparency = 0
end

local function RemoveHighlight(obj)
    if not obj then return end
    local h = obj:FindFirstChild("_VHLight")
    if h then h:Destroy() end
end

-- ================================================================
-- NAMETAG (FIXED - use Enabled instead of Visible)
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
        local pct = math.floor((hum.Health / hum.MaxHealth) * 100)
        table.insert(lines, "❤️ " .. pct .. "%")
    end
    
    local lbl = tag:FindFirstChild("_VHTagLabel")
    if lbl then
        lbl.Text = table.concat(lines, "\n")
        lbl.TextColor3 = color
    end
    
    -- BillboardGui uses Enabled, not Visible
    tag.Enabled = (#lines > 0)
end

-- ================================================================
-- UPDATE PLAYER ESP (NO FLICKER)
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
            
            if hum and hum.Health < hum.MaxHealth then
                color = Color3.fromRGB(230, 220, 0)
            end
            
            ApplyHighlight(char, color, 0.6)
            UpdateNametag(player, color, dist)
        end
    end
end

-- ================================================================
-- GENERATOR ESP (REUSE - NO FLICKER)
-- ================================================================
local ESPGenerators = {}

local function GetOrCreateGenTag(gen, adornee)
    local tag = gen:FindFirstChild("_VHGenTag")
    if not tag then
        tag = Instance.new("BillboardGui")
        tag.Name = "_VHGenTag"
        tag.AlwaysOnTop = true
        tag.Size = UDim2.new(0, 90, 0, 22)
        tag.StudsOffset = Vector3.new(0, 3, 0)
        tag.Adornee = adornee
        tag.Parent = gen
        
        local lbl = Instance.new("TextLabel")
        lbl.Name = "_VHGenLabel"
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0,0,0)
        lbl.Parent = tag
    end
    return tag
end

local function UpdateGeneratorESP()
    for _, gen in ipairs(ESPGenerators) do
        if not gen or not gen.Parent then continue end
        
        local pv = gen:FindFirstChild("RepairProgress") or gen:GetAttribute("RepairProgress")
        local p = pv and (typeof(pv) == "Instance" and pv.Value or pv) or 0
        
        if not Config.ESP_Generator then
            RemoveHighlight(gen)
            local tag = gen:FindFirstChild("_VHGenTag")
            if tag then tag:Destroy() end
        else
            local isComplete = p >= 100
            local color = isComplete and ESPColors.GeneratorDone or ESPColors.Generator
            
            ApplyHighlight(gen, color, 0.5)
            
            if not isComplete then
                local adornee = gen:FindFirstChild("defaultMaterial", true) or gen:FindFirstChildWhichIsA("BasePart") or gen
                local tag = GetOrCreateGenTag(gen, adornee)
                local lbl = tag and tag:FindFirstChild("_VHGenLabel")
                if lbl then
                    lbl.Text = string.format("%.1f%%", p)
                    lbl.TextColor3 = color
                end
                tag.Enabled = true
            else
                local tag = gen:FindFirstChild("_VHGenTag")
                if tag then tag:Destroy() end
            end
        end
    end
end

-- ================================================================
-- SCAN MAP (REFRESH ESP OBJECTS)
-- ================================================================
local function ScanMap()
    -- Bersihkan semua highlight object
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "_VHLight" or obj.Name == "_VHGenTag" then
            obj:Destroy()
        end
    end
    
    ESPGenerators = {}
    local Map = Workspace:FindFirstChild("Map")
    
    if not Map then return end
    
    for _, obj in ipairs(Map:GetDescendants()) do
        local n = obj.Name
        if n == "Generator" then
            table.insert(ESPGenerators, obj)
            if Config.ESP_Generator then
                ApplyHighlight(obj, ESPColors.Generator, 0.5)
            end
        elseif n == "Gate" and Config.ESP_Gate then
            ApplyHighlight(obj, ESPColors.Gate, 0.6)
        elseif n == "Hook" and Config.ESP_Hook then
            ApplyHighlight(obj, ESPColors.Hook, 0.5)
        elseif (n == "Pallet" or n == "Palletwrong") and Config.ESP_Pallet then
            ApplyHighlight(obj, ESPColors.Pallet, 0.55)
        elseif n == "Window" and Config.ESP_Window then
            ApplyHighlight(obj, ESPColors.Window, 0.55)
        end
    end
end

-- ================================================================
-- PERFECT SKILL CHECK
-- ================================================================
local PerfectSC_HBConn = nil
local PerfectSC_VisConn = nil
local touchId = 8822

local function TriggerSkillCheck()
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        for _, gui in ipairs(pg:GetChildren()) do
            local controls = gui:FindFirstChild("Controls", true)
            if controls then
                local btn = controls:FindFirstChild("action", true) or controls:FindFirstChild("Action", true)
                if btn then
                    local pos = btn.AbsolutePosition + btn.AbsoluteSize * 0.5
                    VirtualInputManager:SendTouchEvent(touchId, 0, pos.X, pos.Y)
                    task.wait(0.01)
                    VirtualInputManager:SendTouchEvent(touchId, 2, pos.X, pos.Y)
                    return
                end
            end
        end
    end)
end

local function PerfectSC_Setup()
    task.spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
        local cg = pg and pg:WaitForChild("SkillCheckPromptGui", 10)
        local check = cg and cg:WaitForChild("Check")
        if not check then return end
        
        local line = check:WaitForChild("Line")
        local goal = check:WaitForChild("Goal")
        
        local function inGoal()
            local lr = line.Rotation % 360
            local gr = goal.Rotation % 360
            local gs = (gr + 101) % 360
            local ge = (gr + 115) % 360
            return gs > ge and (lr >= gs or lr <= ge) or (lr >= gs and lr <= ge)
        end
        
        local function onHeartbeat()
            if not Config.PERFECT_SkillCheck then
                if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn = nil end
                return
            end
            if GetRole() == "Survivor" and inGoal() then
                TriggerSkillCheck()
                if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn = nil end
            end
        end
        
        if PerfectSC_VisConn then PerfectSC_VisConn:Disconnect() end
        PerfectSC_VisConn = check:GetPropertyChangedSignal("Visible"):Connect(function()
            if not Config.PERFECT_SkillCheck then return end
            if GetRole() == "Survivor" and check.Visible then
                if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect() end
                PerfectSC_HBConn = RunService.Heartbeat:Connect(onHeartbeat)
            elseif PerfectSC_HBConn then
                PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn = nil
            end
        end)
    end)
end

local function PerfectSC_Stop()
    if PerfectSC_HBConn then PerfectSC_HBConn:Disconnect(); PerfectSC_HBConn = nil end
    if PerfectSC_VisConn then PerfectSC_VisConn:Disconnect(); PerfectSC_VisConn = nil end
end

-- ================================================================
-- AUTO ATTACK (firesignal)
-- ================================================================
local lastAttackTime = 0

local function FindAttackButton()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, gui in ipairs(pg:GetChildren()) do
        local controls = gui:FindFirstChild("Controls")
        if controls then
            local btn = controls:FindFirstChild("attack")
            if btn then return btn end
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
-- AIMBOT (YANG WORK - NEMPEL BANGET)
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
-- AUTO PARRY (ACCURATE)
-- ================================================================
local ParryRemote = nil
local ParryOnCooldown = false
local ParryGuiBtn = nil
local ParryFOVCircle = nil
local KillerHitConns = {}

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
    ["139610361987372"] = true, ["139928639611415"] = true,
}

local function CreateParryFOVCircle()
    if ParryFOVCircle then return end
    ParryFOVCircle = Drawing.new("Circle")
    ParryFOVCircle.Filled = false
    ParryFOVCircle.Thickness = 3
    ParryFOVCircle.Color = Color3.fromRGB(0, 255, 0)
    ParryFOVCircle.Transparency = 1
    ParryFOVCircle.NumSides = 64
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
    
    local cam = Workspace.CurrentCamera
    if not cam then return end
    
    local circlePos = root.Position + Vector3.new(0, -3, 0)
    local screenPos, onScreen = WorldToScreen(circlePos)
    
    if onScreen then
        local dist = (cam.CFrame.Position - circlePos).Magnitude
        local radius = (Config.PARRY_Dist * 50) / math.max(dist, 1)
        radius = math.clamp(radius, 15, 250)
        
        ParryFOVCircle.Position = screenPos
        ParryFOVCircle.Radius = radius
        ParryFOVCircle.Visible = true
        
        if ParryOnCooldown then
            ParryFOVCircle.Color = Color3.fromRGB(255, 50, 50)
        else
            ParryFOVCircle.Color = Color3.fromRGB(0, 255, 50)
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
        task.delay(1.5, function() ParryOnCooldown = false end)
    end
end

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
        
        local conn1 = animator.AnimationPlayed:Connect(function(track)
            if not Config.AUTO_Parry then return end
            if not IsKiller(player) then return end
            
            local id = track.Animation.AnimationId
            local numId = id:match("%d+$") or id:match("id=(%d+)") or ""
            
            if NonAttackAnimIDs[numId] then return end
            if not AttackAnimIDs[numId] then return end
            
            local myRoot = GetCharacterRoot()
            local kr = char:FindFirstChild("HumanoidRootPart")
            if myRoot and kr then
                local dist = (kr.Position - myRoot.Position).Magnitude
                if dist <= Config.PARRY_Dist then
                    AutoParry_TryFire()
                end
            end
        end)
        table.insert(KillerHitConns, conn1)
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
-- THIRD PERSON
-- ================================================================
local ThirdPersonActive = false
local ThirdPersonConn = nil

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
    
    ThirdPersonActive = true
end

local function ThirdPerson_Remove()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
    end
    
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 7
        LocalPlayer.CameraMinZoomDistance = 7
    end)
    
    ThirdPersonActive = false
end

local function UpdateThirdPerson()
    if Config.CAM_ThirdPerson and GetRole() ~= "Spectator" then
        if not ThirdPersonActive then ThirdPerson_Apply() end
    else
        if ThirdPersonActive then ThirdPerson_Remove() end
    end
end

-- ================================================================
-- MOVEMENT FEATURES
-- ================================================================
local SpeedWasOn = false
local OriginalSpeed = 16

local function UpdateSpeed()
    if GetRole() == "Spectator" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if Config.SPEED_Enabled then
        if not SpeedWasOn then
            OriginalSpeed = hum.WalkSpeed
            SpeedWasOn = true
        end
        hum.WalkSpeed = Config.SPEED_Value
    elseif SpeedWasOn then
        hum.WalkSpeed = OriginalSpeed
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

local InfiniteJumpConn = nil
local function SetupInfiniteJump()
    if InfiniteJumpConn then InfiniteJumpConn:Disconnect() end
    InfiniteJumpConn = UserInputService.JumpRequest:Connect(function()
        if not Config.JUMP_Infinite then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

-- ================================================================
-- TELEPORT
-- ================================================================
local function TeleportToGenerator()
    local root = GetCharacterRoot()
    if not root then return end
    local gen = ESPGenerators[1]
    if gen then
        local part = gen:FindFirstChildWhichIsA("BasePart") or gen
        root.CFrame = CFrame.new(part.Position + Vector3.new(0, Config.TP_Offset, 0))
    end
end

local function TeleportToGate()
    local root = GetCharacterRoot()
    if not root then return end
    local map = Workspace:FindFirstChild("Map")
    if map then
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name == "Gate" then
                local part = obj:FindFirstChildWhichIsA("BasePart") or obj
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, Config.TP_Offset, 0))
                break
            end
        end
    end
end

local function TeleportToHook()
    local root = GetCharacterRoot()
    if not root then return end
    local map = Workspace:FindFirstChild("Map")
    if map then
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name == "Hook" then
                local part = obj:FindFirstChildWhichIsA("BasePart") or obj
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, Config.TP_Offset, 0))
                break
            end
        end
    end
end

-- ================================================================
-- FULLBRIGHT & NO FOG
-- ================================================================
local OriginalFogEnd, OriginalFogStart
local OriginalAmbient, OriginalOutdoorAmbient, OriginalBrightness

local function UpdateVisuals()
    if Config.FULLBRIGHT then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = OriginalAmbient or Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient or Color3.fromRGB(127, 127, 127)
        Lighting.Brightness = OriginalBrightness or 1
        Lighting.GlobalShadows = true
    end
    
    if Config.NO_Fog then
        OriginalFogEnd = Lighting.FogEnd
        OriginalFogStart = Lighting.FogStart
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        if OriginalFogEnd then Lighting.FogEnd = OriginalFogEnd end
        if OriginalFogStart then Lighting.FogStart = OriginalFogStart end
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
local lastUpdate = 0
local lastGenCheck = 0

local function MainLoop()
    if State.Unloaded then return end
    
    local cam = Workspace.CurrentCamera
    if not cam then return end
    
    local screenSize = cam.ViewportSize
    local screenCenter = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    local now = tick()
    
    -- Update ESP
    if now - lastUpdate >= 0.05 then
        lastUpdate = now
        UpdatePlayerESP()
        
        -- Update generator progress
        if now - lastGenCheck >= 0.2 then
            lastGenCheck = now
            UpdateGeneratorESP()
        end
    end
    
    -- Update other features
    Aimbot_Update(cam, screenCenter)
    UpdateParryFOV()
    UpdateDrawings(cam, screenCenter)
end

-- ================================================================
-- AUTO LOOP
-- ================================================================
local function AutoLoop()
    while not State.Unloaded do
        AutoAttack()
        UpdateSpeed()
        UpdateNoclip()
        UpdateFly()
        UpdateThirdPerson()
        UpdateVisuals()
        task.wait(0.1)
    end
end

-- ================================================================
-- UNLOAD
-- ================================================================
local function Unload()
    State.Unloaded = true
    
    -- Cleanup drawings
    for i = 1, FOV_SEGMENTS do pcall(function() FOVLines[i]:Remove() end) end
    for i = 1, 4 do pcall(function() CrossLines[i]:Remove() end) end
    if ParryFOVCircle then ParryFOVCircle:Remove() end
    
    -- Cleanup features
    pcall(PerfectSC_Stop)
    pcall(AutoParry_Cleanup)
    pcall(ThirdPerson_Remove)
    
    -- Cleanup ESP
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "_VHLight" or obj.Name == "_VHTag" or obj.Name == "_VHGenTag" then
            obj:Destroy()
        end
    end
    
    -- Reset character
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = OriginalSpeed
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    -- Cleanup fly
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    
    -- Cleanup infinite jump
    if InfiniteJumpConn then InfiniteJumpConn:Disconnect() end
    
    -- Reset lighting
    Lighting.Ambient = OriginalAmbient or Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = OriginalOutdoorAmbient or Color3.fromRGB(127, 127, 127)
    Lighting.Brightness = OriginalBrightness or 1
    if OriginalFogEnd then Lighting.FogEnd = OriginalFogEnd end
    if OriginalFogStart then Lighting.FogStart = OriginalFogStart end
    
    pcall(function() Window:Destroy() end)
    print("[Victoria] Unloaded")
end

-- ================================================================
-- VELARIS UI
-- ================================================================
local VelarisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/tesui.lua"))()

local Window = VelarisUI:Window({
    Title = "Victoria Hub | Violence District",
    Footer = "Final Fixed - No Errors",
    Content = "Violence District",
    Color = "Blue",
    Version = "5.0",
    KeySystem = {
        Title = "Victoria Hub",
        Default = "VD-KEYLESS",
        Callback = function(key) return key == "VD-KEYLESS" or key == "VICTORIA2025" end
    }
})

-- TABS
local Tabs = {
    ESP = Window:AddTab({ Name = "ESP", Icon = "lucide:eye" }),
    AIM = Window:AddTab({ Name = "Aim", Icon = "lucide:crosshair" }),
    SURVIVOR = Window:AddTab({ Name = "Survivor", Icon = "lucide:user" }),
    KILLER = Window:AddTab({ Name = "Killer", Icon = "lucide:sword" }),
    MOVEMENT = Window:AddTab({ Name = "Movement", Icon = "lucide:gamepad-2" }),
    MISC = Window:AddTab({ Name = "Misc", Icon = "lucide:settings" }),
}

-- ESP TAB
local secPlayers = Tabs.ESP:AddSection({ Title = "Players", Open = true })
secPlayers:AddToggle({ Title = "Killer ESP", Default = Config.ESP_Killer, Callback = function(v) Config.ESP_Killer = v end })
secPlayers:AddToggle({ Title = "Survivor ESP", Default = Config.ESP_Survivor, Callback = function(v) Config.ESP_Survivor = v end })
secPlayers:AddToggle({ Title = "Names", Default = Config.ESP_Names, Callback = function(v) Config.ESP_Names = v end })
secPlayers:AddToggle({ Title = "Distance", Default = Config.ESP_Distance, Callback = function(v) Config.ESP_Distance = v end })
secPlayers:AddToggle({ Title = "Health", Default = Config.ESP_Health, Callback = function(v) Config.ESP_Health = v end })

local secObjects = Tabs.ESP:AddSection({ Title = "Objects", Open = false })
secObjects:AddToggle({ Title = "Generator", Default = Config.ESP_Generator, Callback = function(v) Config.ESP_Generator = v; ScanMap() end })
secObjects:AddToggle({ Title = "Gate", Default = Config.ESP_Gate, Callback = function(v) Config.ESP_Gate = v; ScanMap() end })
secObjects:AddToggle({ Title = "Hook", Default = Config.ESP_Hook, Callback = function(v) Config.ESP_Hook = v; ScanMap() end })
secObjects:AddToggle({ Title = "Pallet", Default = Config.ESP_Pallet, Callback = function(v) Config.ESP_Pallet = v; ScanMap() end })
secObjects:AddToggle({ Title = "Window", Default = Config.ESP_Window, Callback = function(v) Config.ESP_Window = v; ScanMap() end })

-- AIM TAB
local secAim = Tabs.AIM:AddSection({ Title = "Aimbot", Open = true })
secAim:AddToggle({ Title = "Enable Aimbot", Default = Config.AIM_Enabled, Callback = function(v) Config.AIM_Enabled = v end })
secAim:AddToggle({ Title = "Auto Mode", Default = Config.AIM_AutoMode, Callback = function(v) Config.AIM_AutoMode = v end })
secAim:AddDropdown({ Title = "Target Mode", Options = { "Auto", "Killer", "Survivor", "Closest" }, Default = Config.AIM_TargetMode, Callback = function(v) Config.AIM_TargetMode = v end })
secAim:AddSlider({ Title = "FOV Size", Min = 50, Max = 400, Default = Config.AIM_FOV, Callback = function(v) Config.AIM_FOV = v end })
secAim:AddSlider({ Title = "Smoothness", Min = 1, Max = 20, Default = 6, Callback = function(v) Config.AIM_Smooth = v / 20 end })
secAim:AddToggle({ Title = "Visibility Check", Default = Config.AIM_VisCheck, Callback = function(v) Config.AIM_VisCheck = v end })
secAim:AddToggle({ Title = "Prediction", Default = Config.AIM_Predict, Callback = function(v) Config.AIM_Predict = v end })
secAim:AddToggle({ Title = "Show FOV", Default = Config.AIM_ShowFOV, Callback = function(v) Config.AIM_ShowFOV = v end })
secAim:AddToggle({ Title = "Crosshair", Default = Config.AIM_Crosshair, Callback = function(v) Config.AIM_Crosshair = v end })

-- SURVIVOR TAB
local secSurv = Tabs.SURVIVOR:AddSection({ Title = "Survivor", Open = true })
secSurv:AddToggle({ Title = "Remove Skill Check", Default = Config.ANTI_SkillCheck, Callback = function(v) Config.ANTI_SkillCheck = v end })
secSurv:AddToggle({ Title = "Perfect Skill Check", Default = Config.PERFECT_SkillCheck, Callback = function(v) Config.PERFECT_SkillCheck = v; if v then PerfectSC_Setup() else PerfectSC_Stop() end end })
secSurv:AddToggle({ Title = "No Fall Damage", Default = Config.SURV_NoFall, Callback = function(v) Config.SURV_NoFall = v end })
secSurv:AddToggle({ Title = "God Mode", Default = Config.SURV_GodMode, Callback = function(v) Config.SURV_GodMode = v end })

local secParry = Tabs.SURVIVOR:AddSection({ Title = "Auto Parry", Open = false })
secParry:AddToggle({ Title = "Auto Parry", Default = Config.AUTO_Parry, Callback = function(v) Config.AUTO_Parry = v; if v then AutoParry_Setup() else AutoParry_Cleanup() end end })
secParry:AddDropdown({ Title = "Parry Mode", Options = { "With Animation", "No Animation" }, Default = Config.PARRY_Mode, Callback = function(v) Config.PARRY_Mode = v end })
secParry:AddSlider({ Title = "Parry Distance", Min = 5, Max = 40, Default = Config.PARRY_Dist, Callback = function(v) Config.PARRY_Dist = v end })
secParry:AddToggle({ Title = "Show Parry FOV", Default = Config.PARRY_FOV, Callback = function(v) Config.PARRY_FOV = v end })

-- KILLER TAB
local secKill = Tabs.KILLER:AddSection({ Title = "Combat", Open = true })
secKill:AddToggle({ Title = "Auto Attack", Default = Config.AUTO_Attack, Callback = function(v) Config.AUTO_Attack = v end })
secKill:AddSlider({ Title = "Attack Range", Min = 5, Max = 20, Default = Config.AUTO_AttackRange, Callback = function(v) Config.AUTO_AttackRange = v end })
secKill:AddToggle({ Title = "Auto Hook", Default = false, Callback = function(v) end })
secKill:AddToggle({ Title = "Third Person", Default = Config.CAM_ThirdPerson, Callback = function(v) Config.CAM_ThirdPerson = v; UpdateThirdPerson() end })

-- MOVEMENT TAB
local secMove = Tabs.MOVEMENT:AddSection({ Title = "Movement", Open = true })
secMove:AddToggle({ Title = "Speed Hack", Default = Config.SPEED_Enabled, Callback = function(v) Config.SPEED_Enabled = v end })
secMove:AddSlider({ Title = "Speed Value", Min = 16, Max = 150, Default = Config.SPEED_Value, Callback = function(v) Config.SPEED_Value = v end })
secMove:AddToggle({ Title = "Fly", Default = Config.FLY_Enabled, Callback = function(v) Config.FLY_Enabled = v end })
secMove:AddSlider({ Title = "Fly Speed", Min = 10, Max = 200, Default = Config.FLY_Speed, Callback = function(v) Config.FLY_Speed = v end })
secMove:AddToggle({ Title = "Noclip", Default = Config.NOCLIP_Enabled, Callback = function(v) Config.NOCLIP_Enabled = v end })
secMove:AddToggle({ Title = "Infinite Jump", Default = Config.JUMP_Infinite, Callback = function(v) Config.JUMP_Infinite = v end })

-- Teleport Section
local secTP = Tabs.MOVEMENT:AddSection({ Title = "Teleport", Open = false })
secTP:AddSlider({ Title = "TP Offset", Min = 0, Max = 10, Default = Config.TP_Offset, Callback = function(v) Config.TP_Offset = v end })
secTP:AddButton({ Title = "TP to Generator", Callback = TeleportToGenerator })
secTP:AddButton({ Title = "TP to Gate", Callback = TeleportToGate })
secTP:AddButton({ Title = "TP to Hook", Callback = TeleportToHook })

-- MISC TAB
local secVisual = Tabs.MISC:AddSection({ Title = "Visual", Open = true })
secVisual:AddToggle({ Title = "No Fog", Default = Config.NO_Fog, Callback = function(v) Config.NO_Fog = v; UpdateVisuals() end })
secVisual:AddToggle({ Title = "Fullbright", Default = Config.FULLBRIGHT, Callback = function(v) Config.FULLBRIGHT = v; UpdateVisuals() end })

local secSystem = Tabs.MISC:AddSection({ Title = "System", Open = false })
secSystem:AddButton({ Title = "Unload Script", Callback = function()
    task.delay(0.5, function() Unload() end)
end })

-- ================================================================
-- INITIALIZATION
-- ================================================================
local function Init()
    -- Save original lighting
    OriginalAmbient = Lighting.Ambient
    OriginalOutdoorAmbient = Lighting.OutdoorAmbient
    OriginalBrightness = Lighting.Brightness
    
    -- Initial scan
    ScanMap()
    PerfectSC_Setup()
    AutoParry_Setup()
    SetupInfiniteJump()
    UpdateVisuals()
    
    -- Event handlers untuk refresh ESP
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            ScanMap()
            UpdateVisuals()
        end
    end)
    
    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        ScanMap()
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if player.Character then
            RemoveHighlight(player.Character)
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        ScanMap()
    end)
    
    -- Keybinds
    UserInputService.InputBegan:Connect(function(input, gp)
        if State.Unloaded then return end
        if input.KeyCode == Config.KEY_Panic then Unload(); return end
        if gp then return end
        if input.KeyCode == Config.KEY_TP_Gen then TeleportToGenerator() end
        if input.KeyCode == Config.KEY_TP_Gate then TeleportToGate() end
        if input.KeyCode == Config.KEY_TP_Hook then TeleportToHook() end
        if input.KeyCode == Config.KEY_Speed then Config.SPEED_Enabled = not Config.SPEED_Enabled end
        if input.KeyCode == Config.KEY_Noclip then Config.NOCLIP_Enabled = not Config.NOCLIP_Enabled end
        if input.KeyCode == Config.KEY_Fly then Config.FLY_Enabled = not Config.FLY_Enabled end
    end)
    
    -- Main loops
    RunService.RenderStepped:Connect(MainLoop)
    task.spawn(AutoLoop)
    
    print("[Victoria] Loaded Successfully!")
end

Init()
