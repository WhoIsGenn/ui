--[[
    Word Chain Auto Script
    Game: Sambung Kata (Word Chain)
    UI: WindUI
    
    Features:
    - Auto Answer: otomatis jawab berdasarkan huruf terakhir kata sekarang
    - Auto Correct: detect & fix jika kata yang diketik tidak valid
    - ESP: highlight kata valid di billboard/UI game
    - GUI: WindUI panel on/off
]]

-- ============================================================
-- SERVICES
-- ============================================================

local cloneref          = (cloneref or clonereference or function(i) return i end)
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local TweenService      = cloneref(game:GetService("TweenService"))
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- LOAD WINDUI
-- ============================================================

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ============================================================
-- REMOTES & SERVICES (wait safely)
-- ============================================================

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)

local function getRemote(name, timeout)
    timeout = timeout or 10
    local r = Remotes and Remotes:WaitForChild(name, timeout)
    if not r then warn("[WordChain] Remote tidak ditemukan: " .. name) end
    return r
end

-- Remote Events
local R_SubmitWord          = getRemote("SubmitWord")
local R_UpdateCurrentWord   = getRemote("UpdateCurrentWord")
local R_PlayerCorrect       = getRemote("PlayerCorrect")
local R_PlayerHit           = getRemote("PlayerHit")
local R_UsedWordWarn        = getRemote("UsedWordWarn")
local R_WordUpdate          = getRemote("WordUpdate")
local R_UpdateWordIndex     = getRemote("UpdateWordIndex")
local R_RequestWordIndex    = getRemote("RequestWordindex")
local R_TypeSound           = getRemote("TypeSound")
local R_UpdateBillboard     = getRemote("UpdateBillboard")
local R_UpdateCurrentWord   = getRemote("UpdateCurrentWord")
local R_MatchUI             = getRemote("MatchUI")
local R_ResultUI            = getRemote("ResultUI")
local R_TurnCamera          = getRemote("TurnCamera")
local R_JoinTable           = getRemote("JoinTable")
local R_LeaveTable          = getRemote("LeaveTable")

-- Services (optional)
local Services     = ReplicatedStorage:FindFirstChild("Services")
local WordService  = Services and Services:FindFirstChild("WordService")

-- WordList
local WordListFolder  = ReplicatedStorage:FindFirstChild("WordList")
local IndonesianWords = WordListFolder and WordListFolder:FindFirstChild("IndonesianWords")

-- ============================================================
-- WORD LIST LOADER
-- ============================================================

local WordList = {}      -- array semua kata
local WordSet  = {}      -- set untuk fast lookup: WordSet["kata"] = true
local WordsByLetter = {} -- index: WordsByLetter["a"] = {"ayam","api",...}

local function loadWordList()
    if not IndonesianWords then
        warn("[WordChain] IndonesianWords tidak ditemukan di WordList folder!")
        return
    end

    local count = 0

    -- Coba baca sebagai StringValue children
    for _, child in ipairs(IndonesianWords:GetChildren()) do
        local word = nil
        if child:IsA("StringValue") then
            word = child.Value:lower():gsub("%s+", "")
        elseif child:IsA("ModuleScript") then
            -- Kalau module, coba require
            local ok, result = pcall(function() return require(child) end)
            if ok and type(result) == "table" then
                for _, w in ipairs(result) do
                    w = tostring(w):lower():gsub("%s+", "")
                    if #w >= 2 then
                        table.insert(WordList, w)
                        WordSet[w] = true
                        local firstLetter = w:sub(1,1)
                        if not WordsByLetter[firstLetter] then
                            WordsByLetter[firstLetter] = {}
                        end
                        table.insert(WordsByLetter[firstLetter], w)
                        count = count + 1
                    end
                end
                goto continue
            end
        end

        if word and #word >= 2 then
            table.insert(WordList, word)
            WordSet[word] = true
            local firstLetter = word:sub(1,1)
            if not WordsByLetter[firstLetter] then
                WordsByLetter[firstLetter] = {}
            end
            table.insert(WordsByLetter[firstLetter], word)
            count = count + 1
        end

        ::continue::
    end

    -- Kalau IndonesianWords sendiri adalah StringValue/ModuleScript
    if count == 0 then
        if IndonesianWords:IsA("ModuleScript") then
            local ok, result = pcall(function() return require(IndonesianWords) end)
            if ok and type(result) == "table" then
                for _, w in ipairs(result) do
                    w = tostring(w):lower():gsub("%s+", "")
                    if #w >= 2 then
                        table.insert(WordList, w)
                        WordSet[w] = true
                        local firstLetter = w:sub(1,1)
                        if not WordsByLetter[firstLetter] then WordsByLetter[firstLetter] = {} end
                        table.insert(WordsByLetter[firstLetter], w)
                        count = count + 1
                    end
                end
            end
        end
    end

    print(string.format("[WordChain] WordList loaded: %d kata", count))
