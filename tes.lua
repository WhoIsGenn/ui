
-- ==================== LOAD VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

local isFirstLoad = true

-- ==================== CREATE MAIN WINDOW ====================
local Window = Vict:Window({
    Title        = "Victoria | Bladeball",
    Footer       = " ",
    Color        = Color3.fromRGB(0, 170, 255),
    ["Tab Width"] = 120,
    Version      = "2.0.0",
    Icon         = "rbxassetid://79482005659181",
    Image        = "79482005659181"
})

-- ==================== SERVICES ====================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Alive   = workspace:FindFirstChild("Alive") or workspace:WaitForChild("Alive")
local Runtime = workspace.Runtime

-- ==================== GLOBALS ====================
getgenv().HitboxEnabled        = false
getgenv().HitboxSize           = 0
getgenv().HighSpeedProtection  = false
getgenv().CooldownProtection   = false
getgenv().AutoAbility          = false
getgenv().skinChangerEnabled   = false
getgenv().swordAnimations      = nil

getgenv().DynamicHitbox = {
    Enabled      = false,
    Part         = nil,
    MinSize      = 5,
    MaxSize      = 40,
    Color        = Color3.fromRGB(255, 255, 255),
    Transparency = 0.7
}

-- ==================== STATE ====================
local revertedRemotes   = {}
local TriggerbotParried = false
local Closest_Entity    = nil
local manualSpamThread  = nil

-- ==================== SYSTEM TABLE ====================
local System = {
    __properties = {
        __autoparry_enabled           = false,
        __curve_mode                  = 1,
        __accuracy                    = 1,
        __divisor_multiplier          = 1.1,
        __parried                     = false,
        __training_parried            = false,
        __parries                     = 0,
        __first_parry_done            = false,
        __connections                 = {},
        __tornado_time                = tick(),
        __infinity_active             = false,
        __deathslash_active           = false,
        __timehole_active             = false,
        __is_mobile                   = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
        __antidot_parried             = false,
        __triggerbot_active           = false,
        __triggerbot_working          = false,
        __manual_spam_enabled         = false,
        __auto_spam_enabled           = false,
        __spam_target                 = nil,
        __spam_target_time            = 0,
        __spam_threshold              = 0,
        __auto_spam_distance_multiplier = 1.0,
        __last_antidot_check          = 0,
    },
    __config = {
        __curve_names = {'Camera', 'Random', 'Accelerated', 'Backwards', 'Slow', 'High'},
        __detections  = {
            __infinity   = false,
            __deathslash = false,
            __timehole   = false,
        }
    }
}

-- ==================== DUAL BYPASS SYSTEM ====================
local DualBypassSystem = {
    __properties = {
        __captured_data          = nil,
        __first_parry_done       = false,
        __test_bypass_enabled    = true,
        __use_virtual_input_once = true,
        __virtual_input_used     = false,
        __original_metatables    = {},
        __active_hooks           = {}
    }
}

function DualBypassSystem.isValidRemoteArgs(args)
    return #args == 7
        and type(args[2]) == "string"
        and type(args[3]) == "number"
        and typeof(args[4]) == "CFrame"
        and type(args[5]) == "table"
        and type(args[6]) == "table"
        and type(args[7]) == "boolean"
end

function DualBypassSystem.hookRemote(remote)
    if DualBypassSystem.__properties.__original_metatables[remote] then return end
    DualBypassSystem.__properties.__original_metatables[remote] = true
    local meta = getrawmetatable(remote)
    setreadonly(meta, false)
    local oldIndex = meta.__index
    meta.__index = function(self, key)
        if (key == "FireServer" and self:IsA("RemoteEvent")) or
           (key == "InvokeServer" and self:IsA("RemoteFunction")) then
            return function(obj, ...)
                local args = {...}
                if DualBypassSystem.isValidRemoteArgs(args) and not DualBypassSystem.__properties.__captured_data then
                    DualBypassSystem.__properties.__captured_data = { remote = obj, args = args }
                end
                if DualBypassSystem.isValidRemoteArgs(args) and not revertedRemotes[obj] then
                    revertedRemotes[obj] = args
                end
                return oldIndex(self, key)(obj, unpack(args))
            end
        end
        return oldIndex(self, key)
    end
    setreadonly(meta, true)
end

