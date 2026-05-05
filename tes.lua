-- ============================================
-- SAILOR PIECE - VELARIS UI (FULL FIXED)
-- SEMUA FITUR TETAP ADA, UI OBSIDIAN DIGANTI VELARIS
-- ============================================

if getgenv().celina_Running then
    warn("Script already running!")
    return
end

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0

function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})

local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');

local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService

local Marketplace = Services.MarketplaceService

local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser

local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)

local assetName = "sailor piece"

if v and Asset then
    assetName = Asset.Name
end

local Support = {
    Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard = (typeof(setclipboard) == "function"),
    FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
}

local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local isXeno = string.find(executorName, "xeno") ~= nil

local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false

for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end

-- LOAD OBSIDIAN LIBRARY (DIBUTUHKAN UNTUK FUNGSI INTERNAL)
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

getgenv().celina_Running = true

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = true
Library.ShowToggleFrameInKeybinds = true

local omg = {
    13820188365,
    13413231458,
    5638697306,
    16660143487,
    12669880433,
    121554255694758,
    14287111618,
    16119081646,
    15868464144,
    13699729039,
    10502160439,
    76020690430974,
    92696084646822,
}

local fire = {
    "https://i.ibb.co/1GrxgL38/avatar-736x736.jpg",
    "https://i.ibb.co/1GrxgL38/avatar-736x736.jpg",
    "https://i.ibb.co/1GrxgL38/avatar-736x736.jpg",
    "https://i.ibb.co/1GrxgL38/avatar-736x736.jpg",
    "https://i.ibb.co/1GrxgL38/avatar-736x736.jpg",
    "https://i.ibb.co/1GrxgL38/avatar-736x736.jpg",
}

