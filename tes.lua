--// =========================================================
--// Oil Empire Admin Menu - Velaris UI Style
--// =========================================================

math.randomseed(tick())

--// UI Library (Velaris - sama kayak tesvd.lua)
local VelarisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/dist/main.lua", true))()

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

--// Player References
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--// Game References
local GasPriceValue = ReplicatedStorage:WaitForChild("GasPrice")
local SellRemote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("Knit")
    :WaitForChild("Services")
    :WaitForChild("BaseService")
    :WaitForChild("RE")
    :WaitForChild("SellGas")

local PurchaseRemote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("Knit")
    :WaitForChild("Services")
    :WaitForChild("StoresService")
    :WaitForChild("RE")
    :WaitForChild("Purchase")

local PlotsFolder = Workspace:WaitForChild("Plots")

--// Defaults
local DefaultWalkSpeed = Humanoid.WalkSpeed
local DefaultJumpPower = Humanoid.JumpPower

--// Player Identity
local UsernameLower = string.lower(LocalPlayer.Name)
local DisplayNameLower = string.lower(LocalPlayer.DisplayName)

--// State
local SpeedEnabled = false
local JumpEnabled = false
local CurrentSpeed = DefaultWalkSpeed
local CurrentJump = DefaultJumpPower

local AutoSellEnabled = false
local AutoSellLimitEnabled = false
local AutoSellPriceTarget = 1
local AutoSellLoopId = 0

local AutoCollectGasEnabled = false
local AutoCollectLoopId = 0

local InstantStealEnabled = false
local AutoReturnAfterStealEnabled = true

local BestRefineryESPEnabled = false

--// Drill State
local DrillPurchaseEnabled = {}
local DrillPurchaseLoopIds = {}
local DrillPurchaseDelay = 0.15

--// Storage
local OriginalStealDurations = {}
local StealPromptConnections = {}

--// Drawing / ESP
local BestRefineryLine = Drawing.new("Line")
BestRefineryLine.Visible = false
BestRefineryLine.Thickness = 2
BestRefineryLine.Color = Color3.fromRGB(255, 0, 0)
BestRefineryLine.Transparency = 1

local BestRefineryText = Drawing.new("Text")
BestRefineryText.Visible = false
BestRefineryText.Size = 16
BestRefineryText.Center = true
BestRefineryText.Outline = true
BestRefineryText.Color = Color3.fromRGB(255, 0, 0)
BestRefineryText.Transparency = 1
BestRefineryText.Text = ""

local BestRefineryESPConnection = nil

--// =========================================================
--// Character Helpers
--// =========================================================

local function refreshCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end

local function applyMovementValues()
    if not Humanoid then
        return
    end

    Humanoid.WalkSpeed = SpeedEnabled and CurrentSpeed or DefaultWalkSpeed
    Humanoid.JumpPower = JumpEnabled and CurrentJump or DefaultJumpPower
end

local function safeTeleportToPosition(position)
    refreshCharacter()

    if not HumanoidRootPart or not position then
        return false
    end

    local success = pcall(function()
        HumanoidRootPart.CFrame = CFrame.new(position)
    end)

    return success
end

--// =========================================================
--// Utility Helpers
--// =========================================================

local function normalizeText(value)
    value = tostring(value or "")
    value = string.lower(value)
    value = value:gsub("^%s+", "")
    value = value:gsub("%s+$", "")
    return value
end

local function parseNumericValue(rawValue)
    if typeof(rawValue) == "number" then
        return rawValue
    end

    if typeof(rawValue) == "string" then
        local cleaned = rawValue:gsub("[%$,%s,]", "")
        return tonumber(cleaned)
    end

    return nil
end

local function getNumericGasPrice()
    return parseNumericValue(GasPriceValue.Value)
end

local function textMatchesLocalPlayer(text)
    local normalized = normalizeText(text)

    if normalized == "" then
        return false
    end

    if normalized == UsernameLower or normalized == DisplayNameLower then
        return true
    end

    if normalized == ("owner: " .. UsernameLower) then
        return true
    end

    if normalized == ("owner: " .. DisplayNameLower) then
        return true
    end

    if normalized == (UsernameLower .. "'s base") then
        return true
    end

    if normalized == (DisplayNameLower .. "'s base") then
        return true
    end

    if string.find(normalized, UsernameLower, 1, true) then
        return true
    end

    if string.find(normalized, DisplayNameLower, 1, true) then
        return true
    end

    return false
