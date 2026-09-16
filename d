repeat task.wait() until game:IsLoaded()

--== AUTO COPY LINK ON START ==
pcall(function()
    if setclipboard then 
        setclipboard("https://youtube.com/@invis_in") 
    elseif toclipboard then 
        toclipboard("https://youtube.com/@invis_in") 
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer

-- ═══ SERVICES & GLOBALS ════════════════════════════════════════════════
local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local Player            = Players.LocalPlayer
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local StarterGui        = game:GetService("StarterGui")
local StatsService      = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris            = game:GetService("Debris")
local Lighting          = game:GetService("Lighting")
local TeleportService   = game:GetService("TeleportService")
local HttpService       = game:GetService("HttpService")

if shared._InvisRunning then
    shared._InvisRunning = false
    if shared._PhysicsBind then shared._PhysicsBind:Disconnect(); shared._PhysicsBind = nil end
    if shared._FlyBind then shared._FlyBind:Disconnect(); shared._FlyBind = nil end
    task.wait(0.1)
end
shared._InvisRunning = true

-- ═══ CONFIGURATION & GLOBAL STATE ══════════════════════════════════════
local Config = {
    AutoParry = false,
    ParryMode = "Curve", 
    TargetTime = 67,       
    DistanceTiming = 100, 
    ParryCurveMode = "Camera", 
    HitSpeedMode = "Fast ball", 
    TargetMode = "Normal", 
    AutoSpam = false,
    ManualSpam = false,
    ManualSpamSpeed = 0.015,
    SuperSpam = false,
    SuperSpamClicks = 1,
    AutoAbility = false, 
    
    -- New Updates Config
    AbilityESP = false,
    SoccerMode = false,
    GodMode = false,
    CustomSpeed = nil,
    CustomJump = nil,
    CustomAnimID = "",
    
    SkinChangerEnabled = false,
    SwordName = "",
    SwordAnimName = "",
    SwordFXName = "",
    SwordAnimationsEnabled = true,
    EmoteName = "",
    LowGraphicsEnabled = false,
    
    SpecialSkillDetections = false,
    AutoPlay = false,
    AutoJumpEnabled = false,
    FlyEnabled = false,
    DesyncEnabled = false,
    DesyncMode = "1: Infinite Sky",
    ParryDirection = "Straight",
    AntiAfk = false,
    
    LookAtBallChar = false,
    LookAtBallCam = false,
    
    PlayerESP = false,  
    wowcurve = 0.33,
    
    UIBackground = "DARK",
    
    CustomComboFX = false,

    MusicEnabled = false,
    MusicLooped = false,
    MusicVolume = 0.5,
}

local BackgroundColors = {
    "DARK",
    "RED",
    "BLUE",
    "PURPLE",
    "GREEN",
    "ORANGE"
}

local Auto_Parry = {}
getgenv().ZX_Parry = getgenv().ZX_Parry or { Hooked = true, KeyTable = "Ball", Remote = true }
local lastParryTime = 0
local parryCooldown = 0.035
local lastHitTick = 0
local lastTargetChecked = nil
local rallyCounter = 0
local lastBallPossession = nil
local Last_Parry = 0
local Cache_Update_Tick = 0
local Last_Positions_Cache = {}

-- ═══ ANTI-SPAM HIGH SPEED RALLY TRACKER ═══════════════════════════════
local rallyTracker = {
    lastTarget = nil,
    counter = 0,
    validRallies = 0,
    lastChangeTick = 0
}

getgenv()._ZX_VelHistory = getgenv()._ZX_VelHistory or { ball = {}, player = {}, MAX_SAMPLES = 7 }
local _ZX_VelHistory = getgenv()._ZX_VelHistory

local function _ZX_pushVelSample(target, pos, vel)
    local history = target == "ball" and _ZX_VelHistory.ball or _ZX_VelHistory.player
    table.insert(history, 1, { pos = pos, vel = vel, t = tick() })
    while #history > _ZX_VelHistory.MAX_SAMPLES do table.remove(history, #history) end
end

-- ═══ EMERGENCY DISTANCE CALCULATOR (OPTIMIZED FORMULA) ═════════════════
local function GetEmergencyDistance(speed)
    local calculated = 8 + (speed * 0.09)
    return math.clamp(calculated, 10, 75)
end

function Auto_Parry.Get_Ball()
    local bc = workspace:FindFirstChild("Balls") or workspace:FindFirstChild("TrainingBalls")
    if bc then
        for _, b in pairs(bc:GetChildren()) do
            if b:IsA("BasePart") and (b:GetAttribute("realBall") or b:GetAttribute("target")) then 
                return b 
            end
        end
    end
    
    shared.ManualSpamActive = false
    shared.LastSpamTime = 0
    if shared.Clicked_Target_Name then 
        shared.Clicked_Target_Name = nil 
    end
    
    if type(parryLocked) == "table" then table.clear(parryLocked) end
    if type(lockTime) == "table" then table.clear(lockTime) end
    if type(lastHitTicks) == "table" then table.clear(lastHitTicks) end
    
    return nil
end

function Auto_Parry.GetTargetPlayer()
    local alive = workspace:FindFirstChild("Alive")
    local myChar = LocalPlayer.Character
    if not alive or not myChar then return nil end
    
    local myRoot = myChar.PrimaryPart or myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local cam = workspace.CurrentCamera
    if not cam then return nil end

    local targetMode = Config.TargetMode

    if targetMode == "Double click" then
        if shared.Clicked_Target_Name then
            local targetModel = alive:FindFirstChild(shared.Clicked_Target_Name)
            if targetModel and targetModel:FindFirstChild("HumanoidRootPart") then
                return targetModel
            end
        end
    end

    local bestTarget = nil
    local maxDot = -1

    for _, p in ipairs(alive:GetChildren()) do
        local hrp = p:FindFirstChild("HumanoidRootPart")
        if p ~= myChar and p:IsA("Model") and hrp then
            local targetDir = (hrp.Position - cam.CFrame.Position).Unit
            local camDot = cam.CFrame.LookVector:Dot(targetDir)

            if camDot > 0 and camDot > maxDot then
                maxDot = camDot
                bestTarget = p
            end
        end
    end

    if not bestTarget then
        local minDist = math.huge
        for _, p in ipairs(alive:GetChildren()) do
            local hrp = p:FindFirstChild("HumanoidRootPart")
            if p ~= myChar and p:IsA("Model") and hrp then
                local d = (hrp.Position - myRoot.Position).Magnitude
                if d < minDist then 
                    minDist = d 
                    bestTarget = p 
                end
            end
        end
    end

    return bestTarget
end

function Auto_Parry.Parry_Animation()
    if not Config.SwordAnimationsEnabled then return end
    pcall(function()
        local Parry_Animation = ReplicatedStorage.Shared.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        local Current_Sword = Player.Character:GetAttribute("CurrentlyEquippedSword")
        if not Current_Sword or not Parry_Animation then return end
        local Sword_Data = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)
        if not Sword_Data or not Sword_Data["AnimationType"] then return end
        for _, object in pairs(ReplicatedStorage.Shared.SwordAPI.Collection:GetChildren()) do
            if object.Name == Sword_Data["AnimationType"] then
                local animType = object:FindFirstChild("GrabParry") and "GrabParry" or (object:FindFirstChild("Grab") and "Grab")
                if animType then Parry_Animation = object[animType] end
            end
        end
        local track = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
        track:Play()
    end)
end

function Auto_Parry.CalculateParryCFrame(ball, targetPlayer)
    local cam = workspace.CurrentCamera
    local character = game.Players.LocalPlayer.Character
    local hrp = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
    
    if not targetPlayer or not targetPlayer.PrimaryPart then
        return targetPlayer and targetPlayer.PrimaryPart and targetPlayer.PrimaryPart.Position or Vector3.zero
    end
    
    local targetPos = targetPlayer.PrimaryPart.Position
    local parryCurveMode = Config.ParryCurveDirection or "Camera"
    
    if parryCurveMode == "Camera" and cam then
        return targetPos + (cam.CFrame.RightVector * 45) + (cam.CFrame.UpVector * 15)
        
    elseif parryCurveMode == "Left" and cam then
        return targetPos + (cam.CFrame.RightVector * -55)
        
    elseif parryCurveMode == "Right" and cam then
        return targetPos + (cam.CFrame.RightVector * 55)
        
    elseif parryCurveMode == "Up" then
        return targetPos + Vector3.new(0, 60, 0)
        
    elseif parryCurveMode == "Down" then
        return targetPos + Vector3.new(0, -35, 0)
        
    elseif parryCurveMode == "Random" then
        return targetPos + Vector3.new(math.random(-40, 40), math.random(-15, 40), math.random(-40, 40))
        
    elseif parryCurveMode == "Straight" then
        return targetPos
    end
    
    return targetPos
end

Auto_Parry.CalculateParryCframe = Auto_Parry.CalculateParryCFrame


local replicated_storage = cloneref(game:GetService('ReplicatedStorage'))
local workspace = cloneref(game:GetService('Workspace'))

local _token
for _, Function in getgc(true) do
    if type(Function) ~= 'function' or not debug.info(Function, 's'):find('PRY', 1, true) then
        continue
    end

    for _, value in debug.getupvalues(Function) do
        if type(value) == 'function' then
            print('found.')
            _token = value
            break
        end
    end

    if _token then
        break
    end
end

