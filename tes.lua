--[[
    NAME: FORKT-HUB
    VERSION: v1.0.8 (God-Tier Mobile Edition)
    CREDITS: @sukitovone
]]
if not game:IsLoaded() then game.Loaded:Wait() end
while not game:GetService("Players").LocalPlayer do task.wait() end
while not workspace.CurrentCamera do task.wait() end

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local Stats = game:GetService("Stats")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local PathfindingService = cloneref(game:GetService("PathfindingService"))
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = cloneref(game:GetService("HttpService"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =========================================================
-- [FIX FATAL] 1. LOAD LIBRARY DENGAN SISTEM KEBAL (FALLBACK)
-- =========================================================
-- 1. LOAD LIBRARY
local function LoadLibrary()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end)
    return success and result or nil
end

local WindUI = LoadLibrary()
if not WindUI then 
    return game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Gagal memuat UI."})
end

-- =========================================================
-- [FIX FATAL] SISTEM LOAD JUNKIE (ANTI-CRASH JARINGAN)
-- =========================================================
local successJunkie, JunkieLib = pcall(function()
    return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
end)

local Junkie = successJunkie and JunkieLib or nil
if not Junkie then
    return game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Fatal", Text = "Gagal memuat Junkie API (Jaringan Lambat)."})
end

-- KEY SYSTEM
Junkie.service = "Violence District"           -- Nama service / Service ID kamu
Junkie.identifier = "1010259"        -- User ID kamu dari dashboard (GANTI INI!)
Junkie.provider = "Mixed"    -- Atau gunakan "Mixed" jika kamu pakai banyak layanan
----------------------------------------------------------------
-- ESP COLORS (Pengganti Config Manual)
----------------------------------------------------------------
local ESP_COLORS = {
    Killer = Color3.fromRGB(255, 93, 108), 
    Survivor = Color3.fromRGB(0, 255, 34),
    Generator = Color3.fromRGB(200, 100, 0), 
    Gate = Color3.fromRGB(255, 255, 255),
    Pallet = Color3.fromRGB(140, 255, 74), 
    Hook = Color3.fromRGB(252, 116, 116)
}
local MaskNames = {
    ["Richard"] = "Rooster",
    ["Tony"] = "Tiger",
    ["Brandon"] = "Panther",
    ["Cobra"] = "Cobra",
    ["Richter"] = "Rat",
    ["Rabbit"] = "Rabbit",
    ["Alex"] = "Chainsaw"
}

local MaskColors = {
    ["Richard"] = Color3.fromRGB(255, 50, 50),     -- Red
    ["Tony"] = Color3.fromRGB(255, 255, 0),        -- Yellow Neon
    ["Brandon"] = Color3.fromRGB(191, 0, 255),    -- Ungu Terang / Neon Purple
    ["Cobra"] = Color3.fromRGB(255, 174, 0),       -- Green Neon
    ["Richter"] = Color3.fromRGB(255, 0, 136),   -- Perak (Silver)
    ["Rabbit"] = Color3.fromRGB(255, 105, 180),    -- Pink
    ["Alex"] = Color3.fromRGB(255, 255, 255)       -- White
}


local CachedMapObjects = {
    Generators = {},
    Pallets = {},
    Hooks = {},
    Gates = {}
}
local function UpdateMapCache()
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    
    CachedMapObjects.Generators = {}
    CachedMapObjects.Pallets = {}
    CachedMapObjects.Hooks = {}
    CachedMapObjects.Gates = {}
    
    local descendants = map:GetDescendants()
    for i = 1, #descendants do
        local obj = descendants[i]
        if obj:IsA("Model") then
            local n = obj.Name:lower() 
            
            if n:find("generator") then 
                table.insert(CachedMapObjects.Generators, obj)
            elseif n == "hook" then  -- [FIX] Pastikan menggunakan ==
                table.insert(CachedMapObjects.Hooks, obj)
            elseif n:find("gate") then 
                table.insert(CachedMapObjects.Gates, obj)
            elseif n == "pallet" or n == "palletwrong" then 
                table.insert(CachedMapObjects.Pallets, obj)
            end
        end
        if i % 500 == 0 then task.wait() end 
    end

    if PrevESPState then
        PrevESPState.Generator = false
        PrevESPState.Hook = false
        PrevESPState.Pallet = false
        PrevESPState.Gate = false
    end
end

-- =========================================================
-- [FIX] SMART MAP DETECTOR (NEW ROUND TRACKER)
-- =========================================================
task.spawn(function() 
    local lastMapObject = nil -- [FIX] Menyimpan identitas fisik map ronde saat ini
    
    while task.wait(2) do 
        if not getgenv().FORKT_RUNNING then break end
        
        local currentMap = workspace:FindFirstChild("Map")
        local hasContents = currentMap and #currentMap:GetChildren() > 5
        
        -- 1. Jika map muncul DAN fisik mapnya berbeda dari ronde sebelumnya
        if hasContents and currentMap ~= lastMapObject then
            lastMapObject = currentMap -- Kunci dan ingat wujud map ronde baru ini!
            
            -- Beri jeda 6 detik agar seluruh objek map baru selesai di-render server
            task.delay(6, function()
                -- Pastikan map yang ditunggu 6 detik tadi masih map yang sama
                if workspace:FindFirstChild("Map") == currentMap then
                    cachedChar = nil; cachedRoot = nil
                    UpdateMapCache()
                    
                    -- ==========================================
                    -- [TAMBAHAN] SMART MAP NAME DETECTOR
                    -- ==========================================
                    local mapName = "Unknown Map"
                    
                    -- 1. Coba cari dari Attribute (Cara paling modern)
                    local attrName = currentMap:GetAttribute("MapName") or currentMap:GetAttribute("Name") or currentMap:GetAttribute("RealName")
                    if type(attrName) == "string" and attrName ~= "" then
                        mapName = attrName
                    else
                        -- 2. Coba cari dari StringValue di dalam folder Map
                        local valName = currentMap:FindFirstChild("MapName") or currentMap:FindFirstChild("MapString")
                        if valName and valName:IsA("StringValue") and valName.Value ~= "" then
                            mapName = valName.Value
                        else
                            -- 3. Fallback: Ambil nama dari Model fisik map yang pertama kali ditemukan
                            local firstModel = currentMap:FindFirstChildWhichIsA("Model")
                            if firstModel and not firstModel.Name:lower():find("generator") and not firstModel.Name:lower():find("pallet") then
                                mapName = firstModel.Name
                            end
                        end
                    end
                    
                    -- Tampilkan nama map di bagian Judul (Title)
                    WindUI:Notify({ 
                        Title = "New Round: " .. mapName, 
                        Content = "Berhasil memuat " .. #CachedMapObjects.Pallets .. " Pallet & " .. #CachedMapObjects.Generators .. " Gen!", 
                        Icon = "lucide:map" 
                    })
                end
            end)
            
        -- 2. Jika map dikosongkan (kembali ke Lobby / Transisi ronde)
        elseif not hasContents and lastMapObject ~= nil then
            lastMapObject = nil -- Hapus ingatan map lama, bersiap untuk ronde berikutnya
            
            -- Bersihkan memori secara brutal saat ronde berakhir
            CachedMapObjects.Generators = {}
            CachedMapObjects.Pallets = {}
            CachedMapObjects.Hooks = {}
            CachedMapObjects.Gates = {}
            if ActiveGenerators then table.clear(ActiveGenerators) end
            
            if PrevESPState then
                PrevESPState.Generator = false
                PrevESPState.Hook = false
                PrevESPState.Pallet = false
                PrevESPState.Gate = false
            end
        end
    end 
end)


----------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------
local SpeedBoost, NoSlowdown, InstantHeal, AntiKnock = false, false, false, false
local AntiBlind, AntiStun = false, false
local Aimbot, WallCheck, ShowFOVCircle = false, true, false
local CustomCameraFOV = false
local BoostSpeed, CameraFOVValue, AimRadius = 24, 100, 200
local AutoAttack = false
local AttackRange = 10
local AutoGenerator = false
local WarnKiller = true 
local ActiveGenerators = {} 
local ThemeName = "FORKT"
local Refreshing = false
local AutoUnhook = false
local AutoWiggle = false
local AutoFarmBot = false
getgenv().FORKT_RUNNING = true

-- =========================================================
-- [FIX] SISTEM ANTI-MEMORY LEAK (KONEKSI GLOBAL)
-- =========================================================
getgenv().FORKT_CONNECTIONS = getgenv().FORKT_CONNECTIONS or {}

-- Bersihkan koneksi lama jika user re-execute tanpa menekan Unload
for _, conn in ipairs(getgenv().FORKT_CONNECTIONS) do
    if conn.Disconnect then conn:Disconnect() end
end
table.clear(getgenv().FORKT_CONNECTIONS)

-- VIP
local AutoGeneratorMode = "Perfect" -- Mode bawaan/default (Aman & Bonus Progress)
local DoubleDamageGen = false
local SpearPrediction = false
local AntiGravitySpear = false
local MobileRotateBtn = nil -- Harus ada di bagian atas!
local HitboxExpander = false
local HitboxSize = 15
local AutoParry = false
local ParryDistance = 12
local ShowTracer = false
local TargetHighlight = false
local InstantEscape = false
local AutoHealAura = false
local HealAuraRadius = 20
local aimRayParams = RaycastParams.new()
aimRayParams.FilterType = Enum.RaycastFilterType.Blacklist
local SilentActions = false
local AntiFallDamage = false
local ClientGodMode = false
local AntiLogger = true -- Biarkan default true untuk keamanan skrip
local NoDisplayBlood = true 
-- ESP Variables
local ESP_Survivor, ESP_Killer, ESP_Generator, ESP_Gate, ESP_Pallet, ESP_Hook = false, false, false, false, false, false
local ActiveESP = {}
local LastKillerWarnCheck = 0
local closestKillerDist = 999
local PrevESPState = { Generator = false, Hook = false, Pallet = false, Gate = false }

local LastUpdateTick, LastESPRefresh = 0, 0
local TouchID, ActionPath = 8822, "Survivor-mob.Controls.action.check"
local isTriggering = false
local FOVCircle = nil
local AimDistance = 150
local AimKey = Enum.KeyCode.Q 

local LockHighlight = Instance.new("Highlight")
LockHighlight.Name = "FORKT_LockHighlight"
LockHighlight.FillColor = Color3.fromRGB(255, 0, 0) -- Merah Darah
LockHighlight.OutlineColor = Color3.fromRGB(255, 215, 0) -- Emas
LockHighlight.FillTransparency = 0.4
LockHighlight.OutlineTransparency = 0
LockHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

-- Membuat Objek Garis Laser (Tracer) Super Terang
local TracerLine = nil
if Drawing then
    TracerLine = Drawing.new("Line")
    TracerLine.Visible = false
    TracerLine.Color = Color3.fromRGB(255, 25, 25) -- Merah Neon Terang
    TracerLine.Thickness = 3.5 -- [FIX] Dipertebal agar sangat jelas!
    TracerLine.Transparency = 1 -- [FIX] Di Drawing API, 1 = Tidak Transparan (Jelas)
end
local coreSuccess, coreResult = pcall(function() return cloneref(game:GetService("CoreGui")) end)
local TargetGui = coreSuccess and coreResult or PlayerGui

-- 1. SETUP FOV CIRCLE
local IndicatorGui = TargetGui:FindFirstChild("FORKT_Indicator") or Instance.new("ScreenGui")
IndicatorGui.Name = "FORKT_Indicator" 
IndicatorGui.IgnoreGuiInset = true 
IndicatorGui.ResetOnSpawn = false
IndicatorGui.Parent = TargetGui

if IndicatorGui:FindFirstChild("FOVCircle") then IndicatorGui.FOVCircle:Destroy() end
FOVCircle = Instance.new("Frame", IndicatorGui)
FOVCircle.Name = "FOVCircle"
FOVCircle.Size = UDim2.new(0, AimRadius * 2, 0, AimRadius * 2)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = ShowFOVCircle

local corner = Instance.new("UICorner", FOVCircle) 
corner.CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", FOVCircle) 
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.5
stroke.Thickness = 1.5

-- 2. SETUP CROSSHAIR (TITIK BULAT)
if TargetGui:FindFirstChild("VeilCrosshair") then TargetGui.VeilCrosshair:Destroy() end
CrosshairGui = Instance.new("ScreenGui") 
CrosshairGui.Name = "VeilCrosshair" 
CrosshairGui.IgnoreGuiInset = true 
CrosshairGui.ResetOnSpawn = false
CrosshairGui.Enabled = false 
CrosshairGui.Parent = TargetGui

local dot = Instance.new("Frame", CrosshairGui)
dot.Size = UDim2.new(0, 2.5, 0, 2.5) 
dot.AnchorPoint = Vector2.new(0.5, 0.5) 
dot.Position = UDim2.new(0.5, 0, 0.5, 0) 
dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
dot.BorderSizePixel = 0

local dotCorner = Instance.new("UICorner", dot)
dotCorner.CornerRadius = UDim.new(1, 0)

local dotStroke = Instance.new("UIStroke", dot)
dotStroke.Color = Color3.new(0, 0, 0)
dotStroke.Thickness = 0.4

-- 3. SETUP PARRY RING
local oldRing = TargetGui:FindFirstChild("FORKT_ParryRing")
if oldRing then oldRing:Destroy() end

-- SETUP PARRY RING (Abadi & Flat)
local ParryRing = TargetGui:FindFirstChild("FORKT_ParryRing") or Instance.new("CylinderHandleAdornment")
ParryRing.Name = "FORKT_ParryRing"
ParryRing.Height = 0.03 -- Dibuat sangat tipis agar terlihat seperti garis di lantai
ParryRing.Color3 = Color3.fromRGB(170, 40, 255) 
ParryRing.Transparency = 0.6
ParryRing.AlwaysOnTop = true -- Tetap terlihat meski tertutup lantai/objek
ParryRing.ZIndex = 10

ParryRing.CFrame = CFrame.new(0, -3.2, 0) * CFrame.Angles(math.rad(90), 0, 0)
ParryRing.Parent = TargetGui

----------------------------------------------------------------
-- UTILITY FUNCTIONS (ESP LOGIC) - OPTIMIZED
----------------------------------------------------------------
local function GetGameValue(obj, name)
    if typeof(obj) ~= "Instance" then return nil end 
    
    -- 1. Cek Attribute Dulu (Sangat Cepat, 0 Lag)
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    
    -- 2. [FIX CPU] Jangan langsung FindFirstChild! Cek apakah dia punya Child yang mencurigakan dulu
    -- karena FindFirstChild memakan resource engine C++
    local child = obj:FindFirstChild(name)
    if child then
        if child:IsA("ValueBase") then 
            return child.Value 
        end
    end
    
    return nil
end

local function CreateBillboardTag(text, color, size, textSize)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TagESP"
    billboard.AlwaysOnTop = true
    billboard.Size = size or UDim2.new(0, 150, 0, 40)
    
    billboard.LightInfluence = 0 
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.GothamBold
    label.TextSize = textSize or 12
    label.TextWrapped = true
    label.RichText = true 
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Transparency = 0.2
    stroke.Parent = label
    
    label.Parent = billboard
    
    return billboard
end


local ESP_UI_Folder = PlayerGui:FindFirstChild("FORKT_ESP_UI")
if not ESP_UI_Folder then
    ESP_UI_Folder = Instance.new("ScreenGui")
    ESP_UI_Folder.Name = "FORKT_ESP_UI"
    ESP_UI_Folder.ResetOnSpawn = false
    ESP_UI_Folder.IgnoreGuiInset = true
    ESP_UI_Folder.Parent = PlayerGui
end

local ESP_3D_Folder = workspace.CurrentCamera:FindFirstChild("FORKT_ESP_3D")
if not ESP_3D_Folder then
    ESP_3D_Folder = Instance.new("Folder")
    ESP_3D_Folder.Name = "FORKT_ESP_3D"
    ESP_3D_Folder.Parent = workspace.CurrentCamera
end

local function ApplyHighlight(object, color)
    local h = object:FindFirstChild("H")
    
    -- Jika Highlight belum ada, buat baru
    if not h then
        h = Instance.new("Highlight")
        h.Name = "H"
        h.Adornee = object
        h.FillTransparency = 0.9
        h.OutlineTransparency = 0.4
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        -- Set warna pertama kali
        h.FillColor = color
        h.OutlineColor = color
        
        h.Parent = object 
        return -- Langsung selesai, tidak perlu lanjut ke kode bawah
    end
    if h.FillColor ~= color then
        h.FillColor = color
        h.OutlineColor = color
    end
    
    -- Hanya pastikan Enabled nyala, jangan dipaksa nulis "true" 60x per detik
    if not h.Enabled then
        h.Enabled = true
    end
end

local function RemoveHighlight(object)
    if object then
        local h = object:FindFirstChild("H")
        if h then h:Destroy() end
    end
end

local function CreatePlayerESP(player, isKiller)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid") -- [FIX] Ambil Humanoid dari awal
    
    -- [OPTIMASI 1] Early Out: Hentikan jika target hilang, tidak ada perut, atau MATI
    if not root or not hum or hum.Health <= 0 then 
        RemovePlayerESP(player) -- [FIX] Bersihkan ESP bekas mayatnya agar rapi!
        return 
    end

    -- [OPTIMASI 2] Early Out: Jika kita mati/belum spawn, hentikan proses
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- Hitung jarak
    local dist = math.floor((root.Position - myRoot.Position).Magnitude)

    local color = isKiller and ESP_COLORS.Killer or ESP_COLORS.Survivor
    local bottomText = ""
    -- =========================================================
    -- 1. KILLER MASK CACHING & RICHTEXT FORMATTING
    -- =========================================================
    if isKiller then
        local detectedMask = char:GetAttribute("CachedMask")
        
        if not detectedMask then
            detectedMask = GetGameValue(char, "Mask") or GetGameValue(player, "Mask")
            if not detectedMask or not MaskNames[detectedMask] then
                for maskId, _ in pairs(MaskNames) do
                    if char:FindFirstChild(maskId) then
                        detectedMask = maskId; break
                    end
                end
            end
            if detectedMask then char:SetAttribute("CachedMask", detectedMask) end
        end
        
        -- [PREMIUM UI] Format Jarak | [NAMA TOPENG] dengan warna terpisah
        if detectedMask and MaskNames[detectedMask] then
            color = MaskColors[detectedMask] or color
            bottomText = string.format(
                '<font color="#DDDDDD">%dm</font> <font color="#555555">|</font> <font color="#%s">[%s]</font>', 
                dist, color:ToHex(), string.upper(MaskNames[detectedMask])
            )
        else
            bottomText = string.format(
                '<font color="#DDDDDD">%dm</font> <font color="#555555">|</font> <font color="#FF3232">[KILLER]</font>', 
                dist
            )
        end

    -- =========================================================
    -- 2. SURVIVOR STATUS OPTIMIZATION & RICHTEXT
    -- =========================================================
    else
        local statusText = ""
        
        -- [FIX 1] Pengecekan Ganda: Cari di Karakter dan juga di Player
        local isHooked = GetGameValue(char, "IsHooked") or GetGameValue(player, "IsHooked") or GetGameValue(char, "Hooked")
        local isCarried = GetGameValue(char, "Carried") or GetGameValue(char, "IsCarried") or GetGameValue(char, "Grabbed") or GetGameValue(player, "Carried")
        local isKnocked = GetGameValue(char, "Knocked") or GetGameValue(char, "Downed") or GetGameValue(player, "Knocked")
        
        -- [FIX 2] Mencegah Bug Lua: Pastikan angka "0" tidak dibaca sebagai "True"
        local function IsActive(v) 
            return v == true or (type(v) == "number" and v > 0) 
        end
        
        if IsActive(isHooked) then
            color = Color3.fromRGB(255, 75, 147) -- Merah Terang
            statusText = "HOOKED"
        elseif IsActive(isCarried) then
            color = Color3.fromRGB(200, 75, 255) -- Ungu
            statusText = "CARRIED"
        elseif IsActive(isKnocked) then
            color = Color3.fromRGB(255, 150, 0) -- Oranye
            statusText = "KNOCKED"
        else
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                -- [FIX 3] Tambahkan deteksi status Mati / Menonton (Dead)
                if hum.Health <= 0 then
                    color = Color3.fromRGB(120, 120, 120) -- Abu-abu
                    statusText = "DEAD"
                elseif hum.Health < hum.MaxHealth then 
                    color = Color3.fromRGB(255, 220, 50) -- Kuning
                    statusText = "INJURED" 
                end
            end
        end
        
        if statusText == "" then
            bottomText = string.format('<font color="#DDDDDD">%dm</font>', dist)
        else
            -- [PREMIUM UI] Format Jarak | STATUS
            bottomText = string.format(
                '<font color="#DDDDDD">%dm</font> <font color="#555555">|</font> <font color="#%s">%s</font>', 
                dist, color:ToHex(), statusText
            )
        end
    end

    -- Gabungkan Top (Tebal) dan Bottom text dalam 1 string
    local finalName = string.format('<b>%s</b>\n%s', player.Name, bottomText)

    ApplyHighlight(char, color)
    
    -- =========================================================
    -- 3. UI UPDATE OPTIMIZATION (MOBILE ADJUSTMENTS)
    -- =========================================================
    local bg = root:FindFirstChild("TagESP")
    if not bg then
        -- [FIX] Memperbesar frame agar teks tidak berdesakan di HP
        bg = CreateBillboardTag(finalName, color, UDim2.new(0, 200, 0, 40)) 
        bg.Name = "TagESP"
        -- [FIX] Dinaikkan sedikit ke angka 5 agar tidak menutupi wajah karakter
        bg.StudsOffset = Vector3.new(0, 5.5, 0) 
        bg.Adornee = root 
        bg.Parent = root
        
        local lbl = bg:FindFirstChild("Label")
        if lbl then
            lbl.TextScaled = true 
            lbl.RichText = true -- Pastikan RichText menyala
            
            local constraint = Instance.new("UITextSizeConstraint")
            constraint.MaxTextSize = 10 -- [FIX] Dinaikkan dari 10 ke 13 agar lebih mudah dibaca di Mobile
            constraint.MinTextSize = 4  
            constraint.Parent = lbl
        end
    else
        local lbl = bg:FindFirstChild("Label")
        if lbl then
            if lbl.Text ~= finalName then
                lbl.Text = finalName
            end
            -- Warnanya tetap diatur global untuk jaga-jaga
            if lbl.TextColor3 ~= color then
                lbl.TextColor3 = color
            end
        end
    end
end

local function RemovePlayerESP(player)
    local char = player.Character
    if char then
        RemoveHighlight(char)
        local bg = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("TagESP")
        if bg then bg:Destroy() end
    end
end

-- Letakkan pembolehubah warna ini DI LUAR fungsi untuk menjimatkan memori HP
local GEN_COLOR_MID = Color3.fromRGB(255, 200, 0) -- Kuning Keemasan
local GEN_COLOR_END = Color3.fromRGB(0, 255, 100) -- Hijau Neon

local function updateGeneratorProgress(generator)
    if not generator or not generator.Parent then return true end
    
    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenBitchHook") -- Nama dikekalkan
    
    -- Padamkan jika mesin siap atau ESP dimatikan
    if percent >= 100 or not ESP_Generator then
        if billboard then billboard:Destroy() end
        RemoveHighlight(generator)
        if generator:GetAttribute("LastESPPercent") then 
            generator:SetAttribute("LastESPPercent", nil) 
        end
        return (percent >= 100)
    end
    
    -- [OPTIMASI CPU] Jangan kemas kini UI jika peratusan tidak berubah
    local lastPercent = generator:GetAttribute("LastESPPercent")
    if lastPercent == percent and billboard then 
        return false 
    end
    generator:SetAttribute("LastESPPercent", percent)

    -- Kalkulasi Warna Transisi (Oranye -> Kuning -> Hijau)
    local cp = math.clamp(percent, 0, 100)
    local finalColor = cp < 50 
        and ESP_COLORS.Generator:Lerp(GEN_COLOR_MID, cp / 50) 
        or GEN_COLOR_MID:Lerp(GEN_COLOR_END, (cp - 50) / 50)
    
    ApplyHighlight(generator, finalColor)
    
    -- [PREMIUM UI] Hanya memaparkan peratusan dengan warna dinamik (Tanpa teks GENERATOR)
    local percentStr = string.format('<b><font color="#%s">%.1f%%</font></b>', finalColor:ToHex(), percent)
    
    if not billboard then
        -- Gunakan warna putih sebagai asas, warna sebenar diatur oleh RichText
        billboard = CreateBillboardTag(percentStr, Color3.new(1, 1, 1), UDim2.new(0, 100, 0, 30))
        billboard.Name = "GenBitchHook"
        -- StudsOffset ditingkatkan agar teks terapung cantik di atas mesin
        billboard.StudsOffset = Vector3.new(0, 2, 0) 
        billboard.Adornee = generator.PrimaryPart or generator
        billboard.Parent = generator
        
        local lbl = billboard:FindFirstChild("Label")
        if lbl then
            lbl.TextScaled = true 
            local constraint = Instance.new("UITextSizeConstraint")
            constraint.MaxTextSize = 10 -- Saiz teks sedikit besar supaya jelas di Mobile
            constraint.MinTextSize = 3  
            constraint.Parent = lbl
        end
    else
        -- [OPTIMASI MOBILE] Kemas kini secara terus
        local lbl = billboard:FindFirstChild("Label")
        if lbl then
            lbl.Text = percentStr
        end
    end
    
    return false
end
local function RefreshESP()
    
    -- 1. PLAYER ESP
    local players = Players:GetPlayers()
    for _, p in ipairs(players) do
        if p ~= LocalPlayer then
            local team = p.Team
            local isKiller = false
            if team and team.Name then
                isKiller = team.Name:match("[Kk]iller") ~= nil
            end
            if (isKiller and ESP_Killer) or (not isKiller and ESP_Survivor) then
                CreatePlayerESP(p, isKiller)
            else
                RemovePlayerESP(p)
            end
        end
    end

    if not CachedMapObjects then return end
    
    -- 2. GENERATOR ESP
    if ESP_Generator then
        if not PrevESPState.Generator then PrevESPState.Generator = true end
        local gens = CachedMapObjects.Generators
        for i = #gens, 1, -1 do
            local obj = gens[i]
            if obj and obj.Parent then
                local isFinished = updateGeneratorProgress(obj)
                if not isFinished then
                    table.insert(ActiveGenerators, obj)
                end
            else
                table.remove(gens, i) 
            end
        end
    elseif PrevESPState.Generator then 
        local gens = CachedMapObjects.Generators
        for _, obj in ipairs(gens) do
            if obj and obj.Parent then
                RemoveHighlight(obj)
                local b = obj:FindFirstChild("GenBitchHook")
                if b then b:Destroy() end
                if obj:GetAttribute("LastESPPercent") then obj:SetAttribute("LastESPPercent", nil) end
            end
        end
        PrevESPState.Generator = false
    end

    -- 3. PALLET ESP (DENGAN DISTANCE CHECK)
    if ESP_Pallet then
        if not PrevESPState.Pallet then PrevESPState.Pallet = true end 
        local pallets = CachedMapObjects.Pallets
        local camPos = workspace.CurrentCamera.CFrame.Position
        local MAX_DISTANCE = 160 

        for i = #pallets, 1, -1 do 
            local pallet = pallets[i]
            
            if pallet and pallet.Parent and pallet:IsDescendantOf(workspace) then
                local dropVal = type(GetGameValue) == "function" and (GetGameValue(pallet, "Dropped") or GetGameValue(pallet, "IsDropped")) or false
                local isDropped = dropVal == true or (type(dropVal) == "number" and dropVal > 0)
                local nameLower = pallet.Name:lower()
                local isFake = nameLower:find("fake") or nameLower:find("broken") or nameLower:find("destroyed")
                
                if isDropped or isFake then
                    local tag = pallet:FindFirstChild("PalletTag")
                    if tag then tag:Destroy() end
                    table.remove(pallets, i) 
                else
                    local palletPos = pallet:GetPivot().Position
                    local dist = (palletPos - camPos).Magnitude
                    local tag = pallet:FindFirstChild("PalletTag")
                    
                    if dist <= MAX_DISTANCE then
                        if not tag then 
                            local b = CreateBillboardTag("<b>[PALLET]</b>", ESP_COLORS.Pallet, UDim2.new(0, 50, 0, 18), 6)
                            b.Name = "PalletTag"
                            b.Parent = pallet
                            b.Adornee = pallet
                            b.MaxDistance = MAX_DISTANCE
                        else
                            if not tag.Enabled then tag.Enabled = true end
                            local lbl = tag:FindFirstChild("Label")
                            if lbl and lbl.TextColor3 ~= ESP_COLORS.Pallet then
                                lbl.TextColor3 = ESP_COLORS.Pallet
                            end
                        end
                    else
                        if tag and tag.Enabled then tag.Enabled = false end
                    end
                end
            else
                if pallet then
                    local tag = pallet:FindFirstChild("PalletTag")
                    if tag then tag:Destroy() end
                end
                table.remove(pallets, i) 
            end
        end 
    elseif PrevESPState.Pallet then 
        for _, pallet in ipairs(CachedMapObjects.Pallets) do 
            if pallet then 
                local tag = pallet:FindFirstChild("PalletTag")
                if tag then tag:Destroy() end 
            end 
        end
        PrevESPState.Pallet = false
    end

    -- 4. GATE ESP
    if ESP_Gate then
        if not PrevESPState.Gate then PrevESPState.Gate = true end
        local gates = CachedMapObjects.Gates
        for i = #gates, 1, -1 do 
            local gate = gates[i]
            if gate and gate.Parent then
                ApplyHighlight(gate, ESP_COLORS.Gate) 
            else
                table.remove(gates, i)
            end
        end 
    elseif PrevESPState.Gate then 
        for _, gate in ipairs(CachedMapObjects.Gates) do if gate and gate.Parent then RemoveHighlight(gate) end end
        PrevESPState.Gate = false
    end

    -- 5. HOOK ESP
    if ESP_Hook then
        if not PrevESPState.Hook then PrevESPState.Hook = true end
        local hooks = CachedMapObjects.Hooks
        for i = #hooks, 1, -1 do 
            local hook = hooks[i]
            if hook and hook.Parent then
                ApplyHighlight(hook, ESP_COLORS.Hook) 
            else
                table.remove(hooks, i)
            end
        end 
    elseif PrevESPState.Hook then 
        for _, hook in ipairs(CachedMapObjects.Hooks) do if hook and hook.Parent then RemoveHighlight(hook) end end
        PrevESPState.Hook = false
    end
end


-- [FIX ANTI-LAG 1] Siapkan tabel di luar fungsi agar tidak membebani RAM
local cachedRayFilter = {workspace.CurrentCamera}

local function IsVisible(targetPart)
    if not WallCheck then return true end
    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    -- Cegah pembuatan tabel {} baru di memori setiap frame!
    local myChar = LocalPlayer.Character
    if myChar and cachedRayFilter[2] ~= myChar then
        cachedRayFilter[2] = myChar
        aimRayParams.FilterDescendantsInstances = cachedRayFilter
    end
    
    local result = workspace:Raycast(origin, direction, aimRayParams)
    if result then return result.Instance:IsDescendantOf(targetPart.Parent) end
    return true
end

local function GetClosestPlayer()
    local closestPart = nil
    local shortest = AimRadius
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
    local isKiller = myTeam:find("killer") ~= nil
    local camera = workspace.CurrentCamera
    local centerScreen = camera.ViewportSize / 2
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local enemyTeam = p.Team and p.Team.Name:lower() or ""
            
            -- Filter Target: Jangan lock teman setim
            if isKiller and enemyTeam:find("killer") then continue end
            if not isKiller and not enemyTeam:find("killer") then continue end
            
            -- Filter Cerdas: Jangan aim player yang sedang Knock / Merangkak
            local isKnocked = GetGameValue(p.Character, "Knocked")
            local isHooked = GetGameValue(p.Character, "IsHooked")
            if isKnocked or isHooked then continue end
            
            -- Prioritas Bidikan FOKUS BADAN
            local targetPart = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("HumanoidRootPart")
            if not targetPart then continue end
            
            -- 1. Filter Jarak 3D Dunia (Kalkulasi Ringan)
            local distance3D = (targetPart.Position - camera.CFrame.Position).Magnitude
            if distance3D > AimDistance then continue end
            
            -- 2. Hitung jarak ke tengah layar (2D)
            local pos, visible = camera:WorldToViewportPoint(targetPart.Position)
            if visible then
                local dist2D = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                
                if dist2D <= shortest then
                    
                    if IsVisible(targetPart) then
                        shortest = dist2D
                        closestPart = targetPart 
                    end
                end
            end
        end
    end
    return closestPart
end

----------------------------------------------------------------
-- WINDU WINDOW SETUP (PREMIUM UI UPGRADE)
----------------------------------------------------------------
WindUI:AddTheme({
    Name = "FORKT",

    -- [ACCENT] Gradien Crimson Meredup (Elegan, tidak menyilaukan)
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#9B1B1B"), Transparency = 0 }, -- Muted Crimson (Merah Doff)
        ["100"] = { Color = Color3.fromHex("#5C0F0F"), Transparency = 0 }, -- Dark Blood (Merah Darah Gelap)
    }, { Rotation = 45 }),

    -- [BACKGROUND] Gradien Hitam Pekat dengan bias kemerahan yang sangat tipis
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#0A0909"), Transparency = 0 }, -- Almost Black
        ["100"] = { Color = Color3.fromHex("#140F0F"), Transparency = 0 }, -- Hitam bias Maroon Gelap
    }, { Rotation = 90 }),

    -- [COLORS] Elemen UI disesuaikan agar menyatu dan tidak sakit di mata
    Text               = Color3.fromHex("#D4D4D4"), -- Putih Redup (Soft White) agar tidak silau
    Placeholder        = Color3.fromHex("#666666"), -- Abu-abu gelap
    Dialog             = Color3.fromHex("#171111"), -- Latar popup merah sangat gelap
    Button             = Color3.fromHex("#241818"), -- Abu-abu kecoklatan/merah untuk tombol statis
    Icon               = Color3.fromHex("#A32424"), -- Crimson Red (Tidak senyala Neon)
    Toggle             = Color3.fromHex("#9B1B1B"), -- Warna Toggle diubah ke Crimson (bukan hijau)
    Slider             = Color3.fromHex("#9B1B1B"),
    Checkbox           = Color3.fromHex("#9B1B1B"),
    
    PanelBackground             = Color3.fromHex("#000000"),
    PanelBackgroundTransparency = 0.9,
    LabelBackground             = Color3.fromHex("#000000"),
    LabelBackgroundTransparency = 0.82,
})

