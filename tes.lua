-- [[ RIVER BLADEBALL - AUTO PARRY + CURVE ]] --
-- Version: 2.0.0 (FULL - Dengan semua fitur dari script pertama)
-- Made with VictUI Library

-- ==================== LOAD VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

local isFirstLoad = true

-- ==================== CREATE MAIN WINDOW ====================
local Window = Vict:Window({
    Title        = "River | Bladeball",
    Footer       = "Auto Parry + Curve (FULL)",
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
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Alive   = workspace:FindFirstChild("Alive") or workspace:WaitForChild("Alive")
local Runtime = workspace.Runtime
local Mouse = LocalPlayer:GetMouse()

-- ==================== GLOBALS ====================
getgenv().HitboxEnabled       = false
getgenv().HitboxSize          = 0
getgenv().AutoParryMode       = "Auto"
getgenv().HighSpeedProtection = false
getgenv().CurveHotkeyEnabled  = false
getgenv().skinChangerEnabled  = false
getgenv().swordAnimations     = nil
getgenv().CooldownProtection  = false
getgenv().AutoAbility         = false
getgenv().TriggerbotEnabled   = false
getgenv().AntiDotEnabled      = false
getgenv().AutoParryNotify     = true
getgenv().AutoSpamNotify      = true
getgenv().ManualSpamNotify    = true

-- ==================== DYNAMIC HITBOX VISUAL (LENGKAP DARI SCRIPT PERTAMA) ====================
getgenv().DynamicHitbox = {
    Enabled      = false,
    Part         = nil,
    MinSize      = 5,
    MaxSize      = 40,
    Color        = Color3.fromRGB(255, 255, 255),
    Transparency = 0.7
}

-- FUNGSI UPDATE DYNAMIC HITBOX YANG LENGKAP DENGAN INTERPOLASI
local function UpdateDynamicHitbox(ball_distance, parry_range)
    local config = getgenv().DynamicHitbox
    if not config or not config.Enabled then
        if config and config.Part then
            config.Part:Destroy()
            config.Part = nil
        end
        return
    end

    if not config.Part then
        local p = Instance.new("Part")
        p.Name = "DynamicParryVisual"
        p.Shape = Enum.PartType.Ball
        p.CanCollide = false
        p.Anchored = true
        p.CastShadow = false
        p.Material = Enum.Material.ForceField
        p.Parent = workspace
        config.Part = p
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local dist = ball_distance or 100
        local range = parry_range or 15
        local max_visual = config.MaxSize or 40
        local min_visual = config.MinSize or 5
        
        -- INTERPOLASI UKURAN: Besar saat bola jauh, kecil saat bola dekat
        local start_shrink_dist = 100
        local t = math.clamp((dist - range) / (start_shrink_dist - range), 0, 1)
        local visual_size = min_visual + (max_visual - min_visual) * t
        
        -- SMOOTH TRANSITION DENGAN LERP
        config.Part.Size = config.Part.Size:Lerp(Vector3.new(visual_size, visual_size, visual_size), 0.2)
        config.Part.CFrame = char.HumanoidRootPart.CFrame
        config.Part.Color = config.Color or Color3.new(1,1,1)
        config.Part.Transparency = config.Transparency or 0.7
    end
end

-- ==================== SISTEM NOTIFIKASI ====================
local function CreateNotificationContainer()
    local container = Instance.new("ScreenGui")
    container.Name = "RiverNotifications"
    container.ResetOnSpawn = false
    container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, _ = pcall(function() container.Parent = CoreGui end)
    if not success then
        container.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local NotificationContainer = Instance.new("Frame")
    NotificationContainer.Name = "NotificationContainer"
    NotificationContainer.Size = UDim2.new(0, 300, 0, 0)
    NotificationContainer.Position = UDim2.new(1, -310, 0, 10)
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.ClipsDescendants = false
    NotificationContainer.ZIndex = 100
    NotificationContainer.Parent = container
    NotificationContainer.AutomaticSize = Enum.AutomaticSize.Y

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = NotificationContainer

    return NotificationContainer
end

local NotificationContainer = nil
pcall(function()
    local core = CoreGui
    local existing = core:FindFirstChild("RiverNotifications")
    if existing then
        NotificationContainer = existing:FindFirstChild("NotificationContainer")
    end
end)

if not NotificationContainer then
    local existing = LocalPlayer.PlayerGui:FindFirstChild("RiverNotifications")
    if existing then
        NotificationContainer = existing:FindFirstChild("NotificationContainer")
    end
end

if not NotificationContainer then
    NotificationContainer = CreateNotificationContainer()
end

-- FUNGSI NOTIFIKASI
local function notif(text, duration, color)
    if not NotificationContainer or not NotificationContainer.Parent then
        NotificationContainer = CreateNotificationContainer()
    end

    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.BackgroundTransparency = 1
    Notification.BorderSizePixel = 0
    Notification.Name = "Notification"
    Notification.Parent = NotificationContainer
    Notification.AutomaticSize = Enum.AutomaticSize.Y
    Notification.LayoutOrder = #NotificationContainer:GetChildren()

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification

    local InnerFrame = Instance.new("Frame")
    InnerFrame.Size = UDim2.new(1, 0, 0, 0)
    InnerFrame.Position = UDim2.new(1, 310, 0, 0)
    InnerFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    InnerFrame.BackgroundTransparency = 0.1
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Name = "InnerFrame"
    InnerFrame.Parent = Notification
    InnerFrame.AutomaticSize = Enum.AutomaticSize.Y
    InnerFrame.ZIndex = 101

    local InnerUICorner = Instance.new("UICorner")
    InnerUICorner.CornerRadius = UDim.new(0, 8)
    InnerUICorner.Parent = InnerFrame
    
    local InnerStroke = Instance.new("UIStroke")
    InnerStroke.Color = color or Color3.fromRGB(0, 170, 255)
    InnerStroke.Transparency = 0.3
    InnerStroke.Thickness = 1
    InnerStroke.Parent = InnerFrame

    local Title = Instance.new("TextLabel")
    Title.Text = "River"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Parent = InnerFrame
    Title.ZIndex = 102

    local Body = Instance.new("TextLabel")
    Body.Text = text or "Notification"
    Body.TextColor3 = Color3.fromRGB(200, 200, 200)
    Body.Font = Enum.Font.Gotham
    Body.TextSize = 12
    Body.Size = UDim2.new(1, -20, 0, 0)
    Body.Position = UDim2.new(0, 10, 0, 28)
    Body.BackgroundTransparency = 1
    Body.TextXAlignment = Enum.TextXAlignment.Left
    Body.TextYAlignment = Enum.TextYAlignment.Top
    Body.TextWrapped = true
    Body.AutomaticSize = Enum.AutomaticSize.Y
    Body.Parent = InnerFrame
    Body.ZIndex = 102

    task.spawn(function()
        wait(0.05)
        local totalHeight = Title.TextBounds.Y + Body.TextBounds.Y + 20
        InnerFrame.Size = UDim2.new(1, 0, 0, totalHeight)
        Notification.Size = UDim2.new(1, 0, 0, totalHeight)
    end)

    task.spawn(function()
        local tweenIn = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0, 0, 0, 0)
        })
        tweenIn:Play()
        tweenIn.Completed:Wait()

        wait(duration or 3)

        local tweenOut = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(1, 310, 0, 0)
        })
        tweenOut:Play()

        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