for _, remote in pairs(ReplicatedStorage:GetChildren()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        DualBypassSystem.hookRemote(remote)
    end
end
ReplicatedStorage.ChildAdded:Connect(function(child)
    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
        DualBypassSystem.hookRemote(child)
    end
end)

-- ==================== HELPERS ====================
local function update_divisor()
    System.__properties.__divisor_multiplier = 0.59 + (System.__properties.__accuracy - 1) * (3 / 99)
end

local function linear_predict(a, b, t) return a + (b - a) * t end

local function update_randomized_accuracy()
    local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(ping_str:match("%d+")) or 0
    local new_accuracy
    if ping >= 90 then
        new_accuracy = 4
    elseif ping <= 50 then
        new_accuracy = math.random(70, 100)
    else
        new_accuracy = System.__properties.__accuracy
    end
    if new_accuracy then
        System.__properties.__accuracy = new_accuracy
        update_divisor()
    end
end

-- Randomized accuracy loop (sama persis dengan original)
task.spawn(function()
    while task.wait(1) do
        update_randomized_accuracy()
    end
end)

local function UpdateDynamicHitbox(ball_distance, parry_range)
    local cfg = getgenv().DynamicHitbox
    if not cfg or not cfg.Enabled then
        if cfg and cfg.Part then cfg.Part:Destroy(); cfg.Part = nil end
        return
    end
    if not cfg.Part then
        local p = Instance.new("Part")
        p.Name = "DynamicParryVisual"; p.Shape = Enum.PartType.Ball
        p.CanCollide = false; p.Anchored = true; p.CastShadow = false
        p.Material = Enum.Material.ForceField; p.Parent = workspace
        cfg.Part = p
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local t  = math.clamp((ball_distance - parry_range) / (100 - parry_range), 0, 1)
        local vs = cfg.MinSize + (cfg.MaxSize - cfg.MinSize) * t
        cfg.Part.Size         = cfg.Part.Size:Lerp(Vector3.new(vs, vs, vs), 0.2)
        cfg.Part.CFrame       = char.HumanoidRootPart.CFrame
        cfg.Part.Color        = cfg.Color
        cfg.Part.Transparency = cfg.Transparency
    end
end

-- ==================== SYSTEM.BALL ====================
System.ball = {}
function System.ball.get()
    local b = workspace:FindFirstChild("Balls"); if not b then return nil end
    for _, ball in pairs(b:GetChildren()) do
        if ball:GetAttribute("realBall") then ball.CanCollide = false; return ball end
    end
end
function System.ball.get_all()
    local t = {}; local b = workspace:FindFirstChild("Balls"); if not b then return t end
    for _, ball in pairs(b:GetChildren()) do
        if ball:GetAttribute("realBall") then ball.CanCollide = false; table.insert(t, ball) end
    end
    return t
end

-- ==================== SYSTEM.PLAYER ====================
System.player = {}
local _LastClosestCheck = 0
function System.player.get_closest()
    local now = tick(); if now - _LastClosestCheck < 0.1 then return Closest_Entity end
    _LastClosestCheck = now
    local md = math.huge; local ce = nil
    if not Alive then return nil end
    for _, e in pairs(Alive:GetChildren()) do
        if e ~= LocalPlayer.Character and e.PrimaryPart then
            local d = LocalPlayer:DistanceFromCharacter(e.PrimaryPart.Position)
            if d < md then md = d; ce = e end
        end
    end
    Closest_Entity = ce; return ce
end
function System.player.get_closest_to_cursor()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local closest = nil; local min_dot = -math.huge; local cam = workspace.CurrentCamera
    if not Alive then return nil end
    local ok, ml = pcall(function() return UserInputService:GetMouseLocation() end); if not ok then return nil end
    local ray = cam:ScreenPointToRay(ml.X, ml.Y)
    local ptr = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
    for _, p in pairs(Alive:GetChildren()) do
        if p == LocalPlayer.Character then continue end
        if not p:FindFirstChild("HumanoidRootPart") then continue end
        local dot = ptr.LookVector:Dot((p.HumanoidRootPart.Position - cam.CFrame.Position).Unit)
        if dot > min_dot then min_dot = dot; closest = p end
    end
    return closest
end

-- ==================== SYSTEM.CURVE ====================
System.curve = {}
function System.curve.get_cframe()
    local cam  = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return cam.CFrame end
    local tp; local cl = System.player.get_closest_to_cursor()
    if cl and cl:FindFirstChild("HumanoidRootPart") then tp = cl.HumanoidRootPart end
    local tpos = tp and tp.Position or (root.Position + cam.CFrame.LookVector * 100)
    local funcs = {
        function() return cam.CFrame end,
        function()
            local dir = (tpos - root.Position).Unit; local off; local att = 0
            repeat
                off = Vector3.new(math.random(-4000,4000), math.random(-4000,4000), math.random(-4000,4000)); att += 1
            until dir:Dot((tpos + off - root.Position).Unit) < 0.95 or att > 10
            return CFrame.new(root.Position, tpos + off)
        end,
        function() return CFrame.new(root.Position, tpos + Vector3.new(0, 5, 0)) end,
        function()
            local d = (root.Position - tpos).Unit
            return CFrame.new(cam.CFrame.Position, root.Position + d * 10000 + Vector3.new(0, 1000, 0))
        end,
        function() return CFrame.new(root.Position, tpos + Vector3.new(0, -9e18, 0)) end,
        function() return CFrame.new(root.Position, tpos + Vector3.new(0,  9e18, 0)) end,
    }
    return funcs[System.__properties.__curve_mode]()
end

-- ==================== SYSTEM.PARRY ====================
System.parry = {}

local function buildEventData(camera)
    local ed = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function() return camera:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok then ed[entity.Name] = sp end
            end
        end
    end
    return ed
end

local function getAimTarget(camera, is_mobile)
    if is_mobile then
        local vp = camera.ViewportSize
        return {vp.X / 2, vp.Y / 2}
    end
    local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
    return ok and {mouse.X, mouse.Y} or {0, 0}
end

function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end

    -- First parry: gunakan VirtualInput sekali untuk capture remote
    if not System.__properties.__first_parry_done
       and DualBypassSystem.__properties.__use_virtual_input_once
       and not DualBypassSystem.__properties.__virtual_input_used then
        pcall(function()
            for _, connection in pairs(getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
                connection:Fire()
            end
        end)
        System.__properties.__first_parry_done = true
        DualBypassSystem.__properties.__virtual_input_used = true
        return
    end

    local camera    = workspace.CurrentCamera
    local is_mobile = System.__properties.__is_mobile
    local aim
    if is_mobile then
        local vp = camera.ViewportSize
        aim = {vp.X / 2, vp.Y / 2}
    else
        local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
        aim = ok and {mouse.X, mouse.Y} or {0, 0}
    end

    local curve_cframe = System.curve.get_cframe()
    local event_data   = buildEventData(camera)

    for remote, original_args in pairs(revertedRemotes) do
        local modified_args = {
            original_args[1], original_args[2], original_args[3],
            curve_cframe, event_data, aim, original_args[7]
        }
        pcall(function()
            if remote:IsA('RemoteEvent') then remote:FireServer(unpack(modified_args))
            elseif remote:IsA('RemoteFunction') then remote:InvokeServer(unpack(modified_args)) end
        end)
    end

    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries += 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then System.__properties.__parries -= 1 end
    end)
end

function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera       = workspace.CurrentCamera
    local curve_cframe = System.curve.get_cframe()
    local event_data   = buildEventData(camera)
    local aim          = getAimTarget(camera, System.__properties.__is_mobile)

    for remote, original_args in pairs(revertedRemotes) do
        local modified_args = {
            original_args[1], original_args[2], original_args[3],
            curve_cframe, event_data, aim, original_args[7]
        }
        pcall(function()
            if remote:IsA('RemoteEvent') then remote:FireServer(unpack(modified_args))
            elseif remote:IsA('RemoteFunction') then remote:InvokeServer(unpack(modified_args)) end
        end)
    end

    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries += 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then System.__properties.__parries -= 1 end
    end)
