--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║           Grow Garden 2 - Main Script (Core)            ║
    ║              All Features Auto-Enabled                   ║
    ╚══════════════════════════════════════════════════════════════╝
]]

-- Key Authentication (BYPASSED)
-- if not getgenv().Key or getgenv().Key == "ENTER_YOUR_LICENSE_KEY_HERE" then
--     warn("❌ Invalid or missing key! Please set your key in Loader.lua")
--     return
-- end

-- Wait for game to load
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer 
print("[GrowGarden2] Game loaded, starting...")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuration (from Loader)
local Config = getgenv().GardenConfig or {}

-- ============================================
-- DEFAULT SETTINGS (All enabled by default)
-- ============================================
local AutoSettings = {
    AutoHarvest = Config.AutoHarvest ~= false,
    AutoSell = Config.AutoSell ~= false,
    AutoBuySeeds = Config.AutoBuySeeds ~= false,
    AutoBuyGears = Config.AutoBuyGears ~= false,
    AutoBuyPets = Config.AutoBuyPets ~= false,
    AutoPlant = Config.AutoPlant ~= false,
    AutoWater = Config.AutoWater ~= false,
    AutoPlaceSprinkler = Config.AutoPlaceSprinkler ~= false,
    AutoHarvestSpecial = Config.AutoHarvestSpecial ~= false,
    AutoPickupRainbow = Config.AutoPickupRainbow ~= false,
    AutoPickupGold = Config.AutoPickupGold ~= false,
    AutoRedeemCode = Config.AutoRedeemCode ~= false,
    AutoSendMail = Config.MailSystem and Config.MailSystem.Enabled or false,
    AutoSendPets = Config.MailSystem and Config.MailSystem.AutoSendPets or false,
    AutoSendSeeds = Config.MailSystem and Config.MailSystem.AutoSendSeeds or false,
    HarvestDelay = Config.Timing and Config.Timing.HarvestDelay or 0.01,
    SellDelay = Config.Timing and Config.Timing.SellDelay or 0.1,
    PlantDelay = Config.Timing and Config.Timing.PlantDelay or 0.1,
    BuyDelay = Config.Timing and Config.Timing.BuyDelay or 0.02,
    FPSCap = Config.Performance and Config.Performance.FPSCap or 60,
    LowEffect = Config.Performance and Config.Performance.LowEffect or true,
    RedeemCode = Config.RedeemCodes and Config.RedeemCodes.Code or "TEAMGREENBEAN",
    DiscordWebhook = Config.Webhook and Config.Webhook.URL or "",
    DiscordNotifications = {
        RainbowSeeds = Config.Webhook and Config.Webhook.NotifyRainbow ~= false,
        GoldSeeds = Config.Webhook and Config.Webhook.NotifyGold ~= false,
        Pets = Config.Webhook and Config.Webhook.NotifyPets ~= false,
    },
    SendPetUsername = Config.MailSystem and Config.MailSystem.SendPetUsername or "",
    SendSeedUsername = Config.MailSystem and Config.MailSystem.SendSeedUsername or "",
    WishSeedUsername = Config.MailSystem and Config.MailSystem.WishUsername or "",
    SendPetNote = Config.MailSystem and Config.MailSystem.PetNote or "pet mail",
    SendSeedNote = Config.MailSystem and Config.MailSystem.SeedNote or "seed mail",
    WishSeedNote = Config.MailSystem and Config.MailSystem.WishNote or "wish",
    AutoBuyPetsRarityFilter = Config.PetSettings and Config.PetSettings.RarityFilter ~= false,
    AutoBuyPetsMaxPrice = Config.PetSettings and Config.PetSettings.MaxPrice or 0,
    AllowedRarities = Config.PetSettings and Config.PetSettings.AllowedRarities or {
        Common = false, Uncommon = false, Rare = false, Epic = false,
        Legendary = true, Mythic = true, Super = true,
    },
}

-- Seed Selection from config
local SeedSelection = Config.SeedSelection or {}
local GearSelection = Config.GearSelection or {}

-- ============================================
-- SEED DATA
-- ============================================
local SeedList = {
    "Carrot", "Strawberry", "Blueberry", "Tulip", "Tomato", "Apple",
    "Bamboo", "Corn", "Cactus", "Pineapple", "Mushroom", "Green Bean",
    "Banana", "Grape", "Coconut", "Mango", "Dragon Fruit", "Acorn",
    "Cherry", "Sunflower", "Venus Fly Trap", "Pomegranate", "Poison Apple",
    "Moon Bloom", "Dragon's Breath", "Ghost Pepper", "Poison Ivy",
    "Baby Cactus", "Glow Mushroom", "Romanesco", "Horned Melon"
}

local SeedSellValues = {
    ["Mushroom"] = 13000, ["Moon Bloom"] = 9000, ["Lotus"] = 6500,
    ["Dragon's Breath"] = 3400, ["Venus Fly Trap"] = 3000, ["Ghost Pepper"] = 2500,
    ["Sunflower"] = 1750, ["Poison Ivy"] = 1700, ["Romanesco"] = 1500,
    ["Poison Apple"] = 900, ["Pomegranate"] = 900, ["Bamboo"] = 800,
    ["Glow Mushroom"] = 700, ["Cherry"] = 350, ["Acorn"] = 200,
    ["Horned Melon"] = 200, ["Dragon Fruit"] = 150, ["Mango"] = 90,
    ["Baby Cactus"] = 70, ["Coconut"] = 60, ["Tulip"] = 60,
    ["Grape"] = 45, ["Cactus"] = 40, ["Banana"] = 35, ["Corn"] = 34,
    ["Pineapple"] = 30, ["Apple"] = 12, ["Green Bean"] = 10, ["Tomato"] = 9,
    ["Carrot"] = 5, ["Blueberry"] = 5, ["Strawberry"] = 3,
}

local SeedValues = {
    ["Mushroom"] = 100, ["Moon Bloom"] = 99, ["Lotus"] = 98, ["Dragon's Breath"] = 97,
    ["Venus Fly Trap"] = 96, ["Ghost Pepper"] = 95, ["Sunflower"] = 93, ["Poison Ivy"] = 92,
    ["Poison Apple"] = 90, ["Pomegranate"] = 89, ["Venom Spitter"] = 88,
    ["Bamboo"] = 85, ["Glow Mushroom"] = 84, ["Cherry"] = 83, ["Acorn"] = 82,
    ["Horned Melon"] = 81, ["Dragon Fruit"] = 80, ["Mango"] = 79,
    ["Baby Cactus"] = 78, ["Coconut"] = 77, ["Tulip"] = 76, ["Grape"] = 75,
    ["Cactus"] = 74, ["Banana"] = 73, ["Corn"] = 72, ["Pineapple"] = 71,
    ["Apple"] = 70, ["Green Bean"] = 69, ["Tomato"] = 68, ["Carrot"] = 67,
    ["Blueberry"] = 66, ["Strawberry"] = 65,
}

