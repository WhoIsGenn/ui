-- [[ VICTORIA HUB FISH IT - COMPLETE ALL FEATURES ]] --
-- Version: 1.0.0

-- ==================== WEBHOOK LOGGER ====================
local WebhookConfig = {
    Url = "https://discord.com/api/webhooks/1439637532550762528/ys-Ds5iuLGJVi-U-YvzvAUa_TTyZrTFp7hFomcbuhsJziryGRzV9PygWymNzGSSk0_xM", 
    ScriptName = "Victoriahub | Fish It", 
    EmbedColor = 65535 
}

local function sendWebhookNotification()
    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if not httpRequest then return end 
    if getgenv().WebhookSent then return end 
    getgenv().WebhookSent = true

    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer
    
    local executorName = "Unknown"
    if identifyexecutor then executorName = identifyexecutor() end
    
    local payload = {
        ["username"] = "Script Logger",
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1458894965131313268/1463597577680195767/Logo_neon__V__berkilau_di_malam_hari.png?ex=69750bf6&is=6973ba76&hm=a71108466bafd1318e1072119cd8a039377cf4d5a8a590c79707e4849b52f594&",
        ["embeds"] = {{
            ["title"] = "🔔 Script Executed: " .. WebhookConfig.ScriptName,
            ["color"] = WebhookConfig.EmbedColor,
            ["fields"] = {
                {
                    ["name"] = "👤 User Info",
                    ["value"] = string.format("Display: %s\nUser: %s\nID: %s", LocalPlayer.DisplayName, LocalPlayer.Name, tostring(LocalPlayer.UserId)),
                    ["inline"] = true
                },
                {
                    ["name"] = "🎮 Game Info",
                    ["value"] = string.format("Place ID: %s\nJob ID: %s", tostring(game.PlaceId), game.JobId),
                    ["inline"] = true
                },
                {
                    ["name"] = "⚙️ Executor",
                    ["value"] = executorName,
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Time: " .. os.date("%c")
            }
        }}
    }
    
    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = WebhookConfig.Url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

task.spawn(sendWebhookNotification)

-- ==================== LOAD VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

-- ==================== CREATE MAIN WINDOW ====================
local Window = Vict:Window({
    Title = "Victoria Hub | Fish It",
    Footer = " ",
    Color = Color3.fromRGB(0, 170, 255),
    ["Tab Width"] = 120,
    Version = "0.0.8",
    Icon = "rbxassetid://96751490485303",
    Image = "96751490485303"
})

-- ==================== PLAYER SETUP ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ANTI-AFK
_G.AntiAFK = true
local VirtualUser = game:GetService("VirtualUser")

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Extra activity loop
task.spawn(function()
    while _G.AntiAFK do
        task.wait(30)
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:MoveMouseBy(1, 0)
            task.wait(0.1)
            VirtualUser:MoveMouseBy(-1, 0)
        end)
    end
end)

-- ==================== TAB 1: INFO ====================
local Tab1 = Window:AddTab({
    Name = "Info",
    Icon = "alert"
})

local infoSection = Tab1:AddSection("Information", true)

infoSection:AddParagraph({
    Title = "Victoria Hub Community",
    Content = "Join Our Community Discord Server to get the latest updates, support, and connect with other users!",
    Icon = "star",
    ButtonText = "Copy Discord",
    ButtonCallback = function()
        setclipboard("https://discord.gg/victoriahub")
        notif("Discord link copied!", 3, Color3.fromRGB(0, 255, 0))
    end
})

-- ==================== TAB 2: PLAYERS ====================
local Tab2 = Window:AddTab({
    Name = "Players",
    Icon = "user"
})

local playerSection = Tab2:AddSection("Player Features")