end

function System.parry.execute_action()
    System.parry.execute()
end

-- ==================== SYSTEM.DETECTION ====================
System.detection = {
    __ball_properties = {
        __aerodynamic_time = tick(),
        __last_warping     = tick(),
        __lerp_radians     = 0,
        __curving          = tick()
    }
}

function System.detection.is_curved()
    local props = System.detection.__ball_properties
    local ball  = System.ball.get(); if not ball then return false end
    local zoom  = ball:FindFirstChild("zoomies"); if not zoom then return false end
    local vel   = zoom.VectorVelocity; local spd = vel.Magnitude; if spd < 1 then return false end
    local char  = LocalPlayer.Character; if not char or not char.PrimaryPart then return false end
    local pos   = char.PrimaryPart.Position
    local dot   = (pos - ball.Position).Unit:Dot(vel.Unit)
    local ping  = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local dist  = (pos - ball.Position).Magnitude
    local reach = dist / spd - ping
    local dot_th = math.clamp(0.55 - ping * 0.75, -1, 0.45)
    local bdt   = 15 - math.min(dist / 1000, 15) + math.min(spd / 100, 45)
    local rad   = math.asin(math.clamp(dot, -1, 1))
    props.__lerp_radians = linear_predict(props.__lerp_radians, rad, 0.85)
    if props.__lerp_radians < 0.016 then props.__last_warping = tick() end
    if dist < bdt * 0.85 then return false end
    if (tick() - props.__last_warping) < reach / 1.4 then return true end
    if (tick() - props.__curving)     < reach / 1.1 then return true end
    return dot < dot_th
end