end

loadWordList()

-- ============================================================
-- GAME STATE
-- ============================================================

local State = {
    CurrentWord     = "",       -- kata yang sedang aktif / harus disambung
    LastLetter      = "",       -- huruf terakhir dari CurrentWord
    UsedWords       = {},       -- set kata yang sudah dipakai
    MyTurn          = false,    -- apakah giliran kita
    AutoAnswer      = false,    -- toggle auto answer
    AutoCorrect     = false,    -- toggle auto correct
    ESPEnabled      = false,    -- toggle ESP
    AnswerDelay     = 0.8,      -- delay sebelum auto answer (detik)
    CorrectCount    = 0,        -- jumlah jawaban benar
    WrongCount      = 0,        -- jumlah jawaban salah
    LastAnswered    = "",       -- kata terakhir yang kita kirim
}

-- ============================================================
-- WORD LOGIC
-- ============================================================

-- Cek apakah kata valid untuk disambung dari huruf tertentu
local function isValidWord(word, requiredFirstLetter)
    word = word:lower():gsub("%s+", "")
    if #word < 2 then return false end
    if requiredFirstLetter and word:sub(1,1) ~= requiredFirstLetter:lower() then return false end
    if not WordSet[word] then return false end
    if State.UsedWords[word] then return false end
    return true
end

-- Cari kata terbaik berdasarkan huruf awal
-- Priority: kata yang huruf terakhirnya jarang (biar lawan susah)
local function findBestWord(firstLetter)
    firstLetter = firstLetter:lower()
    local candidates = WordsByLetter[firstLetter]
    if not candidates or #candidates == 0 then
        -- Fallback: cari di semua kata
        candidates = {}
        for _, w in ipairs(WordList) do
            if w:sub(1,1) == firstLetter and not State.UsedWords[w] then
                table.insert(candidates, w)
            end
        end
    end

    if #candidates == 0 then return nil end

    -- Filter yang belum dipakai
    local available = {}
    for _, w in ipairs(candidates) do
        if not State.UsedWords[w] then
            table.insert(available, w)
        end
    end

    if #available == 0 then return nil end

    -- Sort berdasarkan: kata yang huruf terakhirnya punya sedikit kata (menyulitkan lawan)
    -- Dan panjang kata lebih diutamakan
    table.sort(available, function(a, b)
        local lastA = a:sub(-1)
        local lastB = b:sub(-1)
        local countA = WordsByLetter[lastA] and #WordsByLetter[lastA] or 0
        local countB = WordsByLetter[lastB] and #WordsByLetter[lastB] or 0
        if countA ~= countB then
            return countA < countB -- huruf terakhir yang rare lebih diutamakan
        end
        return #a > #b -- kata panjang lebih diutamakan
    end)

    return available[1]
end

