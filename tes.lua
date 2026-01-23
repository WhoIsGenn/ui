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
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1458894965131313268/1463597577680195767/Logo_neon__V__berkilau_di_malam_hari.png?ex=69746336&is=697311b6&hm=83432870e4d37e75103adf109fa752752ba10e97f6f4637eaf8d4efc3f567b84&",
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
    Title = "Victoria Hub",
    Footer = "VictoriaHub | Fish It",
    Color = Color3.fromRGB(138, 43, 226),
    ["Tab Width"] = 120,
    Version = "1.0.0",
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

-- TITLE ANIMATION
task.spawn(function()
    task.wait(2)
    local character = LocalPlayer.Character
    if character then
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            local overhead = hrp:WaitForChild("Overhead", 3)
            if overhead then
                local titleContainer = overhead:WaitForChild("TitleContainer", 2)
                if titleContainer then
                    titleContainer.Visible = false
                    local title = titleContainer:WaitForChild("Label", 1)
                    if title then
                        title.TextScaled = false
                        title.TextSize = 19
                        title.Text = "Victoria Hub"

                        local uiStroke = Instance.new("UIStroke")
                        uiStroke.Thickness = 2
                        uiStroke.Color = Color3.fromRGB(170, 0, 255)
                        uiStroke.Parent = title

                        local colors = {
                            Color3.fromRGB(0, 255, 255),
                            Color3.fromRGB(255, 0, 127),
                            Color3.fromRGB(0, 255, 127),
                            Color3.fromRGB(255, 255, 0)
                        }

                        local i = 1
                        local function colorCycle()
                            if not title or not title.Parent then return end
                            
                            local nextColor = colors[(i % #colors) + 1]
                            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                            
                            game:GetService("TweenService"):Create(title, tweenInfo, { TextColor3 = nextColor }):Play()
                            game:GetService("TweenService"):Create(uiStroke, tweenInfo, { Color = nextColor }):Play()
                            
                            i += 1
                            task.delay(1.5, colorCycle)
                        end
                        
                        colorCycle()
                    end
                end
            end
        end
    end
end)

-- ==================== TAB 1: INFO ====================
local Tab1 = Window:AddTab({
    Name = "Info",
    Icon = "alert"
})

local infoSection = Tab1:AddSection("Information")

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
playerSection:AddInput({
    Title = "Walk Speed",
    Content = "Default: 16 | Press Enter to apply",
    Default = "16",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 18 and num <= 100 then
            walkSpeedValue = num
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid.WalkSpeed = num 
            end
        end
    end
})

-- JUMP POWER INPUT
local jumpPowerValue = 50
playerSection:AddInput({
    Title = "Jump Power",
    Content = "Default: 50 | Press Enter to apply",
    Default = "50",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 50 and num <= 500 then
            jumpPowerValue = num
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid.JumpPower = num 
            end
        end
    end
})

-- INFINITE JUMP
local UIS = game:GetService("UserInputService")
_G.InfiniteJump = false

playerSection:AddToggle({
    Title = "Infinite Jump",
    Content = "Activate to use infinite jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
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
    Content = "Walk through walls",
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
    end
})

-- FREEZE CHARACTER
local frozen = false
local lastCFrame = nil

playerSection:AddToggle({
    Title = "Freeze Character",
    Content = "Freeze your character in place",
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
        else
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
            hrp.Anchored = false
            if lastCFrame then
                hrp.CFrame = lastCFrame
            end
        end
    end
})

-- DISABLE ANIMATIONS
local animDisabled = false
local animConn

playerSection:AddToggle({
    Title = "Disable Animations",
    Content = "Disable character animations",
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
        else
            if animConn then animConn:Disconnect(); animConn = nil end
            local animate = character:FindFirstChild("Animate")
            if animate then animate.Disabled = false end
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            task.wait()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
})

-- WALK ON WATER
local isWalkOnWater = false
local waterPlatform = nil
local walkOnWaterConnection = nil

playerSection:AddToggle({
    Title = "Walk on Water",
    Content = "Walk on water surface",
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
        end
    end
})

-- ==================== TAB 3: MAIN (FISHING) ====================
local Tab3 = Window:AddTab({
    Name = "Main",
    Icon = "fish"
})

-- FISHING SECTION
local fishingSection = Tab3:AddSection("Fishing Features")

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

local function rod()
    safeCall("rod", function()
        net["RE/EquipToolFromHotbar"]:FireServer(1)
    end)
end

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
        net["RE/FishingCompleted"]:FireServer()
    end)
end

local function charge()
    safeCall("charge", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function lempar()
    safeCall("lempar", function()
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996, -1761532005.497)
    end)
    safeCall("charge2", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function instant_cycle()
    charge()
    lempar()
    task.wait(_G.InstantDelay)
    catch()
end

local mode = "Instant"

-- Auto Fishing Toggle
fishingSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Automatically fish",
    Default = false,
    Callback = function(v)
        _G.AutoFishing = v
        
        if fishThread then
            task.cancel(fishThread)
            fishThread = nil
        end
        
        if v then
            if mode == "Instant" then
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Instant" do
                        instant_cycle()
                        task.wait(_G.InstantDelay)
                    end
                end)
            else
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Legit" do
                        autoon()
                        task.wait(1)
                    end
                end)
            end
        else
            autooff()
        end
    end
})

-- Mode Dropdown
local modeOptions = {"Instant", "Legit"}
fishingSection:AddDropdown({
    Title = "Fishing Mode",
    Content = "Select fishing mode",
    Options = modeOptions,
    Default = "Instant",
    Callback = function(v)
        mode = v
        
        -- Stop fishing when switching modes
        if _G.AutoFishing then
            _G.AutoFishing = false
            autooff()
            if fishThread then 
                task.cancel(fishThread) 
                fishThread = nil
            end
        end
    end
})

-- Instant Fishing Delay Input
fishingSection:AddInput({
    Title = "Instant Fishing Delay",
    Content = "Delay between fishing cycles (Instant mode only)",
    Default = "0.65",
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 0.05 and num <= 5 then
            _G.InstantDelay = num
        end
    end
})

-- Auto Equip Rod
fishingSection:AddToggle({
    Title = "Auto Equip Rod",
    Content = "Automatically equip fishing rod",
    Default = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        if v then
            rod()
        end
    end
})

-- RADAR
local radarEnabled = false
fishingSection:AddToggle({
    Title = "Radar",
    Content = "Enable fishing radar",
    Default = false,
    Callback = function(s)
        radarEnabled = s
        local RS, L = game.ReplicatedStorage, game.Lighting
        if require(RS.Packages.Replion).Client:GetReplion("Data") then
            require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar"):InvokeServer(s)
        end
    end
})

-- BYPASS OXYGEN
fishingSection:AddToggle({
    Title = "Bypass Oxygen",
    Content = "Infinite Oxygen tank",
    Default = false,
    Callback = function(s)
        if s then 
            net["RF/EquipOxygenTank"]:InvokeServer(105)
        else 
            net["RF/UnequipOxygenTank"]:InvokeServer() 
        end
    end
})