local SeedGrowTimes = {
    ["Carrot"] = 4, ["Strawberry"] = 11, ["Blueberry"] = 3, ["Tulip"] = 8,
    ["Tomato"] = 12, ["Apple"] = 5, ["Bamboo"] = 14, ["Corn"] = 10,
    ["Cactus"] = 20, ["Pineapple"] = 25, ["Mushroom"] = 30, ["Green Bean"] = 15,
    ["Banana"] = 12, ["Grape"] = 18, ["Coconut"] = 12, ["Mango"] = 20,
    ["Dragon Fruit"] = 25, ["Acorn"] = 30, ["Cherry"] = 35, ["Sunflower"] = 40,
    ["Venus Fly Trap"] = 50, ["Pomegranate"] = 60, ["Poison Apple"] = 75,
    ["Moon Bloom"] = 8, ["Dragon's Breath"] = 10, ["Ghost Pepper"] = 90,
    ["Poison Ivy"] = 85, ["Baby Cactus"] = 15, ["Glow Mushroom"] = 20,
    ["Romanesco"] = 35, ["Horned Melon"] = 40,
}

local SeedBuyLimits = Config.SeedBuyLimits or {
    ["Carrot"] = 100, ["Strawberry"] = 100, ["Blueberry"] = 100, ["Tulip"] = 100,
    ["Tomato"] = 100, ["Apple"] = 100, ["Corn"] = 100, ["Cactus"] = 100,
    ["Pineapple"] = 100, ["Bamboo"] = 500, ["Mushroom"] = 500, ["Green Bean"] = 100,
    ["Banana"] = 100, ["Grape"] = 100, ["Coconut"] = 100, ["Mango"] = 100,
    ["Dragon Fruit"] = 100, ["Acorn"] = 100, ["Cherry"] = 100, ["Sunflower"] = 100,
    ["Venus Fly Trap"] = 100, ["Pomegranate"] = 100, ["Poison Apple"] = 100,
    ["Venom Spitter"] = 100, ["Moon Bloom"] = 50000, ["Dragon's Breath"] = 50000,
    ["Ghost Pepper"] = 50000, ["Poison Ivy"] = 50000, ["Baby Cactus"] = 50000,
    ["Glow Mushroom"] = 50000, ["Romanesco"] = 50000, ["Horned Melon"] = 50000,
}

local SeedPlantLimits = {
    ["Carrot"] = 50, ["Strawberry"] = 50, ["Blueberry"] = 50, ["Tulip"] = 50,
    ["Tomato"] = 50, ["Apple"] = 50, ["Corn"] = 50, ["Cactus"] = 50,
    ["Pineapple"] = 50, ["Bamboo"] = 20, ["Mushroom"] = 20, ["Green Bean"] = 20,
    ["Banana"] = 20, ["Grape"] = 20, ["Coconut"] = 20, ["Mango"] = 20,
    ["Dragon Fruit"] = 20, ["Acorn"] = 20, ["Cherry"] = 20, ["Sunflower"] = 20,
    ["Venus Fly Trap"] = 10, ["Pomegranate"] = 10, ["Poison Apple"] = 10,
    ["Venom Spitter"] = 10, ["Moon Bloom"] = 10, ["Dragon's Breath"] = 10,
}

local SpecialSeeds = {
    "Rainbow Strawberry", "Rainbow Blueberry", "Rainbow Apple", "Rainbow Corn",
    "Rainbow Grape", "Rainbow Pineapple", "Rainbow Banana", "Rainbow Melon",
    "Rainbow Dragon Fruit", "Rainbow Mango", "Rainbow Lotus", "Rainbow Moon Bloom",
    "Rainbow Bamboo", "Rainbow Tulip", "Rainbow Sunflower", "Rainbow Rose",
    "Rainbow Cactus", "Rainbow Cacao", "Rainbow Horned Melon",
    "Gold Strawberry", "Gold Blueberry", "Gold Apple", "Gold Corn",
    "Gold Grape", "Gold Pineapple", "Gold Banana", "Gold Melon",
    "Gold Dragon Fruit", "Gold Mango", "Gold Lotus", "Gold Moon Bloom",
    "Gold Bamboo", "Gold Tulip", "Gold Sunflower", "Gold Rose",
    "Gold Cactus", "Gold Cacao", "Gold Horned Melon",
    "Rainbow Egg", "Gold Egg", "Golden Egg", "Rainbow Seed", "Gold Seed",
    "Shiny Strawberry", "Shiny Blueberry", "Shiny Apple",
    "Event Seed", "Special Rainbow", "Special Gold",
}

local GearList = {
    "Common Sprinkler", "Sign", "Lantern",
    "Wheelbarrow", "Uncommon Sprinkler", "Rare Sprinkler", "Legendary Sprinkler",
    "Super Sprinkler", "Trowel", "Speed Mushroom", "Jump Mushroom",
    "Gnome", "Shrink Mushroom", "Supersize Mushroom", "Invisibility Mushroom",
    "Teleporter", "Basic Pot", "Flashbang"
}

local PetData = {
    Frog = {price = 10000, rarity = "Common"},
    Bunny = {price = 20000, rarity = "Common"},
    Owl = {price = 25000, rarity = "Uncommon"},
    Deer = {price = 50000, rarity = "Rare"},
    Robin = {price = 75000, rarity = "Legendary"},
    Bee = {price = 1000000, rarity = "Legendary"},
    Bear = {price = 5000000, rarity = "Mythic"},
    BlackDragon = {price = 1000000, rarity = "Super"},
    Monkey = {price = 3000000, rarity = "Mythic"},
    GoldenDragonfly = {price = 9000000, rarity = "Mythic"},
    Unicorn = {price = 12000000, rarity = "Mythic"},
    Raccoon = {price = 15000000, rarity = "Super"},
}

local RARITY_PRIORITY = {
    Common = 1, Uncommon = 2, Rare = 3,
    Super = 4, Legendary = 5, Mythic = 6,
}

local GLOBAL_MAX_PLANTS = 800
local PlantedSeedsCount = {}
local BoughtSeedsCount = {}

-- Performance constants
local PICKUP_RANGE = 50
local PICKUP_LOOP_DELAY = 0.3

-- Weather state
local WeatherState = {
    RainbowMoon = false,
    MidasMoon = false,
}

-- ============================================
-- OPTIMIZATION FEATURES (Always Enabled in Core)
-- ============================================

-- BlackScreen: Creates a black screen to optimize multi-account performance
local BlackScreenGui = nil
local BlackScreenEnabled = true

local function CreateBlackScreen()
    if BlackScreenGui then return end
    
    BlackScreenGui = Instance.new("ScreenGui")
    BlackScreenGui.Name = "GrowGarden2_BlackScreen"
    BlackScreenGui.DisplayOrder = 999
    BlackScreenGui.IgnoreGuiInset = true
    BlackScreenGui.ResetOnSpawn = false
    BlackScreenGui.Parent = PlayerGui
    
    local BlackFrame = Instance.new("Frame")
    BlackFrame.Name = "BlackOverlay"
    BlackFrame.Size = UDim2.new(1, 0, 1, 0)
    BlackFrame.Position = UDim2.new(0, 0, 0, 0)
    BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlackFrame.BackgroundTransparency = 0
    BlackFrame.BorderSizePixel = 0
    BlackFrame.Parent = BlackScreenGui
    
    print("[GrowGarden2] BlackScreen activated - CPU/GPU load reduced")
end