-- Auto correct: cari kata yang paling mirip dengan input
local function findClosestWord(input, firstLetter)
    input = input:lower():gsub("%s+", "")
    if #input == 0 then return nil end

    firstLetter = firstLetter or input:sub(1,1)
    local candidates = WordsByLetter[firstLetter] or {}

    if #candidates == 0 then return nil end

    -- Simple Levenshtein distance
    local function levenshtein(s, t)
        local m, n = #s, #t
        local d = {}
        for i = 0, m do d[i] = {[0] = i} end
        for j = 0, n do d[0][j] = j end
        for i = 1, m do
            for j = 1, n do
                local cost = s:sub(i,i) == t:sub(j,j) and 0 or 1
                d[i][j] = math.min(
                    d[i-1][j] + 1,
                    d[i][j-1] + 1,
                    d[i-1][j-1] + cost
                )
            end
        end
        return d[m][n]
    end

    local bestWord, bestDist = nil, math.huge
    for _, w in ipairs(candidates) do
        if not State.UsedWords[w] then
            local dist = levenshtein(input, w)
            -- Max toleransi: 2 karakter berbeda, dan panjang kata mirip
            if dist < bestDist and dist <= 2 and math.abs(#input - #w) <= 2 then
                bestDist = dist
                bestWord = w
            end
        end
    end

    return bestWord
end

-- Submit kata ke server
local function submitWord(word)
    if not word or #word == 0 then return false end
    word = word:lower():gsub("%s+", "")

    if not R_SubmitWord then
        warn("[WordChain] R_SubmitWord remote tidak ada!")
        return false
    end

    State.LastAnswered = word
    State.UsedWords[word] = true

    local ok = pcall(function()
        R_SubmitWord:FireServer(word)
    end)

    if ok then
        print("[WordChain] ✅ Submit: " .. word)
    else
        warn("[WordChain] ❌ Gagal submit: " .. word)
    end

    return ok
end

-- ============================================================
-- AUTO ANSWER LOGIC
-- ============================================================

local answerDebounce = false

local function triggerAutoAnswer()
    if answerDebounce then return end
    if not State.AutoAnswer then return end
    if not State.MyTurn then return end
    if State.LastLetter == "" then return end

    answerDebounce = true

    task.spawn(function()
        task.wait(State.AnswerDelay)

        if not State.MyTurn or not State.AutoAnswer then
            answerDebounce = false
            return
        end

        local word = findBestWord(State.LastLetter)
        if word then
            submitWord(word)
            State.CorrectCount = State.CorrectCount + 1
        else
            warn("[WordChain] Tidak ada kata yang tersedia untuk huruf: " .. State.LastLetter)
        end

        task.wait(0.5)
        answerDebounce = false
    end)
end

-- ============================================================
-- AUTO CORRECT LOGIC
-- ============================================================

-- Hook ke TextBox input game jika ada
local function hookTextBox()
    task.spawn(function()
        -- Tunggu sampai ada TextBox aktif di PlayerGui
        while true do
            task.wait(0.3)
            if not State.AutoCorrect then continue end

            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if not playerGui then continue end

            -- Scan semua TextBox di PlayerGui
            for _, obj in ipairs(playerGui:GetDescendants()) do
                if obj:IsA("TextBox") and obj.Focused then
                    -- Sudah ada connection? Skip
                    if obj:GetAttribute("ACHooked") then continue end
                    obj:SetAttribute("ACHooked", true)

                    -- Hook FocusLost untuk auto correct sebelum submit
                    obj.FocusLost:Connect(function(enterPressed)
                        if not State.AutoCorrect then return end
                        if not enterPressed then return end

                        local inputText = obj.Text:lower():gsub("%s+", "")
                        if #inputText == 0 then return end

                        -- Cek apakah kata valid
                        if isValidWord(inputText, State.LastLetter) then
                            -- Valid, biarkan submit normal
                            return
                        end

                        -- Tidak valid, cari closest
                        local corrected = findClosestWord(inputText, State.LastLetter)
                        if corrected then
                            print(string.format("[WordChain] AutoCorrect: '%s' → '%s'", inputText, corrected))
                            obj.Text = corrected
                            -- Submit kata yang sudah dikoreksi
                            task.wait(0.05)
                            submitWord(corrected)
                            State.CorrectCount = State.CorrectCount + 1
                        else
                            -- Tidak ada koreksi, cari kata valid baru
                            local fallback = findBestWord(State.LastLetter)
                            if fallback then
                                print(string.format("[WordChain] AutoCorrect fallback: '%s' → '%s'", inputText, fallback))
                                obj.Text = fallback
                                task.wait(0.05)
                                submitWord(fallback)
                            end
                        end
                    end)
                end
            end
        end
    end)
end

-- ============================================================
-- ESP: HIGHLIGHT VALID WORDS DI BILLBOARD
-- ============================================================

local ESPHighlights = {}

local function clearESP()
    for _, gui in ipairs(ESPHighlights) do
        pcall(function() gui:Destroy() end)
    end
    ESPHighlights = {}
end

local function updateESP()
    clearESP()
    if not State.ESPEnabled then return end
    if State.LastLetter == "" then return end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- Scan BillboardGui di workspace (kata yang ditampilkan game)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    local text = child.Text:lower():gsub("%s+", ""):gsub("[^%a]", "")
                    if #text >= 2 then
                        local valid = isValidWord(text, State.LastLetter)
                        if valid then
                            -- Tambah highlight hijau
                            local originalColor = child.TextColor3
                            child.TextColor3 = Color3.fromRGB(50, 255, 100)
                            child.TextStrokeTransparency = 0
                            child.TextStrokeColor3 = Color3.fromRGB(0, 100, 0)
                            table.insert(ESPHighlights, {
                                obj     = child,
                                origColor = originalColor
                            })
                        end
                    end
                end
            end
        end
    end
end

local function restoreESP()
    for _, entry in ipairs(ESPHighlights) do
        pcall(function()
            entry.obj.TextColor3 = entry.origColor
            entry.obj.TextStrokeTransparency = 1
        end)
    end
    ESPHighlights = {}
end

-- ============================================================
-- LISTEN TO REMOTE EVENTS
-- ============================================================

-- Update kata aktif saat ini
if R_UpdateCurrentWord then
    R_UpdateCurrentWord.OnClientEvent:Connect(function(word, ...)
        if type(word) == "string" then
            word = word:lower():gsub("%s+", "")
            State.CurrentWord = word
            State.LastLetter  = #word > 0 and word:sub(-1) or ""
            print(string.format("[WordChain] 📝 Kata sekarang: '%s' | Huruf terakhir: '%s'", word, State.LastLetter))

            if State.ESPEnabled then
                task.spawn(updateESP)
            end
        end
    end)
end

-- WordUpdate (bisa juga membawa current word)
if R_WordUpdate then
    R_WordUpdate.OnClientEvent:Connect(function(data, ...)
        if type(data) == "string" then
            data = data:lower():gsub("%s+", "")
            if #data > 0 then
                State.CurrentWord = data
                State.LastLetter  = data:sub(-1)
                print(string.format("[WordChain] 🔄 WordUpdate: '%s'", data))
            end
        elseif type(data) == "table" then
            -- Mungkin berisi banyak info
            if data.word then
                local w = tostring(data.word):lower():gsub("%s+", "")
                State.CurrentWord = w
                State.LastLetter  = w:sub(-1)
            end
        end

        -- Trigger auto answer jika giliran kita
        if State.MyTurn then
            triggerAutoAnswer()
        end
    end)
end

-- Deteksi giliran kita dari TurnCamera atau MatchUI
if R_TurnCamera then
    R_TurnCamera.OnClientEvent:Connect(function(player, ...)
        if player == LocalPlayer or player == LocalPlayer.Name then
            State.MyTurn = true
            print("[WordChain] 🎯 Giliran KITA!")
            triggerAutoAnswer()
        else
            State.MyTurn = false
        end
    end)
end

if R_MatchUI then
    R_MatchUI.OnClientEvent:Connect(function(data, ...)
        -- Coba detect turn info dari data
        if type(data) == "table" then
            if data.currentPlayer == LocalPlayer.Name or data.currentPlayer == LocalPlayer then
                State.MyTurn = true
                triggerAutoAnswer()
            elseif data.currentPlayer then
                State.MyTurn = false
            end
            -- Bisa juga membawa current word
            if data.currentWord then
                local w = tostring(data.currentWord):lower():gsub("%s+", "")
                State.CurrentWord = w
                State.LastLetter  = w:sub(-1)
            end
        elseif type(data) == "string" then
            -- Mungkin nama player yang giliran
            if data == LocalPlayer.Name then
                State.MyTurn = true
                triggerAutoAnswer()
            else
                State.MyTurn = false
            end
        end
    end)
end

-- Konfirmasi jawaban benar
if R_PlayerCorrect then
    R_PlayerCorrect.OnClientEvent:Connect(function(player, word, ...)
        local p = (player == LocalPlayer or player == LocalPlayer.Name)
        if p then
            print(string.format("[WordChain] ✅ BENAR! Kata: '%s'", tostring(word or State.LastAnswered)))
        end
        -- Update kata sekarang
        if type(word) == "string" and #word > 0 then
            word = word:lower():gsub("%s+", "")
            State.CurrentWord = word
            State.LastLetter  = word:sub(-1)
            State.UsedWords[word] = true
        end
        State.MyTurn = false
    end)
end

-- Kena hit / jawaban salah
if R_PlayerHit then
    R_PlayerHit.OnClientEvent:Connect(function(player, ...)
        local p = (player == LocalPlayer or player == LocalPlayer.Name)
        if p then
            State.WrongCount = State.WrongCount + 1
            print("[WordChain] ❌ Kena hit! (salah/timeout)")
        end
    end)
end

-- Kata sudah dipakai
if R_UsedWordWarn then
    R_UsedWordWarn.OnClientEvent:Connect(function(word, ...)
        if type(word) == "string" then
            word = word:lower():gsub("%s+", "")
            State.UsedWords[word] = true
            print(string.format("[WordChain] ⚠️ Kata sudah dipakai: '%s'", word))
        end
    end)
end

-- Update word index (tambah kata ke used list)
if R_UpdateWordIndex then
    R_UpdateWordIndex.OnClientEvent:Connect(function(data, ...)
        if type(data) == "string" then
            local w = data:lower():gsub("%s+", "")
            if #w > 0 then State.UsedWords[w] = true end
        elseif type(data) == "table" then
            for _, w in ipairs(data) do
                w = tostring(w):lower():gsub("%s+", "")
                if #w > 0 then State.UsedWords[w] = true end
            end
        end
    end)
end

-- ResultUI (game selesai, reset state)
if R_ResultUI then
    R_ResultUI.OnClientEvent:Connect(function(...)
        print("[WordChain] 🏁 Game selesai! Reset state.")
        State.UsedWords   = {}
        State.MyTurn      = false
        State.CurrentWord = ""
        State.LastLetter  = ""
        State.LastAnswered = ""
        clearESP()
    end)
end

-- ============================================================
-- START HOOKS
-- ============================================================

hookTextBox()

-- ============================================================
-- WINDUI
-- ============================================================

local Window = WindUI:CreateWindow({
    Title  = "Word Chain Script",
    Icon   = "type",
    Folder = "WordChainScript",
    NewElements = true,
    OpenButton = {
        Title        = "Word Chain",
        Enabled      = true,
        Draggable    = true,
        OnlyMobile   = false,
        CornerRadius = UDim.new(1, 0),
        Color        = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#00AAFF")
        ),
    },
    Topbar = {
        Height      = 44,
        ButtonsType = "Mac",
    },
})