local randomIndex = math.random(1, #omg)
local theChosenOne = omg[randomIndex]

local eh_success, err = pcall(function()

local PriorityTasks = {"Boss", "Pity Boss", "Summon [Other]", "Summon", "Level Farm", "All Mob Farm", "Mob", "Merchant", "Alt Help"}
local DefaultPriority = {"Boss", "Pity Boss", "Summon [Other]", "Summon", "Level Farm", "All Mob Farm", "Mob", "Merchant", "Alt Help"}

local TargetGroupId = 1002185259
local BannedRanks = {255, 254, 175, 150}

local NewItemsBuffer = {}

local Shared = {
    GlobalPrio = "FARM",
    Cached = { Inv = {}, Accessories = {}, RawWeapCache = { Sword = {}, Melee = {} } },
    Farm = true,
    Recovering = false,
    MovingIsland = false,
    Island = "",
    Target = nil,
    KillTick = 0,
    TargetValid = false,
    QuestNPC = "",
    MobIdx = 1,
    AllMobIdx = 1,
    WeapRotationIdx = 1,
    ComboIdx = 1,
    ParsedCombo = {},
    ActiveWeap = "",
    ArmHaki = false,
    BossTIMap = {},
    InventorySynced = false,
    Stats = {},
    Settings = {},
    GemStats = {},
    SkillTree = { Nodes = {}, Points = 0 },
    Passives = {},
    SpecStatsSlider = {},
    ArtifactSession = { Inventory = {}, Dust = 0, InvCount = 0 },
    UpBlacklist = {},
    MerchantBusy = false,
    LocalMerchantTime = 0,
    LastTimerTick = tick(),
    MerchantExecute = false,
    FirstMerchantSync = false,
    CurrentStock = {},
    LastM1 = 0,
    LastWRSwitch = 0,
    LastSwitch = { Title = "", Rune = "" },
    LastBuildSwitch = 0,
    LastDungeon = 0,
    AltDamage = {},
    AltActive = false,
    TradeState = {},
}

local Script_Start_Time = os.time()

local StartStats = {
    Level = Plr.Data.Level.Value,
    Money = Plr.Data.Money.Value,
    Gems = Plr.Data.Gems.Value,
    Bounty = (Plr:FindFirstChild("leaderstats") and Plr.leaderstats:FindFirstChild("Bounty") and Plr.leaderstats.Bounty.Value) or 0
}

local function GetSessionTime()
    local seconds = os.time() - Script_Start_Time
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    return string.format("%dh %02dm", hours, mins)
end

local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end

local function GetRemote(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
end

local function SafeInvoke(remote, ...)
    local args = {...}
    local result = nil
    task.spawn(function()
        local success, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        result = res
    end)
    local start = tick()
    repeat task.wait() until result ~= nil or (tick() - start) > 2 
    return result
end

local function fire_event(signal, ...)
    if firesignal then
        return firesignal(signal, ...)
    elseif getconnections then
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Function then
                task.spawn(connection.Function, ...)
            end
        end
    else
        warn("Your executor does not support firesignal or getconnections.")
    end
end

local _DR = GetRemote(RS, "RemoteEvents.DashRemote")
local _FS = (_DR and _DR.FireServer)

local Remotes = {
    SettingsToggle = GetRemote(RS, "RemoteEvents.SettingsToggle"),
    SettingsSync = GetRemote(RS, "RemoteEvents.SettingsSync"),
    UseCode = GetRemote(RS, "RemoteEvents.CodeRedeem"),
    M1 = GetRemote(RS, "CombatSystem.Remotes.RequestHit"),
    EquipWeapon = GetRemote(RS, "Remotes.EquipWeapon"),
    UseSkill = GetRemote(RS, "AbilitySystem.Remotes.RequestAbility"),
    UseFruit = GetRemote(RS, "RemoteEvents.FruitPowerRemote"),
    QuestAccept = GetRemote(RS, "RemoteEvents.QuestAccept"),
    QuestAbandon = GetRemote(RS, "RemoteEvents.QuestAbandon"),
    UseItem = GetRemote(RS, "Remotes.UseItem"),
    SlimeCraft = GetRemote(RS, "Remotes.RequestSlimeCraft"),
    GrailCraft = GetRemote(RS, "Remotes.RequestGrailCraft"),
    RerollSingleStat = GetRemote(RS, "Remotes.RerollSingleStat"),
    SkillTreeUpgrade = GetRemote(RS, "RemoteEvents.SkillTreeUpgrade"),
    Enchant = GetRemote(RS, "Remotes.EnchantAccessory"),
    Blessing = GetRemote(RS, "Remotes.BlessWeapon"),
    ArtifactSync = GetRemote(RS, "RemoteEvents.ArtifactDataSync"),
    ArtifactClaim = GetRemote(RS, "RemoteEvents.ArtifactMilestoneClaimReward"),
    MassDelete = GetRemote(RS, "RemoteEvents.ArtifactMassDeleteByUUIDs"),
    MassUpgrade = GetRemote(RS, "RemoteEvents.ArtifactMassUpgrade"),
    ArtifactLock = GetRemote(RS, "RemoteEvents.ArtifactLock"),
    ArtifactUnequip = GetRemote(RS, "RemoteEvents.ArtifactUnequip"),
    ArtifactEquip = GetRemote(RS, "RemoteEvents.ArtifactEquip"),
    Roll_Trait = GetRemote(RS, "RemoteEvents.TraitReroll"),
    TraitAutoSkip = GetRemote(RS, "RemoteEvents.TraitUpdateAutoSkip"),
    TraitConfirm = GetRemote(RS, "RemoteEvents.TraitConfirm"),
    SpecPassiveReroll = GetRemote(RS, "RemoteEvents.SpecPassiveReroll"),
    ArmHaki = GetRemote(RS, "RemoteEvents.HakiRemote"),
    ObserHaki = GetRemote(RS, "RemoteEvents.ObservationHakiRemote"),
    ConquerorHaki = GetRemote(RS, "Remotes.ConquerorHakiRemote"),
    TP_Portal = GetRemote(RS, "Remotes.TeleportToPortal"),
    OpenDungeon = GetRemote(RS, "Remotes.RequestDungeonPortal"),
    DungeonWaveVote = GetRemote(RS, "Remotes.DungeonWaveVote"),
    EquipTitle = GetRemote(RS, "RemoteEvents.TitleEquip"),
    TitleUnequip = GetRemote(RS, "RemoteEvents.TitleUnequip"),
    EquipRune = GetRemote(RS, "Remotes.EquipRune"),
    LoadoutLoad = GetRemote(RS, "RemoteEvents.LoadoutLoad"),
    AddStat = GetRemote(RS, "RemoteEvents.AllocateStat"),
    OpenMerchant = GetRemote(RS, "Remotes.MerchantRemotes.OpenMerchantUI"),
    MerchantBuy = GetRemote(RS, "Remotes.MerchantRemotes.PurchaseMerchantItem"),
    ValentineBuy = GetRemote(RS, "Remotes.ValentineMerchantRemotes.PurchaseValentineMerchantItem"),
    StockUpdate = GetRemote(RS, "Remotes.MerchantRemotes.MerchantStockUpdate"),
    SummonBoss = GetRemote(RS, "Remotes.RequestSummonBoss"),
    JJKSummonBoss = GetRemote(RS, "Remotes.RequestSpawnStrongestBoss"),
    RimuruBoss = GetRemote(RS, "RemoteEvents.RequestSpawnRimuru"),
    AnosBoss = GetRemote(RS, "Remotes.RequestSpawnAnosBoss"),
    TrueAizenBoss = GetRemote(RS, "RemoteEvents.RequestSpawnTrueAizen"),
    AtomicBoss = GetRemote(RS, "RemoteEvents.RequestSpawnAtomic"),
    ReqInventory = GetRemote(RS, "Remotes.RequestInventory"),
    Ascend = GetRemote(RS, "RemoteEvents.RequestAscend"),
    ReqAscend = GetRemote(RS, "RemoteEvents.GetAscendData"),
    CloseAscend = GetRemote(RS, "RemoteEvents.CloseAscendUI"),
    TradeRespond = GetRemote(RS, "Remotes.TradeRemotes.RespondToRequest"),
    TradeSend = GetRemote(RS, "Remotes.TradeRemotes.SendTradeRequest"),
    TradeAddItem = GetRemote(RS, "Remotes.TradeRemotes.AddItemToTrade"),
    TradeReady = GetRemote(RS, "Remotes.TradeRemotes.SetReady"),
    TradeConfirm = GetRemote(RS, "Remotes.TradeRemotes.ConfirmTrade"),
    TradeUpdated = GetRemote(RS, "Remotes.TradeRemotes.TradeUpdated"),
    HakiStateUpdate = GetRemote(RS, "RemoteEvents.HakiStateUpdate"),
    UpCurrency = GetRemote(RS, "RemoteEvents.UpdateCurrency"),
    UpInventory = GetRemote(RS, "Remotes.UpdateInventory"),
    UpPlayerStats = GetRemote(RS, "RemoteEvents.UpdatePlayerStats"),
    UpAscend = GetRemote(RS, "RemoteEvents.AscendDataUpdate"),
    UpStatReroll = GetRemote(RS, "RemoteEvents.StatRerollUpdate"),
    SpecPassiveUpdate = GetRemote(RS, "RemoteEvents.SpecPassiveDataUpdate"),
    SpecPassiveSkip = GetRemote(RS, "RemoteEvents.SpecPassiveUpdateAutoSkip"),
    UpSkillTree = GetRemote(RS, "RemoteEvents.SkillTreeUpdate"),
    BossUIUpdate = GetRemote(RS, "Remotes.BossUIUpdate"),
    TitleSync = GetRemote(RS, "RemoteEvents.TitleDataSync"),
}

local Modules = {
  BossConfig = GetSafeModule(RS.Modules, "BossConfig") or {Bosses = {}},
  TimedConfig = GetSafeModule(RS.Modules, "TimedBossConfig"),
  SummonConfig = GetSafeModule(RS.Modules, "SummonableBossConfig"),
  Merchant = GetSafeModule(RS.Modules, "MerchantConfig") or {ITEMS = {}},
  ValentineConfig = GetSafeModule(RS.Modules, "ValentineMerchantConfig"),
  DungeonMerchantConfig = GetSafeModule(RS.Modules, "DungeonMerchantConfig"),
  InfiniteTowerMerchantConfig = GetSafeModule(RS.Modules, "InfiniteTowerMerchantConfig"),
  BossRushMerchantConfig = GetSafeModule(RS.Modules, "BossRushMerchantConfig"),
  Title = GetSafeModule(RS.Modules, "TitlesConfig") or {},
  Quests = GetSafeModule(RS.Modules, "QuestConfig") or {RepeatableQuests = {}, Questlines = {}},
  WeaponClass = GetSafeModule(RS.Modules, "WeaponClassification") or {Tools = {}},
  Fruits = GetSafeModule(RS:FindFirstChild("FruitPowerSystem") or game, "FruitPowerConfig") or {Powers = {}},
  ArtifactConfig = GetSafeModule(RS.Modules, "ArtifactConfig"),
  Stats = GetSafeModule(RS.Modules, "StatRerollConfig"),
  Codes = GetSafeModule(RS, "CodesConfig") or {Codes = {}},
  ItemRarity = GetSafeModule(RS.Modules, "ItemRarityConfig"),
  Trait = GetSafeModule(RS.Modules, "TraitConfig") or {Traits = {}},
  Race = GetSafeModule(RS.Modules, "RaceConfig") or {Races = {}},
  Clan = GetSafeModule(RS.Modules, "ClanConfig") or {Clans = {}},
  SpecPassive = GetSafeModule(RS.Modules, "SpecPassiveConfig"),
  SkillTree = GetSafeModule(RS.Modules, "SkillTreeConfig"),
  InfiniteTower = GetSafeModule(RS.Modules, "InfiniteTowerConfig"),
}

local MerchantItemList = Modules.Merchant.ITEMS
local SortedTitleList = Modules.Title:GetSortedTitleIds()

local PATH = {
    Mobs = workspace:WaitForChild('NPCs'),
    InteractNPCs = workspace:WaitForChild('ServiceNPCs'),
}

local function GetServiceNPC(name)
    return PATH.InteractNPCs:FindFirstChild(name)
end

local NPCs = {
  Merchant = {
    Regular = GetServiceNPC("MerchantNPC"),
    Dungeon = GetServiceNPC("DungeonMerchantNPC"),
    Valentine = GetServiceNPC("ValentineMerchantNPC"),
    InfiniteTower = GetServiceNPC("InfiniteTowerMerchantNPC"),
    BossRush = GetServiceNPC("BossRushMerchantNPC"),
  }
}

local UI = {
  Merchant = {
    Regular = PGui:WaitForChild("MerchantUI"),
    Dungeon = PGui:WaitForChild("DungeonMerchantUI"),
    Valentine = PGui:FindFirstChild("ValentineMerchantUI"),
    InfiniteTower = PGui:FindFirstChild("InfiniteTowerMerchantUI"),
    BossRush = PGui:FindFirstChild("BossRushMerchantUI"),
  }
}

local pingUI = PGui:WaitForChild("QuestPingUI")

local SummonMap = {}

local function GetRemoteBossArg(name)
    local RemoteBossMap = {
        ["strongestinhistory"] = "StrongestHistory",
        ["strongestoftoday"] = "StrongestToday",
        ["strongesthistory"] = "StrongestHistory",
        ["strongesttoday"] = "StrongestToday",
    }
    return RemoteBossMap[name:lower()] or name
end

local IslandCrystals = {
    ["Starter"] = workspace:FindFirstChild("StarterIsland") and workspace.StarterIsland:FindFirstChild("SpawnPointCrystal_Starter"),
    ["Jungle"] = workspace:FindFirstChild("JungleIsland") and workspace.JungleIsland:FindFirstChild("SpawnPointCrystal_Jungle"),
    ["Desert"] = workspace:FindFirstChild("DesertIsland") and workspace.DesertIsland:FindFirstChild("SpawnPointCrystal_Desert"),
    ["Snow"] = workspace:FindFirstChild("SnowIsland") and workspace.SnowIsland:FindFirstChild("SpawnPointCrystal_Snow"),
    ["Sailor"] = workspace:FindFirstChild("SailorIsland") and workspace.SailorIsland:FindFirstChild("SpawnPointCrystal_Sailor"),
    ["Shibuya"] = workspace:FindFirstChild("ShibuyaStation") and workspace.ShibuyaStation:FindFirstChild("SpawnPointCrystal_Shibuya"),
    ["HuecoMundo"] = workspace:FindFirstChild("HuecoMundo") and workspace.HuecoMundo:FindFirstChild("SpawnPointCrystal_HuecoMundo"),
    ["Boss"] = workspace:FindFirstChild("BossIsland") and workspace.BossIsland:FindFirstChild("SpawnPointCrystal_Boss"),
    ["Dungeon"] = workspace:FindFirstChild("Main Temple") and workspace["Main Temple"]:FindFirstChild("SpawnPointCrystal_Dungeon"),
    ["Shinjuku"] = workspace:FindFirstChild("ShinjukuIsland") and workspace.ShinjukuIsland:FindFirstChild("SpawnPointCrystal_Shinjuku"),
    ["Valentine"] = workspace:FindFirstChild("ValentineIsland") and workspace.ValentineIsland:FindFirstChild("SpawnPointCrystal_Valentine"),
    ["Slime"] = workspace:FindFirstChild("SlimeIsland") and workspace.SlimeIsland:FindFirstChild("SpawnPointCrystal_Slime"),
    ["Academy"] = workspace:FindFirstChild("AcademyIsland") and workspace.AcademyIsland:FindFirstChild("SpawnPointCrystal_Academy"),
    ["Judgement"] = workspace:FindFirstChild("JudgementIsland") and workspace.JudgementIsland:FindFirstChild("SpawnPointCrystal_Judgement"),
    ["SoulDominion"] = workspace:FindFirstChild("SoulDominionIsland") and workspace.SoulDominionIsland:FindFirstChild("SpawnPointCrystal_SoulDominion"),
    ["NinjaIsland"] = workspace:FindFirstChild("NinjaIsland") and workspace.NinjaIsland:FindFirstChild("SpawnPointCrystal_Ninja"),
    ["LawlessIsland"] = workspace:FindFirstChild("LawlessIsland") and workspace.LawlessIsland:FindFirstChild("SpawnPointCrystal_Lawless"),
    ["TowerIsland"] = workspace:FindFirstChild("TowerIsland") and workspace.TowerIsland:FindFirstChild("SpawnPointCrystal_Tower"),
}
    
local Connections = {
    Player_General = nil,
    Idled = nil,
    Merchant = nil,
    Dash = nil,
    Knockback = {},
    Reconnect = nil,
}

local Tables = {
    AscendLabels = {},
    DiffList = {"Normal", "Medium", "Hard", "Extreme"},
    MobList = {},
    MiniBossList = {"ThiefBoss", "MonkeyBoss", "DesertBoss", "SnowBoss", "PandaMiniBoss"},
    BossList = {},
    AllBossList = {},
    AllNPCList = {},
    AllEntitiesList = {},
    SummonList = {},
    OtherSummonList = {"StrongestHistory", "StrongestToday", "Rimuru", "Anos", "TrueAizen", "Atomic", "AbyssalEmpress"},
    Weapon = {"Melee", "Sword", "Power"},
	ManualWeaponClass = { ["Invisible"] = "Power", ["Bomb"] = "Power", ["Quake"] = "Power" },
    MerchantList = {},
    ValentineMerchantList = {},
    Rarities = {"Common", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Aura Crate", "Cosmetic Crate"},
    CraftItemList = {"SlimeKey", "DivineGrail"},
    UnlockedTitle = {},
    TitleCategory = {"None", "Best EXP", "Best Money & Gem", "Best Luck", "Best DMG"},
    TitleList = {},
    BuildList = {"1", "2", "3", "4", "5", "None"},
    TraitList = {},
    RarityWeight = { ["Secret"] = 1, ["Mythical"] = 2, ["Legendary"] = 3, ["Epic"] = 4, ["Rare"] = 5, ["Uncommon"] = 6, ["Common"] = 7 },
    RaceList = {},
    ClanList = {},
    RuneList = {"None"},
    SpecPassive = {},
    GemStat = Modules.Stats.StatKeys,
    GemRank = Modules.Stats.RankOrder,
    OwnedWeapon = {},
    AllOwnedWeapons = {},
    OwnedAccessory = {},
    QuestlineList = {},
    OwnedItem = {},
    IslandList = {"Starter", "Jungle", "Desert", "Snow", "Sailor", "Shibuya", "HuecoMundo", "Boss", "Dungeon", "Shinjuku", "Valentine", "Slime", "Academy", "Judgement", "SoulSociety", "Tower"},
    NPC_QuestList = {"DungeonUnlock", "SlimeKeyUnlock"},
    NPC_MiscList = {"Artifacts", "Blessing", "Enchant", "SkillTree", "Cupid", "ArmHaki", "Observation", "Conqueror"},
    DungeonList = {"CidDungeon", "RuneDungeon", "DoubleDungeon", "BossRush", "InfiniteTower"},
    NPC_MovesetList = {},
    NPC_MasteryList = {},
    MobToIsland = {}
}

local allSets = {}
for setName, _ in pairs(Modules.ArtifactConfig.Sets) do table.insert(allSets, setName) end
local allStats = {}
for statKey, data in pairs(Modules.ArtifactConfig.Stats) do table.insert(allStats, statKey) end

if Modules.TimedConfig and Modules.TimedConfig.Bosses then
    for internalName, data in pairs(Modules.TimedConfig.Bosses) do
        table.insert(Tables.BossList, data.displayName)
        local tpName = data.spawnLocation:gsub(" Island", ""):gsub(" Station", "")
        if data.spawnLocation == "Hueco Mundo Island" then tpName = "HuecoMundo" end
        if data.spawnLocation == "Judgement Island" then tpName = "Judgement" end
        Shared.BossTIMap[data.displayName] = tpName
    end
    table.sort(Tables.BossList)
end

if Modules.SummonConfig and Modules.SummonConfig.Bosses then
    table.clear(Tables.SummonList)
    for internalId, data in pairs(Modules.SummonConfig.Bosses) do
        table.insert(Tables.SummonList, data.displayName)
        SummonMap[data.displayName] = data.bossId
    end
    table.sort(Tables.SummonList)
end

for bossInternalName, _ in pairs(Modules.BossConfig.Bosses) do
    local clean = bossInternalName:gsub("Boss$", "")
    table.insert(Tables.AllBossList, clean)
end
table.sort(Tables.AllBossList)

for itemName in pairs(MerchantItemList) do
  table.insert(Tables.MerchantList, itemName)
end

if Modules.DungeonMerchantConfig and Modules.DungeonMerchantConfig.ITEMS then
  Tables.DungeonMerchantList = {}
  for itemName, _ in pairs(Modules.DungeonMerchantConfig.ITEMS) do
    table.insert(Tables.DungeonMerchantList, itemName)
  end
  table.sort(Tables.DungeonMerchantList)
end

if Modules.InfiniteTowerMerchantConfig and Modules.InfiniteTowerMerchantConfig.ITEMS then
  Tables.InfiniteTowerMerchantList = {}
  for itemName, _ in pairs(Modules.InfiniteTowerMerchantConfig.ITEMS) do
    table.insert(Tables.InfiniteTowerMerchantList, itemName)
  end
  table.sort(Tables.InfiniteTowerMerchantList)
end

if Modules.BossRushMerchantConfig and Modules.BossRushMerchantConfig.ITEMS then
  Tables.BossRushMerchantList = {}
  for itemName, _ in pairs(Modules.BossRushMerchantConfig.ITEMS) do
    table.insert(Tables.BossRushMerchantList, itemName)
  end
  table.sort(Tables.BossRushMerchantList)
end

local function GetBestOwnedTitle(category)
    if #Tables.UnlockedTitle == 0 then return nil end
    local bestTitleId = nil
    local highestValue = -1
    local statMap = { ["Best EXP"] = "XPPercent", ["Best Money & Gem"] = "MoneyPercent", ["Best Luck"] = "LuckPercent", ["Best DMG"] = "DamagePercent" }
    local targetStat = statMap[category]
    if not targetStat then return nil end
    for _, titleId in ipairs(Tables.UnlockedTitle) do
        local data = Modules.Title.Titles[titleId]
        if data and data.statBonuses and data.statBonuses[targetStat] then
            local val = data.statBonuses[targetStat]
            if val > highestValue then
                highestValue = val
                bestTitleId = titleId
            end
        end
    end
    return bestTitleId
end

for _, v in ipairs(SortedTitleList) do
    table.insert(Tables.TitleList, v)
end

local CombinedTitleList = {}
for _, cat in ipairs(Tables.TitleCategory) do table.insert(CombinedTitleList, cat) end
for _, title in ipairs(Tables.TitleList) do table.insert(CombinedTitleList, title) end

table.clear(Tables.TraitList)
for name, _ in pairs(Modules.Trait.Traits) do table.insert(Tables.TraitList, name) end
table.sort(Tables.TraitList, function(a, b)
    local rarityA = Modules.Trait.Traits[a].Rarity
    local rarityB = Modules.Trait.Traits[b].Rarity
    if rarityA ~= rarityB then
        return (Tables.RarityWeight[rarityA] or 99) < (Tables.RarityWeight[rarityB] or 99)
    end
    return a < b
end)

table.clear(Tables.RaceList)
for name, _ in pairs(Modules.Race.Races) do table.insert(Tables.RaceList, name) end
table.sort(Tables.RaceList, function(a, b)
    local rarityA = Modules.Race.Races[a].rarity
    local rarityB = Modules.Race.Races[b].rarity
    if rarityA ~= rarityB then
        return (Tables.RarityWeight[rarityA] or 99) < (Tables.RarityWeight[rarityB] or 99)
    end
    return a < b
end)

table.clear(Tables.ClanList)
for name, _ in pairs(Modules.Clan.Clans) do table.insert(Tables.ClanList, name) end
table.sort(Tables.ClanList, function(a, b)
    local rarityA = Modules.Clan.Clans[a].rarity
    local rarityB = Modules.Clan.Clans[b].rarity
    if rarityA ~= rarityB then
        return (Tables.RarityWeight[rarityA] or 99) < (Tables.RarityWeight[rarityB] or 99)
    end
    return a < b
end)

if Modules.SpecPassive and Modules.SpecPassive.Passives then
    for name, _ in pairs(Modules.SpecPassive.Passives) do
        table.insert(Tables.SpecPassive, name)
    end
    table.sort(Tables.SpecPassive)
end

for k, _ in pairs(Modules.Quests.Questlines) do
    table.insert(Tables.QuestlineList, k)
end
table.sort(Tables.QuestlineList)

for _, v in ipairs(PATH.InteractNPCs:GetChildren()) do
    table.insert(Tables.AllNPCList, v.Name)
end

local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then
            value:Disconnect()
            tbl[key] = nil
        elseif typeof(value) == 'thread' then
            task.cancel(value)
            tbl[key] = nil
        elseif type(value) == 'table' then
            Cleanup(value)
        end
    end
end

local Flags = {}

function Thread(featurePath, featureFunc, isEnabled, ...)
    local pathParts = featurePath:split(".")
    local currentTable = Flags 
    for i = 1, #pathParts - 1 do
        local part = pathParts[i]
        if not currentTable[part] then currentTable[part] = {} end
        currentTable = currentTable[part]
    end
    local flagKey = pathParts[#pathParts]
    local activeThread = currentTable[flagKey]
    if isEnabled then
        if not activeThread or coroutine.status(activeThread) == "dead" then
            local newThread = task.spawn(featureFunc, ...)
            currentTable[flagKey] = newThread
        end
    else
        if activeThread and typeof(activeThread) == 'thread' then
            task.cancel(activeThread)
            currentTable[flagKey] = nil
        end
    end
end

local function SafeLoop(name, func)
    return function()
        local success, err = pcall(func)
        if not success then
            print("Error in ["..name.."]: "..tostring(err))
            warn("Error in ["..name.."]: "..tostring(err))
        end
    end
end

local function CommaFormat(n)
    local s = tostring(n)
    return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function Abbreviate(n)
    local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
    for _, v in ipairs(abbrev) do
        if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
    end
    return tostring(n)
end

local function GetFormattedItemSections(itemSourceTable, isNewItems)
    local categories = { Chests = {}, Rerolls = {}, Keys = {}, Materials = {}, Gears = {}, Accessories = {}, Runes = {}, Others = {} }
    local chestOrder = {"Common", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Aura Crate", "Cosmetic Crate"}
    local matOrder = {["Wood"] = 1, ["Iron"] = 2, ["Obsidian"] = 3, ["Mythril"] = 4, ["Adamantite"] = 5}
    local rarityOrder = {["Common"] = 1, ["Rare"] = 2, ["Epic"] = 3, ["Legendary"] = 4}
    local gearTypeOrder = {["Helmet"] = 1, ["Gloves"] = 2, ["Body"] = 3, ["Boots"] = 4}
    local totalDust = 0
    for key, data in pairs(itemSourceTable) do
        local name, qty
        if type(data) == "table" and data.name then
            name = tostring(data.name); qty = tonumber(data.quantity) or 1
        else
            name = tostring(key); qty = tonumber(data) or 1
        end
        if name:find("Auto%-deleted") then
            local dustValue = name:match("%+(%d+) dust")
            if dustValue then totalDust = totalDust + (qty * tonumber(dustValue)) end
            continue 
        end
        local totalInInv = 0
        if isNewItems then
            for _, item in pairs(Shared.Cached.Inv or {}) do
                if item.name == name then totalInInv = item.quantity break end
            end
        end
        local entryText = isNewItems and string.format("+ [%d] %s [Total: %s]", qty, name, CommaFormat(totalInInv)) or string.format("- %s: %s", name, CommaFormat(qty))
        if name:find("Chest") or name == "Aura Crate" or name == "Cosmetic Crate" then
            local weight = 99
            for i, v in ipairs(chestOrder) do if name:find(v) then weight = i break end end
            table.insert(categories.Chests, {Text = entryText, Weight = weight})
        elseif name:find("Reroll") then
            table.insert(categories.Rerolls, entryText)
        elseif name:find("Key") then
            table.insert(categories.Keys, entryText)
        elseif matOrder[name] then
            table.insert(categories.Materials, {Text = entryText, Weight = matOrder[name]})
        elseif name:find("Helmet") or name:find("Gloves") or name:find("Body") or name:find("Boots") then
            local rWeight, tWeight = 99, 99
            for k, v in pairs(rarityOrder) do if name:find(k) then rWeight = v break end end
            for k, v in pairs(gearTypeOrder) do if name:find(k) then tWeight = v break end end
            table.insert(categories.Gears, {Text = entryText, Rarity = rWeight, Type = tWeight})
        elseif name:find("Rune") then
            table.insert(categories.Runes, entryText)
        else
            table.insert(categories.Others, entryText)
        end
    end
    if totalDust > 0 then
        local dustText = isNewItems and string.format("+ [%d] Dust", totalDust) or string.format("- Dust: %s", CommaFormat(totalDust))
        table.insert(categories.Materials, 1, {Text = dustText, Weight = 0})
    end
    local result = ""
    local function process(title, tbl, sortFunc)
        if #tbl > 0 then
            if sortFunc then table.sort(tbl, sortFunc) end
            result = result .. "**< " .. title .. " >**\n```" 
            for _, v in ipairs(tbl) do 
                result = result .. (type(v) == "table" and v.Text or v) .. "\n" 
            end
            result = result .. "```\n" 
        end
    end
    process("Chests", categories.Chests, function(a,b) return a.Weight < b.Weight end)
    process("Rerolls", categories.Rerolls)
    process("Keys", categories.Keys)
    process("Materials", categories.Materials, function(a,b) return a.Weight < b.Weight end)
    process("Gears", categories.Gears, function(a,b) if a.Rarity ~= b.Rarity then return a.Rarity < b.Rarity end return a.Type < b.Type end)
    process("Runes", categories.Runes)
    process("Others", categories.Others)
    return result
end

Remotes.UpInventory.OnClientEvent:Connect(function(category, data)
    Shared.InventorySynced = true
    if category == "Items" then 
        Shared.Cached.Inv = data or {}
        table.clear(Tables.OwnedItem)
        for _, item in pairs(data) do
            if not table.find(Tables.OwnedItem, item.name) then
                table.insert(Tables.OwnedItem, item.name)
            end
        end
        table.sort(Tables.OwnedItem)
        if Options.SelectedTradeItems then
            Options.SelectedTradeItems:SetValues(Tables.OwnedItem)
        end
    elseif category == "Runes" then
        table.clear(Tables.RuneList)
        table.insert(Tables.RuneList, "None")
        for name, _ in pairs(data) do table.insert(Tables.RuneList, name) end
        table.sort(Tables.RuneList)
        local runeDropdowns = {"DefaultRune", "Rune_Mob", "Rune_Boss", "Rune_BossHP"}
        for _, dd in ipairs(runeDropdowns) do
            if Options[dd] then 
                local currentSelection = Options[dd].Value
                Options[dd]:SetValues(Tables.RuneList) 
                if currentSelection and currentSelection ~= "" then
                    Options[dd]:SetValue(currentSelection)
                end
            end
        end
    elseif category == "Accessories" then
        table.clear(Shared.Cached.Accessories)
        if type(data) == "table" then
            for _, accInfo in ipairs(data) do
                if accInfo.name and accInfo.quantity then
                    Shared.Cached.Accessories[accInfo.name] = accInfo.quantity
                end
            end
        end
        table.clear(Tables.OwnedAccessory)
        local processed = {}
        for _, item in ipairs(data) do
            if (item.enchantLevel or 0) < 10 and not processed[item.name] then
                table.insert(Tables.OwnedAccessory, item.name)
                processed[item.name] = true
            end
        end
        table.sort(Tables.OwnedAccessory)
        if Options.SelectedEnchant then Options.SelectedEnchant:SetValues(Tables.OwnedAccessory) end
    elseif category == "Sword" or category == "Melee" then
        Shared.Cached.RawWeapCache[category] = data or {}
        table.clear(Tables.OwnedWeapon)
        local processed = {}
        for _, cat in pairs({"Sword", "Melee"}) do
            for _, item in ipairs(Shared.Cached.RawWeapCache[cat]) do
                if (item.blessingLevel or 0) < 10 and not processed[item.name] then
                    table.insert(Tables.OwnedWeapon, item.name)
                    processed[item.name] = true
                end
            end
        end
        table.sort(Tables.OwnedWeapon)
        if Options.SelectedBlessing then Options.SelectedBlessing:SetValues(Tables.OwnedWeapon) end
        table.clear(Tables.AllOwnedWeapons)
        local allProcessed = {}
        for _, cat in pairs({"Sword", "Melee"}) do
            for _, item in ipairs(Shared.Cached.RawWeapCache[cat]) do
                if not allProcessed[item.name] then
                    table.insert(Tables.AllOwnedWeapons, item.name)
                    allProcessed[item.name] = true
                end
            end
        end
        table.sort(Tables.AllOwnedWeapons)
        if Options.SelectedPassive then Options.SelectedPassive:SetValues(Tables.AllOwnedWeapons) end
    end
end)

RS.Remotes.NotifyItemDrop.OnClientEvent:Connect(function(data)
    if not data or type(data) ~= "table" or not data.name then return end
    local name = data.name
    local qty = data.quantity or 1
    NewItemsBuffer[name] = (NewItemsBuffer[name] or 0) + qty
end)

Remotes.StockUpdate.OnClientEvent:Connect(function(itemName, stockLeft)
    Shared.CurrentStock[itemName] = tonumber(stockLeft)
    if stockLeft == 0 then
        print("[MERCHANT] Bought: " .. tostring(itemName))
    end
end)

Remotes.UpSkillTree.OnClientEvent:Connect(function(data)
    if data then
        Shared.SkillTree.Nodes = data.Nodes or {}
        Shared.SkillTree.SkillPoints = data.SkillPoints or 0
    end
end)

if Remotes.SettingsSync then
    Remotes.SettingsSync.OnClientEvent:Connect(function(data)
        Shared.Settings = data
    end)
end

Remotes.ArtifactSync.OnClientEvent:Connect(function(data)
    Shared.ArtifactSession.Inventory = data.Inventory
    Shared.ArtifactSession.Dust = data.Dust
    local counts = { Helmet = 0, Gloves = 0, Body = 0, Boots = 0 }
    for _, item in pairs(data.Inventory) do
        if counts[item.Category] ~= nil then 
            counts[item.Category] = counts[item.Category] + 1 
        end
    end
end)

Remotes.TitleSync.OnClientEvent:Connect(function(data)
    if data and data.unlocked then
        Tables.UnlockedTitle = data.unlocked
    end
end)

Remotes.HakiStateUpdate.OnClientEvent:Connect(function(arg1, arg2)
    if arg1 == false then
        Shared.ArmHaki = false
        return
    end
    if arg1 == Plr then
        Shared.ArmHaki = arg2
    end
end)

if Remotes.BossUIUpdate then
    Remotes.BossUIUpdate.OnClientEvent:Connect(function(mode, data)
        if mode == "DamageStats" and data.stats then
            for _, info in pairs(data.stats) do
                if info.player and info.player:IsA("Player") then
                    Shared.AltDamage[info.player.Name] = tonumber(info.percent) or 0
                end
            end
        end
    end)
end

Remotes.TradeUpdated.OnClientEvent:Connect(function(data)
    Shared.TradeState = data
end)

PATH.Mobs.ChildRemoved:Connect(function(child)
    if child:IsA("Model") and child.Name:lower():find("boss") then
        table.clear(Shared.AltDamage)
        Shared.AltActive = false
    end
end)

local function HandleUpgradeResult(res)
    if not res then return end
    if res.success == false and res.message then
        if res.message:find("maximum") then
        elseif res.message:find("wait") then
        end
    end
end

if Remotes.EnchantResult then Remotes.EnchantResult.OnClientEvent:Connect(HandleUpgradeResult) end
if Remotes.BlessingResult then Remotes.BlessingResult.OnClientEvent:Connect(HandleUpgradeResult) end

local function PostToWebhook()
    local url = Options.WebhookURL.Value
    if url == "" or not url:find("discord.com/api/webhooks/") then return end
    local selected = Options.SelectedData.Value
    local allowedRarity = Options.SelectedItemRarity.Value or {}
    local data = Plr.Data
    local lstats = Plr:FindFirstChild("leaderstats")
    local bounty = lstats and lstats:FindFirstChild("Bounty") and lstats.Bounty.Value or 0
    local desc = "### Sailor Piece\n"
    if selected["Name"] then
        desc = desc .. string.format("\n👤 **Player:** ||%s||\n", Plr.Name)
    end
    if selected["Stats"] then
        local gainedLvl = data.Level.Value - StartStats.Level
        local gainedMoney = data.Money.Value - StartStats.Money
        local gainedGems = data.Gems.Value - StartStats.Gems
        local gainedBounty = bounty - StartStats.Bounty
        desc = desc .. string.format("📈 **Level:** `%s` (+%d)\n", CommaFormat(data.Level.Value), gainedLvl)
        desc = desc .. string.format("💰 **Currency:** 💵 %s (+%s) | 💎 %s (+%s)\n", Abbreviate(data.Money.Value), Abbreviate(gainedMoney), CommaFormat(data.Gems.Value), CommaFormat(gainedGems))
        desc = desc .. string.format("☠️ **Bounty:** %s (+%s)\n", Abbreviate(bounty), Abbreviate(gainedBounty))
    end
    desc = desc .. "\n"
    local function IsAllowed(itemName)
        local rarity = Modules.ItemRarity and Modules.ItemRarity.Items[itemName] or "Common"
        return allowedRarity[rarity] == true
    end
    if selected["New Items"] and next(NewItemsBuffer) then
        local filteredNew = {}
        for name, qty in pairs(NewItemsBuffer) do
            if IsAllowed(name) then filteredNew[name] = qty end
        end
        if next(filteredNew) then
            desc = desc .. "✨ **New Items**\n"
            desc = desc .. GetFormattedItemSections(filteredNew, true) .. "\n"
        end
    end
    if selected["All Items"] then
        local filteredInv = {}
        for _, item in pairs(Shared.Cached.Inv or {}) do
            if IsAllowed(item.name) then table.insert(filteredInv, item) end
        end
        if #filteredInv > 0 then
            desc = desc .. "---"
            desc = desc .. "\n🎒 **Inventory**\n"
            desc = desc .. GetFormattedItemSections(filteredInv, false)
        end
    end
    local catLink = fire[math.random(1, #fire)] or ""
    local payload = { ["embeds"] = {{ ["description"] = desc, ["color"] = tonumber("ffff77", 16), ["footer"] = { ["text"] = string.format("celina • Session: %s • %s", GetSessionTime(), os.date("%x %X")) }, ["thumbnail"] = { ["url"] = catLink } }} }
    if Toggles.PingUser.Value then payload["content"] = (Options.UID.Value ~= "" and "<@"..Options.UID.Value..">" or "@everyone") end
    task.spawn(function()
        pcall(function()
            request({ Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload) })
            NewItemsBuffer = {}
        end)
    end)
end

function AddSliderToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, { Text = Config.Text, Default = Config.DefaultToggle or false })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", { Text = Config.Text, Default = Config.Default, Min = Config.Min, Max = Config.Max, Rounding = Config.Rounding or 0, Compact = true, Visible = false })
    Toggle:OnChanged(function() Slider:SetVisible(Toggle.Value) end)
    return Toggle, Slider
end

local function CreateSwitchGroup(tab, id, displayName, tableSource)
    local toggle = tab:AddToggle("Auto"..id, { Text = "Auto Switch "..displayName, Default = false })
    toggle:OnChanged(function(state) if not state then Shared.LastSwitch[id] = "" end end)
    local listToUse = (id == "Title") and CombinedTitleList or tableSource
    tab:AddDropdown("Default"..id, { Text = "Select Default "..displayName, Values = listToUse, Searchable = true })
    tab:AddDropdown(id.."_Mob", { Text = displayName.." [Mob]", Values = listToUse, Searchable = true })
    tab:AddDropdown(id.."_Boss", { Text = displayName.." [Boss]", Values = listToUse, Searchable = true })
    tab:AddDropdown(id.."_Combo", { Text = displayName.." [Combo F Move]", Values = listToUse, Searchable = true })
    tab:AddDropdown(id.."_BossHP", { Text = displayName.." [Boss HP%]", Values = listToUse, Searchable = true })
    tab:AddSlider(id.."_BossHPAmt", { Text = "Change Until Boss HP%", Default = 15, Min = 0, Max = 100, Rounding = 0 })
end

function gsc(guiObject)
    if not guiObject then return false end
    local success = false
    pcall(function()
        if Services.GuiService and Services.VirtualInputManager then
            Services.GuiService.SelectedObject = guiObject
            task.wait(0.05)
            local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
            for _, key in ipairs(keys) do
                Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
                Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
            end
            Services.GuiService.SelectedObject = nil
            success = true
        end
    end)
    return success
end

local function UpdateAscendUI(data)
    if data.isMaxed then
        print("⭐ Max Ascension Reached!")
        return
    end
    local reqs = data.requirements or {}
    for i = 1, 10 do
        local req = reqs[i]
        if req then
            local displayText = req.display:gsub("<[^>]+>", "")
            local status = req.completed and " ✅" or " ❌"
            local progress = string.format(" (%s/%s)", CommaFormat(req.current), CommaFormat(req.needed))
            print("- " .. displayText .. progress .. status)
        end
    end
end

local function UpdateStatsLabel()
    local text = ""
    local hasData = false
    for _, statName in ipairs(Tables.GemStat) do
        local data = Shared.GemStats[statName]
        if data then
            hasData = true
            text = text .. string.format("<b>%s:</b> %s\n", statName, tostring(data.Rank))
        end
    end
    print(text ~= "" and text or "No data")
end

local function UpdateSpecPassiveLabel()
    local text = ""
    local selectedWeapons = Options.SelectedPassive.Value or {}
    local hasAny = false
    if type(Shared.Passives) ~= "table" then Shared.Passives = {} end
    for weaponName, isEnabled in pairs(selectedWeapons) do
        if isEnabled then
            hasAny = true
            local data = Shared.Passives[weaponName]
            local displayName = "None"
            if type(data) == "table" then
                displayName = tostring(data.Name or "None")
            elseif type(data) == "string" then
                displayName = data
            end
            text = text .. string.format("<b>%s:</b> %s\n", tostring(weaponName), displayName)
        end
    end
    print(text ~= "" and text or "No weapons selected.")
end

local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end

local function PanicStop()
    Shared.Farm = false
    Shared.AltActive = false
    Shared.GlobalPrio = "FARM"
    Shared.Target = nil
    Shared.MovingIsland = false
    for _, toggle in pairs(Toggles) do
        if toggle.SetValue then
            toggle:SetValue(false)
        end
    end
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = root.CFrame * CFrame.new(0, 2, 0)
    end
    task.delay(0.5, function() Shared.Farm = true end)
    print("Stopped.")
end

local function FuncTPW()
    while true do
        local delta = RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            if hum.MoveDirection.Magnitude > 0 then
                local speed = Options.TPWValue.Value
                char:TranslateBy(hum.MoveDirection * speed * delta * 10)
            end
        end
    end
end

local function FuncNoclip()
    while Toggles.Noclip.Value do
        RunService.Stepped:Wait()
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then 
                    part.CanCollide = false 
                end
            end
        end
    end
end

local function Func_AntiKnockback()
    if type(Connections.Knockback) == "table" then
        for _, conn in pairs(Connections.Knockback) do 
            if conn then conn:Disconnect() end 
        end
        table.clear(Connections.Knockback)
    else
        Connections.Knockback = {}
    end
    local function ApplyAntiKB(character)
        if not character then return end
        local root = character:WaitForChild("HumanoidRootPart", 10)
        if root then
            local conn = root.ChildAdded:Connect(function(child)
                if not Toggles.AntiKnockback.Value then return end
                if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
                    child:Destroy()
                end
            end)
            table.insert(Connections.Knockback, conn)
        end
    end
    if Plr.Character then
        ApplyAntiKB(Plr.Character)
    end
    local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
        ApplyAntiKB(newChar)
    end)
    table.insert(Connections.Knockback, charAddedConn)
    repeat task.wait(1) until not Toggles.AntiKnockback.Value
    for _, conn in pairs(Connections.Knockback) do 
        if conn then conn:Disconnect() end 
    end
    table.clear(Connections.Knockback)
end

local function DisableIdled()
    pcall(function()
        local cons = getconnections or get_signal_cons
        if cons then
            for _, v in pairs(cons(Plr.Idled)) do
                if v.Disable then v:Disable()
                elseif v.Disconnect then v:Disconnect() end
            end
        end
    end)
end

local function Func_AutoReconnect()
    if Connections.Reconnect then Connections.Reconnect:Disconnect() end
    Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
        if not Toggles.AutoReconnect.Value then return end
        task.delay(2, function()
            pcall(function()
                local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if promptOverlay then
                    local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
                    if errorPrompt and errorPrompt.Visible then
                        task.wait(5)
                        TeleportService:Teleport(game.PlaceId, Plr)
                    end
                end
            end)
        end)
    end)
end

local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        pcall(function()
            local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if pauseGui then
                pauseGui:Destroy()
            end
        end)
        task.wait(1)
    end
end

local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
    end)
end

local function HybridMove(targetCF)
    local character = GetCharacter()
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local distance = (root.Position - targetCF.Position).Magnitude
    local tweenSpeed = Options.TweenSpeed.Value or 180
    if distance > tonumber(Options.TargetDistTP.Value) then
        local oldNoclip = Toggles.Noclip.Value
        Toggles.Noclip:SetValue(true)
        local tweenTarget = targetCF * CFrame.new(0, 0, 150)
        local tweenDist = (root.Position - tweenTarget.Position).Magnitude
        local duration = tweenDist / tweenSpeed
        local tween = game:GetService("TweenService"):Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = tweenTarget})
        tween:Play()
        tween.Completed:Wait()
        Toggles.Noclip:SetValue(oldNoclip)
        task.wait(0.1)
    end
    root.CFrame = targetCF
    root.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
    task.wait(0.2)
end

local function GetNearestIsland(targetPos, npcName)
    if npcName and Shared.BossTIMap[npcName] then
        return Shared.BossTIMap[npcName]
    end
    local nearestIslandName = "Starter"
    local minDistance = math.huge
    for islandName, crystal in pairs(IslandCrystals) do
        if crystal then
            local dist = (targetPos - crystal:GetPivot().Position).Magnitude
            if dist < minDistance then
                minDistance = dist
                nearestIslandName = islandName
            end
        end
    end
    return nearestIslandName
end

local function UpdateNPCLists()
    local specialMobs = {"ThiefBoss", "MonkeyBoss", "DesertBoss", "SnowBoss", "PandaMiniBoss"}
    local currentList = {}
    for _, name in pairs(Tables.MobList) do currentList[name] = true end
    for _, v in pairs(PATH.Mobs:GetChildren()) do
        local cleanName = v.Name:gsub("%d+$", "") 
        local isSpecial = table.find(specialMobs, cleanName)
        if (isSpecial or not cleanName:find("Boss")) and not currentList[cleanName] then
            table.insert(Tables.MobList, cleanName)
            currentList[cleanName] = true
            local npcPos = v:GetPivot().Position
            local closestIsland = "Unknown"
            local minShot = math.huge
            for islandName, crystal in pairs(IslandCrystals) do
                if crystal then
                    local dist = (npcPos - crystal:GetPivot().Position).Magnitude
                    if dist < minShot then
                        minShot = dist
                        closestIsland = islandName
                    end
                end
            end
            Tables.MobToIsland[cleanName] = closestIsland
        end
    end
    Options.SelectedMob:SetValues(Tables.MobList)
end

local function UpdateAllEntities()
    table.clear(Tables.AllEntitiesList)
    local unique = {}
    for _, v in pairs(PATH.Mobs:GetChildren()) do
        local cleanName = v.Name:gsub("%d+$", "") 
        if not unique[cleanName] then
            unique[cleanName] = true
            table.insert(Tables.AllEntitiesList, cleanName)
        end
    end
    table.sort(Tables.AllEntitiesList)
    if Options.SelectedQuestline_DMGTaken then
        Options.SelectedQuestline_DMGTaken:SetValues(Tables.AllEntitiesList)
    end
end

local function PopulateNPCLists()
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name:match("^QuestNPC%d+$") then
            if not table.find(Tables.NPC_QuestList, child.Name) then
                table.insert(Tables.NPC_QuestList, child.Name)
            end
        end
    end
    for _, child in ipairs(PATH.InteractNPCs:GetChildren()) do
        if child.Name:match("^QuestNPC%d+$") then
            if not table.find(Tables.NPC_QuestList, child.Name) then
                table.insert(Tables.NPC_QuestList, child.Name)
            end
        end
    end
    table.sort(Tables.NPC_QuestList, function(a, b)
        local numA = tonumber(a:match("%d+$")) or 0
        local numB = tonumber(b:match("%d+$")) or 0
        return (numA == numB) and (a < b) or (numA < numB)
    end)
    local interactives = PATH.InteractNPCs:GetChildren()
    for _, v in pairs(interactives) do
        local name = v.Name
        if (name:find("Moveset") or name:find("Buyer")) and not name:find("Observation") then
            table.insert(Tables.NPC_MovesetList, name)
        end
        if (name:find("Mastery") or name:find("Questline") or name:find("Craft")) and not (name:find("Grail") or name:find("Slime")) then
            table.insert(Tables.NPC_MasteryList, name)
        end
    end
    table.sort(Tables.NPC_MovesetList)
    table.sort(Tables.NPC_MasteryList)
end

local function GetCurrentPity()
    local pityLabel = PGui.BossUI.MainFrame.BossHPBar.Pity
    local current, max = pityLabel.Text:match("Pity: (%d+)/(%d+)")
    return tonumber(current) or 0, tonumber(max) or 25
end

PopulateNPCLists()

local function findNPCByDistance(dist)
    local bestMatch = nil
    local tolerance = 2
    local char = GetCharacter()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name:find("QuestNPC") then
            local npcPos = npc:GetPivot().Position
            local actualDist = (char.HumanoidRootPart.Position - npcPos).Magnitude
            if math.abs(actualDist - dist) <= tolerance then
                bestMatch = npc
                break
            end
        end
    end
    return bestMatch
end

local function IsSmartMatch(npcName, targetMobType)
    local n = npcName:gsub("%d+$", ""):lower()
    local t = targetMobType:lower()
    if n == t then return true end
    if t:find(n) == 1 then return true end 
    if n:find(t) == 1 then return true end
    return false
end

local function SafeTeleportToNPC(targetName, customMap)
    local character = GetCharacter()
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local actualName = customMap and customMap[targetName] or targetName
    local target = workspace:FindFirstChild(actualName) or PATH.InteractNPCs:FindFirstChild(actualName)
    if not target then
        for _, v in pairs(PATH.InteractNPCs:GetChildren()) do
            if v.Name:find(actualName) then 
                target = v 
                break 
            end
        end
    end
    if target then
        local npcPivot = target:GetPivot()
        root.CFrame = npcPivot * CFrame.new(0, 3, 0)
        root.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    else
        print("NPC not found: " .. tostring(actualName))
    end
end

local function Clean(str)
    return str:gsub("%s+", ""):lower()
end

local function GetToolTypeFromModule(toolName)
    local cleanedTarget = Clean(toolName)
    for manualName, toolType in pairs(Tables.ManualWeaponClass) do
        if Clean(manualName) == cleanedTarget then
            return toolType
        end
    end
    if Modules.WeaponClass and Modules.WeaponClass.Tools then
        for moduleName, toolType in pairs(Modules.WeaponClass.Tools) do
            if Clean(moduleName) == cleanedTarget then
                return toolType
            end
        end
    end
    if toolName:lower():find("fruit") then
        return "Power"
    end
    return "Melee"
end

local function GetWeaponsByType()
    local available = {}
    local enabledTypes = Options.SelectedWeaponType.Value or {}
    local char = GetCharacter()
    local containers = {Plr.Backpack}
    if char then table.insert(containers, char) end
    for _, container in ipairs(containers) do
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local toolType = GetToolTypeFromModule(tool.Name)
                if enabledTypes[toolType] then
                    if not table.find(available, tool.Name) then
                        table.insert(available, tool.Name)
                    end
                end
            end
        end
    end
    return available
end

local function UpdateWeaponRotation()
    local weaponList = GetWeaponsByType()
    if #weaponList == 0 then 
        Shared.ActiveWeap = "" 
        return 
    end
    local switchDelay = Options.SwitchWeaponCD.Value or 4
    if tick() - Shared.LastWRSwitch >= switchDelay then
        Shared.WeapRotationIdx = Shared.WeapRotationIdx + 1
        if Shared.WeapRotationIdx > #weaponList then Shared.WeapRotationIdx = 1 end
        Shared.ActiveWeap = weaponList[Shared.WeapRotationIdx]
        Shared.LastWRSwitch = tick()
    end
    local exists = false
    for _, name in ipairs(weaponList) do
        if name == Shared.ActiveWeap then exists = true break end
    end
    if not exists then
        Shared.ActiveWeap = weaponList[1]
    end
end

local function EquipWeapon()
    UpdateWeaponRotation()
    if Shared.ActiveWeap == "" then return end
    local char = GetCharacter()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if char:FindFirstChild(Shared.ActiveWeap) then return end 
    local tool = Plr.Backpack:FindFirstChild(Shared.ActiveWeap) or char:FindFirstChild(Shared.ActiveWeap)
    if tool then 
        hum:EquipTool(tool) 
    end
end

local function CheckObsHaki()
    local PlayerGui = Plr:FindFirstChild("PlayerGui")
    if PlayerGui then
        local DodgeUI = PlayerGui:FindFirstChild("DodgeCounterUI")
        if DodgeUI and DodgeUI:FindFirstChild("MainFrame") then
            return DodgeUI.MainFrame.Visible
        end
    end
    return false
end

local function CheckArmHaki()
    if Shared.ArmHaki == true then 
        return true 
    end
    local char = GetCharacter()
    if char then
        local leftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
        local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
        local hasVisual = (leftArm and leftArm:FindFirstChild("Lightning Strike")) or (rightArm and rightArm:FindFirstChild("Lightning Strike"))
        if hasVisual then
            Shared.ArmHaki = true
            return true
        end
    end
    return false
end

local function IsBusy()
    return Plr.Character and Plr.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function IsSkillReady(key)
    local char = GetCharacter()
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return true end
    local mainFrame = PGui:FindFirstChild("CooldownUI") and PGui.CooldownUI:FindFirstChild("MainFrame")
    if not mainFrame then return true end
    local cleanTool = Clean(tool.Name)
    for _, frame in pairs(mainFrame:GetChildren()) do
        if not frame:IsA("Frame") then continue end
        local fname = frame.Name:lower()
        if fname:find("cooldown") and (fname:find(cleanTool) or fname:find("skill")) then
            local mapped = "none"
            if fname:find("skill 1") or fname:find("_z") then mapped = "Z"
            elseif fname:find("skill 2") or fname:find("_x") then mapped = "X"
            elseif fname:find("skill 3") or fname:find("_c") then mapped = "C"
            elseif fname:find("skill 4") or fname:find("_v") then mapped = "V"
            elseif fname:find("skill 5") or fname:find("_f") then mapped = "F" end
            if mapped == key then
                local cdLabel = frame:FindFirstChild("WeaponNameAndCooldown", true)
                return (cdLabel and cdLabel.Text:find("Ready"))
            end
        end
    end
    return true
end

local function GetSecondsFromTimer(text)
    local min, sec = text:match("(%d+):(%d+)")
    if min and sec then
        return (tonumber(min) * 60) + tonumber(sec)
    end
    return nil
end

local function FormatSecondsToTimer(s)
    local minutes = math.floor(s / 60)
    local seconds = s % 60
    return string.format("Refresh: %02d:%02d", minutes, seconds)
end

local function OpenMerchantInterface()
    if isXeno then
        local npc = workspace:FindFirstChild("ServiceNPCs") and workspace.ServiceNPCs:FindFirstChild("MerchantNPC")
        local prompt = npc and npc:FindFirstChild("HumanoidRootPart") and npc.HumanoidRootPart:FindFirstChild("MerchantPrompt")
        if prompt then
            local char = GetCharacter()
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local oldCF = root.CFrame
                root.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                task.wait(0.2)
                if Support.Proximity then
                    fireproximityprompt(prompt)
                else
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration + 0.1)
                    prompt:InputHoldEnd()
                end
                task.wait(0.5)
                root.CFrame = oldCF
            end
        end
    else
        if firesignal then
            firesignal(Remotes.OpenMerchant.OnClientEvent)
        elseif getconnections then
            for _, v in pairs(getconnections(Remotes.OpenMerchant.OnClientEvent)) do
                if v.Function then task.spawn(v.Function) end
            end
        end
    end
