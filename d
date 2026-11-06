-- ============================================================
--  Puzzle ESP | Nightmare Escape
--  - ESP: Key, PasscodeNote, Enemy (Opah)
--  - Infinite Sprint
--  - Ringan: Highlight instance + update tiap 0.1s
-- ============================================================

local VUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

local Players     = game:GetService("Players")
local Workspace   = game:GetService("Workspace")
local RunService  = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PuzzleItems = Workspace:WaitForChild("PuzzleItems")

-- ── Config ───────────────────────────────────────────────────
local cfg = {
    itemESP    = true,
    enemyESP   = true,
    infiniteSprint = false,
}

-- ── Highlight pool ───────────────────────────────────────────
-- Pakai Highlight (lebih ringan dari SelectionBox)
local highlights   = {}  -- [model] = Highlight
local billboards   = {}  -- [model] = { gui, label, base }

local function addHL(model, fill, outline)
    if highlights[model] then return end
    local hl = Instance.new("Highlight")
    hl.FillColor        = fill
    hl.OutlineColor     = outline or fill
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode        = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee          = model
    hl.Parent           = LocalPlayer.PlayerGui
    highlights[model]   = hl
end

local function removeHL(model)
    if highlights[model] then
        highlights[model]:Destroy()
        highlights[model] = nil
    end
    if billboards[model] then
        billboards[model].gui:Destroy()
        billboards[model] = nil
    end
end

local function clearAll()
    for model in pairs(highlights) do removeHL(model) end
end

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Root")
        or model:FindFirstChildWhichIsA("BasePart")
end

local function addBB(model, baseLabel, color)
    if billboards[model] then return end
    local root = getRoot(model)
    if not root then return end

    local bb  = Instance.new("BillboardGui")
    bb.AlwaysOnTop  = true
    bb.Size         = UDim2.new(0, 140, 0, 36)
    bb.StudsOffset  = Vector3.new(0, 3.5, 0)
    bb.Adornee      = root
    bb.Parent       = LocalPlayer.PlayerGui

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size      = UDim2.new(1,0,1,0)
    lbl.Font      = Enum.Font.GothamBold
    lbl.TextSize  = 12
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.Text      = baseLabel
    lbl.Parent    = bb

    billboards[model] = { gui = bb, label = lbl, base = baseLabel, root = root }
end

-- ── Refresh ESP (jalankan sekali, bukan tiap frame) ──────────
local function refreshItemESP()
    -- Hapus highlight item lama
    for model, _ in pairs(highlights) do
        local name = model.Name
        if name == "Key" or name == "PasscodeNote" then
            removeHL(model)
        end
    end
    if not cfg.itemESP then return end

    local idx = 0
    for _, item in ipairs(PuzzleItems:GetChildren()) do
        if item.Name == "Key" then
            idx = idx + 1
            addHL(item, Color3.fromRGB(255,215,0), Color3.fromRGB(255,255,100))
            addBB(item, "🗝️ Key "..idx, Color3.fromRGB(255,215,0))
        elseif item.Name == "PasscodeNote" then
            addHL(item, Color3.fromRGB(0,200,255), Color3.fromRGB(100,255,255))
            addBB(item, "📋 Passcode", Color3.fromRGB(0,200,255))
        end
    end
end

local function refreshEnemyESP()
    -- Hapus highlight enemy lama
    for model, _ in pairs(highlights) do
        if model.Name == "Opah" or (model.Parent and model.Parent.Name == "Opah") then
            removeHL(model)
        end
    end
    if not cfg.enemyESP then return end

    -- Opah ada di Workspace langsung
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name == "Opah" then
            addHL(obj, Color3.fromRGB(220,50,50), Color3.fromRGB(255,100,100))
            addBB(obj, "👹 OPAH", Color3.fromRGB(255,80,80))
        end
    end
end

-- ── Distance update — tiap 0.1s ──────────────────────────────
local updateConn
local lastUpdate = 0

local function startUpdateLoop()
    if updateConn then updateConn:Disconnect() end
    updateConn = RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - lastUpdate < 0.1 then return end
        lastUpdate = now

        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for model, data in pairs(billboards) do
            local root = data.root
            if root and root.Parent then
                local dist = math.floor((hrp.Position - root.Position).Magnitude)
                data.label.Text = data.base .. "\n" .. dist .. " studs"
            end
        end
    end)
end

local function stopUpdateLoop()
    if updateConn then updateConn:Disconnect() updateConn = nil end
end

-- ── Infinite Sprint ──────────────────────────────────────────
local sprintConn

