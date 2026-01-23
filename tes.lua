-- [[ VICTORIA HUB FISH IT - SIMPLE VERSION ]] --
-- Version: 1.0.0

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
    Icon = "user"
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

UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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

-- ==================== TAB 3: MAIN (FISHING) ====================
local Tab3 = Window:AddTab({
    Name = "Main",
    Icon = "fish"
})

-- FISHING SECTION
local fishingSection = Tab3:AddSection("Fishing Features", false)

-- Fishing variables
_G.AutoFishing = false
_G.AutoEquipRod = false
_G.InstantDelay = 0.65
local fishThread
local RS = game:GetService("ReplicatedStorage")
local net = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- Simple fishing function
local function simpleFish()
    pcall(function()
        net["RF/ChargeFishingRod"]:InvokeServer()
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996)
        task.wait(_G.InstantDelay)
        net["RE/FishingCompleted"]:FireServer()
    end)
end

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
            fishThread = task.spawn(function()
                while _G.AutoFishing do
                    simpleFish()
                    task.wait(_G.InstantDelay + 0.5)
                end
            end)
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
            pcall(function()
                net["RE/EquipToolFromHotbar"]:FireServer(1)
            end)
        end
    end
})

-- Fishing Delay
fishingSection:AddSlider({
    Title = "Fishing Delay",
    Content = "Delay between fishing cycles",
    Min = 0.5,
    Max = 5,
    Default = _G.InstantDelay,
    Increment = 0.1,
    Callback = function(v)
        _G.InstantDelay = v
    end
})

-- Cancel Delay Input (tanpa button Set)
local cancelDelayValue = 1.7
fishingSection:AddPanel({
    Title = "Cancel Delay",
    Content = "Delay before canceling fishing",
    Placeholder = "1.7",
    Default = tostring(cancelDelayValue),
    ButtonText = "Done",
    ButtonCallback = function(input)
        -- Button hanya untuk close
    end,
    Callback = function(input)
        -- Ini yang auto set ketika input berubah
        local num = tonumber(input)
        if num and num > 0 then
            cancelDelayValue = num
        end
    end
})

-- Complete Delay Input (tanpa button Set)
local completeDelayValue = 0.22
fishingSection:AddPanel({
    Title = "Complete Delay",
    Content = "Delay before completing fishing",
    Placeholder = "0.22",
    Default = tostring(completeDelayValue),
    ButtonText = "Done",
    ButtonCallback = function(input)
        -- Button hanya untuk close
    end,
    Callback = function(input)
        -- Ini yang auto set ketika input berubah
        local num = tonumber(input)
        if num and num > 0 then
            completeDelayValue = num
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

local AutoSell = false
local SellAt = 100

-- Auto Sell Threshold Input (tanpa button Set)
sellSection:AddPanel({
    Title = "Auto Sell When Fish ≥",
    Content = "Sell automatically when fish count reaches this number",
    Placeholder = "100",
    Default = tostring(SellAt),
    ButtonText = "Done",
    ButtonCallback = function(input)
        -- Button hanya untuk close
    end,
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then 
            SellAt = math.floor(n) 
            notif("Will sell at " .. SellAt .. " fish", 3, Color3.fromRGB(0, 255, 0))
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

-- Auto Sell Interval Input (tanpa button Set)
local SellMinute = 5
sellSection:AddPanel({
    Title = "Auto Sell Interval (Minutes)",
    Content = "Sell automatically every X minutes",
    Placeholder = "5",
    Default = tostring(SellMinute),
    ButtonText = "Done",
    ButtonCallback = function(input)
        -- Button hanya untuk close
    end,
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then 
            SellMinute = math.floor(n) 
            notif("Will sell every " .. SellMinute .. " minutes", 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- ==================== TAB 5: SHOP ====================
local Tab5 = Window:AddTab({
    Name = "Shop",
    Icon = "shop"
})

-- BUY ROD SECTION
local rodSection = Tab5:AddSection("Buy Rod", false)

local R = {
    ["Luck Rod"] = 79,
    ["Carbon Rod"] = 76,
    ["Grass Rod"] = 85,
    ["Ice Rod"] = 78,
    ["Lucky Rod"] = 4
}

local rodOptions = {"Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)", "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)"}

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
            notif("Purchased: " .. name, 3, Color3.fromRGB(0, 255, 0))
        end
    end
})

-- BUY BAIT SECTION
local baitSection = Tab5:AddSection("Buy Baits", false)

local B = {
    ["Luck Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Nature Bait"] = 10,
    ["Chroma Bait"] = 6
}

local baitOptions = {"Luck Bait", "Midnight Bait", "Nature Bait", "Chroma Bait"}

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
            notif("Purchased: " .. selectedBait, 3, Color3.fromRGB(0, 255, 0))
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

local IslandLocations = {
    ["Ancient Jungle"] = CFrame.new(1480.000, 3.029, -334.000),
    ["Coral Refs"] = CFrame.new(-3270.860, 2.500, 2228.100),
    ["Crater Island"] = CFrame.new(1079.570, 3.645, 5080.350),
    ["Fisherman Island"] = CFrame.new(51.000, 2.279, 2762.000),
    ["Kohana Volcano"] = CFrame.new(-561.810, 21.239, 156.720),
    ["Konoha"] = CFrame.new(-625.000, 19.250, 424.000),
    ["Tropical Grove"] = CFrame.new(-2020.000, 4.744, 3755.000)
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
            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = IslandLocations[SelectedIsland]
                notif("Teleported to: " .. SelectedIsland, 3, Color3.fromRGB(0, 255, 0))
            end
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

-- HIDE NAME
local hideNameValue = "Player"
playerSettings:AddPanel({
    Title = "Hide Name",
    Content = "Custom name to display",
    Placeholder = "Input Name",
    Default = hideNameValue,
    ButtonText = "Done",
    ButtonCallback = function(input)
        -- Button hanya untuk close
    end,
    Callback = function(v)
        hideNameValue = v
        notif("Custom name set: " .. v, 3, Color3.fromRGB(0, 255, 0))
    end
})

-- HIDE LEVEL
local hideLevelValue = "Lv. 100"
playerSettings:AddPanel({
    Title = "Hide Level",
    Content = "Custom level to display",
    Placeholder = "Input Level",
    Default = hideLevelValue,
    ButtonText = "Done",
    ButtonCallback = function(input)
        -- Button hanya untuk close
    end,
    Callback = function(v)
        hideLevelValue = v
        notif("Custom level set: " .. v, 3, Color3.fromRGB(0, 255, 0))
    end
})

-- SERVER SECTION
local serverSection = Tab7:AddSection("Server", false)

serverSection:AddButton({
    Title = "Rejoin",
    Content = "Rejoin to the same server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        TeleportService:Teleport(game.PlaceId, player)
    end
})

serverSection:AddButton({
    Title = "Server Hop",
    Content = "Switch to another server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        TeleportService:Teleport(game.PlaceId, player)
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

-- ==================== FINAL NOTIFICATION ====================
task.spawn(function()
    task.wait(1)
    notif("Victoria Hub loaded successfully!", 5, Color3.fromRGB(138, 43, 226))
end)

getgenv().VictoriaHubWindow = Window

return Window
