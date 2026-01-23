-- [[ VICTORIA HUB FISH IT - COMPLETE VictUI VERSION ]] --
-- Version: 1.0.0
-- ALL FEATURES MIGRATED TO VictUI

-- ==================== LOAD VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

-- ==================== CREATE MAIN WINDOW ====================
local Window = Vict:Window({
    Title = "Victoria Hub",
    Footer = "VictoriaHub | Fish It",
    Color = Color3.fromRGB(138, 43, 226),
    ["Tab Width"] = 120,
    Version = 1.0,
    Icon = "rbxassetid://134034549147826",
    Image = "134034549147826"
})

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

-- ==================== TAB 1: INFO ====================
local Tab1 = Window:AddTab({
    Name = "Info",
    Icon = "alert"
})

local infoSection = Tab1:AddSection("Information", false)

infoSection:AddParagraph({
    Title = "Victoria Hub",
    Content = "Welcome to Victoria Hub! Made with VictUI.",
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
    Icon = "player"
})

local playerSection = Tab2:AddSection("Player Features", false)

-- SPEED
playerSection:AddSlider({
    Title = "Walk Speed",
    Content = "Default: 16 | Change walk speed",
    Min = 18,
    Max = 100,
    Default = 18,
    Increment = 1,
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then 
            humanoid.WalkSpeed = Value 
        end
    end
})

