-- [[ VICTORIA HUB FISH IT - COMPLETE ORIGINAL + OPTIMIZED ]] --
-- Version: 0.0.9.2
-- ALL ORIGINAL FEATURES + PERFORMANCE OPTIMIZATION

-- ==================== PERFORMANCE MODULE ====================
local Performance = {
    Connections = {},
    Tasks = {},
    Debounce = {}
}

local function SafeConnect(name, connection)
    Performance.Connections[name] = connection
    return connection
end

local function SafeDisconnect(name)
    if Performance.Connections[name] then
        Performance.Connections[name]:Disconnect()
        Performance.Connections[name] = nil
    end
end

local function SafeCancel(name)
    if Performance.Tasks[name] then
        task.cancel(Performance.Tasks[name])
        Performance.Tasks[name] = nil
    end
end

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
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1358728774098882653/1459169498383909049/ai_repair_20260106014107493.png?ex=69624cfe&is=6960fb7e&hm=7ae73d692bb21a5dabee8b09b0d8447b90c5c2a29612b313ebeb9c3c87ae94e4&",
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

-- ==================== UI LOADING ====================
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
end

-- ==================== PLAYER SETUP ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- CACHE OBJECTS
task.spawn(function()
    _G.Characters = workspace:FindFirstChild("Characters"):WaitForChild(LocalPlayer.Name)
    _G.HRP = _G.Characters:WaitForChild("HumanoidRootPart")
    _G.Overhead = _G.HRP:WaitForChild("Overhead")
    _G.Header = _G.Overhead:WaitForChild("Content"):WaitForChild("Header")
    _G.LevelLabel = _G.Overhead:WaitForChild("LevelContainer"):WaitForChild("Label")
    Player = Players.LocalPlayer
    _G.Title = _G.Overhead:WaitForChild("TitleContainer"):WaitForChild("Label")
    _G.TitleEnabled = _G.Overhead:WaitForChild("TitleContainer")
end)

-- AUTO ANTI-AFK (ACTIVE ON EXECUTE)

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

_G.AntiAFK = true

-- Handle Roblox Idle Event
Players.LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Extra activity loop (anti detect tambahan)
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
    if _G.TitleEnabled then
        _G.TitleEnabled.Visible = false
        _G.Title.TextScaled = false
        _G.Title.TextSize = 19
        _G.Title.Text = "Victoria Hub"

        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = 2
        uiStroke.Color = Color3.fromRGB(170, 0, 255)
        uiStroke.Parent = _G.Title

        local colors = {
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 0, 127),
            Color3.fromRGB(0, 255, 127),
            Color3.fromRGB(255, 255, 0)
        }

        local i = 1
        local function colorCycle()
            if not _G.Title or not _G.Title.Parent then return end
            
            local nextColor = colors[(i % #colors) + 1]
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            
            game:GetService("TweenService"):Create(_G.Title, tweenInfo, { TextColor3 = nextColor }):Play()
            game:GetService("TweenService"):Create(uiStroke, tweenInfo, { Color = nextColor }):Play()
            
            i += 1
            Performance.Tasks["ColorCycle"] = task.delay(1.5, colorCycle)
        end
        
        colorCycle()
    end
end)

-- ==================== MAIN WINDOW (UNIVERSAL DESKTOP + MOBILE) ====================
local Window = WindUI:CreateWindow({
    Title = "Victoria Hub",
    Icon = "rbxassetid://134034549147826",
    Author = "Freemium | Fish It",
    Folder = "VICTORIA_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,                                                          
})                                                             

Window:EditOpenButton({
    Title = "Victoria Hub",
    Icon = "rbxassetid://134034549147826",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("#00c3ff"), 
        Color3.fromHex("#ffffff")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "V0.0.9.2",
    Color = Color3.fromRGB(255, 255, 255),
    Radius = 17,
})



-- ==================== EXECUTOR DETECTION ====================
local executorName = "Unknown"
if identifyexecutor then executorName = identifyexecutor() end

local executorColor = Color3.fromRGB(200, 200, 200)
if executorName:lower():find("flux") then
    executorColor = Color3.fromHex("#30ff6a")
elseif executorName:lower():find("delta") then
    executorColor = Color3.fromHex("#38b6ff")
elseif executorName:lower():find("arceus") then
    executorColor = Color3.fromHex("#a03cff")
elseif executorName:lower():find("krampus") or executorName:lower():find("oxygen") then
    executorColor = Color3.fromHex("#ff3838")
elseif executorName:lower():find("volcano") then
    executorColor = Color3.fromHex("#ff8c00")
elseif executorName:lower():find("synapse") or executorName:lower():find("script") or executorName:lower():find("krypton") then
    executorColor = Color3.fromHex("#ffd700")
elseif executorName:lower():find("wave") then
    executorColor = Color3.fromHex("#00e5ff")
elseif executorName:lower():find("zenith") then
    executorColor = Color3.fromHex("#ff00ff")
elseif executorName:lower():find("seliware") then
    executorColor = Color3.fromHex("#00ffa2")
elseif executorName:lower():find("krnl") then
    executorColor = Color3.fromHex("#1e90ff")
elseif executorName:lower():find("trigon") then
    executorColor = Color3.fromHex("#ff007f")
elseif executorName:lower():find("nihon") then
    executorColor = Color3.fromHex("#8a2be2")
elseif executorName:lower():find("celery") then
    executorColor = Color3.fromHex("#4caf50")
elseif executorName:lower():find("lunar") then
    executorColor = Color3.fromHex("#8080ff")
elseif executorName:lower():find("valyse") then
    executorColor = Color3.fromHex("#ff1493")
elseif executorName:lower():find("vega") then
    executorColor = Color3.fromHex("#4682b4")
elseif executorName:lower():find("electron") then
    executorColor = Color3.fromHex("#7fffd4")
elseif executorName:lower():find("awp") then
    executorColor = Color3.fromHex("#ff005e")
elseif executorName:lower():find("bunni") or executorName:lower():find("bunni.lol") then
    executorColor = Color3.fromHex("#ff69b4")
end

Window:Tag({
    Title = "EXECUTOR | " .. executorName,
    Icon = "github",
    Color = executorColor,
    Radius = 0
})

-- ==================== DISCORD DIALOG ====================
Window:Dialog({
    Icon = "circle-plus",
    Title = "Join Discord",
    Content = "For Update",
    Buttons = {
        {
            Title = "Copy Discord",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/victoriahub")
                    WindUI:Notify({
                        Title = "Copied Successfully!",
                        Content = "The Discord link has been copied to the clipboard.",
                        Duration = 3,
                        Icon = "check"
                    })
                else
                    WindUI:Notify({
                        Title = "Fail!",
                        Content = "Your executor does not support the auto-copy command.",
                        Duration = 3,
                        Icon = "x"
                    })
                end
            end,
        },
        {
            Title = "No",
            Callback = function()
                WindUI:Notify({
                    Title = "Canceled",
                    Content = "You cancel the action.",
                    Duration = 3,
                    Icon = "x"
                })
            end,
        },
    },
})

WindUI:Notify({
    Title = "Victoria Hub Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

-- ==================== TAB 1: INFO ====================
local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

Window:SelectTab(1)

Tab1:Paragraph({
    Title = "Victoria Hub Community",
    Desc = "Join Our Community Discord Server to get the latest updates, support, and connect with other users!",
    Image = "rbxassetid://134034549147826",
    ImageSize = 24,
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "link",
            Callback = function()
                setclipboard("https://discord.gg/victoriahub")
                WindUI:Notify({
                    Title = "Link Disalin!",
                    Content = "Link Discord Victoria Hub berhasil disalin.",
                    Duration = 3,
                    Icon = "copy",
                })
            end,
        }
    }
})

-- ==================== TAB 2: PLAYERS ====================
local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user"
})

