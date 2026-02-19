================ LOAD VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

-- ==================== CREATE MAIN WINDOW ====================
local Window = Vict:Window({
    Title   = "River | Bladeball",
    Footer  = "Auto Parry + Curve",
    Color   = Color3.fromRGB(0, 170, 255),
    ["Tab Width"] = 120,
    Version = "1.0.0",
    Icon    = "rbxassetid://79482005659181",
    Image   = "79482005659181"
})

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Stats            = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService     = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Alive   = workspace:FindFirstChild("Alive") or workspace:WaitForChild("Alive")
local Runtime = workspace:WaitForChild("Runtime")

-- ==================== GLOBALS ====================
getgenv().HitboxEnabled       = false
getgenv().HitboxSize          = 0
getgenv().AutoParryMode       = "Auto"
getgenv().HighSpeedProtection = false
getgenv().AutoParryNotify     = false
getgenv().CurveHotkeyEnabled  = false

getgenv().DynamicHitbox = {
    Enabled      = false,
    Part         = nil,
    MinSize      = 5,
    MaxSize      = 40,
    Color        = Color3.fromRGB(0, 170, 255),
    Transparency = 0.7
}

-- ==================== SYSTEM TABLE ====================
local System = {
    __properties = {
        __autoparry_enabled           = false,
        __curve_mode                  = 1,
        __accuracy                    = 50,
        __divisor_multiplier          = 1.1,
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
        __triggerbot_enabled          = false,
        __randomized_accuracy_enabled = false,
    },
    __config = {
        __curve_names = {"Camera", "Random", "Accelerated", "Backwards", "Slow", "High"},
        __detections  = {
            __infinity   = false,
            __deathslash = false,
            __timehole   = false,
        }
    }
}

-- ==================== HELPER ====================
local revertedRemotes = {}

local function update_divisor()
    System.__properties.__divisor_multiplier = 0.59 + (System.__properties.__accuracy - 1) * (3 / 99)
end

local function linear_predict(a, b, t) return a + (b - a) * t end

local function UpdateDynamicHitbox(ball_distance, parry_range)
    local config = getgenv().DynamicHitbox
    if not config or not config.Enabled then
        if config and config.Part then config.Part:Destroy(); config.Part = nil end
        return
    end
    if not config.Part then
        local p = Instance.new("Part")
        p.Name = "DynamicParryVisual"; p.Shape = Enum.PartType.Ball
        p.CanCollide = false; p.Anchored = true; p.CastShadow = false
        p.Material = Enum.Material.ForceField; p.Parent = workspace
        config.Part = p
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local dist = ball_distance or 100; local range = parry_range or 15
        local t = math.clamp((dist - range) / (100 - range), 0, 1)
        local vs = (config.MinSize or 5) + ((config.MaxSize or 40) - (config.MinSize or 5)) * t
        config.Part.Size         = config.Part.Size:Lerp(Vector3.new(vs, vs, vs), 0.2)
        config.Part.CFrame       = char.HumanoidRootPart.CFrame
        config.Part.Color        = config.Color or Color3.new(1, 1, 1)
        config.Part.Transparency = config.Transparency or 0.7
    end
end

-- ==================== SYSTEM.BALL ====================
System.ball = {}
function System.ball.get()
    local balls = workspace:FindFirstChild("Balls"); if not balls then return nil end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute("realBall") then ball.CanCollide = false; return ball end
    end
end
function System.ball.get_all()
    local t = {}; local balls = workspace:FindFirstChild("Balls"); if not balls then return t end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute("realBall") then ball.CanCollide = false; table.insert(t, ball) end
    end
    return t
end

-- ==================== SYSTEM.PLAYER ====================
System.player = {}
local _Closest = nil; local _LastCheck = 0
function System.player.get_closest()
    local now = tick(); if now - _LastCheck < 0.1 then return _Closest end; _LastCheck = now
    local maxd = math.huge; local closest = nil
    if not Alive then return nil end
    for _, e in pairs(Alive:GetChildren()) do
        if e ~= LocalPlayer.Character and e.PrimaryPart then
            local d = LocalPlayer:DistanceFromCharacter(e.PrimaryPart.Position)
            if d < maxd then maxd = d; closest = e end
        end
    end
    _Closest = closest; return closest