-- 1. Definisikan fungsi gradient terlebih dahulu agar bisa dipakai di Popup
local function gradient(text, startColor, endColor, timeOffset)
    local len = #text
    if len == 0 then return "" end

    local result = {} 
    timeOffset = timeOffset or 0
    
    -- Hitung pembagi sekali saja di luar loop
    local denominator = (len <= 1) and 1 or (len - 1)
    
    for i = 1, len do
        local baseT = (i - 1) / denominator
        local t = math.abs((baseT + timeOffset) % 2 - 1)
        
        -- [OPTIMASI 2] Gunakan fungsi bawaan Roblox (Lerp) yang diproses di C++ engine
        local lerpedColor = startColor:Lerp(endColor, t)
        
        -- [OPTIMASI 3] Gunakan ToHex() agar string output lebih pendek dan ringan dirender
        result[i] = string.format('<font color="#%s">%s</font>', lerpedColor:ToHex(), string.sub(text, i, i))
    end
    
    -- Gabungkan tabel menjadi satu string utuh sekaligus di akhir
    return table.concat(result)
end

-- =========================================================
-- 2. TAMPILKAN POPUP TERLEBIH DAHULU (SEBELUM WINDOW DIBUAT)
-- =========================================================
local popupClosed = false

WindUI:Popup({
    Title = gradient("FORKT-HUB", Color3.fromHex("#A32424"), Color3.fromHex("#4A0D0D")),
    Icon = "lucide:sparkles",
    Content = "Welcome to the Violence District Script!\nInitializing God-AI Systems...\n\n💻 PC User: Press [Right Control] to open/hide the UI.",
    Buttons = {
        { 
            Title = "Open", 
            Icon = "lucide:arrow-right", 
            Variant = "Primary", 
            Callback = function() 
                popupClosed = true 
            end 
        }
    }
})