local other = Tab2:Section({ 
    Title = "Other",
    Icon = "user",
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = true,
})

-- SPEED
other:Slider({
    Title = "Speed",
    Desc = "Default 16",
    Step = 1,
    Value = { Min = 18, Max = 100, Default = 18 },
    Callback = function(Value)
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = Value end
    end
})

-- JUMP
other:Slider({
    Title = "Jump",
    Desc = "Default 50",
    Step = 1,
    Value = { Min = 50, Max = 500, Default = 50 },
    Callback = function(Value)
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = Value end
    end
})

Tab2:Divider()

-- INFINITE JUMP
local UIS = game:GetService("UserInputService")
_G.InfiniteJump = false

other:Toggle({
    Title = "Infinite Jump",
    Desc = "activate to use infinite jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

SafeConnect("InfiniteJump", UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local h = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- NOCLIP
_G.Noclip = false

other:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        SafeCancel("NoclipLoop")
        
        if state then
            Performance.Tasks["NoclipLoop"] = task.spawn(function()
                while _G.Noclip do
                    task.wait(0.1)
                    local character = Player.Character
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

-- FREEZE CHARACTER (ORIGINAL)
local frozen, last
local P, SG = game.Players.LocalPlayer, game.StarterGui

local function msg(t,c)
    pcall(function()
        SG:SetCore("ChatMakeSystemMessage",{
            Text="[FREEZE] "..t,
            Color=c or Color3.fromRGB(150,255,150),
            Font=Enum.Font.SourceSansBold,
            FontSize=Enum.FontSize.Size24
        })
    end)
end

local function setFreeze(s)
    local c = P.Character or P.CharacterAdded:Wait()
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end

    if s then
        last = r.CFrame
        h.WalkSpeed,h.JumpPower,h.AutoRotate,h.PlatformStand = 0,0,false,true
        for _,t in ipairs(h:GetPlayingAnimationTracks()) do t:Stop(0) end
        local a = h:FindFirstChildOfClass("Animator")
        if a then a:Destroy() end
        r.Anchored = true
        msg("Freeze character",Color3.fromRGB(100,200,255))
    else
        h.WalkSpeed,h.JumpPower,h.AutoRotate,h.PlatformStand = 16,50,true,false
        if not h:FindFirstChildOfClass("Animator") then Instance.new("Animator",h) end
        r.Anchored = false
        if last then r.CFrame = last end
        msg("Character released",Color3.fromRGB(255,150,150))
    end
end

other:Toggle({
    Title="Freeze Character",
    Value=false,
    Callback=function(s)
        frozen = s
        setFreeze(s)
    end
})

-- DISABLE ANIMATIONS (ORIGINAL)
local animDisabled = false
local animConn

local function applyAnimState()
    local c = P.Character or P.CharacterAdded:Wait()
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end

    if animDisabled then
        for _, track in ipairs(h:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0); track:Destroy() end)
        end

        if animConn then animConn:Disconnect(); animConn = nil end

        animConn = h.AnimationPlayed:Connect(function(track)
            if animDisabled and track then
                task.defer(function()
                    pcall(function() track:Stop(0); track:Destroy() end)
                end)
            end
        end)
    else
        if animConn then animConn:Disconnect(); animConn = nil end
        local animate = c:FindFirstChild("Animate")
        if animate then animate.Disabled = false end
        h:ChangeState(Enum.HumanoidStateType.Physics)
        task.wait()
        h:ChangeState(Enum.HumanoidStateType.Running)
    end
end

SafeConnect("CharacterAddedAnim", P.CharacterAdded:Connect(function()
    task.wait(0.4)
    if animDisabled then pcall(applyAnimState) end
end))

other:Toggle({
    Title = "Disable Animations",
    Value = false,
    Callback = function(state)
        animDisabled = state
        pcall(applyAnimState)
    end
})

_G.AutoFishing = false
_G.AutoEquipRod = false
_G.Radar = false
_G.Instant = false
_G.InstantDelay = _G.InstantDelay or 0.65
_G.CallMinDelay = _G.CallMinDelay or 0.18
_G.CallBackoff = _G.CallBackoff or 1.5

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

local RS = game:GetService("ReplicatedStorage")
local net = RS.Packages._Index["sleitnick_net@0.2.0"].net

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

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "gamepad-2"
})

fishing = Tab3:Section({
    Title = "Fishing",
    Icon = "fish",
    TextXAlignment = "Left",
    TextSize = 17
})

fishing:Toggle({
    Title = "Auto Equip Rod",
    Value = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        if v then rod() end
    end
})

local mode = "Instant"
local fishThread
local sellThread

fishing:Dropdown({
    Title = "Mode",
    Values = {"Instant", "Legit"},
    Value = "Instant",
    Callback = function(v)
        mode = v
        
        -- Auto matikan fishing ketika ganti mode
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

-- Variable untuk menyimpan slider
local delaySlider

-- Function untuk update tampilan slider
local function updateDelaySlider()
    if delaySlider then
        if mode == "Instant" then
            -- Tampilkan slider jika mode Instant
            delaySlider.Visible = true
        else
            -- Sembunyikan slider jika mode Legit
            delaySlider.Visible = false
        end
    end
end

-- Buat slider (tetap dibuat, tapi visibility diatur)
delaySlider = fishing:Slider({
    Title = "Instant Fishing Delay",
    Step = 0.01,
    Value = {Min = 0.05, Max = 5, Default = _G.InstantDelay},
    Callback = function(v)
        _G.InstantDelay = v
    end,
    Visible = true -- Awalnya visible, nanti diatur berdasarkan mode
})

-- Update slider visibility berdasarkan mode awal
updateDelaySlider()

fishing:Toggle({
    Title = "Auto Fishing",
    Value = false,
    Callback = function(v)
        _G.AutoFishing = v
        if v then
            if mode == "Instant" then
                _G.Instant = true
                if fishThread then 
                    task.cancel(fishThread) 
                    fishThread = nil
                end
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Instant" do
                        instant_cycle()
                        task.wait(_G.InstantDelay) -- Pakai delay yang bisa diatur
                    end
                end)
            else
                _G.Instant = false
                if fishThread then 
                    task.cancel(fishThread) 
                    fishThread = nil
                end
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Legit" do
                        autoon()
                        task.wait(1)
                    end
                end)
            end
        else
            autooff()
            _G.Instant = false
            if fishThread then 
                task.cancel(fishThread) 
                fishThread = nil
            end
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== BLANTANT V1 CONFIG & FUNCTIONS (ASLI) ==========
local c = { d = false, e = 1.4, f = 0.34 }

local g = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local h, i, j, k, l
pcall(function()
    h = g:WaitForChild("RF/ChargeFishingRod")
    i = g:WaitForChild("RF/RequestFishingMinigameStarted")
    j = g:WaitForChild("RF/catchFishCompleted")
    k = g:WaitForChild("RE/EquipToolFromHotbar")
    l = g:WaitForChild("RF/CancelFishingInputs")
end)

local m = nil
local n = nil

local function p()
    task.spawn(function()
        pcall(function()
            local q, r = l:InvokeServer()
            if not q then
                while not q do
                    local s = l:InvokeServer()
                    if s then break end
                    task.wait(0.05)
                end
            end

            local t, u = h:InvokeServer(math.huge)
            if not t then
                while not t do
                    local v = h:InvokeServer(math.huge)
                    if v then break end
                    task.wait(0.05)
                end
            end

            i:InvokeServer(-139.63, 0.996)
        end)
    end)

    task.spawn(function()
        task.wait(c.f)
        if c.d then
            pcall(j.InvokeServer, j)
        end
    end)
end

local function w()
    n = task.spawn(function()
        while c.d do
            pcall(k.FireServer, k, 1)
            task.wait(1.5)
        end
    end)

    while c.d do
        p()
        task.wait(c.e)
        if not c.d then break end
        task.wait(0.1)
    end
end

local function x(y)
    c.d = y
    if y then
        if m then task.cancel(m) end
        if n then task.cancel(n) end
        m = task.spawn(w)
    else
        if m then task.cancel(m) end
        if n then task.cancel(n) end
        m = nil
        n = nil
        pcall(l.InvokeServer, l)
    end
end

-- ========== BLANTANT V2 CONFIG & FUNCTIONS (ASLI) ==========
local netFolder = ReplicatedStorage:WaitForChild('Packages')
    :WaitForChild('_Index')
    :WaitForChild('sleitnick_net@0.2.0')
    :WaitForChild('net')

local Remotes = {}
Remotes.RF_RequestFishingMinigameStarted = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
Remotes.RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
Remotes.RF_CancelFishing = netFolder:WaitForChild("RF/CancelFishingInputs")
Remotes.RE_FishingCompleted = netFolder:WaitForChild("RF/CatchFishCompleted")
Remotes.RE_EquipTool = netFolder:WaitForChild("RE/EquipToolFromHotbar")

local toggleState = {
    blatantRunning = false,
}

local FishingController = require(
    ReplicatedStorage:WaitForChild('Controllers')
        :WaitForChild('FishingController')
)

local oldCharge = FishingController.RequestChargeFishingRod
FishingController.RequestChargeFishingRod = function(...)
    if toggleState.blatantRunning then
        return
    end
    return oldCharge(...)
end

local isSuperInstantRunning = false
_G.ReelSuper = 1.15
toggleState.completeDelays = 0.25
toggleState.delayStart = 0.2

local function superInstantFishingCycle()
    task.spawn(function()
        Remotes.RF_CancelFishing:InvokeServer()
        Remotes.RF_ChargeFishingRod:InvokeServer(tick())
        Remotes.RF_RequestFishingMinigameStarted:InvokeServer(-139.63796997070312, 0.9964792798079721)
        task.wait(toggleState.completeDelays)
        Remotes.RE_FishingCompleted:InvokeServer()
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
end

-- ========== AUTO PERFECTION FUNCTIONS (ASLI) ==========
local RS = game:GetService("ReplicatedStorage")
local Net = RS.Packages._Index["sleitnick_net@0.2.0"].net
local FC = require(RS.Controllers.FishingController)

local oc, orc = FC.RequestFishingMinigameClick, FC.RequestChargeFishingRod
local ap = false

task.spawn(function()
    while task.wait() do
        if ap then
            Net["RF/UpdateAutoFishingState"]:InvokeServer(true)
        end
    end
end)

local function updateAutoPerfection(s)
    ap = s
    if s then
        FC.RequestFishingMinigameClick = function() end
        FC.RequestChargeFishingRod = function() end
    else
        Net["RF/UpdateAutoFishingState"]:InvokeServer(false)
        FC.RequestFishingMinigameClick = oc
        FC.RequestChargeFishingRod = orc
    end
end

-- ========== AUTO RECOVERY FUNCTION UNTUK KEDUA VERSION ==========
local function doRecoveryFishing()
    
    -- Stop Blatant V1 jika sedang berjalan
    if c.d then
        c.d = false
        if m then 
            pcall(task.cancel, m)
            m = nil
        end
        if n then 
            pcall(task.cancel, n)
            n = nil
        end
    end
    
    -- Stop Blatant V2 jika sedang berjalan
    if toggleState.blatantRunning then
        toggleState.blatantRunning = false
        isSuperInstantRunning = false
    end
    
    -- Cancel semua fishing
    pcall(function()
        if l then
            l:InvokeServer()
        end
        if Remotes.RF_CancelFishing then
            Remotes.RF_CancelFishing:InvokeServer()
        end
    end)
    
    -- Reset rod di kedua version
    pcall(function()
        if k then
            k:FireServer(1)
        end
        if Remotes.RE_EquipTool then
            Remotes.RE_EquipTool:FireServer(1)
        end
    end)
    
    -- Cancel auto fishing
    pcall(function()
        if Remotes.RF_AutoFish then
            Remotes.RF_AutoFish:InvokeServer(false)
        end
    end)
    
    return true
end

-- ========== UI CREATION (DIGABUNG DI TAB3) ==========

-- SECTION 2: BLANTANT V2
blantantV2Section = Tab3:Section({ 
    Title = "Blatant V1",
    Icon = "fish",
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17,
})

blantantV2Section:Toggle({
    Title = "Blatant V1",
    Value = toggleState.blatantRunning,
    Callback = function(value)
        toggleState.blatantRunning = value
        
        if value then
            startSuperInstantFishing()
        else
            stopSuperInstantFishing()
        end
    end
})

blantantV2Section:Input({
    Title = "Reel Delay",
    Placeholder = "Delay (seconds)",
    Default = tostring(_G.ReelSuper),
    Callback = function(input)
        local num = tonumber(input)
        if num and num >= 0 then
            _G.ReelSuper = num
        end
    end
})

blantantV2Section:Input({
    Title = "Custom Complete Delay",
    Placeholder = "Delay (seconds)",
    Default = tostring(toggleState.completeDelays),
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            toggleState.completeDelays = num
        end
    end
})

-- BUTTON RECOVERY UNTUK BLANTANT V2
blantantV2Section:Button({
    Title = "Recovery Fishing",
    Callback = function()
        doRecoveryFishing()
    end
})

-- SECTION 1: BLANTANT V1
blantantV1Section = Tab3:Section({ 
    Title = "Blatant V2",
    Icon = "fish",
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17,
})

blantantV1Section:Toggle({
    Title = "Blatant V2",
    Value = c.d,
    Callback = function(z2)
        x(z2)
    end
})

blantantV1Section:Input({
    Title = "Cancel Delay",
    Placeholder = "1.7",
    Default = tostring(c.e),
    Callback = function(z4)
        local z5 = tonumber(z4)
        if z5 and z5 > 0 then
            c.e = z5
        end
    end
})

blantantV1Section:Input({
    Title = "Complete Delay",
    Placeholder = "1.4",
    Default = tostring(c.f),
    Callback = function(z7)
        local z8 = tonumber(z7)
        if z8 and z8 > 0 then
            c.f = z8
        end
    end
})

-- BUTTON RECOVERY UNTUK BLANTANT V1
blantantV1Section:Button({
    Title = "Recovery Fishing",
    Callback = function()
        doRecoveryFishing()
    end
})

-- SECTION 3: AUTO PERFECTION
autoPerfectionSection = Tab3:Section({ 
    Title = "Auto Perfection",
    Icon = "settings",
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17,
})

autoPerfectionSection:Toggle({
    Title = "Auto Perfection",
    Value = ap,
    Callback = function(s)
        updateAutoPerfection(s)
    end
})

-- ==================== NOTIFICATION OVERRIDE ====================
task.spawn(function()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local active = {}
    local HOLD_EXTRA_TIME = 5.5

    local function isFishNotif(frame)
        return frame:IsA("Frame") and frame.Name == "NewFrame"
    end

    local function lockFrame(frame)
        if active[frame] then return end
        active[frame] = true
        task.delay(HOLD_EXTRA_TIME, function()
            if frame and frame.Parent then frame:Destroy() end
            active[frame] = nil
        end)
    end

    SafeConnect("FishNotification", PlayerGui.DescendantAdded:Connect(function(frame)
        if not isFishNotif(frame) then return end
        task.wait()
        if not frame.Parent then return end
        
        lockFrame(frame)
        
        task.delay(0, function()
            if not frame or not frame.Parent then return end
            local clone = frame:Clone()
            clone.Parent = frame.Parent
            clone.Visible = true
            clone.ZIndex = frame.ZIndex + 1
            
            task.delay(HOLD_EXTRA_TIME, function()
                if clone then clone:Destroy() end
            end)
        end)
    end))
end)

-- ==================== ITEM SECTION ====================
local item = Tab3:Section({     
    Title = "Item",
    Icon = "list-collapse",
    TextXAlignment = "Left",
    TextSize = 17,    
})

-- RADAR
item:Toggle({
    Title = "Radar",
    Value = false,
    Callback = function(s)
        local RS, L = game.ReplicatedStorage, game.Lighting
        if require(RS.Packages.Replion).Client:GetReplion("Data")
        and require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar"):InvokeServer(s) then

            local spr = require(RS.Packages.spr)
            local cc = L:FindFirstChildWhichIsA("ColorCorrectionEffect")

            require(RS.Shared.Soundbook).Sounds.RadarToggle:Play().PlaybackSpeed = 1 + math.random() * .3

            if cc then
                spr.stop(cc)
                local prof = (require(RS.Controllers.ClientTimeController)._getLightingProfile or require(RS.Controllers.ClientTimeController)._getLighting_profile)(require(RS.Controllers.ClientTimeController)) or {}
                local cfg = prof.ColorCorrection or {}

                cfg.Brightness = cfg.Brightness or .04
                cfg.TintColor = cfg.TintColor or Color3.new(1,1,1)

                cc.TintColor = s and Color3.fromRGB(42,226,118) or Color3.fromRGB(255,0,0)
                cc.Brightness = s and .4 or .2

                require(RS.Controllers.TextNotificationController):DeliverNotification{
                    Type="Text",
                    Text="Radar: "..(s and "Enabled" or "Disabled"),
                    TextColor=s and {R=9,G=255,B=0} or {R=255,G=0,B=0}
                }

                spr.target(cc,1,1,cfg)
            end

            spr.stop(L)
            L.ExposureCompensation = 1
            spr.target(L,1,2,{ExposureCompensation=0})
        end
    end
})

-- BYPASS OXYGEN
item:Toggle({
    Title = "Bypass Oxygen",
    Desc = "Inf Oxygen",
    Default = false,
    Callback = function(s)
        local net = game.ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
        if s then net["RF/EquipOxygenTank"]:InvokeServer(105)
        else net["RF/UnequipOxygenTank"]:InvokeServer() end
    end
})

-- ==================== TAB 4: AUTO ====================
local Tab4 = Window:Tab({
    Title = "Auto",
    Icon = "circle-ellipsis"
})

-- AUTO SELL
local sell = Tab4:Section({
    Title = "Sell",
    Icon = "coins",
    TextXAlignment = "Left",
    TextSize = 17
})

local SellAllRF = RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]
local AutoSell = false
local SellAt = 100
local Selling = false
local SellMinute = 5
local LastSell = 0

-- Item utility
local ItemUtility, DataService
task.spawn(function()
    ItemUtility = require(RS.Shared.ItemUtility)
    DataService = require(RS.Packages.Replion).Client:WaitReplion("Data")
end)

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

sell:Input({
    Title = "Auto Sell When Fish ≥",
    Placeholder = "contoh: 100",
    Value = tostring(SellAt),
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then SellAt = math.floor(n) end
    end
})

sell:Toggle({
    Title = "Auto Sell All Fish",
    Value = false,
    Icon = "dollar-sign",
    Callback = function(state)
        AutoSell = state
    end
})

sell:Input({
    Title = "Auto Sell Interval (Minute)",
    Placeholder = "contoh: 5",
    Value = tostring(SellMinute),
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then SellMinute = math.floor(n) end
    end
})

sell:Toggle({
    Title = "Auto Sell All (By Minute)",
    Value = false,
    Icon = "clock",
    Callback = function(state)
        AutoSell = state
        if state then LastSell = os.clock() end
    end
})

-- Combined Auto Sell Heartbeat
SafeConnect("AutoSellHeartbeat", game:GetService("RunService").Heartbeat:Connect(function()
    if not AutoSell or Selling then return end
    
    if getFishCount() >= SellAt then
        Selling = true
        pcall(function() SellAllRF:InvokeServer() end)
        task.delay(1.5, function() Selling = false end)
    end
    
    if os.clock() - LastSell >= (SellMinute * 60) then
        if getFishCount() > 0 then
            Selling = true
            pcall(function() SellAllRF:InvokeServer() end)
            LastSell = os.clock()
            task.delay(1.5, function() Selling = false end)
        else
            LastSell = os.clock()
        end
    end
end))

-- AUTO FAVORITE (Rewritten with correct WindUI)
local GlobalFav = {
    REObtainedNewFishNotification = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"],
    REFavoriteItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FavoriteItem"],

    FishIdToName = {},
    FishNameToId = {},
    FishNames = {},
    Variants = {},
    VariantIdToName = {},
    VariantNames = {},
    SelectedFishIds = {},
    SelectedVariants = {},
    AutoFavoriteEnabled = false
}

-- Load Fish Data
for _, item in pairs(ReplicatedStorage.Items:GetChildren()) do
    local ok, data = pcall(require, item)
    if ok and data.Data and data.Data.Type == "Fish" then
        local id = data.Data.Id
        local name = data.Data.Name
        GlobalFav.FishIdToName[id] = name
        GlobalFav.FishNameToId[name] = id
        table.insert(GlobalFav.FishNames, name)
    end
end

-- Sort fish names alphabetically
table.sort(GlobalFav.FishNames)

-- Load Variants
for _, variantModule in pairs(ReplicatedStorage.Variants:GetChildren()) do
    local ok, variantData = pcall(require, variantModule)
    if ok and variantData.Data and variantData.Data.Name then
        local id = variantData.Data.Id or variantModule.Name
        local name = variantData.Data.Name
        GlobalFav.Variants[id] = name
        GlobalFav.VariantIdToName[id] = name
        table.insert(GlobalFav.VariantNames, name)
    end
end

-- Sort variant names alphabetically
table.sort(GlobalFav.VariantNames)

-- ===== WINDUI SECTION =====
local favSection = Tab4:Section({
    Title = "Auto Favorite",
    Icon = "star",
    TextXAlignment = "Left",
    TextSize = 17
})

-- Toggle
favSection:Toggle({
    Title = "Auto Favorite",
    Value = false,
    Callback = function(state)
        GlobalFav.AutoFavoriteEnabled = state
        
        if state then
            WindUI:Notify({
                Title = "Auto Favorite",
                Content = "Auto Favorite enabled!",
                Duration = 3
            })
            
        else
            WindUI:Notify({
                Title = "Auto Favorite",
                Content = "Auto Favorite disabled!",
                Duration = 3
            })
            
        end
    end
})

-- Fish Dropdown
favSection:Dropdown({
    Title = "Select Fish",
    Desc = "Choose which fish to auto favorite",
    Values = GlobalFav.FishNames,
    Multi = true,
    AllowNone = true,
    SearchBarEnabled = true,
    Callback = function(selectedNames)
        GlobalFav.SelectedFishIds = {}

        for _, name in ipairs(selectedNames) do
            local id = GlobalFav.FishNameToId[name]
            if id then
                GlobalFav.SelectedFishIds[id] = true
            end
        end

        local count = 0
        for _ in pairs(GlobalFav.SelectedFishIds) do count = count + 1 end
        
        
        
        WindUI:Notify({
            Title = "Auto Favorite",
            Content = count .. " fish selected for favoriting",
            Duration = 2
        })
    end
})

-- Variant Dropdown
favSection:Dropdown({
    Title = "Select Variants",
    Desc = "Choose which variants to auto favorite",
    Values = GlobalFav.VariantNames,
    Multi = true,
    AllowNone = true,
    SearchBarEnabled = true,
    Callback = function(selectedVariants)
        GlobalFav.SelectedVariants = {}
        
        for _, vName in ipairs(selectedVariants) do
            for vId, name in pairs(GlobalFav.Variants) do
                if name == vName then
                    GlobalFav.SelectedVariants[vId] = true
                end
            end
        end
        
        local count = 0
        for _ in pairs(GlobalFav.SelectedVariants) do count = count + 1 end
        
        
        
        WindUI:Notify({
            Title = "Auto Favorite",
            Content = count .. " variants selected for favoriting",
            Duration = 2
        })
    end
})

-- Reset Button
favSection:Button({
    Title = "Reset Selection",
    Desc = "Clear all fish and variant selections",
    Callback = function()
        GlobalFav.SelectedFishIds = {}
        GlobalFav.SelectedVariants = {}
        
        
        WindUI:Notify({
            Title = "Auto Favorite",
            Content = "All selections cleared!",
            Duration = 2
        })
    end
})

-- ===== AUTO FAVORITE LOGIC =====
GlobalFav.REObtainedNewFishNotification.OnClientEvent:Connect(function(itemId, _, data)
    if not GlobalFav.AutoFavoriteEnabled then return end

    local uuid = data.InventoryItem and data.InventoryItem.UUID
    local fishName = GlobalFav.FishIdToName[itemId] or "Unknown"
    local variantId = data.InventoryItem and data.InventoryItem.Metadata and data.InventoryItem.Metadata.VariantId

    if not uuid then 
        
        return 
    end

    local isFishSelected = GlobalFav.SelectedFishIds[itemId]
    local isVariantSelected = variantId and GlobalFav.SelectedVariants[variantId]
    
    -- Check if any fish selected
    local hasFishSelection = false
    for _ in pairs(GlobalFav.SelectedFishIds) do 
        hasFishSelection = true 
        break 
    end
    
    -- Check if any variant selected
    local hasVariantSelection = false
    for _ in pairs(GlobalFav.SelectedVariants) do 
        hasVariantSelection = true 
        break 
    end

    local shouldFavorite = false

    -- Logic:
    -- 1. If fish selected AND no variant filter = favorite
    -- 2. If no fish filter AND variant selected = favorite
    -- 3. If BOTH fish AND variant selected = favorite only if BOTH match
    
    if isFishSelected and not hasVariantSelection then
        shouldFavorite = true
    elseif not hasFishSelection and isVariantSelected then
        shouldFavorite = true
    elseif isFishSelected and isVariantSelected then
        shouldFavorite = true
    end

    if shouldFavorite then
        local success = pcall(function()
            GlobalFav.REFavoriteItem:FireServer(uuid)
        end)
        
        if success then
            local msg = fishName
            if isVariantSelected and variantId then
                local variantName = GlobalFav.Variants[variantId] or variantId
                msg = msg .. " (" .. variantName .. ")"
            end
            
            WindUI:Notify({
                Title = "Auto Favorite",
                Content = "Favorited " .. msg,
                Duration = 2
            })
            
            
        end
    else
        
    end
end)

-- ==================== TAB 5: WEBHOOK ====================
local Tab0 = Window:Tab({
    Title = "Webhook",
    Icon = "star",
})

local webhook = Tab0:Section({ 
    Title = "Webhook Fish Caught",
    Icon = "webhook",
    TextXAlignment = "Left",
    TextSize = 17 
})

local httpRequest = syn and syn.request or http and http.request or http_request or (fluxus and fluxus.request) or request

-- Fish Database
local fishDB = {}
local rarityList = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET" }
local tierToRarity = {
    [1] = "Common", [2] = "Uncommon", [3] = "Rare", [4] = "Epic",
    [5] = "Legendary", [6] = "Mythic", [7] = "SECRET"
}
local knownFishUUIDs = {}

-- Load ItemUtility and DataService for webhook
local ItemUtility, Replion, DataService
task.spawn(function()
    ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
    Replion = require(ReplicatedStorage.Packages.Replion)
    DataService = Replion.Client:WaitReplion("Data")
end)

function buildFishDatabase()
    local itemsContainer = RS:WaitForChild("Items")
    if not itemsContainer then return end

    for _, itemModule in ipairs(itemsContainer:GetChildren()) do
        local success, itemData = pcall(require, itemModule)
        if success and type(itemData) == "table" and itemData.Data and itemData.Data.Type == "Fish" then
            local data = itemData.Data
            if data.Id and data.Name then
                fishDB[data.Id] = {
                    Name = data.Name,
                    Tier = data.Tier,
                    Icon = data.Icon,
                    SellPrice = itemData.SellPrice
                }
            end
        end
    end
end

function getInventoryFish()
    if not (DataService and ItemUtility) then return {} end
    local inventoryItems = DataService:GetExpect({ "Inventory", "Items" })
    local fishes = {}
    for _, v in pairs(inventoryItems) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data.Type == "Fish" then
            table.insert(fishes, { Id = v.Id, UUID = v.UUID, Metadata = v.Metadata })
        end
    end
    return fishes
end

function getPlayerCoins()
    if not DataService then return "N/A" end
    local success, coins = pcall(function() return DataService:Get("Coins") end)
    if success and coins then
        return string.format("%d", coins):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end
    return "N/A"
end

function getThumbnailURL(assetString)
    local assetId = assetString:match("rbxassetid://(%d+)")
    if not assetId then return nil end
    local api = string.format(
        "https://thumbnails.roblox.com/v1/assets?assetIds=%s&type=Asset&size=420x420&format=Png",
        assetId
    )
    local success, response = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet(api))
    end)
    return success and response and response.data and response.data[1] and response.data[1].imageUrl
end

function sendTestWebhook()
    if not httpRequest or not _G.WebhookURL or not _G.WebhookURL:match("discord.com/api/webhooks") then
        WindUI:Notify({ Title = "Error", Content = "Webhook URL Empty" })
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
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = game:GetService("HttpService"):JSONEncode(payload)
            })
        end)
    end)