-- ParrySuccessAll handler 1: execute parry lagi kalau curved + dekat (dari original)
ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root and root.Parent and root.Parent ~= LocalPlayer.Character then
        if not Alive or root.Parent.Parent ~= Alive then return end
    end
    local closest = System.player.get_closest()
    local ball    = System.ball.get()
    if not ball or not closest or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
    local target_dist = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Magnitude
    local dist        = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    UpdateDynamicHitbox(dist, 15)
    local direction   = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local vel         = ball.AssemblyLinearVelocity or Vector3.zero
    local dot         = direction:Dot(vel.Unit)
    local curve_detected = System.detection.is_curved()
    if target_dist < 15 and dist < 15 and dot > -0.25 then
        if curve_detected then System.parry.execute_action() end
    end
end)

-- ParrySuccess handler: stop animasi grab
ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if not Alive or not LocalPlayer.Character or LocalPlayer.Character.Parent ~= Alive then return end
end)

-- ParrySuccessAll handler 2: update curving state (untuk curve detection)
ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
    local primary = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
    local ball = System.ball.get(); if not ball or not primary then return end
    local zoom = ball:FindFirstChild("zoomies"); if not zoom then return end
    local spd   = zoom.VectorVelocity.Magnitude
    local dist  = (primary.Position - ball.Position).Magnitude
    local pings = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local bdt   = 15 - math.min(dist / 1000, 15) + math.min(spd / 100, 40)
    if spd > 1 and (dist / spd - pings/1000) > pings/10 then bdt = math.max(bdt - 5, 15) end
    if b ~= primary and dist > bdt then System.detection.__ball_properties.__curving = tick() end
end)

-- TimeHole detection (path remote dari original)
pcall(function()
    local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net
    net["RE/TimeHoleActivate"].OnClientEvent:Connect(function(...)
        local args = {...}
        local player = args[1]
        if player == LocalPlayer or player == LocalPlayer.Name
           or (player and player.Name == LocalPlayer.Name) then
            System.__properties.__timehole_active = true
        end
    end)
    net["RE/TimeHoleDeactivate"].OnClientEvent:Connect(function()
        System.__properties.__timehole_active = false
    end)
end)

-- ==================== HELPER: CHECK COOLDOWN ====================
local function checkCooldownAndAbility(ball_target, distance, parry_accuracy)
    -- CooldownProtection: skip jika parry sedang cooldown
    if getgenv().CooldownProtection then
        local ok, ParryCD = pcall(function()
            return LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
        end)
        if ok and ParryCD and ParryCD.Offset.Y < 0.4 then
            pcall(function() ReplicatedStorage.Remotes.AbilityButtonPress:Fire() end)
            return true -- skip parry, handled by ability
        end
    end

    -- AutoAbility: pakai ability dulu jika siap
    if getgenv().AutoAbility then
        local ok, AbilityCD = pcall(function()
            return LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
        end)
        if ok and AbilityCD and AbilityCD.Offset.Y == 0.5 then
            local abilities = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Abilities")
            if abilities then
                local abilityNames = {
                    "Raging Deflection", "Rapture", "Calming Deflection",
                    "Aerodynamic Slash", "Fracture", "Death Slash"
                }
                for _, name in ipairs(abilityNames) do
                    local ab = abilities:FindFirstChild(name)
                    if ab and ab.Enabled then
                        System.__properties.__parried = true
                        pcall(function() ReplicatedStorage.Remotes.AbilityButtonPress:Fire() end)
                        task.wait(2.432)
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Remotes")
                                :WaitForChild("DeathSlashShootActivation"):FireServer(true)
                        end)
                        return true
                    end
                end
            end
        end
    end

    return false
end

-- ==================== SYSTEM.AUTOPARRY (NO TRIGGERBOT, WITH ANTI-DOT) ====================
System.autoparry = {}

function System.autoparry.get_balls()
    return System.ball.get_all()
