local VUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()
local Players     = game:GetService("Players")
local Workspace   = game:GetService("Workspace")
local RunService  = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PuzzleItems = Workspace:WaitForChild("PuzzleItems")

local cfg = {
    itemESP    = true,
    enemyESP   = true,
    infiniteSprint = false,
}

local highlights   = {}
local billboards   = {}

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

local function getRoot(model)
    if not model then return nil end
    local root = model:FindFirstChild("Root") or model:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then return root end
    if model:IsA("BasePart") then return model end
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
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

local function refreshItemESP()
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
            addBB(item, "Key "..idx, Color3.fromRGB(255,215,0))
        elseif item.Name == "PasscodeNote" then
            addHL(item, Color3.fromRGB(0,200,255), Color3.fromRGB(100,255,255))
            addBB(item, "Passcode", Color3.fromRGB(0,200,255))
        end
    end
end

local function refreshEnemyESP()
    for model, _ in pairs(highlights) do
        if model.Name == "Opah" or (model.Parent and model.Parent.Name == "Opah") then
            removeHL(model)
        end
    end
    if not cfg.enemyESP then return end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name == "Opah" then
            addHL(obj, Color3.fromRGB(220,50,50), Color3.fromRGB(255,100,100))
            addBB(obj, "OPAH", Color3.fromRGB(255,80,80))
        end
    end
end

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

local sprintConn
local function startSprint()
    pcall(function()
        local sc = ReplicatedStorage:WaitForChild("SprintSystem", 2):WaitForChild("SprintConfig", 2)
        for _, v in ipairs(sc:GetChildren()) do
            if v.Name == "RegenPerSecond" or v.Name == "Drain" then v.Value = 1000 end
            if v.Name == "DrainPerSecond" or v.Name == "Regen" then v.Value = 0 end
            if v.Name == "MaxStamina" or v.Name == "MaxStamina" then v.Value = 9999 end
        end
    end)
    if sprintConn then sprintConn:Disconnect() end
    sprintConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local playerFolder = Workspace:FindFirstChild(LocalPlayer.Name)
            local rigs = playerFolder and playerFolder:FindFirstChild("Rigs")
            local sprintVal = rigs and rigs:FindFirstChild("Sprint")
            if sprintVal and sprintVal:IsA("NumberValue") then sprintVal.Value = 9999 end
        end)
    end)
end
local function stopSprint() if sprintConn then sprintConn:Disconnect() sprintConn = nil end end

-- ==========================================
-- LOGIKA TELEPORT
-- ==========================================
local function teleportTo(part, offset)
    if not part then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = part.CFrame * offset
    end
end

local FRONT_DOOR_POS = Vector3.new(301.76, 11.13, -219.63) 

local function teleportToFrontDoor()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(FRONT_DOOR_POS)
        VUI:MakeNotify({ Title = "Teleport", Content = "Ke depan pintu!", Delay = 2 })
    end
end

local function teleportToNote()
    local noteFound = false
    for _, item in ipairs(PuzzleItems:GetChildren()) do
        if item.Name == "PasscodeNote" then
            local part = getRoot(item)
            if part then
                teleportTo(part, CFrame.new(0, 3, 0)) 
                VUI:MakeNotify({ Title = "Teleport", Content = "Ke Kertas Sandi!", Delay = 2 })
                noteFound = true
                break
            end
        end
    end
    if not noteFound then
        VUI:MakeNotify({ Title = "Gagal", Content = "Kertas (PasscodeNote) ga nemu / udah diambil.", Delay = 2 })
    end
end

local function teleportToKey(index)
    local keysFound = {}
    for _, item in ipairs(PuzzleItems:GetChildren()) do
        if item.Name == "Key" then
            table.insert(keysFound, item)
        end
    end

    if keysFound[index] then
        local keyPart = getRoot(keysFound[index])
        if keyPart then
            teleportTo(keyPart, CFrame.new(0, 3, 0))
            VUI:MakeNotify({ Title = "Teleport", Content = "Berhasil ke Key " .. index, Delay = 2 })
        end
    else
        VUI:MakeNotify({ Title = "Gagal", Content = "Key " .. index .. " udah diambil/ga ada.", Delay = 2 })
    end