-- BLATANT V1 SECTION
local blatantV1Section = Tab3:AddSection("Blatant V1", false)

local c1 = { d = false, e = 1.55, f = 0.22 } -- ganti nama variabel dari 'c' ke 'c1'
local m1 = nil
local n1 = nil

-- Cancel Delay Input
blatantV1Section:AddInput({
    Title = "Cancel Delay",
    Content = "Delay before canceling fishing (seconds)",
    Default = "1.7",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            c1.e = num
        end
    end
})

-- Complete Delay Input
blatantV1Section:AddInput({
    Title = "Complete Delay",
    Content = "Delay before completing fishing (seconds)",
    Default = "1.4",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            c1.f = num
        end
    end
})

-- Blatant V1 Toggle
blatantV1Section:AddToggle({
    Title = "Blatant Mode V1",
    Content = "Enable Blatant V1 fishing",
    Default = false,
    Callback = function(z2)
        c1.d = z2
        if z2 then
            if m1 then task.cancel(m1) end
            if n1 then task.cancel(n1) end
            m1 = task.spawn(function()
                n1 = task.spawn(function()
                    while c1.d do
                        pcall(function()
                            net["RE/EquipToolFromHotbar"]:FireServer(1)
                        end)
                        task.wait(1.5)
                    end
                end)
                
                while c1.d do
                    task.spawn(function()
                        pcall(function()
                            net["RF/CancelFishingInputs"]:InvokeServer()
                            net["RF/ChargeFishingRod"]:InvokeServer(math.huge)
                            net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996)
                        end)
                    end)
                    
                    task.spawn(function()
                        task.wait(c1.f)
                        if c1.d then
                            pcall(function()
                                net["RE/FishingCompleted"]:FireServer()
                            end)
                        end
                    end)
                    
                    task.wait(c1.e)
                    if not c1.d then break end
                    task.wait(0.1)
                end
            end)
        else
            if m1 then task.cancel(m1) end
            if n1 then task.cancel(n1) end
            m1 = nil
            n1 = nil
            pcall(function()
                net["RF/CancelFishingInputs"]:InvokeServer()
            end)
        end
    end
})

-- BLATANT V2 SECTION
local blatantV2Section = Tab3:AddSection("Blatant V2", false)

-- ========== BLATANT V2 CONFIG & FUNCTIONS ==========
local RS = game:GetService("ReplicatedStorage") -- Pakai RS yang sudah ada

local netFolder = RS:WaitForChild('Packages')
    :WaitForChild('_Index')
    :WaitForChild('sleitnick_net@0.2.0')
    :WaitForChild('net')

local Remotes = {}
Remotes.RF_RequestFishingMinigameStarted = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
Remotes.RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
Remotes.RF_CancelFishing = netFolder:WaitForChild("RF/CancelFishingInputs")
Remotes.RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
Remotes.RE_EquipTool = netFolder:WaitForChild("RE/EquipToolFromHotbar")

local toggleState = {
    blatantRunning = false,
    completeDelays = 0.08,
    delayStart = 0.25
}

local isSuperInstantRunning = false
_G.ReelSuper = 1.25

-- Load FishingController async
local FishingController, oldCharge
task.spawn(function()
    local success, controller = pcall(function()
        return require(RS:WaitForChild('Controllers'):WaitForChild('FishingController'))
    end)
    
    if success and controller then
        FishingController = controller
        oldCharge = controller.RequestChargeFishingRod
        
        controller.RequestChargeFishingRod = function(...)
            if toggleState.blatantRunning then
                return
            end
            return oldCharge(...)
        end
    end
end)

local function superInstantFishingCycle()
    task.spawn(function()
        pcall(function()
            Remotes.RF_CancelFishing:InvokeServer()
            Remotes.RF_ChargeFishingRod:InvokeServer(tick())
            Remotes.RF_RequestFishingMinigameStarted:InvokeServer(-139.63796997070312, 0.9964792798079721)
            task.wait(toggleState.completeDelays)
            Remotes.RE_FishingCompleted:FireServer()
        end)
    end)
end

local function startSuperInstantFishing()
    if isSuperInstantRunning then return end
    isSuperInstantRunning = true

    task.spawn(function()
        while isSuperInstantRunning do
            superInstantFishingCycle()
            task.wait(math.max(_G.ReelSuper, 0.1))
        end
    end)
end

local function stopSuperInstantFishing()
    isSuperInstantRunning = false
    -- Restore original function
    if FishingController and oldCharge then
        FishingController.RequestChargeFishingRod = oldCharge
    end
end

blatantV2Section:AddToggle({
    Title = "Blatant Mode V2",
    Content = "Enable Blatant V2 fishing",
    Default = false,
    Callback = function(value)
        toggleState.blatantRunning = value
        
        if value then
            startSuperInstantFishing()
        else
            stopSuperInstantFishing()
        end
    end
})

blatantV2Section:AddInput({
    Title = "Reel Delay",
    Content = "Delay between reels (seconds)",
    Default = tostring(_G.ReelSuper),
    Callback = function(input)
        local num = tonumber(input)
        if num and num >= 0 then
            _G.ReelSuper = num
        end
    end
})

blatantV2Section:AddInput({
    Title = "Complete Delay",
    Content = "Delay before completing (seconds)",
    Default = tostring(toggleState.completeDelays),
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            toggleState.completeDelays = num
        end
    end
})

-- BLATANT V3 SECTION
local blatantV3Section = Tab3:AddSection("Blatant Unstable", false)

-- ========= BLATANT V3 CONFIG =========
local c3 = {  -- ganti nama variabel dari 'c' ke 'c3'
    d = false,        -- toggle
    e = 1.55,         -- loop delay
    f = 0.22,         -- complete delay
    charges = 3,      -- jumlah charge
    chargeDelay = 0.08
}

-- ========= NET V3 =========
local g3 = RS:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local h3, i3, j3, k3, l3
pcall(function()
    h3 = g3:WaitForChild("RF/ChargeFishingRod")
    i3 = g3:WaitForChild("RF/RequestFishingMinigameStarted")
    j3 = g3:WaitForChild("RE/FishingCompleted")
    k3 = g3:WaitForChild("RE/EquipToolFromHotbar")
    l3 = g3:WaitForChild("RF/CancelFishingInputs")
end)

local m3, n3 = nil, nil

-- ========= CORE ACTION V3 =========
local function p3()
    task.spawn(function()
        pcall(function()
            -- cancel
            if l3 then l3:InvokeServer() end
            task.wait(0.03)

            -- charge
            for _ = 1, c3.charges do
                if h3 then h3:InvokeServer(math.huge) end
                task.wait(c3.chargeDelay)
            end

            -- start minigame
            if i3 then i3:InvokeServer(-139.63, 0.996) end
        end)
    end)

    task.spawn(function()
        task.wait(c3.f)
        if c3.d and j3 then
            pcall(j3.FireServer, j3)
        end
    end)
end

-- ========= LOOP V3 =========
local function w3()
    -- auto equip
    n3 = task.spawn(function()
        while c3.d do
            if k3 then pcall(k3.FireServer, k3, 1) end
            task.wait(1.5)
        end
    end)

    while c3.d do
        p3()
        task.wait(c3.e)
    end
