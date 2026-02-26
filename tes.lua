--[[
    Word Chain Auto Script v2.0
    Game: Sambung Kata
    
    Remote yang dipakai:
    - UpdateCurrentWord  → dapat kata aktif sekarang
    - SubmitWord         → kirim jawaban
    - PlayerCorrect      → konfirmasi benar
    - PlayerHit          → kena hit (salah/timeout)
    - UsedWordWarn       → kata sudah dipakai
    - WordUpdate         → update state kata
]]

-- ============================================================
-- SERVICES
-- ============================================================

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- LOAD WINDUI
-- ============================================================

local WindUI
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
        ))()
    end)
    if ok and result then
        WindUI = result
    else
        error("[WordChain] Gagal load WindUI: " .. tostring(result))
    end
end

-- ============================================================
-- REMOTES
-- ============================================================

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)

local R_SubmitWord        = Remotes:WaitForChild("SubmitWord",        10)
local R_UpdateCurrentWord = Remotes:WaitForChild("UpdateCurrentWord", 10)
local R_PlayerCorrect     = Remotes:WaitForChild("PlayerCorrect",     10)
local R_PlayerHit         = Remotes:WaitForChild("PlayerHit",         10)
local R_UsedWordWarn      = Remotes:WaitForChild("UsedWordWarn",      10)
local R_WordUpdate        = Remotes:WaitForChild("WordUpdate",        10)

-- ============================================================
-- LOAD WORD LIST
-- ============================================================

local WordList      = {}   -- { "apel", "api", ... }
local WordSet       = {}   -- WordSet["apel"] = true  (fast lookup)
local ByLetter      = {}   -- ByLetter["a"] = {"apel","api",...}

local function addWord(raw)
    local w = tostring(raw):lower()
                           :gsub("%s+", "")
                           :gsub("[^a-z]", "")
    if #w < 2 then return end
    if WordSet[w] then return end

    WordSet[w] = true
    table.insert(WordList, w)

    local fl = w:sub(1, 1)
    if not ByLetter[fl] then ByLetter[fl] = {} end
    table.insert(ByLetter[fl], w)
end