local function CreateBlackScreenStatus()
    if not BlackScreenGui then return end
    
    local statusFrame = BlackScreenGui:FindFirstChild("StatusOverlay")
    if statusFrame then return end
    
    statusFrame = Instance.new("Frame")
    statusFrame.Name = "StatusOverlay"
    statusFrame.Size = UDim2.new(0, 400, 0, 200)
    statusFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    statusFrame.BackgroundTransparency = 0.3
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = BlackScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = statusFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 80)
    stroke.Thickness = 1
    stroke.Parent = statusFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🌱 GrowGarden2 AutoFarm"
    title.TextColor3 = Color3.fromRGB(72, 195, 115)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -20, 0, 25)
    statusText.Position = UDim2.new(0, 10, 0, 45)
    statusText.BackgroundTransparency = 1
    statusText.Text = "⏳ Initializing..."
    statusText.TextColor3 = Color3.fromRGB(255, 200, 75)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = statusFrame
    
    local shecklesText = Instance.new("TextLabel")
    shecklesText.Name = "ShecklesText"
    shecklesText.Size = UDim2.new(1, -20, 0, 20)
    shecklesText.Position = UDim2.new(0, 10, 0, 72)
    shecklesText.BackgroundTransparency = 1
    shecklesText.Text = "💰 Sheckles: Loading..."
    shecklesText.TextColor3 = Color3.fromRGB(255, 215, 0)
    shecklesText.TextSize = 13
    shecklesText.Font = Enum.Font.Gotham
    shecklesText.TextXAlignment = Enum.TextXAlignment.Left
    shecklesText.Parent = statusFrame
    
    local farmingText = Instance.new("TextLabel")
    farmingText.Name = "FarmingText"
    farmingText.Size = UDim2.new(1, -20, 0, 20)
    farmingText.Position = UDim2.new(0, 10, 0, 94)
    farmingText.BackgroundTransparency = 1
    farmingText.Text = "🌾 Farming: Active"
    farmingText.TextColor3 = Color3.fromRGB(140, 140, 160)
    farmingText.TextSize = 13
    farmingText.Font = Enum.Font.Gotham
    farmingText.TextXAlignment = Enum.TextXAlignment.Left
    farmingText.Parent = statusFrame
    
    local petText = Instance.new("TextLabel")
    petText.Name = "PetText"
    petText.Size = UDim2.new(1, -20, 0, 20)
    petText.Position = UDim2.new(0, 10, 0, 116)
    petText.BackgroundTransparency = 1
    petText.Text = "🐾 Best Pet: None"
    petText.TextColor3 = Color3.fromRGB(200, 150, 255)
    petText.TextSize = 13
    petText.Font = Enum.Font.Gotham
    petText.TextXAlignment = Enum.TextXAlignment.Left
    petText.Parent = statusFrame
    
    local seedText = Instance.new("TextLabel")
    seedText.Name = "SeedText"
    seedText.Size = UDim2.new(1, -20, 0, 20)
    seedText.Position = UDim2.new(0, 10, 0, 138)
    seedText.BackgroundTransparency = 1
    seedText.Text = "✨ Best Seed: None"
    seedText.TextColor3 = Color3.fromRGB(255, 180, 220)
    seedText.TextSize = 13
    seedText.Font = Enum.Font.Gotham
    seedText.TextXAlignment = Enum.TextXAlignment.Left
    seedText.Parent = statusFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, -20, 0, 20)
    infoText.Position = UDim2.new(0, 10, 0, 160)
    infoText.BackgroundTransparency = 1
    infoText.Text = "👤 User: " .. Player.Name
    infoText.TextColor3 = Color3.fromRGB(100, 100, 120)
    infoText.TextSize = 12
    infoText.Font = Enum.Font.Gotham
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.Parent = statusFrame
    
    -- Initialize with loading state
    UpdateBlackScreenStatus()
end

local function UpdateBlackScreenStatus()
    if not BlackScreenGui then return end
    
    local statusFrame = BlackScreenGui:FindFirstChild("StatusOverlay")
    if not statusFrame then
        CreateBlackScreenStatus()
        statusFrame = BlackScreenGui:FindFirstChild("StatusOverlay")
    end
    if not statusFrame then return end
    
    local sheckles = GetData("Sheckles")
    local formattedSheckles = FormatSheckles(sheckles)
    
    -- Get best pet (Mythic/Super)
    local bestPet = "None"
    local bestPetRarity = 0
    pcall(function()
        local petRarityOrder = {Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythic = 6, Super = 7}
        
        -- Check Pets folder
        local petsFolder = Player:FindFirstChild("Pets")
        if petsFolder then
            for _, pet in pairs(petsFolder:GetChildren()) do
                local rarity = pet:GetAttribute("Rarity") or "Common"
                local rarityLevel = petRarityOrder[rarity] or 0
                if rarityLevel > bestPetRarity then
                    bestPetRarity = rarityLevel
                    bestPet = rarity .. " " .. pet.Name
                end
            end
        end
        
        -- Check backpack tools
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local rarity = item:GetAttribute("Rarity") or "Common"
                    local rarityLevel = petRarityOrder[rarity] or 0
                    if rarityLevel > bestPetRarity then
                        bestPetRarity = rarityLevel
                        bestPet = rarity .. " " .. item.Name
                    end
                end
            end
        end
        
        -- Check character tools
        local character = Player.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") then
                    local rarity = item:GetAttribute("Rarity") or "Common"
                    local rarityLevel = petRarityOrder[rarity] or 0
                    if rarityLevel > bestPetRarity then
                        bestPetRarity = rarityLevel
                        bestPet = rarity .. " " .. item.Name
                    end
                end
            end
        end
    end)
    
    -- Get best seed (Super/Mythic tier)
    local bestSeed = "None"
    local bestSeedValue = 0
    pcall(function()
        local seedValues = {
            ["Moon Bloom"] = 99, ["Dragon's Breath"] = 97, ["Venus Fly Trap"] = 96,
            ["Ghost Pepper"] = 95, ["Sunflower"] = 93, ["Poison Ivy"] = 92,
            ["Poison Apple"] = 90, ["Pomegranate"] = 89, ["Venom Spitter"] = 88,
            ["Bamboo"] = 85, ["Glow Mushroom"] = 84, ["Cherry"] = 83,
            ["Acorn"] = 82, ["Horned Melon"] = 81, ["Dragon Fruit"] = 80
        }
        
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local seedName = item.Name
                    local value = seedValues[seedName] or 0
                    if value > bestSeedValue and value > 0 then
                        bestSeedValue = value
                        bestSeed = seedName
                    end
                end
            end
        end
        
        local character = Player.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") then
                    local seedName = item.Name
                    local value = seedValues[seedName] or 0
                    if value > bestSeedValue and value > 0 then
                        bestSeedValue = value
                        bestSeed = seedName
                    end
                end
            end
        end
    end)
    
    local statusText = statusFrame:FindFirstChild("StatusText")
    local shecklesText = statusFrame:FindFirstChild("ShecklesText")
    local farmingText = statusFrame:FindFirstChild("FarmingText")
    local petText = statusFrame:FindFirstChild("PetText")
    local seedText = statusFrame:FindFirstChild("SeedText")
    
    if statusText then
        statusText.Text = "🎮 Farming Active"
    end
    
    if shecklesText then
        shecklesText.Text = "💰 Sheckles: " .. formattedSheckles
    end
    
    if farmingText then
        farmingText.Text = "🌾 Status: Auto-Farming"
    end
    
    if petText then
        petText.Text = "🐾 Best Pet: " .. bestPet
    end
    
    if seedText then
        seedText.Text = "✨ Best Seed: " .. bestSeed
    end