end

-- ========= TOGGLE V3 =========
local function x3(state)
    c3.d = state

    if state then
        if m3 then task.cancel(m3) end
        if n3 then task.cancel(n3) end
        m3 = task.spawn(w3)
    else
        if m3 then task.cancel(m3) end
        if n3 then task.cancel(n3) end
        m3, n3 = nil, nil
        if l3 then pcall(l3.InvokeServer, l3) end
    end
end

-- BLATANT V3 UI
-- Reel / Loop Delay
blatantV3Section:AddInput({
    Title = "Reel Delay",
    Content = "Delay antar fishing loop (detik)",
    Default = tostring(c3.e),
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0.2 then
            c3.e = num
        end
    end
})

-- Complete Delay
blatantV3Section:AddInput({
    Title = "Complete Delay",
    Content = "Delay sebelum FishingCompleted",
    Default = tostring(c3.f),
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0.05 then
            c3.f = num
        end
    end
})

-- Toggle
blatantV3Section:AddToggle({
    Title = "Blatant Mode V3",
    Content = "Enable Blatant V3",
    Default = false,
    Callback = function(state)
        x3(state)
    end
})

-- RECOVERY FISHING BUTTONS
blatantV1Section:AddButton({
    Title = "Recovery Fishing",
    Content = "Reset fishing state",
    Callback = function()
        -- Stop Blatant V1
        if c1.d then
            c1.d = false
            if m1 then task.cancel(m1); m1 = nil end
            if n1 then task.cancel(n1); n1 = nil end
        end
        
        -- Stop Blatant V2
        if toggleState.blatantRunning then
            toggleState.blatantRunning = false
            isSuperInstantRunning = false
        end
        
        -- Stop Blatant V3
        if c3.d then
            c3.d = false
            if m3 then task.cancel(m3); m3 = nil end
            if n3 then task.cancel(n3); n3 = nil end
        end
        
        -- Cancel all fishing
        pcall(function() 
            net["RF/CancelFishingInputs"]:InvokeServer() 
            if Remotes.RF_CancelFishing then Remotes.RF_CancelFishing:InvokeServer() end
            if l3 then l3:InvokeServer() end
        end)
        
        -- Reset rod
        pcall(function() 
            net["RE/EquipToolFromHotbar"]:FireServer(1) 
            if Remotes.RE_EquipTool then Remotes.RE_EquipTool:FireServer(1) end
            if k3 then k3:FireServer(1) end
        end)
    end
})

blatantV2Section:AddButton({
    Title = "Recovery Fishing",
    Content = "Reset fishing state",
    Callback = function()
        -- Stop Blatant V1
        if c1.d then
            c1.d = false
            if m1 then task.cancel(m1); m1 = nil end
            if n1 then task.cancel(n1); n1 = nil end
        end
        
        -- Stop Blatant V2
        if toggleState.blatantRunning then
            toggleState.blatantRunning = false
            isSuperInstantRunning = false
        end
        
        -- Stop Blatant V3
        if c3.d then
            c3.d = false
            if m3 then task.cancel(m3); m3 = nil end
            if n3 then task.cancel(n3); n3 = nil end
        end
        
        -- Cancel all fishing
        pcall(function() 
            net["RF/CancelFishingInputs"]:InvokeServer() 
            if Remotes.RF_CancelFishing then Remotes.RF_CancelFishing:InvokeServer() end
            if l3 then l3:InvokeServer() end
        end)
        
        -- Reset rod
        pcall(function() 
            net["RE/EquipToolFromHotbar"]:FireServer(1) 
            if Remotes.RE_EquipTool then Remotes.RE_EquipTool:FireServer(1) end
            if k3 then k3:FireServer(1) end
        end)
    end
})

blatantV3Section:AddButton({
    Title = "Recovery Fishing",
    Content = "Reset fishing state",
    Callback = function()
        -- Stop Blatant V1
        if c1.d then
            c1.d = false
            if m1 then task.cancel(m1); m1 = nil end
            if n1 then task.cancel(n1); n1 = nil end
        end
        
        -- Stop Blatant V2
        if toggleState.blatantRunning then
            toggleState.blatantRunning = false
            isSuperInstantRunning = false
        end
        
        -- Stop Blatant V3
        if c3.d then
            c3.d = false
            if m3 then task.cancel(m3); m3 = nil end
            if n3 then task.cancel(n3); n3 = nil end
        end
        
        -- Cancel all fishing
        pcall(function() 
            net["RF/CancelFishingInputs"]:InvokeServer() 
            if Remotes.RF_CancelFishing then Remotes.RF_CancelFishing:InvokeServer() end
            if l3 then l3:InvokeServer() end
        end)
        
        -- Reset rod
        pcall(function() 
            net["RE/EquipToolFromHotbar"]:FireServer(1) 
            if Remotes.RE_EquipTool then Remotes.RE_EquipTool:FireServer(1) end
            if k3 then k3:FireServer(1) end
        end)
    end
})

-- AUTO PERFECTION SECTION
local autoPerfectionSection = Tab3:AddSection("Auto Perfection")

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
    Title = "Auto Perfection",
    Content = "Auto perfect fishing",
    Default = false,
    Callback = function(s)
        ap = s
        if s then
            FC.RequestFishingMinigameClick = function() end
            FC.RequestChargeFishingRod = function() end
        else
            net["RF/UpdateAutoFishingState"]:InvokeServer(false)
            FC.RequestFishingMinigameClick = oc
            FC.RequestChargeFishingRod = orc
        end
    end
})

-- SKIN ANIMATION SECTION
local skinSection = Tab3:AddSection("Skin Animation")

local selectedAnim = "None"
local activeAnim = nil

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

skinSection:AddDropdown({
    Title = "Select Rod Animation",
    Content = "Choose fishing rod animation",
    Options = animNames,
    Default = selectedAnim,
    Callback = function(v)
        selectedAnim = v
    end
})

-- Apply Animation Button
skinSection:AddButton({
    Title = "Apply Animation",
    Content = "Apply selected animation",
    Callback = function()
        activeAnim = AnimationList[selectedAnim]
    end
})

-- Disable Animation Button
skinSection:AddButton({
    Title = "Disable Animation",
    Content = "Disable all animations",
    Callback = function()
        activeAnim = nil
        selectedAnim = "None"
    end
})

-- ==================== TAB 4: AUTO ====================
local Tab4 = Window:AddTab({
    Name = "Auto",
    Icon = "loop"
})

-- AUTO SELL SECTION
local sellSection = Tab4:AddSection("Auto Sell")

local AutoSell = false
local SellAt = 100
local Selling = false
local SellMinute = 5
local LastSell = 0

-- Auto Sell Threshold Input
sellSection:AddInput({
    Title = "Auto Sell When Fish ≥",
    Content = "Sell automatically when fish count reaches this number",
    Default = "100",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then 
            SellAt = math.floor(num)
        end
    end
})

