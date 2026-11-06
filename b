-- ============================================================
--  Puzzle ESP | Nightmare Door Escape
--  Highlight: Key x5, PasscodeNote, Padlock x5
-- ============================================================

local VUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

local Players       = game:GetService("Players")
local Workspace     = game:GetService("Workspace")
local RunService    = game:GetService("RunService")
local LocalPlayer   = Players.LocalPlayer

local PuzzleItems   = Workspace:WaitForChild("PuzzleItems")
local FrontDoor     = Workspace:WaitForChild("FrontDoor")
local PuzzleLocks   = FrontDoor:WaitForChild("PuzzleLocks")

-- ── Config ───────────────────────────────────────────────────
local cfg = {
    keyColor      = Color3.fromRGB(255, 215, 0),    -- gold
    noteColor     = Color3.fromRGB(0, 200, 255),    -- cyan
    lockColor     = Color3.fromRGB(255, 80, 80),    -- red
    espEnabled    = true,
    showDistance  = true,
    showName      = true,
    fillTrans     = 0.6,
    outlineTrans  = 0,
}

-- ── Highlight pool ───────────────────────────────────────────
local highlights = {}  -- { model = HighlightInstance }

local function getRoot(model)
    return model:FindFirstChild("Root")
        or model:FindFirstChildWhichIsA("BasePart")
end

local function addHighlight(model, fillColor, outlineColor)
    if highlights[model] then return end
    local hl = Instance.new("SelectionBox")
    hl.Color3 = outlineColor or fillColor
    hl.SurfaceColor3 = fillColor
    hl.SurfaceTransparency = cfg.fillTrans
    hl.LineThickness = 0.05
    hl.Adornee = model
    hl.Parent = LocalPlayer.PlayerGui
    highlights[model] = hl
end

local function removeHighlight(model)
    if highlights[model] then
        highlights[model]:Destroy()
        highlights[model] = nil
    end
end

local function clearAll()
    for model, hl in pairs(highlights) do
        hl:Destroy()
        highlights[model] = nil
    end
end

-- ── BillboardGui label ───────────────────────────────────────
local billboards = {}

local function addBillboard(model, label, color)
    if billboards[model] then return end
    local root = getRoot(model)
    if not root then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "PuzzleESP"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 160, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Adornee = root
    bb.Parent = LocalPlayer.PlayerGui

    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0.4
    txt.TextStrokeColor3 = Color3.new(0,0,0)
    txt.Text = label
    txt.Parent = bb

    billboards[model] = { gui = bb, label = txt, baseLabel = label }
end

local function clearBillboards()
    for _, v in pairs(billboards) do
        v.gui:Destroy()
    end
    billboards = {}
end

-- ── ESP Update ───────────────────────────────────────────────
local function refreshESP()
    clearAll()
    clearBillboards()
    if not cfg.espEnabled then return end

    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")

    -- Keys
    local keyIdx = 0
    for _, item in ipairs(PuzzleItems:GetChildren()) do
        if item.Name == "Key" then
            keyIdx = keyIdx + 1
            addHighlight(item, cfg.keyColor, Color3.fromRGB(255,255,100))
            addBillboard(item, "🗝️ Key " .. keyIdx, cfg.keyColor)
        elseif item.Name == "PasscodeNote" then
            addHighlight(item, cfg.noteColor, Color3.fromRGB(100,255,255))
            addBillboard(item, "📋 Passcode Note", cfg.noteColor)
        end
    end

    -- Padlocks
    for i = 1, 5 do
        local lock = PuzzleLocks:FindFirstChild("Lock_" .. i)
        if lock then
            local padlock = lock:FindFirstChild("Padlock") or lock
            addHighlight(padlock, cfg.lockColor, Color3.fromRGB(255,120,120))
            addBillboard(padlock, "🔒 Lock " .. i, cfg.lockColor)
        end
    end
end

-- Distance update loop
local conn
local function startLoop()
    if conn then conn:Disconnect() end
    conn = RunService.Heartbeat:Connect(function()
        if not cfg.espEnabled or not cfg.showDistance then return end
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for model, data in pairs(billboards) do
            local root = getRoot(model)
            if root and root.Parent then
                local dist = math.floor((hrp.Position - root.Position).Magnitude)
                data.label.Text = data.baseLabel .. "\n[" .. dist .. " studs]"
            end
        end
    end)