Window:Tag({ Title = "v1.0", Icon = "tag", Color = Color3.fromHex("#1c1c1c"), Border = true })
Window:Tag({
    Title  = string.format("%d kata", #WordList),
    Icon   = "book-open",
    Color  = Color3.fromHex("#1c1c1c"),
    Border = true
})


-- ============================================================
-- TAB: MAIN
-- ============================================================

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })

MainTab:Section({ Title = "Auto Features" })

-- Auto Answer Toggle
local AutoAnswerToggle = MainTab:Toggle({
    Title = "Auto Answer",
    Desc  = "Otomatis jawab berdasarkan huruf terakhir kata",
    Icon  = "bot",
    Value = false,
    Callback = function(state)
        State.AutoAnswer = state
        if state then
            WindUI:Notify({ Title = "Auto Answer", Content = "Aktif! Akan jawab otomatis saat giliran kamu.", Icon = "bot", Duration = 3 })
            -- Coba trigger kalau sudah ada state
            if State.MyTurn and State.LastLetter ~= "" then
                triggerAutoAnswer()
            end
        else
            WindUI:Notify({ Title = "Auto Answer", Content = "Dinonaktifkan.", Duration = 2 })
        end
    end
})

MainTab:Space()

-- Auto Correct Toggle
local AutoCorrectToggle = MainTab:Toggle({
    Title = "Auto Correct",
    Desc  = "Fix typo otomatis sebelum kata dikirim",
    Icon  = "spell-check",
    Value = false,
    Callback = function(state)
        State.AutoCorrect = state
        if state then
            WindUI:Notify({ Title = "Auto Correct", Content = "Aktif! Typo akan dikoreksi otomatis.", Icon = "spell-check", Duration = 3 })
        else
            WindUI:Notify({ Title = "Auto Correct", Content = "Dinonaktifkan.", Duration = 2 })
        end
    end
})