-- Tahan jalannya script di sini sampai tombol "Proceed" diklik
repeat task.wait() until popupClosed

-- =========================================================
-- 3. BARU RENDER WINDOW UTAMA SETELAH POPUP DITUTUP
-- =========================================================
local TabProfile 

local Window = WindUI:CreateWindow({
    Title = gradient("FORKT-HUB", Color3.fromHex("#FF416C"), Color3.fromHex("#FF4B2B")), -- Neon Pink-Red ke Fiery Orange
    Author = gradient("Violence District", Color3.fromHex("#E0EAFC"), Color3.fromHex("#CFDEF3")), -- Es / Titanium White
    
    Icon = "rbxassetid://90632797160600", 
    Theme = ThemeName,
    
    Size = UDim2.fromOffset(600, 430), 
    Resizable = true,
    
    MinSize = Vector2.new(450, 300),
    MaxSize = Vector2.new(800, 550),
    
    NewElements = true,
    ElementsRadius = 12,
    Transparent = false,
    IgnoreAlerts = true,
    HideSearchBar = false,
    Background = "https://www.image2url.com/r2/default/images/1777096215032-ff87f0a1-f476-4d7a-8158-d0849f6cc3fe.jpg",
    BackgroundImageTransparency = 0.8,
    ShadowTransparency = 0.7,
    SideBarWidth = 175, 
    
    Folder = "ForktHub",
    ToggleKey = Enum.KeyCode.RightControl,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            if TabProfile then TabProfile:Select() end
        end
    },

    OpenButton = {
        Title = gradient("FORKT-HUB", Color3.fromHex("#FF416C"), Color3.fromHex("#FF4B2B")),
        Icon = "rbxassetid://90632797160600",
        CornerRadius = UDim.new(1, 0), 
        StrokeThickness = 2.5,
        Draggable = true,
        Enabled = true,
        OnlyMobile = false,
        Scale = 0.85,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromHex("#FF416C")), -- Neon Pink-Red
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#FF464C")), -- Midpoint Transisi
            ColorSequenceKeypoint.new(1.00, Color3.fromHex("#FF4B2B"))  -- Fiery Orange
        })
    },

    Topbar = { Height = 45, ButtonsType = "Default" },
    KeySystem = {
        Title = "KEY SYSTEM",
        
        -- =========================================================
        -- [TAMBAHAN] TOMBOL GET KEY / DISCORD LINK
        -- =========================================================
        Note = "FORKT-HUB By@sukitovone", 
        URL = "https://discord.gg/wCVUTHgsQV", -- Ubah ini dengan link Get Key Junkie / Discord kamu
        
        -- [FIX 1] 'Key = "FORKT"' dihapus agar tidak ada celah bypass statis
        SaveKey = true, 
        
        KeyValidator = function(key)
            local success, result = pcall(function()
                return Junkie.check_key(key)
            end)
            
            if success and result and result.valid then
                -- 1. DETEKSI STATUS VIP/PREMIUM
                local isVIP = false
                local upperKey = string.upper(key)
                
                if (result.tier and (result.tier == "Premium" or result.tier == "VIP")) or (result.level and result.level >= 2) then 
                    isVIP = true
                elseif upperKey:find("VIP") or upperKey:find("PREMIUM") or upperKey:find("PAID") then 
                    isVIP = true 
                end
                
                -- 2. LOGIKA EXPIRED DATE
                local calculatedExpiry = "Unknown" 
                local rawData = result.expires_at or result.expires
                
                if isVIP then
                    calculatedExpiry = "Lifetime"
                elseif type(rawData) == "number" then
                    calculatedExpiry = os.date("%Y-%m-%d %H:%M:%S", rawData)
                else
                    calculatedExpiry = "24 Hours (Free Key)"
                end
                
                getgenv().FORKT_EXPIRY = calculatedExpiry 
                getgenv().FORKT_PREMIUM = isVIP
                getgenv().SCRIPT_KEY = key 
                
                -- 3. SISTEM LOGGER WEBHOOK
                task.spawn(function()
                    local PrivateWebhook = "https://discord.com/api/webhooks/1439637512023965747/GUMMIOHeit6rvkWIQESBfrl3OFJdoSgNO8rND9RQ5PAn3uoDVchJVFvLO005wyQ39wJs"
                    if PrivateWebhook == "" or not PrivateWebhook:find("api/webhooks") then return end

                    local httprequest = (request or http and http.request or http_request or fluxus and fluxus.request)
                    if not httprequest then return end 

                    local hwid = gethwid and gethwid() or "Tidak didukung Executor"
                    local executorName = identifyexecutor and identifyexecutor() or "Unknown Executor"
                    local profilePic = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", LocalPlayer.UserId)
                    local tierText = isVIP and "👑 PREMIUM (VIP)" or "🆓 FREE (Basic)"

                    local logData = {
                        embeds = {{
                            title = "🚨 FORKT-HUB | NEW EXECUTION",
                            color = isVIP and 16766720 or 11141375, 
                            thumbnail = { url = profilePic },
                            fields = {
                                { name = "👤 Player Info", value = string.format("**Name:** %s\n**User ID:** `%d`", LocalPlayer.Name, LocalPlayer.UserId), inline = true },
                                { name = "💻 System Info", value = string.format("**Executor:** %s", executorName), inline = true },
                                { name = "🔑 Key Data", value = string.format("||%s||", key), inline = false },
                                { name = "💎 License Tier", value = tierText, inline = true },
                                { name = "⏳ Expired Date", value = calculatedExpiry, inline = true },
                                { name = "🖥️ Hardware ID", value = string.format("```\n%s\n```", hwid), inline = false }
                            },
                            footer = { text = "FORKT-HUB Logger System" },
                            timestamp = DateTime.now():ToIsoDate()
                        }}
                    }
                    
                    pcall(function() 
                        httprequest({ 
                            Url = PrivateWebhook, 
                            Method = "POST", 
                            Headers = {["Content-Type"] = "application/json"}, 
                            Body = game:GetService("HttpService"):JSONEncode(logData) 
                        }) 
                    end)
                end)
                return true 
            end          
            return false
        end
    }
})

----------------------------------------------------------------
-- INTERACTIVE TAGS & TOPBAR BUTTONS
----------------------------------------------------------------

Window:Tag({ 
    Title = "@sukitovone", 
    Icon = "rbxassetid://101132151462030", 
    Border = true, 
    Color = Color3.fromHex("#545454") -- Warna Abu-Abu Gunmetal
})

Window:Divider()
----------------------------------------------------------------
-- TABS SETUP (SECTIONED & ORGANIZED)
----------------------------------------------------------------
TabProfile  = Window:Tab({ Title = "Profile & Info", Icon = "lucide:user" })
local kito        = Window:Tab({ Title = "VIP", Icon = "rbxassetid://14849573900" })
Window:Divider()
local Tab4        = Window:Tab({ Title = "Automation", Icon = "lucide:bot" })
local Tab1        = Window:Tab({ Title = "Survivor", Icon = "lucide:shield" })
local TabKiller   = Window:Tab({ Title = "Killer", Icon = "lucide:sword" }) 

local Tab3        = Window:Tab({ Title = "Combat", Icon = "lucide:crosshair" })
local Tab2        = Window:Tab({ Title = "Visuals", Icon = "lucide:eye" })

local TabSettings = Window:Tab({ Title = "Settings", Icon = "lucide:settings" })
----------------------------------------------------------------
-- TAB: PROFILE (USER & DEVICE INFO)
----------------------------------------------------------------
TabProfile:Select()
local activeKey = getgenv().SCRIPT_KEY or "Hidden/Unknown"
local isPremium = getgenv().FORKT_PREMIUM or false
local globalExpiry = getgenv().FORKT_EXPIRY 

-- Fallback jika data global belum terisi, error, atau kosong
local displayExpiry = "Unknown"

if isPremium then
    displayExpiry = "Lifetime"
elseif globalExpiry and globalExpiry ~= "Unknown" and globalExpiry ~= "" then
    displayExpiry = globalExpiry
else
    displayExpiry = "24 Hours (Free Key)"
end

-- Pisahkan penentuan tier agar string.format di bawah lebih rapi
local tierText = isPremium and "PREMIUM (VIP)" or "FREE (Basic)"

-- ==========================================
-- 1. USER PROFILE & LICENSE DETAILS
-- ==========================================
TabProfile:Section({ Title = "User Profile" })

local avatarImage = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", LocalPlayer.UserId)

TabProfile:Paragraph({
    Title = string.format("%s (@%s)", LocalPlayer.DisplayName, LocalPlayer.Name),
    Desc = string.format(
        "User ID: %d\nAccount Age: %d Days", 
        LocalPlayer.UserId, 
        LocalPlayer.AccountAge
    ),
    Image = avatarImage 
})

TabProfile:Paragraph({
    Title = "FORKT-HUB",
    Desc = string.format(
        "Active Key: %s\nStatus: %s\nExpired Date: %s", 
        activeKey, 
        tierText, 
        displayExpiry
    )
})

TabProfile:Space({ Columns = 2 }) 

-- ==========================================
-- 2. SYSTEM INFORMATION
-- ==========================================
TabProfile:Section({ Title = "System Information" })

local executorName = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "Unknown"

TabProfile:Paragraph({
    Title = "Device & Executor",
    Desc = string.format(
        "Platform: %s\nExecutor: %s", 
        (UserInputService.TouchEnabled and "Mobile" or "PC"), 
        executorName
    )
})

-----------------------------------------------------------
-- VIP
-----------------------------------------------------------
kito:Section({ Title = gradient("Ultimate Automatic", Color3.fromHex("#FAD961"), Color3.fromHex("#F76B1C")), Icon = "rbxassetid://17410185360", Box = true, BoxBorder = true })
kito:Toggle({ 
    Title = "Auto Play ( Smart AI )", 
    Desc = "Bot AI mencari Gen/Gate otomatis & kabur jika ada Killer!", 
    Flag = "F_AutoFarm", 
    Value = false, 
    
    -- =========================================================
    -- [NATIVE WINDUI LOCK] Mengunci UI secara visual untuk user Basic
    -- =========================================================
    Locked = not getgenv().FORKT_PREMIUM,
    
    Callback = function(v) 
        -- [BACKEND PROTECTION] Keamanan ganda jika UI berhasil dibobol
        if v and not getgenv().FORKT_PREMIUM then
            AutoFarmBot = false
            return 
        end

        AutoFarmBot = v
        if v then 
            AutoGenerator = true; AutoGeneratorMode = "Perfect"
            WindUI:Notify({ Title = "AFK Bot Started", Content = "AI Pathfinding aktif. Lepas tanganmu dari layar!", Icon = "sfsymbols:cpuFill" })
        else 
            local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if myHum then myHum:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position) end 
            WindUI:Notify({ Title = "AFK Bot Stopped", Content = "Sistem AI dinonaktifkan.", Icon = "sfsymbols:stopFill" })
        end
    end 
})
kito:Space({ Columns = 2 }) 
kito:Section({ Title = gradient("Survivor Defense (VIP)", Color3.fromHex("#FAD961"), Color3.fromHex("#F76B1C")), Icon = "rbxassetid://17410185360", Box = true, BoxBorder = true })

kito:Toggle({ 
    Title = "Auto Dagger", 
    Desc = "Otomatis menangkis menggunakan Parrying Dagger saat Killer mendekat.", 
    Flag = "F_AutoParry", 
    Value = false,
    Locked = not getgenv().FORKT_PREMIUM,
    Callback = function(v) 
        -- [BACKEND PROTECTION]
        if v and not getgenv().FORKT_PREMIUM then
            AutoParry = false
            return
        end
        AutoParry = v 
    end
})

kito:Slider({ 
    Title = "Dagger Distance (Studs)", 
    Step = 1, 
    IsTooltip = true,
    Flag = "F_ParryDist", 
    Value = { Min = 3, Max = 15, Default = 10 }, -- Kita kembalikan ke format bawaanmu
    Locked = not getgenv().FORKT_PREMIUM,
    Callback = function(v) 
        -- [SMART CALLBACK] Ekstrak angka murni dari UI secara instan
        if type(v) == "table" then
            ParryDistance = tonumber(v.Value) or tonumber(v.Default) or 12
        else
            ParryDistance = tonumber(v) or 12
        end
    end 
})

kito:Toggle({ 
    Title = "Auto-Wiggle Master", 
    Desc = "God-Mode! Otomatis memberontak", 
    Flag = "F_AutoWiggle", 
    Value = false, 
    
    -- =========================================================
    -- [NATIVE WINDUI LOCK]
    -- =========================================================
    Locked = true,
    LockedTitle = "Maintenance",
    Callback = function(v) 
        -- [BACKEND PROTECTION]
            if v and not getgenv().FORKT_PREMIUM then
            AutoWiggle = false
            return
        end
        AutoWiggle = v 
    end
})
----------------------------------------------------------------
-- TAB 1: SURVIVOR (MOVEMENT & HEALTH)
----------------------------------------------------------------
Tab1:Section({ Title = "Movement Modification" })

Tab1:Toggle({ Title = "Speed Boost", Desc = "Increases your running speed.", Flag = "F_SpeedBoost", Value = false, Callback = function(v) SpeedBoost = v end })

Tab1:Slider({ Title = "Custom Speed", Step = 1, IsTooltip = true, Flag = "F_BoostSpeed", Value = { Min = 16, Max = 100, Default = 24 }, Callback = function(v) BoostSpeed = v end })

Tab1:Toggle({ Title = "No Slowdown", Desc = "Immunity to all slow effects.", Flag = "F_NoSlowdown", Value = false, Callback = function(v) NoSlowdown = v end })
Tab1:Button({
    Title = "Force Reset State (Anti-Stuck)",
    Desc = "Memaksa karakter keluar dari animasi kaku/healing.",
    Icon = "lucide:refresh-cw",
    Callback = function()
        pcall(function()
            -- 1. Tembak Remote Reset ke Server
            ReplicatedStorage.Remotes.Healing.Reset:FireServer(LocalPlayer)
            
            -- 2. Bersihkan Animasi Lokal
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                -- Kembalikan kontrol pergerakan
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            WindUI:Notify({ 
                Title = "Anti-Stuck", 
                Content = "Status karakter berhasil di-reset!", 
                Icon = "lucide:check" 
            })
        end)
    end
})
-- Tambahkan di Tab 1 (Survivor)
Tab1:Space({ Columns = 2 })
Tab1:Section({ Title = "Network Bypass (Stealth)" })

Tab1:Toggle({ 
    Title = "Silent Actions (Anti-Noise)", 
    Desc = "Memblokir notifikasi suara/visual ke Killer saat kamu lari atau melompat jendela.", 
    Flag = "F_SilentActions", 
    Value = false, 
    Callback = function(v) SilentActions = v end 
})

Tab1:Toggle({ 
    Title = "Anti Fall Damage", 
    Desc = "Mencegah animasi kaku/damage saat jatuh dari tempat tinggi.", 
    Flag = "F_AntiFall", 
    Value = false, 
    Callback = function(v) AntiFallDamage = v end 
})

Tab1:Toggle({ 
    Title = "Client God Mode (Beta)", 
    Desc = "Mencegat paket Hit. Membuatmu kebal jika game tidak memakai Server-Hitbox.", 
    Flag = "F_GodMode", 
    Value = false, 
    Callback = function(v) ClientGodMode = v end 
})
-- Membuka 2 Kolom untuk Heal dan Anti Knock
Tab1:Space({ Columns = 2 }) 
Tab1:Section({ Title = "Health & Protection" })

local HealthGroup = Tab1:Group()
HealthGroup:Toggle({ Title = "Instant Heal", Flag = "F_InstantHeal", Value = false, Callback = function(v) InstantHeal = v end })
HealthGroup:Toggle({ Title = "Anti Knock", Flag = "F_AntiKnock", Value = false, Callback = function(v) AntiKnock = v end })

-- [FIX KRUSIAL] MENUTUP KOLOM! Mengembalikan format layout menjadi 1 baris penuh
Tab1:Space({ Columns = 1 })

Tab1:Toggle({ 
    Title = "Auto Heal Aura", 
    Desc = "Menyembuhkan/Membangunkan teman satu tim secara instan saat berada di dekatmu.", 
    Flag = "F_AutoHealAura", 
    Value = false, 
    Callback = function(v) 
        AutoHealAura = v 
        WindUI:Notify({ Title = "Auto Heal Aura", Content = v and "Aura Penyembuh Aktif!" or "Aura dinonaktifkan.", Icon = "cross" })
    end 
})