-- JUMP POWER
playerSection:AddSlider({
    Title = "Jump Power",
    Content = "Default: 50 | Change jump power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 1,
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then 
            humanoid.JumpPower = Value 
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

SafeConnect("InfiniteJump", UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then 
            h:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end))

-- NOCLIP
_G.Noclip = false

playerSection:AddToggle({
    Title = "Noclip",
    Content = "Walk through walls",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        SafeCancel("NoclipLoop")
        
        if state then
            Performance.Tasks["NoclipLoop"] = task.spawn(function()
                while _G.Noclip do
                    task.wait(0.1)
                    local character = game.Players.LocalPlayer.Character
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
local P, SG = game.Players.LocalPlayer, game.StarterGui
local frozen, last

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

playerSection:AddToggle({
    Title = "Freeze Character",
    Content = "Freeze your character in place",
    Default = false,
    Callback = function(s)
        frozen = s
        setFreeze(s)
    end
})

-- WALK ON WATER
_G.LocalPlayer = game:GetService("Players").LocalPlayer
_G.RunService = game:GetService("RunService")
_G.UserInputService = game:GetService("UserInputService")

_G.walkOnWaterConnection = nil
_G.isWalkOnWater = false
_G.waterPlatform = nil

playerSection:AddToggle({
    Title = "Walk on Water",
    Content = "Walk on water surface",
    Default = false,
    Callback = function(state)
        if state then
            _G.isWalkOnWater = true

            if not _G.waterPlatform then
                _G.waterPlatform = Instance.new("Part")
                _G.waterPlatform.Name = "WaterPlatform"
                _G.waterPlatform.Anchored = true
                _G.waterPlatform.CanCollide = true
                _G.waterPlatform.Transparency = 1
                _G.waterPlatform.Size = Vector3.new(15, 1, 15)
                _G.waterPlatform.Parent = workspace
            end

            if _G.walkOnWaterConnection then
                _G.walkOnWaterConnection:Disconnect()
            end

            _G.walkOnWaterConnection = _G.RunService.RenderStepped:Connect(function()
                if not _G.isWalkOnWater then return end

                _G.character = _G.LocalPlayer.Character
                if not _G.character then return end

                _G.hrp = _G.character:FindFirstChild("HumanoidRootPart")
                if not _G.hrp then return end

                _G.rayParams = RaycastParams.new()
                _G.rayParams.FilterDescendantsInstances = { workspace.Terrain }
                _G.rayParams.FilterType = Enum.RaycastFilterType.Include
                _G.rayParams.IgnoreWater = false

                _G.result = workspace:Raycast(
                    _G.hrp.Position + Vector3.new(0,5,0),
                    Vector3.new(0,-500,0),
                    _G.rayParams
                )

                if _G.result and _G.result.Material == Enum.Material.Water then
                    _G.waterY = _G.result.Position.Y

                    _G.waterPlatform.Position = Vector3.new(
                        _G.hrp.Position.X,
                        _G.waterY,
                        _G.hrp.Position.Z
                    )

                    if _G.hrp.Position.Y < _G.waterY + 2 then
                        if not _G.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            _G.hrp.CFrame = CFrame.new(
                                _G.hrp.Position.X,
                                _G.waterY + 3.2,
                                _G.hrp.Position.Z
                            )
                        end
                    end
                else
                    _G.waterPlatform.Position = Vector3.new(
                        _G.hrp.Position.X,
                        -500,
                        _G.hrp.Position.Z
                    )
                end
            end)

        else
            _G.isWalkOnWater = false

            if _G.walkOnWaterConnection then
                _G.walkOnWaterConnection:Disconnect()
                _G.walkOnWaterConnection = nil
            end

            if _G.waterPlatform then
                _G.waterPlatform:Destroy()
                _G.waterPlatform = nil
            end
        end
    end
})

-- ==================== TAB 3: MAIN (FISHING) ====================
local Tab3 = Window:AddTab({
    Name = "Main",
    Icon = "fish"
})

-- Fishing variables
_G.AutoFishing = false
_G.AutoEquipRod = false
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

-- FISHING SECTION
local fishingSection = Tab3:AddSection("Fishing Features", false)

-- Auto Equip Rod
fishingSection:AddToggle({
    Title = "Auto Equip Rod",
    Content = "Automatically equip fishing rod",
    Default = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        if v then rod() end
    end
})

-- Fishing Mode
local mode = "Instant"
local fishThread

fishingSection:AddDropdown({
    Title = "Fishing Mode",
    Content = "Select fishing mode",
    Options = {"Instant", "Legit"},
    Default = "Instant",
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

-- Instant Fishing Delay Slider
fishingSection:AddSlider({
    Title = "Instant Fishing Delay",
    Content = "Delay between instant fishing cycles",
    Min = 0.05,
    Max = 5,
    Default = _G.InstantDelay,
    Increment = 0.01,
    Callback = function(v)
        _G.InstantDelay = v
    end
})

-- Auto Fishing Toggle
fishingSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Automatically fish",
    Default = false,
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
                        task.wait(_G.InstantDelay)
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

-- BLANTANT V1 SECTION
local blatantV1Section = Tab3:AddSection("Blatant V1", false)

-- BLANTANT V1 CONFIG & FUNCTIONS
local c = { d = false, e = 1.55, f = 0.22 }
local g = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local h, i, j, k, l
pcall(function()
    h = g:WaitForChild("RF/ChargeFishingRod")
    i = g:WaitForChild("RF/RequestFishingMinigameStarted")
    j = g:WaitForChild("RE/FishingCompleted")
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
            pcall(j.FireServer, j)
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

blatantV1Section:AddToggle({
    Title = "Blatant Mode V1",
    Content = "Activate Blatant V1 fishing",
    Default = false,
    Callback = function(z2)
        x(z2)
    end
})

blatantV1Section:AddPanel({
    Title = "Cancel Delay",
    Content = "Delay before canceling fishing",
    Placeholder = "1.7",
    Default = tostring(c.e),
    ButtonText = "Set",
    ButtonCallback = function(input)
        local z5 = tonumber(input)
        if z5 and z5 > 0 then
            c.e = z5
        end
    end
})

blatantV1Section:AddPanel({
    Title = "Complete Delay",
    Content = "Delay before completing fishing",
    Placeholder = "1.4",
    Default = tostring(c.f),
    ButtonText = "Set",
    ButtonCallback = function(input)
        local z8 = tonumber(input)
        if z8 and z8 > 0 then
            c.f = z8
        end
    end
})

blatantV1Section:AddButton({
    Title = "Recovery Fishing",
    Callback = function()
        pcall(function()
            if l then l:InvokeServer() end
            if k then k:FireServer(1) end
        end)
    end
})

-- BLANTANT V2 SECTION
local blatantV2Section = Tab3:AddSection("Blatant V2", false)

-- BLANTANT V2 CONFIG & FUNCTIONS
local netFolder = RS:WaitForChild('Packages'):WaitForChild('_Index'):WaitForChild('sleitnick_net@0.2.0'):WaitForChild('net')

local Remotes = {}
Remotes.RF_RequestFishingMinigameStarted = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
Remotes.RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
Remotes.RF_CancelFishing = netFolder:WaitForChild("RF/CancelFishingInputs")
Remotes.RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
Remotes.RE_EquipTool = netFolder:WaitForChild("RE/EquipToolFromHotbar")

local toggleState = {
    blatantRunning = false,
}

local isSuperInstantRunning = false
_G.ReelSuper = 1.25
toggleState.completeDelays = 0.08
toggleState.delayStart = 0.25

local function superInstantFishingCycle()
    task.spawn(function()
        Remotes.RF_CancelFishing:InvokeServer()
        Remotes.RF_ChargeFishingRod:InvokeServer(tick())
        Remotes.RF_RequestFishingMinigameStarted:InvokeServer(-139.63796997070312, 0.9964792798079721)
        task.wait(toggleState.completeDelays)
        Remotes.RE_FishingCompleted:FireServer()
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

blatantV2Section:AddToggle({
    Title = "Blatant Mode V2",
    Content = "Activate Blatant V2 fishing",
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

blatantV2Section:AddPanel({
    Title = "Reel Delay",
    Content = "Delay between fishing cycles",
    Placeholder = "1.25",
    Default = tostring(_G.ReelSuper),
    ButtonText = "Set",
    ButtonCallback = function(input)
        local num = tonumber(input)
        if num and num >= 0 then
            _G.ReelSuper = num
        end
    end
})

blatantV2Section:AddPanel({
    Title = "Complete Delay",
    Content = "Delay before completing fishing",
    Placeholder = "0.08",
    Default = tostring(toggleState.completeDelays),
    ButtonText = "Set",
    ButtonCallback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            toggleState.completeDelays = num
        end
    end
})

blatantV2Section:AddButton({
    Title = "Recovery Fishing",
    Callback = function()
        pcall(function()
            if Remotes.RF_CancelFishing then
                Remotes.RF_CancelFishing:InvokeServer()
            end
            if Remotes.RE_EquipTool then
                Remotes.RE_EquipTool:FireServer(1)
            end
        end)
    end
})

-- BLANTANT V3 SECTION
local blatantV3Section = Tab3:AddSection("Blatant V3", false)

-- BLANTANT V3 CONFIG
local V3Config = {
    IsRunning = false,
    ReelDelay = 1.55,
    CompleteDelay = 0.22
}

-- NETWORK REMOTES FOR V3
local netFolderV3 = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local RemotesV3 = {}
pcall(function()
    RemotesV3.Charge = netFolderV3:WaitForChild("RF/ChargeFishingRod")
    RemotesV3.StartMinigame = netFolderV3:WaitForChild("RF/RequestFishingMinigameStarted")
    RemotesV3.Complete = netFolderV3:WaitForChild("RE/FishingCompleted")
    RemotesV3.Equip = netFolderV3:WaitForChild("RE/EquipToolFromHotbar")
    RemotesV3.Cancel = netFolderV3:WaitForChild("RF/CancelFishingInputs")
end)

-- STATE THREADS FOR V3
local MainThreadV3 = nil
local EquipThreadV3 = nil

-- CORE CAST FUNCTION FOR V3
local function ExecuteCastV3()
    task.spawn(function()
        pcall(function()
            -- Cancel existing fishing with retry
            local cancelSuccess = RemotesV3.Cancel:InvokeServer()
            if not cancelSuccess then
                while not cancelSuccess do
                    cancelSuccess = RemotesV3.Cancel:InvokeServer()
                    if cancelSuccess then break end
                    task.wait(0.05)
                end
            end
            
            -- Charge rod with retry
            local chargeSuccess = RemotesV3.Charge:InvokeServer(tick())
            if not chargeSuccess then
                while not chargeSuccess do
                    chargeSuccess = RemotesV3.Charge:InvokeServer(tick())
                    if chargeSuccess then break end
                    task.wait(0.05)
                end
            end
            
            -- Start minigame
            RemotesV3.StartMinigame:InvokeServer(-139.63, 0.996)
        end)
    end)
    
    -- Auto complete
    task.spawn(function()
        task.wait(V3Config.CompleteDelay)
        if V3Config.IsRunning then
            pcall(RemotesV3.Complete.FireServer, RemotesV3.Complete)
        end
    end)
end

-- FISHING LOOP FOR V3
local function FishingLoopV3()
    while V3Config.IsRunning do
        ExecuteCastV3()
        task.wait(V3Config.ReelDelay)
    end
end

-- AUTO EQUIP LOOP FOR V3
local function EquipLoopV3()
    while V3Config.IsRunning do
        pcall(RemotesV3.Equip.FireServer, RemotesV3.Equip, 1)
        task.wait(1.5)
    end
end

-- TOGGLE FUNCTION FOR V3
local function ToggleV3(enabled)
    V3Config.IsRunning = enabled
    
    if enabled then
        -- Cancel old threads
        if MainThreadV3 then task.cancel(MainThreadV3) end
        if EquipThreadV3 then task.cancel(EquipThreadV3) end
        
        -- Start new threads
        MainThreadV3 = task.spawn(FishingLoopV3)
        EquipThreadV3 = task.spawn(EquipLoopV3)
    else
        -- Stop threads
        if MainThreadV3 then 
            task.cancel(MainThreadV3)
            MainThreadV3 = nil
        end
        if EquipThreadV3 then 
            task.cancel(EquipThreadV3)
            EquipThreadV3 = nil
        end
        
        -- Cancel fishing
        pcall(RemotesV3.Cancel.InvokeServer, RemotesV3.Cancel)
    end
end

blatantV3Section:AddToggle({
    Title = "Blatant Mode V3",
    Content = "Activate Blatant V3 fishing",
    Default = false,
    Callback = function(value)
        ToggleV3(value)
    end
})

blatantV3Section:AddPanel({
    Title = "Reel Delay",
    Content = "Delay between fishing cycles",
    Placeholder = "1.9",
    Default = tostring(V3Config.ReelDelay),
    ButtonText = "Set",
    ButtonCallback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            V3Config.ReelDelay = num
        end
    end
})

blatantV3Section:AddPanel({
    Title = "Complete Delay",
    Content = "Delay before completing fishing",
    Placeholder = "1.4",
    Default = tostring(V3Config.CompleteDelay),
    ButtonText = "Set",
    ButtonCallback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            V3Config.CompleteDelay = num
        end
    end
})

blatantV3Section:AddButton({
    Title = "Recovery Fishing",
    Callback = function()
        pcall(function()
            if RemotesV3.Cancel then
                RemotesV3.Cancel:InvokeServer()
            end
            if RemotesV3.Equip then
                RemotesV3.Equip:FireServer(1)
            end
        end)
    end
})

-- AUTO PERFECTION SECTION
local autoPerfectionSection = Tab3:AddSection("Auto Perfection", false)

-- AUTO PERFECTION FUNCTIONS
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

local function updateAutoPerfection(s)
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

autoPerfectionSection:AddToggle({
    Title = "Auto Perfection",
    Content = "Automatically get perfect catches",
    Default = false,
    Callback = function(s)
        updateAutoPerfection(s)
    end
})

-- ITEM SECTION
local itemSection = Tab3:AddSection("Item Features", false)

-- RADAR
itemSection:AddToggle({
    Title = "Radar",
    Content = "Activate fishing radar",
    Default = false,
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
itemSection:AddToggle({
    Title = "Bypass Oxygen",
    Content = "Infinite oxygen underwater",
    Default = false,
    Callback = function(s)
        local net = game.ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
        if s then 
            net["RF/EquipOxygenTank"]:InvokeServer(105)
        else 
            net["RF/UnequipOxygenTank"]:InvokeServer() 
        end
    end
})

-- ==================== TAB 4: AUTO ====================
local Tab4 = Window:AddTab({
    Name = "Auto",
    Icon = "loop"
})

-- AUTO SELL SECTION
local sellSection = Tab4:AddSection("Auto Sell", false)

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

sellSection:AddPanel({
    Title = "Auto Sell When Fish ≥",
    Content = "Sell automatically when fish count reaches this number",
    Placeholder = "100",
    Default = tostring(SellAt),
    ButtonText = "Set",
    ButtonCallback = function(text)
        local n = tonumber(text)
        if n and n > 0 then 
            SellAt = math.floor(n) 
            notif("Will sell at " .. SellAt .. " fish", 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

sellSection:AddToggle({
    Title = "Auto Sell All Fish",
    Content = "Automatically sell all fish when threshold reached",
    Default = false,
    Callback = function(state)
        AutoSell = state
    end
})

sellSection:AddPanel({
    Title = "Auto Sell Interval (Minutes)",
    Content = "Sell automatically every X minutes",
    Placeholder = "5",
    Default = tostring(SellMinute),
    ButtonText = "Set",
    ButtonCallback = function(text)
        local n = tonumber(text)
        if n and n > 0 then 
            SellMinute = math.floor(n) 
            notif("Will sell every " .. SellMinute .. " minutes", 3, Color3.fromRGB(0, 255, 0))
        end
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

-- AUTO FAVORITE SECTION
local favSection = Tab4:AddSection("Auto Favorite", false)

-- AUTO FAVORITE SETUP
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

-- Load fish data
local function refreshDropdowns()
    -- Clear old data
    GlobalFav.FishIdToName = {}
    GlobalFav.FishNameToId = {}
    GlobalFav.FishNames = {}
    GlobalFav.Variants = {}
    GlobalFav.VariantIdToName = {}
    GlobalFav.VariantNames = {}
    
    -- Load fish data
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
    
    -- Sort fish names
    table.sort(GlobalFav.FishNames)
    
    -- Load variant data
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
    
    -- Sort variant names
    table.sort(GlobalFav.VariantNames)
    
    notif(string.format("Loaded %d fish and %d variants!", #GlobalFav.FishNames, #GlobalFav.VariantNames), 3, Color3.fromRGB(0, 255, 0))
end

-- Auto Favorite Toggle
favSection:AddToggle({
    Title = "Auto Favorite",
    Content = "Automatically favorite caught fish",
    Default = false,
    Callback = function(state)
        GlobalFav.AutoFavoriteEnabled = state
        
        if state then
            notif("Auto Favorite enabled!", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Auto Favorite disabled!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Fish Dropdown
local fishDropdownInstance
fishDropdownInstance = favSection:AddDropdown({
    Title = "Select Fish",
    Content = "Choose which fish to auto favorite",
    Options = GlobalFav.FishNames,
    Default = "",
    Callback = function(selected)
        GlobalFav.SelectedFishIds = {}
        
        if selected and selected ~= "" then
            local id = GlobalFav.FishNameToId[selected]
            if id then
                GlobalFav.SelectedFishIds[id] = true
                notif(selected .. " selected for favoriting", 2, Color3.fromRGB(0, 255, 0))
            end
        end
    end
})

-- Variant Dropdown
local variantDropdownInstance
variantDropdownInstance = favSection:AddDropdown({
    Title = "Select Variants",
    Content = "Choose which variants to auto favorite",
    Options = GlobalFav.VariantNames,
    Default = "",
    Callback = function(selected)
        GlobalFav.SelectedVariants = {}
        
        if selected and selected ~= "" then
            for vId, name in pairs(GlobalFav.Variants) do
                if name == selected then
                    GlobalFav.SelectedVariants[vId] = true
                    notif(selected .. " selected for favoriting", 2, Color3.fromRGB(0, 255, 0))
                    break
                end
            end
        end
    end
})

-- Refresh Button
favSection:AddButton({
    Title = "Refresh Fish List",
    Callback = function()
        refreshDropdowns()
    end
})

-- Reset Button
favSection:AddButton({
    Title = "Reset Selection",
    Callback = function()
        GlobalFav.SelectedFishIds = {}
        GlobalFav.SelectedVariants = {}
        
        if fishDropdownInstance then
            fishDropdownInstance:Set("")
        end
        
        if variantDropdownInstance then
            variantDropdownInstance:Set("")
        end
        
        notif("All selections cleared!", 2, Color3.fromRGB(255, 255, 0))
    end
})

-- Initialize fish data
task.spawn(function()
    task.wait(2)
    refreshDropdowns()
end)

-- AUTO FAVORITE LOGIC
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
            
            notif("Favorited " .. msg, 2, Color3.fromRGB(0, 255, 0))
        end
    end
end)

-- EVENT SECTION
local eventSection = Tab4:AddSection("Event Features", false)

-- Auto Open Mysterious Cave
_G.AutoOpenMaze = false
_G.AutoOpenMazeTask = nil

eventSection:AddToggle({
    Title = "Auto Open Mysterious Cave",
    Content = "Take Quest First - Auto open mysterious cave",
    Default = false,
    Callback = function(state)
        _G.AutoOpenMaze = state

        if state then
            _G.AutoOpenMazeTask = task.spawn(function()
                while _G.AutoOpenMaze do
                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Packages")
                            :WaitForChild("_Index")
                            :WaitForChild("sleitnick_net@0.2.0")
                            :WaitForChild("net")
                            :WaitForChild("RE/SearchItemPickedUp")
                            :FireServer("TNT")

                        task.wait(1)

                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Packages")
                            :WaitForChild("_Index")
                            :WaitForChild("sleitnick_net@0.2.0")
                            :WaitForChild("net")
                            :WaitForChild("RE/GainAccessToMaze")
                            :FireServer()
                    end)

                    task.wait(2)
                end
            end)
        else
            _G.AutoOpenMaze = false
            if _G.AutoOpenMazeTask then
                task.cancel(_G.AutoOpenMazeTask)
                _G.AutoOpenMazeTask = nil
            end
        end
    end
})

-- Auto Claim Pirate Chest
_G.AutoClaimPirateChest = false

eventSection:AddToggle({
    Title = "Auto Claim Pirate Chest",
    Content = "Automatically claim pirate chest rewards",
    Default = false,
    Callback = function(v)
        _G.AutoClaimPirateChest = v
    end
})

local NetEvent = RS.Packages._Index["sleitnick_net@0.2.0"].net
local Claim = NetEvent["RE/ClaimPirateChest"]
local Award = NetEvent["RE/AwardPirateChest"]

Award.OnClientEvent:Connect(function(chestId)
    if _G.AutoClaimPirateChest then
        pcall(function()
            Claim:FireServer(chestId)
        end)
    end
end)

-- ==================== TAB 5: SHOP ====================
local Tab5 = Window:AddTab({
    Name = "Shop",
    Icon = "shop"
})

-- BUY ROD SECTION
local rodSection = Tab5:AddSection("Buy Rod", false)

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

rodSection:AddDropdown({
    Title = "Select Rod",
    Content = "Choose fishing rod to buy",
    Options = N,
    Default = S,
    Callback = function(v)
        S = v
    end
})

rodSection:AddButton({
    Title = "Buy Rod",
    Callback = function()
        local k = M[S]
        if k and R[k] then
            pcall(function() 
                RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]:InvokeServer(R[k]) 
            end)
            notif("Purchased: " .. k, 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- BUY BAIT SECTION
local baitSection = Tab5:AddSection("Buy Baits", false)

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

baitSection:AddDropdown({
    Title = "Select Bait",
    Content = "Choose bait to buy",
    Options = baitNames,
    Default = selectedBait,
    Callback = function(v)
        selectedBait = v
    end
})

baitSection:AddButton({
    Title = "Buy Bait",
    Callback = function()
        local name = selectedBait:match("^(.-) %(")
        if name and B[name] then
            pcall(function() 
                RS.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]:InvokeServer(B[name]) 
            end)
            notif("Purchased: " .. name, 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- MERCHANT SHOP SECTION
local merchantSection = Tab5:AddSection("Remote Merchant", false)

local TravelingMerchantController = require(
    ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("TravelingMerchantController")
)

merchantSection:AddButton({
    Title = "OPEN MERCHANT",
    Callback = function()
        local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local merchantUI = playerGui:WaitForChild("Merchant")
        
        if merchantUI then
            merchantUI.Enabled = true
            notif("Merchant UI opened", 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

merchantSection:AddButton({
    Title = "CLOSE MERCHANT",
    Callback = function()
        local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local merchantUI = playerGui:FindFirstChild("Merchant")
        
        if merchantUI then
            merchantUI.Enabled = false
            notif("Merchant UI closed", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- BUY WEATHER EVENT SECTION
local weatherSection = Tab5:AddSection("Buy Weather Event", false)

local autoBuyEnabled = false
local buyDelay = 100 -- 100 detik

-- Weather yang dibeli terus
local autoBuyWeathers = {
    "Wind",
    "Cloudy",
    "Storm"
}

weatherSection:AddToggle({
    Title = "Auto Buy Weather",
    Content = "Auto buy Wind, Cloudy, Storm (100s loop)",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
        SafeCancel("AutoBuyWeather")

        if state then
            notif("Auto buy Wind, Cloudy, Storm (100s loop)", 2, Color3.fromRGB(0, 255, 0))

            Performance.Tasks["AutoBuyWeather"] = task.spawn(function()
                while autoBuyEnabled do
                    for _, weatherName in ipairs(autoBuyWeathers) do
                        pcall(function()
                            RS.Packages._Index["sleitnick_net@0.2.0"]
                                .net["RF/PurchaseWeatherEvent"]
                                :InvokeServer(weatherName)
                        end)
                        task.wait(0.3) -- jeda aman antar request
                    end

                    task.wait(buyDelay) -- delay 100 detik
                end
            end)
        end
    end
})

-- ==================== TAB 6: TELEPORT ====================
local Tab6 = Window:AddTab({
    Name = "Teleport",
    Icon = "gps"
})

-- ISLAND TELEPORT SECTION
local islandSection = Tab6:AddSection("Island Teleport", false)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Function untuk mendapatkan HRP
local function getHRP()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        return Player.Character.HumanoidRootPart
    end
    return nil
end

-- Pakai CFrame untuk teleport
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
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = IslandLocations[SelectedIsland]
                notif("Teleported to: " .. SelectedIsland, 3, Color3.fromRGB(0, 255, 0))
            end
        end
    end
})

-- PLAYER TELEPORT SECTION
local tpplayerSection = Tab6:AddSection("Player Teleport", false)

local selectedPlayerName = nil

-- Function untuk mendapatkan daftar pemain
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

-- Refresh function untuk player list
local function refreshPlayerList()
    local players = getPlayerList()
    
    -- Create new dropdown
    tpplayerSection:AddDropdown({
        Title = "Teleport Target",
        Content = "Select player to teleport to",
        Options = players,
        Default = #players > 0 and players[1] or "",
        Callback = function(value)
            selectedPlayerName = value
        end
    })
end

-- Teleport to Player Button
tpplayerSection:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        if not selectedPlayerName then
            notif("No player selected", 3, Color3.fromRGB(255, 0, 0))
            return
        end

        local target = Players:FindFirstChild(selectedPlayerName)
        if not target or not target.Character then
            notif("Target player not available", 3, Color3.fromRGB(255, 0, 0))
            return
        end

        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

        if not targetHRP or not myHRP then
            return
        end

        -- Teleport EXACT position (above target)
        myHRP.CFrame = CFrame.new(
            targetHRP.Position + Vector3.new(0, 3, 0)
        )
        
        notif("Teleported to: " .. selectedPlayerName, 3, Color3.fromRGB(0, 255, 0))
    end
})

-- Refresh Player List Button
tpplayerSection:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        refreshPlayerList()
        notif("Player list refreshed", 3, Color3.fromRGB(0, 255, 0))
    end
})

-- Initialize player list
refreshPlayerList()

-- EVENT TELEPORTER SECTION
local eventsSection = Tab6:AddSection("Event Teleporter", false)

-- SERVICES
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

-- EVENT DATA
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

-- Event Selection Dropdown
eventsSection:AddDropdown({
    Title = "Select Events",
    Content = "Choose events to auto teleport to",
    Options = eventNames,
    Default = "",
    Callback = function(v)
        ST.selectedEvents = {v}
    end
})

-- Auto Event Toggle
eventsSection:AddToggle({
    Title = "Auto Event Teleport",
    Content = "Automatically teleport to selected events",
    Default = false,
    Callback = function(state)
        ST.autoTP = state
        ST.autoFloat = state
        ST.lastTP = nil
        if state then
            task.defer(runEventTP)
            notif("Auto event teleport enabled", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Auto event teleport disabled", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- ==================== TAB 7: SETTINGS ====================
local Tab7 = Window:AddTab({
    Name = "Settings",
    Icon = "settings"
})

-- MISCELLANEOUS SECTION
local playerSettings = Tab7:AddSection("Miscellaneous", false)

-- INFINITE ZOOM
local Z = {game.Players.LocalPlayer.CameraMaxZoomDistance, game.Players.LocalPlayer.CameraMinZoomDistance}

playerSettings:AddToggle({
    Title = "Infinite Zoom",
    Content = "Infinite zoom to take photos",
    Default = false,
    Callback = function(s)
        if s then
            game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
            game.Players.LocalPlayer.CameraMinZoomDistance = .5
        else
            game.Players.LocalPlayer.CameraMaxZoomDistance = Z[1] or 128
            game.Players.LocalPlayer.CameraMinZoomDistance = Z[2] or .5
        end
    end
})

-- ANTI STAFF
local ON = true
local BL = {
    [75974130]=1,[40397833]=1,[187190686]=1,[33372493]=1,[889918695]=1,
    [33679472]=1,[30944240]=1,[25050357]=1,[8462585751]=1,[8811129148]=1,
    [192821024]=1,[4509801805]=1,[124505170]=1,[108397209]=1
}

playerSettings:AddToggle({
    Title = "Anti Staff",
    Content = "Auto serverhop if staff detected",
    Default = true,
    Callback = function(s) 
        ON = s 
    end
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
    if ON and plr~=game.Players.LocalPlayer and BL[plr.UserId] then
        notif(plr.Name.." joined, serverhopping in 6 seconds...", 6, Color3.fromRGB(255, 165, 0))
        hop()
    end
end))

Performance.Tasks["AntiStaffCheck"] = task.spawn(function()
    while task.wait(2) do
        if ON then
            for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr~=game.Players.LocalPlayer and BL[plr.UserId] then
                    notif(plr.Name.." detected, serverhopping in 6 seconds...", 6, Color3.fromRGB(255, 165, 0))
                    hop()
                    break
                end
            end
        end
    end
end)

-- SERVER SECTION
local serverSection = Tab7:AddSection("Server", false)

serverSection:AddButton({
    Title = "Rejoin",
    Content = "Rejoin to the same server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        TeleportService:Teleport(game.PlaceId, player)
    end
})

serverSection:AddButton({
    Title = "Server Hop",
    Content = "Switch to another server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        
        local player = Players.LocalPlayer
        local PlaceId = game.PlaceId
        
        TeleportService:Teleport(PlaceId, player)
    end
})

-- OTHER SCRIPTS SECTION
local scriptSection = Tab7:AddSection("Other Scripts", false)

scriptSection:AddButton({
    Title = "Infinite Yield",
    Content = "Load Infinite Yield script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
        notif("Infinite Yield loaded successfully!", 3, Color3.fromRGB(0, 255, 0))
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
end

-- game:BindToClose(cleanup)

-- ==================== FINAL NOTIFICATION ====================
task.spawn(function()
    task.wait(1)
    notif("Victoria Hub loaded successfully!", 5, Color3.fromRGB(138, 43, 226))
end)

getgenv().VictoriaHubWindow = Window

return Window