end

local function SyncRaceSettings()
    if not Toggles.AutoRace.Value then return end
    pcall(function()
        local selected = Options.SelectedRace.Value or {}
        local hasEpic = false
        local hasLegendary = false
        for name, data in pairs(Modules.Race.Races) do
            local rarity = data.rarity or data.Rarity
            if rarity == "Mythical" then
                local shouldSkip = not selected[name]
                if Shared.Settings["SkipRace_" .. name] ~= shouldSkip then
                    Remotes.SettingsToggle:FireServer("SkipRace_" .. name, shouldSkip)
                end
            end
            if selected[name] then
                if rarity == "Epic" then hasEpic = true end
                if rarity == "Legendary" then hasLegendary = true end
            end
        end
        if Shared.Settings["SkipEpicReroll"] ~= not hasEpic then
            Remotes.SettingsToggle:FireServer("SkipEpicReroll", not hasEpic)
        end
        if Shared.Settings["SkipLegendaryReroll"] ~= not hasLegendary then
            Remotes.SettingsToggle:FireServer("SkipLegendaryReroll", not hasLegendary)
        end
    end)
end

local function SyncClanSettings()
    if not Toggles.AutoClan.Value then return end
    pcall(function()
        local selected = Options.SelectedClan.Value or {}
        local hasEpic = false
        local hasLegendary = false
        for name, data in pairs(Modules.Clan.Clans) do
            local rarity = data.rarity or data.Rarity
            if rarity == "Legendary" then
                local shouldSkip = not selected[name]
                if Shared.Settings["SkipClan_" .. name] ~= shouldSkip then
                    Remotes.SettingsToggle:FireServer("SkipClan_" .. name, shouldSkip)
                end
            end
            if selected[name] then
                if rarity == "Epic" then hasEpic = true end
                if rarity == "Legendary" then hasLegendary = true end
            end
        end
        if Shared.Settings["SkipEpicClan"] ~= not hasEpic then
            Remotes.SettingsToggle:FireServer("SkipEpicClan", not hasEpic)
        end
        if Shared.Settings["SkipLegendaryClan"] ~= not hasLegendary then
            Remotes.SettingsToggle:FireServer("SkipLegendaryClan", not hasLegendary)
        end
    end)