function _tokenize(_remote_uid)
    local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, 'TIME')
    local characters = table.create(#time)

    for index = 1, #time do
        characters[index] = string.char(bit32.bxor(
            (string.byte(time, index ) + index) % 256,
            string.byte(key, (index - 1) % #key + 1)
        ))
    end

    return table.concat(characters)
end

local _reverted = {}
local _original = {}
local _captured = nil

function _is_valid(args)
    return #args == 8 and type(args[2]) == "string" and type(args[3]) == "string" and type(args[4]) == "number" and typeof(args[5]) == "CFrame" and type(args[6]) == "table" and type(args[7]) == "table" and type(args[8]) == "boolean"
end

function _hook(remote)
    if not _reverted[remote] then
        if not _original[getrawmetatable(remote)] then
            _original[getrawmetatable(remote)] = true
            local _meta = getrawmetatable(remote)
            setreadonly(_meta, false)

            local _old = _meta.__index
            _meta.__index = function(self, key)
                if (key == 'FireServer' and self:IsA('RemoteEvent')) or
                   (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
                    return function(_, ...)
                        local _arguments = {...}
                        if _is_valid(_arguments) then
                            if not _reverted[self] then
                                _reverted[self] = _arguments
                                _captured = {
                                    remote = self,
                                    args = _arguments
                                }
                            end
                        end
                        return _old(self, key)(_, unpack(_arguments))
                    end
                end
                return _old(self, key)
            end
            setreadonly(_meta, true)
        end
    end
end

for _iterator, _remote in pairs(replicated_storage:GetDescendants()) do
    if _remote:IsA('RemoteEvent') or _remote:IsA('RemoteFunction') then
        _hook(_remote)
    end
end

task.wait(1)

-- =======================================================================
-- [MODIFIED] FUNCTION FIRE PARRY REMOTE & TASK.SPAWN NETWORK PIPELINE
-- =======================================================================
function Auto_Parry.FireParryRemote(isSpam)
    if not _reverted then return end
    
    local ball = Auto_Parry.Get_Ball()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local alive = workspace:FindFirstChild("Alive")
    local curTime = os.clock()

    -- ✅ DYNAMIC CACHE PROCESSING (อัปเดตทุก 0.1 วินาทีเพื่อลด Overhead)
    if curTime - Cache_Update_Tick > 0.1 then
        table.clear(Last_Positions_Cache)

        if alive then
            for _, character in ipairs(alive:GetChildren()) do
                if character:IsA("Model") and character.PrimaryPart then
                    if character.Name ~= game.Players.LocalPlayer.Name then
                        Last_Positions_Cache[character.Name] = Auto_Parry.CalculateParryCFrame(ball, character)
                    end
                end
            end
            
            local myChar = game.Players.LocalPlayer.Character
            local myHrp = myChar and (myChar.PrimaryPart or myChar:FindFirstChild("HumanoidRootPart"))
            if myHrp then 
                Last_Positions_Cache[game.Players.LocalPlayer.Name] = myHrp.Position 
            end
        end
        Cache_Update_Tick = curTime
    end

    -- 🚀 NETWORK PIPELINE (เจาะดัชนี Array ดักจับค่ารีโมท)
    for _remote, _originalArgs in pairs(_reverted) do
        if type(_originalArgs) == "table" and _originalArgs ~= nil then
            task.spawn(function()
                local centerX = cam.ViewportSize.X / 2
                local centerY = cam.ViewportSize.Y / 2

                pcall(function()
                    if _remote:IsA("RemoteEvent") then
                        _remote:FireServer(
                            _originalArgs[1],            -- ดึง Token ดัชนีตัวที่ 1
                            _originalArgs[2],            -- ดึง Token ดัชนีตัวที่ 2
                            _tokenize(_originalArgs[2]), -- ✅ ฟังก์ชันถอดรหัสใช้เฉพาะดัชนีตัวที่ 2 เท่านั้น
                            isSpam and 0.001 or 0.5,   
                            cam.CFrame,                 
                            Last_Positions_Cache,       
                            {centerX, centerY},         
                            false                     
                        )
                    end
                end)
            end)
        end
    end
end

function Auto_Parry.Is_Curved(ball)
    local success, isCurved = pcall(function()
        if not ball or not ball:IsA("BasePart") then return false end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return false end

        local hrp = char.HumanoidRootPart
        local ballVel = ball.AssemblyLinearVelocity
        if ballVel.Magnitude < 1 then return false end

        local dirToPlayer = (hrp.Position - ball.Position).Unit
        local ballDir = ballVel.Unit
        local dot = ballDir:Dot(dirToPlayer)

        return (dot < 0.75 and dot > -0.6)
    end)

    return success and isCurved or false
end

function Auto_Parry.IsTargetingMe(ball)
    if not ball then return false end
    
    -- ดึงค่า Target จาก Attribute ของลูกบอล
    local targetName = tostring(ball:GetAttribute("target") or ball:GetAttribute("Target") or "")
    local localName = LocalPlayer.Name
    
    if targetName == localName then 
        return true 
    end
    if LocalPlayer.Character and targetName == LocalPlayer.Character.Name then 
        return true 
    end
    
    return false
end


-- ═══ SKIN CHANGER BACKEND SYSTEM ═══════════════
getgenv().skinChanger = false
getgenv().swordModel = ""
getgenv().swordAnimations = ""
getgenv().swordFX = ""

task.spawn(function()
    local rs = ReplicatedStorage
    local swordInstancesInstance = rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
    local swordInstances = require(swordInstancesInstance)

    local swordsController
    task.spawn(function()
        while task.wait() and not swordsController do
            local ok, conns = pcall(getconnections, rs.Remotes.FireSwordInfo.OnClientEvent)
            if ok and conns then
                for _, v in ipairs(conns) do
                    if v.Function and islclosure and islclosure(v.Function) then
                        local ok2, up = pcall(getupvalues, v.Function)
                        if ok2 and #up == 1 and type(up[1]) == "table" then
                            swordsController = up[1]
                            break
                        end
                    end
                end
            end
        end
    end)

    local function getSlashName(swordName)
        local ok, sln = pcall(function() return swordInstances:GetSword(swordName) end)
        return (ok and sln and sln.SlashName) or "SlashEffect"
    end

    local function refreshSlashName()
        local fxName = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
        if fxName ~= "" then getgenv().slashName = getSlashName(fxName) else getgenv().slashName = "SlashEffect" end
    end

    local function setSword()
        if not getgenv().skinChanger then return end
        if not LocalPlayer.Character then return end
        pcall(function()
            local f = rawget(swordInstances, "EquipSwordTo")
            if type(f) == "function" then
                local ups = getupvalues(f)
                for i = 1, #ups do if type(ups[i]) == "boolean" then setupvalue(f, i, false) break end end
            end
        end)
        pcall(function() swordInstances:EquipSwordTo(LocalPlayer.Character, getgenv().swordModel) end)
        task.spawn(function()
            local attempts = 0
            while not swordsController and attempts < 20 do task.wait(0.5); attempts = attempts + 1 end
            if not swordsController then return end
            pcall(function()
                if swordsController.SetSword then
                    swordsController:SetSword(getgenv().swordAnimations ~= "" and getgenv().swordAnimations or getgenv().swordModel)
                end
            end)
            pcall(function()
                local targetSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                if rs.Remotes:FindFirstChild("FireSwordInfo") then rs.Remotes.FireSwordInfo:FireServer(targetSword) end
                if swordsController.currentSword ~= nil then swordsController.currentSword = targetSword end
                if swordsController.SwordFX ~= nil then swordsController.SwordFX = targetSword end
            end)
        end)
    end

    -- Hook ParrySuccessAll for FX Override
    local hookedFuncs = {}
    task.spawn(function()
        while task.wait(1) do
            local ok, conns = pcall(getconnections, rs.Remotes.ParrySuccessAll.OnClientEvent)
            if ok and type(conns) == "table" then
                for _, v in ipairs(conns) do
                    local func = v.Function
                    if func and not hookedFuncs[func] then
                        if isourclosure and isourclosure(func) then 
                            hookedFuncs[func] = true
                        else
                            hookedFuncs[func] = true
                            v:Disable()
                            local targetFunc = func
                            local ourFunc
                            ourFunc = function(...)
                                local args = { ... }
                                if tostring(args[4]) == LocalPlayer.Name and getgenv().skinChanger then
                                    local fxSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                    refreshSlashName()
                                    args[1] = getgenv().slashName
                                    args[3] = fxSword
                                end
                                if setthreadidentity then pcall(setthreadidentity, 2) end
                                pcall(targetFunc, unpack(args))
                            end
                            hookedFuncs[ourFunc] = true
                            rs.Remotes.ParrySuccessAll.OnClientEvent:Connect(ourFunc)
                        end
                    end
                end
            end
        end
    end)

    getgenv().updateSword = function() refreshSlashName(); setSword() end

    -- Persistent Sync Loop
    task.spawn(function()
        while task.wait(1) do
            if getgenv().skinChanger and getgenv().swordModel ~= "" then
                local char = LocalPlayer.Character
                if char then
                    if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel then setSword() end
                    if not char:FindFirstChild(getgenv().swordModel) then setSword() end
                    for _, v in char:GetChildren() do
                        if v:IsA("Model") and v.Name ~= getgenv().swordModel then v:Destroy() end
                        task.wait()
                    end
                end
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        if getgenv().skinChanger then
            getgenv().skinChanger = false; task.wait(1.5)
            getgenv().skinChanger = true; task.wait(0.5)
            pcall(function() getgenv().updateSword() end)
        end
    end)
end)

-- =======================================================================
-- 🎮 SMART AUTO ABILITY v3 (FIXED & FULLY FUNCTIONAL VERSION)
-- =======================================================================
local AbilityRemote = nil
local AbilityRawFunc = nil
local abilityHooked = false

local AutoAbilityData = {
    Enabled = false,
    LastAbilityName = nil,
}
getgenv().ZX_AutoAbility = AutoAbilityData

-- กำหนดเวลา Cooldown และจังหวะการกดแยกตามแต่ละสกิล
local ABILITY_TIMINGS = {
    ["Raging Deflection"] = { cooldown = 15, fireAt = 0.5, trigger = "target" },
    ["Calming Deflection"] = { cooldown = 15, fireAt = 1.2, trigger = "target" },
    ["Rapture"]            = { cooldown = 20, fireAt = 2.0, trigger = "proximity" },
    ["Aerodynamic Slash"]  = { cooldown = 12, fireAt = 0.8, trigger = "target" },
    ["Fracture"]           = { cooldown = 18, fireAt = 1.5, trigger = "proximity" },
    ["Death Slash"]        = { cooldown = 25, fireAt = 3.0, trigger = "clash" },
}
getgenv().ZX_AbilityTimings = ABILITY_TIMINGS

local _abilityLastFire = {}

-- Hook Remote สำหรับกดใช้ Ability
task.spawn(function()
    task.wait(2)
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local abilRemote = ReplicatedStorage:WaitForChild("Remotes", 5):FindFirstChild("AbilityButtonPress")
        if abilRemote then
            if abilRemote:IsA("RemoteEvent") then
                AbilityRemote = abilRemote
                AbilityRawFunc = abilRemote.FireServer
                abilityHooked = true
            elseif abilRemote:IsA("RemoteFunction") then
                AbilityRemote = abilRemote
                AbilityRawFunc = abilRemote.InvokeServer
                abilityHooked = true
            end
        end
    end)
end)

local function fireAbilityRemote()
    if not AbilityRemote or not AbilityRawFunc then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:FireServer()
        end)
        return true
    end
    pcall(function()
        if AbilityRemote:IsA("RemoteEvent") then
            AbilityRawFunc(AbilityRemote)
        else
            AbilityRemote:InvokeServer()
        end
    end)
    return true
end

-- 🛠️ FIXED: ฟังก์ชันตรวจเช็คว่าสกิลพร้อมใช้งานจริงจากหน้าจอ UI ของผู้เล่น
local function isAbilityReady()
    local success, ready = pcall(function()
        local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not PlayerGui then return true end
        
        -- ตรวจหาปุ่มกดสกิลดั้งเดิมของตัวเกม
        local screenGui = PlayerGui:FindFirstChild("ScreenGui") or PlayerGui:FindFirstChild("MainGui")
        if screenGui then
            local hotbar = screenGui:FindFirstChild("Hotbar") or screenGui:FindFirstChild("AbilityFrame")
            local abilityBtn = hotbar and (hotbar:FindFirstChild("AbilityButton") or hotbar:FindFirstChild("Ability"))
            
            if abilityBtn then
                -- ตรวจสอบหาภาพเฟดคูลดาวน์ (ถ้ามีกรอบคูลดาวน์บดบังอยู่ หรือความโปร่งแสงไม่เต็ม แปลว่ายังไม่พร้อม)
                local cdFrame = abilityBtn:FindFirstChild("Cooldown") or abilityBtn:FindFirstChild("Darken")
                if cdFrame and cdFrame.Visible then
                    return false
                end
            end
        end
        return true
    end)
    return success and ready
end

local function isAbilityOffCooldown(abilityName)
    local timing = ABILITY_TIMINGS[abilityName]
    if not timing then return true end
    local lastFire = _abilityLastFire[abilityName] or 0
    return (tick() - lastFire) >= timing.cooldown
end

local function getEquippedAbility()
    local char = game:GetService("Players").LocalPlayer.Character
    if not char then return nil end
    local abilities = char:FindFirstChild("Abilities")
    if not abilities then return nil end
    for name, _ in pairs(ABILITY_TIMINGS) do
        local abil = abilities:FindFirstChild(name)
        if abil and (abil:GetAttribute("Equipped") or abil.Enabled == true) then
            return name
        end
    end
    for _, abil in ipairs(abilities:GetChildren()) do
        if abil:GetAttribute("Equipped") or abil.Enabled == true then
            return abil.Name
        end
    end
    local first = abilities:GetChildren()[1]
    return first and first.Name or nil
end
getgenv().ZX_GetEquippedAbility = getEquippedAbility

local _lastBallTargetTime = 0
local _lastClashTime = 0

local function smartAutoAbility()
    -- 🛠️ FIXED: ผูกเงื่อนไขเข้ากับระบบ Config หน้าต่าง UI ของสคริปต์คุณให้ถูกต้อง
    if not Config.AutoAbility then return false end
    if not isAbilityReady() then return false end

    local abilityName = getEquippedAbility()
    if not abilityName then return false end

    local timing = ABILITY_TIMINGS[abilityName]
    if not timing then
        task.spawn(function()
            local fired = fireAbilityRemote()
            if fired then
                AutoAbilityData.LastAbilityName = abilityName
                _abilityLastFire[abilityName] = tick()
            end
        end)
        return false  
    end

    if not isAbilityOffCooldown(abilityName) then return false end

    local ball = Auto_Parry.Get_Ball()
    if not ball then return false end

    local target = ball:GetAttribute("target") or ball:GetAttribute("Target")
    local isTargetingMe = (tostring(target or "") == game:GetService("Players").LocalPlayer.Name)

    local char = game:GetService("Players").LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local ballDist = 999
    if hrp and ball.Parent then
        ballDist = (ball.Position - hrp.Position).Magnitude
    end

    local shouldFire = false
    if timing.trigger == "target" then
        if isTargetingMe then
            if (tick() - _lastBallTargetTime) >= timing.fireAt then
                shouldFire = true
            end
        end
    elseif timing.trigger == "proximity" then
        if isTargetingMe and ballDist <= 45 then -- ขยายระยะตรวจจับสกิลระเบิดรอบตัวให้กว้างขึ้นเล็กน้อย
            if (tick() - _lastBallTargetTime) >= timing.fireAt then
                shouldFire = true
            end
        end
    elseif timing.trigger == "clash" then
        if (tick() - _lastClashTime) <= 2 and (tick() - _lastClashTime) >= timing.fireAt then
            shouldFire = true
        end
    end

    if not shouldFire then return false end

    task.spawn(function()
        local fired = fireAbilityRemote()
        if fired then
            AutoAbilityData.LastAbilityName = abilityName
            _abilityLastFire[abilityName] = tick()
            pcall(function() CustomNotify("⚡ Smart Ability Activated: " .. abilityName, 2.5) end)
        end
    end)
    return false  
end
getgenv().ZX_SmartAutoAbility = smartAutoAbility

task.spawn(function()
    while true do
        task.wait(0.05)
        local ball = Auto_Parry.Get_Ball()
        if ball then
            local target = ball:GetAttribute("target") or ball:GetAttribute("Target")
            if tostring(target or "") == game:GetService("Players").LocalPlayer.Name then
                if _lastBallTargetTime == 0 then
                    _lastBallTargetTime = tick()
                end
            else
                _lastBallTargetTime = 0
            end
        else
            _lastBallTargetTime = 0
        end
    end
end)

pcall(function()
    game:GetService("ReplicatedStorage").Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
        if root and root.Parent and root.Parent ~= game:GetService("Players").LocalPlayer.Character then
            _lastClashTime = tick()
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if Config.AutoAbility then
            smartAutoAbility()
        end
    end
end)

-- ═══ DOUBLE CLICK TARGETING ENGINE (FIXED SCREEN CACHE) ═══
shared.Clicked_Target_Name = nil
local lastClickTime = 0

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local now = tick()
        if now - lastClickTime < 0.35 then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target:IsA("BasePart") then
                local model = target:FindFirstAncestorOfClass("Model")
                local alive = workspace:FindFirstChild("Alive")
                if model and alive and model:IsDescendantOf(alive) and model ~= LocalPlayer.Character then
                    shared.Clicked_Target_Name = model.Name
                    CustomNotify("🎯 Locked Double Click Target: " .. model.Name, 2.5)
                end
            end
        else
            -- ดับเบิ้ลคลิกพื้นที่ว่างเพื่อเคลียร์การล็อกเป้าหมาย
            if shared.Clicked_Target_Name and now - lastClickTime >= 1.5 then
                shared.Clicked_Target_Name = nil
                CustomNotify("🔓 Target Unlocked (Auto Mode)", 2)
            end
        end
        lastClickTime = now
    end
end)

-- ฟังก์ชันสร้าง Cache ตำแหน่งหน้าจอส่งให้ตัวเกม (รองรับล็อกเป้า/Nearest/Farest)
local function BuildDynamicPositionsCache()
    local positionsCache = {}
    local alive = workspace:FindFirstChild("Alive")
    local cam = workspace.CurrentCamera
    if not alive or not cam then return positionsCache end

    -- ตรวจสอบการล็อกเป้าหมายจากการดับเบิ้ลคลิก (Double Click Locked Target)
    if shared.Clicked_Target_Name then
        local tar = alive:FindFirstChild(shared.Clicked_Target_Name)
        if tar and tar:FindFirstChild("HumanoidRootPart") then
            positionsCache[shared.Clicked_Target_Name] = cam:WorldToScreenPoint(tar.HumanoidRootPart.Position)
            return positionsCache
        else
            shared.Clicked_Target_Name = nil -- ปลดล็อกอัตโนมัติหากเป้าหมายตายหรือหลุดจาก Alive
        end
    end

    -- โหมดการค้นหาเป้าหมายอัตโนมัติตามเมนู (Nearest / Farest / Normal)
    local targetPlayer = Auto_Parry.GetTargetPlayer()
    if targetPlayer and targetPlayer:FindFirstChild("HumanoidRootPart") then
        positionsCache[targetPlayer.Name] = cam:WorldToScreenPoint(targetPlayer.HumanoidRootPart.Position)
    end
    return positionsCache
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ═══ ULTIMATE CORE PHYSICS LOOP (PERFECT ANTI-DOUBLE HANDLER - PART 1/3) ══
-- ═══════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- 📦 State Tables & Memory Buffers
local parryLocked = parryLocked or {}
local lockTime = lockTime or {}
local lastHitTicks = lastHitTicks or {}
local lastParryTime = lastParryTime or 0
_clashStartTime = _clashStartTime or 0
shared.ManualSpamActive = shared.ManualSpamActive or false
local activeClashBall = nil
local clashPartner = ""
local velocityHistory = {} -- คลังจดจำวิถีความเร็วแบบ Real-timeต่อเฟรม

-- เอาไปวางไว้ด้านบนสุด ด้านใน shared._PhysicsBind ทันทีหลังจากประกาศ local parryLocked
shared.InvisClearLock = function(targetBall)
    if targetBall and parryLocked and lockTime then
        parryLocked[targetBall] = false
        lockTime[targetBall] = 0
    end
end