-- OVERRIDE FUNGSI notif bawaan VictUI
notif = notif

-- ==================== STATE ====================
local revertedRemotes = {}
local Parry_Key = nil

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
        __grab_animation              = nil,
        __tornado_time                = tick(),
        __infinity_active             = false,
        __deathslash_active           = false,
        __timehole_active             = false,
        __is_mobile                   = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
        __antidot_parried             = false,
        __triggerbot_enabled          = false,
        __triggerbot_active           = false,
        __triggerbot_working          = false,
        __play_animation              = false,
        __randomized_accuracy_enabled = false,
        __mobile_guis                 = {},
        __manual_spam_enabled         = false,
        __auto_spam_enabled           = false,
        __spam_threshold              = 2.5,
        __auto_spam_distance_multiplier = 1.0,
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
    return #args == 7 and
        type(args[2]) == "string" and
        type(args[3]) == "number" and
        typeof(args[4]) == "CFrame" and
        type(args[5]) == "table" and
        type(args[6]) == "table" and
        type(args[7]) == "boolean"
end

function DualBypassSystem.hookRemote(remote)
    if not DualBypassSystem.__properties.__original_metatables[getrawmetatable(remote)] then
        DualBypassSystem.__properties.__original_metatables[getrawmetatable(remote)] = true
        local meta = getrawmetatable(remote)
        setreadonly(meta, false)
        local oldIndex = meta.__index
        meta.__index = function(self, key)
            if (key == "FireServer" and self:IsA("RemoteEvent")) or
               (key == "InvokeServer" and self:IsA("RemoteFunction")) then
                return function(obj, ...)
                    local args = {...}
                    if DualBypassSystem.isValidRemoteArgs(args) and not DualBypassSystem.__properties.__captured_data then
                        DualBypassSystem.__properties.__captured_data = {
                            remote = obj,
                            args   = args
                        }
                    end
                    if DualBypassSystem.isValidRemoteArgs(args) and not revertedRemotes[obj] then
                        revertedRemotes[obj] = args
                        Parry_Key = args[2]
                    end
                    return oldIndex(self, key)(obj, unpack(args))
                end
            end
            return oldIndex(self, key)
        end
        setreadonly(meta, true)
    end
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

-- ==================== SYSTEM.ANIMATION ====================
System.animation = {}

function System.animation.play_grab_parry()
    if not System.__properties.__play_animation then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    local animator = humanoid and humanoid:FindFirstChildOfClass('Animator')
    if not humanoid or not animator then return end
    local sword_name
    if getgenv().skinChangerEnabled then
        sword_name = getgenv().swordAnimations
    else
        sword_name = character:GetAttribute('CurrentlyEquippedSword')
    end
    if not sword_name then return end
    local sword_api = ReplicatedStorage.Shared.SwordAPI.Collection
    local parry_animation = sword_api.Default:FindFirstChild('GrabParry')
    if not parry_animation then return end
    local sword_data = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(sword_name)
    if not sword_data or not sword_data['AnimationType'] then return end
    for _, object in pairs(sword_api:GetChildren()) do
        if object.Name == sword_data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                local anim_type = object:FindFirstChild('GrabParry') and 'GrabParry' or 'Grab'
                parry_animation = object[anim_type]
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

-- ==================== HELPERS ====================
local function update_divisor()
    System.__properties.__divisor_multiplier = 0.59 + (System.__properties.__accuracy - 1) * (3 / 99)
end

local function linear_predict(a, b, t) return a + (b - a) * t end

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
local _CE = nil; local _LC = 0
function System.player.get_closest()
    local now = tick(); if now - _LC < 0.1 then return _CE end; _LC = now
    local md = math.huge; local ce = nil
    if not Alive then return nil end
    for _, e in pairs(Alive:GetChildren()) do
        if e ~= LocalPlayer.Character and e.PrimaryPart then
            local d = LocalPlayer:DistanceFromCharacter(e.PrimaryPart.Position)
            if d < md then md = d; ce = e end
        end
    end
    _CE = ce; return ce
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