end
function System.player.get_closest_to_cursor()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local closest = nil; local min_dot = -math.huge; local camera = workspace.CurrentCamera
    if not Alive then return nil end
    local ok, ml = pcall(function() return UserInputService:GetMouseLocation() end); if not ok then return nil end
    local ray = camera:ScreenPointToRay(ml.X, ml.Y)
    local pointer = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
    for _, p in pairs(Alive:GetChildren()) do
        if p == LocalPlayer.Character then continue end
        if not p:FindFirstChild("HumanoidRootPart") then continue end
        local dir = (p.HumanoidRootPart.Position - camera.CFrame.Position).Unit
        local dot = pointer.LookVector:Dot(dir)
        if dot > min_dot then min_dot = dot; closest = p end
    end
    return closest
end

-- ==================== SYSTEM.CURVE ====================
System.curve = {}
function System.curve.get_cframe()
    local camera = workspace.CurrentCamera
    local root   = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return camera.CFrame end
    local targetPart
    local closest = System.player.get_closest_to_cursor()
    if closest and closest:FindFirstChild("HumanoidRootPart") then targetPart = closest.HumanoidRootPart end
    local target_pos = targetPart and targetPart.Position or (root.Position + camera.CFrame.LookVector * 100)
    local funcs = {
        function() return camera.CFrame end,
        function()
            local dir = (target_pos - root.Position).Unit; local off; local att = 0
            repeat
                off = Vector3.new(math.random(-4000,4000), math.random(-4000,4000), math.random(-4000,4000)); att += 1
            until dir:Dot((target_pos + off - root.Position).Unit) < 0.95 or att > 10
            return CFrame.new(root.Position, target_pos + off)
        end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, 5, 0)) end,
        function()
            local d = (root.Position - target_pos).Unit
            return CFrame.new(camera.CFrame.Position, root.Position + d * 10000 + Vector3.new(0, 1000, 0))
        end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, -9e18, 0)) end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0,  9e18, 0)) end,
    }
    return funcs[System.__properties.__curve_mode]()
end