end

local function StartBlackScreenUpdater()
    task.spawn(function()
        while BlackScreenEnabled do
            UpdateBlackScreenStatus()
            task.wait(1)
        end
    end)
end

local function DisableRobloxRendering()
    pcall(function()
        -- Disable particles
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Beam") then
                v.Enabled = false
            end
        end
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        
        -- Reduce quality
        if settings and settings().Rendering then
            settings().Rendering.QualityLevel = Enum.SavedQualitySetting.Level01
        end
    end)
    print("[GrowGarden2] Roblox rendering disabled - performance optimized")
end

-- AutoSkipLoading: Automatically skips loading screens
local AutoSkipEnabled = true

local function StartAutoSkipLoading()
    task.spawn(function()
        while AutoSkipEnabled do
            pcall(function()
                -- Check for loading screens
                local loadingGui = PlayerGui:FindFirstChild("LoadingGui")
                if loadingGui then
                    for _, child in pairs(loadingGui:GetDescendants()) do
                        if child:IsA("ImageButton") or child:IsA("TextButton") then
                            local buttonText = child.Text:lower()
                            if buttonText:find("skip") or buttonText:find("continue") or buttonText:find("play") then
                                if child:IsA("ImageButton") then
                                    firesignal(child.Activated)
                                else
                                    child:Click()
                                end
                                print("[GrowGarden2] Loading screen skipped")
                            end
                        end
                    end
                end
                
                -- Try clicking anywhere to skip
                local skipGui = PlayerGui:FindFirstChildWhichIsA("ScreenGui")
                if skipGui then
                    for _, gui in pairs(PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") then
                            local txt = gui.Text:lower()
                            if txt:find("skip") or txt:find("start") or txt:find("play") then
                                gui:Click()
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- AntiAfk: Prevents disconnection from being idle
local AntiAfkEnabled = true

local function StartAntiAfk()
    task.spawn(function()
        while AntiAfkEnabled do
            pcall(function()
                -- Simulate virtual input to prevent AFK
                if VirtualInputManager then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                else
                    -- Alternative: move mouse slightly
                    local mouse = Player:GetMouse()
                    local oldX, oldY = mouse.X, mouse.Y
                    VirtualInputManager:SendMouseMoveEvent(oldX + 1, oldY + 1, true, game)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseMoveEvent(oldX, oldY, true, game)
                end
            end)
            task.wait(120) -- Every 2 minutes
        end
    end)
    print("[GrowGarden2] AntiAfk activated - will prevent disconnections")
end

-- ============================================
-- UI CREATION
-- ============================================
local ScreenGui, StatusLabel, FeaturesLabel

local function CreateUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GrowGarden2_AutoFarm"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 400)
    Frame.Position = UDim2.new(0.01, 0, 0.25, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    Frame.BackgroundTransparency = 0.05
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(55, 55, 80)
    Stroke.Thickness = 1
    Stroke.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "🌱 GrowGarden2 AutoFarm"
    Title.TextColor3 = Color3.fromRGB(72, 195, 115)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(1, 0, 0, 20)
    Version.Position = UDim2.new(0, 0, 0, 40)
    Version.BackgroundTransparency = 1
    Version.Text = "v2.0 | All Features Auto-Enabled"
    Version.TextColor3 = Color3.fromRGB(100, 100, 120)
    Version.TextSize = 11
    Version.Font = Enum.Font.Gotham
    Version.Parent = Frame
    
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 25)
    StatusLabel.Position = UDim2.new(0, 10, 0, 60)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⏳ Initializing..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 75)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame
    
    FeaturesLabel = Instance.new("TextLabel")
    FeaturesLabel.Size = UDim2.new(1, -20, 1, -80)
    FeaturesLabel.Position = UDim2.new(0, 10, 0, 90)
    FeaturesLabel.BackgroundTransparency = 1
    FeaturesLabel.Text = "⏳ Loading features..."
    FeaturesLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
    FeaturesLabel.TextSize = 11
    FeaturesLabel.Font = Enum.Font.Gotham
    FeaturesLabel.TextXAlignment = Enum.TextXAlignment.Left
    FeaturesLabel.TextYAlignment = Enum.TextYAlignment.Top
    FeaturesLabel.Parent = Frame
    
    print("[GrowGarden2] UI Created")
end

local function SetStatus(text)
    if StatusLabel then StatusLabel.Text = text end
    print("[Status] " .. text)
end

local function SetFeatures(text)
    if FeaturesLabel then FeaturesLabel.Text = text end
end

-- ============================================
-- PERFORMANCE SETTINGS
-- ============================================
local function ApplyPerformanceSettings()
    setfpscap(AutoSettings.FPSCap or 60)
    
    if AutoSettings.LowEffect then
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
        end)
    end
end

-- ============================================
-- NETWORKING (EXACT FROM ULTIMATE GUI)
-- ============================================
local NetworkingCache = nil

local function GetNetworking()
    if NetworkingCache then return NetworkingCache end
    
    local success, net = pcall(function()
        local sm = ReplicatedStorage:WaitForChild("SharedModules", 15)
        if not sm then return nil end
        return require(sm:WaitForChild("Networking", 15))
    end)
    
    if success and net then
        NetworkingCache = net
        print("[GrowGarden2] Networking loaded!")
    end
    
    return success and net or nil
end

local function GetNetworkingEvents()
    if NetworkingCache then return NetworkingCache end
    return GetNetworking()
end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function GetData(dataType)
    local success, result = pcall(function()
        if dataType == "Sheckles" then
            if Player:FindFirstChild("leaderstats") then
                local sheckles = Player.leaderstats:FindFirstChild("Sheckles")
                return sheckles and sheckles.Value or 0
            end
            return 0
        elseif dataType == "AllFruits" then
            local gardens = workspace:FindFirstChild("Gardens")
            if not gardens then return {} end
            
            local allFruits = {}
            for _, plot in pairs(gardens:GetChildren()) do
                if plot:IsA("Model") then
                    local plantsFolder = plot:FindFirstChild("Plants")
                    if plantsFolder then
                        for _, plant in pairs(plantsFolder:GetChildren()) do
                            local seedName = plant:GetAttribute("SeedName")
                            local fruits = plant:FindFirstChild("Fruits")
                            
                            if fruits then
                                for _, fruit in pairs(fruits:GetChildren()) do
                                    local sizeMulti = fruit:GetAttribute("SizeMulti") or 1
                                    local fruitValue = SeedSellValues[seedName] or 10
                                    local actualValue = math.floor(fruitValue * sizeMulti)
                                    local fruitId = fruit:GetAttribute("FruitId") or fruit.Name
                                    
                                    table.insert(allFruits, {
                                        Model = fruit,
                                        Plant = plant,
                                        FruitId = fruitId,
                                        SeedName = seedName,
                                        SizeMulti = sizeMulti,
                                        BaseValue = fruitValue,
                                        ActualValue = actualValue,
                                        HasFruitsFolder = true
                                    })
                                end
                            else
                                local harvestPart = plant:FindFirstChild("HarvestPart")
                                if harvestPart then
                                    table.insert(allFruits, {
                                        Model = plant,
                                        Plant = plant,
                                        SeedName = seedName,
                                        SizeMulti = plant:GetAttribute("SizeMulti") or 1,
                                        BaseValue = SeedSellValues[seedName] or 10,
                                        ActualValue = 0,
                                        HasFruitsFolder = false
                                    })
                                end
                            end
                        end
                    end
                end
            end
            
            -- Calculate weights
            local maxSize = 0
            for _, fruit in ipairs(allFruits) do
                if fruit.SizeMulti > maxSize then maxSize = fruit.SizeMulti end
            end
            
            for _, fruit in ipairs(allFruits) do
                fruit.Weight = maxSize > 0 and math.floor((fruit.SizeMulti / maxSize) * 512) or 0
            end
            
            table.sort(allFruits, function(a, b) return (a.Weight or 0) > (b.Weight or 0) end)
            return allFruits
        end
        return 0
    end)
    return success and result or (dataType == "AllFruits" and {} or 0)
end

local function GetSeedStock(seedName)
    local success, result = pcall(function()
        local StockValues = ReplicatedStorage:WaitForChild("StockValues", 5)
        if not StockValues then return nil end
        local SeedShop = StockValues:WaitForChild("SeedShop", 5)
        if not SeedShop then return nil end
        local Items = SeedShop:WaitForChild("Items", 5)
        if not Items then return nil end
        local seedItem = Items:FindFirstChild(seedName)
        if seedItem and seedItem:IsA("IntValue") then
            return seedItem.Value
        end
        return nil
    end)
    return success and result
end

local function GetAllSeedStock()
    local stockInfo = {}
    pcall(function()
        local StockValues = ReplicatedStorage:WaitForChild("StockValues", 5)
        if not StockValues then return end
        local SeedShop = StockValues:WaitForChild("SeedShop", 5)
        if not SeedShop then return end
        local Items = SeedShop:WaitForChild("Items", 5)
        if not Items then return end
        
        for _, item in pairs(Items:GetChildren()) do
            if item:IsA("IntValue") then
                stockInfo[item.Name] = item.Value
            end
        end
    end)
    return stockInfo
end

local function GetInventoryItems()
    local items = {}
    pcall(function()
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    items[item.Name] = (items[item.Name] or 0) + 1
                end
            end
        end
        local character = Player.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") then
                    items[item.Name] = (items[item.Name] or 0) + 1
                end
            end
        end
    end)
    return items
end

local function CountSeedsInBackpack(seedName)
    local backpack = Player:FindFirstChild("Backpack")
    if not backpack then return 0 end
    
    local count = 0
    for _, item in pairs(backpack:GetChildren()) do
        if item.Name == seedName and item:IsA("Tool") then
            count = count + 1
        end
    end
    return count
end

local function CountPlantedSeeds(seedName)
    local count = 0
    local gardens = workspace:FindFirstChild("Gardens")
    if not gardens then return 0 end
    
    for _, plot in pairs(gardens:GetChildren()) do
        if plot:IsA("Model") then
            local plants = plot:FindFirstChild("Plants")
            if plants then
                for _, plant in pairs(plants:GetChildren()) do
                    local plantSeedName = plant:GetAttribute("SeedName")
                    if plantSeedName == seedName then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

local function GetGardenPosition()
    local gardens = workspace:FindFirstChild("Gardens")
    if not gardens then return nil end
    
    local playerId = Player.UserId
    
    for _, plot in pairs(gardens:GetChildren()) do
        if plot:IsA("Model") then
            local ownerId = plot:GetAttribute("OwnerId")
            if ownerId == playerId then
                local visual = plot:FindFirstChild("Visual")
                local area = visual and visual:FindFirstChild("GardenTotalArea")
                if area and area:IsA("BasePart") then
                    return area.Position
                end
            end
        end
    end
    
    return nil
end

local function TeleportTo(pos)
    local character = Player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end
end

local function FormatSheckles(amount)
    if amount >= 1000000 then
        return string.format("%.1fM", amount / 1000000)
    elseif amount >= 1000 then
        return string.format("%.1fK", amount / 1000)
    else
        return tostring(amount)
    end
end

-- ============================================
-- WEATHER DETECTION
-- ============================================
local function SetupWeatherDetection()
    local weatherValues = ReplicatedStorage:FindFirstChild("WeatherValues")
    if not weatherValues then return end
    
    local rainbow = weatherValues:FindFirstChild("Rainbow")
    if rainbow then
        local playing = rainbow:FindFirstChild("Playing")
        if playing and playing:IsA("BoolValue") then
            WeatherState.RainbowMoon = playing.Value
            playing.Changed:Connect(function(newValue)
                WeatherState.RainbowMoon = newValue
            end)
        end
    end
    
    local midas = weatherValues:FindFirstChild("Midas")
    if midas then
        local playing = midas:FindFirstChild("Playing")
        if playing and playing:IsA("BoolValue") then
            WeatherState.MidasMoon = playing.Value
            playing.Changed:Connect(function(newValue)
                WeatherState.MidasMoon = newValue
            end)
        end
    end
end

local function IsRainbowMoonActive()
    return WeatherState.RainbowMoon
end

local function IsMidasMoonActive()
    return WeatherState.MidasMoon
end

-- ============================================
-- DISCORD NOTIFICATIONS
-- ============================================
local function SendDiscordNotification(type, data)
    if not AutoSettings.DiscordWebhook or AutoSettings.DiscordWebhook == "" then return end
    
    local content = ""
    if type == "pet" and AutoSettings.DiscordNotifications.Pets then
        content = "🐾 **Rare Pet!** " .. (data.petName or "Unknown") .. " [" .. (data.rarity or "Unknown") .. "]\n💰 Price: " .. FormatSheckles(data.price or 0)
    elseif type == "rainbow" and AutoSettings.DiscordNotifications.RainbowSeeds then
        content = "🌈 **Rainbow Seed!** " .. (data.seedName or "Unknown")
    elseif type == "gold" and AutoSettings.DiscordNotifications.GoldSeeds then
        content = "💛 **Gold Seed!** " .. (data.seedName or "Unknown")
    end
    
    if content ~= "" then
        pcall(function()
            HttpService:PostAsync(AutoSettings.DiscordWebhook, HttpService:JSONEncode({content = content}))
        end)
    end
end

-- ============================================
-- CORE ACTIONS (FROM ULTIMATE GUI)
-- ============================================

local function SellAllItems()
    local net = GetNetworkingEvents()
    if net and net.NPCS and net.NPCS.SellAll then
        net.NPCS.SellAll:Fire()
        return true
    end
    
    pcall(function()
        local npcs = workspace:FindFirstChild("NPCS")
        if npcs then
            for _, npc in pairs(npcs:GetChildren()) do
                if npc:IsA("Model") then
                    local npcHrp = npc:FindFirstChild("HumanoidRootPart")
                    if npcHrp then
                        TeleportTo(npcHrp.Position)
                        task.wait(0.1)
                        for _, child in pairs(npcHrp:GetChildren()) do
                            if child:IsA("ProximityPrompt") then
                                fireproximityprompt(child)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return false
end

local function HarvestPlant(plant, fruitId)
    if not plant then return false end
    
    local harvestSuccess = false
    
    local function tryFirePrompts(target)
        if not target then return false end
        for _, child in pairs(target:GetChildren()) do
            if child:IsA("ProximityPrompt") then
                fireproximityprompt(child)
                return true
            end
        end
        for _, child in pairs(target:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                fireproximityprompt(child)
                return true
            end
        end
        return false
    end
    
    if tryFirePrompts(plant) then
        harvestSuccess = true
    end
    
    if plant.Parent and plant.Parent:IsA("Model") then
        if tryFirePrompts(plant.Parent) then
            harvestSuccess = true
        end
    end
    
    local plantUUID = plant:GetAttribute("PlantId")
    if not plantUUID and plant.Parent then
        plantUUID = plant.Parent:GetAttribute("PlantId")
    end
    
    if plantUUID then
        local net = GetNetworkingEvents()
        if net and net.Garden and net.Garden.CollectFruit then
            net.Garden.CollectFruit:Fire(plantUUID, fruitId or "")
            harvestSuccess = true
        end
    end
    
    return harvestSuccess
end

local function IsSpecialSeed(seedName)
    if not seedName then return false end
    local lowerName = seedName:lower()
    for _, special in ipairs(SpecialSeeds) do
        if lowerName:find(special:lower()) then
            return true
        end
    end
    return false
end

local function GetSpecialReadyFruits()
    local specialFruits = {}
    local gardens = workspace:FindFirstChild("Gardens")
    if not gardens then return specialFruits end
    
    local playerId = Player.UserId
    
    for _, plot in pairs(gardens:GetChildren()) do
        if plot:IsA("Model") then
            local ownerId = plot:GetAttribute("OwnerId")
            if ownerId == playerId then
                local plants = plot:FindFirstChild("Plants")
                if plants then
                    for _, plant in pairs(plants:GetChildren()) do
                        local seedName = plant:GetAttribute("SeedName")
                        if seedName and IsSpecialSeed(seedName) then
                            local stage = plant:GetAttribute("Stage") or 0
                            local age = plant:GetAttribute("Age") or 0
                            local maxAge = plant:GetAttribute("MaxAge") or age + 1
                            local isReady = age >= maxAge or stage >= 3
                            
                            table.insert(specialFruits, {
                                Model = plant,
                                Plant = plant,
                                SeedName = seedName,
                                Stage = stage,
                                Age = age,
                                IsReady = isReady
                            })
                        end
                    end
                end
            end
        end
    end
    
    return specialFruits
end

local function BuySeed(seedName)
    local success, err = pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.SeedShop and Networking.SeedShop.PurchaseSeed then
            local purchaseSeed = Networking.SeedShop.PurchaseSeed
            local mt = getmetatable(purchaseSeed)
            if mt and mt.Fire then
                mt.Fire(purchaseSeed, seedName)
                return true
            end
        end
    end)
    return success and err == true
end

local function PlantSeed(seedName)
    local success = pcall(function()
        if CountSeedsInBackpack(seedName) == 0 then
            return false
        end
        
        local gardens = workspace:FindFirstChild("Gardens")
        if not gardens then return false end
        
        local totalPlants = 0
        for _, plot in pairs(gardens:GetChildren()) do
            if plot:IsA("Model") then
                local plants = plot:FindFirstChild("Plants")
                if plants then
                    totalPlants = totalPlants + #plants:GetChildren()
                end
            end
        end
        if totalPlants >= GLOBAL_MAX_PLANTS then
            return false
        end
        
        local myPlot = gardens:FindFirstChild("Plot1") or gardens:GetChildren()[1]
        if not myPlot then return false end
        
        local visual = myPlot:FindFirstChild("Visual")
        local gardenArea = visual and visual:FindFirstChild("GardenTotalArea")
        if not gardenArea or not gardenArea:IsA("BasePart") then
            return false
        end
        
        local gardenPos = gardenArea.Position
        local plantPos = gardenPos + Vector3.new(math.random(-5, 5), 0.5, math.random(-5, 5))
        
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        local plantSeed = Networking.Plant.PlantSeed
        local mt = getmetatable(plantSeed)
        
        if mt and mt.Fire then
            mt.Fire(plantSeed, plantPos, seedName)
            return true
        end
    end)
    return success
end

local function BuyGear(gearName)
    pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.GearShop and Networking.GearShop.PurchaseGear then
            local purchaseGear = Networking.GearShop.PurchaseGear
            local mt = getmetatable(purchaseGear)
            if mt and mt.Fire then
                mt.Fire(purchaseGear, gearName)
            end
        end
    end)
end

local function WaterPlants()
    pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.Garden and Networking.Garden.WaterPlant then
            local waterPlant = Networking.Garden.WaterPlant
            local mt = getmetatable(waterPlant)
            if mt and mt.Fire then
                mt.Fire(waterPlant, 0)
            end
        end
    end)