local function loadWords()
    -- Cari IndonesianWords di ReplicatedStorage > WordList
    local folder      = ReplicatedStorage:FindFirstChild("WordList")
    local indoWords   = folder and folder:FindFirstChild("IndonesianWords")

    if not indoWords then
        warn("[WordChain] IndonesianWords tidak ketemu!")
        warn("[WordChain] Path: ReplicatedStorage > WordList > IndonesianWords")
        return
    end

    -- ── Tipe 1: ModuleScript yang return table of strings ──
    if indoWords:IsA("ModuleScript") then
        local ok, res = pcall(require, indoWords)
        if ok and type(res) == "table" then
            for _, w in ipairs(res) do addWord(w) end
            goto done
        end
    end

    -- ── Tipe 2: Folder berisi ModuleScript/StringValue ──
    for _, child in ipairs(indoWords:GetChildren()) do
        if child:IsA("ModuleScript") then
            local ok, res = pcall(require, child)
            if ok and type(res) == "table" then
                for _, w in ipairs(res) do addWord(w) end
            end
        elseif child:IsA("StringValue") then
            -- value bisa satu kata atau dipisah newline/koma
            for w in child.Value:gmatch("[^\n,;%s]+") do addWord(w) end
        end
    end

    -- ── Tipe 3: IndonesianWords sendiri StringValue ──
    if indoWords:IsA("StringValue") then
        for w in indoWords.Value:gmatch("[^\n,;%s]+") do addWord(w) end
    end

    ::done::
    print(string.format("[WordChain] ✅ WordList loaded: %d kata", #WordList))
end

loadWords()

-- ============================================================
-- WORD LOGIC
-- ============================================================

-- Cari kata terbaik berdasarkan huruf awal
-- Strategi: pilih kata yang huruf terakhirnya punya sedikit opsi
-- (menyulitkan lawan), tie-break dengan kata terpanjang
local function findBestWord(firstLetter)
    firstLetter = firstLetter:lower()
    local pool = ByLetter[firstLetter]
    if not pool or #pool == 0 then return nil end

    -- filter yang belum dipakai
    local available = {}
    for _, w in ipairs(pool) do
        if not State.UsedWords[w] then  -- State didefinisikan di bawah, closure
            table.insert(available, w)
        end
    end
    if #available == 0 then return nil end

    table.sort(available, function(a, b)
        local cA = ByLetter[a:sub(-1)] and #ByLetter[a:sub(-1)] or 0
        local cB = ByLetter[b:sub(-1)] and #ByLetter[b:sub(-1)] or 0
        if cA ~= cB then return cA < cB end  -- huruf terakhir yang rare
        return #a > #b                        -- kalau sama, pilih kata terpanjang
    end)

    return available[1]
end

-- Auto correct: Levenshtein distance
local function levenshtein(s, t)
    local m, n = #s, #t
    if m == 0 then return n end
    if n == 0 then return m end
    local d = {}
    for i = 0, m do d[i] = {[0] = i} end
    for j = 0, n do d[0][j] = j end
    for i = 1, m do
        for j = 1, n do
            local cost = s:sub(i,i) == t:sub(j,j) and 0 or 1
            d[i][j] = math.min(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost)
        end
    end
    return d[m][n]
end

local function findClosestWord(input, firstLetter)
    input = input:lower():gsub("[^a-z]", "")
    if #input == 0 then return nil end
    firstLetter = (firstLetter or input:sub(1,1)):lower()

    local pool = ByLetter[firstLetter] or {}
    local best, bestDist = nil, math.huge

    for _, w in ipairs(pool) do
        if not State.UsedWords[w] then
            local d = levenshtein(input, w)
            if d < bestDist and d <= 2 and math.abs(#input - #w) <= 2 then
                bestDist = d
                best     = w
            end
        end
    end
    return best
end

-- ============================================================
-- STATE
-- ============================================================

-- NOTE: State harus di atas findBestWord yg pakai closure,
-- tapi findBestWord di atas hanya dipanggil runtime jadi aman.
State = {
    CurrentWord  = "",   -- kata yang sedang aktif
    LastLetter   = "",   -- huruf terakhir (= huruf awal jawaban kita)
    UsedWords    = {},   -- set kata yang sudah dipakai
    MyTurn       = false,
    AutoAnswer   = false,
    AutoCorrect  = false,
    ESPEnabled   = false,
    AnswerDelay  = 0.8,  -- detik sebelum auto answer
    CorrectCount = 0,
    WrongCount   = 0,
    DebugMode    = false,
}

-- ============================================================
-- SUBMIT
-- ============================================================

local function submitWord(word)
    word = word:lower():gsub("[^a-z]", "")
    if #word < 2 then return false end
    if not R_SubmitWord then warn("[WordChain] R_SubmitWord nil!"); return false end

    State.UsedWords[word] = true

    local ok, err = pcall(function()
        R_SubmitWord:FireServer(word)
    end)

    if ok then
        print("[WordChain] 📤 Submit: '" .. word .. "'")
    else
        warn("[WordChain] Submit error: " .. tostring(err))
    end
    return ok
end

-- ============================================================
-- AUTO ANSWER
-- ============================================================

local answerBusy = false

local function doAutoAnswer()
    if answerBusy then return end
    if not State.AutoAnswer then return end
    if not State.MyTurn then return end
    if State.LastLetter == "" then return end

    answerBusy = true
    task.spawn(function()
        task.wait(State.AnswerDelay)

        -- Cek ulang kondisi
        if State.AutoAnswer and State.MyTurn then
            local word = findBestWord(State.LastLetter)
            if word then
                submitWord(word)
                State.CorrectCount += 1
            else
                warn("[WordChain] Tidak ada kata untuk huruf: '" .. State.LastLetter .. "'")
                WindUI:Notify({
                    Title   = "Auto Answer",
                    Content = "Tidak ada kata untuk huruf '"
                              .. State.LastLetter:upper() .. "'!",
                    Icon    = "alert-circle",
                    Duration = 4,
                })
            end
        end

        task.wait(0.5)
        answerBusy = false
    end)
end

-- ============================================================
-- AUTO CORRECT (hook TextBox)
-- ============================================================

local hookedBoxes = {}

local function hookTextBoxes()
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not State.AutoCorrect then continue end

            local gui = LocalPlayer:FindFirstChild("PlayerGui")
            if not gui then continue end

            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("TextBox") and not hookedBoxes[obj] then
                    hookedBoxes[obj] = true

                    obj.FocusLost:Connect(function(enterPressed)
                        if not State.AutoCorrect or not enterPressed then return end

                        local input = obj.Text:lower():gsub("[^a-z]", "")
                        if #input < 2 then return end

                        -- Cek valid
                        if WordSet[input]
                           and not State.UsedWords[input]
                           and (State.LastLetter == "" or input:sub(1,1) == State.LastLetter)
                        then
                            return -- valid, biarkan
                        end

                        -- Cari koreksi
                        local fix = findClosestWord(input, State.LastLetter ~= "" and State.LastLetter or input:sub(1,1))
                        if fix then
                            print("[AutoCorrect] '" .. input .. "' → '" .. fix .. "'")
                            obj.Text = fix
                            task.wait(0.05)
                            submitWord(fix)
                            WindUI:Notify({
                                Title   = "Auto Correct",
                                Content = "'" .. input .. "' → '" .. fix .. "'",
                                Icon    = "spell-check",
                                Duration = 3,
                            })
                        else
                            -- Fallback: cari kata valid
                            if State.LastLetter ~= "" then
                                local fallback = findBestWord(State.LastLetter)
                                if fallback then
                                    obj.Text = fallback
                                    task.wait(0.05)
                                    submitWord(fallback)
                                end
                            end
                        end
                    end)
                end
            end

            -- Cleanup
            for box in pairs(hookedBoxes) do
                if not box.Parent then hookedBoxes[box] = nil end
            end
        end
    end)
end

-- ============================================================
-- ESP
-- ============================================================

local espBackup = {}

local function clearESP()
    for _, e in ipairs(espBackup) do
        pcall(function()
            if e.obj and e.obj.Parent then
                e.obj.TextColor3             = e.color
                e.obj.TextStrokeTransparency = e.trans
                e.obj.TextStrokeColor3       = e.stroke
            end
        end)
    end
    espBackup = {}
end

local function refreshESP()
    clearESP()
    if not State.ESPEnabled or State.LastLetter == "" then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            for _, lbl in ipairs(obj:GetDescendants()) do
                if lbl:IsA("TextLabel") or lbl:IsA("TextButton") then
                    local txt = lbl.Text:lower():gsub("[^a-z]", "")
                    if #txt >= 2
                       and WordSet[txt]
                       and not State.UsedWords[txt]
                       and txt:sub(1,1) == State.LastLetter
                    then
                        table.insert(espBackup, {
                            obj    = lbl,
                            color  = lbl.TextColor3,
                            trans  = lbl.TextStrokeTransparency,
                            stroke = lbl.TextStrokeColor3,
                        })
                        lbl.TextColor3             = Color3.fromRGB(80, 255, 120)
                        lbl.TextStrokeTransparency = 0
                        lbl.TextStrokeColor3       = Color3.fromRGB(0, 80, 30)
                    end
                end
            end
        end
    end
end

-- ============================================================
-- REMOTE LISTENERS
-- ============================================================

-- Helper: parse kata dari berbagai format argument
local function parseWord(arg)
    if type(arg) == "string" then
        return arg:lower():gsub("[^a-z]", "")
    elseif type(arg) == "table" then
        local w = arg.word or arg.currentWord or arg.Word or ""
        return tostring(w):lower():gsub("[^a-z]", "")
    end
    return ""
end

local function onNewWord(word)
    if #word < 1 then return end
    State.CurrentWord       = word
    State.LastLetter        = word:sub(-1)
    State.UsedWords[word]   = true

    if State.DebugMode then
        print(string.format("[WordChain] Kata: '%s'  →  huruf awal jawaban: '%s'",
            word, State.LastLetter:upper()))
    end

    if State.ESPEnabled then task.spawn(refreshESP) end
    if State.MyTurn      then doAutoAnswer() end
end

-- UpdateCurrentWord  ← kata aktif berubah
R_UpdateCurrentWord.OnClientEvent:Connect(function(...)
    local args = {...}
    if State.DebugMode then
        local parts = {}
        for _, v in ipairs(args) do table.insert(parts, tostring(v)) end
        print("[DEBUG] UpdateCurrentWord → " .. table.concat(parts, " | "))
    end
    local w = parseWord(args[1])
    if #w > 0 then onNewWord(w) end
end)

-- WordUpdate ← bisa juga bawa current word + trigger giliran
R_WordUpdate.OnClientEvent:Connect(function(...)
    local args = {...}
    if State.DebugMode then
        local parts = {}
        for _, v in ipairs(args) do table.insert(parts, tostring(v)) end
        print("[DEBUG] WordUpdate → " .. table.concat(parts, " | "))
    end
    local w = parseWord(args[1])
    if #w > 0 then onNewWord(w) end

    -- WordUpdate sering juga jadi sinyal giliran kita
    if State.MyTurn then doAutoAnswer() end
end)

-- PlayerCorrect ← jawaban benar (kita atau orang lain)
R_PlayerCorrect.OnClientEvent:Connect(function(...)
    local args = {...}
    if State.DebugMode then
        local parts = {}
        for _, v in ipairs(args) do table.insert(parts, tostring(v)) end
        print("[DEBUG] PlayerCorrect → " .. table.concat(parts, " | "))
    end

    -- arg[1] biasanya player, arg[2] kata yang diterima
    local player = args[1]
    local word   = parseWord(args[2] or args[1])

    if #word > 0 then
        State.UsedWords[word] = true
        State.CurrentWord     = word
        State.LastLetter      = word:sub(-1)
        if State.ESPEnabled then task.spawn(refreshESP) end
    end

    -- Kalau kita yang baru jawab benar → bukan giliran kita lagi
    local isMe = (player == LocalPlayer) or (player == LocalPlayer.Name)
    if isMe then State.MyTurn = false end
end)

-- PlayerHit ← kena hit / salah
R_PlayerHit.OnClientEvent:Connect(function(...)
    local args   = {...}
    local player = args[1]
    local isMe   = (player == LocalPlayer) or (player == LocalPlayer.Name)
    if isMe then
        State.WrongCount += 1
        if State.DebugMode then print("[DEBUG] PlayerHit → kita kena!") end
    end
end)

-- UsedWordWarn ← kata sudah dipakai
R_UsedWordWarn.OnClientEvent:Connect(function(...)
    local args = {...}
    local w    = parseWord(args[1])
    if #w > 0 then
        State.UsedWords[w] = true
        if State.DebugMode then print("[DEBUG] UsedWordWarn → '" .. w .. "'") end
    end
end)

-- ============================================================
-- START HOOKS
-- ============================================================

hookTextBoxes()

-- Refresh ESP tiap 2 detik
local espTimer = 0
RunService.Stepped:Connect(function(_, dt)
    espTimer += dt
    if espTimer >= 2 then
        espTimer = 0
        if State.ESPEnabled then task.spawn(refreshESP) end
    end
end)

-- ============================================================
-- WINDUI WINDOW
-- ============================================================

local Window = WindUI:CreateWindow({
    Title       = "Word Chain",
    Icon        = "type",
    Folder      = "WordChainScript",
    NewElements = true,
    OpenButton  = {
        Title        = "Word Chain",
        Enabled      = true,
        Draggable    = true,
        OnlyMobile   = false,
        CornerRadius = UDim.new(1, 0),
        Color        = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#00C8FF")
        ),
    },
    Topbar = { Height = 44, ButtonsType = "Mac" },
})

Window:Tag({ Title = "v2.0",           Icon = "tag",       Color = Color3.fromHex("#1c1c1c"), Border = true })
Window:Tag({ Title = #WordList.." kata", Icon = "book-open", Color = Color3.fromHex("#1c1c1c"), Border = true })

-- ============================================================
-- TAB: MAIN
-- ============================================================

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })

MainTab:Section({ Title = "Auto Features" })

MainTab:Toggle({
    Title    = "Auto Answer",
    Desc     = "Otomatis jawab saat giliran kamu",
    Icon     = "bot",
    Value    = false,
    Callback = function(v)
        State.AutoAnswer = v
        WindUI:Notify({
            Title   = "Auto Answer",
            Content = v and "Aktif! Jawab otomatis saat giliran kamu."
                        or "Dinonaktifkan.",
            Icon    = "bot", Duration = 2,
        })
        if v and State.MyTurn and State.LastLetter ~= "" then
            doAutoAnswer()
        end
    end,
})

MainTab:Space()

MainTab:Toggle({
    Title    = "Auto Correct",
    Desc     = "Fix typo sebelum kata dikirim",
    Icon     = "spell-check",
    Value    = false,
    Callback = function(v)
        State.AutoCorrect = v
        WindUI:Notify({
            Title   = "Auto Correct",
            Content = v and "Aktif! Typo otomatis dikoreksi." or "Dinonaktifkan.",
            Icon    = "spell-check", Duration = 2,
        })
    end,
})

MainTab:Space()

MainTab:Toggle({
    Title    = "ESP Valid Words",
    Desc     = "Highlight kata valid di billboard/UI game",
    Icon     = "eye",
    Value    = false,
    Callback = function(v)
        State.ESPEnabled = v
        if v then task.spawn(refreshESP) else clearESP() end
        WindUI:Notify({
            Title   = "ESP",
            Content = v and "Aktif! Kata valid = hijau." or "Dinonaktifkan.",
            Icon    = "eye", Duration = 2,
        })
    end,
})

MainTab:Space()
MainTab:Section({ Title = "Settings" })

MainTab:Slider({
    Title = "Answer Delay",
    Desc  = "Jeda sebelum auto jawab (x0.1 detik)",
    Step  = 1,
    Value = { Min = 1, Max = 30, Default = 8 },
    Callback = function(v) State.AnswerDelay = v / 10 end,
})

MainTab:Space()
MainTab:Section({ Title = "Manual" })

MainTab:Toggle({
    Title    = "Force My Turn",
    Desc     = "Paksa anggap giliran kita (jika deteksi gagal)",
    Icon     = "user-check",
    Value    = false,
    Callback = function(v)
        State.MyTurn = v
        if v and State.AutoAnswer and State.LastLetter ~= "" then
            doAutoAnswer()
        end
    end,
})

MainTab:Space()

MainTab:Button({
    Title    = "Jawab Sekarang",
    Desc     = "Paksa cari & submit kata terbaik",
    Icon     = "send",
    Justify  = "Center",
    Callback = function()
        if State.LastLetter == "" then
            WindUI:Notify({ Title = "Error", Content = "Belum ada kata aktif!", Icon = "alert-circle", Duration = 3 })
            return
        end
        local word = findBestWord(State.LastLetter)
        if word then
            submitWord(word)
            WindUI:Notify({ Title = "Submitted!", Content = "→ '" .. word .. "'", Icon = "check", Duration = 3 })
        else
            WindUI:Notify({
                Title   = "Gagal",
                Content = "Tidak ada kata untuk huruf '" .. State.LastLetter:upper() .. "'",
                Icon    = "x-circle", Duration = 4,
            })
        end
    end,
})

-- ============================================================
-- TAB: WORD TOOLS
-- ============================================================

local WordTab = Window:Tab({ Title = "Word Tools", Icon = "book-open" })

WordTab:Section({ Title = "Cari Kata dari Huruf" })

local searchInput = WordTab:Input({
    Title       = "Huruf Awal",
    Desc        = "Masukkan huruf, akan dicari kata terbaik",
    Icon        = "search",
    Placeholder = "Contoh: a",
    Callback    = function() end,
})

WordTab:Space()

WordTab:Button({
    Title    = "Cari & Copy",
    Icon     = "search",
    Justify  = "Center",
    Callback = function()
        local raw    = searchInput and searchInput:Get() or ""
        local letter = raw:lower():gsub("[^a-z]",""):sub(1,1)
        if letter == "" then
            WindUI:Notify({ Title = "Error", Content = "Masukkan huruf dulu!", Duration = 2 })
            return
        end
        local word = findBestWord(letter)
        if word then
            pcall(function() setclipboard(word) end)
            WindUI:Notify({
                Title   = "Kata untuk '" .. letter:upper() .. "'",
                Content = "→ " .. word .. "\n(huruf terakhir: '" .. word:sub(-1):upper() .. "')\nSudah dicopy!",
                Icon    = "check", Duration = 5,
            })
        else
            WindUI:Notify({
                Title   = "Tidak ada",
                Content = "Tidak ada kata tersedia untuk huruf '" .. letter:upper() .. "'",
                Duration = 3,
            })
        end
    end,
})

WordTab:Space()
WordTab:Section({ Title = "Cek Kata" })

local checkInput = WordTab:Input({
    Title       = "Kata",
    Desc        = "Cek apakah kata ini ada di kamus",
    Icon        = "spell-check",
    Placeholder = "Contoh: apel",
    Callback    = function() end,
})

WordTab:Space()

WordTab:Button({
    Title    = "Cek",
    Icon     = "check-square",
    Justify  = "Center",
    Callback = function()
        local word = (checkInput and checkInput:Get() or ""):lower():gsub("[^a-z]","")
        if #word < 2 then
            WindUI:Notify({ Title = "Error", Content = "Masukkan kata dulu!", Duration = 2 })
            return
        end
        if WordSet[word] then
            local last      = word:sub(-1)
            local nextCount = ByLetter[last] and #ByLetter[last] or 0
            WindUI:Notify({
                Title   = "✅ Ada di kamus!",
                Content = "'" .. word .. "'\nHuruf terakhir '"..last:upper().."' → "..nextCount.." kata buat lawan",
                Icon    = "check-circle", Duration = 5,
            })
        else
            local closest = findClosestWord(word, word:sub(1,1))
            WindUI:Notify({
                Title   = "❌ Tidak ada di kamus",
                Content = "'" .. word .. "'" .. (closest and ("\nMaksud: '" .. closest .. "'?") or ""),
                Icon    = "x-circle", Duration = 5,
            })
        end
    end,
})

-- ============================================================
-- TAB: STATUS & DEBUG
-- ============================================================

local StatusTab = Window:Tab({ Title = "Status", Icon = "activity" })

StatusTab:Section({ Title = "Info" })

StatusTab:Button({
    Title    = "Lihat Status",
    Icon     = "info",
    Justify  = "Center",
    Callback = function()
        local usedCount = 0
        for _ in pairs(State.UsedWords) do usedCount += 1 end
        local avail = State.LastLetter ~= ""
            and (ByLetter[State.LastLetter] and #ByLetter[State.LastLetter] or 0)
            or 0

        WindUI:Notify({
            Title   = "Status",
            Content = string.format(
                "Kata aktif : '%s'\n"..
                "Huruf next : '%s'\n"..
                "Tersedia   : %d kata\n"..
                "Dipakai    : %d kata\n"..
                "Giliran    : %s\n"..
                "✅ Benar: %d  ❌ Salah: %d",
                State.CurrentWord,
                State.LastLetter:upper(),
                avail,
                usedCount,
                State.MyTurn and "KITA 🎯" or "lawan",
                State.CorrectCount,
                State.WrongCount
            ),
            Icon = "info", Duration = 8,
        })
    end,
})

StatusTab:Space()

StatusTab:Button({
    Title    = "Reset Used Words",
    Desc     = "Kosongkan list kata terpakai (tiap ronde baru)",
    Icon     = "trash-2",
    Callback = function()
        State.UsedWords = {}
        WindUI:Notify({ Title = "Reset", Content = "List dikosongkan.", Icon = "check", Duration = 2 })
    end,
})

StatusTab:Space()
StatusTab:Section({ Title = "Debug" })

StatusTab:Toggle({
    Title    = "Debug Mode",
    Desc     = "Print semua event ke console (F9)",
    Value    = false,
    Callback = function(v)
        State.DebugMode = v
        WindUI:Notify({
            Title   = "Debug",
            Content = v and "ON — buka console F9" or "OFF",
            Icon    = "terminal", Duration = 2,
        })
    end,
})

StatusTab:Space()

StatusTab:Button({
    Title    = "WordList Info (F9)",
    Icon     = "terminal",
    Callback = function()
        print("\n=== WORDLIST INFO ===")
        print("Total: " .. #WordList .. " kata")
        for _, l in ipairs({"a","b","c","d","e","f","g","h","i","j","k","l","m",
                             "n","o","p","q","r","s","t","u","v","w","x","y","z"}) do
            local n = ByLetter[l] and #ByLetter[l] or 0
            if n > 0 then
                print(string.format("  %s : %d kata", l:upper(), n))
            end
        end
        print("====================\n")
        WindUI:Notify({ Title = "Done", Content = "Cek console F9", Icon = "terminal", Duration = 3 })
    end,
})

-- ============================================================
-- DONE
-- ============================================================

print(string.format("[WordChain] ✅ Script v2.0 loaded! %d kata siap.", #WordList))

WindUI:Notify({
    Title   = "Word Chain Script v2.0",
    Content = #WordList .. " kata loaded!\nAktifkan Auto Answer & Force My Turn untuk mulai.",
    Icon    = "type",
    Duration = 5,
})