end

local function SyncSpecPassiveAutoSkip()
    local skipData = { ["Epic"] = true, ["Legendary"] = true, ["Mythical"] = true }
    pcall(function()
        local remote = Remotes.SpecPassiveSkip
        if remote then
            remote:FireServer(skipData)
        end
    end)
end

local function SyncTraitAutoSkip()
    if not Toggles.AutoTrait.Value then return end
    pcall(function()
        local selected = Options.SelectedTrait.Value or {}
        local rarityHierarchy = { ["Epic"] = 1, ["Legendary"] = 2, ["Mythical"] = 3, ["Secret"] = 4 }
        local lowestTargetValue = 99
        for traitName, enabled in pairs(selected) do
            if enabled then
                local data = Modules.Trait.Traits[traitName]
                if data then
                    local val = rarityHierarchy[data.Rarity] or 0
                    if val > 0 and val < lowestTargetValue then
                        lowestTargetValue = val
                    end
                end
            end
        end
        if lowestTargetValue == 99 then return end
        local skipData = { ["Epic"] = 1 < lowestTargetValue, ["Legendary"] = 2 < lowestTargetValue, ["Mythical"] = 3 < lowestTargetValue, ["Secret"] = 4 < lowestTargetValue }
        Remotes.TraitAutoSkip:FireServer(skipData)
    end)