-- ==================== SYSTEM.PARRY ====================
System.parry = {}
function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera = workspace.CurrentCamera
    local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end); if not ok then return end
    local is_mobile = System.__properties.__is_mobile
    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok2, sp = pcall(function() return camera:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok2 then event_data[entity.Name] = sp end
            end
        end
    end
    local curve_cframe = System.curve.get_cframe()
    if not System.__properties.__first_parry_done then
        for _, conn in pairs(getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do conn:Fire() end
        System.__properties.__first_parry_done = true; return
    end
    local aim = is_mobile and {camera.ViewportSize.X/2, camera.ViewportSize.Y/2} or {mouse.X, mouse.Y}
    for remote, args in pairs(revertedRemotes) do
        pcall(function()
            local margs = {args[1], args[2], args[3], curve_cframe, event_data, aim, args[7]}
            if remote:IsA("RemoteEvent") then remote:FireServer(unpack(margs))
            elseif remote:IsA("RemoteFunction") then remote:InvokeServer(unpack(margs)) end
        end)
    end
    System.__properties.__parries += 1
    task.delay(0.5, function() if System.__properties.__parries > 0 then System.__properties.__parries -= 1 end end)
end
function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera = workspace.CurrentCamera; local curve_cframe = System.curve.get_cframe(); local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok2, sp = pcall(function() return camera:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok2 then event_data[entity.Name] = sp end
            end
        end
    end
    local is_mobile = System.__properties.__is_mobile; local aim
    if is_mobile then aim = {camera.ViewportSize.X/2, camera.ViewportSize.Y/2}
    else local ok, m = pcall(function() return UserInputService:GetMouseLocation() end); aim = ok and {m.X, m.Y} or {0,0} end
    for remote, args in pairs(revertedRemotes) do
        pcall(function()
            local margs = {args[1], args[2], args[3], curve_cframe, event_data, aim, args[7]}
            if remote:IsA("RemoteEvent") then remote:FireServer(unpack(margs))
            elseif remote:IsA("RemoteFunction") then remote:InvokeServer(unpack(margs)) end
        end)
    end
    System.__properties.__parries += 1
    task.delay(0.5, function() if System.__properties.__parries > 0 then System.__properties.__parries -= 1 end end)
end
function System.parry.execute_action() System.parry.execute() end

-- ==================== SYSTEM.DETECTION ====================
System.detection = { __ball_properties = { __last_warping = tick(), __lerp_radians = 0, __curving = tick() } }
function System.detection.is_curved()
    local props = System.detection.__ball_properties; local ball = System.ball.get(); if not ball then return false end
    local zoomies = ball:FindFirstChild("zoomies"); if not zoomies then return false end
    local velocity = zoomies.VectorVelocity; local speed = velocity.Magnitude; if speed < 1 then return false end
    local char = LocalPlayer.Character; if not char or not char.PrimaryPart then return false end
    local pos = char.PrimaryPart.Position; local direction = (pos - ball.Position).Unit; local dot = direction:Dot(velocity.Unit)
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local distance = (pos - ball.Position).Magnitude; local reach_time = distance / speed - ping
    local dot_threshold = math.clamp(0.55 - (ping * 0.75), -1, 0.45)
    local speed_threshold = math.min(speed / 100, 45)
    local bdt = 15 - math.min(distance / 1000, 15) + speed_threshold
    local radians = math.asin(math.clamp(dot, -1, 1))
    props.__lerp_radians = linear_predict(props.__lerp_radians, radians, 0.85)
    if props.__lerp_radians < 0.016 then props.__last_warping = tick() end
    if distance < (bdt * 0.85) then return false end
    if (tick() - props.__last_warping) < (reach_time / 1.4) then return true end
    if (tick() - props.__curving)     < (reach_time / 1.1) then return true end
    return dot < dot_threshold
end

-- Update curving state
ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
    local primary = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
    local ball = System.ball.get(); if not ball or not primary then return end
    local zoom = ball:FindFirstChild("zoomies"); if not zoom then return end
    local speed = zoom.VectorVelocity.Magnitude; local dist = (primary.Position - ball.Position).Magnitude
    local pings = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local st = math.min(speed / 100, 40); local bdt = 15 - math.min(dist / 1000, 15) + st
    if speed > 1 and (dist / speed - pings/1000) > pings/10 then bdt = math.max(bdt - 5, 15) end
    if b ~= primary and dist > bdt then System.detection.__ball_properties.__curving = tick() end
end)

-- ==================== SYSTEM.AUTOPARRY ====================
System.autoparry = {}
function System.autoparry.get_balls() return System.ball.get_all() end

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end
    System.__properties.__connections.__autoparry = RunService.RenderStepped:Connect(function()
        if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
        local balls = System.autoparry.get_balls(); local one_ball = System.ball.get()

        -- Training Ball
        local training_ball = nil
        if workspace:FindFirstChild("TrainingBalls") then
            for _, inst in pairs(workspace.TrainingBalls:GetChildren()) do
                if inst:GetAttribute("realBall") then training_ball = inst; break end
            end
        end

        -- Main ball loop
        for _, ball in pairs(balls) do
            if not ball then continue end
            local zoomies = ball:FindFirstChild("zoomies"); if not zoomies then continue end
            ball:GetAttributeChangedSignal("target"):Once(function()
                System.__properties.__parried = false; System.__properties.__antidot_parried = false
            end)
            if System.__properties.__parried then continue end
            local ball_target = ball:GetAttribute("target")
            local velocity    = zoomies.VectorVelocity
            local distance    = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
            local ping        = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
            local ping_th     = math.clamp(ping / 10, 5, 17)
            local speed       = velocity.Magnitude; if speed <= 0 then continue end
            local csd         = math.min(math.max(speed - 9.5, 0), 650)
            local spd_div     = (2.5 + csd * 0.002) * System.__properties.__divisor_multiplier
            local parry_acc   = ping_th + math.max(speed / spd_div, 9.5)
            if getgenv().HitboxEnabled then parry_acc += getgenv().HitboxSize or 0 end
            UpdateDynamicHitbox(distance, parry_acc)
            local dir_to_plr = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
            local dot_to_plr = dir_to_plr:Dot(velocity.Unit)
            if ball_target ~= LocalPlayer.Name and dot_to_plr < 0.1 then continue end
            if getgenv().HighSpeedProtection and speed > 1500 then
                parry_acc *= math.clamp(1 + (speed - 1500) / 1000, 1.5, 3.5)
            elseif speed > 2000 then parry_acc *= 2.0 end
            if ball:FindFirstChild("AeroDynamicSlashVFX") then ball.AeroDynamicSlashVFX:Destroy(); System.__properties.__tornado_time = tick() end
            if Runtime:FindFirstChild("Tornado") and (tick() - System.__properties.__tornado_time) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then continue end
            if one_ball and one_ball:GetAttribute("target") == LocalPlayer.Name and System.detection.is_curved() then continue end
            if ball:FindFirstChild("ComboCounter") then continue end
            if LocalPlayer.Character.PrimaryPart:FindFirstChild("SingularityCape") then continue end
            if System.__config.__detections.__infinity   and System.__properties.__infinity_active   then continue end
            if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
            if System.__config.__detections.__timehole   and System.__properties.__timehole_active   then continue end
            local closest = System.player.get_closest()
            if closest and not System.__properties.__antidot_parried then
                local pd = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Magnitude
                if pd <= 30 and dot_to_plr > 0.75 and ball_target == LocalPlayer.Name and distance <= 30 then
                    System.parry.execute_action()
                    System.__properties.__parried = true; System.__properties.__antidot_parried = true
                end
            end
            if ball_target == LocalPlayer.Name and distance <= parry_acc then
                if getgenv().AutoParryMode == "Keypress" then System.parry.keypress() else System.parry.execute_action() end
                System.__properties.__parried = true
            end
            local lp = tick()
            repeat RunService.RenderStepped:Wait() until (tick() - lp) >= 1 or not System.__properties.__parried
            System.__properties.__parried = false; System.__properties.__antidot_parried = false
        end

        -- Training ball
        if training_ball then
            local zoomies = training_ball:FindFirstChild("zoomies")
            if zoomies and not System.__properties.__training_parried then
                training_ball:GetAttributeChangedSignal("target"):Once(function() System.__properties.__training_parried = false end)
                local bt   = training_ball:GetAttribute("target")
                local vel  = zoomies.VectorVelocity; local dist = LocalPlayer:DistanceFromCharacter(training_ball.Position)
                local spd  = vel.Magnitude; local png = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                local png_th = math.clamp(png / 10, 5, 17)
                local csd  = math.min(math.max(spd - 9.5, 0), 650)
                local pa   = png_th + math.max(spd / ((2.4 + csd * 0.002) * System.__properties.__divisor_multiplier), 9.5)
                if getgenv().HitboxEnabled then pa += getgenv().HitboxSize or 0 end
                if spd > 2000 then pa *= 2.0 end
                UpdateDynamicHitbox(dist, pa)
                if bt == LocalPlayer.Name and dist <= pa then
                    if getgenv().AutoParryMode == "Keypress" then System.parry.keypress() else System.parry.execute_action() end
                    System.__properties.__training_parried = true
                    local lp = tick()
                    repeat RunService.RenderStepped:Wait() until (tick() - lp) >= 1 or not System.__properties.__training_parried
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

-- ==================== REMOTE HOOK ====================
local meta = getrawmetatable(game); setreadonly(meta, false)
local old_index = meta.__index
meta.__index = function(self, key)
    local isEvent = pcall(function() return self:IsA("RemoteEvent") end) and self:IsA("RemoteEvent")
    local isFunc  = pcall(function() return self:IsA("RemoteFunction") end) and self:IsA("RemoteFunction")
    if (key == "FireServer" and isEvent) or (key == "InvokeServer" and isFunc) then
        return function(obj, ...)
            local args = {...}
            if #args == 7 and type(args[2]) == "string" and type(args[3]) == "number"
               and typeof(args[4]) == "CFrame" and type(args[5]) == "table"
               and type(args[6]) == "table" and type(args[7]) == "boolean" then
                revertedRemotes[obj] = args
            end
            return old_index(self, key)(obj, ...)
        end
    end
    return old_index(self, key)
end
setreadonly(meta, true)

-- ==================== EVENTS ====================
ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c, d)
    System.__properties.__deathslash_active = d or false
end)
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    System.__properties.__infinity_active = b or false
end)