-- 📡 1. PING LISTENER FOR DYNAMIC TIMING COMPENSATION
local pingSeconds = 0.03
task.spawn(function()
    while true do
        pcall(function()
            if StatsService then
                local network = StatsService:FindFirstChild("Network")
                if network then
                    local serverStats = network:FindFirstChild("ServerStatsItem")
                    if serverStats then
                        local dataPing = serverStats:FindFirstChild("Data Ping")
                        if dataPing then
                            pingSeconds = math.clamp((dataPing:GetValue() or 30) / 1000, 0.01, 0.3)
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- 📦 2. VELOCITY INTEGRATION FALLBACK
if type(_ZX_pushVelSample) ~= "function" then
    getgenv()._ZX_VelHistory = getgenv()._ZX_VelHistory or {}
    getgenv()._ZX_pushVelSample = function(key, pos, vel)
        _ZX_VelHistory[key] = _ZX_VelHistory[key] or {}
        table.insert(_ZX_VelHistory[key], 1, {pos = pos, vel = vel, time = os.clock()})
        if #_ZX_VelHistory[key] > 5 then
            table.remove(_ZX_VelHistory[key])
        end
    end
end

-- 🛡️ 3. EMERGENCY DEFENSE OVERWRITE
local function SafeGetEmergencyDistance(speed)
    local calculated = 8 + (speed * 0.09) + (pingSeconds * speed * 1.5)
    -- กำหนดเพดานระยะฉุกเฉินสูงสุดที่ 25
    local infinityBuffer = math.clamp(calculated, 10, 50) 
    if type(GetEmergencyDistance) == "function" then
        local success, result = pcall(GetEmergencyDistance, speed)
        if success and type(result) == "number" then
            -- บังคับไม่ให้ค่าเกิน 25
            return math.min(math.max(result, math.clamp(8 + (speed * 0.09), 10, 25)), 25)
        end
    end
    return infinityBuffer
end

-- 🎯 4. STABLE OBJECT RESOLVER
local function SafeGetBalls()
    local balls = {}
    if type(Auto_Parry) == "table" then
        if type(Auto_Parry.Get_Balls) == "function" then
            local success, res = pcall(Auto_Parry.Get_Balls)
            if success then
                if type(res) == "table" then balls = res
                elseif res and typeof(res) == "Instance" then balls = {res} end
            end
        elseif type(Auto_Parry.Get_Ball) == "function" then
            local success, res = pcall(Auto_Parry.Get_Ball)
            if success then
                if type(res) == "table" then
                    balls = res
                elseif res and typeof(res) == "Instance" then
                    balls = {res}
                end
            end
        end
    end
    return balls
end

-- ⚡ 5. DISCONNECT PREVIOUS BINDS
if shared._PhysicsBind then shared._PhysicsBind:Disconnect() end
if shared._BBAChaoticThread then task.cancel(shared._BBAChaoticThread) shared._BBAChaoticThread = nil end

local singularityEndTime = 0

if shared._BBAChaoticThread then task.cancel(shared._BBAChaoticThread) end

local lastAutoSpamTime = 0

if shared._BBAChaoticThread then task.cancel(shared._BBAChaoticThread) end

shared._BBAChaoticThread = task.spawn(function()
    while shared._InvisRunning do
        local cfg = (type(Config) == "table") and Config or {}
        local autoSpamEnabled = cfg.AutoSpam or cfg.AutoSpamClash or false
        
        if not autoSpamEnabled then
            shared.ManualSpamActive = false
            _clashStartTime = 0
        end

        -- ⚔️ ทำงานเมื่อเปิด Auto Spam และสถานะตัวละครอยู่ในจุดปะทะ (Clash Zone)
        if autoSpamEnabled and shared.ManualSpamActive then
            local currentTime = os.clock()
            
            -- 🚀 [Zythera Overdrive Loop]: ดึงคูลดาวน์ลงลึกกว่ารอบเฟรมเรตปกติ (ทะลุขีดจำกัด 0.001s)
            -- ตั้งค่าล็อกขั้นต่ำสุดไว้ที่ 0.0005 วินาที เพื่อการระเบิดแพ็กเก็ตถี่แบบต่อเนื่อง
            local targetSpeed = math.max(0.0005, Config.ManualSpamSpeed or 0.015)
            
            if currentTime - lastAutoSpamTime >= targetSpeed then
                -- ⚡ แตกเธรดย่อยคู่ขนาน (Asynchronous) เพื่อดันสัญญาณบล็อกไปหาเซิร์ฟเวอร์แบบ Real-time 
                coroutine.wrap(function()
                    if autoSpamEnabled and shared.ManualSpamActive and type(Auto_Parry) == "table" and type(Auto_Parry.FireParryRemote) == "function" then
                        -- กระหน่ำยิงแพ็กเก็ตเพิ่มความหนาแน่นสูงสุดในเฟรมนั้น 
                        for i = 1, 12 do
                            pcall(Auto_Parry.FireParryRemote, true)
                        end
                    end
                end)()
                lastAutoSpamTime = currentTime
            end
        end
        -- สั่งพักลูปด้วยเศษเสี้ยวเวลาที่สั้นที่สุดที่เธรดระบบคอมพิวเตอร์จะประมวลผลได้
        task.wait(0.0001) 
    end
end)

local LockedSingularBall = nil 
local LastSingularState = false
shared._PhysicsBind = RunService.RenderStepped:Connect(function()

    if not shared._InvisRunning then return end

    local character = LocalPlayer.Character
    if not character or not character.PrimaryPart then 
        shared.ManualSpamActive = false
        _clashStartTime = 0
        return 
    end

    local hrp = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
    if not hrp then return end

    local balls = SafeGetBalls()
    if #balls == 0 then
        shared.ManualSpamActive = false
        _clashStartTime = 0
        return
    end

    local playerPos = hrp.Position
    local anyTargetingMe = false
    local shouldSpamAny = false
    local now = os.clock()
    
    local tempSpamBall = nil
    local tempSpamTarget = ""

    local cfg = (type(Config) == "table") and Config or {}
    local autoParryEnabled = cfg.AutoParry or false
    local autoSpamEnabled = cfg.AutoSpam or cfg.AutoSpamClash or false
    local soccerMode = cfg.SoccerMode or false
    local parryMode = cfg.ParryMode or "Curve"
    local distanceTiming = cfg.DistanceTiming or 100
    local targetTime = cfg.TargetTime or 0.3

    -- 🛡️ [Scanner] เช็คกลุ่มลูกบอลซ้อนประชิดตัว
    local myTargetedBalls = {}
    for _, b in ipairs(balls) do
        if b and b.Parent then
            local tAttr = b:GetAttribute("target") or b:GetAttribute("Target")
            if tostring(tAttr or "") == LocalPlayer.Name then
                table.insert(myTargetedBalls, b)
            end
        end
    end

    local multiBallBurstCount = 1
    if #myTargetedBalls >= 2 then
        for i = 1, #myTargetedBalls do
            local ballA = myTargetedBalls[i]
            local distToMe = (playerPos - ballA.Position).Magnitude
            if distToMe < 25 then
                local closeGroupCount = 1
                for j = 1, #myTargetedBalls do
                    if i ~= j then
                        local ballB = myTargetedBalls[j]
                        if (ballA.Position - ballB.Position).Magnitude < 8 then
                            closeGroupCount = closeGroupCount + 1
                        end
                    end
                end
                if closeGroupCount > multiBallBurstCount then multiBallBurstCount = closeGroupCount end
            end
        end
    end
    for idx, Ball in ipairs(balls) do
        if not Ball or typeof(Ball) ~= "Instance" or not Ball.Parent then continue end

        -- 🛰️ ดึงข้อมูลวิถีฟิสิกส์สไตล์ ZytheraX
        local Velocity = Vector3.zero
        local Zoomies = Ball:FindFirstChild("zoomies")
        
        if Zoomies then
            local s, v = pcall(function() return Zoomies.VectorVelocity end)
            if s and v then Velocity = v end
        end
        if Velocity == Vector3.zero and Ball:IsA("BasePart") then
            Velocity = Ball.AssemblyLinearVelocity
        end

        local Speed = Velocity.Magnitude
        local ballPos = Ball.Position
        local Distance = (playerPos - ballPos).Magnitude

        local ballDirection = Speed > 1 and Velocity.Unit or Vector3.new(0, -1, 0)
        local toPlayerDirection = Distance > 0.1 and (playerPos - ballPos).Unit or Vector3.zero
        local dotProduct = ballDirection:Dot(toPlayerDirection)

        local targetAttr = Ball:GetAttribute("target") or Ball:GetAttribute("Target")
        local ballTargetStr = tostring(targetAttr or "")
        local isTargetingMe = (ballTargetStr == LocalPlayer.Name or ballTargetStr == tostring(LocalPlayer))

        if soccerMode then
            isTargetingMe = (dotProduct > -0.15 or Distance <= 16)
        end

        if not isTargetingMe then
            lastHitTicks[Ball] = 0
            parryLocked[Ball] = false
            lockTime[Ball] = 0
            continue
        else
            anyTargetingMe = true
        end

        -- 🔒 HARD LOCK COOLDOWN BYPASS (สูตรเสถียรภาพสัญญาณ Eryndor)
        if parryLocked[Ball] then
            local safeLockCooldown = math.clamp(0.45 - (Speed * 0.0001), 0.70, 0.85)
            
            if multiBallBurstCount > 1 then
                safeLockCooldown = 0.4
            end

            if now - (lockTime[Ball] or 0) >= safeLockCooldown then
                parryLocked[Ball] = false
            else
                continue
            end
        end


        -- ⚔️ คำนวณขยายเกณฑ์ Clash Zone แบบใกล้ชิด
        local targetPlr = Auto_Parry.GetTargetPlayer()
        local insideBodyZone = false
        if targetPlr and targetPlr:FindFirstChild("HumanoidRootPart") then
            if (hrp.Position - targetPlr.HumanoidRootPart.Position).Magnitude <= 6.5 then
                insideBodyZone = true
            end
        end

        local ballRallyCount = Ball:GetAttribute("rally") or Ball:GetAttribute("Rally") or Ball:GetAttribute("Rallies") or 0
        local dynamicClashDistance = 10
        if ballRallyCount >= 4 then
            local pingCompensation = (pingSeconds * Speed * 1.5)
            dynamicClashDistance = math.clamp((Speed * 0.95) + pingCompensation, 22, 55)
        end

        local reachTime = Distance / math.max(Speed, 1)
        local isRealClashZone = (Distance <= dynamicClashDistance) or (reachTime <= 0.25 and Distance <= 40) or insideBodyZone
        
        if autoSpamEnabled and (isTargetingMe or insideBodyZone) and isRealClashZone then
            parryLocked[Ball] = false
            shouldSpamAny = true
            tempSpamBall = Ball
            tempSpamTarget = insideBodyZone and targetPlr.Name or ballTargetStr
            continue
        end

        -- 🎯 ยิงตรรกะตัดสินใจสวนกลับแบบแม่นยำสูง
        local allowedToHit = isTargetingMe and not parryLocked[Ball]
        
        if autoParryEnabled and allowedToHit then
            local triggerParry = false
            local userScale = distanceTiming / 100
            local emergencyDist = SafeGetEmergencyDistance(Speed) + 2.5
            
            if reachTime <= 0.05 then
                triggerParry = true
            end
            
            if Speed > 470 then
                local triggerTimeThreshold = pingSeconds + 0.34
                if reachTime <= triggerTimeThreshold or Distance <= emergencyDist then
                    triggerParry = true
                end
            else
                if parryMode == "Curve" then
                    local maxCurveDist = (Speed > 470) and 35 or 18.5
                    local bypassAntiCurve = (Distance <= emergencyDist and Distance <= maxCurveDist)

                    if bypassAntiCurve then
                        triggerParry = true
                    else
                        local lateralVelocity = Velocity - (Velocity.Unit:Dot(toPlayerDirection) * Velocity.Unit)
                        local pingBuffer = (pingSeconds * Speed * 1.35)
                        local strikeZone = math.clamp((16.5 + (Speed * (Config.wowcurve or 0.35))) - (lateralVelocity.Magnitude * 0.15) + pingBuffer, 17, 120) * userScale
                        
                        -- 🚀 FIX: Bola lambat (speed < 130) dapat reachTime threshold lebih besar
                        local dynamicReachTime = 0.285
                        if Speed < 130 then
                            dynamicReachTime = 0.50   -- bola lambat: fire 0.5s sebelum sampai
                        elseif Speed < 200 then
                            dynamicReachTime = 0.38
                        end
                        
                        if Distance <= strikeZone or reachTime <= dynamicReachTime then
                            if dotProduct > -0.35 or Distance <= 35 then
                                triggerParry = true
                            end
                        end
                    end
                elseif parryMode == "Distance" then
                    local pingBuffer = pingSeconds * Speed * 1.55
                    local distanceThreshold = math.clamp(((21.5 + Speed * 0.16) * userScale) + pingBuffer, 18.5, 105)
                    if Distance <= distanceThreshold or reachTime <= 0.28 or Distance <= emergencyDist then
                        triggerParry = true
                    end
                elseif parryMode == "Time" then
                    local timeThreshold = math.clamp(((21.5 + Speed * 0.16) * userScale) + (pingSeconds * Speed * 1.5), 18.5, 105)
                    local dynamicTimeWindow = targetTime + (pingSeconds * 1.25) + 0.15
                    if reachTime <= dynamicTimeWindow or Distance <= timeThreshold or Distance <= emergencyDist then
                        triggerParry = true
                    end
                end
            end

            -- 🚀 สั่งรันเน็ตเวิร์กแพ็คเก็ตตีลูกบอลโต้กลับ (อัปเดตคีย์ตามลูกบอลจริง)
            if triggerParry then
                -- สกัดคีย์ปัจจุบันจากแอตทริบิวต์หรือคีย์ลับของบอลลูกที่กำลังจะถึงตัว
                local bTarget = Ball:GetAttribute("target") or Ball:GetAttribute("Target")
                if bTarget then
                    -- อัปเดตคีย์เข้าสู่ระบบสแกนเนอร์หลักทันทีเพื่อให้ FireParryRemote ดึงไปสร้าง Token ได้ถูกต้อง
                    ZX_Parry.KeyTable = Ball:GetAttribute("realBall") or Ball.Name or bTarget
                end

                if (now - lastParryTime) >= 0.003 then 
                    if type(Auto_Parry) == "table" and type(Auto_Parry.FireParryRemote) == "function" then
                        local speedBurst = (Speed > 2000) and 3 or 1
                        local finalBurstCount = math.max(speedBurst, multiBallBurstCount)
                        
                        -- ส่งสัญญาณแพ็กเก็ตตีโต้กลับตามจำนวน Burst
                        for i = 1, finalBurstCount do
                            pcall(Auto_Parry.FireParryRemote, false)
                        end
                    end
                    lastParryTime = now
                end
                lastHitTicks[Ball] = now
                parryLocked[Ball] = true
                lockTime[Ball] = now
           end
        end
    end

    -- ⚔️ SYSTEM SPAM CONTROLLER CLEANUP
    if shouldSpamAny and tempSpamBall then
        local now = os.clock()
        if clashPartner ~= "" and tempSpamTarget ~= "" and tempSpamTarget ~= clashPartner then
            if _differentTargetStart == 0 then
                _differentTargetStart = now 
            elseif (now - _differentTargetStart) > 0.45 then
                shared.ManualSpamActive = false
                shared.LastSpamTime = 0
                activeClashBall = nil
                clashPartner = ""
                _clashStartTime = 0
                _differentTargetStart = 0
                return
            end
        else
            _differentTargetStart = 0
        end

        activeClashBall = tempSpamBall
        clashPartner = tempSpamTarget
        shared.ManualSpamActive = true
        shared.LastSpamTime = now
    else
        _differentTargetStart = 0 
        local now = os.clock()
        if shared.ManualSpamActive then
            local dist = 999
            if activeClashBall and activeClashBall.Parent then
                dist = (hrp.Position - activeClashBall.Position).Magnitude
            end
            
            if dist > 25 or not activeClashBall or not activeClashBall.Parent then
                if activeClashBall then parryLocked[activeClashBall] = false end 
                shared.ManualSpamActive = false
                shared.LastSpamTime = 0 
                activeClashBall = nil
                clashPartner = ""
            else
                if not (shared.LastSpamTime and (now - shared.LastSpamTime < 0.15)) then
                    if activeClashBall then parryLocked[activeClashBall] = false end 
                    shared.ManualSpamActive = false 
                    shared.LastSpamTime = 0
                    activeClashBall = nil
                    clashPartner = ""
                end
            end
        end
    end
end)

-- auto jump (Fixed Floor & Solid Ground Detection)
task.spawn(function()
    while true do
        task.wait(0.05) -- ปรับเป็นตรวจจับความถี่สูง เพื่อเช็คจังหวะเท้าแตะพื้นได้ทันท่วงที
        if Config.AutoJumpEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if hum and hum.Health > 0 then
                    -- 1. เช็คว่าวัสดุใต้เท้าต้องไม่ใช่ "Air" (ต้องมีวัตถุรองรับ)
                    local onSolidGround = hum.FloorMaterial ~= Enum.Material.Air
                    
                    -- 2. เช็คสถานะทางฟิสิกส์ว่าอยู่ในโหมด ยืนนิ่ง, วิ่ง หรือกำลังแลนดิ้งถึงพื้นแล้ว
                    local state = hum:GetState()
                    local isReadyState = (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.None)
                    
                    -- ทำการกระโดดทันทีเมื่อเงื่อนไขครบถ้วน (เท้าแตะพื้นแข็งจริง ไม่ใช่ลอยอยู่กลางอากาศ)
                    if onSolidGround and isReadyState then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.2) -- คูลดาวน์สั้น ๆ หลังกระโดด เพื่อป้องกันการส่งคำสั่งซ้ำซ้อนในเฟรมเดียวกัน
                    end
                end
            end)
        else
            task.wait(0.4)
        end
    end
end)

-- ═══ ANTI-AFK SYSTEM (JUMP & DROP -Y EVERY 5 MINS) ═══
local afkTimer = 0
task.spawn(function()
    while true do
        task.wait(1)
        if Config.AntiAfk then
            afkTimer = afkTimer + 1
            if afkTimer >= 300 then -- 300 วินาที = 5 นาที
                afkTimer = 0 -- รีเซ็ตเวลาเพื่อเริ่มนับใหม่
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if hum and hrp then
                        -- 1. สั่งกระโดด
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.15) -- รอจังหวะตัวลอยนิดนึง
                        
                        -- 2. ดึงแกน Y ลงมาทันที (ป้องกันเดินค้าง)
                        hrp.CFrame = hrp.CFrame - Vector3.new(0, 5, 0)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, -50, 0) 
                    end
                end)
            end
        else
            afkTimer = 0 -- ถ้าปิดสวิตช์ ให้รีเซ็ตเวลา
        end
    end
end)

-- ═══ PLAYER ESP SYSTEM ═══
local ESP_Folder = Instance.new("Folder", workspace)
ESP_Folder.Name = "PlayerESP_Storage"

local function removeESP(player)
    if ESP_Folder:FindFirstChild(player.Name) then
        ESP_Folder[player.Name]:Destroy()
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function applyHighlight(character)
        if not character then return end
        removeESP(player)

        -- สร้าง Highlight (กรอบเรืองแสงทะลุกำแพง)
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = ESP_Folder

        -- สร้าง BillboardGui (แสดงชื่อและหลอดเลือดบนหัว)
        local head = character:WaitForChild("Head", 5)
        if head then
            local bb = Instance.new("BillboardGui")
            bb.Name = "ESP_Name"
            bb.Adornee = head
            bb.Size = UDim2.new(0, 100, 0, 40)
            bb.StudsOffset = Vector3.new(0, 2, 0)
            bb.AlwaysOnTop = true

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.DisplayName or player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 13
            nameLabel.Parent = bb

            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                local hpLabel = Instance.new("TextLabel")
                hpLabel.Size = UDim2.new(1, 0, 0.5, 0)
                hpLabel.Position = UDim2.new(0, 0, 0.5, 0)
                hpLabel.BackgroundTransparency = 1
                hpLabel.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
                hpLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                hpLabel.TextStrokeTransparency = 0
                hpLabel.Font = Enum.Font.Gotham
                hpLabel.TextSize = 11
                hpLabel.Parent = bb

                -- อัปเดตเลือดตาม Real-time
                hum.HealthChanged:Connect(function(newHp)
                    hpLabel.Text = math.floor(newHp) .. " / " .. math.floor(hum.MaxHealth)
                end)
            end

            bb.Parent = highlight
        end
    end

    if player.Character then
        applyHighlight(player.Character)
    end
    player.CharacterAdded:Connect(applyHighlight)
end

-- ลูปอัปเดตการทำงานเมื่อเปิด/ปิด
task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.PlayerESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if not ESP_Folder:FindFirstChild(player.Name) and player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            ESP_Folder:ClearAllChildren()
        end
    end
end)

task.spawn(function() 
    while shared._InvisRunning do 
        -- ใช้ RenderStepped:Wait() เพื่อให้ทำงานถี่และแม่นยำตามเฟรมเรตเกม 
        game:GetService("RunService").RenderStepped:Wait() 
        
        pcall(function() 
            local ball = Auto_Parry.Get_Ball() 
            if ball and ball.Parent then 
                -- 1. คำนวณความเร็วปัจจุบันของลูกบอลจาก AssemblyLinearVelocity หรือ zoomies 
                local velocity = Vector3.zero 
                local zoomies = ball:FindFirstChild("zoomies") 
                if zoomies then 
                    pcall(function() velocity = zoomies.VectorVelocity end) 
                end 
                if velocity == Vector3.zero and ball:IsA("BasePart") then 
                    velocity = ball.AssemblyLinearVelocity 
                end 
                
                local ballSpeed = velocity.Magnitude 
                
                -- 2. ระบบปรับค่า wowcurve แบบ Dynamic ตามเกณฑ์ความเร็วบอลรุนแรงพิเศษ
                if ballSpeed >= 2500 then
                    Config.wowcurve = 0.82
                elseif ballSpeed >= 1000 then
                    Config.wowcurve = 0.76
                elseif ballSpeed >= 470 then
                    Config.wowcurve = 0.6
                else
                    -- สูตรคำนวณปกติสำหรับบอลความเร็วต่ำกว่า 450 (จำกัดค่าไว้ไม่เกิน 0.54)
                    local calculatedCurve = 0.33 + (ballSpeed * 0.0005)
                    Config.wowcurve = math.clamp(calculatedCurve, 0.33, 0.54)
                end
            end 
        end) 
    end
end)

-- ลบออกอัตโนมัติเมื่อผู้เล่นออกจากเกม
Players.PlayerRemoving:Connect(removeESP)

-- ═══ 🤖 ADVANCED HUMAN EMULATION AUTO PLAY BOT (10-MODE ENGINE) ═══════════════
local currentMode = 1
local modeTimer = 0
local doubleJumpToken = false