end

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end

    System.__properties.__connections.__autoparry = RunService.RenderStepped:Connect(function()
        if not System.__properties.__autoparry_enabled
           or not LocalPlayer.Character
           or not LocalPlayer.Character.PrimaryPart then return end

        local balls    = System.autoparry.get_balls()
        local one_ball = System.ball.get()

        -- Training ball
        local training_ball = nil
        if workspace:FindFirstChild("TrainingBalls") then
            for _, i in pairs(workspace.TrainingBalls:GetChildren()) do
                if i:GetAttribute("realBall") then training_ball = i; break end
            end
        end

        for _, ball in pairs(balls) do
            if not ball then continue end
            local zoom = ball:FindFirstChild('zoomies'); if not zoom then continue end

            ball:GetAttributeChangedSignal('target'):Once(function()
                System.__properties.__parried = false
                System.__properties.__antidot_parried = false
            end)

            if System.__properties.__parried then continue end

            local bt   = ball:GetAttribute('target')
            local vel  = zoom.VectorVelocity
            local dist = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local pth  = math.clamp(ping / 10, 5, 17)
            local spd  = vel.Magnitude; if spd <= 0 then continue end

            local csd = math.min(math.max(spd - 9.5, 0), 650)
            local pa  = pth + math.max(spd / ((2.5 + csd * 0.002) * System.__properties.__divisor_multiplier), 9.5)
            if getgenv().HitboxEnabled then pa = pa + (getgenv().HitboxSize or 0) end

            UpdateDynamicHitbox(dist, pa)

            local dtp = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit:Dot(vel.Unit)

            -- FILTER: Hanya proses bola target kita ATAU bola yang sangat mendekat
            if bt ~= LocalPlayer.Name and dtp < 0.1 then continue end

            -- High speed protection
            if getgenv().HighSpeedProtection then
                if spd > 1500 then
                    local multiplier = 1 + (spd - 1500) / 1000
                    pa = pa * math.clamp(multiplier, 1.5, 3.5)
                end
            else
                if spd > 2000 then pa = pa * 2.0 end
            end

            -- curved detection
            local curved = System.detection.is_curved()

            -- Tornado check
            if ball:FindFirstChild('AeroDynamicSlashVFX') then
                ball.AeroDynamicSlashVFX:Destroy()
                System.__properties.__tornado_time = tick()
            end
            if Runtime:FindFirstChild('Tornado') then
                if (tick() - System.__properties.__tornado_time)
                   < (Runtime.Tornado:GetAttribute('TornadoTime') or 1) + 0.314159 then continue end
            end

            -- Curve check
            if one_ball and one_ball:GetAttribute('target') == LocalPlayer.Name and curved then continue end

            -- Combo / singularity check
            if ball:FindFirstChild('ComboCounter') then continue end
            if LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then continue end

            -- Detection checks
            if System.__config.__detections.__infinity   and System.__properties.__infinity_active   then continue end
            if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
            if System.__config.__detections.__timehole   and System.__properties.__timehole_active   then continue end

            -- ========== ANTI-DOT PROTECTION (TETAP) ==========
            local closest_player = System.player.get_closest()
            if closest_player and not System.__properties.__antidot_parried then
                local player_dist = (LocalPlayer.Character.PrimaryPart.Position - closest_player.PrimaryPart.Position).Magnitude
                if player_dist <= 30 and dtp > 0.75 and bt == LocalPlayer.Name and dist <= 30 then
                    System.parry.execute_action()
                    System.__properties.__parried      = true
                    System.__properties.__antidot_parried = true
                    System.__properties.__last_antidot_check = tick()
                end
            end

            -- ========== MAIN PARRY (HANYA UNTUK BOLA TARGET KITA) ==========
            -- TRIGGERBOT DIHAPUS! Hanya parry jika target kita
            if bt == LocalPlayer.Name and dist <= pa then
                -- Cooldown protection
                if getgenv().CooldownProtection then
                    local ParryCD = LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
                    if ParryCD and ParryCD.Offset.Y < 0.4 then
                        pcall(function() ReplicatedStorage.Remotes.AbilityButtonPress:Fire() end)
                        continue
                    end
                end

                -- Auto ability
                if getgenv().AutoAbility then
                    local AbilityCD = LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                    if AbilityCD and AbilityCD.Offset.Y == 0.5 then
                        local abilities = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Abilities")
                        if abilities then
                            local abilityNames = {
                                "Raging Deflection", "Rapture", "Calming Deflection",
                                "Aerodynamic Slash", "Fracture", "Death Slash"
                            }
                            for _, name in ipairs(abilityNames) do
                                local ab = abilities:FindFirstChild(name)
                                if ab and ab.Enabled then
                                    System.__properties.__parried = true
                                    pcall(function() ReplicatedStorage.Remotes.AbilityButtonPress:Fire() end)
                                    task.wait(2.432)
                                    pcall(function()
                                        ReplicatedStorage:WaitForChild("Remotes")
                                            :WaitForChild("DeathSlashShootActivation"):FireServer(true)
                                    end)
                                    continue
                                end
                            end
                        end
                    end
                end

                -- Eksekusi parry
                System.parry.execute_action()
                System.__properties.__parried = true
            end

            -- ========== WAIT 1 DETIK (ANTI-DOUBLE UNTUK BOLA YANG SAMA) ==========
            local lp = tick()
            repeat 
                RunService.RenderStepped:Wait() 
            until (tick() - lp) >= 1 or not System.__properties.__parried
            System.__properties.__parried      = false
            System.__properties.__antidot_parried = false
        end

        -- Training ball loop
        if training_ball then
            local zoom = training_ball:FindFirstChild('zoomies')
            if zoom then
                training_ball:GetAttributeChangedSignal('target'):Once(function()
                    System.__properties.__training_parried = false
                end)
                if not System.__properties.__training_parried then
                    local bt   = training_ball:GetAttribute('target')
                    local vel  = zoom.VectorVelocity
                    local dist = LocalPlayer:DistanceFromCharacter(training_ball.Position)
                    local spd  = vel.Magnitude
                    local png  = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
                    local pth  = math.clamp(png / 10, 5, 17)
                    local csd  = math.min(math.max(spd - 9.5, 0), 650)
                    local pa   = pth + math.max(spd / ((2.4 + csd * 0.002) * System.__properties.__divisor_multiplier), 9.5)
                    if getgenv().HitboxEnabled then pa = pa + (getgenv().HitboxSize or 0) end
                    if spd > 2000 then pa = pa * 2.0 end
                    UpdateDynamicHitbox(dist, pa)
                    if bt == LocalPlayer.Name and dist <= pa then
                        System.parry.execute_action()
                        System.__properties.__training_parried = true
                        local lp = tick()
                        repeat 
                            RunService.RenderStepped:Wait() 
                        until (tick() - lp) >= 1 or not System.__properties.__training_parried
                        System.__properties.__training_parried = false
                    end
                end
            end
        end
    end)