end

local function PlaceSprinkler(plot, sprinklerName)
    pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.Sprinkler and Networking.Sprinkler.PlaceSprinkler then
            local placeSprinkler = Networking.Sprinkler.PlaceSprinkler
            local mt = getmetatable(placeSprinkler)
            if mt and mt.Fire then
                mt.Fire(placeSprinkler, 0)
            end
        end
    end)
end

local function GetAvailableSprinkler(minRarity, maxRarity)
    local items = GetInventoryItems()
    local sprinklerRarity = {
        ["Common Sprinkler"] = 1,
        ["Uncommon Sprinkler"] = 2,
        ["Rare Sprinkler"] = 3,
        ["Legendary Sprinkler"] = 4,
        ["Super Sprinkler"] = 5,
    }
    
    for rarity = maxRarity, minRarity, -1 do
        for name, count in pairs(items) do
            if sprinklerRarity[name] == rarity and count > 0 then
                return name
            end
        end
    end
    return nil
end

local function CollectSpecialFruit(seedName)
    pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.Garden and Networking.Garden.CollectFruit then
            local collectFruit = Networking.Garden.CollectFruit
            local mt = getmetatable(collectFruit)
            if mt and mt.Fire then
                mt.Fire(collectFruit, seedName, "")
            end
        end
    end)