end

function sendNewFishWebhook(newlyCaughtFish)
    if not httpRequest or not _G.WebhookURL or not _G.WebhookURL:match("discord.com/api/webhooks") then return end

    local newFishDetails = fishDB[newlyCaughtFish.Id]
    if not newFishDetails then return end

    local newFishRarity = tierToRarity[newFishDetails.Tier] or "Unknown"
    if #_G.WebhookRarities > 0 and not table.find(_G.WebhookRarities, newFishRarity) then return end

    local fishWeight = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.Weight and string.format("%.2f Kg", newlyCaughtFish.Metadata.Weight)) or "N/A"
    local mutation   = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.VariantId and tostring(newlyCaughtFish.Metadata.VariantId)) or "None"
    local sellPrice  = (newFishDetails.SellPrice and ("$"..string.format("%d", newFishDetails.SellPrice):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "").." Coins")) or "N/A"
    local currentCoins = getPlayerCoins()

    local totalFishInInventory = #getInventoryFish()
    local backpackInfo = string.format("%d/4500", totalFishInInventory)
    local playerName = game.Players.LocalPlayer.Name

    local payload = {
        content = nil,
        embeds = {{
            title = "Victoria Hub Webhook Fish caught!",
            description = string.format("Congrats! **%s** You obtained new **%s** here for full detail fish :", playerName, newFishRarity),
            url = "https://discord.gg/victoriahub",
            color = 65535,
            fields = {
                {
                    name = "Fish Details",
                    value = "```" ..
                        "Name Fish        : " .. newFishDetails.Name .. "\n" ..
                        "Rarity           : " .. newFishRarity .. "\n" ..
                        "Weight           : " .. fishWeight .. "\n" ..
                        "Mutation         : " .. mutation .. "\n" ..
                        "Sell Price       : " .. sellPrice .. "\n" ..
                        "Backpack Counter : " .. backpackInfo .. "\n" ..
                        "Current Coin     : " .. currentCoins .. "\n" ..
                        "```"
                }
            },
            footer = {
                text = "Victoria Hub Webhook",
                icon_url = "https://cdn.discordapp.com/attachments/1358728774098882653/1459169498383909049/ai_repair_20260106014107493.png?ex=69624cfe&is=6960fb7e&hm=7ae73d692bb21a5dabee8b09b0d8447b90c5c2a29612b313ebeb9c3c87ae94e4&"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
            thumbnail = { url = getThumbnailURL(newFishDetails.Icon) }
        }},
        username = "Victoria Hub Webhook",
        avatar_url = "https://cdn.discordapp.com/attachments/1358728774098882653/1459169498383909049/ai_repair_20260106014107493.png?ex=69624cfe&is=6960fb7e&hm=7ae73d692bb21a5dabee8b09b0d8447b90c5c2a29612b313ebeb9c3c87ae94e4&",
        attachments = {}
    }

    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = game:GetService("HttpService"):JSONEncode(payload)
            })
        end)
    end)