end

function System.autoparry.stop()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
        System.__properties.__connections.__autoparry = nil
    end
end

-- ==================== SYSTEM.MANUAL_SPAM ====================
System.manual_spam = {}
function System.manual_spam.start()
    System.manual_spam.stop()
    System.__properties.__manual_spam_enabled = true
    local parry_execute  = System.parry.execute
    local threshold = 0.005
    manualSpamThread = coroutine.create(function()
        local last_spam = os.clock()
        while System.__properties.__manual_spam_enabled do
            local now = os.clock()
            if now - last_spam >= threshold then
                last_spam = now
                parry_execute()
            end
            task.wait(0)
        end
    end)
    coroutine.resume(manualSpamThread)
end
function System.manual_spam.stop()
    System.__properties.__manual_spam_enabled = false
    manualSpamThread = nil
end

-- ==================== SYSTEM.AUTO_SPAM ====================
System.auto_spam = {}
function System.auto_spam:get_ball_properties()
    local ball = System.ball.get(); if not ball then return false end
    local char = LocalPlayer.Character; if not char or not char.PrimaryPart then return false end
    local ball_pos = ball.Position; local root_pos = char.PrimaryPart.Position
    local diff = root_pos - ball_pos
    local ball_velocity = ball.AssemblyLinearVelocity or Vector3.zero
    return { Velocity = ball_velocity, Direction = diff.Unit, Distance = diff.Magnitude, Dot = diff.Unit:Dot(ball_velocity.Unit) }
end
function System.auto_spam:get_entity_properties()
    local entity = Closest_Entity; if not entity or not entity.PrimaryPart then return false end
    local char = LocalPlayer.Character; if not char or not char.PrimaryPart then return false end
    local diff = char.PrimaryPart.Position - entity.PrimaryPart.Position
    return { Velocity = entity.PrimaryPart.Velocity, Direction = diff.Unit, Distance = diff.Magnitude }
end
function System.auto_spam.spam_service(self)
    local ball   = System.ball.get(); if not ball then return 0 end
    local entity = System.player.get_closest(); if not entity or not entity.PrimaryPart then return 0 end
    local vel    = ball.AssemblyLinearVelocity or Vector3.zero
    local spd    = vel.Magnitude
    local direction   = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dot         = direction:Dot(vel.Unit)
    local target_dist = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
    local multiplier  = System.__properties.__auto_spam_distance_multiplier or 1.0
    local base_dist   = 30 * multiplier
    local max_spam    = (self.Ping + math.min(spd / 4, 60)) * multiplier
    if self.Entity_Properties.Distance > max_spam and self.Entity_Properties.Distance > base_dist then return 0 end
    if self.Ball_Properties.Distance  > max_spam and self.Ball_Properties.Distance  > base_dist then return 0 end
    if target_dist > max_spam and target_dist > base_dist then return 0 end
    local max_spd = 7 - math.min(spd / 5, 5)
    local max_dot = math.clamp(dot, -1, 1) * max_spd
    return max_spam - max_dot