end

local function GetMatches(data, subStatFilter)
    local count = 0
    for _, sub in pairs(data.Substats or {}) do
        if subStatFilter[sub.Stat] then
            count = count + 1
        end
    end
    return count
end

local function AutoEquipArtifacts()
    if not Toggles.ArtifactEquip.Value then return end
    local bestItems = { Helmet = nil, Gloves = nil, Body = nil, Boots = nil }
    local bestScores = { Helmet = -1, Gloves = -1, Body = -1, Boots = -1 }
    local targetTypes = Options.Eq_Type.Value or {}
    local targetMS = Options.Eq_MS.Value or {}
    local targetSS = Options.Eq_SS.Value or {}
    for uuid, data in pairs(Shared.ArtifactSession.Inventory) do
        if targetTypes[data.Category] then
            local score = (GetMatches(data, targetSS) * 10) + data.Level
            if score > bestScores[data.Category] then
                bestScores[data.Category] = score
                bestItems[data.Category] = {UUID = uuid, Equipped = data.Equipped}
            end
        end
    end
    for category, item in pairs(bestItems) do
        if item and not item.Equipped then
            Remotes.ArtifactEquip:FireServer(item.UUID)
            task.wait(0.2)
        end
    end
end

local function IsStrictBossMatch(npcName, targetDisplayName)
    local n = npcName:lower():gsub("%s+", "")
    local t = targetDisplayName:lower():gsub("%s+", "")
    if n:find("true") and not t:find("true") then return false end
    if t:find("strongest") then
        local era = t:find("history") and "history" or "today"
        return n:find("strongest") and n:find(era)
    end
    return n:find(t)