task.spawn(function()
    while shared._InvisRunning do
        task.wait(math.random(15, 30) / 100) -- สุ่มดีเลย์ตอบสนองของบอทให้มีความเป็นมนุษย์ (0.15 - 0.3 วินาที)
        
        if Config.AutoPlay then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hum or hum.Health <= 0 or not hrp then return end
                
                local ball = Auto_Parry.Get_Ball()
                local targetPlr = Auto_Parry.GetTargetPlayer()
                
                -- ตรวจสอบว่าใครเป็นเป้าหมายของลูกบอลปัจจุบัน
                local ballTargetStr = ball and tostring(ball:GetAttribute("target") or ball:GetAttribute("Target") or "") or ""
                local isTargetingMe = (ballTargetStr == LocalPlayer.Name or (char and ballTargetStr == char.Name))
                
                -- ระบบสลับโหมดการเล่นอัตโนมัติทุก ๆ 4-8 วินาที เพื่อสร้างรูปแบบเคลื่อนที่แบบไม่ซ้ำซาก
                if tick() - modeTimer > math.random(4, 8) then
                    currentMode = math.random(1, 10)
                    modeTimer = tick()
                end
                
                -- 🛡️ ระบบรักษาระยะห่างเพื่อความปลอดภัย (ถ้าบอลไม่ได้เล็งมาห้ามเข้าใกล้บอลเกินไป)
                local safeDestination = nil
                
                if ball and not isTargetingMe then
                    local ballDist = (hrp.Position - ball.Position).Magnitude
                    -- หากอยู่ใกล้ลูกบอลเกิน 35 สตัดตอนที่ไม่ได้โดนเล็ง ให้บังคับเดินฉีกถอยห่างออกมาทันที
                    if ballDist < 35 then
                        local escapeDirection = (hrp.Position - ball.Position).Unit
                        safeDestination = hrp.Position + (escapeDirection * math.random(20, 35))
                    end
                end
                
                -- หากเข้าสู่สูตรการรักษาระยะห่างให้เดินไปจุดปลอดภัยก่อน ไม่งั้นให้เข้าสู่ระบบสุ่ม 10 โหมดด้านล่าง
                if safeDestination then
                    hum:MoveTo(safeDestination + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
                else
                    -- 🎯 ระบบจำลองการเล่นอัจฉริยะสุ่ม 10 โหมดพฤติกรรมมนุษย์
                    if currentMode == 1 then
                        -- โหมดที่ 1: วิ่งอ้อมเป็นวงกลมรอบแผนที่ (Circle Strafe) เพื่อหลบวิถีตรง
                        local center = targetPlr and targetPlr.PrimaryPart and targetPlr.PrimaryPart.Position or Vector3.new(0,0,0)
                        local offset = (hrp.Position - center).Unit * math.random(25, 45)
                        local rotatedOffset = Vector3.new(-offset.Z, 0, offset.X) -- เลี้ยวฉาก 90 องศาเพื่อวิ่งวน
                        hum:MoveTo(center + rotatedOffset)
                        
                    elseif currentMode == 2 then
                        -- โหมดที่ 2: วิ่งสไลด์เข้าหาขอบแผนที่ชั่วคราว (Wall Hugger) ลดมุมอับ
                        hum:MoveTo(hrp.Position + Vector3.new(math.random(-40, 40), 0, math.random(-40, 40)))
                        
                    elseif currentMode == 3 then
                        -- โหมดที่ 3: เดินสลับฟันปลาซ้าย-ขวาอย่างรวดเร็ว (Zig-Zag Movement) สับขาหลอกศัตรู
                        local forward = targetPlr and targetPlr.PrimaryPart and (targetPlr.PrimaryPart.Position - hrp.Position).Unit or Vector3.new(0,0,1)
                        local side = Vector3.new(-forward.Z, 0, forward.X)
                        local sideStep = (tick() % 1 > 0.5) and 1 or -1
                        hum:MoveTo(hrp.Position + (forward * 10) + (side * (sideStep * 20)))
                        
                    elseif currentMode == 4 then
                        -- โหมดที่ 4: ยืนนิ่ง ๆ คุมเชิงคอยจังหวะสวนกลับ (Passive Baiting)
                        hum:MoveTo(hrp.Position)
                        
                    elseif currentMode == 5 then
                        -- โหมดที่ 5: เดินตามผู้เล่นคนอื่นที่อยู่ใกล้ที่สุดแต่อยู่ข้างหลังเขาเอาไว้บังกระสุน (Meatshield Mode)
                        if targetPlr and targetPlr.PrimaryPart then
                            hum:MoveTo(targetPlr.PrimaryPart.Position + Vector3.new(math.random(15, 25), 0, math.random(15, 25)))
                        end
                        
                    elseif currentMode == 6 then
                        -- โหมดที่ 6: วิ่งถอยหลังสลับกระโดดมองความเคลื่อนไหว (Backward Jumper)
                        if ball then
                            local awayDir = (hrp.Position - ball.Position).Unit
                            hum:MoveTo(hrp.Position + (awayDir * 25))
                            if hum.FloorMaterial ~= Enum.Material.Air and math.random(1, 3) == 1 then
                                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                        
                    elseif currentMode == 7 then
                        -- โหมดที่ 7: วิ่งกดดันเข้าหาพิกัดผู้เล่นเป้าหมายตรง ๆ (Aggressive Rush) ตอนบอลวิ่งเร็ว
                        if targetPlr and targetPlr.PrimaryPart then
                            hum:MoveTo(targetPlr.PrimaryPart.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
                        end
                        
                    elseif currentMode == 8 then
                        -- โหมดที่ 8: วิ่งพุ่งมั่วไร้ทิศทางระยะสั้นสลับหยุด (Twitchy Movement) บอทสแกนตรวจจับทิศทางยาก
                        hum:MoveTo(hrp.Position + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
                        
                    elseif currentMode == 9 then
                        -- โค๊ตที่ 9: เดินยึกยัก เดินหน้าถอยหลังสั้นๆ คุมโซนกลางแมพ (Mid-Zone Control)
                        hum:MoveTo(Vector3.new(0, hrp.Position.Y, 0) + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20)))
                        
                    elseif currentMode == 10 then
                        -- โหมดที่ 10: วิ่งหลบไปซ่อนหลังเสาหรือสิ่งปลูกสร้างหากมีพิกัดวัตถุในระบบ
                        hum:MoveTo(hrp.Position + (hrp.CFrame.RightVector * math.random(-30, 30)))
                    end
                end
                
                -- 🦘 🔊 [ระบบจัดการกระโดดสองจังหวะดักฟิสิกส์ลอยตัว - DOUBLE JUMP ENGINE]
                if isTargetingMe and ball then
                    local ballDist = (hrp.Position - ball.Position).Magnitude
                    -- ถ้าโดนเล็งอยู่ และบอลเข้ามาใกล้ในระยะกระโดดหลบ (ประมาณ 25-50 สตัด)
                    if ballDist <= math.clamp(ball.AssemblyLinearVelocity.Magnitude * 0.4, 25, 65) then
                        -- จังหวะที่ 1: กระโดดขึ้นจากพื้นปกติ
                        if hum.FloorMaterial ~= Enum.Material.Air and not doubleJumpToken then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            doubleJumpToken = true
                            task.wait(0.18) -- ดีเลย์หน่วงจังหวะลอยตัวของมนุษย์ก่อนกดเบิ้ล
                        end
                        
                        -- จังหวะที่ 2: สั่งเบิ้ล Double Jump กลางอากาศเพื่อดึงระยะหลบวิถีโค้ง
                        if doubleJumpToken and hum:GetState() == Enum.HumanoidStateType.FreeFall then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            doubleJumpToken = false -- รีเซ็ตคีย์หลังใช้งานเสร็จสิ้น
                            task.wait(0.3)
                        end
                    end
                else
                    -- ปลดล็อก Token เสมอเมื่อเท้าแตะพื้นแข็งเรียบร้อยแล้ว
                    if hum.FloorMaterial ~= Enum.Material.Air then
                        doubleJumpToken = false
                    end
                end
                
            end)
        end
    end
end)

-- ═══ SPECIAL SKILL DETECTIONS (TORNADO & SPECIAL BALLS) ═══
task.spawn(function()
    while shared._InvisRunning do
        task.wait(0.1)
        if Config.SpecialSkillDetections then
            pcall(function()
                local ball = Auto_Parry.Get_Ball()
                if ball then
                    -- ตรวจจับ Tornado / Singularities Effect
                    if ball:FindFirstChild("TornadoEffect") or ball:FindFirstChild("Vortex") then
                        parryCooldown = 0.8 -- เร่งความเร็วปุ่มป้องกันอัตโนมัติ
                    else
                        parryCooldown = 0.035
                    end
                end
            end)
        end
    end
end)

-- =======================================================================
-- 💀 GODMODE DESYNC ENGINE (ERYNDOR PERFECT COMPATIBLE VERSION)
-- =======================================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local DesyncState = {} -- ตารางสำหรับเก็บค่า [1] CFrame และ [2] Velocity
local Angle, h1, h2, Radius = 250, -8, 32, 10

-- 📦 สร้าง Part ล่องหนปัก Anchor (Camera Proxy)
local CamAnchor = workspace:FindFirstChild("Invis_CamAnchor") or Instance.new("Part")
if not CamAnchor.Parent then
    CamAnchor.Size = Vector3.new(1, 1, 1)
    CamAnchor.Transparency = 1 
    CamAnchor.CanCollide = false 
    CamAnchor.Anchored = true
    CamAnchor.Name = "Invis_CamAnchor"
    CamAnchor.Parent = workspace
end

if shared.InvisGodModeBind then shared.InvisGodModeBind:Disconnect() end

shared.InvisGodModeBind = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not Config.GodMode or not hrp or not hum or hum.Health <= 0 then 
        if Cam.CameraSubject == CamAnchor then 
            Cam.CameraSubject = hum 
        end
        return 
    end
    
    -- บังคับพิกัดกล้องให้เกาะติดร่าง Client
    CamAnchor.CFrame = CamAnchor.CFrame:Lerp(CFrame.new(hrp.Position), 0.5)
    if Cam.CameraSubject ~= CamAnchor then 
        Cam.CameraSubject = CamAnchor 
    end

    -- 🌟 แก้ไขจุดที่ผิดพลาด: แยกเก็บลง Array ป้องกันการเขียนทับกันเอง
    DesyncState[1] = hrp.CFrame
    DesyncState[2] = hrp.AssemblyLinearVelocity
    
    local curTime = tick()
    local calcAngle = curTime * math.pi * 2 * Angle / 5
    local calcY = (math.floor(curTime * 29) % 2 == 0) and h1 or h2
    local offset = Vector3.new(math.cos(calcAngle) * Radius, calcY, math.sin(calcAngle) * Radius)
    
    pcall(function() setfflag("S2PhysicsSenderRate", "1333335") end)
    
    -- วาร์ปร่างหลอกเซิร์ฟเวอร์
    hrp.CFrame = DesyncState[1] + offset
    hrp.AssemblyLinearVelocity = Vector3.new(math.sin(calcAngle) * 50, 0, math.cos(calcAngle) * 50)
    
    RunService.RenderStepped:Wait()
    
    -- ดึงร่างกลับมาตำแหน่ง Client จริงโดยดึงค่าจาก Array อย่างถูกต้อง
    if hrp and hrp.Parent then
        hrp.CFrame = DesyncState[1]
        hrp.AssemblyLinearVelocity = DesyncState[2]
    end
end)

-- ═══ LOW GRAPHICS & ULTRA FPS BOOST FUNCTION (DYNAMIC LOOP) ═══
local lowGraphicsConn = nil

local function applyLowGraphics(enable)
    Config.LowGraphicsEnabled = enable
    
    -- ถ้าปิดการใช้งาน ให้ยกเลิกลูปการดักจับวัตถุใหม่
    if not enable then
        if lowGraphicsConn then
            lowGraphicsConn:Disconnect()
            lowGraphicsConn = nil
        end
        return
    end
    
    -- ฟังก์ชันย่อยสำหรับปรับแต่งวัตถุแต่ละชิ้น
    local function optimizeObject(obj)
        pcall(function()
            if obj:IsA("BasePart") then
                obj.CastShadow = false -- ปิดเงาวัตถุ
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") then
                obj.Enabled = false -- ปิดเอฟเฟกต์ฟุ่มเฟือย
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy() -- ลบเท็กซ์เจอร์ลดการกินแรม
            end
        end)
    end
    
    pcall(function()
        -- 1. ปรับลดการประมวลผลแสงและสภาพแวดล้อม (Lighting) รอบแรก
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") then
                effect.Enabled = false
            end
        end
        
        -- 2. เคลียร์วัตถุที่มีอยู่เดิมทั้งหมดใน Workspace
        for _, obj in ipairs(workspace:GetDescendants()) do
            optimizeObject(obj)
        end
        
        -- 3. ปิดการประมวลผลน้ำและซ่อนน้ำใน Terrain แบบ 100%
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end
    end)
    
    -- 4. ระบบลูปอัตโนมัติ (คอยจัดการวัตถุใหม่ๆ ที่ถูกสร้างขึ้นมาระหว่างเล่นทันที)
    if not lowGraphicsConn then
        lowGraphicsConn = workspace.DescendantAdded:Connect(function(obj)
            if Config.LowGraphicsEnabled then
                optimizeObject(obj)
            end
        end)
    end
end

local function executeWarp(target)
    if target and target.PrimaryPart and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        LocalPlayer.Character.PrimaryPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 0, 4)
    end
end

local function executeTween(target)
    if target and target.PrimaryPart and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local hrp = LocalPlayer.Character.PrimaryPart
        local dist = (target.PrimaryPart.Position - hrp.Position).Magnitude
        local duration = dist / 130 
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 0, 4)})
        tween:Play()
    end
end


local function PlayCustomAnimation(id)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Animator and id ~= "" then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(id)
            local track = hum.Animator:LoadAnimation(anim)
            track:Play()
            CustomNotify("Playing Anim ID: " .. id, 2.5)
            pcall(function() anim:Destroy() end) -- ✅ ย้ายเข้ามาไว้ตรงนี้
        else
            CustomNotify("Invalid Anim ID or missing Humanoid!", 2.5)
        end
    end)
end
-- ===============================================================================
-- 🖼️ SAFE SCREEN GUI SETUP (COMPLETELY FIXED & ANTI-CRASH VERSION)
-- ===============================================================================
local UI_Target_Parent = nil

-- ใช้ pcall ล้อมรอบทุกการดึงค่า Environment เพื่อป้องกันการระเบิดของ Thread
pcall(function()
    if gethui and type(gethui) == "function" then
        UI_Target_Parent = gethui()
    end
end)

pcall(function()
    if not UI_Target_Parent and get_hidden_ui and type(get_hidden_ui) == "function" then
        UI_Target_Parent = get_hidden_ui()
    end
end)

pcall(function()
    if not UI_Target_Parent then
        local coreGui = game:GetService("CoreGui")
        -- ดึงพิกัดแบบรัดกุมที่สุด ตรวจเช็คว่า CoreGui ต้องไม่ใช่ค่าว่างก่อนเคาะหาลูก
        if coreGui and coreGui:FindFirstChild("RobloxGui") then
            UI_Target_Parent = coreGui
        end
    end
end)

-- แผนสำรองสุดท้าย: หากตัวรัน Delta ตัดขาดสิทธิ์ทั้งหมด ให้โยนเข้า PlayerGui เผื่อเซฟฟังก์ชันใช้งาน
if not UI_Target_Parent then
    local lp = game:GetService("Players").LocalPlayer
    UI_Target_Parent = lp and lp:WaitForChild("PlayerGui", 10)
end

-- สั่งเริ่มสร้าง Instance ScreenGui เมื่อตรวจสอบแล้วว่าโฟลเดอร์ปลายทางพร้อมใช้งาน
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InvisHub_Horizontal_" .. math.random(100, 999)
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ป้องกันจุดตาย FindFirstChild บนวัตถุ Nil โดยเพิ่มระบบตรวจสอบเงื่อนไขความพร้อม
if UI_Target_Parent then
    ScreenGui.Parent = UI_Target_Parent
    shared._InvisHubStealthGui = ScreenGui
else
    -- กรณีฉุกเฉินระดับสูงสุดเพื่อหลีกเลี่ยงข้อผิดพลาดใน Developer Console
    warn("[Invis Core UI Error]: All parental pipelines are severely restricted.")
end

-- ═══ CUSTOM STACK-SAFE NOTIFICATION GUI QUEUE ═══
local NotificationHolder = Instance.new("Frame", ScreenGui)
NotificationHolder.Size = UDim2.new(0, 240, 0, 450)
NotificationHolder.Position = UDim2.new(1, -255, 0, 30)
NotificationHolder.BackgroundTransparency = 1
local notifyList = Instance.new("UIListLayout", NotificationHolder)
notifyList.Padding = UDim.new(0, 6)
notifyList.SortOrder = Enum.SortOrder.LayoutOrder

local function CustomNotify(text, duration)
    duration = duration or 3.5
    local card = Instance.new("Frame", NotificationHolder)
    card.Size = UDim2.new(1, 0, 0, 38)
    card.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(255, 60, 60)
    stroke.Thickness = 1.2
    
    local txt = Instance.new("TextLabel", card)
    txt.Size = UDim2.new(1, -12, 1, 0)
    txt.Position = UDim2.new(0, 8, 0, 0)
    txt.Text = "🔔 " .. text
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 11
    txt.BackgroundTransparency = 1
    txt.TextXAlignment = Enum.TextXAlignment.Left

    card.BackgroundTransparency = 1
    txt.TextTransparency = 1
    stroke.Transparency = 1
    
    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(txt, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()

    task.delay(duration, function()
        local t1 = TweenService:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        local t2 = TweenService:Create(txt, TweenInfo.new(0.25), {TextTransparency = 1})
        local t3 = TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 1})
        t1:Play() t2:Play() t3:Play()
        t1.Completed:Connect(function() card:Destroy() end)
    end)
end

-- ═══ LOOK AT BALL SYSTEM (TASK.SPAWN) ═══
task.spawn(function()
    while shared._InvisRunning do
        -- ใช้ RenderStepped:Wait() เพื่อให้อัปเดตมุมกล้องและตัวละครตามเฟรมเรตเกม (นุ่มนวล ไม่กระตุก)
        RunService.RenderStepped:Wait()
        
        pcall(function()
            local ball = Auto_Parry.Get_Ball()
            if ball then
                -- 1. Look at Ball (Character)
                if Config.LookAtBallChar then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local targetPos = Vector3.new(ball.Position.X, hrp.Position.Y, ball.Position.Z)
                        hrp.CFrame = CFrame.lookAt(hrp.Position, targetPos)
                    end
                end

                -- 2. Look at Ball (Camera)
                if Config.LookAtBallCam then
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, ball.Position)
                    end
                end
            end
        end)
    end
end)

-- ═══ PLAYER ABILITY ESP TRACKER MODULE (MODERN REDESIGN) ═══
local function createBillboardGui(p)
    if p == LocalPlayer then return end
    task.spawn(function()
        local character = p.Character or p.CharacterAdded:Wait()
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild("AbilityESP_Gui") then head.AbilityESP_Gui:Destroy() end
        
        -- สร้าง BillboardGui หลัก
        local bg = Instance.new("BillboardGui", head)
        bg.Name = "AbilityESP_Gui"
        bg.Adornee = head
        bg.Size = UDim2.new(0, 220, 0, 50)
        bg.StudsOffset = Vector3.new(0, 3.2, 0)
        bg.AlwaysOnTop = true
        
        -- กรอบพื้นหลังแบบโปร่งใสแต่งขอบเรืองแสงเบาๆ
        local frame = Instance.new("Frame", bg)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        frame.BackgroundTransparency = 0.4
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(255, 75, 75)
        stroke.Transparency = 0.3
        stroke.Thickness = 1.5

        -- ข้อความแสดงชื่อ (บรรทัดบน)
        local nameLabel = Instance.new("TextLabel", frame)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0.05, 0)
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 12
        nameLabel.TextStrokeTransparency = 0.4
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.BackgroundTransparency = 1
        
        -- ข้อความแสดงสกิล (บรรทัดล่าง พร้อมไอคอน)
        local abilityLabel = Instance.new("TextLabel", frame)
        abilityLabel.Size = UDim2.new(1, 0, 0.5, 0)
        abilityLabel.Position = UDim2.new(0, 0, 0.45, 0)
        abilityLabel.TextColor3 = Color3.fromRGB(100, 220, 255)
        abilityLabel.TextSize = 11
        abilityLabel.TextStrokeTransparency = 0.4
        abilityLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        abilityLabel.Font = Enum.Font.GothamSemibold
        abilityLabel.BackgroundTransparency = 1
        
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not character or not character.Parent or not bg or not bg.Parent then 
                if conn then conn:Disconnect() end 
                return 
            end
            
            if Config.AbilityESP then
                bg.Enabled = true
                local currentAbil = p:GetAttribute("EquippedAbility") or p:GetAttribute("Ability") or "None"
                nameLabel.Text = p.DisplayName
                abilityLabel.Text = "⚡ ABILITY: " .. string.upper(tostring(currentAbil))
            else
                bg.Enabled = false
            end
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do 
    p.CharacterAdded:Connect(function() createBillboardGui(p) end) 
    if p.Character then createBillboardGui(p) end 