end
function System.auto_spam.start()
    if System.__properties.__connections.__auto_spam_connection then
        System.__properties.__connections.__auto_spam_connection:Disconnect()
    end
    System.__properties.__auto_spam_enabled = true
    local last_auto_spam    = 0
    local last_target_check = 0
    local get_ball    = System.ball.get
    local get_closest = System.player.get_closest
    local parry_execute  = System.parry.execute
    System.__properties.__connections.__auto_spam_connection = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if not System.__properties.__auto_spam_enabled or not char or not char.Parent then return end
        local now = tick()
        if now - last_auto_spam < 0.004 then return end
        last_auto_spam = now
        local ball = get_ball(); if not ball then return end
        local zoom = ball:FindFirstChild('zoomies'); if not zoom then return end
        if now - last_target_check > 0.1 then
            get_closest(); last_target_check = now
            if System.__properties.__spam_target then
                local target = System.__properties.__spam_target
                if not target.Parent or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
                    System.__properties.__spam_target = nil; System.__properties.__spam_target_time = 0
                end
            end
            if not System.__properties.__spam_target or (now - System.__properties.__spam_target_time > 1) then
                System.__properties.__spam_target = Closest_Entity
                System.__properties.__spam_target_time = now
            end
        end
        local ball_target = ball:GetAttribute('target'); if not ball_target then return end
        local ball_props   = System.auto_spam:get_ball_properties()
        local entity_props = System.auto_spam:get_entity_properties()
        if ball_props and entity_props then
            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
            local ping_th = math.clamp(ping / 5, 1, 16)
            local spam_acc = System.auto_spam.spam_service({ Ball_Properties = ball_props, Entity_Properties = entity_props, Ping = ping_th })
            if spam_acc > 0 then
                local root = char.PrimaryPart; if not root then return end
                local target_entity = Closest_Entity; if not target_entity or not target_entity.PrimaryPart then return end
                local target_pos  = target_entity.PrimaryPart.Position
                local target_dist = (root.Position - target_pos).Magnitude
                local dist_ball   = (root.Position - ball.Position).Magnitude
                local shouldSpam  = false
                local spam_target = System.__properties.__spam_target
                if spam_target then
                    if ball_target == spam_target.Name or ball_target == LocalPlayer.Name then
                        shouldSpam = true
                    end
                end
                if shouldSpam and not char:GetAttribute('Pulsed') then
                    if target_dist <= spam_acc and dist_ball <= spam_acc then
                        local multiplier  = System.__properties.__auto_spam_distance_multiplier or 1.0
                        local max_allowed = 35 * multiplier
                        local is_target   = (ball_target == LocalPlayer.Name)
                        local final_max   = is_target and max_allowed or (max_allowed * 0.8)
                        if target_dist <= final_max and dist_ball <= final_max then
                            parry_execute()
                        end
                    end
                end
            end
        end
    end)
end
function System.auto_spam.stop()
    System.__properties.__auto_spam_enabled = false
    System.__properties.__spam_target = nil
    System.__properties.__spam_target_time = 0
    if System.__properties.__connections.__auto_spam_connection then
        System.__properties.__connections.__auto_spam_connection:Disconnect()
        System.__properties.__connections.__auto_spam_connection = nil
    end
end

-- ==================== EVENTS ====================
ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c, d)
    System.__properties.__deathslash_active = d or false
end)
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    System.__properties.__infinity_active = b or false
end)

local bfolder = workspace:FindFirstChild("Balls")
if bfolder then
    bfolder.ChildAdded:Connect(function()
        System.__properties.__parried = false
        System.__properties.__antidot_parried = false
    end)
    bfolder.ChildRemoved:Connect(function()
        System.__properties.__parries = 0
        System.__properties.__parried = false
        System.__properties.__antidot_parried = false
    end)
end

update_divisor()

-- =====================================================================
-- ============================= UI ====================================
-- =====================================================================

-- ==================== TAB 1: AUTO PARRY ====================
local Tab1 = Window:AddTab({ Name = "Auto Parry", Icon = "crosshair" })

-- SECTION: Main
local mainSection = Tab1:AddSection("Main")