end

local function RedeemCode(code)
    pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.Codes and Networking.Codes.Redeem then
            local redeem = Networking.Codes.Redeem
            local mt = getmetatable(redeem)
            if mt and mt.Fire then
                mt.Fire(redeem, code)
            end
        end
    end)
end

local function SendMail(recipient, subject, body, items)
    pcall(function()
        local Networking = require(game.ReplicatedStorage.SharedModules.Networking)
        if Networking.Mail and Networking.Mail.SendMail then
            local sendMail = Networking.Mail.SendMail
            local mt = getmetatable(sendMail)
            if mt and mt.Fire then
                mt.Fire(sendMail, recipient, subject, body, items)
            end
        end
    end)
end

-- ============================================
-- PET SYSTEM
-- ============================================
local function ShouldAutoBuyRarity(rarity)
    local priority = RARITY_PRIORITY[rarity] or 0
    return priority >= 4
end

local function FindWildPets()
    local pets = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:match("WildPet") and obj:IsA("Model") then
            local petName = obj:GetAttribute("PetName")
            local mutation = obj:GetAttribute("Mutation") or "Normal"
            local variant = obj:GetAttribute("Variant") or "Normal"
            
            local rootPart = obj:FindFirstChild("RootPart")
            if rootPart then
                local prompt = rootPart:FindFirstChildWhichIsA("ProximityPrompt")
                
                if rootPart:IsDescendantOf(workspace) then
                    table.insert(pets, {
                        Model = obj,
                        RootPart = rootPart,
                        PetName = petName or "Unknown",
                        Mutation = mutation,
                        Variant = variant,
                        Prompt = prompt,
                        Position = rootPart.Position
                    })
                end
            end
        end
    end
    
    return pets