end
Players.PlayerAdded:Connect(function(p) 
    p.CharacterAdded:Connect(function() createBillboardGui(p) end) 
end)
-- ═══ ULTIMATE UNIFIED FLY ENGINE (MOVE + CAMERA LOOK + LOCK) ════════
if shared._FlyBind then
    shared._FlyBind:Disconnect()
    shared._FlyBind = nil
end

shared._FlyBind = RunService.Heartbeat:Connect(function(dt)
    -- รองรับทั้ง Config.FlyMode หรือ Confiชg.FlyEnabled
    if not shared._InvisRunning or (not Config.FlyMode and not Config.FlyEnabled) then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        
        if hrp and hum and cam then
            -- 1. ล็อกแรงโน้มถ่วงและฟิสิกส์เดิมไม่ให้ดึงตกลงพื้น
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            local moveDir = Vector3.new(0, 0, 0)
            
            -- 2. รองรับการเคลื่อนที่ทั้งจอยสติ๊กมือถือ และ คีย์บอร์ด PC (WASD)
            if hum.MoveDirection.Magnitude > 0 then
                moveDir = hum.MoveDirection
            else
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            end
            
            -- ควบคุมการขึ้น-ลง (Spacebar / ปุ่มกระโดด ขึ้นข้างบน, LeftShift ลงข้างล่าง)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            -- 3. คำนวณตำแหน่งใหม่ตามความเร็วที่ตั้งไว้
            local currentPos = hrp.Position
            if moveDir.Magnitude > 0 then
                currentPos = currentPos + (moveDir.Unit * ((Config.FlySpeed or 50) * dt))
            end
            
            -- 4. บังคับอัปเดตตำแหน่ง พร้อมหันหน้าตามทิศทางกล้องแนวราบในลูปเดียว (ไม่ตีกัน ลื่นไหล 100%)
            local lookVector = cam.CFrame.LookVector
            hrp.CFrame = CFrame.new(currentPos, currentPos + Vector3.new(lookVector.X, lookVector.Y, lookVector.Z))
        end
    end)
end)

-- ═══ STABLE HUMANOID ENFORCER (ULTIMATE OPTIMIZED CONTROLLER) ═══
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hum or hum.Health <= 0 then return end
        
        -- ควบคุม WalkSpeed แบบเงียบและรวดเร็ว (เปลี่ยนเฉพาะตอนค่าไม่ตรง)
        if Config.CustomSpeed and hum.WalkSpeed ~= Config.CustomSpeed then
            hum.WalkSpeed = Config.CustomSpeed
        end
        
        -- ควบคุม JumpPower ให้เสถียรและบังคับเปิด UseJumpPower
        if Config.CustomJump then
            if not hum.UseJumpPower then
                hum.UseJumpPower = true
            end
            if hum.JumpPower ~= Config.CustomJump then
                hum.JumpPower = Config.CustomJump
            end
        end
    end)
end)

-- ═══ TELEPORT & TWEEN ENGINE UTILITIES ═══
local function targetDistanceSolver(mode)
    local alive = workspace:FindFirstChild("Alive")
    if not alive or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return nil end
    local myPos = LocalPlayer.Character.PrimaryPart.Position
    local chosen, pivotDist = nil, (mode == "Nearest" and math.huge or -1)
    for _, p in pairs(alive:GetChildren()) do
        if p ~= LocalPlayer.Character and p:IsA("Model") and p.PrimaryPart then
            local d = (p.PrimaryPart.Position - myPos).Magnitude
            if mode == "Nearest" then if d < pivotDist then pivotDist = d; chosen = p end
            else if d > pivotDist then pivotDist = d; chosen = p end end
        end
    end
    return chosen
end
local function executeWarp(target)
    if target and target.PrimaryPart and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        LocalPlayer.Character.PrimaryPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 0, 4)
        CustomNotify("Warped to: " .. target.Name, 2.5)
    else
        CustomNotify("Target player not found!", 2.5)
    end
end
local function executeTween(target)
    if target and target.PrimaryPart and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local hrp = LocalPlayer.Character.PrimaryPart
        local dist = (target.PrimaryPart.Position - hrp.Position).Magnitude
        local duration = dist / 130 
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = target.PrimaryPart.CFrame * CFrame.new(0, 0, 4)})
        tween:Play()
        CustomNotify("Tweening to: " .. target.Name, 2.5)
    else
        CustomNotify("Target player not found!", 2.5)
    end
end
-- ═══ SERVER CONTROLLER UTILITIES (ULTIMATE OPTIMIZED) ═════════════════
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function RejoinServer()
    CustomNotify("Rejoining current server...", 3)
    task.wait(0.5)
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    if not success then
        CustomNotify("Rejoin failed: " .. tostring(err), 4)
    end
end

local function ServerHop()
    CustomNotify("Searching for an optimal public server...", 4)
    
    local success, err = pcall(function()
        local validServers = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        
        local req = HttpService:JSONDecode(game:HttpGet(url))
        if req and req.data then
            for _, server in ipairs(req.data) do
                -- คัดเลือกเซิร์ฟเวอร์ที่ไม่ใช่ห้องเดิม, ยังไม่เต็ม, และมีผู้เล่นอย่างน้อย 1 คน (ป้องกันห้องร้าง)
                if server.id ~= game.JobId and server.playing < server.maxPlayers and server.playing > 0 then
                    table.insert(validServers, server.id)
                end
            end
        end
        
        if #validServers > 0 then
            -- สุ่มเลือกเซิร์ฟเวอร์จากรายชื่อที่กรองได้ เพื่อความปลอดภัยและกระจายตัว
            math.randomseed(os.time())
            local targetServerId = validServers[math.random(1, #validServers)]
            
            CustomNotify("Connecting to new server...", 3)
            task.wait(0.5)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, LocalPlayer)
        else
            -- Fallback: ถ้าหาห้องที่มีคนไม่ได้ ให้ลองเข้าห้องว่างห้องไหนก็ได้ที่มีที่ว่าง
            if req and req.data then
                for _, server in ipairs(req.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        return
                    end
                end
            end
            CustomNotify("Server hop failed: All servers are full or unavailable.", 4)
        end
    end)
    
    if not success then
        CustomNotify("Server hop error occurred.", 4)
    end
end

local function PlayCustomAnimation(id)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Animator and id ~= "" then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(id)
            local track = hum.Animator:LoadAnimation(anim)
            track:Play()
            CustomNotify("Playing Anim ID: " .. id, 2.5)
        else
            CustomNotify("Invalid Anim ID or missing Humanoid!", 2.5)
        end
     pcall(function() anim:Destroy() end)
    end)
end
-- ═══ GUI SETUP LAYOUTS ═══

-- 🎨 THEME COLORS & PALETTE
local THEME = {
    Background = Color3.fromRGB(12, 12, 16),
    Sidebar    = Color3.fromRGB(16, 16, 22),
    CardBg     = Color3.fromRGB(22, 22, 30),
    CardHover  = Color3.fromRGB(28, 28, 38),
    InputBg    = Color3.fromRGB(18, 18, 24),
    Accent     = Color3.fromRGB(255, 60, 90),
    AccentGlow = Color3.fromRGB(255, 90, 120),
    TextMain   = Color3.fromRGB(240, 240, 245),
    TextDark   = Color3.fromRGB(140, 140, 160),
    Active     = Color3.fromRGB(50, 220, 130),
    Inactive   = Color3.fromRGB(255, 70, 90)
}

-- ตัวแปรควบคุมสถานะเปิด-ปิดหน้าต่าง (ย้ายขึ้นมาไว้ด้านบนสุดเพื่อให้ระบบเรียกใช้งานได้ถูกต้อง)
local guiOpenState = true 
local isTweening = false
local fadeTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- 🔘 TOGGLE MAIN HUB BUTTON
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 90, 0, 38)
ToggleBtn.Position = UDim2.new(0.03, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = THEME.Sidebar
ToggleBtn.Text = "INVIS📌"
ToggleBtn.TextColor3 = THEME.Accent
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.AutoButtonColor = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = THEME.Accent
tStroke.Thickness = 1.5

-- 📌 ระบบลากปุ่ม Toggle แบบแยกแยะคลิกกับการลาก (Fixed Dragging & Click Logic)
local tDrag, tStart, tPos, dragStartMousePos
local dragThreshold = 5
local isDragging = false

ToggleBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        tDrag = true
        tStart = i.Position
        dragStartMousePos = UserInputService:GetMouseLocation()
        tPos = ToggleBtn.Position
        isDragging = false -- รีเซ็ตค่าทุกครั้งที่เริ่มกดสแตนด์บาย
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if tDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local currentMousePos = UserInputService:GetMouseLocation()
        local moveDistance = (currentMousePos - dragStartMousePos).Magnitude
        
        -- ตรวจสอบระยะห่างการลาก ถ้าเกิน Threshold ให้ถือว่าเป็นการ "ลากนิ้ว/ลากเมาส์" ไม่ใช่การคลิก
        if moveDistance > dragThreshold then
            isDragging = true
        end
        
        if isDragging then
            local d = i.Position - tStart
            local cam = workspace.CurrentCamera
            local targetX = tPos.X.Offset + d.X
            local targetY = tPos.Y.Offset + d.Y
            
            -- 🔒 ล็อกไม่ให้ปุ่มหลุดหายทะลุขอบหน้าจอ
            if cam then
                targetX = math.clamp(targetX, 0, cam.ViewportSize.X - ToggleBtn.Size.X.Offset)
                targetY = math.clamp(targetY, 0, cam.ViewportSize.Y - ToggleBtn.Size.Y.Offset)
            end
            
            ToggleBtn.Position = UDim2.new(tPos.X.Scale, targetX, tPos.Y.Scale, targetY)
        end
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        tDrag = false
        -- หน่วงเวลาเล็กน้อยก่อนล้างค่าสถานะการลาก เพื่อไม่ให้ตรรกะการคลิกทำงานทับซ้อนตอนปล่อยเมาส์
        task.defer(function()
            isDragging = false
        end)
    end
end)


-- 🖼️ MAIN FRAME WINDOW
local MainFrame = Instance.new("CanvasGroup", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 350)
MainFrame.Position = UDim2.new(0.3, 0, 0.22, 0)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.Visible = true
MainFrame.GroupTransparency = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
task.spawn(function()
    while shared._InvisRunning do
        MainStroke.Color = Color3.fromHSV((tick() % 4) / 4, 0.8, 1)
        task.wait()
    end
end)

-- Window Toggle Logic
local guiOpenState, isTweening = true, false
local fadeTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Window Dragging Logic
local mDrag, mStart, mPos
MainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mDrag = true; mStart = i.Position; mPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if mDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - mStart
        MainFrame.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + d.X, mPos.Y.Scale, mPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mDrag = false
    end
end)

-- 📌 ตรรกะการคลิกปุ่มเพื่อเปิด/ปิด UI (Fixed Visibility Click Handler)
ToggleBtn.MouseButton1Click:Connect(function()
    if isDragging then return end -- หากตรวจพบว่าผู้เล่นกำลังลากปุ่มอยู่ จะไม่สั่งเปิด/ปิดหน้าต่างมั่วซั่ว
    if isTweening then return end
    
    isTweening = true
    guiOpenState = not guiOpenState
    
    if guiOpenState then
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, fadeTweenInfo, {GroupTransparency = 0})
        tween:Play()
        tween.Completed:Connect(function() 
            isTweening = false 
        end)
    else
        local tween = TweenService:Create(MainFrame, fadeTweenInfo, {GroupTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function()
            if not guiOpenState then 
                MainFrame.Visible = false 
            end
            isTweening = false
        end)
    end
end)

-- 🏷️ TOP TITLE BAR
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 42)
Title.Text = "  ⚡ INVIS HUB (Paid but free)"
Title.TextColor3 = THEME.TextMain
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundColor3 = THEME.Sidebar
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 📌 SIDEBAR NAVIGATION
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = THEME.Sidebar

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0, 6)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local SidePadding = Instance.new("UIPadding", Sidebar)
SidePadding.PaddingTop = UDim.new(0, 8)

-- 📑 CONTENT CONTAINER
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -150, 1, -48)
ContentContainer.Position = UDim2.new(0, 145, 0, 44)
ContentContainer.BackgroundTransparency = 1

-- ═══ 🎨 UI BACKGROUND SYSTEM ═══════════════════════════════

local UIBackgroundImage = Instance.new("ImageLabel", MainFrame)
UIBackgroundImage.Name = "UIBackgroundImage"
UIBackgroundImage.Size = UDim2.new(1, 0, 1, 0)
UIBackgroundImage.Position = UDim2.new(0, 0, 0, 0)
UIBackgroundImage.BackgroundTransparency = 1
UIBackgroundImage.Image = ""
UIBackgroundImage.ImageTransparency = 0.15
UIBackgroundImage.ScaleType = Enum.ScaleType.Crop
UIBackgroundImage.ZIndex = 0

-- ทำให้มุมของรูปตาม MainFrame
local bgCorner = Instance.new("UICorner", UIBackgroundImage)
bgCorner.CornerRadius = UDim.new(0, 10)

-- เนื้อหา GUI ให้อยู่เหนือพื้นหลัง
Title.ZIndex = 2
Sidebar.ZIndex = 2
ContentContainer.ZIndex = 2

-- ═══ 🛠️ FIXED TAB FRAMES INITIALIZATION (ANTI-CRASH) ═══
-- ประกาศคลังหน่วยความจำให้ระบบสแกนอ่านค่าเจอแบบ Global/Shared ป้องกันบอร์ดหลุด
if not getgenv().TabFrames then getgenv().TabFrames = {} end
if not getgenv().TabButtons then getgenv().TabButtons = {} end

local TabFrames = getgenv().TabFrames
local TabButtons = getgenv().TabButtons

-- ล้าง Cache โครงสร้างตารางอันเก่าออกเพื่อไม่ให้ซ้อนทับกันตอนรีสคริปต์
table.clear(TabFrames)
table.clear(TabButtons)

local function createTabScroll(tabName)
    -- ตรวจสอบความปลอดภัยพิกัดโครงสร้างหลัก
    if not ContentContainer then 
        warn("[Invis Hub Error]: ContentContainer missing!")
        return Instance.new("ScrollingFrame")
    end

    local scr = Instance.new("ScrollingFrame")
    scr.Name = tostring(tabName) .. "_ScrollFrame"
    scr.Size = UDim2.new(1, 0, 1, 0)
    scr.BackgroundTransparency = 1
    scr.CanvasSize = UDim2.new(0, 0, 0, 0)
    scr.AutomaticCanvasSize = Enum.AutomaticSize.Y 
    scr.ScrollBarThickness = 3 
    scr.ScrollBarImageColor3 = THEME.Accent 
    scr.Visible = false 
    scr.ClipsDescendants = true 
    scr.BorderSizePixel = 0
    scr.Parent = ContentContainer -- ผูกเข้ากับเมนูกลาง

    local UIList = Instance.new("UIListLayout", scr)
    UIList.Padding = UDim.new(0, 6)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local UIPad = Instance.new("UIPadding", scr)
    UIPad.PaddingRight = UDim.new(0, 6)
    UIPad.PaddingLeft = UDim.new(0, 2)
    UIPad.PaddingTop = UDim.new(0, 4)
    UIPad.PaddingBottom = UDim.new(0, 15) -- เพิ่มระยะเผื่อลากลงล่างสุดสำหรับจอมือถือ

    -- ระบบคำนวณสเกลแบบไดนามิก ป้องกันการดึงค่า nil จาก AbsoluteContentSize
    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pcall(function()
            if UIList and UIPad then
                scr.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + UIPad.PaddingTop.Offset + UIPad.PaddingBottom.Offset)
            end
        end)
    end)

    -- บันทึกลงตารางหน่วยความจำ (Hotfix: จุดที่เคยเกิด Error)
    TabFrames[tabName] = scr
    return scr
end

local combatScroll = createTabScroll("Combat")
local visualScroll = createTabScroll("Visuals")
local settingsScroll = createTabScroll("Settings")
local uiScroll = createTabScroll("UI")
local statusScroll = createTabScroll("Status")
local scriptScroll = createTabScroll("Script Hub")
local musicScroll = createTabScroll("Music")
TabFrames["Combat"].Visible = true

local function setupTabButton(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -14, 0, 36)
    btn.BackgroundColor3 = (name == "Combat") and THEME.CardHover or THEME.CardBg
    btn.Text = name
    btn.TextColor3 = (name == "Combat") and THEME.Accent or THEME.TextDark
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 3
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    TabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        for tName, frame in pairs(TabFrames) do
            local isTarget = (tName == name)
            frame.Visible = isTarget
            if TabButtons[tName] then
                TabButtons[tName].BackgroundColor3 = isTarget and THEME.CardHover or THEME.CardBg
                TabButtons[tName].TextColor3 = isTarget and THEME.Accent or THEME.TextDark
            end
        end
    end)
end

setupTabButton("Combat")
setupTabButton("Visuals")
setupTabButton("Settings")
setupTabButton("UI")
setupTabButton("Status")
setupTabButton("Script Hub")
setupTabButton("Music")

