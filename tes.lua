local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()
local isFirstLoad = true

local Window = Vict:Window({
    Title        = "River | Bladeball",
    Footer       = "Auto Parry System",
    Color        = Color3.fromRGB(0, 170, 255),
    ["Tab Width"] = 120,
    Version      = "4.0.0",
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

-- ==================== STATE ====================
local revertedRemotes   = {}
local Closest_Entity    = nil
local manualSpamThread  = nil

-- ==================== SYSTEM ====================
local System = {
    __properties = {
        __autoparry_enabled           = false,
        __auto_spam_enabled           = false,
        __curve_mode                  = 1,
        -- Accuracy: 1-100, default 50 (tengah). Triggerbot + randomized berjalan di dalam sini.
        __accuracy                    = 50,
        __divisor_multiplier          = 0.59 + (50 - 1) * (3 / 99), -- diupdate oleh update_divisor
        __parried                     = false,
        __training_parried            = false,
        __parries                     = 0,
        __first_parry_done            = false,
        __connections                 = {},
        __grab_animation              = nil,
        __tornado_time                = tick(),
        __infinity_active             = false,
        __deathslash_active           = false,
        __timehole_active             = false,
        __is_mobile                   = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
        __antidot_parried             = false,
        -- Triggerbot built-in (tidak perlu toggle terpisah)
        __triggerbot_active           = false,
        __play_animation              = false,
        __randomized_accuracy_enabled = false,
        __spam_target                 = nil,
        __spam_target_time            = 0,
        __last_antidot_check          = 0,
        __auto_spam_connection        = nil,
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

local DualBypassSystem = {
    __properties = {
        __captured_data          = nil,
        __use_virtual_input_once = true,
        __virtual_input_used     = false,
        __original_metatables    = {},
    }
}

-- ==================== BYPASS HOOK ====================
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
    local ok, meta = pcall(getrawmetatable, remote)
    if not ok or not meta then return end
    local rok = pcall(setreadonly, meta, false)
    if not rok then return end
    local oldIndex = meta.__index
    meta.__index = function(self, key)
        if (key == "FireServer" and self:IsA("RemoteEvent")) or
           (key == "InvokeServer" and self:IsA("RemoteFunction")) then
            return function(obj, ...)
                local args = {...}
                if DualBypassSystem.isValidRemoteArgs(args) then
                    if not DualBypassSystem.__properties.__captured_data then
                        DualBypassSystem.__properties.__captured_data = { remote = obj, args = args }
                    end
                    if not revertedRemotes[obj] then
                        revertedRemotes[obj] = args
                    end
                end
                return oldIndex(self, key)(obj, unpack(args))
            end
        end
        return oldIndex(self, key)
    end
    pcall(setreadonly, meta, true)
end

for _, r in pairs(ReplicatedStorage:GetChildren()) do
    if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then DualBypassSystem.hookRemote(r) end
end
ReplicatedStorage.ChildAdded:Connect(function(r)
    if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then DualBypassSystem.hookRemote(r) end
end)

-- ==================== HELPERS ====================
local function update_divisor()
    System.__properties.__divisor_multiplier = 0.59 + (System.__properties.__accuracy - 1) * (3 / 99)
end
update_divisor()

local function linear_predict(a, b, t) return a + (b - a) * t end

-- Randomized accuracy: auto adjust berdasarkan ping, jalan 1x/detik
task.spawn(function()
    while task.wait(1) do
        if not System.__properties.__randomized_accuracy_enabled then continue end
        local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        local ping = tonumber(ping_str:match("%d+")) or 0
        local new_acc
        if ping >= 90 then
            new_acc = math.random(10, 25)   -- ping tinggi → accuracy rendah = parry lebih awal
        elseif ping <= 50 then
            new_acc = math.random(60, 85)   -- ping bagus → accuracy tinggi = parry presisi
        else
            new_acc = math.random(35, 55)   -- middle ground
        end
        System.__properties.__accuracy = new_acc
        update_divisor()
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
        local t  = math.clamp((ball_distance - parry_range) / math.max(100 - parry_range, 1), 0, 1)
        local vs = cfg.MinSize + (cfg.MaxSize - cfg.MinSize) * t
        cfg.Part.Size         = cfg.Part.Size:Lerp(Vector3.new(vs, vs, vs), 0.2)
        cfg.Part.CFrame       = char.HumanoidRootPart.CFrame
        cfg.Part.Color        = Color3.fromRGB(255, 255, 255)
        cfg.Part.Transparency = 0.7
    end
end

getgenv().DynamicHitbox = { Enabled = false, Part = nil, MinSize = 5, MaxSize = 40 }

-- ==================== BALL / PLAYER ====================
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

System.player = {}
local _LastClosestCheck = 0
function System.player.get_closest()
    local now = tick()
    if now - _LastClosestCheck < 0.1 then return Closest_Entity end
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
    local ok, ml = pcall(function() return UserInputService:GetMouseLocation() end)
    if not ok then return nil end
    local ray = cam:ScreenPointToRay(ml.X, ml.Y)
    local fwd = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction).LookVector
    for _, p in pairs(Alive:GetChildren()) do
        if p == LocalPlayer.Character then continue end
        if not p:FindFirstChild("HumanoidRootPart") then continue end
        local dot = fwd:Dot((p.HumanoidRootPart.Position - cam.CFrame.Position).Unit)
        if dot > min_dot then min_dot = dot; closest = p end
    end
    return closest
end

-- ==================== CURVE ====================
System.curve = {}
function System.curve.get_cframe()
    local cam  = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return cam.CFrame end
    local cl = System.player.get_closest_to_cursor()
    local tp = cl and cl:FindFirstChild("HumanoidRootPart")
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

-- ==================== PARRY ====================
System.animation = {}
function System.animation.play_grab_parry()
    if not System.__properties.__play_animation then return end
    local character = LocalPlayer.Character; if not character then return end
    local humanoid  = character:FindFirstChildOfClass('Humanoid')
    local animator  = humanoid and humanoid:FindFirstChildOfClass('Animator')
    if not humanoid or not animator then return end
    local sword_name = character:GetAttribute('CurrentlyEquippedSword')
    if not sword_name then return end
    local ok, sword_api = pcall(function() return ReplicatedStorage.Shared.SwordAPI.Collection end)
    if not ok then return end
    local parry_animation = sword_api.Default:FindFirstChild('GrabParry')
    if not parry_animation then return end
    local ok2, sword_data = pcall(function()
        return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(sword_name)
    end)
    if not ok2 or not sword_data or not sword_data['AnimationType'] then return end
    for _, object in pairs(sword_api:GetChildren()) do
        if object.Name == sword_data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                parry_animation = object[object:FindFirstChild('GrabParry') and 'GrabParry' or 'Grab']
            end
        end
    end
    if System.__properties.__grab_animation and System.__properties.__grab_animation.IsPlaying then
        System.__properties.__grab_animation:Stop()
    end
    System.__properties.__grab_animation = animator:LoadAnimation(parry_animation)
    System.__properties.__grab_animation.Priority = Enum.AnimationPriority.Action4
    System.__properties.__grab_animation:Play()
end

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

local function getAimTarget(camera)
    if System.__properties.__is_mobile then
        local vp = camera.ViewportSize
        return {vp.X / 2, vp.Y / 2}
    end
    local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
    return ok and {mouse.X, mouse.Y} or {0, 0}
end

local function fireParry()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera       = workspace.CurrentCamera
    local curve_cframe = System.curve.get_cframe()
    local event_data   = buildEventData(camera)
    local aim          = getAimTarget(camera)
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
    System.__properties.__parries += 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then System.__properties.__parries -= 1 end
    end)
end

function System.parry.execute()
    -- First parry: VirtualInput untuk capture remote
    if not System.__properties.__first_parry_done
       and DualBypassSystem.__properties.__use_virtual_input_once
       and not DualBypassSystem.__properties.__virtual_input_used then
        pcall(function()
            for _, conn in pairs(getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
                conn:Fire()
            end
        end)
        System.__properties.__first_parry_done = true
        DualBypassSystem.__properties.__virtual_input_used = true
        return
    end
    fireParry()
end

function System.parry.execute_action()
    System.animation.play_grab_parry()
    System.parry.execute()
end

-- ==================== DETECTION ====================
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
    if (tick() - props.__curving)      < reach / 1.1 then return true end
    return dot < dot_th
end

-- ==================== TIMING CORE ====================
-- Ini inti perbaikan timing:
-- Daripada cek jarak statis (dist <= radius),
-- kita hitung TIME TO REACH (bola sampai ke kita dalam berapa detik),
-- lalu parry saat time_to_reach <= ping_window.
-- Untuk bola lambat dari jauh → time_to_reach besar → tidak parry dulu.
-- Untuk bola cepat dari dekat → time_to_reach kecil → langsung parry.
-- Accuracy slider mengontrol ping_window multiplier (0.8 - 2.0).

local function compute_parry_window()
    -- accuracy 1 = ketat (window kecil = parry lebih telat/presisi)
    -- accuracy 100 = longgar (window besar = parry lebih awal)
    -- Range: 0.8x - 2.0x dari ping dasar
    return 0.8 + (System.__properties.__accuracy - 1) * (1.2 / 99)
end

local function should_parry_now(ball, zoom, char_root)
    local vel  = zoom.VectorVelocity
    local spd  = vel.Magnitude
    if spd <= 0 then return false end

    local ball_pos = ball.Position
    local root_pos = char_root.Position
    local dist     = (root_pos - ball_pos).Magnitude

    -- Arah bola ke player
    local dir_to_player = (root_pos - ball_pos).Unit
    local dot           = dir_to_player:Dot(vel.Unit)

    -- Bola harus mengarah ke kita (dot positif)
    local bt = ball:GetAttribute('target')
    if bt ~= LocalPlayer.Name and dot < 0.1 then return false end

    -- Hitung time to reach (detik sampai bola ke titik kita)
    -- Pakai proyeksi kecepatan ke arah kita, bukan magnitude penuh
    local approach_speed = math.max(vel:Dot(dir_to_player), 1)
    local time_to_reach  = dist / approach_speed

    -- Ping dalam detik
    local ping_sec = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 1000

    -- Window: ping + buffer berbasis accuracy
    local window_multiplier = compute_parry_window()
    local parry_window      = ping_sec * window_multiplier

    -- Clash / face-to-face: tambah window untuk bola sangat cepat + jarak dekat
    -- Bola cepat dari dekat → time_to_reach sangat kecil → butuh window lebih besar
    if spd > 300 and dist < 40 then
        -- Scale window naik seiring speed & kedekatan
        local clash_factor = math.clamp(spd / 300, 1, 4) * math.clamp((40 - dist) / 40, 0.5, 1)
        parry_window = parry_window + ping_sec * clash_factor
    end

    -- Minimum window: tidak boleh terlalu kecil (5 frame @ 60fps = ~0.083s)
    parry_window = math.max(parry_window, 0.05)

    return time_to_reach <= parry_window
end

-- ==================== AUTO PARRY LOOP ====================
System.autoparry = {}

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end

    System.__properties.__connections.__autoparry = RunService.RenderStepped:Connect(function()
        if not System.__properties.__autoparry_enabled
           or not LocalPlayer.Character
           or not LocalPlayer.Character.PrimaryPart then return end

        local char_root = LocalPlayer.Character.PrimaryPart
        local balls     = System.ball.get_all()
        local one_ball  = System.ball.get()

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

            local bt  = ball:GetAttribute('target')
            local vel = zoom.VectorVelocity
            local spd = vel.Magnitude; if spd <= 0 then continue end
            local dist = (char_root.Position - ball.Position).Magnitude

            -- Dynamic hitbox visual
            local ping    = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local pth     = math.clamp(ping / 10, 5, 17)
            local csd     = math.min(math.max(spd - 9.5, 0), 650)
            local vis_acc = pth + math.max(spd / ((2.5 + csd * 0.002) * System.__properties.__divisor_multiplier), 9.5)
            UpdateDynamicHitbox(dist, vis_acc)

            local dtp = (char_root.Position - ball.Position).Unit:Dot(vel.Unit)

            -- Tornado check
            if ball:FindFirstChild('AeroDynamicSlashVFX') then
                ball.AeroDynamicSlashVFX:Destroy()
                System.__properties.__tornado_time = tick()
            end
            if Runtime:FindFirstChild('Tornado') then
                if (tick() - System.__properties.__tornado_time)
                   < (Runtime.Tornado:GetAttribute('TornadoTime') or 1) + 0.314159 then continue end
            end

            local curved = System.detection.is_curved()
            if one_ball and one_ball:GetAttribute('target') == LocalPlayer.Name and curved then continue end

            if ball:FindFirstChild('ComboCounter') then continue end
            if char_root:FindFirstChild('SingularityCape') then continue end

            if System.__config.__detections.__infinity   and System.__properties.__infinity_active   then continue end
            if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
            if System.__config.__detections.__timehole   and System.__properties.__timehole_active   then continue end

            -- Triggerbot built-in: kalau bola ke player terdekat & mereka dekat, parry juga
            local closest_player = System.player.get_closest()
            if closest_player and bt == closest_player.Name then
                local dist_to_closest = (char_root.Position - closest_player.PrimaryPart.Position).Magnitude
                if dist_to_closest <= 35 then
                    System.__properties.__triggerbot_active = true
                    -- Parry pakai timing yang sama
                    if should_parry_now(ball, zoom, char_root) then
                        System.parry.execute_action()
                        System.__properties.__parried = true
                    end
                end
            else
                System.__properties.__triggerbot_active = false
            end

            if System.__properties.__parried then goto continue_ball end

            -- Anti-dot: bola dari samping/dekat player lain, parry cepat
            if closest_player and not System.__properties.__antidot_parried then
                local player_dist = (char_root.Position - closest_player.PrimaryPart.Position).Magnitude
                if player_dist <= 30 and dtp > 0.75 and bt == LocalPlayer.Name and dist <= 30 then
                    System.parry.execute_action()
                    System.__properties.__parried = true
                    System.__properties.__antidot_parried = true
                    System.__properties.__last_antidot_check = tick()
                end
            end

            if System.__properties.__parried then goto continue_ball end

            -- Main parry: pakai time-to-reach
            if bt == LocalPlayer.Name and should_parry_now(ball, zoom, char_root) then
                System.parry.execute_action()
                System.__properties.__parried = true
            end

            ::continue_ball::

            if System.__properties.__parried then
                local lp = tick()
                repeat RunService.RenderStepped:Wait()
                until (tick() - lp) >= 0.5 or not System.__properties.__parried
                System.__properties.__parried      = false
                System.__properties.__antidot_parried = false
            end
        end

        -- Training ball
        if training_ball then
            local zoom = training_ball:FindFirstChild('zoomies')
            if zoom and not System.__properties.__training_parried then
                training_ball:GetAttributeChangedSignal('target'):Once(function()
                    System.__properties.__training_parried = false
                end)
                local bt = training_ball:GetAttribute('target')
                if bt == LocalPlayer.Name and should_parry_now(training_ball, zoom, char_root) then
                    System.parry.execute_action()
                    System.__properties.__training_parried = true
                    local lp = tick()
                    repeat RunService.RenderStepped:Wait()
                    until (tick() - lp) >= 0.5 or not System.__properties.__training_parried
                    System.__properties.__training_parried = false
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

-- ==================== AUTO SPAM ====================
-- Auto spam pakai timing yang sama tapi threshold sedikit lebih ketat
-- supaya tidak spam terlalu awal dari jauh
System.auto_spam = {}

function System.auto_spam.start()
    if System.__properties.__auto_spam_connection then
        System.__properties.__auto_spam_connection:Disconnect()
    end
    System.__properties.__auto_spam_enabled = true

    local last_spam     = 0
    local last_closest  = 0

    System.__properties.__auto_spam_connection = RunService.RenderStepped:Connect(function()
        if not System.__properties.__auto_spam_enabled
           or not LocalPlayer.Character
           or not LocalPlayer.Character.PrimaryPart then return end

        local now = tick()
        if now - last_spam < 0.008 then return end

        local char_root = LocalPlayer.Character.PrimaryPart
        local ball = System.ball.get(); if not ball then return end
        local zoom = ball:FindFirstChild('zoomies'); if not zoom then return end

        local bt = ball:GetAttribute('target'); if not bt then return end

        -- Update closest setiap 0.1s
        if now - last_closest > 0.1 then
            System.player.get_closest()
            last_closest = now
        end

        -- Spam hanya kalau bola ke kita atau ke player terdekat yang dekat
        local closest = Closest_Entity
        local valid_target = (bt == LocalPlayer.Name)
        if not valid_target and closest and closest.PrimaryPart then
            local dist_to_closest = (char_root.Position - closest.PrimaryPart.Position).Magnitude
            if bt == closest.Name and dist_to_closest <= 35 then
                valid_target = true
            end
        end

        if not valid_target then return end
        if char_root:GetAttribute('Pulsed') then return end

        -- Pakai timing system yang sama dengan auto parry
        if should_parry_now(ball, zoom, char_root) then
            last_spam = now
            fireParry()
        end
    end)
end

function System.auto_spam.stop()
    System.__properties.__auto_spam_enabled = false
    if System.__properties.__auto_spam_connection then
        System.__properties.__auto_spam_connection:Disconnect()
        System.__properties.__auto_spam_connection = nil
    end
end

-- ==================== REMOTE EVENTS ====================
ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c, d)
    System.__properties.__deathslash_active = d or false
end)
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    System.__properties.__infinity_active = b or false
end)

-- ParrySuccessAll: parry lagi kalau curved + sangat dekat
ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root and root.Parent and root.Parent ~= LocalPlayer.Character then
        if not Alive or root.Parent.Parent ~= Alive then return end
    end
    local closest = System.player.get_closest()
    local ball = System.ball.get()
    if not ball or not closest or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
    local char_root   = LocalPlayer.Character.PrimaryPart
    local target_dist = (char_root.Position - closest.PrimaryPart.Position).Magnitude
    local dist        = (char_root.Position - ball.Position).Magnitude
    UpdateDynamicHitbox(dist, 15)
    local vel = ball.AssemblyLinearVelocity or Vector3.zero
    local dot = (char_root.Position - ball.Position).Unit:Dot(vel.Unit)
    if target_dist < 15 and dist < 15 and dot > -0.25 then
        if System.detection.is_curved() then System.parry.execute_action() end
    end
    if System.__properties.__grab_animation then System.__properties.__grab_animation:Stop() end
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if not Alive or not LocalPlayer.Character or LocalPlayer.Character.Parent ~= Alive then return end
    if System.__properties.__grab_animation then System.__properties.__grab_animation:Stop() end
end)

-- Curving state update
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

-- TimeHole
pcall(function()
    local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net
    net["RE/TimeHoleActivate"].OnClientEvent:Connect(function(...)
        local args = {...}; local player = args[1]
        if player == LocalPlayer or player == LocalPlayer.Name
           or (player and player.Name == LocalPlayer.Name) then
            System.__properties.__timehole_active = true
        end
    end)
    net["RE/TimeHoleDeactivate"].OnClientEvent:Connect(function()
        System.__properties.__timehole_active = false
    end)
end)

getgenv().CooldownProtection = false
getgenv().AutoAbility        = false

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

-- =====================================================================
-- ============================= UI ====================================
-- =====================================================================

local Tab1 = Window:AddTab({ Name = "Auto Parry", Icon = "crosshair" })
local mainSection = Tab1:AddSection("Main")

-- Auto Parry toggle
mainSection:AddToggle({
    Title   = "Auto Parry",
    Content = "Deteksi timing presisi berbasis time-to-reach",
    Default = false,
    Callback = function(state)
        System.__properties.__autoparry_enabled = state
        if state then System.autoparry.start() else System.autoparry.stop() end
        if not isFirstLoad then
            notif("Auto Parry: " .. (state and "ON" or "OFF"), 3,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Spam toggle (di Main, langsung di bawah Auto Parry)
mainSection:AddToggle({
    Title   = "Auto Spam",
    Content = "Spam parry saat bola dalam jangkauan, anti-miss bola cepat",
    Default = false,
    Callback = function(state)
        System.__properties.__auto_spam_enabled = state
        if state then System.auto_spam.start() else System.auto_spam.stop() end
        if not isFirstLoad then
            notif("Auto Spam: " .. (state and "ON" or "OFF"), 3,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Accuracy slider
mainSection:AddSlider({
    Title     = "Parry Timing",
    Content   = "Rendah = parry lebih awal | Tinggi = parry lebih presisi/telat",
    Min       = 1,
    Max       = 100,
    Default   = 50,
    Increment = 1,
    Callback  = function(val)
        System.__properties.__accuracy = val
        update_divisor()
    end
})

-- Randomized accuracy (merged, tidak butuh slider terpisah)
mainSection:AddToggle({
    Title   = "Auto Timing (Randomized)",
    Content = "Auto atur timing berdasarkan ping (override slider)",
    Default = false,
    Callback = function(state)
        System.__properties.__randomized_accuracy_enabled = state
        if not isFirstLoad then
            notif("Auto Timing: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

mainSection:AddToggle({
    Title   = "Play Parry Animation",
    Content = "Animasi grab saat parry",
    Default = false,
    Callback = function(state)
        System.__properties.__play_animation = state
    end
})

-- Protections section
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

-- Detections section
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
    Content = "Camera: ikut arah kamera\nRandom: arah acak\nAccelerated: sedikit ke atas\nBackwards: arah balik\nSlow: bawah ekstrem\nHigh: atas ekstrem"
})

-- ==================== TAB 3: VISUALS ====================
local Tab3 = Window:AddTab({ Name = "Visuals", Icon = "eyes" })
local visualSection = Tab3:AddSection("Dynamic Hitbox")

visualSection:AddToggle({
    Title   = "Dynamic Hitbox",
    Content = "Tampilkan sphere parry radius di karakter",
    Default = false,
    Callback = function(state)
        getgenv().DynamicHitbox.Enabled = state
        if not state and getgenv().DynamicHitbox.Part then
            getgenv().DynamicHitbox.Part:Destroy()
            getgenv().DynamicHitbox.Part = nil
        end
    end
})

-- ==================== TAB 4: MISC ====================
local Tab4 = Window:AddTab({ Name = "Misc", Icon = "settings" })
local miscSection = Tab4:AddSection("Controls")

miscSection:AddButton({
    Title    = "Stop All",
    Callback = function()
        System.__properties.__autoparry_enabled = false
        System.__properties.__auto_spam_enabled = false
        System.autoparry.stop()
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
        notif("River Bladeball v4.0 aktif!", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- ==================== FINAL ====================
task.delay(1, function() isFirstLoad = false end)
task.delay(1.5, function()
    notif("River Bladeball v4.0 | Auto Parry + Spam aktif!", 4, Color3.fromRGB(0, 170, 255))
end)

return Window