MainTab:Space()

-- ESP Toggle
local ESPToggle = MainTab:Toggle({
    Title = "ESP Valid Words",
    Desc  = "Highlight kata yang valid di billboard game",
    Icon  = "eye",
    Value = false,
    Callback = function(state)
        State.ESPEnabled = state
        if state then
            updateESP()
            WindUI:Notify({ Title = "ESP", Content = "Aktif! Kata valid di-highlight hijau.", Icon = "eye", Duration = 3 })
        else
            restoreESP()
            clearESP()
            WindUI:Notify({ Title = "ESP", Content = "Dinonaktifkan.", Duration = 2 })
        end
    end
})

MainTab:Space()
MainTab:Section({ Title = "Settings" })

-- Delay slider
MainTab:Slider({
    Title = "Answer Delay",
    Desc  = "Jeda sebelum auto answer dikirim (detik)",
    Step  = 1,
    Value = { Min = 1, Max = 30, Default = 8 },
    Callback = function(val)
        State.AnswerDelay = val / 10
    end
})

MainTab:Space()

-- Manual answer button
MainTab:Button({
    Title    = "Manual: Jawab Sekarang",
    Desc     = "Paksa cari & kirim kata terbaik sekarang",
    Icon     = "send",
    Justify  = "Center",
    Callback = function()
        if State.LastLetter == "" then
            WindUI:Notify({ Title = "Error", Content = "Belum ada kata aktif! Tunggu giliran.", Icon = "alert-circle", Duration = 3 })
            return
        end
        local word = findBestWord(State.LastLetter)
        if word then
            submitWord(word)
            WindUI:Notify({ Title = "Submitted!", Content = "'" .. word .. "'", Icon = "check-circle", Duration = 3 })
        else
            WindUI:Notify({ Title = "Gagal", Content = "Tidak ada kata tersedia untuk huruf '" .. State.LastLetter .. "'", Icon = "x-circle", Duration = 4 })
        end
    end
})