function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera = workspace.CurrentCamera
    local success, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
    if not success then return end
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
    if not System.__properties.__first_parry_done and DualBypassSystem.__properties.__use_virtual_input_once
       and not DualBypassSystem.__properties.__virtual_input_used then
        for _, connection in pairs(getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
            connection:Fire()
        end
        System.__properties.__first_parry_done = true
        DualBypassSystem.__properties.__virtual_input_used = true
        return
    end
    local final_aim_target
    if is_mobile then
        local vp = camera.ViewportSize
        final_aim_target = {vp.X / 2, vp.Y / 2}
    else
        final_aim_target = {mouse.X, mouse.Y}
    end
    for remote, original_args in pairs(revertedRemotes) do
        local modified_args = {
            original_args[1], original_args[2], original_args[3],
            curve_cframe, event_data, final_aim_target, original_args[7]
        }
        pcall(function()
            if remote:IsA('RemoteEvent') then remote:FireServer(unpack(modified_args))
            elseif remote:IsA('RemoteFunction') then remote:InvokeServer(unpack(modified_args)) end
        end)
    end
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries = System.__properties.__parries + 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then System.__properties.__parries = System.__properties.__parries - 1 end
    end)
end

function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    local camera = workspace.CurrentCamera
    local curve_cframe = System.curve.get_cframe()
    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok2, sp = pcall(function() return camera:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok2 then event_data[entity.Name] = sp end
            end
        end
    end
    local is_mobile = System.__properties.__is_mobile
    local final_aim_target
    if is_mobile then
        local vp = camera.ViewportSize
        final_aim_target = {vp.X / 2, vp.Y / 2}
    else
        local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
        final_aim_target = ok and {mouse.X, mouse.Y} or {0, 0}
    end
    for remote, original_args in pairs(revertedRemotes) do
        local modified_args = {
            original_args[1], original_args[2], original_args[3],
            curve_cframe, event_data, final_aim_target, original_args[7]
        }
        pcall(function()
            if remote:IsA('RemoteEvent') then remote:FireServer(unpack(modified_args))
            elseif remote:IsA('RemoteFunction') then remote:InvokeServer(unpack(modified_args)) end
        end)
    end
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries = System.__properties.__parries + 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then System.__properties.__parries = System.__properties.__parries - 1 end
    end)
end

function System.parry.execute_action()
    System.animation.play_grab_parry()
    System.parry.execute()
end