end

local function FireBossRemote(bossName, diff)   
    local lowerName = bossName:lower():gsub("%s+", "")
    local remoteArg = GetRemoteBossArg(bossName)
    table.clear(Shared.AltDamage)
    local function GetInternalSummonId(name)
        local cleanTarget = name:lower():gsub("%s+", "")
        for displayName, internalId in pairs(SummonMap) do
            if displayName:lower():gsub("%s+", "") == cleanTarget then
                return internalId
            end
        end
        return name:gsub("%s+", "") .. "Boss"
    end
    pcall(function()
        if lowerName:find("rimuru") then
            Remotes.RimuruBoss:FireServer(diff)
        elseif lowerName:find("anos") then
            Remotes.AnosBoss:FireServer("Anos", diff)
        elseif lowerName:find("trueaizen") then
            if Remotes.TrueAizenBoss then Remotes.TrueAizenBoss:FireServer(diff) end
        elseif lowerName:find("strongest") then
            Remotes.JJKSummonBoss:FireServer(remoteArg, diff)
        elseif lowerName:find("atomic") then
            Remotes.AtomicBoss:FireServer(diff)
        else
            local summonId = GetInternalSummonId(bossName)
            Remotes.SummonBoss:FireServer(summonId, diff)
        end
    end)
end

local function HandleSummons()
    if Shared.MerchantBusy then return end
    local function MatchName(name1, name2)
        if not name1 or not name2 then return false end
        return name1:lower():gsub("%s+", "") == name2:lower():gsub("%s+", "")
    end
    local function IsSummonable(name)
        local cleanName = name:lower():gsub("%s+", "")
        for _, boss in ipairs(Tables.SummonList) do
            if MatchName(boss, cleanName) then return true end
        end
        for _, boss in ipairs(Tables.OtherSummonList) do
            if MatchName(boss, cleanName) then return true end
        end
        return false
    end
    if Toggles.PityBossFarm.Value then
        local current, max = GetCurrentPity()
        local buildOptions = Options.SelectedBuildPity.Value or {} 
        local useName = Options.SelectedUsePity.Value 
        if useName and next(buildOptions) then
            local isUseTurn = (current >= (max - 1))
            if isUseTurn then
                local found = false
                for _, v in pairs(PATH.Mobs:GetChildren()) do
                    if MatchName(v.Name, useName) or v.Name:lower():find(useName:lower():gsub("%s+", "")) then
                        found = true break
                    end
                end
                if not found and IsSummonable(useName) then
                    FireBossRemote(useName, Options.SelectedPityDiff.Value or "Normal")
                    task.wait(0.5)
                    return 
                end
            else
                local anyBuildBossSpawned = false
                for bossName, enabled in pairs(buildOptions) do
                    if enabled then
                        for _, v in pairs(PATH.Mobs:GetChildren()) do
                            if MatchName(v.Name, bossName) or v.Name:lower():find(bossName:lower():gsub("%s+", "")) then
                                anyBuildBossSpawned = true
                                break
                            end
                        end
                    end
                    if anyBuildBossSpawned then break end
                end
                if not anyBuildBossSpawned then
                    for bossName, enabled in pairs(buildOptions) do
                        if enabled and IsSummonable(bossName) then
                            FireBossRemote(bossName, "Normal")
                            task.wait(0.5)
                            return 
                        end
                    end
                end
            end
        end
    end
    if Toggles.AutoOtherSummon.Value then
        local selected = Options.SelectedOtherSummon.Value
        local diff = Options.SelectedOtherSummonDiff.Value
        if selected and diff then
            local keyword = selected:gsub("Strongest", ""):lower()
            local found = false
            for _, v in pairs(PATH.Mobs:GetChildren()) do
                local npcName = v.Name:lower()
                if npcName:find(selected:lower()) or (npcName:find("strongest") and npcName:find(keyword)) then
                    found = true break
                end
            end
            if not found then
                FireBossRemote(selected, diff)
                task.wait(0.5)
            end
        end
    end
    if Toggles.AutoSummon.Value then
        local selected = Options.SelectedSummon.Value
        if selected then
            local found = false
            for _, v in pairs(PATH.Mobs:GetChildren()) do
                if IsStrictBossMatch(v.Name, selected) then
                    found = true break
                end
            end
            if not found then
                FireBossRemote(selected, Options.SelectedSummonDiff.Value or "Normal")
                task.wait(0.5)
            end
        end
    end
end