MainTab:Space()

-- Force set turn (bypass deteksi)
MainTab:Toggle({
    Title = "Force My Turn",
    Desc  = "Paksa anggap giliran kita (jika deteksi gagal)",
    Icon  = "user-check",
    Value = false,
    Callback = function(state)
        State.MyTurn = state
        if state and State.AutoAnswer and State.LastLetter ~= "" then
            triggerAutoAnswer()
        end
    end
})


-- ============================================================
-- TAB: WORD TOOLS
-- ============================================================

local WordTab = Window:Tab({ Title = "Word Tools", Icon = "book-open" })

WordTab:Section({ Title = "Dictionary Lookup" })

-- Cari kata dari huruf
local searchResultLabel
local searchInput = WordTab:Input({
    Title       = "Cari Kata dari Huruf",
    Desc        = "Ketik huruf awal, akan dicari kata terbaik",
    Icon        = "search",
    Placeholder = "Contoh: a",
    Callback    = function(val)
        -- live update
    end
})

WordTab:Button({
    Title    = "Cari Kata Terbaik",
    Icon     = "search",
    Justify  = "Center",
    Callback = function()
        local inputVal = searchInput and searchInput:Get() or ""
        local letter   = inputVal:lower():sub(1,1)

        if letter == "" then
            WindUI:Notify({ Title = "Error", Content = "Masukkan huruf dulu!", Duration = 2 })
            return
        end

        local word = findBestWord(letter)
        if word then
            WindUI:Notify({
                Title   = "Kata Terbaik untuk '" .. letter .. "'",
                Content = "→ " .. word .. "  (huruf terakhir: '" .. word:sub(-1) .. "')",
                Icon    = "check",
                Duration = 5
            })
            -- Copy to clipboard
            pcall(function() setclipboard(word) end)
        else
            WindUI:Notify({ Title = "Tidak Ditemukan", Content = "Tidak ada kata untuk huruf '" .. letter .. "'", Duration = 3 })
        end
    end
})