-- 🛠️ UI BUILDER UTILITIES (FIXED TEXTBOXES & MODERN UI)
local function createToggle(name, stateKey, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.CardBg
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1

    local update = function()
        local isAct = false
        if stateKey == "SkinChangerEnabled" then
            isAct = getgenv().skinChanger
        else
            isAct = Config[stateKey]
        end

        if isAct then
            btn.Text = "  " .. name .. " : ON"
            btn.TextColor3 = THEME.Active
            btn.BackgroundColor3 = Color3.fromRGB(18, 32, 24)
            stroke.Color = THEME.Active
        else
            btn.Text = "  " .. name .. " : OFF"
            btn.TextColor3 = THEME.Inactive
            btn.BackgroundColor3 = THEME.CardBg
            stroke.Color = Color3.fromRGB(35, 35, 45)
        end
        btn.TextXAlignment = Enum.TextXAlignment.Left
    end

    btn.MouseButton1Click:Connect(function()
        if stateKey == "SkinChangerEnabled" then
            getgenv().skinChanger = not getgenv().skinChanger
            pcall(function() getgenv().updateSword() end)
        else
            Config[stateKey] = not Config[stateKey]
        end
        CustomNotify(name .. " Toggled!", 2)
        update()
    end)
    update()
end

local function createCycle(name, stateKey, list, parent, onChanged)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.CardBg
    btn.TextColor3 = Color3.fromRGB(100, 180, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 60, 90)
    stroke.Thickness = 1

local update = function()
    btn.Text = "  " .. name .. " : [ " .. tostring(Config[stateKey]) .. " ]"
    btn.TextXAlignment = Enum.TextXAlignment.Left

    if stateKey == "UIBackground" then
        local colors = {
            DARK = Color3.fromRGB(12, 12, 16),
            RED = Color3.fromRGB(45, 10, 18),
            BLUE = Color3.fromRGB(10, 20, 45),
            PURPLE = Color3.fromRGB(30, 15, 45),
            GREEN = Color3.fromRGB(10, 40, 25),
            ORANGE = Color3.fromRGB(50, 25, 10)
        }

        local selectedColor = colors[Config[stateKey]]

        if selectedColor then
            MainFrame.BackgroundColor3 = selectedColor
            UIBackgroundImage.Visible = false
        end
    end
end

    btn.MouseButton1Click:Connect(function()
        local idx = table.find(list, Config[stateKey]) or 1

        Config[stateKey] =
            list[idx + 1 > #list and 1 or idx + 1]

        update()

        if onChanged then
            onChanged(Config[stateKey])
        end
    end)

    update()
end

local function createActionBtn(text, color, fn, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Text = text
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(fn)
end

local TweenService = game:GetService("TweenService")

-- 🛠️ DYNAMIC DROPDOWN/SELECT CREATOR WITH LEADING TEXTLABEL
local function createSelect(labelText, defaultOption, optionsList, parent, onSelectionChanged)
    local currentSelected = defaultOption or (optionsList and optionsList[1]) or "None"
    local isDropdownOpen = false

    -- 📦 1. กรอบหลักภายนอก
    local selectContainer = Instance.new("Frame", parent)
    selectContainer.Size = UDim2.new(1, 0, 0, 34)
    selectContainer.BackgroundColor3 = THEME.InputBg
    Instance.new("UICorner", selectContainer).CornerRadius = UDim.new(0, 6)

    local containerStroke = Instance.new("UIStroke", selectContainer)
    containerStroke.Color = Color3.fromRGB(45, 45, 60)
    containerStroke.Thickness = 1

    -- 🏷️ 2. TextLabel ด้านหน้า (ป้ายชื่อหัวข้อ)
    local label = Instance.new("TextLabel", selectContainer)
    label.Size = UDim2.new(0, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Select:"
    label.TextColor3 = THEME.TextMain
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.AutomaticSize = Enum.AutomaticSize.X 

    -- 🔘 3. ปุ่มกดเลือกตัวเลือกด้านหลัง (ตัวแสดงค่าที่กำลังเลือกอยู่)
    local selectButton = Instance.new("TextButton", selectContainer)
    selectButton.BackgroundTransparency = 1
    selectButton.Text = tostring(currentSelected)
    selectButton.TextColor3 = THEME.TextMain
    selectButton.Font = Enum.Font.GothamBold
    selectButton.TextSize = 11
    selectButton.TextXAlignment = Enum.TextXAlignment.Left

    -- 📐 ระบบจัดตำแหน่งและระยะอัตโนมัติ (ต่อท้ายต่อแถวให้พอดี)
    local function updateLayout()
        local labelWidth = label.AbsoluteSize.X
        selectButton.Position = UDim2.new(0, 10 + labelWidth + 6, 0, 0)
        selectButton.Size = UDim2.new(1, -(10 + labelWidth + 6 + 10), 1, 0)
    end
    label:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
    task.spawn(updateLayout)

    -- 📋 4. หน้าต่างลอยแสดงรายการตัวเลือก (Dropdown List)
    local listContainer = Instance.new("Frame")
    listContainer.BackgroundColor3 = THEME.InputBg
    listContainer.BorderSizePixel = 0
    listContainer.ZIndex = 50
    listContainer.Visible = false
    Instance.new("UICorner", listContainer).CornerRadius = UDim.new(0, 6)
    
    local listStroke = Instance.new("UIStroke", listContainer)
    listStroke.Color = Color3.fromRGB(55, 55, 75)
    listStroke.Thickness = 1

    local scrollFrame = Instance.new("ScrollingFrame", listContainer)
    scrollFrame.Size = UDim2.new(1, -4, 1, -4)
    scrollFrame.Position = UDim2.new(0, 2, 0, 2)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 2
    scrollFrame.ScrollBarImageColor3 = THEME.Accent or Color3.fromRGB(255,255,255)
    scrollFrame.ZIndex = 51

    local listLayout = Instance.new("UIListLayout", scrollFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)

    -- เชื่อม Dropdown เข้ากับหน้าจอหลัก (เพื่อไม่ให้โดนกรอบ Scroll พ่อแม่บังมิดตอนเปิด)
    local screenGui = parent:FindFirstAncestorOfClass("ScreenGui")
    if screenGui then listContainer.Parent = screenGui end

    -- ฟังก์ชันสำหรับซิงค์ตำแหน่งหน้าต่าง Dropdown ลอยให้เกาะตามช่องปุ่มกด
    local function updateDropdownPosition()
        if selectButton and selectButton.Parent then
            listContainer.Position = UDim2.fromOffset(selectButton.AbsolutePosition.X, selectButton.AbsolutePosition.Y + selectButton.AbsoluteSize.Y + 4)
            listContainer.Size = UDim2.fromOffset(selectButton.AbsoluteSize.X, math.clamp(listLayout.AbsoluteContentSize.Y + 6, 34, 150))
            scrollFrame.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
        end
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDropdownPosition)

    -- ➕ ฟังก์ชันสร้างปุ่มเมนูตัวเลือกภายใน Dropdown
    local function refreshOptions()
        for _, item in ipairs(scrollFrame:GetChildren()) do
            if item:IsA("TextButton") then item:Destroy() end
        end

        for idx, optionName in ipairs(optionsList or {}) do
            local optBtn = Instance.new("TextButton", scrollFrame)
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = (tostring(optionName) == tostring(currentSelected)) and (THEME.Accent or Color3.fromRGB(0, 150, 255)) or Color3.fromRGB(25, 25, 35)
            optBtn.BackgroundTransparency = (tostring(optionName) == tostring(currentSelected)) and 0.3 or 0
            optBtn.Text = "  " .. tostring(optionName)
            optBtn.TextColor3 = THEME.TextMain
            optBtn.Font = Enum.Font.GothamBold
            optBtn.TextSize = 10
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.ZIndex = 52
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

            optBtn.MouseButton1Click:Connect(function()
                currentSelected = optionName
                selectButton.Text = tostring(optionName)
                isDropdownOpen = false
                listContainer.Visible = false
                containerStroke.Color = Color3.fromRGB(45, 45, 60)
                
                if onSelectionChanged then onSelectionChanged(optionName) end
            end)
        end
    end

    -- ⚡ เปิด/ปิด Dropdown เมื่อกดคลิกที่ปุ่ม
    selectButton.MouseButton1Click:Connect(function()
        isDropdownOpen = not isDropdownOpen
        if isDropdownOpen then
            refreshOptions()
            updateDropdownPosition()
            listContainer.Visible = true
            containerStroke.Color = THEME.Accent or Color3.fromRGB(0, 150, 255)
        else
            listContainer.Visible = false
            containerStroke.Color = Color3.fromRGB(45, 45, 60)
        end
    end)

    -- ดักจับการปิดอัตโนมัติหากผู้เล่นคลิกนอกขอบเขตพื้นที่เมนู Dropdown
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDropdownOpen and listContainer.Visible then
                local mLoc = UserInputService:GetMouseLocation()
                local pPos, pSize = listContainer.AbsolutePosition, listContainer.AbsoluteSize
                local bPos, bSize = selectButton.AbsolutePosition, selectButton.AbsoluteSize
                
                -- ตรวจเช็คว่าไม่ได้กดทั้งตัวปุ่มหลักและกล่องเมนูลอย
                local inList = (mLoc.X >= pPos.X and mLoc.X <= pPos.X + pSize.X and mLoc.Y >= pPos.Y and mLoc.Y <= pPos.Y + pSize.Y)
                local inButton = (mLoc.X >= bPos.X and mLoc.X <= bPos.X + bSize.X and mLoc.Y >= bPos.Y and mLoc.Y <= bPos.Y + bSize.Y)
                
                if not inList and not inButton then
                    isDropdownOpen = false
                    listContainer.Visible = false
                    containerStroke.Color = Color3.fromRGB(45, 45, 60)
                end
            end
        end
    end)

    -- อัปเดตพิกัดตามหน้าต่างหลักตลอดเวลาเพื่อป้องกันตอนเลื่อน Scroll ลากเมนูแล้วหลุดตำแหน่ง
    game:GetService("RunService").RenderStepped:Connect(function()
        if isDropdownOpen and listContainer.Visible then updateDropdownPosition() end
    end)

    -- คืนค่าวัตถุดาต้าควบคุมสำหรับอัปเดตค่าจากภายนอกสคริปต์
    return {
        SetOptions = function(newOptions)
            optionsList = newOptions
            if isDropdownOpen then refreshOptions() end
        end,
        SetValue = function(newValue)
            currentSelected = newValue
            selectButton.Text = tostring(newValue)
            if isDropdownOpen then refreshOptions() end
        end,
        Visible = function(state)
            selectContainer.Visible = state
            if not state then listContainer.Visible = false isDropdownOpen = false end
        end
    }
end


-- 🛠️ FIXED TEXTBOX CREATOR WITH LEADING TEXTLABEL (DYNAMIC SIZING)
local function createTextBox(labelText, defaultText, parent, onFocusLost)
    -- 📦 กรอบหลักภายนอก
    local boxContainer = Instance.new("Frame", parent)
    boxContainer.Size = UDim2.new(1, 0, 0, 34)
    boxContainer.BackgroundColor3 = THEME.InputBg
    Instance.new("UICorner", boxContainer).CornerRadius = UDim.new(0, 6)

    local boxStroke = Instance.new("UIStroke", boxContainer)
    boxStroke.Color = Color3.fromRGB(45, 45, 60)
    boxStroke.Thickness = 1

    -- 🏷️ 1. TextLabel ด้านหน้า (ดึงข้อความจากอาร์กิวเมนต์แรก เช่น "Speed")
    local label = Instance.new("TextLabel", boxContainer)
    label.Size = UDim2.new(0, 0, 1, 0) -- กำหนดความกว้างเริ่มต้นเป็น 0
    label.Position = UDim2.new(0, 10, 0, 0) -- ขยับห่างจากขอบซ้ายกรอบนอก 10 พิกเซล
    label.BackgroundTransparency = 1
    label.Text = labelText or "Input:"
    label.TextColor3 = THEME.TextMain
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    -- ใช้ AutomaticSize ขยายความกว้างตามความยาวตัวอักษรจริง
    label.AutomaticSize = Enum.AutomaticSize.X 

    -- ⌨️ 2. TextBox ช่องกรอกข้อมูลด้านหลัง
    local box = Instance.new("TextBox", boxContainer)
    box.BackgroundTransparency = 1
    box.Text = defaultText or ""
    box.PlaceholderText = "Type here..." -- กำหนดเป็นคำใบ้มาตรฐานแทน
    box.PlaceholderColor3 = THEME.TextDark
    box.TextColor3 = THEME.TextMain
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.ClearTextOnFocus = false
    box.ClipsDescendants = true
    box.TextXAlignment = Enum.TextXAlignment.Left

    -- 📐 ระบบปรับขนาดอัตโนมัติ (ขยับ TextBox ไปต่อหลัง TextLabel เสมอ)
    local function updateLayout()
        -- รอพิกัด AbsoluteSize ของ Label คำนวณเสร็จในเฟรมเรตนั้น
        local labelWidth = label.AbsoluteSize.X
        -- ขยับจุดเริ่มต้นของ TextBox ไปห่างจากท้ายข้อความ Label อีก 6 พิกเซล
        box.Position = UDim2.new(0, 10 + labelWidth + 6, 0, 0)
        -- คำนวณความกว้างที่เหลือให้ช่องกรอกกินพื้นที่เต็มกรอบขวาโดยไม่ล้นจอ
        box.Size = UDim2.new(1, -(10 + labelWidth + 6 + 10), 1, 0)
    end

    -- ดักจับการเปลี่ยนแปลงขนาดตัวอักษรเพื่ออัปเดตตำแหน่ง Layout ให้ยืดหยุ่น
    label:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
    task.spawn(updateLayout) -- บังคับเรียกทำงานครั้งแรกทันทีตอนสร้างวัตถุ

    -- ⚡ สัญญาณตรวจจับการกด/หลุดโฟกัส
    box.Focused:Connect(function() boxStroke.Color = THEME.Accent end)
    box.FocusLost:Connect(function(enterPressed)
        boxStroke.Color = Color3.fromRGB(45, 45, 60)
        if onFocusLost then onFocusLost(box.Text) end
    end)

    return box
end

local function createLabel(text, parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.Text = "—— " .. text .. " ——"
    lbl.TextColor3 = THEME.TextDark
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.BackgroundTransparency = 1
end

-- 🟢 สร้างตัวแปรข้อความ (TextLabels) รอไว้สำหรับอัปเดตข้อมูลสถานะ
createLabel("REAL-TIME MATCH STATUS", statusScroll)

local function createStatusCard(title, defaultText)
    local card = Instance.new("Frame", statusScroll)
    card.Size = UDim2.new(1, 0, 0, 34)
    card.BackgroundColor3 = THEME.CardBg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", card).Color = Color3.fromRGB(45, 45, 60)
    
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. title .. " : " .. defaultText
    lbl.TextColor3 = THEME.TextMain
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local Stat_BallSpeed = createStatusCard("Ball Speed", "0.00")
local Stat_TimeToHit  = createStatusCard("Time To Hit", "0.00s")
local Stat_Target     = createStatusCard("Your Target", "None")
local Stat_Nearest    = createStatusCard("Nearest Player", "None")
local Stat_Farthest   = createStatusCard("Farthest Player", "None")

-- ═══ COMBAT CONTROLS ═══
createToggle("Auto Parry (Paid)", "AutoParry", combatScroll)
createToggle("Soccer Mode", "SoccerMode", combatScroll)
createToggle("immortal (paid)", "GodMode", combatScroll)
createToggle("Smart Auto Ability", "AutoAbility", combatScroll)

createLabel("Pre-Hit Time Input (Time Mode)", combatScroll)
createTextBox("Enter Time (timemode)", tostring(Config.TargetTime), combatScroll, function(val)
    local n = tonumber(val)
    if n then Config.TargetTime = n CustomNotify("Target Time: " .. tostring(n), 2) end
end)

createToggle("Play Parry Animation Track", "SwordAnimationsEnabled", combatScroll)
createToggle("Auto Spam Clash", "AutoSpam", combatScroll)

-- 1. เพิ่มสถานะและ Config สำหรับ Manual Spam (ใส่ไว้ส่วนบนของสคริปต์)
Config.ManualSpamShow = false  -- ใช้สำหรับคุมปุ่มในเฟรมหลัก (โชว์/ซ่อนปุ่มลอย)
Config.ManualSpamActive = false -- ใช้สำหรับคุมปุ่มลอย (เปิด/ปิดระบบสแปมจริง)

-- 2. สร้างปุ่มวงกลมลอยสำหรับควบคุม (Floating Toggle Control)
-- 🔘 สร้างปุ่มวงกลมลอยสำหรับควบคุม (Floating Spam Button)
local FloatingSpamBtn = Instance.new("TextButton", ScreenGui)
FloatingSpamBtn.Size = UDim2.new(0, 55, 0, 55)
FloatingSpamBtn.Position = UDim2.new(0.82, 0, 0.48, 0)
FloatingSpamBtn.BackgroundColor3 = THEME.Sidebar
FloatingSpamBtn.Text = "SPAM\nOFF"
FloatingSpamBtn.TextColor3 = THEME.Inactive
FloatingSpamBtn.Font = Enum.Font.GothamBold
FloatingSpamBtn.TextSize = 10
FloatingSpamBtn.Visible = false -- เริ่มต้นซ่อนไว้ (จะโชว์เมื่อเปิดปุ่มจากเฟรมหลัก)
Instance.new("UICorner", FloatingSpamBtn).CornerRadius = UDim.new(1, 0) -- บังคับเป็นวงกลมสมบูรณ์

local fsStroke = Instance.new("UIStroke", FloatingSpamBtn)
fsStroke.Color = THEME.Inactive
fsStroke.Thickness = 2

-- 📌 ระบบลากปุ่มวงกลมลอย (Drag Logic)
local fsDrag, fsStart, fsPos, fsMouseStart
local fsThreshold = 5
local fsIsDragging = false

FloatingSpamBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        fsDrag = true
        fsStart = i.Position
        fsMouseStart = UserInputService:GetMouseLocation()
        fsPos = FloatingSpamBtn.Position
        fsIsDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if fsDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local currentMouse = UserInputService:GetMouseLocation()
        if (currentMouse - fsMouseStart).Magnitude > fsThreshold then
            fsIsDragging = true
        end
        if fsIsDragging then
            local d = i.Position - fsStart
            local cam = workspace.CurrentCamera
            local targetX = fsPos.X.Offset + d.X
            local targetY = fsPos.Y.Offset + d.Y
            if cam then
                targetX = math.clamp(targetX, 0, cam.ViewportSize.X - FloatingSpamBtn.Size.X.Offset)
                targetY = math.clamp(targetY, 0, cam.ViewportSize.Y - FloatingSpamBtn.Size.Y.Offset)
            end
            FloatingSpamBtn.Position = UDim2.new(fsPos.X.Scale, targetX, fsPos.Y.Scale, targetY)
        end
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        fsDrag = false
    end
end)

-- 🎨 ฟังก์ชันอัปเดตสีและข้อความของปุ่มลอย
local function updateFloatingButtonVisual()
    if Config.ManualSpamActive then
        FloatingSpamBtn.Text = "SPAM\nON"
        FloatingSpamBtn.TextColor3 = THEME.Active
        fsStroke.Color = THEME.Active
        FloatingSpamBtn.BackgroundColor3 = Color3.fromRGB(18, 32, 24) -- เขียวมืด
    else
        FloatingSpamBtn.Text = "SPAM\nOFF"
        FloatingSpamBtn.TextColor3 = THEME.Inactive
        fsStroke.Color = THEME.Inactive
        FloatingSpamBtn.BackgroundColor3 = THEME.Sidebar -- ดำSidebar
    end
end

-- ⚡ คลิกปุ่มลอยเพื่อเปิด/ปิดระบบสแปมอย่างเดียว
FloatingSpamBtn.MouseButton1Click:Connect(function()
    if fsIsDragging then return end -- ป้องกันเด้งตอนลากปุ่ม
    Config.ManualSpamActive = not Config.ManualSpamActive
    updateFloatingButtonVisual()
    CustomNotify("Spam Overdrive: " .. (Config.ManualSpamActive and "ON" or "OFF"), 1.5)
end)

-- =======================================================================
-- 🚀 HIGH-DENSITY BALANCED SPAM OVERDRIVE (MAX-SPEED / ANTI-NETBUG)
-- =======================================================================
task.spawn(function()
    -- ดึงฟังก์ชันอ้างอิงตรงมาเก็บใน Local ตัวแปรภายนอกเพื่อลด Overhead ในการเข้าถึง Table ทุกๆ ไมโครวินาที
    local getBall = Auto_Parry.Get_Ball
    local fireRemote = Auto_Parry.FireParryRemote
    
    -- กำหนดขนาดของ Batch (จำนวนการยิงต่อรอบ) ให้บาลานซ์ระหว่างความเร็วระดับวินาทีต่อเฟรมและขีดจำกัดที่เซิร์ฟเวอร์รับได้
    local packetBatchSize = 16 

    while shared._InvisRunning do
        -- เช็คเงื่อนไขสถานะการเปิดใช้งานสแปม
        if Config.ManualSpamActive and Config.ManualSpamShow then
            
            -- [OPTIMIZATION] ตรวจสอบก่อนว่ามีลูกบอลในเกมจริงหรือไม่ เพื่อไม่ให้ส่งแพ็กเก็ตว่างเปล่าเปลือง Bandwidth เครือข่าย
            local currentBall = getBall()
            if currentBall and type(fireRemote) == "function" then
                
                -- สั่งทำงานผ่านระบบ Asynchronous Coroutine ที่ทำงานได้เสถียรและเบากว่า task.spawn ทั่วไป
                coroutine.wrap(function()
                    -- ส่งแพ็กเก็ตต่อเนื่องกันเป็นกลุ่ม (Unrolled Loop) เพื่อรีดความเร็วสูงสุดในเศษเสี้ยววินาทีนั้น
                    for i = 1, packetBatchSize do
                        pcall(fireRemote, true)
                    end
                end)()
                
            end
            
            -- สั่งพักเธรดด้วยเศษเสี้ยววินาทีที่สั้นที่สุด (หรือข้ามเฟรมระดับไมโครเซกนด)
            task.wait() 
        else
            -- หากไม่ได้เปิดใช้งานสแปม ให้พักลูปไว้ที่ 0.1 วินาที เพื่อประหยัด CPU ของผู้ใช้
            task.wait(0.1)
        end
    end
end)

createToggle("Infinity Spam Floating Button", "ManualSpamShow", combatScroll)

-- ลูปตรวจสอบสถานะจากปุ่มเมนูหลักแบบ Real-time เพื่อสั่ง ซ่อน/แสดง ปุ่มลอย
task.spawn(function()
    local lastShowState = false
    while shared._InvisRunning do
        if Config.ManualSpamShow ~= lastShowState then
            lastShowState = Config.ManualSpamShow
            
            if Config.ManualSpamShow then
                FloatingSpamBtn.Visible = true -- แสดงปุ่มลอย
            else
                FloatingSpamBtn.Visible = false -- ซ่อนปุ่มลอย
                Config.ManualSpamActive = false -- ปิดระบบสแปมทันทีเพื่อความปลอดภัย
                if type(updateFloatingButtonVisual) == "function" then
                    updateFloatingButtonVisual() -- อัปเดตสีปุ่มลอยให้กลับเป็นสีแดง/OFF
                end
            end
        end
        task.wait(0.1) -- เช็คความถี่ทุกๆ 0.1 วินาทีเพื่อประหยัดทรัพยากรเครื่อง
    end
end)

-- ทำการ Hook ทับปุ่มกดเพื่อให้แสดงผลและควบคุมร่วมกับปุ่มวงกลมลอยได้สมบูรณ์
local originalToggleLogic = combatScroll:FindFirstChild("Manual Spam Overdrive_ScrollFrame") or combatScroll:GetChildren()[#combatScroll:GetChildren()]
-- 🌟 แก้ไขโค้ดตรรกะของปุ่มเดิมใน mainframe
if originalToggleLogic and originalToggleLogic:IsA("TextButton") then
    originalToggleLogic.MouseButton1Click:Connect(function()
        -- บังคับปิดระบบสแปมไว้ก่อนตอนกดสวิตช์ในเมนูหลัก ไม่ให้มันเปิดเอง
        Config.ManualSpam = false 
        updateFloatingButtonVisual()
        
        -- ควบคุมแค่การโชว์/ซ่อน ปุ่มวงกลมลอย (Floating Button) ตามค่าเปิดปิด
        FloatingSpamBtn.Visible = Config.ManualSpamEnabled -- (ใช้ตัวแปรเช็คสถานะการเปิดใช้งานเมนู)
    end)
end

createToggle("Auto Play (Bot Movement)", "AutoPlay", combatScroll)
createToggle("Special Skill Detections", "SpecialSkillDetections", combatScroll)
createToggle("Look at Ball (Character)", "LookAtBallChar", combatScroll)
createToggle("Look at Ball (Camera)", "LookAtBallCam", combatScroll)

-- 1. เพิ่มค่าเริ่มต้นของ Parry Curve Mode ลงในตาราง Config (หากยังไม่มี)
Config.ParryCurveMode = "Camera" 

-- 2. สร้างรายการตัวเลือกโหมดวิถีบอลไซด์โค้ง (Options List)
local ParryCurveModes = {
    "Camera",    -- บอลไซด์โค้งเลี้ยวตามหน้ากล้องและมุมเงย
    "Left",      -- บอลหักไซด์เลี้ยวฉีกหนีไปทางซ้ายมือ
    "Right",     -- บอลหักไซด์เลี้ยวฉีกหนีไปทางขวามือ
    "Up",        -- บอลย้อยงัดขึ้นฟ้าข้ามหัวหลบแนวบล็อก
    "Down",      -- บอลปักหัวดิ่งลงพื้นเพื่อเร่งความเร็ว
    "Random",    -- สุ่มพิกัดรอบตัวศัตรูให้เดาทางยาก
    "Straight"   -- พุ่งตรงปกติ ไม่ออฟเซ็ตพิกัด
}

-- 3. เรียกใช้งานฟังก์ชันสร้างปุ่มสลับโหมด พร้อมใส่ Function ประมวลผลด้านท้าย
createCycle("Parry Curve Mode", "ParryCurveMode", ParryCurveModes, combatScroll, function(selectedMode)
    -- บังคับอัปเดตตัวแปรภายในระบบคำนวณ CFrame ให้ตรงกับค่าที่ผู้เล่นกดเลือก
    Config.ParryCurveDirection = selectedMode 
    
    -- ส่งการแจ้งเตือนบอกผู้ใช้แบบ Real-time
    if type(CustomNotify) == "function" then
        CustomNotify("🎯 Curve Direction set to: " .. selectedMode, 2)
    end
end)

-- 🎯 3. ตัวเลือกโปรไฟล์การล็อกเป้าหมายผู้เล่น (Lock Target Profile)
createSelect("Lock Target Profile", Config.TargetMode or "Double click", {
    "Double click", "Normal", "Nearest", "Farest"
}, combatScroll, function(selected)
    Config.TargetMode = selected
    if type(CustomNotify) == "function" then
        CustomNotify("Target Profile: " .. selected, 2)
    end
end)

-- ═══ VISUAL CONTROLS ═══
createToggle("Player Ability ESP Tracker", "AbilityESP", visualScroll)
createToggle("Enable Visual Sword Changer Backend", "SkinChangerEnabled", visualScroll)

createTextBox("Type Sword Model Name", "", visualScroll, function(val)
    getgenv().swordModel = val
    pcall(function() getgenv().updateSword() end)
end)

createTextBox("Type Custom Animations Name", "", visualScroll, function(val)
    getgenv().swordAnimations = val
    pcall(function() getgenv().updateSword() end)
end)

createTextBox("Type Sword Custom FX Name", "", visualScroll, function(val)
    getgenv().swordFX = val
    pcall(function() getgenv().updateSword() end)
end)

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 2. สร้างระบบดักฟังเหตุการณ์การตีลูกบอล (รันไว้รอตั้งแต่แรก แต่จะสร้างเอฟเฟกต์เมื่อ Toggle เปิดอยู่เท่านั้น)
pcall(function()
    ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, ballPart, swordName, playerName)
            
        if tostring(playerName) == game:GetService("Players").LocalPlayer.Name and ballPart then
        if type(shared.InvisClearLock) == "function" then
                shared.InvisClearLock(ballPart)
        end
        if Config.CustomComboFX then
            pcall(function()
                -- สร้างเอฟเฟกต์แสงนีออนวงระเบิดใหม่ขึ้นมา
                local fxPart = Instance.new("Part")
                fxPart.Size = Vector3.new(3, 3, 3)
                fxPart.Shape = Enum.PartType.Ball
                fxPart.Color = Color3.fromRGB(0, 220, 255) -- Custom Cyan Theme
                fxPart.Material = Enum.Material.Neon
                fxPart.Anchored = true
                fxPart.CanCollide = false
                fxPart.Position = ballPart.Position
                fxPart.Parent = workspace
                
                -- เพิ่มประกายไฟสปาร์คด้านในวงระเบิด
                local attachment = Instance.new("Attachment", fxPart)
                local sparkles = Instance.new("Sparkles", attachment)
                sparkles.SparkleColor = Color3.fromRGB(255, 255, 255)
                
                -- เล่นแอนิเมชันขยายวงกว้างและจางหายไปอย่างรวดเร็ว
                TweenService:Create(fxPart, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(18, 18, 18),
                    Transparency = 1
                }):Play()
                
                -- เคลียร์ไอเทมออกจากหน่วยความจำอัตโนมัติใน 0.5 วินาที
                Debris:AddItem(fxPart, 0.5)
            end)
        end
        end
    end)
end)