-- Auto Sell Toggle
sellSection:AddToggle({
    Title = "Auto Sell All Fish",
    Content = "Automatically sell all fish when threshold reached",
    Default = false,
    Callback = function(state)
        AutoSell = state
    end
})

-- Auto Sell Interval Input
sellSection:AddInput({
    Title = "Auto Sell Interval (Minutes)",
    Content = "Sell automatically every X minutes",
    Default = "5",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then 
            SellMinute = math.floor(num)
        end
    end
})

-- AUTO FAVORITE SECTION
local favSection = Tab4:AddSection("Auto Favorite")

local GlobalFav = {
    FishNames = {},
    VariantNames = {},
    SelectedFish = {},
    SelectedVariants = {},
    AutoFavoriteEnabled = false
}

-- Load fish data
task.spawn(function()
    for _, item in pairs(RS.Items:GetChildren()) do
        local ok, data = pcall(require, item)
        if ok and data.Data and data.Data.Type == "Fish" then
            table.insert(GlobalFav.FishNames, data.Data.Name)
        end
    end
    table.sort(GlobalFav.FishNames)
    
    for _, variantModule in pairs(RS.Variants:GetChildren()) do
        local ok, variantData = pcall(require, variantModule)
        if ok and variantData.Data and variantData.Data.Name then
            table.insert(GlobalFav.VariantNames, variantData.Data.Name)
        end
    end
    table.sort(GlobalFav.VariantNames)
end)

-- Fish Selection Dropdown
favSection:AddDropdown({
    Title = "Select Fish",
    Content = "Choose fish to auto-favorite",
    Options = GlobalFav.FishNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        GlobalFav.SelectedFish = v
    end
})

-- Variant Selection Dropdown
favSection:AddDropdown({
    Title = "Select Variants",
    Content = "Choose variants to auto-favorite",
    Options = GlobalFav.VariantNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        GlobalFav.SelectedVariants = v
    end
})

-- Auto Favorite Toggle
favSection:AddToggle({
    Title = "Auto Favorite",
    Content = "Automatically favorite caught fish",
    Default = false,
    Callback = function(state)
        GlobalFav.AutoFavoriteEnabled = state
    end
})

-- Refresh Button
favSection:AddButton({
    Title = "Refresh Fish List",
    Content = "Load all available fish and variants",
    Callback = function()
        GlobalFav.FishNames = {}
        GlobalFav.VariantNames = {}
        
        for _, item in pairs(RS.Items:GetChildren()) do
            local ok, data = pcall(require, item)
            if ok and data.Data and data.Data.Type == "Fish" then
                table.insert(GlobalFav.FishNames, data.Data.Name)
            end
        end
        table.sort(GlobalFav.FishNames)
        
        for _, variantModule in pairs(RS.Variants:GetChildren()) do
            local ok, variantData = pcall(require, variantModule)
            if ok and variantData.Data and variantData.Data.Name then
                table.insert(GlobalFav.VariantNames, variantData.Data.Name)
            end
        end
        table.sort(GlobalFav.VariantNames)
    end
})

-- Reset Button
favSection:AddButton({
    Title = "Reset Selection",
    Content = "Clear all fish and variant selections",
    Callback = function()
        GlobalFav.SelectedFish = {}
        GlobalFav.SelectedVariants = {}
    end
})

-- EVENT SECTION
local eventSection = Tab4:AddSection("Events")

-- Auto Open Mysterious Cave
local AutoOpenMaze = false
local AutoOpenMazeTask = nil

eventSection:AddToggle({
    Title = "Auto Open Mysterious Cave",
    Content = "Automatically open mysterious cave",
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
        else
            AutoOpenMaze = false
            if AutoOpenMazeTask then
                task.cancel(AutoOpenMazeTask)
                AutoOpenMazeTask = nil
            end
        end
    end
})

-- Auto Claim Pirate Chest
local AutoClaimPirateChest = false
eventSection:AddToggle({
    Title = "Auto Claim Pirate Chest",
    Content = "Automatically claim pirate chest rewards",
    Default = false,
    Callback = function(v)
        AutoClaimPirateChest = v
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
    Content = "Choose which totem to auto-place",
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
    end
})

-- Delay Input
totemSection:AddInput({
    Title = "Delay (Minutes)",
    Content = "Delay between auto-placing totems",
    Default = "60",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            TotemDelayMinutes = math.floor(num)
        end
    end
})

-- Auto Place Totem Toggle
totemSection:AddToggle({
    Title = "Auto Place Totem",
    Content = "Automatically place totem on cooldown",
    Default = false,
    Callback = function(enabled)
        AutoTotemEnabled = enabled
        if not enabled then return end

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
    end
})

-- Place Now Button
totemSection:AddButton({
    Title = "Place Selected Totem",
    Content = "Place the selected totem now",
    Callback = function()
        local Net = require(RS.Packages.Net)
        local Replion = require(RS.Packages.Replion)
        local DataReplion = Replion.Client:WaitReplion("Data")
        
        local inventory = DataReplion:Get("Inventory")
        if not inventory or not inventory.Totems then return end

        local spawnTotem = Net:RemoteEvent("SpawnTotem")
        for _, totem in pairs(inventory.Totems) do
            if totem.Id == SelectedTotemId then
                spawnTotem:FireServer(totem.UUID)
                break
            end
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
    Content = "Filter which rarities to send",
    Options = rarityOptions,
    Default = {},
    Multi = true,
    Callback = function(v)
        WebhookRarities = v
    end
})

-- Webhook URL Input
webhookSection:AddInput({
    Title = "Webhook URL",
    Content = "Enter your Discord webhook URL",
    Default = "",
    Callback = function(text)
        WebhookURL = text
    end
})

-- Send Webhook Toggle
webhookSection:AddToggle({
    Title = "Send Fish Caught Webhook",
    Content = "Send webhook notification when catching fish",
    Default = false,
    Callback = function(state)
        DetectNewFishActive = state
    end
})

-- Test Webhook Button
webhookSection:AddButton({
    Title = "Test Webhook",
    Content = "Send test webhook to check connection",
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
    Content = "Choose fishing rod to buy",
    Options = rodOptions,
    Default = selectedRod,
    Callback = function(v)
        selectedRod = v
    end
})

rodSection:AddButton({
    Title = "Buy Rod",
    Callback = function()
        local name = selectedRod:match("^(.-) %(")
        if name and R[name] then
            pcall(function() 
                net["RF/PurchaseFishingRod"]:InvokeServer(R[name]) 
            end)
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
    Content = "Choose bait to buy",
    Options = baitOptions,
    Default = selectedBait,
    Callback = function(v)
        selectedBait = v
    end
})

baitSection:AddButton({
    Title = "Buy Bait",
    Callback = function()
        if selectedBait and B[selectedBait] then
            pcall(function() 
                net["RF/PurchaseBait"]:InvokeServer(B[selectedBait]) 
            end)
        end
    end
})

-- MERCHANT SECTION
local merchantSection = Tab6:AddSection("Merchant")

merchantSection:AddButton({
    Title = "OPEN MERCHANT",
    Content = "Open traveling merchant UI",
    Callback = function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local merchantUI = playerGui:WaitForChild("Merchant")
        if merchantUI then
            merchantUI.Enabled = true
        end
    end
})