WordTab:Space()
WordTab:Section({ Title = "Word Validator" })

local validateInput = WordTab:Input({
    Title       = "Cek Kata Valid",
    Desc        = "Ketik kata untuk dicek apakah ada di kamus",
    Icon        = "spell-check",
    Placeholder = "Contoh: apel",
    Callback    = function(val) end
})

WordTab:Button({
    Title    = "Cek Kata",
    Icon     = "check-square",
    Justify  = "Center",
    Callback = function()
        local word = validateInput and validateInput:Get() or ""
        word = word:lower():gsub("%s+", "")
        if #word == 0 then
            WindUI:Notify({ Title = "Error", Content = "Masukkan kata dulu!", Duration = 2 })
            return
        end

        if WordSet[word] then
            local lastChar = word:sub(-1)
            local nextCount = WordsByLetter[lastChar] and #WordsByLetter[lastChar] or 0
            WindUI:Notify({
                Title   = "✅ Valid!",
                Content = string.format("'%s' ada di kamus.\nHuruf terakhir '%s' → %d kata tersedia buat lawan", word, lastChar, nextCount),
                Icon    = "check-circle",
                Duration = 5
            })
        else
            -- Cari yang paling mirip
            local closest = findClosestWord(word, word:sub(1,1))
            if closest then
                WindUI:Notify({
                    Title   = "❌ Tidak valid",
                    Content = string.format("'%s' tidak ada.\nMaksud kamu: '%s'?", word, closest),
                    Icon    = "x-circle",
                    Duration = 5
                })
            else
                WindUI:Notify({
                    Title   = "❌ Tidak valid",
                    Content = string.format("'%s' tidak ditemukan di kamus.", word),
                    Icon    = "x-circle",
                    Duration = 4
                })
            end
        end
    end
})

WordTab:Space()
WordTab:Section({ Title = "Top Kata per Huruf" })