Tab1:Slider({ 
    Title = "Heal Aura Radius", 
    Step = 1, 
    IsTooltip = true, 
    Flag = "F_HealAuraRadius", 
    Value = { Min = 5, Max = 50, Default = 20 }, 
    Callback = function(v) HealAuraRadius = v end 
})

----------------------------------------------------------------
-- TAB: KILLER (KHUSUS KILLER)
----------------------------------------------------------------
TabKiller:Section({ Title = "Vein Killer Modification" })

TabKiller:Toggle({ Title = "Vein Spear: Drop Prediction", Desc = "Aimbot automatically aims slightly upwards for distant targets.", Flag = "F_SpearPrediction", Value = false, Callback = function(v) SpearPrediction = v end })

TabKiller:Toggle({ Title = "Vein Spear: No Gravity", Desc = "Spear flies straight through the air unaffected by gravity.", Flag = "F_AntiGravSpear", Value = false, Callback = function(v) AntiGravitySpear = v end })

TabKiller:Space({ Columns = 1 }) 
TabKiller:Section({ Title = "Killer Advantages", Box = true })

TabKiller:Toggle({ Title = "Anti-Blind", Desc = "Removes Fog & Flash effects.", Flag = "F_AntiBlind", Value = false, Callback = function(v) 
    AntiBlind = v 
    if v then for _, effect in pairs(Lighting:GetChildren()) do if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("Atmosphere") then effect:Destroy() end end end
end })

TabKiller:Toggle({ Title = "Anti-Stun", Desc = "Prevents the Stun effect from Pallet.", Flag = "F_AntiStun", Value = false, Callback = function(v) AntiStun = v end })

TabKiller:Toggle({ Title = "Double Damage Generator", Desc = "Deals double damage when kicking a Generator.", Flag = "F_DoubleDamage", Value = false, Callback = function(v) DoubleDamageGen = v end })

TabKiller:Button({ Title = "Activate Killer Power", Desc = "Instantly triggers the Killer's special power.", Icon = "sfsymbols:starFill", Callback = function()
    pcall(function() ReplicatedStorage.Remotes.Killers.Killer.ActivatePower:FireServer() end)
end })

-----------------------------------------------------------------
-- TAB 2: VISUALS (ESP, FOV, & WORLD)
----------------------------------------------------------------
Tab2:Section({ Title = "Player & Entity Visuals" })

local PlayerGroup1 = Tab2:Group()
PlayerGroup1:Toggle({ Title = "ESP Survivor", Desc = "Displays Survivor locations.", Flag = "F_ESPSurvivor", Value = false, Callback = function(v) ESP_Survivor = v; RefreshESP() end })

local PlayerGroup2 = Tab2:Group()
PlayerGroup2:Toggle({ Title = "ESP Killer", Desc = "Displays Killer locations.", Flag = "F_ESPKiller", Value = false, Callback = function(v) ESP_Killer = v; RefreshESP() end })

-- Kembalikan ke 1 Kolom
Tab2:Space({ Columns = 1 }) 


Tab2:Section({ Title = "Object Visuals" })


local ObjectGroup1 = Tab2:Group()
ObjectGroup1:Toggle({ Title = "ESP Generator", Desc = "Displays unfinished Gens.", Flag = "F_ESPGen", Value = false, Callback = function(v) ESP_Generator = v; RefreshESP() end })
ObjectGroup1:Toggle({ Title = "ESP Pallet", Desc = "Displays Pallets.", Flag = "F_ESPPallet", Value = false, Callback = function(v) ESP_Pallet = v; RefreshESP() end })

local ObjectGroup2 = Tab2:Group()
ObjectGroup2:Toggle({ Title = "ESP Exit Gate", Desc = "Displays Exit Gates.", Flag = "F_ESPGate", Value = false, Callback = function(v) ESP_Gate = v; RefreshESP() end })
ObjectGroup2:Toggle({ Title = "ESP Hook", Desc = "Displays Hook locations.", Flag = "F_ESPHook", Value = false, Callback = function(v) ESP_Hook = v; RefreshESP() end })

-- Kembalikan ke 1 Kolom
Tab2:Space({ Columns = 1 }) 


Tab2:Section({ Title = "Camera & Viewport Modification" })

local CamGroup1 = Tab2:Group()

CamGroup1:Toggle({ 
    Title = "Enable Custom FOV", 
    Desc = "View distance customization.", 
    Flag = "F_CustomFOV", 
    Value = false, 
    Callback = function(v) 
        CustomCameraFOV = v 
    end 
})

CamGroup1:Toggle({ 
    Title = "Show Crosshair", 
    Desc = "Displays the aiming point.", 
    Flag = "F_Crosshair", 
    Value = false, 
    Callback = function(v) 
        if CrosshairGui then CrosshairGui.Enabled = v end 
    end 
})
Tab2:Slider({ 
    Title = "Field of View", 
    Step = 1, 
    IsTooltip = true, 
    Flag = "F_FOVValue", 
    Value = { Min = 70, Max = 120, Default = 100 }, 
    Callback = function(v) 
        CameraFOVValue = v 
    end 
})

-- Kembalikan ke 1 Kolom
Tab2:Space({ Columns = 2 }) 

Tab2:Section({ Title = "World Optimization", Box = true })
Tab2:Toggle({ 
    Title = "Remove Blur & Bloom", 
    Desc = "Menonaktifkan efek buram jarak jauh dan cahaya yang menyilaukan.", 
    Flag = "F_RemoveDoF", 
    Value = false, 
    Callback = function(v) 
        -- Fungsi lokal untuk menyapu bersih efek di target folder
        local function toggleVisualEffects(parent, state)
            for _, effect in ipairs(parent:GetChildren()) do
                if effect:IsA("DepthOfFieldEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") then
                    -- Kita gunakan Enabled = false, bukan Destroy(), agar tidak memicu deteksi Anti-Cheat
                    effect.Enabled = not state 
                end
            end
        end

        -- Eksekusi di Lighting (Tempat standar)
        toggleVisualEffects(Lighting, v)
        
        -- Eksekusi di Kamera (Tempat game modern menyembunyikan DoF)
        toggleVisualEffects(workspace.CurrentCamera, v)
        
        if v then
            WindUI:Notify({ 
                Title = "Visual Cleared", 
                Content = "Efek DoF & Bloom berhasil dimatikan!", 
                Icon = "lucide:eye-off" 
            })
        end
    end 
})
Tab2:Button({ Title = "Force Fullbright", Desc = "Illuminates the entire map and removes fog.", Icon = "sfsymbols:sunMax", Callback = function() 
    Lighting.Brightness = 2; Lighting.ClockTime = 12; Lighting.GlobalShadows = false; Lighting.FogStart = 100000; Lighting.FogEnd = 100000
    for _, effect in pairs(Lighting:GetChildren()) do if effect:IsA("Atmosphere") then effect:Destroy() end end
end })

Tab2:Button({ 
    Title = "Extreme Potato Mode", 
    Desc = "Remove all textures to maximize FPS. (Cannot be undone!)", 
    Icon = "sfsymbols:cpuFill", 
    Color = Color3.fromRGB(255, 100, 50), 
    Callback = function() 
        WindUI:Notify({ 
            Title = "Potato Mode", 
            Content = "Mengoptimalkan map untuk HP kentang... Proses ini butuh beberapa detik.", 
            Icon = "sfsymbols:hourglass" 
        })

        task.spawn(function()
            -- 1. Optimasi Langit & Cahaya (Sangat Cepat)
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 0
            Lighting.FogEnd = 9e9
            
            -- [TAMBAHAN] Mematikan pantulan cahaya PBR yang sangat memakan GPU HP
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            
            for _, effect in ipairs(Lighting:GetDescendants()) do 
                if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then 
                    effect.Enabled = false 
                end 
            end

            -- 2. [TAMBAHAN] Optimasi Terrain (Menghilangkan lag dari animasi air & rumput)
            local terrain = workspace.Terrain
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 0
                terrain.Decoration = false
            end

            -- 3. Chunking Eksekusi Objek Map (Anti-Crash HP)
            local descendants = workspace:GetDescendants()
            local total = #descendants
            
            for i = 1, total do
                local v = descendants[i]
                
                -- [FIX] Terapkan ke MeshPart juga agar tidak ada material HD yang tersisa
                if v:IsA("BasePart") then 
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") then 
                    v.Transparency = 1 
                -- [FIX] Matikan Fire, Smoke, dan Sparkles bawaan Roblox, dan gunakan .Enabled = false (Lebih ringan dari mengubah Lifetime)
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then 
                    v.Enabled = false 
                end
                
                -- [FIX MOBILE] Turunkan dari 1000 ke 150 agar HP low-end tidak kepanasan & aplikasi tidak keluar sendiri
                if i % 150 == 0 then 
                    task.wait() 
                end
            end
            
            WindUI:Notify({ 
                Title = "Selesai!", 
                Content = "Potato Mode berhasil diterapkan. FPS Boosted!", 
                Icon = "sfsymbols:checkmarkCircleFill" 
            })
        end)
    end 
})

----------------------------------------------------------------
-- TAB 3: COMBAT (AIMBOT, HITBOX, PARRY)
----------------------------------------------------------------
Tab3:Section({ Title = "Targeting System" })

Tab3:Toggle({ Title = "Enable Aimbot", Desc = "Locks onto the nearest enemy.", Flag = "F_Aimbot", Value = false, Callback = function(v) Aimbot = v end })

Tab3:Slider({ 
    Title = "Aim Radius", 
    Step = 5, 
    IsTooltip = true, 
    IsTextbox = true, 
    Flag = "F_AimRadius", 
    Value = { Min = 30, Max = 200, Default = 55 }, 
    Callback = function(v) 
        AimRadius = v
        if FOVCircle then 
            FOVCircle.Size = UDim2.new(0, v*2, 0, v*2) 
        end 
    end 
})
Tab3:Toggle({ Title = "Show Aim Circle", Desc = "Displays aim radius on screen.", Flag = "F_ShowFOV", Value = false, Callback = function(v) 
    ShowFOVCircle = v; if FOVCircle then FOVCircle.Visible = v end 
end })

Tab3:Toggle({ 
    Title = "Show Target Tracer", 
    Desc = "Menarik garis laser merah dari bawah layar ke target yang dikunci.", 
    Flag = "F_Tracer", 
    Value = false, 
    Callback = function(v) ShowTracer = v end 
})

Tab3:Toggle({ 
    Title = "Lock-On Highlight", 
    Desc = "Membuat tubuh target yang sedang dibidik bersinar Merah/Emas.", 
    Flag = "F_TargetHighlight", 
    Value = false, 
    Callback = function(v) TargetHighlight = v end 
})
local isFPP = false

local fppHideConn = nil 

local function SwitchCameraMode(toFPP)
    local lp = Players.LocalPlayer
    
    if toFPP then
        lp.CameraMode = Enum.CameraMode.LockFirstPerson
        
        -- [FIX KEPALA KETUTUPAN & ROTASI BADAN] 
        if not fppHideConn then
            fppHideConn = RunService.RenderStepped:Connect(function()
                local char = lp.Character
                if char then
                    -- 1. Sembunyikan Kepala
                    local head = char:FindFirstChild("Head")
                    if head then head.LocalTransparencyModifier = 1 end
                    
                    -- 2. Sembunyikan semua aksesoris (Rambut, Topi, Topeng, dll)
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Accessory") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then handle.LocalTransparencyModifier = 1 end
                        end
                    end
                    
                    -- 3. Paksa Badan Menghadap Kamera (Real-time Sync)
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    local cam = workspace.CurrentCamera
                    
                    if hrp and hum and cam then
                        -- Matikan rotasi bawaan game agar tidak error/bergetar
                        hum.AutoRotate = false 
                        
                        local lookVector = cam.CFrame.LookVector
                        local flatLookVector = Vector3.new(lookVector.X, 0, lookVector.Z)
                        
                        -- Anti-Crash: Cegah error jika pemain melihat lurus 90 derajat ke langit/tanah
                        if flatLookVector.Magnitude > 0.001 then
                            local targetPos = hrp.Position + flatLookVector
                            -- Terapkan rotasi tanpa mengubah posisi kaki
                            hrp.CFrame = CFrame.lookAt(hrp.Position, targetPos)
                        end
                    end
                end
            end)
        end
    else
        lp.CameraMode = Enum.CameraMode.Classic
        lp.CameraMaxZoomDistance = 128 
        
        -- Kembalikan rotasi normal saat kembali ke TPP
        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.AutoRotate = true end
        
        if fppHideConn then
            fppHideConn:Disconnect()
            fppHideConn = nil
        end
    end
end

Tab3:Toggle({ 
    Title = "FPP / TPP Toggle", 
    Desc = UserInputService.TouchEnabled and "Memunculkan tombol mengambang untuk FPP/TPP." or "Paksa mode First Person (FPP).", 
    Flag = "F_CameraToggle", 
    Value = false, 
    Callback = function(v) 
        if UserInputService.TouchEnabled then
            -- [MOBILE] Hanya memunculkan/menyembunyikan tombol
            if MobileRotateBtn then 
                MobileRotateBtn.Visible = v
                if not v then 
                    -- Jika dimatikan, reset kembali ke normal (TPP)
                    isFPP = false
                    SwitchCameraMode(false)
                    MobileRotateBtn.BackgroundColor3 = Color3.fromRGB(75, 150, 255)
                    MobileRotateBtn.Text = "TPP\nMODE" 
                end 
            end
        else 
            -- [PC] Langsung eksekusi tanpa tombol mengambang
            isFPP = v
            SwitchCameraMode(v)
        end
    end 
})
Tab3:Space({ Columns = 2 }) 
Tab3:Section({ Title = "Killer Hitbox Modification" })

Tab3:Toggle({ Title = "Expand Killer Hitbox", Desc = "Memperbesar ukuran Killer agar mudah di-Stun.", Flag = "F_HitboxKiller", Value = false, Callback = function(v) 
    HitboxExpander = v 
    if not v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Team and p.Team.Name:lower():find("killer") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1); p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end })

Tab3:Slider({ Title = "Hitbox Size", Step = 1, IsTooltip = true, Flag = "F_HitboxSize", Value = { Min = 2, Max = 50, Default = 15 }, Callback = function(v) HitboxSize = v end })
Tab3:Space({ Columns = 2 }) 
Tab3:Section({ Title = "Auto Attack (Killer Only)" })

Tab3:Toggle({ Title = "Enable Auto Attack", Desc = "Automatically attacks the nearest Survivor.", Flag = "F_AutoAttack", Value = false, Callback = function(v) AutoAttack = v end })

Tab3:Slider({ Title = "Attack Range (Studs)", Step = 1, IsTooltip = true, Flag = "F_AttackRange", Value = { Min = 5, Max = 25, Default = 10 }, Callback = function(v) AttackRange = v end })

-- TAB 4
Tab4:Section({ Title = "Generator Logic" })

Tab4:Toggle({ 
    Title = "Auto Generator", 
    Desc = "Secara otomatis menyelesaikan SkillCheck saat memperbaiki.", 
    Flag = "F_AutoGen", 
    Value = false, 
    Callback = function(v) AutoGenerator = v end 
})