merchantSection:AddButton({
    Title = "CLOSE MERCHANT",
    Content = "Close traveling merchant UI",
    Callback = function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local merchantUI = playerGui:FindFirstChild("Merchant")
        if merchantUI then
            merchantUI.Enabled = false
        end
    end
})

-- BUY WEATHER EVENT
local weatherSection = Tab6:AddSection("Weather Events")

local autoBuyEnabled = false

weatherSection:AddToggle({
    Title = "Auto Buy Weather",
    Content = "Auto buy Wind, Cloudy, Storm (100s loop)",
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
                    task.wait(100)
                end
            end)
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
    Content = "Choose island to teleport to",
    Options = islandNames,
    Default = SelectedIsland,
    Callback = function(Value)
        SelectedIsland = Value
    end
})

islandSection:AddButton({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = IslandLocations[SelectedIsland]
            end
        end
    end
})

-- PLAYER TELEPORT SECTION
local playerTeleportSection = Tab7:AddSection("Player Teleport")

-- Function to get player list
local function getPlayerList()
    local players = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    table.sort(players)
    return players
end

-- Player dropdown
local playerList = getPlayerList()
local selectedPlayer = playerList[1] or ""

playerTeleportSection:AddDropdown({
    Title = "Select Player",
    Content = "Choose player to teleport to",
    Options = playerList,
    Default = selectedPlayer,
    Callback = function(v)
        selectedPlayer = v
    end
})

-- Refresh player list button
playerTeleportSection:AddButton({
    Title = "Refresh Player List",
    Content = "Refresh list of online players",
    Callback = function()
        playerList = getPlayerList()
        selectedPlayer = playerList[1] or ""
    end
})

-- Teleport to player button
playerTeleportSection:AddButton({
    Title = "Teleport to Player",
    Content = "Teleport to selected player",
    Callback = function()
        if not selectedPlayer then return end

        local target = Players:FindFirstChild(selectedPlayer)
        if not target or not target.Character then return end

        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not targetHRP or not myHRP then return end

        myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
    end
})

-- EVENT TELEPORT SECTION
local eventTeleportSection = Tab7:AddSection("Event Teleporter")

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

-- Event names
local eventNames = {}
for n in pairs(eventData) do
    table.insert(eventNames, n)
end
table.sort(eventNames)

local ST = {
    player = LocalPlayer,
    char = nil,
    hrp = nil,
    megRadius = 150,
    autoTP = false,
    autoFloat = false,
    selectedEvents = {},
    lastTP = nil,
    tpCooldown = 0.3,
    floatOffset = 6
}

-- Initialize character
local function bindChar(c)
    ST.char = c
    task.wait(1)
    ST.hrp = c:WaitForChild("HumanoidRootPart")
end

bindChar(ST.player.Character or ST.player.CharacterAdded:Wait())
ST.player.CharacterAdded:Connect(bindChar)

-- Force TP function
local function forceTP(pos)
    if not ST.lastTP or (ST.lastTP - pos).Magnitude > 5 then
        ST.lastTP = pos
        for _ = 1, 2 do
            ST.hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
            ST.hrp.AssemblyLinearVelocity = Vector3.zero
            ST.hrp.Velocity = Vector3.zero
            task.wait(0.02)
        end
    end
end