end

--// =========================================================
--// Plot Detection
--// =========================================================

local function getOwnerTextLabel(plot)
    if not plot then
        return nil
    end

    local ownerTag = plot:FindFirstChild("OwnerTag")
    if not ownerTag then
        return nil
    end

    local billboardGui = ownerTag:FindFirstChild("BillboardGui")
    if not billboardGui then
        return nil
    end

    local main = billboardGui:FindFirstChild("Main")
    if not main then
        return nil
    end

    local directLabel = main:FindFirstChild("TextLabel")
    if directLabel and directLabel:IsA("TextLabel") then
        return directLabel
    end

    for _, descendant in ipairs(main:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            return descendant
        end
    end

    return nil
end

local function getPlotOwnerText(plot)
    local label = getOwnerTextLabel(plot)
    return label and label.Text or nil
end

local function findOwnedPlot()
    for i = 1, 6 do
        local plot = PlotsFolder:FindFirstChild("Plot" .. i)
        if plot then
            local ownerText = getPlotOwnerText(plot)
            if ownerText and textMatchesLocalPlayer(ownerText) then
                return plot, ownerText
            end
        end
    end

    return nil, nil
end

--// =========================================================
--// Building Helpers
--// =========================================================

local function getTeleportPartFromBuilding(building)
    if not building then
        return nil
    end

    local primaryChild = building:FindFirstChild("Primary")
    if primaryChild and primaryChild:IsA("BasePart") then
        return primaryChild
    end

    if building:IsA("BasePart") then
        return building
    end

    if building:IsA("Model") then
        if building.PrimaryPart then
            return building.PrimaryPart
        end

        local preferredNames = {
            "Main",
            "Base",
            "Root",
            "HumanoidRootPart",
            "Hitbox"
        }

        for _, partName in ipairs(preferredNames) do
            local found = building:FindFirstChild(partName, true)
            if found and found:IsA("BasePart") then
                return found
            end
        end

        local firstPart = building:FindFirstChildWhichIsA("BasePart", true)
        if firstPart then
            return firstPart
        end
    end

    return nil
end

local function getAllOwnedPlotBuildings(plot)
    local results = {}

    if not plot then
        return results
    end

    local buildingsFolder = plot:FindFirstChild("Buildings")
    if not buildingsFolder then
        return results
    end

    for _, building in ipairs(buildingsFolder:GetChildren()) do
        local teleportPart = getTeleportPartFromBuilding(building)
        if teleportPart then
            table.insert(results, {
                Name = building.Name,
                Part = teleportPart
            })
        end
    end

    return results
end

local function getRandomOwnedBuildingPart(plot)
    local buildings = getAllOwnedPlotBuildings(plot)
    if #buildings == 0 then
        return nil
    end

    local randomIndex = math.random(1, #buildings)
    return buildings[randomIndex].Part
end

local function returnToOwnedBase()
    local ownedPlot = findOwnedPlot()
    if not ownedPlot then
        return false
    end

    local randomBuildingPart = getRandomOwnedBuildingPart(ownedPlot)
    if randomBuildingPart and randomBuildingPart.Parent then
        return safeTeleportToPosition(randomBuildingPart.Position + Vector3.new(0, 5, 0))
    end

    return false
end

local function getRefineryBuildingsForOwnedPlot(plot)
    local results = {}

    if not plot then
        return results
    end

    local buildingsFolder = plot:FindFirstChild("Buildings")
    if not buildingsFolder then
        return results
    end

    for _, building in ipairs(buildingsFolder:GetChildren()) do
        local buildingType = tostring(building:GetAttribute("Type") or ""):lower()

        if buildingType == "refinery" then
            local teleportPart = getTeleportPartFromBuilding(building)
            if teleportPart then
                table.insert(results, {
                    Name = building.Name,
                    Part = teleportPart
                })
            end
        end
    end

    table.sort(results, function(a, b)
        return a.Name < b.Name
    end)

    return results
end

--// =========================================================
--// Best Refinery Logic
--// =========================================================

local function isRefineryBuilding(building)
    if not building then
        return false
    end

    local buildingType = tostring(building:GetAttribute("Type") or ""):lower()
    return buildingType == "refinery"
end

local function getBuildingPrimaryContainer(building)
    if not building then
        return nil
    end

    local namedPrimary = building:FindFirstChild("Primary")
    if namedPrimary then
        return namedPrimary
    end

    if building:IsA("Model") and building.PrimaryPart then
        return building.PrimaryPart
    end

    return nil
end

local function parseRefineryCapacityText(text)
    if typeof(text) ~= "string" then
        return nil, nil
    end

    local cleaned = text:gsub("%$", ""):gsub("%s+", "")
    local left, right = cleaned:match("([^/]+)/([^/]+)")

    if not left or not right then
        return nil, nil
    end

    left = left:gsub(",", "")
    right = right:gsub(",", "")

    local currentAmount = tonumber(left)
    local maxAmount = tonumber(right)

    if not currentAmount or not maxAmount then
        return nil, nil
    end

    return currentAmount, maxAmount
end

local function getRefineryValueTextLabel(building)
    if not building then
        return nil
    end

    local primary = getBuildingPrimaryContainer(building)
    if not primary then
        return nil
    end

    local info = primary:FindFirstChild("Info")
    if not info then
        return nil
    end

    local main = info:FindFirstChild("Main")
    if not main then
        return nil
    end

    local valueObject = main:FindFirstChild("Value")
    if not valueObject then
        return nil
    end

    if valueObject:IsA("TextLabel") or valueObject:IsA("TextButton") or valueObject:IsA("TextBox") then
        return valueObject
    end

    return nil
end

local function getRefineryAmounts(building)
    local valueLabel = getRefineryValueTextLabel(building)
    if not valueLabel then
        return nil, nil, nil
    end

    local rawText = valueLabel.Text
    local currentAmount, maxAmount = parseRefineryCapacityText(rawText)

    if not currentAmount or not maxAmount then
        return nil, nil, rawText
    end

    return currentAmount, maxAmount, rawText
end

local function getBestRefinery()
    local bestBuilding = nil
    local bestPart = nil
    local bestPlot = nil
    local bestCurrent = nil
    local bestMax = nil
    local bestRawText = nil

    for i = 1, 6 do
        local plot = PlotsFolder:FindFirstChild("Plot" .. i)
        if plot then
            local buildingsFolder = plot:FindFirstChild("Buildings")
            if buildingsFolder then
                for _, building in ipairs(buildingsFolder:GetChildren()) do
                    if isRefineryBuilding(building) then
                        local targetPart = getTeleportPartFromBuilding(building)
                        local currentAmount, maxAmount, rawText = getRefineryAmounts(building)

                        if targetPart and maxAmount then
                            if bestMax == nil or maxAmount > bestMax then
                                bestBuilding = building
                                bestPart = targetPart
                                bestPlot = plot
                                bestCurrent = currentAmount
                                bestMax = maxAmount
                                bestRawText = rawText
                            end
                        end
                    end
                end
            end
        end
    end

    return bestBuilding, bestPart, bestPlot, bestCurrent, bestMax, bestRawText
end

--// =========================================================
--// Best Refinery ESP
--// =========================================================

local function hideBestRefineryESP()
    BestRefineryLine.Visible = false
    BestRefineryText.Visible = false
end

local function stopBestRefineryESP()
    BestRefineryESPEnabled = false

    if BestRefineryESPConnection then
        BestRefineryESPConnection:Disconnect()
        BestRefineryESPConnection = nil
    end

    hideBestRefineryESP()
end

local function updateBestRefineryESP()
    if not BestRefineryESPEnabled then
        hideBestRefineryESP()
        return
    end

    refreshCharacter()

    if not Camera or not HumanoidRootPart then
        hideBestRefineryESP()
        return
    end

    local bestBuilding, bestPart, bestPlot, bestCurrent, bestMax, bestRawText = getBestRefinery()
    if not bestBuilding or not bestPart or not bestPlot or not bestMax then
        hideBestRefineryESP()
        return
    end

    local fromWorld = HumanoidRootPart.Position + Vector3.new(0, 2, 0)
    local toWorld = bestPart.Position + Vector3.new(0, 2, 0)

    local fromScreen, fromVisible = Camera:WorldToViewportPoint(fromWorld)
    local toScreen, toVisible = Camera:WorldToViewportPoint(toWorld)

    if not fromVisible or not toVisible then
        hideBestRefineryESP()
        return
    end

    BestRefineryLine.From = Vector2.new(fromScreen.X, fromScreen.Y)
    BestRefineryLine.To = Vector2.new(toScreen.X, toScreen.Y)
    BestRefineryLine.Visible = true

    BestRefineryText.Text = string.format(
        "Best Refinery: %s | %s | %s",
        tostring(bestPlot.Name),
        tostring(bestBuilding.Name),
        tostring(bestRawText or (tostring(bestCurrent) .. "/" .. tostring(bestMax)))
    )
    BestRefineryText.Position = Vector2.new(toScreen.X, toScreen.Y - 20)
    BestRefineryText.Visible = true
end

local function startBestRefineryESP()
    if BestRefineryESPConnection then
        BestRefineryESPConnection:Disconnect()
        BestRefineryESPConnection = nil
    end

    BestRefineryESPEnabled = true
    BestRefineryESPConnection = RunService.RenderStepped:Connect(updateBestRefineryESP)
end

--// =========================================================
--// Auto Sell
--// =========================================================

local function shouldAutoSellNow()
    if not AutoSellEnabled then
        return false
    end

    if not AutoSellLimitEnabled then
        return true
    end

    local gasPrice = getNumericGasPrice()
    if gasPrice == nil then
        return false
    end

    return gasPrice >= AutoSellPriceTarget
end

local function startAutoSellLoop()
    AutoSellLoopId = AutoSellLoopId + 1
    local thisLoopId = AutoSellLoopId

    task.spawn(function()
        while AutoSellEnabled and thisLoopId == AutoSellLoopId do
            if shouldAutoSellNow() then
                pcall(function()
                    SellRemote:FireServer()
                end)
            end

            task.wait(0.5)
        end
    end)
end

--// =========================================================
--// Auto Collect Gas
--// =========================================================

local function startAutoCollectLoop()
    AutoCollectLoopId = AutoCollectLoopId + 1
    local thisLoopId = AutoCollectLoopId

    task.spawn(function()
        while AutoCollectGasEnabled and thisLoopId == AutoCollectLoopId do
            local ownedPlot = findOwnedPlot()

            if ownedPlot then
                local refineryBuildings = getRefineryBuildingsForOwnedPlot(ownedPlot)

                for _, info in ipairs(refineryBuildings) do
                    if not AutoCollectGasEnabled or thisLoopId ~= AutoCollectLoopId then
                        break
                    end

                    if info.Part and info.Part.Parent then
                        safeTeleportToPosition(info.Part.Position + Vector3.new(0, 4, 0))
                        task.wait(0.35)
                    end
                end
            end

            task.wait(0.75)
        end
    end)
end

--// =========================================================
--// Instant Steal + Auto Return After Steal
--// =========================================================

local function setStealPromptHoldDuration(prompt, duration)
    if prompt and prompt:IsA("ProximityPrompt") then
        pcall(function()
            prompt.HoldDuration = duration
        end)
    end
end

local function bindStealPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return
    end

    if StealPromptConnections[prompt] then
        return
    end

    StealPromptConnections[prompt] = prompt.Triggered:Connect(function(player)
        if player ~= LocalPlayer then
            return
        end

        if not AutoReturnAfterStealEnabled then
            return
        end

        task.defer(function()
            task.wait(0.2)
            returnToOwnedBase()
        end)
    end)
end

local function unbindStealPrompt(prompt)
    local connection = StealPromptConnections[prompt]
    if connection then
        connection:Disconnect()
        StealPromptConnections[prompt] = nil
    end
end

local function scanBuildingForStealPrompts(building)
    if not building then
        return
    end

    for _, descendant in ipairs(building:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "Steal" then
            if OriginalStealDurations[descendant] == nil then
                OriginalStealDurations[descendant] = descendant.HoldDuration
            end

            bindStealPrompt(descendant)

            if InstantStealEnabled then
                setStealPromptHoldDuration(descendant, 0)
            else
                local original = OriginalStealDurations[descendant]
                if original ~= nil then
                    setStealPromptHoldDuration(descendant, original)
                end
            end
        end
    end
end

local function cleanupDeadStealPrompts()
    for prompt, _ in pairs(OriginalStealDurations) do
        if prompt == nil or prompt.Parent == nil then
            OriginalStealDurations[prompt] = nil
        end
    end

    for prompt, connection in pairs(StealPromptConnections) do
        if prompt == nil or prompt.Parent == nil then
            if connection then
                connection:Disconnect()
            end
            StealPromptConnections[prompt] = nil
        end
    end
end

local function refreshInstantSteal()
    cleanupDeadStealPrompts()

    for _, plot in ipairs(PlotsFolder:GetChildren()) do
        local buildingsFolder = plot:FindFirstChild("Buildings")
        if buildingsFolder then
            for _, building in ipairs(buildingsFolder:GetChildren()) do
                scanBuildingForStealPrompts(building)
            end
        end
    end
end

local function bindAllStealPrompts()
    for _, descendant in ipairs(PlotsFolder:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "Steal" then
            bindStealPrompt(descendant)
        end
    end
end

--// =========================================================
--// Drill Purchase Helpers
--// =========================================================

local DrillNames = {
    "Basic Drill",
    "Strong Drill",
    "Enhanced Drill",
    "Speed Drill",
    "Reinforced Drill",
    "Industrial Drill",
    "Double Industrial Drill",
    "Turbo Drill",
    "Mega Drill",
    "Mega Emerald Drill",
    "Hell Drill",
    "Plasma Drill",
    "Huge Long Drill",
    "Mega Plasma Drill",
    "Multi Drill",
    "Lava Drill",
    "Ice Plasma Drill",
    "Crystal Drill",
    "Diamond Drill",
    "Ruby Drill"
}

local function purchaseDrill(drillName)
    local args = {
        "DrillShop",
        drillName
    }

    pcall(function()
        PurchaseRemote:FireServer(unpack(args))
    end)
end

local function startDrillPurchaseLoop(drillName)
    DrillPurchaseLoopIds[drillName] = (DrillPurchaseLoopIds[drillName] or 0) + 1
    local thisLoopId = DrillPurchaseLoopIds[drillName]
    DrillPurchaseEnabled[drillName] = true

    task.spawn(function()
        while DrillPurchaseEnabled[drillName] and DrillPurchaseLoopIds[drillName] == thisLoopId do
            purchaseDrill(drillName)
            task.wait(DrillPurchaseDelay)
        end
    end)
end

local function stopDrillPurchaseLoop(drillName)
    DrillPurchaseEnabled[drillName] = false
    DrillPurchaseLoopIds[drillName] = (DrillPurchaseLoopIds[drillName] or 0) + 1
end

--// =========================================================
--// WINDOW VELARIS UI
--// =========================================================

local Window = VelarisUI:Window({
    Title = "Victoria Hub | Oil Empire",
    Footer = "Gennskie Development",
    Content = "Oil Empire",
    Color = "Blue",
    Version = "1.0",
    ["Tab Width"] = 120,
    Image = "96751490485303",
    Configname = "Victoriahub_OilEmpire",
    Uitransparent = 0.15,
    ShowUser = true,
    Search = true,
    Animation = true,
    TypeDelay = 0.07,
    TypePause = 2.5,
    Config = {
        AutoSave = true,
        AutoLoad = true
    },
    KeySystem = false
})

Window:Tag({
    Title = "v1.0 | Oil Empire",
    Color = Color3.fromRGB(255, 140, 0),
})

--// =========================================================
--// TABS
--// =========================================================

local Tabs = {
    Player = Window:AddTab({ Name = "Player", Icon = "lucide:user" }),
    Game = Window:AddTab({ Name = "Game", Icon = "lucide:fuel" }),
    Drills = Window:AddTab({ Name = "Drills", Icon = "lucide:drill" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "lucide:settings" }),
}

--// =========================================================
--// Player Tab
--// =========================================================

local secMovement = Tabs.Player:AddSection({ Title = "Movement", open = false })

secMovement:AddSlider({
    Name = "Speed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = DefaultWalkSpeed,
    Callback = function(Value)
        CurrentSpeed = Value
        if SpeedEnabled and Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end,
})

secMovement:AddToggle({
    Name = "Set Speed",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
        if Humanoid then
            Humanoid.WalkSpeed = Value and CurrentSpeed or DefaultWalkSpeed
        end
    end,
})

secMovement:AddSlider({
    Name = "JumpPower",
    Range = {50, 750},
    Increment = 5,
    CurrentValue = DefaultJumpPower,
    Callback = function(Value)
        CurrentJump = Value
        if JumpEnabled and Humanoid then
            Humanoid.JumpPower = Value
        end
    end,
})

secMovement:AddToggle({
    Name = "Set JumpPower",
    Default = false,
    Callback = function(Value)
        JumpEnabled = Value
        if Humanoid then
            Humanoid.JumpPower = Value and CurrentJump or DefaultJumpPower
        end
    end,
})

secMovement:AddButton({
    Name = "Reset Movement",
    Callback = function()
        SpeedEnabled = false
        JumpEnabled = false
        CurrentSpeed = DefaultWalkSpeed
        CurrentJump = DefaultJumpPower
        applyMovementValues()
        VelarisUI:MakeNotify({ Title = "Reset", Description = "Movement values reset!", Color = "Info", Time = 1 })
    end,
})

--// =========================================================
--// Game Tab
--// =========================================================

local secAutoSell = Tabs.Game:AddSection({ Title = "Auto Sell", open = false })

secAutoSell:AddToggle({
    Name = "Auto Sell",
    Default = false,
    Callback = function(Value)
        AutoSellEnabled = Value
        if Value then
            startAutoSellLoop()
        else
            AutoSellLoopId = AutoSellLoopId + 1
        end
    end,
})

secAutoSell:AddToggle({
    Name = "Enable Price Limit",
    Default = false,
    Callback = function(Value)
        AutoSellLimitEnabled = Value
    end,
})

secAutoSell:AddSlider({
    Name = "Sell At Price",
    Range = {1, 20},
    Increment = 1,
    Suffix = "$",
    CurrentValue = 1,
    Callback = function(Value)
        AutoSellPriceTarget = Value
    end,
})

-- Info Labels
local gasPriceLabel = Tabs.Game:AddLabel("Current GasPrice: loading...")
local plotStatusLabel = Tabs.Game:AddLabel("Owned Plot: scanning...")

local function updateGasPriceLabel()
    local numeric = getNumericGasPrice()
    if numeric then
        gasPriceLabel:Set("Current GasPrice: $" .. tostring(numeric))
    else
        gasPriceLabel:Set("Current GasPrice: " .. tostring(GasPriceValue.Value))
    end
end

local function updateOwnedPlotLabel()
    local ownedPlot = findOwnedPlot()
    if ownedPlot then
        plotStatusLabel:Set("Owned Plot: " .. ownedPlot.Name)
    else
        plotStatusLabel:Set("Owned Plot: not found")
    end
end

GasPriceValue:GetPropertyChangedSignal("Value"):Connect(updateGasPriceLabel)
updateGasPriceLabel()
updateOwnedPlotLabel()

-- Auto Collect Gas
local secAutoCollect = Tabs.Game:AddSection({ Title = "Auto Collect Gas", open = false })

secAutoCollect:AddToggle({
    Name = "Auto Collect Gas",
    Default = false,
    Callback = function(Value)
        AutoCollectGasEnabled = Value
        if Value then
            startAutoCollectLoop()
        else
            AutoCollectLoopId = AutoCollectLoopId + 1
        end
    end,
})

-- Steal Section
local secSteal = Tabs.Game:AddSection({ Title = "Steal", open = false })

secSteal:AddToggle({
    Name = "Instant Steal",
    Default = false,
    Callback = function(Value)
        InstantStealEnabled = Value
        refreshInstantSteal()
    end,
})

secSteal:AddToggle({
    Name = "Auto Return After Steal",
    Default = true,
    Callback = function(Value)
        AutoReturnAfterStealEnabled = Value
    end,
})

secSteal:AddButton({
    Name = "Return To Random Base Building",
    Callback = function()
        returnToOwnedBase()
        VelarisUI:MakeNotify({ Title = "Teleport", Description = "Returned to base!", Color = "Success", Time = 1 })
    end,
})

-- Best Refinery ESP
local secRefineryESP = Tabs.Game:AddSection({ Title = "Best Refinery ESP", open = false })

secRefineryESP:AddToggle({
    Name = "Show Best Refinery Line",
    Default = false,
    Callback = function(Value)
        BestRefineryESPEnabled = Value
        if Value then
            startBestRefineryESP()
        else
            stopBestRefineryESP()
        end
    end,
})

-- Refresh Buttons
local secRefresh = Tabs.Game:AddSection({ Title = "Refresh", open = false })

secRefresh:AddButton({
    Name = "Refresh Owned Plot Check",
    Callback = function()
        updateOwnedPlotLabel()
        VelarisUI:MakeNotify({ Title = "Refreshed", Description = "Plot status updated!", Color = "Info", Time = 1 })
    end,
})

secRefresh:AddButton({
    Name = "Refresh Instant Steal",
    Callback = function()
        refreshInstantSteal()
        VelarisUI:MakeNotify({ Title = "Refreshed", Description = "Steal prompts updated!", Color = "Info", Time = 1 })
    end,
})

secRefresh:AddButton({
    Name = "Refresh Best Refinery",
    Callback = function()
        updateBestRefineryESP()
        VelarisUI:MakeNotify({ Title = "Refreshed", Description = "Best refinery updated!", Color = "Info", Time = 1 })
    end,
})

--// =========================================================
--// Drills Tab
--// =========================================================

local secDrills = Tabs.Drills:AddSection({ Title = "Drills", open = false })

secDrills:AddSlider({
    Name = "Purchase Delay",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(Value)
        DrillPurchaseDelay = Value / 100
    end,
})

-- Buat 2 kolom untuk drill (pakai grid)
local drillColumns = {}
local currentCol = 1

for _, drillName in ipairs(DrillNames) do
    local col = "Column" .. currentCol
    if not drillColumns[col] then
        drillColumns[col] = Tabs.Drills:AddSection({ Title = col, open = false })
    end
    
    drillColumns[col]:AddToggle({
        Name = drillName,
        Default = false,
        Callback = function(Value)
            if Value then
                startDrillPurchaseLoop(drillName)
            else
                stopDrillPurchaseLoop(drillName)
            end
        end,
    })
    
    currentCol = currentCol % 2 + 1
end

--// =========================================================
--// Misc Tab
--// =========================================================

local secAdmin = Tabs.Misc:AddSection({ Title = "Admin Tools", open = false })

secAdmin:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

secAdmin:AddButton({
    Name = "Unload Script",
    Callback = function()
        if BestRefineryESPConnection then BestRefineryESPConnection:Disconnect() end
        window:Destroy()
        VelarisUI:MakeNotify({ Title = "Unloaded", Description = "Script unloaded!", Color = "Error", Time = 2 })
    end,
})

--// =========================================================
--// Character Respawn Handling
--// =========================================================

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")

    DefaultWalkSpeed = Humanoid.WalkSpeed
    DefaultJumpPower = Humanoid.JumpPower

    applyMovementValues()
end)

--// =========================================================
--// INIT
--// =========================================================

VelarisUI:MakeNotify({ 
    Title = "Victoria Hub", 
    Description = "Oil Empire Loaded!", 
    Content = "Oil Empire", 
    Color = "Success", 
    Time = 3 
})

refreshInstantSteal()
bindAllStealPrompts()