end

-- ── UI ───────────────────────────────────────────────────────
local Win = VUI:Window({
    Title         = "Victoria Hub",
    Footer        = "Gennskie Development",
    Content       = "Night With Opah",
    Color         = Color3.fromRGB(0, 170, 210),
    Size          = UDim2.fromOffset(580, 440),
    Version       = 1.0,
    Image = "96751490485303",
    ["Tab Width"] = 130,
    Uitransparent = 0.15,
    ShowUser = true,
    Search = true, 
    Animation = true,   -- aktifkan animasi
    TypeDelay  = 0.07,   -- opsional, default 0.07
    TypePause  = 2.5,   
    Config = {
        ConfigFolder  = "VictoriaHub/Config/" .. tostring(game.PlaceId) .. "/",
        AutoSaveFile  = "Default",
        AutoSave      = false,
        AutoLoad      = true,
    },
})

local Tab  = Win:AddTab({ Name = "ESP" })
local Sec  = Tab:AddSection({ Title = "ESP Settings", Open = true })

Sec:AddToggle({
    Title    = "Item ESP",
    Default  = true,
    Callback = function(val) 
        cfg.itemESP = val 
        if val then refreshItemESP() else
            for model, _ in pairs(highlights) do
                if model.Name == "Key" or model.Name == "PasscodeNote" then removeHL(model) end
            end
        end
    end,
})

Sec:AddToggle({
    Title    = "Enemy ESP",
    Default  = true,
    Callback = function(val) 
        cfg.enemyESP = val 
        if val then refreshEnemyESP() else
            for model, _ in pairs(highlights) do
                if model.Name == "Opah" or (model.Parent and model.Parent.Name == "Opah") then removeHL(model) end
            end
        end
    end,
})

local TpTab = Win:AddTab({ Name = "Teleport" })
local TpSec = TpTab:AddSection({ Title = "Items", Open = true })

TpSec:AddButton({
    Title    = "Teleport Door",
    Content  = " ",
    Callback = function() teleportToFrontDoor() end,
})

TpSec:AddButton({
    Title    = "Teleport Passcode",
    Content  = " ",
    Callback = function() teleportToNote() end,
})

local KeySec = TpTab:AddSection({ Title = "Kunci (Key)", Open = true })
for i = 1, 5 do
    KeySec:AddButton({
        Title    = "Teleport Key " .. i,
        Callback = function() teleportToKey(i) end,
    })
end

local SpTab = Win:AddTab({ Name = "Sprint" })
local SpSec = SpTab:AddSection({ Title = "Infinite Sprint", Open = true })
SpSec:AddToggle({
    Title    = "Infinite Sprint",
    Default  = false,
    Callback = function(val) if val then startSprint() else stopSprint() end end,
})

-- ── Init ─────────────────────────────────────────────────────
refreshItemESP()
refreshEnemyESP()
startUpdateLoop()

-- EVENT: Biar ESP balik lagi kalau karakter mati / respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5) -- Tunggu 1.5 detik biar map & karakter ke-load sempurna
    if cfg.itemESP then refreshItemESP() end
    if cfg.enemyESP then refreshEnemyESP() end
    if cfg.infiniteSprint then startSprint() end
end)

PuzzleItems.ChildAdded:Connect(function() task.wait(0.3); refreshItemESP() end)
PuzzleItems.ChildRemoved:Connect(function() task.wait(0.1); refreshItemESP() end)
Workspace.ChildAdded:Connect(function(obj) if obj.Name == "Opah" then task.wait(0.3); refreshEnemyESP() end end)
Workspace.ChildRemoved:Connect(function(obj) if obj.Name == "Opah" then removeHL(obj) end end)

VUI:MakeNotify({ Title = "Loaded", Content = "Auto-Respawn ESP aktif!", Delay = 4 })