-- Main TP loop
local function runEventTP()
    while ST.autoTP do
        local list = {}

        for _, name in ipairs(ST.selectedEvents) do
            if eventData[name] then
                list[#list+1] = eventData[name]
            end
        end

        table.sort(list, function(a, b)
            return a.Priority < b.Priority
        end)

        for _, cfg in ipairs(list) do
            local found

            if cfg.TargetName == "Model" then
                local rings = workspace:FindFirstChild("!!! MENU RINGS")
                if rings then
                    for _, p in ipairs(rings:GetChildren()) do
                        if p.Name == "Props" then
                            local m = p:FindFirstChild("Model")
                            if m and m.PrimaryPart then
                                for _, loc in ipairs(cfg.Locations) do
                                    if (m.PrimaryPart.Position - loc).Magnitude <= ST.megRadius then
                                        found = m.PrimaryPart.Position
                                        break
                                    end
                                end
                            end
                        end
                        if found then break end
                    end
                end
            else
                for _, loc in ipairs(cfg.Locations) do
                    for _, d in ipairs(workspace:GetDescendants()) do
                        if d.Name == cfg.TargetName then
                            local pos = d:IsA("BasePart") and d.Position or (d.PrimaryPart and d.PrimaryPart.Position)
                            if pos and (pos - loc).Magnitude <= ST.megRadius then
                                found = pos
                                break
                            end
                        end
                    end
                    if found then break end
                end
            end

            if found then
                forceTP(found)
            end
        end

        task.wait(ST.tpCooldown)
    end
end

-- Float on water
game:GetService("RunService").RenderStepped:Connect(function()
    if ST.autoFloat and ST.hrp then
        local pos = ST.hrp.Position
        local targetY = workspace.Terrain.WaterLevel + ST.floatOffset
        if pos.Y < targetY then
            ST.hrp.CFrame = CFrame.new(pos.X, targetY, pos.Z)
            ST.hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

-- Event selection dropdown
eventTeleportSection:AddDropdown({
    Title = "Select Events",
    Content = "Choose events to auto-teleport to",
    Options = eventNames,
    Default = {},
    Multi = true,
    Callback = function(v)
        ST.selectedEvents = v
    end
})

-- Auto Event Toggle
eventTeleportSection:AddToggle({
    Title = "Auto Event Teleport",
    Content = "Automatically teleport to selected events",
    Default = false,
    Callback = function(state)
        ST.autoTP = state
        ST.autoFloat = state
        ST.lastTP = nil
        if state then
            task.defer(runEventTP)
        end
    end
})

-- ==================== TAB 8: SETTINGS ====================
local Tab8 = Window:AddTab({
    Name = "Settings",
    Icon = "settings"
})

-- MISC SECTION
local miscSection = Tab8:AddSection("Miscellaneous")

local PingEnabled = false -- default false, bukan true
local Frame, HeaderText, StatsText, CloseButton
local lastPingUpdate = 0
local pingUpdateInterval = 0.5

local function makeDraggable(frame)
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

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
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
    Frame.Size = UDim2.fromOffset(220, 60)
    Frame.Position = UDim2.fromScale(0.5, 0.05)
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.7
    Frame.BorderSizePixel = 0
    Frame.Visible = PingEnabled
    Frame.ZIndex = 1000
    Frame.Active = true

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(100, 100, 100)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.ZIndex = 1001

    -- Close Button
    CloseButton = Instance.new("TextButton", Frame)
    CloseButton.Size = UDim2.fromOffset(20, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.BackgroundTransparency = 0.3
    CloseButton.BorderSizePixel = 0
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 12
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.ZIndex = 1003
    
    local CloseCorner = Instance.new("UICorner", CloseButton)
    CloseCorner.CornerRadius = UDim.new(0, 3)

    CloseButton.MouseButton1Click:Connect(function()
        PingEnabled = false
        Frame.Visible = false
    end)

    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end)

    CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end)

    -- Header Text (CENTER)
    HeaderText = Instance.new("TextLabel", Frame)
    HeaderText.Size = UDim2.new(1, 0, 0, 20)
    HeaderText.Position = UDim2.fromOffset(0, 5)
    HeaderText.BackgroundTransparency = 1
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.TextSize = 11
    HeaderText.TextXAlignment = Enum.TextXAlignment.Center
    HeaderText.TextYAlignment = Enum.TextYAlignment.Center
    HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderText.Text = "VICTORIA PANEL"
    HeaderText.ZIndex = 1002

    -- Divider Line
    local Divider = Instance.new("Frame", Frame)
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.fromOffset(10, 28)
    Divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 1002

    -- Stats Text
    StatsText = Instance.new("TextLabel", Frame)
    StatsText.Size = UDim2.new(1, -20, 0, 25)
    StatsText.Position = UDim2.fromOffset(10, 32)
    StatsText.BackgroundTransparency = 1
    StatsText.Font = Enum.Font.GothamBold
    StatsText.TextSize = 10
    StatsText.TextXAlignment = Enum.TextXAlignment.Center
    StatsText.TextYAlignment = Enum.TextYAlignment.Center
    StatsText.TextColor3 = Color3.fromRGB(230, 230, 230)
    StatsText.ZIndex = 1002
    
    -- Make draggable
    makeDraggable(Frame)
    
    return Frame
end

-- Create ping display
createPingDisplay()

-- Ping update connection
game:GetService("RunService").RenderStepped:Connect(function()
    if not PingEnabled then return end
    
    local now = tick()
    if now - lastPingUpdate < pingUpdateInterval then return end
    lastPingUpdate = now
    
    local Stats = game:GetService("Stats")
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    local cpu = string.format("%.2f", Stats.PerformanceStats.CPU:GetValue())
    
    StatsText.Text = string.format("PING: %d ms | CPU: %s%%", ping, cpu)
end)

miscSection:AddToggle({
    Title = "Ping Display",
    Content = "Show ping and CPU usage",
    Default = false,
    Callback = function(v)
        PingEnabled = v
        if Frame then Frame.Visible = v end
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
    Content = "Custom name to display",
    Default = D.h,
    Callback = function(v)
        D.ch = v
        if D.on then H.Text = v end
    end
})

miscSection:AddInput({
    Title = "Hide Level",
    Content = "Custom level to display",
    Default = D.l,
    Callback = function(v)
        D.cl = v
        if D.on then L.Text = v end
    end
})

miscSection:AddToggle({
    Title = "Hide Name & Level (Custom)",
    Content = "Enable custom name and level",
    Default = false,
    Callback = function(v)
        D.on = v
        if v then
            H.Text = D.ch
            L.Text = D.cl
        else
            H.Text = D.h
            L.Text = D.l
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
    Content = "Hide with default text",
    Default = false,
    Callback = function(v)
        S.on = v
        if not S.ui then return end
        if v then
            S.ui.h.Text = HN
            S.ui.l.Text = HL
        else
            S.ui.h.Text = S.ui.dh
            S.ui.l.Text = S.ui.dl
        end
    end
})

-- INFINITE ZOOM
local infiniteZoom = false
local originalZoom = {LocalPlayer.CameraMaxZoomDistance, LocalPlayer.CameraMinZoomDistance}

miscSection:AddToggle({
    Title = "Infinite Zoom",
    Content = "Infinite zoom to take photos",
    Default = false,
    Callback = function(s)
        infiniteZoom = s
        if s then
            LocalPlayer.CameraMaxZoomDistance = math.huge
            LocalPlayer.CameraMinZoomDistance = .5
        else
            LocalPlayer.CameraMaxZoomDistance = originalZoom[1] or 128
            LocalPlayer.CameraMinZoomDistance = originalZoom[2] or .5
        end
    end
})

-- AUTO RECONNECT
local AutoReconnect = false
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
    Content = "Auto click Reconnect button",
    Default = false,
    Callback = function(v) 
        AutoReconnect = v
    end
})

-- ANTI STAFF
local AntiStaffEnabled = false
local StaffBlacklist = {
    [75974130]=1,[40397833]=1,[187190686]=1,[33372493]=1,[889918695]=1,
    [33679472]=1,[30944240]=1,[25050357]=1,[8462585751]=1,[8811129148]=1,
    [192821024]=1,[4509801805]=1,[124505170]=1,[108397209]=1
}