-- 3. สร้างตัวปุ่ม Toggle บนหน้าจอเมนู
createToggle("Custom Combo Overlap FX", "CustomComboFX", visualScroll)

local LowGraphicBtn = Instance.new("TextButton", visualScroll)
LowGraphicBtn.Size = UDim2.new(1, 0, 0, 34)
LowGraphicBtn.BackgroundColor3 = THEME.CardBg
LowGraphicBtn.Font = Enum.Font.GothamBold
LowGraphicBtn.TextSize = 11
Instance.new("UICorner", LowGraphicBtn).CornerRadius = UDim.new(0, 6)

local lowStroke = Instance.new("UIStroke", LowGraphicBtn)
lowStroke.Thickness = 1

local updateLowGFX = function()
    if Config.LowGraphicsEnabled then
        LowGraphicBtn.Text = "  Low Graphics Mode : ACTIVE"
        LowGraphicBtn.TextColor3 = THEME.Active
        lowStroke.Color = THEME.Active
    else
        LowGraphicBtn.Text = "  Low Graphics Mode : DISABLED"
        LowGraphicBtn.TextColor3 = THEME.Inactive
        lowStroke.Color = Color3.fromRGB(35, 35, 45)
    end
    LowGraphicBtn.TextXAlignment = Enum.TextXAlignment.Left
end

LowGraphicBtn.MouseButton1Click:Connect(function()
    applyLowGraphics(not Config.LowGraphicsEnabled)
    updateLowGFX()
end)
updateLowGFX()

-- ═══ แก้ไข: ปิดฟังก์ชันครอบและยึดวงเล็บปลายทางให้ครบถ้วน ═══
--createActionBtn("🔓 Unlock All (Don't work For now)", Color3.fromRGB(90, 40, 150), function()
--    task.spawn(function()
--        CustomNotify("Loading Unlock All...", 2)
--        pcall(function() 
--            loadstring(game:HttpGet("https://raw.githubusercontent.com/foreverspacexc-blip/OTHERHUB/refs/heads/main/wSuhUFTr.txt"))()
--        end) -- 🔒 ปิด pcall
--    end) -- 🔒 ปิด task.spawn
--end, visualScroll) -- 🔒 ปิด function หลักของ createActionBtn

local isCustomChar = false
local customModelInstance = nil
local syncConnection = nil

createActionBtn("👤 Load Custom Character", Color3.fromRGB(35, 80, 140), function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/foreverspacexc-blip/eced349643cd1c4e6f5622bf6242be3e/raw/SkinChangeV1"))()
    CustomNotify("Skin Change V1 Loaded!", 2.5)
end, visualScroll)

-- =========================================================
-- 💀 HEADLESS
-- =========================================================
local isHeadless = false

local function ApplyHeadless(char)
    if not char then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    pcall(function()
        head.Transparency = isHeadless and 1 or 0

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                child.Transparency = isHeadless and 1 or 0
            end
        end
    end)
end

createActionBtn("💀 Toggle Headless", Color3.fromRGB(70, 35, 90), function()
    isHeadless = not isHeadless

    local char = LocalPlayer.Character
    ApplyHeadless(char)

    CustomNotify(
        isHeadless and "💀 Headless: ENABLED"
        or "👤 Headless: DISABLED",
        2.5
    )
end, visualScroll)


-- =========================================================
-- 🦴 KORBLOX
-- =========================================================
local isKorblox = false

local function ApplyKorblox(char)
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    pcall(function()

        -- R15
        if char:FindFirstChild("RightLowerLeg")
            and char:FindFirstChild("RightFoot") then

            local rLowerLeg = char:FindFirstChild("RightLowerLeg")
            local rFoot = char:FindFirstChild("RightFoot")

            rLowerLeg.Transparency = isKorblox and 1 or 0
            rFoot.Transparency = isKorblox and 1 or 0

        -- R6
        elseif char:FindFirstChild("Right Leg") then
            local rLeg = char:FindFirstChild("Right Leg")
            rLeg.Transparency = isKorblox and 1 or 0
        end
    end)
    -- พยายามใช้ HumanoidDescription
    if isKorblox then
        pcall(function()
            local desc = hum:GetAppliedDescription()
            desc.RightLeg = 139607718
            hum:ApplyDescription(desc)
        end)
    end
end

createActionBtn("🦴 Toggle Korblox Leg", Color3.fromRGB(25, 70, 120), function()
    isKorblox = not isKorblox
    local char = LocalPlayer.Character
    ApplyKorblox(char)
    CustomNotify(
        isKorblox and "🦴 Korblox Leg: ENABLED"
        or "🦵 Korblox Leg: DISABLED",
        2.5
    )
end, visualScroll)

-- =========================================================
-- 🔄 REAPPLY หลังเกิดใหม่
-- =========================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    -- รอ Character โหลด
    task.wait(0.5)
    -- รอ Head / Humanoid
    local hum = char:WaitForChild("Humanoid", 5)
    local head = char:WaitForChild("Head", 5)
    if not hum then
        return
    end
    task.wait(0.3)
    -- 💀 คืนค่า Headless
    if isHeadless then
        ApplyHeadless(char)
    end
    -- 🦴 คืนค่า Korblox
    if isKorblox then
        ApplyKorblox(char)
    end
end)

createToggle("Player ESP", "PlayerESP", visualScroll)

-- ═══ SYSTEM SETTINGS ═══
createTextBox("Speed", tostring(Config.CustomSpeed or ""), settingsScroll, function(val)
    local n = tonumber(val)
    Config.CustomSpeed = n
    CustomNotify("WalkSpeed Enforced: " .. tostring(n or "Default"), 2)
end)

createToggle("Enable Fly", "FlyEnabled", settingsScroll)
createTextBox("Fly Speed", tostring(Config.FlySpeed or 50), settingsScroll, function(val)
    local n = tonumber(val)
    if n then Config.FlySpeed = n CustomNotify("Fly Speed: " .. tostring(n), 2) end
end)

createTextBox("JumpPower", tostring(Config.CustomJump or ""), settingsScroll, function(val)
    local n = tonumber(val)
    Config.CustomJump = n
    CustomNotify("JumpPower Enforced: " .. tostring(n or "Default"), 2)
end)

createToggle("Auto Jump Loop", "AutoJumpEnabled", settingsScroll)
createToggle("Anti-AFK (Jump & Drop 5 Mins)", "AntiAfk", settingsScroll)

createTextBox("Enter Roblox Animation ID", "", settingsScroll, function(val)
    Config.CustomAnimID = val
end)

createActionBtn("🎭 Execute Custom Anim Track", Color3.fromRGB(55, 25, 85), function()
    PlayCustomAnimation(Config.CustomAnimID)
end, settingsScroll)