-- ==================== SYSTEM.DETECTION ====================
System.detection = {
    __ball_properties = {
        __aerodynamic_time = tick(),
        __last_warping = tick(),
        __lerp_radians = 0,
        __curving      = tick()
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

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
    local primary = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
    local ball = System.ball.get(); if not ball or not primary then return end
    local zoom = ball:FindFirstChild("zoomies"); if not zoom then return end
    local spd  = zoom.VectorVelocity.Magnitude
    local dist = (primary.Position - ball.Position).Magnitude
    local pings = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local bdt  = 15 - math.min(dist / 1000, 15) + math.min(spd / 100, 40)
    if spd > 1 and (dist / spd - pings/1000) > pings/10 then bdt = math.max(bdt - 5, 15) end
    if b ~= primary and dist > bdt then System.detection.__ball_properties.__curving = tick() end
end)

-- ==================== SYSTEM.AUTOPARRY (LENGKAP DENGAN TRIGGERBOT, ANTI-DOT, DLL) ====================
System.autoparry = {}

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end
    System.__properties.__connections.__autoparry = RunService.RenderStepped:Connect(function()
        if not System.__properties.__autoparry_enabled
           or not LocalPlayer.Character
           or not LocalPlayer.Character.PrimaryPart then return end

        local balls    = System.ball.get_all()
        local one_ball = System.ball.get()
        local any_triggerbot_active = false
        local closest_distance = math.huge

        local training_ball = nil
        if workspace:FindFirstChild("TrainingBalls") then
            for _, i in pairs(workspace.TrainingBalls:GetChildren()) do
                if i:GetAttribute("realBall") then training_ball = i; break end
            end
        end

        for _, ball in pairs(balls) do
            if not ball then continue end
            local zoom = ball:FindFirstChild("zoomies"); if not zoom then continue end
            ball:GetAttributeChangedSignal("target"):Once(function()
                System.__properties.__parried = false
                System.__properties.__antidot_parried = false
            end)
            if System.__properties.__parried then continue end

            local bt   = ball:GetAttribute("target")
            local vel  = zoom.VectorVelocity
            local dist = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
            local pth  = math.clamp(ping / 10, 5, 17)
            local spd  = vel.Magnitude; if spd <= 0 then continue end

            local csd = math.min(math.max(spd - 9.5, 0), 650)
            local pa  = pth + math.max(spd / ((2.5 + csd * 0.002) * System.__properties.__divisor_multiplier), 9.5)
            if getgenv().HitboxEnabled then pa = pa + (getgenv().HitboxSize or 0) end

            -- PANGGIL DYNAMIC HITBOX VISUAL
            UpdateDynamicHitbox(dist, pa)

            local dtp = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit:Dot(vel.Unit)
            if bt ~= LocalPlayer.Name and dtp < 0.1 then continue end

            if getgenv().HighSpeedProtection and spd > 1500 then
                pa = pa * math.clamp(1 + (spd - 1500) / 1000, 1.5, 3.5)
            elseif spd > 2000 then pa = pa * 2.0 end

            -- CEK CURVED BALL
            local curved = System.detection.is_curved()
            
            if ball:FindFirstChild("AeroDynamicSlashVFX") then
                ball.AeroDynamicSlashVFX:Destroy(); System.__properties.__tornado_time = tick()
            end
            if Runtime:FindFirstChild("Tornado") then
                if (tick() - System.__properties.__tornado_time) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then continue end
            end
            if one_ball and one_ball:GetAttribute("target") == LocalPlayer.Name and curved then continue end
            if ball:FindFirstChild("ComboCounter") then continue end
            if LocalPlayer.Character.PrimaryPart:FindFirstChild("SingularityCape") then continue end
            if System.__config.__detections.__infinity   and System.__properties.__infinity_active   then continue end
            if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
            if System.__config.__detections.__timehole   and System.__properties.__timehole_active   then continue end

            -- TRIGGERBOT SYSTEM (DARI SCRIPT PERTAMA)
            local closest_player = System.player.get_closest()
            local should_use_triggerbot = false
            
            if closest_player and bt == closest_player.Name then
                local distance_to_closest = (LocalPlayer.Character.PrimaryPart.Position - closest_player.PrimaryPart.Position).Magnitude
                closest_distance = math.min(closest_distance, distance_to_closest)
                
                if distance_to_closest <= 35 then
                    should_use_triggerbot = true
                    System.__properties.__triggerbot_active = true
                    System.__properties.__triggerbot_working = true
                    any_triggerbot_active = true
                end
            else
                should_use_triggerbot = false
                System.__properties.__triggerbot_active = false
                System.__properties.__triggerbot_working = false
            end
            
            if bt ~= LocalPlayer.Name and bt ~= (closest_player and closest_player.Name) then
                should_use_triggerbot = false
                System.__properties.__triggerbot_active = false
                System.__properties.__triggerbot_working = false
            end

            -- ANTI-DOT PROTECTION (DARI SCRIPT PERTAMA)
            if getgenv().AntiDotEnabled and closest_player and not System.__properties.__antidot_parried then
                local player_distance = (LocalPlayer.Character.PrimaryPart.Position - closest_player.PrimaryPart.Position).Magnitude
                
                if player_distance <= 30 and dtp > 0.75 then
                    if bt == LocalPlayer.Name and dist <= 30 then
                        System.parry.execute_action()
                        System.__properties.__parried = true
                        System.__properties.__antidot_parried = true
                    end
                end
            end

            -- COOLDOWN PROTECTION (DARI SCRIPT PERTAMA)
            if getgenv().CooldownProtection and bt == LocalPlayer.Name and dist <= pa then
                local ParryCD = LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
                if ParryCD.Offset.Y < 0.4 then
                    ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                    continue
                end
            end

            -- AUTO ABILITY SYSTEM (DARI SCRIPT PERTAMA)
            if getgenv().AutoAbility and bt == LocalPlayer.Name and dist <= pa then
                local AbilityCD = LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                if AbilityCD.Offset.Y == 0.5 then
                    if (LocalPlayer.Character.Abilities:FindFirstChild("Raging Deflection") and LocalPlayer.Character.Abilities["Raging Deflection"].Enabled) or
                       (LocalPlayer.Character.Abilities:FindFirstChild("Rapture") and LocalPlayer.Character.Abilities["Rapture"].Enabled) or
                       (LocalPlayer.Character.Abilities:FindFirstChild("Calming Deflection") and LocalPlayer.Character.Abilities["Calming Deflection"].Enabled) or
                       (LocalPlayer.Character.Abilities:FindFirstChild("Aerodynamic Slash") and LocalPlayer.Character.Abilities["Aerodynamic Slash"].Enabled) or
                       (LocalPlayer.Character.Abilities:FindFirstChild("Fracture") and LocalPlayer.Character.Abilities["Fracture"].Enabled) or
                       (LocalPlayer.Character.Abilities:FindFirstChild("Death Slash") and LocalPlayer.Character.Abilities["Death Slash"].Enabled) then
                        System.__properties.__parried = true
                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                        task.wait(2.432)
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                        continue
                    end
                end
            end

            -- TRIGGERBOT PARRY (DARI SCRIPT PERTAMA)
            if should_use_triggerbot and getgenv().TriggerbotEnabled then
                if bt == LocalPlayer.Name and dist <= pa then
                    if getgenv().AutoParryMode == "Keypress" then
                        System.parry.keypress()
                    else
                        System.parry.execute_action()
                    end
                    System.__properties.__parried = true
                end
            else
                -- AUTO PARRY NORMAL
                if bt == LocalPlayer.Name and dist <= pa then
                    if getgenv().AutoParryMode == "Keypress" then
                        System.parry.keypress()
                    else
                        System.parry.execute_action()
                    end
                    System.__properties.__parried = true
                end
            end

            local lp = tick()
            repeat RunService.RenderStepped:Wait() until (tick() - lp) >= 1 or not System.__properties.__parried
            System.__properties.__parried = false
            System.__properties.__antidot_parried = false
        end

        -- TRAINING BALL HANDLER
        if training_ball then
            local zoom = training_ball:FindFirstChild("zoomies")
            if zoom and not System.__properties.__training_parried then
                training_ball:GetAttributeChangedSignal("target"):Once(function()
                    System.__properties.__training_parried = false
                end)
                local bt   = training_ball:GetAttribute("target")
                local vel  = zoom.VectorVelocity
                local dist = LocalPlayer:DistanceFromCharacter(training_ball.Position)
                local spd  = vel.Magnitude
                local png  = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                local pth  = math.clamp(png / 10, 5, 17)
                local csd  = math.min(math.max(spd - 9.5, 0), 650)
                local pa   = pth + math.max(spd / ((2.4 + csd * 0.002) * System.__properties.__divisor_multiplier), 9.5)
                if getgenv().HitboxEnabled then pa = pa + (getgenv().HitboxSize or 0) end
                if spd > 2000 then pa = pa * 2.0 end
                UpdateDynamicHitbox(dist, pa)
                if bt == LocalPlayer.Name and dist <= pa then
                    if getgenv().AutoParryMode == "Keypress" then
                        System.parry.keypress()
                    else
                        System.parry.execute_action()
                    end
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

-- ==================== RANDOMIZED ACCURACY ====================
local function update_randomized_accuracy()
    if not System.__properties.__randomized_accuracy_enabled then return end
    
    local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(ping_str:match("%d+")) or 0
    
    if ping >= 90 then
        System.__properties.__accuracy = 4
    elseif ping <= 50 then
        System.__properties.__accuracy = math.random(70, 100)
    end
    
    update_divisor()
end

task.spawn(function()
    while task.wait(1) do
        if System.__properties.__randomized_accuracy_enabled then
            update_randomized_accuracy()
        end
    end
end)

-- ==================== MANUAL SPAM SYSTEM ====================
local manualSpamThread = nil

function System.manual_spam_start()
    System.__properties.__manual_spam_enabled = true

    local parry_keypress = System.parry.keypress
    local parry_execute = System.parry.execute
    local play_animation = System.animation.play_grab_parry

    manualSpamThread = coroutine.create(function()
        local last_spam = os.clock()
        local threshold = 0.005 -- 200 CPS

        while System.__properties.__manual_spam_enabled do
            local now = os.clock()
            if now - last_spam >= threshold then
                last_spam = now
                if getgenv().ManualSpamMode == "Keypress" then
                    parry_keypress()
                else
                    parry_execute()
                    if getgenv().ManualSpamAnimationFix then
                        play_animation()
                    end
                end
            end
            task.wait(0)
        end
    end)

    coroutine.resume(manualSpamThread)
end

function System.manual_spam_stop()
    System.__properties.__manual_spam_enabled = false
    manualSpamThread = nil
end

-- ==================== AUTO SPAM SYSTEM ====================
local autoSpamThread = nil

function System.auto_spam_start()
    System.__properties.__auto_spam_enabled = true

    autoSpamThread = coroutine.create(function()
        while System.__properties.__auto_spam_enabled do
            local ball = System.ball.get()
            local closest = System.player.get_closest()
            
            if ball and closest and closest.PrimaryPart then
                local ball_target = ball:GetAttribute("target")
                local dist_to_ball = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
                local dist_to_player = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Magnitude
                
                if ball_target == LocalPlayer.Name or ball_target == closest.Name then
                    if dist_to_ball <= 35 and dist_to_player <= 35 then
                        if getgenv().AutoSpamMode == "Keypress" then
                            System.parry.keypress()
                        else
                            System.parry.execute()
                            if getgenv().AutoSpamAnimationFix then
                                System.animation.play_grab_parry()
                            end
                        end
                    end
                end
            end
            task.wait(0)
        end
    end)

    coroutine.resume(autoSpamThread)
end

function System.auto_spam_stop()
    System.__properties.__auto_spam_enabled = false
    autoSpamThread = nil
end

-- ==================== MOBILE UI (DARI SCRIPT PERTAMA) ====================
local function create_mobile_button(name, position_y, color)
    local gui = Instance.new('ScreenGui')
    gui.Name = 'Sigma' .. name .. 'Mobile'
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    
    local button = Instance.new('TextButton')
    button.Size = UDim2.new(0, 140, 0, 50)
    button.Position = UDim2.new(0.5, -70, position_y, 0)
    button.BackgroundTransparency = 1
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Draggable = true
    button.AutoButtonColor = false
    button.ZIndex = 2
    
    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bg.Parent = button
    
    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg
    
    local stroke = Instance.new('UIStroke')
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = bg
    
    local text = Instance.new('TextLabel')
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.ZIndex = 3
    text.Parent = button
    
    button.Parent = gui
    
    return {gui = gui, button = button, text = text, bg = bg}
end

local function create_curve_selector_mobile()
    local gui = Instance.new('ScreenGui')
    gui.Name = 'SigmaCurveSelectorMobile'
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    gui.Parent = CoreGui
    
    local main_frame = Instance.new('Frame')
    main_frame.Size = UDim2.new(0, 140, 0, 40)
    main_frame.Position = UDim2.new(0.5, -70, 0.12, 0)
    main_frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    main_frame.BorderSizePixel = 0
    main_frame.AnchorPoint = Vector2.new(0.5, 0)
    main_frame.ZIndex = 5
    main_frame.Active = true
    main_frame.Selectable = true
    main_frame.Draggable = true
    main_frame.Parent = gui
    
    local main_corner = Instance.new('UICorner')
    main_corner.CornerRadius = UDim.new(0, 8)
    main_corner.Parent = main_frame
    
    local main_stroke = Instance.new('UIStroke')
    main_stroke.Color = Color3.fromRGB(60, 60, 60)
    main_stroke.Thickness = 1
    main_stroke.Parent = main_frame

    local header = Instance.new('Frame')
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundTransparency = 1
    header.ZIndex = 6
    header.Parent = main_frame
    
    local header_text = Instance.new('TextLabel')
    header_text.Size = UDim2.new(1, -35, 1, 0)
    header_text.Position = UDim2.new(0, 12, 0, 0)
    header_text.BackgroundTransparency = 1
    header_text.Text = "CURVE"
    header_text.Font = Enum.Font.Gotham
    header_text.TextSize = 11
    header_text.TextColor3 = Color3.fromRGB(0, 170, 255)
    header_text.TextXAlignment = Enum.TextXAlignment.Left
    header_text.ZIndex = 7
    header_text.Parent = header

    local toggle_btn = Instance.new('TextButton')
    toggle_btn.Size = UDim2.new(0, 24, 0, 24)
    toggle_btn.Position = UDim2.new(1, -32, 0.5, -12)
    toggle_btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    toggle_btn.Text = "−"
    toggle_btn.Font = Enum.Font.GothamBold
    toggle_btn.TextSize = 14
    toggle_btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    toggle_btn.AutoButtonColor = false
    toggle_btn.ZIndex = 7
    toggle_btn.Parent = header
    
    local toggle_corner = Instance.new('UICorner')
    toggle_corner.CornerRadius = UDim.new(0, 4)
    toggle_corner.Parent = toggle_btn
    
    local buttons_container = Instance.new('Frame')
    buttons_container.Size = UDim2.new(1, -16, 0, 0)
    buttons_container.Position = UDim2.new(0, 8, 0, 48)
    buttons_container.BackgroundTransparency = 1
    buttons_container.ClipsDescendants = true
    buttons_container.ZIndex = 6
    buttons_container.Parent = main_frame
    
    local list_layout = Instance.new('UIListLayout')
    list_layout.Padding = UDim.new(0, 4)
    list_layout.FillDirection = Enum.FillDirection.Vertical
    list_layout.SortOrder = Enum.SortOrder.LayoutOrder
    list_layout.Parent = buttons_container
    
    local buttons = {}
    local current_selected = nil

    for i, curve_name in ipairs(System.__config.__curve_names) do
        if not curve_name then continue end
        local btn_container = Instance.new('Frame')
        btn_container.Size = UDim2.new(1, 0, 0, 32)
        btn_container.BackgroundTransparency = 1
        btn_container.ZIndex = 7
        btn_container.LayoutOrder = i
        btn_container.Parent = buttons_container
        
        local btn = Instance.new('TextButton')
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 8
        btn.Parent = btn_container
        
        local btn_corner = Instance.new('UICorner')
        btn_corner.CornerRadius = UDim.new(0, 6)
        btn_corner.Parent = btn
        
        local btn_stroke = Instance.new('UIStroke')
        btn_stroke.Color = Color3.fromRGB(0, 170, 255)
        btn_stroke.Thickness = 1
        btn_stroke.Parent = btn

        local indicator = Instance.new('Frame')
        indicator.Name = "indicator"
        indicator.Size = UDim2.new(0, 3, 0, 20)
        indicator.Position = UDim2.new(0, 6, 0.5, -10)
        indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.ZIndex = 10
        indicator.Parent = btn
        
        local indicator_corner = Instance.new('UICorner')
        indicator_corner.CornerRadius = UDim.new(1, 0)
        indicator_corner.Parent = indicator
        
        local btn_text = Instance.new('TextLabel')
        btn_text.Size = UDim2.new(1, -20, 1, 0)
        btn_text.Position = UDim2.new(0, 16, 0, 0)
        btn_text.BackgroundTransparency = 1
        btn_text.Text = curve_name
        btn_text.Font = Enum.Font.Gotham
        btn_text.TextSize = 11
        btn_text.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn_text.TextXAlignment = Enum.TextXAlignment.Left
        btn_text.ZIndex = 9
        btn_text.Parent = btn
        
        buttons[i] = {
            button = btn, 
            stroke = btn_stroke, 
            text = btn_text,
            indicator = indicator,
            container = btn_container
        }
        
        btn.MouseButton1Click:Connect(function()
            System.__properties.__curve_mode = i
            if current_selected then
                current_selected.text.TextColor3 = Color3.fromRGB(150, 150, 150)
                current_selected.stroke.Color = Color3.fromRGB(60, 60, 60)
                current_selected.indicator.Visible = false
            end
            btn_text.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn_stroke.Color = Color3.fromRGB(0, 170, 255)
            indicator.Visible = true
            current_selected = buttons[i]
        end)
    end

    local is_expanded = true
    local curve_count = #System.__config.__curve_names
    local expanded_height = 48 + (curve_count * 32) + ((curve_count - 1) * 4) + 12
    local minimized_height = 40
    
    buttons_container.Size = UDim2.new(1, -16, 0, (curve_count * 32) + ((curve_count - 1) * 4))
    main_frame.Size = UDim2.new(0, 140, 0, expanded_height)
    
    toggle_btn.MouseButton1Click:Connect(function()
        is_expanded = not is_expanded
        toggle_btn.Text = is_expanded and "−" or "+"
        
        TweenService:Create(main_frame, TweenInfo.new(0.25), {
            Size = UDim2.new(0, 140, 0, is_expanded and expanded_height or minimized_height)
        }):Play()
        
        TweenService:Create(buttons_container, TweenInfo.new(0.25), {
            Size = UDim2.new(1, -16, 0, is_expanded and (curve_count * 32) + ((curve_count - 1) * 4) or 0)
        }):Play()
    end)

    return {gui = gui, main_frame = main_frame}
end

-- ==================== EVENTS ====================
ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c, d)
    System.__properties.__deathslash_active = d or false
end)
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    System.__properties.__infinity_active = b or false
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleActivate"].OnClientEvent:Connect(function(...)
    local args = {...}
    local player = args[1]
    if player == LocalPlayer or player == LocalPlayer.Name then
        System.__properties.__timehole_active = true
    end
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleDeactivate"].OnClientEvent:Connect(function()
    System.__properties.__timehole_active = false
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