local function UpdateSwitchState(target, farmType)
    if Shared.GlobalPrio == "COMBO" then return end
    local types = {
        { id = "Title", remote = Remotes.EquipTitle, method = function(val) return val end },
        { id = "Rune", remote = Remotes.EquipRune, method = function(val) return {"Equip", val} end },
        { id = "Build", remote = Remotes.LoadoutLoad, method = function(val) return tonumber(val) end }
    }
    for _, switch in ipairs(types) do
        local toggleObj = Toggles["Auto"..switch.id]
        if not (toggleObj and toggleObj.Value) then continue end
        if switch.id == "Build" and tick() - Shared.LastBuildSwitch < 3.1 then continue end
        local toEquip = ""
        local threshold = Options[switch.id.."_BossHPAmt"].Value
        local isLow = false
        if farmType == "Boss" and target then
            local hum = target:FindFirstChildOfClass("Humanoid")
            if hum and (hum.Health / hum.MaxHealth) * 100 <= threshold then
                isLow = true
            end
        end
        if farmType == "None" then toEquip = Options["Default"..switch.id].Value
        elseif farmType == "Mob" then toEquip = Options[switch.id.."_Mob"].Value
        elseif farmType == "Boss" then toEquip = isLow and Options[switch.id.."_BossHP"].Value or Options[switch.id.."_Boss"].Value end
        if not toEquip or toEquip == "" or toEquip == "None" then continue end
        local finalEquipValue = toEquip
        if switch.id == "Title" and toEquip:find("Best ") then
            local bestId = GetBestOwnedTitle(toEquip)
            if bestId then finalEquipValue = bestId else continue end
        end
        if finalEquipValue ~= Shared.LastSwitch[switch.id] then
            local args = switch.method(finalEquipValue)
            pcall(function()
                if type(args) == "table" then 
                    switch.remote:FireServer(unpack(args))
                else 
                    switch.remote:FireServer(args) 
                end
            end)
            Shared.LastSwitch[switch.id] = finalEquipValue
            if switch.id == "Build" then
                Shared.LastBuildSwitch = tick()
            end
        end
    end
end