createActionBtn("Load Stellar Hub ✅", Color3.fromRGB(200, 160, 0), function()
    loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/f7388eab91b827b35ecd1785c9261fb8c6249fa5d53780948ab1ffac8ab9c91b/download"))()
    CustomNotify("Stellar Hub Loaded!", 2.5)
end, scriptScroll)

createActionBtn("Load Eryndor Hub ✅", Color3.fromRGB(200, 160, 0), function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/meow920/ed1e1f4a19b220b44f30e77a3c628a23/raw/5d946a50cf69e8c480f4186f6ad283361baef946/BBEryndor"))()
    CustomNotify("Stellar Hub Loaded!", 2.5)
end, scriptScroll)

createActionBtn("💥 Warp to Nearest Player", Color3.fromRGB(70, 25, 25), function() executeWarp(targetDistanceSolver("Nearest")) end, settingsScroll)
createActionBtn("💥 Warp to Farthest Player", Color3.fromRGB(90, 30, 30), function() executeWarp(targetDistanceSolver("Farest")) end, settingsScroll)
createActionBtn("🚀 Tween to Nearest Player", Color3.fromRGB(25, 50, 75), function() executeTween(targetDistanceSolver("Nearest")) end, settingsScroll)
createActionBtn("🚀 Tween to Farthest Player", Color3.fromRGB(30, 60, 95), function() executeTween(targetDistanceSolver("Farest")) end, settingsScroll)

createActionBtn("🔄 Rejoin Server Instance", Color3.fromRGB(35, 85, 35), function() RejoinServer() end, settingsScroll)
createActionBtn("🌌 Server Hop Network Search", Color3.fromRGB(95, 70, 25), function() ServerHop() end, settingsScroll)

createCycle("UI Background Theme", "UIBackground", BackgroundColors, uiScroll)

-- ═══ IMAGE BACKGROUND ══════════════════════════════════════

createLabel("IMAGE BACKGROUND", uiScroll)

createTextBox(
    "Image ID",
    "",
    uiScroll,
    function(text)
        local id = tostring(text):match("%d+")

        if id then
            UIBackgroundImage.Image = "rbxassetid://" .. id
            UIBackgroundImage.Visible = true

            CustomNotify("🖼️ Background Image Updated!", 2)
        else
            UIBackgroundImage.Image = ""
            UIBackgroundImage.Visible = false

            CustomNotify("❌ Image ID", 2)
        end
    end
)

createTextBox(
    "Image Transparency 0 - 1",
    "0.15",
    uiScroll,
    function(text)
        local value = tonumber(text)

        if value then
            UIBackgroundImage.ImageTransparency = math.clamp(value, 0, 1)
        end
    end
)

createActionBtn(
    "🖼️ Hide Background Image",
    THEME.CardBg,
    function()
        UIBackgroundImage.Visible = false
    end,
    uiScroll
)

createActionBtn(
    "🔄 Reset Background",
    THEME.CardBg,
    function()
        BackgroundIndex = 1

        UIBackgroundImage.Visible = false
        UIBackgroundImage.Image = ""
        UIBackgroundImage.ImageTransparency = 0.15

        updateBackgroundCycle()

        CustomNotify("🔄 Background Reset!", 2)
    end,
    uiScroll
)

-- 🟢 🔁 ลูปอัปเดตค่าสถานะ Real-time ทุกเฟรมเรตหน้าจอ
task.spawn(function()
    while shared._InvisRunning do
        RunService.RenderStepped:Wait()
        pcall(function()
            if not TabFrames["Status"].Visible then return end -- ประหยัดทรัพยากร: ถ้าไม่ได้เปิดหน้าแท็บนี้อยู่ จะไม่คำนวณ
            
            local ball = Auto_Parry.Get_Ball()
            local character = LocalPlayer.Character
            local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
            
            -- 1. อัปเดต Ball Speed และ Time To Hit
            if ball and ball.Parent and hrp then
                local velocity = Vector3.zero
                local zoomies = ball:FindFirstChild("zoomies")
                if zoomies then pcall(function() velocity = zoomies.VectorVelocity end) end
                if velocity == Vector3.zero and ball:IsA("BasePart") then velocity = ball.AssemblyLinearVelocity end
                
                local speed = velocity.Magnitude
                local dist = (hrp.Position - ball.Position).Magnitude
                local reachTime = dist / math.max(speed, 1)
                
                Stat_BallSpeed.Text = string.format("  ⚡ Ball Speed : %.2f", speed)
                Stat_TimeToHit.Text  = string.format("  ⏳ Time To Hit : %.3fs", reachTime)
            else
                Stat_BallSpeed.Text = "  ⚡ Ball Speed : 0.00 (No Ball)"
                Stat_TimeToHit.Text  = "  ⏳ Time To Hit : 0.000s"
            end
            
            -- 2. อัปเดต Target ล็อกเป้าหมายปัจจุบัน
            if shared.Clicked_Target_Name then
                Stat_Target.Text = "  🎯 Your Target : " .. tostring(shared.Clicked_Target_Name) .. " (Locked)"
            else
                local curTarget = Auto_Parry.GetTargetPlayer()
                Stat_Target.Text = "  🎯 Your Target : " .. (curTarget and curTarget.Name or "None") .. " (Auto)"
            end
            
            -- 3. อัปเดต Nearest และ Farthest Player
            local nearPlr = targetDistanceSolver("Nearest")
            local farPlr  = targetDistanceSolver("Farest")
            
            Stat_Nearest.Text  = "  🧍 Nearest Player : " .. (nearPlr and nearPlr.Name or "None")
            Stat_Farthest.Text = "  🌌 Farthest Player : " .. (farPlr and farPlr.Name or "None")
        end)
    end
end)

-- =======================================================================
-- 🎵 INDEPENDENT MUSIC HUB SYSTEM v5 (EXECUTOR SUPPORT VERSION)
-- =======================================================================
local RunService = game:GetService("RunService")

-- 📦 1. สเตทและการตั้งค่าระบบหลัก
Config.MusicEnabled = false
Config.MusicLooped = false
Config.AutoPlayNext = false
Config.MaxPlayTime = nil -- ค่าเริ่มต้นเป็น nil คือเล่นจนจบเพลงปกติ (ไม่มีการจำกัดเวลา)
Config.MusicVolume = 0.5

local CurrentSound = nil
local progressConnection = nil
local currentTrackIndex = 1

-- 📋 คลังเพลงเริ่มต้น (ใช้ลิงก์ GitHub ได้เลย)
local CustomPlaylists = {
    {Name = "🎵 Everything Works Out", URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/everything%20works%20out%20in%20the%20end%20slowed%20best%20part%20looped.mp3"},
    {Name = "🎵 Pupsies Misery Lyrics", URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/pupsies%20misery.Lyrics.mp3"},
    {Name = "🎵 Young Girl A Funk",        URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/YOUNG%20GIRL%20A%20FUNK%20ABDUKXRIM%20SLOWED%20REVERB%20BRAZILIAN%20PHONK.mp3"},
    {Name = "🎵 Aura Feel Powerful",       URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/AURA%20%F0%9F%91%91%20Songs%20to%20feel%20Powerful%20Slowed.mp3"},
    {Name = "💥 BRAWL Funk", URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/BRAWL%20SWAG%20FUNK.mp3"},
    {Name = "🌙 Beautiful Moon Funk", URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/BEAUTIFUL%20MOON%20FUNK%20(SLOWED).mp3"},
    {Name = "📌 Alan Walker", URL = "https://github.com/foreverspacexc-blip/INVISRobloxMusic/raw/refs/heads/main/Alan%20Walker%20-%20Top%205%20Best%20Songs%202023.mp3"}
}

local customTimeText = nil
local customProgressText = nil
local currentPlayingLabel = nil

pcall(function()
    currentPlayingLabel = createLabel("Now Playing: None", musicScroll)
    customTimeText = createLabel("00:00 / 00:00", musicScroll)
    customProgressText = createLabel("[□□□□□□□□□□□□□□□□□□□□ 0%]", musicScroll)
end)

-- 🛠️ 3. ระบบล้างไฟล์เสียงเก่า
local function StopCurrentMusic()
    if progressConnection then
        progressConnection:Disconnect()
        progressConnection = nil
    end
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil
    end
end

-- 🛠️ 4. ฟังก์ชันสำหรับโหลดและเล่นเพลงผ่าน Executor
local function PlayMusicByIndex(index)
    StopCurrentMusic()
    
    if not Config.MusicEnabled then return end
    if #CustomPlaylists == 0 then return end
    
    currentTrackIndex = math.clamp(index, 1, #CustomPlaylists)
    local targetTrack = CustomPlaylists[currentTrackIndex]
    
    -- ตั้งชื่อไฟล์ที่จะเซฟลงเครื่อง (ลบอักขระพิเศษออกป้องกัน error)
    local safeFileName = string.gsub(targetTrack.Name, "[^%w%s]", "")
    safeFileName = string.gsub(safeFileName, "%s+", "_") .. ".mp3"
    
    task.spawn(function()
        pcall(function()
            if currentPlayingLabel then
                currentPlayingLabel.Text = "Loading: " .. targetTrack.Name .. "..."
            end
            
            -- [สำคัญ]: ระบบดาวน์โหลดและสร้าง Custom Asset สำหรับตัวรัน
            if not isfile(safeFileName) then
                if customTimeText then customTimeText.Text = "Downloading File..." end
                local soundData = game:HttpGet(targetTrack.URL)
                writefile(safeFileName, soundData)
            end
            
            local assetId = getcustomasset(safeFileName)
            
            if currentPlayingLabel then
                currentPlayingLabel.Text = "Now Playing: " .. targetTrack.Name
            end
            
            CurrentSound = Instance.new("Sound")
            CurrentSound.Name = "InvisHub_BackgroundMusic"
            CurrentSound.SoundId = assetId -- ใส่ ID ที่แปลงมา
            CurrentSound.Volume = Config.MusicVolume
            CurrentSound.Looped = Config.MusicLooped
            CurrentSound.Parent = game:GetService("SoundService")
            
            CurrentSound:Play()
            
progressConnection = RunService.RenderStepped:Connect(function()
    if CurrentSound and CurrentSound.IsPlaying and CurrentSound.TimeLength > 0 then
        local current = CurrentSound.TimePosition
        local total = CurrentSound.TimeLength
        
        -- [ระบบคำนวณข้อความและหลอดความคืบหน้าเดิมของคุณ...]
        local currentStr = string.format("%02d:%02d", math.floor(current / 60), math.floor(current % 60))
        local totalStr = string.format("%02d:%02d", math.floor(total / 60), math.floor(total % 60))
        if customTimeText then customTimeText.Text = currentStr .. " / " .. totalStr end
        
        -- 🌟 [TRIGGER NEW TRACK] เงื่อนไขการสลับเพลงใหม่
        local isTimeLimitExceeded = Config.MaxPlayTime and (current >= Config.MaxPlayTime)
        local isSongEnded = Config.AutoPlayNext and (current >= total - 0.1)

        if isSongEnded or isTimeLimitExceeded then
            StopCurrentMusic()
            
            -- แจ้งเตือนเมื่อโดนตัดจบเพราะหมดเวลาที่ตั้งไว้ใน TextBox
            if isTimeLimitExceeded and type(CustomNotify) == "function" then
                CustomNotify("⏱️ Time limit reached! Switching track...", 2.5)
            end
            
            -- สั่งรันเพลงถัดไปในเพลย์ลิสต์
            if currentTrackIndex < #CustomPlaylists then
                PlayMusicByIndex(currentTrackIndex + 1)
            else
                PlayMusicByIndex(1)
            end
        end
    end
end)
        end)
    end)
end

-- =======================================================================
-- 🔘 5. คอนโทรลเลอร์และปุ่ม
-- =======================================================================
createToggle("Enable Music System", "MusicEnabled", musicScroll)
createToggle("Loop Single Track", "MusicLooped", musicScroll)
createToggle("Auto Play Next Track", "AutoPlayNext", musicScroll)

createActionBtn("< Previous Track", Color3.fromRGB(45, 45, 65), function()
    if Config.MusicEnabled then
        if currentTrackIndex > 1 then
            PlayMusicByIndex(currentTrackIndex - 1)
        else
            PlayMusicByIndex(#CustomPlaylists)
        end
    else
        CustomNotify("❌ Please enable Music System first!", 3)
    end
end, musicScroll)

createActionBtn("> Next Track", Color3.fromRGB(45, 45, 65), function()
    if Config.MusicEnabled then
        if currentTrackIndex < #CustomPlaylists then
            PlayMusicByIndex(currentTrackIndex + 1)
        else
            PlayMusicByIndex(1)
        end
    else
        CustomNotify("❌ Please enable Music System first!", 3)
    end
end, musicScroll)

-- 📥 6. ระบบดาวน์โหลดลิงก์ภายนอกเข้ามาเป็นส่วนหนึ่งของคลังเพลง
createLabel("DOWNLOAD & ADD EXTERNAL LINK TO PLAYLIST", musicScroll)

createTextBox("Paste Direct MP3 Link to Download...", "", musicScroll, function(text)
    if text and string.match(text, "http") then
        local trackNumber = #CustomPlaylists + 1
        local newTrack = {
            Name = "🎵 Downloaded Track #" .. tostring(trackNumber),
            URL = text
        }
        
        table.insert(CustomPlaylists, newTrack)
        CustomNotify("📥 Successfully added to Playlist! (#" .. tostring(trackNumber) .. ")", 3)
        
        createActionBtn(newTrack.Name, Color3.fromRGB(24, 38, 28), function()
            if Config.MusicEnabled then
                PlayMusicByIndex(trackNumber)
            else
                CustomNotify("❌ Please enable Music System first!", 3)
            end
        end, musicScroll)
    else
        CustomNotify("❌ Invalid URL! Please provide a valid direct link.", 3)
    end
end)

createLabel("TRACK TIMING LIMITER", musicScroll)

createTextBox("Max Playtime (Seconds)", "", musicScroll, function(val)
    local n = tonumber(val)
    if n and n > 0 then
        Config.MaxPlayTime = n
        CustomNotify("⏱️ Max Playtime set to: " .. tostring(n) .. "s", 2.5)
    else
        Config.MaxPlayTime = nil
        CustomNotify("🔄 Reset Playtime: Play until song ends", 2.5)
    end
end)

-- 📋 7. ส่วนสร้างปุ่มเริ่มต้นของเพลงทั้งหมดในคลัง
createLabel("CURRENT PLAYLIST STORE", musicScroll)
for i, track in ipairs(CustomPlaylists) do
    createActionBtn(track.Name, Color3.fromRGB(32, 28, 44), function()
        if Config.MusicEnabled then
            PlayMusicByIndex(i)
        else
            CustomNotify("❌ Please enable Music System first!", 3)
        end
    end, musicScroll)
end

-- ═══ โค้ดส่วนลูปท้ายสคริปต์ที่ได้รับการแก้ไขจุดตกหล่น ═══
task.spawn(function()
    while true do
        task.wait(0.2)
        if CurrentSound then 
            CurrentSound.Looped = Config.MusicLooped 
        end
        -- ✨ แก้ไขบรรทัด 3849: เพิ่มคำว่า then เข้าไปให้สมบูรณ์
        if not Config.MusicEnabled and CurrentSound then 
            StopCurrentMusic() 
            if currentPlayingLabel then 
                currentPlayingLabel.Text = "Now Playing: None" 
            end
        end
    end
end) -- 🔒 ปิดครอบฟังก์ชันลูปย่อยตัวสุดท้ายสำเร็จ
--[[
-- ==========================================
-- 1. ตัวแปรสำหรับเก็บค่าสแกนแบบ Dynamic
-- ==========================================
local Found_Parry_Remote = nil
local Current_Token1 = ""
local Current_Key2 = ""
local Current_Secret3 = ""

-- ==========================================
-- 2. ฟังก์ชันสแกนหาโฟลเดอร์เครือข่ายของเกม (สแกนข้ามทุกเซิร์ฟเวอร์)
-- ==========================================
local function ScanForParryRemote()
    local indexFolder = game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5)
    if indexFolder then
        indexFolder = indexFolder:WaitForChild("_Index", 5)
    end
    
    if indexFolder then
        -- เดินลูปหาโฟลเดอร์ของ sleitnick_net ที่สุ่มชื่อย้ายตำแหน่ง
        for _, folder in ipairs(indexFolder:GetChildren()) do
            if string.find(folder.Name, "sleitnick_net") then
                local netFolder = folder:FindFirstChild("net")
                if netFolder then
                    -- ค้นหา RemoteEvent ที่มีชื่อแฮชสุ่มยาวๆ ด้านใน
                    for _, remote in ipairs(netFolder:GetChildren()) do
                        if remote:IsA("RemoteEvent") and string.len(remote.Name) > 30 then
                            Found_Parry_Remote = remote
                            warn("[Invis Hub Scan] Found Remote: " .. remote.Name)
                            break
                        end
                    end
                end
            end
            if Found_Parry_Remote then break end
        end
    end
end

-- รันระบบสแกนหาเป้าหมายทันทีที่เข้าเซิร์ฟเวอร์
ScanForParryRemote()

-- ==========================================
-- 3. ระบบ Hook ดักฟังข้อมูลที่เปลี่ยนทุกๆ 10 วินาที
-- ==========================================
if Found_Parry_Remote then
    local oldFireServer
    oldFireServer = hookmetamethod(game, "__index", function(self, key)
        -- ดักจับว่ามีการใช้งาน FireServer บน Remote ที่เราสแกนเจอหรือไม่
        if self == Found_Parry_Remote and key == "FireServer" then
            return function(remote, ...)
                local args = {...}
                -- ตรวจสอบโครงสร้างแพ็คเก็ตตามที่ Cobalt ดึงมา
                if #args >= 3 and type(args[1]) == "string" and string.len(args[1]) == 36 then
                    -- บันทึกค่าที่สุ่มใหม่ทุกๆ 10 วินาทีลงหน่วยความจำทันทีที่มีการขยับหรือคลิกตี
                    Current_Token1 = args[1]
                    Current_Key2 = args[2]
                    Current_Secret3 = args[3]
                end
                return oldFireServer(remote, unpack(args))
            end
        end
        return oldFireServer(self, key)
    end)
else
    warn("[Invis Hub Scan] ❌ Cannot find sleitnick_net folder!")
end
]]