end

-- Webhook UI
webhook:Input({
    Title = "URL Webhook",
    Placeholder = "Paste your Discord Webhook URL here",
    Value = _G.WebhookURL or "",
    Callback = function(text) _G.WebhookURL = text end
})

webhook:Dropdown({
    Title = "Rarity Filter",
    Values = rarityList,
    Multi = true,
    AllowNone = true,
    Value = _G.WebhookRarities or {},
    Callback = function(selected_options) _G.WebhookRarities = selected_options end
})

webhook:Toggle({
    Title = "Send Webhook",
    Value = _G.DetectNewFishActive or false,
    Callback = function(state) _G.DetectNewFishActive = state end
})

webhook:Button({
    Title = "Test Webhook",
    Callback = sendTestWebhook
})

-- Initialize fish detection
task.spawn(function()
    buildFishDatabase()
    
    local initialFishList = getInventoryFish()
    for _, fish in ipairs(initialFishList) do
        if fish and fish.UUID then knownFishUUIDs[fish.UUID] = true end
    end
    
    Performance.Tasks["FishDetection"] = task.spawn(function()
        while true do
            task.wait(3)
            if _G.DetectNewFishActive then
                local currentFishList = getInventoryFish()
                for _, fish in ipairs(currentFishList) do
                    if fish and fish.UUID and not knownFishUUIDs[fish.UUID] then
                        knownFishUUIDs[fish.UUID] = true
                        sendNewFishWebhook(fish)
                    end
                end
            end
        end
    end)
end)