local mainSection = Tab1:AddSection("Main")

mainSection:AddToggle({
    Title   = "Auto Parry",
    Content = "Aktifkan auto parry otomatis",
    Default = false,
    Callback = function(state)
        System.__properties.__autoparry_enabled = state
        if state then
            System.autoparry.start()
            if getgenv().AutoParryNotify and not isFirstLoad then
                notif("Auto Parry: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            System.autoparry.stop()
            if getgenv().AutoParryNotify and not isFirstLoad then
                notif("Auto Parry: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

mainSection:AddDropdown({
    Title   = "Parry Mode",
    Options = {"Auto", "Keypress"},
    Default = "Auto",
    Callback = function(val)
        getgenv().AutoParryMode = val
        if not isFirstLoad then
            notif("Mode: " .. val, 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

mainSection:AddSlider({
    Title     = "Parry Accuracy",
    Content   = "Tinggi = parry lebih awal",
    Min       = 1,
    Max       = 100,
    Default   = 1,
    Increment = 1,
    Callback  = function(val)
        System.__properties.__accuracy = val
        update_divisor()
    end
})

mainSection:AddToggle({
    Title   = "Play Parry Animation",
    Content = "Mainkan animasi grab saat parry",
    Default = false,
    Callback = function(state)
        System.__properties.__play_animation = state
    end
})

mainSection:AddToggle({
    Title   = "Randomized Accuracy",
    Content = "Auto ubah akurasi berdasarkan ping",
    Default = false,
    Callback = function(state)
        System.__properties.__randomized_accuracy_enabled = state
        if not isFirstLoad then
            notif("Randomized Accuracy: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

mainSection:AddToggle({
    Title   = "Notify",
    Content = "Tampilkan notifikasi saat toggle",
    Default = true,
    Callback = function(state)
        getgenv().AutoParryNotify = state
    end
})

-- SECTION: Advanced Features (DARI SCRIPT PERTAMA)
local advancedSection = Tab1:AddSection("Advanced Features")

advancedSection:AddToggle({
    Title   = "Triggerbot",
    Content = "Parry otomatis saat musuh dekat",
    Default = false,
    Callback = function(state)
        getgenv().TriggerbotEnabled = state
        System.__properties.__triggerbot_enabled = state
        if not isFirstLoad then
            notif("Triggerbot: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

advancedSection:AddToggle({
    Title   = "Anti-Dot Protection",
    Content = "Parry otomatis saat bola menuju Anda",
    Default = false,
    Callback = function(state)
        getgenv().AntiDotEnabled = state
        if not isFirstLoad then
            notif("Anti-Dot: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

advancedSection:AddToggle({
    Title   = "Cooldown Protection",
    Content = "Hindari parry saat cooldown",
    Default = false,
    Callback = function(state)
        getgenv().CooldownProtection = state
        if not isFirstLoad then
            notif("Cooldown Protection: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

advancedSection:AddToggle({
    Title   = "Auto Ability",
    Content = "Gunakan ability otomatis",
    Default = false,
    Callback = function(state)
        getgenv().AutoAbility = state
        if not isFirstLoad then
            notif("Auto Ability: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
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
        if not isFirstLoad then
            notif("Hitbox Extender: " .. (state and "ON" or "OFF"), 2,
                state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

hitboxSection:AddSlider({
    Title     = "Hitbox Size",
    Content   = "Tambahan radius hitbox (studs)",
    Min       = 0,
    Max       = 50,
    Default   = 0,
    Increment = 1,
    Callback  = function(val)
        getgenv().HitboxSize = val
    end
})

hitboxSection:AddToggle({
    Title   = "High Speed Protection",
    Content = "Scale accuracy saat bola sangat cepat",
    Default = false,
    Callback = function(state)
        getgenv().HighSpeedProtection = state
        if not isFirstLoad then
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

-- ==================== TAB 2: SPAM ====================
local Tab2 = Window:AddTab({ Name = "Spam", Icon = "zap" })

local manualSpamSection = Tab2:AddSection("Manual Spam")

manualSpamSection:AddToggle({
    Title   = "Manual Spam",
    Content = "Spam parry terus menerus",
    Default = false,
    Callback = function(state)
        if System.__properties.__is_mobile then
            if state then
                if not System.__properties.__mobile_guis.manual_spam then
                    local mobile_btn = create_mobile_button("Spam", 0.8, Color3.fromRGB(255, 255, 255))
                    System.__properties.__mobile_guis.manual_spam = mobile_btn
                    
                    mobile_btn.button.MouseButton1Click:Connect(function()
                        System.__properties.__manual_spam_enabled = not System.__properties.__manual_spam_enabled
                        if System.__properties.__manual_spam_enabled then
                            System.manual_spam_start()
                            mobile_btn.text.Text = "ON"
                            mobile_btn.text.TextColor3 = Color3.fromRGB(0, 255, 0)
                        else
                            System.manual_spam_stop()
                            mobile_btn.text.Text = "Spam"
                            mobile_btn.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end)
                end
            else
                System.__properties.__manual_spam_enabled = false
                System.manual_spam_stop()
                if System.__properties.__mobile_guis.manual_spam then
                    System.__properties.__mobile_guis.manual_spam.gui:Destroy()
                    System.__properties.__mobile_guis.manual_spam = nil
                end
            end
        else
            System.__properties.__manual_spam_enabled = state
            if state then
                System.manual_spam_start()
                if getgenv().ManualSpamNotify and not isFirstLoad then
                    notif("Manual Spam: ON", 2, Color3.fromRGB(0, 255, 0))
                end
            else
                System.manual_spam_stop()
                if getgenv().ManualSpamNotify and not isFirstLoad then
                    notif("Manual Spam: OFF", 2, Color3.fromRGB(255, 0, 0))
                end
            end
        end
    end
})

manualSpamSection:AddDropdown({
    Title   = "Mode",
    Options = {"Auto", "Keypress"},
    Default = "Auto",
    Callback = function(val)
        getgenv().ManualSpamMode = val
    end
})

manualSpamSection:AddToggle({
    Title   = "Animation Fix",
    Content = "Mainkan animasi saat spam",
    Default = false,
    Callback = function(state)
        getgenv().ManualSpamAnimationFix = state
    end
})

manualSpamSection:AddToggle({
    Title   = "Notify",
    Content = "Tampilkan notifikasi",
    Default = true,
    Callback = function(state)
        getgenv().ManualSpamNotify = state
    end
})

local autoSpamSection = Tab2:AddSection("Auto Spam")

autoSpamSection:AddToggle({
    Title   = "Auto Spam",
    Content = "Spam otomatis saat musuh dekat",
    Default = false,
    Callback = function(state)
        System.__properties.__auto_spam_enabled = state
        if state then
            System.auto_spam_start()
            if getgenv().AutoSpamNotify and not isFirstLoad then
                notif("Auto Spam: ON", 2, Color3.fromRGB(0, 255, 0))
            end
        else
            System.auto_spam_stop()
            if getgenv().AutoSpamNotify and not isFirstLoad then
                notif("Auto Spam: OFF", 2, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

autoSpamSection:AddDropdown({
    Title   = "Mode",
    Options = {"Auto", "Keypress"},
    Default = "Auto",
    Callback = function(val)
        getgenv().AutoSpamMode = val
    end
})

autoSpamSection:AddToggle({
    Title   = "Animation Fix",
    Content = "Mainkan animasi saat spam",
    Default = false,
    Callback = function(state)
        getgenv().AutoSpamAnimationFix = state
    end
})

autoSpamSection:AddToggle({
    Title   = "Notify",
    Content = "Tampilkan notifikasi",
    Default = true,
    Callback = function(state)
        getgenv().AutoSpamNotify = state
    end
})

autoSpamSection:AddSlider({
    Title     = "Parry Threshold",
    Content   = "Batas maksimal parry per detik",
    Min       = 1,
    Max       = 10,
    Default   = 5,
    Increment = 0.5,
    Callback  = function(val)
        System.__properties.__spam_threshold = val
    end
})

-- ==================== TAB 3: CURVE ====================
local Tab3 = Window:AddTab({ Name = "Curve", Icon = "loop" })

local curveSection = Tab3:AddSection("Curve Mode")

curveSection:AddDropdown({
    Title   = "Curve Mode",
    Options = System.__config.__curve_names,
    Default = "Camera",
    Callback = function(val)
        for i, name in ipairs(System.__config.__curve_names) do
            if name == val then System.__properties.__curve_mode = i; break end
        end
        if not isFirstLoad then
            notif("Curve: " .. val, 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

curveSection:AddParagraph({
    Title   = "Mode Info",
    Content = "Camera: arah kamera\nRandom: arah acak\nAccelerated: ke atas sedikit\nBackwards: arah balik\nSlow: bawah ekstrem\nHigh: atas ekstrem"
})

-- SECTION: Hotkey
local hotkeySection = Tab3:AddSection("Curve Hotkeys")

hotkeySection:AddToggle({
    Title   = "Enable Curve Hotkeys",
    Content = "Tekan 1-6 untuk ganti curve mode",
    Default = false,
    Callback = function(state)
        getgenv().CurveHotkeyEnabled = state
        if not isFirstLoad then
            notif("Curve Hotkeys: " .. (state and "ON" or "OFF"), 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

hotkeySection:AddParagraph({
    Title   = "Hotkey Map",
    Content = "1=Camera | 2=Random | 3=Accelerated\n4=Backwards | 5=Slow | 6=High"
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

-- ==================== TAB 4: VISUALS (DENGAN COLOR PICKER) ====================
local Tab4 = Window:AddTab({ Name = "Visuals", Icon = "eyes" })

local visualSection = Tab4:AddSection("Dynamic Hitbox Visual")

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
    Title     = "Max Size",
    Content   = "Ukuran sphere saat bola jauh",
    Min       = 5,
    Max       = 80,
    Default   = 40,
    Increment = 1,
    Callback  = function(val)
        getgenv().DynamicHitbox.MaxSize = val
    end
})

visualSection:AddSlider({
    Title     = "Min Size",
    Content   = "Ukuran sphere saat bola dekat",
    Min       = 1,
    Max       = 20,
    Default   = 5,
    Increment = 1,
    Callback  = function(val)
        getgenv().DynamicHitbox.MinSize = val
    end
})

visualSection:AddSlider({
    Title     = "Transparency",
    Content   = "0 = solid | 9 = hampir tak terlihat",
    Min       = 0,
    Max       = 9,
    Default   = 7,
    Increment = 1,
    Callback  = function(val)
        getgenv().DynamicHitbox.Transparency = val / 10
    end
})

-- COLOR PICKER (DARI SCRIPT PERTAMA)
visualSection:AddParagraph({
    Title   = "Color Picker",
    Content = "Gunakan format RGB: (R,G,B)"
})

visualSection:AddTextbox({
    Title   = "Red (0-255)",
    Content = "Nilai merah",
    Default = "255",
    Callback = function(val)
        local r = tonumber(val) or 255
        local g = getgenv().DynamicHitbox.Color.G * 255
        local b = getgenv().DynamicHitbox.Color.B * 255
        getgenv().DynamicHitbox.Color = Color3.fromRGB(r, g, b)
    end
})

visualSection:AddTextbox({
    Title   = "Green (0-255)",
    Content = "Nilai hijau",
    Default = "255",
    Callback = function(val)
        local r = getgenv().DynamicHitbox.Color.R * 255
        local g = tonumber(val) or 255
        local b = getgenv().DynamicHitbox.Color.B * 255
        getgenv().DynamicHitbox.Color = Color3.fromRGB(r, g, b)
    end
})

visualSection:AddTextbox({
    Title   = "Blue (0-255)",
    Content = "Nilai biru",
    Default = "255",
    Callback = function(val)
        local r = getgenv().DynamicHitbox.Color.R * 255
        local g = getgenv().DynamicHitbox.Color.G * 255
        local b = tonumber(val) or 255
        getgenv().DynamicHitbox.Color = Color3.fromRGB(r, g, b)
    end
})

-- ==================== TAB 5: MISC ====================
local Tab5 = Window:AddTab({ Name = "Misc", Icon = "settings" })

local miscSection = Tab5:AddSection("Controls")

miscSection:AddButton({
    Title    = "Stop All",
    Callback = function()
        System.__properties.__autoparry_enabled = false
        System.autoparry.stop()
        System.__properties.__manual_spam_enabled = false
        System.manual_spam_stop()
        System.__properties.__auto_spam_enabled = false
        System.auto_spam_stop()
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
        notif("River Bladeball aktif!", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- SECTION: Mobile Settings
local mobileSection = Tab5:AddSection("Mobile Settings")

mobileSection:AddToggle({
    Title   = "Curve Selector (Mobile)",
    Content = "Tampilkan curve selector untuk mobile",
    Default = false,
    Callback = function(state)
        if System.__properties.__is_mobile then
            if state then
                if not System.__properties.__mobile_guis.curve_selector then
                    System.__properties.__mobile_guis.curve_selector = create_curve_selector_mobile()
                end
            else
                if System.__properties.__mobile_guis.curve_selector then
                    System.__properties.__mobile_guis.curve_selector.gui:Destroy()
                    System.__properties.__mobile_guis.curve_selector = nil
                end
            end
        else
            notif("Fitur ini hanya untuk mobile!", 2, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- ==================== FINAL ====================
task.delay(1, function()
    isFirstLoad = false
end)

task.delay(1.5, function()
    notif("River Bladeball FULL Version loaded! (F3 = toggle UI)", 4, Color3.fromRGB(0, 170, 255))
end)

return Window