miscSection:AddToggle({
    Title = "Anti Staff",
    Content = "Auto serverhop if staff detected",
    Default = false,
    Callback = function(s) 
        AntiStaffEnabled = s
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

-- ULTRA FPS BOOST - CHARACTER OPTIMIZATION
local FPSBoost = false
local CurrentConnections = {}
local OriginalValues = {}
local OptimizedCharacters = {}
local CharacterStates = {}

-- Character optimization settings
local Settings = {
    RemoveAccessories = true,
    RemoveClothing = true,
    SimplifyBody = true,
    ReduceFaceDetail = true,
    DisableAnimations = true,
    RemoveParticles = true,
    SimplifyTextures = true,
    ForceLowDetail = true
}

-- Save original values with better tracking
local function saveOriginal(obj, property)
    if not obj then return end
    
    local objId = tostring(obj) .. "_" .. property
    if OriginalValues[objId] == nil then
        OriginalValues[objId] = {
            Object = obj,
            Property = property,
            Value = obj[property],
            Type = typeof(obj[property])
        }
    end
end

-- Restore specific object property
local function restoreOriginal(objId)
    if OriginalValues[objId] then
        local data = OriginalValues[objId]
        if data.Object and data.Object.Parent then
            pcall(function()
                data.Object[data.Property] = data.Value
            end)
        end
        OriginalValues[objId] = nil
    end
end

-- Ultra character optimization
local function optimizeCharacter(char)
    if not char or not char:IsA("Model") or OptimizedCharacters[char] then 
        return 
    end
    
    local player = game:GetService("Players"):GetPlayerFromCharacter(char)
    if not player and char.Name ~= "Dummy" then return end
    
    OptimizedCharacters[char] = true
    CharacterStates[char] = {}
    
    -- Store original character state
    CharacterStates[char].OriginalParent = char.Parent
    CharacterStates[char].RemovedParts = {}
    CharacterStates[char].DisabledParts = {}
    CharacterStates[char].OriginalProperties = {}
    
    -- Get humanoid for reference
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        saveOriginal(humanoid, "AutoRotate")
        saveOriginal(humanoid, "AutoJumpEnabled")
        saveOriginal(humanoid, "UseJumpPower")
        
        humanoid.AutoRotate = false
        humanoid.AutoJumpEnabled = false
        humanoid.UseJumpPower = false
        
        -- Disable animations if setting enabled
        if Settings.DisableAnimations then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                saveOriginal(animator, "Parent")
                animator.Parent = nil
            end
            
            -- Stop all animations
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
    end
    
    -- Process all descendants
    for _, obj in pairs(char:GetDescendants()) do
        pcall(function()
            -- REMOVE ACCESSORIES
            if Settings.RemoveAccessories then
                if obj:IsA("Accessory") or obj:IsA("Hat") then
                    local handle = obj:FindFirstChild("Handle")
                    if handle then
                        -- Store accessory for restoration
                        table.insert(CharacterStates[char].RemovedParts, {
                            Object = obj,
                            Parent = obj.Parent,
                            Position = handle.Position
                        })
                        obj.Parent = nil
                    end
                end
            end
            
            -- REMOVE CLOTHING
            if Settings.RemoveClothing then
                if obj:IsA("Clothing") or obj:IsA("ShirtGraphic") or 
                   obj:IsA("Pants") or obj:IsA("Shirt") then
                    table.insert(CharacterStates[char].RemovedParts, {
                        Object = obj,
                        Parent = obj.Parent
                    })
                    obj.Parent = nil
                end
            end
            
            -- SIMPLIFY BODY
            if Settings.SimplifyBody and obj:IsA("BasePart") then
                local partName = obj.Name:lower()
                
                -- Simplify body parts
                saveOriginal(obj, "Material")
                saveOriginal(obj, "Reflectance")
                saveOriginal(obj, "Transparency")
                saveOriginal(obj, "Color")
                saveOriginal(obj, "CastShadow")
                
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
                
                -- Make certain parts more transparent
                if partName:find("hand") or partName:find("foot") then
                    obj.Transparency = 0.3
                elseif partName:find("arm") or partName:find("leg") then
                    obj.Transparency = 0.2
                else
                    obj.Transparency = 0.1
                end
                
                -- Simplify color
                if partName:find("head") then
                    obj.Color = Color3.fromRGB(240, 184, 160) -- Skin tone
                else
                    obj.Color = Color3.fromRGB(200, 200, 200) -- Gray
                end
                
                -- Remove surface appearances
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("SurfaceAppearance") or 
                       child:IsA("Texture") or 
                       child:IsA("Decal") then
                        if Settings.SimplifyTextures then
                            table.insert(CharacterStates[char].RemovedParts, {
                                Object = child,
                                Parent = child.Parent
                            })
                            child.Parent = nil
                        else
                            saveOriginal(child, "Transparency")
                            child.Transparency = 0.8
                        end
                    end
                end
            end
            
            -- REDUCE FACE DETAIL
            if Settings.ReduceFaceDetail then
                if obj:IsA("Decal") and obj.Parent and obj.Parent.Name == "Head" then
                    local faceName = obj.Name:lower()
                    if faceName:find("face") or faceName:find("head") then
                        if Settings.SimplifyTextures then
                            table.insert(CharacterStates[char].RemovedParts, {
                                Object = obj,
                                Parent = obj.Parent
                            })
                            obj.Parent = nil
                        else
                            saveOriginal(obj, "Transparency")
                            obj.Transparency = 0.7
                        end
                    end
                end
            end
            
            -- REMOVE PARTICLES
            if Settings.RemoveParticles then
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or 
                   obj:IsA("Smoke") or obj:IsA("Fire") or 
                   obj:IsA("Sparkles") then
                    saveOriginal(obj, "Enabled")
                    obj.Enabled = false
                    table.insert(CharacterStates[char].DisabledParts, obj)
                end
            end
            
            -- SIMPLIFY MESHES
            if obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
                if Settings.ForceLowDetail then
                    saveOriginal(obj, "LOD")
                    saveOriginal(obj, "RenderFidelity")
                    saveOriginal(obj, "LevelOfDetail")
                    
                    if obj:IsA("MeshPart") then
                        obj.RenderFidelity = Enum.RenderFidelity.Performance
                        obj.LevelOfDetail = Enum.LevelOfDetail.Low
                    end
                    
                    -- Force low LOD
                    pcall(function()
                        obj.LOD = Enum.LOD.Level01
                    end)
                end
            end
            
            -- DISABLE LIGHTS
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or 
               obj:IsA("SurfaceLight") then
                saveOriginal(obj, "Enabled")
                obj.Enabled = false
                table.insert(CharacterStates[char].DisabledParts, obj)
            end
            
            -- DISABLE SOUNDS
            if obj:IsA("Sound") then
                saveOriginal(obj, "Playing")
                if obj.Playing then
                    obj.Playing = false
                end
            end
        end)
    end
    
    -- Force character to lowest LOD
    if Settings.ForceLowDetail then
        pcall(function()
            char:SetAttribute("LOD", "Lowest")
            
            -- Use hidden properties if available
            if sethiddenproperty then
                sethiddenproperty(char, "LODSpecificity", Enum.LODSpecificity.Level01)
            end
        end)
    end
    
    
end

-- Restore character to original state
local function restoreCharacter(char)
    if not char or not CharacterStates[char] then return end
    
    -- Restore removed parts
    for _, removed in ipairs(CharacterStates[char].RemovedParts or {}) do
        if removed.Object and removed.Parent then
            pcall(function()
                removed.Object.Parent = removed.Parent
            end)
        end
    end
    
    -- Re-enable disabled parts
    for _, disabled in ipairs(CharacterStates[char].DisabledParts or {}) do
        if disabled then
            local objId = tostring(disabled) .. "_Enabled"
            restoreOriginal(objId)
        end
    end
    
    -- Restore original properties
    for objId, _ in pairs(OriginalValues) do
        if objId:find(tostring(char)) then
            restoreOriginal(objId)
        end
    end
    
    -- Restore humanoid animator
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator and CharacterStates[char].OriginalAnimatorParent then
            animator.Parent = CharacterStates[char].OriginalAnimatorParent
        end
    end
    
    OptimizedCharacters[char] = nil
    CharacterStates[char] = nil
    
    
end

-- Optimize workspace objects (including sky removal)
local function optimizeObject(obj)
    pcall(function()
        -- Remove sky textures
        if obj:IsA("Texture") then
            local name = obj.Name:lower()
            if name:find("sky") or name:find("cloud") or name:find("sun") then
                saveOriginal(obj, "Parent")
                obj.Parent = nil
                return
            end
        end
        
        -- Remove atmosphere/sky objects
        if obj:IsA("Sky") or obj.Name:lower():find("atmosphere") then
            saveOriginal(obj, "Parent")
            obj.Parent = nil
            return
        end
        
        -- Standard optimizations
        if obj:IsA("BasePart") then
            saveOriginal(obj, "Material")
            saveOriginal(obj, "Reflectance")
            saveOriginal(obj, "CastShadow")
            
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
            
        elseif obj:IsA("Decal") then
            saveOriginal(obj, "Transparency")
            obj.Transparency = 0.9
            
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            saveOriginal(obj, "Enabled")
            obj.Enabled = false
            
        elseif obj:IsA("PostEffect") then
            saveOriginal(obj, "Enabled")
            obj.Enabled = false
        end
    end)
end

-- Main boost application
local function applyBoost()
    
    
    -- Clear previous optimizations
    OptimizedCharacters = {}
    CharacterStates = {}
    
    -- Get services
    local Lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")
    local workspace = game:GetService("Workspace")
    
    -- REMOVE SKY AND ATMOSPHERE
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or 
           obj.Name:lower():find("sky") or obj.Name:lower():find("atmosphere") then
            saveOriginal(obj, "Parent")
            obj.Parent = nil
        end
    end
    
    -- OPTIMIZE LIGHTING
    local lightingProps = {
        "GlobalShadows", "FogEnd", "Brightness", "EnvironmentDiffuseScale",
        "EnvironmentSpecularScale", "OutdoorAmbient", "Ambient", "ClockTime",
        "Technology", "ShadowSoftness", "ExposureCompensation"
    }
    
    for _, prop in ipairs(lightingProps) do
        if Lighting[prop] ~= nil then
            saveOriginal(Lighting, prop)
        end
    end
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 3
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.Ambient = Color3.new(0.9, 0.9, 0.9)
    Lighting.ClockTime = 12
    Lighting.Technology = Enum.Technology.Legacy
    Lighting.ShadowSoftness = 0
    Lighting.ExposureCompensation = 0
    
    -- DISABLE ALL POST EFFECTS
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            saveOriginal(effect, "Enabled")
            effect.Enabled = false
        end
    end
    
    -- OPTIMIZE TERRAIN
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        saveOriginal(Terrain, "Decoration")
        saveOriginal(Terrain, "WaterWaveSize")
        saveOriginal(Terrain, "WaterWaveSpeed")
        saveOriginal(Terrain, "WaterReflectance")
        saveOriginal(Terrain, "WaterTransparency")
        saveOriginal(Terrain, "MaterialColors")
        
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
        Terrain.MaterialColors = false
        
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(Terrain, "Decoration", false)
            end
        end)
    end
    
    -- OPTIMIZE RENDERING SETTINGS
    local rendering = settings().Rendering
    saveOriginal(rendering, "QualityLevel")
    saveOriginal(rendering, "MeshPartDetailLevel")
    saveOriginal(rendering, "EagerBulkExecution")
    
    rendering.QualityLevel = Enum.QualityLevel.Level01
    rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    rendering.EagerBulkExecution = true
    
    -- OPTIMIZE EXISTING CHARACTERS
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            optimizeCharacter(player.Character)
        end
    end
    
    -- OPTIMIZE EXISTING WORKSPACE OBJECTS
    for _, obj in pairs(workspace:GetDescendants()) do
        optimizeObject(obj)
    end
    
    -- SET UP CONNECTIONS
    local connections = {}
    
    -- New character connection
    local function onCharacterAdded(char)
        task.wait(0.5) -- Wait for character to fully load
        optimizeCharacter(char)
    end
    
    -- Connect to players
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            onCharacterAdded(player.Character)
        end
        local conn = player.CharacterAdded:Connect(onCharacterAdded)
        table.insert(connections, conn)
    end
    
    local playersConn = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(onCharacterAdded)
    end)
    table.insert(connections, playersConn)
    
    -- Workspace connection
    local workspaceConn = workspace.DescendantAdded:Connect(optimizeObject)
    table.insert(connections, workspaceConn)
    
    -- Lighting connection
    local lightingConn = Lighting.ChildAdded:Connect(function(child)
        if child:IsA("Sky") or child:IsA("Atmosphere") then
            saveOriginal(child, "Parent")
            child.Parent = nil
        elseif child:IsA("PostEffect") then
            saveOriginal(child, "Enabled")
            child.Enabled = false
        end
    end)
    table.insert(connections, lightingConn)
    
    CurrentConnections = connections
    
    -- SET FPS CAP
    pcall(function()
        if setfpscap then
            setfpscap(9999)
        end
    end)
    
    