Tab4:Dropdown({ 
    Title = "SkillCheck Mode", 
    Desc = "Perfect (Bonus Progress), Neutral (Normal/Aman).",
    Values = {"Perfect", "Neutral"}, 
    Value = "Perfect", 
    Flag = "F_GenMode", 
    Callback = function(Option) AutoGeneratorMode = Option end 
})
Tab4:Button({ 
    Title = "Boost All Gen (Group Project)", 
    Desc = "Menyuntikkan efek perk Group Project ke semua Generator!", 
    Icon = "sfsymbols:boltFill", 
    Color = Color3.fromRGB(0, 200, 100), 
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end

        -- =========================================================
        -- 1. SMART CACHE: CARI REMOTE PERK & SKILLCHECK (Hanya 1x Cari)
        -- =========================================================
        if not getgenv().CachedPerkRemote_Gen then
            for _, obj in ipairs(remotes:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    -- Gunakan string.match untuk menangkap berbagai variasi nama file developer
                    local n = obj.Name:lower()
                    if n:match("groupproject") or n:match("genproject") or n:match("generatorproject") then
                        getgenv().CachedPerkRemote_Gen = obj
                        break
                    end
                end
            end
        end
        
        local skillCheckEvent = getgenv().CachedSkillCheckEvent
        if not skillCheckEvent then
            for _, obj in ipairs(remotes:GetDescendants()) do
                if obj:IsA("RemoteEvent") and obj.Name:lower():find("skillcheck") then
                    skillCheckEvent = obj
                    getgenv().CachedSkillCheckEvent = obj
                    break
                end
            end
        end
        
        local perkRemote = getgenv().CachedPerkRemote_Gen

        if not perkRemote and not skillCheckEvent then 
            WindUI:Notify({ Title = "Error", Content = "Remote gagal ditemukan!", Icon = "sfsymbols:xmarkCircleFill" })
            return 
        end
        
        if not CachedMapObjects or not CachedMapObjects.Generators or #CachedMapObjects.Generators == 0 then
            WindUI:Notify({ Title = "Loading", Content = "Loading map data...", Icon = "sfsymbols:timer" })
            return
        end

        -- =========================================================
        -- 2. EKSEKUSI BACKGROUND (ANTI-FREEZE UI)
        -- =========================================================
        task.spawn(function()
            local boostedCount = 0
            
            for _, obj in ipairs(CachedMapObjects.Generators) do
                if obj:IsA("Model") and obj.Name == "Generator" then
                    
                    local progress = type(GetGameValue) == "function" and (GetGameValue(obj, "RepairProgress") or GetGameValue(obj, "Progress") or 0) or 0
                    
                    if progress < 100 then
                        local validPoint = nil
                        for _, point in ipairs(obj:GetChildren()) do
                            if string.sub(point.Name, 1, 14) == "GeneratorPoint" then
                                validPoint = point
                                break 
                            end
                        end
                        
                        if validPoint then
                            -- METODE 1: SUNTIKAN PERK "GROUP PROJECT" (Sangat Masif!)
                            if perkRemote then
                                pcall(function() perkRemote:FireServer(obj) end)
                                pcall(function() perkRemote:FireServer(obj, validPoint) end)
                            end
                            
                            -- METODE 2: SKILLCHECK INJECTION (Sebagai pendorong sisa bar)
                            -- Kita turunkan dari 15 ke 5 karena efek Perk sudah menutupi sebagian besar progress
                            if skillCheckEvent then
                                for i = 1, 5 do
                                    pcall(function() skillCheckEvent:FireServer("success", 1, obj, validPoint) end)
                                end
                            end
                            
                            boostedCount = boostedCount + 1
                            
                            -- Jeda 0.05s agar tidak di-kick oleh sistem Anti-Spam server
                            task.wait(0.05) 
                        end
                    end
                end
            end
            
            -- Notifikasi hasil
            if boostedCount > 0 then
                WindUI:Notify({
                    Title = "Boost Success!",
                    Content = string.format("Perk Group Project berhasil disuntikkan ke %d Mesin!", boostedCount),
                    Icon = "sfsymbols:battery100"
                })
            else
                WindUI:Notify({
                    Title = "Completed",
                    Content = "Semua mesin sudah selesai diperbaiki.",
                    Icon = "sfsymbols:checkmarkCircleFill"
                })
            end
        end)
    end
})
Tab4:Section({ Title = "Utilities", Box = true })

Tab4:Toggle({ 
    Title = "Instant Escape (Gate)", 
    Desc = "Otomatis menarik tuas gerbang dari jarak jauh secara instan!", 
    Flag = "F_InstantEscape", 
    Value = false, 
    Callback = function(v) 
        InstantEscape = v 
        if v then
            WindUI:Notify({ 
                Title = "Instant Escape", 
                Content = "Mencari tuas gerbang untuk dibuka...", 
                Icon = "lucide:door-open" 
            })
        end
    end 
})


Tab4:Toggle({ Title = "Self UnHook", Desc = "Automatically escapes from the Hook instantly.", Flag = "F_AutoUnhook", Value = false, Callback = function(v) AutoUnhook = v end })

----------------------------------------------------------------
----------------------------------------------------------------
-- SETTINGS & CONFIG SYSTEM (WINDUI NATIVE)
----------------------------------------------------------------
local ConfigManager = Window.ConfigManager
local SaveName = "FORKT-HUB"
local Themes = {}

-- Ambil tema dengan aman
pcall(function()
    for name, _ in pairs(WindUI.Themes) do table.insert(Themes, name) end
end)

TabSettings:Section({ Title = "Configuration System" })

TabSettings:Space({ Columns = 2 }) 
local ConfigGroup = TabSettings:Group()

ConfigGroup:Button({
    Title = "Save Config",
    Justify = "Center",
    Size = "Small", 
    Icon = "sfsymbols:documentBadgeEllipsis",
    Callback = function()
        -- [FIX MOBILE] Proteksi pcall agar executor tidak crash jika tidak support penyimpanan file
        local success, err = pcall(function()
            Window.CurrentConfig = ConfigManager:Config(SaveName)
            Window.CurrentConfig:Save()
        end)
        if success then
            WindUI:Notify({ Title = "Config Saved", Content = "Semua pengaturan berhasil disimpan!", Icon = "sfsymbols:checkmarkCircle" })
        else
            WindUI:Notify({ Title = "Save Failed", Content = "Executor kamu tidak mendukung penyimpanan.", Icon = "sfsymbols:xmarkCircleFill" })
        end
    end
})

ConfigGroup:Button({
    Title = "Load Config",
    Justify = "Center",
    Size = "Small", 
    Icon = "sfsymbols:documentFill",
    Callback = function()
        local success, err = pcall(function()
            Window.CurrentConfig = ConfigManager:CreateConfig(SaveName)
            Window.CurrentConfig:Load()
        end)
        if success then
            WindUI:Notify({ Title = "Config Loaded", Content = "Pengaturan berhasil dimuat!", Icon = "sfsymbols:folderFill" })
        else
            WindUI:Notify({ Title = "Load Failed", Content = "Tidak ada config yang ditemukan.", Icon = "sfsymbols:xmarkCircleFill" })
        end
    end
})
-- Tambahkan di Tab Settings
TabSettings:Toggle({ 
    Title = "Anti-Logger (Bypass Anti-Cheat)", 
    Desc = "Memblokir pengiriman laporan error/cheat dari client kamu ke server developer.", 
    Flag = "F_AntiLogger", 
    Value = true, -- Default ON
    Callback = function(v) AntiLogger = v end 
})
TabSettings:Space({ Columns = 1 })

TabSettings:Section({ Title = "Window & Interface" })

TabSettings:Dropdown({ 
    Title = "Select Theme", 
    Flag = "F_Theme", 
    Value = ThemeName, 
    Values = Themes, 
    Callback = function(v) pcall(function() WindUI:SetTheme(v) end) end 
})

TabSettings:Toggle({ 
    Title = "Window Transparency", 
    Flag = "F_Trans", 
    Value = Window.Transparent, 
    Callback = function(v) pcall(function() Window:ToggleTransparency(v) end) end 
})
TabSettings:Space({ Columns = 1 }) 
TabSettings:Section({ Title = "System Management", Box = true })

TabSettings:Button({
    Title = "Unload FORKT-HUB",
    Desc = "Membatalkan semua fungsi, menghapus UI, dan membersihkan ESP dari layar.",
    Icon = "sfsymbols:trashFill",
    Color = Color3.fromRGB(255, 60, 60), 
    Justify = "Center",
    Callback = function()
        getgenv().FORKT_RUNNING = false
        pcall(function() Window:Destroy() end)
        
        -- [FIX] Bersihkan semua koneksi event yang berjalan di background
        if getgenv().FORKT_CONNECTIONS then
            for _, conn in ipairs(getgenv().FORKT_CONNECTIONS) do
                if conn.Disconnect then conn:Disconnect() end
            end
            table.clear(getgenv().FORKT_CONNECTIONS)
        end
        
        -- [FIX] Hancurkan dan Kosongkan variabel agar re-execute aman
        if CrosshairGui then CrosshairGui:Destroy(); CrosshairGui = nil end
        if ParryRing then ParryRing:Destroy(); ParryRing = nil end
        if TracerLine then TracerLine:Remove(); TracerLine = nil end
        if IndicatorGui then IndicatorGui:Destroy(); IndicatorGui = nil end

        -- Pembersihan ESP Pemain
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local h = p.Character:FindFirstChild("H")
                if h then h:Destroy() end
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local tag = root:FindFirstChild("TagESP")
                    if tag then tag:Destroy() end
                end
            end
        end
        
        -- Pembersihan Map ESP
        if CachedMapObjects then
            for _, list in pairs(CachedMapObjects) do
                for _, obj in ipairs(list) do
                    local h = obj:FindFirstChild("H")
                    if h then h:Destroy() end
                end
            end
        end
    end -- [FIX FATAL] Penutup "end" ini yang sebelumnya hilang/terpotong!
})
TabSettings:Space({ Columns = 1 }) 
TabSettings:Section({ Title = "Credits & Information" })

TabSettings:Paragraph({
    Title = "Developer: @sukitovone | @forkt",
    Desc = "Dapatkan update script terbaru, beri saran, atau laporkan bug langsung ke developer!",
    Image = "rbxassetid://18505728201",
    Buttons = {
        {
            Title = "Copy Discord Link", 
            Icon = "sfsymbols:link",
            Callback = function()
                -- [FIX MOBILE 3] Tambahkan Fallback Notification jika executor tidak bisa setclipboard
                local success, err = pcall(function() setclipboard("https://discord.gg/wCVUTHgsQV") end)
                if success then 
                    WindUI:Notify({ 
                        Title = "Success!", 
                        Content = "Link Discord berhasil disalin ke Clipboard!", 
                        Icon = "sfsymbols:checkmarkCircle" 
                    }) 
                else
                    WindUI:Notify({ 
                        Title = "Gagal Menyalin", 
                        Content = "Executor kamu tidak mendukung fitur Copy Clipboard.", 
                        Icon = "sfsymbols:xmarkCircleFill" 
                    }) 
                end
            end
        }
    }
})

----------------------------------------------------------------
-- [PREMIUM MOBILE UI] TOMBOL STATIS (ANTI-HILANG)
----------------------------------------------------------------
if UserInputService.TouchEnabled then
    -- [FIX FATAL] Kita gunakan CoreGui sebagai tameng. 
    -- Jika executor tidak support CoreGui, otomatis fallback ke PlayerGui.
    local coreSuccess, coreResult = pcall(function() return cloneref(game:GetService("CoreGui")) end)
    local SafeGuiFolder = coreSuccess and coreResult or PlayerGui

    local combatGui = SafeGuiFolder:FindFirstChild("FORKT_MobileButtons") or Instance.new("ScreenGui")
    combatGui.Name = "FORKT_MobileButtons"
    combatGui.ResetOnSpawn = false
    combatGui.IgnoreGuiInset = true
    combatGui.Parent = SafeGuiFolder -- [FIX] Pindahkan ke folder kebal wipe!

    MobileRotateBtn = combatGui:FindFirstChild("RotateBtn") or Instance.new("TextButton")
    MobileRotateBtn.Name = "RotateBtn"
    MobileRotateBtn.Size = UDim2.new(0, 65, 0, 65) 
    MobileRotateBtn.Position = UDim2.new(1, -85, 0.5, 30) 
    MobileRotateBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) 
    MobileRotateBtn.BackgroundTransparency = 0.15
    MobileRotateBtn.AutoButtonColor = false 
    MobileRotateBtn.Text = "TPP"
    MobileRotateBtn.TextColor3 = Color3.new(1, 1, 1)
    MobileRotateBtn.Font = Enum.Font.GothamBlack
    MobileRotateBtn.TextSize = 16 
    MobileRotateBtn.Visible = false 
    MobileRotateBtn.Parent = combatGui

    -- Bersihkan style lama jika re-execute agar tidak menumpuk
    for _, child in ipairs(MobileRotateBtn:GetChildren()) do child:Destroy() end

    -- [UI BEAUTIFY] Sudut membulat penuh
    local corner = Instance.new("UICorner", MobileRotateBtn)
    corner.CornerRadius = UDim.new(1, 0)

    -- [UI BEAUTIFY] Outline Neon
    local stroke = Instance.new("UIStroke", MobileRotateBtn)
    stroke.Thickness = 2.5
    stroke.Color = Color3.fromRGB(75, 150, 255) 

    -- [UI BEAUTIFY] Efek Gradient
    local gradient = Instance.new("UIGradient", MobileRotateBtn)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
    })
    gradient.Rotation = 45

    -- =========================================================
    -- SIMPLE TAP LOGIC (NO DRAG)
    -- =========================================================
    
    MobileRotateBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MobileRotateBtn.Size = UDim2.new(0, 58, 0, 58)
        end
    end)

    MobileRotateBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MobileRotateBtn.Size = UDim2.new(0, 65, 0, 65)
            
            isFPP = not isFPP
            SwitchCameraMode(isFPP)
            
            stroke.Color = isFPP and Color3.fromRGB(255, 100, 50) or Color3.fromRGB(75, 150, 255)
            MobileRotateBtn.Text = isFPP and "FPP" or "TPP"
        end
    end)
end

-- =========================================================
-- [NATIVE BYPASS 1] OMNI-NETWORK HOOK (ULTRA OPTIMIZED)
-- =========================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if not checkcaller() and getnamecallmethod() == "FireServer" and typeof(self) == "Instance" then
        
        -- [FIX CPU] JANGAN buat "args = {...}" di sini! Bikin RAM HP Bocor!
        -- Ambil nama remote dulu pakai pencarian string biasa (sangat ringan)
        local nLower = self.Name:lower()

        if nLower:find("skillcheck") then
            if AutoGenerator then
                local args = {...} -- Baru buat tabel args jika benar-benar butuh!
                if args[1] == "fail" or args[1] == "failed" or args[1] == false or args[1] == 0 then
                    args[1] = (AutoGeneratorMode == "Perfect") and "success" or "neutral"
                    args[2] = (AutoGeneratorMode == "Perfect") and 1 or 0
                    self.FireServer(self, unpack(args))
                    return 
                end
            end
        elseif DoubleDamageGen and (nLower:find("breakgen") or nLower:find("damage") or nLower:find("kick")) then
            local isKiller = LocalPlayer.Team and LocalPlayer.Team.Name:lower():find("killer")
            if isKiller then
                local savedArgs = {...} 
                task.spawn(function()
                    for i = 1, 15 do
                        self.FireServer(self, unpack(savedArgs))
                        task.wait(0.02) 
                    end
                end)
                WindUI:Notify({ Title = "Double Damage", Content = "Objek dihancurkan dengan multiplier!", Icon = "sfsymbols:boltFill" })
            end
        elseif SilentActions and (nLower:find("noise") or nLower:find("scream") or nLower:find("vaultalert") or nLower:find("spotted") or nLower:find("alert")) then
            return 
        elseif AntiFallDamage and (nLower:find("falldamage") or nLower:find("fall") or nLower:find("fallevents") or nLower:find("land")) then
            return 
        elseif ClientGodMode and (nLower:find("takedamage") or nLower:find("hit") or nLower:find("attacked")) then
            local args = {...}
            for _, v in ipairs(args) do
                if v == LocalPlayer.Character or v == LocalPlayer or v == (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
                    return 
                end
            end
        elseif AntiLogger and (nLower:find("log") or nLower:find("error") or nLower:find("report") or nLower:find("anticheat") or nLower:find("ban") or nLower:find("kick")) then
            return 
        elseif NoDisplayBlood and (nLower:find("blood") or nLower:find("bleed") or nLower:find("displayblood")) then
            local args = {...}
            for _, arg in ipairs(args) do
                if arg == LocalPlayer.Character or arg == LocalPlayer then
                    return 
                end
            end
            return 
        end
    end

    return oldNamecall(self, ...)
end)


-- =========================================================
-- [NATIVE BYPASS 2] OMNI-NEWINDEX HOOK (ANTI-BLOOD PARTICLES)
-- =========================================================
local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindex", function(t, k, v)
    if not checkcaller() and NoDisplayBlood then
        -- [FIX FATAL UI MACET] 
        -- Simpan karakter ke variabel dan pastikan TIDAK NIL!
        local myChar = LocalPlayer.Character
        
        if myChar and k == "Parent" and v == myChar then
            local objName = tostring(t):lower()
            if objName:find("blood") or objName:find("bleed") or objName:find("drop") or objName:find("gore") then
                return nil 
            end
        end
    end
    return oldNewIndex(t, k, v)
end)

-- =========================================================
-- [NATIVE BYPASS 3] OMNI-INDEX HOOK (SPOOF BLEEDING STATUS)
-- =========================================================
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(t, k)
    if not checkcaller() and NoDisplayBlood then
        if k == "Bleeding" or k == "IsBleeding" then
            -- [FIX FATAL UI MACET]
            local myChar = LocalPlayer.Character
            
            if myChar and t == myChar then
                return false 
            end
        end
    end
    return oldIndex(t, k)
end)

----------------------------------------------------------------
-- AUTO GENERATOR & AUTO HEAL (MOBILE OPTIMIZED & SAFE)
----------------------------------------------------------------
local CachedRemotes = {} 

