-- ============================================================
--  Puzzle Solver | Nightmare Door Escape
--  Game: FrontDoor > PuzzleLocks (Lock_1..5) + Passcode
--  UI: VilarisUI (victui.lua)
-- ============================================================

local VUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

-- ── Remotes & Config ─────────────────────────────────────────
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer

local PuzzleShared  = ReplicatedStorage:WaitForChild("PuzzleShared")
local Remotes       = PuzzleShared:WaitForChild("Remotes")
local PuzzleRemote  = Remotes:WaitForChild("PuzzleRemote")
local SubmitPasscode = Remotes:WaitForChild("SubmitPasscode")

-- ── Workspace refs ───────────────────────────────────────────
local FrontDoor    = Workspace:WaitForChild("FrontDoor")
local PuzzleLocks  = FrontDoor:WaitForChild("PuzzleLocks")
local PuzzleItems  = Workspace:WaitForChild("PuzzleItems")

-- Lock warna sesuai screenshot (urutan 1–5)
local LOCKS = {
    { name = "Lock_1", color = "Red",    display = "🔴 Lock 1 (Red)"    },
    { name = "Lock_2", color = "Blue",   display = "🔵 Lock 2 (Blue)"   },
    { name = "Lock_3", color = "Green",  display = "🟢 Lock 3 (Green)"  },
    { name = "Lock_4", color = "Yellow", display = "🟡 Lock 4 (Yellow)" },
    { name = "Lock_5", color = "Purple", display = "🟣 Lock 5 (Purple)" },
}

-- ── State ────────────────────────────────────────────────────
local solvedLocks   = {}   -- { [lockName] = true }
local passcodeFound = false
local passcodeValue = "????"
local running       = false

-- ── Helpers ──────────────────────────────────────────────────
local function notify(title, msg, color)
    VUI:MakeNotify({
        Title   = title,
        Content = msg,
        Delay   = 4,
        Color   = color,
    })
end

-- Ambil Key dari PuzzleItems yang cocok dengan lock ke-i
local function findKeyForLock(lockIndex)
    local keys = PuzzleItems:GetChildren()
    -- Key ke-i (ada 5 Key, urutan = index)
    local count = 0
    for _, obj in ipairs(keys) do
        if obj.Name == "Key" then
            count = count + 1
            if count == lockIndex then
                return obj
            end
        end
    end
    return nil
end

-- Ambil PasscodeNote
local function findPasscodeNote()
    for _, obj in ipairs(PuzzleItems:GetChildren()) do
        if obj.Name == "PasscodeNote" then return obj end
    end
    return nil
end

-- Baca passcode dari note (cari IntValue / StringValue di dalamnya)
local function readPasscode()
    local note = findPasscodeNote()
    if not note then return nil end
    -- Coba baca value
    local sv = note:FindFirstChildWhichIsA("StringValue")
    if sv then return sv.Value end
    local iv = note:FindFirstChildWhichIsA("IntValue")
    if iv then return tostring(iv.Value) end
    -- Coba attribute
    local attr = note:GetAttribute("Passcode") or note:GetAttribute("Code") or note:GetAttribute("Value")
    if attr then return tostring(attr) end
    return nil
end

-- Solve satu lock via PuzzleRemote
local function solveLock(lockData, lockIndex, statusLabel)
    if solvedLocks[lockData.name] then
        notify("⚠️ Skip", lockData.display .. " sudah solved.", nil)
        return
    end

    -- Step 1: Ambil key
    local key = findKeyForLock(lockIndex)
    if not key then
        notify("❌ Error", "Key " .. lockIndex .. " tidak ditemukan!", Color3.fromRGB(220,50,50))
        return
    end

    -- Step 2: Fire remote untuk unlock
    local lockModel = PuzzleLocks:FindFirstChild(lockData.name)
    if not lockModel then
        notify("❌ Error", lockData.name .. " tidak ada di workspace!", Color3.fromRGB(220,50,50))
        return
    end

    local padlock = lockModel:FindFirstChild("Padlock")
    local ok, err = pcall(function()
        PuzzleRemote:FireServer(padlock or lockModel, key)
    end)

    task.wait(0.3)

    if ok then
        solvedLocks[lockData.name] = true
        notify("✅ Unlocked", lockData.display .. " berhasil dibuka!", Color3.fromRGB(50,200,80))
        if statusLabel then
            statusLabel.Value = "✅ " .. lockData.display
        end
    else
        notify("❌ Failed", lockData.display .. " gagal: " .. tostring(err), Color3.fromRGB(220,50,50))
    end
end

