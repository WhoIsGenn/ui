local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local LocalPlayer       = Players.LocalPlayer

-- WINDUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- REMOTES
local Remotes         = ReplicatedStorage:WaitForChild("Remotes", 15)
local R_SubmitWord    = Remotes:WaitForChild("SubmitWord", 10)
local R_TypeSound     = Remotes:FindFirstChild("TypeSound")
local R_UsedWordWarn  = Remotes:FindFirstChild("UsedWordWarn")
local R_PlayerCorrect = Remotes:FindFirstChild("PlayerCorrect")

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- KBBI
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local WordSet    = {}
local ByLetter   = {}
local kbbiLoaded = false
local kbbiStatus = "Loading..."
local totalWords = 0

local function addWord(w)
    w = w:lower():gsub("[^a-z]","")
    if #w < 2 or WordSet[w] then return end
    WordSet[w] = true
    local fl = w:sub(1,1)
    if not ByLetter[fl] then ByLetter[fl] = {} end
    table.insert(ByLetter[fl], w)
end

local function getRarityText()
    local data = {}
    for i = string.byte("a"), string.byte("z") do
        local ch = string.char(i)
        table.insert(data, {l=ch, n=ByLetter[ch] and #ByLetter[ch] or 0})
    end
    table.sort(data, function(a,b) return a.n < b.n end)
    local lines = {}
    for _, d in ipairs(data) do
        if d.n > 0 then table.insert(lines, d.l:upper()..": "..d.n) end
    end
    return table.concat(lines, "  ")
end

local ParaDB, ParaStatus, ParaRarity  -- forward

-- HARD WORDS: kata susah dari list (berakhiran -ia, -if, -iat, -tif, -ks, dll)
local HardWords = {}
task.spawn(function()
    local ok, data = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/VictoriaHub/refs/heads/main/Loader/susah2.txt")
    end)
    if ok and data and #data > 100 then
        for line in data:gmatch("[^
]+") do
            local w = line:gsub("%s+",""):lower():gsub("[^a-z]","")
            if #w >= 2 then HardWords[w] = true end
        end
    end
end)

-- Mode filter SK Manual: "semua"/"mudah"/"normal"/"hard"
local S_ManualMode = "semua"

task.spawn(function()
    local ok, data = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/VictoriaHub/refs/heads/main/Loader/kbbi.txt")
    end)
    if ok and data and #data > 1000 then
        for line in data:gmatch("[^\n\r]+") do
            addWord(line:gsub("%s+",""):lower():gsub("[^a-z]",""))
        end
        for _,ws in pairs(ByLetter) do totalWords=totalWords+#ws end
        kbbiLoaded=true; kbbiStatus="✅ "..totalWords.." Words"
        if ParaDB then pcall(function()
            ParaDB:SetDesc("Source: GitHub (VictoriaHub)\nTotal: "..totalWords.." Words\nStatus: "..kbbiStatus)
        end) end
        if ParaRarity then pcall(function() ParaRarity:SetDesc(getRarityText()) end) end
        WindUI:Notify({Title="KBBI Ready!",Content=totalWords.." Words siap",Icon="book-open",Duration=4})
    else
        for _,w in ipairs({"ada","adik","air","ajak","ajar","akan","akar","akhir","aku","alam","alat","aman","anak","aneh","angin","api","apel","arah","arus","asah","asal","atap","atas","ayah","baik","baju","baru","batas","batu","bawa","besar","bisa","bola","buah","bunga","buruk","cabai","cahaya","cair","cakap","calon","cantik","capek","cari","cedera","cepat","cerita","cermat","cinta","cocok","cukup","curang","curi","dagang","dalam","damai","dapur","darah","darat","dasar","datang","daun","dekat","dengan","depan","deras","desa","diam","dingin","diri","dosa","duduk","duka","dulu","dunia","duri","dusta","edar","ejek","ekor","emas","enam","enak","erat","esok","fajar","fakta","fisik","gadis","gagah","gagal","galak","gambar","ganas","garang","gelap","gemuk","gembira","gerak","gigi","gigih","gila","girang","goreng","guna","gunung","guru","habis","hadap","hadir","halal","halus","hancur","hangat","hanya","hapus","harap","hari","harum","hasil","hati","hebat","hemat","hidup","hilang","hitam","hormat","hujan","hukum","hutan","ibu","ikut","ilmu","indah","ingin","ingat","istri","jaga","jalan","janda","jantan","jasa","jatuh","jauh","jawab","jelas","jenis","jiwa","jual","juara","jujur","juga","jumlah","kabar","kabur","kacau","kaki","kalah","kami","kanan","karya","kasih","kata","kaya","keras","kiri","kita","kuat","kurang","kurus","kursi","kunci","kulit","lagi","lain","lama","langit","lapor","lapar","lepas","lewat","liar","licin","lihat","lurus","lupa","lucu","laut","macam","mahir","main","maju","makna","malas","malam","makan","malu","manis","marah","masuk","mati","mawar","meja","minta","muda","murah","mulus","murni","musuh","naik","nama","nanti","nasib","nilai","nyata","nyaman","obat","olah","otak","orang","pagi","paham","pakai","panas","pandai","pantai","pasti","perlu","pikir","pilih","pintar","pohon","pulang","putih","rasa","rata","rekan","rendah","resmi","ringan","rindu","roboh","rumah","rusak","sabar","sakit","sama","santai","satu","senang","sehat","semua","siap","sikap","sopan","sulit","sunyi","susah","tabah","tahan","tajam","tali","tampil","tanda","tangguh","tanya","tarik","teguh","tekad","tenang","tengah","tepat","teras","terima","terus","tinggi","tidak","tujuan","turun","tugas","tulus","tutup","ubah","ujian","usaha","utama","wajah","waktu","warga","warna","wisata","yakin","zaman"}) do addWord(w) end
        for _,ws in pairs(ByLetter) do totalWords=totalWords+#ws end
        kbbiLoaded=true; kbbiStatus="⚠️ "..totalWords.." Words (fallback)"
        if ParaRarity then pcall(function() ParaRarity:SetDesc(getRarityText()) end) end
    end
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- STATE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local S = {
    AutoAnswer  = false,
    ShowMonitor = false,
    ShowManual  = false,
    Delay       = 1.5,
    Speed       = 0.30,
    UsedWords   = {},
    CurrentWord = "-",
    LastSubmit  = "",
    Prefix      = "-",
    Suggestion  = "-",
    Terpakai    = 0,
    Benar       = 0,
    Salah       = 0,
    Busy        = false,
    Debug       = false,
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- MATCHUI HELPERS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function getMatchUI()
    local g = LocalPlayer:FindFirstChild("PlayerGui")
    return g and g:FindFirstChild("MatchUI")
end
local function getBottomUI() local m=getMatchUI(); return m and m:FindFirstChild("BottomUI") end
local function getKeyboard() local b=getBottomUI(); return b and b:FindFirstChild("Keyboard") end
local function getTopUI() local b=getBottomUI(); return b and b:FindFirstChild("TopUI") end
local function getWordSubmit() local t=getTopUI(); return t and t:FindFirstChild("WordSubmit") end
local function getWordServerFrame() local t=getTopUI(); return t and t:FindFirstChild("WordServerFrame") end
local function getWordServerText()
    local wsf=getWordServerFrame(); if not wsf then return "" end
    local ws=wsf:FindFirstChild("WordServer"); if not ws then return "" end
    return (ws.Text or ""):gsub("%s+",""):lower():gsub("[^a-z]","")
end
local function isMyTurn()
    local kb=getKeyboard(); return kb~=nil and kb.Visible==true
end

local function getWordSlots()
    local ws=getWordSubmit(); if not ws then return {} end
    local slots={}
    for _,child in ipairs(ws:GetChildren()) do
        if child:IsA("TextLabel") then
            local ok,pos=pcall(function() return child.AbsolutePosition end)
            table.insert(slots,{obj=child,x=ok and pos.X or 0})
        end
    end
    table.sort(slots,function(a,b) return a.x<b.x end)
    return slots
end
local function getWordSubmitText()
    local chars={}
    for _,s in ipairs(getWordSlots()) do
        local t=s.obj.Text or ""
        if #t==1 and t:match("^%a$") then table.insert(chars,t:lower()) end
    end
    return table.concat(chars)
end
local function clearWordSubmit()
    for _,s in ipairs(getWordSlots()) do pcall(function() s.obj.Text="" end) end
    if S.Debug then print("[SK] cleared") end
    task.wait(0.05)
end

local function getKeys()
    local kb=getKeyboard(); if not kb then return {},nil end
    local keys,enter={},nil
    for _,row in ipairs(kb:GetChildren()) do
        if row:IsA("Frame") then
            for _,btn in ipairs(row:GetChildren()) do
                if btn:IsA("TextButton") then
                    local t=btn.Text:gsub("%s+","")
                    if #t==1 and t:match("^[A-Za-z]$") then keys[t:lower()]=btn end
                    if t:lower()=="enter" then enter=btn end
                end
            end
        end
    end
    return keys,enter
end
local function fireBtn(btn)
    if not btn or not btn.Parent then return false end
    pcall(function() for _,c in ipairs(getconnections(btn.Activated)) do c:Fire() end end)
    return true
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- WORD LOGIC
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function findBest(prefix, skipWord)
    prefix=prefix:lower():gsub("[^a-z]","")
    if #prefix==0 then return nil end
    local pool=ByLetter[prefix:sub(1,1)]; if not pool then return nil end
    local avail={}
    if #prefix==1 then
        for _,w in ipairs(pool) do
            if not S.UsedWords[w] and w~=skipWord then table.insert(avail,w) end
        end
    else
        for _,w in ipairs(pool) do
            if not S.UsedWords[w] and w~=skipWord and w:sub(1,#prefix)==prefix then table.insert(avail,w) end
        end
        if #avail==0 then
            for _,w in ipairs(pool) do
                if not S.UsedWords[w] and w~=skipWord then table.insert(avail,w) end
            end
        end
    end
    if #avail==0 then return nil end
    table.sort(avail,function(a,b)
        local ca=ByLetter[a:sub(-1)] and #ByLetter[a:sub(-1)] or 0
        local cb=ByLetter[b:sub(-1)] and #ByLetter[b:sub(-1)] or 0
        if ca~=cb then return ca<cb end
        return #a>#b
    end)
    return avail[1]
end

-- Ambil sorted word list untuk SK Manual panel
local function getWordList(prefix, maxN)
    prefix=prefix:lower():gsub("[^a-z]","")
    maxN=maxN or 50
    if #prefix==0 then return {} end
    local pool=ByLetter[prefix:sub(1,1)]; if not pool then return {} end
    local avail={}
    if #prefix==1 then
        for _,w in ipairs(pool) do
            if not S.UsedWords[w] then table.insert(avail,w) end
        end
    else
        for _,w in ipairs(pool) do
            if not S.UsedWords[w] and w:sub(1,#prefix)==prefix then table.insert(avail,w) end
        end
        if #avail==0 then
            for _,w in ipairs(pool) do
                if not S.UsedWords[w] then table.insert(avail,w) end
            end
        end
    end
    -- Filter by mode, lalu sort/interleave HARD:NORMAL:MUDAH
    local hard,normal,mudah={},{},{}
    for _,w in ipairs(avail) do
        local d=getDiff(w)
        if S_ManualMode=="hard"   and d~="HARD"   then
        elseif S_ManualMode=="normal" and d~="NORMAL" then
        elseif S_ManualMode=="mudah"  and d~="MUDAH"  then
        else
            if d=="HARD" then table.insert(hard,w)
            elseif d=="NORMAL" then table.insert(normal,w)
            else table.insert(mudah,w) end
        end
    end
    local function slen(t) table.sort(t,function(a,b) return #a>#b end) end
    slen(hard) slen(normal) slen(mudah)
    local res={}
    local hi,ni,mi=1,1,1
    while #res<maxN do
        local added=false
        if hi<=#hard   then table.insert(res,hard[hi]);   hi=hi+1   added=true end
        if #res>=maxN then break end
        if ni<=#normal then table.insert(res,normal[ni]); ni=ni+1   added=true end
        if #res>=maxN then break end
        if ni<=#normal then table.insert(res,normal[ni]); ni=ni+1   added=true end
        if #res>=maxN then break end
        if mi<=#mudah  then table.insert(res,mudah[mi]);  mi=mi+1   added=true end
        if #res>=maxN then break end
        if mi<=#mudah  then table.insert(res,mudah[mi]);  mi=mi+1   added=true end
        if #res>=maxN then break end
        if mi<=#mudah  then table.insert(res,mudah[mi]);  mi=mi+1   added=true end
        if not added then break end
    end
    return res
end

-- Difficulty: HardWords list + huruf akhir susah
-- HARD  = ada di HardWords ATAU huruf akhir f/x/q/z/v
-- NORMAL= huruf akhir b/d/g/p/c/j/y/h/w
-- MUDAH = sisanya (a/i/u/e/o/n/r/l/t/s/k/m)
local _eH={f=1,x=1,q=1,z=1,v=1}
local _eN={b=1,d=1,g=1,p=1,c=1,j=1,y=1,h=1,w=1}
local function getDiff(word)
    local l=word:sub(-1):lower()
    if HardWords[word] or _eH[l] then
        return "HARD",  Color3.fromRGB(160,20,20),  Color3.fromRGB(255,90,90)
    end
    if _eN[l] then
        return "NORMAL",Color3.fromRGB(140,90,0),   Color3.fromRGB(255,190,50)
    end
    return "MUDAH", Color3.fromRGB(20,100,40),  Color3.fromRGB(60,215,100)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- TYPE AND SUBMIT
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function typeAndSubmit(word, prefix)
    local keys,enter=getKeys()
    task.wait(0.15)
    local existing=getWordSubmitText()
    if S.Debug then print("[SK] Typing '"..word.."' existing='"..existing.."'") end
    local si=1
    if #existing>0 then
        if word:sub(1,#existing)==existing then
            si=#existing+1
        else
            clearWordSubmit(); task.wait(0.3)
            local ri=getWordSubmitText()
            si=(#ri>0 and word:sub(1,#ri)==ri) and #ri+1 or 1
        end
    end
    for i=si,#word do
        if not isMyTurn() then return false end
        local ch=word:sub(i,i):lower()
        local btn=keys[ch]
        if btn then fireBtn(btn) end
        if S.Debug then print("[SK] '"..ch.."' ("..i.."/"..#word..")") end
        if R_TypeSound then pcall(function() R_TypeSound:FireServer() end) end
        task.wait(S.Speed+math.random()*0.05)
    end
    if S.Debug then task.wait(0.05) print("[SK] final='"..getWordSubmitText().."'") end
    task.wait(0.1)
    if enter then fireBtn(enter) end
    task.wait(0.05)
    pcall(function() R_SubmitWord:FireServer(word) end)
    return true
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- DO ANSWER
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function doAnswer(skipWord)
    if S.Busy or not S.AutoAnswer or not isMyTurn() then return end
    S.Busy=true
    task.spawn(function()
        task.wait(S.Delay)
        if not isMyTurn() or not S.AutoAnswer then S.Busy=false return end
        local wt=0
        while not kbbiLoaded and wt<5 do task.wait(0.3) wt=wt+0.3 end
        local prefix=S.Prefix
        if prefix=="" or prefix=="-" then
            prefix=getWordServerText()
            if prefix~="" then S.Prefix=prefix end
        end
        if prefix=="" or prefix=="-" then S.Busy=false return end
        local word=findBest(prefix,skipWord)
        if not word then
            WindUI:Notify({Title="Prefix '"..prefix:upper().."' Habis!",Content="Tidak ada kata.",Icon="alert-circle",Duration=3})
            S.Busy=false return
        end
        if S.Debug then print("[SK] Jawab: '"..word.."'") end
        local serverBefore=getWordServerText()
        local ok=typeAndSubmit(word,prefix)
        if not ok then S.Busy=false return end
        local el=0; local acc=false
        while el<2.0 do
            task.wait(0.1); el=el+0.1
            if not isMyTurn() then acc=true break end
            local cur=getWordServerText()
            if cur~="" and cur~=serverBefore then acc=true break end
        end
        if acc then
            S.UsedWords[word]=true; S.CurrentWord=word
            S.LastSubmit=word; S.Terpakai=S.Terpakai+1; S.Benar=S.Benar+1
            S.Suggestion=findBest(word:sub(-1),nil) or "-"
            WindUI:Notify({Title="✓ "..word:upper(),Content="→ Next: "..word:sub(-1):upper(),Icon="check",Duration=2})
        else
            S.UsedWords[word]=true; S.Salah=S.Salah+1
            WindUI:Notify({Title="✗ Ditolak: "..word:upper(),Content="Auto ganti kata...",Icon="alert-circle",Duration=2})
            clearWordSubmit(); task.wait(0.5)
            if isMyTurn() and S.AutoAnswer then S.Busy=false; doAnswer(word); return end
        end
        task.wait(0.3); S.Busy=false
    end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- MONITOR GUI  (compact clean minimal)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local MON={}
local function buildMonitor()
    local old=LocalPlayer.PlayerGui:FindFirstChild("VHMonitor")
    if old then old:Destroy() end
    local sg=Instance.new("ScreenGui")
    sg.Name="VHMonitor" sg.ResetOnSpawn=false sg.DisplayOrder=20
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.Parent=LocalPlayer:WaitForChild("PlayerGui")

    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,200,0,222) card.Position=UDim2.new(1,-210,1,-232)
    card.BackgroundColor3=Color3.fromRGB(11,13,22) card.BackgroundTransparency=0
    card.BorderSizePixel=0 card.Active=true card.Draggable=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,12)
    local cst=Instance.new("UIStroke",card)
    cst.Color=Color3.fromRGB(0,180,230) cst.Thickness=1 cst.Transparency=0.55

    local sbar=Instance.new("Frame",card)
    sbar.Size=UDim2.new(1,0,0,4) sbar.BackgroundColor3=Color3.fromRGB(0,160,220) sbar.BorderSizePixel=0
    Instance.new("UICorner",sbar).CornerRadius=UDim.new(0,12)
    local sbfix=Instance.new("Frame",sbar)
    sbfix.Size=UDim2.new(1,0,0.5,0) sbfix.Position=UDim2.new(0,0,0.5,0)
    sbfix.BackgroundColor3=Color3.fromRGB(0,160,220) sbfix.BorderSizePixel=0
    MON.statusBar=sbar MON.sbFix=sbfix

    local hdr=Instance.new("Frame",card)
    hdr.Size=UDim2.new(1,0,0,36) hdr.Position=UDim2.new(0,0,0,4) hdr.BackgroundTransparency=1
    local dot=Instance.new("Frame",hdr)
    dot.Size=UDim2.new(0,7,0,7) dot.Position=UDim2.new(0,13,0.5,-3)
    dot.BackgroundColor3=Color3.fromRGB(0,200,130) dot.BorderSizePixel=0
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0) MON.dot=dot
    local tl=Instance.new("TextLabel",hdr)
    tl.Size=UDim2.new(1,-60,0,16) tl.Position=UDim2.new(0,26,0,5) tl.BackgroundTransparency=1
    tl.Text="Victoria Hub" tl.TextColor3=Color3.fromRGB(235,240,255) tl.TextSize=12
    tl.Font=Enum.Font.GothamBold tl.TextXAlignment=Enum.TextXAlignment.Left
    local sl=Instance.new("TextLabel",hdr)
    sl.Size=UDim2.new(1,-60,0,12) sl.Position=UDim2.new(0,26,0,20) sl.BackgroundTransparency=1
    sl.Text="Sambung Kata" sl.TextColor3=Color3.fromRGB(80,140,200) sl.TextSize=9
    sl.Font=Enum.Font.Gotham sl.TextXAlignment=Enum.TextXAlignment.Left
    local cb=Instance.new("TextButton",hdr)
    cb.Size=UDim2.new(0,20,0,20) cb.Position=UDim2.new(1,-26,0.5,-10)
    cb.BackgroundColor3=Color3.fromRGB(28,30,46) cb.Text="✕"
    cb.TextColor3=Color3.fromRGB(100,120,160) cb.TextSize=10
    cb.Font=Enum.Font.GothamBold cb.BorderSizePixel=0
    Instance.new("UICorner",cb).CornerRadius=UDim.new(0,5)
    cb.MouseButton1Click:Connect(function() sg.Enabled=false S.ShowMonitor=false end)
    cb.MouseEnter:Connect(function() cb.BackgroundColor3=Color3.fromRGB(180,40,40) cb.TextColor3=Color3.fromRGB(255,255,255) end)
    cb.MouseLeave:Connect(function() cb.BackgroundColor3=Color3.fromRGB(28,30,46) cb.TextColor3=Color3.fromRGB(100,120,160) end)
    local div=Instance.new("Frame",card)
    div.Size=UDim2.new(1,-24,0,1) div.Position=UDim2.new(0,12,0,40)
    div.BackgroundColor3=Color3.fromRGB(30,50,80) div.BorderSizePixel=0

    local rf=Instance.new("Frame",card)
    rf.Size=UDim2.new(1,-16,0,168) rf.Position=UDim2.new(0,8,0,48) rf.BackgroundTransparency=1
    local ll=Instance.new("UIListLayout",rf)
    ll.SortOrder=Enum.SortOrder.LayoutOrder ll.Padding=UDim.new(0,3)

    local C={cyan=Color3.fromRGB(0,185,230),blue=Color3.fromRGB(60,120,255),green=Color3.fromRGB(40,210,120),yellow=Color3.fromRGB(255,195,50),purple=Color3.fromRGB(160,100,255)}
    local function makeRow(label,def,accent,order)
        local r=Instance.new("Frame",rf)
        r.Size=UDim2.new(1,0,0,26) r.BackgroundColor3=Color3.fromRGB(16,18,30)
        r.BackgroundTransparency=0.2 r.BorderSizePixel=0 r.LayoutOrder=order
        Instance.new("UICorner",r).CornerRadius=UDim.new(0,6)
        local b=Instance.new("Frame",r) b.Size=UDim2.new(0,2,0.6,0) b.Position=UDim2.new(0,0,0.2,0)
        b.BackgroundColor3=accent b.BorderSizePixel=0 Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
        local kl=Instance.new("TextLabel",r) kl.Size=UDim2.new(0,62,1,0) kl.Position=UDim2.new(0,8,0,0)
        kl.BackgroundTransparency=1 kl.Text=label kl.TextColor3=Color3.fromRGB(90,110,150) kl.TextSize=10
        kl.Font=Enum.Font.Gotham kl.TextXAlignment=Enum.TextXAlignment.Left
        local vl=Instance.new("TextLabel",r) vl.Size=UDim2.new(1,-74,1,0) vl.Position=UDim2.new(0,72,0,0)
        vl.BackgroundTransparency=1 vl.Text=def vl.TextColor3=Color3.fromRGB(210,225,255) vl.TextSize=11
        vl.Font=Enum.Font.GothamBold vl.TextXAlignment=Enum.TextXAlignment.Left vl.TextTruncate=Enum.TextTruncate.AtEnd
        return vl
    end
    MON.valStatus=makeRow("Status","—",C.cyan,1)
    MON.valPrefix=makeRow("Prefix","—",C.yellow,2)
    MON.valSugg  =makeRow("Saran", "—",C.green,3)
    MON.valWord  =makeRow("Kata",  "—",C.blue,4)

    local sr=Instance.new("Frame",rf)
    sr.Size=UDim2.new(1,0,0,26) sr.BackgroundColor3=Color3.fromRGB(16,18,30)
    sr.BackgroundTransparency=0.2 sr.BorderSizePixel=0 sr.LayoutOrder=5
    Instance.new("UICorner",sr).CornerRadius=UDim.new(0,6)
    local sb2=Instance.new("Frame",sr) sb2.Size=UDim2.new(0,2,0.6,0) sb2.Position=UDim2.new(0,0,0.2,0)
    sb2.BackgroundColor3=C.purple sb2.BorderSizePixel=0 Instance.new("UICorner",sb2).CornerRadius=UDim.new(1,0)
    local sk=Instance.new("TextLabel",sr) sk.Size=UDim2.new(0,40,1,0) sk.Position=UDim2.new(0,8,0,0)
    sk.BackgroundTransparency=1 sk.Text="Stats" sk.TextColor3=Color3.fromRGB(90,110,150) sk.TextSize=10
    sk.Font=Enum.Font.Gotham sk.TextXAlignment=Enum.TextXAlignment.Left
    local function makePill(x,bg,fg)
        local p=Instance.new("Frame",sr) p.Size=UDim2.new(0,38,0,18) p.Position=UDim2.new(0,x,0.5,-9)
        p.BackgroundColor3=bg p.BorderSizePixel=0 Instance.new("UICorner",p).CornerRadius=UDim.new(1,0)
        local l=Instance.new("TextLabel",p) l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1
        l.TextColor3=fg l.TextSize=10 l.Font=Enum.Font.GothamBold l.Text="0" return l
    end
    MON.pillTotal=makePill(48, Color3.fromRGB(25,40,70),  Color3.fromRGB(140,180,255))
    MON.pillBenar=makePill(92, Color3.fromRGB(15,45,30),  Color3.fromRGB(60,210,110))
    MON.pillSalah=makePill(136,Color3.fromRGB(45,15,15),  Color3.fromRGB(255,80,80))
    MON.valDB=makeRow("KBBI","loading...",C.cyan,6)

    local ft=Instance.new("TextLabel",card) ft.Size=UDim2.new(1,-16,0,14) ft.Position=UDim2.new(0,8,1,-16)
    ft.BackgroundTransparency=1 ft.Text="v36.0  •  Auto SK"
    ft.TextColor3=Color3.fromRGB(35,50,80) ft.TextSize=9
    ft.Font=Enum.Font.Gotham ft.TextXAlignment=Enum.TextXAlignment.Right
    MON.sg=sg MON.card=card
end

local function updateMonitor()
    if not MON.sg or not S.ShowMonitor then return end
    local myTurn=isMyTurn()
    local barC,dotC,stTxt
    if not S.AutoAnswer then barC=Color3.fromRGB(55,65,90) dotC=Color3.fromRGB(80,90,110) stTxt="OFF"
    elseif myTurn then barC=Color3.fromRGB(0,210,130) dotC=Color3.fromRGB(0,210,130) stTxt="GILIRAN KAMU"
    else barC=Color3.fromRGB(0,160,220) dotC=Color3.fromRGB(0,160,220) stTxt="Menunggu..." end
    pcall(function() MON.statusBar.BackgroundColor3=barC end)
    pcall(function() MON.sbFix.BackgroundColor3=barC end)
    pcall(function() MON.dot.BackgroundColor3=dotC end)
    pcall(function() MON.valStatus.Text=stTxt MON.valStatus.TextColor3=barC end)
    pcall(function() MON.valPrefix.Text=S.Prefix~="-" and S.Prefix:upper() or "—" end)
    pcall(function() MON.valSugg.Text=S.Suggestion~="-" and S.Suggestion:upper() or "—" end)
    pcall(function() MON.valWord.Text=S.CurrentWord~="-" and S.CurrentWord:upper() or "—" end)
    pcall(function() MON.pillTotal.Text=tostring(S.Terpakai) end)
    pcall(function() MON.pillBenar.Text="✓"..S.Benar end)
    pcall(function() MON.pillSalah.Text="✗"..S.Salah end)
    pcall(function() MON.valDB.Text=kbbiLoaded and totalWords.." kata" or "loading..." end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SK MANUAL GUI  —  persis seperti screenshot
-- Dark panel kiri layar, header "SK MANUAL" + "Awalan: X"
-- Search bar, scrollable word list, badge huruf akhir, SENT+PILIH
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local MAN={}
local manPrefix=""    -- prefix yang sedang ditampilkan di panel

local function rebuildList(prefix)
    if not MAN.scroll then return end
    -- Hapus rows lama
    for _,c in ipairs(MAN.scroll:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
    if not kbbiLoaded then
        MAN.footer.Text="KBBI belum siap..." MAN.scroll.CanvasSize=UDim2.new(0,0,0,0) return
    end
    if not prefix or #prefix<1 then
        MAN.footer.Text="Ketik awalan untuk mencari" MAN.scroll.CanvasSize=UDim2.new(0,0,0,0) return
    end

    local words=getWordList(prefix,50)
    if #words==0 then
        local el=Instance.new("TextLabel",MAN.scroll)
        el.Size=UDim2.new(1,0,0,40) el.BackgroundTransparency=1
        el.Text='Tidak ada kata "'..prefix:upper()..'"'
        el.TextColor3=Color3.fromRGB(80,100,140) el.TextSize=11 el.Font=Enum.Font.Gotham
        MAN.footer.Text="0 kata" MAN.scroll.CanvasSize=UDim2.new(0,0,0,44) return
    end

    for idx, word in ipairs(words) do
        local diffTxt,diffBg,diffFg=getDiff(word)
        local lastCh=word:sub(-1):upper()

        -- ── Item row ──
        local row=Instance.new("Frame",MAN.scroll)
        row.Name="row"..idx row.LayoutOrder=idx
        row.Size=UDim2.new(1,-2,0,46)
        row.BackgroundColor3=Color3.fromRGB(16,20,34)
        row.BackgroundTransparency=0.05 row.BorderSizePixel=0
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)

        -- Left stripe (difficulty color)
        local stripe=Instance.new("Frame",row)
        stripe.Size=UDim2.new(0,3,0.65,0) stripe.Position=UDim2.new(0,0,0.175,0)
        stripe.BackgroundColor3=diffBg stripe.BorderSizePixel=0
        Instance.new("UICorner",stripe).CornerRadius=UDim.new(1,0)

        -- Kata (bold, warna dan tanda sesuai difficulty)
        local wordLbl=Instance.new("TextLabel",row)
        wordLbl.Size=UDim2.new(0,110,0,20) wordLbl.Position=UDim2.new(0,10,0,5)
        wordLbl.BackgroundTransparency=1
        wordLbl.Text=diffTxt=="HARD" and (word.." *") or word
        wordLbl.TextColor3=diffTxt=="HARD" and Color3.fromRGB(255,100,100)
            or diffTxt=="NORMAL" and Color3.fromRGB(255,200,70)
            or Color3.fromRGB(80,220,120)
        wordLbl.TextSize=12
        wordLbl.Font=Enum.Font.GothamBold wordLbl.TextXAlignment=Enum.TextXAlignment.Left

        -- Sub info: "X huruf | DIFFICULTY"
        local infoBase=Instance.new("TextLabel",row)
        infoBase.Size=UDim2.new(0,55,0,13) infoBase.Position=UDim2.new(0,10,0,26)
        infoBase.BackgroundTransparency=1 infoBase.Text=#word.." huruf  |  "
        infoBase.TextColor3=Color3.fromRGB(80,95,130) infoBase.TextSize=9
        infoBase.Font=Enum.Font.Gotham infoBase.TextXAlignment=Enum.TextXAlignment.Left

        -- Difficulty badge inline
        local dbadge=Instance.new("Frame",row)
        dbadge.Size=UDim2.new(0,46,0,13) dbadge.Position=UDim2.new(0,63,0,27)
        dbadge.BackgroundColor3=diffBg dbadge.BackgroundTransparency=0.55 dbadge.BorderSizePixel=0
        Instance.new("UICorner",dbadge).CornerRadius=UDim.new(0,4)
        local dTxt=Instance.new("TextLabel",dbadge)
        dTxt.Size=UDim2.new(1,0,1,0) dTxt.BackgroundTransparency=1
        dTxt.Text=diffTxt dTxt.TextColor3=diffFg dTxt.TextSize=8 dTxt.Font=Enum.Font.GothamBold

        -- Huruf akhir badge (bulat)
        local lbadge=Instance.new("Frame",row)
        lbadge.Size=UDim2.new(0,22,0,22) lbadge.Position=UDim2.new(1,-112,0.5,-11)
        lbadge.BackgroundColor3=diffBg lbadge.BackgroundTransparency=0.5 lbadge.BorderSizePixel=0
        Instance.new("UICorner",lbadge).CornerRadius=UDim.new(1,0)
        local lTxt=Instance.new("TextLabel",lbadge)
        lTxt.Size=UDim2.new(1,0,1,0) lTxt.BackgroundTransparency=1
        lTxt.Text=lastCh lTxt.TextColor3=diffFg lTxt.TextSize=11 lTxt.Font=Enum.Font.GothamBold

        -- Tombol SENT
        local sentBtn=Instance.new("TextButton",row)
        sentBtn.Size=UDim2.new(0,44,0,22) sentBtn.Position=UDim2.new(1,-82,0.5,-11)
        sentBtn.BackgroundColor3=Color3.fromRGB(0,110,220) sentBtn.Text="SENT"
        sentBtn.TextColor3=Color3.fromRGB(255,255,255) sentBtn.TextSize=10
        sentBtn.Font=Enum.Font.GothamBold sentBtn.BorderSizePixel=0
        Instance.new("UICorner",sentBtn).CornerRadius=UDim.new(0,5)
        sentBtn.MouseEnter:Connect(function() sentBtn.BackgroundColor3=Color3.fromRGB(0,145,255) end)
        sentBtn.MouseLeave:Connect(function() sentBtn.BackgroundColor3=Color3.fromRGB(0,110,220) end)

        -- Tombol PILIH
        local pilihBtn=Instance.new("TextButton",row)
        pilihBtn.Size=UDim2.new(0,44,0,22) pilihBtn.Position=UDim2.new(1,-34,0.5,-11)
        pilihBtn.BackgroundColor3=Color3.fromRGB(20,135,55) pilihBtn.Text="PILIH"
        pilihBtn.TextColor3=Color3.fromRGB(255,255,255) pilihBtn.TextSize=10
        pilihBtn.Font=Enum.Font.GothamBold pilihBtn.BorderSizePixel=0
        Instance.new("UICorner",pilihBtn).CornerRadius=UDim.new(0,5)
        pilihBtn.MouseEnter:Connect(function() pilihBtn.BackgroundColor3=Color3.fromRGB(30,175,70) end)
        pilihBtn.MouseLeave:Connect(function() pilihBtn.BackgroundColor3=Color3.fromRGB(20,135,55) end)

        -- Hover highlight row
        row.MouseEnter:Connect(function() row.BackgroundColor3=Color3.fromRGB(22,28,48) end)
        row.MouseLeave:Connect(function() row.BackgroundColor3=Color3.fromRGB(16,20,34) end)

        -- === SENT logic ===
        local capturedWord=word
        sentBtn.MouseButton1Click:Connect(function()
            if not isMyTurn() then
                WindUI:Notify({Title="Bukan giliran!",Content="Tunggu giliran dulu.",Icon="alert-circle",Duration=2}) return
            end
            if S.Busy then return end
            S.Busy=true
            task.spawn(function()
                local sbefore=getWordServerText()
                local ok=typeAndSubmit(capturedWord,manPrefix)
                if not ok then S.Busy=false return end
                local el2=0; local acc=false
                while el2<2.0 do
                    task.wait(0.1); el2=el2+0.1
                    if not isMyTurn() then acc=true break end
                    local cur=getWordServerText()
                    if cur~="" and cur~=sbefore then acc=true break end
                end
                if acc then
                    S.UsedWords[capturedWord]=true S.CurrentWord=capturedWord
                    S.Terpakai=S.Terpakai+1 S.Benar=S.Benar+1
                    S.Suggestion=findBest(capturedWord:sub(-1),nil) or "-"
                    WindUI:Notify({Title="✓ "..capturedWord:upper(),Content="Terkirim!",Icon="check",Duration=2})
                    -- Tandai row sebagai terpakai (redup)
                    pcall(function()
                        row.BackgroundColor3=Color3.fromRGB(10,30,15)
                        wordLbl.TextColor3=Color3.fromRGB(40,100,60)
                        sentBtn.BackgroundColor3=Color3.fromRGB(30,60,30)
                        sentBtn.Text="✓" sentBtn.Active=false pilihBtn.Active=false
                    end)
                else
                    S.UsedWords[capturedWord]=true S.Salah=S.Salah+1
                    WindUI:Notify({Title="✗ Ditolak",Content=capturedWord:upper().." tidak diterima.",Icon="alert-circle",Duration=2})
                    pcall(function()
                        row.BackgroundColor3=Color3.fromRGB(35,10,10)
                        wordLbl.TextColor3=Color3.fromRGB(160,60,60)
                    end)
                end
                task.wait(0.3); S.Busy=false
            end)
        end)

        -- === PILIH logic: highlight saja, tidak kirim ===
        pilihBtn.MouseButton1Click:Connect(function()
            -- Reset highlight row lain
            for _,c in ipairs(MAN.scroll:GetChildren()) do
                if c:IsA("Frame") and c~=row then
                    pcall(function() c.BackgroundColor3=Color3.fromRGB(16,20,34) end)
                    pcall(function()
                        local wl=c:FindFirstChildWhichIsA("TextLabel")
                        if wl then wl.TextColor3=Color3.fromRGB(80,220,120) end
                    end)
                end
            end
            row.BackgroundColor3=Color3.fromRGB(15,42,25)
            local pstroke=row:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke",row)
            pstroke.Color=Color3.fromRGB(30,200,100) pstroke.Thickness=1 pstroke.Transparency=0.25
            S.Suggestion=capturedWord
            WindUI:Notify({Title="Dipilih: "..capturedWord:upper(),Content="Kata ini siap diketik",Icon="check",Duration=2})
        end)
    end

    -- Update canvas size
    task.wait()
    local h=MAN.listLayout.AbsoluteContentSize.Y+10
    MAN.scroll.CanvasSize=UDim2.new(0,0,0,h)
    MAN.footer.Text=#words.." kata ditemukan"
end

local function buildManual()
    local old=LocalPlayer.PlayerGui:FindFirstChild("VHManual")
    if old then old:Destroy() end

    local sg=Instance.new("ScreenGui")
    sg.Name="VHManual" sg.ResetOnSpawn=false sg.DisplayOrder=21
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.Parent=LocalPlayer:WaitForChild("PlayerGui")

    -- ── Panel utama COMPACT: 260×300, pojok kiri atas, tidak nutupin keyboard ──
    local panel=Instance.new("Frame",sg)
    panel.Name="Panel"
    panel.Size=UDim2.new(0,262,0,305)
    panel.Position=UDim2.new(0,6,0,50)
    panel.BackgroundColor3=Color3.fromRGB(11,14,24)
    panel.BackgroundTransparency=0 panel.BorderSizePixel=0
    panel.Active=true panel.Draggable=true
    Instance.new("UICorner",panel).CornerRadius=UDim.new(0,12)
    local pst=Instance.new("UIStroke",panel)
    pst.Color=Color3.fromRGB(30,70,130) pst.Thickness=1 pst.Transparency=0.4

    -- ── Header ──
    local hdr=Instance.new("Frame",panel)
    hdr.Size=UDim2.new(1,0,0,44) hdr.BackgroundColor3=Color3.fromRGB(8,11,20) hdr.BorderSizePixel=0
    Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,12)
    local hfix=Instance.new("Frame",hdr)
    hfix.Size=UDim2.new(1,0,0,12) hfix.Position=UDim2.new(0,0,1,-12)
    hfix.BackgroundColor3=Color3.fromRGB(8,11,20) hfix.BorderSizePixel=0

    -- Title "SK MANUAL"
    local htitle=Instance.new("TextLabel",hdr)
    htitle.Size=UDim2.new(0,130,1,0) htitle.Position=UDim2.new(0,14,0,0) htitle.BackgroundTransparency=1
    htitle.Text="SK MANUAL" htitle.TextColor3=Color3.fromRGB(255,255,255) htitle.TextSize=15
    htitle.Font=Enum.Font.GothamBold htitle.TextXAlignment=Enum.TextXAlignment.Left

    -- "Pilih kata..." label kanan atas (seperti screenshot)
    MAN.pilihLabel=Instance.new("TextLabel",hdr)
    MAN.pilihLabel.Size=UDim2.new(0,100,1,0) MAN.pilihLabel.Position=UDim2.new(0,135,0,0)
    MAN.pilihLabel.BackgroundTransparency=1 MAN.pilihLabel.Text="Pilih kata..."
    MAN.pilihLabel.TextColor3=Color3.fromRGB(60,100,160) MAN.pilihLabel.TextSize=10
    MAN.pilihLabel.Font=Enum.Font.Gotham MAN.pilihLabel.TextXAlignment=Enum.TextXAlignment.Right

    -- Close
    local cb=Instance.new("TextButton",hdr)
    cb.Size=UDim2.new(0,22,0,22) cb.Position=UDim2.new(1,-28,0.5,-11)
    cb.BackgroundColor3=Color3.fromRGB(22,25,40) cb.Text="✕"
    cb.TextColor3=Color3.fromRGB(100,120,160) cb.TextSize=11
    cb.Font=Enum.Font.GothamBold cb.BorderSizePixel=0
    Instance.new("UICorner",cb).CornerRadius=UDim.new(0,6)
    cb.MouseButton1Click:Connect(function() sg.Enabled=false S.ShowManual=false end)
    cb.MouseEnter:Connect(function() cb.BackgroundColor3=Color3.fromRGB(180,40,40) cb.TextColor3=Color3.fromRGB(255,255,255) end)
    cb.MouseLeave:Connect(function() cb.BackgroundColor3=Color3.fromRGB(22,25,40) cb.TextColor3=Color3.fromRGB(100,120,160) end)

    -- ── "Awalan: X" sub-header (seperti screenshot "Awalan: F") ──
    MAN.awalanLabel=Instance.new("TextLabel",panel)
    MAN.awalanLabel.Size=UDim2.new(1,-20,0,18) MAN.awalanLabel.Position=UDim2.new(0,14,0,48)
    MAN.awalanLabel.BackgroundTransparency=1 MAN.awalanLabel.Text="Awalan: —"
    MAN.awalanLabel.TextColor3=Color3.fromRGB(140,180,255) MAN.awalanLabel.TextSize=11
    MAN.awalanLabel.Font=Enum.Font.GothamBold MAN.awalanLabel.TextXAlignment=Enum.TextXAlignment.Left

    -- ── Mode filter: Semua / Mudah / Normal / Hard ──
    local modeFrame=Instance.new("Frame",panel)
    modeFrame.Size=UDim2.new(1,-20,0,22) modeFrame.Position=UDim2.new(0,10,0,70)
    modeFrame.BackgroundTransparency=1 modeFrame.BorderSizePixel=0
    local mll=Instance.new("UIListLayout",modeFrame)
    mll.FillDirection=Enum.FillDirection.Horizontal mll.Padding=UDim.new(0,3)
    local modeBtns={}
    local mClr={semua=Color3.fromRGB(40,70,150),mudah=Color3.fromRGB(18,100,38),normal=Color3.fromRGB(130,80,0),hard=Color3.fromRGB(150,18,18)}
    local mDef=Color3.fromRGB(22,26,44)
    for _,md in ipairs({{"Semua","semua"},{"Mudah","mudah"},{"Normal","normal"},{"Hard","hard"}}) do
        local lbl,key=md[1],md[2]
        local mb=Instance.new("TextButton",modeFrame)
        mb.Size=UDim2.new(0.23,0,1,0) mb.BackgroundColor3=(key=="semua") and mClr[key] or mDef
        mb.BorderSizePixel=0 mb.Text=lbl mb.TextColor3=Color3.fromRGB(210,220,255)
        mb.TextSize=9 mb.Font=Enum.Font.GothamBold
        Instance.new("UICorner",mb).CornerRadius=UDim.new(0,4)
        modeBtns[key]=mb
        mb.MouseButton1Click:Connect(function()
            S_ManualMode=key
            for k,b in pairs(modeBtns) do b.BackgroundColor3=(k==key) and mClr[k] or mDef end
            if manPrefix~="" then task.spawn(function() rebuildList(manPrefix) end) end
        end)
    end

    -- ── Search bar (seperti screenshot "Cari kata... (ketik awalan)") ──
    local sbg=Instance.new("Frame",panel)
    sbg.Size=UDim2.new(1,-20,0,32) sbg.Position=UDim2.new(0,10,0,96)
    sbg.BackgroundColor3=Color3.fromRGB(18,22,38) sbg.BorderSizePixel=0
    Instance.new("UICorner",sbg).CornerRadius=UDim.new(0,8)
    local sbst=Instance.new("UIStroke",sbg)
    sbst.Color=Color3.fromRGB(40,80,150) sbst.Thickness=1 sbst.Transparency=0.6

    local sbox=Instance.new("TextBox",sbg)
    sbox.Size=UDim2.new(1,-16,1,-4) sbox.Position=UDim2.new(0,10,0,2)
    sbox.BackgroundTransparency=1 sbox.Text=""
    sbox.PlaceholderText="Cari kata... (ketik awalan)"
    sbox.PlaceholderColor3=Color3.fromRGB(60,80,130)
    sbox.TextColor3=Color3.fromRGB(200,220,255) sbox.TextSize=11
    sbox.Font=Enum.Font.Gotham sbox.TextXAlignment=Enum.TextXAlignment.Left
    sbox.ClearTextOnFocus=false
    MAN.searchBox=sbox

    -- ── Scrolling list ──
    local scroll=Instance.new("ScrollingFrame",panel)
    scroll.Size=UDim2.new(1,-8,1,-112) scroll.Position=UDim2.new(0,4,0,104)
    scroll.BackgroundTransparency=1 scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=3 scroll.ScrollBarImageColor3=Color3.fromRGB(40,120,220)
    scroll.ScrollBarImageTransparency=0.4 scroll.CanvasSize=UDim2.new(0,0,0,0)
    MAN.scroll=scroll

    local ll=Instance.new("UIListLayout",scroll)
    ll.SortOrder=Enum.SortOrder.LayoutOrder ll.Padding=UDim.new(0,4)
    MAN.listLayout=ll
    local lpad=Instance.new("UIPadding",scroll)
    lpad.PaddingLeft=UDim.new(0,3) lpad.PaddingRight=UDim.new(0,3) lpad.PaddingTop=UDim.new(0,3)

    -- ── Footer (jumlah kata) ──
    MAN.footer=Instance.new("TextLabel",panel)
    MAN.footer.Size=UDim2.new(1,-16,0,14) MAN.footer.Position=UDim2.new(0,8,1,-16)
    MAN.footer.BackgroundTransparency=1 MAN.footer.Text=""
    MAN.footer.TextColor3=Color3.fromRGB(40,60,100) MAN.footer.TextSize=9
    MAN.footer.Font=Enum.Font.Gotham MAN.footer.TextXAlignment=Enum.TextXAlignment.Right

    MAN.sg=sg MAN.panel=panel

    -- Search hook
    sbox:GetPropertyChangedSignal("Text"):Connect(function()
        local q=sbox.Text:lower():gsub("[^a-z]","")
        if #q>=1 then
            manPrefix=q
            MAN.awalanLabel.Text="Awalan: "..q:upper()
            task.spawn(function() rebuildList(q) end)
        else
            MAN.awalanLabel.Text="Awalan: —"
        end
    end)
end

local function openManual(prefix)
    if not MAN.sg then buildManual() end
    MAN.sg.Enabled=true
    if prefix and #prefix>=1 then
        manPrefix=prefix
        MAN.awalanLabel.Text="Awalan: "..prefix:upper()
        if MAN.searchBox then MAN.searchBox.Text=prefix end
        task.spawn(function() rebuildList(prefix) end)
    end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- WINDUI
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local Win=WindUI:CreateWindow({
    Title="Victoria Hub", Icon="rbxassetid://134034549147826",
    Author="Sambung Kata", Folder="VICTORIA_HUB",
    Transparent=true, Size=UDim2.fromOffset(240,300),
    HasOutline=true, SideBarWidth=160,
})
Win:EditOpenButton({
    Title="Victoria Hub", Icon="rbxassetid://134034549147826",
    CornerRadius=UDim.new(0,16), StrokeThickness=2,
    Color=ColorSequence.new(Color3.fromHex("#0066ff"),Color3.fromHex("#003399")),
    OnlyMobile=true, Enabled=true, Draggable=true,
})
Win:Tag({Title="V29.0",Color=Color3.fromRGB(255,255,255),Radius=17})
local executorName=identifyexecutor and identifyexecutor() or "Unknown"
local executorColor=Color3.fromRGB(200,200,200)
local execMap={flux="#30ff6a",delta="#38b6ff",arceus="#a03cff",krampus="#ff3838",oxygen="#ff3838",volcano="#ff8c00",synapse="#ffd700",krypton="#ffd700",wave="#00e5ff",zenith="#ff00ff",seliware="#00ffa2",krnl="#1e90ff",trigon="#ff007f",nihon="#8a2be2",celery="#4caf50",lunar="#8080ff",valyse="#ff1493",vega="#4682b4",electron="#7fffd4",awp="#ff005e",bunni="#ff69b4"}
for k,v in pairs(execMap) do
    if executorName:lower():find(k) then executorColor=Color3.fromHex(v) break end
end
Win:Tag({Title="EXECUTOR | "..executorName,Icon="github",Color=executorColor,Radius=0})

local Tab1=Win:Tab({Title="Main",Icon="gamepad-2",Box=true,BoxBorder=true})

local actSec=Tab1:Section({Title="Activities Monitoring",Icon="activity",Box=true,BoxBorder=true,Opened=false})
ParaStatus=actSec:Paragraph({
    Title="SYSTEM",
    Desc="Status: -\nDatabase: "..kbbiStatus.."\nPrefix: -\nSuggestion: -\nTerpakai: 0\nBenar: 0  Salah: 0",
})
actSec:Button({
    Title="Reset Words",Icon="refresh-cw",Justify="Center",
    Callback=function()
        S.UsedWords={} S.LastSubmit="" S.Terpakai=0
        S.CurrentWord="-" S.Benar=0 S.Salah=0 S.Busy=false S.Suggestion="-"
        WindUI:Notify({Title="Reset",Content="Siap ronde baru!",Icon="check",Duration=2})
    end,
})
actSec:Toggle({
    Title="Monitor GUI",Desc="Panel compact pojok kanan bawah",Icon="monitor",Value=false,
    Callback=function(v)
        S.ShowMonitor=v
        if v then
            if not MON.sg then buildMonitor() end
            MON.sg.Enabled=true updateMonitor()
        else if MON.sg then MON.sg.Enabled=false end end
    end,
})

local modeSec=Tab1:Section({Title="Auto Feature",Icon="power",Box=true,BoxBorder=true,Opened=false})
modeSec:Toggle({
    Title="Auto Answer",Desc="Auto jawab + koreksi jika ditolak server",Icon="play",Value=false,
    Callback=function(v)
        S.AutoAnswer=v S.Busy=false
        WindUI:Notify({Title=v and "Auto SK ON" or "Auto SK OFF",Content=v and "Siap!" or "Stop.",Icon=v and "play" or "square",Duration=2})
    end,
})
modeSec:Slider({Title="Answer Delay",Desc="Jeda sebelum mulai ketik",Step=1,Value={Min=1,Max=50,Default=15},Callback=function(v) S.Delay=v/10 end})
modeSec:Slider({Title="Typing Speed",Desc="Kecepatan klik per huruf",Step=1,Value={Min=3,Max=50,Default=30},Callback=function(v) S.Speed=v/100 end})

-- SK Manual
local manSec=Tab1:Section({Title="SK Manual",Icon="list",Box=true,BoxBorder=true,Opened=false})
manSec:Toggle({
    Title="Panel SK Manual",Desc="List kata KBBI per prefix + SENT/PILIH",Icon="list",Value=false,
    Callback=function(v)
        S.ShowManual=v
        if v then
            openManual(S.Prefix~="-" and S.Prefix or "")
        else
            if MAN.sg then MAN.sg.Enabled=false end
        end
    end,
})
manSec:Paragraph({
    Title="Cara pakai",
    Desc="Buka panel → ketik awalan di search\nSENT = kirim via auto-type\nPILIH = highlight kata pilihan",
})

local kbbiSec=Tab1:Section({Title="KBBI Word Source",Icon="database",Box=true,BoxBorder=true,Opened=false})
ParaDB=kbbiSec:Paragraph({Title="KBBI Status",Desc="Source: GitHub (VictoriaHub)\nTotal: "..totalWords.." Words\nStatus: "..kbbiStatus})

local raritySec=Tab1:Section({Title="Letter Rarity",Icon="book-open",Box=true,BoxBorder=true,Opened=false})
ParaRarity=raritySec:Paragraph({Title="Frekuensi Huruf",Desc=getRarityText()})

local Tab2=Win:Tab({Title="Settings",Icon="settings",Box=true,BoxBorder=true})
local dbgSec=Tab2:Section({Title="Debug",Icon="terminal",Box=true,BoxBorder=true,Opened=false})
dbgSec:Toggle({
    Title="Debug Mode",Desc="Print info ke F9",Value=false,
    Callback=function(v) S.Debug=v WindUI:Notify({Title="Debug",Content=v and "ON" or "OFF",Icon="terminal",Duration=2}) end,
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- MAIN LOOP
-- ★ FIX LAG: getWordSubmitText() TIDAK dipanggil di Heartbeat!
-- Semua update prefix → event-driven .Changed di bawah
-- Heartbeat hanya cek kb.Visible (sangat ringan, 1 property access)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local prevTurn=false
local tStat=0

-- Event hook pada WordSubmit TextLabels
-- Dipasang SEKALI, update prefix tiap ada perubahan teks slot
task.spawn(function()
    while true do
        task.wait(0.5)
        local ws=getWordSubmit()
        if ws then
            -- Debounce: tiap huruf diketik nunggu 0.15s baru proses
            -- Kata 8 huruf = 8 event tapi hanya 1x getWordSubmitText()
            local _dbt=nil
            local function onSlotChanged()
                if _dbt then task.cancel(_dbt) end
                _dbt=task.delay(0.15,function()
                    _dbt=nil
                    if not kbbiLoaded then return end
                    local text=getWordSubmitText()
                    local newPfx=""
                    if text and #text>0 then
                        newPfx=text
                    else
                        local p=getWordServerText()
                        if p~="" then newPfx=p end
                    end
                    if newPfx~="" and newPfx~=S.Prefix then
                        S.Prefix=newPfx
                        S.Suggestion=findBest(newPfx,nil) or "-"
                        if S.ShowManual and MAN.sg and MAN.sg.Enabled and newPfx~=manPrefix then
                            manPrefix=newPfx
                            if MAN.awalanLabel then MAN.awalanLabel.Text="Awalan: "..newPfx:upper() end
                            if MAN.searchBox then MAN.searchBox.Text=newPfx end
                            task.spawn(function() rebuildList(newPfx) end)
                        end
                    end
                end)
            end
            -- Pasang ke semua TextLabel yang sudah ada
            for _,child in ipairs(ws:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:GetPropertyChangedSignal("Text"):Connect(onSlotChanged)
                end
            end
            -- Pasang ke TextLabel yang muncul belakangan
            ws.DescendantAdded:Connect(function(child)
                if child:IsA("TextLabel") then
                    child:GetPropertyChangedSignal("Text"):Connect(onSlotChanged)
                end
            end)
            onSlotChanged()
            break
        end
    end
end)

-- Scan prefix via label "Hurufnya adalah" (deteksi giliran lawan juga)
local _lastHurufPfx=""
task.spawn(function()
    while true do
        task.wait(0.3)
        if kbbiLoaded then
            local pg=LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _,v in ipairs(pg:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Visible and v.Text and v.Text:find("Hurufnya adalah") then
                        for _,sib in ipairs(v.Parent:GetChildren()) do
                            if sib:IsA("TextLabel") and sib~=v and sib.Visible then
                                local t=sib.Text:gsub("%s+",""):upper()
                                if t:match("^[A-Z]+$") and #t>=1 and #t<=4 and t~=_lastHurufPfx then
                                    _lastHurufPfx=t
                                    local raw=t:lower()
                                    if raw~=S.Prefix then
                                        S.Prefix=raw
                                        S.Suggestion=findBest(raw,nil) or "-"
                                    end
                                    if S.ShowManual and MAN.sg and MAN.sg.Enabled and raw~=manPrefix then
                                        manPrefix=raw
                                        if MAN.awalanLabel then MAN.awalanLabel.Text="Awalan: "..raw:upper() end
                                        if MAN.searchBox then MAN.searchBox.Text=raw end
                                        task.spawn(function() rebuildList(raw) end)
                                    end
                                    break
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    tStat=tStat+dt

    -- ★ Hanya cek kb.Visible — TIDAK ada getWordSubmitText() di sini!
    local myTurn=isMyTurn()
    if myTurn and not prevTurn then
        prevTurn=true S.Busy=false S.LastSubmit=""
        local p=getWordServerText()
        if p~="" and p~=S.Prefix then
            S.Prefix=p; S.Suggestion=findBest(p,nil) or "-"
        end
        if S.Debug then print("[SK] GILIRAN! Prefix='"..S.Prefix.."'") end
        -- Auto-update manual panel
        if S.ShowManual and MAN.sg and MAN.sg.Enabled and S.Prefix~="-" and S.Prefix~=manPrefix then
            manPrefix=S.Prefix
            if MAN.awalanLabel then MAN.awalanLabel.Text="Awalan: "..S.Prefix:upper() end
            if MAN.searchBox then MAN.searchBox.Text=S.Prefix end
            task.spawn(function() rebuildList(S.Prefix) end)
        end
        if S.AutoAnswer then doAnswer() end
    end
    if not myTurn and prevTurn then prevTurn=false S.Busy=false end

    -- UI text refresh setiap 0.4s (di task.spawn, non-blocking)
    if tStat>=0.4 then
        tStat=0
        task.spawn(function()
            local mt=isMyTurn()
            local st=not S.AutoAnswer and "Stop" or mt and "Giliran kamu!" or "Menunggu lawan..."
            pcall(function() ParaStatus:SetDesc(
                "Status: "..st.."\nDatabase: "..kbbiStatus..
                "\nPrefix: "..(S.Prefix~="-" and S.Prefix:upper() or "-")..
                "\nSuggestion: "..(S.Suggestion~="-" and S.Suggestion:upper() or "-")..
                "\nTerpakai: "..S.Terpakai.."\nBenar: "..S.Benar.."  Salah: "..S.Salah
            ) end)
            pcall(function() ParaDB:SetDesc(
                "Source: GitHub (VictoriaHub)\nTotal: "..totalWords.." Words\nStatus: "..kbbiStatus
            ) end)
            if kbbiLoaded then pcall(function() ParaRarity:SetDesc(getRarityText()) end) end
            if S.ShowMonitor then updateMonitor() end
        end)
    end
end)

-- REMOTE LISTENERS
if R_UsedWordWarn then
    R_UsedWordWarn.OnClientEvent:Connect(function(a1)
        local w=type(a1)=="string" and a1:lower():gsub("[^a-z]","") or ""
        if #w>1 then S.UsedWords[w]=true end
    end)
end
if R_PlayerCorrect then
    R_PlayerCorrect.OnClientEvent:Connect(function()
        S.LastSubmit="" S.Busy=false
    end)
end

print("[SK] v36.0 | No Heartbeat scan | SK Manual panel")
WindUI:Notify({Title="Auto SK v36.0",Content="Loading KBBI...",Icon="zap",Duration=3})