end

local function stopLoop()
    if conn then conn:Disconnect() conn = nil end
end

-- ── UI ───────────────────────────────────────────────────────
local Win     = VUI:Window({
    Title   = "Puzzle ESP",
    Footer  = "Nightmare Escape",
    Color   = "Default",
    Version = "1.0",
    Size    = UDim2.fromOffset(580, 400),
})

local Tab     = Win:AddTab({ Name = "ESP" })
local Sec     = Tab:AddSection({ Title = "Settings", Open = true })

Sec:AddToggle({
    Title   = "ESP Aktif",
    Default = true,
    Flag    = "ESPToggle",
    Callback = function(val)
        cfg.espEnabled = val
        if val then
            refreshESP()
            startLoop()
        else
            clearAll()
            clearBillboards()
            stopLoop()
        end
    end,
})

Sec:AddToggle({
    Title   = "Tampilkan Jarak",
    Default = true,
    Flag    = "DistToggle",
    Callback = function(val)
        cfg.showDistance = val
    end,
})

Sec:AddSlider({
    Title   = "Fill Transparency",
    Min     = 0,
    Max     = 1,
    Default = 0.6,
    Flag    = "FillTrans",
    Callback = function(val)
        cfg.fillTrans = val
        refreshESP()
    end,
})

Sec:AddDivider()

Sec:AddButton({
    Title    = "🔄 Refresh ESP",
    Content  = "Scan ulang semua item di world",
    Callback = function()
        refreshESP()
        startLoop()
        VUI:MakeNotify({ Title = "✅ Refresh", Content = "ESP di-refresh!", Delay = 2 })
    end,
})

-- Info section
local InfoTab = Win:AddTab({ Name = "Items" })
local InfoSec = InfoTab:AddSection({ Title = "List Item", Open = true })

InfoSec:AddButton({
    Title    = "📋 Scan & Tampilkan",
    Content  = "List semua item puzzle yang ada",
    Callback = function()
        local lines = {}
        local keyIdx = 0
        for _, item in ipairs(PuzzleItems:GetChildren()) do
            local root = getRoot(item)
            local pos  = root and root.Position or Vector3.zero
            if item.Name == "Key" then
                keyIdx = keyIdx + 1
                table.insert(lines, "Key " .. keyIdx .. " → " .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z))
            elseif item.Name == "PasscodeNote" then
                -- Coba baca kode
                local code = "?"
                local writing = item:FindFirstChild("Writing", true)
                local codeVal = writing and writing:FindFirstChild("Code")
                if codeVal then code = tostring(codeVal.Value) end
                table.insert(lines, "PasscodeNote (code=" .. code .. ") → " .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z))
            end
        end
        for i = 1, 5 do
            local lock = PuzzleLocks:FindFirstChild("Lock_" .. i)
            if lock then
                local root = getRoot(lock:FindFirstChild("Padlock") or lock)
                local pos  = root and root.Position or Vector3.zero
                table.insert(lines, "Lock_" .. i .. " → " .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z))
            end
        end

        if #lines == 0 then
            VUI:MakeNotify({ Title = "⚠️", Content = "Tidak ada item ditemukan!", Delay = 3 })
            return
        end

        -- Print ke console + notify ringkas
        print("=== PUZZLE ITEM LOCATIONS ===")
        for _, l in ipairs(lines) do print(l) end

        VUI:MakeNotify({
            Title   = "📋 " .. #lines .. " item ditemukan",
            Content = "Lihat console (F9) untuk koordinat lengkap",
            Delay   = 5,
        })
    end,
})

-- ── Init ─────────────────────────────────────────────────────
refreshESP()
startLoop()

-- Auto refresh kalau item baru spawn
PuzzleItems.ChildAdded:Connect(function()
    task.wait(0.5)
    refreshESP()
end)
PuzzleItems.ChildRemoved:Connect(function()
    task.wait(0.1)
    refreshESP()
end)

VUI:MakeNotify({
    Title   = "🔍 ESP Aktif",
    Content = "Key = Gold | Note = Cyan | Lock = Red",
    Delay   = 4,
    Color   = Color3.fromRGB(0,170,210),
})