task.spawn(function()
    while task.wait(0.2) do 
        if not getgenv().FORKT_RUNNING then break end
        
        -- [FIX MOBILE FINAL] Cegat di awal! Jangan hitung status mesin dan animasi jika mati!
        if not AutoGenerator then continue end 
        
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            if not myRoot or not myHum then return end

            local isMoving = myHum.MoveDirection.Magnitude > 0.1
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if not remotes then return end

            -- 1. SMART CACHING REMOTE
            if not CachedRemotes.globalSkillCheck then
                for _, obj in ipairs(remotes:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and obj.Name:lower():find("skillcheck") then
                        CachedRemotes.globalSkillCheck = obj
                        break
                    end
                end
            end

            local genRemotes = remotes:FindFirstChild("Generator")
            local genSkillCheckEvent = (genRemotes and genRemotes:FindFirstChild("SkillCheckResultEvent")) or CachedRemotes.globalSkillCheck

            if not CachedRemotes.healSkillCheckEvent then
                local healKeywords = {"Healing", "Heal", "Medical", "Revive", "Help"}
                for _, keyword in ipairs(healKeywords) do
                    local folder = remotes:FindFirstChild(keyword)
                    if folder then
                        local ev = folder:FindFirstChild("SkillCheckResultEvent")
                        if ev then CachedRemotes.healSkillCheckEvent = ev; break end
                    end
                end
                if not CachedRemotes.healSkillCheckEvent then
                    CachedRemotes.healSkillCheckEvent = CachedRemotes.globalSkillCheck or genSkillCheckEvent
                end
            end

            local healSkillCheckEvent = CachedRemotes.healSkillCheckEvent

            -- 2. DETEKSI STATUS KARAKTER
            local isHealingTarget = false
            local isRepairingTarget = false
            local nearestHealTarget = nil

            for _, track in pairs(myHum:GetPlayingAnimationTracks()) do
                if track.Animation then
                    local animName = track.Animation.Name:lower()
                    if animName:find("heal") or animName:find("revive") or animName:find("medkit") or animName:find("help") then
                        isHealingTarget = true
                    elseif animName:find("repair") or animName:find("fix") or animName:find("work") or animName:find("gen") then
                        isRepairingTarget = true
                    end
                end
            end

            if not isHealingTarget and not isRepairingTarget then
                local sysHeal = GetGameValue(myChar, "Healing") or GetGameValue(myChar, "IsHealing") or GetGameValue(myChar, "Reviving")
                local sysRepair = GetGameValue(myChar, "Repairing") or GetGameValue(myChar, "IsRepairing")
                local sysInteract = GetGameValue(myChar, "Interacting")

                if sysHeal == true or (type(sysHeal) == "number" and sysHeal > 0) then isHealingTarget = true end
                if sysRepair == true or (type(sysRepair) == "number" and sysRepair > 0) then isRepairingTarget = true end
                if sysInteract == true and not isHealingTarget and not isRepairingTarget then isRepairingTarget = true end
            end

            if isMoving then isRepairingTarget = false end

            if isHealingTarget then
                local healDist = 12
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= healDist then nearestHealTarget = p.Character; healDist = dist end
                    end
                end
            end

            -- 3. MENCARI GENERATOR TERDEKAT
            local nearestGen, nearestPoint
            if CachedMapObjects and CachedMapObjects.Generators then
                local genDist = 15 
                for _, obj in ipairs(CachedMapObjects.Generators) do
                    if obj:IsA("Model") and obj.Name == "Generator" then
                        local progress = GetGameValue(obj, "RepairProgress") or GetGameValue(obj, "Progress") or 0
                        if progress < 100 then
                            for _, point in ipairs(obj:GetChildren()) do
                                if point.Name:find("GeneratorPoint") then
                                    local dist = (myRoot.Position - point.Position).Magnitude
                                    if dist < genDist then
                                        genDist = dist; nearestGen = obj; nearestPoint = point
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- =========================================================
            -- 4. OMNI SKILLCHECK INTERCEPTOR (ULTRA OPTIMIZED)
            -- =========================================================
            local isSkillCheckVisible = false
            local promptGui = getgenv().CachedSkillCheckUI
            
            -- [FIX ANTI-LAG & SAFETY] 
            -- Pastikan objeknya nyata (Instance) dan belum dihapus dari PlayerGui
            if not promptGui or typeof(promptGui) ~= "Instance" or not promptGui:IsDescendantOf(PlayerGui) then
                promptGui = nil
                getgenv().CachedSkillCheckUI = nil
                
                local guis = PlayerGui:GetChildren()
                for i = 1, #guis do
                    local gui = guis[i]
                    if gui:IsA("ScreenGui") then
                        local n = gui.Name:lower()
                        -- [FIX PENTING] Hapus pencarian kata "prompt" agar tidak menangkap "ProximityPrompt"!
                        -- Tambahkan "qte" dan "skill_check" untuk variasi nama developer lain.
                        if string.find(n, "skillcheck") or string.find(n, "skill_check") or string.find(n, "qte") then
                            promptGui = gui
                            getgenv().CachedSkillCheckUI = gui
                            break
                        end
                    end
                end
            end

            -- Cek visibilitas secara super ringan
            if promptGui then
                local checkFrame = promptGui:FindFirstChild("Check") or promptGui:FindFirstChild("Main")
                if promptGui.Enabled or (checkFrame and checkFrame.Visible) then
                    isSkillCheckVisible = true
                end
            end

            -- Eksekusi Auto Skillcheck
            if isSkillCheckVisible and promptGui then
                task.wait(math.random(10, 20) / 100)

                if promptGui:FindFirstChild("Check") then promptGui.Check.Visible = false end
                promptGui.Enabled = false 

                local scResult = (AutoGeneratorMode == "Perfect") and "success" or "neutral"
                local scValue  = (AutoGeneratorMode == "Perfect") and 1 or 0

                if isHealingTarget and healSkillCheckEvent then
                    if nearestHealTarget then 
                        healSkillCheckEvent:FireServer(scResult, scValue, nearestHealTarget)
                    else 
                        healSkillCheckEvent:FireServer(scResult, scValue) 
                    end
                    task.wait(0.5) 
                    return 
                elseif genSkillCheckEvent then
                    if nearestGen and nearestPoint then
                        genSkillCheckEvent:FireServer(scResult, scValue, nearestGen, nearestPoint)
                    else 
                        genSkillCheckEvent:FireServer(scResult, scValue) 
                    end
                    task.wait(0.5)
                end
            end
        end)
    end
end)
----------------------------------------------------------------
-- KILLER: AUTO ATTACK LOGIC (MOBILE OPTIMIZED)
----------------------------------------------------------------
local CachedBasicAttack = nil
local SearchedAttackRemote = false

task.spawn(function()
    while task.wait(0.2) do
        if not getgenv().FORKT_RUNNING then break end 
        
        -- [FIX 1] Cegat di awal jika fitur mati agar tidak membebani CPU
        if not AutoAttack then continue end
        
        -- Pastikan yang memakai ini hanya tim Killer
        local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
        if not myTeam:find("killer") then continue end

        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            
            -- Pastikan Killer hidup
            if not myRoot or not myHum or myHum.Health <= 0 then return end
            
            -- [FIX 2] Pengecekan Status Killer (Anti-Glitch)
            -- Jangan menyerang jika sedang menggendong atau terkena Stun
            local isCarrying = GetGameValue(myChar, "Carrying") or GetGameValue(myChar, "IsCarrying")
            local isStunned = GetGameValue(myChar, "Stunned")
            if isCarrying or isStunned then return end

            local targetFound = false
            
            -- Mencari Survivor Terdekat
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyTeam = p.Team and p.Team.Name:lower() or ""
                    
                    if not enemyTeam:find("killer") then
                        local enemyChar = p.Character
                        local enemyHum = enemyChar:FindFirstChild("Humanoid")
                        
                        -- Pastikan target hidup
                        if enemyHum and enemyHum.Health > 0 then
                            -- Jangan pukul yang sudah jatuh/dirangkak atau sedang digantung
                            local isKnocked = GetGameValue(enemyChar, "Knocked")
                            local isHooked = GetGameValue(enemyChar, "IsHooked")
                            
                            if not isKnocked and not isHooked then
                                local dist = (enemyChar.HumanoidRootPart.Position - myRoot.Position).Magnitude
                                if dist <= AttackRange then
                                    targetFound = true
                                    break 
                                end
                            end
                        end
                    end
                end
            end

            -- [FIX 3] Smart Remote Caching (Cari 1x saja)
            if targetFound then
                if not SearchedAttackRemote then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local attacks = remotes and (remotes:FindFirstChild("Attacks") or remotes:FindFirstChild("attacks") or remotes:FindFirstChild("Attack"))
                    if attacks then
                        CachedBasicAttack = attacks:FindFirstChild("BasicAttack") or attacks:FindFirstChild("basicattack")
                    end
                    SearchedAttackRemote = true
                end

                -- Eksekusi Serangan Instan
                if CachedBasicAttack then
                    CachedBasicAttack:FireServer(false)
                end
            end
        end)
    end
end)
local SearchedParry = false
local ParryRemotesList = {} 

local function TriggerParryDagger()
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChild("Humanoid")
    if not myChar or not myHum or myHum.Health <= 0 then return end

    -- =========================================================
    -- [FIX 1] PENANGKAL BUG STATUS LUA AGAR TIDAK MACET
    -- =========================================================
    local function IsActive(val)
        return val == true or (type(val) == "number" and val > 0)
    end

    local isKnocked = IsActive(GetGameValue(myChar, "Knocked"))
    local isHooked = IsActive(GetGameValue(myChar, "IsHooked"))
    local isCarried = IsActive(GetGameValue(myChar, "Carried")) or IsActive(GetGameValue(myChar, "IsCarried")) or IsActive(GetGameValue(myChar, "Grabbed"))
    
    if isKnocked or isHooked or isCarried then return end

    local now = os.clock()
    local parryFired = false

    -- =========================================================
    -- [METODE 1] AGGRESSIVE GLOBAL REMOTE HUNTING (DENGAN PAYLOAD)
    -- =========================================================
    if not SearchedParry then
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                for _, obj in ipairs(remotes:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and obj.Name:lower():find("parry") then
                        table.insert(ParryRemotesList, obj)
                    end
                end
            end
        end)
        SearchedParry = true
    end

    if #ParryRemotesList > 0 then
        task.spawn(function()
            for _, remote in ipairs(ParryRemotesList) do
                -- [FIX 2] Tembak ganda: Kosong dan pakai argumen "true"
                for i = 1, 2 do 
                    pcall(function() remote:FireServer() end) 
                    pcall(function() remote:FireServer(true) end)
                end
            end
        end)
        parryFired = true
    end

    -- =========================================================
    -- [METODE 2] INSTANT TOOL EQUIP & ACTIVATE 
    -- =========================================================
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local daggerTool = myChar:FindFirstChild("Parrying Dagger") or (backpack and backpack:FindFirstChild("Parrying Dagger"))

    if daggerTool then
        task.spawn(function()
            -- [FIX 3] Paksa Pindah Tangan Instan (Anti-Lemot)
            if daggerTool.Parent ~= myChar then
                pcall(function() myHum:EquipTool(daggerTool) end)
                daggerTool.Parent = myChar -- Paksa pindah parent
                task.wait(0.03) -- Jeda aman agar server mencatat senjata sudah dipegang
            end
            
            -- Tembak remote internal Tool (Bypass murni)
            local toolRemote = daggerTool:FindFirstChild("parry") or daggerTool:FindFirstChild("ParryEvent")
            if toolRemote then
                for i = 1, 2 do 
                    pcall(function() toolRemote:FireServer() end) 
                    pcall(function() toolRemote:FireServer(true) end) 
                end
            end
            
            -- Spam Activate Murni 
            for i = 1, 5 do 
                pcall(function() daggerTool:Activate() end) 
                task.wait(0.015)
            end
        end)
        parryFired = true
    end

    -- =========================================================
    -- [GOD MODE] ANIMATION & STUN CANCELING
    -- =========================================================
    if parryFired then
        task.spawn(function()
            -- [FIX 4] Jeda dinaikkan sedikit agar animasi parry sempat terkirim sebelum dibatalkan
            task.wait(0.08)
            
            if myHum then
                for _, track in ipairs(myHum:GetPlayingAnimationTracks()) do
                    if track.Animation then
                        local animName = track.Animation.Name:lower()
                        if animName:match("parry") or animName:match("block") or animName:match("attack") or animName:match("swing") or animName:match("slash") or animName:match("stun") then
                            track:Stop()
                        end
                    end
                end
                
                myHum.PlatformStand = false
                if myHum:GetState() ~= Enum.HumanoidStateType.Running then
                    myHum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
            
            if myChar:GetAttribute("Stunned") then myChar:SetAttribute("Stunned", false) end
            local stunVal = myChar:FindFirstChild("Stunned")
            if stunVal and stunVal:IsA("ValueBase") then stunVal.Value = false end
            
            if SpeedBoost and myHum then
                myHum.WalkSpeed = BoostSpeed
            end
        end)

        -- =========================================================
        -- NOTIFIKASI ANTI-LAG
        -- =========================================================
        local lastNotif = getgenv().LastParryNotif or 0
        if now - lastNotif > 7.0 then
            getgenv().LastParryNotif = now
            WindUI:Notify({ 
                Title = "DAGGER TRIGGERED!", 
                Content = "Menangkis Instan (Bypass Method)!", 
                Icon = "lucide:zap" 
            })
        end
    end
end

local CachedTarget = nil
local LastTargetCheck = 0

local isMobileFiring = false
if UserInputService.TouchEnabled then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Touch then 
            isMobileFiring = true 
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch then 
            -- Cek apakah masih ada jari lain di layar
            isMobileFiring = #UserInputService:GetTouches() > 0 
        end
    end)
end

-- [OPTIMASI MOBILE 2] Variabel Cache untuk Karakter (Meringankan CPU)
local cachedChar, cachedRoot, cachedHum = nil, nil, nil
local camera = workspace.CurrentCamera

if LockHighlight.Parent ~= workspace then LockHighlight.Parent = workspace end

local lastRenderCheck = 0
local cachedIsCarrying = false

RunService.RenderStepped:Connect(function(deltaTime)
    if not getgenv().FORKT_RUNNING then return end
    
    local myChar = LocalPlayer.Character
    if not cachedChar or myChar ~= cachedChar or not cachedRoot or not cachedRoot.Parent then
        cachedChar = myChar
        cachedRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        cachedHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        camera = workspace.CurrentCamera
        if ParryRing and cachedRoot then ParryRing.Adornee = cachedRoot end
    end
    
    local myRoot = cachedRoot
    local myHum = cachedHum 
    local safeDistance = type(ParryDistance) == "table" and (ParryDistance.Default or ParryDistance.Value or 12) or tonumber(ParryDistance) or 12

    -- =========================================================
    -- 1. PARRY RING VISUAL
    -- =========================================================
    if AutoParry and myRoot and myHum and myHum.Health > 0 then
        ParryRing.Visible = true
        if ParryRing.Adornee ~= myRoot then ParryRing.Adornee = myRoot end
        ParryRing.CFrame = CFrame.new(0, -3.2, 0) * CFrame.Angles(math.rad(90), 0, 0)
        
        if ParryRing.Radius ~= safeDistance then
            ParryRing.Radius = safeDistance
            ParryRing.InnerRadius = safeDistance - 0.2 
        end
    else
        if ParryRing.Visible then 
            ParryRing.Visible = false 
            ParryRing.Adornee = nil
        end
    end

    -- =========================================================
    -- 2. SMART SENSOR & AIM LOGIC (THROTTLED CPU)
    -- =========================================================
    local needsTargeting = (Aimbot or ShowTracer or TargetHighlight)

    if needsTargeting and myRoot and myHum and myHum.Health > 0 then
        local now = os.clock()
        
        -- [FIX CPU] Jangan cek status Carrying 60x detik! Cukup cek 4x sedetik.
        if now - lastRenderCheck > 0.25 then
            cachedIsCarrying = GetGameValue(myChar, "Carrying") or GetGameValue(myChar, "IsCarrying") or false
            lastRenderCheck = now
        end
        
        if not cachedIsCarrying then
            if now - LastTargetCheck > 0.1 then
                CachedTarget = GetClosestPlayer()
                LastTargetCheck = now
            end
            
            local targetPart = CachedTarget 

            if targetPart then
                local lockedTarget = targetPart.Parent 
                local isFiring = false
                
                if Aimbot then
                    if UserInputService.TouchEnabled then
                        isFiring = isMobileFiring
                    else
                        isFiring = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or 
                                   UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                    end
                end
                
                -- =========================================================
                -- 3. VISUAL PREVIEW & HIGHLIGHT (DIGABUNG)
                -- =========================================================
                if ShowTracer and TracerLine then
                    local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        TracerLine.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        TracerLine.To = Vector2.new(pos.X, pos.Y)
                        TracerLine.Visible = true
                    else
                        TracerLine.Visible = false
                    end
                end

                if TargetHighlight then
                    if LockHighlight.Adornee ~= lockedTarget then LockHighlight.Adornee = lockedTarget end
                    LockHighlight.Enabled = true
                end
                
                if isFiring and Aimbot then
                    local targetPos = targetPart.Position
                    if SpearPrediction then
                        local dist = (myRoot.Position - targetPos).Magnitude
                        if dist > 15 then targetPos = targetPos + Vector3.new(0, dist * 0.08, 0) end
                    end
                    camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, targetPos), math.clamp(deltaTime * 20, 0, 1)) 
                end
            else
                if TracerLine then TracerLine.Visible = false end
                LockHighlight.Enabled = false
            end
        else
            if TracerLine then TracerLine.Visible = false end
            LockHighlight.Enabled = false
        end
    else
        if TracerLine then TracerLine.Visible = false end
        LockHighlight.Enabled = false
    end
end)

RunService:BindToRenderStep("SmoothFOV", Enum.RenderPriority.Camera.Value + 1, function()
    if CustomCameraFOV and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = CameraFOVValue end
end)

-- =========================================================
-- [OPTIMASI MOBILE] CACHING REMOTE HEARTBEAT
-- =========================================================
local CachedHBRemotes = {}
local SearchedHBRemotes = false
local lastKillerScan = 0 -- Variabel baru untuk melimitasi pencarian Killer