WordTab:Button({
    Title    = "Print Top 5 Kata per Huruf",
    Desc     = "Cek console (F9) untuk hasilnya",
    Icon     = "list",
    Justify  = "Center",
    Callback = function()
        print("\n=== TOP 5 KATA PER HURUF ===")
        local letters = "abcdefghijklmnopqrstuvwxyz"
        for i = 1, #letters do
            local letter = letters:sub(i,i)
            local words  = WordsByLetter[letter]
            if words and #words > 0 then
                local top = {}
                for j = 1, math.min(5, #words) do
                    table.insert(top, words[j])
                end
                print(string.format("  %s: %s  (+%d lainnya)", letter:upper(), table.concat(top, ", "), math.max(0, #words - 5)))
            end
        end
        print("============================\n")
        WindUI:Notify({ Title = "Done", Content = "Cek console (F9)", Icon = "terminal", Duration = 3 })
    end
})


-- ============================================================
-- TAB: STATUS
-- ============================================================

local StatusTab = Window:Tab({ Title = "Status", Icon = "activity" })

StatusTab:Section({ Title = "Game State" })

StatusTab:Button({
    Title    = "Refresh Status",
    Icon     = "refresh-cw",
    Justify  = "Center",
    Callback = function()
        local available = WordsByLetter[State.LastLetter] or {}
        local usedCount = 0
        for _ in pairs(State.UsedWords) do usedCount = usedCount + 1 end

        WindUI:Notify({
            Title   = "Status Sekarang",
            Content = string.format(
                "Kata: '%s'\nHuruf next: '%s'\nKata tersedia: %d\nSudah dipakai: %d\nGiliran kita: %s\n✅ Benar: %d  ❌ Salah: %d",
                State.CurrentWord,
                State.LastLetter,
                #available,
                usedCount,
                State.MyTurn and "YA" or "TIDAK",
                State.CorrectCount,
                State.WrongCount
            ),
            Icon     = "info",
            Duration = 8
        })
    end
})

StatusTab:Space()

StatusTab:Button({
    Title    = "Reset Used Words",
    Desc     = "Hapus list kata yang sudah dipakai (reset per ronde)",
    Icon     = "trash-2",
    Callback = function()
        State.UsedWords = {}
        WindUI:Notify({ Title = "Reset", Content = "Used words list dikosongkan", Icon = "check", Duration = 2 })
    end
})

StatusTab:Space()

StatusTab:Button({
    Title    = "Set Current Word Manual",
    Desc     = "Override kata aktif secara manual",
    Icon     = "edit",
    Callback = function()
        -- Ambil dari clipboard atau input
        WindUI:Notify({
            Title   = "Info",
            Content = "Gunakan tab Word Tools → input manual, atau tunggu event dari server.",
            Icon    = "info",
            Duration = 4
        })
    end
})

StatusTab:Space()
StatusTab:Section({ Title = "Debug" })

StatusTab:Toggle({
    Title = "Debug Mode",
    Desc  = "Print semua event ke console",
    Value = false,
    Callback = function(state)
        if state then
            -- Hook semua remote buat debug
            if Remotes then
                for _, remote in ipairs(Remotes:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        pcall(function()
                            remote.OnClientEvent:Connect(function(...)
                                local args = {...}
                                local strs = {}
                                for _, v in ipairs(args) do
                                    table.insert(strs, tostring(v))
                                end
                                print(string.format("[DEBUG] %s fired: %s", remote.Name, table.concat(strs, ", ")))
                            end)
                        end)
                    end
                end
            end
            WindUI:Notify({ Title = "Debug", Content = "Debug mode aktif. Cek console (F9).", Icon = "terminal", Duration = 3 })
        end
    end
})

-- ============================================================
-- PERIODIC ESP UPDATE
-- ============================================================

RunService.Heartbeat:Connect(function()
    -- Update ESP setiap 2 detik kalau aktif
end)

local espTimer = 0
RunService.Stepped:Connect(function(_, dt)
    espTimer = espTimer + dt
    if espTimer >= 2 then
        espTimer = 0
        if State.ESPEnabled then
            task.spawn(updateESP)
        end
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================

print("[WordChain] ✅ Script loaded!")
print(string.format("[WordChain] 📚 %d kata siap digunakan", #WordList))

WindUI:Notify({
    Title   = "Word Chain Script",
    Content = string.format("Loaded! %d kata di kamus.\nAktifkan Auto Answer untuk mulai.", #WordList),
    Icon    = "type",
    Duration = 5
})