local function UniversalPuzzleSolver(puzzleType)
    local moduleMap = { ["Dungeon"] = RS.Modules:FindFirstChild("DungeonConfig"), ["Slime"] = RS.Modules:FindFirstChild("SlimePuzzleConfig") }
    local targetModule = moduleMap[puzzleType]
    if not targetModule then return end
    local data = require(targetModule)
    local settings = data.PuzzleSettings or data.PieceSettings
    local piecesToCollect = data.Pieces or settings.IslandOrder
    local pieceModelName = settings and settings.PieceModelName or "DungeonPuzzlePiece"
    print("Starting " .. puzzleType .. " Puzzle...")
    for i, islandOrPiece in ipairs(piecesToCollect) do
        local piece = nil
        local tpTarget = nil
        tpTarget = islandOrPiece:gsub("Island", ""):gsub("Station", "")
        if islandOrPiece == "HuecoMundo" then tpTarget = "HuecoMundo" end
        if tpTarget then
            Remotes.TP_Portal:FireServer(tpTarget)
            task.wait(2.5)
        end
        if puzzleType == "Slime" and i == #piecesToCollect then
            local char = GetCharacter()
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                Remotes.TP_Portal:FireServer("Shinjuku")
                task.wait(2)
                Remotes.TP_Portal:FireServer("Slime")
                task.wait(2)
                root.CFrame = CFrame.new(788, 68, -2309)
                task.wait(1.5)
            end
        end
        local islandFolder = workspace:FindFirstChild(islandOrPiece)
        piece = islandFolder and islandFolder:FindFirstChild(pieceModelName, true) or workspace:FindFirstChild(pieceModelName, true)
        if piece then
            HybridMove(piece:GetPivot() * CFrame.new(0, 3, 0))
            task.wait(0.5)
            local prompt = piece:FindFirstChildOfClass("ProximityPrompt") or piece:FindFirstChild("PuzzlePrompt", true) or piece:FindFirstChild("ProximityPrompt", true)
            if prompt then
                fireproximityprompt(prompt)
                print(string.format("Collected Piece %d/%d", i, #piecesToCollect))
                task.wait(1.5)
            else
                print("Found piece but no interaction prompt was detected.")
            end
        else
            print("Failed to find piece " .. i .. " on " .. tostring(tpTarget or "Island"))
        end
    end
    print(puzzleType .. " Puzzle Completed!")
end

local function IsValidTarget(npc)
    if not npc or not npc.Parent then return false end
    local hum = npc:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

local function GetBestMobCluster(mobNamesDictionary)
    local allMobs = {}
    local clusterRadius = 35
    if type(mobNamesDictionary) ~= "table" then return nil end
    for _, npc in pairs(PATH.Mobs:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
            local cleanName = npc.Name:gsub("%d+$", "")
            if mobNamesDictionary[cleanName] and IsValidTarget(npc) then
                table.insert(allMobs, npc)
            end
        end
    end
    if #allMobs == 0 then return nil end
    local bestMob = allMobs[1]
    local maxNearby = 0
    for _, mobA in ipairs(allMobs) do
        local nearbyCount = 0
        local posA = mobA:GetPivot().Position
        for _, mobB in ipairs(allMobs) do
            if (posA - mobB:GetPivot().Position).Magnitude <= clusterRadius then
                nearbyCount = nearbyCount + 1
            end
        end
        if nearbyCount > maxNearby then
            maxNearby = nearbyCount
            bestMob = mobA
        end
    end
    return bestMob, maxNearby
end

local function GetMobTarget()
    if not Toggles.MobFarm.Value then return nil end
    local selectedDict = Options.SelectedMob.Value or {}
    local enabledMobs = {}
    for mob, enabled in pairs(selectedDict) do
        if enabled then table.insert(enabledMobs, mob) end
    end
    if #enabledMobs == 0 then return nil end
    if Shared.MobIdx > #enabledMobs then Shared.MobIdx = 1 end
    local targetMobName = enabledMobs[Shared.MobIdx]
    local target, count = GetBestMobCluster({[targetMobName] = true})
    if target then
        local island = GetNearestIsland(target:GetPivot().Position, target.Name)
        return target, island, "Mob"
    else
        Shared.MobIdx = Shared.MobIdx + 1
        return nil
    end
end

local function GetWorldBossTarget()
    if not Toggles.BossesFarm.Value then return nil end
    local selected = Options.SelectedBosses.Value or {}
    for bossDisplayName, isEnabled in pairs(selected) do
        if isEnabled then
            for _, npc in pairs(PATH.Mobs:GetChildren()) do
                if IsStrictBossMatch(npc.Name, bossDisplayName) then
                    if IsValidTarget(npc) then
                        local island = Shared.BossTIMap[bossDisplayName] or "Boss"
                        return npc, island, "Boss"
                    end
                end
            end
        end
    end
    return nil
end

local function GetSummonTarget()
    if not Toggles.SummonBossFarm.Value then return nil end
    local selected = Options.SelectedSummon.Value
    if not selected then return nil end
    local workspaceName = SummonMap[selected] or (selected .. "Boss")
    for _, npc in pairs(PATH.Mobs:GetChildren()) do
        if npc.Name:lower():find(workspaceName:lower()) then
            if IsValidTarget(npc) then
                return npc, "Boss", "Boss"
            end
        end
    end
    return nil
end

local function GetOtherTarget()
    if not Toggles.OtherSummonFarm.Value then return nil end
    local selected = Options.SelectedOtherSummon.Value
    if not selected then return nil end
    local lowerSelected = selected:lower()
    for _, npc in pairs(PATH.Mobs:GetChildren()) do
        local name = npc.Name:lower()
        if name:find(lowerSelected) then
            if IsValidTarget(npc) then
                local island = GetNearestIsland(npc:GetPivot().Position, npc.Name)
                return npc, island, "Boss"
            end
        end
    end
    return nil
end

local function CheckTask(taskType)
    if taskType == "Merchant" then
        return nil
    elseif taskType == "Pity Boss" then
        return nil
    elseif taskType == "Summon [Other]" then
        return GetOtherTarget()
    elseif taskType == "Summon" then
        return GetSummonTarget()
    elseif taskType == "Boss" then
        return GetWorldBossTarget()
    elseif taskType == "Level Farm" then
        return nil
    elseif taskType == "All Mob Farm" then
        return nil
    elseif taskType == "Mob" then
        return GetMobTarget()
    elseif taskType == "Alt Help" then
        return nil
    end
    return nil
end

local function ExecuteFarmLogic(target, island, farmType)
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not target or not root then return end
    if Shared.MovingIsland then return end
    Shared.Target = target
    if Toggles.IslandTP.Value then
        if island and island ~= "" and island ~= "Unknown" and island ~= Shared.Island then
            Shared.MovingIsland = true
            Remotes.TP_Portal:FireServer(island)
            task.wait(0.8)
            Shared.Island = island
            Shared.MovingIsland = false
            return
        end
    end
    local targetPos = target:GetPivot().Position
    local distVal = Options.Distance.Value or 10
    local finalPos = (target:GetPivot() * CFrame.new(0, 0, distVal)).Position
    local finalDestination = CFrame.lookAt(finalPos, targetPos)
    if (root.Position - finalPos).Magnitude > 0.1 then
        root.CFrame = finalDestination
    end
end

local function Func_AutoHaki()
    while task.wait(0.5) do
        if Toggles.ObserHaki.Value and not CheckObsHaki() then
            Remotes.ObserHaki:FireServer("Toggle")
        end
        if Toggles.ArmHaki.Value and not CheckArmHaki() then
            Remotes.ArmHaki:FireServer("Toggle")
        end
    end
end

local function Func_AutoM1()
    local m1Speed = Options.M1Speed.Value or 0.1
    while task.wait(m1Speed) do
        if Toggles.AutoM1.Value then
            Remotes.M1:FireServer()
        end
    end
end

local function Func_AutoSkill()
    local keyToSlot = { Z = 1, X = 2, C = 3, V = 4 }
    while task.wait(0.3) do
        if Toggles.AutoSkill.Value then
            for key, slot in pairs(keyToSlot) do
                if IsSkillReady(key) then
                    Remotes.UseSkill:FireServer(slot)
                    task.wait(0.1)
                end
            end
        end
    end
end

local function Func_AutoCombo()
    Shared.ComboIdx = 1
    while Toggles.AutoCombo.Value do
        task.wait(0.1)
        local rawPattern = Options.ComboPattern.Value
        if not rawPattern or rawPattern == "" then continue end
        Shared.ParsedCombo = {}
        for item in string.gmatch(rawPattern:upper():gsub("%s+", ""), "([^,>]+)") do
            table.insert(Shared.ParsedCombo, item)
        end
        if #Shared.ParsedCombo == 0 then continue end
        if Shared.ComboIdx > #Shared.ParsedCombo then Shared.ComboIdx = 1 end
        local currentAction = Shared.ParsedCombo[Shared.ComboIdx]
        local waitTime = tonumber(currentAction)
        if waitTime then
            task.wait(waitTime)
            Shared.ComboIdx = Shared.ComboIdx + 1
            continue
        end
        if IsSkillReady(currentAction) then
            local slot = ({ Z = 1, X = 2, C = 3, V = 4 })[currentAction] or 1
            Remotes.UseSkill:FireServer(slot)
            Shared.ComboIdx = Shared.ComboIdx + 1
            task.wait(0.2)
        else
            task.wait(0.2)
        end
    end
end

local function Func_AutoStats()
    local pointsPath = Plr:WaitForChild("Data"):WaitForChild("StatPoints")
    while task.wait(1) do
        if Toggles.AutoStats.Value then
            local availablePoints = pointsPath.Value
            if availablePoints > 0 then
                local selectedStats = Options.SelectedStats.Value
                for statName, enabled in pairs(selectedStats) do
                    if enabled then
                        Remotes.AddStat:FireServer(statName, availablePoints)
                        break
                    end
                end
            end
        end
        if not Toggles.AutoStats.Value then break end
    end
end

local function Func_AutoMerchant()
    local MerchantUI = UI.Merchant.Regular
    local function StartPurchaseSequence()
        if Shared.MerchantExecute then return end
        Shared.MerchantExecute = true
        OpenMerchantInterface()
        task.wait(2)
        local selectedItems = Options.SelectedMerchantItems.Value
        if selectedItems then
            for itemName, _ in pairs(selectedItems) do
                pcall(function() Remotes.MerchantBuy:InvokeServer(itemName, 99) end)
                task.wait(1)
            end
        end
        Shared.MerchantExecute = false
    end
    while Toggles.AutoMerchant.Value do
        task.spawn(StartPurchaseSequence)
        task.wait(60)
    end
end

local function Func_AutoChest()
    while task.wait(2) do
        if Toggles.AutoChest.Value then
            local selected = Options.SelectedChests.Value
            for rarityName, enabled in pairs(selected) do
                if enabled then
                    local fullName = rarityName .. " Chest"
                    pcall(function() Remotes.UseItem:FireServer("Use", fullName, 10000) end)
                    task.wait(1)
                end
            end
        end
        if not Toggles.AutoChest.Value then break end
    end
end

local function Func_AutoCraft()
    while task.wait(1) do
        if Toggles.AutoCraftItem.Value then
            local selected = Options.SelectedCraftItems.Value
            for _, item in pairs(Shared.Cached.Inv) do
                if selected["DivineGrail"] and item.name == "Broken Sword" and item.quantity >= 3 then
                    pcall(function() Remotes.GrailCraft:InvokeServer("DivineGrail", 1) end)
                    task.wait(0.5)
                end
                if selected["SlimeKey"] and item.name == "Slime Shard" and item.quantity >= 2 then
                    pcall(function() Remotes.SlimeCraft:InvokeServer("SlimeKey", 1) end)
                end
            end
        end
        if not Toggles.AutoCraftItem.Value then break end
    end
end

-- ============================================
-- VELARIS UI - PENGGANTI OBSIDIAN (FIXED)
-- ============================================

local VelarisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/dist/main.lua", true))()

local Window = VelarisUI:Window({
    Title = "celina",
    Footer = assetName .. " | by celina | LOVE YOU",
    Color = "Default",
    ShowUser = true,
    Search = true,
    Uitransparent = 0.15,
    Icon = tostring(theChosenOne),
    Config = { AutoSave = true, AutoLoad = true, ConfigFolder = "celina/SailorPiece/", AutoSaveFile = "Config" },
    DiscordSet = {
        Enable = true,
        Title = "DISCORD",
        Link = "https://discord.gg/qDccUkch9B",
        Icon = "lucide:disc"
    }
})

Window:Tag({ Title = "v1.0", Color = Color3.fromRGB(0, 208, 255) })

local TabsVel = {
    Information = Window:AddTab({ Name = "Information", Icon = "lucide:info" }),
    Priority = Window:AddTab({ Name = "Priority", Icon = "lucide:arrow-up-down" }),
    Main = Window:AddTab({ Name = "Main", Icon = "lucide:box" }),
    Automation = Window:AddTab({ Name = "Automation", Icon = "lucide:repeat-2" }),
    Artifact = Window:AddTab({ Name = "Artifact", Icon = "lucide:gem" }),
    Dungeon = Window:AddTab({ Name = "Dungeon", Icon = "lucide:door-open" }),
    Player = Window:AddTab({ Name = "Player", Icon = "lucide:user" }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "lucide:map-pin" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "lucide:apple" }),
    Config = Window:AddTab({ Name = "Config", Icon = "lucide:cog" }),
}

-- Information Tab
local InfoUserSec = TabsVel.Information:AddSection({ Title = "User", Open = true })
InfoUserSec:AddParagraph({ Title = "Executor", Content = (identifyexecutor and identifyexecutor() or "Unknown") })
InfoUserSec:AddParagraph({ Title = "Status", Content = isLimitedExecutor and "Semi-Working" or "Working" })
InfoUserSec:AddParagraph({ Title = "Type", Content = "Premium User" })
InfoUserSec:AddParagraph({ Title = "Time Left", Content = "Lifetime" })

local GameSec = TabsVel.Information:AddSection({ Title = "Game", Open = true })
GameSec:AddButton({ Title = "Redeem All Codes", Callback = function()
    local allCodes = Modules.Codes.Codes
    local playerLevel = Plr.Data.Level.Value
    for codeName, data in pairs(allCodes) do
        if playerLevel >= (data.LevelReq or 0) then
            Remotes.UseCode:InvokeServer(codeName)
            Window:Notify({ Title = "Code", Content = "Redeemed: " .. codeName, Duration = 3 })
            task.wait(2)
        end
    end
end })

local OthersSec = TabsVel.Information:AddSection({ Title = "Others", Open = true })
OthersSec:AddParagraph({ Title = "⚠️", Content = "If some features are disabled, it is because your executor lacks the required functions." })
OthersSec:AddButton({ Title = "Join Discord Server", Callback = function()
    local inviteCode = "qDccUkch9B"
    if request then
        pcall(function()
            request({ Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST", Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" }, Body = HttpService:JSONEncode({ cmd = "INVITE_BROWSER", args = { code = inviteCode }, nonce = HttpService:GenerateGUID(false) }) })
        end)
    end
end })

-- Priority Tab
local PrioritySec = TabsVel.Priority:AddSection({ Title = "Config", Open = true })
for i = 1, #PriorityTasks do
    PrioritySec:AddDropdown({ Title = "Priority " .. i, Options = PriorityTasks, Default = DefaultPriority[i], Callback = function(val) 
        if Options["SelectedPriority_" .. i] then
            Options["SelectedPriority_" .. i].Value = val
        end
    end })
end

-- MAIN TAB - Autofarm
local MainTabVel = TabsVel.Main
local AutofarmSec = MainTabVel:AddSection({ Title = "Autofarm", Open = true })
AutofarmSec:AddDropdown({ Title = "Select Mob(s)", Options = Tables.MobList, Multi = true, Callback = function(v) 
    if Options.SelectedMob then Options.SelectedMob.Value = v end
end })
AutofarmSec:AddButton({ Title = "Refresh Mobs", Callback = UpdateNPCLists })
AutofarmSec:AddToggle({ Title = "Mob Farm", Default = false, Callback = function(s) 
    if Toggles.MobFarm and Toggles.MobFarm.SetValue then Toggles.MobFarm:SetValue(s) end
end })

-- Boss Farm Section
local BossSec = MainTabVel:AddSection({ Title = "Boss Farm", Open = true })
BossSec:AddDropdown({ Title = "Select Bosses", Options = Tables.BossList, Multi = true, Callback = function(v) 
    if Options.SelectedBosses then Options.SelectedBosses.Value = v end
end })
BossSec:AddToggle({ Title = "Boss Farm", Default = false, Callback = function(s) 
    if Toggles.BossesFarm and Toggles.BossesFarm.SetValue then Toggles.BossesFarm:SetValue(s) end
end })
BossSec:AddDivider()
BossSec:AddDropdown({ Title = "Select Summon Boss", Options = Tables.SummonList, Callback = function(v) 
    if Options.SelectedSummon then Options.SelectedSummon.Value = v end
end })
BossSec:AddToggle({ Title = "Auto Summon", Default = false, Callback = function(s) 
    if Toggles.AutoSummon and Toggles.AutoSummon.SetValue then Toggles.AutoSummon:SetValue(s) end
end })

-- Movement Config Section
local MoveSec = MainTabVel:AddSection({ Title = "Movement", Open = true })
MoveSec:AddToggle({ Title = "Noclip", Default = false, Callback = function(s) 
    if Toggles.Noclip and Toggles.Noclip.SetValue then Toggles.Noclip:SetValue(s) end
end })
MoveSec:AddSlider({ Title = "WalkSpeed", Min = 16, Max = 250, Default = 16, Callback = function(v) 
    if Options.WSValue then Options.WSValue.Value = v end
    if Toggles.WS and Toggles.WS.SetValue then Toggles.WS:SetValue(true) end
end })

-- Automation Tab
local AutoTabVel = TabsVel.Automation

-- Haki Section
local HakiSec = AutoTabVel:AddSection({ Title = "Haki", Open = true })
HakiSec:AddToggle({ Title = "Auto Armament Haki", Default = false, Callback = function(s) 
    if Toggles.ArmHaki and Toggles.ArmHaki.SetValue then Toggles.ArmHaki:SetValue(s) end
end })
HakiSec:AddToggle({ Title = "Auto Observation Haki", Default = false, Callback = function(s) 
    if Toggles.ObserHaki and Toggles.ObserHaki.SetValue then Toggles.ObserHaki:SetValue(s) end
end })

-- Skills Section
local SkillSec = AutoTabVel:AddSection({ Title = "Skills", Open = true })
SkillSec:AddToggle({ Title = "Auto M1", Default = false, Callback = function(s) 
    if Toggles.AutoM1 and Toggles.AutoM1.SetValue then Toggles.AutoM1:SetValue(s) end
end })
SkillSec:AddToggle({ Title = "Auto Skill", Default = false, Callback = function(s) 
    if Toggles.AutoSkill and Toggles.AutoSkill.SetValue then Toggles.AutoSkill:SetValue(s) end
end })

-- Player Tab
local PlayerTabVel = TabsVel.Player
local SafetySec = PlayerTabVel:AddSection({ Title = "Safety", Open = true })
SafetySec:AddKeybind({ Title = "Panic Keybind", Value = "P", Callback = function() PanicStop() end })
SafetySec:AddToggle({ Title = "Anti AFK", Default = true, Callback = function(s) 
    if Toggles.AntiAFK and Toggles.AntiAFK.SetValue then Toggles.AntiAFK:SetValue(s) end
end })

-- Teleport Tab
local TeleTabVel = TabsVel.Teleport
local IslandSec = TeleTabVel:AddSection({ Title = "Island Teleport", Open = true })
IslandSec:AddDropdown({ Title = "Select Island", Options = Tables.IslandList, Callback = function(v) 
    if v and Remotes.TP_Portal then Remotes.TP_Portal:FireServer(v) end
end })

-- Config Tab
local ConfigTabVel = TabsVel.Config
local MenuSec = ConfigTabVel:AddSection({ Title = "Menu", Open = true })
MenuSec:AddKeybind({ Title = "Menu Keybind", Value = "U" })
MenuSec:AddButton({ Title = "Unload Script", Callback = function()
    getgenv().celina_Running = false
    if Shared then Shared.Farm = false end
end })

-- Start background threads
task.spawn(Func_AutoHaki)
task.spawn(Func_AutoM1)
task.spawn(Func_AutoSkill)
task.spawn(Func_AutoStats)
task.spawn(Func_AutoCombo)
task.spawn(Func_AutoMerchant)
task.spawn(Func_AutoChest)
task.spawn(Func_AutoCraft)

-- Farm loop
task.spawn(function()
    while getgenv().celina_Running do
        task.wait()
        if not Shared.Farm then 
            Shared.Target = nil 
            continue 
        end
        local foundTask = false
        for i = 1, #PriorityTasks do
            local taskName = Options["SelectedPriority_" .. i] and Options["SelectedPriority_" .. i].Value
            if not taskName then continue end
            local t, isl, fType = CheckTask(taskName)
            if t then
                foundTask = true
                Shared.Target = t
                ExecuteFarmLogic(t, isl, fType)
                local m1Delay = Options.M1Speed and Options.M1Speed.Value or 0.2
                if tick() - Shared.LastM1 >= m1Delay then
                    EquipWeapon()
                    Remotes.M1:FireServer()
                    Shared.LastM1 = tick()
                end
                break
            end
        end
        if not foundTask then
            Shared.Target = nil
        end
    end
end)

-- Anti AFK
task.spawn(function()
    while getgenv().celina_Running do
        task.wait(60)
        if Toggles.AntiAFK and Toggles.AntiAFK.Value then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

UpdateNPCLists()

Window:Notify({ Title = "celina", Content = "Script loaded with Velaris UI!", Duration = 5 })

end) -- penutup pcall

if not eh_success then
    warn("ERROR: " .. tostring(err))
end