local function startSprint()
    -- Coba edit SprintConfig di ReplicatedStorage
    local ok = pcall(function()
        local sc = ReplicatedStorage:WaitForChild("SprintSystem", 2)
                    :WaitForChild("SprintConfig", 2)
        for _, v in ipairs(sc:GetChildren()) do
            -- Biasanya ada NumberValue "StaminaMax", "StaminaDrain" dll
            if v.Name == "StaminaDrain" or v.Name == "Drain" then
                v.Value = 0
            end
            if v.Name == "StaminaRegen" or v.Name == "Regen" then
                v.Value = 999
            end
            if v.Name == "StaminaMax" or v.Name == "MaxStamina" then
                v.Value = 9999
            end
        end
    end)

    -- Fallback: langsung manipulasi WalkSpeed via Humanoid saat sprint
    -- + hold sprint button otomatis via SprintController di character
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum  = char:FindFirstChildOfClass("Humanoid")

    -- Coba set stamina attribute langsung
    pcall(function()
        local sprintModel = Workspace:FindFirstChild(LocalPlayer.Name)
        if sprintModel then
            local ctrl = sprintModel:FindFirstChild("SprintController")
            if ctrl then
                -- Set attribute stamina
                ctrl:SetAttribute("Stamina", 9999)
                ctrl:SetAttribute("MaxStamina", 9999)
            end
        end
    end)

    -- Loop: setiap 0.5s reset stamina attribute di karakter
    if sprintConn then sprintConn:Disconnect() end
    sprintConn = RunService.Heartbeat:Connect(function()
        local c = LocalPlayer.Character
        if not c then return end
        -- Reset via karakter folder (Opah > Rigs > Sprint)
        pcall(function()
            local playerFolder = Workspace:FindFirstChild(LocalPlayer.Name)
            local rigs = playerFolder and playerFolder:FindFirstChild("Rigs")
            local sprintVal = rigs and rigs:FindFirstChild("Sprint")
            if sprintVal then
                -- NumberValue atau BoolValue
                if sprintVal:IsA("NumberValue") then
                    sprintVal.Value = 9999
                end
            end
        end)
    end)
end

local function stopSprint()
    if sprintConn then sprintConn:Disconnect() sprintConn = nil end
end

-- ── UI ───────────────────────────────────────────────────────
local Win = VUI:Window({
    Title   = "Puzzle Tools",
    Footer  = "Nightmare Escape",
    Color   = "Default",
    Version = "1.0",
    Size    = UDim2.fromOffset(580, 400),
})

local Tab  = Win:AddTab({ Name = "ESP" })
local Sec  = Tab:AddSection({ Title = "ESP Settings", Open = true })

Sec:AddToggle({
    Title    = "🗝️ Item ESP (Key + Note)",
    Default  = true,
    Flag     = "ItemESP",
    Callback = function(val)
        cfg.itemESP = val
        refreshItemESP()
        if val then startUpdateLoop() end
    end,
})

Sec:AddToggle({
    Title    = "👹 Enemy ESP (Opah)",
    Default  = true,
    Flag     = "EnemyESP",
    Callback = function(val)
        cfg.enemyESP = val
        refreshEnemyESP()
    end,
})

Sec:AddButton({
    Title    = "🔄 Refresh ESP",
    Content  = "Scan ulang semua item & enemy",
    Callback = function()
        refreshItemESP()
        refreshEnemyESP()
        VUI:MakeNotify({ Title = "✅ Refresh", Content = "ESP di-refresh!", Delay = 2 })
    end,
})

-- Sprint tab
local SpTab = Win:AddTab({ Name = "Sprint" })
local SpSec = SpTab:AddSection({ Title = "Infinite Sprint", Open = true })

SpSec:AddToggle({
    Title    = "⚡ Infinite Sprint",
    Default  = false,
    Flag     = "InfSprint",
    Callback = function(val)
        cfg.infiniteSprint = val
        if val then
            startSprint()
            VUI:MakeNotify({ Title = "⚡ Sprint", Content = "Infinite sprint aktif!", Delay = 3, Color = Color3.fromRGB(50,200,80) })
        else
            stopSprint()
            VUI:MakeNotify({ Title = "Sprint", Content = "Sprint normal.", Delay = 2 })
        end
    end,
})

SpSec:AddParagraph({
    Title   = "Info",
    Content = "Script mencoba reset nilai stamina di SprintConfig & karakter folder. Kalau tidak berhasil penuh, stamina akan terus di-refill tiap frame.",
})

-- ── Init ─────────────────────────────────────────────────────
refreshItemESP()
refreshEnemyESP()
startUpdateLoop()

-- Auto refresh item saat diambil/spawn
PuzzleItems.ChildAdded:Connect(function() task.wait(0.3); refreshItemESP() end)
PuzzleItems.ChildRemoved:Connect(function() task.wait(0.1); refreshItemESP() end)

-- Auto detect Opah kalau belum spawn
Workspace.ChildAdded:Connect(function(obj)
    if obj.Name == "Opah" then
        task.wait(0.3)
        refreshEnemyESP()
    end
end)
Workspace.ChildRemoved:Connect(function(obj)
    if obj.Name == "Opah" then
        removeHL(obj)
    end
end)

VUI:MakeNotify({
    Title   = "✅ Loaded",
    Content = "ESP aktif | Key=Gold | Note=Cyan | Opah=Red",
    Delay   = 4,
    Color   = Color3.fromRGB(0,170,210),
})
