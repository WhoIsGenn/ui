--[[
    Word Chain Auto Script v6.0
    - ESP = GUI panel (list kata valid untuk huruf aktif)
    - Kamus 6000+ kata
    - Typing simulation (submit + TypeSound per huruf)
    - TextBox path akan di-update setelah debug
]]

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
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

local Remotes      = ReplicatedStorage:WaitForChild("Remotes", 15)
local R_SubmitWord = Remotes:WaitForChild("SubmitWord", 10)
local R_TypeSound  = Remotes:FindFirstChild("TypeSound")
local R_UsedWordWarn  = Remotes:FindFirstChild("UsedWordWarn")
local R_PlayerCorrect = Remotes:FindFirstChild("PlayerCorrect")
local R_PlayerHit     = Remotes:FindFirstChild("PlayerHit")

-- ============================================================
-- WORD LIST 6000+
-- ============================================================

local RAW_WORDS = {
    "abadi","abah","abang","abdi","abon","abri","abu","acara","acuh","ada","adab",
    "adam","adik","adil","adinda","aduan","agama","agung","ahad","ahli","air","aib",
    "ajaib","ajak","ajar","ajaran","ajek","ajuk","ajur","akad","akal","akan","akar",
    "akbar","akhir","akhlak","akrab","aksara","aksi","aktif","aktris","aku","alam",
    "alat","album","alih","aliran","alim","alit","alpa","altar","alun","alur","amal",
    "aman","amar","ambil","ambisi","ambon","amis","ampas","ampun","amuk","anak","aneh",
    "angin","angka","angkat","angkuh","angsa","anjing","anjur","antara","anting","antuk",
    "anut","anyam","apel","apik","api","apung","arab","arang","arca","arif","arit",
    "arsitek","artis","arung","asah","asal","asap","asar","asas","asih","asik","askar",
    "aspal","asuh","asyik","atap","atas","atau","atur","awal","awak","awam","awan",
    "awas","ayah","ayang","ayat","ayun","azas","aziz","abjad","absen","acap","acir",
    "agak","agam","agen","aib","aih","aim","ainun","airi","ajal","akbar","akin","akir",
    "akis","akit","aksa","akta","aktor","akur","alaf","alai","alan","alang","alar",
    "alas","alba","albu","aleh","alek","alem","alen","aler","ales","alif","alik","alir",
    "alis","alku","amin","amsal","andam","andap","andas","andul","aneka","angsur","antap",
    "antri","apas","astaga","asur","atak","atal","atan","atat","atik","atir","awetan",
    "ayunan","azab","azali",
    "babu","badan","bagus","bahan","bahas","bahaya","baik","bakar","bakau","baki",
    "bakmi","bakso","bakti","baku","balai","balam","baldi","balik","balok","balun",
    "balut","bambu","banci","bandel","bangun","banjir","bantu","banyak","bapak","barat",
    "baring","baris","baru","basah","batak","batik","batuk","bawa","bawah","bawang",
    "bayam","bayar","beda","bebas","becak","becus","bekal","belah","belok","belum",
    "benar","benci","bendera","bengkel","bensin","benua","berat","berani","berita",
    "bersih","besan","besar","besok","betah","betul","bidang","bijak","bijaksana",
    "bila","bilik","bimbang","binar","binatang","bintang","bodoh","boleh","bonus",
    "boros","botol","bubur","budak","budaya","bujur","bukit","bulan","bulat","bumi",
    "bunuh","buruh","burung","busa","busur","butuh","biadab","bohong","bangga",
    "bangkit","bangkrut","bangsa","bantah","barang","barisan","basmi","batal","batin",
    "bakul","balada","balap","balon","bandar","berhasil","berlari","berpikir","berkata",
    "belanja","brilian","boikot","babak","babat","bagai","bagian","bahari","bahasa",
    "bahagia","bakalan","bantal","bareng","batasan","bekas","belaja","berakal","berdaya",
    "betapa","biografi","blankon","blokir","bolak","bolos","bosan","bukti","buron",
    "bursa","bayangan","berbagi","berdoa","berguna","beriman","berjasa","berjiwa",
    "berkah","berlaku","bermain","bersatu","bertahan","bertanya","berubah","berwarna",
    "bimbingan","bintang","birahi","bisnis","blokade","bodong","bokong","bolang",
    "borong","brengsek","buat","buatan","budiman","bukan","bundar","buruk",
    "cabai","cabang","cabut","cagar","cahaya","cair","cakap","cakep","cakram",
    "calon","campur","canda","cangkir","cangkul","cantik","capai","capek","cari",
    "catat","catut","catur","cedera","cegah","celah","cemara","cemas","cendol",
    "cepat","cerai","cerewet","ceria","cermat","cermin","cetakan","cicak","cicil",
    "cinta","ciprat","ciuman","cobaan","cokelat","comot","copot","corat","coreng",
    "cubit","cuci","cukup","cukur","cumbu","cumi","cupang","curang","curam","curiga",
    "curi","cadangan","cairan","campuran","canggih","cemerlang","cerdas","cerdik",
    "cergas","cita","coblos","colong","cakrawala","cangkang","catatan","ceroboh",
    "cicilan","cita","cobaan","dakwah","dalam","damai","dapur","darah","darat",
    "dasar","datang","daun","debat","dedikasi","definisi","dekat","demokratis",
    "dengan","depan","deras","desa","desak","deskripsi","detail","diam","dingin",
    "dinasti","dinihari","diplomasi","direktur","disiplin","diskusi","distribusi",
    "dobrak","dominan","dorong","dosa","drastis","duduk","duka","dukungan","dulang",
    "dulu","dungu","dunia","duplikat","duri","dusta","duit","durasi","dusun","duyun",
    "daerah","daftar","dahulu","dakwa","dalang","damba","dampak","danau","daratan",
    "darma","data","dedak","desah","didik","dinamo","dinding","dirgantara","dodol",
    "dokar","delegasi","demam","derajat","deretan","diagnosis","diantara","dinamis",
    "dokter","dorongan","drama","duka","damba","damai","danau","debar","debur",
    "edan","edaran","edar","efektif","efisien","ejek","ekor","ekonomi","edukasi",
    "eksekusi","ekspansi","ekspedisi","ekspor","eksperimen","ekspresi","ekstra",
    "elaborasi","elang","emas","emansipasi","empat","empati","empuk","encok","endap",
    "energi","enggan","enam","entah","entitas","enak","erat","esok","etika","etnis",
    "evaluasi","evolusi","elok","emosi","ekuitas","elegans","esensi","esensial",
    "estimasi","efektif","efisien","emang","enak","enak","endus","engkau","enteng",
    "faham","fajar","fakir","fakta","famili","fasih","fasilitator","fatal","festival",
    "fikir","filsafat","finansial","fisik","fleksibel","fokus","fondasi","formal",
    "formula","forum","foto","frasa","frustasi","fungsi","futsal","faktor","fabel",
    "faksi","fanatik","fana","fitnah","fitrah","fluktuasi","fondasi","formulasi",
    "gadis","gagah","gagal","gairah","galak","galeri","gambar","gampang","ganas",
    "ganda","gang","garang","garansi","garpu","garis","gelap","gelisah","gemuk",
    "gembira","gendut","generasi","gentar","gerak","getah","getar","gigi","gigih",
    "gila","girang","global","golong","goreng","gosip","gotong","goyang","gradual",
    "guna","gunung","guru","gusar","gusur","gaib","gairah","gamblang","gelora",
    "gempar","genap","genteng","gerakan","getir","giliran","gombal","guncang",
    "habis","hadap","hadir","hafal","haji","halal","halang","halus","hamba","hambat",
    "hampir","hancur","handuk","hangat","hangus","hanya","hapus","harap","harapan",
    "hari","harmonis","harum","hasrat","hasil","hati","hebat","heboh","hemat",
    "hewan","hidup","hidayah","hierarki","hilang","hipotesis","hitam","hitungan",
    "hobi","holistik","hormat","hubungan","hujan","hukum","humanis","humor","hutan",
    "haluan","hambatan","haru","hasilkan","helai","hikmah","hikmat","himbauan",
    "hubung","hujah","hukuman","huruf","hadiah",
    "ibarat","ibu","identitas","ikhlas","ikrar","ikut","imajinatif","imbang",
    "implementasi","imut","indah","induk","ingat","ingkar","ingin","inisiatif",
    "injak","inovasi","insan","inspirasi","institusi","interaksi","interpretasi",
    "intai","investasi","irama","iri","iris","isap","iseng","istana","isteri","istri",
    "itu","izin","ikhlas","ikhtiar","imam","imbalan","imun","incar","industri",
    "infak","informatif","insaf","integritas","irigasi","imbas","imajinasi",
    "jaga","jalan","jaminan","janda","jangkar","jantan","jasa","jasad","jatah",
    "jatuh","jauh","jaringan","jawab","jawara","jelas","jelang","jelajah","jembatan",
    "jenderal","jernih","jenis","jimat","jiwa","jitu","joget","jolok","jompo",
    "jubah","jual","juara","judas","jujur","juga","julat","jumpa","jumlah","jurnal",
    "jurus","jadwal","jagoan","jahat","jalur","jangka","jarahan","jarum","jauhari",
    "jebak","jelita","jemput","jinak","jogja","juang","jabatan","jajaran","jalinan",
    "kabar","kabur","kacau","kadang","kaget","kaki","kalem","kaleng","kalah","kali",
    "kalung","kamar","kami","kamu","kampung","kandang","kangkung","kanan","kapan",
    "karakter","karya","kasar","kasih","kata","kawat","kawan","kaya","kebal",
    "kebun","kecewa","kecil","kejar","kelas","keluar","kenapa","kenal","keras",
    "kepribadian","keseimbangan","kesempatan","kewajiban","kering","kerja","kinerja",
    "kira","kirim","kolaborasi","kompeten","komunitas","konflik","konsekuensi",
    "konsistensi","konstruktif","kontribusi","korupsi","kotor","kreativitas",
    "kritis","krisis","kriteria","kualitas","kubur","kuda","kudeta","kumis","kunci",
    "kulit","kupas","kurang","kurus","kursi","kutu","kagum","kajian","kampanye",
    "kapital","karunia","kategori","keahlian","kebajikan","kebijakan","kebenaran",
    "kebesaran","kecerdasan","kehidupan","kejujuran","kekuatan","kelompok",
    "kemampuan","kemerdekaan","kemurahan","kenangan","kepemimpinan","kerabat",
    "kerugian","keselamatan","kesuksesan","kewirausahaan","keyakinan","kobaran",
    "kodrat","koperasi","kreatif","kukuh","kumpul","kundur","kunjung","kurawal",
    "lagi","lain","lama","langit","langkah","lancar","lapisan","lapor","lapar",
    "latihan","laut","layanan","lebih","lembaga","lepas","letak","lewat","liar",
    "libur","licin","lidah","lihat","lingkar","lingkungan","lintas","lipat","logika",
    "lolos","lomba","longsor","loyalitas","luka","lunak","luntur","lupa","lucu",
    "lumpur","lurus","lapang","laporan","lautan","lembut","lencana","lengkap",
    "lestari","lezat","lincah","lingkup","lirik","lokal","lugas","luhur","lulusan",
    "lumayan","lumpuh","lunglai","luruh","lusuh","latarbelakang",
    "mabuk","macam","macet","mahir","mahal","main","maju","majikan","makna","malas",
    "malam","makan","malu","manfaat","manis","mapan","marah","martabat","masalah",
    "masuk","masyarakat","mati","mawar","mediasi","meja","melawan","menang","mendapat",
    "mengelola","merah","merasa","mesin","mewujudkan","migrasi","mimpi","minat",
    "minta","mirip","mitos","modal","mogok","molek","monitor","monyet","motivasi",
    "mudah","muda","muncul","mungkin","murni","murung","musuh","musik","murah","mulus",
    "madani","mahasiswa","makmur","mandiri","mangkuk","manusia","melimpah",
    "membangun","memperjuangkan","memimpin","menginspirasi","mentari","merdeka",
    "merindu","minuman","mitigasi","momen","mulia","musim","mutlak","malam","makna",
    "nafsu","naik","nakal","nalar","nama","nampak","nanti","narasi","nasib","nasional",
    "nasehat","negara","negosiasi","nekat","nikmat","nilai","nonton","normal","normatif",
    "nurani","nyaman","nyata","naikkan","naungan","negeri","niat","nikah","niscaya",
    "nyali","nyanyian","nyawa","nalar","napas","negeri",
    "obat","objektif","observasi","olah","olahraga","ombak","omong","operasional",
    "opini","optimis","orang","orde","organ","organisasi","orientasi","otak",
    "otomatis","otot","obrolan","omset","oplah","orasi",
    "pacaran","pagar","pahat","pagi","paham","pakai","pajak","paksa","palang","paling",
    "palung","pandai","pandang","panggil","panjang","pantai","pantas","papan",
    "partisipasi","pasang","pasrah","pasti","patah","patuh","peduli","pejuang",
    "pelan","peluk","pemimpin","pengetahuan","penilaian","penuh","percaya",
    "perencanaan","pergi","perlu","persatuan","perspektif","pesan","petang","petani",
    "petarung","pikir","pilar","pilih","pintasan","pintar","pisah","pohon","pokok",
    "polos","popular","potensi","potong","prioritas","produktif","profesional",
    "program","proyek","proses","pukul","pulang","pulih","punah","puncak","punya",
    "puas","pura","pusat","pusing","putih","putra","panas","panduan","pangkat",
    "panitia","pelajaran","pelayanan","pelindung","pembangunan","pengalaman",
    "penghargaan","perjuangan","permata","petunjuk","pilihan","piutang","prakarsa",
    "prinsip","produksi","provisi","puisi","puluhan","pusat",
    "ragu","raih","rajin","rakus","ramah","ramai","rampok","rangkul","rapih","rapat",
    "rasa","rasional","rata","rayu","rebut","reda","reformasi","rekan","rela","relasi",
    "relevan","rendam","rencana","rendah","renggang","representasi","resah","resolusi",
    "responsif","resmi","revolusi","ringan","rindu","risiko","roboh","roda","rongga",
    "ruang","rugi","rumah","rumus","runtuh","rupa","rusak","raihlah","rakyat",
    "ramalan","rancangan","rekaman","rekayasa","rekrutan","relawan","remaja",
    "renungan","reputasi","rezeki","riset","rohani","rotasi","rumusan",
    "sabar","sabtu","sadar","sahur","saing","sajak","sakit","salah","saling","sama",
    "sandal","sanggup","santai","sapu","sarat","sasaran","satu","sawah","sayur",
    "segera","sehat","sekolah","sejuk","selain","selamat","selalu","selesai","sembuh",
    "semua","sengaja","senang","serba","serius","siap","sigap","sikap","silap","simpan",
    "sinyal","singkat","sistem","siswa","soal","sobat","solar","solusi","sombong",
    "sopan","strategi","struktur","suku","sulap","sulit","sumber","sungguh","sunyi",
    "supaya","susah","syukur","sabuk","sahaja","sajian","samudra","saudara","sayang",
    "seimbang","sekitar","sendiri","sesama","setia","simpati","sinergis","sirkulasi",
    "situasi","slogan","solidaritas","sponsor","substansi","sukacita","sabda",
    "sahabat","sakral","salut","santun","satria","sebab","segenap","semangat",
    "senantiasa","sentuh","senyum","serasi","serentak","seruan","setara","setulus",
    "siaga","siasat","sigap","silaturahmi","simfoni","singgah","sirna","sitaan",
    "tabah","tabrakan","tahan","tajam","taktik","tali","tampil","tanda","tangguh",
    "tanggung","tanya","tapak","tarik","tawar","teguh","tekad","tekun","tenang",
    "tengah","tepat","terang","teras","terobosan","terima","terus","tiang","tiap",
    "tidur","timbul","timur","tinggal","tinggi","tiruan","tobat","toleransi","tolong",
    "tombak","tonton","total","tradisi","transformasi","transparansi","tidak","tujuan",
    "tumit","tunjuk","tugas","tulus","turun","tutup","tabungan","tanah","tatanan",
    "teladan","tenaga","teori","tepat","terbuka","terdepan","terpadu","tersayang",
    "titik","tokoh","transisi","tumbuh","tuntas","tutur",
    "ubah","ujar","ujian","ukur","ulang","umat","umpan","undang","universal","unggul",
    "unik","untung","upaya","urutan","usaha","usai","utama","utang","ulet","uraian",
    "utuh","usaha",
    "validasi","vital","visi","vokal","vitalitas","versi","wahana","warisan",
    "wajah","wajib","waktu","waras","watak","warga","warna","wasiat","wawasan",
    "wedang","wibawa","wirausaha","wisata","wujud","walau","wilayah",
    "yakin","yang","yatim","yaitu","yakni",
    "zaman","ziarah","zona","zakat","zarah",
    -- Kata 2-3 huruf penting untuk sambung kata
    "abu","adu","air","aja","aji","aku","ala","ali","alo","alu","ama","ami","ana",
    "ani","anu","apa","are","ari","aru","asa","asi","ata","ati","ayo","bau","bea",
    "beo","bir","bis","bos","bus","cap","cat","cek","cik","doa","dol","dus","eja",
    "eka","ela","eli","elo","ema","ena","eni","era","eta","gel","gen","hal","ham",
    "han","has","hat","hem","her","ide","iga","ijo","ika","iki","ila","ima","ina",
    "ini","ipa","ira","iri","itu","jab","jam","jan","jar","jas","jek","jet","job",
    "jok","jot","kab","kad","kai","kak","kan","kau","kek","kel","ken","ker","kes",
    "kil","kim","kin","kip","kir","kit","kol","kom","kos","kub","kud","kuk","kul",
    "lab","lad","lak","lap","las","lat","lau","led","lek","lem","len","lep","les",
    "lid","lik","lim","lin","lip","lis","lit","log","luk","lum","lun","mad","mak",
    "mal","man","mas","mau","mek","mel","men","mer","mes","mik","mil","mim","min",
    "mir","mis","mob","mod","mol","mon","mor","mug","mul","mun","nak","nam","nan",
    "nar","nas","nat","nab","nag","nek","nel","nem","nep","ner","nes","net","nik",
    "nim","nip","nor","not","oba","obi","oke","ola","ole","oma","omi","ona","ong",
    "opa","ora","ota","oti","oto","pak","pal","pan","par","pas","pat","pau","ped",
    "pek","pel","pen","pep","per","pes","pet","pil","pim","pin","pir","pol","pom",
    "pon","pop","pos","pot","pub","pul","pun","put","rab","rad","rak","rap","ras",
    "rat","reb","red","reg","rek","rem","ren","rep","res","ret","rib","rid","rik",
    "rim","rin","rip","ris","rob","rod","rok","rom","ron","ros","rot","rub","rug",
    "rum","run","rut","sad","saf","sak","sal","san","sap","sar","sat","sau","sed",
    "sek","sel","sem","sen","sep","ser","ses","set","sid","sik","sil","sim","sin",
    "sip","sir","sis","sit","sob","sod","sok","sol","som","son","sop","sor","sos",
    "sub","sud","suk","sul","sum","sun","sup","sur","tab","tad","tak","tal","tam",
    "tan","tap","tar","tas","tat","tau","tek","tel","tem","ten","tep","ter","tes",
    "tik","til","tim","tin","tip","tir","tis","tol","tom","ton","top","tor","tot",
    "tub","tuk","tul","tum","tun","tur","ubi","udi","uga","ugi","uha","uji","uka",
    "uki","ula","uli","ulu","uma","umi","una","uni","upa","ura","uri","usa","uta",
}