local balls_folder = workspace:FindFirstChild("Balls")
if balls_folder then
    balls_folder.ChildAdded:Connect(function()
        System.__properties.__parried = false; System.__properties.__antidot_parried = false
    end)
    balls_folder.ChildRemoved:Connect(function()
        System.__properties.__parries = 0
        System.__properties.__parried = false; System.__properties.__antidot_parried = false
    end)
end

update_divisor()

-- =====================================================================
-- ======================== BUILD UI ===================================
-- =====================================================================

-- ==================== TAB 1: AUTO PARRY ====================
local Tab1 = Window:AddTab({ Name = "Auto Parry", Icon = "crosshair" })

-- SECTION: Main
local mainSection = Tab1:AddSection("Main")

mainSection:AddToggle({
    Title   = "Auto Parry",
    Content = "Aktifkan auto parry otomatis",
    Default = false,
    Callback = function(state)
        System.__properties.__autoparry_enabled = state
        if state then
            System.autoparry.start()
        else
            System.autoparry.stop()
        end
        if getgenv().AutoParryNotify then
            notif("Auto Parry: " .. (state and "Enabled" or "Disabled"), 3,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

mainSection:AddDropdown({
    Title   = "Parry Mode",
    Options = {"Auto", "Keypress"},
    Default = "Auto",
    Callback = function(val)
        getgenv().AutoParryMode = val
        notif("Mode: " .. val, 2, Color3.fromRGB(0, 170, 255))
    end
})

mainSection:AddSlider({
    Title    = "Parry Accuracy",
    Content  = "Tinggi = lebih awal parry",
    Min      = 1,
    Max      = 100,
    Default  = 50,
    Increment = 1,
    Callback = function(val)
        System.__properties.__accuracy = val
        update_divisor()
    end
})

mainSection:AddToggle({
    Title   = "Randomized Accuracy",
    Content = "Auto ubah akurasi berdasarkan ping",
    Default = false,
    Callback = function(state)
        System.__properties.__randomized_accuracy_enabled = state
        if state then
            task.spawn(function()
                while System.__properties.__randomized_accuracy_enabled do
                    task.wait(1)
                    local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                    local ping = tonumber(ping_str:match("%d+")) or 0
                    if ping >= 90 then System.__properties.__accuracy = 4
                    elseif ping <= 50 then System.__properties.__accuracy = math.random(70, 100) end
                    update_divisor()
                end
            end)
        end
        if not _G.VictoriaFirstLoad then
            notif("Randomized Accuracy: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

mainSection:AddToggle({
    Title   = "Auto Parry Notify",
    Content = "Tampilkan notif saat toggle parry",
    Default = false,
    Callback = function(state)
        getgenv().AutoParryNotify = state
    end
})

-- SECTION: Hitbox
local hitboxSection = Tab1:AddSection("Hitbox")

hitboxSection:AddToggle({
    Title   = "Hitbox Extender",
    Content = "Perbesar area parry",
    Default = false,
    Callback = function(state)
        getgenv().HitboxEnabled = state
        if not _G.VictoriaFirstLoad then
            notif("Hitbox Extender: " .. (state and "ON" or "OFF"), 2,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

hitboxSection:AddSlider({
    Title    = "Hitbox Size",
    Content  = "Tambahan radius hitbox (studs)",
    Min      = 0,
    Max      = 50,
    Default  = 0,
    Increment = 1,
    Callback = function(val)
        getgenv().HitboxSize = val
    end
})

hitboxSection:AddToggle({
    Title   = "High Speed Protection",
    Content = "Scale accuracy saat bola cepat banget",
    Default = false,
    Callback = function(state)
        getgenv().HighSpeedProtection = state
        if not _G.VictoriaFirstLoad then
            notif("HS Protection: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- SECTION: Detections
local detectionSection = Tab1:AddSection("Detections")

detectionSection:AddToggle({
    Title   = "Ignore Infinity Ball",
    Content = "Skip parry saat Infinity Ball aktif",
    Default = false,
    Callback = function(state)
        System.__config.__detections.__infinity = state
    end
})

detectionSection:AddToggle({
    Title   = "Ignore Death Slash",
    Content = "Skip parry saat Death Slash aktif",
    Default = false,
    Callback = function(state)
        System.__config.__detections.__deathslash = state
    end
})

detectionSection:AddToggle({
    Title   = "Ignore Time Hole",
    Content = "Skip parry saat Time Hole aktif",
    Default = false,
    Callback = function(state)
        System.__config.__detections.__timehole = state
    end
})

-- ==================== TAB 2: CURVE ====================
local Tab2 = Window:AddTab({ Name = "Curve", Icon = "loop" })

-- SECTION: Curve Mode
local curveSection = Tab2:AddSection("Curve Mode")

curveSection:AddDropdown({
    Title   = "Curve Mode",
    Options = System.__config.__curve_names,
    Default = "Camera",
    Callback = function(val)
        for i, name in ipairs(System.__config.__curve_names) do
            if name == val then System.__properties.__curve_mode = i; break end
        end
        if getgenv().CurveHotkeyEnabled then
            notif("Curve: " .. val, 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

curveSection:AddParagraph({
    Title   = "Curve Modes Info",
    Content = "Camera = arah kamera\nRandom = arah acak\nAccelerated = sedikit ke atas\nBackwards = arah balik\nSlow = ke bawah ekstrem\nHigh = ke atas ekstrem"
})

-- SECTION: Hotkey
local hotkeySection = Tab2:AddSection("Curve Hotkeys")

hotkeySection:AddToggle({
    Title   = "Enable Curve Hotkeys",
    Content = "Tekan 1-6 keyboard untuk ganti curve",
    Default = false,
    Callback = function(state)
        getgenv().CurveHotkeyEnabled = state
        if not _G.VictoriaFirstLoad then
            notif("Curve Hotkeys: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

hotkeySection:AddParagraph({
    Title   = "Hotkey Map",
    Content = "1 → Camera\n2 → Random\n3 → Accelerated\n4 → Backwards\n5 → Slow\n6 → High"
})

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not getgenv().CurveHotkeyEnabled then return end
    local keys = {
        [Enum.KeyCode.One]   = 1, [Enum.KeyCode.Two]   = 2,
        [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four]  = 4,
        [Enum.KeyCode.Five]  = 5, [Enum.KeyCode.Six]   = 6,
    }
    if keys[input.KeyCode] then
        local idx = keys[input.KeyCode]
        System.__properties.__curve_mode = idx
        notif("Curve: " .. System.__config.__curve_names[idx], 2, Color3.fromRGB(0, 170, 255))
    end
end)

-- ==================== TAB 3: VISUALS ====================
local Tab3 = Window:AddTab({ Name = "Visuals", Icon = "eyes" })

-- SECTION: Dynamic Hitbox Visual
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
        if not _G.VictoriaFirstLoad then
            notif("Dynamic Hitbox: " .. (state and "ON" or "OFF"), 2,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

visualSection:AddSlider({
    Title    = "Max Size",
    Content  = "Ukuran sphere saat bola jauh",
    Min      = 5,
    Max      = 80,
    Default  = 40,
    Increment = 1,
    Callback = function(val)
        getgenv().DynamicHitbox.MaxSize = val
    end
})

visualSection:AddSlider({
    Title    = "Min Size",
    Content  = "Ukuran sphere saat bola dekat",
    Min      = 1,
    Max      = 20,
    Default  = 5,
    Increment = 1,
    Callback = function(val)
        getgenv().DynamicHitbox.MinSize = val
    end
})

visualSection:AddSlider({
    Title    = "Transparency",
    Content  = "0 = solid | 9 = hampir tidak kelihatan",
    Min      = 0,
    Max      = 9,
    Default  = 7,
    Increment = 1,
    Callback = function(val)
        getgenv().DynamicHitbox.Transparency = val / 10
    end
})

-- ==================== TAB 4: MISC ====================
local Tab4 = Window:AddTab({ Name = "Misc", Icon = "settings" })

local miscSection = Tab4:AddSection("Misc")

miscSection:AddButton({
    Title    = "Stop All",
    Description = "Matikan semua fitur sekarang",
    Callback = function()
        System.__properties.__autoparry_enabled = false
        System.autoparry.stop()
        getgenv().DynamicHitbox.Enabled = false
        if getgenv().DynamicHitbox.Part then
            getgenv().DynamicHitbox.Part:Destroy()
            getgenv().DynamicHitbox.Part = nil
        end
        notif("Semua fitur dimatikan!", 3, Color3.fromRGB(255, 80, 80))
    end
})

miscSection:AddButton({
    Title    = "Test Notify",
    Description = "Cek apakah notif berjalan",
    Callback = function()
        notif("River Bladeball berjalan!", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- ==================== FINAL ====================
task.delay(1.5, function()
    notif("River Bladeball loaded! (F3 = toggle UI)", 4, Color3.fromRGB(0, 170, 255))
end)

return Window