-- ==================== TAB 6: SHOP ====================
local Tab5 = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
})

-- BUY ROD
local rod = Tab5:Section({ 
    Title = "Buy Rod",
    Icon = "shrimp",
    TextXAlignment = "Left",
    TextSize = 17,
})

local R = {
    ["Luck Rod"] = 79, ["Carbon Rod"] = 76, ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77, ["Ice Rod"] = 78, ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80, ["Steampunk Rod"] = 6, ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5, ["Ares Rod"] = 126, ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}

local N = {
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)",
    "Demascus Rod (3k Coins)", "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)",
    "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)", "Chrome Rod (437k Coins)",
    "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod (8M Coins)",
    "Bamboo Rod (12M Coins)"
}

local M = {}
for _, display in ipairs(N) do
    local name = display:match("^(.-) %(")
    if name then M[display] = name end
end

local S = N[1]
rod:Dropdown({
    Title = "Select Rod",
    SearchBarEnabled = true,
    Values = N,
    Value = S,
    Callback = function(v) S = v end
})

rod:Button({
    Title = "Buy Rod",
    Callback = function()
        local k = M[S]
        if k and R[k] then
            pcall(function() RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]:InvokeServer(R[k]) end)
        end
    end
})

-- BUY BAIT
local bait = Tab5:Section({
    Title = "Buy Baits",
    Icon = "compass",
    TextXAlignment = "Left",
    TextSize = 17,
})