mainSection:AddToggle({
    Title   = "Auto Parry",
    Content = "Auto parry + auto timing berdasarkan ping",
    Default = false,
    Callback = function(state)
        System.__properties.__autoparry_enabled = state
        if state then System.autoparry.start() else System.autoparry.stop() end
        if not isFirstLoad then
            notif("Auto Parry: " .. (state and "Enabled" or "Disabled"), 3,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

mainSection:AddSlider({
    Title     = "Parry Accuracy",
    Content   = "Tinggi = parry lebih awal (lebih besar radius)",
    Min       = 1,
    Max       = 100,
    Default   = 1,
    Increment = 1,
    Callback  = function(val)
        System.__properties.__accuracy = val
        update_divisor()
    end
})

-- SECTION: Protections
local protSection = Tab1:AddSection("Protections")

protSection:AddToggle({
    Title   = "Cooldown Protection",
    Content = "Skip parry jika block sedang cooldown",
    Default = false,
    Callback = function(state)
        getgenv().CooldownProtection = state
    end
})

protSection:AddToggle({
    Title   = "Auto Ability",
    Content = "Auto pakai ability saat bola datang",
    Default = false,
    Callback = function(state)
        getgenv().AutoAbility = state
    end
})


mainSection:AddToggle({
    Title   = "Auto Spam",
    Content = "Auto spam parry berdasarkan jarak bola & player",
    Default = false,
    Callback = function(state)
        if state then System.auto_spam.start() else System.auto_spam.stop() end
        if not isFirstLoad then
            notif("Auto Spam: " .. (state and "ON" or "OFF"), 2,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- SECTION: Detections
local detectionSection = Tab1:AddSection("Detections")

detectionSection:AddToggle({
    Title   = "Ignore Infinity Ball",
    Content = "Skip parry saat Infinity Ball aktif",
    Default = false,
    Callback = function(state) System.__config.__detections.__infinity = state end
})

detectionSection:AddToggle({
    Title   = "Ignore Death Slash",
    Content = "Skip parry saat Death Slash aktif",
    Default = false,
    Callback = function(state) System.__config.__detections.__deathslash = state end
})

detectionSection:AddToggle({
    Title   = "Ignore Time Hole",
    Content = "Skip parry saat Time Hole aktif",
    Default = false,
    Callback = function(state) System.__config.__detections.__timehole = state end
})

-- ==================== TAB 2: CURVE ====================
local Tab2 = Window:AddTab({ Name = "Curve", Icon = "loop" })

local curveSection = Tab2:AddSection("Curve Mode")

curveSection:AddDropdown({
    Title   = "Curve Mode",
    Options = System.__config.__curve_names,
    Default = "Camera",
    Callback = function(val)
        for i, name in ipairs(System.__config.__curve_names) do
            if name == val then System.__properties.__curve_mode = i; break end
        end
        if not isFirstLoad then notif("Curve: " .. val, 2, Color3.fromRGB(0, 170, 255)) end
    end
})

curveSection:AddParagraph({
    Title   = "Mode Info",
    Content = "Camera: arah kamera\nRandom: arah acak\nAccelerated: ke atas sedikit\nBackwards: arah balik\nSlow: bawah ekstrem\nHigh: atas ekstrem"
})

-- ==================== TAB 3: VISUALS ====================
local Tab3 = Window:AddTab({ Name = "Visuals", Icon = "eyes" })

local visualSection = Tab3:AddSection("Dynamic Hitbox Visual")

visualSection:AddToggle({
    Title   = "Dynamic Hitbox",
    Content = "Tampilkan sphere hitbox di karakter",
    Default = false,
    Callback = function(state)
        getgenv().DynamicHitbox.Enabled = state
        if not state and getgenv().DynamicHitbox.Part then
            getgenv().DynamicHitbox.Part:Destroy()
            getgenv().DynamicHitbox.Part = nil
        end
        if not isFirstLoad then
            notif("Dynamic Hitbox: " .. (state and "ON" or "OFF"), 2,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

visualSection:AddSlider({
    Title = "Max Size", Content = "Ukuran sphere saat bola jauh",
    Min = 5, Max = 80, Default = 40, Increment = 1,
    Callback = function(val) getgenv().DynamicHitbox.MaxSize = val end
})

visualSection:AddSlider({
    Title = "Min Size", Content = "Ukuran sphere saat bola dekat",
    Min = 1, Max = 20, Default = 5, Increment = 1,
    Callback = function(val) getgenv().DynamicHitbox.MinSize = val end
})

visualSection:AddSlider({
    Title = "Transparency", Content = "0 = solid | 9 = hampir tak terlihat",
    Min = 0, Max = 9, Default = 7, Increment = 1,
    Callback = function(val) getgenv().DynamicHitbox.Transparency = val / 10 end
})

-- ==================== TAB 4: MISC ====================
local Tab4 = Window:AddTab({ Name = "Misc", Icon = "settings" })

local miscSection = Tab4:AddSection("Controls")

miscSection:AddButton({
    Title    = "Stop All",
    Callback = function()
        System.__properties.__autoparry_enabled = false
        System.autoparry.stop()
        System.manual_spam.stop()
        System.auto_spam.stop()
        getgenv().DynamicHitbox.Enabled = false
        if getgenv().DynamicHitbox.Part then
            getgenv().DynamicHitbox.Part:Destroy()
            getgenv().DynamicHitbox.Part = nil
        end
        notif("Semua fitur dimatikan!", 3, Color3.fromRGB(255, 0, 0))
    end
})

miscSection:AddButton({
    Title    = "Test Notify",
    Callback = function()
        notif("Victoria Bladeball v2.0 aktif!", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- ==================== FINAL ====================
task.delay(1, function() isFirstLoad = false end)
task.delay(1.5, function()
    notif("Victoria Blade Ball v2.0 loaded!", 4, Color3.fromRGB(0, 170, 255))
end)

return Window