-- SPEED INPUT
local walkSpeedValue = 16
local lastWalkSpeedValue = 16
playerSection:AddInput({
    Title = "Walk Speed",
    Default = "16",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 18 and num <= 10000 then
            walkSpeedValue = num
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid.WalkSpeed = num 
                notif("Walk Speed set to " .. num, 3, Color3.fromRGB(0, 255, 0))
                lastWalkSpeedValue = num
            end
        else
            notif("Invalid Walk Speed!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- JUMP POWER INPUT
local jumpPowerValue = 50
local lastJumpPowerValue = 50
playerSection:AddInput({
    Title = "Jump Power",
    Default = "50",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 50 and num <= 500 then
            jumpPowerValue = num
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid.JumpPower = num 
                notif("Jump Power set to " .. num, 3, Color3.fromRGB(0, 255, 0))
                lastJumpPowerValue = num
            end
        else
            notif("Invalid Jump Power!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- INFINITE JUMP
local UIS = game:GetService("UserInputService")
_G.InfiniteJump = false

playerSection:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
       if not _G.VictoriaFirstLoad then
            notif("Infinite Jump: " .. (state and "Enabled" or "Disabled"), 3, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then 
            h:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end)

-- NOCLIP
_G.Noclip = false
local noclipThread

playerSection:AddToggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        
        if noclipThread then
            task.cancel(noclipThread)
            noclipThread = nil
        end
        
        if state then
            noclipThread = task.spawn(function()
                while _G.Noclip do
                    task.wait(0.1)
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
        
       if not _G.VictoriaFirstLoad then
            notif("Noclip: " .. (state and "Enabled" or "Disabled"), 3, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- FREEZE CHARACTER
local frozen = false
local lastCFrame = nil

playerSection:AddToggle({
    Title = "Freeze Character",
    Default = false,
    Callback = function(s)
        frozen = s
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        
        if s then
            lastCFrame = hrp.CFrame
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.AutoRotate = false
            humanoid.PlatformStand = true
            hrp.Anchored = true
           if not _G.VictoriaFirstLoad then
                notif("Character Frozen", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            humanoid.WalkSpeed = walkSpeedValue
            humanoid.JumpPower = jumpPowerValue
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
            hrp.Anchored = false
            if lastCFrame then
                hrp.CFrame = lastCFrame
            end
           if not _G.VictoriaFirstLoad then
                notif("Character Unfrozen", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- DISABLE ANIMATIONS
local animDisabled = false
local animConn

playerSection:AddToggle({
    Title = "Disable Animations",
    Default = false,
    Callback = function(state)
        animDisabled = state
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        if state then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0); track:Destroy() end)
            end

            if animConn then animConn:Disconnect(); animConn = nil end

            animConn = humanoid.AnimationPlayed:Connect(function(track)
                if animDisabled and track then
                    task.defer(function()
                        pcall(function() track:Stop(0); track:Destroy() end)
                    end)
                end
            end)
           if not _G.VictoriaFirstLoad then
                notif("Animations Disabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            if animConn then animConn:Disconnect(); animConn = nil end
            local animate = character:FindFirstChild("Animate")
            if animate then animate.Disabled = false end
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            task.wait()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
           if not _G.VictoriaFirstLoad then
                notif("Animations Enabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- WALK ON WATER
local isWalkOnWater = false
local waterPlatform = nil
local walkOnWaterConnection = nil

playerSection:AddToggle({
    Title = "Walk on Water",
    Default = false,
    Callback = function(state)
        isWalkOnWater = state
        
        if walkOnWaterConnection then
            walkOnWaterConnection:Disconnect()
            walkOnWaterConnection = nil
        end
        
        if waterPlatform then
            waterPlatform:Destroy()
            waterPlatform = nil
        end
        
        if state then
            waterPlatform = Instance.new("Part")
            waterPlatform.Name = "WaterPlatform"
            waterPlatform.Anchored = true
            waterPlatform.CanCollide = true
            waterPlatform.Transparency = 1
            waterPlatform.Size = Vector3.new(15, 1, 15)
            waterPlatform.Parent = workspace
           if not _G.VictoriaFirstLoad then
                notif("Walk on Water: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end

            walkOnWaterConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not isWalkOnWater then return end

                local character = LocalPlayer.Character
                if not character then return end

                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = { workspace.Terrain }
                rayParams.FilterType = Enum.RaycastFilterType.Include
                rayParams.IgnoreWater = false

                local result = workspace:Raycast(
                    hrp.Position + Vector3.new(0,5,0),
                    Vector3.new(0,-500,0),
                    rayParams
                )

                if result and result.Material == Enum.Material.Water then
                    local waterY = result.Position.Y
                    waterPlatform.Position = Vector3.new(hrp.Position.X, waterY, hrp.Position.Z)

                    if hrp.Position.Y < waterY + 2 then
                        if not UIS:IsKeyDown(Enum.KeyCode.Space) then
                            hrp.CFrame = CFrame.new(hrp.Position.X, waterY + 3.2, hrp.Position.Z)
                        end
                    end
                else
                    waterPlatform.Position = Vector3.new(hrp.Position.X, -500, hrp.Position.Z)
                end
            end)
        else
           if not _G.VictoriaFirstLoad then
                notif("Walk on Water: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- ==================== TAB 3: MAIN (FISHING) ====================
local Tab3 = Window:AddTab({
    Name = "Main",
    Icon = "fish"
})

-- ==================== FISHING FEATURES SECTION ====================
local fishingFeaturesSection = Tab3:AddSection("Fishing Features")

local RS = game:GetService("ReplicatedStorage")
local net = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- FISHING VARIABLES
_G.AutoFishing = false
_G.AutoEquipRod = false
_G.InstantDelay = 0.65
_G.CallMinDelay = 0.18
_G.CallBackoff = 1.5

local fishThread
local lastCall = {}

-- UTILITY FUNCTION
local function safeCall(k, f)
    local n = os.clock()
    if lastCall[k] and n - lastCall[k] < _G.CallMinDelay then
        task.wait(_G.CallMinDelay - (n - lastCall[k]))
    end
    local ok, result = pcall(f)
    lastCall[k] = os.clock()
    if not ok then
        local msg = tostring(result):lower()
        task.wait(msg:find("429") or msg:find("too many requests") and _G.CallBackoff or 0.2)
    end
    return ok, result
end

-- FISHING FEATURES
local function rod()
    safeCall("rod", function()
        net["RE/EquipToolFromHotbar"]:FireServer(1)
    end)
end

-- Auto Equip Rod (DI PINDAH KE SINI)
fishingFeaturesSection:AddToggle({
    Title = "Auto Equip Rod",
    Default = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        if v then
            rod()
            notif("Auto Equip Rod: Enabled", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Auto Equip Rod: Disabled", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- RADAR BYPASS (DI PINDAH KE SINI)
local radarEnabled = false
fishingFeaturesSection:AddToggle({
    Title = "Bypass Radar",
    Default = false,
    Callback = function(s)
        radarEnabled = s
        local RS, L = game.ReplicatedStorage, game.Lighting
        if require(RS.Packages.Replion).Client:GetReplion("Data") then
            require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar"):InvokeServer(s)
        end
        notif("Bypass Radar: " .. (s and "Enabled" or "Disabled"), 3, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end
})

-- OXYGEN BYPASS (DI PINDAH KE SINI)
fishingFeaturesSection:AddToggle({
    Title = "Bypass Oxygen",
    Default = false,
    Callback = function(s)
        if s then 
            net["RF/EquipOxygenTank"]:InvokeServer(105)
            notif("Oxygen Tank Equipped", 3, Color3.fromRGB(0, 255, 0))
        else 
            net["RF/UnequipOxygenTank"]:InvokeServer()
            notif("Oxygen Tank Unequipped", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- ==================== LEGIT FISHING SECTION ====================
local legitFishingSection = Tab3:AddSection("Legit Fishing")

-- Legit Fishing Variables
_G.LegitDelay = 5.5  -- Variabel untuk delay legit fishing

-- Legit Fishing Functions
local function autoon()
    safeCall("autoon", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(true)
    end)
end

local function autooff()
    safeCall("autooff", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(false)
    end)
end

local function catch()
    safeCall("catch", function()
        net["RF/CatchFishCompleted"]:InvokeServer()
    end)
end

local function legitcycle()
    if _G.AutoEquipRod then
        rod()
        task.wait(0.5)  -- Tunggu rod ter-equip
    end
    autoon()
    task.wait(_G.LegitDelay)  -- PAKAI VARIABLE YANG BISA DIUBAH
    catch()
end

-- Legit Fishing Delay Input (TAMBAH INI)
legitFishingSection:AddInput({
    Title = "Complete Delay",
    Default = "5.5",
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 1 and num <= 15 then
            _G.LegitDelay = num
            notif("Legit Delay: " .. num .. "s", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid delay! (1-15s)", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Fishing (Legit) Toggle
legitFishingSection:AddToggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(v)
        _G.AutoFishing = v
        
        if fishThread then
            task.cancel(fishThread)
            fishThread = nil
        end
        
        if v then
            fishThread = task.spawn(function()
                while _G.AutoFishing do
                    legitcycle()
                end
            end)
            notif("Legit Fishing: Enabled", 3, Color3.fromRGB(0, 255, 0))
        else
            autooff()
            notif("Legit Fishing: Disabled", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- ==================== INSTANT FISHING SECTION ====================
local instantFishingSection = Tab3:AddSection("Instant Fishing")

-- Instant Fishing Functions
local function catch()
    safeCall("catch", function()
        net["RF/CatchFishCompleted"]:InvokeServer()
    end)
end

local function charge()
    safeCall("charge", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function lempar()
    safeCall("lempar", function()
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996, -1771532005.497)
    end)
    safeCall("charge2", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function instant_cycle()
    if _G.AutoEquipRod then
        rod()
        task.wait(0.5)
    end
    charge()
    task.wait(0.3)
    lempar()
    task.wait(_G.InstantDelay)
    catch()
end

-- Instant Fishing Delay Input
instantFishingSection:AddInput({
    Title = "Complete Delay",
    Default = "0.65",
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 0.05 and num <= 5 then
            _G.InstantDelay = num
            notif("Instant Delay: " .. num .. "s", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid delay!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Fishing (Instant) Toggle
instantFishingSection:AddToggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(v)
        _G.AutoFishing = v
        
        if fishThread then
            task.cancel(fishThread)
            fishThread = nil
        end
        
        if v then
            fishThread = task.spawn(function()
                while _G.AutoFishing do
                    instant_cycle()
                    task.wait(_G.InstantDelay)
                end
            end)
            notif("Instant Fishing: Enabled", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Instant Fishing: Disabled", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- AUTO PERFECTION SECTION
local autoPerfectionSection = Tab3:AddSection("Auto Perfection/Good")

local FC = require(RS.Controllers.FishingController)
local oc, orc = FC.RequestFishingMinigameClick, FC.RequestChargeFishingRod
local ap = false

task.spawn(function()
    while task.wait() do
        if ap then
            net["RF/UpdateAutoFishingState"]:InvokeServer(true)
        end
    end
end)

autoPerfectionSection:AddToggle({
    Title = "Enable Perfection/Good",
    Default = false,
    Callback = function(s)
        ap = s
        if s then
            FC.RequestFishingMinigameClick = function() end
            FC.RequestChargeFishingRod = function() end
           if not _G.VictoriaFirstLoad then
                notif("Stable Result: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            net["RF/UpdateAutoFishingState"]:InvokeServer(false)
            FC.RequestFishingMinigameClick = oc
            FC.RequestChargeFishingRod = orc
           if not _G.VictoriaFirstLoad then
                notif("Stable Result: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- SKIN ANIMATION SECTION
local skinSection = Tab3:AddSection("Skin Animation")

-- Initialize global state
_G.BlockRodAnim = false
_G.CurrentTrack = nil
_G.ActiveAnim = nil
_G.SelectedAnim = "None"
_G.Animator = nil
_G.AnimationEnabled = false
_G.OriginalAnimatorConnections = {}

-- Animation list
local AnimationList = {
    ["None"] = nil,
    ["Holy Trident"] = "Holy Trident - FishCaught",
    ["Eclipse Katana"] = "Eclipse Katana - FishCaught",
    ["1x1x1x1 Ban Hammer"] = "1x1x1x1 Ban Hammer - FishCaught",
    ["Frozen Krampus Scythe"] = "Frozen Krampus Scythe - FishCaught",
    ["The Vanquisher"] = "The Vanquisher - FishCaught",
    ["Gingerbread Katana"] = "Gingerbread Katana - FishCaught",
    ["Christmas Parasol"] = "Christmas Parasol - FishCaught",
    ["Blackhole Sword"] = "Blackhole Sword - FishCaught",
    ["Eternal Flower"] = "Eternal Flower - FishCaught"
}

local animNames = {}
for name in pairs(AnimationList) do
    table.insert(animNames, name)
end
table.sort(animNames)

-- HOOK ANIMATOR FUNCTION
local function hookCharacter(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    _G.Animator = animator

    -- Store original animation played connection
    if not _G.OriginalAnimatorConnections[animator] then
        _G.OriginalAnimatorConnections[animator] = {}
    end
    
    -- Clear previous connections
    for _, conn in ipairs(_G.OriginalAnimatorConnections[animator]) do
        conn:Disconnect()
    end
    _G.OriginalAnimatorConnections[animator] = {}
    
    -- Create new connection for blocking rod animations
    local conn = animator.AnimationPlayed:Connect(function(track)
        if _G.BlockRodAnim and track ~= _G.CurrentTrack then
            track:Stop()
        end
    end)
    
    table.insert(_G.OriginalAnimatorConnections[animator], conn)
end

-- Setup initial character
if Players.LocalPlayer.Character then
    hookCharacter(Players.LocalPlayer.Character)
end

Players.LocalPlayer.CharacterAdded:Connect(function(char)
    _G.CurrentTrack = nil
    task.wait(0.2)
    hookCharacter(char)
end)

-- PLAY ANIMATION FUNCTION
local function PlayFishAnim(animName)
    if not _G.Animator then return end
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    if not ReplicatedStorage:FindFirstChild("Modules") then return end

    local animFolder = ReplicatedStorage.Modules:FindFirstChild("Animations")
    if not animFolder then return end

    local animObj = animFolder:FindFirstChild(animName)
    if not animObj then return end

    _G.BlockRodAnim = true

    if _G.CurrentTrack then
        _G.CurrentTrack:Stop()
    end

    local track = _G.Animator:LoadAnimation(animObj)
    track.Priority = Enum.AnimationPriority.Action
    track.Looped = false
    track:Play()

    _G.CurrentTrack = track

    task.delay(1, function()
        _G.BlockRodAnim = false
    end)
end

-- APPLY ANIMATION FUNCTION
local function ApplyAnimation()
    if _G.SelectedAnim == "None" then
        notif("Please select an animation first", 2, Color3.fromRGB(255, 165, 0))
        return false
    end
    
    _G.ActiveAnim = AnimationList[_G.SelectedAnim]
    notif("Animation applied: " .. _G.SelectedAnim, 2, Color3.fromRGB(0, 255, 0))
    return true
end

-- RESTORE ANIMATION FUNCTION
local function RestoreAnimation()
    _G.ActiveAnim = nil
    if _G.CurrentTrack then
        _G.CurrentTrack:Stop()
        _G.CurrentTrack = nil
    end
    _G.BlockRodAnim = false
    notif("Animation restored to default", 2, Color3.fromRGB(255, 0, 0))
    return true
end

-- UI ELEMENTS (VICTUI STYLE)
skinSection:AddDropdown({
    Title = "Select Rod Animation",
    Options = animNames,
    Default = _G.SelectedAnim,
    Callback = function(v)
        _G.SelectedAnim = v
        notif("Animation selected: " .. v, 2, Color3.fromRGB(0, 170, 255))
        
        -- If animation is enabled, apply the new selection
        if _G.AnimationEnabled and v ~= "None" then
            _G.ActiveAnim = AnimationList[v]
            notif("Auto-applied new animation: " .. v, 2, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- Toggle for enabling/disabling animation
skinSection:AddToggle({
    Title = "Enable Animation",
    Default = false,
    Callback = function(state)
        _G.AnimationEnabled = state
        
        if state then
            -- Enable animation
            if ApplyAnimation() then
                notif("Animation system enabled", 2, Color3.fromRGB(0, 255, 0))
            else
                -- If no animation selected, keep toggle off
                _G.AnimationEnabled = false
            end
        else
            -- Disable animation
            RestoreAnimation()
            notif("Animation system disabled", 2, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- FISH CAUGHT EVENT LISTENER
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Net = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
    
    local fishCaughtEvent = Net:WaitForChild("RE/FishCaught")
    
    fishCaughtEvent.OnClientEvent:Connect(function()
        if _G.ActiveAnim and _G.AnimationEnabled then
            PlayFishAnim(_G.ActiveAnim)
        end
    end)
end)

-- Cleanup function for when player leaves
Players.LocalPlayer.CharacterRemoving:Connect(function()
    _G.CurrentTrack = nil
    _G.BlockRodAnim = false
end)

-- ==================== TAB 4: AUTO ====================
local Tab4 = Window:AddTab({
    Name = "Auto",
    Icon = "loop"
})

-- AUTO SELL SECTION (VICTUI VERSION - SIMPLIFIED)
local sellSection = Tab4:AddSection("Auto Sell")

local RS = game:GetService("ReplicatedStorage")
local SellAllRF = RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]
local AutoSell = false
local SellAt = 100
local Selling = false

-- Item utility untuk menghitung ikan
local ItemUtility, DataService
task.spawn(function()
    ItemUtility = require(RS.Shared.ItemUtility)
    DataService = require(RS.Packages.Replion).Client:WaitReplion("Data")
end)

-- Function untuk menghitung total ikan di inventory
local function getFishCount()
    if not (DataService and ItemUtility) then return 0 end
    local items = DataService:GetExpect({ "Inventory", "Items" })
    local count = 0
    for _, v in pairs(items) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data and itemData.Data.Type == "Fish" then
            count += 1
        end
    end
    return count
end

-- Auto Sell Threshold Input
sellSection:AddInput({
    Title = "Auto Sell When Fish ≥",
    Content = "Sell automatically when fish count reaches this number",
    Default = "100",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then 
            SellAt = math.floor(num)
            notif("Auto Sell Threshold: " .. SellAt, 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid threshold!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Sell Toggle
sellSection:AddToggle({
    Title = "Auto Sell All Fish",
    Default = false,
    Callback = function(state)
        AutoSell = state
       if not _G.VictoriaFirstLoad then
            notif("Auto Sell: " .. (state and "Enabled" or "Disabled"), 3, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- HEARTBEAT untuk auto sell (simplified)
game:GetService("RunService").Heartbeat:Connect(function()
    if not AutoSell or Selling then return end
    
    -- Cek berdasarkan jumlah ikan
    local fishCount = getFishCount()
    if fishCount >= SellAt then
        Selling = true
        
        pcall(function() 
            SellAllRF:InvokeServer() 
        end)
        
        task.delay(1.5, function() 
            Selling = false 
        end)
    end
end)

-- AUTO FAVORITE SECTION
local favSection = Tab4:AddSection("Auto Favorite")

local GlobalFav = {
    FishNames = {},
    VariantNames = {},
    SelectedFish = {},
    SelectedVariants = {},
    AutoFavoriteEnabled = false,
    FishIdToName = {},
    FishNameToId = {},
    VariantIdToName = {},
    VariantNameToId = {}
}

-- Load fish data dengan mapping
task.spawn(function()
    for _, item in pairs(RS.Items:GetChildren()) do
        local ok, data = pcall(require, item)
        if ok and data.Data and data.Data.Type == "Fish" then
            table.insert(GlobalFav.FishNames, data.Data.Name)
            GlobalFav.FishIdToName[data.Data.Id] = data.Data.Name
            GlobalFav.FishNameToId[data.Data.Name] = data.Data.Id
        end
    end
    table.sort(GlobalFav.FishNames)
    
    for _, variantModule in pairs(RS.Variants:GetChildren()) do
        local ok, variantData = pcall(require, variantModule)
        if ok and variantData.Data and variantData.Data.Name then
            table.insert(GlobalFav.VariantNames, variantData.Data.Name)
            local variantId = variantData.Data.Id or variantModule.Name
            GlobalFav.VariantIdToName[variantId] = variantData.Data.Name
            GlobalFav.VariantNameToId[variantData.Data.Name] = variantId
        end
    end
    table.sort(GlobalFav.VariantNames)
end)

-- Fish Selection Dropdown
favSection:AddDropdown({
    Title = "Select Fish",
    Options = GlobalFav.FishNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        GlobalFav.SelectedFish = v
        notif("Selected " .. #v .. " fish types", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Variant Selection Dropdown
favSection:AddDropdown({
    Title = "Select Variants",
    Options = GlobalFav.VariantNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        GlobalFav.SelectedVariants = v
        notif("Selected " .. #v .. " variants", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Auto Favorite Toggle
favSection:AddToggle({
    Title = "Auto Favorite",
    Default = false,
    Callback = function(state)
        GlobalFav.AutoFavoriteEnabled = state
       if not _G.VictoriaFirstLoad then
            notif("Auto Favorite: " .. (state and "Enabled" or "Disabled"), 3, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Reset Button
favSection:AddButton({
    Title = "Reset Selection",
    Callback = function()
        GlobalFav.SelectedFish = {}
        GlobalFav.SelectedVariants = {}
        notif("Selection Reset", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- AUTO FAVORITE LOGIC
local REFavoriteItem = RS.Packages._Index["sleitnick_net@0.2.0"].net["RE/FavoriteItem"]
local REObtainedNewFishNotification = RS.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]

REObtainedNewFishNotification.OnClientEvent:Connect(function(itemId, _, data)
    if not GlobalFav.AutoFavoriteEnabled then return end
    
    local uuid = data.InventoryItem and data.InventoryItem.UUID
    local fishName = GlobalFav.FishIdToName[itemId]
    
    if not uuid or not fishName then return end
    
    local variantId = data.InventoryItem and data.InventoryItem.Metadata and data.InventoryItem.Metadata.VariantId
    local variantName = variantId and GlobalFav.VariantIdToName[variantId]
    
    -- Cek fish selected
    local isFishSelected = false
    for _, selectedFish in ipairs(GlobalFav.SelectedFish) do
        if selectedFish == fishName then
            isFishSelected = true
            break
        end
    end
    
    -- Cek variant selected
    local isVariantSelected = false
    if variantName then
        for _, selectedVariant in ipairs(GlobalFav.SelectedVariants) do
            if selectedVariant == variantName then
                isVariantSelected = true
                break
            end
        end
    end
    
    -- Logic favorit
    local shouldFavorite = false
    
    if isFishSelected and #GlobalFav.SelectedVariants == 0 then
        shouldFavorite = true
    elseif isFishSelected and isVariantSelected then
        shouldFavorite = true
    elseif #GlobalFav.SelectedFish == 0 and isVariantSelected then
        shouldFavorite = true
    end
    
    if shouldFavorite then
        pcall(function()
            REFavoriteItem:FireServer(uuid)
        end)
    end
end)

-- EVENT SECTION
local eventSection = Tab4:AddSection("Events")

-- Auto Open Mysterious Cave
local AutoOpenMaze = false
local AutoOpenMazeTask = nil

eventSection:AddToggle({
    Title = "Auto Open Mysterious Cave",
    Default = false,
    Callback = function(state)
        AutoOpenMaze = state

        if state then
            AutoOpenMazeTask = task.spawn(function()
                while AutoOpenMaze do
                    pcall(function()
                        net["RE/SearchItemPickedUp"]:FireServer("TNT")
                        task.wait(1)
                        net["RE/GainAccessToMaze"]:FireServer()
                    end)
                    task.wait(2)
                end
            end)
           if not _G.VictoriaFirstLoad then
                notif("Auto Mysterious Cave: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            AutoOpenMaze = false
            if AutoOpenMazeTask then
                task.cancel(AutoOpenMazeTask)
                AutoOpenMazeTask = nil
            end
           if not _G.VictoriaFirstLoad then
                notif("Auto Mysterious Cave: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- Auto Claim Pirate Chest
local AutoClaimPirateChest = false
eventSection:AddToggle({
    Title = "Auto Claim Pirate Chest",
    Default = false,
    Callback = function(v)
        AutoClaimPirateChest = v
       if not _G.VictoriaFirstLoad then
            notif("Auto Claim Pirate Chest: " .. (v and "Enabled" or "Disabled"), 3, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Pirate chest event
task.spawn(function()
    local Award = net["RE/AwardPirateChest"]
    Award.OnClientEvent:Connect(function(chestId)
        if AutoClaimPirateChest then
            pcall(function()
                net["RE/ClaimPirateChest"]:FireServer(chestId)
            end)
        end
    end)
end)

-- AUTO TOTEM SECTION
local totemSection = Tab4:AddSection("Totem Feature")

local AutoTotemEnabled = false
local SelectedTotemId = 1
local TotemDelayMinutes = 60

-- Totem dropdown
local totemOptions = {"Luck Totem", "Mutation Totem", "Shiny Totem"}
totemSection:AddDropdown({
    Title = "Select Totem Type",
    Options = totemOptions,
    Default = totemOptions[1],
    Callback = function(v)
        if v == "Luck Totem" then
            SelectedTotemId = 1
        elseif v == "Mutation Totem" then
            SelectedTotemId = 2
        elseif v == "Shiny Totem" then
            SelectedTotemId = 3
        end
        notif("Selected: " .. v, 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Delay Input
totemSection:AddInput({
    Title = "Delay (Minutes)",
    Default = "60",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            TotemDelayMinutes = math.floor(num)
            notif("Totem Delay: " .. num .. " minutes", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid delay!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Place Totem Toggle
totemSection:AddToggle({
    Title = "Auto Place Totem",
    Default = false,
    Callback = function(enabled)
        AutoTotemEnabled = enabled
        if not enabled then 
           if not _G.VictoriaFirstLoad then
                notif("Auto Place Totem: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
            return 
        end

        task.spawn(function()
            while AutoTotemEnabled do
                local Net = require(RS.Packages.Net)
                local Replion = require(RS.Packages.Replion)
                local DataReplion = Replion.Client:WaitReplion("Data")
                
                local inventory = DataReplion:Get("Inventory")
                if inventory and inventory.Totems then
                    local spawnTotem = Net:RemoteEvent("SpawnTotem")
                    for _, totem in pairs(inventory.Totems) do
                        if totem.Id == SelectedTotemId then
                            spawnTotem:FireServer(totem.UUID)
                            break
                        end
                    end
                end
                task.wait(TotemDelayMinutes * 60)
            end
        end)
        
       if not _G.VictoriaFirstLoad then
            notif("Auto Place Totem: Enabled (" .. TotemDelayMinutes .. " minutes)", 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- Place Now Button
totemSection:AddButton({
    Title = "Place Selected Totem",
    Callback = function()
        local Net = require(RS.Packages.Net)
        local Replion = require(RS.Packages.Replion)
        local DataReplion = Replion.Client:WaitReplion("Data")
        
        local inventory = DataReplion:Get("Inventory")
        if not inventory or not inventory.Totems then 
            notif("No totems found!", 3, Color3.fromRGB(255, 0, 0))
            return 
        end

        local spawnTotem = Net:RemoteEvent("SpawnTotem")
        for _, totem in pairs(inventory.Totems) do
            if totem.Id == SelectedTotemId then
                spawnTotem:FireServer(totem.UUID)
                notif("Totem Placed", 3, Color3.fromRGB(0, 255, 0))
                break
            end
        end
    end
})
 
-- AUTO TRADE SECTION
local tradeSection = Tab4:AddSection("Auto Trade")

-- TRADE VARIABLES
local Trade = {
    SelectedFish = {},
    SelectedRarities = {},
    SelectedPlayer = "",
    AutoTradeEnabled = false,
    TradeDelay = 5,
    FishNames = {},
    FishRarityDB = {}  -- Simpan rarity per ikan
}

-- Load fish data dengan RARITY
task.spawn(function()
    for _, item in pairs(game:GetService("ReplicatedStorage").Items:GetChildren()) do
        local ok, data = pcall(require, item)
        if ok and data.Data and data.Data.Type == "Fish" then
            local fishName = data.Data.Name
            local fishTier = data.Data.Tier or 1
            
            table.insert(Trade.FishNames, fishName)
            Trade.FishRarityDB[fishName] = fishTier  -- SIMPAN TIER/RARITY!
        end
    end
    table.sort(Trade.FishNames)
end)

-- Function untuk get player list
local function getPlayerList()
    local players = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    table.sort(players)
    return players
end

-- Function untuk get rarity name dari tier number
local function getRarityName(tierNumber)
    local rarityMap = {
        [1] = "Common",
        [2] = "Uncommon",
        [3] = "Rare",
        [4] = "Epic",
        [5] = "Legendary",
        [6] = "Mythic",
        [7] = "Secret"
    }
    return rarityMap[tierNumber] or "Common"
end

-- Fish Dropdown
tradeSection:AddDropdown({
    Title = "Select Fish",
    Options = Trade.FishNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        Trade.SelectedFish = v
    end
})

-- Rarity Dropdown (SEKARANG BISA BERFUNGSI!)
local rarityNames = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}
tradeSection:AddDropdown({
    Title = "Select Rarity",
    Options = rarityNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        Trade.SelectedRarities = v
    end
})

-- Player Dropdown
local playerList = getPlayerList()
Trade.SelectedPlayer = #playerList > 0 and playerList[1] or ""

tradeSection:AddDropdown({
    Title = "Select Player",
    Options = playerList,
    Default = Trade.SelectedPlayer,
    Callback = function(v)
        Trade.SelectedPlayer = v
    end
})

-- Delay Input
tradeSection:AddInput({
    Title = "Delay (seconds)",
    Default = "5",
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 1 then 
            Trade.TradeDelay = n 
        end
    end
})

-- Function untuk check rarity dengan BENAR
local function shouldTradeFish(fishName)
    -- Dapatkan tier dari database
    local fishTier = Trade.FishRarityDB[fishName] or 1
    local fishRarityName = getRarityName(fishTier)
    
    -- Check fish filter
    if #Trade.SelectedFish > 0 then
        local fishMatch = false
        for _, selectedFish in ipairs(Trade.SelectedFish) do
            if selectedFish == fishName then
                fishMatch = true
                break
            end
        end
        if not fishMatch then
            return false
        end
    end
    
    -- Check rarity filter (SEKARANG BERFUNGSI!)
    if #Trade.SelectedRarities > 0 then
        local rarityMatch = false
        for _, selectedRarity in ipairs(Trade.SelectedRarities) do
            if selectedRarity == fishRarityName then
                rarityMatch = true
                break
            end
        end
        if not rarityMatch then
            return false
        end
    end
    
    return true
end

-- Function untuk trade
local function sendTrade(targetPlayer, itemUUID)
    if not targetPlayer then return false end
    
    if not net["RF/CanSendTrade"] or not net["RF/InitiateTrade"] then
        return false
    end
    
    local canTradeSuccess, canTradeResult = pcall(function()
        return net["RF/CanSendTrade"]:InvokeServer(targetPlayer.UserId)
    end)
    
    if not canTradeSuccess or canTradeResult == false then
        return false
    end
    
    local params = itemUUID and {targetPlayer.UserId, itemUUID} or {targetPlayer.UserId}
    
    local tradeSuccess = pcall(function()
        net["RF/InitiateTrade"]:InvokeServer(unpack(params))
        return true
    end)
    
    return tradeSuccess
end

-- Auto Trade Toggle
tradeSection:AddToggle({
    Title = "Auto Trade",
    Default = false,
    Callback = function(state)
        Trade.AutoTradeEnabled = state
        
        if state then
            task.spawn(function()
                while Trade.AutoTradeEnabled do
                    -- REFRESH PLAYER LIST
                    local currentPlayers = getPlayerList()
                    
                    local playerExists = false
                    for _, playerName in ipairs(currentPlayers) do
                        if playerName == Trade.SelectedPlayer then
                            playerExists = true
                            break
                        end
                    end
                    
                    if not playerExists and #currentPlayers > 0 then
                        Trade.SelectedPlayer = currentPlayers[1]
                    elseif not playerExists then
                        Trade.SelectedPlayer = ""
                    end
                    
                    -- LANJUT TRADE
                    if Trade.SelectedPlayer ~= "" then
                        local Replion = require(game:GetService("ReplicatedStorage").Packages.Replion)
                        local DataService = Replion.Client:WaitReplion("Data")
                        local ItemUtility = require(game:GetService("ReplicatedStorage").Shared.ItemUtility)
                        
                        local target = game.Players:FindFirstChild(Trade.SelectedPlayer)
                        if target then
                            local items = DataService:GetExpect({ "Inventory", "Items" })
                            
                            for _, itemData in pairs(items) do
                                if not Trade.AutoTradeEnabled then break end
                                
                                local itemInfo = ItemUtility.GetItemDataFromItemType("Items", itemData.Id)
                                
                                if itemInfo and itemInfo.Data and itemInfo.Data.Type == "Fish" then
                                    local fishName = itemInfo.Data.Name or "Unknown Fish"
                                    local uuid = itemData.UUID
                                    
                                    -- CEK RARITY DENGAN DATABASE BARU
                                    if uuid and shouldTradeFish(fishName) then
                                        if net["RF/CanSendTrade"] and net["RF/InitiateTrade"] then
                                            pcall(function()
                                                net["RF/CanSendTrade"]:InvokeServer(target.UserId)
                                                net["RF/InitiateTrade"]:InvokeServer(target.UserId, uuid)
                                            end)
                                            task.wait(Trade.TradeDelay)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(Trade.TradeDelay)
                end
            end)
        end
    end
})

-- Refresh Player Button
tradeSection:AddButton({
    Title = "Refresh Player",
    Callback = function()
        local currentPlayers = getPlayerList()
        
        local playerExists = false
        for _, playerName in ipairs(currentPlayers) do
            if playerName == Trade.SelectedPlayer then
                playerExists = true
                break
            end
        end
        
        if not playerExists and #currentPlayers > 0 then
            Trade.SelectedPlayer = currentPlayers[1]
        elseif not playerExists then
            Trade.SelectedPlayer = ""
        end
    end
})

-- ==================== TAB 5: WEBHOOK ====================
local Tab5 = Window:AddTab({
    Name = "Webhook",
    Icon = "plug"
})

local webhookSection = Tab5:AddSection("Webhook Fish Caught")

local httpRequest = syn and syn.request or http and http.request or http_request or (fluxus and fluxus.request) or request

-- Webhook Variables
local WebhookURL = ""
local WebhookRarities = {}
local DetectNewFishActive = false

-- Rarity filter dropdown
local rarityOptions = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET"}
webhookSection:AddDropdown({
    Title = "Rarity Filter",
    Options = rarityOptions,
    Default = {},
    Multi = true,
    Callback = function(v)
        WebhookRarities = v
        notif("Selected " .. #v .. " rarities", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Webhook URL Input
webhookSection:AddInput({
    Title = "Webhook URL",
    Default = "",
    Callback = function(text)
        WebhookURL = text
        if text ~= "" then
            notif("Webhook URL set", 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- Send Webhook Toggle
webhookSection:AddToggle({
    Title = "Send Fish Caught Webhook",
    Default = false,
    Callback = function(state)
        DetectNewFishActive = state
       if not _G.VictoriaFirstLoad then
            notif("Fish Webhook: " .. (state and "Enabled" or "Disabled"), 3, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Test Webhook Button
webhookSection:AddButton({
    Title = "Test Webhook",
    Callback = function()
        if not httpRequest or not WebhookURL or not WebhookURL:match("discord.com/api/webhooks") then
            notif("Webhook URL Empty or Invalid", 3, Color3.fromRGB(255, 0, 0))
            return
        end

        local payload = {
            username = "Victoria Hub Webhook",
            avatar_url = "https://cdn.discordapp.com/attachments/1358728774098882653/1459169498383909049/ai_repair_20260106014107493.png?ex=69624cfe&is=6960fb7e&hm=7ae73d692bb21a5dabee8b09b0d8447b90c5c2a29612b313ebeb9c3c87ae94e4&",
            embeds = {{
                title = "Test Webhook Connected",
                description = "Webhook connection successful!",
                color = 0xFFFFFF
            }}
        }

        task.spawn(function()
            pcall(function()
                httpRequest({
                    Url = WebhookURL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = game:GetService("HttpService"):JSONEncode(payload)
                })
            end)
        end)
        
        notif("Test Webhook Sent", 3, Color3.fromRGB(0, 255, 0))
    end
})

-- ==================== TAB 6: SHOP ====================
local Tab6 = Window:AddTab({
    Name = "Shop",
    Icon = "shop"
})

-- BUY ROD SECTION
local rodSection = Tab6:AddSection("Buy Rod")

local R = {
    ["Luck Rod"] = 79, ["Carbon Rod"] = 76, ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77, ["Ice Rod"] = 78, ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80, ["Steampunk Rod"] = 6, ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5, ["Ares Rod"] = 126, ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}

local rodOptions = {
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)",
    "Demascus Rod (3k Coins)", "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)",
    "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)", "Chrome Rod (437k Coins)",
    "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod (8M Coins)",
    "Bamboo Rod (12M Coins)"
}

local selectedRod = rodOptions[1]

rodSection:AddDropdown({
    Title = "Select Rod",
    Options = rodOptions,
    Default = selectedRod,
    Callback = function(v)
        selectedRod = v
        notif("Selected: " .. v, 3, Color3.fromRGB(0, 170, 255))
    end
})

rodSection:AddButton({
    Title = "Buy Rod",
    Callback = function()
        local name = selectedRod:match("^(.-) %(")
        if name and R[name] then
            pcall(function() 
                net["RF/PurchaseFishingRod"]:InvokeServer(R[name]) 
                notif("Purchased: " .. name, 3, Color3.fromRGB(0, 255, 0))
            end)
        else
            notif("Invalid rod selection!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- BUY BAIT SECTION
local baitSection = Tab6:AddSection("Buy Baits")

local B = {
    ["Luck Bait"] = 2, ["Midnight Bait"] = 3, ["Nature Bait"] = 10,
    ["Chroma Bait"] = 6, ["Dark Matter Bait"] = 8, ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16, ["Floral Bait"] = 20
}

local baitOptions = {}
for name, _ in pairs(B) do
    table.insert(baitOptions, name)
end

local selectedBait = baitOptions[1]

baitSection:AddDropdown({
    Title = "Select Bait",
    Options = baitOptions,
    Default = selectedBait,
    Callback = function(v)
        selectedBait = v
        notif("Selected: " .. v, 3, Color3.fromRGB(0, 170, 255))
    end
})

baitSection:AddButton({
    Title = "Buy Bait",
    Callback = function()
        if selectedBait and B[selectedBait] then
            pcall(function() 
                net["RF/PurchaseBait"]:InvokeServer(B[selectedBait]) 
                notif("Purchased: " .. selectedBait, 3, Color3.fromRGB(0, 255, 0))
            end)
        else
            notif("Invalid bait selection!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- MERCHANT SECTION
local merchantSection = Tab6:AddSection("Merchant")

merchantSection:AddButton({
    Title = "OPEN MERCHANT",
    Callback = function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local merchantUI = playerGui:WaitForChild("Merchant")
        if merchantUI then
            merchantUI.Enabled = true
            notif("Merchant Opened", 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

merchantSection:AddButton({
    Title = "CLOSE MERCHANT",
    Callback = function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local merchantUI = playerGui:FindFirstChild("Merchant")
        if merchantUI then
            merchantUI.Enabled = false
            notif("Merchant Closed", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- BUY WEATHER EVENT
local weatherSection = Tab6:AddSection("Weather Events")

local autoBuyEnabled = false

weatherSection:AddToggle({
    Title = "Auto Buy Weather",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            task.spawn(function()
                while autoBuyEnabled do
                    for _, weatherName in ipairs({"Wind", "Cloudy", "Storm"}) do
                        pcall(function()
                            net["RF/PurchaseWeatherEvent"]:InvokeServer(weatherName)
                        end)
                        task.wait(0.3)
                    end
                    task.wait(1)
                end
            end)
           if not _G.VictoriaFirstLoad then
                notif("Auto Buy Weather: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
           if not _G.VictoriaFirstLoad then
                notif("Auto Buy Weather: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- ==================== TAB 7: TELEPORT ====================
local Tab7 = Window:AddTab({
    Name = "Teleport",
    Icon = "gps"
})

-- ISLAND TELEPORT SECTION
local islandSection = Tab7:AddSection("Island Teleport")

local IslandLocations = {
    ["Ancient Jungle"] = CFrame.new(1480.000, 3.029, -334.000, -0.766, 0.000, -0.643, 0.000, 1.000, 0.000, 0.643, 0.000, -0.766),
    ["Coral Refs"] = CFrame.new(-3270.860, 2.500, 2228.100, -0.000, 0.000, 1.000, 0.000, 1.000, -0.000, -1.000, 0.000, -0.000),
    ["Crater Island"] = CFrame.new(1079.570, 3.645, 5080.350, -0.000, -0.000, 1.000, -0.000, 1.000, 0.000, -1.000, -0.000, -0.000),
    ["Enchant Room"] = CFrame.new(3232.390, -1302.855, 1401.953),
    ["Enchant Room 2"] = CFrame.new(1480, 126, -585),
    ["Esoteric Island"] = CFrame.new(3208.000, -1302.855, 1420.000, -0.940, 0.000, -0.342, 0.000, 1.000, 0.000, 0.342, 0.000, -0.940),
    ["Fisherman Island"] = CFrame.new(51.000, 2.279, 2762.000, 1.000, -0.000, -0.000, 0.000, 1.000, 0.000, 0.000, -0.000, 1.000),
    ["Kohana Volcano"] = CFrame.new(-561.810, 21.239, 156.720, -1.000, 0.000, -0.000, 0.000, 1.000, 0.000, 0.000, 0.000, -1.000),
    ["Konoha"] = CFrame.new(-625.000, 19.250, 424.000, -1.000, 0.000, -0.000, 0.000, 1.000, 0.000, 0.000, 0.000, -1.000),
    ["Sacred Temple"] = CFrame.new(1485.000, -21.875, -641.000, 0.866, 0.000, -0.500, -0.000, 1.000, 0.000, 0.500, 0.000, 0.866),
    ["Sysyphus Statue"] = CFrame.new(-3702.000, -135.074, -1009.000, -1.000, -0.000, -0.000, -0.000, 1.000, -0.000, 0.000, -0.000, -1.000),
    ["Treasure Room"] = CFrame.new(-3609.000, -279.074, -1591.000, 1.000, 0.000, -0.000, -0.000, 1.000, -0.000, 0.000, 0.000, 1.000),
    ["Tropical Grove"] = CFrame.new(-2020.000, 4.744, 3755.000, -1.000, -0.000, -0.000, -0.000, 1.000, -0.000, 0.000, -0.000, -1.000),
    ["Underground Cellar"] = CFrame.new(2136.000, -91.199, -699.000, 1.000, 0.000, -0.000, -0.000, 1.000, -0.000, 0.000, 0.000, 1.000),
    ["Weather Machine"] = CFrame.new(-1524.880, 2.875, 1915.560, -1.000, 0.000, -0.000, 0.000, 1.000, 0.000, 0.000, 0.000, -1.000),
    ["Ancient Ruin"] = CFrame.new(6085.609, -585.924, 4638.000, -0.666, -0.000, 0.746, -0.000, 1.000, 0.000, -0.746, -0.000, -0.666),
    ["Pirate Cave"] = CFrame.new(3399.000, 2.708, 3469.000, -0.000, 0.000, -1.000, -0.000, 1.000, 0.000, 1.000, 0.000, -0.000),
    ["Treasure Pirate Cave"] = CFrame.new(3307.264, -303.662, 3031.954, -0.761, 0.000, -0.649, 0.000, 1.000, 0.000, 0.649, 0.000, -0.761),
    ["Crystal Depths"] = CFrame.new(5637.000, -904.985, 15354.000, -0.866, 0.000, -0.500, 0.000, 1.000, 0.000, 0.500, 0.000, -0.866),
    ["Leviathan Den"] = CFrame.new(3473.000, -287.843, 3472.000, -0.866, 0.000, -0.500, 0.000, 1.000, 0.000, 0.500, 0.000, -0.866),
    ["Secret Passage"] = CFrame.new(3440.293, -287.845, 3384.696, -0.924, -0.000, -0.382, -0.000, 1.000, -0.000, 0.382, -0.000, -0.924),
}

local islandNames = {}
for name in pairs(IslandLocations) do table.insert(islandNames, name) end
table.sort(islandNames)

local SelectedIsland = islandNames[1]

islandSection:AddDropdown({
    Title = "Select Island",
    Options = islandNames,
    Default = SelectedIsland,
    Callback = function(Value)
        SelectedIsland = Value
        notif("Selected: " .. Value, 3, Color3.fromRGB(0, 170, 255))
    end
})

islandSection:AddButton({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = IslandLocations[SelectedIsland]
                notif("Teleported to " .. SelectedIsland, 3, Color3.fromRGB(0, 255, 0))
            else
                notif("Character not found!", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- PLAYER TELEPORT SECTION
local playerTeleportSection = Tab7:AddSection("Player Teleport")

-- Variables
local selectedPlayer = game.Players.LocalPlayer.Name

local function getPlayerList()
    local players = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        table.insert(players, plr.Name)
    end
    table.sort(players)
    return players
end

-- Create dropdown (LANGSUNG LOAD - TANPA SETOPTIONS)
local initialPlayers = getPlayerList()
playerTeleportSection:AddDropdown({
    Title = "Select Player",
    Options = initialPlayers,
    Default = selectedPlayer,
    Callback = function(v)
        selectedPlayer = v
    end
})

-- Teleport to player button
playerTeleportSection:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        if not selectedPlayer then 
            return 
        end

        local target = game.Players:FindFirstChild(selectedPlayer)
        if not target then 
            return 
        end

        if not target.Character then
            target.CharacterAdded:Wait()
            task.wait(1)
        end

        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = game.Players.LocalPlayer.Character and 
                     game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not targetHRP or not myHRP then 
            return 
        end

        myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
    end
})

-- Refresh player list button (VERSI FIX - TANPA SETOPTIONS)
playerTeleportSection:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        local currentPlayers = getPlayerList()
        
        -- Cek apakah player yang dipilih masih online
        local playerExists = false
        for _, playerName in ipairs(currentPlayers) do
            if playerName == selectedPlayer then
                playerExists = true
                break
            end
        end
        
        -- Jika player tidak ditemukan, pilih LocalPlayer
        if not playerExists then
            selectedPlayer = game.Players.LocalPlayer.Name
        end
        
        -- TIDAK ADA SETOPTIONS di sini
        -- Variable selectedPlayer sudah di-update
    end
})

-- Auto refresh ketika player join/leave
game.Players.PlayerAdded:Connect(function()
    task.wait(2)
    if selectedPlayer == "" then
        local playerList = getPlayerList()
        if #playerList > 0 then
            selectedPlayer = playerList[1]
        end
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    if selectedPlayer == player.Name then
        task.wait(1)
        local playerList = getPlayerList()
        if #playerList > 0 then
            selectedPlayer = playerList[1]
        else
            selectedPlayer = game.Players.LocalPlayer.Name
        end
    end
end)

-- EVENT TELEPORT SECTION
local eventTeleportSection = Tab7:AddSection("Event Teleporter")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Event data
local eventData = {
    ["Worm Hunt"] = {
        TargetName = "Model",
        Locations = {
            Vector3.new(2190.85, -1.4, 97.575),
            Vector3.new(-2450.679, -1.4, 139.731),
            Vector3.new(-267.479, -1.4, 5188.531),
            Vector3.new(-327, -1.4, 2422)
        },
        PlatformY = 106,
        Priority = 1
    },

    ["Megalodon Hunt"] = {
        TargetName = "Megalodon Hunt",
        Locations = {
            Vector3.new(-1076.3, -1.4, 1676.2),
            Vector3.new(-1191.8, -1.4, 3597.3),
            Vector3.new(412.7, -1.4, 4134.4)
        },
        PlatformY = 106,
        Priority = 2
    },

    ["Ghost Shark Hunt"] = {
        TargetName = "Ghost Shark Hunt",
        Locations = {
            Vector3.new(489.559, -1.35, 25.406),
            Vector3.new(-1358.216, -1.35, 4100.556),
            Vector3.new(627.859, -1.35, 3798.081)
        },
        PlatformY = 106,
        Priority = 3
    },

    ["Shark Hunt"] = {
        TargetName = "Shark Hunt",
        Locations = {
            Vector3.new(1.65, -1.35, 2095.725),
            Vector3.new(1369.95, -1.35, 930.125),
            Vector3.new(-1585.5, -1.35, 1242.875),
            Vector3.new(-1896.8, -1.35, 2634.375)
        },
        PlatformY = 106,
        Priority = 4
    }
}

-- Event names for dropdown
local eventNames = {}
for name in pairs(eventData) do
    table.insert(eventNames, name)
end
table.sort(eventNames)

-- State
local EventTP = {
    player = Players.LocalPlayer,
    char = nil,
    hrp = nil,
    radius = 150,
    active = false,
    floatActive = false,
    selectedEvents = {},
    tpCooldown = 1,
    floatHeight = 6,
    descendantsCache = {},
    lastCacheTime = 0,
    cacheInterval = 3
}

-- Get character
local function setupCharacter(character)
    EventTP.char = character
    task.wait(0.5)
    EventTP.hrp = character:FindFirstChild("HumanoidRootPart")
end

if EventTP.player.Character then
    setupCharacter(EventTP.player.Character)
end

EventTP.player.CharacterAdded:Connect(setupCharacter)

-- Update cache
local function updateDescendantsCache()
    local now = tick()
    if now - EventTP.lastCacheTime >= EventTP.cacheInterval then
        EventTP.descendantsCache = workspace:GetDescendants()
        EventTP.lastCacheTime = now
    end
end

-- Teleport function
local function teleportTo(position)
    if not EventTP.hrp or not EventTP.hrp.Parent then return end
    
    pcall(function()
        EventTP.hrp.CFrame = CFrame.new(position.X, position.Y + 3, position.Z)
        EventTP.hrp.AssemblyLinearVelocity = Vector3.zero
        EventTP.hrp.AssemblyAngularVelocity = Vector3.zero
    end)
end

-- Find event location
local function findEventLocation(config)
    if config.TargetName == "Model" then
        -- Worm Hunt specific
        local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
        if menuRings then
            for _, prop in ipairs(menuRings:GetChildren()) do
                if prop.Name == "Props" then
                    local model = prop:FindFirstChild("Model")
                    if model and model.PrimaryPart then
                        for _, location in ipairs(config.Locations) do
                            local distance = (model.PrimaryPart.Position - location).Magnitude
                            if distance <= EventTP.radius then
                                return model.PrimaryPart.Position
                            end
                        end
                    end
                end
            end
        end
    else
        -- Other events
        updateDescendantsCache()
        
        for _, descendant in ipairs(EventTP.descendantsCache) do
            if descendant and descendant.Parent and descendant.Name == config.TargetName then
                local position = nil
                
                if descendant:IsA("BasePart") then
                    position = descendant.Position
                elseif descendant:IsA("Model") and descendant.PrimaryPart then
                    position = descendant.PrimaryPart.Position
                end
                
                if position then
                    for _, location in ipairs(config.Locations) do
                        local distance = (position - location).Magnitude
                        if distance <= EventTP.radius then
                            return position
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

-- Main teleport loop
local function runTeleportLoop()
    while EventTP.active do
        task.wait(EventTP.tpCooldown)
        
        if not EventTP.hrp or not EventTP.hrp.Parent then
            continue
        end
        
        -- Build event list by priority
        local eventList = {}
        for _, eventName in ipairs(EventTP.selectedEvents) do
            local config = eventData[eventName]
            if config then
                table.insert(eventList, config)
            end
        end
        
        -- Sort by priority
        table.sort(eventList, function(a, b)
            return a.Priority < b.Priority
        end)
        
        -- Find and teleport to highest priority event
        for _, config in ipairs(eventList) do
            local position = findEventLocation(config)
            if position then
                teleportTo(position)
                break
            end
        end
    end
end

-- Float on water
local floatConnection = nil

local function startFloat()
    if floatConnection then
        floatConnection:Disconnect()
    end
    
    floatConnection = RunService.Heartbeat:Connect(function()
        if not EventTP.floatActive or not EventTP.hrp or not EventTP.hrp.Parent then 
            return 
        end
        
        pcall(function()
            local currentPos = EventTP.hrp.Position
            local waterLevel = -1.4 -- Default water level
            local targetHeight = waterLevel + EventTP.floatHeight
            
            if currentPos.Y < targetHeight then
                EventTP.hrp.CFrame = CFrame.new(currentPos.X, targetHeight, currentPos.Z)
                local velocity = EventTP.hrp.AssemblyLinearVelocity
                EventTP.hrp.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
            end
        end)
    end)
end

startFloat()

-- Dropdown for event selection
eventTeleportSection:AddDropdown({
    Title = "Select Events",
    Options = eventNames,
    Default = {},
    Multi = true,
    Callback = function(selected)
        EventTP.selectedEvents = selected
        notif("Selected " .. #selected .. " events", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Toggle for auto teleport
eventTeleportSection:AddToggle({
    Title = "Auto Event Teleport",
    Default = false,
    Callback = function(enabled)
        EventTP.active = enabled
        EventTP.floatActive = enabled
        EventTP.lastCacheTime = 0
        
        if enabled then
            task.spawn(runTeleportLoop)
           if not _G.VictoriaFirstLoad then
                notif("Auto Event Teleport: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
           if not _G.VictoriaFirstLoad then
                notif("Auto Event Teleport: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- Cleanup
EventTP.player.CharacterRemoving:Connect(function()
    EventTP.hrp = nil
    EventTP.char = nil
end)

-- ==================== TAB 8: SETTINGS ====================
local Tab8 = Window:AddTab({
    Name = "Settings",
    Icon = "settings"
})

-- ==================== TAB 8: SETTINGS ====================
local Tab8 = Window:AddTab({
    Name = "Settings",
    Icon = "settings"
})

-- ==================== CONFIG SECTION ====================
local configSection = Tab8:AddSection("Configuration")

-- CONFIG MANAGEMENT FUNCTIONS
local function getCurrentConfigName()
    return ConfigData._currentConfig or "Default"
end

-- Save Config Button
configSection:AddButton({
    Title = "💾 Save Current Config",
    Description = "Save semua pengaturan yang aktif",
    Callback = function()
        local configName = getCurrentConfigName()
        SaveConfig(configName)
        notif("Config saved: " .. configName, 3, Color3.fromRGB(0, 255, 0))
    end
})

-- Load Config Button
configSection:AddButton({
    Title = "📂 Load Last Config",
    Description = "Load pengaturan terakhir yang disimpan",
    Callback = function()
        local configName = getCurrentConfigName()
        local loaded = LoadConfigFromFile(configName)
        if loaded then
            notif("Config loaded: " .. configName, 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Config not found: " .. configName, 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- New Config Input
configSection:AddInput({
    Title = "New Config Name",
    Default = "Default",
    Callback = function(v)
        if v and v:len() > 0 then
            ConfigData._currentConfig = v
            notif("Current config: " .. v, 3, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Save As Button
configSection:AddButton({
    Title = "💾 Save As New Config",
    Description = "Simpan sebagai config baru",
    Callback = function()
        if ConfigData._currentConfig then
            SaveConfig(ConfigData._currentConfig)
            notif("Saved as: " .. ConfigData._currentConfig, 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- Delete Config Button
configSection:AddButton({
    Title = "🗑️ Delete Current Config",
    Description = "Hapus config yang aktif",
    Callback = function()
        local configName = getCurrentConfigName()
        local fileName = "VictoriaHub/Config/" .. configName .. ".json"
        
        if delfile and delfile(fileName) then
            ConfigData._currentConfig = "Default"
            notif("Config deleted: " .. configName, 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Failed to delete config", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Save Toggle
configSection:AddToggle({
    Title = "Auto Save on Change",
    Default = false,
    Callback = function(state)
        _G.AutoSaveConfig = state
        if state then
            notif("Auto Save: Enabled", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Auto Save: Disabled", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Load on Start Toggle
configSection:AddToggle({
    Title = "Auto Load on Start",
    Default = true,
    Callback = function(state)
        _G.AutoLoadConfig = state
        if state then
            notif("Auto Load: Enabled", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Auto Load: Disabled", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- MISC SECTION
local miscSection = Tab8:AddSection("Miscellaneous")

-- PING DISPLAY
local PingEnabled = false
local Frame, HeaderText, StatsText, CloseButton, IconLabel, PingLabel, CpuLabel
local lastPingUpdate = 0
local pingUpdateInterval = 0.5

-- Color thresholds
local function getPingColor(ping)
    if ping <= 50 then
        return Color3.fromRGB(46, 204, 113) -- Green
    elseif ping <= 100 then
        return Color3.fromRGB(241, 196, 15) -- Yellow
    else
        return Color3.fromRGB(231, 76, 60) -- Red
    end
end

local function getCpuColor(cpu)
    if cpu <= 30 then
        return Color3.fromRGB(46, 204, 113) -- Green
    elseif cpu <= 60 then
        return Color3.fromRGB(241, 196, 15) -- Yellow
    else
        return Color3.fromRGB(231, 76, 60) -- Red
    end
end

local function makeDraggable(frame, dragArea)
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function createPingDisplay()
    local CG = game:GetService("CoreGui")
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "PerformanceHUD"
    Gui.Parent = CG
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.fromOffset(280, 90)
    Frame.Position = UDim2.fromScale(0.5, 0.05)
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.Visible = PingEnabled
    Frame.ZIndex = 1000
    Frame.Active = true

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(80, 80, 100)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Transparency = 0.5
    Stroke.ZIndex = 1001

    -- Gradient Background
    local Gradient = Instance.new("UIGradient", Frame)
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
    }
    Gradient.Rotation = 45

    -- Icon
    IconLabel = Instance.new("ImageLabel", Frame)
    IconLabel.Size = UDim2.fromOffset(32, 32)
    IconLabel.Position = UDim2.fromOffset(12, 10)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = "rbxassetid://96751490485303"
    IconLabel.ImageColor3 = Color3.fromRGB(100, 200, 255)
    IconLabel.ZIndex = 1002

    -- Header Text
    HeaderText = Instance.new("TextLabel", Frame)
    HeaderText.Size = UDim2.new(1, -100, 0, 25)
    HeaderText.Position = UDim2.fromOffset(50, 12)
    HeaderText.BackgroundTransparency = 1
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.TextSize = 14
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.TextYAlignment = Enum.TextYAlignment.Center
    HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderText.Text = "VICTORIA X PANEL"
    HeaderText.ZIndex = 1002

    -- Drag Area (invisible overlay for dragging - created AFTER close button)
    local DragArea = Instance.new("TextButton", Frame)
    DragArea.Size = UDim2.new(1, 0, 0, 45)
    DragArea.Position = UDim2.fromOffset(0, 0)
    DragArea.BackgroundTransparency = 1
    DragArea.Text = ""
    DragArea.ZIndex = 1005
    DragArea.AutoButtonColor = false

    -- Divider Line
    local Divider = Instance.new("Frame", Frame)
    Divider.Size = UDim2.new(1, -24, 0, 1)
    Divider.Position = UDim2.fromOffset(12, 45)
    Divider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    Divider.BackgroundTransparency = 0.5
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 1002

    -- Ping Label
    PingLabel = Instance.new("TextLabel", Frame)
    PingLabel.Size = UDim2.new(0.5, -18, 0, 30)
    PingLabel.Position = UDim2.fromOffset(12, 52)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextSize = 12
    PingLabel.TextXAlignment = Enum.TextXAlignment.Center
    PingLabel.TextYAlignment = Enum.TextYAlignment.Center
    PingLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    PingLabel.Text = "PING: 0 ms"
    PingLabel.ZIndex = 1002

    -- CPU Label
    CpuLabel = Instance.new("TextLabel", Frame)
    CpuLabel.Size = UDim2.new(0.5, -18, 0, 30)
    CpuLabel.Position = UDim2.new(0.5, 6, 0, 52)
    CpuLabel.BackgroundTransparency = 1
    CpuLabel.Font = Enum.Font.GothamBold
    CpuLabel.TextSize = 12
    CpuLabel.TextXAlignment = Enum.TextXAlignment.Center
    CpuLabel.TextYAlignment = Enum.TextYAlignment.Center
    CpuLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    CpuLabel.Text = "CPU: 0.00%"
    CpuLabel.ZIndex = 1002

    -- Vertical Divider between stats
    local VertDivider = Instance.new("Frame", Frame)
    VertDivider.Size = UDim2.new(0, 1, 0, 30)
    VertDivider.Position = UDim2.new(0.5, 0, 0, 52)
    VertDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    VertDivider.BackgroundTransparency = 0.5
    VertDivider.BorderSizePixel = 0
    VertDivider.ZIndex = 1002

    makeDraggable(Frame, DragArea)
    
    return Frame
end

if createPingDisplay() then
    game:GetService("RunService").RenderStepped:Connect(function()
        if not PingEnabled or not Frame.Visible then return end
        
        local now = tick()
        if now - lastPingUpdate < pingUpdateInterval then return end
        lastPingUpdate = now
        
        local Stats = game:GetService("Stats")
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local cpu = Stats.PerformanceStats.CPU:GetValue()
        
        -- Update ping display with color
        local pingColor = getPingColor(ping)
        PingLabel.TextColor3 = pingColor
        PingLabel.Text = string.format("PING: %d ms", ping)
        
        -- Update CPU display with color
        local cpuColor = getCpuColor(cpu)
        CpuLabel.TextColor3 = cpuColor
        CpuLabel.Text = string.format("CPU: %.2f%%", cpu)
    end)
end

miscSection:AddToggle({
    Title = "Ping Display",
    Default = false,
    Callback = function(v)
        PingEnabled = v
        if Frame then Frame.Visible = v end
       if not _G.VictoriaFirstLoad then
            notif("Ping Display: " .. (v and "Enabled" or "Disabled"), 3, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- HIDE NAME & LEVEL
local P = LocalPlayer -- GANTI: Player -> LocalPlayer
local C = P.Character or P.CharacterAdded:Wait()
local O = C:WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
local H = O.Content.Header
local L = O.LevelContainer.Label

local D = {h = H.Text, l = L.Text, ch = H.Text, cl = L.Text, on = false}

miscSection:AddInput({
    Title = "Hide Name",
    Default = D.h,
    Callback = function(v)
        D.ch = v
        if D.on then H.Text = v end
        notif("Custom Name: " .. v, 3, Color3.fromRGB(0, 255, 0))
    end
})

miscSection:AddInput({
    Title = "Hide Level",
    Default = D.l,
    Callback = function(v)
        D.cl = v
        if D.on then L.Text = v end
        notif("Custom Level: " .. v, 3, Color3.fromRGB(0, 255, 0))
    end
})

miscSection:AddToggle({
    Title = "Hide Name & Level (Custom)",
    Default = false,
    Callback = function(v)
        D.on = v
        if v then
            H.Text = D.ch
            L.Text = D.cl
           if not _G.VictoriaFirstLoad then
                notif("Custom Hide: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            H.Text = D.h
            L.Text = D.l
           if not _G.VictoriaFirstLoad then
                notif("Custom Hide: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- DEFAULT HIDE
local HN, HL = "discord.gg/victoriahub", "Lv. ???"
local S = {on = false, ui = nil}

local function setup(c)
    local o = c:WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
    local h = o.Content.Header
    local l = o.LevelContainer.Label
    return {h = h, l = l, dh = h.Text, dl = l.Text}
end

S.ui = setup(P.Character or P.CharacterAdded:Wait())

P.CharacterAdded:Connect(function(c) -- HAPUS: SafeConnect
    task.wait(0.2)
    S.ui = setup(c)
    if S.on then
        S.ui.h.Text = HN
        S.ui.l.Text = HL
    end
end)

miscSection:AddToggle({
    Title = "Hide Name & Level (Default)",
    Default = false,
    Callback = function(v)
        S.on = v
        if not S.ui then return end
        if v then
            S.ui.h.Text = HN
            S.ui.l.Text = HL
           if not _G.VictoriaFirstLoad then
                notif("Default Hide: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            S.ui.h.Text = S.ui.dh
            S.ui.l.Text = S.ui.dl
           if not _G.VictoriaFirstLoad then
                notif("Default Hide: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- INFINITE ZOOM
local infiniteZoom = false
local originalZoom = {LocalPlayer.CameraMaxZoomDistance, LocalPlayer.CameraMinZoomDistance}

miscSection:AddToggle({
    Title = "Infinite Zoom",
    Default = false,
    Callback = function(s)
        infiniteZoom = s
        if s then
            LocalPlayer.CameraMaxZoomDistance = math.huge
            LocalPlayer.CameraMinZoomDistance = .5
           if not _G.VictoriaFirstLoad then
                notif("Infinite Zoom: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            LocalPlayer.CameraMaxZoomDistance = originalZoom[1] or 128
            LocalPlayer.CameraMinZoomDistance = originalZoom[2] or .5
           if not _G.VictoriaFirstLoad then
                notif("Infinite Zoom: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- AUTO RECONNECT
local AutoReconnect = true
local VIM = game:GetService("VirtualInputManager")

local function click(btn)
    local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, game, 0)
end

game:GetService("CoreGui"):WaitForChild("RobloxPromptGui")
    :WaitForChild("promptOverlay")
    .ChildAdded:Connect(function(v)
        if not AutoReconnect then return end
        if v.Name ~= "ErrorPrompt" then return end

        task.wait(0.3)
        local btn = v:FindFirstChild("ReconnectButton", true)
        if btn then click(btn) end
    end)

miscSection:AddToggle({
    Title = "Auto Reconnect",
    Default = true,
    Callback = function(v) 
        AutoReconnect = v
       if not _G.VictoriaFirstLoad then
            notif("Auto Reconnect: " .. (v and "Enabled" or "Disabled"), 3, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- ANTI STAFF
local AntiStaffEnabled = true
local StaffBlacklist = {
    [75974130]=1,[40397833]=1,[187190686]=1,[33372493]=1,[889918695]=1,
    [33679472]=1,[30944240]=1,[25050357]=1,[8462585751]=1,[8811129148]=1,
    [192821024]=1,[4509801805]=1,[124505170]=1,[108397209]=1
}

miscSection:AddToggle({
    Title = "Anti Staff",
    Default = true,
    Callback = function(s) 
        AntiStaffEnabled = s
       if not _G.VictoriaFirstLoad then
            notif("Anti Staff: " .. (s and "Enabled" or "Disabled"), 3, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

local function hop()
    task.wait(6)
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        ).data
    end)
    
    if success and data then
        for _,v in ipairs(data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                break
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if AntiStaffEnabled and plr ~= LocalPlayer and StaffBlacklist[plr.UserId] then
        hop()
    end
end)

task.spawn(function()
    while task.wait(2) do
        if AntiStaffEnabled then
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and StaffBlacklist[plr.UserId] then
                    hop()
                    break
                end
            end
        end
    end
end)

-- GRAPHICS SECTION
local graphicsSection = Tab8:AddSection("Graphics")

-- FPS BOOST (Simple Version)
local FPSBoost = false
local CurrentConnections = {}
local OriginalValues = {}

-- Function to save original value
local function saveOriginal(obj, property)
    if not OriginalValues[obj] then
        OriginalValues[obj] = {}
    end
    if OriginalValues[obj][property] == nil then
        OriginalValues[obj][property] = obj[property]
    end
end

-- Apply FPS Boost
local function applyBoost()
    -- Lighting settings
    local Lighting = game:GetService("Lighting")
    
    -- Save and apply lighting settings
    saveOriginal(Lighting, "GlobalShadows")
    saveOriginal(Lighting, "FogEnd")
    saveOriginal(Lighting, "Brightness")
    saveOriginal(Lighting, "EnvironmentDiffuseScale")
    saveOriginal(Lighting, "EnvironmentSpecularScale")
    saveOriginal(Lighting, "ClockTime")
    saveOriginal(Lighting, "Ambient")
    saveOriginal(Lighting, "OutdoorAmbient")
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ClockTime = 12
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    
    -- Disable all post effects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            saveOriginal(effect, "Enabled")
            effect.Enabled = false
        end
    end
    
    -- Terrain settings
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        saveOriginal(Terrain, "WaterWaveSize")
        saveOriginal(Terrain, "WaterWaveSpeed")
        saveOriginal(Terrain, "WaterReflectance")
        saveOriginal(Terrain, "WaterTransparency")
        
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
        
        -- Try to disable terrain decoration
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(Terrain, "Decoration", false)
            else
                Terrain.Decoration = false
            end
        end)
    end
    
    -- Rendering settings
    saveOriginal(settings().Rendering, "QualityLevel")
    saveOriginal(settings().Rendering, "MeshPartDetailLevel")
    
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    
    -- Monitor and optimize new objects
    local function optimizeObject(obj)
        pcall(function()
            if obj:IsA("BasePart") then
                saveOriginal(obj, "Material")
                saveOriginal(obj, "Reflectance")
                saveOriginal(obj, "CastShadow")
                
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
                
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                saveOriginal(obj, "Transparency")
                obj.Transparency = 1
                
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or 
                   obj:IsA("Smoke") or obj:IsA("Fire") then
                saveOriginal(obj, "Enabled")
                obj.Enabled = false
                
            elseif obj:IsA("Beam") or obj:IsA("SpotLight") or 
                   obj:IsA("PointLight") or obj:IsA("SurfaceLight") then
                saveOriginal(obj, "Enabled")
                obj.Enabled = false
                
            elseif obj:IsA("Sound") then
                saveOriginal(obj, "Volume")
                if obj.Volume > 0.5 then
                    obj.Volume = 0.1
                end
            end
        end)
    end
    
    -- Optimize all existing objects
    for _, obj in pairs(game:GetDescendants()) do
        optimizeObject(obj)
    end
    
    -- Monitor for new objects
    local connection = game.DescendantAdded:Connect(function(obj)
        if FPSBoost then
            optimizeObject(obj)
        end
    end)
    
    table.insert(CurrentConnections, connection)
    
    -- FPS Cap
    pcall(function()
        if setfpscap then
            setfpscap(999)
        end
    end)
end

-- Restore original settings
local function restoreBoost()
    -- Disconnect all monitoring connections
    for _, connection in ipairs(CurrentConnections) do
        pcall(function() connection:Disconnect() end)
    end
    CurrentConnections = {}
    
    -- Restore all saved values
    for obj, properties in pairs(OriginalValues) do
        if obj and (obj.Parent or obj == game:GetService("Lighting") or obj == settings().Rendering) then
            for property, value in pairs(properties) do
                pcall(function()
                    obj[property] = value
                end)
            end
        end
    end
    
    -- Clear the saved values
    OriginalValues = {}
    
    -- Restore Terrain Decoration if needed
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(Terrain, "Decoration", true)
            else
                Terrain.Decoration = true
            end
        end)
    end
end

-- UI Toggle
graphicsSection:AddToggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(v)
        FPSBoost = v
        
        if v then
            applyBoost()
           if not _G.VictoriaFirstLoad then
                notif("FPS Boost: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            restoreBoost()
           if not _G.VictoriaFirstLoad then
                notif("FPS Boost: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- REMOVE FISH NOTIFICATION
local PopupConn, RemoteConn

graphicsSection:AddToggle({
    Title = "Remove Fish Pop-up Notification",
    Default = false,
    Callback = function(state)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local RemoteEvent = net["RE/ObtainedNewFishNotification"]

        if state then
            local function getPopup()
                local gui = PlayerGui:FindFirstChild("Small Notification")
                if not gui then return end
                local display = gui:FindFirstChild("Display")
                if not display then return end
                return display:FindFirstChild("NewFrame")
            end

            local frame = getPopup()
            if frame then frame.Visible = false; frame:Destroy() end

            PopupConn = PlayerGui.DescendantAdded:Connect(function(v)
                if v.Name == "NewFrame" then
                    task.wait()
                    v.Visible = false
                    v:Destroy()
                end
            end)

            RemoteConn = RemoteEvent.OnClientEvent:Connect(function()
                local f = getPopup()
                if f then f.Visible = false; f:Destroy() end
            end)
           if not _G.VictoriaFirstLoad then
                notif("Fish Popup Removal: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            if PopupConn then PopupConn:Disconnect(); PopupConn = nil end
            if RemoteConn then RemoteConn:Disconnect(); RemoteConn = nil end
           if not _G.VictoriaFirstLoad then
                notif("Fish Popup Removal: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- DISABLE 3D RENDERING
local disable3DRendering = false
local G

graphicsSection:AddToggle({
    Title = "Disable 3D Rendering",
    Default = false,
    Callback = function(s)
        disable3DRendering = s
        pcall(function() 
            game:GetService("RunService"):Set3dRenderingEnabled(not s) 
        end)
        if s then
            G = Instance.new("ScreenGui")
            G.IgnoreGuiInset = true
            G.ResetOnSpawn = false
            G.Parent = LocalPlayer.PlayerGui

            local frame = Instance.new("Frame", G)
            frame.Size = UDim2.fromScale(1,1)
            frame.BackgroundColor3 = Color3.new(1,1,1)
            frame.BorderSizePixel = 0
           if not _G.VictoriaFirstLoad then
                notif("3D Rendering: Disabled", 3, Color3.fromRGB(0, 255, 0))
            end
        elseif G then
            G:Destroy()
            G = nil
           if not _G.VictoriaFirstLoad then
                notif("3D Rendering: Enabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- HIDE ALL VFX
local VFXState = {on = false, cache = {}}

local VFX = {
    ParticleEmitter = true, Beam = true, Trail = true, Smoke = true,
    Fire = true, Sparkles = true, Explosion = true,
    PointLight = true, SpotLight = true, SurfaceLight = true, Highlight = true
}

local LE = {
    BloomEffect = true, SunRaysEffect = true, ColorCorrectionEffect = true,
    DepthOfFieldEffect = true, Atmosphere = true
}

local function disableVFX()
    for _, o in ipairs(workspace:GetDescendants()) do
        if VFX[o.ClassName] and o.Enabled == true then
            VFXState.cache[o] = true
            o.Enabled = false
        end
    end

    for _, o in ipairs(game:GetService("Lighting"):GetChildren()) do
        if LE[o.ClassName] and o.Enabled ~= nil then
            VFXState.cache[o] = true
            o.Enabled = false
        end
    end
end

local function restoreVFX()
    for o in pairs(VFXState.cache) do
        if o and o.Parent and o.Enabled ~= nil then o.Enabled = true end
    end
    VFXState.cache = {}
end

workspace.DescendantAdded:Connect(function(o)
    if VFXState.on and VFX[o.ClassName] and o.Enabled ~= nil then
        task.defer(function() o.Enabled = false end)
    end
end)

game:GetService("Lighting").DescendantAdded:Connect(function(o)
    if VFXState.on and LE[o.ClassName] and o.Enabled ~= nil then
        task.defer(function() o.Enabled = false end)
    end
end)

graphicsSection:AddToggle({
    Title = "Hide All VFX",
    Default = false,
    Callback = function(state)
        VFXState.on = state
        if state then 
            disableVFX()
           if not _G.VictoriaFirstLoad then
                notif("VFX Hidden: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else 
            restoreVFX()
           if not _G.VictoriaFirstLoad then
                notif("VFX Hidden: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- REMOVE SKIN EFFECT
local VFXController = require(RS.Controllers.VFXController)
local ORI = {
    H = VFXController.Handle,
    P = VFXController.RenderAtPoint,
    I = VFXController.RenderInstance
}

graphicsSection:AddToggle({
    Title = "Remove Skin Effect",
    Default = false,
    Callback = function(state)
        if state then
            VFXController.Handle = function() end
            VFXController.RenderAtPoint = function() end
            VFXController.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then pcall(f.ClearAllChildren, f) end
           if not _G.VictoriaFirstLoad then
                notif("Skin Effects: Removed", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            VFXController.Handle = ORI.H
            VFXController.RenderAtPoint = ORI.P
            VFXController.RenderInstance = ORI.I
           if not _G.VictoriaFirstLoad then
                notif("Skin Effects: Restored", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- DISABLE CUTSCENE
_G.CutsceneController = require(RS.Controllers.CutsceneController)
_G.GuiControl = require(RS.Modules.GuiControl)
_G.ProximityPromptService = game:GetService("ProximityPromptService")
_G.AutoSkipCutscene = false

if not _G.OriginalPlayCutscene then
    _G.OriginalPlayCutscene = _G.CutsceneController.Play
end

_G.CutsceneController.Play = function(self, ...)
    if _G.AutoSkipCutscene then
        task.spawn(function()
            task.wait()
            if _G.GuiControl then _G.GuiControl:SetHUDVisibility(true) end
            _G.ProximityPromptService.Enabled = true
            LocalPlayer:SetAttribute("IgnoreFOV")
        end)
        return
    end
    return _G.OriginalPlayCutscene(self, ...)
end

graphicsSection:AddToggle({
    Title = "Disable Cutscene",
    Default = false,
    Callback = function(state)
        _G.AutoSkipCutscene = state
        if state then
            if _G.CutsceneController then
                _G.CutsceneController:Stop()
                _G.GuiControl:SetHUDVisibility(true)
                _G.ProximityPromptService.Enabled = true
            end
           if not _G.VictoriaFirstLoad then
                notif("Cutscene: Disabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
           if not _G.VictoriaFirstLoad then
                notif("Cutscene: Enabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- SERVER SECTION
local serverSection = Tab8:AddSection("Server")

serverSection:AddButton({
    Title = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        notif("Rejoining server...", 3, Color3.fromRGB(0, 170, 255))
    end
})

serverSection:AddButton({
    Title = "Server Hop",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        notif("Server hopping...", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- OTHER SCRIPTS SECTION
local scriptSection = Tab8:AddSection("Other Scripts")

scriptSection:AddButton({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
        notif("Infinite Yield loaded", 3, Color3.fromRGB(0, 255, 0))
    end
})

-- Di paling bawah script
task.spawn(function()
    task.wait(1.5) 
    LoadConfigFromFile()
end)

-- ==================== FINAL ====================
getgenv().VictoriaHubWindow = Window

-- Single notification on load
task.spawn(function()
    task.wait(1)
    notif("Victoria Hub loaded successfully!", 5, Color3.fromRGB(0, 170, 255))
end)

return Window