end

-- Restore everything
local function restoreBoost()
    
    
    -- Disconnect all connections
    for _, conn in ipairs(CurrentConnections) do
        pcall(function() conn:Disconnect() end)
    end
    CurrentConnections = {}
    
    -- Restore all characters
    for char, _ in pairs(OptimizedCharacters) do
        if char then
            restoreCharacter(char)
        end
    end
    
    -- Restore all original values
    for objId, data in pairs(OriginalValues) do
        if data.Object and data.Object.Parent then
            pcall(function()
                data.Object[data.Property] = data.Value
            end)
        end
    end
    
    -- Restore terrain
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(Terrain, "Decoration", true)
            end
        end)
    end
    
    -- Clear tables
    OriginalValues = {}
    OptimizedCharacters = {}
    CharacterStates = {}
    
    
end

-- UI Integratioi
    graphicsSection:AddToggle({
        Title = "ULTRA FPS BOOST",
        Content = "Remove accessories/clothes, simplify bodies, kill sky",
        Default = false,
        Callback = function(v)
            FPSBoost = v
            if v then
                applyBoost()
            else
                restoreBoost()
            end
        end
    })
end

-- REMOVE FISH NOTIFICATION
local PopupConn, RemoteConn

graphicsSection:AddToggle({
    Title = "Remove Fish Notification",
    Content = "Remove fish caught pop-up notifications",
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
        else
            if PopupConn then PopupConn:Disconnect(); PopupConn = nil end
            if RemoteConn then RemoteConn:Disconnect(); RemoteConn = nil end
        end
    end
})

-- DISABLE 3D RENDERING
local disable3DRendering = false
local G

graphicsSection:AddToggle({
    Title = "Disable 3D Rendering",
    Content = "Disable 3D rendering (white screen)",
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
        elseif G then
            G:Destroy()
            G = nil
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
    Content = "Hide all visual effects",
    Default = false,
    Callback = function(state)
        VFXState.on = state
        if state then 
            disableVFX()
        else 
            restoreVFX()
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
    Content = "Remove fishing skin visual effects",
    Default = false,
    Callback = function(state)
        if state then
            VFXController.Handle = function() end
            VFXController.RenderAtPoint = function() end
            VFXController.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then pcall(f.ClearAllChildren, f) end
        else
            VFXController.Handle = ORI.H
            VFXController.RenderAtPoint = ORI.P
            VFXController.RenderInstance = ORI.I
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
    Content = "Skip all cutscenes automatically",
    Default = false,
    Callback = function(state)
        _G.AutoSkipCutscene = state
        if state then
            if _G.CutsceneController then
                _G.CutsceneController:Stop()
                _G.GuiControl:SetHUDVisibility(true)
                _G.ProximityPromptService.Enabled = true
            end
        end
    end
})

-- SERVER SECTION
local serverSection = Tab8:AddSection("Server")

serverSection:AddButton({
    Title = "Rejoin",
    Content = "Rejoin to the same server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

serverSection:AddButton({
    Title = "Server Hop",
    Content = "Switch to another server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

-- OTHER SCRIPTS SECTION
local scriptSection = Tab8:AddSection("Other Scripts")

scriptSection:AddButton({
    Title = "Infinite Yield",
    Content = "Load Infinite Yield script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
    end
})

-- ==================== FINAL ====================
getgenv().VictoriaHubWindow = Window

-- Single notification on load
task.spawn(function()
    task.wait(1)
    notif("Victoria Hub loaded successfully!", 5, Color3.fromRGB(138, 43, 226))
end)

return Window