end

local function BuyWildPet(pet)
    if pet.Prompt and fireproximityprompt then
        fireproximityprompt(pet.Prompt)
        return true
    end
    return false
end

-- ============================================
-- SEED HELPERS
-- ============================================
local function CanBuyMore(seedName)
    local buyLimit = SeedBuyLimits[seedName] or 9999
    local currentBought = BoughtSeedsCount[seedName] or 0
    return currentBought < buyLimit
end

local function CanPlantMore(seedName)
    local plantLimit = SeedPlantLimits[seedName] or 999
    local currentPlanted = PlantedSeedsCount[seedName] or 0
    return currentPlanted < plantLimit
end

local function GetBestAvailableSeed(mode)
    local bestSeed = nil
    local bestValue = -1
    
    for _, seedName in ipairs(SeedList) do
        if SeedSelection[seedName] ~= false then
            local seedsInBackpack = CountSeedsInBackpack(seedName)
            if seedsInBackpack > 0 and CanPlantMore(seedName) then
                local value = SeedValues[seedName] or 0
                if value > bestValue then
                    bestValue = value
                    bestSeed = seedName
                end
            end
        end
    end
    
    return bestSeed
end

local function GetBestSeedToBuy(mode)
    local bestSeed = nil
    local bestValue = -1
    
    for _, seedName in ipairs(SeedList) do
        if SeedSelection[seedName] ~= false then
            if CanBuyMore(seedName) then
                local stock = GetSeedStock(seedName)
                if stock == nil or stock > 0 then
                    local value = SeedValues[seedName] or 0
                    if value > bestValue then
                        bestValue = value
                        bestSeed = seedName
                    end
                end
            end
        end
    end
    
    return bestSeed
end

local function GetSeedsToBuy()
    local seedsToBuy = {}
    
    for _, seedName in ipairs(SeedList) do
        if SeedSelection[seedName] ~= false and CanBuyMore(seedName) then
            local stock = GetSeedStock(seedName)
            if stock == nil or stock > 0 then
                table.insert(seedsToBuy, {
                    seed = seedName,
                    value = SeedValues[seedName] or 0
                })
            end
        end
    end
    
    table.sort(seedsToBuy, function(a, b) return a.value > b.value end)
    return seedsToBuy
end

local function GetGearsToBuy()
    local gearsToBuy = {}
    
    for _, gearName in ipairs(GearList) do
        if GearSelection[gearName] ~= false then
            table.insert(gearsToBuy, gearName)
        end
    end
    
    return gearsToBuy
end

-- ============================================
-- AUTO FEATURES
-- ============================================

local function StartAutoHarvest()
    print("[AutoHarvest] Started")
    task.spawn(function()
        while AutoSettings.AutoHarvest do
            pcall(function()
                local fruits = GetData("AllFruits")
                local harvested = 0
                
                for _, fruit in ipairs(fruits) do
                    if not AutoSettings.AutoHarvest then break end
                    
                    local interactModel = fruit.Model
                    if interactModel and interactModel:IsDescendantOf(workspace) then
                        if HarvestPlant(interactModel, fruit.FruitId or "") then
                            harvested = harvested + 1
                        end
                    end
                    task.wait(0.01)
                end
                
                if harvested > 0 then
                    SetStatus("🌾 Harvested " .. harvested .. " fruits")
                end
            end)
            
            task.wait(AutoSettings.HarvestDelay)
        end
    end)
end

local function StartAutoSell()
    print("[AutoSell] Started")
    task.spawn(function()
        while AutoSettings.AutoSell do
            SellAllItems()
            task.wait(AutoSettings.SellDelay)
        end
    end)
end

local function StartAutoBuySeeds()
    print("[AutoBuySeeds] Started")
    task.spawn(function()
        while AutoSettings.AutoBuySeeds do
            pcall(function()
                local sheckles = GetData("Sheckles")
                if sheckles >= 10 then
                    local seedsToBuy = GetSeedsToBuy()
                    
                    for _, data in ipairs(seedsToBuy) do
                        if not AutoSettings.AutoBuySeeds then break end
                        
                        if BuySeed(data.seed) then
                            BoughtSeedsCount[data.seed] = (BoughtSeedsCount[data.seed] or 0) + 1
                        end
                        task.wait(AutoSettings.BuyDelay)
                    end
                end
            end)
            
            task.wait(0.5)
        end
    end)
end

local function StartAutoBuyGears()
    print("[AutoBuyGears] Started")
    task.spawn(function()
        while AutoSettings.AutoBuyGears do
            pcall(function()
                local gearsToBuy = GetGearsToBuy()
                
                for _, gearName in ipairs(gearsToBuy) do
                    if not AutoSettings.AutoBuyGears then break end
                    BuyGear(gearName)
                end
            end)
            
            task.wait(2)
        end
    end)
end

local function StartAutoPlant()
    print("[AutoPlant] Started")
    task.spawn(function()
        for _, seedName in ipairs(SeedList) do
            if not PlantedSeedsCount[seedName] then
                PlantedSeedsCount[seedName] = CountPlantedSeeds(seedName)
            end
        end
        
        while AutoSettings.AutoPlant do
            pcall(function()
                local seedToPlant = GetBestAvailableSeed("efficiency")
                
                if not seedToPlant then
                    local bestSeed = GetBestSeedToBuy("efficiency")
                    if bestSeed then
                        BuySeed(bestSeed)
                        BoughtSeedsCount[bestSeed] = (BoughtSeedsCount[bestSeed] or 0) + 1
                    end
                    task.wait(0.3)
                    return
                end
                
                local seedsInBackpack = CountSeedsInBackpack(seedToPlant)
                
                if seedsInBackpack == 0 then
                    if CanBuyMore(seedToPlant) then
                        BuySeed(seedToPlant)
                        BoughtSeedsCount[seedToPlant] = (BoughtSeedsCount[seedToPlant] or 0) + 1
                    end
                    task.wait(0.2)
                    return
                end
                
                if PlantSeed(seedToPlant) then
                    PlantedSeedsCount[seedToPlant] = (PlantedSeedsCount[seedToPlant] or 0) + 1
                    
                    if AutoSettings.AutoWater then
                        WaterPlants()
                    end
                end
            end)
            
            task.wait(AutoSettings.PlantDelay)
        end
    end)
end

local function StartAutoWater()
    print("[AutoWater] Started")
    task.spawn(function()
        while AutoSettings.AutoWater do
            WaterPlants()
            task.wait(2)
        end
    end)
end

local function StartAutoPlaceSprinkler()
    print("[AutoPlaceSprinkler] Started")
    task.spawn(function()
        while AutoSettings.AutoPlaceSprinkler do
            pcall(function()
                local sprinkler = GetAvailableSprinkler(1, 5)
                if sprinkler then
                    PlaceSprinkler(nil, sprinkler)
                end
            end)
            task.wait(3)
        end
    end)
end