-- Solve semua lock berurutan
local function solveAllLocks(statusLabels)
    if running then
        notify("⏳ Wait", "Sedang berjalan...", nil)
        return
    end
    running = true
    notify("🚀 Start", "Mulai solve 5 locks...", Color3.fromRGB(0,170,210))

    for i, lock in ipairs(LOCKS) do
        if not solvedLocks[lock.name] then
            solveLock(lock, i, statusLabels and statusLabels[i])
            task.wait(0.6)
        end
    end

    -- Solve passcode
    local code = readPasscode()
    if code then
        passcodeValue = code
        local ok, err = pcall(function()
            SubmitPasscode:FireServer(code)
        end)
        if ok then
            passcodeFound = true
            notify("🔑 Passcode", "Passcode '" .. code .. "' submitted!", Color3.fromRGB(0,170,210))
        else
            notify("❌ Passcode", "Gagal submit passcode: " .. tostring(err), Color3.fromRGB(220,50,50))
        end
    else
        notify("⚠️ Passcode", "Passcode tidak ditemukan otomatis. Masukkan manual.", Color3.fromRGB(255,165,0))
    end

    running = false
end

-- ── UI ───────────────────────────────────────────────────────
local Win = VUI:Window({
    Title   = "Puzzle Solver",
    Footer  = "Nightmare Escape",
    Color   = "Default",
    Version = "1.0",
    Size    = UDim2.fromOffset(620, 420),
})

-- Tab: Main
local Tab = Win:AddTab({ Name = "Main", Icon = "rbxassetid://103875081318049" })

-- Section: Status
local StatusSec = Tab:AddSection({ Title = "Lock Status", Open = true })

local statusLabels = {}
for i, lock in ipairs(LOCKS) do
    local lbl = StatusSec:AddParagraph({
        Title   = lock.display,
        Content = "⬜ Belum solved",
    })
    statusLabels[i] = lbl
end

local passLbl = StatusSec:AddParagraph({
    Title   = "🔑 Passcode",
    Content = "⬜ Belum ditemukan",
})

-- Section: Controls
local CtrlSec = Tab:AddSection({ Title = "Controls", Open = true })

-- Solve all
CtrlSec:AddButton({
    Title    = "🚀 Solve All (Auto)",
    Content  = "Ambil semua key & submit passcode berurutan",
    Callback = function()
        task.spawn(function()
            solveAllLocks(statusLabels)
        end)
    end,
})

-- Individual locks
for i, lock in ipairs(LOCKS) do
    local idx = i
    local ldata = lock
    CtrlSec:AddButton({
        Title    = "Unlock " .. ldata.display,
        Content  = "Solve lock " .. idx .. " saja",
        Callback = function()
            task.spawn(function()
                solveLock(ldata, idx, statusLabels[idx])
            end)
        end,
    })
end

-- Manual passcode input
local passcodeInput = CtrlSec:AddInput({
    Title       = "Manual Passcode",
    PlaceHolder = "Masukkan kode...",
    Flag        = "ManualPasscode",
    Callback    = function(val)
        passcodeValue = val
    end,
})

CtrlSec:AddButton({
    Title    = "🔑 Submit Passcode",
    Content  = "Kirim passcode yang ada di input",
    Callback = function()
        if passcodeValue == "" or passcodeValue == "????" then
            notify("⚠️ Input", "Isi dulu passcode-nya!", Color3.fromRGB(255,165,0))
            return
        end
        local ok, err = pcall(function()
            SubmitPasscode:FireServer(passcodeValue)
        end)
        if ok then
            notify("✅ Done", "Passcode '" .. passcodeValue .. "' submitted!", Color3.fromRGB(50,200,80))
        else
            notify("❌ Error", tostring(err), Color3.fromRGB(220,50,50))
        end
    end,
})

-- Tab: Info
local InfoTab = Win:AddTab({ Name = "Info", Icon = "" })
local InfoSec = InfoTab:AddSection({ Title = "Cara Pakai", Open = true })

InfoSec:AddParagraph({
    Title   = "Flow",
    Content = "1. Tekan 'Solve All' untuk auto ambil semua key dan submit passcode.\n2. Atau unlock satu per satu pakai tombol per lock.\n3. Kalau passcode tidak ke-detect otomatis, isi manual lalu Submit.",
})

InfoSec:AddParagraph({
    Title   = "Remote",
    Content = "PuzzleRemote → unlock tiap padlock\nSubmitPasscode → kirim kode pintu",
})

-- Live status update loop
task.spawn(function()
    while task.wait(1) do
        for i, lock in ipairs(LOCKS) do
            if statusLabels[i] and statusLabels[i].SetContent then
                local text = solvedLocks[lock.name] and "✅ Solved" or "⬜ Belum solved"
                pcall(function() statusLabels[i]:SetContent(text) end)
            end
        end
        if passLbl and passLbl.SetContent then
            local ptxt = passcodeFound and ("✅ Submitted: " .. passcodeValue) or ("⬜ " .. (passcodeValue ~= "????" and passcodeValue or "Belum ditemukan"))
            pcall(function() passLbl:SetContent(ptxt) end)
        end
    end
end)

notify("💀 Loaded", "Puzzle Solver aktif. Good luck!", Color3.fromRGB(0,170,210))