local B = {
    ["Luck Bait"] = 2, ["Midnight Bait"] = 3, ["Nature Bait"] = 10,
    ["Chroma Bait"] = 6, ["Dark Matter Bait"] = 8, ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16, ["Floral Bait"] = 20
}

local baitNames = {}
for name, _ in pairs(B) do
    table.insert(baitNames, name .. " (Price varies)")
end

local selectedBait = baitNames[1]
bait:Dropdown({
    Title = "Select Bait",
    SearchBarEnabled = true,
    Values = baitNames,
    Value = selectedBait,
    Callback = function(v) selectedBait = v end
})

bait:Button({
    Title = "Buy Bait",
    Callback = function()
        local name = selectedBait:match("^(.-) %(")
        if name and B[name] then
            pcall(function() RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]:InvokeServer(B[name]) end)
        end
    end
})

-- BUY WEATHER EVENT
local weather = Tab5:Section({
    Title = "Buy Weather Event",
    Icon = "cloud-drizzle",
    TextXAlignment = "Left",
    TextSize = 17,
})

local weatherKeyMap = {
    ["Wind (10k Coins)"] = "Wind",
    ["Snow (15k Coins)"] = "Snow",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Storm (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

local weatherNames = {
    "Wind (10k Coins)", "Snow (15k Coins)", "Cloudy (20k Coins)",
    "Storm (35k Coins)", "Radiant (50k Coins)", "Shark Hunt (300k Coins)"
}

local selectedWeathers = {}
local autoBuyEnabled = false
local buyDelay = 540

weather:Dropdown({
    Title = "Select Weather",
    Values = weatherNames,
    Multi = true,
    Callback = function(values) selectedWeathers = values end
})

weather:Input({
    Title = "Buy Delay (minutes)",
    Desc = "Default 9 Minutes",
    Placeholder = "9",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            buyDelay = num * 60
            WindUI:Notify({
                Title = "Delay Updated",
                Content = "Pembelian setiap " .. num .. " menit",
                Duration = 2
            })
        end
    end
})

weather:Toggle({
    Title = "Buy Weather",
    Value = false,
    Callback = function(state)
        autoBuyEnabled = state
        SafeCancel("AutoBuyWeather")
        
        if state then
            WindUI:Notify({
                Title = "Auto Buy",
                Content = "Enabled (Beli setiap " .. (buyDelay / 60) .. " menit)",
                Duration = 2
            })
            
            Performance.Tasks["AutoBuyWeather"] = task.spawn(function()
                while autoBuyEnabled do
                    for _, displayName in ipairs(selectedWeathers) do
                        local key = weatherKeyMap[displayName]
                        if key then
                            pcall(function()
                                RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]:InvokeServer(key)
                            end)
                        end
                    end
                    task.wait(buyDelay)
                end
            end)
        end
    end
})

local Tab6 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Function untuk mendapatkan HRP
local function getHRP()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        return Player.Character.HumanoidRootPart
    end
    return nil
end

-- ISLAND TELEPORT
local island = Tab6:Section({ 
    Title = "Island",
    Icon = "tree-palm",
    TextXAlignment = "Left",
    TextSize = 17,
})

-- Pakai CFrame untuk teleport
local IslandLocations = {
    ["Ancient Jungle"] = CFrame.new(1518, 1, -186),
    ["Coral Refs"] = CFrame.new(-3204.128, 4.744, 2278.412),
    ["Crater Island"] = CFrame.new(988.366, 2.678, 5011.464),
    ["Enchant Room"] = CFrame.new(3232.390, -1302.855, 1401.953),
    ["Enchant Room 2"] = CFrame.new(1480, 126, -585),
    ["Esoteric Island"] = CFrame.new(1990, 5, 1398),
    ["Fisherman Island"] = CFrame.new(-63.768, 3.262, 2852.105),
    ["Kohana Volcano"] = CFrame.new(-545.302429, 17.1266193, 118.870537),
    ["Konoha"] = CFrame.new(-609.842, 19.250, 424.131),
    ["Sacred Temple"] = CFrame.new(1454.296, -22.125, -634.009),
    ["Sysyphus Statue"] = CFrame.new(-3734.805, -135.074, -885.983),
    ["Treasure Room"] = CFrame.new(-3556.384, -279.074, -1610.293),
    ["Tropical Grove"] = CFrame.new(-2176.410, 53.487, 3638.278),
    ["Underground Cellar"] = CFrame.new(2135, -93, -701),
    ["Weather Machine"] = CFrame.new(-1523.458, 2.875, 1914.113),
    ["Ancient Ruin"] = CFrame.new(6083.515, -585.924, 4632.402),
    ["Pirate Cave"] = CFrame.new(3416.945, 4.193, 3510.004),
    ["Treesaure Pirate"] = CFrame.new(3341.121, -301.021, 3093.529),
}

local islandNames = {}
for name in pairs(IslandLocations) do table.insert(islandNames, name) end
table.sort(islandNames)

local SelectedIsland = islandNames[1]
island:Dropdown({
    Title = "Select Island",
    SearchBarEnabled = true,
    Values = islandNames,
    Value = SelectedIsland,
    Callback = function(Value) SelectedIsland = Value end
})

island:Button({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = IslandLocations[SelectedIsland]
            end
        end
    end
})

-- ======================================================
-- PLAYER TELEPORT (FULL FIX – NO UI BREAK)
-- ======================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ======================================================
-- SECTION
-- ======================================================

local tpplayer = Tab6:Section({
    Title = "Player Teleport",
    Icon = "user-search",
    TextXAlignment = "Left",
    TextSize = 17,
})

-- ======================================================
-- STATE
-- ======================================================

local selectedPlayerName = nil
local dropdownRef = nil

-- ======================================================
-- UTILS
-- ======================================================

local function getHRP(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            table.insert(list, plr.Name)
        end
    end
    table.sort(list)
    return list
end

-- ======================================================
-- DROPDOWN INIT
-- ======================================================

dropdownRef = tpplayer:Dropdown({
    Title = "Teleport Target",
    Values = {},
    Callback = function(value)
        selectedPlayerName = value
    end
})

-- ======================================================
-- REFRESH FUNCTION (SAFE)
-- ======================================================

local function refreshDropdown()
    local players = getPlayerList()

    -- Refresh values only
    dropdownRef:Refresh(players, true)

    -- Set default manually (NO :Set)
    if #players > 0 then
        selectedPlayerName = players[1]
    else
        selectedPlayerName = nil
    end
end

-- ======================================================
-- TELEPORT BUTTON
-- ======================================================

tpplayer:Button({
    Title = "Teleport to Player",
    Callback = function()
        if not selectedPlayerName then
            warn("[TP] No player selected")
            return
        end

        local target = Players:FindFirstChild(selectedPlayerName)
        if not target or not target.Character then
            warn("[TP] Target not available")
            return
        end

        local targetHRP = getHRP(target.Character)
        local myHRP = getHRP(Player.Character)

        if not targetHRP or not myHRP then
            return
        end

        -- Teleport EXACT position (above target)
        myHRP.CFrame = CFrame.new(
            targetHRP.Position + Vector3.new(0, 3, 0)
        )
    end
})

-- ======================================================
-- MANUAL REFRESH BUTTON
-- ======================================================

tpplayer:Button({
    Title = "Refresh Player List",
    Callback = function()
        refreshDropdown()
    end
})

-- ======================================================
-- AUTO REFRESH ON JOIN / LEAVE
-- ======================================================

Players.PlayerAdded:Connect(function(plr)
    if plr ~= Player then
        task.wait(0.5)
        refreshDropdown()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr ~= Player then
        task.wait(0.5)
        refreshDropdown()
    end
end)

-- ======================================================
-- INIT
-- ======================================================

refreshDropdown()

events = Tab6:Section({
    Title = "Event Teleporter",
    Icon = "calendar",
    TextXAlignment = "Left",
    TextSize = 17,
})

-- SERVICES (SATU TABLE)
local S = setmetatable({}, {
    __index = function(_, k)
        return game:GetService(k)
    end
})

-- STATE
local ST = {
    player = S.Players.LocalPlayer,
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

-- INIT CHARACTER
local function bindChar(c)
    ST.char = c
    task.wait(1)
    ST.hrp = c:WaitForChild("HumanoidRootPart")
end

bindChar(ST.player.Character or ST.player.CharacterAdded:Wait())
ST.player.CharacterAdded:Connect(bindChar)

-- EVENT DATA (TETAP)
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

-- EVENT NAMES
local eventNames = {}
for n in pairs(eventData) do
    eventNames[#eventNames+1] = n
end

-- FORCE TP
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

-- MAIN TP LOOP
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
                local rings = S.Workspace:FindFirstChild("!!! MENU RINGS")
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
                    for _, d in ipairs(S.Workspace:GetDescendants()) do
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

-- FLOAT
S.RunService.RenderStepped:Connect(function()
    if ST.autoFloat and ST.hrp then
        local pos = ST.hrp.Position
        local targetY = S.Workspace.Terrain.WaterLevel + ST.floatOffset
        if pos.Y < targetY then
            ST.hrp.CFrame = CFrame.new(pos.X, targetY, pos.Z)
            ST.hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

Tab6:Dropdown({
    Title = "Select Events",
    Values = eventNames,
    Multi = true,
    AllowNone = true,
    Callback = function(v)
        ST.selectedEvents = v
    end
})

Tab6:Toggle({
    Title = "Auto Event",
    Value = false,
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
local Tab7 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local playerSettings = Tab7:Section({ 
    Title = "Player Featured",
    Icon = "play",
    TextXAlignment = "Left",
    TextSize = 17,
})

local PingEnabled = true
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

    frame.InputChanged:Connect(function(input)
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
    Gui = Instance.new("ScreenGui")
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

if createPingDisplay() then
    SafeConnect("PingUpdate", game:GetService("RunService").RenderStepped:Connect(function()
        if not PingEnabled then return end
        
        local now = tick()
        if now - lastPingUpdate < pingUpdateInterval then return end
        lastPingUpdate = now
        
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        
        StatsText.Text = string.format("PING: %d ms | FPS: %d", ping, math.min(fps, 999))
    end))
end

playerSettings:Toggle({
    Title = "Ping Display",
    Default = false,
    Callback = function(v)
        PingEnabled = v
        if Frame then Frame.Visible = v end
    end
})

-- HIDE NAME & LEVEL
local P = Player
local C = P.Character or P.CharacterAdded:Wait()
local O = C:WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
local H = O.Content.Header
local L = O.LevelContainer.Label

local D = {h = H.Text, l = L.Text, ch = H.Text, cl = L.Text, on = false}

playerSettings:Input({
    Title = "Hide Name",
    Placeholder = "Input Name",
    Default = D.h,
    Callback = function(v)
        D.ch = v
        if D.on then H.Text = v end
    end
})

playerSettings:Input({
    Title = "Hide Level",
    Placeholder = "Input Level",
    Default = D.l,
    Callback = function(v)
        D.cl = v
        if D.on then L.Text = v end
    end
})

playerSettings:Toggle({
    Title = "Hide Name & Level (Custom)",
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

SafeConnect("CharAddedHide", P.CharacterAdded:Connect(function(c)
    task.wait(0.2)
    S.ui = setup(c)
    if S.on then
        S.ui.h.Text = HN
        S.ui.l.Text = HL
    end
end))

playerSettings:Toggle({
    Title = "Hide Name & Level (Default)",
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
local Z = {P.CameraMaxZoomDistance, P.CameraMinZoomDistance}

playerSettings:Toggle({
    Title="Infinite Zoom",
    Desc="infinite zoom to take a photo",
    Value=false,
    Callback=function(s)
        if s then
            P.CameraMaxZoomDistance=math.huge
            P.CameraMinZoomDistance=.5
        else
            P.CameraMaxZoomDistance=Z[1] or 128
            P.CameraMinZoomDistance=Z[2] or .5
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
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
end

SafeConnect("AutoReconnect", game:GetService("CoreGui"):WaitForChild("RobloxPromptGui")
    :WaitForChild("promptOverlay")
    .ChildAdded:Connect(function(v)
        if not AutoReconnect then return end
        if v.Name ~= "ErrorPrompt" then return end

        task.wait(0.3)
        local btn = v:FindFirstChild("ReconnectButton", true)
        if btn then click(btn) end
    end))

playerSettings:Toggle({
    Title = "Auto Reconnect",
    Desc = "Auto click Reconnect",
    Default = false,
    Callback = function(v) AutoReconnect = v end
})

-- ANTI STAFF
local ON = true
local BL = {
    [75974130]=1,[40397833]=1,[187190686]=1,[33372493]=1,[889918695]=1,
    [33679472]=1,[30944240]=1,[25050357]=1,[8462585751]=1,[8811129148]=1,
    [192821024]=1,[4509801805]=1,[124505170]=1,[108397209]=1
}

playerSettings:Toggle({
    Title="Anti Staff",
    Desc="Auto serverhop if there is staff",
    Value=true,
    Callback=function(s) ON=s end
})

local function hop()
    task.wait(6)
    local d = game.HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    ).data
    for _,v in ipairs(d) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, Player)
            break
        end
    end
end

SafeConnect("PlayerAddedAntiStaff", game:GetService("Players").PlayerAdded:Connect(function(plr)
    if ON and plr~=Player and BL[plr.UserId] then
        WindUI:Notify({
            Title="Victoria Hub",
            Content=plr.Name.." telah join, serverhop dalam 6 detik...",
            Duration=6,
            Icon="alert-triangle"
        })
        hop()
    end
end))

Performance.Tasks["AntiStaffCheck"] = task.spawn(function()
    while task.wait(2) do
        if ON then
            for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr~=Player and BL[plr.UserId] then
                    WindUI:Notify({
                        Title="Victoria Hub",
                        Content=plr.Name.." terdeteksi, serverhop dalam 6 detik...",
                        Duration=6,
                        Icon="alert-triangle"
                    })
                    hop()
                    break
                end
            end
        end
    end
end)

-- ==================== GRAPHICS SECTION ====================
local graphic = Tab7:Section({ 
    Title = "Graphics Featured",
    Icon = "chart-bar",
    TextXAlignment = "Left",
    TextSize = 17,
})

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
graphic:Toggle({
    Title = "FPS Boost",
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

-- REMOVE FISH NOTIFICATION
local PopupConn, RemoteConn

graphic:Toggle({
    Title = "Remove Fish Notification Pop-up",
    Value = false,
    Callback = function(state)
        local PlayerGui = Player:WaitForChild("PlayerGui")
        local RemoteEvent = RS.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]

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
local G
graphic:Toggle({
    Title = "Disable 3D Rendering",
    Value = false,
    Callback = function(s)
        pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(not s) end)
        if s then
            G = Instance.new("ScreenGui")
            G.IgnoreGuiInset = true
            G.ResetOnSpawn = false
            G.Parent = Player.PlayerGui

            Instance.new("Frame", G).Size = UDim2.fromScale(1,1)
            G.Frame.BackgroundColor3 = Color3.new(1,1,1)
            G.Frame.BorderSizePixel = 0
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

SafeConnect("VFXDescendant", workspace.DescendantAdded:Connect(function(o)
    if VFXState.on and VFX[o.ClassName] and o.Enabled ~= nil then
        task.defer(function() o.Enabled = false end)
    end
end))

SafeConnect("LightingDescendant", game:GetService("Lighting").DescendantAdded:Connect(function(o)
    if VFXState.on and LE[o.ClassName] and o.Enabled ~= nil then
        task.defer(function() o.Enabled = false end)
    end
end))

graphic:Toggle({
    Title = "Hide All VFX",
    Value = false,
    Callback = function(state)
        VFXState.on = state
        if state then disableVFX() else restoreVFX() end
    end
})

-- REMOVE SKIN EFFECT
local VFX = require(RS.Controllers.VFXController)
local ORI = {
    H = VFX.Handle,
    P = VFX.RenderAtPoint,
    I = VFX.RenderInstance
}

graphic:Toggle({
    Title = "Remove Skin Effect",
    Desc = "Remove Your Skin Effect",
    Default = false,
    Callback = function(state)
        if state then
            VFX.Handle = function() end
            VFX.RenderAtPoint = function() end
            VFX.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then pcall(f.ClearAllChildren, f) end
        else
            VFX.Handle = ORI.H
            VFX.RenderAtPoint = ORI.P
            VFX.RenderInstance = ORI.I
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
            LocalPlayer:SetAttribute("IgnoreFOV", false)
        end)
        return
    end
    return _G.OriginalPlayCutscene(self, ...)
end

graphic:Toggle({
    Title = "Disable Cutscene",
    Value = false,
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

-- ==================== FINAL CLEANUP ====================
local function cleanup()
    for name, _ in pairs(Performance.Tasks) do SafeCancel(name) end
    for name, _ in pairs(Performance.Connections) do SafeDisconnect(name) end
    
    _G.InfiniteJump = false
    _G.Noclip = false
    _G.AutoFishing = false
    _G.AutoEquipRod = false
    _G.Radar = false
    _G.Instant = false
    _G.AntiAFK = false
    _G.AutoSkipCutscene = false
    
    if Frame then Frame:Destroy() end
    if G then G:Destroy() end
    
    
end

--- game:BindToClose(cleanup)

-- ==================== FINAL INIT ====================
getgenv().VictoriaHubWindow = Window

return Window
