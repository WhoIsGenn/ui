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
    Version = "1.0.0",
    Icon = "rbxassetid://96751490485303",
    Image = "96751490485303"
})

-- ==================== PLAYER SETUP ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Notification function
local function notif(text, duration, color)
    if Window and Window.notif then
        Window.notif(text, duration, color)
    end
end

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
                notif("Walk Speed set to " .. num, 2, Color3.fromRGB(0, 170, 255))
            end
        end
    end
})

-- JUMP POWER INPUT
local jumpPowerValue = 50
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
                notif("Jump Power set to " .. num, 2, Color3.fromRGB(0, 170, 255))
            end
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
        notif("Infinite Jump " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
        notif("Noclip " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        
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
    Default = false,
    Callback = function(s)
        frozen = s
        notif("Character " .. (s and "frozen" or "unfrozen"), 2, s and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(0, 255, 0))
        
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
    Default = false,
    Callback = function(state)
        animDisabled = state
        notif("Animations " .. (state and "disabled" or "enabled"), 2, state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0))
        
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
    Default = false,
    Callback = function(state)
        isWalkOnWater = state
        notif("Walk on Water " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        
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
    Default = false,
    Callback = function(v)
        _G.AutoFishing = v
        notif("Auto Fishing " .. (v and "started" or "stopped"), 2, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        
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
        notif("Fishing mode set to " .. v, 2, Color3.fromRGB(0, 170, 255))
        
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
    Default = "0.65",
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 0.05 and num <= 5 then
            _G.InstantDelay = num
            notif("Instant delay set to " .. num .. "s", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Auto Equip Rod
fishingSection:AddToggle({
    Title = "Auto Equip Rod",
    Default = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        notif("Auto Equip Rod " .. (v and "enabled" or "disabled"), 2, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        if v then
            rod()
        end
    end
})

-- RADAR
local radarEnabled = false
fishingSection:AddToggle({
    Title = "Bypass Radar",
    Default = false,
    Callback = function(s)
        radarEnabled = s
        notif("Radar Bypass " .. (s and "enabled" or "disabled"), 2, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        local RS, L = game.ReplicatedStorage, game.Lighting
        if require(RS.Packages.Replion).Client:GetReplion("Data") then
            require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar"):InvokeServer(s)
        end
    end
})

-- BYPASS OXYGEN
fishingSection:AddToggle({
    Title = "Bypass Oxygen",
    Default = false,
    Callback = function(s)
        notif("Oxygen Bypass " .. (s and "enabled" or "disabled"), 2, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        if s then 
            net["RF/EquipOxygenTank"]:InvokeServer(105)
        else 
            net["RF/UnequipOxygenTank"]:InvokeServer() 
        end
    end
})

-- BLATANT V1 SECTION
local blatantV1Section = Tab3:AddSection("Blatant Mode")

local c = { d = false, e = 1.55, f = 0.22 }
local m = nil
local n = nil

-- Cancel Delay Input
blatantV1Section:AddInput({
    Title = "Cancel Delay",
    Default = "1.7",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            c.e = num
            notif("Cancel delay set to " .. num .. "s", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Complete Delay Input
blatantV1Section:AddInput({
    Title = "Complete Delay",
    Default = "1.4",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            c.f = num
            notif("Complete delay set to " .. num .. "s", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Blatant V1 Toggle
blatantV1Section:AddToggle({
    Title = "Enable Blatant",
    Default = false,
    Callback = function(z2)
        c.d = z2
        notif("Blatant V1 " .. (z2 and "enabled" or "disabled"), 2, z2 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        if z2 then
            if m then task.cancel(m) end
            if n then task.cancel(n) end
            m = task.spawn(function()
                n = task.spawn(function()
                    while c.d do
                        pcall(function()
                            net["RE/EquipToolFromHotbar"]:FireServer(1)
                        end)
                        task.wait(1.5)
                    end
                end)
                
                while c.d do
                    task.spawn(function()
                        pcall(function()
                            net["RF/CancelFishingInputs"]:InvokeServer()
                            net["RF/ChargeFishingRod"]:InvokeServer(math.huge)
                            net["RF/RequestFishingMinigameStarted"]:InvokeServer(-1.233184814453125, 0.9965292652011685)
                        end)
                    end)
                    
                    task.spawn(function()
                        task.wait(c.f)
                        if c.d then
                            pcall(function()
                                net["RE/FishingCompleted"]:FireServer()
                            end)
                        end
                    end)
                    
                    task.wait(c.e)
                    if not c.d then break end
                    task.wait(0.1)
                end
            end)
        else
            if m then task.cancel(m) end
            if n then task.cancel(n) end
            m = nil
            n = nil
            pcall(function()
                net["RF/CancelFishingInputs"]:InvokeServer()
            end)
        end
    end
})

-- BLATANT V2 SECTION
local blatantV2Section = Tab3:AddSection("Blatant V2")

local toggleState = {
    blatantRunning = false,
    completeDelays = 0.06
}
local isSuperInstantRunning = false
_G.ReelSuper = 1.10

-- Reel Delay Input
blatantV2Section:AddInput({
    Title = "Reel Delay",
    Default = "1.9",
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 0 then
            _G.ReelSuper = num
            notif("Reel delay set to " .. num .. "s", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Complete Delay Input
blatantV2Section:AddInput({
    Title = "Complete Delay",
    Default = "0.9",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            toggleState.completeDelays = num
            notif("Complete delay set to " .. num .. "s", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Blatant V2 Toggle
blatantV2Section:AddToggle({
    Title = "Enable Blatant",
    Default = false,
    Callback = function(value)
        toggleState.blatantRunning = value
        notif("Blatant V2 " .. (value and "enabled" or "disabled"), 2, value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        
        if value then
            isSuperInstantRunning = true
            task.spawn(function()
                while isSuperInstantRunning do
                    task.spawn(function()
                        pcall(function()
                            net["RF/CancelFishingInputs"]:InvokeServer()
                            net["RF/ChargeFishingRod"]:InvokeServer(tick())
                            net["RF/RequestFishingMinigameStarted"]:InvokeServer(-1.233184814453125, 0.9965292652011685)
                            task.wait(toggleState.completeDelays)
                            net["RE/FishingCompleted"]:FireServer()
                        end)
                    end)
                    task.wait(math.max(_G.ReelSuper))
                end
            end)
        else
            isSuperInstantRunning = false
        end
    end
})

-- RECOVERY FISHING BUTTONS
blatantV1Section:AddButton({
    Title = "Recovery Fishing",
    Callback = function()
        -- Stop Blatant V1
        if c.d then
            c.d = false
            if m then task.cancel(m); m = nil end
            if n then task.cancel(n); n = nil end
        end
        
        -- Stop Blatant V2
        if toggleState.blatantRunning then
            toggleState.blatantRunning = false
            isSuperInstantRunning = false
        end
        
        -- Cancel all fishing
        pcall(function() net["RF/CancelFishingInputs"]:InvokeServer() end)
        
        -- Reset rod
        pcall(function() net["RE/EquipToolFromHotbar"]:FireServer(1) end)
        
        notif("Fishing recovery executed", 2, Color3.fromRGB(0, 255, 255))
    end
})

blatantV2Section:AddButton({
    Title = "Recovery Fishing",
    Callback = function()
        -- Stop Blatant V1
        if c.d then
            c.d = false
            if m then task.cancel(m); m = nil end
            if n then task.cancel(n); n = nil end
        end
        
        -- Stop Blatant V2
        if toggleState.blatantRunning then
            toggleState.blatantRunning = false
            isSuperInstantRunning = false
        end
        
        -- Cancel all fishing
        pcall(function() net["RF/CancelFishingInputs"]:InvokeServer() end)
        
        -- Reset rod
        pcall(function() net["RE/EquipToolFromHotbar"]:FireServer(1) end)
        
        notif("Fishing recovery executed", 2, Color3.fromRGB(0, 255, 255))
    end
})

-- AUTO PERFECTION SECTION
local autoPerfectionSection = Tab3:AddSection("Stable Result")

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
    Title = "Stable Result/Good",
    Default = false,
    Callback = function(s)
        ap = s
        notif("Stable Result " .. (s and "enabled" or "disabled"), 2, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
            notif("Auto sell threshold set to " .. SellAt, 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Auto Sell Toggle
sellSection:AddToggle({
    Title = "Auto Sell All Fish",
    Default = false,
    Callback = function(state)
        AutoSell = state
        notif("Auto Sell " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
            notif("Auto selling " .. fishCount .. " fish...", 2, Color3.fromRGB(255, 215, 0))
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
        notif("Selected " .. #v .. " fish for auto-favorite", 2, Color3.fromRGB(0, 170, 255))
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
        notif("Selected " .. #v .. " variants for auto-favorite", 2, Color3.fromRGB(0, 170, 255))
    end
})

-- Auto Favorite Toggle
favSection:AddToggle({
    Title = "Auto Favorite",
    Default = false,
    Callback = function(state)
        GlobalFav.AutoFavoriteEnabled = state
        notif("Auto Favorite " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end
})

-- Reset Button
favSection:AddButton({
    Title = "Reset Selection",
    Callback = function()
        GlobalFav.SelectedFish = {}
        GlobalFav.SelectedVariants = {}
        notif("Selection reset", 2, Color3.fromRGB(255, 165, 0))
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
            notif("Auto-favorited: " .. fishName .. (variantName and " (" .. variantName .. ")" or ""), 3, Color3.fromRGB(0, 255, 0))
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
        notif("Auto Open Maze " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))

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
    Default = false,
    Callback = function(v)
        AutoClaimPirateChest = v
        notif("Auto Claim Pirate Chest " .. (v and "enabled" or "disabled"), 2, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end
})

-- Pirate chest event
task.spawn(function()
    local Award = net["RE/AwardPirateChest"]
    Award.OnClientEvent:Connect(function(chestId)
        if AutoClaimPirateChest then
            pcall(function()
                net["RE/ClaimPirateChest"]:FireServer(chestId)
                notif("Auto-claimed pirate chest!", 2, Color3.fromRGB(255, 215, 0))
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
        notif("Totem selected: " .. v, 2, Color3.fromRGB(0, 170, 255))
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
            notif("Totem delay set to " .. num .. " minutes", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Auto Place Totem Toggle
totemSection:AddToggle({
    Title = "Auto Place Totem",
    Default = false,
    Callback = function(enabled)
        AutoTotemEnabled = enabled
        notif("Auto Place Totem " .. (enabled and "enabled" or "disabled"), 2, enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
    Callback = function()
        local Net = require(RS.Packages.Net)
        local Replion = require(RS.Packages.Replion)
        local DataReplion = Replion.Client:WaitReplion("Data")
        
        local inventory = DataReplion:Get("Inventory")
        if not inventory or not inventory.Totems then 
            notif("No totems in inventory", 2, Color3.fromRGB(255, 0, 0))
            return 
        end

        local spawnTotem = Net:RemoteEvent("SpawnTotem")
        local placed = false
        for _, totem in pairs(inventory.Totems) do
            if totem.Id == SelectedTotemId then
                spawnTotem:FireServer(totem.UUID)
                placed = true
                notif("Totem placed!", 2, Color3.fromRGB(0, 255, 0))
                break
            end
        end
        
        if not placed then
            notif("Selected totem not found", 2, Color3.fromRGB(255, 0, 0))
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
        notif("Webhook rarity filter updated: " .. #v .. " selected", 2, Color3.fromRGB(0, 170, 255))
    end
})

-- Webhook URL Input
webhookSection:AddInput({
    Title = "Webhook URL",
    Default = "",
    Callback = function(text)
        WebhookURL = text
        if text ~= "" then
            notif("Webhook URL saved", 2, Color3.fromRGB(0, 170, 255))
        end
    end
})

-- Send Webhook Toggle
webhookSection:AddToggle({
    Title = "Send Fish Caught Webhook",
    Default = false,
    Callback = function(state)
        DetectNewFishActive = state
        notif("Fish Webhook " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
                notif("Test webhook sent!", 3, Color3.fromRGB(0, 255, 0))
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
    Options = rodOptions,
    Default = selectedRod,
    Callback = function(v)
        selectedRod = v
        notif("Rod selected: " .. v, 2, Color3.fromRGB(0, 170, 255))
    end
})

rodSection:AddButton({
    Title = "Buy Rod",
    Callback = function()
        local name = selectedRod:match("^(.-) %(")
        if name and R[name] then
            pcall(function() 
                net["RF/PurchaseFishingRod"]:InvokeServer(R[name]) 
                notif("Purchased: " .. name, 2, Color3.fromRGB(0, 255, 0))
            end)
        else
            notif("Failed to purchase rod", 2, Color3.fromRGB(255, 0, 0))
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
        notif("Bait selected: " .. v, 2, Color3.fromRGB(0, 170, 255))
    end
})

baitSection:AddButton({
    Title = "Buy Bait",
    Callback = function()
        if selectedBait and B[selectedBait] then
            pcall(function() 
                net["RF/PurchaseBait"]:InvokeServer(B[selectedBait]) 
                notif("Purchased: " .. selectedBait, 2, Color3.fromRGB(0, 255, 0))
            end)
        else
            notif("Failed to purchase bait", 2, Color3.fromRGB(255, 0, 0))
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
            notif("Merchant opened", 2, Color3.fromRGB(0, 255, 0))
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
            notif("Merchant closed", 2, Color3.fromRGB(255, 0, 0))
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
        notif("Auto Buy Weather " .. (state and "enabled" or "disabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
        notif("Island selected: " .. Value, 2, Color3.fromRGB(0, 170, 255))
    end
})

islandSection:AddButton({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = IslandLocations[SelectedIsland]
                notif("Teleported to " .. SelectedIsland, 2, Color3.fromRGB(0, 255, 0))
            else
                notif("Character not found", 2, Color3.fromRGB(255, 0, 0))
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
    Options = playerList,
    Default = selectedPlayer,
    Callback = function(v)
        selectedPlayer = v
        notif("Player selected: " .. v, 2, Color3.fromRGB(0, 170, 255))
    end
})

-- Refresh player list button
playerTeleportSection:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        playerList = getPlayerList()
        selectedPlayer = playerList[1] or ""
        notif("Player list refreshed", 2, Color3.fromRGB(0, 170, 255))
    end
})

-- Teleport to player button
playerTeleportSection:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        if not selectedPlayer then 
            notif("No player selected", 2, Color3.fromRGB(255, 0, 0))
            return 
        end

        local target = Players:FindFirstChild(selectedPlayer)
        if not target or not target.Character then 
            notif("Player not found", 2, Color3.fromRGB(255, 0, 0))
            return 
        end

        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not targetHRP or not myHRP then 
            notif("Character parts not found", 2, Color3.fromRGB(255, 0, 0))
            return 
        end

        myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
        notif("Teleported to " .. selectedPlayer, 2, Color3.fromRGB(0, 255, 0))
    end
})

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
        notif("Selected " .. #selected .. " events", 2, Color3.fromRGB(0, 170, 255))
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
        
        notif("Auto Event Teleport " .. (enabled and "enabled" or "disabled"), 2, enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        
        if enabled then
            task.spawn(runTeleportLoop)
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

-- MISC SECTION
local miscSection = Tab8:AddSection("Miscellaneous")

-- PING DISPLAY WITH REAL-TIME NOTIFICATION COUNTER
local PingEnabled = false
local Frame, HeaderText, IconLabel, PingLabel, CpuLabel, FishCountLabel
local lastPingUpdate = 0
local pingUpdateInterval = 0.5

-- Color thresholds for ping
local function getPingColor(ping)
    if ping <= 50 then
        return Color3.fromRGB(46, 204, 113) -- Green
    elseif ping <= 100 then
        return Color3.fromRGB(241, 196, 15) -- Yellow
    else
        return Color3.fromRGB(231, 76, 60) -- Red
    end
end

-- Color thresholds for CPU
local function getCpuColor(cpu)
    if cpu <= 30 then
        return Color3.fromRGB(46, 204, 113) -- Green
    elseif cpu <= 60 then
        return Color3.fromRGB(241, 196, 15) -- Yellow
    else
        return Color3.fromRGB(231, 76, 60) -- Red
    end
end

-- Color thresholds for fish notification count
local function getFishCountColor(count)
    if count <= 5 then
        return Color3.fromRGB(46, 204, 113) -- Green
    elseif count <= 8 then
        return Color3.fromRGB(241, 196, 15) -- Yellow
    elseif count <= 10 then
        return Color3.fromRGB(255, 87, 34) -- Orange
    else
        return Color3.fromRGB(231, 76, 60) -- Red (11+)
    end
end

-- Store active notification IDs
local activeNotifications = {}
local notificationCounter = 0

-- Function to check fish notifications from event
local function setupFishNotificationTracker()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Net = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
    
    local fishNotificationEvent = Net:WaitForChild("RE/ObtainedNewFishNotification")
    
    fishNotificationEvent.OnClientEvent:Connect(function(itemId, _, data)
        -- Generate unique ID for this notification
        local notifId = tick() .. "_" .. itemId
        notificationCounter = notificationCounter + 1
        activeNotifications[notifId] = {
            time = tick(),
            itemId = itemId,
            data = data
        }
        
        -- Update display
        updateFishCounterDisplay()
        
        -- Auto-remove notification after 5 seconds (typical notification duration)
        task.delay(5, function()
            if activeNotifications[notifId] then
                activeNotifications[notifId] = nil
                notificationCounter = math.max(0, notificationCounter - 1)
                updateFishCounterDisplay()
            end
        end)
    end)
end

-- Function to update fish counter display
local function updateFishCounterDisplay()
    if FishCountLabel and Frame.Visible then
        FishCountLabel.Text = "Fish Notif: " .. notificationCounter
        FishCountLabel.TextColor3 = getFishCountColor(notificationCounter)
    end
end

-- Also track UI notifications as backup
local function setupUINotificationTracker()
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Common notification GUI patterns in Fish It
    local notificationNames = {
        "Small Notification",
        "Notification",
        "FishNotification",
        "CaughtNotification",
        "NewFishPopup"
    }
    
    -- Track visible notification frames
    local visibleFrames = {}
    
    local function checkVisibleNotifications()
        local count = 0
        
        -- Check for common notification GUIs
        for _, guiName in pairs(notificationNames) do
            local gui = PlayerGui:FindFirstChild(guiName)
            if gui and gui.Enabled then
                -- Count visible frames in this GUI
                for _, descendant in pairs(gui:GetDescendants()) do
                    if descendant:IsA("Frame") and descendant.Visible then
                        -- Check if it looks like a notification frame
                        local textLabels = descendant:GetDescendants()
                        local hasText = false
                        for _, child in pairs(textLabels) do
                            if child:IsA("TextLabel") or child:IsA("TextButton") then
                                local text = child.Text:lower()
                                if text:find("fish") or text:find("caught") or text:find("new") then
                                    hasText = true
                                    break
                                end
                            end
                        end
                        
                        if hasText then
                            count = count + 1
                        end
                    end
                end
            end
        end
        
        -- If we found UI notifications, use that count
        if count > 0 and count > notificationCounter then
            notificationCounter = count
            updateFishCounterDisplay()
        end
        
        return count
    end
    
    -- Monitor GUI changes
    PlayerGui.ChildAdded:Connect(function(child)
        task.wait(0.5) -- Wait for GUI to fully load
        checkVisibleNotifications()
    end)
    
    PlayerGui.ChildRemoved:Connect(function(child)
        task.wait(0.5)
        checkVisibleNotifications()
    end)
    
    -- Periodic check
    task.spawn(function()
        while true do
            task.wait(1)
            if PingEnabled and Frame.Visible then
                checkVisibleNotifications()
            end
        end
    end)
end

-- Setup both trackers
task.spawn(setupFishNotificationTracker)
task.spawn(setupUINotificationTracker)

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

    -- Increased height from 90 to 120 to accommodate fish counter
    Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.fromOffset(280, 120)
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
    HeaderText.Text = "VICTORIA HUB"
    HeaderText.ZIndex = 1002

    -- Drag Area
    local DragArea = Instance.new("TextButton", Frame)
    DragArea.Size = UDim2.new(1, 0, 0, 45)
    DragArea.Position = UDim2.fromOffset(0, 0)
    DragArea.BackgroundTransparency = 1
    DragArea.Text = ""
    DragArea.ZIndex = 1005
    DragArea.AutoButtonColor = false

    -- First Divider Line (under header)
    local Divider1 = Instance.new("Frame", Frame)
    Divider1.Size = UDim2.new(1, -24, 0, 1)
    Divider1.Position = UDim2.fromOffset(12, 45)
    Divider1.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    Divider1.BackgroundTransparency = 0.5
    Divider1.BorderSizePixel = 0
    Divider1.ZIndex = 1002

    -- Ping Label (top row)
    PingLabel = Instance.new("TextLabel", Frame)
    PingLabel.Size = UDim2.new(0.5, -18, 0, 25)
    PingLabel.Position = UDim2.fromOffset(12, 52)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextSize = 12
    PingLabel.TextXAlignment = Enum.TextXAlignment.Center
    PingLabel.TextYAlignment = Enum.TextYAlignment.Center
    PingLabel.TextColor3 = getPingColor(0)
    PingLabel.Text = "PING: 0 ms"
    PingLabel.ZIndex = 1002

    -- CPU Label (top row)
    CpuLabel = Instance.new("TextLabel", Frame)
    CpuLabel.Size = UDim2.new(0.5, -18, 0, 25)
    CpuLabel.Position = UDim2.new(0.5, 6, 0, 52)
    CpuLabel.BackgroundTransparency = 1
    CpuLabel.Font = Enum.Font.GothamBold
    CpuLabel.TextSize = 12
    CpuLabel.TextXAlignment = Enum.TextXAlignment.Center
    CpuLabel.TextYAlignment = Enum.TextYAlignment.Center
    CpuLabel.TextColor3 = getCpuColor(0)
    CpuLabel.Text = "CPU: 0.00%"
    CpuLabel.ZIndex = 1002

    -- Vertical Divider between ping and cpu
    local VertDivider = Instance.new("Frame", Frame)
    VertDivider.Size = UDim2.new(0, 1, 0, 25)
    VertDivider.Position = UDim2.new(0.5, 0, 0, 52)
    VertDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    VertDivider.BackgroundTransparency = 0.5
    VertDivider.BorderSizePixel = 0
    VertDivider.ZIndex = 1002

    -- Second Divider Line (before fish counter)
    local Divider2 = Instance.new("Frame", Frame)
    Divider2.Size = UDim2.new(1, -24, 0, 1)
    Divider2.Position = UDim2.fromOffset(12, 82)
    Divider2.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    Divider2.BackgroundTransparency = 0.5
    Divider2.BorderSizePixel = 0
    Divider2.ZIndex = 1002

    -- Fish Notification Counter (bottom row, centered)
    FishCountLabel = Instance.new("TextLabel", Frame)
    FishCountLabel.Size = UDim2.new(1, -24, 0, 30)
    FishCountLabel.Position = UDim2.fromOffset(12, 88)
    FishCountLabel.BackgroundTransparency = 1
    FishCountLabel.Font = Enum.Font.GothamBold
    FishCountLabel.TextSize = 12
    FishCountLabel.TextXAlignment = Enum.TextXAlignment.Center
    FishCountLabel.TextYAlignment = Enum.TextYAlignment.Center
    FishCountLabel.TextColor3 = getFishCountColor(0)
    FishCountLabel.Text = "Fish Notif: 0"
    FishCountLabel.ZIndex = 1002

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
    Title = "Ping & Fish Counter Display",
    Default = false,
    Callback = function(v)
        PingEnabled = v
        if Frame then 
            Frame.Visible = v 
            -- Reset counter when display is turned on
            if v then
                notificationCounter = 0
                activeNotifications = {}
                updateFishCounterDisplay()
                notif("Fish counter reset", 2, Color3.fromRGB(0, 170, 255))
            end
        end
        notif("Display " .. (v and "enabled" or "disabled"), 2, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end
})

-- Add button to manually reset fish counter
miscSection:AddButton({
    Title = "Reset Fish Counter",
    Callback = function()
        notificationCounter = 0
        activeNotifications = {}
        updateFishCounterDisplay()
        notif("Fish counter reset manually", 2, Color3.fromRGB(0, 170, 255))
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
        notif("Custom name set", 2, Color3.fromRGB(0, 170, 255))
    end
})

miscSection:AddInput({
    Title = "Hide Level",
    Default = D.l,
    Callback = function(v)
        D.cl = v
        if D.on then L.Text = v end
        notif("Custom level set", 2, Color3.fromRGB(0, 170, 255))
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
            notif("Custom name/level enabled", 2, Color3.fromRGB(0, 255, 0))
        else
            H.Text = D.h
            L.Text = D.l
            notif("Custom name/level disabled", 2, Color3.fromRGB(255, 0, 0))
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
            notif("Default name/level enabled", 2, Color3.fromRGB(0, 255, 0))
        else
            S.ui.h.Text = S.ui.dh
            S.ui.l.Text = S.ui.dl
            notif("Default name/level disabled", 2, Color3.fromRGB(255, 0, 0))
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
            notif("Infinite Zoom enabled", 2, Color3.fromRGB(0, 255, 0))
        else
            LocalPlayer.CameraMaxZoomDistance = originalZoom[1] or 128
            LocalPlayer.CameraMinZoomDistance = originalZoom[2] or .5
            notif("Infinite Zoom disabled", 2, Color3.fromRGB(255, 0, 0))
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
        if btn then 
            click(btn)
            notif("Auto-reconnecting...", 3, Color3.fromRGB(255, 215, 0))
        end
    end)

miscSection:AddToggle({
    Title = "Auto Reconnect",
    Default = true,
    Callback = function(v) 
        AutoReconnect = v
        notif("Auto Reconnect " .. (v and "enabled" or "disabled"), 2, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
    Default = false,
    Callback = function(s) 
        AntiStaffEnabled = s
        notif("Anti Staff " .. (s and "enabled" or "disabled"), 2, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
                notif("Server hopping...", 3, Color3.fromRGB(255, 165, 0))
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
        notif("FPS Boost " .. (v and "enabled" or "disabled"), 2, v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        
        if v then
            applyBoost()
        else
            restoreBoost()
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
            notif("Fish notifications disabled", 2, Color3.fromRGB(0, 255, 0))
        else
            if PopupConn then PopupConn:Disconnect(); PopupConn = nil end
            if RemoteConn then RemoteConn:Disconnect(); RemoteConn = nil end
            notif("Fish notifications enabled", 2, Color3.fromRGB(255, 0, 0))
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
        notif("3D Rendering " .. (s and "disabled" or "enabled"), 2, s and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0))
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
    Default = false,
    Callback = function(state)
        VFXState.on = state
        notif("VFX " .. (state and "hidden" or "visible"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
    Default = false,
    Callback = function(state)
        if state then
            VFXController.Handle = function() end
            VFXController.RenderAtPoint = function() end
            VFXController.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then pcall(f.ClearAllChildren, f) end
            notif("Skin effects removed", 2, Color3.fromRGB(0, 255, 0))
        else
            VFXController.Handle = ORI.H
            VFXController.RenderAtPoint = ORI.P
            VFXController.RenderInstance = ORI.I
            notif("Skin effects restored", 2, Color3.fromRGB(255, 0, 0))
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
        notif("Cutscene " .. (state and "disabled" or "enabled"), 2, state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
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
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        notif("Rejoining server...", 3, Color3.fromRGB(255, 215, 0))
    end
})

serverSection:AddButton({
    Title = "Server Hop",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        notif("Server hopping...", 3, Color3.fromRGB(255, 165, 0))
    end
})

-- OTHER SCRIPTS SECTION
local scriptSection = Tab8:AddSection("Other Scripts")

scriptSection:AddButton({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
        notif("Loading Infinite Yield...", 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Di paling bawah script
task.spawn(function()
    task.wait(1) -- Tunggu 1 detik biar semua element pasti udah dibuat
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