RunService.Heartbeat:Connect(function()
    if not getgenv().FORKT_RUNNING then return end 
    
    local now = os.clock()
    if now - LastUpdateTick < 0.05 then return end
    LastUpdateTick = now

    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") 
    
    if now - LastESPRefresh > 0.4 then LastESPRefresh = now; RefreshESP() end
    
    -- [FIX CPU] Hanya memindai jarak Killer 4x dalam 1 detik (Setiap 0.25 detik)
    if myRoot and now - lastKillerScan > 0.25 then
        lastKillerScan = now
        closestKillerDist = 999 -- Reset jarak lokal
        
        local players = Players:GetPlayers()
        for i = 1, #players do
            local p = players[i]
            if p ~= LocalPlayer and p.Character then
                local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local teamName = p.Team and p.Team.Name:lower() or ""
                    
                    if teamName:find("killer") then
                        local dist = (eRoot.Position - myRoot.Position).Magnitude
                        if dist < closestKillerDist then 
                            closestKillerDist = dist 
                        end
                        
                        -- Eksekusi Hitbox Expander
                        if HitboxExpander and eRoot.Size.X ~= HitboxSize then
                            eRoot.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                            eRoot.Transparency = 1
                            eRoot.BrickColor = BrickColor.new("Bright red")
                            eRoot.Material = Enum.Material.ForceField
                            eRoot.CanCollide = false 
                        end
                    end
                end
            end
        end
    end

    if myRoot then
        -- Eksekusi Killer Warn berdasarkan jarak yang di-cache
        local warn = myRoot:FindFirstChild("KillerWarn")
-- ... (Biarkan kode Killer Warn dan sisanya ke bawah tetap sama) ...

        if WarnKiller and closestKillerDist <= 60 then
            local isChased = closestKillerDist <= 30
            local txt = isChased and "!!" or "!"
            local col = isChased and Color3.new(1,0,0) or Color3.new(1,0.6,0)
            if not warn then
                warn = CreateBillboardTag(txt, col, UDim2.new(0,15,0,15), 20)
                warn.Name, warn.StudsOffset, warn.Parent = "KillerWarn", Vector3.new(0,4,0), myRoot
            else
                warn.Label.Text, warn.Label.TextColor3 = txt, col
            end
        elseif warn then 
            warn:Destroy() 
        end
        -- Eksekusi Auto Parry berdasarkan jarak
        local safeDistance = type(ParryDistance) == "table" and (ParryDistance.Default or ParryDistance.Value or 12) or tonumber(ParryDistance) or 12
        
        if AutoParry and closestKillerDist <= safeDistance then
            TriggerParryDagger()
        end
    end

    -- =========================================================
    -- SMART CACHING REMOTE (HANYA CARI 1 KALI)
    -- =========================================================
    if not SearchedHBRemotes then
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            CachedHBRemotes.DisplayBlood = remotes:FindFirstChild("DisplayBlood", true) or remotes:FindFirstChild("BloodEvent", true)
            CachedHBRemotes.FallDamage = remotes:FindFirstChild("FallDamage", true)
            CachedHBRemotes.HealEvent = remotes:FindFirstChild("HealEvent", true) or remotes:FindFirstChild("RequestHeal", true) or remotes:FindFirstChild("ReviveEvent", true)
            CachedHBRemotes.HookPhase = remotes:FindFirstChild("HookPhase", true)
            CachedHBRemotes.UnHook = remotes:FindFirstChild("UnHookEvent", true) or remotes:FindFirstChild("Unhook", true)
            CachedHBRemotes.SelfUnHook = remotes:FindFirstChild("SelfUnHookEvent", true)
        end
        SearchedHBRemotes = true
    end

    if myChar and myHum then
        -- =========================================================
        -- SPEED & ANTI-SLOW LOGIC
        -- =========================================================
        local isCarrying = GetGameValue(myChar, "Carrying") or GetGameValue(myChar, "IsCarrying")

        if isCarrying then
            if myHum.WalkSpeed == BoostSpeed then myHum.WalkSpeed = 16 end
        else
            local targetSpeed = SpeedBoost and BoostSpeed or 16
            local baseSpeed = 16
            local safeSpeed = targetSpeed
            
            local currentSpeed = myHum.WalkSpeed
            local currentAttr = myHum:GetAttribute("WalkSpeed")
            
            if not SpeedBoost then
                if currentSpeed > safeSpeed then safeSpeed = currentSpeed end
                if currentAttr and type(currentAttr) == "number" and currentAttr > safeSpeed then safeSpeed = currentAttr end
            end

            if SpeedBoost or NoSlowdown then
                if SpeedBoost and myHum.WalkSpeed ~= targetSpeed then myHum.WalkSpeed = targetSpeed end
                if NoSlowdown and myHum.WalkSpeed < safeSpeed then myHum.WalkSpeed = safeSpeed end
                if currentAttr and type(currentAttr) == "number" then
                    if SpeedBoost and currentAttr ~= targetSpeed then myHum:SetAttribute("WalkSpeed", targetSpeed)
                    elseif NoSlowdown and currentAttr < safeSpeed then myHum:SetAttribute("WalkSpeed", safeSpeed) end
                end
            else
                if myHum.WalkSpeed == BoostSpeed then myHum.WalkSpeed = baseSpeed end
                if currentAttr == BoostSpeed then myHum:SetAttribute("WalkSpeed", baseSpeed) end
            end 
        end
        local function IsStatusActive(val)
            return val == true or (type(val) == "number" and val > 0)
        end
        -- =========================================================
        -- INSTANT HEAL (CLEANSE VISUAL & SERVER SYNC)
        -- =========================================================
        local lastHealSpam = getgenv().LastHealSpam or 0

        if InstantHeal then
            local isHurt = myHum.Health < myHum.MaxHealth
            local hasBadStatus = false
            local badStatuses = {"Knocked", "Injured", "Bleeding"}
            
            for _, status in ipairs(badStatuses) do
                -- [FIX PENTING] Gunakan IsStatusActive agar angka 0 tidak memicu Spam Heal!
                if IsStatusActive(GetGameValue(myChar, status)) then 
                    hasBadStatus = true
                    break 
                end
            end

            if (isHurt or hasBadStatus) and (now - lastHealSpam > 1) then
                getgenv().LastHealSpam = now 
                
                if myHum.Health > 0 then myHum.Health = myHum.MaxHealth end
                
                for _, status in ipairs(badStatuses) do
                    -- [FIX PENTING] Pastikan kita hanya menonaktifkan status yang benar-benar aktif
                    if IsStatusActive(GetGameValue(myChar, status)) then
                        local val = myChar:FindFirstChild(status)
                        if val and val:IsA("ValueBase") then val.Value = false end
                        if myChar:GetAttribute(status) ~= nil then myChar:SetAttribute(status, false) end
                    end
                end
                
                if myHum.PlatformStand then myHum.PlatformStand = false end
                if myHum:GetState() ~= Enum.HumanoidStateType.Running then myHum:ChangeState(Enum.HumanoidStateType.Running) end
                
                -- [OPTIMASI MOBILE] Menggunakan pattern matching Luau agar lebih ringan
                for _, track in ipairs(myHum:GetPlayingAnimationTracks()) do
                    local animName = track.Animation and track.Animation.Name or ""
                    if animName:match("[Cc]rawl") or animName:match("[Dd]own") or animName:match("[Kk]nock") then 
                        track:Stop() 
                    end
                end

                if CachedHBRemotes.FallDamage then pcall(function() CachedHBRemotes.FallDamage:FireServer(-100) end) end
                if CachedHBRemotes.HealEvent then
                    pcall(function() CachedHBRemotes.HealEvent:FireServer(myChar, 100) end) 
                    pcall(function() CachedHBRemotes.HealEvent:FireServer(true) end)        
                end
            end
        end

        -- =========================================================
        -- ANTI-KNOCK & ANTI-CARRY (ULTIMATE GHOST MODE)
        -- =========================================================
        local lastAntiKnockSpam = getgenv().LastAntiKnockSpam or 0
        
        -- Kita deteksi 2 status sekaligus: Sedang Jatuh (Knock) ATAU Digendong (Carried)
        local isKnocked = IsStatusActive(GetGameValue(myChar, "Knocked"))
        local isCarried = IsStatusActive(GetGameValue(myChar, "Carried")) or IsStatusActive(GetGameValue(myChar, "IsCarried")) or IsStatusActive(GetGameValue(myChar, "Grabbed"))
        
        if AntiKnock and (isKnocked or isCarried) then 
            -- 1. Pulihkan Darah & Hapus Status Knock
            if myHum.Health < myHum.MaxHealth then myHum.Health = myHum.MaxHealth end

            if myChar:GetAttribute("Knocked") then myChar:SetAttribute("Knocked", false) end
            local knockedVal = myChar:FindFirstChild("Knocked")
            if knockedVal and knockedVal.Value then knockedVal.Value = false end

            if now - lastAntiKnockSpam > 1.5 then
                getgenv().LastAntiKnockSpam = now
                if CachedHBRemotes.HealEvent then
                    pcall(function() CachedHBRemotes.HealEvent:FireServer(myChar, 100) end)
                    pcall(function() CachedHBRemotes.HealEvent:FireServer(true) end)
                end
                
                if CachedHBRemotes.DisplayBlood then
                    pcall(function() CachedHBRemotes.DisplayBlood:FireServer(myChar, false) end)
                    pcall(function() CachedHBRemotes.DisplayBlood:FireServer(false) end)
                end
            end

            -- ==========================================
            -- [FIX FATAL] PEMECAH WELD ANTI-GENDONG
            -- ==========================================
            if isCarried then
                -- A. Hapus status digendong agar UI game dan skrip lokal membebaskan kita
                local carryAttrs = {"Carried", "IsCarried", "Grabbed"}
                for _, attr in ipairs(carryAttrs) do
                    if myChar:GetAttribute(attr) then myChar:SetAttribute(attr, false) end
                    local val = myChar:FindFirstChild(attr)
                    if val and val:IsA("ValueBase") then val.Value = false end
                end
                
                -- B. Hancurkan tali/weld tak terlihat yang menempelkan fisik tubuhmu ke pundak Killer
                for _, obj in ipairs(myRoot:GetChildren()) do
                    if obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("ManualWeld") then
                        obj:Destroy()
                    end
                end
                
                -- C. Spam Wiggle Instan (Bypass lepas otomatis ke Server tanpa perlu ditekan manual)
                if not getgenv().SearchedWiggle then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        getgenv().CachedWiggle1 = remotes:FindFirstChild("Wiggle", true) or remotes:FindFirstChild("Struggle", true)
                        getgenv().CachedWiggle2 = remotes:FindFirstChild("WiggleEvent", true) or remotes:FindFirstChild("StruggleEvent", true)
                    end
                    getgenv().SearchedWiggle = true
                end

                if getgenv().CachedWiggle1 then 
                    pcall(function() getgenv().CachedWiggle1:FireServer(true); getgenv().CachedWiggle1:FireServer() end)
                end
                if getgenv().CachedWiggle2 then 
                    pcall(function() getgenv().CachedWiggle2:FireServer(true); getgenv().CachedWiggle2:FireServer() end)
                end
            end

            -- 3. Bangkitkan Karakter secara Paksa
            if myHum.PlatformStand then myHum.PlatformStand = false end 
            if myHum.Sit then myHum.Sit = false end -- Mencegah game mendudukkan karaktermu di pundak
            
            if myHum:GetState() ~= Enum.HumanoidStateType.Running then 
                myHum:ChangeState(Enum.HumanoidStateType.Running) 
            end
            
            -- 4. Matikan semua animasi yang berhubungan dengan kekalahan
            for _, track in ipairs(myHum:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                if anim then
                    local animName = anim.Name:lower()
                    if animName:match("crawl") or animName:match("down") or animName:match("knock") or animName:match("fall") or animName:match("carry") or animName:match("grab") or animName:match("hold") then
                        track:Stop()
                    end
                end
            end
        end
        -- =========================================================
        -- [FIX CPU] MASTER VISUAL CLEANSER (ANTI FRAME-DROP)
        -- =========================================================
        local lastVisualCleanse = getgenv().LastVisualCleanse or 0
        
        -- KITA TAMBAHKAN JEDA 2 DETIK: (now - lastVisualCleanse > 2)
        -- Agar HP tidak dipaksa membedah ratusan partikel darah 20 kali dalam sedetik!
        if (InstantHeal or AntiKnock or NoDisplayBlood) and (now - lastVisualCleanse > 2) then
            getgenv().LastVisualCleanse = now -- Kunci timer
            
            task.spawn(function()
                -- 1. Bersihkan noda darah/merah yang menutupi layar (UI)
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in ipairs(playerGui:GetChildren()) do
                        -- Pakai string.find agar lebih ringan daripada pattern matching
                        local n = gui.Name:lower()
                        if string.find(n, "blood") or string.find(n, "damage") then
                            gui.Enabled = false
                        end
                    end
                end
                
                -- 2. Sapu bersih sisa partikel fisik
                for _, obj in ipairs(myChar:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Decal") then
                        local n = obj.Name:lower()
                        if string.find(n, "blood") or string.find(n, "bleed") or string.find(n, "gore") then
                            obj.Enabled = false
                            obj:Destroy()
                        end
                    end
                    -- Bersihkan sisa highlight (khusus saat InstantHeal nyala)
                    if InstantHeal and obj:IsA("Highlight") and obj.Name ~= "H" then 
                        obj:Destroy() 
                    end
                end
            end)
        end
        -- =========================================================
        -- ANTI-STUN
        -- =========================================================
        if AntiStun and IsStatusActive(GetGameValue(myChar, "Stunned")) then
            myChar:SetAttribute("Stunned", false)
            local s = myChar:FindFirstChild("Stunned")
            if s and s.Value then s.Value = false end
            if myHum.PlatformStand then myHum.PlatformStand = false end
        end
        -- =========================================================
        -- [VIP] 100% CHANCE SPOOFER (SMART UNHOOK)
        -- =========================================================
        if AutoUnhook and not getgenv().IsUnhooking and IsStatusActive(GetGameValue(myChar, "IsHooked")) then
            getgenv().IsUnhooking = true 
            
            task.spawn(function()
                if CachedHBRemotes.SelfUnHook then
                    
                    -- ==========================================
                    -- FASE 1: INJEKSI ATRIBUT PELUANG KEMUTLAKAN
                    -- Membanjiri memori dengan atribut yang sering dipakai Perk Unhook
                    -- ==========================================
                    pcall(function()
                        local fakeChance = 100
                        local fakeLuck = 9999
                        
                        -- Suntik ke Player
                        LocalPlayer:SetAttribute("UnhookChance", fakeChance)
                        LocalPlayer:SetAttribute("EscapeChance", fakeChance)
                        LocalPlayer:SetAttribute("Luck", fakeLuck)
                        
                        -- Suntik ke Karakter
                        if myChar then
                            myChar:SetAttribute("UnhookChance", fakeChance)
                            myChar:SetAttribute("EscapeChance", fakeChance)
                            myChar:SetAttribute("Luck", fakeLuck)
                        end
                    end)

                    -- ==========================================
                    -- FASE 2: TEMBAKAN REMOTE DENGAN ARGUMEN PERK
                    -- ==========================================
                    for i = 1, 3 do
                        if not GetGameValue(myChar, "IsHooked") then break end 
                        
                        pcall(function() 
                            -- 1. Tembakan Normal
                            CachedHBRemotes.SelfUnHook:FireServer()
                            
                            -- 2. Tembakan Meniru Parameter Perk (Bypass)
                            -- Biasanya Perk mengirimkan argumen tambahan ke server
                            CachedHBRemotes.SelfUnHook:FireServer(100) 
                            CachedHBRemotes.SelfUnHook:FireServer(true, "PerkOverride")
                            CachedHBRemotes.SelfUnHook:FireServer("Deliverance") 
                            CachedHBRemotes.SelfUnHook:FireServer("Group Project") 
                        end)
                        
                        task.wait(1.5) 
                    end
                end
            end)

            WindUI:Notify({ 
                Title = "Spoofing Chance...", 
                Content = "Menyuntikkan peluang 100% untuk lepas dari hook!", 
                Icon = "lucide:anchor" 
            })
            
            task.spawn(function()
                task.wait(15) 
                getgenv().IsUnhooking = false
            end)
        end
    end

    local lastGenESPUpdate = getgenv().LastGenESPUpdate or 0
    if ActiveGenerators and now - lastGenESPUpdate > 0.5 then
        getgenv().LastGenESPUpdate = now
        for i = #ActiveGenerators, 1, -1 do
            local gen = ActiveGenerators[i]
            if updateGeneratorProgress(gen) then table.remove(ActiveGenerators, i) end
        end
    end
end)
-- =========================================================
-- [ULTIMATE VIP] GOD-AI AUTO FARM (ULTRA MOBILE OPTIMIZED)
-- =========================================================
local CachedHealEvent = nil
local SearchHealRemote = false

task.spawn(function()
    -- [FIX CPU] Berpikir 3x sedetik sudah lebih dari cukup untuk AI. Menghemat 70% RAM!
    while task.wait(0.35) do 
        if not getgenv().FORKT_RUNNING then break end
        
        if not AutoFarmBot then 
            getgenv().CachedWaypoints = nil
            continue 
        end 
        
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            
            if not myRoot or not myHum or myHum.Health <= 0 then return end
            
            local team = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
            if team:find("killer") then return end 

            -- [OPTIMASI 1] Simpan posisi di variabel lokal agar tidak memanggil ".Position" berulang kali
            local myPos = myRoot.Position

            -- ==========================================
            -- 1. [OPTIMASI] SINGLE LOOP PEMAIN
            -- Menggabungkan pencarian Killer dan Teman (Hemat 50% CPU)
            -- ==========================================
            local closestKillerDist = 999
            local killerRoot = nil
            
            local injuredTeammate = nil
            local shortestMateDist = 90

            local players = Players:GetPlayers()
            for _, p in ipairs(players) do
                if p ~= LocalPlayer and p.Character then
                    local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if eRoot then
                        local eTeam = p.Team and p.Team.Name:lower() or ""
                        local dist = (eRoot.Position - myPos).Magnitude

                        if eTeam:find("killer") then
                            if dist < closestKillerDist then
                                closestKillerDist = dist
                                killerRoot = eRoot
                            end
                        else
                            local isKnocked = GetGameValue(p.Character, "Knocked")
                            local eHum = p.Character:FindFirstChild("Humanoid")
                            local isInjured = eHum and eHum.Health < eHum.MaxHealth
                            
                            if (isKnocked or isInjured) and dist < shortestMateDist then
                                shortestMateDist = dist
                                injuredTeammate = p.Character
                            end
                        end
                    end
                end
            end

            -- ==========================================
            -- 2. [OPTIMASI] ZERO-ALLOCATION GENERATOR
            -- Menghitung & mencari Gen terdekat TANPA membuat table/array baru
            -- ==========================================
            local completedGens = 0
            local shortestGenDist = 9999
            local bestGenTarget = nil

            if CachedMapObjects and CachedMapObjects.Generators then
                for _, gen in ipairs(CachedMapObjects.Generators) do
                    local progress = GetGameValue(gen, "RepairProgress") or GetGameValue(gen, "Progress") or 0
                    if progress >= 100 then
                        completedGens = completedGens + 1
                    else
                        local genPos = gen:GetPivot().Position
                        local dist = (genPos - myPos).Magnitude
                        if dist < shortestGenDist then
                            shortestGenDist = dist
                            bestGenTarget = genPos
                        end
                    end
                end
            end

            -- ==========================================
            -- 3. STATE MACHINE (PRIORITAS TINDAKAN)
            -- ==========================================
            local targetPos = nil
            local actionState = "Idle"

            -- PRIORITAS 1: Lari dari Killer
            if closestKillerDist <= 70 and killerRoot then
                local maxDistFromKiller = 0
                local bestEscapeTarget = nil
                local killerPos = killerRoot.Position

                -- [OPTIMASI] Virtual Loop (Menghindari pembuatan table safeSpots={})
                local function checkSafeSpot(spot)
                    local spotPos = spot:GetPivot().Position
                    local distFromKiller = (spotPos - killerPos).Magnitude
                    if distFromKiller > maxDistFromKiller then
                        maxDistFromKiller = distFromKiller
                        bestEscapeTarget = spotPos
                    end
                end

                if CachedMapObjects.Generators then
                    for _, g in ipairs(CachedMapObjects.Generators) do checkSafeSpot(g) end
                end
                if CachedMapObjects.Gates then
                    for _, g in ipairs(CachedMapObjects.Gates) do checkSafeSpot(g) end
                end
                
                if bestEscapeTarget then
                    targetPos = bestEscapeTarget
                    actionState = "Evading"
                else
                    local runDir = (myPos - killerPos).Unit
                    targetPos = myPos + (runDir * 50)
                    actionState = "Evading"
                end

            -- PRIORITAS 2: Heal Teman
            elseif injuredTeammate then
                targetPos = injuredTeammate.HumanoidRootPart.Position
                actionState = "Healing"
                
                if shortestMateDist <= 12 then
                    -- [OPTIMASI] Cari Remote hanya 1x saja seumur hidup script
                    if not SearchHealRemote then
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        CachedHealEvent = remotes and (remotes:FindFirstChild("HealEvent", true) or remotes:FindFirstChild("RequestHeal", true) or remotes:FindFirstChild("ReviveEvent", true))
                        SearchHealRemote = true
                    end

                    if CachedHealEvent then
                        pcall(function() CachedHealEvent:FireServer(injuredTeammate, 100) end)
                        pcall(function() CachedHealEvent:FireServer(injuredTeammate, true) end)
                    end
                    
                    getgenv().CachedWaypoints = nil
                    if (myHum.WalkToPoint - myPos).Magnitude > 1 then
                        myHum:MoveTo(myPos)
                    end
                    return
                end

            -- PRIORITAS 3: Perbaiki Generator
            elseif completedGens < 5 and bestGenTarget then
                targetPos = bestGenTarget
                actionState = "Repairing"
                
            -- PRIORITAS 4: Lari ke Gerbang
            elseif completedGens >= 5 then
                if CachedMapObjects and CachedMapObjects.Gates then
                    local shortestGate = 9999
                    for _, gate in ipairs(CachedMapObjects.Gates) do
                        local gatePos = gate:GetPivot().Position
                        local dist = (gatePos - myPos).Magnitude
                        if dist < shortestGate then
                            shortestGate = dist
                            targetPos = gatePos
                            actionState = "Escaping"
                        end
                    end
                end
            end

            -- ==========================================
            -- 4. [OPTIMASI] ASYNC PATHFINDING
            -- ==========================================
            if targetPos then
                local now = os.clock()
                local lastPathCalc = getgenv().LastPathCalc or 0
                local lastTargetPos = getgenv().LastTargetPos or Vector3.new()
                
                if (targetPos - lastTargetPos).Magnitude > 5 or (now - lastPathCalc > 1.5) then
                    getgenv().LastPathCalc = now
                    getgenv().LastTargetPos = targetPos
                    
                    -- [OPTIMASI] Pindahkan fungsi kalkulasi berat ini ke background thread!
                    -- Sehingga loop AI tetap berjalan lancar selagi rute dipikirkan.
                    task.spawn(function()
                        pcall(function()
                            local path = PathfindingService:CreatePath({ 
                                AgentRadius = 2.5,  
                                AgentHeight = 5, 
                                AgentCanJump = true,
                                WaypointSpacing = 4 
                            })
                            path:ComputeAsync(myPos, targetPos)
                            
                            if path.Status == Enum.PathStatus.Success then
                                getgenv().CachedWaypoints = path:GetWaypoints()
                                getgenv().CurrentWaypointIdx = 2 
                            else
                                getgenv().CachedWaypoints = nil
                            end
                        end)
                    end)
                end
                
                local waypoints = getgenv().CachedWaypoints
                local idx = getgenv().CurrentWaypointIdx
                
                if waypoints and idx and idx <= #waypoints then
                    local nextPoint = waypoints[idx]
                    local distToWaypoint = (nextPoint.Position - myPos).Magnitude
                    
                    if distToWaypoint < 4 then
                        getgenv().CurrentWaypointIdx = idx + 1
                        if getgenv().CurrentWaypointIdx <= #waypoints then
                            nextPoint = waypoints[getgenv().CurrentWaypointIdx]
                        end
                    end
                    
                    if nextPoint then
                        myHum:MoveTo(nextPoint.Position)
                        if nextPoint.Action == Enum.PathWaypointAction.Jump then 
                            myHum.Jump = true 
                        end
                    end
                else
                    myHum:MoveTo(targetPos)
                end
            else
                getgenv().CachedWaypoints = nil
                if (myHum.WalkToPoint - myPos).Magnitude > 1 then
                    myHum:MoveTo(myPos) 
                end
            end
        end)
    end
end)

-- =========================================================
-- [ULTIMATE VIP] AUTO-WIGGLE MASTER (ANTI-PING SPIKE)
-- =========================================================
task.spawn(function()
    local cachedWiggleRemotes = {}
    local hasSearchedWiggle = false
    
    while task.wait(0.1) do 
        if not getgenv().FORKT_RUNNING then break end
        
        if AutoWiggle then
            pcall(function()
                local myChar = LocalPlayer.Character
                if myChar and (GetGameValue(myChar, "Carried") or GetGameValue(myChar, "IsCarried") or GetGameValue(myChar, "Grabbed")) then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    
                    if remotes then
                        -- [FIX] Gunakan remote khusus melepaskan diri (Bukan Vault)
                        if not hasSearchedWiggle then
                            cachedWiggleRemotes[1] = remotes:FindFirstChild("Wiggle", true) or remotes:FindFirstChild("Struggle", true)
                            cachedWiggleRemotes[2] = remotes:FindFirstChild("WiggleEvent", true) or remotes:FindFirstChild("StruggleEvent", true)
                            hasSearchedWiggle = true
                        end
                        
                        for _, remote in pairs(cachedWiggleRemotes) do
                            if remote then
                                remote:FireServer(true)
                                remote:FireServer()
                            end
                        end
                    end
                else
                    hasSearchedWiggle = false -- Reset saat dilepas
                end
            end)
        end
    end
end)
-- =========================================================
-- [SUPPORT VIP] GOD-TIER AUTO HEAL AURA (MOBILE OPTIMIZED)
-- =========================================================
local healedTeammates = {} 
local CachedAuraRemotes = {} 
local SearchedAuraRemotes = false 

task.spawn(function()
    -- [FIX 1] Helper function lokal khusus Aura agar tidak terjebak bug angka 0
    local function IsActive(val)
        return val == true or (type(val) == "number" and val > 0)
    end

    while task.wait(0.5) do 
        if not getgenv().FORKT_RUNNING then break end
        
        if AutoHealAura then
            pcall(function()
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end

                local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
                if myTeam:find("killer") then return end 

                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if not remotes then return end
                
                if not SearchedAuraRemotes then
                    -- [FIX 2] Perluas pencarian nama Remote agar pasti kena!
                    CachedAuraRemotes.HealEvent = remotes:FindFirstChild("HealEvent", true) or remotes:FindFirstChild("RequestHeal", true) or remotes:FindFirstChild("Heal", true)
                    CachedAuraRemotes.ReviveEvent = remotes:FindFirstChild("ReviveEvent", true) or remotes:FindFirstChild("Revive", true) or remotes:FindFirstChild("Help", true)
                    CachedAuraRemotes.DisplayBloodEvent = remotes:FindFirstChild("DisplayBlood", true)
                    SearchedAuraRemotes = true 
                end

                local healEvent = CachedAuraRemotes.HealEvent
                local reviveEvent = CachedAuraRemotes.ReviveEvent
                local displayBloodEvent = CachedAuraRemotes.DisplayBloodEvent

                -- [FIX 3] Pastikan Jarak (Radius) dibaca sebagai angka mutlak, bukan tabel!
                local safeRadius = type(HealAuraRadius) == "table" and (HealAuraRadius.Value or HealAuraRadius.Default or 20) or tonumber(HealAuraRadius) or 20

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local eTeam = p.Team and p.Team.Name:lower() or ""
                        
                        if not eTeam:find("killer") then 
                            local mateChar = p.Character
                            local dist = (mateChar.HumanoidRootPart.Position - myRoot.Position).Magnitude
                            
                            -- Cek apakah teman masuk ke dalam jangkauan Aura
                            if dist <= safeRadius then
                                local mateHum = mateChar:FindFirstChild("Humanoid")
                                
                                -- Terapkan IsActive agar logic tidak tertipu oleh angka 0
                                local isKnocked = IsActive(GetGameValue(mateChar, "Knocked")) or IsActive(GetGameValue(mateChar, "Downed"))
                                local isBleeding = IsActive(GetGameValue(mateChar, "Bleeding"))
                                local isInjured = mateHum and mateHum.Health < mateHum.MaxHealth
                                
                                if isKnocked or isInjured or isBleeding then
                                    local lastHeal = healedTeammates[p.UserId] or 0
                                    if os.clock() - lastHeal > 2 then 
                                        healedTeammates[p.UserId] = os.clock()
                                        
                                        -- [FIX 4] Tembakan Remote Ganda (Menggunakan mateChar DAN p)
                                        -- Karena arsitektur tiap game berbeda-beda
                                        if healEvent then
                                            pcall(function() healEvent:FireServer(mateChar) end)
                                            pcall(function() healEvent:FireServer(p) end)
                                            pcall(function() healEvent:FireServer(mateChar, 100) end)
                                            pcall(function() healEvent:FireServer(mateChar, true) end)
                                        end
                                        
                                        if isKnocked and reviveEvent then
                                            pcall(function() reviveEvent:FireServer(mateChar) end)
                                            pcall(function() reviveEvent:FireServer(p) end)
                                            pcall(function() reviveEvent:FireServer(mateChar, true) end)
                                        end
                                        
                                        if displayBloodEvent then
                                            pcall(function() displayBloodEvent:FireServer(mateChar, false) end)
                                            pcall(function() displayBloodEvent:FireServer(p, false) end)
                                        end

                                        WindUI:Notify({
                                            Title = "Aura Triggered!", 
                                            Content = "Menyembuhkan: " .. p.Name, 
                                            Icon = "lucide:cross"
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if SpeedBoost then hum.WalkSpeed = BoostSpeed end
end)

-- =========================================================
-- FITUR TERPISAH: NO GRAVITY PROJECTILE (TOMBAK LURUS / ANTI-LAG) 
-- =========================================================
table.insert(getgenv().FORKT_CONNECTIONS, workspace.DescendantAdded:Connect(function(obj)
    -- [OPTIMASI 1] Fast-fail: Jangan proses jika fitur mati atau objek bukan BasePart
    if not AntiGravitySpear or not obj:IsA("BasePart") then return end
    
    -- [OPTIMASI 2] Fast-fail: Abaikan objek yang diam/statis (Anchored). 
    -- Ini menghemat 99% beban CPU HP karena mengabaikan spawn bangunan map!
    if obj.Anchored then return end

    local name = obj.Name:lower()
    
    -- [FIX FATAL] Kata "hitbox" dihapus agar lengan karakter tidak melayang ke langit saat menyerang.
    if name:find("spear") or name:find("tombak") or name:find("projectile") or name:find("throw") then
        
        -- Waktu tunggu diturunkan ke 0.02 agar tombak tidak sempat menukik sebelum daya angkat bekerja
        task.delay(0.02, function()
            -- Pastikan objek masih hidup, masih di dunia, dan tidak tiba-tiba di-anchor server
            if obj and obj.Parent and not obj.Anchored then
                local totalMass = obj.AssemblyMass
                
                -- Cegah error matematika (NaN) jika massa tombaknya 0 atau tidak berwujud
                if totalMass and totalMass > 0 then
                    local antiGrav = obj:FindFirstChild("FORKT_AntiGrav") or Instance.new("BodyForce")
                    antiGrav.Name = "FORKT_AntiGrav"
                    
                    -- Menyuntikkan daya angkat persis sebesar berat benda X Gravitasi bumi
                    antiGrav.Force = Vector3.new(0, totalMass * workspace.Gravity, 0)
                    antiGrav.Parent = obj
                end
            end
        end)
        
    end
end))

-- =========================================================
-- [VIP] INSTANT ESCAPE (AUTO-TELEPORT FINISH)
-- =========================================================
task.spawn(function()
    local lastEscapeAttempt = 0
    
    while task.wait(1) do -- Cek setiap 1 detik agar hemat CPU Mobile
        if not getgenv().FORKT_RUNNING then break end
        
        if InstantEscape then
            pcall(function()
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChild("Humanoid")
                if not myRoot or not myHum or myHum.Health <= 0 then return end
                
                -- Pastikan fitur ini tidak aktif jika kamu sedang jadi Killer
                local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
                if myTeam:find("killer") then return end

                -- 1. HITUNG GENERATOR YANG SUDAH SELESAI
                local completedGens = 0
                if CachedMapObjects and CachedMapObjects.Generators then
                    for _, gen in ipairs(CachedMapObjects.Generators) do
                        local progress = type(GetGameValue) == "function" and (GetGameValue(gen, "RepairProgress") or GetGameValue(gen, "Progress") or 0) or 0
                        if progress >= 100 then
                            completedGens = completedGens + 1
                        end
                    end
                end

                -- Cari Gerbang (Gate)
                local targetGate = nil
                if CachedMapObjects and CachedMapObjects.Gates and #CachedMapObjects.Gates > 0 then
                    targetGate = CachedMapObjects.Gates[1]
                else
                    local mapFolder = workspace:FindFirstChild("Map")
                    targetGate = mapFolder and mapFolder:FindFirstChild("Gate")
                end

                -- Cek apakah gerbang sudah terbuka oleh orang lain
                local isGateOpen = false
                if targetGate then
                    isGateOpen = GetGameValue(targetGate, "Opened") or GetGameValue(targetGate, "IsOpen") or false
                end

                -- =========================================================
                -- 2. EKSEKUSI ESCAPE (JIKA 5 GEN SELESAI / GATE TERBUKA)
                -- =========================================================
                if completedGens >= 5 or isGateOpen then
                    local now = os.clock()
                    
                    -- Jeda 5 detik agar tidak dispam terus-terusan
                    if now - lastEscapeAttempt > 5 then
                        lastEscapeAttempt = now
                        
                        -- A. Tarik Tuas Secara Remote (Untuk memicu event Server)
                        local exitLever = targetGate and targetGate:FindFirstChild("ExitLever") and targetGate.ExitLever:FindFirstChild("Main")
                        if exitLever then
                            local exitRemote = ReplicatedStorage:FindFirstChild("Remotes") and 
                                               ReplicatedStorage.Remotes:FindFirstChild("Exit") and 
                                               ReplicatedStorage.Remotes.Exit:FindFirstChild("LeverEvent")
                            if exitRemote then
                                pcall(function() exitRemote:FireServer(exitLever, true) end)
                            end
                        end

                        -- B. SUNTIK REMOTE ESCAPE LANGSUNG (Jika game memakai remote untuk kabur)
                        local escapeRemote = ReplicatedStorage:FindFirstChild("Remotes") and 
                                             ReplicatedStorage.Remotes:FindFirstChild("Exit") and 
                                             ReplicatedStorage.Remotes.Exit:FindFirstChild("EscapeEvent")
                        if escapeRemote then
                            pcall(function() escapeRemote:FireServer() end)
                        end

                        -- C. AUTO-TELEPORT KE ZONA FINISH
                        if targetGate then
                            local escapeZone = nil
                            -- Cari part transparan pembatas Finish di dalam Gate
                            for _, obj in ipairs(targetGate:GetDescendants()) do
                                if obj:IsA("BasePart") and obj ~= exitLever then
                                    local n = obj.Name:lower()
                                    if n:find("escape") or n:find("exit") or n:find("finish") or n:find("win") then
                                        escapeZone = obj
                                        break
                                    end
                                end
                            end

                            -- Jika zona Finish ketemu, langsung teleport ke sana
                            if escapeZone then
                                myRoot.CFrame = escapeZone.CFrame
                            else
                                -- Fallback: Teleport paksa menembus gerbang (dorong 25 stud ke arah pintu keluar)
                                myRoot.CFrame = targetGate:GetPivot() * CFrame.new(0, 0, -25)
                            end
                        end

                        WindUI:Notify({ 
                            Title = "GOD ESCAPE!", 
                            Content = "Syarat terpenuhi! Teleport langsung ke luar ronde!", 
                            Icon = "lucide:door-open" 
                        })
                    end
                end
            end)
        end
    end
end)

WindUI:Notify({ 
    Title = "Welcome to FORKT-HUB!", 
    Content = "God-AI Systems Initialized.\n💻 PC User: Press [Right Control] to open/hide the UI.", 
    Duration = 8,
    CanClose = false,
    Icon = "lucide:sparkles" 
})