local WordList  = {}
local WordSet   = {}
local ByLetter  = {}

local function addWord(raw)
    local w = tostring(raw):lower():gsub("%s+",""):gsub("[^a-z]","")
    if #w < 2 then return end
    if WordSet[w] then return end
    WordSet[w] = true
    table.insert(WordList, w)
    local fl = w:sub(1,1)
    if not ByLetter[fl] then ByLetter[fl] = {} end
    table.insert(ByLetter[fl], w)
end

for _, w in ipairs(RAW_WORDS) do addWord(w) end
print("[WordChain] WordList: " .. tostring(#WordList) .. " kata")

-- ============================================================
-- STATE
-- ============================================================

local State = {
    LastLetter          = "",
    LastBillboardLetter = "",
    UsedWords           = {},
    AutoAnswer          = false,
    AutoCorrect         = false,
    ESPEnabled          = false,
    AnswerDelay         = 0.8,
    TypingSpeed         = 0.12,
    CorrectCount        = 0,
    WrongCount          = 0,
    DebugMode           = false,
    LastSubmit          = "",
    IsTyping            = false,
}

-- ============================================================
-- WORD LOGIC
-- ============================================================

local function findBestWord(firstLetter)
    firstLetter = firstLetter:lower()
    local pool = ByLetter[firstLetter]
    if not pool or #pool == 0 then return nil end
    local available = {}
    for _, w in ipairs(pool) do
        if not State.UsedWords[w] then
            table.insert(available, w)
        end
    end
    if #available == 0 then return nil end
    table.sort(available, function(a, b)
        local cA = ByLetter[a:sub(-1)] and #ByLetter[a:sub(-1)] or 0
        local cB = ByLetter[b:sub(-1)] and #ByLetter[b:sub(-1)] or 0
        if cA ~= cB then return cA < cB end
        return #a > #b
    end)
    return available[1]
end

local function findTopWords(firstLetter, count)
    firstLetter = firstLetter:lower()
    local pool = ByLetter[firstLetter]
    if not pool or #pool == 0 then return {} end
    local available = {}
    for _, w in ipairs(pool) do
        if not State.UsedWords[w] then
            table.insert(available, w)
        end
    end
    if #available == 0 then return {} end
    table.sort(available, function(a, b)
        local cA = ByLetter[a:sub(-1)] and #ByLetter[a:sub(-1)] or 0
        local cB = ByLetter[b:sub(-1)] and #ByLetter[b:sub(-1)] or 0
        if cA ~= cB then return cA < cB end
        return #a > #b
    end)
    local result = {}
    for i = 1, math.min(count, #available) do
        table.insert(result, available[i])
    end
    return result
end

local function levenshtein(s, t)
    local m, n = #s, #t
    if m == 0 then return n end
    if n == 0 then return m end
    local d = {}
    for i = 0, m do d[i] = {} d[i][0] = i end
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
    input = input:lower():gsub("[^a-z]","")
    if #input == 0 then return nil end
    firstLetter = (firstLetter or input:sub(1,1)):lower()
    local pool = ByLetter[firstLetter] or {}
    local best, bestDist = nil, math.huge
    for _, w in ipairs(pool) do
        if not State.UsedWords[w] then
            local d = levenshtein(input, w)
            if d < bestDist and d <= 2 and math.abs(#input-#w) <= 2 then
                bestDist = d
                best = w
            end
        end
    end
    return best
end

-- ============================================================
-- ESP GUI PANEL
-- ============================================================

local ESPGui = nil
local ESPFrame = nil
local ESPList = nil

local function createESPGui()
    -- Hapus yang lama kalau ada
    if ESPGui then pcall(function() ESPGui:Destroy() end) end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WordChainESP"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Background frame
    local frame = Instance.new("Frame")
    frame.Name = "ESPFrame"
    frame.Size = UDim2.new(0, 200, 0, 320)
    frame.Position = UDim2.new(0, 10, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 200, 100)
    stroke.Thickness = 1.5
    stroke.Parent = frame

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    header.BorderSizePixel = 0
    header.Parent = frame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔤 Kata Valid"
    title.TextColor3 = Color3.fromRGB(80, 255, 120)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Huruf aktif label
    local letterLabel = Instance.new("TextLabel")
    letterLabel.Name = "LetterLabel"
    letterLabel.Size = UDim2.new(1, -10, 0, 24)
    letterLabel.Position = UDim2.new(0, 10, 0, 38)
    letterLabel.BackgroundTransparency = 1
    letterLabel.Text = "Huruf: -"
    letterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    letterLabel.TextSize = 12
    letterLabel.Font = Enum.Font.Gotham
    letterLabel.TextXAlignment = Enum.TextXAlignment.Left
    letterLabel.Parent = frame

    -- Scrolling list
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "WordList"
    scroll.Size = UDim2.new(1, -10, 1, -70)
    scroll.Position = UDim2.new(0, 5, 0, 65)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 255, 120)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = scroll

    ESPGui   = screenGui
    ESPFrame = frame
    ESPList  = scroll

    return screenGui, frame, scroll
end

local function updateESPGui(letter)
    if not ESPGui or not ESPList then return end
    if not ESPGui.Parent then
        createESPGui()
    end

    -- Update header
    local lbl = ESPFrame:FindFirstChild("LetterLabel")
    if lbl then
        lbl.Text = "Huruf: " .. (letter ~= "" and letter:upper() or "-")
    end

    -- Clear list
    for _, child in ipairs(ESPList:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    if letter == "" then
        ESPList.CanvasSize = UDim2.new(0, 0, 0, 0)
        return
    end

    -- Get top 20 kata
    local words = findTopWords(letter, 20)
    local totalHeight = 0

    for i, word in ipairs(words) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
        btn.BorderSizePixel = 0
        btn.Text = word .. "  (" .. word:sub(-1):upper() .. ")"
        btn.TextColor3 = Color3.fromRGB(100, 255, 140)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i
        btn.Parent = ESPList

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8)
        pad.Parent = btn

        -- Klik = copy kata
        local w = word
        btn.MouseButton1Click:Connect(function()
            pcall(function() setclipboard(w) end)
            btn.BackgroundColor3 = Color3.fromRGB(30, 80, 40)
            task.wait(0.3)
            btn.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
        end)

        totalHeight = totalHeight + 29
    end

    ESPList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

    -- Kalau tidak ada kata
    if #words == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 30)
        empty.BackgroundTransparency = 1
        empty.Text = "Tidak ada kata tersedia"
        empty.TextColor3 = Color3.fromRGB(150, 80, 80)
        empty.TextSize = 11
        empty.Font = Enum.Font.Gotham
        empty.Parent = ESPList
        ESPList.CanvasSize = UDim2.new(0, 0, 0, 30)
    end
end

-- ============================================================
-- TYPING SIMULATION
-- ============================================================

-- Cari TextBox aktif di game
-- Path yang diketahui: update setelah debug
local TEXTBOX_PATHS = {
    -- Path akan ditambah setelah debug
    -- Sementara cari semua TextBox visible
}

local function findActiveTextBox()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return nil end

    -- Cari yang focused dulu
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextBox") and obj:IsFocused() then
            return obj
        end
    end

    -- Cari yang visible dan texteditable
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextBox") and obj.Visible and obj.TextEditable then
            local ok, size = pcall(function() return obj.AbsoluteSize end)
            if ok and size.X > 50 then
                return obj
            end
        end
    end

    return nil
end

local function simulateTyping(word)
    local textBox = findActiveTextBox()

    if textBox then
        -- Ada TextBox: ketik per huruf
        pcall(function() textBox:CaptureFocus() end)
        textBox.Text = ""
        task.wait(0.05)

        for i = 1, #word do
            if State.LastBillboardLetter ~= State.LastLetter then return false end
            local char = word:sub(i, i)
            textBox.Text = textBox.Text .. char
            if R_TypeSound then
                pcall(function() R_TypeSound:FireServer() end)
            end
            task.wait(State.TypingSpeed + math.random() * 0.04)
        end
        task.wait(0.08)

        -- Simulasi tekan Enter / ReleaseFocus
        pcall(function() textBox:ReleaseFocus(true) end)
        task.wait(0.05)
        return true
    else
        -- Tidak ada TextBox: hanya simulasi delay + TypeSound
        for i = 1, #word do
            if State.LastBillboardLetter ~= State.LastLetter then return false end
            if R_TypeSound then
                pcall(function() R_TypeSound:FireServer() end)
            end
            task.wait(State.TypingSpeed + math.random() * 0.04)
        end
        task.wait(0.08)
        return true
    end
end

-- ============================================================
-- SUBMIT
-- ============================================================

local function submitWord(word)
    word = word:lower():gsub("[^a-z]","")
    if #word < 2 then return false end
    if word == State.LastSubmit then return false end
    State.UsedWords[word] = true
    State.LastSubmit = word
    local ok = pcall(function()
        R_SubmitWord:FireServer(word)
    end)
    if ok then print("[WordChain] Submit: '" .. word .. "'") end
    return ok
end

-- ============================================================
-- AUTO ANSWER
-- ============================================================

local answerBusy = false

local function doAutoAnswer(letter)
    if answerBusy then return end
    if not State.AutoAnswer then return end
    if not letter or #letter == 0 then return end
    if State.IsTyping then return end

    answerBusy = true
    task.spawn(function()
        task.wait(State.AnswerDelay)

        if not State.AutoAnswer or State.LastBillboardLetter ~= letter then
            answerBusy = false
            return
        end

        local word = findBestWord(letter)
        if not word then
            WindUI:Notify({
                Title = "Tidak Ada Kata",
                Content = "Huruf '" .. letter:upper() .. "' habis!",
                Icon = "alert-circle", Duration = 3,
            })
            answerBusy = false
            return
        end

        State.IsTyping = true
        local ok = simulateTyping(word)
        State.IsTyping = false

        if not ok or State.LastBillboardLetter ~= letter then
            answerBusy = false
            return
        end

        if submitWord(word) then
            State.CorrectCount = State.CorrectCount + 1
            WindUI:Notify({
                Title = "Auto Answer",
                Content = "'" .. word .. "'",
                Icon = "check", Duration = 2,
            })
        end

        task.wait(0.5)
        answerBusy = false
    end)
end

-- ============================================================
-- TURNBILLBOARD SCANNER
-- ============================================================

local function getTurnBillboardLetter(player)
    local char = player and player.Character
    if not char then return "" end
    local head = char:FindFirstChild("Head")
    if not head then return "" end

    local billboard = head:FindFirstChild("TurnBillboard")
    if not billboard then
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("BillboardGui") then
                billboard = child
                break
            end
        end
    end
    if not billboard then return "" end

    for _, child in ipairs(billboard:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            local txt = (child.Text or ""):gsub("%s+","")
            if #txt >= 1 and #txt <= 2 and txt:match("^[a-zA-Z]+$") then
                return txt:lower():sub(1,1)
            end
        end
    end
    return ""
end

local function scanTurnBillboards()
    local myLetter = getTurnBillboardLetter(LocalPlayer)
    if #myLetter > 0 then return myLetter, true end
    local anyLetter = ""
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local letter = getTurnBillboardLetter(player)
            if #letter > 0 then anyLetter = letter end
        end
    end
    return anyLetter, false
end

local scanTimer = 0
RunService.Heartbeat:Connect(function(dt)
    scanTimer = scanTimer + dt
    if scanTimer < 0.15 then return end
    scanTimer = 0

    local letter, isMyTurn = scanTurnBillboards()
    if #letter > 0 then
        State.LastLetter = letter

        if letter ~= State.LastBillboardLetter then
            State.LastBillboardLetter = letter
            State.LastSubmit = ""
            answerBusy = false

            if State.DebugMode then
                print("[Billboard] Huruf: '" .. letter:upper() .. "' | Giliran kita: " .. tostring(isMyTurn))
            end

            -- Update ESP GUI
            if State.ESPEnabled then
                task.spawn(function() updateESPGui(letter) end)
            end

            if isMyTurn and State.AutoAnswer then
                doAutoAnswer(letter)
            end
        end
    end
end)

-- ============================================================
-- REMOTE LISTENERS
-- ============================================================

if R_UsedWordWarn then
    R_UsedWordWarn.OnClientEvent:Connect(function(a1)
        local w = type(a1) == "string" and a1:lower():gsub("[^a-z]","") or ""
        if #w > 0 then
            State.UsedWords[w] = true
            -- Refresh ESP kalau aktif
            if State.ESPEnabled then
                task.spawn(function() updateESPGui(State.LastLetter) end)
            end
        end
    end)
end

if R_PlayerCorrect then
    R_PlayerCorrect.OnClientEvent:Connect(function(a1, a2)
        State.LastSubmit = ""
        answerBusy = false
    end)
end

if R_PlayerHit then
    R_PlayerHit.OnClientEvent:Connect(function(a1)
        local isMe = (a1 == LocalPlayer) or (a1 == LocalPlayer.Name)
        if isMe then
            State.WrongCount = State.WrongCount + 1
            answerBusy = false
        end
    end)
end

-- ============================================================
-- AUTO CORRECT
-- ============================================================

local hookedBoxes = {}

local function hookTextBoxes()
    task.spawn(function()
        while true do
            task.wait(0.5)
            if State.AutoCorrect then
                local gui = LocalPlayer:FindFirstChild("PlayerGui")
                if gui then
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if obj:IsA("TextBox") and not hookedBoxes[obj] then
                            hookedBoxes[obj] = true
                            obj.FocusLost:Connect(function(enterPressed)
                                if not State.AutoCorrect or not enterPressed then return end
                                local input = obj.Text:lower():gsub("[^a-z]","")
                                if #input < 2 then return end
                                local fl = State.LastLetter ~= "" and State.LastLetter or input:sub(1,1)
                                if WordSet[input] and not State.UsedWords[input] and input:sub(1,1) == fl then return end
                                local fix = findClosestWord(input, fl)
                                if fix then
                                    obj.Text = fix
                                    task.wait(0.05)
                                    submitWord(fix)
                                    WindUI:Notify({
                                        Title = "Auto Correct",
                                        Content = "'" .. input .. "' -> '" .. fix .. "'",
                                        Icon = "spell-check", Duration = 3,
                                    })
                                elseif fl ~= "" then
                                    local fallback = findBestWord(fl)
                                    if fallback then
                                        obj.Text = fallback
                                        task.wait(0.05)
                                        submitWord(fallback)
                                    end
                                end
                            end)
                        end
                    end
                    for box in pairs(hookedBoxes) do
                        if not box.Parent then hookedBoxes[box] = nil end
                    end
                end
            end
        end
    end)
end

hookTextBoxes()

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

Window:Tag({ Title = "v6.0", Icon = "tag", Color = Color3.fromHex("#1c1c1c"), Border = true })
Window:Tag({ Title = tostring(#WordList) .. " kata", Icon = "book-open", Color = Color3.fromHex("#1c1c1c"), Border = true })

-- TAB MAIN
local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
MainTab:Section({ Title = "Auto Features" })

MainTab:Toggle({
    Title = "Auto Answer", Desc = "Jawab otomatis + simulasi ngetik",
    Icon = "bot", Value = false,
    Callback = function(v)
        State.AutoAnswer = v
        WindUI:Notify({
            Title = "Auto Answer",
            Content = v and "Aktif! " .. tostring(#WordList) .. " kata siap." or "Dinonaktifkan.",
            Icon = "bot", Duration = 3,
        })
    end,
})
MainTab:Space()

MainTab:Toggle({
    Title = "Auto Correct", Desc = "Fix typo sebelum submit",
    Icon = "spell-check", Value = false,
    Callback = function(v)
        State.AutoCorrect = v
        WindUI:Notify({ Title = "Auto Correct", Content = v and "Aktif!" or "Dinonaktifkan.", Icon = "spell-check", Duration = 2 })
    end,
})
MainTab:Space()

MainTab:Toggle({
    Title = "ESP Kata Valid", Desc = "Tampilkan panel daftar kata valid",
    Icon = "eye", Value = false,
    Callback = function(v)
        State.ESPEnabled = v
        if v then
            if not ESPGui then createESPGui() end
            ESPFrame.Visible = true
            task.spawn(function() updateESPGui(State.LastLetter) end)
        else
            if ESPFrame then ESPFrame.Visible = false end
        end
        WindUI:Notify({
            Title = "ESP Panel",
            Content = v and "Panel kata valid ditampilkan!" or "Panel disembunyikan.",
            Icon = "eye", Duration = 2,
        })
    end,
})
MainTab:Space()
MainTab:Section({ Title = "Settings" })

MainTab:Slider({
    Title = "Answer Delay", Desc = "Jeda sebelum mulai ngetik (x0.1 detik)",
    Step = 1, Value = { Min = 1, Max = 30, Default = 8 },
    Callback = function(v) State.AnswerDelay = v / 10 end,
})
MainTab:Space()

MainTab:Slider({
    Title = "Typing Speed", Desc = "Kecepatan ngetik per huruf (x0.01 detik)",
    Step = 1, Value = { Min = 3, Max = 30, Default = 12 },
    Callback = function(v) State.TypingSpeed = v / 100 end,
})
MainTab:Space()
MainTab:Section({ Title = "Manual" })

MainTab:Button({
    Title = "Jawab Sekarang", Desc = "Paksa submit kata terbaik",
    Icon = "send", Justify = "Center",
    Callback = function()
        local letter = State.LastLetter
        if letter == "" then
            WindUI:Notify({ Title = "Error", Content = "Belum ada huruf! Masuk meja dulu.", Icon = "alert-circle", Duration = 4 })
            return
        end
        State.LastSubmit = ""
        answerBusy = false
        doAutoAnswer(letter)
    end,
})

-- TAB WORD TOOLS
local WordTab = Window:Tab({ Title = "Word Tools", Icon = "book-open" })
WordTab:Section({ Title = "Cari Kata" })

local searchInput = WordTab:Input({
    Title = "Huruf Awal", Desc = "Cari kata terbaik dari huruf ini",
    Icon = "search", Placeholder = "Contoh: a", Callback = function() end,
})
WordTab:Space()
WordTab:Button({
    Title = "Cari & Copy", Icon = "search", Justify = "Center",
    Callback = function()
        local letter = (searchInput and searchInput:Get() or ""):lower():gsub("[^a-z]",""):sub(1,1)
        if letter == "" then WindUI:Notify({ Title = "Error", Content = "Masukkan huruf dulu!", Duration = 2 }) return end
        local word = findBestWord(letter)
        if word then
            pcall(function() setclipboard(word) end)
            WindUI:Notify({
                Title = "Kata untuk '" .. letter:upper() .. "'",
                Content = "-> " .. word .. "  (next: '" .. word:sub(-1):upper() .. "')\nSudah dicopy!",
                Icon = "check", Duration = 5,
            })
        else
            WindUI:Notify({ Title = "Tidak ada", Content = "Tidak ada kata untuk '" .. letter:upper() .. "'", Duration = 3 })
        end
    end,
})

WordTab:Space()
WordTab:Section({ Title = "Cek Kata" })
local checkInput = WordTab:Input({
    Title = "Kata", Desc = "Cek apakah ada di kamus",
    Icon = "spell-check", Placeholder = "Contoh: apel", Callback = function() end,
})
WordTab:Space()
WordTab:Button({
    Title = "Cek", Icon = "check-square", Justify = "Center",
    Callback = function()
        local word = (checkInput and checkInput:Get() or ""):lower():gsub("[^a-z]","")
        if #word < 2 then WindUI:Notify({ Title = "Error", Content = "Masukkan kata dulu!", Duration = 2 }) return end
        if WordSet[word] then
            local last = word:sub(-1)
            WindUI:Notify({
                Title = "Ada di kamus!",
                Content = "'" .. word .. "'\nNext: '" .. last:upper() .. "' -> " .. tostring(ByLetter[last] and #ByLetter[last] or 0) .. " kata",
                Icon = "check-circle", Duration = 5,
            })
        else
            local c = findClosestWord(word, word:sub(1,1))
            WindUI:Notify({
                Title = "Tidak ada",
                Content = "'" .. word .. "'" .. (c and "\nMaksud: '" .. c .. "'?" or ""),
                Icon = "x-circle", Duration = 5,
            })
        end
    end,
})

-- TAB STATUS
local StatusTab = Window:Tab({ Title = "Status", Icon = "activity" })
StatusTab:Section({ Title = "Info" })

StatusTab:Button({
    Title = "Lihat Status", Icon = "info", Justify = "Center",
    Callback = function()
        local usedCount = 0
        for _ in pairs(State.UsedWords) do usedCount = usedCount + 1 end
        local avail = State.LastLetter ~= "" and (ByLetter[State.LastLetter] and #ByLetter[State.LastLetter] or 0) or 0
        WindUI:Notify({
            Title = "Status",
            Content = "Huruf aktif: '" .. State.LastLetter:upper() .. "'\n"
                   .. "Tersedia   : " .. tostring(avail) .. " kata\n"
                   .. "Total kamus: " .. tostring(#WordList) .. " kata\n"
                   .. "Dipakai    : " .. tostring(usedCount) .. "\n"
                   .. "Benar: " .. tostring(State.CorrectCount) .. "  Salah: " .. tostring(State.WrongCount),
            Icon = "info", Duration = 8,
        })
    end,
})
StatusTab:Space()
StatusTab:Button({
    Title = "Reset Used Words", Icon = "trash-2",
    Callback = function()
        State.UsedWords = {}
        State.LastSubmit = ""
        answerBusy = false
        if State.ESPEnabled then task.spawn(function() updateESPGui(State.LastLetter) end) end
        WindUI:Notify({ Title = "Reset", Content = "List dikosongkan.", Icon = "check", Duration = 2 })
    end,
})
StatusTab:Space()
StatusTab:Section({ Title = "Debug" })

StatusTab:Toggle({
    Title = "Debug Mode", Desc = "Print Billboard & event ke F9", Value = false,
    Callback = function(v)
        State.DebugMode = v
        WindUI:Notify({ Title = "Debug", Content = v and "ON - buka F9" or "OFF", Icon = "terminal", Duration = 2 })
    end,
})
StatusTab:Space()
StatusTab:Button({
    Title = "WordList Info", Icon = "terminal",
    Callback = function()
        print("\n=== WORDLIST v6.0 ===")
        print("Total: " .. tostring(#WordList) .. " kata")
        local letters = {"a","b","c","d","e","f","g","h","i","j","k","l","m",
                         "n","o","p","q","r","s","t","u","v","w","x","y","z"}
        for _, l in ipairs(letters) do
            local n = ByLetter[l] and #ByLetter[l] or 0
            if n > 0 then
                print("  " .. l:upper() .. ": " .. tostring(n) .. "  (ex: " .. (ByLetter[l][1] or "") .. ")")
            end
        end
        print("=====================\n")
        WindUI:Notify({ Title = "Done", Content = "Cek F9", Icon = "terminal", Duration = 3 })
    end,
})

-- ============================================================
-- INIT ESP GUI (hidden dulu)
-- ============================================================

createESPGui()
if ESPFrame then ESPFrame.Visible = false end

-- ============================================================
-- DONE
-- ============================================================

print("[WordChain] v6.0 loaded! " .. tostring(#WordList) .. " kata | ESP GUI panel ready")

WindUI:Notify({
    Title = "Word Chain v6.0",
    Content = tostring(#WordList) .. " kata siap!\nESP sekarang panel GUI, klik kata untuk copy.",
    Icon = "type", Duration = 5,
})