local function StartAutoHarvestSpecial()
    print("[AutoHarvestSpecial] Started")
    task.spawn(function()
        while AutoSettings.AutoHarvestSpecial do
            pcall(function()
                local specialFruits = GetSpecialReadyFruits()
                
                for _, fruit in ipairs(specialFruits) do
                    if not AutoSettings.AutoHarvestSpecial then break end
                    
                    local plant = fruit.Model
                    if plant and plant:IsDescendantOf(workspace) then
                        local plantUUID = plant:GetAttribute("PlantUUID")
                        local net = GetNetworkingEvents()
                        if net and net.Garden and net.Garden.CollectFruit then
                            net.Garden.CollectFruit:Fire(plantUUID or "", "")
                        end
                    end
                end
            end)
            
            task.wait(1)
        end
    end)
end

local function StartAutoPickupRainbow()
    print("[AutoPickupRainbow] Started")
    task.spawn(function()
        while AutoSettings.AutoPickupRainbow do
            task.wait(0.3)
            
            if IsRainbowMoonActive() then
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("rainbow") and obj:IsA("Tool") then
                            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and obj:FindFirstChild("Handle") then
                                hrp.CFrame = obj.Handle.CFrame
                                SendDiscordNotification("rainbow", {seedName = obj.Name})
                            end
                        end
                    end
                end)
            end
        end
    end)
end

local function StartAutoPickupGold()
    print("[AutoPickupGold] Started")
    task.spawn(function()
        while AutoSettings.AutoPickupGold do
            task.wait(0.3)
            
            if IsMidasMoonActive() then
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("gold") and obj:IsA("Tool") then
                            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and obj:FindFirstChild("Handle") then
                                hrp.CFrame = obj.Handle.CFrame
                                SendDiscordNotification("gold", {seedName = obj.Name})
                            end
                        end
                    end
                end)
            end
        end
    end)
end

local function StartAutoBuyPets()
    print("[AutoBuyPets] Started")
    task.spawn(function()
        while AutoSettings.AutoBuyPets do
            pcall(function()
                local pets = FindWildPets()
                
                if #pets == 0 then
                    task.wait(0.5)
                    return
                end
                
                local character = Player.Character
                if not character then
                    task.wait(PICKUP_LOOP_DELAY)
                    return
                end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then
                    task.wait(PICKUP_LOOP_DELAY)
                    return
                end
                
                table.sort(pets, function(a, b)
                    local petInfoA = PET_DATA[a.PetName] or {price = 0, rarity = "Unknown"}
                    local petInfoB = PET_DATA[b.PetName] or {price = 0, rarity = "Unknown"}
                    local priorityA = RARITY_PRIORITY[petInfoA.rarity] or 0
                    local priorityB = RARITY_PRIORITY[petInfoB.rarity] or 0
                    return priorityA > priorityB
                end)
                
                for _, pet in ipairs(pets) do
                    if not AutoSettings.AutoBuyPets then break end
                    
                    if pet.Model and pet.Model:IsDescendantOf(workspace) then
                        local petInfo = PET_DATA[pet.PetName] or {price = 0, rarity = "Unknown"}
                        local withinPrice = AutoSettings.AutoBuyPetsMaxPrice == 0 or petInfo.price <= AutoSettings.AutoBuyPetsMaxPrice
                        local rarityCheck = not AutoSettings.AutoBuyPetsRarityFilter or ShouldAutoBuyRarity(petInfo.rarity)
                        
                        if withinPrice and rarityCheck then
                            local distance = (hrp.Position - pet.Position).Magnitude
                            
                            if distance > PICKUP_RANGE then
                                TeleportTo(pet.Position + Vector3.new(0, 3, 0))
                                task.wait(0.03)
                            end
                            
                            if BuyWildPet(pet) then
                                SendDiscordNotification("pet", {
                                    petName = pet.PetName,
                                    rarity = petInfo.rarity,
                                    price = petInfo.price
                                })
                                SetStatus("🐾 " .. petInfo.rarity .. " " .. pet.PetName .. "!")
                            end
                        end
                    end
                end
            end)
            
            task.wait(PICKUP_LOOP_DELAY)
        end
    end)
end

local function StartAutoRedeemCode()
    print("[AutoRedeemCode] Started")
    task.spawn(function()
        local code = AutoSettings.RedeemCode or "TEAMGREENBEAN"
        task.wait(3)
        RedeemCode(code)
        print("[GrowGarden2] Code redeemed: " .. code)
    end)
end

local function StartAutoSendMail()
    print("[AutoSendMail] Started")
    -- Mail system can be extended based on requirements
end

-- ============================================
-- START ALL FEATURES
-- ============================================

local function StartAllFeatures()
    SetStatus("🚀 Starting All Features...")
    
    for _, seed in ipairs(SeedList) do
        if not BoughtSeedsCount[seed] then BoughtSeedsCount[seed] = 0 end
        if not PlantedSeedsCount[seed] then PlantedSeedsCount[seed] = 0 end
    end
    
    SetupWeatherDetection()
    
    -- Start optimization features
    if BlackScreenEnabled then
        CreateBlackScreen()
        DisableRobloxRendering()
        StartBlackScreenUpdater()
    end
    
    if AutoSkipEnabled then
        StartAutoSkipLoading()
    end
    
    if AntiAfkEnabled then
        StartAntiAfk()
    end
    
    if AutoSettings.AutoHarvest then StartAutoHarvest() end
    if AutoSettings.AutoSell then StartAutoSell() end
    if AutoSettings.AutoBuySeeds then StartAutoBuySeeds() end
    if AutoSettings.AutoBuyGears then StartAutoBuyGears() end
    if AutoSettings.AutoPlant then StartAutoPlant() end
    if AutoSettings.AutoWater then StartAutoWater() end
    if AutoSettings.AutoPlaceSprinkler then StartAutoPlaceSprinkler() end
    if AutoSettings.AutoHarvestSpecial then StartAutoHarvestSpecial() end
    if AutoSettings.AutoPickupRainbow then StartAutoPickupRainbow() end
    if AutoSettings.AutoPickupGold then StartAutoPickupGold() end
    if AutoSettings.AutoBuyPets then StartAutoBuyPets() end
    if AutoSettings.AutoRedeemCode then StartAutoRedeemCode() end
    if AutoSettings.AutoSendMail then StartAutoSendMail() end
    
    SetFeatures([[
🌾 AutoHarvest: ✅ ACTIVE
💵 AutoSell: ✅ ACTIVE
🛒 AutoBuySeeds: ✅ ACTIVE
⚙️ AutoBuyGears: ✅ ACTIVE
🌱 AutoPlant: ✅ ACTIVE
💧 AutoWater: ✅ ACTIVE
🚿 AutoSprinkler: ✅ ACTIVE
✨ AutoHarvestSpecial: ✅ ACTIVE
🌈 AutoPickupRainbow: ✅ ACTIVE
💛 AutoPickupGold: ✅ ACTIVE
🐾 AutoBuyPets: ✅ ACTIVE
📝 AutoRedeemCode: ✅ ACTIVE
🌑 BlackScreen: ✅ ACTIVE (Optimized)
⏭️ AutoSkipLoading: ✅ ACTIVE
🛡️ AntiAfk: ✅ ACTIVE (24/7 Protection)
🎮 ALL FEATURES ENABLED!
    ]])
    
    SetStatus("🎮 Auto Farm Running!")
    print("[GrowGarden2] 🎉 All features started!")
end

-- ============================================
-- MAIN INITIALIZATION
-- ============================================

CreateUI()
ApplyPerformanceSettings()
StartAllFeatures()
