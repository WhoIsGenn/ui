-- // VilarisUi | Version : 0.3.0 | Added: Separator, SubPage, MultiColumn, PageSearch
-- // Original by VelarisUI team | Features added & integrated

local HttpService = game:GetService("HttpService") 
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService  = game:GetService("RunService")

-- Modul lokal di-inline langsung (tidak lagi loadstring/HttpGet dari GitHub).
-- 4 modul di bawah ini TETAP diambil online karena source-nya ada di domain lain
-- (fitri324.pythonanywhere.com) dan tidak disertakan di repo yang di-upload.
local function loadUrl(url) return loadstring(game:HttpGet(url))() end

local ColorModule    = (function()
    local color = {
    	-- Default
    	["Default"] = Color3.fromRGB(0, 170, 210),
    	["DefaultV2"] = Color3.fromRGB(0, 200, 255),

    	-- Basic
    	["Light"] = Color3.fromRGB(230, 230, 230),
    	["White"] = Color3.fromRGB(255, 255, 255),
    	["Black"] = Color3.fromRGB(0, 0, 0),
    	["Gray"] = Color3.fromRGB(128, 128, 128),
    	["Silver"] = Color3.fromRGB(192, 192, 192),
    	["Charcoal"] = Color3.fromRGB(54, 69, 79),
    	["Ash"] = Color3.fromRGB(178, 190, 181),
    	["Smoke"] = Color3.fromRGB(115, 130, 118),
    	["Ivory"] = Color3.fromRGB(255, 255, 240),
    	["Pearl"] = Color3.fromRGB(234, 224, 200),
    	["Platinum"] = Color3.fromRGB(229, 228, 226),
    	["Graphite"] = Color3.fromRGB(71, 71, 71),
    	["Slate"] = Color3.fromRGB(112, 128, 144),
    	["Dim Gray"] = Color3.fromRGB(105, 105, 105),

    	-- Reds/Pinks
    	["Rose"] = Color3.fromRGB(199, 21, 133),
    	["Red"] = Color3.fromRGB(183, 28, 28),
    	["Crimson"] = Color3.fromRGB(220, 20, 60),
    	["Scarlet"] = Color3.fromRGB(255, 36, 0),
    	["Burgundy"] = Color3.fromRGB(128, 0, 32),
    	["Pink"] = Color3.fromRGB(255, 192, 203),
    	["Hot Pink"] = Color3.fromRGB(255, 105, 180),
    	["Magenta"] = Color3.fromRGB(255, 0, 255),
    	["Raspberry"] = Color3.fromRGB(227, 11, 93),
    	["Cherry"] = Color3.fromRGB(222, 49, 99),
    	["Salmon"] = Color3.fromRGB(250, 128, 114),
    	["Maroon"] = Color3.fromRGB(128, 0, 0),
    	["Brick Red"] = Color3.fromRGB(203, 65, 84),
    	["Coral"] = Color3.fromRGB(255, 127, 80),
    	["Light Pink"] = Color3.fromRGB(255, 182, 193),
    	["Deep Pink"] = Color3.fromRGB(255, 20, 147),
    	["Flamingo"] = Color3.fromRGB(252, 142, 172),
    	["Blush"] = Color3.fromRGB(222, 93, 131),
    	["Ruby"] = Color3.fromRGB(155, 17, 30),
    	["Garnet"] = Color3.fromRGB(115, 54, 53),
    	["Candy Red"] = Color3.fromRGB(255, 0, 51),
    	["Rose Gold"] = Color3.fromRGB(183, 110, 121),
    	["Strawberry"] = Color3.fromRGB(252, 90, 141),
    	["Watermelon"] = Color3.fromRGB(252, 108, 133),
    	["Tomato"] = Color3.fromRGB(255, 99, 71),

    	-- Oranges/Yellows
    	["Amber"] = Color3.fromRGB(255, 140, 0),
    	["Orange"] = Color3.fromRGB(255, 165, 0),
    	["Tangerine"] = Color3.fromRGB(242, 133, 0),
    	["Gold"] = Color3.fromRGB(255, 215, 0),
    	["Yellow"] = Color3.fromRGB(255, 255, 0),
    	["Lemon"] = Color3.fromRGB(253, 233, 16),
    	["Mustard"] = Color3.fromRGB(255, 219, 88),
    	["Peach"] = Color3.fromRGB(255, 218, 185),
    	["Apricot"] = Color3.fromRGB(251, 206, 177),
    	["Pumpkin"] = Color3.fromRGB(255, 117, 24),
    	["Burnt Orange"] = Color3.fromRGB(204, 85, 0),
    	["Sunflower"] = Color3.fromRGB(255, 218, 3),
    	["Saffron"] = Color3.fromRGB(244, 196, 48),
    	["Goldenrod"] = Color3.fromRGB(218, 165, 32),
    	["Marigold"] = Color3.fromRGB(252, 192, 6),
    	["Canary"] = Color3.fromRGB(255, 239, 0),
    	["Butter"] = Color3.fromRGB(255, 243, 176),
    	["Papaya"] = Color3.fromRGB(255, 155, 85),
    	["Mango"] = Color3.fromRGB(255, 130, 67),
    	["Ochre"] = Color3.fromRGB(204, 119, 34),
    	["Honey"] = Color3.fromRGB(236, 172, 70),
    	["Carrot"] = Color3.fromRGB(237, 145, 33),
    	["Cinnamon"] = Color3.fromRGB(210, 105, 30),
    	["Champagne"] = Color3.fromRGB(247, 231, 206),

    	-- Greens
    	["Plant"] = Color3.fromRGB(34, 139, 34),
    	["Emerald"] = Color3.fromRGB(0, 150, 100),
    	["Green"] = Color3.fromRGB(0, 200, 0),
    	["Lime"] = Color3.fromRGB(50, 205, 50),
    	["Forest"] = Color3.fromRGB(34, 139, 34),
    	["Mint"] = Color3.fromRGB(152, 251, 152),
    	["Sea Green"] = Color3.fromRGB(46, 139, 87),
    	["Olive"] = Color3.fromRGB(128, 128, 0),
    	["Sage"] = Color3.fromRGB(156, 179, 127),
    	["Teal"] = Color3.fromRGB(0, 128, 128),
    	["Jade"] = Color3.fromRGB(0, 168, 107),
    	["Chartreuse"] = Color3.fromRGB(127, 255, 0),
    	["Fern"] = Color3.fromRGB(79, 121, 66),
    	["Moss"] = Color3.fromRGB(138, 154, 91),
    	["Avocado"] = Color3.fromRGB(86, 130, 3),
    	["Jungle"] = Color3.fromRGB(41, 171, 135),
    	["Pistachio"] = Color3.fromRGB(147, 197, 114),
    	["Pear"] = Color3.fromRGB(209, 226, 49),
    	["Neon Green"] = Color3.fromRGB(57, 255, 20),
    	["Spring Green"] = Color3.fromRGB(0, 255, 127),
    	["Hunter Green"] = Color3.fromRGB(53, 94, 59),
    	["Kelly Green"] = Color3.fromRGB(76, 187, 23),
    	["Grass"] = Color3.fromRGB(124, 185, 36),
    	["Bottle Green"] = Color3.fromRGB(0, 106, 78),
    	["Spearmint"] = Color3.fromRGB(0, 175, 143),
    	["Cucumber"] = Color3.fromRGB(119, 168, 72),

    	-- Blues/Cyans
    	["Indigo"] = Color3.fromRGB(63, 81, 181),
    	["Sky"] = Color3.fromRGB(0, 191, 255),
    	["Midnight"] = Color3.fromRGB(25, 42, 86),
    	["Blue"] = Color3.fromRGB(0, 0, 255),
    	["Navy"] = Color3.fromRGB(0, 0, 128),
    	["Royal Blue"] = Color3.fromRGB(65, 105, 225),
    	["Cornflower"] = Color3.fromRGB(100, 149, 237),
    	["Azure"] = Color3.fromRGB(0, 127, 255),
    	["Cyan"] = Color3.fromRGB(0, 255, 255),
    	["Turquoise"] = Color3.fromRGB(64, 224, 208),
    	["Aqua"] = Color3.fromRGB(0, 200, 200),
    	["Baby Blue"] = Color3.fromRGB(137, 207, 240),
    	["Steel Blue"] = Color3.fromRGB(70, 130, 180),
    	["Denim"] = Color3.fromRGB(21, 96, 189),
    	["Cobalt"] = Color3.fromRGB(0, 71, 171),
    	["Sapphire"] = Color3.fromRGB(15, 82, 186),
    	["Ice Blue"] = Color3.fromRGB(153, 214, 234),
    	["Powder Blue"] = Color3.fromRGB(176, 224, 230),
    	["Periwinkle"] = Color3.fromRGB(204, 204, 255),
    	["Cerulean"] = Color3.fromRGB(0, 123, 167),
    	["Ocean"] = Color3.fromRGB(0, 119, 190),
    	["Deep Blue"] = Color3.fromRGB(0, 0, 139),
    	["Electric Blue"] = Color3.fromRGB(125, 249, 255),
    	["Dodger Blue"] = Color3.fromRGB(30, 144, 255),
    	["Cadet Blue"] = Color3.fromRGB(95, 158, 160),
    	["Slate Blue"] = Color3.fromRGB(106, 90, 205),
    	["Aquamarine"] = Color3.fromRGB(127, 255, 212),
    	["Glacier"] = Color3.fromRGB(128, 183, 200),

    	-- Purples/Violets
    	["Violet"] = Color3.fromRGB(138, 43, 226),
    	["Purple"] = Color3.fromRGB(128, 0, 128),
    	["Lavender"] = Color3.fromRGB(230, 230, 250),
    	["Plum"] = Color3.fromRGB(221, 160, 221),
    	["Orchid"] = Color3.fromRGB(218, 112, 214),
    	["Mauve"] = Color3.fromRGB(224, 176, 255),
    	["Lilac"] = Color3.fromRGB(200, 162, 200),
    	["Grape"] = Color3.fromRGB(111, 45, 168),
    	["Eggplant"] = Color3.fromRGB(97, 64, 81),
    	["Amethyst"] = Color3.fromRGB(153, 102, 204),
    	["Mulberry"] = Color3.fromRGB(197, 75, 140),
    	["Thistle"] = Color3.fromRGB(216, 191, 216),
    	["Wisteria"] = Color3.fromRGB(201, 160, 220),
    	["Heliotrope"] = Color3.fromRGB(223, 115, 255),
    	["Byzantine"] = Color3.fromRGB(189, 51, 164),
    	["Deep Purple"] = Color3.fromRGB(69, 39, 160),
    	["Neon Purple"] = Color3.fromRGB(188, 19, 254),
    	["Periwinkle Purple"] = Color3.fromRGB(142, 130, 254),
    	["Boysenberry"] = Color3.fromRGB(135, 50, 96),
    	["Iris"] = Color3.fromRGB(90, 79, 207),
    	["Fuchsia"] = Color3.fromRGB(255, 0, 143),
    	["Byzantium"] = Color3.fromRGB(112, 41, 99),

    	-- Browns/Neutrals
    	["Brown"] = Color3.fromRGB(165, 42, 42),
    	["Tan"] = Color3.fromRGB(210, 180, 140),
    	["Beige"] = Color3.fromRGB(245, 245, 220),
    	["Cream"] = Color3.fromRGB(255, 253, 208),
    	["Chocolate"] = Color3.fromRGB(123, 63, 0),
    	["Coffee"] = Color3.fromRGB(111, 78, 55),
    	["Sand"] = Color3.fromRGB(194, 178, 128),
    	["Camel"] = Color3.fromRGB(193, 154, 107),
    	["Sienna"] = Color3.fromRGB(160, 82, 45),
    	["Umber"] = Color3.fromRGB(99, 81, 71),
    	["Walnut"] = Color3.fromRGB(120, 80, 60),
    	["Mahogany"] = Color3.fromRGB(192, 64, 0),
    	["Russet"] = Color3.fromRGB(128, 70, 27),
    	["Copper"] = Color3.fromRGB(184, 115, 51),
    	["Bronze"] = Color3.fromRGB(205, 127, 50),
    	["Clay"] = Color3.fromRGB(163, 99, 67),
    	["Terracotta"] = Color3.fromRGB(226, 114, 91),
    	["Mocha"] = Color3.fromRGB(150, 105, 85),
    	["Toffee"] = Color3.fromRGB(189, 139, 68),
    	["Hazel"] = Color3.fromRGB(142, 118, 72),
    	["Chestnut"] = Color3.fromRGB(149, 69, 53),
    	["Khaki"] = Color3.fromRGB(195, 176, 145),
    	["Wheat"] = Color3.fromRGB(245, 222, 179),
    	["Linen"] = Color3.fromRGB(250, 240, 230),
    	["Parchment"] = Color3.fromRGB(240, 225, 196),

    	-- Special/Unique
    	["Monokai Pro"] = Color3.fromRGB(255, 143, 96),
    	["Cotton Candy"] = Color3.fromRGB(255, 105, 180),
    	["Mellow"] = Color3.fromRGB(90, 70, 50),
    	["Neon"] = Color3.fromRGB(57, 255, 20),
    	["Pastel"] = Color3.fromRGB(209, 224, 224),
    	["Sepia"] = Color3.fromRGB(112, 66, 20),
    	["Lavender Blush"] = Color3.fromRGB(255, 240, 245),
    	["Mint Cream"] = Color3.fromRGB(245, 255, 250),
    	["Honeydew"] = Color3.fromRGB(240, 255, 240),
    	["Ghost White"] = Color3.fromRGB(248, 248, 255),
    	["Neon Pink"] = Color3.fromRGB(255, 16, 240),
    	["Neon Blue"] = Color3.fromRGB(4, 217, 255),
    	["Neon Yellow"] = Color3.fromRGB(255, 255, 51),
    	["Neon Orange"] = Color3.fromRGB(255, 95, 31),
    	["Electric Violet"] = Color3.fromRGB(143, 0, 255),
    	["Holographic"] = Color3.fromRGB(190, 220, 255),
    	["Retro Red"] = Color3.fromRGB(210, 43, 43),
    	["Retro Blue"] = Color3.fromRGB(50, 100, 168),
    	["Retrowave"] = Color3.fromRGB(255, 0, 128),
    	["Cyberpunk"] = Color3.fromRGB(255, 243, 0),
    	["Synthwave"] = Color3.fromRGB(114, 9, 183),
    	["Vaporwave"] = Color3.fromRGB(255, 113, 206),
    	["Glitch"] = Color3.fromRGB(0, 255, 159),
    	["Matrix"] = Color3.fromRGB(0, 255, 65),
    	["Hacker"] = Color3.fromRGB(0, 200, 0),
    	["Pixel"] = Color3.fromRGB(255, 85, 0),
    	["Arctic"] = Color3.fromRGB(168, 218, 220),
    	["Aurora"] = Color3.fromRGB(0, 255, 200),
    	["Galaxy"] = Color3.fromRGB(86, 11, 173),
    	["Nebula"] = Color3.fromRGB(97, 0, 178),
    	["Stardust"] = Color3.fromRGB(255, 215, 140),
    	["Cosmic"] = Color3.fromRGB(46, 0, 79),
    	["Twilight"] = Color3.fromRGB(78, 52, 130),
    	["Dusk"] = Color3.fromRGB(184, 134, 157),
    	["Dawn"] = Color3.fromRGB(255, 189, 150),
    	["Sunset"] = Color3.fromRGB(253, 94, 83),
    	["Sunrise"] = Color3.fromRGB(255, 160, 50),
    	["Moonlight"] = Color3.fromRGB(174, 185, 212),
    	["Starlight"] = Color3.fromRGB(240, 232, 196),
    	["Shadow"] = Color3.fromRGB(52, 52, 52),
    	["Obsidian"] = Color3.fromRGB(11, 11, 11),
    	["Onyx"] = Color3.fromRGB(53, 56, 57),
    	["Void"] = Color3.fromRGB(8, 8, 20),
    	["Abyss"] = Color3.fromRGB(3, 3, 15),
    	["Lava"] = Color3.fromRGB(207, 16, 32),
    	["Magma"] = Color3.fromRGB(255, 69, 0),
    	["Ash Gray"] = Color3.fromRGB(178, 190, 181),
    	["Storm"] = Color3.fromRGB(79, 99, 120),
    	["Thunder"] = Color3.fromRGB(51, 68, 92),
    	["Ice"] = Color3.fromRGB(210, 236, 255),
    	["Snow"] = Color3.fromRGB(255, 250, 250),
    	["Frost"] = Color3.fromRGB(214, 234, 248),
    	["Blizzard"] = Color3.fromRGB(185, 210, 235),
    	["Spring"] = Color3.fromRGB(160, 231, 129),
    	["Summer"] = Color3.fromRGB(255, 200, 87),
    	["Autumn"] = Color3.fromRGB(210, 105, 30),
    	["Winter"] = Color3.fromRGB(104, 157, 187),
    	["Tropical"] = Color3.fromRGB(0, 209, 178),
    	["Lagoon"] = Color3.fromRGB(38, 166, 154),
    	["Reef"] = Color3.fromRGB(0, 204, 153),
    	["Seafoam"] = Color3.fromRGB(120, 214, 175),
    	["Deep Sea"] = Color3.fromRGB(0, 50, 98),
    	["Coral Reef"] = Color3.fromRGB(255, 127, 80),
    	["Poison"] = Color3.fromRGB(100, 255, 50),
    	["Toxic"] = Color3.fromRGB(173, 255, 47),
    	["Slime"] = Color3.fromRGB(125, 200, 0),
    	["Radioactive"] = Color3.fromRGB(105, 246, 0),
    	["Blood"] = Color3.fromRGB(138, 3, 3),
    	["Rust"] = Color3.fromRGB(183, 65, 14),
    	["Patina"] = Color3.fromRGB(82, 172, 139),
    	["Verdigris"] = Color3.fromRGB(67, 179, 174),
    	["Champagne Gold"] = Color3.fromRGB(250, 214, 165),
    	["Rose Quartz"] = Color3.fromRGB(247, 183, 196),
    	["Serenity"] = Color3.fromRGB(146, 168, 209),
    	["Ultraviolet"] = Color3.fromRGB(95, 75, 139),
    	["Living Coral"] = Color3.fromRGB(255, 111, 97),
    	["Classic Blue"] = Color3.fromRGB(15, 76, 129),
    	["Illuminating"] = Color3.fromRGB(245, 223, 77),
    	["Very Peri"] = Color3.fromRGB(102, 103, 171),
    	["Viva Magenta"] = Color3.fromRGB(187, 38, 73),
    	["Peach Fuzz"] = Color3.fromRGB(255, 190, 152),
    	["Mocha Mousse"] = Color3.fromRGB(169, 126, 105),
    }
    return color
end)()
local ElementsModule = (function()
    -- // vilarisUi | Elements.lua
    -- Upgrade: CreateToggle kini support drag horizontal + scroll guard (Wind UI style)
    -- Upgrade: CreateToggle & CreateCheckbox support cfg.Icon di dalam knob/checkbox
    -- Upgrade: CreateParagraph support Thumbnail (header besar) + Image (inline kecil)
    -- Fix: Flag wajib ada untuk config save — tanpa Flag element tetap jalan tapi tidak disimpan

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Elements = {}

    local _registeredElements = {}
    Elements.Elements = _registeredElements

    local SaveConfig, ConfigData, GuiConfig, Icons
    function Elements:Initialize(config, saveFunc, configData, icons)
        GuiConfig = config
        SaveConfig = saveFunc
        ConfigData = configData
        Icons = icons
    end
    local function GetIconId(iconName)
        if not iconName or iconName == "" then return "" end
        if iconName:match("^rbxassetid://") then return iconName end
        if iconName:match("^https?://") then return iconName end
        if iconName:match("^%d+$") then return "rbxassetid://" .. iconName end
        if Icons and Icons[iconName] then return Icons[iconName] end
        local stripped = iconName:match("^[%a]+:(.+)$")
        if stripped and Icons and Icons[stripped] then return Icons[stripped] end
        return ""
    end
    function Elements:GetIconId(iconName)
        return GetIconId(iconName)
    end

    -- ══════════════════════════════════════════════════════════════
    -- Flag wajib untuk config save
    -- Kalau tidak ada Flag → return nil → skip config read/write/save
    -- ══════════════════════════════════════════════════════════════
    local function ResolveKey(cfg)
        if cfg and cfg.Flag and tostring(cfg.Flag) ~= "" then
            return tostring(cfg.Flag)
        end
        return nil
    end

    local function ReadConfig(key, default)
        if not key then return default end
        local saved = ConfigData[key]
        return saved ~= nil and saved or default
    end

    local function WriteConfig(key, value)
        if not key then return end
        ConfigData[key] = value
        SaveConfig()
    end

    local BADGE_CONFIG = {
        New = {
            Text  = "NEW",
            Color = nil,
            Pulse = "glow",
            Dot   = true,
        },
        Warning = {
            Text  = "WARNING",
            Color = Color3.fromRGB(255, 165, 0),
            Pulse = "glow",
            Dot   = true,
        },
        Bug = {
            Text  = "BUG",
            Color = Color3.fromRGB(220, 50, 50),
            Pulse = "glow",
            Dot   = true,
        },
        Fixed = {
            Text  = "FIXED",
            Color = Color3.fromRGB(50, 200, 80),
            Pulse = "none",
            Dot   = false,
        },
        Beta = {
            Text  = "BETA",
            Color = Color3.fromRGB(140, 80, 255),
            Pulse = "none",
            Dot   = false,
        },
        Hot = {
            Text  = "HOT",
            Color = Color3.fromRGB(255, 80, 80),
            Pulse = "glow",
            Dot   = true,
        },
        Soon = {
            Text  = "SOON",
            Color = Color3.fromRGB(100, 160, 255),
            Pulse = "none",
            Dot   = false,
        },
    }

    local function ApplyLock(frame, isLocked, lockMessage)
        local LockFunc = { IsLocked = isLocked == true }
        local msg = lockMessage or "Locked"
        local _destroyed = false
        local _rebuilding = false
        local LockOverlay

        local function BuildOverlay()
            if _destroyed then return end

            LockOverlay = Instance.new("TextButton")
            LockOverlay.Name = "LockOverlay"
            LockOverlay.Text = ""
            LockOverlay.Size = UDim2.new(1, 0, 1, 0)
            LockOverlay.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
            LockOverlay.BackgroundTransparency = 0.28
            LockOverlay.BorderSizePixel = 0
            LockOverlay.ZIndex = 10
            LockOverlay.AutoButtonColor = false
            LockOverlay.ClipsDescendants = false
            LockOverlay.Visible = LockFunc.IsLocked
            LockOverlay.Parent = frame
            Instance.new("UICorner", LockOverlay).CornerRadius = UDim.new(0, 6)

            local Inner = Instance.new("Frame")
            Inner.Name = "LockInner"
            Inner.AnchorPoint = Vector2.new(0.5, 0.5)
            Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
            Inner.Size = UDim2.new(0, 120, 0, 20)
            Inner.BackgroundTransparency = 1
            Inner.ClipsDescendants = false
            Inner.ZIndex = 11
            Inner.Parent = LockOverlay

            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.Padding = UDim.new(0, 7)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = Inner

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 15, 0, 15)
            LockIcon.BackgroundTransparency = 1
            LockIcon.ScaleType = Enum.ScaleType.Fit
            LockIcon.Image = "rbxassetid://134724289526879"
            LockIcon.ImageColor3 = Color3.fromRGB(235, 235, 235)
            LockIcon.ImageTransparency = 0.05
            LockIcon.LayoutOrder = 1
            LockIcon.ZIndex = 12
            LockIcon.Parent = Inner

            local LockLabel = Instance.new("TextLabel")
            LockLabel.Name = "LockLabel"
            LockLabel.Size = UDim2.new(0, 200, 0, 20)
            LockLabel.BackgroundTransparency = 1
            LockLabel.Font = Enum.Font.GothamBold
            LockLabel.Text = msg
            LockLabel.TextSize = 13
            LockLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
            LockLabel.TextTransparency = 0.05
            LockLabel.TextXAlignment = Enum.TextXAlignment.Left
            LockLabel.TextYAlignment = Enum.TextYAlignment.Center
            LockLabel.TextTruncate = Enum.TextTruncate.None
            LockLabel.TextWrapped = false
            LockLabel.LayoutOrder = 2
            LockLabel.ZIndex = 12
            LockLabel.Parent = Inner

            local function UpdateInnerSize()
                task.defer(function()
                    if not LockLabel.Parent then return end
                    local textW = math.max(40, LockLabel.TextBounds.X)
                    LockLabel.Size = UDim2.new(0, textW, 0, 20)
                    Inner.Size = UDim2.new(0, 15 + 7 + textW, 0, 20)
                end)
            end
            LockLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateInnerSize)
            UpdateInnerSize()

            LockOverlay.MouseButton1Click:Connect(function()
                if not Inner.Parent then return end
                local curW = Inner.Size.X.Offset
                TweenService:Create(Inner, TweenInfo.new(0.07, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    { Size = UDim2.new(0, curW + 8, 0, 24) }):Play()
                task.delay(0.18, function()
                    if not Inner.Parent then return end
                    TweenService:Create(Inner, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        { Size = UDim2.new(0, curW, 0, 20) }):Play()
                end)
            end)

            function LockFunc:SetMessage(text)
                msg = tostring(text or "Locked")
                LockLabel.Text = msg
                UpdateInnerSize()
            end
        end

        BuildOverlay()

        frame.DescendantRemoving:Connect(function(desc)
            if desc == LockOverlay and LockFunc.IsLocked and not _destroyed then
                if _rebuilding then return end
                _rebuilding = true
                task.defer(function()
                    BuildOverlay()
                    _rebuilding = false
                end)
            end
        end)

        frame.AncestryChanged:Connect(function(_, newParent)
            if newParent == nil then
                _destroyed = true
            end
        end)

        local function SetVisible(state)
            LockFunc.IsLocked = state
            if LockOverlay and LockOverlay.Parent then
                LockOverlay.Visible = state
            end
        end
        SetVisible(LockFunc.IsLocked)

        function LockFunc:SetLocked(state)
            SetVisible(state == true)
            if state and (not LockOverlay or not LockOverlay.Parent) then
                BuildOverlay()
            end
        end

        function LockFunc:GetLocked()
            return LockFunc.IsLocked
        end

        return LockFunc
    end

    local function CreateBadge(parent, badgeType)
        local preset = BADGE_CONFIG[badgeType]
        if not preset then
            warn("[Elements] CreateBadge: unknown type '" .. tostring(badgeType) .. "'")
            return nil
        end
        local color = preset.Color or GuiConfig.Color
        local Badge = Instance.new("Frame")
        Badge.Name = badgeType .. "Badge"
        Badge.AnchorPoint = Vector2.new(1, 0)
        Badge.Position = UDim2.new(1, -6, 0, 6)
        Badge.Size = UDim2.new(0, 10, 0, 18)
        Badge.BackgroundColor3 = color
        Badge.BackgroundTransparency = 0.78
        Badge.BorderSizePixel = 0
        Badge.ZIndex = 5
        Badge.ClipsDescendants = false
        Badge.Parent = parent
        Instance.new("UICorner", Badge).CornerRadius = UDim.new(1, 0)
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = color
        Stroke.Thickness = 1
        Stroke.Transparency = 0.5
        Stroke.Parent = Badge
        local DOT_W = preset.Dot and 14 or 0
        local BadgeText = Instance.new("TextLabel")
        BadgeText.Name = "BadgeText"
        BadgeText.BackgroundTransparency = 1
        BadgeText.Font = Enum.Font.GothamBold
        BadgeText.Text = preset.Text
        BadgeText.TextColor3 = color
        BadgeText.TextTransparency = 0.05
        BadgeText.TextSize = 9
        BadgeText.TextXAlignment = Enum.TextXAlignment.Left
        BadgeText.AnchorPoint = Vector2.new(0, 0.5)
        BadgeText.Position = UDim2.new(0, DOT_W + 6, 0.5, 0)
        BadgeText.Size = UDim2.new(1, -(DOT_W + 10), 1, 0)
        BadgeText.ZIndex = 6
        BadgeText.Parent = Badge
        if preset.Dot then
            local Dot = Instance.new("Frame")
            Dot.Name = "BadgeDot"
            Dot.Size = UDim2.new(0, 5, 0, 5)
            Dot.AnchorPoint = Vector2.new(0, 0.5)
            Dot.Position = UDim2.new(0, 6, 0.5, 0)
            Dot.BackgroundColor3 = color
            Dot.BackgroundTransparency = 0
            Dot.BorderSizePixel = 0
            Dot.ZIndex = 7
            Dot.Parent = Badge
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        end
        local function UpdateBadgeWidth()
            task.wait()
            if not BadgeText.Parent then return end
            local textW = BadgeText.TextBounds.X
            local totalW = textW + DOT_W + 14
            Badge.Size = UDim2.new(0, totalW, 0, 18)
        end
        BadgeText:GetPropertyChangedSignal("TextBounds"):Connect(UpdateBadgeWidth)
        task.defer(UpdateBadgeWidth)
        if preset.Pulse == "glow" then
            local pulseIn = TweenService:Create(Stroke,
                TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                { Transparency = 0.1 })
            local pulseOut = TweenService:Create(Stroke,
                TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                { Transparency = 0.6 })
            pulseIn.Completed:Connect(function() pulseOut:Play() end)
            pulseOut.Completed:Connect(function() pulseIn:Play() end)
            pulseIn:Play()
            local dotInst = Badge:FindFirstChild("BadgeDot")
            if dotInst then
                local dIn = TweenService:Create(dotInst,
                    TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    { BackgroundTransparency = 0.5 })
                local dOut = TweenService:Create(dotInst,
                    TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    { BackgroundTransparency = 0 })
                dIn.Completed:Connect(function() dOut:Play() end)
                dOut.Completed:Connect(function() dIn:Play() end)
                dIn:Play()
            end
        end
        return Badge
    end
    function Elements:CreateBadge(parent, badgeType)
        return CreateBadge(parent, badgeType)
    end

    local _activeTweens = {}
    local function AnimateButtonClick(button, color)
        color = color or GuiConfig.Color
        if not button:GetAttribute("_origTrans") then
            button:SetAttribute("_origTrans", button.BackgroundTransparency)
        end
        if not button:GetAttribute("_origColorR") then
            local c = button.BackgroundColor3
            button:SetAttribute("_origColorR", c.R)
            button:SetAttribute("_origColorG", c.G)
            button:SetAttribute("_origColorB", c.B)
        end
        local origTrans = button:GetAttribute("_origTrans")
        local origColor = Color3.new(
            button:GetAttribute("_origColorR"),
            button:GetAttribute("_origColorG"),
            button:GetAttribute("_origColorB")
        )
        if _activeTweens[button] then
            _activeTweens[button]:Cancel()
            _activeTweens[button] = nil
        end
        local tweenIn = TweenService:Create(button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0.7, BackgroundColor3 = color }
        )
        local tweenOut = TweenService:Create(button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = origTrans, BackgroundColor3 = origColor }
        )
        _activeTweens[button] = tweenIn
        tweenIn.Completed:Connect(function(playbackState)
            if playbackState == Enum.PlaybackState.Completed then
                _activeTweens[button] = tweenOut
                tweenOut:Play()
                tweenOut.Completed:Connect(function()
                    _activeTweens[button] = nil
                end)
            end
        end)
        tweenIn:Play()
    end

    local function SafeCall(fn, ...)
        if typeof(fn) ~= "function" then return end
        local ok, err = pcall(fn, ...)
        if not ok then warn("[Elements] Callback error:", err) end
    end

    local function RoundToFactor(value, factor)
        if factor == 0 then return value end
        return math.floor(value / factor + 0.5) * factor
    end

    -- ── Helper: pasang Unlock / SetVisible / Destroy ke semua elemen ──
    local function _attachCommon(funcTable, rootFrame)
        -- Unlock: hapus LockOverlay tanpa ubah LockFunc state
        function funcTable:Unlock()
            local lo = rootFrame:FindFirstChild("LockOverlay")
            if lo then lo:Destroy() end
        end
        -- SetVisible / GetVisible
        function funcTable:SetVisible(state)
            rootFrame.Visible = state == true
        end
        function funcTable:GetVisible()
            return rootFrame.Visible
        end
        -- Destroy: hapus elemen dari UI
        function funcTable:Destroy()
            rootFrame:Destroy()
        end
    end

    -- ============================================================
    --  CreateParagraph
    --  NEW: cfg.Thumbnail / cfg.ThumbnailSize  → gambar besar di atas teks
    --  NEW: cfg.Image     / cfg.ImageSize      → gambar kecil inline kiri teks
    -- ============================================================
    function Elements:CreateParagraph(parent, config, countItem)
        local cfg = config or {}
        cfg.Title       = cfg.Title       or "Title"
        cfg.Content     = cfg.Content     or "Content"
        cfg.Badge       = cfg.Badge       or nil
        cfg.Color       = cfg.Color       or nil
        cfg.Locked      = cfg.Locked      or false
        cfg.MediaType   = cfg.MediaType   or nil
        cfg.MediaId     = cfg.MediaId     or nil
        cfg.VideoId     = cfg.VideoId     or nil
        cfg.AutoPlay    = cfg.AutoPlay    or false
        cfg.Volume      = cfg.Volume      or 1
        -- VideoType: "rbx" (VideoFrame rbxassetid) atau "webm" (VideoFrame URL / .webm)
        -- Auto-detect dari cfg.VideoId kalau tidak di-set manual
        cfg.VideoType   = cfg.VideoType   or nil  -- akan di-resolve setelah VideoId diketahui

        -- MediaType size (ImageSize lama dipakai untuk MediaType = "Image")
        cfg.ImageSize   = cfg.ImageSize   or cfg.MediaHeight or 160
        cfg.VideoSize   = cfg.VideoSize   or cfg.MediaHeight or 160

        -- ── NEW ──────────────────────────────────────────────────
        -- Thumbnail : gambar besar di atas teks (header image)
        cfg.Thumbnail     = cfg.Thumbnail     or ""
        cfg.ThumbnailSize = cfg.ThumbnailSize or 80
        -- Image     : gambar kecil inline di kiri teks
        -- Pakai nama internal _InlineSize agar tidak bentrok dengan cfg.ImageSize (MediaType)
        local _inlineImgId   = cfg.Image     or ""
        local _inlineImgSize = cfg.ImageSize2 -- bisa override lewat ImageSize2
        if not _inlineImgSize or _inlineImgSize == 0 then
            -- kalau user pakai field "ImageSize" tapi tidak ada MediaType, anggap untuk inline
            if _inlineImgId ~= "" and not cfg.MediaType then
                _inlineImgSize = tonumber(cfg.ImageSize) or 30
                -- reset cfg.ImageSize supaya MediaType block tidak salah ukuran
                cfg.ImageSize = cfg.MediaHeight or 160
            else
                _inlineImgSize = 30
            end
        end
        -- ─────────────────────────────────────────────────────────

        local _rawVol = tonumber(cfg.Volume) or 1
        cfg.Volume = _rawVol

        -- hitung tinggi blok MediaType
        local _mediaH = 0
        if cfg.MediaType == "Image" then
            _mediaH = cfg.ImageSize
        elseif cfg.MediaType == "Video" then
            _mediaH = cfg.VideoSize
        end
        cfg.MediaHeight = _mediaH

        -- hitung tinggi blok Thumbnail
        local _thumbH = 0
        if cfg.Thumbnail and cfg.Thumbnail ~= "" then
            _thumbH = cfg.ThumbnailSize
        end

        local ParagraphFunc = {}

        -- ── Frame utama ──────────────────────────────────────────
        local Paragraph = Instance.new("Frame")
        Paragraph.Name               = "Paragraph"
        Paragraph.BorderSizePixel    = 0
        Paragraph.LayoutOrder        = countItem
        Paragraph.Size               = UDim2.new(1, 0, 0, 56)
        Paragraph.ClipsDescendants   = true
        Paragraph.Parent             = parent

        if cfg.Color then
            Paragraph.BackgroundColor3       = cfg.Color
            Paragraph.BackgroundTransparency = 0.88
            local AccentBar = Instance.new("Frame")
            AccentBar.Name                   = "AccentBar"
            AccentBar.Size                   = UDim2.new(0, 3, 1, -10)
            AccentBar.Position               = UDim2.new(0, 4, 0, 5)
            AccentBar.BackgroundColor3       = cfg.Color
            AccentBar.BackgroundTransparency = 0
            AccentBar.BorderSizePixel        = 0
            AccentBar.ZIndex                 = 2
            AccentBar.Parent                 = Paragraph
            Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)
            local AccentGlow = Instance.new("UIStroke")
            AccentGlow.Color        = cfg.Color
            AccentGlow.Thickness    = 1
            AccentGlow.Transparency = 0.55
            AccentGlow.Parent       = Paragraph
        else
            Paragraph.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
            Paragraph.BackgroundTransparency = 0.935
        end
        Instance.new("UICorner", Paragraph).CornerRadius = UDim.new(0, 8)
        if cfg.Badge then CreateBadge(Paragraph, cfg.Badge) end

        -- ── THUMBNAIL block ──────────────────────────────────────
        -- Ditampilkan sesudah MediaType (jika ada), sebelum teks
        if cfg.Thumbnail and cfg.Thumbnail ~= "" then
            local ThumbContainer = Instance.new("Frame")
            ThumbContainer.Name                   = "ThumbnailContainer"
            ThumbContainer.Position               = UDim2.new(0, 0, 0, _mediaH)
            ThumbContainer.Size                   = UDim2.new(1, 0, 0, _thumbH)
            ThumbContainer.BackgroundColor3       = Color3.fromRGB(15, 15, 15)
            ThumbContainer.BackgroundTransparency = 0.25
            ThumbContainer.BorderSizePixel        = 0
            ThumbContainer.ClipsDescendants       = true
            ThumbContainer.ZIndex                 = 2
            ThumbContainer.Parent                 = Paragraph
            Instance.new("UICorner", ThumbContainer).CornerRadius = UDim.new(0, 8)

            local ThumbImg = Instance.new("ImageLabel")
            ThumbImg.Name                   = "ThumbnailImg"
            ThumbImg.Size                   = UDim2.new(1, 0, 1, 0)
            ThumbImg.BackgroundTransparency = 1
            ThumbImg.ScaleType              = Enum.ScaleType.Crop
            ThumbImg.Image                  = cfg.Thumbnail
            ThumbImg.ZIndex                 = 3
            ThumbImg.Parent                 = ThumbContainer

            -- divider tipis pemisah antara thumbnail dan teks
            local ThumbDivider = Instance.new("Frame")
            ThumbDivider.Name                   = "ThumbnailDivider"
            ThumbDivider.Position               = UDim2.new(0, 0, 0, _mediaH + _thumbH)
            ThumbDivider.Size                   = UDim2.new(1, 0, 0, 1)
            ThumbDivider.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
            ThumbDivider.BackgroundTransparency = 0.92
            ThumbDivider.BorderSizePixel        = 0
            ThumbDivider.Parent                 = Paragraph
        end
        -- ─────────────────────────────────────────────────────────

        -- offset Y awal teks = setelah MediaType + setelah Thumbnail
        local textTopBase = _mediaH + _thumbH + ((_mediaH > 0 or _thumbH > 0) and 1 or 0)

        -- ── VIDEO / IMAGE (MediaType) block ──────────────────────
        local VideoObject  = nil
        local ThumbnailImg = nil  -- ref untuk MediaType image (bukan cfg.Thumbnail)
        local PlayOverlay  = nil
        local PlayBgRef    = nil
        local IsPlaying    = false
        local MediaContainer

        if cfg.MediaType == "Image" or cfg.MediaType == "Video" then
            MediaContainer = Instance.new("Frame")
            MediaContainer.Name                   = "MediaContainer"
            MediaContainer.Position               = UDim2.new(0, 0, 0, 0)
            MediaContainer.Size                   = UDim2.new(1, 0, 0, cfg.MediaHeight)
            MediaContainer.BackgroundColor3       = Color3.fromRGB(15, 15, 15)
            MediaContainer.BackgroundTransparency = 0.2
            MediaContainer.BorderSizePixel        = 0
            MediaContainer.ClipsDescendants       = true
            MediaContainer.ZIndex                 = 2
            MediaContainer.Parent                 = Paragraph
            Instance.new("UICorner", MediaContainer).CornerRadius = UDim.new(0, 8)

            local Divider = Instance.new("Frame")
            Divider.Name                   = "MediaDivider"
            Divider.Position               = UDim2.new(0, 0, 0, cfg.MediaHeight)
            Divider.Size                   = UDim2.new(1, 0, 0, 1)
            Divider.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
            Divider.BackgroundTransparency = 0.92
            Divider.BorderSizePixel        = 0
            Divider.Parent                 = Paragraph

            ThumbnailImg = Instance.new("ImageLabel")
            ThumbnailImg.Name                   = "MediaImg"
            ThumbnailImg.Size                   = UDim2.new(1, 0, 1, 0)
            ThumbnailImg.BackgroundTransparency = 1
            ThumbnailImg.ScaleType              = Enum.ScaleType.Crop
            ThumbnailImg.Image                  = cfg.MediaId or ""
            ThumbnailImg.Visible                = (cfg.MediaId ~= nil and cfg.MediaId ~= "")
            ThumbnailImg.Parent                 = MediaContainer

            if cfg.MediaType == "Video" then
                -- ── Auto-detect VideoType ────────────────────────────
                local _vid = cfg.VideoId or ""
                local _isWebm = cfg.VideoType == "webm"
                    or (cfg.VideoType == nil and (
                        _vid:match("%.webm$") or
                        _vid:match("%.webm%?") or
                        _vid:match("^https?://") and not _vid:match("^rbxassetid://")
                    ))
                -- ────────────────────────────────────────────────────

                VideoObject = Instance.new("VideoFrame")
                VideoObject.Name                   = "VideoFrame"
                VideoObject.Size                   = UDim2.new(1, 0, 1, 0)
                VideoObject.BackgroundTransparency = 1
                VideoObject.Video                  = _vid
                VideoObject.Volume                 = _isWebm and math.clamp((_rawVol or 1) / 100, 0, 10) or 1
                VideoObject.Visible                = false
                VideoObject.Parent                 = MediaContainer

                -- SoundBooster hanya untuk rbx (webm sudah ada audio di VideoFrame)
                local SoundBooster
                if not _isWebm then
                    SoundBooster = Instance.new("Sound")
                    SoundBooster.Name        = "SoundBooster"
                    SoundBooster.SoundId     = _vid
                    SoundBooster.Volume      = math.clamp((_rawVol or 1) / 100, 0, 10)
                    SoundBooster.Looped      = true
                    SoundBooster.RollOffMaxDistance = 0
                    SoundBooster.Parent      = MediaContainer
                end

                PlayBgRef = Instance.new("Frame")
                PlayBgRef.Name                   = "PlayBg"
                PlayBgRef.Size                   = UDim2.new(1, 0, 1, 0)
                PlayBgRef.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
                PlayBgRef.BackgroundTransparency = 0.45
                PlayBgRef.BorderSizePixel        = 0
                PlayBgRef.ZIndex                 = 4
                PlayBgRef.Parent                 = MediaContainer

                PlayOverlay = Instance.new("TextButton")
                PlayOverlay.Name                   = "PlayOverlay"
                PlayOverlay.Size                   = UDim2.new(1, 0, 1, 0)
                PlayOverlay.BackgroundTransparency = 1
                PlayOverlay.AutoButtonColor        = false
                PlayOverlay.Text                   = ""
                PlayOverlay.ZIndex                 = 5
                PlayOverlay.Parent                 = MediaContainer

                local PlayCircle = Instance.new("Frame")
                PlayCircle.Name                   = "PlayCircle"
                PlayCircle.AnchorPoint            = Vector2.new(0.5, 0.5)
                PlayCircle.Position               = UDim2.new(0.5, 0, 0.5, 0)
                PlayCircle.Size                   = UDim2.new(0, 52, 0, 52)
                PlayCircle.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
                PlayCircle.BackgroundTransparency = 0.15
                PlayCircle.BorderSizePixel        = 0
                PlayCircle.ZIndex                 = 6
                PlayCircle.Parent                 = PlayOverlay
                Instance.new("UICorner", PlayCircle).CornerRadius = UDim.new(1, 0)

                local PlayIcon = Instance.new("ImageLabel")
                PlayIcon.Name                   = "PlayIcon"
                PlayIcon.AnchorPoint            = Vector2.new(0.5, 0.5)
                PlayIcon.Position               = UDim2.new(0.5, 0, 0.5, 0)
                PlayIcon.Size                   = UDim2.new(0, 28, 0, 28)
                PlayIcon.BackgroundTransparency = 1
                PlayIcon.ScaleType              = Enum.ScaleType.Fit
                PlayIcon.Image                  = "rbxassetid://7743870813"
                PlayIcon.ImageColor3            = Color3.fromRGB(255, 255, 255)
                PlayIcon.ZIndex                 = 7
                PlayIcon.Parent                 = PlayCircle

                PlayOverlay.MouseButton1Click:Connect(function()
                    if IsPlaying then ParagraphFunc:StopVideo() else ParagraphFunc:StartVideo() end
                end)
                local VideoClickBtn = Instance.new("TextButton")
                VideoClickBtn.Name = "VideoClickBtn"
                VideoClickBtn.Size = UDim2.new(1, 0, 1, 0)
                VideoClickBtn.BackgroundTransparency = 1
                VideoClickBtn.AutoButtonColor = false
                VideoClickBtn.Text = ""
                VideoClickBtn.ZIndex = 3
                VideoClickBtn.Parent = MediaContainer
                VideoClickBtn.MouseButton1Click:Connect(function()
                    if IsPlaying then ParagraphFunc:StopVideo() else ParagraphFunc:StartVideo() end
                end)

                VideoObject.Ended:Connect(function()
                    if IsPlaying then
                        VideoObject.TimePosition = 0
                        local sb = MediaContainer and MediaContainer:FindFirstChild("SoundBooster")
                        if sb then sb.TimePosition = 0 end
                        VideoObject:Play()
                        if sb then sb:Play() end
                    end
                end)
                -- simpan flag webm agar StartVideo/StopVideo tahu
                VideoObject:SetAttribute("_isWebm", _isWebm)
            end
        end

        -- ── INLINE IMAGE block ───────────────────────────────────
        -- Gambar kecil di kiri teks; hanya aktif kalau tidak ada MediaType
        local _inlineImgW   = 0
        local _inlineImgPadL = 0
        local _inlineImgContainer = nil
        local _inlineImgLabel     = nil

        if _inlineImgId ~= "" and not cfg.MediaType then
            _inlineImgPadL = 10
            _inlineImgW    = _inlineImgSize + 8  -- gambar + gap ke teks

            _inlineImgContainer = Instance.new("Frame")
            _inlineImgContainer.Name                   = "InlineImgContainer"
            _inlineImgContainer.Position               = UDim2.new(0, _inlineImgPadL, 0, textTopBase + 8)
            _inlineImgContainer.Size                   = UDim2.new(0, _inlineImgSize, 0, _inlineImgSize)
            _inlineImgContainer.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
            _inlineImgContainer.BackgroundTransparency = 0.92
            _inlineImgContainer.BorderSizePixel        = 0
            _inlineImgContainer.ClipsDescendants       = true
            _inlineImgContainer.ZIndex                 = 2
            _inlineImgContainer.Parent                 = Paragraph
            Instance.new("UICorner", _inlineImgContainer).CornerRadius = UDim.new(0, 6)

            _inlineImgLabel = Instance.new("ImageLabel")
            _inlineImgLabel.Name                   = "InlineImg"
            _inlineImgLabel.Size                   = UDim2.new(1, 0, 1, 0)
            _inlineImgLabel.BackgroundTransparency = 1
            _inlineImgLabel.ScaleType              = Enum.ScaleType.Crop
            _inlineImgLabel.Image                  = _inlineImgId
            _inlineImgLabel.ZIndex                 = 3
            _inlineImgLabel.Parent                 = _inlineImgContainer
        end
        -- ─────────────────────────────────────────────────────────

        -- ── ICON lama (cfg.Icon) — hanya aktif kalau tidak ada cfg.Image dan tidak ada MediaType ──
        local iconSize = 0
        local iconPadL = 0
        if cfg.Icon and not cfg.MediaType and _inlineImgId == "" then
            iconSize = 36
            iconPadL = 10
            local IconContainer = Instance.new("Frame")
            IconContainer.Name                   = "IconContainer"
            IconContainer.Position               = UDim2.new(0, iconPadL, 0, textTopBase + 10)
            IconContainer.Size                   = UDim2.new(0, iconSize, 0, iconSize)
            IconContainer.BackgroundTransparency = 1
            IconContainer.Parent                 = Paragraph
            local IconImg = Instance.new("ImageLabel")
            IconImg.Name                   = "ParagraphIcon"
            IconImg.Size                   = UDim2.new(1, 0, 1, 0)
            IconImg.BackgroundTransparency = 1
            IconImg.ScaleType              = Enum.ScaleType.Fit
            IconImg.Image                  = GetIconId(cfg.Icon)
            IconImg.Parent                 = IconContainer
        end

        -- hitung posisi X teks
        local textLeft
        if cfg.MediaType then
            textLeft = cfg.Color and 14 or 10
        elseif _inlineImgId ~= "" then
            textLeft = _inlineImgPadL + _inlineImgW + 2
        elseif cfg.Icon then
            textLeft = iconPadL + iconSize + 10
        else
            textLeft = cfg.Color and 14 or 10
        end

        -- ── Title & Content labels ───────────────────────────────
        local ParagraphTitle = Instance.new("TextLabel")
        ParagraphTitle.Name                   = "ParagraphTitle"
        ParagraphTitle.Font                   = Enum.Font.GothamBold
        ParagraphTitle.Text                   = cfg.Title
        ParagraphTitle.TextColor3             = cfg.Color and cfg.Color or Color3.fromRGB(255, 255, 255)
        ParagraphTitle.TextSize               = 13
        ParagraphTitle.TextXAlignment         = Enum.TextXAlignment.Left
        ParagraphTitle.TextYAlignment         = Enum.TextYAlignment.Top
        ParagraphTitle.BackgroundTransparency = 1
        ParagraphTitle.Position               = UDim2.new(0, textLeft, 0, textTopBase + 10)
        ParagraphTitle.Size                   = UDim2.new(1, -(textLeft + 10), 0, 15)
        ParagraphTitle.TextWrapped            = false
        ParagraphTitle.Parent                 = Paragraph

        local ParagraphContent = Instance.new("TextLabel")
        ParagraphContent.Name                   = "ParagraphContent"
        ParagraphContent.Font                   = Enum.Font.GothamBold
        ParagraphContent.Text                   = cfg.Content
        ParagraphContent.TextColor3             = Color3.fromRGB(255, 255, 255)
        ParagraphContent.TextSize               = 11
        ParagraphContent.TextTransparency       = cfg.Color and 0.25 or 0.45
        ParagraphContent.TextXAlignment         = Enum.TextXAlignment.Left
        ParagraphContent.TextYAlignment         = Enum.TextYAlignment.Top
        ParagraphContent.BackgroundTransparency = 1
        ParagraphContent.Position               = UDim2.new(0, textLeft, 0, textTopBase + 27)
        ParagraphContent.Size                   = UDim2.new(1, -(textLeft + 10), 0, 12)
        ParagraphContent.TextWrapped            = true
        ParagraphContent.RichText               = true
        ParagraphContent.Parent                 = Paragraph

        -- ── Buttons (opsional) ───────────────────────────────────
        local btnBgColor = cfg.ButtonColor    or Color3.fromRGB(255, 255, 255)
        local subBgColor = cfg.SubButtonColor or Color3.fromRGB(255, 255, 255)
        local btnBgTrans = cfg.ButtonColor    and 0.15 or 0.85
        local subBgTrans = cfg.SubButtonColor and 0.15 or 0.85
        local ParagraphButton, ParagraphSubButton

        if cfg.ButtonText then
            local hasSubBtn = cfg.SubButtonText ~= nil
            ParagraphButton = Instance.new("TextButton")
            ParagraphButton.Name                   = "ParagraphButton"
            ParagraphButton.BackgroundColor3       = btnBgColor
            ParagraphButton.BackgroundTransparency = btnBgTrans
            ParagraphButton.Font                   = Enum.Font.GothamBold
            ParagraphButton.TextSize               = 12
            ParagraphButton.TextColor3             = Color3.fromRGB(255, 255, 255)
            ParagraphButton.TextTransparency       = 0
            ParagraphButton.Text                   = cfg.ButtonText
            ParagraphButton.Size                   = hasSubBtn and UDim2.new(0.5, -13, 0, 28) or UDim2.new(1, -16, 0, 28)
            ParagraphButton.Position               = UDim2.new(0, 8, 0, 0)
            ParagraphButton.AutoButtonColor        = false
            ParagraphButton.Parent                 = Paragraph
            Instance.new("UICorner", ParagraphButton).CornerRadius = UDim.new(0, 6)
            ParagraphButton.MouseButton1Click:Connect(function()
                AnimateButtonClick(ParagraphButton, btnBgColor)
                SafeCall(cfg.ButtonCallback)
            end)

            if hasSubBtn then
                ParagraphSubButton = Instance.new("TextButton")
                ParagraphSubButton.Name                   = "ParagraphSubButton"
                ParagraphSubButton.BackgroundColor3       = subBgColor
                ParagraphSubButton.BackgroundTransparency = subBgTrans
                ParagraphSubButton.Font                   = Enum.Font.GothamBold
                ParagraphSubButton.TextSize               = 12
                ParagraphSubButton.TextColor3             = Color3.fromRGB(255, 255, 255)
                ParagraphSubButton.TextTransparency       = 0
                ParagraphSubButton.Text                   = cfg.SubButtonText
                ParagraphSubButton.Size                   = UDim2.new(0.5, -13, 0, 28)
                ParagraphSubButton.Position               = UDim2.new(0.5, 5, 0, 0)
                ParagraphSubButton.AutoButtonColor        = false
                ParagraphSubButton.Parent                 = Paragraph
                Instance.new("UICorner", ParagraphSubButton).CornerRadius = UDim.new(0, 6)
                ParagraphSubButton.MouseButton1Click:Connect(function()
                    AnimateButtonClick(ParagraphSubButton, subBgColor)
                    SafeCall(cfg.SubButtonCallback)
                end)
            end
        end

        -- ── UpdateSize ───────────────────────────────────────────
        -- Pastikan tinggi frame cukup untuk InlineImg agar tidak terpotong
        local function MinHeightFromInlineImg()
            if _inlineImgId ~= "" and not cfg.MediaType then
                return textTopBase + _inlineImgSize + 16
            end
            return 0
        end

        local function UpdateSize()
            task.wait()
            local contentH = math.max(12, ParagraphContent.TextBounds.Y)
            ParagraphContent.Size = UDim2.new(1, -(textLeft + 10), 0, contentH)
            local textBottom = textTopBase + 10 + 15 + 2 + contentH + 8
            local totalH = math.max(textBottom, MinHeightFromInlineImg())
            if ParagraphButton then
                ParagraphButton.Position = UDim2.new(0, 8, 0, totalH)
                if ParagraphSubButton then
                    ParagraphSubButton.Position = UDim2.new(0.5, 5, 0, totalH)
                end
                totalH = totalH + 28 + 8
            end
            Paragraph.Size = UDim2.new(1, 0, 0, totalH)
        end
        UpdateSize()
        ParagraphContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
        ParagraphContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)
        Paragraph:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSize)

        local LockFunc = ApplyLock(Paragraph, cfg.Locked)

        -- ── Video methods ────────────────────────────────────────
        function ParagraphFunc:StartVideo()
            if not VideoObject then return end
            if IsPlaying then return end
            IsPlaying = true
            local _webm = VideoObject:GetAttribute("_isWebm")
            if ThumbnailImg then ThumbnailImg.Visible = false end
            VideoObject.Visible = true
            local resumePos = VideoObject.TimePosition
            VideoObject:Play()
            if resumePos > 0 then VideoObject.TimePosition = resumePos end
            -- SoundBooster hanya untuk rbx
            if not _webm then
                local sb = MediaContainer and MediaContainer:FindFirstChild("SoundBooster")
                if sb then sb.TimePosition = resumePos; sb:Play() end
            end
            if PlayBgRef then TweenService:Create(PlayBgRef, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play() end
            if PlayOverlay then PlayOverlay.Visible = false end
        end

        function ParagraphFunc:StopVideo()
            if not VideoObject then return end
            if not IsPlaying then return end
            IsPlaying = false
            local _webm = VideoObject:GetAttribute("_isWebm")
            VideoObject:Pause()
            if not _webm then
                local sb = MediaContainer and MediaContainer:FindFirstChild("SoundBooster")
                if sb then sb:Pause() end
            end
            if PlayBgRef then PlayBgRef.BackgroundTransparency = 1 end
            if PlayOverlay then PlayOverlay.Visible = false end
        end

        function ParagraphFunc:SetMedia(mediaType, mediaId, videoId, videoType)
            if not ThumbnailImg then return end
            if IsPlaying then ParagraphFunc:StopVideo() end
            ThumbnailImg.Image = mediaId or ""
            ThumbnailImg.Visible = (mediaId ~= nil and mediaId ~= "")
            if VideoObject then
                local _vid = videoId or ""
                VideoObject.Video = _vid
                local _isWebm = videoType == "webm"
                    or (videoType == nil and (
                        _vid:match("%.webm$") or
                        _vid:match("%.webm%?") or
                        (_vid:match("^https?://") and not _vid:match("^rbxassetid://"))
                    ))
                VideoObject:SetAttribute("_isWebm", _isWebm)
                -- update SoundBooster SoundId kalau rbx
                if not _isWebm then
                    local sb = MediaContainer and MediaContainer:FindFirstChild("SoundBooster")
                    if sb then sb.SoundId = _vid end
                end
            end
            cfg.MediaType = mediaType; cfg.MediaId = mediaId; cfg.VideoId = videoId
        end

        function ParagraphFunc:IsVideoPlaying() return IsPlaying end

        -- ── NEW: runtime set Thumbnail & Image ───────────────────
        function ParagraphFunc:SetThumbnail(imageId)
            local tc = Paragraph:FindFirstChild("ThumbnailContainer")
            if tc then
                local img = tc:FindFirstChild("ThumbnailImg")
                if img then img.Image = tostring(imageId or "") end
            end
            cfg.Thumbnail = tostring(imageId or "")
        end

        function ParagraphFunc:SetImage(imageId)
            if _inlineImgLabel then
                _inlineImgLabel.Image = tostring(imageId or "")
            end
            _inlineImgId = tostring(imageId or "")
        end
        -- ─────────────────────────────────────────────────────────

        function ParagraphFunc:SetContent(content) ParagraphContent.Text = tostring(content or "Content"); UpdateSize() end
        function ParagraphFunc:SetTitle(title) ParagraphTitle.Text = tostring(title or "Title") end
        function ParagraphFunc:GetContent() return ParagraphContent.Text end
        function ParagraphFunc:GetTitle() return ParagraphTitle.Text end
        function ParagraphFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function ParagraphFunc:GetLocked() return LockFunc:GetLocked() end
        function ParagraphFunc:SetLockMessage(text) LockFunc:SetMessage(text) end

        if cfg.AutoPlay and cfg.MediaType == "Video" then
            task.defer(function() ParagraphFunc:StartVideo() end)
        end

        _attachCommon(ParagraphFunc, Paragraph)
        return ParagraphFunc
    end

    function Elements:CreateEditableParagraph(parent, config, countItem)
        local cfg = config or {}
        cfg.Title       = cfg.Title       or "Title"
        cfg.Content     = cfg.Content     or "Type here..."
        cfg.Placeholder = cfg.Placeholder or "Type something..."
        cfg.Callback    = cfg.Callback    or function() end
        cfg.Default     = cfg.Default     or ""
        cfg.Badge       = cfg.Badge       or nil
        cfg.Locked      = cfg.Locked      or false
        local configKey = ResolveKey(cfg)
        cfg.Default = ReadConfig(configKey, cfg.Default)
        local ParagraphFunc = { Value = cfg.Default }
        local Paragraph        = Instance.new("Frame")
        local UICorner         = Instance.new("UICorner")
        local ParagraphTitle   = Instance.new("TextLabel")
        local TextBoxFrame     = Instance.new("Frame")
        local TextBoxCorner    = Instance.new("UICorner")
        local ParagraphTextBox = Instance.new("TextBox")
        Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Paragraph.BackgroundTransparency = 0.935
        Paragraph.BorderSizePixel = 0
        Paragraph.LayoutOrder = countItem
        Paragraph.Size = UDim2.new(1, 0, 0, 80)
        Paragraph.Name = "EditableParagraph"
        Paragraph.Parent = parent
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Paragraph
        if cfg.Badge then CreateBadge(Paragraph, cfg.Badge) end
        local iconOffset = 10
        if cfg.Icon then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.new(0, 20, 0, 20)
            IconImg.Position = UDim2.new(0, 8, 0, 10)
            IconImg.BackgroundTransparency = 1
            IconImg.Name = "ParagraphIcon"
            IconImg.Image = GetIconId(cfg.Icon)
            IconImg.Parent = Paragraph
            iconOffset = 35
        end
        ParagraphTitle.Font = Enum.Font.GothamBold
        ParagraphTitle.Text = cfg.Title
        ParagraphTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
        ParagraphTitle.TextSize = 13
        ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
        ParagraphTitle.BackgroundTransparency = 1
        ParagraphTitle.Position = UDim2.new(0, iconOffset, 0, 10)
        ParagraphTitle.Size = UDim2.new(1, -iconOffset - 10, 0, 13)
        ParagraphTitle.Name = "ParagraphTitle"
        ParagraphTitle.Parent = Paragraph
        TextBoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBoxFrame.BackgroundTransparency = 0.95
        TextBoxFrame.BorderSizePixel = 0
        TextBoxFrame.Position = UDim2.new(0, 10, 0, 30)
        TextBoxFrame.Size = UDim2.new(1, -20, 0, 40)
        TextBoxFrame.Name = "TextBoxFrame"
        TextBoxFrame.Parent = Paragraph
        TextBoxCorner.CornerRadius = UDim.new(0, 4)
        TextBoxCorner.Parent = TextBoxFrame
        ParagraphTextBox.Font = Enum.Font.Gotham
        ParagraphTextBox.PlaceholderText = cfg.Placeholder
        ParagraphTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        ParagraphTextBox.Text = cfg.Default
        ParagraphTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        ParagraphTextBox.TextSize = 12
        ParagraphTextBox.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphTextBox.TextYAlignment = Enum.TextYAlignment.Top
        ParagraphTextBox.BackgroundTransparency = 1
        ParagraphTextBox.Position = UDim2.new(0, 8, 0, 6)
        ParagraphTextBox.Size = UDim2.new(1, -16, 1, -12)
        ParagraphTextBox.Name = "ParagraphTextBox"
        ParagraphTextBox.TextWrapped = true
        ParagraphTextBox.MultiLine = true
        ParagraphTextBox.ClearTextOnFocus = false
        ParagraphTextBox.RichText = false
        ParagraphTextBox.Parent = TextBoxFrame
        local ParagraphButton
        if cfg.ButtonText then
            ParagraphButton = Instance.new("TextButton")
            ParagraphButton.Size = UDim2.new(1, -20, 0, 28)
            ParagraphButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ParagraphButton.BackgroundTransparency = 0.935
            ParagraphButton.Font = Enum.Font.GothamBold
            ParagraphButton.TextSize = 12
            ParagraphButton.TextTransparency = 0.3
            ParagraphButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ParagraphButton.Text = cfg.ButtonText
            ParagraphButton.Position = UDim2.new(0, 10, 0, 75)
            ParagraphButton.AutoButtonColor = false
            ParagraphButton.Parent = Paragraph
            Instance.new("UICorner", ParagraphButton).CornerRadius = UDim.new(0, 6)
            ParagraphButton.MouseButton1Click:Connect(function()
                AnimateButtonClick(ParagraphButton)
                SafeCall(cfg.ButtonCallback, ParagraphTextBox.Text)
            end)
        end
        local function UpdateSize()
            local textHeight = math.max(40, ParagraphTextBox.TextBounds.Y + 12)
            TextBoxFrame.Size = UDim2.new(1, -20, 0, textHeight)
            local totalHeight = 30 + textHeight + 10
            if ParagraphButton then
                ParagraphButton.Position = UDim2.new(0, 10, 0, 30 + textHeight + 5)
                totalHeight = totalHeight + ParagraphButton.Size.Y.Offset + 10
            end
            Paragraph.Size = UDim2.new(1, 0, 0, totalHeight)
        end
        UpdateSize()
        ParagraphTextBox:GetPropertyChangedSignal("Text"):Connect(function()
            UpdateSize()
            ParagraphFunc.Value = ParagraphTextBox.Text
            WriteConfig(configKey, ParagraphTextBox.Text)
            SafeCall(cfg.Callback, ParagraphTextBox.Text)
        end)
        ParagraphTextBox:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)
        Paragraph:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSize)
        local LockFunc = ApplyLock(Paragraph, cfg.Locked)
        function ParagraphFunc:SetContent(content) ParagraphTextBox.Text = tostring(content or ""); ParagraphFunc.Value = ParagraphTextBox.Text; UpdateSize() end
        function ParagraphFunc:GetContent() return ParagraphTextBox.Text end
        function ParagraphFunc:SetTitle(title) ParagraphTitle.Text = tostring(title or "Title") end
        function ParagraphFunc:GetTitle() return ParagraphTitle.Text end
        function ParagraphFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function ParagraphFunc:GetLocked() return LockFunc:GetLocked() end
        function ParagraphFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
        _attachCommon(ParagraphFunc, Paragraph)
        return ParagraphFunc
    end

    function Elements:CreatePanel(parent, config, countItem)
        local cfg = config or {}
        cfg.Title             = cfg.Title          or "Title"
        cfg.Content           = cfg.Content        or ""
        cfg.Placeholder       = cfg.Placeholder    or nil
        cfg.Default           = cfg.Default        or ""
        cfg.ButtonText        = cfg.Button         or cfg.ButtonText     or "Confirm"
        cfg.ButtonCallback    = cfg.Callback       or cfg.ButtonCallback  or function() end
        cfg.SubButtonText     = cfg.SubButton      or cfg.SubButtonText   or nil
        cfg.SubButtonCallback = cfg.SubCallback    or cfg.SubButtonCallback or function() end
        cfg.Badge             = cfg.Badge          or nil
        cfg.Locked            = cfg.Locked         or false
        local configKey = ResolveKey(cfg)
        cfg.Default = ReadConfig(configKey, cfg.Default)
        local PanelFunc = { Value = cfg.Default }
        local baseHeight = 50
        if cfg.Placeholder then baseHeight = baseHeight + 40 end
        if cfg.SubButtonText then baseHeight = baseHeight + 40 else baseHeight = baseHeight + 36 end
        local Panel = Instance.new("Frame")
        Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Panel.BackgroundTransparency = 0.935
        Panel.Size = UDim2.new(1, 0, 0, baseHeight)
        Panel.LayoutOrder = countItem
        Panel.Parent = parent
        Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 4)
        if cfg.Badge then CreateBadge(Panel, cfg.Badge) end
        local Title = Instance.new("TextLabel")
        Title.Font = Enum.Font.GothamBold
        Title.Text = cfg.Title
        Title.TextSize = 13
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.Size = UDim2.new(1, -20, 0, 13)
        Title.Parent = Panel
        local Content = Instance.new("TextLabel")
        Content.Font = Enum.Font.Gotham
        Content.Text = cfg.Content
        Content.TextSize = 12
        Content.TextColor3 = Color3.fromRGB(255, 255, 255)
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.BackgroundTransparency = 1
        Content.RichText = true
        Content.TextWrapped = true
        Content.Position = UDim2.new(0, 10, 0, 28)
        Content.Size = UDim2.new(1, -20, 0, 14)
        Content.Parent = Panel
        local InputBox
        local InputFrameRef
        if cfg.Placeholder then
            InputFrameRef = Instance.new("Frame")
            InputFrameRef.AnchorPoint = Vector2.new(0.5, 0)
            InputFrameRef.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InputFrameRef.BackgroundTransparency = 0.95
            InputFrameRef.Size = UDim2.new(1, -20, 0, 30)
            InputFrameRef.Name = "InputFrame"
            InputFrameRef.Parent = Panel
            Instance.new("UICorner", InputFrameRef).CornerRadius = UDim.new(0, 4)
            InputBox = Instance.new("TextBox")
            InputBox.Font = Enum.Font.GothamBold
            InputBox.PlaceholderText = cfg.Placeholder
            InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            InputBox.Text = cfg.Default
            InputBox.TextSize = 11
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.BackgroundTransparency = 1
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.Size = UDim2.new(1, -10, 1, -6)
            InputBox.Position = UDim2.new(0, 5, 0, 3)
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = InputFrameRef
        end
        local ButtonMain = Instance.new("TextButton")
        ButtonMain.Font = Enum.Font.GothamBold
        ButtonMain.Text = cfg.ButtonText
        ButtonMain.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonMain.TextSize = 12
        ButtonMain.TextTransparency = 0.3
        ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ButtonMain.BackgroundTransparency = 0.935
        ButtonMain.Size = cfg.SubButtonText and UDim2.new(0.5, -12, 0, 30) or UDim2.new(1, -20, 0, 30)
        ButtonMain.AutoButtonColor = false
        ButtonMain.Parent = Panel
        Instance.new("UICorner", ButtonMain).CornerRadius = UDim.new(0, 6)
        local SubButton
        if cfg.SubButtonText then
            SubButton = Instance.new("TextButton")
            SubButton.Font = Enum.Font.GothamBold
            SubButton.Text = cfg.SubButtonText
            SubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SubButton.TextSize = 12
            SubButton.TextTransparency = 0.3
            SubButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SubButton.BackgroundTransparency = 0.935
            SubButton.Size = UDim2.new(0.5, -12, 0, 30)
            SubButton.AutoButtonColor = false
            SubButton.Parent = Panel
            Instance.new("UICorner", SubButton).CornerRadius = UDim.new(0, 6)
            SubButton.MouseButton1Click:Connect(function()
                AnimateButtonClick(SubButton)
                local inputVal = InputBox and InputBox.Text or ""
                SafeCall(cfg.SubButtonCallback, inputVal)
            end)
        end
        local function UpdatePanelLayout()
            task.wait()
            local contentH = math.max(14, Content.TextBounds.Y)
            Content.Size = UDim2.new(1, -20, 0, contentH)
            local afterContent = 28 + contentH + 6
            if InputFrameRef then
                InputFrameRef.Position = UDim2.new(0.5, 0, 0, afterContent)
                afterContent = afterContent + 30 + 6
            end
            ButtonMain.Position = UDim2.new(0, 10, 0, afterContent)
            if SubButton then SubButton.Position = UDim2.new(0.5, 2, 0, afterContent) end
            Panel.Size = UDim2.new(1, 0, 0, afterContent + 30 + 8)
        end
        UpdatePanelLayout()
        Content:GetPropertyChangedSignal("TextBounds"):Connect(UpdatePanelLayout)
        Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdatePanelLayout)
        ButtonMain.MouseButton1Click:Connect(function()
            AnimateButtonClick(ButtonMain)
            local inputVal = InputBox and InputBox.Text or ""
            PanelFunc.Value = inputVal
            SafeCall(cfg.ButtonCallback, inputVal)
        end)
        if InputBox then
            InputBox.FocusLost:Connect(function()
                PanelFunc.Value = InputBox.Text
                WriteConfig(configKey, InputBox.Text)
            end)
        end
        local LockFunc = ApplyLock(Panel, cfg.Locked)
        function PanelFunc:GetInput() return InputBox and InputBox.Text or "" end
        function PanelFunc:GetValue() return PanelFunc.Value end
        function PanelFunc:SetContent(text) Content.Text = tostring(text or "") end
        function PanelFunc:SetTitle(text) Title.Text = tostring(text or "Title") end
        function PanelFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function PanelFunc:GetLocked() return LockFunc:GetLocked() end
        function PanelFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
        _attachCommon(PanelFunc, Panel)
        return PanelFunc
    end

    function Elements:CreateButton(parent, config, countItem)
        local cfg = config or {}
        cfg.Title       = cfg.Title       or "Confirm"
        cfg.Content     = cfg.Content     or ""
        cfg.Callback    = cfg.Callback    or function() end
        cfg.SubTitle    = cfg.SubTitle    or nil
        cfg.SubContent  = cfg.SubContent  or ""
        cfg.SubCallback = cfg.SubCallback or function() end
        cfg.SubIcon     = cfg.SubIcon     or nil
        cfg.Badge       = cfg.Badge       or nil
        cfg.Version     = (cfg.Icon and cfg.Icon ~= "") and "V2" or (cfg.Version or "V1")
        cfg.Locked      = cfg.Locked      or false
        local ButtonFunc = {}
        if cfg.Version == "V2" then
            local hasContent = cfg.Content ~= ""
            local hasDual    = cfg.SubTitle ~= nil
            local infoH      = hasContent and 56 or 40
            local totalH     = hasDual and (infoH + 38) or infoH
            local Button = Instance.new("Frame")
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 0.935
            Button.BorderSizePixel = 0
            Button.LayoutOrder = countItem
            Button.Size = UDim2.new(1, 0, 0, totalH)
            Button.Name = "ButtonV2"
            Button.ClipsDescendants = false
            Button.Parent = parent
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            if cfg.Badge then CreateBadge(Button, cfg.Badge) end
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = cfg.Title
            TitleLabel.TextSize = 13
            TitleLabel.TextColor3 = Color3.fromRGB(231, 231, 231)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextYAlignment = Enum.TextYAlignment.Top
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Name = "ButtonTitle"
            TitleLabel.Parent = Button
            if hasContent then
                TitleLabel.Position = UDim2.new(0, 12, 0, 10)
                TitleLabel.Size     = UDim2.new(1, -60, 0, 15)
            else
                TitleLabel.Position = UDim2.new(0, 12, 0, (infoH - 15) / 2)
                TitleLabel.Size     = UDim2.new(1, -60, 0, 15)
            end
            local ContentLabel
            if hasContent then
                ContentLabel = Instance.new("TextLabel")
                ContentLabel.Font = Enum.Font.GothamBold
                ContentLabel.Text = cfg.Content
                ContentLabel.TextSize = 11
                ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ContentLabel.TextTransparency = 0.45
                ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
                ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
                ContentLabel.BackgroundTransparency = 1
                ContentLabel.Position = UDim2.new(0, 12, 0, 28)
                ContentLabel.Size = UDim2.new(1, -60, 0, 14)
                ContentLabel.TextWrapped = true
                ContentLabel.RichText = true
                ContentLabel.Name = "ButtonContent"
                ContentLabel.Parent = Button
                local function _resizeContent()
                    ContentLabel.TextWrapped = false
                    local lines = ContentLabel.TextBounds.X // math.max(1, ContentLabel.AbsoluteSize.X)
                    ContentLabel.Size = UDim2.new(1, -60, 0, 12 + 12 * lines)
                    local newInfoH = ContentLabel.AbsoluteSize.Y + 42
                    Button.Size = UDim2.new(1, 0, 0, hasDual and (newInfoH + 38) or newInfoH)
                    local dr = Button:FindFirstChild("DualRow")
                    local dd = Button:FindFirstChild("DualDivider")
                    if dr then dr.Position = UDim2.new(0, 8, 0, newInfoH + 4) end
                    if dd then dd.Position = UDim2.new(0, 8, 0, newInfoH) end
                    ContentLabel.TextWrapped = true
                end
                ContentLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(_resizeContent)
            end
            local IconImg
            if cfg.Icon then
                IconImg = Instance.new("ImageLabel")
                IconImg.AnchorPoint = Vector2.new(1, 0)
                IconImg.Position    = UDim2.new(1, -10, 0, (infoH - 20) / 2)
                IconImg.Size        = UDim2.new(0, 20, 0, 20)
                IconImg.BackgroundTransparency = 1
                IconImg.ScaleType   = Enum.ScaleType.Fit
                IconImg.Image       = GetIconId(cfg.Icon)
                IconImg.ImageColor3 = Color3.fromRGB(220, 220, 220)
                IconImg.ImageTransparency = 0.2
                IconImg.Name        = "IconImg"
                IconImg.Parent      = Button
            else
                local ChevronFrame = Instance.new("Frame")
                ChevronFrame.Name  = "IconImg"
                ChevronFrame.AnchorPoint = Vector2.new(1, 0)
                ChevronFrame.Position    = UDim2.new(1, -12, 0, (infoH - 16) / 2)
                ChevronFrame.Size        = UDim2.new(0, 16, 0, 16)
                ChevronFrame.BackgroundTransparency = 1
                ChevronFrame.Parent = Button
                local LineTop = Instance.new("Frame")
                LineTop.Size = UDim2.new(0, 6, 0, 2); LineTop.Position = UDim2.new(0, 2, 0, 4)
                LineTop.Rotation = 45; LineTop.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                LineTop.BackgroundTransparency = 0.2; LineTop.BorderSizePixel = 0; LineTop.Parent = ChevronFrame
                Instance.new("UICorner", LineTop).CornerRadius = UDim.new(1, 0)
                local LineBot = Instance.new("Frame")
                LineBot.Size = UDim2.new(0, 6, 0, 2); LineBot.Position = UDim2.new(0, 2, 0, 9)
                LineBot.Rotation = -45; LineBot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                LineBot.BackgroundTransparency = 0.2; LineBot.BorderSizePixel = 0; LineBot.Parent = ChevronFrame
                Instance.new("UICorner", LineBot).CornerRadius = UDim.new(1, 0)
                IconImg = ChevronFrame
            end
            -- ── Dual row ──────────────────────────────────────────
            local MainBtnV2, SubBtnV2
            if hasDual then
                local DualDivider = Instance.new("Frame")
                DualDivider.Name = "DualDivider"
                DualDivider.Size = UDim2.new(1, -16, 0, 1)
                DualDivider.Position = UDim2.new(0, 8, 0, infoH)
                DualDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DualDivider.BackgroundTransparency = 0.88
                DualDivider.BorderSizePixel = 0
                DualDivider.Parent = Button
                local DualRow = Instance.new("Frame")
                DualRow.Name = "DualRow"
                DualRow.BackgroundTransparency = 1
                DualRow.Position = UDim2.new(0, 8, 0, infoH + 4)
                DualRow.Size = UDim2.new(1, -16, 0, 30)
                DualRow.Parent = Button
                -- ── helper buat isi satu tombol dual ─────────────
                local function _makeDualBtn(parent, text, content, iconId, isSolid, posX, sizeW)
                    local hasC = content and content ~= ""
                    local hasI = iconId and iconId ~= ""
                    local btn  = Instance.new("TextButton")
                    btn.Font               = Enum.Font.GothamBold
                    btn.Text               = ""   -- teks pakai Label di dalam
                    btn.BackgroundColor3   = isSolid and GuiConfig.Color or Color3.fromRGB(255, 255, 255)
                    btn.BackgroundTransparency = isSolid and 0.1 or 0.92
                    btn.Size               = UDim2.new(sizeW, (sizeW == 1 and -16 or -3), 1, 0)
                    btn.Position           = UDim2.new(posX, posX == 0 and 0 or 3, 0, 0)
                    btn.AutoButtonColor    = false
                    btn.ClipsDescendants   = true
                    btn.Parent             = parent
                    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

                    if not isSolid then
                        local st = Instance.new("UIStroke")
                        st.Color        = Color3.fromRGB(255, 255, 255)
                        st.Thickness    = 1
                        st.Transparency = 0.75
                        st.Name         = "BtnStroke"
                        st.Parent       = btn
                        btn.MouseEnter:Connect(function()
                            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.82 }):Play()
                            TweenService:Create(st,  TweenInfo.new(0.15), { Transparency = 0.5 }):Play()
                        end)
                        btn.MouseLeave:Connect(function()
                            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.92 }):Play()
                            TweenService:Create(st,  TweenInfo.new(0.15), { Transparency = 0.75 }):Play()
                        end)
                    else
                        btn.MouseEnter:Connect(function()
                            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
                        end)
                        btn.MouseLeave:Connect(function()
                            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.1 }):Play()
                        end)
                    end

                    -- icon di kiri (dalam tombol)
                    local iconW = 0
                    if hasI then
                        iconW = 18
                        local ic = Instance.new("ImageLabel")
                        ic.Name               = "BtnIcon"
                        ic.Size               = UDim2.new(0, 14, 0, 14)
                        ic.AnchorPoint        = Vector2.new(0, 0.5)
                        ic.Position           = UDim2.new(0, 8, 0.5, hasC and -7 or 0)
                        ic.BackgroundTransparency = 1
                        ic.ScaleType          = Enum.ScaleType.Fit
                        ic.Image              = GetIconId(iconId)
                        ic.ImageColor3        = isSolid and Color3.fromRGB(255,255,255) or Color3.fromRGB(210,210,210)
                        ic.ZIndex             = 2
                        ic.Parent             = btn
                    end

                    -- title label
                    local lbl = Instance.new("TextLabel")
                    lbl.Name               = "BtnLabel"
                    lbl.BackgroundTransparency = 1
                    lbl.Font               = Enum.Font.GothamBold
                    lbl.Text               = text
                    lbl.TextSize           = 12
                    lbl.TextColor3         = isSolid and Color3.fromRGB(255,255,255) or Color3.fromRGB(220,220,220)
                    lbl.TextTransparency   = isSolid and 0 or 0.05
                    lbl.TextXAlignment     = hasI and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
                    lbl.TextYAlignment     = hasC and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
                    lbl.Size               = UDim2.new(1, -(iconW + 10 + (hasI and 4 or 0)), hasC and 0 or 1, hasC and 14 or 0)
                    lbl.Position           = UDim2.new(0, iconW + 8, hasC and 0 or 0, hasC and 8 or 0)
                    lbl.ZIndex             = 2
                    lbl.Parent             = btn

                    -- content label (opsional)
                    if hasC then
                        local clbl = Instance.new("TextLabel")
                        clbl.Name               = "BtnContent"
                        clbl.BackgroundTransparency = 1
                        clbl.Font               = Enum.Font.GothamBold
                        clbl.Text               = content
                        clbl.TextSize           = 10
                        clbl.TextColor3         = Color3.fromRGB(255,255,255)
                        clbl.TextTransparency   = isSolid and 0.25 or 0.45
                        clbl.TextXAlignment     = hasI and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
                        clbl.TextYAlignment     = Enum.TextYAlignment.Top
                        clbl.Size               = UDim2.new(1, -(iconW + 10 + (hasI and 4 or 0)), 0, 12)
                        clbl.Position           = UDim2.new(0, iconW + 8, 0, 24)
                        clbl.TextWrapped        = false
                        clbl.ZIndex             = 2
                        clbl.Parent             = btn

                        -- update icon posisi ke tengah antara title+content
                        if hasI then
                            local ic2 = btn:FindFirstChild("BtnIcon")
                            if ic2 then ic2.Position = UDim2.new(0, 8, 0.5, 0) end
                        end
                    end

                    return btn, lbl
                end

                -- tinggi DualRow naik kalau ada content
                local _mainHasC = cfg.Content ~= ""
                local _subHasC  = cfg.SubContent ~= ""
                local _dualRowH = (_mainHasC or _subHasC) and 44 or 30
                DualRow.Size    = UDim2.new(1, -16, 0, _dualRowH)
                -- update Button & DualDivider total height
                local _newTotal = infoH + _dualRowH + 8
                Button.Size = UDim2.new(1, 0, 0, _newTotal)

                local _hasBothBtns = cfg.SubTitle ~= nil
                MainBtnV2, _ = _makeDualBtn(
                    DualRow,
                    cfg.Title,
                    cfg.Content,
                    cfg.Icon,
                    true,   -- solid
                    0,
                    _hasBothBtns and 0.5 or 1
                )
                MainBtnV2.Name = "MainBtnV2"
                MainBtnV2.MouseButton1Click:Connect(function()
                    AnimateButtonClick(MainBtnV2, GuiConfig.Color)
                    SafeCall(cfg.Callback)
                end)

                SubBtnV2, _ = _makeDualBtn(
                    DualRow,
                    cfg.SubTitle,
                    cfg.SubContent,
                    cfg.SubIcon,
                    false,  -- ghost
                    0.5,
                    0.5
                )
                SubBtnV2.Name = "SubBtnV2"
                SubBtnV2.MouseButton1Click:Connect(function()
                    AnimateButtonClick(SubBtnV2)
                    SafeCall(cfg.SubCallback)
                end)
            end
            -- ── Hitbox info row ───────────────────────────────────
            local ClickButton = Instance.new("TextButton")
            ClickButton.Text = ""
            ClickButton.BackgroundTransparency = 1
            ClickButton.Size     = UDim2.new(1, 0, 0, infoH)
            ClickButton.Position = UDim2.new(0, 0, 0, 0)
            ClickButton.Name = "ClickButton"
            ClickButton.AutoButtonColor = false
            ClickButton.Parent = Button
            ClickButton.MouseButton1Click:Connect(function()
                if hasDual then return end
                AnimateButtonClick(ClickButton)
                SafeCall(cfg.Callback)
            end)
            ClickButton.MouseEnter:Connect(function()
                TweenService:Create(TitleLabel, TweenInfo.new(0.15), { TextColor3 = GuiConfig.Color }):Play()
                if not cfg.Icon and IconImg then
                    for _, line in ipairs(IconImg:GetChildren()) do
                        if line:IsA("Frame") then
                            TweenService:Create(line, TweenInfo.new(0.15), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0 }):Play()
                        end
                    end
                end
            end)
            ClickButton.MouseLeave:Connect(function()
                TweenService:Create(TitleLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(231, 231, 231) }):Play()
                if not cfg.Icon and IconImg then
                    for _, line in ipairs(IconImg:GetChildren()) do
                        if line:IsA("Frame") then
                            TweenService:Create(line, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(200, 200, 200), BackgroundTransparency = 0.2 }):Play()
                        end
                    end
                end
            end)
            local LockFunc = ApplyLock(Button, cfg.Locked)
            function ButtonFunc:Fire()    SafeCall(cfg.Callback) end
            function ButtonFunc:FireSub() SafeCall(cfg.SubCallback) end
            function ButtonFunc:SetTitle(text)
                TitleLabel.Text = tostring(text or "")
                if MainBtnV2 then
                    local lbl = MainBtnV2:FindFirstChild("BtnLabel")
                    if lbl then lbl.Text = tostring(text or "") end
                end
                cfg.Title = tostring(text or "")
            end
            function ButtonFunc:SetSubTitle(text)
                if SubBtnV2 then
                    local lbl = SubBtnV2:FindFirstChild("BtnLabel")
                    if lbl then lbl.Text = tostring(text or "") end
                end
                cfg.SubTitle = tostring(text or "")
            end
            function ButtonFunc:SetContent(text)
                if ContentLabel then ContentLabel.Text = tostring(text or "") end
                if MainBtnV2 then
                    local clbl = MainBtnV2:FindFirstChild("BtnContent")
                    if clbl then clbl.Text = tostring(text or "") end
                end
                cfg.Content = tostring(text or "")
            end
            function ButtonFunc:SetSubContent(text)
                if SubBtnV2 then
                    local clbl = SubBtnV2:FindFirstChild("BtnContent")
                    if clbl then clbl.Text = tostring(text or "") end
                end
                cfg.SubContent = tostring(text or "")
            end
            function ButtonFunc:SetIcon(iconId)
                local ic = MainBtnV2 and MainBtnV2:FindFirstChild("BtnIcon")
                if ic then ic.Image = GetIconId(iconId or "") end
                cfg.Icon = iconId
            end
            function ButtonFunc:SetSubIcon(iconId)
                local ic = SubBtnV2 and SubBtnV2:FindFirstChild("BtnIcon")
                if ic then ic.Image = GetIconId(iconId or "") end
                cfg.SubIcon = iconId
            end
            function ButtonFunc:SetCallback(fn)    cfg.Callback    = typeof(fn) == "function" and fn or function() end end
            function ButtonFunc:SetSubCallback(fn) cfg.SubCallback = typeof(fn) == "function" and fn or function() end end
            function ButtonFunc:SetLocked(state) LockFunc:SetLocked(state) end
            function ButtonFunc:GetLocked() return LockFunc:GetLocked() end
            function ButtonFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
            _attachCommon(ButtonFunc, Button)
            return ButtonFunc
        end
        local Button = Instance.new("Frame")
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Button.BackgroundTransparency = 0.935
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.LayoutOrder = countItem
        Button.Parent = parent
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
        if cfg.Badge then CreateBadge(Button, cfg.Badge) end
        local MainButton = Instance.new("TextButton")
        MainButton.Font = Enum.Font.GothamBold
        MainButton.Text = cfg.Title
        MainButton.TextSize = 12
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainButton.TextTransparency = 0.3
        MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MainButton.BackgroundTransparency = 0.935
        MainButton.Size = cfg.SubTitle and UDim2.new(0.5, -8, 1, -10) or UDim2.new(1, -12, 1, -10)
        MainButton.Position = UDim2.new(0, 6, 0, 5)
        MainButton.AutoButtonColor = false
        MainButton.Parent = Button
        Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)
        MainButton.MouseButton1Click:Connect(function()
            AnimateButtonClick(MainButton)
            SafeCall(cfg.Callback)
        end)
        local SubButtonRef
        if cfg.SubTitle then
            SubButtonRef = Instance.new("TextButton")
            SubButtonRef.Font = Enum.Font.GothamBold
            SubButtonRef.Text = cfg.SubTitle
            SubButtonRef.TextSize = 12
            SubButtonRef.TextTransparency = 0.3
            SubButtonRef.TextColor3 = Color3.fromRGB(255, 255, 255)
            SubButtonRef.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SubButtonRef.BackgroundTransparency = 0.935
            SubButtonRef.Size = UDim2.new(0.5, -8, 1, -10)
            SubButtonRef.Position = UDim2.new(0.5, 2, 0, 5)
            SubButtonRef.AutoButtonColor = false
            SubButtonRef.Parent = Button
            Instance.new("UICorner", SubButtonRef).CornerRadius = UDim.new(0, 4)
            SubButtonRef.MouseButton1Click:Connect(function()
                AnimateButtonClick(SubButtonRef)
                SafeCall(cfg.SubCallback)
            end)
        end
        local LockFunc = ApplyLock(Button, cfg.Locked)
        function ButtonFunc:Fire() AnimateButtonClick(MainButton) SafeCall(cfg.Callback) end
        function ButtonFunc:FireSub() if SubButtonRef then AnimateButtonClick(SubButtonRef) SafeCall(cfg.SubCallback) end end
        function ButtonFunc:SetTitle(text) MainButton.Text = tostring(text or "Confirm") cfg.Title = MainButton.Text end
        function ButtonFunc:SetSubTitle(text) if SubButtonRef then SubButtonRef.Text = tostring(text or "") cfg.SubTitle = SubButtonRef.Text end end
        function ButtonFunc:SetCallback(fn) cfg.Callback = typeof(fn) == "function" and fn or function() end end
        function ButtonFunc:SetSubCallback(fn) cfg.SubCallback = typeof(fn) == "function" and fn or function() end end
        function ButtonFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function ButtonFunc:GetLocked() return LockFunc:GetLocked() end
        function ButtonFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
        _attachCommon(ButtonFunc, Button)
        return ButtonFunc
    end

    -- ============================================================
    --  CreateToggle
    -- ============================================================
    function Elements:CreateToggle(parent, config, countItem, updateSectionSize, Elements_Table)
        local cfg = config or {}
        cfg.Title    = cfg.Title    or "Title"
        cfg.Title2   = cfg.Title2   or ""
        cfg.Content  = cfg.Content  or ""
        cfg.Default  = cfg.Default  or false
        cfg.Callback = cfg.Callback or function() end
        cfg.Badge    = cfg.Badge    or nil
        cfg.Locked   = cfg.Locked   or false
        cfg.Type     = cfg.Type     or "Toggle"
        cfg.Icon     = cfg.Icon     or nil
        local configKey = ResolveKey(cfg)
        cfg.Default = ReadConfig(configKey, cfg.Default)
        if typeof(cfg.Default) ~= "boolean" then cfg.Default = cfg.Default and true or false end
        local ToggleFunc = { Value = cfg.Default, Flag = configKey }

        local Toggle        = Instance.new("Frame")
        local UICorner20    = Instance.new("UICorner")
        local ToggleTitle   = Instance.new("TextLabel")
        local ToggleTitle2  = Instance.new("TextLabel")
        local ToggleContent = Instance.new("TextLabel")
        local ToggleButton  = Instance.new("TextButton")
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.BackgroundTransparency = 0.935
        Toggle.BorderSizePixel = 0
        Toggle.LayoutOrder = countItem
        Toggle.Name = "Toggle"
        Toggle.Parent = parent
        UICorner20.CornerRadius = UDim.new(0, 4)
        UICorner20.Parent = Toggle
        if cfg.Badge then CreateBadge(Toggle, cfg.Badge) end

        ToggleTitle.Font = Enum.Font.GothamBold
        ToggleTitle.Text = cfg.Title
        ToggleTitle.TextSize = 13
        ToggleTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
        ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
        ToggleTitle.BackgroundTransparency = 1
        ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
        ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
        ToggleTitle.Name = "ToggleTitle"
        ToggleTitle.Parent = Toggle

        ToggleTitle2.Font = Enum.Font.GothamBold
        ToggleTitle2.Text = cfg.Title2
        ToggleTitle2.TextSize = 12
        ToggleTitle2.TextColor3 = Color3.fromRGB(231, 231, 231)
        ToggleTitle2.TextXAlignment = Enum.TextXAlignment.Left
        ToggleTitle2.TextYAlignment = Enum.TextYAlignment.Top
        ToggleTitle2.BackgroundTransparency = 1
        ToggleTitle2.Position = UDim2.new(0, 10, 0, 23)
        ToggleTitle2.Size = UDim2.new(1, -100, 0, 12)
        ToggleTitle2.Name = "ToggleTitle2"
        ToggleTitle2.Parent = Toggle

        ToggleContent.Font = Enum.Font.GothamBold
        ToggleContent.Text = cfg.Content
        ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleContent.TextSize = 12
        ToggleContent.TextTransparency = 0.6
        ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
        ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
        ToggleContent.BackgroundTransparency = 1
        ToggleContent.Name = "ToggleContent"
        ToggleContent.Parent = Toggle

        if cfg.Title2 ~= "" then
            Toggle.Size = UDim2.new(1, 0, 0, 57)
            ToggleContent.Position = UDim2.new(0, 10, 0, 36)
            ToggleTitle2.Visible = true
        else
            Toggle.Size = UDim2.new(1, 0, 0, 46)
            ToggleContent.Position = UDim2.new(0, 10, 0, 23)
            ToggleTitle2.Visible = false
        end
        ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // math.max(1, ToggleContent.AbsoluteSize.X))))
        ToggleContent.TextWrapped = true
        if cfg.Title2 ~= "" then
            Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
        else
            Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
        end
        ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            ToggleContent.TextWrapped = false
            ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // math.max(1, ToggleContent.AbsoluteSize.X))))
            if cfg.Title2 ~= "" then
                Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
            else
                Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
            end
            ToggleContent.TextWrapped = true
            if updateSectionSize then updateSectionSize() end
        end)

        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.AutoButtonColor = false
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = Toggle

        local FeatureFrame, ToggleCircle, UIStroke8
        local CheckboxFrame, CheckMark
        local CircleScale = nil

        local TRACK_W  = 30
        local CIRCLE_W = 14
        local DRAG_MIN = 0
        local DRAG_MAX = TRACK_W - CIRCLE_W

        local ToggleIcon   = nil
        local CheckboxIcon = nil

        if cfg.Type == "Checkbox" then
            CheckboxFrame = Instance.new("Frame")
            CheckboxFrame.AnchorPoint = Vector2.new(1, 0.5)
            CheckboxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxFrame.BackgroundTransparency = 0.92
            CheckboxFrame.BorderSizePixel = 0
            CheckboxFrame.Position = UDim2.new(1, -15, 0.5, 0)
            CheckboxFrame.Size = UDim2.new(0, 18, 0, 18)
            CheckboxFrame.Name = "CheckboxFrame"
            CheckboxFrame.Parent = Toggle
            Instance.new("UICorner", CheckboxFrame).CornerRadius = UDim.new(0, 4)
            local CBStroke = Instance.new("UIStroke")
            CBStroke.Color = Color3.fromRGB(255, 255, 255)
            CBStroke.Thickness = 1.5
            CBStroke.Transparency = 0.7
            CBStroke.Name = "CBStroke"
            CBStroke.Parent = CheckboxFrame
            CheckMark = Instance.new("ImageLabel")
            CheckMark.Name = "CheckMark"
            CheckMark.AnchorPoint = Vector2.new(0.5, 0.5)
            CheckMark.Position = UDim2.new(0.5, 0, 0.5, 0)
            CheckMark.Size = UDim2.new(0, 12, 0, 12)
            CheckMark.BackgroundTransparency = 1
            CheckMark.ScaleType = Enum.ScaleType.Fit
            CheckMark.Image = "rbxassetid://6031094667"
            CheckMark.ImageColor3 = Color3.fromRGB(255, 255, 255)
            CheckMark.ImageTransparency = 1
            CheckMark.ZIndex = 2
            CheckMark.Parent = CheckboxFrame
            if cfg.Icon and cfg.Icon ~= "" then
                CheckMark.Visible = false
                CheckboxIcon = Instance.new("ImageLabel")
                CheckboxIcon.Name                   = "CheckboxIcon"
                CheckboxIcon.AnchorPoint            = Vector2.new(0.5, 0.5)
                CheckboxIcon.Position               = UDim2.new(0.5, 0, 0.5, 0)
                CheckboxIcon.Size                   = UDim2.new(0, 11, 0, 11)
                CheckboxIcon.BackgroundTransparency = 1
                CheckboxIcon.ScaleType              = Enum.ScaleType.Fit
                CheckboxIcon.Image                  = GetIconId(cfg.Icon)
                CheckboxIcon.ImageColor3            = Color3.fromRGB(255, 255, 255)
                CheckboxIcon.ImageTransparency      = 1
                CheckboxIcon.ZIndex                 = 3
                CheckboxIcon.Parent                 = CheckboxFrame
            end
        else
            FeatureFrame = Instance.new("Frame")
            FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
            FeatureFrame.BackgroundTransparency = 0.92
            FeatureFrame.BorderSizePixel = 0
            FeatureFrame.Position = UDim2.new(1, -15, 0.5, 0)
            FeatureFrame.Size = UDim2.new(0, TRACK_W, 0, 15)
            FeatureFrame.Name = "FeatureFrame"
            FeatureFrame.Parent = Toggle
            Instance.new("UICorner", FeatureFrame)
            UIStroke8 = Instance.new("UIStroke")
            UIStroke8.Color = Color3.fromRGB(255, 255, 255)
            UIStroke8.Thickness = 2
            UIStroke8.Transparency = 0.9
            UIStroke8.Parent = FeatureFrame
            ToggleCircle = Instance.new("Frame")
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Size = UDim2.new(0, CIRCLE_W, 0, CIRCLE_W)
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Parent = FeatureFrame
            Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(0, 15)
            CircleScale = Instance.new("UIScale")
            CircleScale.Scale  = 1
            CircleScale.Parent = ToggleCircle
            if cfg.Icon and cfg.Icon ~= "" then
                ToggleIcon = Instance.new("ImageLabel")
                ToggleIcon.Name                   = "ToggleIcon"
                ToggleIcon.AnchorPoint            = Vector2.new(0.5, 0.5)
                ToggleIcon.Position               = UDim2.new(0.5, 0, 0.5, 0)
                ToggleIcon.Size                   = UDim2.new(0, 10, 0, 10)
                ToggleIcon.BackgroundTransparency = 1
                ToggleIcon.ScaleType              = Enum.ScaleType.Fit
                ToggleIcon.Image                  = GetIconId(cfg.Icon)
                ToggleIcon.ImageColor3            = Color3.fromRGB(255, 255, 255)
                ToggleIcon.ImageTransparency      = 1
                ToggleIcon.ZIndex                 = 3
                ToggleIcon.Parent                 = ToggleCircle
            end
        end

        function ToggleFunc:Set(Value, SkipCallback)
            Value = Value and true or false
            ToggleFunc.Value = Value
            if not SkipCallback then
                WriteConfig(configKey, Value)
                SafeCall(cfg.Callback, Value)
            end
            if cfg.Type == "Checkbox" then
                local cbStroke = CheckboxFrame:FindFirstChild("CBStroke")
                if Value then
                    TweenService:Create(ToggleTitle,   TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                    TweenService:Create(CheckboxFrame, TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0 }):Play()
                    if cbStroke then TweenService:Create(cbStroke, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 }):Play() end
                    if CheckboxIcon then
                        TweenService:Create(CheckboxIcon, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
                    else
                        TweenService:Create(CheckMark, TweenInfo.new(0.15), { ImageTransparency = 0 }):Play()
                    end
                else
                    TweenService:Create(ToggleTitle,   TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                    TweenService:Create(CheckboxFrame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92 }):Play()
                    if cbStroke then TweenService:Create(cbStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.7 }):Play() end
                    if CheckboxIcon then
                        TweenService:Create(CheckboxIcon, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 1 }):Play()
                    else
                        TweenService:Create(CheckMark, TweenInfo.new(0.1), { ImageTransparency = 1 }):Play()
                    end
                end
            else
                if Value then
                    TweenService:Create(ToggleTitle,  TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, DRAG_MAX, 0, 0) }):Play()
                    TweenService:Create(UIStroke8,    TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 }):Play()
                    TweenService:Create(FeatureFrame, TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0 }):Play()
                    if ToggleIcon then
                        TweenService:Create(ToggleIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 0,
                            ImageColor3       = Color3.fromRGB(0, 0, 0),
                        }):Play()
                    end
                else
                    TweenService:Create(ToggleTitle,  TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, DRAG_MIN, 0, 0) }):Play()
                    TweenService:Create(UIStroke8,    TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9 }):Play()
                    TweenService:Create(FeatureFrame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92 }):Play()
                    if ToggleIcon then
                        TweenService:Create(ToggleIcon, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 1,
                            ImageColor3       = Color3.fromRGB(255, 255, 255),
                        }):Play()
                    end
                end
            end
        end

        if cfg.Type ~= "Checkbox" then
            local isDragging   = false
            local isScrolling  = false
            local startMouseX  = 0
            local startMouseY  = 0
            local startCircleX = 0
            local currentCircleX = ToggleFunc.Value and DRAG_MAX or DRAG_MIN
            local activeTweenCircle = nil
            local dragConn, endConn

            local function CancelCircleTween()
                if activeTweenCircle then
                    activeTweenCircle:Cancel()
                    activeTweenCircle = nil
                end
            end

            local _origSet = ToggleFunc.Set
            function ToggleFunc:Set(Value, SkipCallback)
                _origSet(self, Value, SkipCallback)
                currentCircleX = Value and DRAG_MAX or DRAG_MIN
            end

            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
                if isDragging then return end

                CancelCircleTween()
                ToggleCircle.Position = UDim2.new(0, currentCircleX, 0, 0)

                isDragging   = true
                isScrolling  = false
                startMouseX  = input.Position.X
                startMouseY  = input.Position.Y
                startCircleX = currentCircleX

                if CircleScale then
                    TweenService:Create(CircleScale,
                        TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { Scale = 1.5 }):Play()
                end
                TweenService:Create(ToggleCircle,
                    TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 0.85 }):Play()

                if dragConn then dragConn:Disconnect() end
                dragConn = UserInputService.InputChanged:Connect(function(inputChanged)
                    if not isDragging then return end
                    if inputChanged.UserInputType ~= Enum.UserInputType.MouseMovement
                    and inputChanged.UserInputType ~= Enum.UserInputType.Touch then return end
                    if isScrolling then return end

                    local dX = math.abs(inputChanged.Position.X - startMouseX)
                    local dY = math.abs(inputChanged.Position.Y - startMouseY)

                    if dY > dX and dY > 8 then
                        isScrolling = true
                        isDragging  = false
                        TweenService:Create(ToggleCircle,
                            TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            { Position = UDim2.new(0, startCircleX, 0, 0),
                              BackgroundTransparency = 0 }):Play()
                        if CircleScale then
                            TweenService:Create(CircleScale,
                                TweenInfo.new(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                                { Scale = 1 }):Play()
                        end
                        currentCircleX = startCircleX
                        if dragConn then dragConn:Disconnect(); dragConn = nil end
                        if endConn  then endConn:Disconnect();  endConn  = nil end
                        return
                    end

                    local delta = inputChanged.Position.X - startMouseX
                    local newX  = math.clamp(startCircleX + delta, DRAG_MIN, DRAG_MAX)
                    currentCircleX = newX
                    ToggleCircle.Position = UDim2.new(0, newX, 0, 0)

                    local pct = newX / DRAG_MAX
                    TweenService:Create(FeatureFrame, TweenInfo.new(0.05),
                        { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 1 - pct }):Play()
                    TweenService:Create(UIStroke8, TweenInfo.new(0.05),
                        { Color = GuiConfig.Color, Transparency = 1 - pct }):Play()
                end)

                if endConn then endConn:Disconnect() end
                endConn = UserInputService.InputEnded:Connect(function(inputEnded)
                    if not isDragging then return end
                    if inputEnded.UserInputType ~= Enum.UserInputType.MouseButton1
                    and inputEnded.UserInputType ~= Enum.UserInputType.Touch then return end

                    isDragging = false
                    if dragConn then dragConn:Disconnect(); dragConn = nil end
                    if endConn  then endConn:Disconnect();  endConn  = nil end

                    if CircleScale then
                        TweenService:Create(CircleScale,
                            TweenInfo.new(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            { Scale = 1 }):Play()
                    end
                    TweenService:Create(ToggleCircle,
                        TweenInfo.new(0.23, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { BackgroundTransparency = 0 }):Play()

                    local totalDelta = math.abs(inputEnded.Position.X - startMouseX)
                    if totalDelta < 10 then
                        ToggleFunc:Set(not ToggleFunc.Value)
                    else
                        local midPoint = DRAG_MAX / 2
                        ToggleFunc:Set(currentCircleX >= midPoint)
                    end
                end)
            end)
        else
            ToggleButton.Activated:Connect(function()
                ToggleFunc:Set(not ToggleFunc.Value)
            end)
        end

        function ToggleFunc:GetValue() return ToggleFunc.Value end
        local LockFunc = ApplyLock(Toggle, cfg.Locked)
        function ToggleFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function ToggleFunc:GetLocked() return LockFunc:GetLocked() end
        function ToggleFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
        ToggleFunc:Set(ToggleFunc.Value, true)
        if configKey and Elements_Table then Elements_Table[configKey] = ToggleFunc end
        if configKey then _registeredElements[configKey] = ToggleFunc end
        _attachCommon(ToggleFunc, Toggle)
        return ToggleFunc
    end

    -- ============================================================
    --  CreateSlider
    -- ============================================================
    local _IsSliderHolding = false

    function Elements:CreateSlider(parent, config, countItem, updateSectionSize, Elements_Table)
        local cfg = config or {}
        cfg.Title     = cfg.Title     or "Slider"
        cfg.Content   = cfg.Content   or ""
        cfg.Increment = cfg.Increment or 1
        cfg.Min       = cfg.Min       or 0
        cfg.Max       = cfg.Max       or 100
        cfg.Default   = cfg.Default   or 50
        cfg.Callback  = cfg.Callback  or function() end
        cfg.Badge     = cfg.Badge     or nil
        cfg.Locked    = cfg.Locked    or false
        cfg.Tooltip   = cfg.Tooltip   or false
        cfg.IconFrom  = cfg.IconFrom  or nil
        cfg.IconTo    = cfg.IconTo    or nil
        cfg.ScrollParent = cfg.ScrollParent or nil

        if cfg.Min >= cfg.Max then cfg.Max = cfg.Min + 1 end
        if cfg.Increment <= 0 then cfg.Increment = 1 end

        local configKey = ResolveKey(cfg)
        cfg.Default = ReadConfig(configKey, cfg.Default)

        local IsFloat = cfg.Increment % 1 ~= 0
        local LastValue = cfg.Default
        local _settingFromCode = false

        local function FormatValue(val)
            if IsFloat then
                return tonumber(string.format("%.2f", val)) or val
            end
            return math.floor(val + 0.5)
        end

        local SliderFunc = { Value = FormatValue(cfg.Default), Flag = configKey }

        local Slider = Instance.new("Frame")
        Slider.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
        Slider.BackgroundTransparency = 0.935
        Slider.BorderSizePixel        = 0
        Slider.LayoutOrder            = countItem
        Slider.Name                   = "Slider"
        Slider.Parent                 = parent
        Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 4)
        if cfg.Badge then CreateBadge(Slider, cfg.Badge) end

        local SliderTitle = Instance.new("TextLabel")
        SliderTitle.Font               = Enum.Font.GothamBold
        SliderTitle.Text               = cfg.Title
        SliderTitle.TextColor3         = Color3.fromRGB(231, 231, 231)
        SliderTitle.TextSize           = 13
        SliderTitle.TextXAlignment     = Enum.TextXAlignment.Left
        SliderTitle.TextYAlignment     = Enum.TextYAlignment.Top
        SliderTitle.BackgroundTransparency = 1
        SliderTitle.Position           = UDim2.new(0, 10, 0, 10)
        SliderTitle.Size               = UDim2.new(1, -180, 0, 13)
        SliderTitle.Name               = "SliderTitle"
        SliderTitle.Parent             = Slider

        local SliderContent = Instance.new("TextLabel")
        SliderContent.Font             = Enum.Font.GothamBold
        SliderContent.Text             = cfg.Content
        SliderContent.TextColor3       = Color3.fromRGB(255, 255, 255)
        SliderContent.TextSize         = 12
        SliderContent.TextTransparency = 0.6
        SliderContent.TextXAlignment   = Enum.TextXAlignment.Left
        SliderContent.TextYAlignment   = Enum.TextYAlignment.Bottom
        SliderContent.BackgroundTransparency = 1
        SliderContent.Position         = UDim2.new(0, 10, 0, 25)
        SliderContent.TextWrapped      = true
        SliderContent.Name             = "SliderContent"
        SliderContent.Parent           = Slider
        SliderContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (SliderContent.TextBounds.X // math.max(1, SliderContent.AbsoluteSize.X))))
        Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)
        SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            SliderContent.TextWrapped = false
            SliderContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (SliderContent.TextBounds.X // math.max(1, SliderContent.AbsoluteSize.X))))
            Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)
            SliderContent.TextWrapped = true
            if updateSectionSize then updateSectionSize() end
        end)

        local RightContainer = Instance.new("Frame")
        RightContainer.Name               = "RightContainer"
        RightContainer.AnchorPoint        = Vector2.new(1, 0.5)
        RightContainer.Position           = UDim2.new(1, -8, 0.5, 0)
        RightContainer.BackgroundTransparency = 1
        RightContainer.BorderSizePixel    = 0
        RightContainer.AutomaticSize      = Enum.AutomaticSize.X
        RightContainer.Size               = UDim2.new(0, 0, 0, 26)
        RightContainer.Parent             = Slider
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.FillDirection         = Enum.FillDirection.Horizontal
        RightLayout.VerticalAlignment     = Enum.VerticalAlignment.Center
        RightLayout.HorizontalAlignment   = Enum.HorizontalAlignment.Right
        RightLayout.Padding               = UDim.new(0, 6)
        RightLayout.SortOrder             = Enum.SortOrder.LayoutOrder
        RightLayout.Parent                = RightContainer

        if cfg.IconFrom and cfg.IconFrom ~= "" then
            local IconFromImg = Instance.new("ImageLabel")
            IconFromImg.Size               = UDim2.new(0, 18, 0, 18)
            IconFromImg.BackgroundTransparency = 1
            IconFromImg.ScaleType          = Enum.ScaleType.Fit
            IconFromImg.Image              = GetIconId(cfg.IconFrom)
            IconFromImg.ImageColor3        = Color3.fromRGB(180, 180, 180)
            IconFromImg.ImageTransparency  = 0.3
            IconFromImg.LayoutOrder        = 1
            IconFromImg.Name               = "IconFrom"
            IconFromImg.Parent             = RightContainer
        end

        local TrackWidth = 100
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name               = "TrackBg"
        SliderFrame.Size               = UDim2.new(0, TrackWidth, 0, 3)
        SliderFrame.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
        SliderFrame.BackgroundTransparency = 0.8
        SliderFrame.BorderSizePixel    = 0
        SliderFrame.LayoutOrder        = 2
        SliderFrame.Parent             = RightContainer
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(1, 0)

        local initDelta = math.clamp((cfg.Default - cfg.Min) / (cfg.Max - cfg.Min), 0, 1)

        local TrackFill = Instance.new("Frame")
        TrackFill.Name               = "TrackFill"
        TrackFill.AnchorPoint        = Vector2.new(0, 0.5)
        TrackFill.Position           = UDim2.new(0, 0, 0.5, 0)
        TrackFill.Size               = UDim2.new(initDelta, 0, 1, 0)
        TrackFill.BackgroundColor3   = GuiConfig.Color
        TrackFill.BackgroundTransparency = 0
        TrackFill.BorderSizePixel    = 0
        TrackFill.Parent             = SliderFrame
        Instance.new("UICorner", TrackFill).CornerRadius = UDim.new(1, 0)

        local THUMB_W = 8
        local THUMB_H = 8
        local Thumb = Instance.new("Frame")
        Thumb.Name               = "Thumb"
        Thumb.AnchorPoint        = Vector2.new(1, 0.5)
        Thumb.Position           = UDim2.new(1, 4, 0.5, 0)
        Thumb.Size               = UDim2.new(0, THUMB_W, 0, THUMB_H)
        Thumb.BackgroundColor3   = GuiConfig.Color
        Thumb.BackgroundTransparency = 0
        Thumb.BorderSizePixel    = 0
        Thumb.ZIndex             = 2
        Thumb.Parent             = TrackFill
        Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)
        local ThumbStroke = Instance.new("UIStroke")
        ThumbStroke.Color        = GuiConfig.Color
        ThumbStroke.Parent       = Thumb

        local TrackBg = SliderFrame

        if cfg.IconTo and cfg.IconTo ~= "" then
            local IconToImg = Instance.new("ImageLabel")
            IconToImg.Size               = UDim2.new(0, 18, 0, 18)
            IconToImg.BackgroundTransparency = 1
            IconToImg.ScaleType          = Enum.ScaleType.Fit
            IconToImg.Image              = GetIconId(cfg.IconTo)
            IconToImg.ImageColor3        = Color3.fromRGB(220, 220, 220)
            IconToImg.ImageTransparency  = 0.1
            IconToImg.LayoutOrder        = 3
            IconToImg.Name               = "IconTo"
            IconToImg.Parent             = RightContainer
        end

        local TextBox = Instance.new("TextBox")
        TextBox.Font               = Enum.Font.GothamBold
        TextBox.Text               = tostring(FormatValue(cfg.Default))
        TextBox.TextColor3         = Color3.fromRGB(255, 255, 255)
        TextBox.TextTransparency   = 0.4
        TextBox.TextSize           = 13
        TextBox.TextXAlignment     = Enum.TextXAlignment.Left
        TextBox.BackgroundTransparency = 1
        TextBox.BorderSizePixel    = 0
        TextBox.ClearTextOnFocus   = false
        TextBox.Size               = UDim2.new(0, 30, 0, 20)
        TextBox.LayoutOrder        = 4
        TextBox.Name               = "TextBox"
        TextBox.Parent             = RightContainer

        local TooltipFrame  = nil
        local TooltipLabel  = nil
        local TooltipScale  = nil
        local TooltipBg     = nil
        local TooltipArrowImg = nil

        if cfg.Tooltip then
            TooltipFrame = Instance.new("Frame")
            TooltipFrame.Name               = "Tooltip"
            TooltipFrame.AnchorPoint        = Vector2.new(0.5, 1)
            TooltipFrame.Position           = UDim2.new(0.5, 0, 0, -8)
            TooltipFrame.AutomaticSize      = Enum.AutomaticSize.XY
            TooltipFrame.BackgroundTransparency = 1
            TooltipFrame.ZIndex             = 20
            TooltipFrame.Visible            = false
            TooltipFrame.ClipsDescendants   = false
            TooltipFrame.Parent             = Thumb

            local TipList = Instance.new("UIListLayout")
            TipList.FillDirection           = Enum.FillDirection.Vertical
            TipList.HorizontalAlignment     = Enum.HorizontalAlignment.Center
            TipList.VerticalAlignment       = Enum.VerticalAlignment.Center
            TipList.Padding                 = UDim.new(0, 0)
            TipList.SortOrder               = Enum.SortOrder.LayoutOrder
            TipList.Parent                  = TooltipFrame

            local SizeConstraint = Instance.new("UISizeConstraint")
            SizeConstraint.MaxSize          = Vector2.new(400, math.huge)
            SizeConstraint.Parent           = TooltipFrame

            TooltipScale = Instance.new("UIScale")
            TooltipScale.Scale              = 0.9
            TooltipScale.Parent             = TooltipFrame

            TooltipBg = Instance.new("ImageLabel")
            TooltipBg.Name                  = "Background"
            TooltipBg.Image                 = "rbxassetid://80999662900595"
            TooltipBg.ScaleType             = Enum.ScaleType.Slice
            TooltipBg.SliceCenter           = Rect.new(512/2, 512/2, 512/2, 512/2)
            TooltipBg.SliceScale            = (999 / (512/2))
            TooltipBg.BackgroundTransparency = 1
            TooltipBg.ImageColor3           = Color3.fromRGB(40, 38, 55)
            TooltipBg.ImageTransparency     = 1
            TooltipBg.AutomaticSize         = Enum.AutomaticSize.XY
            TooltipBg.ZIndex                = 21
            TooltipBg.LayoutOrder           = 1
            TooltipBg.Parent                = TooltipFrame

            local BgInner = Instance.new("Frame")
            BgInner.AutomaticSize           = Enum.AutomaticSize.XY
            BgInner.BackgroundTransparency  = 1
            BgInner.ZIndex                  = 22
            BgInner.Parent                  = TooltipBg
            Instance.new("UICorner", BgInner).CornerRadius = UDim.new(0, 16)
            local BgList = Instance.new("UIListLayout")
            BgList.FillDirection            = Enum.FillDirection.Horizontal
            BgList.VerticalAlignment        = Enum.VerticalAlignment.Center
            BgList.Padding                  = UDim.new(0, 0)
            BgList.Parent                   = BgInner
            local BgPad = Instance.new("UIPadding")
            BgPad.PaddingLeft               = UDim.new(0, 12)
            BgPad.PaddingRight              = UDim.new(0, 12)
            BgPad.PaddingTop                = UDim.new(0, 7)
            BgPad.PaddingBottom             = UDim.new(0, 7)
            BgPad.Parent                    = BgInner

            TooltipLabel = Instance.new("TextLabel")
            TooltipLabel.Name               = "Label"
            TooltipLabel.AutomaticSize      = Enum.AutomaticSize.XY
            TooltipLabel.BackgroundTransparency = 1
            TooltipLabel.Font               = Enum.Font.GothamBold
            TooltipLabel.Text               = tostring(FormatValue(cfg.Default))
            TooltipLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
            TooltipLabel.TextTransparency   = 1
            TooltipLabel.TextSize           = 15
            TooltipLabel.ZIndex             = 23
            TooltipLabel.Parent             = BgInner

            local ArrowContainer = Instance.new("Frame")
            ArrowContainer.Name             = "Arrow"
            ArrowContainer.AutomaticSize    = Enum.AutomaticSize.XY
            ArrowContainer.BackgroundTransparency = 1
            ArrowContainer.LayoutOrder      = 2
            ArrowContainer.ZIndex           = 21
            ArrowContainer.Parent           = TooltipFrame
            TooltipArrowImg = Instance.new("ImageLabel")
            TooltipArrowImg.Name            = "ImageLabel"
            TooltipArrowImg.Size            = UDim2.new(0, 16, 0, 6)
            TooltipArrowImg.BackgroundTransparency = 1
            TooltipArrowImg.Image           = "rbxassetid://105854070513330"
            TooltipArrowImg.ImageColor3     = Color3.fromRGB(40, 38, 55)
            TooltipArrowImg.ImageTransparency = 1
            TooltipArrowImg.ZIndex          = 22
            TooltipArrowImg.Parent          = ArrowContainer
        end

        local function OpenTooltip()
            if not TooltipFrame then return end
            TooltipFrame.Visible = true
            TweenService:Create(TooltipBg,       TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
            TweenService:Create(TooltipArrowImg, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
            TweenService:Create(TooltipLabel,    TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
            TweenService:Create(TooltipScale,    TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end

        local function CloseTooltip()
            if not TooltipFrame then return end
            TweenService:Create(TooltipBg,       TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 1 }):Play()
            TweenService:Create(TooltipArrowImg, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 1 }):Play()
            TweenService:Create(TooltipLabel,    TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { TextTransparency = 1 }):Play()
            TweenService:Create(TooltipScale,    TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),  { Scale = 0.9 }):Play()
            task.delay(0.35, function()
                if TooltipFrame then TooltipFrame.Visible = false end
            end)
        end

        local SliderHitbox = Instance.new("TextButton")
        SliderHitbox.Text              = ""
        SliderHitbox.BackgroundTransparency = 1
        SliderHitbox.AutoButtonColor   = false
        SliderHitbox.Size              = UDim2.new(1, 8, 0, 40)
        SliderHitbox.AnchorPoint       = Vector2.new(0.5, 0.5)
        SliderHitbox.Position          = UDim2.new(0.5, 0, 0.5, 0)
        SliderHitbox.ZIndex            = 5
        SliderHitbox.Name              = "SliderHitbox"
        SliderHitbox.Parent            = TrackBg

        local Dragging = false
        local moveConn, releaseConn
        local RunService = game:GetService("RunService")

        local function GetDelta(inputX)
            return math.clamp(
                (inputX - TrackBg.AbsolutePosition.X) / TrackBg.AbsoluteSize.X,
                0, 1
            )
        end

        local function UpdateVisual(delta)
            TweenService:Create(TrackFill, TweenInfo.new(0.05), { Size = UDim2.new(delta, 0, 1, 0) }):Play()
        end

        local function FindScrollParent()
            if cfg.ScrollParent then return cfg.ScrollParent end
            local p = Slider.Parent
            for _ = 1, 10 do
                if not p then break end
                if p:IsA("ScrollingFrame") then return p end
                p = p.Parent
            end
            return nil
        end

        function SliderFunc:Set(Value, SkipCallback)
            Value = math.clamp(
                RoundToFactor(tonumber(Value) or cfg.Min, cfg.Increment),
                cfg.Min, cfg.Max
            )
            local formatted = FormatValue(Value)
            if formatted == LastValue and not SkipCallback then return end
            SliderFunc.Value = formatted
            LastValue = formatted
            _settingFromCode = true
            TextBox.Text = tostring(formatted)
            _settingFromCode = false
            if TooltipLabel then
                TooltipLabel.Text = tostring(formatted)
            end
            local delta = (Value - cfg.Min) / (cfg.Max - cfg.Min)
            UpdateVisual(delta)
            if not SkipCallback then
                SafeCall(cfg.Callback, formatted)
                WriteConfig(configKey, formatted)
            end
        end

        function SliderFunc:GetValue() return SliderFunc.Value end

        function SliderFunc:SetMin(min)
            cfg.Min = tonumber(min) or cfg.Min
            if cfg.Min >= cfg.Max then cfg.Max = cfg.Min + 1 end
            SliderFunc:Set(math.max(SliderFunc.Value, cfg.Min), true)
        end

        function SliderFunc:SetMax(max)
            cfg.Max = tonumber(max) or cfg.Max
            if cfg.Max <= cfg.Min then cfg.Min = cfg.Max - 1 end
            SliderFunc:Set(math.min(SliderFunc.Value, cfg.Max), true)
        end

        SliderHitbox.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if _IsSliderHolding then return end

            Dragging = true
            _IsSliderHolding = true

            local scrollP = FindScrollParent()
            if scrollP then scrollP.ScrollingEnabled = false end

            TweenService:Create(Thumb,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 14, 0, 14) }):Play()

            OpenTooltip()

            local isTouch = input.UserInputType == Enum.UserInputType.Touch
            local function GetX()
                return isTouch and input.Position.X or UserInputService:GetMouseLocation().X
            end
            SliderFunc:Set(cfg.Min + (cfg.Max - cfg.Min) * GetDelta(GetX()))

            if moveConn then moveConn:Disconnect() end
            moveConn = RunService.Heartbeat:Connect(function()
                if not Dragging then return end
                local x = isTouch and input.Position.X or UserInputService:GetMouseLocation().X
                SliderFunc:Set(cfg.Min + (cfg.Max - cfg.Min) * GetDelta(x))
            end)

            if releaseConn then releaseConn:Disconnect() end
            releaseConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType ~= Enum.UserInputType.MouseButton1
                and endInput.UserInputType ~= Enum.UserInputType.Touch then return end

                Dragging = false
                _IsSliderHolding = false
                if moveConn then moveConn:Disconnect(); moveConn = nil end
                if releaseConn then releaseConn:Disconnect(); releaseConn = nil end

                if scrollP then scrollP.ScrollingEnabled = true end

                TweenService:Create(Thumb,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { Size = UDim2.new(0, 8, 0, 8) }):Play()

                CloseTooltip()
            end)
        end)

        TextBox.FocusLost:Connect(function(enterPressed)
            if _settingFromCode then return end
            if not enterPressed then
                _settingFromCode = true
                TextBox.Text = tostring(SliderFunc.Value)
                _settingFromCode = false
                return
            end
            local raw = TextBox.Text:gsub("[^%d%-%.]", "")
            local num = tonumber(raw)
            if num then
                SliderFunc:Set(num)
            else
                _settingFromCode = true
                TextBox.Text = tostring(SliderFunc.Value)
                _settingFromCode = false
            end
        end)

        local LockFunc = ApplyLock(Slider, cfg.Locked)
        function SliderFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function SliderFunc:GetLocked() return LockFunc:GetLocked() end
        function SliderFunc:SetLockMessage(text) LockFunc:SetMessage(text) end

        SliderFunc:Set(cfg.Default, true)
        if configKey and Elements_Table then Elements_Table[configKey] = SliderFunc end
        if configKey then _registeredElements[configKey] = SliderFunc end
        _attachCommon(SliderFunc, Slider)
        return SliderFunc
    end

    function Elements:CreateInput(parent, config, countItem, updateSectionSize, Elements_Table)
        local cfg = config or {}
        cfg.Title       = cfg.Title       or "Title"
        cfg.Content     = cfg.Content     or ""
        cfg.Callback    = cfg.Callback    or function() end
        cfg.Default     = cfg.Default     or ""
        cfg.Badge       = cfg.Badge       or nil
        cfg.Locked      = cfg.Locked      or false
        cfg.Type        = cfg.Type        or "Input"
        cfg.Placeholder = cfg.Placeholder or (cfg.Type == "Textarea" and "Type here..." or "Input Here")
        cfg.TextHeight  = cfg.TextHeight  or 60
        local configKey = ResolveKey(cfg)
        cfg.Default = ReadConfig(configKey, cfg.Default)
        local InputFunc = { Value = cfg.Default, Flag = configKey }
        local Input      = Instance.new("Frame")
        local InputTitle = Instance.new("TextLabel")
        local InputTextBox
        Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Input.BackgroundTransparency = 0.935
        Input.BorderSizePixel = 0
        Input.LayoutOrder = countItem
        Input.Name = "Input"
        Input.Parent = parent
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
        if cfg.Badge then CreateBadge(Input, cfg.Badge) end
        local iconOffset = 10
        InputTitle.Font = Enum.Font.GothamBold
        InputTitle.Text = cfg.Title
        InputTitle.TextColor3 = Color3.fromRGB(231, 231, 231)
        InputTitle.TextSize = 13
        InputTitle.TextXAlignment = Enum.TextXAlignment.Left
        InputTitle.TextYAlignment = Enum.TextYAlignment.Top
        InputTitle.BackgroundTransparency = 1
        InputTitle.Name = "InputTitle"
        InputTitle.Parent = Input
        if cfg.Type == "Input" then
            InputTitle.Position = UDim2.new(0, iconOffset, 0, 10)
            InputTitle.Size = UDim2.new(1, -180, 0, 13)
            local InputContent = Instance.new("TextLabel")
            InputContent.Font = Enum.Font.GothamBold
            InputContent.Text = cfg.Content
            InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputContent.TextSize = 12
            InputContent.TextTransparency = 0.6
            InputContent.TextWrapped = true
            InputContent.TextXAlignment = Enum.TextXAlignment.Left
            InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
            InputContent.BackgroundTransparency = 1
            InputContent.Position = UDim2.new(0, iconOffset, 0, 25)
            InputContent.Size = UDim2.new(1, -180, 0, 12)
            InputContent.Name = "InputContent"
            InputContent.Parent = Input
            InputContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // math.max(1, InputContent.AbsoluteSize.X))))
            Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
            InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                InputContent.TextWrapped = false
                InputContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // math.max(1, InputContent.AbsoluteSize.X))))
                Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
                InputContent.TextWrapped = true
                if updateSectionSize then updateSectionSize() end
            end)
            local InputFrame = Instance.new("Frame")
            InputFrame.AnchorPoint = Vector2.new(1, 0.5)
            InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InputFrame.BackgroundTransparency = 0.95
            InputFrame.BorderSizePixel = 0
            InputFrame.ClipsDescendants = true
            InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
            InputFrame.Size = UDim2.new(0, 148, 0, 30)
            InputFrame.Name = "InputFrame"
            InputFrame.Parent = Input
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)
            local boxIconOffset = 5
            if cfg.InputIcon and cfg.InputIcon ~= "" then
                local BoxIcon = Instance.new("ImageLabel")
                BoxIcon.Size = UDim2.new(0, 14, 0, 14)
                BoxIcon.AnchorPoint = Vector2.new(0, 0.5)
                BoxIcon.Position = UDim2.new(0, 6, 0.5, 0)
                BoxIcon.BackgroundTransparency = 1
                BoxIcon.ScaleType = Enum.ScaleType.Fit
                BoxIcon.Image = GetIconId(cfg.InputIcon)
                BoxIcon.ImageColor3 = Color3.fromRGB(160, 160, 160)
                BoxIcon.ImageTransparency = 0.2
                BoxIcon.Name = "BoxIcon"
                BoxIcon.Parent = InputFrame
                boxIconOffset = 24
            end
            InputTextBox = Instance.new("TextBox")
            InputTextBox.CursorPosition = -1
            InputTextBox.Font = Enum.Font.GothamBold
            InputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            InputTextBox.PlaceholderText = cfg.Placeholder
            InputTextBox.Text = cfg.Default
            InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputTextBox.TextSize = 12
            InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
            InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
            InputTextBox.BackgroundTransparency = 1
            InputTextBox.BorderSizePixel = 0
            InputTextBox.Position = UDim2.new(0, boxIconOffset, 0.5, 0)
            InputTextBox.Size = UDim2.new(1, -boxIconOffset - 5, 1, -8)
            InputTextBox.ClearTextOnFocus = false
            InputTextBox.Name = "InputTextBox"
            InputTextBox.Parent = InputFrame
            InputTextBox.FocusLost:Connect(function()
                InputFunc:Set(InputTextBox.Text)
            end)
        else
            InputTitle.Position = UDim2.new(0, iconOffset, 0, 10)
            InputTitle.Size = UDim2.new(1, -20, 0, 13)
            if cfg.Content and cfg.Content ~= "" then
                local InputContent = Instance.new("TextLabel")
                InputContent.Font = Enum.Font.GothamBold
                InputContent.Text = cfg.Content
                InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputContent.TextSize = 11
                InputContent.TextTransparency = 0.55
                InputContent.TextWrapped = true
                InputContent.TextXAlignment = Enum.TextXAlignment.Left
                InputContent.BackgroundTransparency = 1
                InputContent.Position = UDim2.new(0, iconOffset, 0, 26)
                InputContent.Size = UDim2.new(1, -20, 0, 12)
                InputContent.Name = "InputContent"
                InputContent.Parent = Input
            end
            local titleBottom = (cfg.Content and cfg.Content ~= "") and 42 or 30
            local TextareaFrame = Instance.new("Frame")
            TextareaFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextareaFrame.BackgroundTransparency = 0.95
            TextareaFrame.BorderSizePixel = 0
            TextareaFrame.ClipsDescendants = true
            TextareaFrame.Position = UDim2.new(0, 8, 0, titleBottom)
            TextareaFrame.Size = UDim2.new(1, -16, 0, cfg.TextHeight)
            TextareaFrame.Name = "TextareaFrame"
            TextareaFrame.Parent = Input
            Instance.new("UICorner", TextareaFrame).CornerRadius = UDim.new(0, 5)
            local TAStroke = Instance.new("UIStroke")
            TAStroke.Color = Color3.fromRGB(255, 255, 255)
            TAStroke.Thickness = 1
            TAStroke.Transparency = 0.88
            TAStroke.Name = "TAStroke"
            TAStroke.Parent = TextareaFrame
            InputTextBox = Instance.new("TextBox")
            InputTextBox.Font = Enum.Font.GothamBold
            InputTextBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
            InputTextBox.PlaceholderText = cfg.Placeholder
            InputTextBox.Text = cfg.Default
            InputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputTextBox.TextSize = 12
            InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
            InputTextBox.TextYAlignment = Enum.TextYAlignment.Top
            InputTextBox.BackgroundTransparency = 1
            InputTextBox.BorderSizePixel = 0
            InputTextBox.Position = UDim2.new(0, 8, 0, 6)
            InputTextBox.Size = UDim2.new(1, -16, 1, -12)
            InputTextBox.ClearTextOnFocus = false
            InputTextBox.MultiLine = true
            InputTextBox.TextWrapped = true
            InputTextBox.Name = "InputTextBox"
            InputTextBox.Parent = TextareaFrame
            InputTextBox.Focused:Connect(function()
                TweenService:Create(TAStroke, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0.4 }):Play()
            end)
            InputTextBox.FocusLost:Connect(function()
                TweenService:Create(TAStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.88 }):Play()
                InputFunc:Set(InputTextBox.Text)
            end)
            local MIN_H = cfg.TextHeight
            local function UpdateTextareaSize()
                task.wait()
                local lines = math.max(1, InputTextBox.TextBounds.Y)
                local newH = math.max(MIN_H, lines + 18)
                TextareaFrame.Size = UDim2.new(1, -16, 0, newH)
                Input.Size = UDim2.new(1, 0, 0, titleBottom + newH + 10)
                if updateSectionSize then updateSectionSize() end
            end
            InputTextBox:GetPropertyChangedSignal("TextBounds"):Connect(UpdateTextareaSize)
            Input.Size = UDim2.new(1, 0, 0, titleBottom + cfg.TextHeight + 10)
        end
        function InputFunc:Set(Value, SkipCallback)
            Value = tostring(Value or "")
            InputFunc.Value = Value
            InputTextBox.Text = Value
            if not SkipCallback then
                WriteConfig(configKey, Value)
                SafeCall(cfg.Callback, Value)
            end
        end
        function InputFunc:GetValue() return InputFunc.Value end
        function InputFunc:Clear() InputFunc:Set("") end
        function InputFunc:SetTitle(text) InputTitle.Text = tostring(text or "Title") end
        function InputFunc:GetTitle() return InputTitle.Text end
        local LockFunc = ApplyLock(Input, cfg.Locked)
        function InputFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function InputFunc:GetLocked() return LockFunc:GetLocked() end
        function InputFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
        InputFunc:Set(InputFunc.Value, true)
        if configKey and Elements_Table then Elements_Table[configKey] = InputFunc end
        if configKey then _registeredElements[configKey] = InputFunc end
        _attachCommon(InputFunc, Input)
        return InputFunc
    end

    function Elements:CreateDropdown(parent, config, countItem, countDropdown, DropdownFolder, MoreBlur, DropdownSelect, DropPageLayout, Elements_Table)
        local cfg = config or {}
        cfg.Title          = cfg.Title    or "Title"
        cfg.Content        = cfg.Content  or ""
        cfg.Multi          = cfg.Multi    or false
        cfg.Options        = cfg.Options  or {}
        cfg.Default        = cfg.Default  or (cfg.Multi and {} or nil)
        cfg.Callback       = cfg.Callback or function() end
        cfg.Badge          = cfg.Badge    or nil
        cfg.Locked         = cfg.Locked   or false
        cfg.DisabledValues = cfg.DisabledValues or {}
        local configKey = ResolveKey(cfg)
        cfg.Default = ReadConfig(configKey, cfg.Default)
        local DropdownFunc = { Value = cfg.Default, Options = {}, Flag = configKey }
        local Dropdown           = Instance.new("Frame")
        local DropdownButton     = Instance.new("TextButton")
        local UICorner10         = Instance.new("UICorner")
        local DropdownTitle      = Instance.new("TextLabel")
        local DropdownContent    = Instance.new("TextLabel")
        local SelectOptionsFrame = Instance.new("Frame")
        local UICorner11         = Instance.new("UICorner")
        local OptionSelecting    = Instance.new("TextLabel")
        local OptionImg          = Instance.new("ImageLabel")
        Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dropdown.BackgroundTransparency = 0.935
        Dropdown.BorderSizePixel = 0
        Dropdown.LayoutOrder = countItem
        Dropdown.Size = UDim2.new(1, 0, 0, 46)
        Dropdown.Name = "Dropdown"
        Dropdown.Parent = parent
        DropdownButton.Text = ""
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.AutoButtonColor = false
        DropdownButton.Size = UDim2.new(1, 0, 1, 0)
        DropdownButton.Name = "ToggleButton"
        DropdownButton.Parent = Dropdown
        UICorner10.CornerRadius = UDim.new(0, 4)
        UICorner10.Parent = Dropdown
        if cfg.Badge then CreateBadge(Dropdown, cfg.Badge) end
        DropdownTitle.Font = Enum.Font.GothamBold
        DropdownTitle.Text = cfg.Title
        DropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        DropdownTitle.TextSize = 13
        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
        DropdownTitle.BackgroundTransparency = 1
        DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
        DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
        DropdownTitle.Name = "DropdownTitle"
        DropdownTitle.Parent = Dropdown
        DropdownContent.Font = Enum.Font.GothamBold
        DropdownContent.Text = cfg.Content
        DropdownContent.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownContent.TextSize = 12
        DropdownContent.TextTransparency = 0.6
        DropdownContent.TextWrapped = true
        DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
        DropdownContent.BackgroundTransparency = 1
        DropdownContent.Position = UDim2.new(0, 10, 0, 25)
        DropdownContent.Size = UDim2.new(1, -180, 0, 12)
        DropdownContent.Name = "DropdownContent"
        DropdownContent.Parent = Dropdown
        DropdownContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (DropdownContent.TextBounds.X // math.max(1, DropdownContent.AbsoluteSize.X))))
        Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)
        DropdownContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            DropdownContent.TextWrapped = false
            DropdownContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (DropdownContent.TextBounds.X // math.max(1, DropdownContent.AbsoluteSize.X))))
            Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)
            DropdownContent.TextWrapped = true
        end)
        SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
        SelectOptionsFrame.BackgroundTransparency = 0.95
        SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
        SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
        SelectOptionsFrame.Name = "SelectOptionsFrame"
        SelectOptionsFrame.LayoutOrder = countDropdown
        SelectOptionsFrame.Parent = Dropdown
        UICorner11.CornerRadius = UDim.new(0, 4)
        UICorner11.Parent = SelectOptionsFrame
        DropdownButton.Activated:Connect(function()
            if not MoreBlur.Visible then
                MoreBlur.Visible = true
                DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
                TweenService:Create(MoreBlur, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(DropdownSelect, TweenInfo.new(0.3), { Position = UDim2.new(1, -11, 0.5, 0) }):Play()
            end
        end)
        OptionSelecting.Font = Enum.Font.GothamBold
        OptionSelecting.Text = cfg.Multi and "Select Options" or "Select Option"
        OptionSelecting.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionSelecting.TextSize = 12
        OptionSelecting.TextTransparency = 0.6
        OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
        OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
        OptionSelecting.BackgroundTransparency = 1
        OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
        OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
        OptionSelecting.Name = "OptionSelecting"
        OptionSelecting.Parent = SelectOptionsFrame
        OptionImg.Image = "rbxassetid://16851841101"
        OptionImg.ImageColor3 = Color3.fromRGB(230, 230, 230)
        OptionImg.AnchorPoint = Vector2.new(1, 0.5)
        OptionImg.BackgroundTransparency = 1
        OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
        OptionImg.Size = UDim2.new(0, 25, 0, 25)
        OptionImg.Name = "OptionImg"
        OptionImg.Parent = SelectOptionsFrame
        local DropdownContainer = Instance.new("Frame")
        DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
        DropdownContainer.BackgroundTransparency = 1
        DropdownContainer.Parent = DropdownFolder
        local SearchBox = Instance.new("TextBox")
        SearchBox.PlaceholderText = "Search"
        SearchBox.Font = Enum.Font.Gotham
        SearchBox.Text = ""
        SearchBox.TextSize = 12
        SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SearchBox.BackgroundTransparency = 0.9
        SearchBox.BorderSizePixel = 0
        SearchBox.Size = UDim2.new(1, 0, 0, 25)
        SearchBox.Position = UDim2.new(0, 0, 0, 0)
        SearchBox.ClearTextOnFocus = false
        SearchBox.Name = "SearchBox"
        SearchBox.Parent = DropdownContainer
        local ScrollSelect = Instance.new("ScrollingFrame")
        ScrollSelect.Size = UDim2.new(1, 0, 1, -30)
        ScrollSelect.Position = UDim2.new(0, 0, 0, 30)
        ScrollSelect.ScrollBarImageTransparency = 1
        ScrollSelect.BorderSizePixel = 0
        ScrollSelect.BackgroundTransparency = 1
        ScrollSelect.ScrollBarThickness = 0
        ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollSelect.Name = "ScrollSelect"
        ScrollSelect.Parent = DropdownContainer
        local UIListLayout4 = Instance.new("UIListLayout")
        UIListLayout4.Padding = UDim.new(0, 3)
        UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout4.Parent = ScrollSelect
        UIListLayout4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
        end)
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = string.lower(SearchBox.Text)
            for _, option in pairs(ScrollSelect:GetChildren()) do
                if option.Name == "Option" and option:FindFirstChild("OptionText") then
                    local text = string.lower(option.OptionText.Text)
                    option.Visible = query == "" or string.find(text, query, 1, true) ~= nil
                end
            end
        end)
        local AllButton
        if cfg.Multi then
            AllButton = Instance.new("Frame")
            Instance.new("UICorner", AllButton).CornerRadius = UDim.new(0, 3)
            AllButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            AllButton.BackgroundTransparency = 0.97
            AllButton.BorderSizePixel = 0
            AllButton.Size = UDim2.new(1, 0, 0, 22)
            AllButton.LayoutOrder = -1
            AllButton.Name = "AllButton"
            AllButton.Parent = ScrollSelect
            local AllFeatureFrame = Instance.new("Frame")
            AllFeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
            AllFeatureFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            AllFeatureFrame.BackgroundTransparency = 0.93
            AllFeatureFrame.BorderSizePixel = 0
            AllFeatureFrame.Position = UDim2.new(1, -6, 0.5, 0)
            AllFeatureFrame.Size = UDim2.new(0, 22, 0, 11)
            AllFeatureFrame.Name = "AllFeatureFrame"
            AllFeatureFrame.Parent = AllButton
            Instance.new("UICorner", AllFeatureFrame)
            local AllStroke = Instance.new("UIStroke")
            AllStroke.Color = Color3.fromRGB(255, 255, 255)
            AllStroke.Thickness = 1
            AllStroke.Transparency = 0.85
            AllStroke.Name = "AllStroke"
            AllStroke.Parent = AllFeatureFrame
            local AllCircle = Instance.new("Frame")
            AllCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            AllCircle.BorderSizePixel = 0
            AllCircle.Position = UDim2.new(0, 1, 0, 1)
            AllCircle.Size = UDim2.new(0, 9, 0, 9)
            AllCircle.Name = "AllCircle"
            AllCircle.Parent = AllFeatureFrame
            Instance.new("UICorner", AllCircle).CornerRadius = UDim.new(1, 0)
            local AllText = Instance.new("TextLabel")
            AllText.Font = Enum.Font.Gotham
            AllText.Text = "All"
            AllText.TextSize = 10
            AllText.TextColor3 = Color3.fromRGB(200, 200, 200)
            AllText.TextTransparency = 0.45
            AllText.Position = UDim2.new(0, 7, 0, 0)
            AllText.Size = UDim2.new(1, -40, 1, 0)
            AllText.BackgroundTransparency = 1
            AllText.TextXAlignment = Enum.TextXAlignment.Left
            AllText.TextYAlignment = Enum.TextYAlignment.Center
            AllText.Name = "AllText"
            AllText.Parent = AllButton
            local AllDivider = Instance.new("Frame")
            AllDivider.Size = UDim2.new(1, -12, 0, 1)
            AllDivider.Position = UDim2.new(0, 6, 1, -1)
            AllDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            AllDivider.BackgroundTransparency = 0.92
            AllDivider.BorderSizePixel = 0
            AllDivider.Name = "AllDivider"
            AllDivider.Parent = AllButton
            local AllButtonClick = Instance.new("TextButton")
            AllButtonClick.BackgroundTransparency = 1
            AllButtonClick.AutoButtonColor = false
            AllButtonClick.Size = UDim2.new(1, 0, 1, 0)
            AllButtonClick.Text = ""
            AllButtonClick.ZIndex = 2
            AllButtonClick.Name = "AllButtonClick"
            AllButtonClick.Parent = AllButton
            AllButtonClick.Activated:Connect(function()
                local allValues = {}
                for _, opt in ipairs(DropdownFunc.Options) do
                    local v = (typeof(opt) == "table" and opt.Value ~= nil) and opt.Value or opt
                    table.insert(allValues, v)
                end
                local allSelected = #allValues > 0
                for _, v in ipairs(allValues) do
                    if not table.find(DropdownFunc.Value, v) then allSelected = false break end
                end
                if allSelected then DropdownFunc:Set({}) else DropdownFunc:Set(allValues) end
            end)
        end
        function DropdownFunc:Clear()
            for _, child in ScrollSelect:GetChildren() do
                if child.Name == "Option" then child:Destroy() end
            end
            DropdownFunc.Value   = cfg.Multi and {} or nil
            DropdownFunc.Options = {}
            OptionSelecting.Text = cfg.Multi and "Select Options" or "Select Option"
            if AllButton then
                local af = AllButton:FindFirstChild("AllFeatureFrame")
                local st = af and af:FindFirstChild("AllStroke")
                local ac = af and af:FindFirstChild("AllCircle")
                local at = AllButton:FindFirstChild("AllText")
                if af then TweenService:Create(af, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.93 }):Play() end
                if st then TweenService:Create(st, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.85 }):Play() end
                if ac then TweenService:Create(ac, TweenInfo.new(0.2), { Position = UDim2.new(0, 1, 0, 1), BackgroundColor3 = Color3.fromRGB(200, 200, 200) }):Play() end
                if at then TweenService:Create(at, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(200, 200, 200), TextTransparency = 0.45 }):Play() end
                TweenService:Create(AllButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.97 }):Play()
            end
        end
        function DropdownFunc:AddOption(option)
            local label, value
            if typeof(option) == "table" and option.Label and option.Value ~= nil then
                label = tostring(option.Label)
                value = option.Value
            else
                label = tostring(option)
                value = option
            end
            table.insert(DropdownFunc.Options, option)
            local Option = Instance.new("Frame")
            Instance.new("UICorner", Option).CornerRadius = UDim.new(0, 3)
            Option.BackgroundTransparency = 0.999
            Option.Size = UDim2.new(1, 0, 0, 30)
            Option.Name = "Option"
            Option.Parent = ScrollSelect
            local OptionButton = Instance.new("TextButton")
            OptionButton.BackgroundTransparency = 1
            OptionButton.AutoButtonColor = false
            OptionButton.Size = UDim2.new(1, 0, 1, 0)
            OptionButton.Text = ""
            OptionButton.Name = "OptionButton"
            OptionButton.Parent = Option
            local OptionText = Instance.new("TextLabel")
            OptionText.Font = Enum.Font.GothamBold
            OptionText.Text = label
            OptionText.TextSize = 13
            OptionText.TextColor3 = Color3.fromRGB(230, 230, 230)
            OptionText.Position = UDim2.new(0, 8, 0, 8)
            OptionText.Size = UDim2.new(1, -100, 0, 13)
            OptionText.BackgroundTransparency = 1
            OptionText.TextXAlignment = Enum.TextXAlignment.Left
            OptionText.Name = "OptionText"
            OptionText.Parent = Option
            Option:SetAttribute("RealValue", value)
            local isDisabledOnCreate = table.find(cfg.DisabledValues, value) ~= nil
            if isDisabledOnCreate then OptionText.TextTransparency = 0.7 end
            local ChooseFrame = Instance.new("Frame")
            ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
            ChooseFrame.BackgroundColor3 = GuiConfig.Color
            ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
            ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
            ChooseFrame.Name = "ChooseFrame"
            ChooseFrame.Parent = Option
            Instance.new("UICorner", ChooseFrame)
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = GuiConfig.Color
            UIStroke.Thickness = 1.6
            UIStroke.Transparency = 0.999
            UIStroke.Name = "UIStroke"
            UIStroke.Parent = ChooseFrame
            OptionButton.Activated:Connect(function()
                local isDisabled = table.find(cfg.DisabledValues, value) ~= nil
                if isDisabled then return end
                if cfg.Multi then
                    local idx = table.find(DropdownFunc.Value, value)
                    if not idx then table.insert(DropdownFunc.Value, value) else table.remove(DropdownFunc.Value, idx) end
                    DropdownFunc:Set(DropdownFunc.Value)
                else
                    if DropdownFunc.Value == value then DropdownFunc:Set(nil) else DropdownFunc:Set(value) end
                end
            end)
        end
        function DropdownFunc:Set(Value, SkipCallback)
            if cfg.Multi then
                if type(Value) == "table" then DropdownFunc.Value = Value
                elseif Value == nil then DropdownFunc.Value = {}
                else DropdownFunc.Value = { Value } end
            else
                if type(Value) == "table" then DropdownFunc.Value = Value[1]
                else DropdownFunc.Value = Value end
            end
            if not SkipCallback then WriteConfig(configKey, DropdownFunc.Value) end
            local texts = {}
            for _, Drop in ScrollSelect:GetChildren() do
                if Drop.Name == "Option" and Drop:FindFirstChild("OptionText") then
                    local v = Drop:GetAttribute("RealValue")
                    local isDisabled = table.find(cfg.DisabledValues, v) ~= nil
                    local selected = cfg.Multi
                        and (type(DropdownFunc.Value) == "table" and table.find(DropdownFunc.Value, v) ~= nil)
                        or (DropdownFunc.Value == v)
                    local cf = Drop:FindFirstChild("ChooseFrame")
                    local st = cf and cf:FindFirstChild("UIStroke")
                    local optText = Drop:FindFirstChild("OptionText")
                    if isDisabled then
                        if cf then TweenService:Create(cf, TweenInfo.new(0.1), { Size = UDim2.new(0, 0, 0, 0) }):Play() end
                        if st then TweenService:Create(st, TweenInfo.new(0.1), { Transparency = 0.999 }):Play() end
                        TweenService:Create(Drop, TweenInfo.new(0.1), { BackgroundTransparency = 0.999 }):Play()
                        if optText then TweenService:Create(optText, TweenInfo.new(0.1), { TextTransparency = 0.7 }):Play() end
                    elseif selected then
                        if cf then TweenService:Create(cf, TweenInfo.new(0.2), { Size = UDim2.new(0, 1, 0, 12) }):Play() end
                        if st then TweenService:Create(st, TweenInfo.new(0.2), { Transparency = 0 }):Play() end
                        TweenService:Create(Drop, TweenInfo.new(0.2), { BackgroundTransparency = 0.935 }):Play()
                        if optText then TweenService:Create(optText, TweenInfo.new(0.2), { TextTransparency = 0.05 }):Play() end
                        table.insert(texts, Drop.OptionText.Text)
                    else
                        if cf then TweenService:Create(cf, TweenInfo.new(0.1), { Size = UDim2.new(0, 0, 0, 0) }):Play() end
                        if st then TweenService:Create(st, TweenInfo.new(0.1), { Transparency = 0.999 }):Play() end
                        TweenService:Create(Drop, TweenInfo.new(0.1), { BackgroundTransparency = 0.999 }):Play()
                        if optText then TweenService:Create(optText, TweenInfo.new(0.2), { TextTransparency = 0.4 }):Play() end
                    end
                end
            end
            OptionSelecting.Text = (#texts == 0)
                and (cfg.Multi and "Select Options" or "Select Option")
                or table.concat(texts, ", ")
            if cfg.Multi and AllButton then
                local allValues = {}
                for _, opt in ipairs(DropdownFunc.Options) do
                    local v = (typeof(opt) == "table" and opt.Value ~= nil) and opt.Value or opt
                    table.insert(allValues, v)
                end
                local allSelected = #allValues > 0
                for _, v in ipairs(allValues) do
                    if not table.find(DropdownFunc.Value, v) then allSelected = false break end
                end
                local af = AllButton:FindFirstChild("AllFeatureFrame")
                local st = af and af:FindFirstChild("AllStroke")
                local ac = af and af:FindFirstChild("AllCircle")
                local at = AllButton:FindFirstChild("AllText")
                if allSelected then
                    TweenService:Create(AllButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.93 }):Play()
                    if at then TweenService:Create(at, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color, TextTransparency = 0.2 }):Play() end
                    if ac then TweenService:Create(ac, TweenInfo.new(0.2), { Position = UDim2.new(0, 11, 0, 1), BackgroundColor3 = GuiConfig.Color }):Play() end
                    if st then TweenService:Create(st, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0.5 }):Play() end
                    if af then TweenService:Create(af, TweenInfo.new(0.2), { BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0.7 }):Play() end
                else
                    TweenService:Create(AllButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.97 }):Play()
                    if at then TweenService:Create(at, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(200, 200, 200), TextTransparency = 0.45 }):Play() end
                    if ac then TweenService:Create(ac, TweenInfo.new(0.2), { Position = UDim2.new(0, 1, 0, 1), BackgroundColor3 = Color3.fromRGB(200, 200, 200) }):Play() end
                    if st then TweenService:Create(st, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.85 }):Play() end
                    if af then TweenService:Create(af, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.93 }):Play() end
                end
            end
            if not SkipCallback then
                if cfg.Multi then SafeCall(cfg.Callback, DropdownFunc.Value)
                else SafeCall(cfg.Callback, DropdownFunc.Value ~= nil and tostring(DropdownFunc.Value) or nil) end
            end
        end
        function DropdownFunc:SetValue(val) self:Set(val) end
        function DropdownFunc:GetValue() return self.Value end
        function DropdownFunc:SetValues(newList, selecting)
            newList   = newList   or {}
            selecting = selecting or (cfg.Multi and {} or nil)
            DropdownFunc:Clear()
            for _, v in ipairs(newList) do DropdownFunc:AddOption(v) end
            DropdownFunc:Set(selecting)
        end
        function DropdownFunc:SetDisabledValues(disabledList)
            cfg.DisabledValues = disabledList or {}
            DropdownFunc:Set(DropdownFunc.Value)
        end
        local LockFunc = ApplyLock(Dropdown, cfg.Locked)
        function DropdownFunc:SetLocked(state) LockFunc:SetLocked(state) end
        function DropdownFunc:GetLocked() return LockFunc:GetLocked() end
        function DropdownFunc:SetLockMessage(text) LockFunc:SetMessage(text) end
        DropdownFunc:SetValues(cfg.Options, cfg.Default)
        if configKey and Elements_Table then Elements_Table[configKey] = DropdownFunc end
        if configKey then _registeredElements[configKey] = DropdownFunc end
        _attachCommon(DropdownFunc, Dropdown)
        return DropdownFunc
    end

    function Elements:CreateDivider(parent, countItem)
        local Divider = Instance.new("Frame")
        Divider.Name = "Divider"
        Divider.AnchorPoint = Vector2.new(0.5, 0)
        Divider.Position = UDim2.new(0.5, 0, 0, 0)
        Divider.Size = UDim2.new(1, 0, 0, 2)
        Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Divider.BackgroundTransparency = 0
        Divider.BorderSizePixel = 0
        Divider.LayoutOrder = countItem
        Divider.Parent = parent
        local UIGradient = Instance.new("UIGradient")
        UIGradient.Color = ColorSequence.new {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
            ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20)),
        }
        UIGradient.Parent = Divider
        Instance.new("UICorner", Divider).CornerRadius = UDim.new(0, 2)
        return Divider
    end

    function Elements:CreateSubSection(parent, title, countItem, config)
        local cfg = config or {}
        title = title or cfg.Title or "Sub Section"

        local _alignMap = {
            Left   = Enum.TextXAlignment.Left,
            Center = Enum.TextXAlignment.Center,
            Right  = Enum.TextXAlignment.Right,
        }
        local _align = _alignMap[cfg.TextXAlignment] or Enum.TextXAlignment.Left

        local _anchorX = 0
        local _posX    = 10
        if _align == Enum.TextXAlignment.Center then
            _anchorX = 0.5; _posX = 0
        elseif _align == Enum.TextXAlignment.Right then
            _anchorX = 1;   _posX = -10
        end

        local SubSection = Instance.new("Frame")
        SubSection.Name = "SubSection"
        SubSection.BackgroundTransparency = 1
        SubSection.Size = UDim2.new(1, 0, 0, 22)
        SubSection.LayoutOrder = countItem
        SubSection.Parent = parent
        local Background = Instance.new("Frame")
        Background.Size = UDim2.new(1, 0, 1, 0)
        Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Background.BackgroundTransparency = 0.935
        Background.BorderSizePixel = 0
        Background.Parent = SubSection
        Instance.new("UICorner", Background).CornerRadius = UDim.new(0, 6)
        local Label = Instance.new("TextLabel")
        Label.AnchorPoint = Vector2.new(_anchorX, 0.5)
        Label.Position = UDim2.new(_anchorX, _posX, 0.5, 0)
        Label.Size = UDim2.new(1, -20, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.Text = "── [ " .. title .. " ] ──"
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextSize = 12
        Label.TextXAlignment = _align
        Label.Parent = SubSection

        local SubSectionFunc = {}
        function SubSectionFunc:SetTitle(text)
            Label.Text = "── [ " .. tostring(text or "") .. " ] ──"
        end
        function SubSectionFunc:SetAlignment(alignStr)
            local a = _alignMap[alignStr] or Enum.TextXAlignment.Left
            Label.TextXAlignment = a
            if a == Enum.TextXAlignment.Center then
                Label.AnchorPoint = Vector2.new(0.5, 0.5)
                Label.Position    = UDim2.new(0.5, 0, 0.5, 0)
            elseif a == Enum.TextXAlignment.Right then
                Label.AnchorPoint = Vector2.new(1, 0.5)
                Label.Position    = UDim2.new(1, -10, 0.5, 0)
            else
                Label.AnchorPoint = Vector2.new(0, 0.5)
                Label.Position    = UDim2.new(0, 10, 0.5, 0)
            end
        end
        function SubSectionFunc:SetVisible(state) SubSection.Visible = state == true end
        function SubSectionFunc:GetVisible() return SubSection.Visible end
        function SubSectionFunc:Destroy() SubSection:Destroy() end

        return SubSectionFunc
    end

    return Elements
end)()
local KeybindModule  = (function()
    -- // Vilaris Ui | Keybind.lua 

    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    local GuiConfig  = { Color = Color3.fromRGB(0, 208, 255) }
    local ConfigData = {}
    local SaveConfig = function() end

    local KeybindModule = {}

    function KeybindModule:Initialize(config, saveFunc, configData)
        if config     then GuiConfig  = config     end
        if saveFunc   then SaveConfig = saveFunc   end
        if configData then ConfigData = configData end
    end

    function KeybindModule:CreateKeybind(SectionAdd, KeybindConfig, CountItem, Elements)
        KeybindConfig          = KeybindConfig or {}
        KeybindConfig.Title    = KeybindConfig.Title    or "Keybind"
        KeybindConfig.Content  = KeybindConfig.Content  or ""
        KeybindConfig.Value    = KeybindConfig.Value    or "None"
        KeybindConfig.Mode     = KeybindConfig.Mode     or "Toggle"
        KeybindConfig.Modes    = KeybindConfig.Modes    or {"Always","Toggle","Hold"}
        KeybindConfig.Callback = KeybindConfig.Callback or function() end
        KeybindConfig.Changed  = KeybindConfig.Changed  or function() end
        KeybindConfig.Locked   = KeybindConfig.Locked   or false

        -- Load saved config
        local ck    = (KeybindConfig.Flag and KeybindConfig.Flag ~= "") and KeybindConfig.Flag or ("Keybind_" .. KeybindConfig.Title)
        local saved = ConfigData[ck]
        if type(saved) == "table" then
            if type(saved.Key) == "string" and saved.Key ~= "" then KeybindConfig.Value = saved.Key end
            if type(saved.Mode) == "string" and table.find(KeybindConfig.Modes, saved.Mode) then KeybindConfig.Mode = saved.Mode end
        elseif type(saved) == "string" and saved ~= "" then
            KeybindConfig.Value = saved
        end

        -- ── Obsidian special keys ──────────────────────────────────────
        local SpecialKeys = {
            MB1 = Enum.UserInputType.MouseButton1,
            MB2 = Enum.UserInputType.MouseButton2,
            MB3 = Enum.UserInputType.MouseButton3,
        }
        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        }

        -- ── Obsidian modifiers ─────────────────────────────────────────
        local Modifiers = {
            LAlt   = Enum.KeyCode.LeftAlt,   RAlt  = Enum.KeyCode.RightAlt,
            LCtrl  = Enum.KeyCode.LeftControl, RCtrl = Enum.KeyCode.RightControl,
            LShift = Enum.KeyCode.LeftShift,  RShift = Enum.KeyCode.RightShift,
            Tab    = Enum.KeyCode.Tab,         CapsLock = Enum.KeyCode.CapsLock,
        }
        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt]      = "LAlt",  [Enum.KeyCode.RightAlt]     = "RAlt",
            [Enum.KeyCode.LeftControl]  = "LCtrl", [Enum.KeyCode.RightControl] = "RCtrl",
            [Enum.KeyCode.LeftShift]    = "LShift",[Enum.KeyCode.RightShift]   = "RShift",
            [Enum.KeyCode.Tab]          = "Tab",   [Enum.KeyCode.CapsLock]     = "CapsLock",
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local active = {}
            for name, kc in pairs(Modifiers) do
                if not table.find(active, name) and UserInputService:IsKeyDown(kc) then
                    table.insert(active, name)
                end
            end
            return active
        end

        local AreModifiersHeld = function(required)
            if type(required) ~= "table" or #required == 0 then return true end
            local active = GetActiveModifiers()
            for _, name in ipairs(required) do
                if not table.find(active, name) then return false end
            end
            return true
        end

        local VerifyModifiers = function(mods)
            if type(mods) ~= "table" then return {} end
            local valid = {}
            for _, name in ipairs(mods) do
                if Modifiers[name] then table.insert(valid, name) end
            end
            return valid
        end

        local ConvertToInputModifiers = function(mods)
            local out = {}
            for _, name in ipairs(mods) do table.insert(out, Modifiers[name]) end
            return out
        end

        -- ── State ──────────────────────────────────────────────────────
        local curKey      = KeybindConfig.Value
        local curMode     = KeybindConfig.Mode
        local curMods     = VerifyModifiers(KeybindConfig.DefaultModifiers or {})
        local displayVal  = curKey
        local toggled     = false
        local Picking     = false
        local Signals     = {}

        local function saveState()
            ConfigData[ck] = { Key = curKey, Mode = curMode }
            SaveConfig()
        end

        local function safeCall(fn, ...)
            if type(fn) == "function" then
                local ok, err = pcall(fn, ...)
                if not ok then warn("[keybind]", err) end
            end
        end

        -- ── Row frame (Vilaris style) ──────────────────────────────────
        local KeybindFrame = Instance.new("Frame")
        KeybindFrame.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
        KeybindFrame.BackgroundTransparency = 0.935
        KeybindFrame.BorderSizePixel        = 0
        KeybindFrame.LayoutOrder            = CountItem
        KeybindFrame.Size                   = UDim2.new(1, 0, 0, 46)
        KeybindFrame.Name                   = "KeybindFrame"
        KeybindFrame.ClipsDescendants       = false
        KeybindFrame.Parent                 = SectionAdd
        Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 4)

        local KBTitle = Instance.new("TextLabel")
        KBTitle.Font               = Enum.Font.GothamBold
        KBTitle.Text               = KeybindConfig.Title
        KBTitle.TextColor3         = Color3.fromRGB(231, 231, 231)
        KBTitle.TextSize           = 13
        KBTitle.TextXAlignment     = Enum.TextXAlignment.Left
        KBTitle.TextYAlignment     = Enum.TextYAlignment.Top
        KBTitle.BackgroundTransparency = 1
        KBTitle.Position           = UDim2.new(0, 10, 0, 10)
        KBTitle.Size               = UDim2.new(1, -100, 0, 13)
        KBTitle.Parent             = KeybindFrame

        local KBContent = Instance.new("TextLabel")
        KBContent.Font               = Enum.Font.GothamBold
        KBContent.Text               = KeybindConfig.Content
        KBContent.TextColor3         = Color3.fromRGB(255, 255, 255)
        KBContent.TextSize           = 12
        KBContent.TextTransparency   = 0.6
        KBContent.TextXAlignment     = Enum.TextXAlignment.Left
        KBContent.TextYAlignment     = Enum.TextYAlignment.Bottom
        KBContent.BackgroundTransparency = 1
        KBContent.TextWrapped        = true
        KBContent.Position           = UDim2.new(0, 10, 0, 23)
        KBContent.Size               = UDim2.new(1, -100, 0, 12 + (12 * (KBContent.TextBounds.X // math.max(1, KBContent.AbsoluteSize.X))))
        KBContent.TextWrapped        = true
        KeybindFrame.Size            = UDim2.new(1, 0, 0, KBContent.AbsoluteSize.Y + 33)
        KBContent.Parent             = KeybindFrame

        KBContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            KBContent.TextWrapped = false
            KBContent.Size = UDim2.new(1, -100, 0, 12 + (12 * (KBContent.TextBounds.X // math.max(1, KBContent.AbsoluteSize.X))))
            KeybindFrame.Size = UDim2.new(1, 0, 0, KBContent.AbsoluteSize.Y + 33)
            KBContent.TextWrapped = true
        end)

        -- ── Picker button (Obsidian style: auto-width TextButton) ──────
        local Picker = Instance.new("TextButton")
        Picker.BackgroundColor3       = Color3.fromRGB(35, 35, 35)
        Picker.BorderColor3           = Color3.fromRGB(50, 50, 50)
        Picker.BorderSizePixel        = 1
        Picker.AnchorPoint            = Vector2.new(1, 0.5)
        Picker.Position               = UDim2.new(1, -8, 0.5, 0)
        Picker.Size                   = UDim2.fromOffset(18, 18)
        Picker.Text                   = curKey
        Picker.Font                   = Enum.Font.GothamBold
        Picker.TextSize               = 13
        Picker.TextColor3             = Color3.fromRGB(200, 200, 200)
        Picker.AutoButtonColor        = false
        Picker.Parent                 = KeybindFrame

        -- Mode label kecil di bawah picker


        -- Mode context menu (Obsidian style: appears at ScreenGui level)
        -- We parent it to KeybindFrame with ClipsDescendants=false so it overflows
        local ModeMenu = Instance.new("Frame")
        ModeMenu.Name               = "ModeMenu"
        ModeMenu.AnchorPoint        = Vector2.new(1, 0)
        ModeMenu.BackgroundColor3   = Color3.fromRGB(25, 25, 25)
        ModeMenu.BorderColor3       = Color3.fromRGB(50, 50, 50)
        ModeMenu.BorderSizePixel    = 1
        ModeMenu.Size               = UDim2.fromOffset(62, 0)
        ModeMenu.Position           = UDim2.new(1, -8, 0, 22)
        ModeMenu.ZIndex             = 50
        ModeMenu.Visible            = false
        ModeMenu.ClipsDescendants   = false
        ModeMenu.Parent             = KeybindFrame

        local MML = Instance.new("UIListLayout", ModeMenu)
        MML.SortOrder = Enum.SortOrder.LayoutOrder

        -- ── Helper: Obsidian-style Display ────────────────────────────
        local function Display(overrideText)
            local text = overrideText or displayVal
            -- Obsidian calculates text bounds to auto-size the picker
            local textService = game:GetService("TextService")
            local params = Instance.new("GetTextBoundsParams")
            params.Text = text
            params.RichText = false
            params.Font = Font.fromEnum(Enum.Font.GothamBold)
            params.Size = 13
            params.Width = 200

            local bounds = Vector2.new(30, 14)
            pcall(function()
                bounds = textService:GetTextBoundsAsync(params)
            end)

            Picker.Text = text
            Picker.Size = UDim2.fromOffset(math.max(18, bounds.X + 9), math.max(18, bounds.Y + 4))
        end

        -- ── Mode buttons ───────────────────────────────────────────────
        local ModeButtons = {}
        for i, modeName in ipairs(KeybindConfig.Modes) do
            local ModeBtn = Instance.new("TextButton")
            ModeBtn.BackgroundColor3       = Color3.fromRGB(25, 25, 25)
            ModeBtn.BackgroundTransparency = 1
            ModeBtn.Size                   = UDim2.new(1, 0, 0, 21)
            ModeBtn.Text                   = modeName
            ModeBtn.Font                   = Enum.Font.GothamBold
            ModeBtn.TextSize               = 13
            ModeBtn.TextColor3             = Color3.fromRGB(200, 200, 200)
            ModeBtn.TextTransparency       = 0.5
            ModeBtn.AutoButtonColor        = false
            ModeBtn.ZIndex                 = 51
            ModeBtn.LayoutOrder            = i
            ModeBtn.Parent                 = ModeMenu

            local MB = {}

            function MB:Select()
                for _, other in pairs(ModeButtons) do
                    other:Deselect()
                end
                curMode = modeName
                ModeBtn.BackgroundTransparency = 0
                ModeBtn.TextTransparency       = 0

                ModeMenu.Visible               = false
            end

            function MB:Deselect()
                ModeBtn.BackgroundTransparency = 1
                ModeBtn.TextTransparency       = 0.5
            end

            ModeBtn.MouseButton1Click:Connect(function()
                MB:Select()
                saveState()
                safeCall(KeybindConfig.Changed, curKey, curMode)
            end)

            if curMode == modeName then MB:Select() end
            ModeButtons[modeName] = MB
        end

        -- Resize ModeMenu height
        MML:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ModeMenu.Size = UDim2.fromOffset(62, MML.AbsoluteContentSize.Y)
        end)

        -- ── Trigger connections (rebuilt on key/mode change) ──────────
        local trigC, trigEndC

        local function RebuildTrigger()
            if trigC    then trigC:Disconnect();    trigC    = nil end
            if trigEndC then trigEndC:Disconnect(); trigEndC = nil end

            if curMode == "Always" or curKey == "None" or curKey == "Unknown" then return end

            local function matchesInput(input)
                if SpecialKeysInput[input.UserInputType] == curKey then return true end
                return input.UserInputType == Enum.UserInputType.Keyboard
                    and input.KeyCode.Name == curKey
            end

            trigC = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe or Picking or UserInputService:GetFocusedTextBox() then return end
                if curMode == "Always" or curKey == "None" or curKey == "Unknown" then return end
                if not AreModifiersHeld(curMods) then return end
                if not matchesInput(input) then return end

                if curMode == "Toggle" then
                    toggled = not toggled
                    safeCall(KeybindConfig.Callback, toggled)
                end
            end)

            if curMode == "Hold" then
                trigEndC = UserInputService.InputEnded:Connect(function(input)
                    if Picking or UserInputService:GetFocusedTextBox() then return end
                    if not matchesInput(input) then return end
                    toggled = false
                    safeCall(KeybindConfig.Callback, toggled)
                end)
            end
        end

        -- Also fire Hold on InputBegan
        table.insert(Signals, UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe or Picking or UserInputService:GetFocusedTextBox() then return end
            if curMode ~= "Hold" or curKey == "None" or curKey == "Unknown" then return end

            local function matchesInput(inp)
                if SpecialKeysInput[inp.UserInputType] == curKey then return true end
                return inp.UserInputType == Enum.UserInputType.Keyboard
                    and inp.KeyCode.Name == curKey
            end

            if not AreModifiersHeld(curMods) then return end
            if not matchesInput(input) then return end
            toggled = true
            safeCall(KeybindConfig.Callback, toggled)
        end))

        table.insert(Signals, UserInputService.InputEnded:Connect(function()
            if Picking or UserInputService:GetFocusedTextBox() then return end
            if curMode ~= "Hold" then return end
            -- Update display only
        end))

        -- ── Left-click: Obsidian picking loop ─────────────────────────
        Picker.MouseButton1Click:Connect(function()
            if Picking then return end
            Picking = true

            Picker.Text = "..."
            Picker.Size = UDim2.fromOffset(29, 18)

            local Input
            local ActiveModifiers = {}

            local GetInput = function()
                Input = UserInputService.InputBegan:Wait()
                return UserInputService:GetFocusedTextBox() ~= nil
            end

            repeat
                task.wait()

                Picker.Text = "..."
                Picker.Size = UDim2.fromOffset(29, 18)

                if GetInput() then
                    Picking = false
                    Display()
                    return
                end

                if Input.KeyCode == Enum.KeyCode.Escape then
                    break
                end

                if IsModifierInput(Input) then
                    local StopLoop = false

                    repeat
                        task.wait()
                        if UserInputService:IsKeyDown(Input.KeyCode) then
                            task.wait(0.075)
                            if UserInputService:IsKeyDown(Input.KeyCode) then
                                if not table.find(ActiveModifiers, ModifiersInput[Input.KeyCode]) then
                                    table.insert(ActiveModifiers, ModifiersInput[Input.KeyCode])
                                    Display(table.concat(ActiveModifiers, " + ") .. " + ...")
                                end
                                if GetInput() then
                                    StopLoop = true
                                    break
                                end
                                if Input.KeyCode == Enum.KeyCode.Escape then break end
                                if not IsModifierInput(Input) then break end
                            else
                                if not table.find(ActiveModifiers, ModifiersInput[Input.KeyCode]) then
                                    break
                                end
                            end
                        end
                    until false

                    if StopLoop then
                        Picking = false
                        Display()
                        return
                    end
                end

                break
            until false

            local Key = "Unknown"
            if SpecialKeysInput[Input.UserInputType] ~= nil then
                Key = SpecialKeysInput[Input.UserInputType]
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                Key = Input.KeyCode == Enum.KeyCode.Escape and "None" or Input.KeyCode.Name
            end

            ActiveModifiers = (Input.KeyCode == Enum.KeyCode.Escape or Key == "Unknown") and {} or ActiveModifiers

            curKey   = Key
            curMods  = VerifyModifiers(ActiveModifiers)

            displayVal = #curMods > 0
                and (table.concat(curMods, " + ") .. " + " .. curKey)
                or curKey

            toggled = false
            Display()

            saveState()

            local newMods = ConvertToInputModifiers(curMods)
            safeCall(KeybindConfig.Changed, curKey, curMode, newMods)
            RebuildTrigger()

            -- Wait for release (Obsidian does this to prevent immediate re-trigger)
            local function isInputDown()
                if SpecialKeysInput[Input.UserInputType] then
                    return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                        and not UserInputService:GetFocusedTextBox()
                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                    return UserInputService:IsKeyDown(Input.KeyCode)
                        and not UserInputService:GetFocusedTextBox()
                end
                return false
            end

            repeat task.wait() until not isInputDown() or UserInputService:GetFocusedTextBox()
            Picking = false
        end)

        -- ── Right-click: open mode menu ────────────────────────────────
        Picker.MouseButton2Click:Connect(function()
            ModeMenu.Visible = not ModeMenu.Visible
        end)

        -- Close mode menu on click outside
        table.insert(Signals, UserInputService.InputBegan:Connect(function(input)
            if not ModeMenu.Visible then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
            task.defer(function()
                if ModeMenu.Visible then ModeMenu.Visible = false end
            end)
        end))

        -- ── Lock overlay ───────────────────────────────────────────────
        if KeybindConfig.Locked then
            local ov = Instance.new("TextButton")
            ov.Text = ""; ov.AutoButtonColor = false
            ov.Size = UDim2.new(1,0,1,0)
            ov.BackgroundColor3 = Color3.fromRGB(8,8,14)
            ov.BackgroundTransparency = 0.4
            ov.BorderSizePixel = 0; ov.ZIndex = 10
            ov.Parent = KeybindFrame
            Instance.new("UICorner", ov).CornerRadius = UDim.new(0, 4)
        end

        -- Init
        Display()
        RebuildTrigger()

        -- ── API ────────────────────────────────────────────────────────
        local KeybindFunc = {}

        function KeybindFunc:Set(value, silent)
            curKey     = (not value or value == "") and "None" or tostring(value)
            displayVal = curKey
            Display()
            RebuildTrigger()
            saveState()
            if not silent then safeCall(KeybindConfig.Changed, curKey, curMode) end
        end

        function KeybindFunc:Get()     return curKey  end
        function KeybindFunc:GetMode() return curMode end

        function KeybindFunc:SetMode(mode)
            if not table.find(KeybindConfig.Modes, mode) then return end
            if ModeButtons[mode] then ModeButtons[mode]:Select() end
            curMode = mode
            saveState()
            RebuildTrigger()
        end

        function KeybindFunc:GetState()
            if curMode == "Always" then return true end
            if curMode == "Hold" then
                if curKey == "None" or curKey == "Unknown" then return false end
                if not AreModifiersHeld(curMods) then return false end
                if SpecialKeys[curKey] then
                    return UserInputService:IsMouseButtonPressed(SpecialKeys[curKey])
                        and not UserInputService:GetFocusedTextBox()
                end
                local ok, kc = pcall(function() return Enum.KeyCode[curKey] end)
                return ok and UserInputService:IsKeyDown(kc) and not UserInputService:GetFocusedTextBox() or false
            end
            return toggled
        end

        function KeybindFunc:Clear(silent)      KeybindFunc:Set("None", silent)          end
        function KeybindFunc:SetTitle(t)        KBTitle.Text = tostring(t or "Keybind")  end
        function KeybindFunc:SetContent(t)      KBContent.Text = tostring(t or "")       end

        function KeybindFunc:Destroy()
            if trigC    then trigC:Disconnect()    end
            if trigEndC then trigEndC:Disconnect() end
            for _, c in ipairs(Signals) do
                if c and c.Connected then c:Disconnect() end
            end
            KeybindFrame:Destroy()
        end

        if KeybindConfig.Flag and KeybindConfig.Flag ~= "" and Elements then
            Elements[KeybindConfig.Flag] = KeybindFunc
        end

        return KeybindFunc
    end

    return KeybindModule
end)()
local DialogModule   = (function()
    -- // dialog.lua | Velaris UI Dialog Module

    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")

    local ActiveDialog = nil

    local function Dialog(DialogConfig)
        DialogConfig = DialogConfig or {}
        DialogConfig.Title   = DialogConfig.Title or "Dialog"
        DialogConfig.Content = DialogConfig.Content or ""
        DialogConfig.Buttons = DialogConfig.Buttons or {}

        if ActiveDialog and ActiveDialog.Parent then
            pcall(function() ActiveDialog:Destroy() end)
        end

        local DialogGui = Instance.new("ScreenGui")
        DialogGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        DialogGui.Name = "DialogGui"
        DialogGui.Parent = CoreGui

        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.new(1, 0, 1, 0)
        Overlay.BackgroundTransparency = 1
        Overlay.ZIndex = 50
        Overlay.Name = "Overlay"
        Overlay.Parent = DialogGui

        local Dialog = Instance.new("ImageLabel")
        Dialog.Size = UDim2.new(0, 300, 0, 150)
        Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
        Dialog.Image = "rbxassetid://9542022979"
        Dialog.ImageTransparency = 0
        Dialog.BorderSizePixel = 0
        Dialog.ZIndex = 51
        Dialog.Parent = Overlay

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = Dialog

        local DialogGlow = Instance.new("Frame")
        DialogGlow.Size = UDim2.new(0, 310, 0, 160)
        DialogGlow.Position = UDim2.new(0.5, -155, 0.5, -80)
        DialogGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DialogGlow.BackgroundTransparency = 0.75
        DialogGlow.BorderSizePixel = 0
        DialogGlow.ZIndex = 50
        DialogGlow.Parent = Overlay

        local GlowCorner = Instance.new("UICorner")
        GlowCorner.CornerRadius = UDim.new(0, 10)
        GlowCorner.Parent = DialogGlow

        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0,  Color3.fromRGB(0, 191, 255)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.0,  Color3.fromRGB(0, 191, 255))
        })
        Gradient.Rotation = 90
        Gradient.Parent = DialogGlow

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Position = UDim2.new(0, 0, 0, 4)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.GothamBold
        Title.Text = DialogConfig.Title
        Title.TextSize = 22
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.ZIndex = 52
        Title.Parent = Dialog

        local Message = Instance.new("TextLabel")
        Message.Size = UDim2.new(1, -20, 0, 60)
        Message.Position = UDim2.new(0, 10, 0, 30)
        Message.BackgroundTransparency = 1
        Message.Font = Enum.Font.Gotham
        Message.Text = DialogConfig.Content
        Message.TextSize = 14
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextWrapped = true
        Message.ZIndex = 52
        Message.Parent = Dialog

        for i, buttonConfig in ipairs(DialogConfig.Buttons) do
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0.45, -10, 0, 35)
            if i == 1 then
                Button.Position = UDim2.new(0.05, 0, 1, -55)
            else
                Button.Position = UDim2.new(0.5, 10, 1, -55)
            end
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 0.935
            Button.Text = buttonConfig.Name or "Button"
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 15
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextTransparency = 0.3
            Button.ZIndex = 52
            Button.Name = "DialogButton_" .. i
            Button.Parent = Dialog

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                if buttonConfig.Callback and type(buttonConfig.Callback) == "function" then
                    pcall(function() buttonConfig.Callback() end)
                end
                pcall(function()
                    DialogGui:Destroy()
                    if ActiveDialog == DialogGui then ActiveDialog = nil end
                end)
            end)
        end

        ActiveDialog = DialogGui
        return DialogGui
    end

    return Dialog
end)()
local NotifyFactory       = (function()
    -- // VelarisUI | Notify.lua | SpeedHubX Style |

    local function MakeNotifyModule(TweenService, CoreGui, getIconId, defaultColor)

        local TextService = game:GetService("TextService")

        local function Create(Name, Properties, Parent)
            local inst = Instance.new(Name)
            for i, v in pairs(Properties) do
                inst[i] = v
            end
            if Parent then inst.Parent = Parent end
            return inst
        end

        local NotifyModule = {}

        function NotifyModule:MakeNotify(NotifyConfig)
            NotifyConfig             = NotifyConfig or {}
            NotifyConfig.Title       = NotifyConfig.Title or "VelarisUI"
            NotifyConfig.Description = NotifyConfig.Description or ""
            NotifyConfig.Content     = NotifyConfig.Content or ""
            NotifyConfig.Icon        = NotifyConfig.Icon or ""
            NotifyConfig.Time        = tonumber(NotifyConfig.Time) or 0.5
            NotifyConfig.Delay       = tonumber(NotifyConfig.Delay) or 5
            NotifyConfig.Buttons     = NotifyConfig.Buttons or {}

            if typeof(NotifyConfig.Color) ~= "Color3" then
                if typeof(defaultColor) == "Color3" then
                    NotifyConfig.Color = defaultColor
                else
                    NotifyConfig.Color = Color3.fromRGB(0, 170, 210)
                end
            end

            local NotifyFunction = {}
            local isClosing = false

            spawn(function()
                local notifyGui = CoreGui:FindFirstChild("VelarisNotifyGui")
                if not notifyGui then
                    notifyGui = Create("ScreenGui", {
                        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                        Name           = "VelarisNotifyGui",
                        ResetOnSpawn   = false,
                    }, CoreGui)
                end

                local notifyLayout = notifyGui:FindFirstChild("NotifyLayout")
                if not notifyLayout then
                    notifyLayout = Create("Frame", {
                        AnchorPoint            = Vector2.new(1, 1),
                        BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.999,
                        BorderSizePixel        = 0,
                        Position               = UDim2.new(1, -30, 1, -30),
                        Size                   = UDim2.new(0, 260, 1, 0),
                        Name                   = "NotifyLayout",
                    }, notifyGui)

                    local function reorganizeStack()
                        local Count = 0
                        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        for _, v in ipairs(notifyLayout:GetChildren()) do
                            if v:IsA("Frame") and v.Name == "NotifyFrame" then
                                local NewPOS = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))
                                TweenService:Create(v, tweenInfo, { Position = NewPOS }):Play()
                                Count += 1
                            end
                        end
                    end

                    notifyLayout.ChildRemoved:Connect(reorganizeStack)
                    notifyLayout.ChildAdded:Connect(reorganizeStack)
                end

                local _Count = 0
                for _, v in ipairs(notifyLayout:GetChildren()) do
                    if v:IsA("Frame") and v.Name == "NotifyFrame" then
                        _Count = -v.Position.Y.Offset + v.Size.Y.Offset + 12
                    end
                end

                local notifyFrame = Create("Frame", {
                    BackgroundColor3       = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel        = 0,
                    Size                   = UDim2.new(1, 0, 0, 70),
                    AnchorPoint            = Vector2.new(0, 1),
                    Position               = UDim2.new(0, 0, 1, -_Count),
                    Name                   = "NotifyFrame",
                }, notifyLayout)

                local notifyFrameReal = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 400, 0, 0),
                    Size             = UDim2.new(1, 0, 1, 0),
                    Name             = "NotifyFrameReal",
                }, notifyFrame)

                Create("UICorner", { CornerRadius = UDim.new(0, 8) }, notifyFrameReal)

                Create("UIStroke", {
                    Color     = Color3.fromRGB(50, 50, 50),
                    Thickness = 1.6,
                }, notifyFrameReal)

                local shadowHolder = Create("Frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel        = 0,
                    Size                   = UDim2.new(1, 0, 1, 0),
                    ZIndex                 = 0,
                    Name                   = "DropShadowHolder",
                }, notifyFrameReal)

                Create("ImageLabel", {
                    Image                  = "",
                    ImageColor3            = Color3.fromRGB(0, 0, 0),
                    ImageTransparency      = 0.5,
                    ScaleType              = Enum.ScaleType.Slice,
                    SliceCenter            = Rect.new(49, 49, 450, 450),
                    AnchorPoint            = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    BorderSizePixel        = 0,
                    Position               = UDim2.new(0.5, 0, 0.5, 0),
                    Size                   = UDim2.new(1, 47, 1, 47),
                    ZIndex                 = 0,
                    Name                   = "DropShadow",
                }, shadowHolder)

                local Top = Create("Frame", {
                    BackgroundColor3       = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel        = 0,
                    Size                   = UDim2.new(1, 0, 0, 30),
                    Name                   = "Top",
                }, notifyFrameReal)

                Create("UICorner", { CornerRadius = UDim.new(0, 5) }, Top)

                local iconId = getIconId(NotifyConfig.Icon)
                local hasIcon = iconId ~= ""

                if hasIcon then
                    Create("ImageLabel", {
                        Image                  = iconId,
                        ImageColor3            = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.999,
                        BorderSizePixel        = 0,
                        Position               = UDim2.new(0, 8, 0.5, -6),
                        Size                   = UDim2.new(0, 12, 0, 12),
                        ScaleType              = Enum.ScaleType.Fit,
                        Name                   = "IconImg",
                    }, Top)
                end

                local titleOffsetX = hasIcon and 26 or 10

                local titleLabel = Create("TextLabel", {
                    Font                   = Enum.Font.GothamBold,
                    Text                   = NotifyConfig.Title,
                    TextColor3             = Color3.fromRGB(255, 255, 255),
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel        = 0,
                    Size                   = UDim2.new(1, 0, 1, 0),
                    Position               = UDim2.new(0, titleOffsetX, 0, 0),
                    Name                   = "TitleLabel",
                }, Top)

                Create("UIStroke", {
                    Color     = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.3,
                }, titleLabel)

                if NotifyConfig.Description ~= "" then
                    local descLabel = Create("TextLabel", {
                        Font                   = Enum.Font.GothamBold,
                        Text                   = NotifyConfig.Description,
                        TextColor3             = NotifyConfig.Color,
                        TextSize               = 12,
                        TextXAlignment         = Enum.TextXAlignment.Left,
                        BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.999,
                        BorderSizePixel        = 0,
                        Size                   = UDim2.new(1, 0, 1, 0),
                        Position               = UDim2.new(0, titleOffsetX + titleLabel.TextBounds.X + 10, 0, 0),
                        Name                   = "DescLabel",
                    }, Top)

                    Create("UIStroke", {
                        Color     = NotifyConfig.Color,
                        Thickness = 0.4,
                    }, descLabel)
                end

                local closeBtn = Create("TextButton", {
                    Font                   = Enum.Font.SourceSans,
                    Text                   = "",
                    TextColor3             = Color3.fromRGB(0, 0, 0),
                    TextSize               = 14,
                    AnchorPoint            = Vector2.new(1, 0.5),
                    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel        = 0,
                    Position               = UDim2.new(1, -8, 0.5, 0),
                    Size                   = UDim2.new(0, 25, 0, 25),
                    Name                   = "CloseBtn",
                }, Top)

                Create("ImageLabel", {
                    Image                  = "rbxassetid://9886659671",
                    AnchorPoint            = Vector2.new(0.5, 0.5),
                    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel        = 0,
                    Position               = UDim2.new(0.49, 0, 0.5, 0),
                    Size                   = UDim2.new(1, -8, 1, -8),
                }, closeBtn)

                local hasButtons = #NotifyConfig.Buttons > 0

                -- Lebar frame real (260) dikurangi padding kiri+kanan (10+10)
                local FRAME_WIDTH   = 240
                local CONTENT_FONT  = Enum.Font.GothamBold
                local CONTENT_SIZE  = 11

                -- Hitung tinggi teks pakai TextService supaya akurat walau panjang
                local textBounds = TextService:GetTextSize(
                    NotifyConfig.Content,
                    CONTENT_SIZE,
                    CONTENT_FONT,
                    Vector2.new(FRAME_WIDTH, math.huge)
                )

                local contentH = math.max(textBounds.Y, CONTENT_SIZE)

                local textLabel = Create("TextLabel", {
                    Font                   = CONTENT_FONT,
                    Text                   = NotifyConfig.Content,
                    TextColor3             = Color3.fromRGB(150, 150, 150),
                    TextSize               = CONTENT_SIZE,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    TextYAlignment         = Enum.TextYAlignment.Top,
                    TextWrapped            = true,
                    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel        = 0,
                    -- posisi Y = 30 (Top bar) + 6 (gap)
                    Position               = UDim2.new(0, 10, 0, 36),
                    Size                   = UDim2.new(1, -20, 0, contentH),
                    Name                   = "ContentText",
                }, notifyFrameReal)

                -- Total tinggi frame: 30 (top bar) + 6 (gap atas) + contentH + 10 (gap bawah)
                local totalFrameH = 30 + 6 + contentH + 10
                if totalFrameH < 52 then totalFrameH = 52 end

                notifyFrame.Size = UDim2.new(1, 0, 0, totalFrameH)

                if hasButtons then
                    local frameH = totalFrameH

                    local btnRow = Create("Frame", {
                        BackgroundTransparency = 1,
                        BorderSizePixel        = 0,
                        Position               = UDim2.new(0, 10, 0, frameH - 4),
                        Size                   = UDim2.new(1, -20, 0, 28),
                        Name                   = "BtnRow",
                    }, notifyFrameReal)

                    Create("UIListLayout", {
                        FillDirection       = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment   = Enum.VerticalAlignment.Center,
                        Padding             = UDim.new(0, 6),
                    }, btnRow)

                    notifyFrame.Size = UDim2.new(1, 0, 0, frameH + 34)

                    for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                        local isPrimary = btnCfg.Primary == true

                        local btn = Create("TextButton", {
                            Font                   = Enum.Font.GothamBold,
                            Text                   = btnCfg.Name or ("Button " .. idx),
                            TextSize               = 12,
                            TextColor3             = Color3.fromRGB(255, 255, 255),
                            TextTransparency       = isPrimary and 0.1 or 0.3,
                            BackgroundColor3       = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 0.935,
                            BorderSizePixel        = 0,
                            LayoutOrder            = idx,
                            Size                   = UDim2.new(1 / #NotifyConfig.Buttons, -((6 * (#NotifyConfig.Buttons - 1)) / #NotifyConfig.Buttons), 1, 0),
                        }, btnRow)

                        Create("UICorner", { CornerRadius = UDim.new(0, 4) }, btn)

                        if isPrimary then
                            Create("UIStroke", {
                                Color        = NotifyConfig.Color,
                                Thickness    = 1,
                                Transparency = 0.4,
                            }, btn)
                        end

                        btn.Activated:Connect(function()
                            if btnCfg.Callback then
                                local ok, err = pcall(btnCfg.Callback)
                                if not ok then warn("Notify Button Error: " .. tostring(err)) end
                            end
                            NotifyFunction:Close()
                        end)
                    end
                end

                function NotifyFunction:Close()
                    if isClosing then return false end
                    isClosing = true

                    local tween = TweenService:Create(
                        notifyFrameReal,
                        TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                        { Position = UDim2.new(0, 400, 0, 0) }
                    )
                    tween:Play()

                    task.wait(NotifyConfig.Time / 1.2)
                    if notifyFrame and notifyFrame.Parent then
                        notifyFrame:Destroy()
                    end

                    isClosing = false
                    return true
                end

                closeBtn.Activated:Connect(function() NotifyFunction:Close() end)

                TweenService:Create(
                    notifyFrameReal,
                    TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                    { Position = UDim2.new(0, 0, 0, 0) }
                ):Play()

                if NotifyConfig.Delay > 0 then
                    task.wait(NotifyConfig.Delay)
                    NotifyFunction:Close()
                end
            end)

            return NotifyFunction
        end

        function NotifyModule:Nt(msg, delay, color, title, desc)
            return self:MakeNotify({
                Title       = title or "VelarisUI",
                Description = desc  or "Notification",
                Content     = msg   or "",
                Color       = (typeof(color) == "Color3") and color or nil,
                Delay       = delay or 4,
            })
        end

        return NotifyModule
    end

    return MakeNotifyModule
end)()
local TabsModule          = loadUrl("https://fitri324.pythonanywhere.com/Tabs.lua/raw")
local SearchModule        = loadUrl("https://fitri324.pythonanywhere.com/Search.lua/raw")
local _ColorpickerSetup   = loadUrl("https://fitri324.pythonanywhere.com/Colorpicker.lua/raw")

local defaultIcons = (function()
    -- defaulticons.lua

    local defaulticons = {
        nexa     = "rbxassetid://0",
        vikai     = "rbxassetid://0",
        alert     = "rbxassetid://73186275216515",
        bag       = "rbxassetid://8601111810",
        boss      = "rbxassetid://13132186360",
        cart      = "rbxassetid://128874923961846",
        compas    = "rbxassetid://125300760963399",
        crosshair = "rbxassetid://12614416478",
        dcs       = "rbxassetid://15310731934",
        discord   = "rbxassetid://94434236999817",
        eyes      = "rbxassetid://14321059114",
        fish      = "rbxassetid://97167558235554",
        folder    = "rbxassetid://111411260968321",
        gamepad   = "rbxassetid://84173963561612",
        gps       = "rbxassetid://17824309485",
        idea      = "rbxassetid://16833255748",
        lexshub   = "rbxassetid://71947103252559",
        loop      = "rbxassetid://122032243989747",
        menu      = "rbxassetid://6340513838",
        next      = "rbxassetid://12662718374",
        Notify    = "rbxassetid://70884221600423",
        payment   = "rbxassetid://18747025078",
        player    = "rbxassetid://12120698352",
        plug      = "rbxassetid://137601480983962",
        question  = "rbxassetid://17510196486",
        rod       = "rbxassetid://103247953194129",
        scan      = "rbxassetid://109869955247116",
        scroll    = "rbxassetid://114127804740858",
        settings  = "rbxassetid://70386228443175",
        shop      = "rbxassetid://4985385964",
        skeleton  = "rbxassetid://17313330026",
        star      = "rbxassetid://107005941750079",
        start     = "rbxassetid://108886429866687",
        stat      = "rbxassetid://12094445329",
        strom     = "rbxassetid://13321880293",
        sword     = "rbxassetid://82472368671405",
        sword1    = "rbxassetid://109643735374029",
        user      = "rbxassetid://108483430622128",
        water     = "rbxassetid://100076212630732",
        web       = "rbxassetid://137601480983962",
    }

    return defaulticons
end)()
local lucideIcons  = (function()
    local lucideIcons = {
      ["a-arrow-down"] = "rbxassetid://92867583610071",
    	["a-arrow-up"] = "rbxassetid://132318504999733",
    	["a-large-small"] = "rbxassetid://111491496660216",
    	["accessibility"] = "rbxassetid://114029945302017",
    	["activity"] = "rbxassetid://94212016861936",
    	["air-vent"] = "rbxassetid://81517226012329",
    	["airplay"] = "rbxassetid://115020759309179",
    	["alarm-clock-check"] = "rbxassetid://76437352099157",
    	["alarm-clock-minus"] = "rbxassetid://77364179863205",
    	["alarm-clock-off"] = "rbxassetid://97904885874823",
    	["alarm-clock-plus"] = "rbxassetid://80468822979214",
    	["alarm-clock"] = "rbxassetid://126259032907535",
    	["alarm-smoke"] = "rbxassetid://96965448419685",
    	["album"] = "rbxassetid://127358331163602",
    	["align-center-horizontal"] = "rbxassetid://81570549209434",
    	["align-center-vertical"] = "rbxassetid://118470463752466",
    	["align-end-horizontal"] = "rbxassetid://139502909745427",
    	["align-end-vertical"] = "rbxassetid://96528869059554",
    	["align-horizontal-distribute-center"] = "rbxassetid://97220086126656",
    	["align-horizontal-distribute-end"] = "rbxassetid://106128590702022",
    	["align-horizontal-distribute-start"] = "rbxassetid://76074660002997",
    	["align-horizontal-justify-center"] = "rbxassetid://75732302772427",
    	["align-horizontal-justify-end"] = "rbxassetid://129167626402283",
    	["align-horizontal-justify-start"] = "rbxassetid://130161830325281",
    	["align-horizontal-space-around"] = "rbxassetid://91646106782950",
    	["align-horizontal-space-between"] = "rbxassetid://103886093046990",
    	["align-start-horizontal"] = "rbxassetid://125674804697729",
    	["align-start-vertical"] = "rbxassetid://105020230154823",
    	["align-vertical-distribute-center"] = "rbxassetid://93791183635525",
    	["align-vertical-distribute-end"] = "rbxassetid://139354223511433",
    	["align-vertical-distribute-start"] = "rbxassetid://74961997822126",
    	["align-vertical-justify-center"] = "rbxassetid://134754696166569",
    	["align-vertical-justify-end"] = "rbxassetid://92569381441969",
    	["align-vertical-justify-start"] = "rbxassetid://99692844572718",
    	["align-vertical-space-around"] = "rbxassetid://96206012459190",
    	["align-vertical-space-between"] = "rbxassetid://124998077349706",
    	["ambulance"] = "rbxassetid://78599995190651",
    	["ampersand"] = "rbxassetid://75272915739209",
    	["ampersands"] = "rbxassetid://126947193455996",
    	["amphora"] = "rbxassetid://137370389604364",
    	["anchor"] = "rbxassetid://92181172123618",
    	["angry"] = "rbxassetid://74237056000103",
    	["annoyed"] = "rbxassetid://80064369052011",
    	["antenna"] = "rbxassetid://99628923540956",
    	["anvil"] = "rbxassetid://100203029845919",
    	["aperture"] = "rbxassetid://83396154449972",
    	["app-window-mac"] = "rbxassetid://79587216113811",
    	["app-window"] = "rbxassetid://93142176757189",
    	["apple"] = "rbxassetid://104349242902442",
    	["archive-restore"] = "rbxassetid://78956681942188",
    	["archive-x"] = "rbxassetid://75830115088395",
    	["archive"] = "rbxassetid://122180020814574",
    	["armchair"] = "rbxassetid://105384358373973",
    	["arrow-big-down-dash"] = "rbxassetid://137987229582002",
    	["arrow-big-down"] = "rbxassetid://81081164158885",
    	["arrow-big-left-dash"] = "rbxassetid://97827621354677",
    	["arrow-big-left"] = "rbxassetid://85973092492641",
    	["arrow-big-right-dash"] = "rbxassetid://117825834972403",
    	["arrow-big-right"] = "rbxassetid://82960676755590",
    	["arrow-big-up-dash"] = "rbxassetid://99260194327483",
    	["arrow-big-up"] = "rbxassetid://93136954756149",
    	["arrow-down-0-1"] = "rbxassetid://120961896217875",
    	["arrow-down-1-0"] = "rbxassetid://93474255891850",
    	["arrow-down-a-z"] = "rbxassetid://99554596207900",
    	["arrow-down-from-line"] = "rbxassetid://132045845807798",
    	["arrow-down-left"] = "rbxassetid://102899325237364",
    	["arrow-down-narrow-wide"] = "rbxassetid://129105261655061",
    	["arrow-down-right"] = "rbxassetid://123109928624974",
    	["arrow-down-to-dot"] = "rbxassetid://101675355931221",
    	["arrow-down-to-line"] = "rbxassetid://87050478931254",
    	["arrow-down-up"] = "rbxassetid://85780258549577",
    	["arrow-down-wide-narrow"] = "rbxassetid://88461733425991",
    	["arrow-down-z-a"] = "rbxassetid://76115279362232",
    	["arrow-down"] = "rbxassetid://98764963621439",
    	["arrow-left-from-line"] = "rbxassetid://87857914437603",
    	["arrow-left-right"] = "rbxassetid://131324733048447",
    	["arrow-left-to-line"] = "rbxassetid://118645136026970",
    	["arrow-left"] = "rbxassetid://102531941843733",
    	["arrow-right-from-line"] = "rbxassetid://74073639809355",
    	["arrow-right-left"] = "rbxassetid://77015754304300",
    	["arrow-right-to-line"] = "rbxassetid://78632510329852",
    	["arrow-right"] = "rbxassetid://113692007244654",
    	["arrow-up-0-1"] = "rbxassetid://105257823943016",
    	["arrow-up-1-0"] = "rbxassetid://134175521693798",
    	["arrow-up-a-z"] = "rbxassetid://77763416595160",
    	["arrow-up-down"] = "rbxassetid://81019887641527",
    	["arrow-up-from-dot"] = "rbxassetid://124408496673275",
    	["arrow-up-from-line"] = "rbxassetid://95777664626453",
    	["arrow-up-left"] = "rbxassetid://123490598231261",
    	["arrow-up-narrow-wide"] = "rbxassetid://73006024672636",
    	["arrow-up-right"] = "rbxassetid://129280608535523",
    	["arrow-up-to-line"] = "rbxassetid://108818207813537",
    	["arrow-up-wide-narrow"] = "rbxassetid://87437426951568",
    	["arrow-up-z-a"] = "rbxassetid://107546173611884",
    	["arrow-up"] = "rbxassetid://89282378235317",
    	["arrows-up-from-line"] = "rbxassetid://133710016938621",
    	["asterisk"] = "rbxassetid://88552752106723",
    	["at-sign"] = "rbxassetid://79059152889146",
    	["atom"] = "rbxassetid://73167696981648",
    	["audio-lines"] = "rbxassetid://70930641819242",
    	["audio-waveform"] = "rbxassetid://86462036665209",
    	["award"] = "rbxassetid://132740088158419",
    	["axe"] = "rbxassetid://132405197863294",
    	["axis-3d"] = "rbxassetid://122438676546804",
    	["baby"] = "rbxassetid://93472926933440",
    	["backpack"] = "rbxassetid://140420225386018",
    	["badge-alert"] = "rbxassetid://101829200081951",
    	["badge-cent"] = "rbxassetid://133345018873154",
    	["badge-check"] = "rbxassetid://76078495178149",
    	["badge-dollar-sign"] = "rbxassetid://127139803581141",
    	["badge-euro"] = "rbxassetid://120016477674659",
    	["badge-indian-rupee"] = "rbxassetid://75659682309981",
    	["badge-info"] = "rbxassetid://131995373201472",
    	["badge-japanese-yen"] = "rbxassetid://99081574588615",
    	["badge-minus"] = "rbxassetid://140321561183881",
    	["badge-percent"] = "rbxassetid://121359224294885",
    	["badge-plus"] = "rbxassetid://100325578561866",
    	["badge-pound-sterling"] = "rbxassetid://119688217279444",
    	["badge-question-mark"] = "rbxassetid://121464963737502",
    	["badge-russian-ruble"] = "rbxassetid://108839463659864",
    	["badge-swiss-franc"] = "rbxassetid://91447608372740",
    	["badge-turkish-lira"] = "rbxassetid://137839965873529",
    	["badge-x"] = "rbxassetid://122931434733842",
    	["badge"] = "rbxassetid://116620312917084",
    	["baggage-claim"] = "rbxassetid://86922213051957",
    	["ban"] = "rbxassetid://90767043015246",
    	["banana"] = "rbxassetid://140713420056179",
    	["bandage"] = "rbxassetid://129660129590770",
    	["banknote-arrow-down"] = "rbxassetid://139366449345199",
    	["banknote-arrow-up"] = "rbxassetid://133758343082529",
    	["banknote-x"] = "rbxassetid://95348701438065",
    	["banknote"] = "rbxassetid://104840231536668",
    	["barcode"] = "rbxassetid://118473018143689",
    	["barrel"] = "rbxassetid://130647115622774",
    	["baseline"] = "rbxassetid://124677132511270",
    	["bath"] = "rbxassetid://76031400297942",
    	["battery-charging"] = "rbxassetid://80139357470047",
    	["battery-full"] = "rbxassetid://70906718268972",
    	["battery-low"] = "rbxassetid://139659256984314",
    	["battery-medium"] = "rbxassetid://105934079398915",
    	["battery-plus"] = "rbxassetid://91931341486966",
    	["battery-warning"] = "rbxassetid://115230083817257",
    	["battery"] = "rbxassetid://70765800346189",
    	["beaker"] = "rbxassetid://80902539995520",
    	["bean-off"] = "rbxassetid://98164436608714",
    	["bean"] = "rbxassetid://89491967076869",
    	["bed-double"] = "rbxassetid://73820193212911",
    	["bed-single"] = "rbxassetid://113423940880634",
    	["bed"] = "rbxassetid://97726529032925",
    	["beef"] = "rbxassetid://105850162318915",
    	["beer-off"] = "rbxassetid://120333134736361",
    	["beer"] = "rbxassetid://116404978807744",
    	["bell-dot"] = "rbxassetid://93161277118810",
    	["bell-electric"] = "rbxassetid://100277767266983",
    	["bell-minus"] = "rbxassetid://126334890449727",
    	["bell-off"] = "rbxassetid://78560046118930",
    	["bell-plus"] = "rbxassetid://77014333795836",
    	["bell-ring"] = "rbxassetid://94612128913941",
    	["bell"] = "rbxassetid://97392696311902",
    	["between-horizontal-end"] = "rbxassetid://81602774794322",
    	["between-horizontal-start"] = "rbxassetid://76112384929846",
    	["between-vertical-end"] = "rbxassetid://72817612571631",
    	["between-vertical-start"] = "rbxassetid://85278312190301",
    	["biceps-flexed"] = "rbxassetid://82004462003936",
    	["bike"] = "rbxassetid://102930322246035",
    	["binary"] = "rbxassetid://91751953950088",
    	["binoculars"] = "rbxassetid://101460003267896",
    	["biohazard"] = "rbxassetid://95956532900432",
    	["bird"] = "rbxassetid://132284145117371",
    	["birdhouse"] = "rbxassetid://83999157401433",
    	["bitcoin"] = "rbxassetid://95459240442938",
    	["blend"] = "rbxassetid://111679612185257",
    	["blinds"] = "rbxassetid://71164165283925",
    	["blocks"] = "rbxassetid://72212693357737",
    	["bluetooth-connected"] = "rbxassetid://96315134002985",
    	["bluetooth-off"] = "rbxassetid://80600044218117",
    	["bluetooth-searching"] = "rbxassetid://100673019606426",
    	["bluetooth"] = "rbxassetid://90506573139443",
    	["bold"] = "rbxassetid://116141470019166",
    	["bolt"] = "rbxassetid://102881251417484",
    	["bomb"] = "rbxassetid://139223800924636",
    	["bone"] = "rbxassetid://111242153474115",
    	["book-a"] = "rbxassetid://104067275658465",
    	["book-alert"] = "rbxassetid://124159928044853",
    	["book-audio"] = "rbxassetid://109208148317037",
    	["book-check"] = "rbxassetid://115999656081696",
    	["book-copy"] = "rbxassetid://108543407492005",
    	["book-dashed"] = "rbxassetid://127430784795958",
    	["book-down"] = "rbxassetid://101011730128222",
    	["book-headphones"] = "rbxassetid://108670200799574",
    	["book-heart"] = "rbxassetid://112788845135284",
    	["book-image"] = "rbxassetid://80808285757226",
    	["book-key"] = "rbxassetid://116024426170705",
    	["book-lock"] = "rbxassetid://118765061220571",
    	["book-marked"] = "rbxassetid://73211024251780",
    	["book-minus"] = "rbxassetid://112724962046282",
    	["book-open-check"] = "rbxassetid://130848362492667",
    	["book-open-text"] = "rbxassetid://100629528672195",
    	["book-open"] = "rbxassetid://129845326810392",
    	["book-plus"] = "rbxassetid://140267785051233",
    	["book-text"] = "rbxassetid://94011772484232",
    	["book-type"] = "rbxassetid://97817304725443",
    	["book-up-2"] = "rbxassetid://130161620853665",
    	["book-up"] = "rbxassetid://98640174079190",
    	["book-user"] = "rbxassetid://128489189240523",
    	["book-x"] = "rbxassetid://118754548186537",
    	["book"] = "rbxassetid://125383279695672",
    	["bookmark-check"] = "rbxassetid://93940443347986",
    	["bookmark-minus"] = "rbxassetid://96807096039910",
    	["bookmark-plus"] = "rbxassetid://121469724491615",
    	["bookmark-x"] = "rbxassetid://112272342584706",
    	["bookmark"] = "rbxassetid://121093149326239",
    	["boom-box"] = "rbxassetid://99901322535868",
    	["bot-message-square"] = "rbxassetid://96145330292478",
    	["bot-off"] = "rbxassetid://140417690560013",
    	["bot"] = "rbxassetid://80451686744860",
    	["bottle-wine"] = "rbxassetid://131675403196921",
    	["bow-arrow"] = "rbxassetid://124089655150375",
    	["box"] = "rbxassetid://101768155599700",
    	["boxes"] = "rbxassetid://136372617578355",
    	["braces"] = "rbxassetid://117761094704041",
    	["brackets"] = "rbxassetid://74368995728099",
    	["brain-circuit"] = "rbxassetid://70547962410202",
    	["brain-cog"] = "rbxassetid://132039205501538",
    	["brain"] = "rbxassetid://92424107303177",
    	["brick-wall-fire"] = "rbxassetid://92980588705520",
    	["brick-wall-shield"] = "rbxassetid://75954432775071",
    	["brick-wall"] = "rbxassetid://112878522258821",
    	["briefcase-business"] = "rbxassetid://129135125207283",
    	["briefcase-conveyor-belt"] = "rbxassetid://108665725653714",
    	["briefcase-medical"] = "rbxassetid://119917756334087",
    	["briefcase"] = "rbxassetid://96754188164225",
    	["bring-to-front"] = "rbxassetid://132975903553748",
    	["brush-cleaning"] = "rbxassetid://71728977448805",
    	["brush"] = "rbxassetid://127035535799640",
    	["bubbles"] = "rbxassetid://106183424168227",
    	["bug-off"] = "rbxassetid://88020025049245",
    	["bug-play"] = "rbxassetid://80107955888092",
    	["bug"] = "rbxassetid://83626408925438",
    	["building-2"] = "rbxassetid://77873775611951",
    	["building"] = "rbxassetid://110616258983082",
    	["bus-front"] = "rbxassetid://89863432456045",
    	["bus"] = "rbxassetid://133798469717463",
    	["cable-car"] = "rbxassetid://128643682205596",
    	["cable"] = "rbxassetid://128449944504901",
    	["cake-slice"] = "rbxassetid://136769828413242",
    	["cake"] = "rbxassetid://103131590503275",
    	["calculator"] = "rbxassetid://74915716529646",
    	["calendar-1"] = "rbxassetid://98458364171044",
    	["calendar-arrow-down"] = "rbxassetid://108415736543437",
    	["calendar-arrow-up"] = "rbxassetid://70574654109118",
    	["calendar-check-2"] = "rbxassetid://120231170248276",
    	["calendar-check"] = "rbxassetid://71551019465748",
    	["calendar-clock"] = "rbxassetid://119132152594595",
    	["calendar-cog"] = "rbxassetid://122402172360287",
    	["calendar-days"] = "rbxassetid://99072017568595",
    	["calendar-fold"] = "rbxassetid://117368871270394",
    	["calendar-heart"] = "rbxassetid://88839008103676",
    	["calendar-minus-2"] = "rbxassetid://98846170279891",
    	["calendar-minus"] = "rbxassetid://137354318924383",
    	["calendar-off"] = "rbxassetid://109726151749217",
    	["calendar-plus-2"] = "rbxassetid://112264562093883",
    	["calendar-plus"] = "rbxassetid://125266115249843",
    	["calendar-range"] = "rbxassetid://103641849247576",
    	["calendar-search"] = "rbxassetid://92010083223634",
    	["calendar-sync"] = "rbxassetid://78082218499697",
    	["calendar-x-2"] = "rbxassetid://107518051061147",
    	["calendar-x"] = "rbxassetid://106703374806500",
    	["calendar"] = "rbxassetid://114792700814035",
    	["camera-off"] = "rbxassetid://81057636835256",
    	["camera"] = "rbxassetid://79950339943067",
    	["candy-cane"] = "rbxassetid://71689468772492",
    	["candy-off"] = "rbxassetid://110232752314832",
    	["candy"] = "rbxassetid://107812129154678",
    	["cannabis"] = "rbxassetid://98792006538601",
    	["captions-off"] = "rbxassetid://105223545364193",
    	["captions"] = "rbxassetid://104960225031445",
    	["car-front"] = "rbxassetid://87380942739063",
    	["car-taxi-front"] = "rbxassetid://122455403384057",
    	["car"] = "rbxassetid://121065933462582",
    	["caravan"] = "rbxassetid://120070979471783",
    	["card-sim"] = "rbxassetid://134490550095771",
    	["carrot"] = "rbxassetid://119118221444304",
    	["case-lower"] = "rbxassetid://129303130603241",
    	["case-sensitive"] = "rbxassetid://125410273293056",
    	["case-upper"] = "rbxassetid://111633433531325",
    	["cassette-tape"] = "rbxassetid://137065788934157",
    	["cast"] = "rbxassetid://98202245922071",
    	["castle"] = "rbxassetid://119275077187784",
    	["cat"] = "rbxassetid://124252153404931",
    	["cctv"] = "rbxassetid://99979894766624",
    	["chart-area"] = "rbxassetid://123446436762366",
    	["chart-bar-big"] = "rbxassetid://72336824986044",
    	["chart-bar-decreasing"] = "rbxassetid://107217459044963",
    	["chart-bar-increasing"] = "rbxassetid://88268905998571",
    	["chart-bar-stacked"] = "rbxassetid://98478751113024",
    	["chart-bar"] = "rbxassetid://105389816384108",
    	["chart-candlestick"] = "rbxassetid://125676898615697",
    	["chart-column-big"] = "rbxassetid://98598733210787",
    	["chart-column-decreasing"] = "rbxassetid://73586137373563",
    	["chart-column-increasing"] = "rbxassetid://120421615068601",
    	["chart-column-stacked"] = "rbxassetid://86031449675105",
    	["chart-column"] = "rbxassetid://97915995538580",
    	["chart-gantt"] = "rbxassetid://88811660555940",
    	["chart-line"] = "rbxassetid://101833156055618",
    	["chart-network"] = "rbxassetid://104027882693561",
    	["chart-no-axes-column-decreasing"] = "rbxassetid://123371717192542",
    	["chart-no-axes-column-increasing"] = "rbxassetid://140383830943049",
    	["chart-no-axes-column"] = "rbxassetid://94078751170351",
    	["chart-no-axes-combined"] = "rbxassetid://121424233161912",
    	["chart-no-axes-gantt"] = "rbxassetid://131936541106368",
    	["chart-pie"] = "rbxassetid://113412261630136",
    	["chart-scatter"] = "rbxassetid://108217585014571",
    	["chart-spline"] = "rbxassetid://90307460742494",
    	["check-check"] = "rbxassetid://95183312173858",
    	["check-line"] = "rbxassetid://115122343485290",
    	["check"] = "rbxassetid://93898873302694",
    	["chef-hat"] = "rbxassetid://121744015002573",
    	["cherry"] = "rbxassetid://139519182403183",
    	["chess-bishop"] = "rbxassetid://121701705580238",
    	["chess-king"] = "rbxassetid://90885687223462",
    	["chess-knight"] = "rbxassetid://96467707042169",
    	["chess-pawn"] = "rbxassetid://111318574652751",
    	["chess-queen"] = "rbxassetid://98304702099749",
    	["chess-rook"] = "rbxassetid://76223925830262",
    	["chevron-down"] = "rbxassetid://134243273101015",
    	["chevron-first"] = "rbxassetid://105243363790238",
    	["chevron-last"] = "rbxassetid://89268452603731",
    	["chevron-left"] = "rbxassetid://73780377692148",
    	["chevron-right"] = "rbxassetid://92473583511724",
    	["chevron-up"] = "rbxassetid://122444883127455",
    	["chevrons-down-up"] = "rbxassetid://139404716013205",
    	["chevrons-down"] = "rbxassetid://100524612205956",
    	["chevrons-left-right-ellipsis"] = "rbxassetid://125035817741526",
    	["chevrons-left-right"] = "rbxassetid://87910685945204",
    	["chevrons-left"] = "rbxassetid://82617201744347",
    	["chevrons-right-left"] = "rbxassetid://87149546686569",
    	["chevrons-right"] = "rbxassetid://139121276490483",
    	["chevrons-up-down"] = "rbxassetid://131833120209646",
    	["chevrons-up"] = "rbxassetid://100467452364672",
    	["chromium"] = "rbxassetid://128165143739006",
    	["church"] = "rbxassetid://113714744350666",
    	["cigarette-off"] = "rbxassetid://77797883078452",
    	["circle-alert"] = "rbxassetid://83898160590116",
    	["circle-arrow-down"] = "rbxassetid://95901860261344",
    	["circle-arrow-left"] = "rbxassetid://102148876968988",
    	["circle-arrow-out-down-left"] = "rbxassetid://140598097856694",
    	["circle-arrow-out-down-right"] = "rbxassetid://119952801379305",
    	["circle-arrow-out-up-left"] = "rbxassetid://132858212688303",
    	["circle-arrow-out-up-right"] = "rbxassetid://81783743753173",
    	["circle-arrow-right"] = "rbxassetid://70786767999559",
    	["circle-arrow-up"] = "rbxassetid://84395128546494",
    	["circle-check-big"] = "rbxassetid://93202927221730",
    	["circle-check"] = "rbxassetid://85262178816537",
    	["circle-chevron-down"] = "rbxassetid://137069490345718",
    	["circle-chevron-left"] = "rbxassetid://130250009740827",
    	["circle-chevron-right"] = "rbxassetid://125943696958495",
    	["circle-chevron-up"] = "rbxassetid://111223574026321",
    	["circle-dashed"] = "rbxassetid://126799443883746",
    	["circle-divide"] = "rbxassetid://106398997754208",
    	["circle-dollar-sign"] = "rbxassetid://91106238890387",
    	["circle-dot-dashed"] = "rbxassetid://111451232827180",
    	["circle-dot"] = "rbxassetid://82947033619201",
    	["circle-ellipsis"] = "rbxassetid://91687150884779",
    	["circle-equal"] = "rbxassetid://95133963751438",
    	["circle-fading-arrow-up"] = "rbxassetid://104648212910336",
    	["circle-fading-plus"] = "rbxassetid://91847890443490",
    	["circle-gauge"] = "rbxassetid://108157549473765",
    	["circle-minus"] = "rbxassetid://133556159576809",
    	["circle-off"] = "rbxassetid://97923456918886",
    	["circle-parking-off"] = "rbxassetid://128369410981252",
    	["circle-parking"] = "rbxassetid://124034962915196",
    	["circle-pause"] = "rbxassetid://139337739700879",
    	["circle-percent"] = "rbxassetid://133311912860256",
    	["circle-play"] = "rbxassetid://120408917249739",
    	["circle-plus"] = "rbxassetid://113157136350384",
    	["circle-pound-sterling"] = "rbxassetid://105476153083828",
    	["circle-power"] = "rbxassetid://140676030155098",
    	["circle-question-mark"] = "rbxassetid://97516698664325",
    	["circle-slash-2"] = "rbxassetid://136766902186549",
    	["circle-slash"] = "rbxassetid://125206439913049",
    	["circle-small"] = "rbxassetid://73685402843600",
    	["circle-star"] = "rbxassetid://120318414957104",
    	["circle-stop"] = "rbxassetid://87400503942659",
    	["circle-user-round"] = "rbxassetid://95489465399880",
    	["circle-user"] = "rbxassetid://136220511671311",
    	["circle-x"] = "rbxassetid://76821953846248",
    	["circle"] = "rbxassetid://130359823580534",
    	["circuit-board"] = "rbxassetid://107695264369312",
    	["citrus"] = "rbxassetid://139018222976433",
    	["clapperboard"] = "rbxassetid://132660667070200",
    	["clipboard-check"] = "rbxassetid://92649798577170",
    	["clipboard-clock"] = "rbxassetid://123957515687745",
    	["clipboard-copy"] = "rbxassetid://125851897718493",
    	["clipboard-list"] = "rbxassetid://96460215958908",
    	["clipboard-minus"] = "rbxassetid://107968008485671",
    	["clipboard-paste"] = "rbxassetid://74382068849983",
    	["clipboard-pen-line"] = "rbxassetid://77711589791615",
    	["clipboard-pen"] = "rbxassetid://75290966822953",
    	["clipboard-plus"] = "rbxassetid://134285318675662",
    	["clipboard-type"] = "rbxassetid://89949374318028",
    	["clipboard-x"] = "rbxassetid://102222456890103",
    	["clipboard"] = "rbxassetid://89601995828423",
    	["clock-1"] = "rbxassetid://129363225422045",
    	["clock-10"] = "rbxassetid://104332695855541",
    	["clock-11"] = "rbxassetid://119023205186105",
    	["clock-12"] = "rbxassetid://117789618723068",
    	["clock-2"] = "rbxassetid://134710777209413",
    	["clock-3"] = "rbxassetid://136385631189327",
    	["clock-4"] = "rbxassetid://121808839832144",
    	["clock-5"] = "rbxassetid://85082019959457",
    	["clock-6"] = "rbxassetid://71009733505593",
    	["clock-7"] = "rbxassetid://103111188546225",
    	["clock-8"] = "rbxassetid://110059272125337",
    	["clock-9"] = "rbxassetid://77610027126437",
    	["clock-alert"] = "rbxassetid://97157344465162",
    	["clock-arrow-down"] = "rbxassetid://92349314416042",
    	["clock-arrow-up"] = "rbxassetid://111484286332629",
    	["clock-check"] = "rbxassetid://85231630218857",
    	["clock-fading"] = "rbxassetid://93205297285245",
    	["clock-plus"] = "rbxassetid://93367709263150",
    	["clock"] = "rbxassetid://121808839832144",
    	["closed-caption"] = "rbxassetid://99832644030788",
    	["cloud-alert"] = "rbxassetid://91967273658626",
    	["cloud-check"] = "rbxassetid://97318598202432",
    	["cloud-cog"] = "rbxassetid://96497764065749",
    	["cloud-download"] = "rbxassetid://121435581993566",
    	["cloud-drizzle"] = "rbxassetid://139525315752605",
    	["cloud-fog"] = "rbxassetid://76650233148776",
    	["cloud-hail"] = "rbxassetid://72320462748242",
    	["cloud-lightning"] = "rbxassetid://133517088924849",
    	["cloud-moon-rain"] = "rbxassetid://127667837827018",
    	["cloud-moon"] = "rbxassetid://71938114737914",
    	["cloud-off"] = "rbxassetid://131907154501444",
    	["cloud-rain-wind"] = "rbxassetid://107414583736721",
    	["cloud-rain"] = "rbxassetid://105547081967408",
    	["cloud-snow"] = "rbxassetid://72307126270226",
    	["cloud-sun-rain"] = "rbxassetid://99041604425705",
    	["cloud-sun"] = "rbxassetid://86114208148727",
    	["cloud-upload"] = "rbxassetid://93307473217005",
    	["cloud"] = "rbxassetid://121226497050352",
    	["cloudy"] = "rbxassetid://105360479023346",
    	["clover"] = "rbxassetid://74925550436750",
    	["club"] = "rbxassetid://108490365816628",
    	["code-xml"] = "rbxassetid://130150477351734",
    	["code"] = "rbxassetid://107380207681249",
    	["codepen"] = "rbxassetid://135643965971885",
    	["codesandbox"] = "rbxassetid://106911852964823",
    	["coffee"] = "rbxassetid://106864403231093",
    	["cog"] = "rbxassetid://116544501716299",
    	["coins"] = "rbxassetid://116510979641930",
    	["columns-2"] = "rbxassetid://113004100221850",
    	["columns-3-cog"] = "rbxassetid://121589691981064",
    	["columns-3"] = "rbxassetid://115223357399375",
    	["columns-4"] = "rbxassetid://130807991968419",
    	["combine"] = "rbxassetid://79908476334048",
    	["command"] = "rbxassetid://93648221906330",
    	["compass"] = "rbxassetid://115123411028382",
    	["component"] = "rbxassetid://110027788875080",
    	["computer"] = "rbxassetid://77480056459407",
    	["concierge-bell"] = "rbxassetid://140384259310436",
    	["cone"] = "rbxassetid://97759550688437",
    	["construction"] = "rbxassetid://106539489968173",
    	["contact-round"] = "rbxassetid://71907624112229",
    	["contact"] = "rbxassetid://75868297719012",
    	["container"] = "rbxassetid://91507237573499",
    	["contrast"] = "rbxassetid://112796643981497",
    	["cookie"] = "rbxassetid://73159504540002",
    	["cooking-pot"] = "rbxassetid://94959783129799",
    	["copy-check"] = "rbxassetid://91177247988892",
    	["copy-minus"] = "rbxassetid://109524509933035",
    	["copy-plus"] = "rbxassetid://113618379616952",
    	["copy-slash"] = "rbxassetid://93805787810390",
    	["copy-x"] = "rbxassetid://106557557978061",
    	["copy"] = "rbxassetid://78979572434545",
    	["copyleft"] = "rbxassetid://78559055698593",
    	["copyright"] = "rbxassetid://129433635747111",
    	["corner-down-left"] = "rbxassetid://90473561177832",
    	["corner-down-right"] = "rbxassetid://86512767702085",
    	["corner-left-down"] = "rbxassetid://139876989150630",
    	["corner-left-up"] = "rbxassetid://126228268096099",
    	["corner-right-down"] = "rbxassetid://89237035551302",
    	["corner-right-up"] = "rbxassetid://112851237026705",
    	["corner-up-left"] = "rbxassetid://84669279763024",
    	["corner-up-right"] = "rbxassetid://115099889693145",
    	["cpu"] = "rbxassetid://77549309870247",
    	["creative-commons"] = "rbxassetid://90408210735312",
    	["credit-card"] = "rbxassetid://99163352872346",
    	["croissant"] = "rbxassetid://130710485559420",
    	["crop"] = "rbxassetid://116344601101413",
    	["cross"] = "rbxassetid://101833377863588",
    	["crosshair"] = "rbxassetid://134242818164054",
    	["crown"] = "rbxassetid://127843403295538",
    	["cuboid"] = "rbxassetid://75618807946111",
    	["cup-soda"] = "rbxassetid://121098640829562",
    	["currency"] = "rbxassetid://90551250119972",
    	["cylinder"] = "rbxassetid://90569677179169",
    	["dam"] = "rbxassetid://76874486231393",
    	["database-backup"] = "rbxassetid://103403210984699",
    	["database-zap"] = "rbxassetid://131199921258418",
    	["database"] = "rbxassetid://126791525623846",
    	["decimals-arrow-left"] = "rbxassetid://120198500638749",
    	["decimals-arrow-right"] = "rbxassetid://118263047146797",
    	["delete"] = "rbxassetid://126279426372342",
    	["dessert"] = "rbxassetid://71508133278830",
    	["diameter"] = "rbxassetid://97429051503783",
    	["diamond-minus"] = "rbxassetid://128989071438290",
    	["diamond-percent"] = "rbxassetid://107717860105959",
    	["diamond-plus"] = "rbxassetid://134701163723675",
    	["diamond"] = "rbxassetid://105846996304890",
    	["dice-1"] = "rbxassetid://112650149591038",
    	["dice-2"] = "rbxassetid://112278274566793",
    	["dice-3"] = "rbxassetid://118526270626312",
    	["dice-4"] = "rbxassetid://113365650364004",
    	["dice-5"] = "rbxassetid://72768312430593",
    	["dice-6"] = "rbxassetid://85376239182543",
    	["dices"] = "rbxassetid://81268120302865",
    	["diff"] = "rbxassetid://135052708609715",
    	["disc-2"] = "rbxassetid://91419420404185",
    	["disc-3"] = "rbxassetid://135470554736048",
    	["disc-album"] = "rbxassetid://74693460404344",
    	["disc"] = "rbxassetid://101908120120777",
    	["divide"] = "rbxassetid://136678191878278",
    	["dna-off"] = "rbxassetid://89612426361540",
    	["dna"] = "rbxassetid://74007982981741",
    	["dock"] = "rbxassetid://121997427160252",
    	["dog"] = "rbxassetid://71920105558570",
    	["dollar-sign"] = "rbxassetid://127320961224019",
    	["donut"] = "rbxassetid://72204922742657",
    	["door-closed-locked"] = "rbxassetid://74027613267551",
    	["door-closed"] = "rbxassetid://136249099949073",
    	["door-open"] = "rbxassetid://91306356501736",
    	["dot"] = "rbxassetid://137321056643916",
    	["download"] = "rbxassetid://134814648082393",
    	["drafting-compass"] = "rbxassetid://99701976182841",
    	["drama"] = "rbxassetid://110297795801577",
    	["dribbble"] = "rbxassetid://80231809663849",
    	["drill"] = "rbxassetid://108644821412796",
    	["drone"] = "rbxassetid://117299095794783",
    	["droplet-off"] = "rbxassetid://119365002225172",
    	["droplet"] = "rbxassetid://100597455015098",
    	["droplets"] = "rbxassetid://140111846025180",
    	["drum"] = "rbxassetid://136979060344890",
    	["drumstick"] = "rbxassetid://104662462521709",
    	["dumbbell"] = "rbxassetid://80277236776212",
    	["ear-off"] = "rbxassetid://87421916192807",
    	["ear"] = "rbxassetid://121894949934209",
    	["earth-lock"] = "rbxassetid://88814147073745",
    	["earth"] = "rbxassetid://76231597751076",
    	["eclipse"] = "rbxassetid://114829622118222",
    	["egg-fried"] = "rbxassetid://90622538210545",
    	["egg-off"] = "rbxassetid://92288321309285",
    	["egg"] = "rbxassetid://117851493400222",
    	["ellipsis-vertical"] = "rbxassetid://117978708573781",
    	["ellipsis"] = "rbxassetid://140019550645825",
    	["equal-approximately"] = "rbxassetid://105382689698323",
    	["equal-not"] = "rbxassetid://76864449458032",
    	["equal"] = "rbxassetid://123467780715624",
    	["eraser"] = "rbxassetid://133957773112410",
    	["ethernet-port"] = "rbxassetid://75391715149314",
    	["euro"] = "rbxassetid://72229646524456",
    	["ev-charger"] = "rbxassetid://97906158859623",
    	["expand"] = "rbxassetid://137492887754537",
    	["external-link"] = "rbxassetid://129331830773832",
    	["eye-closed"] = "rbxassetid://111063268625789",
    	["eye-off"] = "rbxassetid://135928786788378",
    	["eye"] = "rbxassetid://100033680381365",
    	["facebook"] = "rbxassetid://72098528632192",
    	["factory"] = "rbxassetid://102170024318039",
    	["fan"] = "rbxassetid://78391400440696",
    	["fast-forward"] = "rbxassetid://121615540167909",
    	["feather"] = "rbxassetid://91872927606406",
    	["fence"] = "rbxassetid://123451565578029",
    	["ferris-wheel"] = "rbxassetid://79729205796176",
    	["figma"] = "rbxassetid://134182122852301",
    	["file-archive"] = "rbxassetid://77018106869967",
    	["file-axis-3d"] = "rbxassetid://133912328009885",
    	["file-badge"] = "rbxassetid://74564895394477",
    	["file-box"] = "rbxassetid://119264004071690",
    	["file-braces-corner"] = "rbxassetid://77253337986109",
    	["file-braces"] = "rbxassetid://95314128621234",
    	["file-chart-column-increasing"] = "rbxassetid://134449481172067",
    	["file-chart-column"] = "rbxassetid://82048481252560",
    	["file-chart-line"] = "rbxassetid://71954360551345",
    	["file-chart-pie"] = "rbxassetid://81072193564497",
    	["file-check-corner"] = "rbxassetid://76295552859171",
    	["file-check"] = "rbxassetid://82604001452455",
    	["file-clock"] = "rbxassetid://102325208830990",
    	["file-code-corner"] = "rbxassetid://78293841184371",
    	["file-code"] = "rbxassetid://130978036895504",
    	["file-cog"] = "rbxassetid://101385347151368",
    	["file-diff"] = "rbxassetid://96147216772241",
    	["file-digit"] = "rbxassetid://89220220354580",
    	["file-down"] = "rbxassetid://120650154178290",
    	["file-exclamation-point"] = "rbxassetid://102821865889635",
    	["file-headphone"] = "rbxassetid://100533735901986",
    	["file-heart"] = "rbxassetid://132214916401696",
    	["file-image"] = "rbxassetid://123334057511782",
    	["file-input"] = "rbxassetid://124728604166044",
    	["file-key"] = "rbxassetid://118790255921100",
    	["file-lock"] = "rbxassetid://72170228691242",
    	["file-minus-corner"] = "rbxassetid://119263271735124",
    	["file-minus"] = "rbxassetid://111014798459222",
    	["file-music"] = "rbxassetid://134948051536671",
    	["file-output"] = "rbxassetid://92146832572911",
    	["file-pen-line"] = "rbxassetid://104622936345006",
    	["file-pen"] = "rbxassetid://79556179730240",
    	["file-play"] = "rbxassetid://89006821567838",
    	["file-plus-corner"] = "rbxassetid://76544604043974",
    	["file-plus"] = "rbxassetid://78881710800060",
    	["file-question-mark"] = "rbxassetid://127617422859576",
    	["file-scan"] = "rbxassetid://129480105228213",
    	["file-search-corner"] = "rbxassetid://90974165234008",
    	["file-search"] = "rbxassetid://97780235974933",
    	["file-signal"] = "rbxassetid://122070252538165",
    	["file-sliders"] = "rbxassetid://85787771732439",
    	["file-spreadsheet"] = "rbxassetid://134501869359270",
    	["file-stack"] = "rbxassetid://138929929862605",
    	["file-symlink"] = "rbxassetid://91865722036510",
    	["file-terminal"] = "rbxassetid://116757454755476",
    	["file-text"] = "rbxassetid://90496405707281",
    	["file-type-corner"] = "rbxassetid://124902230275209",
    	["file-type"] = "rbxassetid://115272552799361",
    	["file-up"] = "rbxassetid://131173039312748",
    	["file-user"] = "rbxassetid://99552018455009",
    	["file-video-camera"] = "rbxassetid://81719056173960",
    	["file-volume"] = "rbxassetid://111264764438958",
    	["file-x-corner"] = "rbxassetid://87554136773609",
    	["file-x"] = "rbxassetid://107333775515154",
    	["file"] = "rbxassetid://74748492079329",
    	["files"] = "rbxassetid://102806336233202",
    	["film"] = "rbxassetid://120978945609706",
    	["fingerprint"] = "rbxassetid://112173305232811",
    	["fire-extinguisher"] = "rbxassetid://111643493006960",
    	["fish-off"] = "rbxassetid://89756724887508",
    	["fish-symbol"] = "rbxassetid://118475177681618",
    	["fish"] = "rbxassetid://124360663785796",
    	["flag-off"] = "rbxassetid://112944528856799",
    	["flag-triangle-left"] = "rbxassetid://88045221285272",
    	["flag-triangle-right"] = "rbxassetid://108292480304566",
    	["flag"] = "rbxassetid://78183383236196",
    	["flame-kindling"] = "rbxassetid://139728976917928",
    	["flame"] = "rbxassetid://98218034436456",
    	["flashlight-off"] = "rbxassetid://79780362871740",
    	["flashlight"] = "rbxassetid://100286985600444",
    	["flask-conical-off"] = "rbxassetid://112597970025298",
    	["flask-conical"] = "rbxassetid://128406680901165",
    	["flask-round"] = "rbxassetid://127508287324940",
    	["flip-horizontal-2"] = "rbxassetid://103726993598186",
    	["flip-horizontal"] = "rbxassetid://122937530107837",
    	["flip-vertical-2"] = "rbxassetid://103836358956328",
    	["flip-vertical"] = "rbxassetid://108003917346888",
    	["flower-2"] = "rbxassetid://72934574245145",
    	["flower"] = "rbxassetid://86129438272762",
    	["focus"] = "rbxassetid://87493973153317",
    	["fold-horizontal"] = "rbxassetid://92835712442240",
    	["fold-vertical"] = "rbxassetid://108873727253656",
    	["folder-archive"] = "rbxassetid://97312009460206",
    	["folder-check"] = "rbxassetid://128492920904557",
    	["folder-clock"] = "rbxassetid://111964836738545",
    	["folder-closed"] = "rbxassetid://118286209350843",
    	["folder-code"] = "rbxassetid://70624096349370",
    	["folder-cog"] = "rbxassetid://85299519462846",
    	["folder-dot"] = "rbxassetid://138687772725278",
    	["folder-down"] = "rbxassetid://118044108459225",
    	["folder-git-2"] = "rbxassetid://101394054141166",
    	["folder-git"] = "rbxassetid://121885778095158",
    	["folder-heart"] = "rbxassetid://79104747211105",
    	["folder-input"] = "rbxassetid://90699920697871",
    	["folder-kanban"] = "rbxassetid://78313285104072",
    	["folder-key"] = "rbxassetid://85270407596791",
    	["folder-lock"] = "rbxassetid://119201572260567",
    	["folder-minus"] = "rbxassetid://85648718999010",
    	["folder-open-dot"] = "rbxassetid://74741494767354",
    	["folder-open"] = "rbxassetid://76018996254888",
    	["folder-output"] = "rbxassetid://101532447937612",
    	["folder-pen"] = "rbxassetid://112770491173911",
    	["folder-plus"] = "rbxassetid://91865663406119",
    	["folder-root"] = "rbxassetid://103333751154693",
    	["folder-search-2"] = "rbxassetid://71276453442655",
    	["folder-search"] = "rbxassetid://110568075123861",
    	["folder-symlink"] = "rbxassetid://127485747227189",
    	["folder-sync"] = "rbxassetid://91544602659796",
    	["folder-tree"] = "rbxassetid://85577554337861",
    	["folder-up"] = "rbxassetid://72008269765857",
    	["folder-x"] = "rbxassetid://91699618247635",
    	["folder"] = "rbxassetid://80846616596607",
    	["folders"] = "rbxassetid://110351216219061",
    	["footprints"] = "rbxassetid://139192589041315",
    	["forklift"] = "rbxassetid://72030930983101",
    	["forward"] = "rbxassetid://97545944739523",
    	["frame"] = "rbxassetid://109080612832751",
    	["framer"] = "rbxassetid://108384807262391",
    	["frown"] = "rbxassetid://124407301067982",
    	["fuel"] = "rbxassetid://106447647274511",
    	["fullscreen"] = "rbxassetid://77793665526178",
    	["funnel-plus"] = "rbxassetid://100780233821928",
    	["funnel-x"] = "rbxassetid://70984385812555",
    	["funnel"] = "rbxassetid://108829540827529",
    	["gallery-horizontal-end"] = "rbxassetid://74672430161161",
    	["gallery-horizontal"] = "rbxassetid://80004001442122",
    	["gallery-thumbnails"] = "rbxassetid://136219289862706",
    	["gallery-vertical-end"] = "rbxassetid://106461402088317",
    	["gallery-vertical"] = "rbxassetid://119299431466725",
    	["gamepad-2"] = "rbxassetid://92483947987410",
    	["gamepad-directional"] = "rbxassetid://84342305212226",
    	["gamepad"] = "rbxassetid://121607283959010",
    	["gauge"] = "rbxassetid://110273524101447",
    	["gavel"] = "rbxassetid://78952298198456",
    	["gem"] = "rbxassetid://112904952151156",
    	["georgian-lari"] = "rbxassetid://98084432591687",
    	["ghost"] = "rbxassetid://113822048130017",
    	["gift"] = "rbxassetid://109855212076373",
    	["git-branch-minus"] = "rbxassetid://97385010649411",
    	["git-branch-plus"] = "rbxassetid://125944221134316",
    	["git-branch"] = "rbxassetid://90490195516649",
    	["git-commit-horizontal"] = "rbxassetid://133646041800147",
    	["git-commit-vertical"] = "rbxassetid://122098032990350",
    	["git-compare-arrows"] = "rbxassetid://84874426520216",
    	["git-compare"] = "rbxassetid://91945124438792",
    	["git-fork"] = "rbxassetid://89954992404765",
    	["git-graph"] = "rbxassetid://86166832019304",
    	["git-merge"] = "rbxassetid://131833355158059",
    	["git-pull-request-arrow"] = "rbxassetid://94507974577439",
    	["git-pull-request-closed"] = "rbxassetid://78070600389091",
    	["git-pull-request-create-arrow"] = "rbxassetid://127422677061091",
    	["git-pull-request-create"] = "rbxassetid://105929577383926",
    	["git-pull-request-draft"] = "rbxassetid://76173459869943",
    	["git-pull-request"] = "rbxassetid://138463010991471",
    	["github"] = "rbxassetid://120349554354380",
    	["gitlab"] = "rbxassetid://114054627192933",
    	["glass-water"] = "rbxassetid://115526102400988",
    	["glasses"] = "rbxassetid://87936407455373",
    	["globe-lock"] = "rbxassetid://134065526704402",
    	["globe"] = "rbxassetid://114238209622913",
    	["goal"] = "rbxassetid://120517954878160",
    	["gpu"] = "rbxassetid://95577823614219",
    	["graduation-cap"] = "rbxassetid://93771896340220",
    	["grape"] = "rbxassetid://134760640415561",
    	["grid-2x2-check"] = "rbxassetid://138468840220821",
    	["grid-2x2-plus"] = "rbxassetid://91811610580247",
    	["grid-2x2-x"] = "rbxassetid://72407303981388",
    	["grid-2x2"] = "rbxassetid://99050491897640",
    	["grid-3x2"] = "rbxassetid://95528684210010",
    	["grid-3x3"] = "rbxassetid://70419024781206",
    	["grip-horizontal"] = "rbxassetid://136255899715930",
    	["grip-vertical"] = "rbxassetid://137183678565296",
    	["grip"] = "rbxassetid://109058783556768",
    	["group"] = "rbxassetid://107643418926671",
    	["guitar"] = "rbxassetid://75915531867926",
    	["ham"] = "rbxassetid://74465607934635",
    	["hamburger"] = "rbxassetid://93086916815495",
    	["hammer"] = "rbxassetid://83545120140895",
    	["hand-coins"] = "rbxassetid://126990543175462",
    	["hand-fist"] = "rbxassetid://83341608917591",
    	["hand-grab"] = "rbxassetid://88867162163985",
    	["hand-heart"] = "rbxassetid://117507367668412",
    	["hand-helping"] = "rbxassetid://89897738419446",
    	["hand-metal"] = "rbxassetid://113619498548713",
    	["hand-platter"] = "rbxassetid://88594727743168",
    	["hand"] = "rbxassetid://130703864968637",
    	["handbag"] = "rbxassetid://135675846264061",
    	["handshake"] = "rbxassetid://78442115255814",
    	["hard-drive-download"] = "rbxassetid://73913801230614",
    	["hard-drive-upload"] = "rbxassetid://85762133615118",
    	["hard-drive"] = "rbxassetid://88183305858463",
    	["hard-hat"] = "rbxassetid://128050846767382",
    	["hash"] = "rbxassetid://82890331678520",
    	["hat-glasses"] = "rbxassetid://101165538224815",
    	["haze"] = "rbxassetid://108857561768901",
    	["hdmi-port"] = "rbxassetid://103693661037020",
    	["heading-1"] = "rbxassetid://118129315662110",
    	["heading-2"] = "rbxassetid://110209069670094",
    	["heading-3"] = "rbxassetid://90267885237062",
    	["heading-4"] = "rbxassetid://129625620307602",
    	["heading-5"] = "rbxassetid://120386663181267",
    	["heading-6"] = "rbxassetid://90959079775093",
    	["heading"] = "rbxassetid://129254312067735",
    	["headphone-off"] = "rbxassetid://85038251615641",
    	["headphones"] = "rbxassetid://118833729589183",
    	["headset"] = "rbxassetid://129269236787694",
    	["heart-crack"] = "rbxassetid://110987638564119",
    	["heart-handshake"] = "rbxassetid://111483078692002",
    	["heart-minus"] = "rbxassetid://96827380163326",
    	["heart-off"] = "rbxassetid://89748414415617",
    	["heart-plus"] = "rbxassetid://94877796283249",
    	["heart-pulse"] = "rbxassetid://129352925579546",
    	["heart"] = "rbxassetid://116559368303288",
    	["heater"] = "rbxassetid://140478466880916",
    	["helicopter"] = "rbxassetid://111557171735930",
    	["hexagon"] = "rbxassetid://127592089339199",
    	["highlighter"] = "rbxassetid://77411555641113",
    	["history"] = "rbxassetid://123980022019922",
    	["hop-off"] = "rbxassetid://103386036934034",
    	["hop"] = "rbxassetid://82778923997672",
    	["hospital"] = "rbxassetid://105868763850707",
    	["hotel"] = "rbxassetid://132283390859718",
    	["hourglass"] = "rbxassetid://86160434939203",
    	["house-heart"] = "rbxassetid://136054771868597",
    	["house-plug"] = "rbxassetid://71438263712075",
    	["house-plus"] = "rbxassetid://118495165208309",
    	["house-wifi"] = "rbxassetid://126495519725698",
    	["house"] = "rbxassetid://98755624629571",
    	["ice-cream-bowl"] = "rbxassetid://124867218454386",
    	["ice-cream-cone"] = "rbxassetid://90751397288639",
    	["id-card-lanyard"] = "rbxassetid://90761480469224",
    	["id-card"] = "rbxassetid://75354294622640",
    	["image-down"] = "rbxassetid://78972295741235",
    	["image-minus"] = "rbxassetid://101066016918565",
    	["image-off"] = "rbxassetid://81934811700938",
    	["image-play"] = "rbxassetid://129501806784210",
    	["image-plus"] = "rbxassetid://70391970623917",
    	["image-up"] = "rbxassetid://126610009605241",
    	["image-upscale"] = "rbxassetid://106963545024679",
    	["images"] = "rbxassetid://79350649395557",
    	["import"] = "rbxassetid://116545008906029",
    	["inbox"] = "rbxassetid://112591360302868",
    	["indian-rupee"] = "rbxassetid://113038778381805",
    	["infinity"] = "rbxassetid://98083086936965",
    	["info"] = "rbxassetid://124560466474914",
    	["inspection-panel"] = "rbxassetid://70905313146088",
    	["instagram"] = "rbxassetid://119864798614855",
    	["italic"] = "rbxassetid://96220378864282",
    	["iteration-ccw"] = "rbxassetid://140221832794083",
    	["iteration-cw"] = "rbxassetid://95534489554662",
    	["japanese-yen"] = "rbxassetid://106362863465813",
    	["joystick"] = "rbxassetid://99416790224739",
    	["kanban"] = "rbxassetid://125934100055431",
    	["kayak"] = "rbxassetid://136107544609389",
    	["key-round"] = "rbxassetid://83619031955390",
    	["key-square"] = "rbxassetid://94621420033649",
    	["key"] = "rbxassetid://96510194465420",
    	["keyboard-music"] = "rbxassetid://121058541758636",
    	["keyboard-off"] = "rbxassetid://92466375369772",
    	["keyboard"] = "rbxassetid://121474456068237",
    	["lamp-ceiling"] = "rbxassetid://80032758469141",
    	["lamp-desk"] = "rbxassetid://85290686983238",
    	["lamp-floor"] = "rbxassetid://104585881375892",
    	["lamp-wall-down"] = "rbxassetid://91271394132073",
    	["lamp-wall-up"] = "rbxassetid://132141464337445",
    	["lamp"] = "rbxassetid://110730830653382",
    	["land-plot"] = "rbxassetid://96449039620294",
    	["landmark"] = "rbxassetid://76885079756393",
    	["languages"] = "rbxassetid://90816903776498",
    	["laptop-minimal-check"] = "rbxassetid://114352019833865",
    	["laptop-minimal"] = "rbxassetid://136705765566068",
    	["laptop"] = "rbxassetid://111387063244975",
    	["lasso-select"] = "rbxassetid://105609719912753",
    	["lasso"] = "rbxassetid://121072936884007",
    	["laugh"] = "rbxassetid://104491311361166",
    	["layers-2"] = "rbxassetid://70536710516357",
    	["layers"] = "rbxassetid://81973586053257",
    	["layout-dashboard"] = "rbxassetid://139929981863901",
    	["layout-grid"] = "rbxassetid://81344910161871",
    	["layout-list"] = "rbxassetid://87462136296578",
    	["layout-panel-left"] = "rbxassetid://125092469751491",
    	["layout-panel-top"] = "rbxassetid://91943941515944",
    	["layout-template"] = "rbxassetid://115564446417985",
    	["leaf"] = "rbxassetid://119951075637174",
    	["leafy-green"] = "rbxassetid://105146290493154",
    	["lectern"] = "rbxassetid://106166425183862",
    	["library-big"] = "rbxassetid://106794530191412",
    	["library"] = "rbxassetid://114334671982047",
    	["life-buoy"] = "rbxassetid://81168450671956",
    	["ligature"] = "rbxassetid://111397873269411",
    	["lightbulb-off"] = "rbxassetid://83795722296178",
    	["lightbulb"] = "rbxassetid://103871245626488",
    	["line-squiggle"] = "rbxassetid://109555164424447",
    	["link-2-off"] = "rbxassetid://76885956296867",
    	["link-2"] = "rbxassetid://86072351557466",
    	["link"] = "rbxassetid://131607023382430",
    	["linkedin"] = "rbxassetid://132842789255788",
    	["list-check"] = "rbxassetid://72374358471156",
    	["list-checks"] = "rbxassetid://99809353635593",
    	["list-chevrons-down-up"] = "rbxassetid://137409641500711",
    	["list-chevrons-up-down"] = "rbxassetid://81825351389084",
    	["list-collapse"] = "rbxassetid://124505247702401",
    	["list-end"] = "rbxassetid://77650610048119",
    	["list-filter-plus"] = "rbxassetid://96385120752336",
    	["list-filter"] = "rbxassetid://103321376129527",
    	["list-indent-decrease"] = "rbxassetid://137879979228193",
    	["list-indent-increase"] = "rbxassetid://79051053161201",
    	["list-minus"] = "rbxassetid://138507965142671",
    	["list-music"] = "rbxassetid://126380635781840",
    	["list-ordered"] = "rbxassetid://83212528113913",
    	["list-plus"] = "rbxassetid://112384738137814",
    	["list-restart"] = "rbxassetid://91703153577421",
    	["list-start"] = "rbxassetid://84828348299727",
    	["list-todo"] = "rbxassetid://132980603752108",
    	["list-tree"] = "rbxassetid://97685396239010",
    	["list-video"] = "rbxassetid://93648525452489",
    	["list-x"] = "rbxassetid://113025303988861",
    	["list"] = "rbxassetid://113179976918783",
    	["loader-circle"] = "rbxassetid://116535712789945",
    	["loader-pinwheel"] = "rbxassetid://108513357940900",
    	["loader"] = "rbxassetid://78408734580845",
    	["locate-fixed"] = "rbxassetid://137367361548433",
    	["locate-off"] = "rbxassetid://73729216338137",
    	["locate"] = "rbxassetid://84467676590391",
    	["lock-keyhole-open"] = "rbxassetid://110863509313073",
    	["lock-keyhole"] = "rbxassetid://78672912777756",
    	["lock-open"] = "rbxassetid://93597915325122",
    	["lock"] = "rbxassetid://134724289526879",
    	["log-in"] = "rbxassetid://103768533135201",
    	["log-out"] = "rbxassetid://84895399304975",
    	["logs"] = "rbxassetid://89772091251787",
    	["lollipop"] = "rbxassetid://84681611583044",
    	["luggage"] = "rbxassetid://76619236486400",
    	["magnet"] = "rbxassetid://135162361226972",
    	["mail-check"] = "rbxassetid://86921536259917",
    	["mail-minus"] = "rbxassetid://81989813236553",
    	["mail-open"] = "rbxassetid://122785416858638",
    	["mail-plus"] = "rbxassetid://104886401588341",
    	["mail-question-mark"] = "rbxassetid://126540170949819",
    	["mail-search"] = "rbxassetid://135616173775287",
    	["mail-warning"] = "rbxassetid://81495303676089",
    	["mail-x"] = "rbxassetid://74607841705644",
    	["mail"] = "rbxassetid://103945161245599",
    	["mailbox"] = "rbxassetid://82765503320335",
    	["mails"] = "rbxassetid://90673453450080",
    	["map-minus"] = "rbxassetid://129525760577747",
    	["map-pin-check-inside"] = "rbxassetid://107130529843809",
    	["map-pin-check"] = "rbxassetid://118110914690154",
    	["map-pin-house"] = "rbxassetid://80546885029816",
    	["map-pin-minus-inside"] = "rbxassetid://79005529692964",
    	["map-pin-minus"] = "rbxassetid://74518762643623",
    	["map-pin-off"] = "rbxassetid://82474689391020",
    	["map-pin-pen"] = "rbxassetid://113515395277504",
    	["map-pin-plus-inside"] = "rbxassetid://134639656514430",
    	["map-pin-plus"] = "rbxassetid://91875228967029",
    	["map-pin-x-inside"] = "rbxassetid://126235934252379",
    	["map-pin-x"] = "rbxassetid://101085273547316",
    	["map-pin"] = "rbxassetid://84279202219901",
    	["map-pinned"] = "rbxassetid://103963788475034",
    	["map-plus"] = "rbxassetid://129388826743495",
    	["map"] = "rbxassetid://95107167260947",
    	["mars-stroke"] = "rbxassetid://131973193186828",
    	["mars"] = "rbxassetid://111287112372511",
    	["martini"] = "rbxassetid://82977695401058",
    	["maximize-2"] = "rbxassetid://73085922906397",
    	["maximize"] = "rbxassetid://76045941763188",
    	["medal"] = "rbxassetid://79016002264450",
    	["megaphone-off"] = "rbxassetid://124280774193935",
    	["megaphone"] = "rbxassetid://118759541854879",
    	["meh"] = "rbxassetid://132197867028557",
    	["memory-stick"] = "rbxassetid://93212591343119",
    	["menu"] = "rbxassetid://77021539815611",
    	["merge"] = "rbxassetid://126201866476775",
    	["message-circle-code"] = "rbxassetid://112865244991651",
    	["message-circle-dashed"] = "rbxassetid://81525157881897",
    	["message-circle-heart"] = "rbxassetid://101990756073677",
    	["message-circle-more"] = "rbxassetid://92856823884663",
    	["message-circle-off"] = "rbxassetid://134955643890328",
    	["message-circle-plus"] = "rbxassetid://106562979649273",
    	["message-circle-question-mark"] = "rbxassetid://107700302759934",
    	["message-circle-reply"] = "rbxassetid://137071749508334",
    	["message-circle-warning"] = "rbxassetid://119020096067894",
    	["message-circle-x"] = "rbxassetid://126843387725536",
    	["message-circle"] = "rbxassetid://127255077587058",
    	["message-square-code"] = "rbxassetid://110968863152123",
    	["message-square-dashed"] = "rbxassetid://107653455516238",
    	["message-square-diff"] = "rbxassetid://75472190472625",
    	["message-square-dot"] = "rbxassetid://127806382463916",
    	["message-square-heart"] = "rbxassetid://75612811742074",
    	["message-square-lock"] = "rbxassetid://81268215619563",
    	["message-square-more"] = "rbxassetid://120139782405970",
    	["message-square-off"] = "rbxassetid://99961019005789",
    	["message-square-plus"] = "rbxassetid://76934450256199",
    	["message-square-quote"] = "rbxassetid://116670768629340",
    	["message-square-reply"] = "rbxassetid://130985622754637",
    	["message-square-share"] = "rbxassetid://131017005324026",
    	["message-square-text"] = "rbxassetid://94899503194205",
    	["message-square-warning"] = "rbxassetid://138432903962261",
    	["message-square-x"] = "rbxassetid://137285463279462",
    	["message-square"] = "rbxassetid://83881670383280",
    	["messages-square"] = "rbxassetid://97532166733358",
    	["mic-off"] = "rbxassetid://82123034444822",
    	["mic-vocal"] = "rbxassetid://99082286164362",
    	["mic"] = "rbxassetid://89640799126523",
    	["microchip"] = "rbxassetid://73937907669903",
    	["microscope"] = "rbxassetid://116875530102782",
    	["microwave"] = "rbxassetid://108411735353008",
    	["milestone"] = "rbxassetid://101618292325920",
    	["milk-off"] = "rbxassetid://72388480962742",
    	["milk"] = "rbxassetid://96221903896918",
    	["minimize-2"] = "rbxassetid://116269596042539",
    	["minimize"] = "rbxassetid://121304296213645",
    	["minus"] = "rbxassetid://118026365011536",
    	["monitor-check"] = "rbxassetid://86651948439229",
    	["monitor-cloud"] = "rbxassetid://85931096038318",
    	["monitor-cog"] = "rbxassetid://94345128715799",
    	["monitor-dot"] = "rbxassetid://130394010063680",
    	["monitor-down"] = "rbxassetid://97466933743423",
    	["monitor-off"] = "rbxassetid://74395526657953",
    	["monitor-pause"] = "rbxassetid://76002184067562",
    	["monitor-play"] = "rbxassetid://133018824306217",
    	["monitor-smartphone"] = "rbxassetid://84335680433378",
    	["monitor-speaker"] = "rbxassetid://81744810060380",
    	["monitor-stop"] = "rbxassetid://98708958984757",
    	["monitor-up"] = "rbxassetid://96035360858377",
    	["monitor-x"] = "rbxassetid://126265210441423",
    	["monitor"] = "rbxassetid://72664649203050",
    	["moon-star"] = "rbxassetid://82782200506348",
    	["moon"] = "rbxassetid://83380517901735",
    	["motorbike"] = "rbxassetid://94580787368233",
    	["mountain-snow"] = "rbxassetid://105315495740588",
    	["mountain"] = "rbxassetid://73269957566415",
    	["mouse-off"] = "rbxassetid://75267871697595",
    	["mouse-pointer-2-off"] = "rbxassetid://104701076865632",
    	["mouse-pointer-2"] = "rbxassetid://117093892862228",
    	["mouse-pointer-ban"] = "rbxassetid://106849413057133",
    	["mouse-pointer-click"] = "rbxassetid://107150227368485",
    	["mouse-pointer"] = "rbxassetid://72322454962935",
    	["mouse"] = "rbxassetid://73096068864710",
    	["move-3d"] = "rbxassetid://103365982054003",
    	["move-diagonal-2"] = "rbxassetid://117298577948096",
    	["move-diagonal"] = "rbxassetid://101433481954184",
    	["move-down-left"] = "rbxassetid://102819433534567",
    	["move-down-right"] = "rbxassetid://101479760041877",
    	["move-down"] = "rbxassetid://70510115135583",
    	["move-horizontal"] = "rbxassetid://88513523439149",
    	["move-left"] = "rbxassetid://137614740247980",
    	["move-right"] = "rbxassetid://132455779472989",
    	["move-up-left"] = "rbxassetid://139079815540148",
    	["move-up-right"] = "rbxassetid://105885140592646",
    	["move-up"] = "rbxassetid://84505444262658",
    	["move-vertical"] = "rbxassetid://86234730730899",
    	["move"] = "rbxassetid://116138709011735",
    	["music-2"] = "rbxassetid://134397426600888",
    	["music-3"] = "rbxassetid://94466120066498",
    	["music-4"] = "rbxassetid://132459323665838",
    	["music"] = "rbxassetid://113343203848535",
    	["navigation-2-off"] = "rbxassetid://116569611780763",
    	["navigation-2"] = "rbxassetid://81889066747907",
    	["navigation-off"] = "rbxassetid://87003270290777",
    	["navigation"] = "rbxassetid://79308213542922",
    	["network"] = "rbxassetid://127410729922644",
    	["newspaper"] = "rbxassetid://123479530460544",
    	["nfc"] = "rbxassetid://76822396542242",
    	["non-binary"] = "rbxassetid://78442360386235",
    	["notebook-pen"] = "rbxassetid://140380614761023",
    	["notebook-tabs"] = "rbxassetid://127371085570083",
    	["notebook-text"] = "rbxassetid://93061585217270",
    	["notebook"] = "rbxassetid://136132108664987",
    	["notepad-text-dashed"] = "rbxassetid://135793446376219",
    	["notepad-text"] = "rbxassetid://93404682958966",
    	["nut-off"] = "rbxassetid://78795397311573",
    	["nut"] = "rbxassetid://127146410705656",
    	["octagon-alert"] = "rbxassetid://140438367956051",
    	["octagon-minus"] = "rbxassetid://74720436795421",
    	["octagon-pause"] = "rbxassetid://103161463909039",
    	["octagon-x"] = "rbxassetid://90498161006311",
    	["octagon"] = "rbxassetid://120803515514852",
    	["omega"] = "rbxassetid://70414080018786",
    	["option"] = "rbxassetid://100776883894054",
    	["orbit"] = "rbxassetid://108926136860562",
    	["origami"] = "rbxassetid://136020626667101",
    	["package-2"] = "rbxassetid://70394974762575",
    	["package-check"] = "rbxassetid://102374216055130",
    	["package-minus"] = "rbxassetid://114492858789692",
    	["package-open"] = "rbxassetid://132890233237818",
    	["package-plus"] = "rbxassetid://129261988138366",
    	["package-search"] = "rbxassetid://95465120894145",
    	["package-x"] = "rbxassetid://70818501607442",
    	["package"] = "rbxassetid://97261141732706",
    	["paint-bucket"] = "rbxassetid://124275586663284",
    	["paint-roller"] = "rbxassetid://115248074358348",
    	["paintbrush-vertical"] = "rbxassetid://105151296591292",
    	["paintbrush"] = "rbxassetid://125572663700289",
    	["palette"] = "rbxassetid://86350350950064",
    	["panda"] = "rbxassetid://132509022802512",
    	["panel-bottom-close"] = "rbxassetid://74287004071159",
    	["panel-bottom-dashed"] = "rbxassetid://131084651621603",
    	["panel-bottom-open"] = "rbxassetid://107768659586540",
    	["panel-bottom"] = "rbxassetid://132127145048511",
    	["panel-left-close"] = "rbxassetid://126579818823552",
    	["panel-left-dashed"] = "rbxassetid://75536606374585",
    	["panel-left-open"] = "rbxassetid://111075816195767",
    	["panel-left-right-dashed"] = "rbxassetid://110100707973959",
    	["panel-left"] = "rbxassetid://97419752870313",
    	["panel-right-close"] = "rbxassetid://139528655524132",
    	["panel-right-dashed"] = "rbxassetid://94959793877311",
    	["panel-right-open"] = "rbxassetid://118114419142794",
    	["panel-right"] = "rbxassetid://116365035443156",
    	["panel-top-bottom-dashed"] = "rbxassetid://134737235653344",
    	["panel-top-close"] = "rbxassetid://83578325777808",
    	["panel-top-dashed"] = "rbxassetid://70522913169237",
    	["panel-top-open"] = "rbxassetid://137959875507454",
    	["panel-top"] = "rbxassetid://75838479462875",
    	["panels-left-bottom"] = "rbxassetid://72996856149149",
    	["panels-right-bottom"] = "rbxassetid://90659068960726",
    	["panels-top-left"] = "rbxassetid://79858853850600",
    	["paperclip"] = "rbxassetid://92088291163453",
    	["parentheses"] = "rbxassetid://78950955173096",
    	["parking-meter"] = "rbxassetid://84652733960568",
    	["party-popper"] = "rbxassetid://111626795712193",
    	["pause"] = "rbxassetid://74873705394436",
    	["paw-print"] = "rbxassetid://112218825427601",
    	["pc-case"] = "rbxassetid://122978648019101",
    	["pen-line"] = "rbxassetid://109108135755303",
    	["pen-off"] = "rbxassetid://84807123119438",
    	["pen-tool"] = "rbxassetid://106145404953445",
    	["pen"] = "rbxassetid://72037878096321",
    	["pencil-line"] = "rbxassetid://88392917053533",
    	["pencil-off"] = "rbxassetid://103330927652832",
    	["pencil-ruler"] = "rbxassetid://110120288284597",
    	["pencil"] = "rbxassetid://137986121120732",
    	["pentagon"] = "rbxassetid://79184802179890",
    	["percent"] = "rbxassetid://130155041032013",
    	["person-standing"] = "rbxassetid://125020872044147",
    	["philippine-peso"] = "rbxassetid://91173798254675",
    	["phone-call"] = "rbxassetid://70555587592860",
    	["phone-forwarded"] = "rbxassetid://113269614319737",
    	["phone-incoming"] = "rbxassetid://82863576359288",
    	["phone-missed"] = "rbxassetid://130156165198376",
    	["phone-off"] = "rbxassetid://133318623553383",
    	["phone-outgoing"] = "rbxassetid://104576478735825",
    	["phone"] = "rbxassetid://128804946640049",
    	["pi"] = "rbxassetid://74936036243146",
    	["piano"] = "rbxassetid://85008880789520",
    	["pickaxe"] = "rbxassetid://105888023317688",
    	["picture-in-picture-2"] = "rbxassetid://112803319544468",
    	["picture-in-picture"] = "rbxassetid://80579597835123",
    	["piggy-bank"] = "rbxassetid://79498575790721",
    	["pilcrow-left"] = "rbxassetid://103803000849583",
    	["pilcrow-right"] = "rbxassetid://104881733911870",
    	["pilcrow"] = "rbxassetid://139512780392871",
    	["pill-bottle"] = "rbxassetid://118394692404597",
    	["pill"] = "rbxassetid://73280534813448",
    	["pin-off"] = "rbxassetid://127696372451750",
    	["pin"] = "rbxassetid://120978111007514",
    	["pipette"] = "rbxassetid://133167932934404",
    	["pizza"] = "rbxassetid://126964453193501",
    	["plane-landing"] = "rbxassetid://122555692211889",
    	["plane-takeoff"] = "rbxassetid://117179478829575",
    	["plane"] = "rbxassetid://126985561580989",
    	["play"] = "rbxassetid://135609604299893",
    	["plug-2"] = "rbxassetid://97912386476366",
    	["plug-zap"] = "rbxassetid://74506269884055",
    	["plug"] = "rbxassetid://99782373064495",
    	["plus"] = "rbxassetid://111774323017047",
    	["pocket-knife"] = "rbxassetid://134075428063965",
    	["pocket"] = "rbxassetid://136686762542964",
    	["podcast"] = "rbxassetid://109577075549215",
    	["pointer-off"] = "rbxassetid://95488389312794",
    	["pointer"] = "rbxassetid://92615117311099",
    	["popcorn"] = "rbxassetid://139446511232750",
    	["popsicle"] = "rbxassetid://112696318077073",
    	["pound-sterling"] = "rbxassetid://127482649469130",
    	["power-off"] = "rbxassetid://118768311012214",
    	["power"] = "rbxassetid://96479131758775",
    	["presentation"] = "rbxassetid://106134583757890",
    	["printer-check"] = "rbxassetid://130273549443689",
    	["printer"] = "rbxassetid://76080649734247",
    	["projector"] = "rbxassetid://103281856385283",
    	["proportions"] = "rbxassetid://130046855997237",
    	["puzzle"] = "rbxassetid://136837798892463",
    	["pyramid"] = "rbxassetid://107811442374127",
    	["qr-code"] = "rbxassetid://105329945723350",
    	["quote"] = "rbxassetid://103271711590001",
    	["rabbit"] = "rbxassetid://98580518804206",
    	["radar"] = "rbxassetid://138528222906635",
    	["radiation"] = "rbxassetid://104499586848433",
    	["radical"] = "rbxassetid://132758286926047",
    	["radio-receiver"] = "rbxassetid://129598303378835",
    	["radio-tower"] = "rbxassetid://93958663130054",
    	["radio"] = "rbxassetid://85611589536956",
    	["radius"] = "rbxassetid://89814505307129",
    	["rail-symbol"] = "rbxassetid://134295386306962",
    	["rainbow"] = "rbxassetid://132488862841895",
    	["rat"] = "rbxassetid://127400975953159",
    	["ratio"] = "rbxassetid://126369423897295",
    	["receipt-cent"] = "rbxassetid://91557573925201",
    	["receipt-euro"] = "rbxassetid://94015722210295",
    	["receipt-indian-rupee"] = "rbxassetid://89718170439990",
    	["receipt-japanese-yen"] = "rbxassetid://132472560758851",
    	["receipt-pound-sterling"] = "rbxassetid://73934967569625",
    	["receipt-russian-ruble"] = "rbxassetid://105164576936853",
    	["receipt-swiss-franc"] = "rbxassetid://72503668620116",
    	["receipt-text"] = "rbxassetid://138483536013737",
    	["receipt-turkish-lira"] = "rbxassetid://91950765836342",
    	["receipt"] = "rbxassetid://77877895901792",
    	["rectangle-circle"] = "rbxassetid://100642423153903",
    	["rectangle-ellipsis"] = "rbxassetid://112919953980965",
    	["rectangle-goggles"] = "rbxassetid://98605436666727",
    	["rectangle-horizontal"] = "rbxassetid://90224199814966",
    	["rectangle-vertical"] = "rbxassetid://117277050590967",
    	["recycle"] = "rbxassetid://140417023381961",
    	["redo-2"] = "rbxassetid://70451039017914",
    	["redo-dot"] = "rbxassetid://94252981719732",
    	["redo"] = "rbxassetid://116150342119054",
    	["refresh-ccw-dot"] = "rbxassetid://106702246753270",
    	["refresh-ccw"] = "rbxassetid://117913330389477",
    	["refresh-cw-off"] = "rbxassetid://140179498843054",
    	["refresh-cw"] = "rbxassetid://138133190015277",
    	["refrigerator"] = "rbxassetid://102614042652753",
    	["regex"] = "rbxassetid://100727200791841",
    	["remove-formatting"] = "rbxassetid://112833162022628",
    	["repeat-1"] = "rbxassetid://130144534857095",
    	["repeat-2"] = "rbxassetid://85927537182704",
    	["repeat"] = "rbxassetid://121886242955173",
    	["replace-all"] = "rbxassetid://127862728198635",
    	["replace"] = "rbxassetid://128404082279430",
    	["reply-all"] = "rbxassetid://71723137343562",
    	["reply"] = "rbxassetid://109788633497028",
    	["rewind"] = "rbxassetid://95205297521988",
    	["ribbon"] = "rbxassetid://94265331526851",
    	["rocket"] = "rbxassetid://87412317685854",
    	["rocking-chair"] = "rbxassetid://110420269495360",
    	["roller-coaster"] = "rbxassetid://112426178972099",
    	["rose"] = "rbxassetid://126336840238769",
    	["rotate-3d"] = "rbxassetid://76300551576392",
    	["rotate-ccw-key"] = "rbxassetid://74976035240976",
    	["rotate-ccw-square"] = "rbxassetid://90515853170424",
    	["rotate-ccw"] = "rbxassetid://110116685948665",
    	["rotate-cw-square"] = "rbxassetid://77095448159303",
    	["rotate-cw"] = "rbxassetid://84183336178654",
    	["route-off"] = "rbxassetid://106350402024079",
    	["route"] = "rbxassetid://89968303228953",
    	["router"] = "rbxassetid://102130331994471",
    	["rows-2"] = "rbxassetid://112556185960101",
    	["rows-3"] = "rbxassetid://117215586961375",
    	["rows-4"] = "rbxassetid://125646021959055",
    	["rss"] = "rbxassetid://131789058984793",
    	["ruler-dimension-line"] = "rbxassetid://70673861371412",
    	["ruler"] = "rbxassetid://81432445547423",
    	["russian-ruble"] = "rbxassetid://126357936542156",
    	["sailboat"] = "rbxassetid://87110567187540",
    	["salad"] = "rbxassetid://128864507821603",
    	["sandwich"] = "rbxassetid://104573187458917",
    	["satellite-dish"] = "rbxassetid://136742443888305",
    	["satellite"] = "rbxassetid://134967053164645",
    	["saudi-riyal"] = "rbxassetid://102282769104635",
    	["save-all"] = "rbxassetid://116946975799440",
    	["save-off"] = "rbxassetid://87085435778560",
    	["save"] = "rbxassetid://126116963775616",
    	["scale-3d"] = "rbxassetid://72414199620352",
    	["scale"] = "rbxassetid://108203682317477",
    	["scaling"] = "rbxassetid://122360365318466",
    	["scan-barcode"] = "rbxassetid://96889457154761",
    	["scan-eye"] = "rbxassetid://99244790601968",
    	["scan-face"] = "rbxassetid://109959345069668",
    	["scan-heart"] = "rbxassetid://106280819776142",
    	["scan-line"] = "rbxassetid://126544908146540",
    	["scan-qr-code"] = "rbxassetid://105409149549927",
    	["scan-search"] = "rbxassetid://80009010551347",
    	["scan-text"] = "rbxassetid://73702396787766",
    	["scan"] = "rbxassetid://123104789658180",
    	["school"] = "rbxassetid://76351530290068",
    	["scissors-line-dashed"] = "rbxassetid://122237447974173",
    	["scissors"] = "rbxassetid://118665510911274",
    	["screen-share-off"] = "rbxassetid://107677572669805",
    	["screen-share"] = "rbxassetid://85137895705653",
    	["scroll-text"] = "rbxassetid://97321022666868",
    	["scroll"] = "rbxassetid://74072101474951",
    	["search-check"] = "rbxassetid://75442076191356",
    	["search-code"] = "rbxassetid://117114794592802",
    	["search-slash"] = "rbxassetid://96483932261041",
    	["search-x"] = "rbxassetid://137319957522951",
    	["search"] = "rbxassetid://121018724060431",
    	["section"] = "rbxassetid://91732188298948",
    	["send-horizontal"] = "rbxassetid://111734392411664",
    	["send-to-back"] = "rbxassetid://75340312862253",
    	["send"] = "rbxassetid://127751956873796",
    	["separator-horizontal"] = "rbxassetid://84864453699927",
    	["separator-vertical"] = "rbxassetid://84031801478581",
    	["server-cog"] = "rbxassetid://138470287250966",
    	["server-crash"] = "rbxassetid://132810618000212",
    	["server-off"] = "rbxassetid://114048751507723",
    	["server"] = "rbxassetid://92188766517878",
    	["settings-2"] = "rbxassetid://135684703553372",
    	["settings"] = "rbxassetid://80758916183665",
    	["shapes"] = "rbxassetid://129989433311409",
    	["share-2"] = "rbxassetid://71210767962065",
    	["share"] = "rbxassetid://87340985053299",
    	["sheet"] = "rbxassetid://134902122480171",
    	["shell"] = "rbxassetid://140212943563599",
    	["shield-alert"] = "rbxassetid://114995877719925",
    	["shield-ban"] = "rbxassetid://108765041044649",
    	["shield-check"] = "rbxassetid://87354736164608",
    	["shield-ellipsis"] = "rbxassetid://114794739892123",
    	["shield-half"] = "rbxassetid://117842634172647",
    	["shield-minus"] = "rbxassetid://89965059528921",
    	["shield-off"] = "rbxassetid://133426959132690",
    	["shield-plus"] = "rbxassetid://100664857995498",
    	["shield-question-mark"] = "rbxassetid://135722075265150",
    	["shield-user"] = "rbxassetid://124832775645347",
    	["shield-x"] = "rbxassetid://73370117343811",
    	["shield"] = "rbxassetid://110987169760162",
    	["ship-wheel"] = "rbxassetid://130797795829448",
    	["ship"] = "rbxassetid://83995100553930",
    	["shirt"] = "rbxassetid://106579555405966",
    	["shopping-bag"] = "rbxassetid://71885477293226",
    	["shopping-basket"] = "rbxassetid://138646411956433",
    	["shopping-cart"] = "rbxassetid://128420521375441",
    	["shovel"] = "rbxassetid://102465000512056",
    	["shower-head"] = "rbxassetid://75884944024117",
    	["shredder"] = "rbxassetid://122125164414463",
    	["shrimp"] = "rbxassetid://102625900815307",
    	["shrink"] = "rbxassetid://90953687918880",
    	["shrub"] = "rbxassetid://127326280714343",
    	["shuffle"] = "rbxassetid://132382786975101",
    	["sigma"] = "rbxassetid://126884244870899",
    	["signal-high"] = "rbxassetid://130436670012270",
    	["signal-low"] = "rbxassetid://73674683500458",
    	["signal-medium"] = "rbxassetid://125003021367019",
    	["signal-zero"] = "rbxassetid://130045332414754",
    	["signal"] = "rbxassetid://78424889355261",
    	["signature"] = "rbxassetid://114402748013000",
    	["signpost-big"] = "rbxassetid://115780185675001",
    	["signpost"] = "rbxassetid://106584743791433",
    	["siren"] = "rbxassetid://134210267818039",
    	["skip-back"] = "rbxassetid://70466132711334",
    	["skip-forward"] = "rbxassetid://124844823753990",
    	["skull"] = "rbxassetid://137726256442333",
    	["slack"] = "rbxassetid://96089719516736",
    	["slash"] = "rbxassetid://117792185664263",
    	["slice"] = "rbxassetid://95810504278179",
    	["sliders-horizontal"] = "rbxassetid://85538382643347",
    	["sliders-vertical"] = "rbxassetid://101190569086853",
    	["smartphone-charging"] = "rbxassetid://102837532613995",
    	["smartphone-nfc"] = "rbxassetid://82326425754446",
    	["smartphone"] = "rbxassetid://96623008834511",
    	["smile-plus"] = "rbxassetid://131981881472144",
    	["smile"] = "rbxassetid://105880397565283",
    	["snail"] = "rbxassetid://70904536548363",
    	["snowflake"] = "rbxassetid://101235206534566",
    	["soap-dispenser-droplet"] = "rbxassetid://77258480479465",
    	["sofa"] = "rbxassetid://114427687218324",
    	["solar-panel"] = "rbxassetid://132448188047921",
    	["soup"] = "rbxassetid://115092551871618",
    	["space"] = "rbxassetid://87072088914178",
    	["spade"] = "rbxassetid://131444449466462",
    	["sparkle"] = "rbxassetid://111044800239623",
    	["sparkles"] = "rbxassetid://138635884129147",
    	["speaker"] = "rbxassetid://96227183003618",
    	["speech"] = "rbxassetid://87013139446349",
    	["spell-check-2"] = "rbxassetid://81556731785534",
    	["spell-check"] = "rbxassetid://91913483031334",
    	["spline-pointer"] = "rbxassetid://84842840956804",
    	["spline"] = "rbxassetid://129406685807412",
    	["split"] = "rbxassetid://105112438805988",
    	["spool"] = "rbxassetid://124541981347743",
    	["spotlight"] = "rbxassetid://77571742539344",
    	["spray-can"] = "rbxassetid://128372039366326",
    	["sprout"] = "rbxassetid://100091687832508",
    	["square-activity"] = "rbxassetid://89496630185293",
    	["square-arrow-down-left"] = "rbxassetid://108194680296901",
    	["square-arrow-down-right"] = "rbxassetid://99403846801050",
    	["square-arrow-down"] = "rbxassetid://135962519626588",
    	["square-arrow-left"] = "rbxassetid://111671474549238",
    	["square-arrow-out-down-left"] = "rbxassetid://125714881756353",
    	["square-arrow-out-down-right"] = "rbxassetid://89971003001390",
    	["square-arrow-out-up-left"] = "rbxassetid://103759986579087",
    	["square-arrow-out-up-right"] = "rbxassetid://91221896066807",
    	["square-arrow-right"] = "rbxassetid://113920471701361",
    	["square-arrow-up-left"] = "rbxassetid://112424670290693",
    	["square-arrow-up-right"] = "rbxassetid://76602291406940",
    	["square-arrow-up"] = "rbxassetid://106998604646718",
    	["square-asterisk"] = "rbxassetid://89186832353625",
    	["square-bottom-dashed-scissors"] = "rbxassetid://79076980104803",
    	["square-chart-gantt"] = "rbxassetid://104034017316411",
    	["square-check-big"] = "rbxassetid://115320390907184",
    	["square-check"] = "rbxassetid://134682053539509",
    	["square-chevron-down"] = "rbxassetid://91032307924592",
    	["square-chevron-left"] = "rbxassetid://73143404829510",
    	["square-chevron-right"] = "rbxassetid://90612077729930",
    	["square-chevron-up"] = "rbxassetid://85565910197337",
    	["square-code"] = "rbxassetid://81604576616881",
    	["square-dashed-bottom-code"] = "rbxassetid://100354801563230",
    	["square-dashed-bottom"] = "rbxassetid://101102319625624",
    	["square-dashed-kanban"] = "rbxassetid://90388067649847",
    	["square-dashed-mouse-pointer"] = "rbxassetid://121016142178467",
    	["square-dashed-top-solid"] = "rbxassetid://117157577548540",
    	["square-dashed"] = "rbxassetid://136905537847606",
    	["square-divide"] = "rbxassetid://99894657101970",
    	["square-dot"] = "rbxassetid://116613421354866",
    	["square-equal"] = "rbxassetid://110283363706707",
    	["square-function"] = "rbxassetid://86075219551088",
    	["square-kanban"] = "rbxassetid://114537101260131",
    	["square-library"] = "rbxassetid://73810931222081",
    	["square-m"] = "rbxassetid://117662700410577",
    	["square-menu"] = "rbxassetid://104067089444415",
    	["square-minus"] = "rbxassetid://116764432015770",
    	["square-mouse-pointer"] = "rbxassetid://76141850603920",
    	["square-parking-off"] = "rbxassetid://100857293535141",
    	["square-parking"] = "rbxassetid://133116656122387",
    	["square-pause"] = "rbxassetid://86608552787615",
    	["square-pen"] = "rbxassetid://120239476110475",
    	["square-percent"] = "rbxassetid://87111930314567",
    	["square-pi"] = "rbxassetid://75383328781618",
    	["square-pilcrow"] = "rbxassetid://131854284699367",
    	["square-play"] = "rbxassetid://108186325238481",
    	["square-plus"] = "rbxassetid://114713264461873",
    	["square-power"] = "rbxassetid://129240437805187",
    	["square-radical"] = "rbxassetid://132645931868292",
    	["square-round-corner"] = "rbxassetid://104592745113567",
    	["square-scissors"] = "rbxassetid://110601255612411",
    	["square-sigma"] = "rbxassetid://113231244246816",
    	["square-slash"] = "rbxassetid://105477013908757",
    	["square-split-horizontal"] = "rbxassetid://76095370148660",
    	["square-split-vertical"] = "rbxassetid://88589192032058",
    	["square-square"] = "rbxassetid://136555087357875",
    	["square-stack"] = "rbxassetid://100463396619394",
    	["square-star"] = "rbxassetid://94506958703720",
    	["square-stop"] = "rbxassetid://80018708472943",
    	["square-terminal"] = "rbxassetid://83969264476798",
    	["square-user-round"] = "rbxassetid://86484997229302",
    	["square-user"] = "rbxassetid://70771214183445",
    	["square-x"] = "rbxassetid://125136183850190",
    	["square"] = "rbxassetid://86304921356806",
    	["squares-exclude"] = "rbxassetid://102345385822324",
    	["squares-intersect"] = "rbxassetid://120869602570119",
    	["squares-subtract"] = "rbxassetid://131484650948795",
    	["squares-unite"] = "rbxassetid://96673080107843",
    	["squircle-dashed"] = "rbxassetid://129936702532522",
    	["squircle"] = "rbxassetid://82426632573807",
    	["squirrel"] = "rbxassetid://112864252085343",
    	["stamp"] = "rbxassetid://92370779813368",
    	["star-half"] = "rbxassetid://117449275562979",
    	["star-off"] = "rbxassetid://75742832732503",
    	["star"] = "rbxassetid://136141469398409",
    	["step-back"] = "rbxassetid://108672750005121",
    	["step-forward"] = "rbxassetid://126131872136145",
    	["stethoscope"] = "rbxassetid://122331031702148",
    	["sticker"] = "rbxassetid://79938203791608",
    	["sticky-note"] = "rbxassetid://111894074643919",
    	["store"] = "rbxassetid://90338129673705",
    	["stretch-horizontal"] = "rbxassetid://87665042192343",
    	["stretch-vertical"] = "rbxassetid://95265463417122",
    	["strikethrough"] = "rbxassetid://103417324549613",
    	["subscript"] = "rbxassetid://74553514785183",
    	["sun-dim"] = "rbxassetid://129141645592715",
    	["sun-medium"] = "rbxassetid://130278807964710",
    	["sun-moon"] = "rbxassetid://75752898854559",
    	["sun-snow"] = "rbxassetid://112791898014579",
    	["sun"] = "rbxassetid://110150589884127",
    	["sunrise"] = "rbxassetid://134705665494098",
    	["sunset"] = "rbxassetid://75904872203588",
    	["superscript"] = "rbxassetid://96887696590118",
    	["swatch-book"] = "rbxassetid://126786244872453",
    	["swiss-franc"] = "rbxassetid://113497920041625",
    	["switch-camera"] = "rbxassetid://76841154349737",
    	["sword"] = "rbxassetid://124448418211665",
    	["swords"] = "rbxassetid://81872698913435",
    	["syringe"] = "rbxassetid://123891270479254",
    	["table-2"] = "rbxassetid://95751552281545",
    	["table-cells-merge"] = "rbxassetid://95363715175258",
    	["table-cells-split"] = "rbxassetid://114799086088649",
    	["table-columns-split"] = "rbxassetid://111011625447949",
    	["table-of-contents"] = "rbxassetid://135044763275414",
    	["table-properties"] = "rbxassetid://125062886015372",
    	["table-rows-split"] = "rbxassetid://96443733673997",
    	["table"] = "rbxassetid://109109148250737",
    	["tablet-smartphone"] = "rbxassetid://133680859813404",
    	["tablet"] = "rbxassetid://128403991264386",
    	["tablets"] = "rbxassetid://80835787970735",
    	["tag"] = "rbxassetid://129104970103940",
    	["tags"] = "rbxassetid://107179263080798",
    	["tally-1"] = "rbxassetid://115301298241643",
    	["tally-2"] = "rbxassetid://110363186864027",
    	["tally-3"] = "rbxassetid://97655344572540",
    	["tally-4"] = "rbxassetid://102633494371890",
    	["tally-5"] = "rbxassetid://88031817475886",
    	["tangent"] = "rbxassetid://123263132981724",
    	["target"] = "rbxassetid://87563802520297",
    	["telescope"] = "rbxassetid://91755049143647",
    	["tent-tree"] = "rbxassetid://76698322463977",
    	["tent"] = "rbxassetid://109779587826330",
    	["terminal"] = "rbxassetid://106783148545356",
    	["test-tube-diagonal"] = "rbxassetid://75662704378840",
    	["test-tube"] = "rbxassetid://98801015650164",
    	["test-tubes"] = "rbxassetid://92555361447433",
    	["text-align-center"] = "rbxassetid://84051028246390",
    	["text-align-end"] = "rbxassetid://130041738343555",
    	["text-align-justify"] = "rbxassetid://80279880143030",
    	["text-align-start"] = "rbxassetid://134489585487649",
    	["text-cursor-input"] = "rbxassetid://107551944047171",
    	["text-cursor"] = "rbxassetid://115984654447300",
    	["text-initial"] = "rbxassetid://129458097472087",
    	["text-quote"] = "rbxassetid://139278366448736",
    	["text-search"] = "rbxassetid://92345384671606",
    	["text-select"] = "rbxassetid://117087320884956",
    	["text-wrap"] = "rbxassetid://114804318314018",
    	["theater"] = "rbxassetid://108558145549163",
    	["thermometer-snowflake"] = "rbxassetid://121876188028425",
    	["thermometer-sun"] = "rbxassetid://106693240074310",
    	["thermometer"] = "rbxassetid://106546011492311",
    	["thumbs-down"] = "rbxassetid://87794009914015",
    	["thumbs-up"] = "rbxassetid://111137070767020",
    	["ticket-check"] = "rbxassetid://105428777212507",
    	["ticket-minus"] = "rbxassetid://78966299769328",
    	["ticket-percent"] = "rbxassetid://80834774406405",
    	["ticket-plus"] = "rbxassetid://110086734392189",
    	["ticket-slash"] = "rbxassetid://89045681172265",
    	["ticket-x"] = "rbxassetid://88674114109926",
    	["ticket"] = "rbxassetid://126527071492145",
    	["tickets-plane"] = "rbxassetid://100367018248695",
    	["tickets"] = "rbxassetid://135268612687833",
    	["timer-off"] = "rbxassetid://110916370767271",
    	["timer-reset"] = "rbxassetid://110052125369932",
    	["timer"] = "rbxassetid://85473888890506",
    	["toggle-left"] = "rbxassetid://85887872573050",
    	["toggle-right"] = "rbxassetid://90411952142550",
    	["toilet"] = "rbxassetid://80930782432931",
    	["tool-case"] = "rbxassetid://87533537832522",
    	["tornado"] = "rbxassetid://88358291515768",
    	["torus"] = "rbxassetid://70855707283051",
    	["touchpad-off"] = "rbxassetid://78784008075456",
    	["touchpad"] = "rbxassetid://74882354908014",
    	["tower-control"] = "rbxassetid://95937619060532",
    	["toy-brick"] = "rbxassetid://86293483924633",
    	["tractor"] = "rbxassetid://103376704722051",
    	["traffic-cone"] = "rbxassetid://74110220470369",
    	["train-front-tunnel"] = "rbxassetid://105194827005114",
    	["train-front"] = "rbxassetid://125237934215370",
    	["train-track"] = "rbxassetid://77451032453723",
    	["tram-front"] = "rbxassetid://93315182364998",
    	["transgender"] = "rbxassetid://135530817673639",
    	["trash-2"] = "rbxassetid://109843431391323",
    	["trash"] = "rbxassetid://106723740584310",
    	["tree-deciduous"] = "rbxassetid://123124389219004",
    	["tree-palm"] = "rbxassetid://103846705893963",
    	["tree-pine"] = "rbxassetid://124662547202594",
    	["trees"] = "rbxassetid://121203841375919",
    	["trello"] = "rbxassetid://130987241149527",
    	["trending-down"] = "rbxassetid://139309232226438",
    	["trending-up-down"] = "rbxassetid://85083293981691",
    	["trending-up"] = "rbxassetid://81819858538839",
    	["triangle-alert"] = "rbxassetid://125920361880643",
    	["triangle-dashed"] = "rbxassetid://124324079103935",
    	["triangle-right"] = "rbxassetid://116930791412791",
    	["triangle"] = "rbxassetid://126330486745540",
    	["trophy"] = "rbxassetid://131545003268773",
    	["truck-electric"] = "rbxassetid://111873446387359",
    	["truck"] = "rbxassetid://86662707764771",
    	["turkish-lira"] = "rbxassetid://114589876174070",
    	["turntable"] = "rbxassetid://129870346487856",
    	["turtle"] = "rbxassetid://118295081560334",
    	["tv-minimal-play"] = "rbxassetid://99201833426972",
    	["tv-minimal"] = "rbxassetid://100382201729427",
    	["tv"] = "rbxassetid://135687724791776",
    	["twitch"] = "rbxassetid://71383308134888",
    	["twitter"] = "rbxassetid://88791703276842",
    	["type-outline"] = "rbxassetid://80108627791690",
    	["type"] = "rbxassetid://133543553793564",
    	["umbrella-off"] = "rbxassetid://72395143739955",
    	["umbrella"] = "rbxassetid://127502210274589",
    	["underline"] = "rbxassetid://123709229216544",
    	["undo-2"] = "rbxassetid://113885292059932",
    	["undo-dot"] = "rbxassetid://132055277744844",
    	["undo"] = "rbxassetid://111258459077271",
    	["unfold-horizontal"] = "rbxassetid://117128358526398",
    	["unfold-vertical"] = "rbxassetid://116593025265499",
    	["ungroup"] = "rbxassetid://106674800451003",
    	["university"] = "rbxassetid://84652528263642",
    	["unlink-2"] = "rbxassetid://128131898892572",
    	["unlink"] = "rbxassetid://139835795227752",
    	["unplug"] = "rbxassetid://90171381619874",
    	["upload"] = "rbxassetid://138212042425501",
    	["usb"] = "rbxassetid://117230058949613",
    	["user-check"] = "rbxassetid://81775205032725",
    	["user-cog"] = "rbxassetid://92795491530865",
    	["user-lock"] = "rbxassetid://78892639693821",
    	["user-minus"] = "rbxassetid://126976941957511",
    	["user-pen"] = "rbxassetid://87445472574836",
    	["user-plus"] = "rbxassetid://118514469915884",
    	["user-round-check"] = "rbxassetid://118794737621941",
    	["user-round-cog"] = "rbxassetid://78239503290053",
    	["user-round-minus"] = "rbxassetid://98944176636447",
    	["user-round-pen"] = "rbxassetid://108155244324878",
    	["user-round-plus"] = "rbxassetid://113301899567470",
    	["user-round-search"] = "rbxassetid://71565774381870",
    	["user-round-x"] = "rbxassetid://122367980560930",
    	["user-round"] = "rbxassetid://136485052187963",
    	["user-search"] = "rbxassetid://101335649828115",
    	["user-star"] = "rbxassetid://98777846316000",
    	["user-x"] = "rbxassetid://139748155894754",
    	["user"] = "rbxassetid://81589895647169",
    	["users-round"] = "rbxassetid://103005444008339",
    	["users"] = "rbxassetid://115398113982385",
    	["utensils-crossed"] = "rbxassetid://109520762270383",
    	["utensils"] = "rbxassetid://139952569804235",
    	["utility-pole"] = "rbxassetid://101965541238242",
    	["variable"] = "rbxassetid://104743088438151",
    	["vault"] = "rbxassetid://108049164599845",
    	["vector-square"] = "rbxassetid://86713728565344",
    	["vegan"] = "rbxassetid://119489190688082",
    	["venetian-mask"] = "rbxassetid://102636443033920",
    	["venus-and-mars"] = "rbxassetid://120227752103771",
    	["venus"] = "rbxassetid://82891342220859",
    	["vibrate-off"] = "rbxassetid://113446447326246",
    	["vibrate"] = "rbxassetid://108330910738733",
    	["video-off"] = "rbxassetid://132239189859305",
    	["video"] = "rbxassetid://107587444636945",
    	["videotape"] = "rbxassetid://114816894323398",
    	["view"] = "rbxassetid://118717253976805",
    	["voicemail"] = "rbxassetid://134313454010227",
    	["volleyball"] = "rbxassetid://83889351124153",
    	["volume-1"] = "rbxassetid://98514588731639",
    	["volume-2"] = "rbxassetid://89344380902620",
    	["volume-off"] = "rbxassetid://103047478058767",
    	["volume-x"] = "rbxassetid://139252359189540",
    	["volume"] = "rbxassetid://103236289817396",
    	["vote"] = "rbxassetid://89409762851246",
    	["wallet-cards"] = "rbxassetid://129728715308337",
    	["wallet-minimal"] = "rbxassetid://137800448816116",
    	["wallet"] = "rbxassetid://132331555762628",
    	["wallpaper"] = "rbxassetid://74682121235494",
    	["wand-sparkles"] = "rbxassetid://82546429942392",
    	["wand"] = "rbxassetid://114580617777835",
    	["warehouse"] = "rbxassetid://78388887451080",
    	["washing-machine"] = "rbxassetid://104194127573858",
    	["watch"] = "rbxassetid://130544621618405",
    	["waves-ladder"] = "rbxassetid://101808619355514",
    	["waves"] = "rbxassetid://96340135183647",
    	["waypoints"] = "rbxassetid://102450133666017",
    	["webcam"] = "rbxassetid://104148487911129",
    	["webhook-off"] = "rbxassetid://96370548093471",
    	["webhook"] = "rbxassetid://112812457747322",
    	["weight"] = "rbxassetid://103860559844854",
    	["wheat-off"] = "rbxassetid://133294844612307",
    	["wheat"] = "rbxassetid://85261952080359",
    	["whole-word"] = "rbxassetid://90111083954485",
    	["wifi-cog"] = "rbxassetid://110500263326209",
    	["wifi-high"] = "rbxassetid://81954601342139",
    	["wifi-low"] = "rbxassetid://138217335635913",
    	["wifi-off"] = "rbxassetid://74113634330106",
    	["wifi-pen"] = "rbxassetid://91290205064712",
    	["wifi-sync"] = "rbxassetid://84043971055177",
    	["wifi-zero"] = "rbxassetid://124286465246123",
    	["wifi"] = "rbxassetid://104669375183960",
    	["wind-arrow-down"] = "rbxassetid://127753987414870",
    	["wind"] = "rbxassetid://114551690399915",
    	["wine-off"] = "rbxassetid://108294164302317",
    	["wine"] = "rbxassetid://115743721332829",
    	["workflow"] = "rbxassetid://99186544029189",
    	["worm"] = "rbxassetid://115752311548091",
    	["wrench"] = "rbxassetid://112148279212860",
    	["x"] = "rbxassetid://110786993356448",
    	["youtube"] = "rbxassetid://123663668456341",
    	["zap-off"] = "rbxassetid://81385483183652",
    	["zap"] = "rbxassetid://130551565616516",
    	["zoom-in"] = "rbxassetid://127956924984803",
    	["zoom-out"] = "rbxassetid://108334162607319",
    }

    return lucideIcons
end)()
local solarIcons   = (function()
    local solarIcons = {
        ["4-k-bold"] = "rbxassetid://101120062438598",
    	["4-k-bold-duotone"] = "rbxassetid://126989059970515",
    	["4-k-broken"] = "rbxassetid://92249598853910",
    	["4-k-line-duotone"] = "rbxassetid://104684186471030",
    	["4-k-linear"] = "rbxassetid://97192250167717",
    	["4-k-outline"] = "rbxassetid://125154263962247",
    	["accessibility-bold"] = "rbxassetid://93185703470955",
    	["accessibility-bold-duotone"] = "rbxassetid://92804781804692",
    	["accessibility-broken"] = "rbxassetid://118663159902292",
    	["accessibility-line-duotone"] = "rbxassetid://89775331976041",
    	["accessibility-linear"] = "rbxassetid://135355322565211",
    	["accessibility-outline"] = "rbxassetid://116113708071947",
    	["accumulator-bold"] = "rbxassetid://77779477064861",
    	["accumulator-linear"] = "rbxassetid://137952694280343",
    	["add-circle-bold"] = "rbxassetid://139478909806812",
    	["add-circle-bold-duotone"] = "rbxassetid://111633677396509",
    	["add-circle-broken"] = "rbxassetid://71971473356064",
    	["add-circle-line-duotone"] = "rbxassetid://108955871025711",
    	["add-circle-linear"] = "rbxassetid://90038352293436",
    	["add-circle-outline"] = "rbxassetid://109943070611447",
    	["add-folder-bold"] = "rbxassetid://79676023660166",
    	["add-folder-bold-duotone"] = "rbxassetid://118608478399586",
    	["add-folder-broken"] = "rbxassetid://102791878721789",
    	["add-folder-line-duotone"] = "rbxassetid://124221659981268",
    	["add-folder-linear"] = "rbxassetid://106830316070672",
    	["add-folder-outline"] = "rbxassetid://104075011759824",
    	["add-square-bold"] = "rbxassetid://123814080145589",
    	["add-square-bold-duotone"] = "rbxassetid://81887342786441",
    	["add-square-broken"] = "rbxassetid://83452998181816",
    	["add-square-line-duotone"] = "rbxassetid://116678313492064",
    	["add-square-linear"] = "rbxassetid://102198172144691",
    	["add-square-outline"] = "rbxassetid://107788851217472",
    	["adhesive-plaster-2-bold"] = "rbxassetid://137710405817081",
    	["adhesive-plaster-2-bold-duotone"] = "rbxassetid://93176492500638",
    	["adhesive-plaster-2-broken"] = "rbxassetid://104186835386613",
    	["adhesive-plaster-2-line-duotone"] = "rbxassetid://83052367948642",
    	["adhesive-plaster-2-linear"] = "rbxassetid://132663571218762",
    	["adhesive-plaster-2-outline"] = "rbxassetid://127391781443100",
    	["adhesive-plaster-bold"] = "rbxassetid://103862563694954",
    	["adhesive-plaster-bold-duotone"] = "rbxassetid://80607228784025",
    	["adhesive-plaster-broken"] = "rbxassetid://127197845342097",
    	["adhesive-plaster-line-duotone"] = "rbxassetid://111133662128228",
    	["adhesive-plaster-linear"] = "rbxassetid://89011561018209",
    	["adhesive-plaster-outline"] = "rbxassetid://132644107616701",
    	["airbuds-bold"] = "rbxassetid://79899601682293",
    	["airbuds-bold-duotone"] = "rbxassetid://130500351179392",
    	["airbuds-broken"] = "rbxassetid://104040998713846",
    	["airbuds-case-bold"] = "rbxassetid://91577497572229",
    	["airbuds-case-bold-duotone"] = "rbxassetid://96191423377681",
    	["airbuds-case-broken"] = "rbxassetid://95028736705834",
    	["airbuds-case-charge-bold"] = "rbxassetid://81628313108625",
    	["airbuds-case-charge-bold-duotone"] = "rbxassetid://126610964287555",
    	["airbuds-case-charge-broken"] = "rbxassetid://121635528897600",
    	["airbuds-case-charge-line-duotone"] = "rbxassetid://91805505157992",
    	["airbuds-case-charge-linear"] = "rbxassetid://96629634786686",
    	["airbuds-case-charge-outline"] = "rbxassetid://104541144936328",
    	["airbuds-case-line-duotone"] = "rbxassetid://71484176302988",
    	["airbuds-case-linear"] = "rbxassetid://120992094343706",
    	["airbuds-case-minimalistic-bold"] = "rbxassetid://101860495296783",
    	["airbuds-case-minimalistic-bold-duotone"] = "rbxassetid://86048583298461",
    	["airbuds-case-minimalistic-broken"] = "rbxassetid://101125376103800",
    	["airbuds-case-minimalistic-line-duotone"] = "rbxassetid://130104574629189",
    	["airbuds-case-minimalistic-linear"] = "rbxassetid://72790211117123",
    	["airbuds-case-minimalistic-outline"] = "rbxassetid://92069759383931",
    	["airbuds-case-open-bold"] = "rbxassetid://101161334364687",
    	["airbuds-case-open-bold-duotone"] = "rbxassetid://94953273950585",
    	["airbuds-case-open-broken"] = "rbxassetid://98193099951437",
    	["airbuds-case-open-line-duotone"] = "rbxassetid://72379870644725",
    	["airbuds-case-open-linear"] = "rbxassetid://91026686980303",
    	["airbuds-case-open-outline"] = "rbxassetid://83652205721846",
    	["airbuds-case-outline"] = "rbxassetid://97395187208293",
    	["airbuds-charge-bold"] = "rbxassetid://100856387884674",
    	["airbuds-charge-bold-duotone"] = "rbxassetid://132338886450738",
    	["airbuds-charge-broken"] = "rbxassetid://77114643428928",
    	["airbuds-charge-line-duotone"] = "rbxassetid://81136650694316",
    	["airbuds-charge-linear"] = "rbxassetid://139020596016678",
    	["airbuds-charge-outline"] = "rbxassetid://117672036352003",
    	["airbuds-check-bold"] = "rbxassetid://73717092179504",
    	["airbuds-check-bold-duotone"] = "rbxassetid://100179763445970",
    	["airbuds-check-broken"] = "rbxassetid://92600356442092",
    	["airbuds-check-line-duotone"] = "rbxassetid://128590100385706",
    	["airbuds-check-linear"] = "rbxassetid://139465354348116",
    	["airbuds-check-outline"] = "rbxassetid://73172565688898",
    	["airbuds-left-bold"] = "rbxassetid://83620215682090",
    	["airbuds-left-bold-duotone"] = "rbxassetid://110546989723741",
    	["airbuds-left-broken"] = "rbxassetid://81535372177862",
    	["airbuds-left-line-duotone"] = "rbxassetid://95169030169415",
    	["airbuds-left-linear"] = "rbxassetid://81089392910038",
    	["airbuds-left-outline"] = "rbxassetid://101024217127572",
    	["airbuds-line-duotone"] = "rbxassetid://139388728886852",
    	["airbuds-linear"] = "rbxassetid://101905716349699",
    	["airbuds-outline"] = "rbxassetid://135210558452887",
    	["airbuds-remove-bold"] = "rbxassetid://80866575674358",
    	["airbuds-remove-bold-duotone"] = "rbxassetid://104975882572570",
    	["airbuds-remove-broken"] = "rbxassetid://100765076615629",
    	["airbuds-remove-line-duotone"] = "rbxassetid://110903500125448",
    	["airbuds-remove-linear"] = "rbxassetid://130999269199614",
    	["airbuds-remove-outline"] = "rbxassetid://76414479047185",
    	["airbuds-right-bold"] = "rbxassetid://125657715024097",
    	["airbuds-right-bold-duotone"] = "rbxassetid://126020132950731",
    	["airbuds-right-broken"] = "rbxassetid://77450501817651",
    	["airbuds-right-line-duotone"] = "rbxassetid://91117762528879",
    	["airbuds-right-linear"] = "rbxassetid://72971004377034",
    	["airbuds-right-outline"] = "rbxassetid://114184924534774",
    	["alarm-add-bold"] = "rbxassetid://118832521157694",
    	["alarm-add-bold-duotone"] = "rbxassetid://117424009778706",
    	["alarm-add-broken"] = "rbxassetid://139483915053493",
    	["alarm-add-line-duotone"] = "rbxassetid://97013397656297",
    	["alarm-add-linear"] = "rbxassetid://126866868996446",
    	["alarm-add-outline"] = "rbxassetid://100699705449510",
    	["alarm-bold"] = "rbxassetid://87863196054318",
    	["alarm-bold-duotone"] = "rbxassetid://97354068318819",
    	["alarm-broken"] = "rbxassetid://129247739055305",
    	["alarm-line-duotone"] = "rbxassetid://76445983824581",
    	["alarm-linear"] = "rbxassetid://80848643578674",
    	["alarm-outline"] = "rbxassetid://106044644889772",
    	["alarm-pause-bold"] = "rbxassetid://140034283208649",
    	["alarm-pause-bold-duotone"] = "rbxassetid://132658343089567",
    	["alarm-pause-broken"] = "rbxassetid://95944880287328",
    	["alarm-pause-line-duotone"] = "rbxassetid://111945985857521",
    	["alarm-pause-linear"] = "rbxassetid://102350322194875",
    	["alarm-pause-outline"] = "rbxassetid://77551818888993",
    	["alarm-play-bold"] = "rbxassetid://117542211985752",
    	["alarm-play-bold-duotone"] = "rbxassetid://92898941462783",
    	["alarm-play-broken"] = "rbxassetid://117119304655102",
    	["alarm-play-line-duotone"] = "rbxassetid://130038601944320",
    	["alarm-play-linear"] = "rbxassetid://87793588467460",
    	["alarm-play-outline"] = "rbxassetid://98062817718138",
    	["alarm-remove-bold"] = "rbxassetid://86145891651954",
    	["alarm-remove-bold-duotone"] = "rbxassetid://127469625827729",
    	["alarm-remove-broken"] = "rbxassetid://91091240046415",
    	["alarm-remove-line-duotone"] = "rbxassetid://85974684822741",
    	["alarm-remove-linear"] = "rbxassetid://134599954927243",
    	["alarm-remove-outline"] = "rbxassetid://103020465413313",
    	["alarm-sleep-bold"] = "rbxassetid://83595096742619",
    	["alarm-sleep-bold-duotone"] = "rbxassetid://102206808258104",
    	["alarm-sleep-broken"] = "rbxassetid://72506942689254",
    	["alarm-sleep-line-duotone"] = "rbxassetid://81334527793723",
    	["alarm-sleep-linear"] = "rbxassetid://110929871628144",
    	["alarm-sleep-outline"] = "rbxassetid://114838805574783",
    	["alarm-turn-off-bold"] = "rbxassetid://94898956597322",
    	["alarm-turn-off-bold-duotone"] = "rbxassetid://92239633481788",
    	["alarm-turn-off-broken"] = "rbxassetid://77641332867357",
    	["alarm-turn-off-line-duotone"] = "rbxassetid://109603753951394",
    	["alarm-turn-off-linear"] = "rbxassetid://99748166876368",
    	["alarm-turn-off-outline"] = "rbxassetid://122517738235571",
    	["album-bold"] = "rbxassetid://100080266427156",
    	["album-bold-duotone"] = "rbxassetid://106955737142097",
    	["album-broken"] = "rbxassetid://107975682806683",
    	["album-line-duotone"] = "rbxassetid://115442281290813",
    	["album-linear"] = "rbxassetid://75790196563738",
    	["album-outline"] = "rbxassetid://129254785257209",
    	["align-bottom-bold"] = "rbxassetid://76617820234901",
    	["align-bottom-bold-duotone"] = "rbxassetid://86631472202872",
    	["align-bottom-broken"] = "rbxassetid://139870541647302",
    	["align-bottom-line-duotone"] = "rbxassetid://104495692745454",
    	["align-bottom-linear"] = "rbxassetid://110518230644951",
    	["align-bottom-outline"] = "rbxassetid://85514006409750",
    	["align-horizonta-spacing-bold"] = "rbxassetid://102991878824177",
    	["align-horizonta-spacing-bold-duotone"] = "rbxassetid://138211620453713",
    	["align-horizonta-spacing-broken"] = "rbxassetid://105429286985220",
    	["align-horizonta-spacing-line-duotone"] = "rbxassetid://123713025589708",
    	["align-horizonta-spacing-linear"] = "rbxassetid://135389353401754",
    	["align-horizonta-spacing-outline"] = "rbxassetid://137549279469045",
    	["align-horizontal-center-bold"] = "rbxassetid://104415582756414",
    	["align-horizontal-center-bold-duotone"] = "rbxassetid://112902734002209",
    	["align-horizontal-center-broken"] = "rbxassetid://139509152419275",
    	["align-horizontal-center-line-duotone"] = "rbxassetid://76763726663401",
    	["align-horizontal-center-linear"] = "rbxassetid://93503846037670",
    	["align-horizontal-center-outline"] = "rbxassetid://129140930316120",
    	["align-left-bold"] = "rbxassetid://100463302569744",
    	["align-left-bold-duotone"] = "rbxassetid://131317626823850",
    	["align-left-broken"] = "rbxassetid://79706275538069",
    	["align-left-line-duotone"] = "rbxassetid://99545277478165",
    	["align-left-linear"] = "rbxassetid://121871479875358",
    	["align-left-outline"] = "rbxassetid://110347641139635",
    	["align-right-bold"] = "rbxassetid://117468537936756",
    	["align-right-bold-duotone"] = "rbxassetid://102852408979462",
    	["align-right-broken"] = "rbxassetid://96352903679209",
    	["align-right-line-duotone"] = "rbxassetid://77612082722962",
    	["align-right-linear"] = "rbxassetid://81198438029821",
    	["align-right-outline"] = "rbxassetid://124304670693815",
    	["align-top-bold"] = "rbxassetid://95658281880384",
    	["align-top-bold-duotone"] = "rbxassetid://114047137225289",
    	["align-top-broken"] = "rbxassetid://123251831567412",
    	["align-top-line-duotone"] = "rbxassetid://113519012167025",
    	["align-top-linear"] = "rbxassetid://119517879339519",
    	["align-top-outline"] = "rbxassetid://119274834032191",
    	["align-vertical-center-bold"] = "rbxassetid://92116479462116",
    	["align-vertical-center-bold-duotone"] = "rbxassetid://85322926175531",
    	["align-vertical-center-broken"] = "rbxassetid://70878993432090",
    	["align-vertical-center-line-duotone"] = "rbxassetid://71727191600464",
    	["align-vertical-center-linear"] = "rbxassetid://85608488495968",
    	["align-vertical-center-outline"] = "rbxassetid://108112942385794",
    	["align-vertical-spacing-bold"] = "rbxassetid://92654428361528",
    	["align-vertical-spacing-bold-duotone"] = "rbxassetid://121523193972875",
    	["align-vertical-spacing-broken"] = "rbxassetid://132751998938817",
    	["align-vertical-spacing-line-duotone"] = "rbxassetid://80527763049020",
    	["align-vertical-spacing-linear"] = "rbxassetid://123341352015084",
    	["align-vertical-spacing-outline"] = "rbxassetid://121037495017348",
    	["alt-arrow-down-bold"] = "rbxassetid://92993587446526",
    	["alt-arrow-down-bold-duotone"] = "rbxassetid://78915786260720",
    	["alt-arrow-down-broken"] = "rbxassetid://133666676975923",
    	["alt-arrow-down-line-duotone"] = "rbxassetid://81407047005159",
    	["alt-arrow-down-linear"] = "rbxassetid://122671882141370",
    	["alt-arrow-down-outline"] = "rbxassetid://108225652984241",
    	["alt-arrow-left-bold"] = "rbxassetid://123545657728863",
    	["alt-arrow-left-bold-duotone"] = "rbxassetid://135394573574033",
    	["alt-arrow-left-broken"] = "rbxassetid://118314548444755",
    	["alt-arrow-left-line-duotone"] = "rbxassetid://83743246131452",
    	["alt-arrow-left-linear"] = "rbxassetid://87873940356938",
    	["alt-arrow-left-outline"] = "rbxassetid://98901772643464",
    	["alt-arrow-right-bold"] = "rbxassetid://136791643717191",
    	["alt-arrow-right-bold-duotone"] = "rbxassetid://111862849751290",
    	["alt-arrow-right-broken"] = "rbxassetid://72642865412108",
    	["alt-arrow-right-line-duotone"] = "rbxassetid://92271383473977",
    	["alt-arrow-right-linear"] = "rbxassetid://72436148617777",
    	["alt-arrow-right-outline"] = "rbxassetid://119781639572794",
    	["alt-arrow-up-bold"] = "rbxassetid://133229409654787",
    	["alt-arrow-up-bold-duotone"] = "rbxassetid://107361999621420",
    	["alt-arrow-up-broken"] = "rbxassetid://120658146779579",
    	["alt-arrow-up-line-duotone"] = "rbxassetid://84370614758188",
    	["alt-arrow-up-linear"] = "rbxassetid://92754164338163",
    	["alt-arrow-up-outline"] = "rbxassetid://126016604376979",
    	["archive-bold"] = "rbxassetid://82469497521888",
    	["archive-bold-duotone"] = "rbxassetid://97347443389835",
    	["archive-broken"] = "rbxassetid://114292788432912",
    	["archive-check-bold"] = "rbxassetid://94946977115413",
    	["archive-check-bold-duotone"] = "rbxassetid://112720844259961",
    	["archive-check-broken"] = "rbxassetid://132755862574041",
    	["archive-check-line-duotone"] = "rbxassetid://130609378809501",
    	["archive-check-linear"] = "rbxassetid://95542870873119",
    	["archive-check-outline"] = "rbxassetid://102214490002038",
    	["archive-down-bold"] = "rbxassetid://112130596451932",
    	["archive-down-bold-duotone"] = "rbxassetid://84822328219750",
    	["archive-down-broken"] = "rbxassetid://123483316318461",
    	["archive-down-line-duotone"] = "rbxassetid://104058700495959",
    	["archive-down-linear"] = "rbxassetid://130577013180564",
    	["archive-down-minimlistic-bold"] = "rbxassetid://94441493899481",
    	["archive-down-minimlistic-bold-duotone"] = "rbxassetid://105435714733563",
    	["archive-down-minimlistic-broken"] = "rbxassetid://71766074383227",
    	["archive-down-minimlistic-line-duotone"] = "rbxassetid://88154100506434",
    	["archive-down-minimlistic-linear"] = "rbxassetid://110441425636076",
    	["archive-down-minimlistic-outline"] = "rbxassetid://126516492296139",
    	["archive-down-outline"] = "rbxassetid://123371571562452",
    	["archive-line-duotone"] = "rbxassetid://110135479569886",
    	["archive-linear"] = "rbxassetid://85322129552529",
    	["archive-minimalistic-bold"] = "rbxassetid://131697260777673",
    	["archive-minimalistic-bold-duotone"] = "rbxassetid://100392523691188",
    	["archive-minimalistic-broken"] = "rbxassetid://98695433762541",
    	["archive-minimalistic-line-duotone"] = "rbxassetid://125703219860399",
    	["archive-minimalistic-linear"] = "rbxassetid://123715888555125",
    	["archive-minimalistic-outline"] = "rbxassetid://104822386162009",
    	["archive-outline"] = "rbxassetid://135496464921266",
    	["archive-up-bold"] = "rbxassetid://101963344754794",
    	["archive-up-bold-duotone"] = "rbxassetid://72432373697718",
    	["archive-up-broken"] = "rbxassetid://121273130973116",
    	["archive-up-line-duotone"] = "rbxassetid://70582656047417",
    	["archive-up-linear"] = "rbxassetid://116964027893772",
    	["archive-up-minimlistic-bold"] = "rbxassetid://105546392045741",
    	["archive-up-minimlistic-bold-duotone"] = "rbxassetid://122406306701558",
    	["archive-up-minimlistic-broken"] = "rbxassetid://85060382161589",
    	["archive-up-minimlistic-line-duotone"] = "rbxassetid://129971923036697",
    	["archive-up-minimlistic-linear"] = "rbxassetid://80206738578948",
    	["archive-up-minimlistic-outline"] = "rbxassetid://125971457520086",
    	["archive-up-outline"] = "rbxassetid://87127132652550",
    	["armchair-2-bold"] = "rbxassetid://110137596225198",
    	["armchair-2-bold-duotone"] = "rbxassetid://138964690256647",
    	["armchair-2-broken"] = "rbxassetid://129924165238708",
    	["armchair-2-line-duotone"] = "rbxassetid://87904341991298",
    	["armchair-2-linear"] = "rbxassetid://111802626836743",
    	["armchair-2-outline"] = "rbxassetid://132259947101780",
    	["armchair-bold"] = "rbxassetid://77008061642022",
    	["armchair-bold-duotone"] = "rbxassetid://75644749949138",
    	["armchair-broken"] = "rbxassetid://71484028354238",
    	["armchair-line-duotone"] = "rbxassetid://130618621941099",
    	["armchair-linear"] = "rbxassetid://99594787127165",
    	["armchair-outline"] = "rbxassetid://116425112550804",
    	["arrow-down-bold"] = "rbxassetid://82011741143422",
    	["arrow-down-bold-duotone"] = "rbxassetid://82330468833606",
    	["arrow-down-broken"] = "rbxassetid://126618986740626",
    	["arrow-down-line-duotone"] = "rbxassetid://98193937240565",
    	["arrow-down-linear"] = "rbxassetid://109885152383937",
    	["arrow-down-outline"] = "rbxassetid://111661707317934",
    	["arrow-left-bold"] = "rbxassetid://71060793100374",
    	["arrow-left-bold-duotone"] = "rbxassetid://102972344725438",
    	["arrow-left-broken"] = "rbxassetid://110593528821654",
    	["arrow-left-down-bold"] = "rbxassetid://72071078068087",
    	["arrow-left-down-bold-duotone"] = "rbxassetid://70921351478393",
    	["arrow-left-down-broken"] = "rbxassetid://128536179322438",
    	["arrow-left-down-line-duotone"] = "rbxassetid://75800260546608",
    	["arrow-left-down-linear"] = "rbxassetid://88803739666097",
    	["arrow-left-down-outline"] = "rbxassetid://100433580032159",
    	["arrow-left-line-duotone"] = "rbxassetid://72184857981455",
    	["arrow-left-linear"] = "rbxassetid://138799951076455",
    	["arrow-left-outline"] = "rbxassetid://85163001398939",
    	["arrow-left-up-bold"] = "rbxassetid://87473838921428",
    	["arrow-left-up-bold-duotone"] = "rbxassetid://98553191165650",
    	["arrow-left-up-broken"] = "rbxassetid://94449778065002",
    	["arrow-left-up-line-duotone"] = "rbxassetid://118667792080799",
    	["arrow-left-up-linear"] = "rbxassetid://133584619011513",
    	["arrow-left-up-outline"] = "rbxassetid://75171736040889",
    	["arrow-right-bold"] = "rbxassetid://118048207855996",
    	["arrow-right-bold-duotone"] = "rbxassetid://123595061597372",
    	["arrow-right-broken"] = "rbxassetid://134281269713938",
    	["arrow-right-down-bold"] = "rbxassetid://114167181406052",
    	["arrow-right-down-bold-duotone"] = "rbxassetid://111747489941484",
    	["arrow-right-down-broken"] = "rbxassetid://71540671883476",
    	["arrow-right-down-line-duotone"] = "rbxassetid://134669793613532",
    	["arrow-right-down-linear"] = "rbxassetid://74344331776716",
    	["arrow-right-down-outline"] = "rbxassetid://114943265228913",
    	["arrow-right-line-duotone"] = "rbxassetid://81118997696951",
    	["arrow-right-linear"] = "rbxassetid://109308343571802",
    	["arrow-right-outline"] = "rbxassetid://110228674780896",
    	["arrow-right-up-bold"] = "rbxassetid://99571448751925",
    	["arrow-right-up-bold-duotone"] = "rbxassetid://92369482671239",
    	["arrow-right-up-broken"] = "rbxassetid://107252876289374",
    	["arrow-right-up-line-duotone"] = "rbxassetid://80737501970288",
    	["arrow-right-up-linear"] = "rbxassetid://95266927628906",
    	["arrow-right-up-outline"] = "rbxassetid://127640791689041",
    	["arrow-to-down-left-bold"] = "rbxassetid://124621822043691",
    	["arrow-to-down-left-bold-duotone"] = "rbxassetid://109059571838426",
    	["arrow-to-down-left-broken"] = "rbxassetid://135625876727944",
    	["arrow-to-down-left-line-duotone"] = "rbxassetid://97563447341500",
    	["arrow-to-down-left-linear"] = "rbxassetid://118817824239215",
    	["arrow-to-down-left-outline"] = "rbxassetid://93600908967420",
    	["arrow-to-down-right-bold"] = "rbxassetid://77591094009658",
    	["arrow-to-down-right-bold-duotone"] = "rbxassetid://103119674686383",
    	["arrow-to-down-right-broken"] = "rbxassetid://136700187853605",
    	["arrow-to-down-right-line-duotone"] = "rbxassetid://127846063807744",
    	["arrow-to-down-right-linear"] = "rbxassetid://92514111016122",
    	["arrow-to-down-right-outline"] = "rbxassetid://97253831188978",
    	["arrow-to-top-left-bold"] = "rbxassetid://109577653463461",
    	["arrow-to-top-left-bold-duotone"] = "rbxassetid://106040549937989",
    	["arrow-to-top-left-broken"] = "rbxassetid://99052863732540",
    	["arrow-to-top-left-line-duotone"] = "rbxassetid://132387748659125",
    	["arrow-to-top-left-linear"] = "rbxassetid://136417017766166",
    	["arrow-to-top-left-outline"] = "rbxassetid://109517025806770",
    	["arrow-to-top-right-bold"] = "rbxassetid://90221999473344",
    	["arrow-to-top-right-bold-duotone"] = "rbxassetid://109608206110963",
    	["arrow-to-top-right-broken"] = "rbxassetid://139967575397450",
    	["arrow-to-top-right-line-duotone"] = "rbxassetid://134995271875052",
    	["arrow-to-top-right-linear"] = "rbxassetid://101494667438775",
    	["arrow-to-top-right-outline"] = "rbxassetid://90890976997351",
    	["arrow-up-bold"] = "rbxassetid://137791757637907",
    	["arrow-up-bold-duotone"] = "rbxassetid://97358884307688",
    	["arrow-up-broken"] = "rbxassetid://138747026212608",
    	["arrow-up-line-duotone"] = "rbxassetid://81714470656666",
    	["arrow-up-linear"] = "rbxassetid://112410968221209",
    	["arrow-up-outline"] = "rbxassetid://78193985056604",
    	["asteroid-bold"] = "rbxassetid://75161033390887",
    	["asteroid-bold-duotone"] = "rbxassetid://104556164793792",
    	["asteroid-broken"] = "rbxassetid://134099850826210",
    	["asteroid-line-duotone"] = "rbxassetid://135113063931768",
    	["asteroid-linear"] = "rbxassetid://109174432061976",
    	["asteroid-outline"] = "rbxassetid://94310554638688",
    	["atom-bold"] = "rbxassetid://92952105276942",
    	["atom-bold-duotone"] = "rbxassetid://83564958719017",
    	["atom-broken"] = "rbxassetid://80472529649975",
    	["atom-line-duotone"] = "rbxassetid://110783287273667",
    	["atom-linear"] = "rbxassetid://135098576704487",
    	["atom-outline"] = "rbxassetid://78928958190575",
    	["augmented-reality-bold"] = "rbxassetid://83574041700058",
    	["augmented-reality-bold-duotone"] = "rbxassetid://99144573673763",
    	["augmented-reality-broken"] = "rbxassetid://113131360731987",
    	["augmented-reality-line-duotone"] = "rbxassetid://126235558643122",
    	["augmented-reality-linear"] = "rbxassetid://77025931663878",
    	["augmented-reality-outline"] = "rbxassetid://70939878426487",
    	["backpack-bold"] = "rbxassetid://127779415041047",
    	["backpack-bold-duotone"] = "rbxassetid://137870848739457",
    	["backpack-broken"] = "rbxassetid://73468412080363",
    	["backpack-line-duotone"] = "rbxassetid://108968187652435",
    	["backpack-linear"] = "rbxassetid://130279204765098",
    	["backpack-outline"] = "rbxassetid://91118646524226",
    	["backspace-bold"] = "rbxassetid://137524521645806",
    	["backspace-bold-duotone"] = "rbxassetid://89598956303495",
    	["backspace-broken"] = "rbxassetid://115011492734506",
    	["backspace-line-duotone"] = "rbxassetid://135131295831194",
    	["backspace-linear"] = "rbxassetid://94604268497069",
    	["backspace-outline"] = "rbxassetid://79591711559035",
    	["bacteria-bold"] = "rbxassetid://111802270049171",
    	["bacteria-bold-duotone"] = "rbxassetid://94527694776103",
    	["bacteria-broken"] = "rbxassetid://120353435940397",
    	["bacteria-line-duotone"] = "rbxassetid://117514113724434",
    	["bacteria-linear"] = "rbxassetid://124898014456019",
    	["bacteria-outline"] = "rbxassetid://115728511489185",
    	["bag-2-bold"] = "rbxassetid://134283957232104",
    	["bag-2-bold-duotone"] = "rbxassetid://89273347214646",
    	["bag-2-broken"] = "rbxassetid://132538910204564",
    	["bag-2-line-duotone"] = "rbxassetid://102646882612430",
    	["bag-2-linear"] = "rbxassetid://105823161613653",
    	["bag-2-outline"] = "rbxassetid://118527609018284",
    	["bag-3-bold"] = "rbxassetid://133056900985022",
    	["bag-3-bold-duotone"] = "rbxassetid://137301522953064",
    	["bag-3-broken"] = "rbxassetid://129642086789863",
    	["bag-3-line-duotone"] = "rbxassetid://121075836244792",
    	["bag-3-linear"] = "rbxassetid://73317349543774",
    	["bag-3-outline"] = "rbxassetid://115947113316642",
    	["bag-4-bold"] = "rbxassetid://99683328329836",
    	["bag-4-bold-duotone"] = "rbxassetid://78618949890503",
    	["bag-4-broken"] = "rbxassetid://77754029984317",
    	["bag-4-line-duotone"] = "rbxassetid://90388883168896",
    	["bag-4-linear"] = "rbxassetid://106721055687943",
    	["bag-4-outline"] = "rbxassetid://96912732449395",
    	["bag-5-bold"] = "rbxassetid://80797096909615",
    	["bag-5-bold-duotone"] = "rbxassetid://125572542903516",
    	["bag-5-broken"] = "rbxassetid://103643007734343",
    	["bag-5-line-duotone"] = "rbxassetid://78198504796278",
    	["bag-5-linear"] = "rbxassetid://75531389806165",
    	["bag-5-outline"] = "rbxassetid://117496279992156",
    	["bag-bold"] = "rbxassetid://81962890075637",
    	["bag-bold-duotone"] = "rbxassetid://83922964128690",
    	["bag-broken"] = "rbxassetid://127515892877036",
    	["bag-check-bold"] = "rbxassetid://71078298136993",
    	["bag-check-bold-duotone"] = "rbxassetid://80012717824733",
    	["bag-check-broken"] = "rbxassetid://127848598744331",
    	["bag-check-line-duotone"] = "rbxassetid://82341372086957",
    	["bag-check-linear"] = "rbxassetid://117379295893119",
    	["bag-check-outline"] = "rbxassetid://109274740945233",
    	["bag-cross-bold"] = "rbxassetid://77291805451487",
    	["bag-cross-bold-duotone"] = "rbxassetid://118580150286767",
    	["bag-cross-broken"] = "rbxassetid://128414637543424",
    	["bag-cross-line-duotone"] = "rbxassetid://98243589662691",
    	["bag-cross-linear"] = "rbxassetid://105671595725356",
    	["bag-cross-outline"] = "rbxassetid://125825069111085",
    	["bag-heart-bold"] = "rbxassetid://125637933423553",
    	["bag-heart-bold-duotone"] = "rbxassetid://79671689049996",
    	["bag-heart-broken"] = "rbxassetid://121014523909743",
    	["bag-heart-line-duotone"] = "rbxassetid://119923857926685",
    	["bag-heart-linear"] = "rbxassetid://140363844445900",
    	["bag-heart-outline"] = "rbxassetid://83802621482469",
    	["bag-line-duotone"] = "rbxassetid://128516972764697",
    	["bag-linear"] = "rbxassetid://101706051496873",
    	["bag-music-2-bold"] = "rbxassetid://99963230743842",
    	["bag-music-2-bold-duotone"] = "rbxassetid://90419480526487",
    	["bag-music-2-broken"] = "rbxassetid://121116995529600",
    	["bag-music-2-line-duotone"] = "rbxassetid://120992920260062",
    	["bag-music-2-linear"] = "rbxassetid://100460888534185",
    	["bag-music-2-outline"] = "rbxassetid://137386044540540",
    	["bag-music-bold"] = "rbxassetid://96382736667853",
    	["bag-music-bold-duotone"] = "rbxassetid://73528272980749",
    	["bag-music-broken"] = "rbxassetid://82870498441075",
    	["bag-music-line-duotone"] = "rbxassetid://106526723338218",
    	["bag-music-linear"] = "rbxassetid://85695444561346",
    	["bag-music-outline"] = "rbxassetid://118041608861581",
    	["bag-outline"] = "rbxassetid://124895255224274",
    	["bag-smile-bold"] = "rbxassetid://109018139365567",
    	["bag-smile-bold-duotone"] = "rbxassetid://100484450748235",
    	["bag-smile-broken"] = "rbxassetid://105475418280401",
    	["bag-smile-line-duotone"] = "rbxassetid://131687283896896",
    	["bag-smile-linear"] = "rbxassetid://137912493516406",
    	["bag-smile-outline"] = "rbxassetid://117547142121093",
    	["balloon-bold"] = "rbxassetid://132517895089288",
    	["balloon-bold-duotone"] = "rbxassetid://87619300414776",
    	["balloon-broken"] = "rbxassetid://85454722882266",
    	["balloon-line-duotone"] = "rbxassetid://90935312077123",
    	["balloon-linear"] = "rbxassetid://79651353233661",
    	["balloon-outline"] = "rbxassetid://74552812005368",
    	["balls-bold"] = "rbxassetid://128007708227558",
    	["balls-bold-duotone"] = "rbxassetid://87960353380713",
    	["balls-broken"] = "rbxassetid://104857664579917",
    	["balls-line-duotone"] = "rbxassetid://81184488334433",
    	["balls-linear"] = "rbxassetid://138019467203881",
    	["balls-outline"] = "rbxassetid://115631063075545",
    	["banknote-2-bold"] = "rbxassetid://133956687343423",
    	["banknote-2-bold-duotone"] = "rbxassetid://125014433548317",
    	["banknote-2-broken"] = "rbxassetid://96610943905055",
    	["banknote-2-line-duotone"] = "rbxassetid://88013162690406",
    	["banknote-2-linear"] = "rbxassetid://134857627939186",
    	["banknote-2-outline"] = "rbxassetid://82506341499186",
    	["banknote-bold"] = "rbxassetid://96952241297285",
    	["banknote-bold-duotone"] = "rbxassetid://90757798901459",
    	["banknote-broken"] = "rbxassetid://78924364867154",
    	["banknote-line-duotone"] = "rbxassetid://116392071827379",
    	["banknote-linear"] = "rbxassetid://132834487038453",
    	["banknote-outline"] = "rbxassetid://110488309769290",
    	["bar-chair-bold"] = "rbxassetid://76250742715772",
    	["bar-chair-bold-duotone"] = "rbxassetid://135166438553310",
    	["bar-chair-broken"] = "rbxassetid://123972911804789",
    	["bar-chair-line-duotone"] = "rbxassetid://95746700071489",
    	["bar-chair-linear"] = "rbxassetid://118745125681159",
    	["bar-chair-outline"] = "rbxassetid://86658681139719",
    	["basketball-bold"] = "rbxassetid://94041625460179",
    	["basketball-bold-duotone"] = "rbxassetid://136745090680448",
    	["basketball-broken"] = "rbxassetid://106582690371028",
    	["basketball-line-duotone"] = "rbxassetid://84143711892810",
    	["basketball-linear"] = "rbxassetid://71989319930025",
    	["basketball-outline"] = "rbxassetid://93562807036777",
    	["bath-bold"] = "rbxassetid://102699788783597",
    	["bath-bold-duotone"] = "rbxassetid://101205763281037",
    	["bath-broken"] = "rbxassetid://136898014650324",
    	["bath-line-duotone"] = "rbxassetid://97020172460235",
    	["bath-linear"] = "rbxassetid://128956278534175",
    	["bath-outline"] = "rbxassetid://98692987261507",
    	["battery-charge-bold"] = "rbxassetid://100475543714865",
    	["battery-charge-bold-duotone"] = "rbxassetid://73616965648032",
    	["battery-charge-broken"] = "rbxassetid://118326935886205",
    	["battery-charge-line-duotone"] = "rbxassetid://140268716755703",
    	["battery-charge-linear"] = "rbxassetid://70510223968140",
    	["battery-charge-minimalistic-bold"] = "rbxassetid://74262418671062",
    	["battery-charge-minimalistic-bold-duotone"] = "rbxassetid://112793928283776",
    	["battery-charge-minimalistic-broken"] = "rbxassetid://125348004354783",
    	["battery-charge-minimalistic-line-duotone"] = "rbxassetid://139495862860304",
    	["battery-charge-minimalistic-linear"] = "rbxassetid://140189174642589",
    	["battery-charge-minimalistic-outline"] = "rbxassetid://117933891618281",
    	["battery-charge-outline"] = "rbxassetid://70752713311104",
    	["battery-full-bold"] = "rbxassetid://133703018655079",
    	["battery-full-bold-duotone"] = "rbxassetid://120892847698130",
    	["battery-full-broken"] = "rbxassetid://88470968352621",
    	["battery-full-line-duotone"] = "rbxassetid://94394984362282",
    	["battery-full-linear"] = "rbxassetid://107891957032365",
    	["battery-full-minimalistic-bold"] = "rbxassetid://138913001687451",
    	["battery-full-minimalistic-bold-duotone"] = "rbxassetid://106409637920548",
    	["battery-full-minimalistic-broken"] = "rbxassetid://102398634701801",
    	["battery-full-minimalistic-line-duotone"] = "rbxassetid://120266021818837",
    	["battery-full-minimalistic-linear"] = "rbxassetid://114619966373761",
    	["battery-full-minimalistic-outline"] = "rbxassetid://112072092740988",
    	["battery-full-outline"] = "rbxassetid://137583317597388",
    	["battery-half-bold"] = "rbxassetid://126213872489127",
    	["battery-half-bold-duotone"] = "rbxassetid://94874022986875",
    	["battery-half-broken"] = "rbxassetid://85055852292725",
    	["battery-half-line-duotone"] = "rbxassetid://95853223301982",
    	["battery-half-linear"] = "rbxassetid://81822938661761",
    	["battery-half-minimalistic-bold"] = "rbxassetid://126835244306746",
    	["battery-half-minimalistic-bold-duotone"] = "rbxassetid://117009541928430",
    	["battery-half-minimalistic-broken"] = "rbxassetid://100651366100863",
    	["battery-half-minimalistic-line-duotone"] = "rbxassetid://87346814822516",
    	["battery-half-minimalistic-linear"] = "rbxassetid://113701405885151",
    	["battery-half-minimalistic-outline"] = "rbxassetid://84945659520479",
    	["battery-half-outline"] = "rbxassetid://129029174739446",
    	["battery-low-bold"] = "rbxassetid://122579327992440",
    	["battery-low-bold-duotone"] = "rbxassetid://89782023720808",
    	["battery-low-broken"] = "rbxassetid://97330184295154",
    	["battery-low-line-duotone"] = "rbxassetid://134088588031718",
    	["battery-low-linear"] = "rbxassetid://112262699665664",
    	["battery-low-minimalistic-bold"] = "rbxassetid://91812294716743",
    	["battery-low-minimalistic-bold-duotone"] = "rbxassetid://98150805366984",
    	["battery-low-minimalistic-broken"] = "rbxassetid://88992242326964",
    	["battery-low-minimalistic-line-duotone"] = "rbxassetid://124797931689039",
    	["battery-low-minimalistic-linear"] = "rbxassetid://139819726459629",
    	["battery-low-minimalistic-outline"] = "rbxassetid://130110914026521",
    	["battery-low-outline"] = "rbxassetid://92386841665155",
    	["bed-bold"] = "rbxassetid://85039430100012",
    	["bed-bold-duotone"] = "rbxassetid://137605656341329",
    	["bed-broken"] = "rbxassetid://91581009266126",
    	["bed-line-duotone"] = "rbxassetid://123628349050799",
    	["bed-linear"] = "rbxassetid://117974109799034",
    	["bed-outline"] = "rbxassetid://80682447720261",
    	["bedside-table-2-bold"] = "rbxassetid://127357060463539",
    	["bedside-table-2-bold-duotone"] = "rbxassetid://98812825868546",
    	["bedside-table-2-broken"] = "rbxassetid://109237789733416",
    	["bedside-table-2-line-duotone"] = "rbxassetid://83510921252329",
    	["bedside-table-2-linear"] = "rbxassetid://117408918449637",
    	["bedside-table-2-outline"] = "rbxassetid://94656900046476",
    	["bedside-table-3-bold"] = "rbxassetid://126668983712393",
    	["bedside-table-3-bold-duotone"] = "rbxassetid://97522381170648",
    	["bedside-table-3-broken"] = "rbxassetid://89694002042408",
    	["bedside-table-3-line-duotone"] = "rbxassetid://121142688240411",
    	["bedside-table-3-linear"] = "rbxassetid://104548877817634",
    	["bedside-table-3-outline"] = "rbxassetid://128667169708904",
    	["bedside-table-4-bold"] = "rbxassetid://94361782916680",
    	["bedside-table-4-bold-duotone"] = "rbxassetid://122049772793266",
    	["bedside-table-4-broken"] = "rbxassetid://82542384843358",
    	["bedside-table-4-line-duotone"] = "rbxassetid://95647255833365",
    	["bedside-table-4-linear"] = "rbxassetid://79942275317314",
    	["bedside-table-4-outline"] = "rbxassetid://117385173502779",
    	["bedside-table-bold"] = "rbxassetid://127339575908485",
    	["bedside-table-bold-duotone"] = "rbxassetid://93446590227474",
    	["bedside-table-broken"] = "rbxassetid://97050029456663",
    	["bedside-table-line-duotone"] = "rbxassetid://114301249356245",
    	["bedside-table-linear"] = "rbxassetid://104385910638217",
    	["bedside-table-outline"] = "rbxassetid://105814146261392",
    	["bell-bing-bold"] = "rbxassetid://90010061712906",
    	["bell-bing-bold-duotone"] = "rbxassetid://124457946480746",
    	["bell-bing-broken"] = "rbxassetid://139336202558021",
    	["bell-bing-line-duotone"] = "rbxassetid://72208643189558",
    	["bell-bing-linear"] = "rbxassetid://79040173024462",
    	["bell-bing-outline"] = "rbxassetid://126869323392855",
    	["bell-bold"] = "rbxassetid://117594985029884",
    	["bell-bold-duotone"] = "rbxassetid://132709815539553",
    	["bell-broken"] = "rbxassetid://85753435911563",
    	["bell-line-duotone"] = "rbxassetid://81124596224155",
    	["bell-linear"] = "rbxassetid://92764160980131",
    	["bell-off-bold"] = "rbxassetid://128085899497128",
    	["bell-off-bold-duotone"] = "rbxassetid://90970953255998",
    	["bell-off-broken"] = "rbxassetid://121944548564126",
    	["bell-off-line-duotone"] = "rbxassetid://96244735722818",
    	["bell-off-linear"] = "rbxassetid://81039428111943",
    	["bell-off-outline"] = "rbxassetid://89131799945351",
    	["bell-outline"] = "rbxassetid://81679114644003",
    	["benzene-ring-bold"] = "rbxassetid://117176915495847",
    	["benzene-ring-bold-duotone"] = "rbxassetid://105068935202557",
    	["benzene-ring-broken"] = "rbxassetid://77341335076288",
    	["benzene-ring-line-duotone"] = "rbxassetid://119274434353891",
    	["benzene-ring-linear"] = "rbxassetid://73244621085408",
    	["benzene-ring-outline"] = "rbxassetid://135108378010626",
    	["bicycling-bold"] = "rbxassetid://133428474201868",
    	["bicycling-bold-duotone"] = "rbxassetid://116844104731226",
    	["bicycling-broken"] = "rbxassetid://103186204480781",
    	["bicycling-line-duotone"] = "rbxassetid://80683987697422",
    	["bicycling-linear"] = "rbxassetid://91810175350093",
    	["bicycling-outline"] = "rbxassetid://72896327530519",
    	["bicycling-round-bold"] = "rbxassetid://121968658208119",
    	["bicycling-round-bold-duotone"] = "rbxassetid://104222384537086",
    	["bicycling-round-broken"] = "rbxassetid://77990627242416",
    	["bicycling-round-line-duotone"] = "rbxassetid://81383915195698",
    	["bicycling-round-linear"] = "rbxassetid://111307216758641",
    	["bicycling-round-outline"] = "rbxassetid://134614605846803",
    	["bill-bold"] = "rbxassetid://79076541631110",
    	["bill-bold-1"] = "rbxassetid://101169583402465",
    	["bill-bold-duotone"] = "rbxassetid://79593138586529",
    	["bill-bold-duotone-1"] = "rbxassetid://135132618806756",
    	["bill-broken"] = "rbxassetid://137666521390770",
    	["bill-broken-1"] = "rbxassetid://106564315915411",
    	["bill-check-bold"] = "rbxassetid://81102381230426",
    	["bill-check-bold-duotone"] = "rbxassetid://114305556316490",
    	["bill-check-broken"] = "rbxassetid://105679315783541",
    	["bill-check-line-duotone"] = "rbxassetid://117945996837111",
    	["bill-check-linear"] = "rbxassetid://88448497113578",
    	["bill-check-outline"] = "rbxassetid://110861126200312",
    	["bill-cross-bold"] = "rbxassetid://103021661260960",
    	["bill-cross-bold-duotone"] = "rbxassetid://97292427213953",
    	["bill-cross-broken"] = "rbxassetid://93533769386954",
    	["bill-cross-line-duotone"] = "rbxassetid://101012975749971",
    	["bill-cross-linear"] = "rbxassetid://93050054452154",
    	["bill-cross-outline"] = "rbxassetid://103026687987051",
    	["bill-line-duotone"] = "rbxassetid://122884925854503",
    	["bill-line-duotone-1"] = "rbxassetid://106632553985664",
    	["bill-linear"] = "rbxassetid://131577041668337",
    	["bill-linear-1"] = "rbxassetid://140540263436220",
    	["bill-list-bold"] = "rbxassetid://109843453218379",
    	["bill-list-bold-duotone"] = "rbxassetid://105170601442117",
    	["bill-list-broken"] = "rbxassetid://91522580248905",
    	["bill-list-line-duotone"] = "rbxassetid://90158793180387",
    	["bill-list-linear"] = "rbxassetid://136244645560765",
    	["bill-list-outline"] = "rbxassetid://116439919076572",
    	["bill-outline"] = "rbxassetid://138168395912254",
    	["bill-outline-1"] = "rbxassetid://138963527965706",
    	["black-hole-2-bold"] = "rbxassetid://140195028508640",
    	["black-hole-2-bold-duotone"] = "rbxassetid://97665167842627",
    	["black-hole-2-broken"] = "rbxassetid://135690631562349",
    	["black-hole-2-line-duotone"] = "rbxassetid://105842421072985",
    	["black-hole-2-linear"] = "rbxassetid://109506547750135",
    	["black-hole-2-outline"] = "rbxassetid://75800391067194",
    	["black-hole-3-bold"] = "rbxassetid://132428630870964",
    	["black-hole-3-bold-duotone"] = "rbxassetid://75800512206564",
    	["black-hole-3-broken"] = "rbxassetid://110458259993073",
    	["black-hole-3-line-duotone"] = "rbxassetid://106069284028662",
    	["black-hole-3-linear"] = "rbxassetid://129769023623419",
    	["black-hole-3-outline"] = "rbxassetid://105415767167004",
    	["black-hole-bold"] = "rbxassetid://133351596269875",
    	["black-hole-bold-duotone"] = "rbxassetid://80256500232753",
    	["black-hole-broken"] = "rbxassetid://89069664432516",
    	["black-hole-line-duotone"] = "rbxassetid://71148365491903",
    	["black-hole-linear"] = "rbxassetid://121162417676813",
    	["black-hole-outline"] = "rbxassetid://90800675290437",
    	["bluetooth-bold"] = "rbxassetid://103766614486088",
    	["bluetooth-bold-duotone"] = "rbxassetid://104412312465703",
    	["bluetooth-broken"] = "rbxassetid://112417348676906",
    	["bluetooth-circle-bold"] = "rbxassetid://125016688396454",
    	["bluetooth-circle-bold-duotone"] = "rbxassetid://121428691968536",
    	["bluetooth-circle-broken"] = "rbxassetid://116660640197146",
    	["bluetooth-circle-line-duotone"] = "rbxassetid://91909885283301",
    	["bluetooth-circle-linear"] = "rbxassetid://133364241845343",
    	["bluetooth-circle-outline"] = "rbxassetid://103025598915180",
    	["bluetooth-line-duotone"] = "rbxassetid://122563991123326",
    	["bluetooth-linear"] = "rbxassetid://111638261148116",
    	["bluetooth-outline"] = "rbxassetid://78308564324514",
    	["bluetooth-square-bold"] = "rbxassetid://101941261809797",
    	["bluetooth-square-bold-duotone"] = "rbxassetid://132927800437606",
    	["bluetooth-square-broken"] = "rbxassetid://128966868275371",
    	["bluetooth-square-line-duotone"] = "rbxassetid://79925113696449",
    	["bluetooth-square-linear"] = "rbxassetid://75358408080709",
    	["bluetooth-square-outline"] = "rbxassetid://89912966131895",
    	["bluetooth-wave-bold"] = "rbxassetid://110539809989493",
    	["bluetooth-wave-bold-duotone"] = "rbxassetid://83025480460939",
    	["bluetooth-wave-broken"] = "rbxassetid://120861853414730",
    	["bluetooth-wave-line-duotone"] = "rbxassetid://70519922730791",
    	["bluetooth-wave-linear"] = "rbxassetid://123374106928696",
    	["bluetooth-wave-outline"] = "rbxassetid://103617821008197",
    	["body-bold"] = "rbxassetid://80297758353971",
    	["body-bold-duotone"] = "rbxassetid://140274929427540",
    	["body-broken"] = "rbxassetid://82728680216916",
    	["body-line-duotone"] = "rbxassetid://132202992100588",
    	["body-linear"] = "rbxassetid://131908717410288",
    	["body-outline"] = "rbxassetid://93732323090352",
    	["body-shape-bold"] = "rbxassetid://138870821023962",
    	["body-shape-bold-duotone"] = "rbxassetid://80832839364864",
    	["body-shape-broken"] = "rbxassetid://127784409587596",
    	["body-shape-line-duotone"] = "rbxassetid://89542123993295",
    	["body-shape-linear"] = "rbxassetid://109130863566169",
    	["body-shape-minimalistic-bold"] = "rbxassetid://111590870437298",
    	["body-shape-minimalistic-bold-duotone"] = "rbxassetid://84625173002872",
    	["body-shape-minimalistic-broken"] = "rbxassetid://98972950829208",
    	["body-shape-minimalistic-line-duotone"] = "rbxassetid://93448786155020",
    	["body-shape-minimalistic-linear"] = "rbxassetid://131638187687719",
    	["body-shape-minimalistic-outline"] = "rbxassetid://135868791732590",
    	["body-shape-outline"] = "rbxassetid://130090514515264",
    	["bolt-bold"] = "rbxassetid://130006650864115",
    	["bolt-bold-duotone"] = "rbxassetid://112773609207487",
    	["bolt-broken"] = "rbxassetid://133777606155506",
    	["bolt-circle-bold"] = "rbxassetid://111887894232172",
    	["bolt-circle-bold-duotone"] = "rbxassetid://71936899267190",
    	["bolt-circle-broken"] = "rbxassetid://78531213054971",
    	["bolt-circle-line-duotone"] = "rbxassetid://117443467508477",
    	["bolt-circle-linear"] = "rbxassetid://134044476273117",
    	["bolt-circle-outline"] = "rbxassetid://104346103879078",
    	["bolt-line-duotone"] = "rbxassetid://85268714461139",
    	["bolt-linear"] = "rbxassetid://129263101178298",
    	["bolt-outline"] = "rbxassetid://107721266403604",
    	["bomb-bold"] = "rbxassetid://86345767436552",
    	["bomb-bold-duotone"] = "rbxassetid://80932587535052",
    	["bomb-broken"] = "rbxassetid://132971809516633",
    	["bomb-emoji-bold"] = "rbxassetid://96091532250136",
    	["bomb-emoji-bold-duotone"] = "rbxassetid://110902611787576",
    	["bomb-emoji-broken"] = "rbxassetid://119558943662306",
    	["bomb-emoji-line-duotone"] = "rbxassetid://101997033219299",
    	["bomb-emoji-linear"] = "rbxassetid://103473657902877",
    	["bomb-emoji-outline"] = "rbxassetid://108957880856004",
    	["bomb-line-duotone"] = "rbxassetid://125578749862015",
    	["bomb-linear"] = "rbxassetid://128621601192663",
    	["bomb-minimalistic-bold"] = "rbxassetid://93289292369709",
    	["bomb-minimalistic-bold-duotone"] = "rbxassetid://110808562421605",
    	["bomb-minimalistic-broken"] = "rbxassetid://133730538982738",
    	["bomb-minimalistic-line-duotone"] = "rbxassetid://133171029213292",
    	["bomb-minimalistic-linear"] = "rbxassetid://135333613767179",
    	["bomb-minimalistic-outline"] = "rbxassetid://108326863712989",
    	["bomb-outline"] = "rbxassetid://103270696032879",
    	["bone-bold"] = "rbxassetid://92810326208125",
    	["bone-bold-duotone"] = "rbxassetid://139241856877226",
    	["bone-broken"] = "rbxassetid://120480750583100",
    	["bone-broken-bold"] = "rbxassetid://129868656651421",
    	["bone-broken-bold-duotone"] = "rbxassetid://98301298527662",
    	["bone-broken-broken"] = "rbxassetid://103343052602583",
    	["bone-broken-line-duotone"] = "rbxassetid://106773336809029",
    	["bone-broken-linear"] = "rbxassetid://129670887571621",
    	["bone-broken-outline"] = "rbxassetid://113045314908706",
    	["bone-crack-bold"] = "rbxassetid://103639382721615",
    	["bone-crack-bold-duotone"] = "rbxassetid://93826507589491",
    	["bone-crack-broken"] = "rbxassetid://129106123437805",
    	["bone-crack-line-duotone"] = "rbxassetid://106678121887053",
    	["bone-crack-linear"] = "rbxassetid://117912934196693",
    	["bone-crack-outline"] = "rbxassetid://105994627989224",
    	["bone-line-duotone"] = "rbxassetid://136066203387837",
    	["bone-linear"] = "rbxassetid://135319165893364",
    	["bone-outline"] = "rbxassetid://122617215991009",
    	["bones-bold"] = "rbxassetid://89953822100418",
    	["bones-bold-duotone"] = "rbxassetid://70495849534195",
    	["bones-broken"] = "rbxassetid://127806651608447",
    	["bones-line-duotone"] = "rbxassetid://99540965230248",
    	["bones-linear"] = "rbxassetid://92243799426617",
    	["bones-outline"] = "rbxassetid://133604225785206",
    	["bonfire-bold"] = "rbxassetid://93575834873850",
    	["bonfire-bold-duotone"] = "rbxassetid://76707510980727",
    	["bonfire-broken"] = "rbxassetid://133248426054626",
    	["bonfire-line-duotone"] = "rbxassetid://126476547385742",
    	["bonfire-linear"] = "rbxassetid://84430047519955",
    	["bonfire-outline"] = "rbxassetid://106358299802964",
    	["book-2-bold"] = "rbxassetid://140202546444576",
    	["book-2-bold-duotone"] = "rbxassetid://76545958374646",
    	["book-2-broken"] = "rbxassetid://124313313131321",
    	["book-2-line-duotone"] = "rbxassetid://74272149649579",
    	["book-2-linear"] = "rbxassetid://85907609674681",
    	["book-2-outline"] = "rbxassetid://118488457915277",
    	["book-bold"] = "rbxassetid://100641675079195",
    	["book-bold-duotone"] = "rbxassetid://81446287370129",
    	["book-bookmark-bold"] = "rbxassetid://130784090293380",
    	["book-bookmark-bold-duotone"] = "rbxassetid://99695427522663",
    	["book-bookmark-broken"] = "rbxassetid://131800398716621",
    	["book-bookmark-line-duotone"] = "rbxassetid://125247295978102",
    	["book-bookmark-linear"] = "rbxassetid://80336946503616",
    	["book-bookmark-minimalistic-bold"] = "rbxassetid://134583418904074",
    	["book-bookmark-minimalistic-bold-duotone"] = "rbxassetid://81806514195195",
    	["book-bookmark-minimalistic-broken"] = "rbxassetid://103550312316916",
    	["book-bookmark-minimalistic-line-duotone"] = "rbxassetid://74572363907218",
    	["book-bookmark-minimalistic-linear"] = "rbxassetid://127016317926289",
    	["book-bookmark-minimalistic-outline"] = "rbxassetid://102952993198024",
    	["book-bookmark-outline"] = "rbxassetid://83033403440861",
    	["book-broken"] = "rbxassetid://133331080367686",
    	["book-line-duotone"] = "rbxassetid://114125414960712",
    	["book-linear"] = "rbxassetid://82601637739895",
    	["book-minimalistic-bold"] = "rbxassetid://105656509929709",
    	["book-minimalistic-bold-duotone"] = "rbxassetid://85396139708832",
    	["book-minimalistic-broken"] = "rbxassetid://108294831370745",
    	["book-minimalistic-line-duotone"] = "rbxassetid://98250147725247",
    	["book-minimalistic-linear"] = "rbxassetid://71210415759786",
    	["book-minimalistic-outline"] = "rbxassetid://118424475672432",
    	["book-outline"] = "rbxassetid://104314478209209",
    	["bookmark-bold"] = "rbxassetid://119882071213128",
    	["bookmark-bold-duotone"] = "rbxassetid://79029964182553",
    	["bookmark-broken"] = "rbxassetid://116060044085855",
    	["bookmark-circle-bold"] = "rbxassetid://108669469214788",
    	["bookmark-circle-bold-duotone"] = "rbxassetid://109888344004263",
    	["bookmark-circle-broken"] = "rbxassetid://85801419819014",
    	["bookmark-circle-line-duotone"] = "rbxassetid://130686254771739",
    	["bookmark-circle-linear"] = "rbxassetid://112724781815490",
    	["bookmark-circle-outline"] = "rbxassetid://90569973120340",
    	["bookmark-line-duotone"] = "rbxassetid://93875452096028",
    	["bookmark-linear"] = "rbxassetid://83718779207220",
    	["bookmark-opened-bold"] = "rbxassetid://119932665743988",
    	["bookmark-opened-bold-duotone"] = "rbxassetid://135883814815115",
    	["bookmark-opened-broken"] = "rbxassetid://133166031566394",
    	["bookmark-opened-line-duotone"] = "rbxassetid://129036912021958",
    	["bookmark-opened-linear"] = "rbxassetid://117303462446669",
    	["bookmark-opened-outline"] = "rbxassetid://96733904904698",
    	["bookmark-outline"] = "rbxassetid://110543288975279",
    	["bookmark-square-bold"] = "rbxassetid://129536097403292",
    	["bookmark-square-bold-duotone"] = "rbxassetid://82143899570121",
    	["bookmark-square-broken"] = "rbxassetid://71872943150145",
    	["bookmark-square-line-duotone"] = "rbxassetid://99198103176737",
    	["bookmark-square-linear"] = "rbxassetid://109580948010535",
    	["bookmark-square-minimalistic-bold"] = "rbxassetid://77336520808134",
    	["bookmark-square-minimalistic-bold-duotone"] = "rbxassetid://98690609013767",
    	["bookmark-square-minimalistic-broken"] = "rbxassetid://122865342900844",
    	["bookmark-square-minimalistic-line-duotone"] = "rbxassetid://114739816244605",
    	["bookmark-square-minimalistic-linear"] = "rbxassetid://127828568965246",
    	["bookmark-square-minimalistic-outline"] = "rbxassetid://100067721610855",
    	["bookmark-square-outline"] = "rbxassetid://79642694375235",
    	["boombox-bold"] = "rbxassetid://123719435207308",
    	["boombox-bold-duotone"] = "rbxassetid://123682137389507",
    	["boombox-broken"] = "rbxassetid://82657745265325",
    	["boombox-line-duotone"] = "rbxassetid://100052268989168",
    	["boombox-linear"] = "rbxassetid://94738449999083",
    	["boombox-outline"] = "rbxassetid://80846085527146",
    	["bottle-bold"] = "rbxassetid://118436758949093",
    	["bottle-bold-duotone"] = "rbxassetid://79092852169290",
    	["bottle-broken"] = "rbxassetid://100211989981473",
    	["bottle-line-duotone"] = "rbxassetid://72595845327011",
    	["bottle-linear"] = "rbxassetid://107412078245942",
    	["bottle-outline"] = "rbxassetid://91697775741834",
    	["bowling-bold"] = "rbxassetid://80900773762567",
    	["bowling-bold-duotone"] = "rbxassetid://134030425270371",
    	["bowling-broken"] = "rbxassetid://74668201626157",
    	["bowling-line-duotone"] = "rbxassetid://95330826166062",
    	["bowling-linear"] = "rbxassetid://95664229282491",
    	["bowling-outline"] = "rbxassetid://127048947738925",
    	["box-bold"] = "rbxassetid://129773998837019",
    	["box-bold-duotone"] = "rbxassetid://119619582427487",
    	["box-broken"] = "rbxassetid://101780647157250",
    	["box-line-duotone"] = "rbxassetid://140660359825129",
    	["box-linear"] = "rbxassetid://94031163680437",
    	["box-minimalistic-bold"] = "rbxassetid://84411265569462",
    	["box-minimalistic-bold-duotone"] = "rbxassetid://121278199501784",
    	["box-minimalistic-broken"] = "rbxassetid://78116032388317",
    	["box-minimalistic-line-duotone"] = "rbxassetid://120589870945111",
    	["box-minimalistic-linear"] = "rbxassetid://120471991203058",
    	["box-minimalistic-outline"] = "rbxassetid://114317047455061",
    	["box-outline"] = "rbxassetid://112837143947035",
    	["branching-paths-down-bold"] = "rbxassetid://130172472185466",
    	["branching-paths-down-bold-duotone"] = "rbxassetid://74640258090714",
    	["branching-paths-down-broken"] = "rbxassetid://133554330181806",
    	["branching-paths-down-line-duotone"] = "rbxassetid://128191481853616",
    	["branching-paths-down-linear"] = "rbxassetid://119013780010068",
    	["branching-paths-down-outline"] = "rbxassetid://138656587420690",
    	["branching-paths-up-bold"] = "rbxassetid://73936780747200",
    	["branching-paths-up-bold-duotone"] = "rbxassetid://133309860134948",
    	["branching-paths-up-broken"] = "rbxassetid://83970582278083",
    	["branching-paths-up-line-duotone"] = "rbxassetid://120135966539174",
    	["branching-paths-up-linear"] = "rbxassetid://115080801807455",
    	["branching-paths-up-outline"] = "rbxassetid://84698267332612",
    	["broom-bold"] = "rbxassetid://117933907616580",
    	["broom-bold-duotone"] = "rbxassetid://95102969843995",
    	["broom-broken"] = "rbxassetid://77073757161288",
    	["broom-line-duotone"] = "rbxassetid://124002763678815",
    	["broom-linear"] = "rbxassetid://138264998339831",
    	["broom-outline"] = "rbxassetid://128119115521532",
    	["bug-bold"] = "rbxassetid://72884019555988",
    	["bug-bold-duotone"] = "rbxassetid://73648503212273",
    	["bug-broken"] = "rbxassetid://129027141790448",
    	["bug-line-duotone"] = "rbxassetid://104416746580282",
    	["bug-linear"] = "rbxassetid://71092918964995",
    	["bug-minimalistic-bold"] = "rbxassetid://127907192871672",
    	["bug-minimalistic-bold-duotone"] = "rbxassetid://78741227187558",
    	["bug-minimalistic-broken"] = "rbxassetid://102566369979702",
    	["bug-minimalistic-line-duotone"] = "rbxassetid://93290655536147",
    	["bug-minimalistic-linear"] = "rbxassetid://140694835122634",
    	["bug-minimalistic-outline"] = "rbxassetid://109840278367331",
    	["bug-outline"] = "rbxassetid://112060949229327",
    	["buildings-2-bold"] = "rbxassetid://130421388375753",
    	["buildings-2-linear"] = "rbxassetid://77604059092291",
    	["buildings-3-bold"] = "rbxassetid://121075963539750",
    	["buildings-3-linear"] = "rbxassetid://78965520003431",
    	["buildings-bold"] = "rbxassetid://131037806195936",
    	["buildings-linear"] = "rbxassetid://133534271714013",
    	["bus-bold"] = "rbxassetid://127617406469560",
    	["bus-linear"] = "rbxassetid://118719456615452",
    	["calculator-bold"] = "rbxassetid://71842919641164",
    	["calculator-bold-duotone"] = "rbxassetid://112426423396596",
    	["calculator-broken"] = "rbxassetid://109687598824837",
    	["calculator-line-duotone"] = "rbxassetid://101798766078824",
    	["calculator-linear"] = "rbxassetid://112506649133300",
    	["calculator-minimalistic-bold"] = "rbxassetid://86763125044493",
    	["calculator-minimalistic-bold-duotone"] = "rbxassetid://103814471284475",
    	["calculator-minimalistic-broken"] = "rbxassetid://100592385432668",
    	["calculator-minimalistic-line-duotone"] = "rbxassetid://85172185773481",
    	["calculator-minimalistic-linear"] = "rbxassetid://103294852910732",
    	["calculator-minimalistic-outline"] = "rbxassetid://89539618854601",
    	["calculator-outline"] = "rbxassetid://73643450951295",
    	["calendar-add-bold"] = "rbxassetid://110893315233879",
    	["calendar-add-bold-duotone"] = "rbxassetid://137687420553112",
    	["calendar-add-broken"] = "rbxassetid://126618338831949",
    	["calendar-add-line-duotone"] = "rbxassetid://101480469033313",
    	["calendar-add-linear"] = "rbxassetid://131450125643911",
    	["calendar-add-outline"] = "rbxassetid://84489412619719",
    	["calendar-bold"] = "rbxassetid://72861377194791",
    	["calendar-bold-duotone"] = "rbxassetid://97347815322197",
    	["calendar-broken"] = "rbxassetid://82384312143536",
    	["calendar-date-bold"] = "rbxassetid://84762294531338",
    	["calendar-date-bold-duotone"] = "rbxassetid://123619742744124",
    	["calendar-date-broken"] = "rbxassetid://76872953603623",
    	["calendar-date-line-duotone"] = "rbxassetid://124526132286899",
    	["calendar-date-linear"] = "rbxassetid://121748890951629",
    	["calendar-date-outline"] = "rbxassetid://89890748049052",
    	["calendar-line-duotone"] = "rbxassetid://81969451487553",
    	["calendar-linear"] = "rbxassetid://77180450432888",
    	["calendar-mark-bold"] = "rbxassetid://111403507857580",
    	["calendar-mark-bold-duotone"] = "rbxassetid://83905887112075",
    	["calendar-mark-broken"] = "rbxassetid://118515563734155",
    	["calendar-mark-line-duotone"] = "rbxassetid://72320016893488",
    	["calendar-mark-linear"] = "rbxassetid://71819781128185",
    	["calendar-mark-outline"] = "rbxassetid://84102158798241",
    	["calendar-minimalistic-bold"] = "rbxassetid://93155514732975",
    	["calendar-minimalistic-bold-duotone"] = "rbxassetid://88772090912867",
    	["calendar-minimalistic-broken"] = "rbxassetid://79544734634533",
    	["calendar-minimalistic-line-duotone"] = "rbxassetid://109776548622926",
    	["calendar-minimalistic-linear"] = "rbxassetid://84957116208284",
    	["calendar-minimalistic-outline"] = "rbxassetid://104519799422677",
    	["calendar-outline"] = "rbxassetid://120788740343953",
    	["calendar-search-bold"] = "rbxassetid://135110980721455",
    	["calendar-search-bold-duotone"] = "rbxassetid://136800049780186",
    	["calendar-search-broken"] = "rbxassetid://122591721017313",
    	["calendar-search-line-duotone"] = "rbxassetid://131638533482407",
    	["calendar-search-linear"] = "rbxassetid://81798804531497",
    	["calendar-search-outline"] = "rbxassetid://131124657608709",
    	["call-cancel-bold"] = "rbxassetid://130401442336024",
    	["call-cancel-bold-duotone"] = "rbxassetid://100392431434618",
    	["call-cancel-broken"] = "rbxassetid://83626511721835",
    	["call-cancel-line-duotone"] = "rbxassetid://131774206325600",
    	["call-cancel-linear"] = "rbxassetid://127541544283155",
    	["call-cancel-outline"] = "rbxassetid://91830658534997",
    	["call-cancel-rounded-bold"] = "rbxassetid://109107939841841",
    	["call-cancel-rounded-bold-duotone"] = "rbxassetid://81199636572984",
    	["call-cancel-rounded-broken"] = "rbxassetid://104829806094905",
    	["call-cancel-rounded-line-duotone"] = "rbxassetid://118521195735687",
    	["call-cancel-rounded-linear"] = "rbxassetid://134114688898640",
    	["call-cancel-rounded-outline"] = "rbxassetid://91571012664861",
    	["call-chat-bold"] = "rbxassetid://94482820796736",
    	["call-chat-bold-duotone"] = "rbxassetid://82008548754070",
    	["call-chat-broken"] = "rbxassetid://72168115907659",
    	["call-chat-line-duotone"] = "rbxassetid://94928989006398",
    	["call-chat-linear"] = "rbxassetid://130881958351607",
    	["call-chat-outline"] = "rbxassetid://79419762634841",
    	["call-chat-rounded-bold"] = "rbxassetid://106552307563170",
    	["call-chat-rounded-bold-duotone"] = "rbxassetid://125023172001032",
    	["call-chat-rounded-broken"] = "rbxassetid://91735261927046",
    	["call-chat-rounded-line-duotone"] = "rbxassetid://113462668515062",
    	["call-chat-rounded-linear"] = "rbxassetid://117899042556347",
    	["call-chat-rounded-outline"] = "rbxassetid://137966987820677",
    	["call-dropped-bold"] = "rbxassetid://84259190108719",
    	["call-dropped-bold-duotone"] = "rbxassetid://89792335926723",
    	["call-dropped-broken"] = "rbxassetid://108446676061721",
    	["call-dropped-line-duotone"] = "rbxassetid://134609605260517",
    	["call-dropped-linear"] = "rbxassetid://103588864603178",
    	["call-dropped-outline"] = "rbxassetid://136925938224114",
    	["call-dropped-rounded-bold"] = "rbxassetid://124693178511966",
    	["call-dropped-rounded-bold-duotone"] = "rbxassetid://131907003095122",
    	["call-dropped-rounded-broken"] = "rbxassetid://87363542821579",
    	["call-dropped-rounded-line-duotone"] = "rbxassetid://76022201425653",
    	["call-dropped-rounded-linear"] = "rbxassetid://95664927749256",
    	["call-dropped-rounded-outline"] = "rbxassetid://83812376127776",
    	["call-medicine-bold"] = "rbxassetid://123709541957602",
    	["call-medicine-bold-duotone"] = "rbxassetid://90773567608309",
    	["call-medicine-broken"] = "rbxassetid://76101372631621",
    	["call-medicine-line-duotone"] = "rbxassetid://93339156979423",
    	["call-medicine-linear"] = "rbxassetid://78928850413523",
    	["call-medicine-outline"] = "rbxassetid://109699566363982",
    	["call-medicine-rounded-bold"] = "rbxassetid://84800694201321",
    	["call-medicine-rounded-bold-duotone"] = "rbxassetid://70875584718768",
    	["call-medicine-rounded-broken"] = "rbxassetid://96227491048464",
    	["call-medicine-rounded-line-duotone"] = "rbxassetid://131544336119233",
    	["call-medicine-rounded-linear"] = "rbxassetid://134384209301792",
    	["call-medicine-rounded-outline"] = "rbxassetid://98182224800168",
    	["camera-add-bold"] = "rbxassetid://110966563261508",
    	["camera-add-bold-duotone"] = "rbxassetid://132372271322427",
    	["camera-add-broken"] = "rbxassetid://96560180570479",
    	["camera-add-line-duotone"] = "rbxassetid://84105061152770",
    	["camera-add-linear"] = "rbxassetid://93923856483302",
    	["camera-add-outline"] = "rbxassetid://109751088046941",
    	["camera-bold"] = "rbxassetid://87068166927681",
    	["camera-bold-duotone"] = "rbxassetid://86241137782704",
    	["camera-broken"] = "rbxassetid://84259965466939",
    	["camera-line-duotone"] = "rbxassetid://100078341502806",
    	["camera-linear"] = "rbxassetid://84198289559749",
    	["camera-minimalistic-bold"] = "rbxassetid://81083337636599",
    	["camera-minimalistic-bold-duotone"] = "rbxassetid://115663557137874",
    	["camera-minimalistic-broken"] = "rbxassetid://79989298864072",
    	["camera-minimalistic-line-duotone"] = "rbxassetid://92746514039128",
    	["camera-minimalistic-linear"] = "rbxassetid://118310315362506",
    	["camera-minimalistic-outline"] = "rbxassetid://108568760943991",
    	["camera-outline"] = "rbxassetid://92540726786059",
    	["camera-rotate-bold"] = "rbxassetid://90982154854314",
    	["camera-rotate-bold-duotone"] = "rbxassetid://136215035669101",
    	["camera-rotate-broken"] = "rbxassetid://111017276344993",
    	["camera-rotate-line-duotone"] = "rbxassetid://118391527995368",
    	["camera-rotate-linear"] = "rbxassetid://87859807368009",
    	["camera-rotate-outline"] = "rbxassetid://113875769362771",
    	["camera-square-bold"] = "rbxassetid://132468039215215",
    	["camera-square-bold-duotone"] = "rbxassetid://88495901032186",
    	["camera-square-broken"] = "rbxassetid://82607307422246",
    	["camera-square-line-duotone"] = "rbxassetid://119460472102858",
    	["camera-square-linear"] = "rbxassetid://130533804955386",
    	["camera-square-outline"] = "rbxassetid://108237991421108",
    	["card-2-bold"] = "rbxassetid://85080545102163",
    	["card-2-bold-duotone"] = "rbxassetid://131063026388830",
    	["card-2-broken"] = "rbxassetid://81128682718472",
    	["card-2-line-duotone"] = "rbxassetid://120856176121338",
    	["card-2-linear"] = "rbxassetid://78614355508714",
    	["card-2-outline"] = "rbxassetid://72673120994360",
    	["card-bold"] = "rbxassetid://72046935796534",
    	["card-bold-duotone"] = "rbxassetid://84914021239506",
    	["card-broken"] = "rbxassetid://92687329117711",
    	["card-line-duotone"] = "rbxassetid://77536763771782",
    	["card-linear"] = "rbxassetid://100700909673096",
    	["card-outline"] = "rbxassetid://74246805356809",
    	["card-recive-bold"] = "rbxassetid://82541807222771",
    	["card-recive-bold-duotone"] = "rbxassetid://102641194518366",
    	["card-recive-broken"] = "rbxassetid://94027089308560",
    	["card-recive-line-duotone"] = "rbxassetid://119417562648790",
    	["card-recive-linear"] = "rbxassetid://137318111979667",
    	["card-recive-outline"] = "rbxassetid://129359763335628",
    	["card-search-bold"] = "rbxassetid://104777342222451",
    	["card-search-bold-duotone"] = "rbxassetid://92305353849505",
    	["card-search-broken"] = "rbxassetid://93747873247488",
    	["card-search-line-duotone"] = "rbxassetid://116789749745379",
    	["card-search-linear"] = "rbxassetid://121151427683678",
    	["card-search-outline"] = "rbxassetid://99189935188528",
    	["card-send-bold"] = "rbxassetid://102552737585107",
    	["card-send-bold-duotone"] = "rbxassetid://127639641763279",
    	["card-send-broken"] = "rbxassetid://132835562484315",
    	["card-send-line-duotone"] = "rbxassetid://72025083215229",
    	["card-send-linear"] = "rbxassetid://98099936726778",
    	["card-send-outline"] = "rbxassetid://92447360114310",
    	["card-transfer-bold"] = "rbxassetid://76243440049768",
    	["card-transfer-bold-duotone"] = "rbxassetid://98150999422371",
    	["card-transfer-broken"] = "rbxassetid://114395036006027",
    	["card-transfer-line-duotone"] = "rbxassetid://70606921414929",
    	["card-transfer-linear"] = "rbxassetid://91325766581882",
    	["card-transfer-outline"] = "rbxassetid://114722426723135",
    	["cardholder-bold"] = "rbxassetid://108585826887462",
    	["cardholder-bold-duotone"] = "rbxassetid://81537661118064",
    	["cardholder-broken"] = "rbxassetid://137642513119751",
    	["cardholder-line-duotone"] = "rbxassetid://103505872802723",
    	["cardholder-linear"] = "rbxassetid://127194745263572",
    	["cardholder-outline"] = "rbxassetid://125844728209950",
    	["cart-2-bold"] = "rbxassetid://137383884939025",
    	["cart-2-bold-duotone"] = "rbxassetid://127166363174119",
    	["cart-2-broken"] = "rbxassetid://106454106340536",
    	["cart-2-line-duotone"] = "rbxassetid://107446191247368",
    	["cart-2-linear"] = "rbxassetid://72104043686571",
    	["cart-2-outline"] = "rbxassetid://139627695271048",
    	["cart-3-bold"] = "rbxassetid://74809500253146",
    	["cart-3-bold-duotone"] = "rbxassetid://129562475331100",
    	["cart-3-broken"] = "rbxassetid://113633937016487",
    	["cart-3-line-duotone"] = "rbxassetid://118734988394905",
    	["cart-3-linear"] = "rbxassetid://138332650312623",
    	["cart-3-outline"] = "rbxassetid://123060333119789",
    	["cart-4-bold"] = "rbxassetid://91739970331197",
    	["cart-4-bold-duotone"] = "rbxassetid://117883822799804",
    	["cart-4-broken"] = "rbxassetid://138625561144278",
    	["cart-4-line-duotone"] = "rbxassetid://90765238531264",
    	["cart-4-linear"] = "rbxassetid://116425459948935",
    	["cart-4-outline"] = "rbxassetid://71239384315809",
    	["cart-5-bold"] = "rbxassetid://111648669485488",
    	["cart-5-bold-duotone"] = "rbxassetid://136343246337330",
    	["cart-5-broken"] = "rbxassetid://76202374076416",
    	["cart-5-line-duotone"] = "rbxassetid://75736565188451",
    	["cart-5-linear"] = "rbxassetid://88081328263101",
    	["cart-5-outline"] = "rbxassetid://90158467092054",
    	["cart-bold"] = "rbxassetid://138472043527451",
    	["cart-bold-duotone"] = "rbxassetid://80088302616581",
    	["cart-broken"] = "rbxassetid://87203515358908",
    	["cart-check-bold"] = "rbxassetid://102943643099870",
    	["cart-check-bold-duotone"] = "rbxassetid://132765200690431",
    	["cart-check-broken"] = "rbxassetid://81639313168141",
    	["cart-check-line-duotone"] = "rbxassetid://96226712100839",
    	["cart-check-linear"] = "rbxassetid://137270362230635",
    	["cart-check-outline"] = "rbxassetid://84375251753420",
    	["cart-cross-bold"] = "rbxassetid://123639464425344",
    	["cart-cross-bold-duotone"] = "rbxassetid://104240491955379",
    	["cart-cross-broken"] = "rbxassetid://128638719661989",
    	["cart-cross-line-duotone"] = "rbxassetid://99657622831222",
    	["cart-cross-linear"] = "rbxassetid://93594877759392",
    	["cart-cross-outline"] = "rbxassetid://135413623683029",
    	["cart-large-2-bold"] = "rbxassetid://76055686947636",
    	["cart-large-2-bold-duotone"] = "rbxassetid://86962473903959",
    	["cart-large-2-broken"] = "rbxassetid://92386299350819",
    	["cart-large-2-line-duotone"] = "rbxassetid://84333350556125",
    	["cart-large-2-linear"] = "rbxassetid://87425049157512",
    	["cart-large-2-outline"] = "rbxassetid://128689232775550",
    	["cart-large-3-bold"] = "rbxassetid://81358757896439",
    	["cart-large-3-bold-duotone"] = "rbxassetid://72267563584231",
    	["cart-large-3-broken"] = "rbxassetid://103302208351947",
    	["cart-large-3-line-duotone"] = "rbxassetid://89520716322201",
    	["cart-large-3-linear"] = "rbxassetid://86633557083868",
    	["cart-large-3-outline"] = "rbxassetid://74332788412747",
    	["cart-large-4-bold"] = "rbxassetid://102152941448876",
    	["cart-large-4-bold-duotone"] = "rbxassetid://112148301988145",
    	["cart-large-4-broken"] = "rbxassetid://90505343975523",
    	["cart-large-4-line-duotone"] = "rbxassetid://127389577831853",
    	["cart-large-4-linear"] = "rbxassetid://70819112505681",
    	["cart-large-4-outline"] = "rbxassetid://107679871996492",
    	["cart-large-bold"] = "rbxassetid://94587988389300",
    	["cart-large-bold-duotone"] = "rbxassetid://95812441135340",
    	["cart-large-broken"] = "rbxassetid://82270639043483",
    	["cart-large-line-duotone"] = "rbxassetid://96041475257430",
    	["cart-large-linear"] = "rbxassetid://106259463497864",
    	["cart-large-minimalistic-bold"] = "rbxassetid://108576259995833",
    	["cart-large-minimalistic-bold-duotone"] = "rbxassetid://116123028907210",
    	["cart-large-minimalistic-broken"] = "rbxassetid://114589142251056",
    	["cart-large-minimalistic-line-duotone"] = "rbxassetid://96367072316598",
    	["cart-large-minimalistic-linear"] = "rbxassetid://122606586618226",
    	["cart-large-minimalistic-outline"] = "rbxassetid://75064189319260",
    	["cart-large-outline"] = "rbxassetid://79319817163046",
    	["cart-line-duotone"] = "rbxassetid://80462402871272",
    	["cart-linear"] = "rbxassetid://97896140013679",
    	["cart-outline"] = "rbxassetid://94096496301056",
    	["cart-plus-bold"] = "rbxassetid://105724815937174",
    	["cart-plus-bold-duotone"] = "rbxassetid://119994716591894",
    	["cart-plus-broken"] = "rbxassetid://132995961514175",
    	["cart-plus-line-duotone"] = "rbxassetid://107761574010691",
    	["cart-plus-linear"] = "rbxassetid://79582799682743",
    	["cart-plus-outline"] = "rbxassetid://124135034545637",
    	["case-bold"] = "rbxassetid://119696465247383",
    	["case-bold-duotone"] = "rbxassetid://89817228763396",
    	["case-broken"] = "rbxassetid://92081055016638",
    	["case-line-duotone"] = "rbxassetid://87213778402265",
    	["case-linear"] = "rbxassetid://87955019434376",
    	["case-minimalistic-bold"] = "rbxassetid://97669720019378",
    	["case-minimalistic-bold-duotone"] = "rbxassetid://122400555042359",
    	["case-minimalistic-broken"] = "rbxassetid://74785543763536",
    	["case-minimalistic-line-duotone"] = "rbxassetid://139053535818376",
    	["case-minimalistic-linear"] = "rbxassetid://105899240513462",
    	["case-minimalistic-outline"] = "rbxassetid://106743838692174",
    	["case-outline"] = "rbxassetid://115188085004086",
    	["case-round-bold"] = "rbxassetid://121744681305340",
    	["case-round-bold-duotone"] = "rbxassetid://105856387542299",
    	["case-round-broken"] = "rbxassetid://136108098828636",
    	["case-round-line-duotone"] = "rbxassetid://140136502645271",
    	["case-round-linear"] = "rbxassetid://83849016647304",
    	["case-round-minimalistic-bold"] = "rbxassetid://83606679966604",
    	["case-round-minimalistic-bold-duotone"] = "rbxassetid://99579734843581",
    	["case-round-minimalistic-broken"] = "rbxassetid://120334276970188",
    	["case-round-minimalistic-line-duotone"] = "rbxassetid://122859555291787",
    	["case-round-minimalistic-linear"] = "rbxassetid://98829113783531",
    	["case-round-minimalistic-outline"] = "rbxassetid://122295088619641",
    	["case-round-outline"] = "rbxassetid://74352104887680",
    	["cash-out-bold"] = "rbxassetid://125777408982128",
    	["cash-out-bold-duotone"] = "rbxassetid://86693783459327",
    	["cash-out-broken"] = "rbxassetid://94680859473227",
    	["cash-out-line-duotone"] = "rbxassetid://126386477007301",
    	["cash-out-linear"] = "rbxassetid://135535206550832",
    	["cash-out-outline"] = "rbxassetid://110432456042805",
    	["cassette-2-bold"] = "rbxassetid://109801530784783",
    	["cassette-2-bold-duotone"] = "rbxassetid://140180889554769",
    	["cassette-2-broken"] = "rbxassetid://99300712545814",
    	["cassette-2-line-duotone"] = "rbxassetid://109305785671715",
    	["cassette-2-linear"] = "rbxassetid://74250430418452",
    	["cassette-2-outline"] = "rbxassetid://112883731371474",
    	["cassette-bold"] = "rbxassetid://86644379909549",
    	["cassette-bold-duotone"] = "rbxassetid://90192889532018",
    	["cassette-broken"] = "rbxassetid://75393734572063",
    	["cassette-line-duotone"] = "rbxassetid://116643195244903",
    	["cassette-linear"] = "rbxassetid://91520661129364",
    	["cassette-outline"] = "rbxassetid://110887047536706",
    	["cat-bold"] = "rbxassetid://105384072434825",
    	["cat-bold-duotone"] = "rbxassetid://128970018868376",
    	["cat-broken"] = "rbxassetid://128864037166522",
    	["cat-line-duotone"] = "rbxassetid://134156207744605",
    	["cat-linear"] = "rbxassetid://98473258912914",
    	["cat-outline"] = "rbxassetid://111738839893038",
    	["chair-2-bold"] = "rbxassetid://89770976424319",
    	["chair-2-bold-duotone"] = "rbxassetid://105310984220075",
    	["chair-2-broken"] = "rbxassetid://126535177066219",
    	["chair-2-line-duotone"] = "rbxassetid://100089766357709",
    	["chair-2-linear"] = "rbxassetid://127569403077279",
    	["chair-2-outline"] = "rbxassetid://84791957381452",
    	["chair-bold"] = "rbxassetid://136818704379426",
    	["chair-bold-duotone"] = "rbxassetid://129476727864230",
    	["chair-broken"] = "rbxassetid://81655166828378",
    	["chair-line-duotone"] = "rbxassetid://90272501837282",
    	["chair-linear"] = "rbxassetid://116579232568255",
    	["chair-outline"] = "rbxassetid://91158794856025",
    	["chandelier-bold"] = "rbxassetid://102497221047148",
    	["chandelier-bold-duotone"] = "rbxassetid://86754023351313",
    	["chandelier-broken"] = "rbxassetid://73028460539349",
    	["chandelier-line-duotone"] = "rbxassetid://125807410080418",
    	["chandelier-linear"] = "rbxassetid://139472775078343",
    	["chandelier-outline"] = "rbxassetid://96937379252032",
    	["chart-2-bold"] = "rbxassetid://118743447551317",
    	["chart-2-bold-duotone"] = "rbxassetid://97005610427025",
    	["chart-2-broken"] = "rbxassetid://93221650360721",
    	["chart-2-line-duotone"] = "rbxassetid://121301088820996",
    	["chart-2-linear"] = "rbxassetid://98893497849089",
    	["chart-2-outline"] = "rbxassetid://115779497668963",
    	["chart-bold"] = "rbxassetid://96276751038556",
    	["chart-bold-duotone"] = "rbxassetid://107553113924682",
    	["chart-broken"] = "rbxassetid://130105778801985",
    	["chart-line-duotone"] = "rbxassetid://111275481468483",
    	["chart-linear"] = "rbxassetid://113365719049717",
    	["chart-outline"] = "rbxassetid://86191179009274",
    	["chart-square-bold"] = "rbxassetid://73897886601288",
    	["chart-square-bold-duotone"] = "rbxassetid://100626710697011",
    	["chart-square-broken"] = "rbxassetid://103596339565065",
    	["chart-square-line-duotone"] = "rbxassetid://97255589991245",
    	["chart-square-linear"] = "rbxassetid://88164958215922",
    	["chart-square-outline"] = "rbxassetid://100702770657911",
    	["chat-dots-bold"] = "rbxassetid://133686914253815",
    	["chat-dots-bold-duotone"] = "rbxassetid://103901890910280",
    	["chat-dots-broken"] = "rbxassetid://128205990696403",
    	["chat-dots-line-duotone"] = "rbxassetid://133377367277254",
    	["chat-dots-linear"] = "rbxassetid://103298542341672",
    	["chat-dots-outline"] = "rbxassetid://99400593664239",
    	["chat-line-bold"] = "rbxassetid://112435740093712",
    	["chat-line-bold-duotone"] = "rbxassetid://120116428348415",
    	["chat-line-broken"] = "rbxassetid://103866481618630",
    	["chat-line-line-duotone"] = "rbxassetid://111708472015269",
    	["chat-line-linear"] = "rbxassetid://125844223663545",
    	["chat-line-outline"] = "rbxassetid://133712428360947",
    	["chat-round-bold"] = "rbxassetid://78330615352102",
    	["chat-round-bold-duotone"] = "rbxassetid://136957461023642",
    	["chat-round-broken"] = "rbxassetid://99195474114909",
    	["chat-round-call-bold"] = "rbxassetid://77596784979156",
    	["chat-round-call-bold-duotone"] = "rbxassetid://130538391446996",
    	["chat-round-call-broken"] = "rbxassetid://83554721577984",
    	["chat-round-call-line-duotone"] = "rbxassetid://80548905468862",
    	["chat-round-call-linear"] = "rbxassetid://112433851160603",
    	["chat-round-call-outline"] = "rbxassetid://131199181183849",
    	["chat-round-check-bold"] = "rbxassetid://125838499001073",
    	["chat-round-check-bold-duotone"] = "rbxassetid://79869409029828",
    	["chat-round-check-broken"] = "rbxassetid://99965119885904",
    	["chat-round-check-line-duotone"] = "rbxassetid://112560098987407",
    	["chat-round-check-linear"] = "rbxassetid://107044681803345",
    	["chat-round-check-outline"] = "rbxassetid://136146117945840",
    	["chat-round-dots-bold"] = "rbxassetid://127493229409116",
    	["chat-round-dots-bold-duotone"] = "rbxassetid://139130904281320",
    	["chat-round-dots-broken"] = "rbxassetid://116182814014766",
    	["chat-round-dots-line-duotone"] = "rbxassetid://128474992489399",
    	["chat-round-dots-linear"] = "rbxassetid://118552037281174",
    	["chat-round-dots-outline"] = "rbxassetid://89666216524801",
    	["chat-round-like-bold"] = "rbxassetid://118988251773984",
    	["chat-round-like-bold-duotone"] = "rbxassetid://71616642373574",
    	["chat-round-like-broken"] = "rbxassetid://90093719237235",
    	["chat-round-like-line-duotone"] = "rbxassetid://115337477123000",
    	["chat-round-like-linear"] = "rbxassetid://96731307974339",
    	["chat-round-like-outline"] = "rbxassetid://111320953586384",
    	["chat-round-line-bold"] = "rbxassetid://112669223154865",
    	["chat-round-line-bold-duotone"] = "rbxassetid://126396014394375",
    	["chat-round-line-broken"] = "rbxassetid://128938461489908",
    	["chat-round-line-duotone"] = "rbxassetid://72425131265903",
    	["chat-round-line-line-duotone"] = "rbxassetid://96030221711932",
    	["chat-round-line-linear"] = "rbxassetid://115321052382057",
    	["chat-round-line-outline"] = "rbxassetid://79073161281717",
    	["chat-round-linear"] = "rbxassetid://91569011554658",
    	["chat-round-money-bold"] = "rbxassetid://77000462768613",
    	["chat-round-money-bold-duotone"] = "rbxassetid://108515935998775",
    	["chat-round-money-broken"] = "rbxassetid://140650510473544",
    	["chat-round-money-line-duotone"] = "rbxassetid://81905208730563",
    	["chat-round-money-linear"] = "rbxassetid://105620553932178",
    	["chat-round-money-outline"] = "rbxassetid://113721872103198",
    	["chat-round-outline"] = "rbxassetid://79567043045432",
    	["chat-round-unread-bold"] = "rbxassetid://89264502342756",
    	["chat-round-unread-bold-duotone"] = "rbxassetid://76407434415241",
    	["chat-round-unread-broken"] = "rbxassetid://119933200542301",
    	["chat-round-unread-line-duotone"] = "rbxassetid://71017725749092",
    	["chat-round-unread-linear"] = "rbxassetid://110296366459650",
    	["chat-round-unread-outline"] = "rbxassetid://74407749319383",
    	["chat-round-video-bold"] = "rbxassetid://99284277113395",
    	["chat-round-video-bold-duotone"] = "rbxassetid://91278992786259",
    	["chat-round-video-broken"] = "rbxassetid://77073030557268",
    	["chat-round-video-line-duotone"] = "rbxassetid://127235038497779",
    	["chat-round-video-linear"] = "rbxassetid://77854945627314",
    	["chat-round-video-outline"] = "rbxassetid://104665407706411",
    	["chat-square-2-bold"] = "rbxassetid://104922074619504",
    	["chat-square-2-bold-duotone"] = "rbxassetid://125810279055433",
    	["chat-square-2-broken"] = "rbxassetid://123028841975869",
    	["chat-square-2-line-duotone"] = "rbxassetid://115021515334869",
    	["chat-square-2-linear"] = "rbxassetid://124910019895998",
    	["chat-square-2-outline"] = "rbxassetid://112509285126442",
    	["chat-square-arrow-bold"] = "rbxassetid://94461822655610",
    	["chat-square-arrow-bold-duotone"] = "rbxassetid://77968308198700",
    	["chat-square-arrow-broken"] = "rbxassetid://101774634555306",
    	["chat-square-arrow-line-duotone"] = "rbxassetid://129528194295682",
    	["chat-square-arrow-linear"] = "rbxassetid://97533114904914",
    	["chat-square-arrow-outline"] = "rbxassetid://107587226359388",
    	["chat-square-bold"] = "rbxassetid://90706166955323",
    	["chat-square-bold-duotone"] = "rbxassetid://87463964902754",
    	["chat-square-broken"] = "rbxassetid://97557786318254",
    	["chat-square-call-bold"] = "rbxassetid://135442679420463",
    	["chat-square-call-bold-duotone"] = "rbxassetid://89826056192244",
    	["chat-square-call-broken"] = "rbxassetid://108658662499786",
    	["chat-square-call-line-duotone"] = "rbxassetid://110065978957122",
    	["chat-square-call-linear"] = "rbxassetid://111316920316325",
    	["chat-square-call-outline"] = "rbxassetid://87984033451166",
    	["chat-square-check-bold"] = "rbxassetid://136066916290330",
    	["chat-square-check-bold-duotone"] = "rbxassetid://130881592597343",
    	["chat-square-check-broken"] = "rbxassetid://124707538970060",
    	["chat-square-check-line-duotone"] = "rbxassetid://75754248382711",
    	["chat-square-check-linear"] = "rbxassetid://102173747186169",
    	["chat-square-check-outline"] = "rbxassetid://96029385009545",
    	["chat-square-code-bold"] = "rbxassetid://70615504226457",
    	["chat-square-code-bold-duotone"] = "rbxassetid://72067070904433",
    	["chat-square-code-broken"] = "rbxassetid://118759933509866",
    	["chat-square-code-line-duotone"] = "rbxassetid://91074429591381",
    	["chat-square-code-linear"] = "rbxassetid://86452201592688",
    	["chat-square-code-outline"] = "rbxassetid://113503841992630",
    	["chat-square-like-bold"] = "rbxassetid://109130783293898",
    	["chat-square-like-bold-duotone"] = "rbxassetid://110198350826447",
    	["chat-square-like-broken"] = "rbxassetid://140406080625919",
    	["chat-square-like-line-duotone"] = "rbxassetid://124256169408921",
    	["chat-square-like-linear"] = "rbxassetid://114989628567081",
    	["chat-square-like-outline"] = "rbxassetid://94611322021866",
    	["chat-square-line-duotone"] = "rbxassetid://79113059236190",
    	["chat-square-linear"] = "rbxassetid://90373192724996",
    	["chat-square-outline"] = "rbxassetid://135053560436794",
    	["chat-unread-bold"] = "rbxassetid://92332599552446",
    	["chat-unread-bold-duotone"] = "rbxassetid://114621782577932",
    	["chat-unread-broken"] = "rbxassetid://82094734618204",
    	["chat-unread-line-duotone"] = "rbxassetid://140304217662914",
    	["chat-unread-linear"] = "rbxassetid://99967137030530",
    	["chat-unread-outline"] = "rbxassetid://78555348739740",
    	["check-circle-bold"] = "rbxassetid://82820801644879",
    	["check-circle-bold-duotone"] = "rbxassetid://103430989975178",
    	["check-circle-broken"] = "rbxassetid://127484973274948",
    	["check-circle-line-duotone"] = "rbxassetid://105154242429503",
    	["check-circle-linear"] = "rbxassetid://95939815653726",
    	["check-circle-outline"] = "rbxassetid://126761170607501",
    	["check-read-bold"] = "rbxassetid://138274208772827",
    	["check-read-bold-duotone"] = "rbxassetid://136567635714242",
    	["check-read-broken"] = "rbxassetid://102242199664142",
    	["check-read-line-duotone"] = "rbxassetid://101249243576719",
    	["check-read-linear"] = "rbxassetid://73771885340045",
    	["check-read-outline"] = "rbxassetid://76428104982861",
    	["check-square-bold"] = "rbxassetid://99566491733646",
    	["check-square-bold-duotone"] = "rbxassetid://76554913698638",
    	["check-square-broken"] = "rbxassetid://77018422330112",
    	["check-square-line-duotone"] = "rbxassetid://78624740866637",
    	["check-square-linear"] = "rbxassetid://113252273001924",
    	["check-square-outline"] = "rbxassetid://108176995275212",
    	["checklist-bold"] = "rbxassetid://136793214085079",
    	["checklist-bold-duotone"] = "rbxassetid://116933104861683",
    	["checklist-broken"] = "rbxassetid://132488209763858",
    	["checklist-line-duotone"] = "rbxassetid://128565132886773",
    	["checklist-linear"] = "rbxassetid://71021881158641",
    	["checklist-minimalistic-bold"] = "rbxassetid://86760195317849",
    	["checklist-minimalistic-bold-duotone"] = "rbxassetid://133054448135882",
    	["checklist-minimalistic-broken"] = "rbxassetid://122001007910080",
    	["checklist-minimalistic-line-duotone"] = "rbxassetid://76160038957047",
    	["checklist-minimalistic-linear"] = "rbxassetid://97416467853136",
    	["checklist-minimalistic-outline"] = "rbxassetid://130207774072690",
    	["checklist-outline"] = "rbxassetid://79964477234926",
    	["chef-hat-bold"] = "rbxassetid://113870156642148",
    	["chef-hat-bold-duotone"] = "rbxassetid://132644736790518",
    	["chef-hat-broken"] = "rbxassetid://110611168230503",
    	["chef-hat-heart-bold"] = "rbxassetid://134301061164302",
    	["chef-hat-heart-bold-duotone"] = "rbxassetid://119369778296943",
    	["chef-hat-heart-broken"] = "rbxassetid://70669421481373",
    	["chef-hat-heart-line-duotone"] = "rbxassetid://136925226244434",
    	["chef-hat-heart-linear"] = "rbxassetid://116491083962584",
    	["chef-hat-heart-outline"] = "rbxassetid://79904104780782",
    	["chef-hat-line-duotone"] = "rbxassetid://139602406265834",
    	["chef-hat-linear"] = "rbxassetid://95259244068112",
    	["chef-hat-minimalistic-bold"] = "rbxassetid://110783253227435",
    	["chef-hat-minimalistic-bold-duotone"] = "rbxassetid://71903349549357",
    	["chef-hat-minimalistic-broken"] = "rbxassetid://75241849899039",
    	["chef-hat-minimalistic-line-duotone"] = "rbxassetid://124528051879749",
    	["chef-hat-minimalistic-linear"] = "rbxassetid://110612423943205",
    	["chef-hat-minimalistic-outline"] = "rbxassetid://137083303536836",
    	["chef-hat-outline"] = "rbxassetid://129772908064983",
    	["circle-bottom-down-bold"] = "rbxassetid://135551371096609",
    	["circle-bottom-down-bold-duotone"] = "rbxassetid://75621150061195",
    	["circle-bottom-down-broken"] = "rbxassetid://120440553739914",
    	["circle-bottom-down-line-duotone"] = "rbxassetid://86109583900390",
    	["circle-bottom-down-linear"] = "rbxassetid://76925609776156",
    	["circle-bottom-down-outline"] = "rbxassetid://104409462865978",
    	["circle-bottom-up-bold"] = "rbxassetid://128946377811138",
    	["circle-bottom-up-bold-duotone"] = "rbxassetid://86810061327705",
    	["circle-bottom-up-broken"] = "rbxassetid://75412848891999",
    	["circle-bottom-up-line-duotone"] = "rbxassetid://120553516131033",
    	["circle-bottom-up-linear"] = "rbxassetid://90493132671625",
    	["circle-bottom-up-outline"] = "rbxassetid://105408781195848",
    	["circle-top-down-bold"] = "rbxassetid://100770929961778",
    	["circle-top-down-bold-duotone"] = "rbxassetid://138491664040864",
    	["circle-top-down-broken"] = "rbxassetid://80535761923161",
    	["circle-top-down-line-duotone"] = "rbxassetid://116651100320734",
    	["circle-top-down-linear"] = "rbxassetid://83247595982035",
    	["circle-top-down-outline"] = "rbxassetid://86340247247340",
    	["circle-top-up-bold"] = "rbxassetid://73051018110236",
    	["circle-top-up-bold-duotone"] = "rbxassetid://77405630835133",
    	["circle-top-up-broken"] = "rbxassetid://72109030640831",
    	["circle-top-up-line-duotone"] = "rbxassetid://81447318853503",
    	["circle-top-up-linear"] = "rbxassetid://139636911051054",
    	["circle-top-up-outline"] = "rbxassetid://84625785091028",
    	["city-bold"] = "rbxassetid://124023948851779",
    	["city-linear"] = "rbxassetid://87849055655711",
    	["clapperboard-bold"] = "rbxassetid://89719508620288",
    	["clapperboard-bold-duotone"] = "rbxassetid://126854322342408",
    	["clapperboard-broken"] = "rbxassetid://120269079935849",
    	["clapperboard-edit-bold"] = "rbxassetid://128938026974232",
    	["clapperboard-edit-bold-duotone"] = "rbxassetid://92046128378891",
    	["clapperboard-edit-broken"] = "rbxassetid://115630842168628",
    	["clapperboard-edit-line-duotone"] = "rbxassetid://96526120748911",
    	["clapperboard-edit-linear"] = "rbxassetid://140242155058343",
    	["clapperboard-edit-outline"] = "rbxassetid://140060328413716",
    	["clapperboard-line-duotone"] = "rbxassetid://121926978837498",
    	["clapperboard-linear"] = "rbxassetid://73039469900239",
    	["clapperboard-open-bold"] = "rbxassetid://104963698433171",
    	["clapperboard-open-bold-duotone"] = "rbxassetid://107068971513779",
    	["clapperboard-open-broken"] = "rbxassetid://83031085509646",
    	["clapperboard-open-line-duotone"] = "rbxassetid://110586220136253",
    	["clapperboard-open-linear"] = "rbxassetid://77581116681420",
    	["clapperboard-open-outline"] = "rbxassetid://115247656326498",
    	["clapperboard-open-play-bold"] = "rbxassetid://73132126521195",
    	["clapperboard-open-play-bold-duotone"] = "rbxassetid://132652422260027",
    	["clapperboard-open-play-broken"] = "rbxassetid://87752241087341",
    	["clapperboard-open-play-line-duotone"] = "rbxassetid://135089713962632",
    	["clapperboard-open-play-linear"] = "rbxassetid://116215033508168",
    	["clapperboard-open-play-outline"] = "rbxassetid://94835663905495",
    	["clapperboard-outline"] = "rbxassetid://121631658092084",
    	["clapperboard-play-bold"] = "rbxassetid://111582197285199",
    	["clapperboard-play-bold-duotone"] = "rbxassetid://93753314372720",
    	["clapperboard-play-broken"] = "rbxassetid://139872661356666",
    	["clapperboard-play-line-duotone"] = "rbxassetid://98907930072108",
    	["clapperboard-play-linear"] = "rbxassetid://139113176505006",
    	["clapperboard-play-outline"] = "rbxassetid://86011534796131",
    	["clapperboard-text-bold"] = "rbxassetid://73477971487222",
    	["clapperboard-text-bold-duotone"] = "rbxassetid://81542640635561",
    	["clapperboard-text-broken"] = "rbxassetid://126585271725983",
    	["clapperboard-text-line-duotone"] = "rbxassetid://96418025765355",
    	["clapperboard-text-linear"] = "rbxassetid://104362019101537",
    	["clapperboard-text-outline"] = "rbxassetid://123569416217139",
    	["clipboard-add-bold"] = "rbxassetid://136180905417645",
    	["clipboard-add-bold-duotone"] = "rbxassetid://100096363478023",
    	["clipboard-add-broken"] = "rbxassetid://126223932020048",
    	["clipboard-add-line-duotone"] = "rbxassetid://98477726183251",
    	["clipboard-add-linear"] = "rbxassetid://92012616937213",
    	["clipboard-add-outline"] = "rbxassetid://111994907608791",
    	["clipboard-bold"] = "rbxassetid://91016040046438",
    	["clipboard-bold-duotone"] = "rbxassetid://118659959776882",
    	["clipboard-broken"] = "rbxassetid://84085270177164",
    	["clipboard-check-bold"] = "rbxassetid://125586662813538",
    	["clipboard-check-bold-duotone"] = "rbxassetid://86661125988064",
    	["clipboard-check-broken"] = "rbxassetid://101406373716708",
    	["clipboard-check-line-duotone"] = "rbxassetid://121794431704629",
    	["clipboard-check-linear"] = "rbxassetid://100471340874927",
    	["clipboard-check-outline"] = "rbxassetid://129578749229640",
    	["clipboard-heart-bold"] = "rbxassetid://136940491369414",
    	["clipboard-heart-bold-duotone"] = "rbxassetid://137086531888796",
    	["clipboard-heart-broken"] = "rbxassetid://114129515778705",
    	["clipboard-heart-line-duotone"] = "rbxassetid://124462541612603",
    	["clipboard-heart-linear"] = "rbxassetid://72265162298931",
    	["clipboard-heart-outline"] = "rbxassetid://83134916076964",
    	["clipboard-line-duotone"] = "rbxassetid://122413471008147",
    	["clipboard-linear"] = "rbxassetid://126887284261452",
    	["clipboard-list-bold"] = "rbxassetid://109929897348568",
    	["clipboard-list-bold-duotone"] = "rbxassetid://104660293760570",
    	["clipboard-list-broken"] = "rbxassetid://78247272752327",
    	["clipboard-list-line-duotone"] = "rbxassetid://90892145882936",
    	["clipboard-list-linear"] = "rbxassetid://129736254490477",
    	["clipboard-list-outline"] = "rbxassetid://134544643646568",
    	["clipboard-outline"] = "rbxassetid://91260959398943",
    	["clipboard-remove-bold"] = "rbxassetid://102890040722269",
    	["clipboard-remove-bold-duotone"] = "rbxassetid://136140234951578",
    	["clipboard-remove-broken"] = "rbxassetid://124703357459613",
    	["clipboard-remove-line-duotone"] = "rbxassetid://82412136863032",
    	["clipboard-remove-linear"] = "rbxassetid://94031577551857",
    	["clipboard-remove-outline"] = "rbxassetid://94148898732896",
    	["clipboard-text-bold"] = "rbxassetid://104672144915107",
    	["clipboard-text-bold-duotone"] = "rbxassetid://140433506860265",
    	["clipboard-text-broken"] = "rbxassetid://87195211770561",
    	["clipboard-text-line-duotone"] = "rbxassetid://130659207066022",
    	["clipboard-text-linear"] = "rbxassetid://86147882685917",
    	["clipboard-text-outline"] = "rbxassetid://77208194273254",
    	["clock-circle-bold"] = "rbxassetid://118979078864433",
    	["clock-circle-bold-duotone"] = "rbxassetid://95579053426777",
    	["clock-circle-broken"] = "rbxassetid://71644651099192",
    	["clock-circle-line-duotone"] = "rbxassetid://125302605178848",
    	["clock-circle-linear"] = "rbxassetid://81077347396706",
    	["clock-circle-outline"] = "rbxassetid://92335178010483",
    	["clock-square-bold"] = "rbxassetid://81088894794035",
    	["clock-square-bold-duotone"] = "rbxassetid://121520638209619",
    	["clock-square-broken"] = "rbxassetid://117786127435255",
    	["clock-square-line-duotone"] = "rbxassetid://78263643433229",
    	["clock-square-linear"] = "rbxassetid://82669955987884",
    	["clock-square-outline"] = "rbxassetid://84694136258810",
    	["close-circle-bold"] = "rbxassetid://103154043386406",
    	["close-circle-bold-duotone"] = "rbxassetid://134492391307751",
    	["close-circle-broken"] = "rbxassetid://74025292886708",
    	["close-circle-line-duotone"] = "rbxassetid://118628655190118",
    	["close-circle-linear"] = "rbxassetid://72407806393692",
    	["close-circle-outline"] = "rbxassetid://86917493607188",
    	["close-square-bold"] = "rbxassetid://117747448917698",
    	["close-square-bold-duotone"] = "rbxassetid://105919813809369",
    	["close-square-broken"] = "rbxassetid://115417323358555",
    	["close-square-line-duotone"] = "rbxassetid://111995317305450",
    	["close-square-linear"] = "rbxassetid://102159833218370",
    	["close-square-outline"] = "rbxassetid://93858598863325",
    	["closet-2-bold"] = "rbxassetid://79121792964717",
    	["closet-2-bold-duotone"] = "rbxassetid://102769258249977",
    	["closet-2-broken"] = "rbxassetid://99001870899139",
    	["closet-2-line-duotone"] = "rbxassetid://121894260632078",
    	["closet-2-linear"] = "rbxassetid://127152923210175",
    	["closet-2-outline"] = "rbxassetid://134193046412353",
    	["closet-bold"] = "rbxassetid://82375761095646",
    	["closet-bold-duotone"] = "rbxassetid://108366633988859",
    	["closet-broken"] = "rbxassetid://83589664552253",
    	["closet-line-duotone"] = "rbxassetid://123100229916528",
    	["closet-linear"] = "rbxassetid://83660682771127",
    	["closet-outline"] = "rbxassetid://106925681273408",
    	["cloud-bold"] = "rbxassetid://108575613594275",
    	["cloud-bold-duotone"] = "rbxassetid://128896456902872",
    	["cloud-bolt-bold"] = "rbxassetid://71224241453064",
    	["cloud-bolt-bold-duotone"] = "rbxassetid://74005689475661",
    	["cloud-bolt-broken"] = "rbxassetid://79422846182863",
    	["cloud-bolt-line-duotone"] = "rbxassetid://127837969578072",
    	["cloud-bolt-linear"] = "rbxassetid://109753005880214",
    	["cloud-bolt-minimalistic-bold"] = "rbxassetid://85544269522058",
    	["cloud-bolt-minimalistic-bold-duotone"] = "rbxassetid://95580249513475",
    	["cloud-bolt-minimalistic-broken"] = "rbxassetid://116307477912151",
    	["cloud-bolt-minimalistic-line-duotone"] = "rbxassetid://105321700651546",
    	["cloud-bolt-minimalistic-linear"] = "rbxassetid://108711467113452",
    	["cloud-bolt-minimalistic-outline"] = "rbxassetid://135949114963031",
    	["cloud-bolt-outline"] = "rbxassetid://76336375670588",
    	["cloud-broken"] = "rbxassetid://115559235294546",
    	["cloud-check-bold"] = "rbxassetid://136880017504577",
    	["cloud-check-bold-duotone"] = "rbxassetid://108663426307850",
    	["cloud-check-broken"] = "rbxassetid://126385669506512",
    	["cloud-check-line-duotone"] = "rbxassetid://140304315189404",
    	["cloud-check-linear"] = "rbxassetid://128199077274951",
    	["cloud-check-outline"] = "rbxassetid://109711078595447",
    	["cloud-download-bold"] = "rbxassetid://95110638826999",
    	["cloud-download-bold-duotone"] = "rbxassetid://107655427460678",
    	["cloud-download-broken"] = "rbxassetid://116045699820525",
    	["cloud-download-line-duotone"] = "rbxassetid://108823933847964",
    	["cloud-download-linear"] = "rbxassetid://94772232072960",
    	["cloud-download-outline"] = "rbxassetid://72084072106355",
    	["cloud-file-bold"] = "rbxassetid://114219090313200",
    	["cloud-file-bold-duotone"] = "rbxassetid://133801539589500",
    	["cloud-file-broken"] = "rbxassetid://87110093242524",
    	["cloud-file-line-duotone"] = "rbxassetid://108453652557280",
    	["cloud-file-linear"] = "rbxassetid://126264448104970",
    	["cloud-file-outline"] = "rbxassetid://95975913895455",
    	["cloud-line-duotone"] = "rbxassetid://78822376985696",
    	["cloud-linear"] = "rbxassetid://120642021685641",
    	["cloud-minus-bold"] = "rbxassetid://117216213198839",
    	["cloud-minus-bold-duotone"] = "rbxassetid://97203047794277",
    	["cloud-minus-broken"] = "rbxassetid://79552971364873",
    	["cloud-minus-line-duotone"] = "rbxassetid://108543936139096",
    	["cloud-minus-linear"] = "rbxassetid://110707507670980",
    	["cloud-minus-outline"] = "rbxassetid://113917225655824",
    	["cloud-outline"] = "rbxassetid://79443960171489",
    	["cloud-plus-bold"] = "rbxassetid://132303686006509",
    	["cloud-plus-bold-duotone"] = "rbxassetid://82488146813869",
    	["cloud-plus-broken"] = "rbxassetid://76517551186359",
    	["cloud-plus-line-duotone"] = "rbxassetid://107558951770317",
    	["cloud-plus-linear"] = "rbxassetid://98598912948463",
    	["cloud-plus-outline"] = "rbxassetid://98709746801001",
    	["cloud-rain-bold"] = "rbxassetid://110376108133266",
    	["cloud-rain-bold-duotone"] = "rbxassetid://104500560880915",
    	["cloud-rain-broken"] = "rbxassetid://131565928903144",
    	["cloud-rain-line-duotone"] = "rbxassetid://109911852046842",
    	["cloud-rain-linear"] = "rbxassetid://90187324726797",
    	["cloud-rain-outline"] = "rbxassetid://97100962849936",
    	["cloud-snowfall-bold"] = "rbxassetid://94426070651598",
    	["cloud-snowfall-bold-duotone"] = "rbxassetid://123489954848168",
    	["cloud-snowfall-broken"] = "rbxassetid://105460049357099",
    	["cloud-snowfall-line-duotone"] = "rbxassetid://93456571334081",
    	["cloud-snowfall-linear"] = "rbxassetid://112157098300732",
    	["cloud-snowfall-minimalistic-bold"] = "rbxassetid://96006117954227",
    	["cloud-snowfall-minimalistic-bold-duotone"] = "rbxassetid://101068216689702",
    	["cloud-snowfall-minimalistic-broken"] = "rbxassetid://110272105218818",
    	["cloud-snowfall-minimalistic-line-duotone"] = "rbxassetid://132293972187656",
    	["cloud-snowfall-minimalistic-linear"] = "rbxassetid://71003450232314",
    	["cloud-snowfall-minimalistic-outline"] = "rbxassetid://133664748944945",
    	["cloud-snowfall-outline"] = "rbxassetid://92679090413888",
    	["cloud-storage-bold"] = "rbxassetid://129700043644165",
    	["cloud-storage-bold-duotone"] = "rbxassetid://108785793364247",
    	["cloud-storage-broken"] = "rbxassetid://90423004541085",
    	["cloud-storage-line-duotone"] = "rbxassetid://82015935764451",
    	["cloud-storage-linear"] = "rbxassetid://119222494179607",
    	["cloud-storage-outline"] = "rbxassetid://95649570453599",
    	["cloud-storm-bold"] = "rbxassetid://113745543435089",
    	["cloud-storm-bold-duotone"] = "rbxassetid://128479591573728",
    	["cloud-storm-broken"] = "rbxassetid://131673521663983",
    	["cloud-storm-line-duotone"] = "rbxassetid://121867080816453",
    	["cloud-storm-linear"] = "rbxassetid://84810902098135",
    	["cloud-storm-outline"] = "rbxassetid://94736342081629",
    	["cloud-sun-2-bold"] = "rbxassetid://115449627128729",
    	["cloud-sun-2-bold-duotone"] = "rbxassetid://127980020019903",
    	["cloud-sun-2-broken"] = "rbxassetid://87719288938198",
    	["cloud-sun-2-line-duotone"] = "rbxassetid://138500301419293",
    	["cloud-sun-2-linear"] = "rbxassetid://127781236991755",
    	["cloud-sun-2-outline"] = "rbxassetid://122389616251485",
    	["cloud-sun-bold"] = "rbxassetid://83282999774503",
    	["cloud-sun-bold-duotone"] = "rbxassetid://98117278227303",
    	["cloud-sun-broken"] = "rbxassetid://73408795801780",
    	["cloud-sun-line-duotone"] = "rbxassetid://92895630960627",
    	["cloud-sun-linear"] = "rbxassetid://93611987480506",
    	["cloud-sun-outline"] = "rbxassetid://74740571396747",
    	["cloud-upload-bold"] = "rbxassetid://138593101904781",
    	["cloud-upload-bold-duotone"] = "rbxassetid://79230957505992",
    	["cloud-upload-broken"] = "rbxassetid://80305097655727",
    	["cloud-upload-line-duotone"] = "rbxassetid://127478942853514",
    	["cloud-upload-linear"] = "rbxassetid://131949303419310",
    	["cloud-upload-outline"] = "rbxassetid://103996982458604",
    	["cloud-waterdrop-bold"] = "rbxassetid://135781878918524",
    	["cloud-waterdrop-bold-duotone"] = "rbxassetid://130954636370104",
    	["cloud-waterdrop-broken"] = "rbxassetid://127458094660887",
    	["cloud-waterdrop-line-duotone"] = "rbxassetid://136229513619913",
    	["cloud-waterdrop-linear"] = "rbxassetid://129616179482675",
    	["cloud-waterdrop-outline"] = "rbxassetid://103553470660739",
    	["cloud-waterdrops-bold"] = "rbxassetid://80640158841131",
    	["cloud-waterdrops-bold-duotone"] = "rbxassetid://124812394501989",
    	["cloud-waterdrops-broken"] = "rbxassetid://85711833250828",
    	["cloud-waterdrops-line-duotone"] = "rbxassetid://78043042337704",
    	["cloud-waterdrops-linear"] = "rbxassetid://136782945573441",
    	["cloud-waterdrops-outline"] = "rbxassetid://136203507877698",
    	["clouds-bold"] = "rbxassetid://110655074990085",
    	["clouds-bold-duotone"] = "rbxassetid://87424957646958",
    	["clouds-broken"] = "rbxassetid://91889951278631",
    	["clouds-line-duotone"] = "rbxassetid://77638340459973",
    	["clouds-linear"] = "rbxassetid://106325783188792",
    	["clouds-outline"] = "rbxassetid://140137709684950",
    	["cloudy-moon-bold"] = "rbxassetid://96621356274700",
    	["cloudy-moon-bold-duotone"] = "rbxassetid://93409587124330",
    	["cloudy-moon-broken"] = "rbxassetid://138948250349350",
    	["cloudy-moon-line-duotone"] = "rbxassetid://77489991981837",
    	["cloudy-moon-linear"] = "rbxassetid://83013577897771",
    	["cloudy-moon-outline"] = "rbxassetid://103409119071756",
    	["clound-cross-bold"] = "rbxassetid://134825811343636",
    	["clound-cross-bold-duotone"] = "rbxassetid://97339420929223",
    	["clound-cross-broken"] = "rbxassetid://139581075946995",
    	["clound-cross-line-duotone"] = "rbxassetid://94138789157830",
    	["clound-cross-linear"] = "rbxassetid://127388876074658",
    	["clound-cross-outline"] = "rbxassetid://75741056439829",
    	["code-2-bold"] = "rbxassetid://137645011895167",
    	["code-2-bold-duotone"] = "rbxassetid://99093716815253",
    	["code-2-broken"] = "rbxassetid://118142548210528",
    	["code-2-line-duotone"] = "rbxassetid://111502608077087",
    	["code-2-linear"] = "rbxassetid://107761719517952",
    	["code-2-outline"] = "rbxassetid://86892294588869",
    	["code-bold"] = "rbxassetid://137231383216181",
    	["code-bold-duotone"] = "rbxassetid://87477421173190",
    	["code-broken"] = "rbxassetid://83985142020042",
    	["code-circle-bold"] = "rbxassetid://97156044146678",
    	["code-circle-bold-duotone"] = "rbxassetid://72788820997166",
    	["code-circle-broken"] = "rbxassetid://140518523585372",
    	["code-circle-line-duotone"] = "rbxassetid://122511578651615",
    	["code-circle-linear"] = "rbxassetid://79923303118259",
    	["code-circle-outline"] = "rbxassetid://79372775681994",
    	["code-file-bold"] = "rbxassetid://117837330462036",
    	["code-file-bold-duotone"] = "rbxassetid://80252160837681",
    	["code-file-broken"] = "rbxassetid://80306494681603",
    	["code-file-line-duotone"] = "rbxassetid://82701628776848",
    	["code-file-linear"] = "rbxassetid://99683106045621",
    	["code-file-outline"] = "rbxassetid://102524030310372",
    	["code-line-duotone"] = "rbxassetid://105648634338774",
    	["code-linear"] = "rbxassetid://109930570333915",
    	["code-outline"] = "rbxassetid://73065550641942",
    	["code-scan-bold"] = "rbxassetid://83531616308724",
    	["code-scan-bold-duotone"] = "rbxassetid://136856930098172",
    	["code-scan-broken"] = "rbxassetid://94087595293736",
    	["code-scan-line-duotone"] = "rbxassetid://108502381381196",
    	["code-scan-linear"] = "rbxassetid://96473463871009",
    	["code-scan-outline"] = "rbxassetid://110871001267313",
    	["code-square-bold"] = "rbxassetid://111042135639244",
    	["code-square-bold-duotone"] = "rbxassetid://129495880796219",
    	["code-square-broken"] = "rbxassetid://132692943019155",
    	["code-square-line-duotone"] = "rbxassetid://78239786894244",
    	["code-square-linear"] = "rbxassetid://130131718544415",
    	["code-square-outline"] = "rbxassetid://115350744472614",
    	["colour-tuneing-bold"] = "rbxassetid://79820790543002",
    	["colour-tuneing-bold-duotone"] = "rbxassetid://131833976201897",
    	["colour-tuneing-broken"] = "rbxassetid://110884475404047",
    	["colour-tuneing-line-duotone"] = "rbxassetid://113905249556419",
    	["colour-tuneing-linear"] = "rbxassetid://137075588512445",
    	["colour-tuneing-outline"] = "rbxassetid://137232099567881",
    	["command-bold"] = "rbxassetid://93159922068420",
    	["command-bold-duotone"] = "rbxassetid://85050048205390",
    	["command-broken"] = "rbxassetid://129616946081751",
    	["command-line-duotone"] = "rbxassetid://74001438356243",
    	["command-linear"] = "rbxassetid://136766204691147",
    	["command-outline"] = "rbxassetid://73264570652834",
    	["compass-big-bold"] = "rbxassetid://124869961638781",
    	["compass-big-bold-duotone"] = "rbxassetid://73383740939011",
    	["compass-big-broken"] = "rbxassetid://122815946213888",
    	["compass-big-line-duotone"] = "rbxassetid://75378930983276",
    	["compass-big-linear"] = "rbxassetid://110562608763691",
    	["compass-big-outline"] = "rbxassetid://106574298145063",
    	["compass-bold"] = "rbxassetid://127242665382390",
    	["compass-bold-duotone"] = "rbxassetid://131939590771870",
    	["compass-broken"] = "rbxassetid://103186223210441",
    	["compass-line-duotone"] = "rbxassetid://94081055932673",
    	["compass-linear"] = "rbxassetid://77856425511260",
    	["compass-outline"] = "rbxassetid://79071127676648",
    	["compass-square-bold"] = "rbxassetid://73284095554635",
    	["compass-square-bold-duotone"] = "rbxassetid://75031122098155",
    	["compass-square-broken"] = "rbxassetid://86044218768838",
    	["compass-square-line-duotone"] = "rbxassetid://110035538777502",
    	["compass-square-linear"] = "rbxassetid://84548496813882",
    	["compass-square-outline"] = "rbxassetid://92267922848372",
    	["condicioner-2-bold"] = "rbxassetid://112356125215271",
    	["condicioner-2-bold-duotone"] = "rbxassetid://90318827798537",
    	["condicioner-2-broken"] = "rbxassetid://83447615284140",
    	["condicioner-2-line-duotone"] = "rbxassetid://108651222564990",
    	["condicioner-2-linear"] = "rbxassetid://95628677549208",
    	["condicioner-2-outline"] = "rbxassetid://127282409203282",
    	["condicioner-bold"] = "rbxassetid://88254629086164",
    	["condicioner-bold-duotone"] = "rbxassetid://95423803142797",
    	["condicioner-broken"] = "rbxassetid://91367495657207",
    	["condicioner-line-duotone"] = "rbxassetid://106048872095508",
    	["condicioner-linear"] = "rbxassetid://135836039748060",
    	["condicioner-outline"] = "rbxassetid://137646431444836",
    	["confetti-bold"] = "rbxassetid://88722678775088",
    	["confetti-bold-duotone"] = "rbxassetid://116751973403393",
    	["confetti-broken"] = "rbxassetid://90957048015329",
    	["confetti-line-duotone"] = "rbxassetid://117553889230965",
    	["confetti-linear"] = "rbxassetid://106037009536308",
    	["confetti-minimalistic-bold"] = "rbxassetid://115073951260212",
    	["confetti-minimalistic-bold-duotone"] = "rbxassetid://83637136661727",
    	["confetti-minimalistic-broken"] = "rbxassetid://122022678637538",
    	["confetti-minimalistic-line-duotone"] = "rbxassetid://75961431719838",
    	["confetti-minimalistic-linear"] = "rbxassetid://140243175919062",
    	["confetti-minimalistic-outline"] = "rbxassetid://134349369884601",
    	["confetti-outline"] = "rbxassetid://116871576302680",
    	["confounded-circle-bold"] = "rbxassetid://118941931906260",
    	["confounded-circle-bold-duotone"] = "rbxassetid://126700061579731",
    	["confounded-circle-broken"] = "rbxassetid://77602777258651",
    	["confounded-circle-line-duotone"] = "rbxassetid://102480921645164",
    	["confounded-circle-linear"] = "rbxassetid://129074444114106",
    	["confounded-circle-outline"] = "rbxassetid://131843769345899",
    	["confounded-square-bold"] = "rbxassetid://74327663573532",
    	["confounded-square-bold-duotone"] = "rbxassetid://83944406461050",
    	["confounded-square-broken"] = "rbxassetid://107339622137272",
    	["confounded-square-line-duotone"] = "rbxassetid://91486830570889",
    	["confounded-square-linear"] = "rbxassetid://119671981452318",
    	["confounded-square-outline"] = "rbxassetid://107222563771065",
    	["copy-bold"] = "rbxassetid://107485544510830",
    	["copy-bold-duotone"] = "rbxassetid://132111453165044",
    	["copy-broken"] = "rbxassetid://117903219790874",
    	["copy-line-duotone"] = "rbxassetid://74633137231916",
    	["copy-linear"] = "rbxassetid://111224245852715",
    	["copy-outline"] = "rbxassetid://83810487915409",
    	["copyright-bold"] = "rbxassetid://98543286923978",
    	["copyright-bold-duotone"] = "rbxassetid://118728944929042",
    	["copyright-broken"] = "rbxassetid://120689454741131",
    	["copyright-line-duotone"] = "rbxassetid://120171293887015",
    	["copyright-linear"] = "rbxassetid://120679955550091",
    	["copyright-outline"] = "rbxassetid://135848160836433",
    	["corkscrew-bold"] = "rbxassetid://75063608922953",
    	["corkscrew-bold-duotone"] = "rbxassetid://107661613888931",
    	["corkscrew-broken"] = "rbxassetid://106535177494358",
    	["corkscrew-line-duotone"] = "rbxassetid://129314792079691",
    	["corkscrew-linear"] = "rbxassetid://121090556587521",
    	["corkscrew-outline"] = "rbxassetid://105207741746095",
    	["cosmetic-bold"] = "rbxassetid://131731033115365",
    	["cosmetic-bold-duotone"] = "rbxassetid://131451442842296",
    	["cosmetic-broken"] = "rbxassetid://91949877066275",
    	["cosmetic-line-duotone"] = "rbxassetid://107602901802126",
    	["cosmetic-linear"] = "rbxassetid://72335537727977",
    	["cosmetic-outline"] = "rbxassetid://136143034149982",
    	["course-down-bold"] = "rbxassetid://117677816719749",
    	["course-down-bold-duotone"] = "rbxassetid://127013208094268",
    	["course-down-broken"] = "rbxassetid://126796869521931",
    	["course-down-line-duotone"] = "rbxassetid://95938925320412",
    	["course-down-linear"] = "rbxassetid://87541808534949",
    	["course-down-outline"] = "rbxassetid://87115920464432",
    	["course-up-bold"] = "rbxassetid://117921035948036",
    	["course-up-bold-duotone"] = "rbxassetid://119863394192405",
    	["course-up-broken"] = "rbxassetid://103352489245571",
    	["course-up-line-duotone"] = "rbxassetid://138642389635929",
    	["course-up-linear"] = "rbxassetid://120497421130472",
    	["course-up-outline"] = "rbxassetid://122755526000042",
    	["cpu-bold"] = "rbxassetid://131156235725075",
    	["cpu-bold-duotone"] = "rbxassetid://91019291873981",
    	["cpu-bolt-bold"] = "rbxassetid://92919014193893",
    	["cpu-bolt-bold-duotone"] = "rbxassetid://122854376685667",
    	["cpu-bolt-broken"] = "rbxassetid://71310461741448",
    	["cpu-bolt-line-duotone"] = "rbxassetid://115563890557209",
    	["cpu-bolt-linear"] = "rbxassetid://117526021929404",
    	["cpu-bolt-outline"] = "rbxassetid://137220938257682",
    	["cpu-broken"] = "rbxassetid://120300862461432",
    	["cpu-line-duotone"] = "rbxassetid://121830073831794",
    	["cpu-linear"] = "rbxassetid://108057220318686",
    	["cpu-outline"] = "rbxassetid://136146063326575",
    	["creative-commons-bold"] = "rbxassetid://111834716132240",
    	["creative-commons-bold-duotone"] = "rbxassetid://98847498593762",
    	["creative-commons-broken"] = "rbxassetid://140198537043405",
    	["creative-commons-line-duotone"] = "rbxassetid://97050996094286",
    	["creative-commons-linear"] = "rbxassetid://121044282652392",
    	["creative-commons-outline"] = "rbxassetid://139525147926272",
    	["crop-bold"] = "rbxassetid://116305623512280",
    	["crop-bold-duotone"] = "rbxassetid://109060350489791",
    	["crop-broken"] = "rbxassetid://116053128588600",
    	["crop-line-duotone"] = "rbxassetid://127506263343885",
    	["crop-linear"] = "rbxassetid://121031337259927",
    	["crop-minimalistic-bold"] = "rbxassetid://105158350951533",
    	["crop-minimalistic-bold-duotone"] = "rbxassetid://140539903498856",
    	["crop-minimalistic-broken"] = "rbxassetid://137714676995842",
    	["crop-minimalistic-line-duotone"] = "rbxassetid://135785100338296",
    	["crop-minimalistic-linear"] = "rbxassetid://107214143466309",
    	["crop-minimalistic-outline"] = "rbxassetid://129324957475704",
    	["crop-outline"] = "rbxassetid://125428074561130",
    	["crown-bold"] = "rbxassetid://116760779834746",
    	["crown-bold-duotone"] = "rbxassetid://103988274003121",
    	["crown-broken"] = "rbxassetid://136407936096865",
    	["crown-line-bold"] = "rbxassetid://131457704283344",
    	["crown-line-bold-duotone"] = "rbxassetid://112540816398643",
    	["crown-line-broken"] = "rbxassetid://124263734837840",
    	["crown-line-duotone"] = "rbxassetid://91672412524824",
    	["crown-line-line-duotone"] = "rbxassetid://108060338684675",
    	["crown-line-linear"] = "rbxassetid://139687658336147",
    	["crown-line-outline"] = "rbxassetid://80621536965379",
    	["crown-linear"] = "rbxassetid://77828841932726",
    	["crown-minimalistic-bold"] = "rbxassetid://119226611739930",
    	["crown-minimalistic-bold-duotone"] = "rbxassetid://114508389368711",
    	["crown-minimalistic-broken"] = "rbxassetid://120344247095419",
    	["crown-minimalistic-line-duotone"] = "rbxassetid://80732396613707",
    	["crown-minimalistic-linear"] = "rbxassetid://105353752558527",
    	["crown-minimalistic-outline"] = "rbxassetid://131362459189956",
    	["crown-outline"] = "rbxassetid://88375405140109",
    	["crown-star-bold"] = "rbxassetid://137184309074044",
    	["crown-star-bold-duotone"] = "rbxassetid://94822470216973",
    	["crown-star-broken"] = "rbxassetid://130800975472761",
    	["crown-star-line-duotone"] = "rbxassetid://104375596034225",
    	["crown-star-linear"] = "rbxassetid://104848177624084",
    	["crown-star-outline"] = "rbxassetid://78471265535626",
    	["cup-bold"] = "rbxassetid://76713390911381",
    	["cup-bold-1"] = "rbxassetid://88181752012475",
    	["cup-bold-duotone"] = "rbxassetid://117151956991684",
    	["cup-bold-duotone-1"] = "rbxassetid://93043034524825",
    	["cup-broken"] = "rbxassetid://122813676149570",
    	["cup-broken-1"] = "rbxassetid://124479247604229",
    	["cup-first-bold"] = "rbxassetid://84944194486522",
    	["cup-first-bold-duotone"] = "rbxassetid://108178423067196",
    	["cup-first-broken"] = "rbxassetid://94815637029913",
    	["cup-first-line-duotone"] = "rbxassetid://112232340338333",
    	["cup-first-linear"] = "rbxassetid://100101376743925",
    	["cup-first-outline"] = "rbxassetid://77713403758773",
    	["cup-hot-bold"] = "rbxassetid://126345557452931",
    	["cup-hot-bold-duotone"] = "rbxassetid://85818233708855",
    	["cup-hot-broken"] = "rbxassetid://134993309078196",
    	["cup-hot-line-duotone"] = "rbxassetid://90830103793354",
    	["cup-hot-linear"] = "rbxassetid://130943615175893",
    	["cup-hot-outline"] = "rbxassetid://80932619984570",
    	["cup-line-duotone"] = "rbxassetid://86442976930977",
    	["cup-line-duotone-1"] = "rbxassetid://136951236221327",
    	["cup-linear"] = "rbxassetid://101051091422909",
    	["cup-linear-1"] = "rbxassetid://114839403116043",
    	["cup-music-bold"] = "rbxassetid://126100709562505",
    	["cup-music-bold-duotone"] = "rbxassetid://118179005341476",
    	["cup-music-broken"] = "rbxassetid://81451749063322",
    	["cup-music-line-duotone"] = "rbxassetid://72302607431646",
    	["cup-music-linear"] = "rbxassetid://128738947472829",
    	["cup-music-outline"] = "rbxassetid://135697466317657",
    	["cup-outline"] = "rbxassetid://110736788658733",
    	["cup-outline-1"] = "rbxassetid://89444214223832",
    	["cup-paper-bold"] = "rbxassetid://84717823163319",
    	["cup-paper-bold-duotone"] = "rbxassetid://120573949246063",
    	["cup-paper-broken"] = "rbxassetid://89601548648778",
    	["cup-paper-line-duotone"] = "rbxassetid://76437953620238",
    	["cup-paper-linear"] = "rbxassetid://111929479129834",
    	["cup-paper-outline"] = "rbxassetid://135758775100187",
    	["cup-star-bold"] = "rbxassetid://124495333491453",
    	["cup-star-bold-duotone"] = "rbxassetid://107099402233053",
    	["cup-star-broken"] = "rbxassetid://73927921474611",
    	["cup-star-line-duotone"] = "rbxassetid://116335228497180",
    	["cup-star-linear"] = "rbxassetid://111453583163617",
    	["cup-star-outline"] = "rbxassetid://114288610238441",
    	["cursor-bold"] = "rbxassetid://82682091622365",
    	["cursor-bold-duotone"] = "rbxassetid://76995408522794",
    	["cursor-broken"] = "rbxassetid://120967383007725",
    	["cursor-line-duotone"] = "rbxassetid://81183452667624",
    	["cursor-linear"] = "rbxassetid://86545848910311",
    	["cursor-outline"] = "rbxassetid://74135384716602",
    	["cursor-square-bold"] = "rbxassetid://90390554022785",
    	["cursor-square-bold-duotone"] = "rbxassetid://127963397151089",
    	["cursor-square-broken"] = "rbxassetid://125171630832447",
    	["cursor-square-line-duotone"] = "rbxassetid://115712985425746",
    	["cursor-square-linear"] = "rbxassetid://130999137896641",
    	["cursor-square-outline"] = "rbxassetid://71294227522736",
    	["danger-bold"] = "rbxassetid://112161288264181",
    	["danger-bold-duotone"] = "rbxassetid://119651283722501",
    	["danger-broken"] = "rbxassetid://128687045046394",
    	["danger-circle-bold"] = "rbxassetid://118792892342823",
    	["danger-circle-bold-duotone"] = "rbxassetid://81131105142874",
    	["danger-circle-broken"] = "rbxassetid://137354149424410",
    	["danger-circle-line-duotone"] = "rbxassetid://70711270393926",
    	["danger-circle-linear"] = "rbxassetid://92131163777941",
    	["danger-circle-outline"] = "rbxassetid://114586707089205",
    	["danger-line-duotone"] = "rbxassetid://134837355174212",
    	["danger-linear"] = "rbxassetid://139497643685585",
    	["danger-outline"] = "rbxassetid://92302923824962",
    	["danger-square-bold"] = "rbxassetid://82318061319530",
    	["danger-square-bold-duotone"] = "rbxassetid://121601954649393",
    	["danger-square-broken"] = "rbxassetid://104047382581324",
    	["danger-square-line-duotone"] = "rbxassetid://71926324946127",
    	["danger-square-linear"] = "rbxassetid://122701068528288",
    	["danger-square-outline"] = "rbxassetid://126117710551626",
    	["danger-triangle-bold"] = "rbxassetid://111725057016862",
    	["danger-triangle-bold-duotone"] = "rbxassetid://99435569679708",
    	["danger-triangle-broken"] = "rbxassetid://107859193403224",
    	["danger-triangle-line-duotone"] = "rbxassetid://123727722203119",
    	["danger-triangle-linear"] = "rbxassetid://84504728099562",
    	["danger-triangle-outline"] = "rbxassetid://109823738696405",
    	["database-bold"] = "rbxassetid://114209748010261",
    	["database-bold-duotone"] = "rbxassetid://99797210152439",
    	["database-broken"] = "rbxassetid://95001080101595",
    	["database-line-duotone"] = "rbxassetid://107603617075287",
    	["database-linear"] = "rbxassetid://82892211900244",
    	["database-outline"] = "rbxassetid://123783295036985",
    	["delivery-bold"] = "rbxassetid://140037605911561",
    	["delivery-bold-duotone"] = "rbxassetid://79053804846791",
    	["delivery-broken"] = "rbxassetid://119252775841427",
    	["delivery-line-duotone"] = "rbxassetid://100046061013760",
    	["delivery-linear"] = "rbxassetid://110294701228278",
    	["delivery-outline"] = "rbxassetid://108619882980470",
    	["devices-bold"] = "rbxassetid://124420224859502",
    	["devices-bold-duotone"] = "rbxassetid://90658635493477",
    	["devices-broken"] = "rbxassetid://101705886428765",
    	["devices-line-duotone"] = "rbxassetid://70540744174094",
    	["devices-linear"] = "rbxassetid://107337283560966",
    	["devices-outline"] = "rbxassetid://132130839225164",
    	["diagram-down-bold"] = "rbxassetid://125656875303554",
    	["diagram-down-bold-duotone"] = "rbxassetid://86137955793423",
    	["diagram-down-broken"] = "rbxassetid://94418415532457",
    	["diagram-down-line-duotone"] = "rbxassetid://113949699772190",
    	["diagram-down-linear"] = "rbxassetid://100539136648580",
    	["diagram-down-outline"] = "rbxassetid://117440868862507",
    	["diagram-up-bold"] = "rbxassetid://136990905295365",
    	["diagram-up-bold-duotone"] = "rbxassetid://125748601003291",
    	["diagram-up-broken"] = "rbxassetid://130806206084451",
    	["diagram-up-line-duotone"] = "rbxassetid://115646138656013",
    	["diagram-up-linear"] = "rbxassetid://136885197428471",
    	["diagram-up-outline"] = "rbxassetid://104634481800023",
    	["dialog-2-bold"] = "rbxassetid://139285095589548",
    	["dialog-2-bold-duotone"] = "rbxassetid://136704464603920",
    	["dialog-2-broken"] = "rbxassetid://83713147580879",
    	["dialog-2-line-duotone"] = "rbxassetid://118333213198980",
    	["dialog-2-linear"] = "rbxassetid://92602729629148",
    	["dialog-2-outline"] = "rbxassetid://129337538032372",
    	["dialog-bold"] = "rbxassetid://99959135295831",
    	["dialog-bold-duotone"] = "rbxassetid://86213693537796",
    	["dialog-broken"] = "rbxassetid://101216980048002",
    	["dialog-line-duotone"] = "rbxassetid://92438859350409",
    	["dialog-linear"] = "rbxassetid://104886023067756",
    	["dialog-outline"] = "rbxassetid://73456495925407",
    	["diploma-bold"] = "rbxassetid://139231126691097",
    	["diploma-bold-duotone"] = "rbxassetid://116246801897922",
    	["diploma-broken"] = "rbxassetid://85178037588087",
    	["diploma-line-duotone"] = "rbxassetid://136962860554009",
    	["diploma-linear"] = "rbxassetid://126622664475467",
    	["diploma-outline"] = "rbxassetid://89014858898713",
    	["diploma-verified-bold"] = "rbxassetid://130406838686147",
    	["diploma-verified-bold-duotone"] = "rbxassetid://105118525477793",
    	["diploma-verified-broken"] = "rbxassetid://94878648918668",
    	["diploma-verified-line-duotone"] = "rbxassetid://89653205810320",
    	["diploma-verified-linear"] = "rbxassetid://104458431640923",
    	["diploma-verified-outline"] = "rbxassetid://124537212503002",
    	["diskette-bold"] = "rbxassetid://100311085528798",
    	["diskette-bold-duotone"] = "rbxassetid://131486348689723",
    	["diskette-broken"] = "rbxassetid://110950484506196",
    	["diskette-line-duotone"] = "rbxassetid://98759071765500",
    	["diskette-linear"] = "rbxassetid://102474155591884",
    	["diskette-outline"] = "rbxassetid://103932434170601",
    	["dislike-bold"] = "rbxassetid://132142104138836",
    	["dislike-bold-duotone"] = "rbxassetid://112583467455516",
    	["dislike-broken"] = "rbxassetid://120957498806987",
    	["dislike-line-duotone"] = "rbxassetid://97284912215323",
    	["dislike-linear"] = "rbxassetid://90151548302891",
    	["dislike-outline"] = "rbxassetid://86262823110593",
    	["display-bold"] = "rbxassetid://80243112979186",
    	["display-bold-duotone"] = "rbxassetid://86232405334050",
    	["display-broken"] = "rbxassetid://77908122403769",
    	["display-line-duotone"] = "rbxassetid://123122337038594",
    	["display-linear"] = "rbxassetid://119821002798229",
    	["display-outline"] = "rbxassetid://115220778184696",
    	["dna-bold"] = "rbxassetid://127305757862516",
    	["dna-bold-duotone"] = "rbxassetid://100749683457223",
    	["dna-broken"] = "rbxassetid://106640049986946",
    	["dna-line-duotone"] = "rbxassetid://127741586936233",
    	["dna-linear"] = "rbxassetid://135495414466931",
    	["dna-outline"] = "rbxassetid://92625926449605",
    	["document-add-bold"] = "rbxassetid://85660538990593",
    	["document-add-bold-duotone"] = "rbxassetid://121968451773234",
    	["document-add-broken"] = "rbxassetid://101842840672551",
    	["document-add-line-duotone"] = "rbxassetid://80163525907145",
    	["document-add-linear"] = "rbxassetid://112635806090858",
    	["document-add-outline"] = "rbxassetid://137473247410168",
    	["document-bold"] = "rbxassetid://123316544392029",
    	["document-bold-1"] = "rbxassetid://106321518245346",
    	["document-bold-duotone"] = "rbxassetid://93554609252011",
    	["document-bold-duotone-1"] = "rbxassetid://106479741245650",
    	["document-broken"] = "rbxassetid://84132213205053",
    	["document-broken-1"] = "rbxassetid://104124971559274",
    	["document-line-duotone"] = "rbxassetid://95040216478134",
    	["document-line-duotone-1"] = "rbxassetid://104967565383385",
    	["document-linear"] = "rbxassetid://87480330652594",
    	["document-linear-1"] = "rbxassetid://131429557615286",
    	["document-medicine-bold"] = "rbxassetid://130572522666406",
    	["document-medicine-bold-duotone"] = "rbxassetid://115381563689102",
    	["document-medicine-broken"] = "rbxassetid://90236550221194",
    	["document-medicine-line-duotone"] = "rbxassetid://110169012669419",
    	["document-medicine-linear"] = "rbxassetid://82779005929278",
    	["document-medicine-outline"] = "rbxassetid://134965977400880",
    	["document-outline"] = "rbxassetid://89719023018490",
    	["document-outline-1"] = "rbxassetid://70897942602484",
    	["document-text-bold"] = "rbxassetid://128687888230039",
    	["document-text-bold-duotone"] = "rbxassetid://122723665140989",
    	["document-text-broken"] = "rbxassetid://104197259684208",
    	["document-text-line-duotone"] = "rbxassetid://112441556279859",
    	["document-text-linear"] = "rbxassetid://79199940500650",
    	["document-text-outline"] = "rbxassetid://82628800588324",
    	["documents-bold"] = "rbxassetid://108349883969750",
    	["documents-bold-duotone"] = "rbxassetid://132097816367908",
    	["documents-broken"] = "rbxassetid://109023563644748",
    	["documents-line-duotone"] = "rbxassetid://113238376056933",
    	["documents-linear"] = "rbxassetid://73862427430463",
    	["documents-minimalistic-bold"] = "rbxassetid://81144114750181",
    	["documents-minimalistic-bold-duotone"] = "rbxassetid://73538460709853",
    	["documents-minimalistic-broken"] = "rbxassetid://102683477207912",
    	["documents-minimalistic-line-duotone"] = "rbxassetid://130511144984870",
    	["documents-minimalistic-linear"] = "rbxassetid://110874365632982",
    	["documents-minimalistic-outline"] = "rbxassetid://92509545367992",
    	["documents-outline"] = "rbxassetid://100832111043166",
    	["dollar-bold"] = "rbxassetid://97783947612153",
    	["dollar-bold-duotone"] = "rbxassetid://109115709640829",
    	["dollar-broken"] = "rbxassetid://92900734471684",
    	["dollar-line-duotone"] = "rbxassetid://71420735492684",
    	["dollar-linear"] = "rbxassetid://138532290297611",
    	["dollar-minimalistic-bold"] = "rbxassetid://127871092309095",
    	["dollar-minimalistic-bold-duotone"] = "rbxassetid://80546520180170",
    	["dollar-minimalistic-broken"] = "rbxassetid://125794248352904",
    	["dollar-minimalistic-line-duotone"] = "rbxassetid://87185386779178",
    	["dollar-minimalistic-linear"] = "rbxassetid://79436285510159",
    	["dollar-minimalistic-outline"] = "rbxassetid://119604157500358",
    	["dollar-outline"] = "rbxassetid://93591469789865",
    	["donut-bitten-bold"] = "rbxassetid://112452617245651",
    	["donut-bitten-bold-duotone"] = "rbxassetid://118049915824223",
    	["donut-bitten-broken"] = "rbxassetid://115398994605264",
    	["donut-bitten-line-duotone"] = "rbxassetid://89205683156662",
    	["donut-bitten-linear"] = "rbxassetid://139332259998050",
    	["donut-bitten-outline"] = "rbxassetid://89366591100345",
    	["donut-bold"] = "rbxassetid://109027053388168",
    	["donut-bold-duotone"] = "rbxassetid://132473322966942",
    	["donut-broken"] = "rbxassetid://83429119675203",
    	["donut-line-duotone"] = "rbxassetid://125154969652130",
    	["donut-linear"] = "rbxassetid://84461075987495",
    	["donut-outline"] = "rbxassetid://124792781204713",
    	["double-alt-arrow-down-bold"] = "rbxassetid://110142860319495",
    	["double-alt-arrow-down-bold-duotone"] = "rbxassetid://74861651965943",
    	["double-alt-arrow-down-broken"] = "rbxassetid://134189036009138",
    	["double-alt-arrow-down-line-duotone"] = "rbxassetid://138946115556743",
    	["double-alt-arrow-down-linear"] = "rbxassetid://117516191153513",
    	["double-alt-arrow-down-outline"] = "rbxassetid://93985728508595",
    	["double-alt-arrow-left-bold"] = "rbxassetid://134102529597514",
    	["double-alt-arrow-left-bold-duotone"] = "rbxassetid://96776692590258",
    	["double-alt-arrow-left-broken"] = "rbxassetid://103217998481919",
    	["double-alt-arrow-left-line-duotone"] = "rbxassetid://110620072861010",
    	["double-alt-arrow-left-linear"] = "rbxassetid://126726129116939",
    	["double-alt-arrow-left-outline"] = "rbxassetid://124042893711610",
    	["double-alt-arrow-right-bold"] = "rbxassetid://128999993985654",
    	["double-alt-arrow-right-bold-duotone"] = "rbxassetid://88880129713469",
    	["double-alt-arrow-right-broken"] = "rbxassetid://110779697216712",
    	["double-alt-arrow-right-line-duotone"] = "rbxassetid://82871438158949",
    	["double-alt-arrow-right-linear"] = "rbxassetid://117762483117088",
    	["double-alt-arrow-right-outline"] = "rbxassetid://114912566299186",
    	["double-alt-arrow-up-bold"] = "rbxassetid://93701167749989",
    	["double-alt-arrow-up-bold-duotone"] = "rbxassetid://109129965162120",
    	["double-alt-arrow-up-broken"] = "rbxassetid://106928558821899",
    	["double-alt-arrow-up-line-duotone"] = "rbxassetid://110154168390488",
    	["double-alt-arrow-up-linear"] = "rbxassetid://111988073731937",
    	["double-alt-arrow-up-outline"] = "rbxassetid://85675998910775",
    	["download-bold"] = "rbxassetid://134000208220434",
    	["download-bold-duotone"] = "rbxassetid://99042652972630",
    	["download-broken"] = "rbxassetid://115651298821707",
    	["download-line-duotone"] = "rbxassetid://78638876423991",
    	["download-linear"] = "rbxassetid://102882499545345",
    	["download-minimalistic-bold"] = "rbxassetid://89402481288235",
    	["download-minimalistic-bold-duotone"] = "rbxassetid://107985210734947",
    	["download-minimalistic-broken"] = "rbxassetid://114590043510413",
    	["download-minimalistic-line-duotone"] = "rbxassetid://100667947579200",
    	["download-minimalistic-linear"] = "rbxassetid://113502572441233",
    	["download-minimalistic-outline"] = "rbxassetid://130906221276796",
    	["download-outline"] = "rbxassetid://122645145224349",
    	["download-square-bold"] = "rbxassetid://111797411162104",
    	["download-square-bold-duotone"] = "rbxassetid://104694969402380",
    	["download-square-broken"] = "rbxassetid://127965543582346",
    	["download-square-line-duotone"] = "rbxassetid://98492772422072",
    	["download-square-linear"] = "rbxassetid://72031667183922",
    	["download-square-outline"] = "rbxassetid://116439110186803",
    	["download-twice-square-bold"] = "rbxassetid://139792271820922",
    	["download-twice-square-bold-duotone"] = "rbxassetid://83303592838549",
    	["download-twice-square-broken"] = "rbxassetid://83744876009450",
    	["download-twice-square-line-duotone"] = "rbxassetid://84555168420915",
    	["download-twice-square-linear"] = "rbxassetid://136497581904980",
    	["download-twice-square-outline"] = "rbxassetid://121636970008712",
    	["dropper-2-bold"] = "rbxassetid://122172977394880",
    	["dropper-2-bold-duotone"] = "rbxassetid://94200377440297",
    	["dropper-2-broken"] = "rbxassetid://76064748312192",
    	["dropper-2-line-duotone"] = "rbxassetid://109715427931374",
    	["dropper-2-linear"] = "rbxassetid://126807623444991",
    	["dropper-2-outline"] = "rbxassetid://130495928272642",
    	["dropper-3-bold"] = "rbxassetid://124580567828410",
    	["dropper-3-bold-duotone"] = "rbxassetid://105860712993635",
    	["dropper-3-broken"] = "rbxassetid://108163917141635",
    	["dropper-3-line-duotone"] = "rbxassetid://97217904980622",
    	["dropper-3-linear"] = "rbxassetid://139426158642215",
    	["dropper-3-outline"] = "rbxassetid://94573375522891",
    	["dropper-bold"] = "rbxassetid://95034602778070",
    	["dropper-bold-duotone"] = "rbxassetid://112860727551681",
    	["dropper-broken"] = "rbxassetid://107466726897586",
    	["dropper-line-duotone"] = "rbxassetid://117297385924027",
    	["dropper-linear"] = "rbxassetid://138584758918074",
    	["dropper-minimalistic-2-bold"] = "rbxassetid://113481866487508",
    	["dropper-minimalistic-2-bold-duotone"] = "rbxassetid://136291854048143",
    	["dropper-minimalistic-2-broken"] = "rbxassetid://98957518617114",
    	["dropper-minimalistic-2-line-duotone"] = "rbxassetid://134940306473998",
    	["dropper-minimalistic-2-linear"] = "rbxassetid://71405051205378",
    	["dropper-minimalistic-2-outline"] = "rbxassetid://120335643080290",
    	["dropper-minimalistic-bold"] = "rbxassetid://105304005315158",
    	["dropper-minimalistic-bold-duotone"] = "rbxassetid://100025299001459",
    	["dropper-minimalistic-broken"] = "rbxassetid://104884094060918",
    	["dropper-minimalistic-line-duotone"] = "rbxassetid://76572669467506",
    	["dropper-minimalistic-linear"] = "rbxassetid://75445207760641",
    	["dropper-minimalistic-outline"] = "rbxassetid://108904854733911",
    	["dropper-outline"] = "rbxassetid://118686123987958",
    	["dumbbell-bold"] = "rbxassetid://99013666612743",
    	["dumbbell-bold-duotone"] = "rbxassetid://138226524910516",
    	["dumbbell-broken"] = "rbxassetid://116617188814102",
    	["dumbbell-large-bold"] = "rbxassetid://129379737580753",
    	["dumbbell-large-bold-duotone"] = "rbxassetid://72663520789849",
    	["dumbbell-large-broken"] = "rbxassetid://85942392563539",
    	["dumbbell-large-line-duotone"] = "rbxassetid://81921487954245",
    	["dumbbell-large-linear"] = "rbxassetid://104725191095634",
    	["dumbbell-large-minimalistic-bold"] = "rbxassetid://125799367645122",
    	["dumbbell-large-minimalistic-bold-duotone"] = "rbxassetid://101013826041029",
    	["dumbbell-large-minimalistic-broken"] = "rbxassetid://73775632762646",
    	["dumbbell-large-minimalistic-line-duotone"] = "rbxassetid://102684919951180",
    	["dumbbell-large-minimalistic-linear"] = "rbxassetid://117217232367047",
    	["dumbbell-large-minimalistic-outline"] = "rbxassetid://98416741359048",
    	["dumbbell-large-outline"] = "rbxassetid://125662618869253",
    	["dumbbell-line-duotone"] = "rbxassetid://106695741510055",
    	["dumbbell-linear"] = "rbxassetid://116431090545247",
    	["dumbbell-outline"] = "rbxassetid://113308478125544",
    	["dumbbell-small-bold"] = "rbxassetid://137874993693288",
    	["dumbbell-small-bold-duotone"] = "rbxassetid://118432840389672",
    	["dumbbell-small-broken"] = "rbxassetid://100242011393692",
    	["dumbbell-small-line-duotone"] = "rbxassetid://127459169686528",
    	["dumbbell-small-linear"] = "rbxassetid://116524699083664",
    	["dumbbell-small-outline"] = "rbxassetid://88956090311221",
    	["dumbbells-2-bold"] = "rbxassetid://118805487781369",
    	["dumbbells-2-bold-duotone"] = "rbxassetid://99124152996359",
    	["dumbbells-2-broken"] = "rbxassetid://111312449446311",
    	["dumbbells-2-line-duotone"] = "rbxassetid://87587008592084",
    	["dumbbells-2-linear"] = "rbxassetid://93841277441242",
    	["dumbbells-2-outline"] = "rbxassetid://89636446903254",
    	["dumbbells-bold"] = "rbxassetid://138680867501464",
    	["dumbbells-bold-duotone"] = "rbxassetid://100253080853807",
    	["dumbbells-broken"] = "rbxassetid://105995821644450",
    	["dumbbells-line-duotone"] = "rbxassetid://100515319390023",
    	["dumbbells-linear"] = "rbxassetid://76772278441260",
    	["dumbbells-outline"] = "rbxassetid://116751740758011",
    	["earth-bold"] = "rbxassetid://118828820753007",
    	["earth-bold-duotone"] = "rbxassetid://72971689125862",
    	["earth-broken"] = "rbxassetid://132518824958123",
    	["earth-line-duotone"] = "rbxassetid://105541951907382",
    	["earth-linear"] = "rbxassetid://114096061793100",
    	["earth-outline"] = "rbxassetid://116304656844138",
    	["electric-refueling-bold"] = "rbxassetid://84674148682167",
    	["electric-refueling-linear"] = "rbxassetid://93154378934884",
    	["emoji-funny-circle-bold"] = "rbxassetid://74881798923771",
    	["emoji-funny-circle-bold-duotone"] = "rbxassetid://80729371131098",
    	["emoji-funny-circle-broken"] = "rbxassetid://70754785311045",
    	["emoji-funny-circle-line-duotone"] = "rbxassetid://123580320231128",
    	["emoji-funny-circle-linear"] = "rbxassetid://140249937937630",
    	["emoji-funny-circle-outline"] = "rbxassetid://132984714141620",
    	["emoji-funny-square-bold"] = "rbxassetid://97591093867810",
    	["emoji-funny-square-bold-duotone"] = "rbxassetid://126454622743535",
    	["emoji-funny-square-broken"] = "rbxassetid://113865874540015",
    	["emoji-funny-square-line-duotone"] = "rbxassetid://111689418406815",
    	["emoji-funny-square-linear"] = "rbxassetid://119366033053458",
    	["emoji-funny-square-outline"] = "rbxassetid://94943032229588",
    	["end-call-bold"] = "rbxassetid://122558856077685",
    	["end-call-bold-duotone"] = "rbxassetid://122862401101283",
    	["end-call-broken"] = "rbxassetid://80637172822946",
    	["end-call-line-duotone"] = "rbxassetid://72910933128195",
    	["end-call-linear"] = "rbxassetid://102253973633618",
    	["end-call-outline"] = "rbxassetid://85298263861166",
    	["end-call-rounded-bold"] = "rbxassetid://139336956699060",
    	["end-call-rounded-bold-duotone"] = "rbxassetid://100305606759804",
    	["end-call-rounded-broken"] = "rbxassetid://74392219910694",
    	["end-call-rounded-line-duotone"] = "rbxassetid://124983667623332",
    	["end-call-rounded-linear"] = "rbxassetid://111314226747471",
    	["end-call-rounded-outline"] = "rbxassetid://108386351964515",
    	["eraser-bold"] = "rbxassetid://81891662012233",
    	["eraser-bold-duotone"] = "rbxassetid://123903610368707",
    	["eraser-broken"] = "rbxassetid://126617765244811",
    	["eraser-circle-bold"] = "rbxassetid://102446186065177",
    	["eraser-circle-bold-duotone"] = "rbxassetid://125977922678171",
    	["eraser-circle-broken"] = "rbxassetid://127522933111933",
    	["eraser-circle-line-duotone"] = "rbxassetid://113909156116055",
    	["eraser-circle-linear"] = "rbxassetid://72335131334982",
    	["eraser-circle-outline"] = "rbxassetid://130520044427709",
    	["eraser-line-duotone"] = "rbxassetid://72209367891137",
    	["eraser-linear"] = "rbxassetid://106430799834894",
    	["eraser-outline"] = "rbxassetid://78782061886894",
    	["eraser-square-bold"] = "rbxassetid://137934453495044",
    	["eraser-square-bold-duotone"] = "rbxassetid://121474653687237",
    	["eraser-square-broken"] = "rbxassetid://118780420739943",
    	["eraser-square-line-duotone"] = "rbxassetid://120320661547298",
    	["eraser-square-linear"] = "rbxassetid://80680054443991",
    	["eraser-square-outline"] = "rbxassetid://98835206566643",
    	["euro-bold"] = "rbxassetid://113440281886093",
    	["euro-bold-duotone"] = "rbxassetid://113134303184294",
    	["euro-broken"] = "rbxassetid://86956705502435",
    	["euro-line-duotone"] = "rbxassetid://117429391978023",
    	["euro-linear"] = "rbxassetid://74806316059322",
    	["euro-outline"] = "rbxassetid://123731308519626",
    	["exit-bold"] = "rbxassetid://72009230196343",
    	["exit-bold-duotone"] = "rbxassetid://73117402515775",
    	["exit-broken"] = "rbxassetid://80262278987036",
    	["exit-line-duotone"] = "rbxassetid://95996943346195",
    	["exit-linear"] = "rbxassetid://105821499776279",
    	["exit-outline"] = "rbxassetid://129618813160886",
    	["explicit-bold"] = "rbxassetid://134015297159246",
    	["explicit-bold-duotone"] = "rbxassetid://98784707685794",
    	["explicit-broken"] = "rbxassetid://83956243203008",
    	["explicit-line-duotone"] = "rbxassetid://94508457160981",
    	["explicit-linear"] = "rbxassetid://85567508251262",
    	["explicit-outline"] = "rbxassetid://109799379520477",
    	["export-bold"] = "rbxassetid://93612238113575",
    	["export-bold-duotone"] = "rbxassetid://130238306757293",
    	["export-broken"] = "rbxassetid://90660535724418",
    	["export-line-duotone"] = "rbxassetid://111884642525588",
    	["export-linear"] = "rbxassetid://139464289982069",
    	["export-outline"] = "rbxassetid://114775860531365",
    	["expressionless-circle-bold"] = "rbxassetid://83604478908797",
    	["expressionless-circle-bold-duotone"] = "rbxassetid://124191905309820",
    	["expressionless-circle-broken"] = "rbxassetid://122294216695084",
    	["expressionless-circle-line-duotone"] = "rbxassetid://131559033390075",
    	["expressionless-circle-linear"] = "rbxassetid://79005597992782",
    	["expressionless-circle-outline"] = "rbxassetid://139175563067354",
    	["expressionless-square-bold"] = "rbxassetid://129613755858803",
    	["expressionless-square-bold-duotone"] = "rbxassetid://71759815009445",
    	["expressionless-square-broken"] = "rbxassetid://134535384731342",
    	["expressionless-square-line-duotone"] = "rbxassetid://105796865185611",
    	["expressionless-square-linear"] = "rbxassetid://96799093958608",
    	["expressionless-square-outline"] = "rbxassetid://131673734696720",
    	["eye-bold"] = "rbxassetid://111781708911036",
    	["eye-bold-duotone"] = "rbxassetid://81490767686611",
    	["eye-broken"] = "rbxassetid://90598662321658",
    	["eye-closed-bold"] = "rbxassetid://73923823679473",
    	["eye-closed-bold-duotone"] = "rbxassetid://108464671443029",
    	["eye-closed-broken"] = "rbxassetid://114321442980605",
    	["eye-closed-line-duotone"] = "rbxassetid://80798005862698",
    	["eye-closed-linear"] = "rbxassetid://101844240218072",
    	["eye-closed-outline"] = "rbxassetid://125692455259053",
    	["eye-line-duotone"] = "rbxassetid://110059418465428",
    	["eye-linear"] = "rbxassetid://93071139016241",
    	["eye-outline"] = "rbxassetid://100941689800124",
    	["eye-scan-bold"] = "rbxassetid://93312767093758",
    	["eye-scan-bold-duotone"] = "rbxassetid://130796688541105",
    	["eye-scan-broken"] = "rbxassetid://115269945926325",
    	["eye-scan-line-duotone"] = "rbxassetid://82079701331464",
    	["eye-scan-linear"] = "rbxassetid://120904523330294",
    	["eye-scan-outline"] = "rbxassetid://78177819776366",
    	["face-scan-circle-bold"] = "rbxassetid://129962308796632",
    	["face-scan-circle-bold-duotone"] = "rbxassetid://120101543559781",
    	["face-scan-circle-broken"] = "rbxassetid://102951939770637",
    	["face-scan-circle-line-duotone"] = "rbxassetid://129756478575958",
    	["face-scan-circle-linear"] = "rbxassetid://117460966630658",
    	["face-scan-circle-outline"] = "rbxassetid://116664750955861",
    	["face-scan-square-bold"] = "rbxassetid://90370720213514",
    	["face-scan-square-bold-duotone"] = "rbxassetid://102709417848628",
    	["face-scan-square-broken"] = "rbxassetid://78002538418574",
    	["face-scan-square-line-duotone"] = "rbxassetid://123428956320230",
    	["face-scan-square-linear"] = "rbxassetid://97005221856225",
    	["face-scan-square-outline"] = "rbxassetid://78737611908143",
    	["facemask-circle-bold"] = "rbxassetid://88290637999492",
    	["facemask-circle-bold-duotone"] = "rbxassetid://87278358804485",
    	["facemask-circle-broken"] = "rbxassetid://112753646303602",
    	["facemask-circle-line-duotone"] = "rbxassetid://99173749664196",
    	["facemask-circle-linear"] = "rbxassetid://131928336240623",
    	["facemask-circle-outline"] = "rbxassetid://106476611597411",
    	["facemask-square-bold"] = "rbxassetid://91607748646701",
    	["facemask-square-bold-duotone"] = "rbxassetid://127675222728613",
    	["facemask-square-broken"] = "rbxassetid://137310697882197",
    	["facemask-square-line-duotone"] = "rbxassetid://91948609424642",
    	["facemask-square-linear"] = "rbxassetid://104372588341014",
    	["facemask-square-outline"] = "rbxassetid://135870557293927",
    	["feed-bold"] = "rbxassetid://115328363898492",
    	["feed-bold-duotone"] = "rbxassetid://114340965335186",
    	["feed-broken"] = "rbxassetid://83704921844879",
    	["feed-line-duotone"] = "rbxassetid://137672852439675",
    	["feed-linear"] = "rbxassetid://117114611876552",
    	["feed-outline"] = "rbxassetid://72304181689796",
    	["ferris-wheel-bold"] = "rbxassetid://80185923710401",
    	["ferris-wheel-bold-duotone"] = "rbxassetid://85440526185267",
    	["ferris-wheel-broken"] = "rbxassetid://118270789445126",
    	["ferris-wheel-line-duotone"] = "rbxassetid://107784329973908",
    	["ferris-wheel-linear"] = "rbxassetid://103271876259966",
    	["ferris-wheel-outline"] = "rbxassetid://95687877593621",
    	["figma-bold"] = "rbxassetid://113267603186495",
    	["figma-bold-duotone"] = "rbxassetid://97180879795523",
    	["figma-broken"] = "rbxassetid://97962262030939",
    	["figma-file-bold"] = "rbxassetid://104470582924155",
    	["figma-file-bold-duotone"] = "rbxassetid://71474085207148",
    	["figma-file-broken"] = "rbxassetid://82179583011926",
    	["figma-file-line-duotone"] = "rbxassetid://134326280909105",
    	["figma-file-linear"] = "rbxassetid://122979171995373",
    	["figma-file-outline"] = "rbxassetid://103268247305969",
    	["figma-line-duotone"] = "rbxassetid://128333245071635",
    	["figma-linear"] = "rbxassetid://108636940495886",
    	["figma-outline"] = "rbxassetid://80331649453811",
    	["file-bold"] = "rbxassetid://127490106584938",
    	["file-bold-duotone"] = "rbxassetid://122853880054941",
    	["file-broken"] = "rbxassetid://121379664201347",
    	["file-check-bold"] = "rbxassetid://88089106708652",
    	["file-check-bold-duotone"] = "rbxassetid://80004382746462",
    	["file-check-broken"] = "rbxassetid://129561565970907",
    	["file-check-line-duotone"] = "rbxassetid://82258349006036",
    	["file-check-linear"] = "rbxassetid://102375026983236",
    	["file-check-outline"] = "rbxassetid://100078989033736",
    	["file-corrupted-bold"] = "rbxassetid://123534996424728",
    	["file-corrupted-bold-duotone"] = "rbxassetid://114158917376730",
    	["file-corrupted-broken"] = "rbxassetid://79425851527880",
    	["file-corrupted-line-duotone"] = "rbxassetid://114361656123028",
    	["file-corrupted-linear"] = "rbxassetid://112687346334482",
    	["file-corrupted-outline"] = "rbxassetid://73646818764697",
    	["file-download-bold"] = "rbxassetid://109242258818317",
    	["file-download-bold-duotone"] = "rbxassetid://99649770614124",
    	["file-download-broken"] = "rbxassetid://84335669795506",
    	["file-download-line-duotone"] = "rbxassetid://72453849027433",
    	["file-download-linear"] = "rbxassetid://116110362115369",
    	["file-download-outline"] = "rbxassetid://116639865090154",
    	["file-favourite-bold"] = "rbxassetid://80480987060536",
    	["file-favourite-bold-duotone"] = "rbxassetid://71920660498375",
    	["file-favourite-broken"] = "rbxassetid://140074594975408",
    	["file-favourite-line-duotone"] = "rbxassetid://138527374567767",
    	["file-favourite-linear"] = "rbxassetid://134389824303143",
    	["file-favourite-outline"] = "rbxassetid://90334595757988",
    	["file-left-bold"] = "rbxassetid://133611650958098",
    	["file-left-bold-duotone"] = "rbxassetid://132650758943220",
    	["file-left-broken"] = "rbxassetid://123768760888545",
    	["file-left-line-duotone"] = "rbxassetid://136303320217772",
    	["file-left-linear"] = "rbxassetid://112574106961243",
    	["file-left-outline"] = "rbxassetid://85819175806157",
    	["file-line-duotone"] = "rbxassetid://89003108425313",
    	["file-linear"] = "rbxassetid://136816437545923",
    	["file-outline"] = "rbxassetid://95781058958923",
    	["file-remove-bold"] = "rbxassetid://136407677886932",
    	["file-remove-bold-duotone"] = "rbxassetid://71576517801936",
    	["file-remove-broken"] = "rbxassetid://94174851715099",
    	["file-remove-line-duotone"] = "rbxassetid://132247033586098",
    	["file-remove-linear"] = "rbxassetid://81887151019113",
    	["file-remove-outline"] = "rbxassetid://140438464807412",
    	["file-right-bold"] = "rbxassetid://117014199354662",
    	["file-right-bold-duotone"] = "rbxassetid://132304449000158",
    	["file-right-broken"] = "rbxassetid://92755775842986",
    	["file-right-line-duotone"] = "rbxassetid://134691616714631",
    	["file-right-linear"] = "rbxassetid://134319064922513",
    	["file-right-outline"] = "rbxassetid://95640169303743",
    	["file-send-bold"] = "rbxassetid://100302492978636",
    	["file-send-bold-duotone"] = "rbxassetid://78574640577721",
    	["file-send-broken"] = "rbxassetid://117541582441298",
    	["file-send-line-duotone"] = "rbxassetid://92997630594654",
    	["file-send-linear"] = "rbxassetid://70559594555652",
    	["file-send-outline"] = "rbxassetid://114535220409110",
    	["file-smile-bold"] = "rbxassetid://139433602139427",
    	["file-smile-bold-duotone"] = "rbxassetid://91134493740328",
    	["file-smile-broken"] = "rbxassetid://108933233612891",
    	["file-smile-line-duotone"] = "rbxassetid://80954156361704",
    	["file-smile-linear"] = "rbxassetid://110983921570635",
    	["file-smile-outline"] = "rbxassetid://101566621754491",
    	["file-text-bold"] = "rbxassetid://111955813704021",
    	["file-text-bold-duotone"] = "rbxassetid://129678879263925",
    	["file-text-broken"] = "rbxassetid://132856338857273",
    	["file-text-line-duotone"] = "rbxassetid://137970501990736",
    	["file-text-linear"] = "rbxassetid://93537225041770",
    	["file-text-outline"] = "rbxassetid://118664926580957",
    	["filter-bold"] = "rbxassetid://90067333688266",
    	["filter-bold-duotone"] = "rbxassetid://81919417864319",
    	["filter-broken"] = "rbxassetid://116313049286370",
    	["filter-line-duotone"] = "rbxassetid://104491554909752",
    	["filter-linear"] = "rbxassetid://121549568563199",
    	["filter-outline"] = "rbxassetid://90208001663162",
    	["filters-bold"] = "rbxassetid://84580916979375",
    	["filters-bold-duotone"] = "rbxassetid://109731191301014",
    	["filters-broken"] = "rbxassetid://123954174737552",
    	["filters-line-duotone"] = "rbxassetid://84467459296190",
    	["filters-linear"] = "rbxassetid://106668062715802",
    	["filters-outline"] = "rbxassetid://136651321895364",
    	["fire-bold"] = "rbxassetid://135755743158580",
    	["fire-bold-duotone"] = "rbxassetid://120730595514033",
    	["fire-broken"] = "rbxassetid://98810806247947",
    	["fire-line-duotone"] = "rbxassetid://110139660467987",
    	["fire-linear"] = "rbxassetid://95185774022524",
    	["fire-minimalistic-bold"] = "rbxassetid://112705408693172",
    	["fire-minimalistic-bold-duotone"] = "rbxassetid://120840967257254",
    	["fire-minimalistic-broken"] = "rbxassetid://116512074703850",
    	["fire-minimalistic-line-duotone"] = "rbxassetid://101100496388158",
    	["fire-minimalistic-linear"] = "rbxassetid://103409933007515",
    	["fire-minimalistic-outline"] = "rbxassetid://76962055371194",
    	["fire-outline"] = "rbxassetid://131760015213908",
    	["fire-square-bold"] = "rbxassetid://106629004615972",
    	["fire-square-bold-duotone"] = "rbxassetid://79456812050945",
    	["fire-square-broken"] = "rbxassetid://96831519245024",
    	["fire-square-line-duotone"] = "rbxassetid://91617614653914",
    	["fire-square-linear"] = "rbxassetid://102603844472804",
    	["fire-square-outline"] = "rbxassetid://140237270826915",
    	["flag-2-bold"] = "rbxassetid://111210658608794",
    	["flag-2-bold-duotone"] = "rbxassetid://110105579107342",
    	["flag-2-broken"] = "rbxassetid://96225832414166",
    	["flag-2-line-duotone"] = "rbxassetid://108305838757657",
    	["flag-2-linear"] = "rbxassetid://130715065578825",
    	["flag-2-outline"] = "rbxassetid://103960203663144",
    	["flag-bold"] = "rbxassetid://123419720240176",
    	["flag-bold-duotone"] = "rbxassetid://92726472190290",
    	["flag-broken"] = "rbxassetid://129524371891788",
    	["flag-line-duotone"] = "rbxassetid://99849917574886",
    	["flag-linear"] = "rbxassetid://78601236870633",
    	["flag-outline"] = "rbxassetid://74472970542812",
    	["flame-bold"] = "rbxassetid://136450031647569",
    	["flame-bold-duotone"] = "rbxassetid://136978818755982",
    	["flame-broken"] = "rbxassetid://124754896778718",
    	["flame-line-duotone"] = "rbxassetid://102453892989041",
    	["flame-linear"] = "rbxassetid://71778267927645",
    	["flame-outline"] = "rbxassetid://139810272208155",
    	["flash-drive-bold"] = "rbxassetid://105112605057571",
    	["flash-drive-bold-duotone"] = "rbxassetid://139947137765065",
    	["flash-drive-broken"] = "rbxassetid://89158655212620",
    	["flash-drive-line-duotone"] = "rbxassetid://139611254141704",
    	["flash-drive-linear"] = "rbxassetid://97986841834753",
    	["flash-drive-outline"] = "rbxassetid://129279682789435",
    	["flashlight-bold"] = "rbxassetid://124411885818533",
    	["flashlight-bold-duotone"] = "rbxassetid://126645291713775",
    	["flashlight-broken"] = "rbxassetid://76696974200804",
    	["flashlight-line-duotone"] = "rbxassetid://101366774130221",
    	["flashlight-linear"] = "rbxassetid://96074161943667",
    	["flashlight-on-bold"] = "rbxassetid://126279289380499",
    	["flashlight-on-bold-duotone"] = "rbxassetid://72170330002836",
    	["flashlight-on-broken"] = "rbxassetid://80415231343499",
    	["flashlight-on-line-duotone"] = "rbxassetid://99911728401985",
    	["flashlight-on-linear"] = "rbxassetid://104327893514348",
    	["flashlight-on-outline"] = "rbxassetid://79950909786359",
    	["flashlight-outline"] = "rbxassetid://91084882200314",
    	["flip-horizontal-bold"] = "rbxassetid://110549717309186",
    	["flip-horizontal-bold-duotone"] = "rbxassetid://131754948585625",
    	["flip-horizontal-broken"] = "rbxassetid://93637989956682",
    	["flip-horizontal-line-duotone"] = "rbxassetid://83023498314744",
    	["flip-horizontal-linear"] = "rbxassetid://73668783390192",
    	["flip-horizontal-outline"] = "rbxassetid://78097432329482",
    	["flip-vertical-bold"] = "rbxassetid://129757687665927",
    	["flip-vertical-bold-duotone"] = "rbxassetid://118549531467275",
    	["flip-vertical-broken"] = "rbxassetid://135431584884683",
    	["flip-vertical-line-duotone"] = "rbxassetid://73960011761963",
    	["flip-vertical-linear"] = "rbxassetid://140367751462435",
    	["flip-vertical-outline"] = "rbxassetid://102639972681513",
    	["floor-lamp-bold"] = "rbxassetid://138946048809299",
    	["floor-lamp-bold-duotone"] = "rbxassetid://89840586921857",
    	["floor-lamp-broken"] = "rbxassetid://80242166975434",
    	["floor-lamp-line-duotone"] = "rbxassetid://84301529569399",
    	["floor-lamp-linear"] = "rbxassetid://126921195882966",
    	["floor-lamp-minimalistic-bold"] = "rbxassetid://97386447919314",
    	["floor-lamp-minimalistic-bold-duotone"] = "rbxassetid://133137546289521",
    	["floor-lamp-minimalistic-broken"] = "rbxassetid://86309813203594",
    	["floor-lamp-minimalistic-line-duotone"] = "rbxassetid://82950059396071",
    	["floor-lamp-minimalistic-linear"] = "rbxassetid://99553569615709",
    	["floor-lamp-minimalistic-outline"] = "rbxassetid://81767162418320",
    	["floor-lamp-outline"] = "rbxassetid://108899904310049",
    	["fog-bold"] = "rbxassetid://86201042014464",
    	["fog-bold-duotone"] = "rbxassetid://83434738973570",
    	["fog-broken"] = "rbxassetid://104125065829661",
    	["fog-line-duotone"] = "rbxassetid://84775215809149",
    	["fog-linear"] = "rbxassetid://78737898359265",
    	["fog-outline"] = "rbxassetid://75847541099817",
    	["folder-2-bold"] = "rbxassetid://76034753816998",
    	["folder-2-bold-duotone"] = "rbxassetid://72013675486996",
    	["folder-2-broken"] = "rbxassetid://73550407943874",
    	["folder-2-line-duotone"] = "rbxassetid://82960349607855",
    	["folder-2-linear"] = "rbxassetid://81948801120502",
    	["folder-2-outline"] = "rbxassetid://91971667155588",
    	["folder-bold"] = "rbxassetid://101207683756324",
    	["folder-bold-duotone"] = "rbxassetid://109675455501592",
    	["folder-broken"] = "rbxassetid://99233272682930",
    	["folder-check-bold"] = "rbxassetid://121195076002492",
    	["folder-check-bold-duotone"] = "rbxassetid://131344559584322",
    	["folder-check-broken"] = "rbxassetid://87261301476234",
    	["folder-check-line-duotone"] = "rbxassetid://136083618819546",
    	["folder-check-linear"] = "rbxassetid://74289616759166",
    	["folder-check-outline"] = "rbxassetid://138504893630173",
    	["folder-cloud-bold"] = "rbxassetid://88660179875500",
    	["folder-cloud-bold-duotone"] = "rbxassetid://92279176090497",
    	["folder-cloud-broken"] = "rbxassetid://101321459814815",
    	["folder-cloud-line-duotone"] = "rbxassetid://74064084977045",
    	["folder-cloud-linear"] = "rbxassetid://130161278174338",
    	["folder-cloud-outline"] = "rbxassetid://72138815517371",
    	["folder-error-bold"] = "rbxassetid://113312905787220",
    	["folder-error-bold-duotone"] = "rbxassetid://116758034338410",
    	["folder-error-broken"] = "rbxassetid://108374508062796",
    	["folder-error-line-duotone"] = "rbxassetid://114808436814972",
    	["folder-error-linear"] = "rbxassetid://135779214752067",
    	["folder-error-outline"] = "rbxassetid://100402271545213",
    	["folder-favourite-bookmark-bold"] = "rbxassetid://121951599078771",
    	["folder-favourite-bookmark-bold-duotone"] = "rbxassetid://98629378712421",
    	["folder-favourite-bookmark-broken"] = "rbxassetid://99901884280493",
    	["folder-favourite-bookmark-line-duotone"] = "rbxassetid://70759554161871",
    	["folder-favourite-bookmark-linear"] = "rbxassetid://118069435095801",
    	["folder-favourite-bookmark-outline"] = "rbxassetid://110077616276963",
    	["folder-favourite-star-bold"] = "rbxassetid://87073155100200",
    	["folder-favourite-star-bold-duotone"] = "rbxassetid://138700955823376",
    	["folder-favourite-star-broken"] = "rbxassetid://71003974718083",
    	["folder-favourite-star-line-duotone"] = "rbxassetid://89573785505875",
    	["folder-favourite-star-linear"] = "rbxassetid://98822090332676",
    	["folder-favourite-star-outline"] = "rbxassetid://135740120171259",
    	["folder-line-duotone"] = "rbxassetid://80078543711839",
    	["folder-linear"] = "rbxassetid://133540230603010",
    	["folder-open-bold"] = "rbxassetid://138167990621065",
    	["folder-open-bold-duotone"] = "rbxassetid://110137669819578",
    	["folder-open-broken"] = "rbxassetid://137300556613848",
    	["folder-open-line-duotone"] = "rbxassetid://134679199505728",
    	["folder-open-linear"] = "rbxassetid://97968548604083",
    	["folder-open-outline"] = "rbxassetid://131398457035782",
    	["folder-outline"] = "rbxassetid://71570466760550",
    	["folder-path-connect-bold"] = "rbxassetid://73283047662646",
    	["folder-path-connect-bold-duotone"] = "rbxassetid://127108352519964",
    	["folder-path-connect-broken"] = "rbxassetid://128092646369497",
    	["folder-path-connect-line-duotone"] = "rbxassetid://128507654236958",
    	["folder-path-connect-linear"] = "rbxassetid://137981588947863",
    	["folder-path-connect-outline"] = "rbxassetid://76610302302603",
    	["folder-security-bold"] = "rbxassetid://76174163239107",
    	["folder-security-bold-duotone"] = "rbxassetid://80305490594063",
    	["folder-security-broken"] = "rbxassetid://76071381737999",
    	["folder-security-line-duotone"] = "rbxassetid://125506509156077",
    	["folder-security-linear"] = "rbxassetid://81277629390560",
    	["folder-security-outline"] = "rbxassetid://74311082151203",
    	["folder-with-files-bold"] = "rbxassetid://96350217047674",
    	["folder-with-files-bold-duotone"] = "rbxassetid://78132869117062",
    	["folder-with-files-broken"] = "rbxassetid://129714593703833",
    	["folder-with-files-line-duotone"] = "rbxassetid://140013606987222",
    	["folder-with-files-linear"] = "rbxassetid://93349925758029",
    	["folder-with-files-outline"] = "rbxassetid://130875846696139",
    	["football-bold"] = "rbxassetid://122607807171647",
    	["football-bold-duotone"] = "rbxassetid://81697399108738",
    	["football-broken"] = "rbxassetid://97556904616246",
    	["football-line-duotone"] = "rbxassetid://79674142110580",
    	["football-linear"] = "rbxassetid://73568432086297",
    	["football-outline"] = "rbxassetid://110184628766740",
    	["forbidden-bold"] = "rbxassetid://123202692288656",
    	["forbidden-bold-duotone"] = "rbxassetid://93232864941770",
    	["forbidden-broken"] = "rbxassetid://110720691033293",
    	["forbidden-circle-bold"] = "rbxassetid://98190469889558",
    	["forbidden-circle-bold-duotone"] = "rbxassetid://80078846265829",
    	["forbidden-circle-broken"] = "rbxassetid://128069193745215",
    	["forbidden-circle-line-duotone"] = "rbxassetid://75671910312019",
    	["forbidden-circle-linear"] = "rbxassetid://128023452454157",
    	["forbidden-circle-outline"] = "rbxassetid://84861114034441",
    	["forbidden-line-duotone"] = "rbxassetid://135133215411121",
    	["forbidden-linear"] = "rbxassetid://138160997444693",
    	["forbidden-outline"] = "rbxassetid://92689685745085",
    	["forward-2-bold"] = "rbxassetid://92800823328814",
    	["forward-2-bold-duotone"] = "rbxassetid://137084737342196",
    	["forward-2-broken"] = "rbxassetid://84356540465938",
    	["forward-2-line-duotone"] = "rbxassetid://131629718773592",
    	["forward-2-linear"] = "rbxassetid://87550599180519",
    	["forward-2-outline"] = "rbxassetid://108153931276512",
    	["forward-bold"] = "rbxassetid://121582467778484",
    	["forward-bold-1"] = "rbxassetid://98969859039111",
    	["forward-bold-duotone"] = "rbxassetid://98310550635612",
    	["forward-bold-duotone-1"] = "rbxassetid://131111404978401",
    	["forward-broken"] = "rbxassetid://81625748703201",
    	["forward-broken-1"] = "rbxassetid://84961449525156",
    	["forward-line-duotone"] = "rbxassetid://121667420252541",
    	["forward-line-duotone-1"] = "rbxassetid://95000885125732",
    	["forward-linear"] = "rbxassetid://104444830463659",
    	["forward-linear-1"] = "rbxassetid://96484120599878",
    	["forward-outline"] = "rbxassetid://123683470135739",
    	["forward-outline-1"] = "rbxassetid://138008713514481",
    	["fridge-bold"] = "rbxassetid://78081212880695",
    	["fridge-bold-duotone"] = "rbxassetid://74929535765297",
    	["fridge-broken"] = "rbxassetid://118224557576708",
    	["fridge-line-duotone"] = "rbxassetid://90749563307856",
    	["fridge-linear"] = "rbxassetid://81752504422048",
    	["fridge-outline"] = "rbxassetid://83909972803389",
    	["fuel-bold"] = "rbxassetid://95119712808078",
    	["fuel-bold-duotone"] = "rbxassetid://126044668014660",
    	["fuel-broken"] = "rbxassetid://135265642104919",
    	["fuel-line-duotone"] = "rbxassetid://70790618993739",
    	["fuel-linear"] = "rbxassetid://86971466989648",
    	["fuel-outline"] = "rbxassetid://105581292273169",
    	["full-screen-bold"] = "rbxassetid://70733270904537",
    	["full-screen-bold-duotone"] = "rbxassetid://105756560330252",
    	["full-screen-broken"] = "rbxassetid://95233158787946",
    	["full-screen-circle-bold"] = "rbxassetid://118761949672681",
    	["full-screen-circle-bold-duotone"] = "rbxassetid://127422695800815",
    	["full-screen-circle-broken"] = "rbxassetid://123079462536349",
    	["full-screen-circle-line-duotone"] = "rbxassetid://132088379214967",
    	["full-screen-circle-linear"] = "rbxassetid://85225840666402",
    	["full-screen-circle-outline"] = "rbxassetid://107311552137756",
    	["full-screen-line-duotone"] = "rbxassetid://112691787095183",
    	["full-screen-linear"] = "rbxassetid://104180878539489",
    	["full-screen-outline"] = "rbxassetid://73771914509632",
    	["full-screen-square-bold"] = "rbxassetid://120424617549682",
    	["full-screen-square-bold-duotone"] = "rbxassetid://116511824472503",
    	["full-screen-square-broken"] = "rbxassetid://105263524414718",
    	["full-screen-square-line-duotone"] = "rbxassetid://76406960532300",
    	["full-screen-square-linear"] = "rbxassetid://71372997970722",
    	["full-screen-square-outline"] = "rbxassetid://108134048999365",
    	["gallery-add-bold"] = "rbxassetid://119169548043101",
    	["gallery-add-bold-duotone"] = "rbxassetid://81847526929607",
    	["gallery-add-broken"] = "rbxassetid://91142470926201",
    	["gallery-add-line-duotone"] = "rbxassetid://104078992765022",
    	["gallery-add-linear"] = "rbxassetid://75630074806443",
    	["gallery-add-outline"] = "rbxassetid://101763359021051",
    	["gallery-bold"] = "rbxassetid://107115824920780",
    	["gallery-bold-duotone"] = "rbxassetid://82681919913181",
    	["gallery-broken"] = "rbxassetid://106317895319066",
    	["gallery-check-bold"] = "rbxassetid://95370122750252",
    	["gallery-check-bold-duotone"] = "rbxassetid://97998832305180",
    	["gallery-check-broken"] = "rbxassetid://80301779949883",
    	["gallery-check-line-duotone"] = "rbxassetid://98504779704744",
    	["gallery-check-linear"] = "rbxassetid://134990498714014",
    	["gallery-check-outline"] = "rbxassetid://124035543080345",
    	["gallery-circle-bold"] = "rbxassetid://98291804743618",
    	["gallery-circle-bold-duotone"] = "rbxassetid://108806814671042",
    	["gallery-circle-broken"] = "rbxassetid://117951568396033",
    	["gallery-circle-line-duotone"] = "rbxassetid://93766811594444",
    	["gallery-circle-linear"] = "rbxassetid://82459191597373",
    	["gallery-circle-outline"] = "rbxassetid://119195783933364",
    	["gallery-download-bold"] = "rbxassetid://74039459113922",
    	["gallery-download-bold-duotone"] = "rbxassetid://121570308336400",
    	["gallery-download-broken"] = "rbxassetid://106333010524331",
    	["gallery-download-line-duotone"] = "rbxassetid://122322703761359",
    	["gallery-download-linear"] = "rbxassetid://86076915875384",
    	["gallery-download-outline"] = "rbxassetid://86353008195728",
    	["gallery-edit-bold"] = "rbxassetid://131296755160748",
    	["gallery-edit-bold-duotone"] = "rbxassetid://99075681624837",
    	["gallery-edit-broken"] = "rbxassetid://79860688472974",
    	["gallery-edit-line-duotone"] = "rbxassetid://103504316580779",
    	["gallery-edit-linear"] = "rbxassetid://122227774742108",
    	["gallery-edit-outline"] = "rbxassetid://117205343596173",
    	["gallery-favourite-bold"] = "rbxassetid://80866000511556",
    	["gallery-favourite-bold-duotone"] = "rbxassetid://110325779904748",
    	["gallery-favourite-broken"] = "rbxassetid://127532570916674",
    	["gallery-favourite-line-duotone"] = "rbxassetid://85421223027504",
    	["gallery-favourite-linear"] = "rbxassetid://90300368074000",
    	["gallery-favourite-outline"] = "rbxassetid://70849095469055",
    	["gallery-line-duotone"] = "rbxassetid://81988234745684",
    	["gallery-linear"] = "rbxassetid://91661210588833",
    	["gallery-minimalistic-bold"] = "rbxassetid://111677697640953",
    	["gallery-minimalistic-bold-duotone"] = "rbxassetid://135527488953456",
    	["gallery-minimalistic-broken"] = "rbxassetid://71148757050340",
    	["gallery-minimalistic-line-duotone"] = "rbxassetid://79231913806058",
    	["gallery-minimalistic-linear"] = "rbxassetid://109316186175476",
    	["gallery-minimalistic-outline"] = "rbxassetid://82693743487964",
    	["gallery-outline"] = "rbxassetid://83918797510658",
    	["gallery-remove-bold"] = "rbxassetid://121381327348902",
    	["gallery-remove-bold-duotone"] = "rbxassetid://81015198409590",
    	["gallery-remove-broken"] = "rbxassetid://86530994131794",
    	["gallery-remove-line-duotone"] = "rbxassetid://79326141383314",
    	["gallery-remove-linear"] = "rbxassetid://126531264157741",
    	["gallery-remove-outline"] = "rbxassetid://70776749787189",
    	["gallery-round-bold"] = "rbxassetid://93521842678616",
    	["gallery-round-bold-duotone"] = "rbxassetid://125402320169739",
    	["gallery-round-broken"] = "rbxassetid://108787002114551",
    	["gallery-round-line-duotone"] = "rbxassetid://120970364249713",
    	["gallery-round-linear"] = "rbxassetid://123195208843344",
    	["gallery-round-outline"] = "rbxassetid://87925611886627",
    	["gallery-send-bold"] = "rbxassetid://83644025804536",
    	["gallery-send-bold-duotone"] = "rbxassetid://130828190219982",
    	["gallery-send-broken"] = "rbxassetid://108993879268015",
    	["gallery-send-line-duotone"] = "rbxassetid://136871739861852",
    	["gallery-send-linear"] = "rbxassetid://102651831583247",
    	["gallery-send-outline"] = "rbxassetid://137228741546389",
    	["gallery-wide-bold"] = "rbxassetid://111039930907780",
    	["gallery-wide-bold-duotone"] = "rbxassetid://84544452458042",
    	["gallery-wide-broken"] = "rbxassetid://72717388478777",
    	["gallery-wide-line-duotone"] = "rbxassetid://94473963077801",
    	["gallery-wide-linear"] = "rbxassetid://121924902113738",
    	["gallery-wide-outline"] = "rbxassetid://84966330183511",
    	["gameboy-bold"] = "rbxassetid://112631387612132",
    	["gameboy-bold-duotone"] = "rbxassetid://85852565388590",
    	["gameboy-broken"] = "rbxassetid://116795818694116",
    	["gameboy-line-duotone"] = "rbxassetid://103512532814435",
    	["gameboy-linear"] = "rbxassetid://125410862617155",
    	["gameboy-outline"] = "rbxassetid://70914876965098",
    	["gamepad-bold"] = "rbxassetid://132228762224767",
    	["gamepad-bold-duotone"] = "rbxassetid://85250259365028",
    	["gamepad-broken"] = "rbxassetid://133577631686614",
    	["gamepad-charge-bold"] = "rbxassetid://82289031849218",
    	["gamepad-charge-bold-duotone"] = "rbxassetid://101286594437885",
    	["gamepad-charge-broken"] = "rbxassetid://124442155613671",
    	["gamepad-charge-line-duotone"] = "rbxassetid://133353919210179",
    	["gamepad-charge-linear"] = "rbxassetid://130869822388107",
    	["gamepad-charge-outline"] = "rbxassetid://102134404500189",
    	["gamepad-line-duotone"] = "rbxassetid://73945620574799",
    	["gamepad-linear"] = "rbxassetid://81369494519380",
    	["gamepad-minimalistic-bold"] = "rbxassetid://107922917997811",
    	["gamepad-minimalistic-bold-duotone"] = "rbxassetid://88269068636348",
    	["gamepad-minimalistic-broken"] = "rbxassetid://117941932261341",
    	["gamepad-minimalistic-line-duotone"] = "rbxassetid://102413964042984",
    	["gamepad-minimalistic-linear"] = "rbxassetid://96780029971540",
    	["gamepad-minimalistic-outline"] = "rbxassetid://118228187233233",
    	["gamepad-no-charge-bold"] = "rbxassetid://100739827942723",
    	["gamepad-no-charge-bold-duotone"] = "rbxassetid://130800516256976",
    	["gamepad-no-charge-broken"] = "rbxassetid://101660704243772",
    	["gamepad-no-charge-line-duotone"] = "rbxassetid://104661250621308",
    	["gamepad-no-charge-linear"] = "rbxassetid://73643991100284",
    	["gamepad-no-charge-outline"] = "rbxassetid://105820255502122",
    	["gamepad-old-bold"] = "rbxassetid://110201467031230",
    	["gamepad-old-bold-duotone"] = "rbxassetid://109797307321783",
    	["gamepad-old-broken"] = "rbxassetid://81056028480056",
    	["gamepad-old-line-duotone"] = "rbxassetid://92840485976886",
    	["gamepad-old-linear"] = "rbxassetid://91888898609964",
    	["gamepad-old-outline"] = "rbxassetid://110342096118561",
    	["gamepad-outline"] = "rbxassetid://81820688031052",
    	["garage-bold"] = "rbxassetid://106033136962094",
    	["garage-linear"] = "rbxassetid://100611748153748",
    	["gas-station-bold"] = "rbxassetid://86311898446535",
    	["gas-station-linear"] = "rbxassetid://123118673162239",
    	["ghost-bold"] = "rbxassetid://98147715916360",
    	["ghost-bold-duotone"] = "rbxassetid://128767328538056",
    	["ghost-broken"] = "rbxassetid://104896350313628",
    	["ghost-line-duotone"] = "rbxassetid://113563936751484",
    	["ghost-linear"] = "rbxassetid://112335376597752",
    	["ghost-outline"] = "rbxassetid://91380515776100",
    	["ghost-smile-bold"] = "rbxassetid://103118938315507",
    	["ghost-smile-bold-duotone"] = "rbxassetid://81281566325629",
    	["ghost-smile-broken"] = "rbxassetid://118654882311966",
    	["ghost-smile-line-duotone"] = "rbxassetid://83529170869839",
    	["ghost-smile-linear"] = "rbxassetid://106634857323028",
    	["ghost-smile-outline"] = "rbxassetid://120497010434861",
    	["gift-bold"] = "rbxassetid://134626236985841",
    	["gift-bold-duotone"] = "rbxassetid://94213582340427",
    	["gift-broken"] = "rbxassetid://71952291980298",
    	["gift-line-duotone"] = "rbxassetid://92275665332065",
    	["gift-linear"] = "rbxassetid://118925298273739",
    	["gift-outline"] = "rbxassetid://125602314688801",
    	["glasses-bold"] = "rbxassetid://77968854251869",
    	["glasses-bold-duotone"] = "rbxassetid://104986463536326",
    	["glasses-broken"] = "rbxassetid://117446666523602",
    	["glasses-line-duotone"] = "rbxassetid://75552792503008",
    	["glasses-linear"] = "rbxassetid://134381277068262",
    	["glasses-outline"] = "rbxassetid://100761103590411",
    	["global-bold"] = "rbxassetid://139419629866911",
    	["global-bold-duotone"] = "rbxassetid://93280439986430",
    	["global-broken"] = "rbxassetid://79619165356726",
    	["global-line-duotone"] = "rbxassetid://138555227646958",
    	["global-linear"] = "rbxassetid://105120698264677",
    	["global-outline"] = "rbxassetid://83739807750028",
    	["globus-bold"] = "rbxassetid://87049589839481",
    	["globus-bold-duotone"] = "rbxassetid://104756292957488",
    	["globus-broken"] = "rbxassetid://114906835945761",
    	["globus-line-duotone"] = "rbxassetid://113480803567619",
    	["globus-linear"] = "rbxassetid://109582883926706",
    	["globus-outline"] = "rbxassetid://77357309765330",
    	["golf-bold"] = "rbxassetid://98322149458809",
    	["golf-bold-duotone"] = "rbxassetid://96987546864373",
    	["golf-broken"] = "rbxassetid://136741209691499",
    	["golf-line-duotone"] = "rbxassetid://106646400058414",
    	["golf-linear"] = "rbxassetid://134629085191114",
    	["golf-outline"] = "rbxassetid://123163219222093",
    	["gps-bold"] = "rbxassetid://96477729873448",
    	["gps-bold-duotone"] = "rbxassetid://129614782938741",
    	["gps-broken"] = "rbxassetid://124106823603356",
    	["gps-line-duotone"] = "rbxassetid://90983916099227",
    	["gps-linear"] = "rbxassetid://116024945164366",
    	["gps-outline"] = "rbxassetid://100449361271335",
    	["graph-bold"] = "rbxassetid://97211064230719",
    	["graph-bold-duotone"] = "rbxassetid://134952990274193",
    	["graph-broken"] = "rbxassetid://125396840697025",
    	["graph-down-bold"] = "rbxassetid://85357519277962",
    	["graph-down-bold-duotone"] = "rbxassetid://124247612376908",
    	["graph-down-broken"] = "rbxassetid://70750219548574",
    	["graph-down-line-duotone"] = "rbxassetid://134524545111602",
    	["graph-down-linear"] = "rbxassetid://124212549191550",
    	["graph-down-new-bold"] = "rbxassetid://126282065399172",
    	["graph-down-new-bold-duotone"] = "rbxassetid://123355496606822",
    	["graph-down-new-broken"] = "rbxassetid://131772673601239",
    	["graph-down-new-line-duotone"] = "rbxassetid://71087922708904",
    	["graph-down-new-linear"] = "rbxassetid://125159931174035",
    	["graph-down-new-outline"] = "rbxassetid://139572418496788",
    	["graph-down-outline"] = "rbxassetid://131058851811169",
    	["graph-line-duotone"] = "rbxassetid://111954495228629",
    	["graph-linear"] = "rbxassetid://86210645840391",
    	["graph-new-bold"] = "rbxassetid://85786914748675",
    	["graph-new-bold-duotone"] = "rbxassetid://132183814974132",
    	["graph-new-broken"] = "rbxassetid://124997266837822",
    	["graph-new-line-duotone"] = "rbxassetid://111300462456929",
    	["graph-new-linear"] = "rbxassetid://127845248715903",
    	["graph-new-outline"] = "rbxassetid://80529006506718",
    	["graph-new-up-bold"] = "rbxassetid://93250207296556",
    	["graph-new-up-bold-duotone"] = "rbxassetid://124165646167824",
    	["graph-new-up-broken"] = "rbxassetid://100054222614708",
    	["graph-new-up-line-duotone"] = "rbxassetid://102279702924109",
    	["graph-new-up-linear"] = "rbxassetid://136775022719826",
    	["graph-new-up-outline"] = "rbxassetid://132018083056970",
    	["graph-outline"] = "rbxassetid://126915097278049",
    	["graph-up-bold"] = "rbxassetid://133545790231682",
    	["graph-up-bold-duotone"] = "rbxassetid://100304081642269",
    	["graph-up-broken"] = "rbxassetid://96054676198399",
    	["graph-up-line-duotone"] = "rbxassetid://114590119396797",
    	["graph-up-linear"] = "rbxassetid://89249183744402",
    	["graph-up-outline"] = "rbxassetid://76772571966994",
    	["hamburger-menu-bold"] = "rbxassetid://79473109809580",
    	["hamburger-menu-bold-duotone"] = "rbxassetid://118519251600018",
    	["hamburger-menu-broken"] = "rbxassetid://76160566875171",
    	["hamburger-menu-line-duotone"] = "rbxassetid://127170436666442",
    	["hamburger-menu-linear"] = "rbxassetid://79119755625892",
    	["hamburger-menu-outline"] = "rbxassetid://101118075751604",
    	["hand-heart-bold"] = "rbxassetid://130716318062267",
    	["hand-heart-linear"] = "rbxassetid://102314752003538",
    	["hand-money-bold"] = "rbxassetid://75640944758219",
    	["hand-money-linear"] = "rbxassetid://133642774671836",
    	["hand-pills-bold"] = "rbxassetid://127850574287384",
    	["hand-pills-linear"] = "rbxassetid://72720572428053",
    	["hand-shake-bold"] = "rbxassetid://108947571035632",
    	["hand-shake-linear"] = "rbxassetid://93488778032327",
    	["hand-stars-bold"] = "rbxassetid://77864301483163",
    	["hand-stars-linear"] = "rbxassetid://72643549512304",
    	["hanger-2-bold"] = "rbxassetid://127952312462409",
    	["hanger-2-bold-duotone"] = "rbxassetid://79287404491130",
    	["hanger-2-broken"] = "rbxassetid://88465301789670",
    	["hanger-2-line-duotone"] = "rbxassetid://133743118320617",
    	["hanger-2-linear"] = "rbxassetid://113139331771976",
    	["hanger-2-outline"] = "rbxassetid://118887767020739",
    	["hanger-bold"] = "rbxassetid://121629637423486",
    	["hanger-bold-duotone"] = "rbxassetid://79208930489790",
    	["hanger-broken"] = "rbxassetid://121651233390046",
    	["hanger-line-duotone"] = "rbxassetid://97931742009139",
    	["hanger-linear"] = "rbxassetid://126953212274062",
    	["hanger-outline"] = "rbxassetid://131017196616194",
    	["hashtag-bold"] = "rbxassetid://107142548785326",
    	["hashtag-bold-duotone"] = "rbxassetid://77863976534325",
    	["hashtag-broken"] = "rbxassetid://128069989381021",
    	["hashtag-chat-bold"] = "rbxassetid://80437575983407",
    	["hashtag-chat-bold-duotone"] = "rbxassetid://139020999867631",
    	["hashtag-chat-broken"] = "rbxassetid://78712179403933",
    	["hashtag-chat-line-duotone"] = "rbxassetid://115850803176723",
    	["hashtag-chat-linear"] = "rbxassetid://118464443613134",
    	["hashtag-chat-outline"] = "rbxassetid://87659483376157",
    	["hashtag-circle-bold"] = "rbxassetid://77446982417735",
    	["hashtag-circle-bold-duotone"] = "rbxassetid://94654869397313",
    	["hashtag-circle-broken"] = "rbxassetid://130009754970947",
    	["hashtag-circle-line-duotone"] = "rbxassetid://122846143503830",
    	["hashtag-circle-linear"] = "rbxassetid://107197670508125",
    	["hashtag-circle-outline"] = "rbxassetid://110794560266086",
    	["hashtag-line-duotone"] = "rbxassetid://79744746124995",
    	["hashtag-linear"] = "rbxassetid://111588117563713",
    	["hashtag-outline"] = "rbxassetid://113845381450488",
    	["hashtag-square-bold"] = "rbxassetid://103351344998670",
    	["hashtag-square-bold-duotone"] = "rbxassetid://102379879708801",
    	["hashtag-square-broken"] = "rbxassetid://90009625567002",
    	["hashtag-square-line-duotone"] = "rbxassetid://78845243054354",
    	["hashtag-square-linear"] = "rbxassetid://112095670346630",
    	["hashtag-square-outline"] = "rbxassetid://124027606244623",
    	["headphones-round-bold"] = "rbxassetid://128280382670309",
    	["headphones-round-bold-duotone"] = "rbxassetid://113158510821310",
    	["headphones-round-broken"] = "rbxassetid://132662598762599",
    	["headphones-round-line-duotone"] = "rbxassetid://138194384715395",
    	["headphones-round-linear"] = "rbxassetid://111065196256263",
    	["headphones-round-outline"] = "rbxassetid://107854155554692",
    	["headphones-round-sound-bold"] = "rbxassetid://100766574538440",
    	["headphones-round-sound-bold-duotone"] = "rbxassetid://98688614729013",
    	["headphones-round-sound-broken"] = "rbxassetid://90166439814045",
    	["headphones-round-sound-line-duotone"] = "rbxassetid://91966150804036",
    	["headphones-round-sound-linear"] = "rbxassetid://127189345504390",
    	["headphones-round-sound-outline"] = "rbxassetid://78588901844797",
    	["headphones-square-bold"] = "rbxassetid://78135331232845",
    	["headphones-square-bold-duotone"] = "rbxassetid://135547766762978",
    	["headphones-square-broken"] = "rbxassetid://83624957714381",
    	["headphones-square-line-duotone"] = "rbxassetid://122098348226786",
    	["headphones-square-linear"] = "rbxassetid://140592739462882",
    	["headphones-square-outline"] = "rbxassetid://80775987318629",
    	["headphones-square-sound-bold"] = "rbxassetid://124380127559063",
    	["headphones-square-sound-bold-duotone"] = "rbxassetid://72337311038266",
    	["headphones-square-sound-broken"] = "rbxassetid://127322782387973",
    	["headphones-square-sound-line-duotone"] = "rbxassetid://115616956286157",
    	["headphones-square-sound-linear"] = "rbxassetid://106752413307821",
    	["headphones-square-sound-outline"] = "rbxassetid://80614903386391",
    	["health-bold"] = "rbxassetid://139029626825956",
    	["health-bold-duotone"] = "rbxassetid://88565833545580",
    	["health-broken"] = "rbxassetid://127767224416240",
    	["health-line-duotone"] = "rbxassetid://100509668072110",
    	["health-linear"] = "rbxassetid://121945365967664",
    	["health-outline"] = "rbxassetid://136287060298224",
    	["heart-angle-bold"] = "rbxassetid://134542484641582",
    	["heart-angle-bold-duotone"] = "rbxassetid://121839146993535",
    	["heart-angle-broken"] = "rbxassetid://120293258593074",
    	["heart-angle-line-duotone"] = "rbxassetid://89272909526182",
    	["heart-angle-linear"] = "rbxassetid://73254298299319",
    	["heart-angle-outline"] = "rbxassetid://117951045608239",
    	["heart-bold"] = "rbxassetid://119572392737590",
    	["heart-bold-duotone"] = "rbxassetid://104108932969149",
    	["heart-broken"] = "rbxassetid://130408576568774",
    	["heart-broken-bold"] = "rbxassetid://117389905375092",
    	["heart-broken-bold-duotone"] = "rbxassetid://116232375895566",
    	["heart-broken-broken"] = "rbxassetid://86131790495117",
    	["heart-broken-line-duotone"] = "rbxassetid://93822036141159",
    	["heart-broken-linear"] = "rbxassetid://116205971765120",
    	["heart-broken-outline"] = "rbxassetid://84867116008833",
    	["heart-line-duotone"] = "rbxassetid://86457467281421",
    	["heart-linear"] = "rbxassetid://113645798637763",
    	["heart-lock-bold"] = "rbxassetid://74134825079392",
    	["heart-lock-bold-duotone"] = "rbxassetid://113260873502920",
    	["heart-lock-broken"] = "rbxassetid://101792595060860",
    	["heart-lock-line-duotone"] = "rbxassetid://81532301515221",
    	["heart-lock-linear"] = "rbxassetid://128828262982418",
    	["heart-lock-outline"] = "rbxassetid://73777444560854",
    	["heart-outline"] = "rbxassetid://95051301697671",
    	["heart-pulse-2-bold"] = "rbxassetid://86416022263141",
    	["heart-pulse-2-bold-duotone"] = "rbxassetid://125871787761327",
    	["heart-pulse-2-broken"] = "rbxassetid://115582451731861",
    	["heart-pulse-2-line-duotone"] = "rbxassetid://81862168659265",
    	["heart-pulse-2-linear"] = "rbxassetid://121668034285404",
    	["heart-pulse-2-outline"] = "rbxassetid://111432239738647",
    	["heart-pulse-bold"] = "rbxassetid://95037082144393",
    	["heart-pulse-bold-duotone"] = "rbxassetid://112914835530248",
    	["heart-pulse-broken"] = "rbxassetid://110430508107459",
    	["heart-pulse-line-duotone"] = "rbxassetid://134682597902102",
    	["heart-pulse-linear"] = "rbxassetid://113820167383020",
    	["heart-pulse-outline"] = "rbxassetid://123091796263451",
    	["heart-shine-bold"] = "rbxassetid://73693161433363",
    	["heart-shine-bold-duotone"] = "rbxassetid://99130270693702",
    	["heart-shine-broken"] = "rbxassetid://91879501225879",
    	["heart-shine-line-duotone"] = "rbxassetid://118090143426466",
    	["heart-shine-linear"] = "rbxassetid://93662062674474",
    	["heart-shine-outline"] = "rbxassetid://88869364974433",
    	["heart-unlock-bold"] = "rbxassetid://109726686524974",
    	["heart-unlock-bold-duotone"] = "rbxassetid://90776776169662",
    	["heart-unlock-broken"] = "rbxassetid://127101052426330",
    	["heart-unlock-line-duotone"] = "rbxassetid://130529119300641",
    	["heart-unlock-linear"] = "rbxassetid://83690964994138",
    	["heart-unlock-outline"] = "rbxassetid://133721424734318",
    	["hearts-bold"] = "rbxassetid://93869078516452",
    	["hearts-bold-duotone"] = "rbxassetid://72943674270006",
    	["hearts-broken"] = "rbxassetid://119451232696113",
    	["hearts-line-duotone"] = "rbxassetid://108071789976218",
    	["hearts-linear"] = "rbxassetid://107657606223227",
    	["hearts-outline"] = "rbxassetid://138881727937010",
    	["help-bold"] = "rbxassetid://74549672827568",
    	["help-bold-duotone"] = "rbxassetid://110612368446156",
    	["help-broken"] = "rbxassetid://112724423725922",
    	["help-line-duotone"] = "rbxassetid://105448252078232",
    	["help-linear"] = "rbxassetid://91283854526238",
    	["help-outline"] = "rbxassetid://70529738750281",
    	["high-definition-bold"] = "rbxassetid://80838009750190",
    	["high-definition-bold-duotone"] = "rbxassetid://76066522924649",
    	["high-definition-broken"] = "rbxassetid://112696352653514",
    	["high-definition-line-duotone"] = "rbxassetid://71195689764940",
    	["high-definition-linear"] = "rbxassetid://94322182612743",
    	["high-definition-outline"] = "rbxassetid://97316863455833",
    	["high-quality-bold"] = "rbxassetid://137403273802579",
    	["high-quality-bold-duotone"] = "rbxassetid://140080144600407",
    	["high-quality-broken"] = "rbxassetid://100129656134220",
    	["high-quality-line-duotone"] = "rbxassetid://135101762643465",
    	["high-quality-linear"] = "rbxassetid://85413812610822",
    	["high-quality-outline"] = "rbxassetid://107863099179413",
    	["hiking-bold"] = "rbxassetid://82931610763804",
    	["hiking-bold-duotone"] = "rbxassetid://121144500828784",
    	["hiking-broken"] = "rbxassetid://85601551919962",
    	["hiking-line-duotone"] = "rbxassetid://104406571588952",
    	["hiking-linear"] = "rbxassetid://83665127021537",
    	["hiking-minimalistic-bold"] = "rbxassetid://136348686208306",
    	["hiking-minimalistic-bold-duotone"] = "rbxassetid://105701833454684",
    	["hiking-minimalistic-broken"] = "rbxassetid://112593930871657",
    	["hiking-minimalistic-line-duotone"] = "rbxassetid://89265858463800",
    	["hiking-minimalistic-linear"] = "rbxassetid://103694269108611",
    	["hiking-minimalistic-outline"] = "rbxassetid://130672309331903",
    	["hiking-outline"] = "rbxassetid://95973286169521",
    	["hiking-round-bold"] = "rbxassetid://98000809158973",
    	["hiking-round-bold-duotone"] = "rbxassetid://129537168513885",
    	["hiking-round-broken"] = "rbxassetid://111104538874440",
    	["hiking-round-line-duotone"] = "rbxassetid://132799318539117",
    	["hiking-round-linear"] = "rbxassetid://119436892182615",
    	["hiking-round-outline"] = "rbxassetid://121534681034132",
    	["history-2-bold"] = "rbxassetid://119156111252056",
    	["history-2-bold-duotone"] = "rbxassetid://93391717017311",
    	["history-2-broken"] = "rbxassetid://72633773265866",
    	["history-2-line-duotone"] = "rbxassetid://82765900860823",
    	["history-2-linear"] = "rbxassetid://118323344428679",
    	["history-2-outline"] = "rbxassetid://107754364682279",
    	["history-3-bold"] = "rbxassetid://102058567061813",
    	["history-3-bold-duotone"] = "rbxassetid://96779665394761",
    	["history-3-broken"] = "rbxassetid://102719279067942",
    	["history-3-line-duotone"] = "rbxassetid://130527068840995",
    	["history-3-linear"] = "rbxassetid://72374742008547",
    	["history-3-outline"] = "rbxassetid://82847919291777",
    	["history-bold"] = "rbxassetid://97353417492391",
    	["history-bold-duotone"] = "rbxassetid://80548168520886",
    	["history-broken"] = "rbxassetid://133317136532561",
    	["history-line-duotone"] = "rbxassetid://120872468237174",
    	["history-linear"] = "rbxassetid://106761166048606",
    	["history-outline"] = "rbxassetid://94056872406465",
    	["home-2-bold"] = "rbxassetid://117906088481880",
    	["home-2-bold-duotone"] = "rbxassetid://85202485209619",
    	["home-2-broken"] = "rbxassetid://100535740254809",
    	["home-2-line-duotone"] = "rbxassetid://84659329722128",
    	["home-2-linear"] = "rbxassetid://113192541185690",
    	["home-2-outline"] = "rbxassetid://100004093448148",
    	["home-add-angle-bold"] = "rbxassetid://120045039719252",
    	["home-add-angle-bold-duotone"] = "rbxassetid://128279879608378",
    	["home-add-angle-broken"] = "rbxassetid://103522177983264",
    	["home-add-angle-line-duotone"] = "rbxassetid://94451738203957",
    	["home-add-angle-linear"] = "rbxassetid://90421449615117",
    	["home-add-angle-outline"] = "rbxassetid://98560889031828",
    	["home-add-bold"] = "rbxassetid://117995122988574",
    	["home-add-bold-duotone"] = "rbxassetid://73100605130883",
    	["home-add-broken"] = "rbxassetid://76928440909503",
    	["home-add-line-duotone"] = "rbxassetid://113533636220299",
    	["home-add-linear"] = "rbxassetid://122427506572604",
    	["home-add-outline"] = "rbxassetid://70650785386547",
    	["home-angle-2-bold"] = "rbxassetid://83857918016474",
    	["home-angle-2-bold-duotone"] = "rbxassetid://108944915560942",
    	["home-angle-2-broken"] = "rbxassetid://93239181546256",
    	["home-angle-2-line-duotone"] = "rbxassetid://81818122673611",
    	["home-angle-2-linear"] = "rbxassetid://111640162884727",
    	["home-angle-2-outline"] = "rbxassetid://75395259457470",
    	["home-angle-bold"] = "rbxassetid://138932921214460",
    	["home-angle-bold-duotone"] = "rbxassetid://80510404120545",
    	["home-angle-broken"] = "rbxassetid://105861811245048",
    	["home-angle-line-duotone"] = "rbxassetid://118010521168477",
    	["home-angle-linear"] = "rbxassetid://84652926620929",
    	["home-angle-outline"] = "rbxassetid://109971354763713",
    	["home-bold"] = "rbxassetid://110908061043900",
    	["home-bold-1"] = "rbxassetid://117550358732194",
    	["home-bold-duotone"] = "rbxassetid://110952130589954",
    	["home-broken"] = "rbxassetid://122851197219945",
    	["home-line-duotone"] = "rbxassetid://133782282469602",
    	["home-linear"] = "rbxassetid://111419679114665",
    	["home-linear-1"] = "rbxassetid://118103981564484",
    	["home-outline"] = "rbxassetid://105998061854466",
    	["home-smile-angle-bold"] = "rbxassetid://100747143305761",
    	["home-smile-angle-bold-duotone"] = "rbxassetid://96663893378656",
    	["home-smile-angle-broken"] = "rbxassetid://106588435427560",
    	["home-smile-angle-line-duotone"] = "rbxassetid://75379092896089",
    	["home-smile-angle-linear"] = "rbxassetid://78266306397603",
    	["home-smile-angle-outline"] = "rbxassetid://106681767905607",
    	["home-smile-bold"] = "rbxassetid://87523684474921",
    	["home-smile-bold-duotone"] = "rbxassetid://70623994357805",
    	["home-smile-broken"] = "rbxassetid://126545050980646",
    	["home-smile-line-duotone"] = "rbxassetid://73851539411179",
    	["home-smile-linear"] = "rbxassetid://94291163808976",
    	["home-smile-outline"] = "rbxassetid://132622757885004",
    	["home-wi-fi-angle-bold"] = "rbxassetid://132404171071568",
    	["home-wi-fi-angle-bold-duotone"] = "rbxassetid://72909667825397",
    	["home-wi-fi-angle-broken"] = "rbxassetid://103286656289263",
    	["home-wi-fi-angle-line-duotone"] = "rbxassetid://93103769789755",
    	["home-wi-fi-angle-linear"] = "rbxassetid://75304271438336",
    	["home-wi-fi-angle-outline"] = "rbxassetid://131334252495293",
    	["home-wi-fi-bold"] = "rbxassetid://125675624043794",
    	["home-wi-fi-bold-duotone"] = "rbxassetid://93428621836213",
    	["home-wi-fi-broken"] = "rbxassetid://93800984027877",
    	["home-wi-fi-line-duotone"] = "rbxassetid://97687536118398",
    	["home-wi-fi-linear"] = "rbxassetid://106026512949363",
    	["home-wi-fi-outline"] = "rbxassetid://115721395580124",
    	["hospital-bold"] = "rbxassetid://119261943878093",
    	["hospital-linear"] = "rbxassetid://93327636639216",
    	["hourglass-bold"] = "rbxassetid://97468116462119",
    	["hourglass-bold-duotone"] = "rbxassetid://95424509694761",
    	["hourglass-broken"] = "rbxassetid://92218412589494",
    	["hourglass-line-bold"] = "rbxassetid://94077487038206",
    	["hourglass-line-bold-duotone"] = "rbxassetid://89127693898077",
    	["hourglass-line-broken"] = "rbxassetid://79417001213649",
    	["hourglass-line-duotone"] = "rbxassetid://98752362126278",
    	["hourglass-line-line-duotone"] = "rbxassetid://124971749487137",
    	["hourglass-line-linear"] = "rbxassetid://100933071986279",
    	["hourglass-line-outline"] = "rbxassetid://132596765606272",
    	["hourglass-linear"] = "rbxassetid://73119276842388",
    	["hourglass-outline"] = "rbxassetid://83636730223985",
    	["i-phone-bold"] = "rbxassetid://115103457868482",
    	["i-phone-bold-duotone"] = "rbxassetid://136663132448847",
    	["i-phone-broken"] = "rbxassetid://91601430081041",
    	["i-phone-line-duotone"] = "rbxassetid://119732829551909",
    	["i-phone-linear"] = "rbxassetid://126618533832651",
    	["i-phone-outline"] = "rbxassetid://131918414382895",
    	["import-bold"] = "rbxassetid://94955686787672",
    	["import-bold-duotone"] = "rbxassetid://115017814345146",
    	["import-broken"] = "rbxassetid://75023527347068",
    	["import-line-duotone"] = "rbxassetid://78384430987784",
    	["import-linear"] = "rbxassetid://117800135689429",
    	["import-outline"] = "rbxassetid://82566962927963",
    	["inbox-archive-bold"] = "rbxassetid://100304044661400",
    	["inbox-archive-bold-duotone"] = "rbxassetid://84438065994736",
    	["inbox-archive-broken"] = "rbxassetid://94069479740608",
    	["inbox-archive-line-duotone"] = "rbxassetid://94829953833047",
    	["inbox-archive-linear"] = "rbxassetid://84158272601597",
    	["inbox-archive-outline"] = "rbxassetid://127916003332285",
    	["inbox-bold"] = "rbxassetid://136217097965233",
    	["inbox-bold-duotone"] = "rbxassetid://113924240450174",
    	["inbox-broken"] = "rbxassetid://92506033121162",
    	["inbox-in-bold"] = "rbxassetid://130124951048332",
    	["inbox-in-bold-duotone"] = "rbxassetid://97313694365965",
    	["inbox-in-broken"] = "rbxassetid://106365380482121",
    	["inbox-in-line-duotone"] = "rbxassetid://121658766327375",
    	["inbox-in-linear"] = "rbxassetid://130335606962080",
    	["inbox-in-outline"] = "rbxassetid://107457409500804",
    	["inbox-line-bold"] = "rbxassetid://74954329094178",
    	["inbox-line-bold-duotone"] = "rbxassetid://139696329493878",
    	["inbox-line-broken"] = "rbxassetid://107194240587057",
    	["inbox-line-duotone"] = "rbxassetid://99006040722597",
    	["inbox-line-line-duotone"] = "rbxassetid://87639741212312",
    	["inbox-line-linear"] = "rbxassetid://86714873274852",
    	["inbox-line-outline"] = "rbxassetid://108705897319285",
    	["inbox-linear"] = "rbxassetid://98204672268426",
    	["inbox-out-bold"] = "rbxassetid://134100020984116",
    	["inbox-out-bold-duotone"] = "rbxassetid://106204183213085",
    	["inbox-out-broken"] = "rbxassetid://126732008814931",
    	["inbox-out-line-duotone"] = "rbxassetid://129450809508146",
    	["inbox-out-linear"] = "rbxassetid://127772877604634",
    	["inbox-out-outline"] = "rbxassetid://128249712009340",
    	["inbox-outline"] = "rbxassetid://82550530823327",
    	["inbox-unread-bold"] = "rbxassetid://75549440169195",
    	["inbox-unread-bold-duotone"] = "rbxassetid://87771052812423",
    	["inbox-unread-broken"] = "rbxassetid://126329076125436",
    	["inbox-unread-line-duotone"] = "rbxassetid://75338004082757",
    	["inbox-unread-linear"] = "rbxassetid://120151023621869",
    	["inbox-unread-outline"] = "rbxassetid://110259633640398",
    	["incognito-bold"] = "rbxassetid://80542702049291",
    	["incognito-bold-duotone"] = "rbxassetid://85341918034790",
    	["incognito-broken"] = "rbxassetid://121807055701331",
    	["incognito-line-duotone"] = "rbxassetid://90962820654926",
    	["incognito-linear"] = "rbxassetid://118972936019473",
    	["incognito-outline"] = "rbxassetid://92382184841069",
    	["incoming-call-bold"] = "rbxassetid://98467559903476",
    	["incoming-call-bold-duotone"] = "rbxassetid://116204957020463",
    	["incoming-call-broken"] = "rbxassetid://113796223187961",
    	["incoming-call-line-duotone"] = "rbxassetid://79855726203059",
    	["incoming-call-linear"] = "rbxassetid://79983128357549",
    	["incoming-call-outline"] = "rbxassetid://122985913486022",
    	["incoming-call-rounded-bold"] = "rbxassetid://116052533683978",
    	["incoming-call-rounded-bold-duotone"] = "rbxassetid://71574491882655",
    	["incoming-call-rounded-broken"] = "rbxassetid://109980342242359",
    	["incoming-call-rounded-line-duotone"] = "rbxassetid://85467887046836",
    	["incoming-call-rounded-linear"] = "rbxassetid://131110545679092",
    	["incoming-call-rounded-outline"] = "rbxassetid://106864795840875",
    	["infinity-bold"] = "rbxassetid://104195103286648",
    	["infinity-bold-duotone"] = "rbxassetid://126947465536062",
    	["infinity-broken"] = "rbxassetid://116270366886322",
    	["infinity-line-duotone"] = "rbxassetid://72722143693951",
    	["infinity-linear"] = "rbxassetid://117206303421154",
    	["infinity-outline"] = "rbxassetid://91293318677346",
    	["info-circle-bold"] = "rbxassetid://94529541997278",
    	["info-circle-bold-duotone"] = "rbxassetid://103428026269268",
    	["info-circle-broken"] = "rbxassetid://80946544201767",
    	["info-circle-line-duotone"] = "rbxassetid://139564117775418",
    	["info-circle-linear"] = "rbxassetid://91217256024624",
    	["info-circle-outline"] = "rbxassetid://86292259585105",
    	["info-square-bold"] = "rbxassetid://104423298306796",
    	["info-square-bold-duotone"] = "rbxassetid://130397227563794",
    	["info-square-broken"] = "rbxassetid://123420858602730",
    	["info-square-line-duotone"] = "rbxassetid://95442077169953",
    	["info-square-linear"] = "rbxassetid://73058260745682",
    	["info-square-outline"] = "rbxassetid://87415284996335",
    	["jar-of-pills-2-bold"] = "rbxassetid://132651755818837",
    	["jar-of-pills-2-bold-duotone"] = "rbxassetid://77975002299873",
    	["jar-of-pills-2-broken"] = "rbxassetid://124405372795866",
    	["jar-of-pills-2-line-duotone"] = "rbxassetid://129956057597200",
    	["jar-of-pills-2-linear"] = "rbxassetid://121473611013330",
    	["jar-of-pills-2-outline"] = "rbxassetid://131043277628736",
    	["jar-of-pills-bold"] = "rbxassetid://103950091083076",
    	["jar-of-pills-bold-duotone"] = "rbxassetid://81416298949064",
    	["jar-of-pills-broken"] = "rbxassetid://74169270935023",
    	["jar-of-pills-line-duotone"] = "rbxassetid://105282957487470",
    	["jar-of-pills-linear"] = "rbxassetid://118506580402974",
    	["jar-of-pills-outline"] = "rbxassetid://72722892879328",
    	["key-bold"] = "rbxassetid://93569468678423",
    	["key-bold-duotone"] = "rbxassetid://107418774101235",
    	["key-broken"] = "rbxassetid://97657391900645",
    	["key-line-duotone"] = "rbxassetid://122428799194111",
    	["key-linear"] = "rbxassetid://134625746131089",
    	["key-minimalistic-2-bold"] = "rbxassetid://79096393495440",
    	["key-minimalistic-2-bold-duotone"] = "rbxassetid://107932037699405",
    	["key-minimalistic-2-broken"] = "rbxassetid://90630769893665",
    	["key-minimalistic-2-line-duotone"] = "rbxassetid://82452464655609",
    	["key-minimalistic-2-linear"] = "rbxassetid://126208371941248",
    	["key-minimalistic-2-outline"] = "rbxassetid://120489847862095",
    	["key-minimalistic-bold"] = "rbxassetid://133574953255757",
    	["key-minimalistic-bold-duotone"] = "rbxassetid://82175402496674",
    	["key-minimalistic-broken"] = "rbxassetid://70885761466452",
    	["key-minimalistic-line-duotone"] = "rbxassetid://132490064181888",
    	["key-minimalistic-linear"] = "rbxassetid://126455954362779",
    	["key-minimalistic-outline"] = "rbxassetid://97362201925714",
    	["key-minimalistic-square-2-bold"] = "rbxassetid://96035142453800",
    	["key-minimalistic-square-2-bold-duotone"] = "rbxassetid://102302314794181",
    	["key-minimalistic-square-2-broken"] = "rbxassetid://87850779939409",
    	["key-minimalistic-square-2-line-duotone"] = "rbxassetid://71690653297466",
    	["key-minimalistic-square-2-linear"] = "rbxassetid://129165714601456",
    	["key-minimalistic-square-2-outline"] = "rbxassetid://105451863182561",
    	["key-minimalistic-square-3-bold"] = "rbxassetid://137963276929413",
    	["key-minimalistic-square-3-bold-duotone"] = "rbxassetid://94646321906508",
    	["key-minimalistic-square-3-broken"] = "rbxassetid://131544122857227",
    	["key-minimalistic-square-3-line-duotone"] = "rbxassetid://121072539001046",
    	["key-minimalistic-square-3-linear"] = "rbxassetid://100134059395367",
    	["key-minimalistic-square-3-outline"] = "rbxassetid://111602860784056",
    	["key-minimalistic-square-bold"] = "rbxassetid://116865300484698",
    	["key-minimalistic-square-bold-duotone"] = "rbxassetid://125254813904107",
    	["key-minimalistic-square-broken"] = "rbxassetid://92202440771025",
    	["key-minimalistic-square-line-duotone"] = "rbxassetid://127460498040993",
    	["key-minimalistic-square-linear"] = "rbxassetid://135213637113180",
    	["key-minimalistic-square-outline"] = "rbxassetid://112793130776817",
    	["key-outline"] = "rbxassetid://120276566974152",
    	["key-square-2-bold"] = "rbxassetid://90069226177359",
    	["key-square-2-bold-duotone"] = "rbxassetid://132380125475218",
    	["key-square-2-broken"] = "rbxassetid://126108224520531",
    	["key-square-2-line-duotone"] = "rbxassetid://120924967569030",
    	["key-square-2-linear"] = "rbxassetid://136752658021999",
    	["key-square-2-outline"] = "rbxassetid://86803014547146",
    	["key-square-bold"] = "rbxassetid://140300865739042",
    	["key-square-bold-duotone"] = "rbxassetid://135617676881066",
    	["key-square-broken"] = "rbxassetid://103306638956685",
    	["key-square-line-duotone"] = "rbxassetid://129031908465119",
    	["key-square-linear"] = "rbxassetid://85271706011668",
    	["key-square-outline"] = "rbxassetid://135407698958253",
    	["keyboard-bold"] = "rbxassetid://140087399831489",
    	["keyboard-bold-duotone"] = "rbxassetid://129703290115714",
    	["keyboard-broken"] = "rbxassetid://82460154562185",
    	["keyboard-line-duotone"] = "rbxassetid://138571081396787",
    	["keyboard-linear"] = "rbxassetid://113055385729412",
    	["keyboard-outline"] = "rbxassetid://126341137700036",
    	["kick-scooter-bold"] = "rbxassetid://77337311538937",
    	["kick-scooter-linear"] = "rbxassetid://126157640930562",
    	["ladle-bold"] = "rbxassetid://76281632345463",
    	["ladle-bold-duotone"] = "rbxassetid://93177501221343",
    	["ladle-broken"] = "rbxassetid://85675705789323",
    	["ladle-line-duotone"] = "rbxassetid://138712076237748",
    	["ladle-linear"] = "rbxassetid://129957351227761",
    	["ladle-outline"] = "rbxassetid://73555969817235",
    	["lamp-bold"] = "rbxassetid://79510744607245",
    	["lamp-bold-duotone"] = "rbxassetid://119773169769589",
    	["lamp-broken"] = "rbxassetid://120113681153484",
    	["lamp-line-duotone"] = "rbxassetid://137619375265444",
    	["lamp-linear"] = "rbxassetid://121715608207125",
    	["lamp-outline"] = "rbxassetid://121897238032658",
    	["laptop-2-bold"] = "rbxassetid://83146254210014",
    	["laptop-2-bold-duotone"] = "rbxassetid://73255631634579",
    	["laptop-2-broken"] = "rbxassetid://118499194042967",
    	["laptop-2-line-duotone"] = "rbxassetid://81697175916572",
    	["laptop-2-linear"] = "rbxassetid://133468672724706",
    	["laptop-2-outline"] = "rbxassetid://122983327344341",
    	["laptop-3-bold"] = "rbxassetid://108781585715333",
    	["laptop-3-bold-duotone"] = "rbxassetid://112626138234212",
    	["laptop-3-broken"] = "rbxassetid://140248725817705",
    	["laptop-3-line-duotone"] = "rbxassetid://93236330672468",
    	["laptop-3-linear"] = "rbxassetid://98675796548102",
    	["laptop-3-outline"] = "rbxassetid://131330885244960",
    	["laptop-bold"] = "rbxassetid://71947327712110",
    	["laptop-bold-duotone"] = "rbxassetid://73811467108735",
    	["laptop-broken"] = "rbxassetid://130756907410415",
    	["laptop-line-duotone"] = "rbxassetid://134768708461835",
    	["laptop-linear"] = "rbxassetid://138211509439239",
    	["laptop-minimalistic-bold"] = "rbxassetid://74400581500001",
    	["laptop-minimalistic-bold-duotone"] = "rbxassetid://94913706969284",
    	["laptop-minimalistic-broken"] = "rbxassetid://105178978192855",
    	["laptop-minimalistic-line-duotone"] = "rbxassetid://71347700218089",
    	["laptop-minimalistic-linear"] = "rbxassetid://106975681296497",
    	["laptop-minimalistic-outline"] = "rbxassetid://78775249567479",
    	["laptop-outline"] = "rbxassetid://89734260341146",
    	["layers-bold"] = "rbxassetid://76370553090551",
    	["layers-bold-duotone"] = "rbxassetid://112417372273558",
    	["layers-broken"] = "rbxassetid://100255412898194",
    	["layers-line-duotone"] = "rbxassetid://75496740534328",
    	["layers-linear"] = "rbxassetid://101145518715776",
    	["layers-minimalistic-bold"] = "rbxassetid://112408985270064",
    	["layers-minimalistic-bold-duotone"] = "rbxassetid://77317311620588",
    	["layers-minimalistic-broken"] = "rbxassetid://105728528447333",
    	["layers-minimalistic-line-duotone"] = "rbxassetid://96920402063089",
    	["layers-minimalistic-linear"] = "rbxassetid://133312354266097",
    	["layers-minimalistic-outline"] = "rbxassetid://135289161522927",
    	["layers-outline"] = "rbxassetid://114728407987106",
    	["leaf-bold"] = "rbxassetid://121283616337277",
    	["leaf-bold-duotone"] = "rbxassetid://76019999639576",
    	["leaf-broken"] = "rbxassetid://135014634634478",
    	["leaf-line-duotone"] = "rbxassetid://107427557085982",
    	["leaf-linear"] = "rbxassetid://72725988750510",
    	["leaf-outline"] = "rbxassetid://122718324851712",
    	["letter-bold"] = "rbxassetid://97695461226778",
    	["letter-bold-duotone"] = "rbxassetid://93916962452911",
    	["letter-broken"] = "rbxassetid://110384614005383",
    	["letter-line-duotone"] = "rbxassetid://116313259221992",
    	["letter-linear"] = "rbxassetid://98487415930615",
    	["letter-opened-bold"] = "rbxassetid://100795825334889",
    	["letter-opened-bold-duotone"] = "rbxassetid://74610401205460",
    	["letter-opened-broken"] = "rbxassetid://82500446617262",
    	["letter-opened-line-duotone"] = "rbxassetid://88992869599579",
    	["letter-opened-linear"] = "rbxassetid://88031939707868",
    	["letter-opened-outline"] = "rbxassetid://72729436324509",
    	["letter-outline"] = "rbxassetid://133554998601253",
    	["letter-unread-bold"] = "rbxassetid://122970067011164",
    	["letter-unread-bold-duotone"] = "rbxassetid://83635567117870",
    	["letter-unread-broken"] = "rbxassetid://79187554532507",
    	["letter-unread-line-duotone"] = "rbxassetid://124334601863332",
    	["letter-unread-linear"] = "rbxassetid://75993614543165",
    	["letter-unread-outline"] = "rbxassetid://108664970775267",
    	["library-bold"] = "rbxassetid://129335697992755",
    	["library-bold-duotone"] = "rbxassetid://120424904137395",
    	["library-broken"] = "rbxassetid://86310050631797",
    	["library-line-duotone"] = "rbxassetid://135801819572905",
    	["library-linear"] = "rbxassetid://96836309640241",
    	["library-outline"] = "rbxassetid://84632746680137",
    	["lightbulb-bold"] = "rbxassetid://115038153659889",
    	["lightbulb-bold-duotone"] = "rbxassetid://139994416384358",
    	["lightbulb-bolt-bold"] = "rbxassetid://110944734577584",
    	["lightbulb-bolt-bold-duotone"] = "rbxassetid://121584436441698",
    	["lightbulb-bolt-broken"] = "rbxassetid://119296641306259",
    	["lightbulb-bolt-line-duotone"] = "rbxassetid://70625664541690",
    	["lightbulb-bolt-linear"] = "rbxassetid://87585645904755",
    	["lightbulb-bolt-outline"] = "rbxassetid://85701839951992",
    	["lightbulb-broken"] = "rbxassetid://76260976048775",
    	["lightbulb-line-duotone"] = "rbxassetid://85868301467056",
    	["lightbulb-linear"] = "rbxassetid://108320101739147",
    	["lightbulb-minimalistic-bold"] = "rbxassetid://116487573327398",
    	["lightbulb-minimalistic-bold-duotone"] = "rbxassetid://75736376574362",
    	["lightbulb-minimalistic-broken"] = "rbxassetid://82630638075639",
    	["lightbulb-minimalistic-line-duotone"] = "rbxassetid://130103142177870",
    	["lightbulb-minimalistic-linear"] = "rbxassetid://122335513269522",
    	["lightbulb-minimalistic-outline"] = "rbxassetid://92749107808191",
    	["lightbulb-outline"] = "rbxassetid://129358162373289",
    	["lightning-bold"] = "rbxassetid://89278362360178",
    	["lightning-bold-duotone"] = "rbxassetid://94156080974945",
    	["lightning-broken"] = "rbxassetid://84160856819197",
    	["lightning-line-duotone"] = "rbxassetid://139365162950104",
    	["lightning-linear"] = "rbxassetid://98289464495631",
    	["lightning-outline"] = "rbxassetid://100029894809281",
    	["like-bold"] = "rbxassetid://92774442572396",
    	["like-bold-duotone"] = "rbxassetid://103394417556622",
    	["like-broken"] = "rbxassetid://99635481427733",
    	["like-line-duotone"] = "rbxassetid://101578188025677",
    	["like-linear"] = "rbxassetid://93108209287179",
    	["like-outline"] = "rbxassetid://118921629286639",
    	["link-bold"] = "rbxassetid://71038734318580",
    	["link-bold-duotone"] = "rbxassetid://72006204990285",
    	["link-broken"] = "rbxassetid://96554127469375",
    	["link-broken-bold"] = "rbxassetid://120022598023679",
    	["link-broken-bold-duotone"] = "rbxassetid://109523688344825",
    	["link-broken-broken"] = "rbxassetid://85558035350677",
    	["link-broken-line-duotone"] = "rbxassetid://130438257222559",
    	["link-broken-linear"] = "rbxassetid://109902624509141",
    	["link-broken-minimalistic-bold"] = "rbxassetid://108137121204402",
    	["link-broken-minimalistic-bold-duotone"] = "rbxassetid://111459765741730",
    	["link-broken-minimalistic-broken"] = "rbxassetid://106545558982252",
    	["link-broken-minimalistic-line-duotone"] = "rbxassetid://118103260070599",
    	["link-broken-minimalistic-linear"] = "rbxassetid://128649480019080",
    	["link-broken-minimalistic-outline"] = "rbxassetid://76679326709428",
    	["link-broken-outline"] = "rbxassetid://77465703090651",
    	["link-circle-bold"] = "rbxassetid://75912193654076",
    	["link-circle-bold-duotone"] = "rbxassetid://110558126466490",
    	["link-circle-broken"] = "rbxassetid://88389259663465",
    	["link-circle-line-duotone"] = "rbxassetid://89358101700658",
    	["link-circle-linear"] = "rbxassetid://101675935979902",
    	["link-circle-outline"] = "rbxassetid://82231966342646",
    	["link-line-duotone"] = "rbxassetid://75921684805902",
    	["link-linear"] = "rbxassetid://98269530128338",
    	["link-minimalistic-2-bold"] = "rbxassetid://73371793592887",
    	["link-minimalistic-2-bold-duotone"] = "rbxassetid://75793695431687",
    	["link-minimalistic-2-broken"] = "rbxassetid://81065134505437",
    	["link-minimalistic-2-line-duotone"] = "rbxassetid://138941730272221",
    	["link-minimalistic-2-linear"] = "rbxassetid://128752318540649",
    	["link-minimalistic-2-outline"] = "rbxassetid://131299740022120",
    	["link-minimalistic-bold"] = "rbxassetid://90998085196725",
    	["link-minimalistic-bold-duotone"] = "rbxassetid://124563966988179",
    	["link-minimalistic-broken"] = "rbxassetid://93489670355314",
    	["link-minimalistic-line-duotone"] = "rbxassetid://95883913521347",
    	["link-minimalistic-linear"] = "rbxassetid://103400824023369",
    	["link-minimalistic-outline"] = "rbxassetid://114164675023193",
    	["link-outline"] = "rbxassetid://95589629325178",
    	["link-round-angle-bold"] = "rbxassetid://100204314620474",
    	["link-round-angle-bold-duotone"] = "rbxassetid://140071567085514",
    	["link-round-angle-broken"] = "rbxassetid://119613029666073",
    	["link-round-angle-line-duotone"] = "rbxassetid://116259958886417",
    	["link-round-angle-linear"] = "rbxassetid://102140072312729",
    	["link-round-angle-outline"] = "rbxassetid://114255328783751",
    	["link-round-bold"] = "rbxassetid://91263312996877",
    	["link-round-bold-duotone"] = "rbxassetid://84967339033820",
    	["link-round-broken"] = "rbxassetid://137215759228504",
    	["link-round-line-duotone"] = "rbxassetid://91262707448122",
    	["link-round-linear"] = "rbxassetid://138163687446265",
    	["link-round-outline"] = "rbxassetid://98858295685603",
    	["link-square-bold"] = "rbxassetid://138720591143154",
    	["link-square-bold-duotone"] = "rbxassetid://81703838465866",
    	["link-square-broken"] = "rbxassetid://107186979446611",
    	["link-square-line-duotone"] = "rbxassetid://111055212934390",
    	["link-square-linear"] = "rbxassetid://82907837732179",
    	["link-square-outline"] = "rbxassetid://129377943583913",
    	["list-1-bold"] = "rbxassetid://77829614179818",
    	["list-1-bold-duotone"] = "rbxassetid://125943209047840",
    	["list-1-broken"] = "rbxassetid://118376560075928",
    	["list-1-line-duotone"] = "rbxassetid://130434580178796",
    	["list-1-linear"] = "rbxassetid://76478134384638",
    	["list-1-outline"] = "rbxassetid://125449886494716",
    	["list-arrow-down-bold"] = "rbxassetid://100524319044924",
    	["list-arrow-down-bold-duotone"] = "rbxassetid://100519458735895",
    	["list-arrow-down-broken"] = "rbxassetid://133775058634684",
    	["list-arrow-down-line-duotone"] = "rbxassetid://106840759977644",
    	["list-arrow-down-linear"] = "rbxassetid://98599096939320",
    	["list-arrow-down-minimalistic-bold"] = "rbxassetid://75040706926636",
    	["list-arrow-down-minimalistic-bold-duotone"] = "rbxassetid://112562364541481",
    	["list-arrow-down-minimalistic-broken"] = "rbxassetid://122874299572626",
    	["list-arrow-down-minimalistic-line-duotone"] = "rbxassetid://86047460956675",
    	["list-arrow-down-minimalistic-linear"] = "rbxassetid://127315745467828",
    	["list-arrow-down-minimalistic-outline"] = "rbxassetid://81403304279525",
    	["list-arrow-down-outline"] = "rbxassetid://96026980687191",
    	["list-arrow-up-bold"] = "rbxassetid://116073837413607",
    	["list-arrow-up-bold-duotone"] = "rbxassetid://95992634181797",
    	["list-arrow-up-broken"] = "rbxassetid://105767817419802",
    	["list-arrow-up-line-duotone"] = "rbxassetid://101702231559263",
    	["list-arrow-up-linear"] = "rbxassetid://132497492111354",
    	["list-arrow-up-minimalistic-bold"] = "rbxassetid://81415474234835",
    	["list-arrow-up-minimalistic-bold-duotone"] = "rbxassetid://95133956234758",
    	["list-arrow-up-minimalistic-broken"] = "rbxassetid://127445215474959",
    	["list-arrow-up-minimalistic-line-duotone"] = "rbxassetid://129834292569024",
    	["list-arrow-up-minimalistic-linear"] = "rbxassetid://132592373944358",
    	["list-arrow-up-minimalistic-outline"] = "rbxassetid://123342346140187",
    	["list-arrow-up-outline"] = "rbxassetid://77557060361384",
    	["list-bold"] = "rbxassetid://76813409396375",
    	["list-bold-duotone"] = "rbxassetid://82893735121175",
    	["list-broken"] = "rbxassetid://121717139550136",
    	["list-check-bold"] = "rbxassetid://89754806507060",
    	["list-check-bold-duotone"] = "rbxassetid://93197821329077",
    	["list-check-broken"] = "rbxassetid://124373951994873",
    	["list-check-line-duotone"] = "rbxassetid://118384573404337",
    	["list-check-linear"] = "rbxassetid://133227621229086",
    	["list-check-minimalistic-bold"] = "rbxassetid://81557739889362",
    	["list-check-minimalistic-bold-duotone"] = "rbxassetid://77927522219655",
    	["list-check-minimalistic-broken"] = "rbxassetid://123103700955117",
    	["list-check-minimalistic-line-duotone"] = "rbxassetid://93408020695513",
    	["list-check-minimalistic-linear"] = "rbxassetid://121355095577299",
    	["list-check-minimalistic-outline"] = "rbxassetid://112120895974129",
    	["list-check-outline"] = "rbxassetid://123033013455780",
    	["list-cross-bold"] = "rbxassetid://109760310655770",
    	["list-cross-bold-duotone"] = "rbxassetid://101618140262275",
    	["list-cross-broken"] = "rbxassetid://121571035972923",
    	["list-cross-line-duotone"] = "rbxassetid://85189200905322",
    	["list-cross-linear"] = "rbxassetid://131904525035138",
    	["list-cross-minimalistic-bold"] = "rbxassetid://87719958292663",
    	["list-cross-minimalistic-bold-duotone"] = "rbxassetid://97226812090755",
    	["list-cross-minimalistic-broken"] = "rbxassetid://98857161831989",
    	["list-cross-minimalistic-line-duotone"] = "rbxassetid://125827842834139",
    	["list-cross-minimalistic-linear"] = "rbxassetid://95802821599515",
    	["list-cross-minimalistic-outline"] = "rbxassetid://106798791124836",
    	["list-cross-outline"] = "rbxassetid://101224661428126",
    	["list-down-bold"] = "rbxassetid://100158705699286",
    	["list-down-bold-duotone"] = "rbxassetid://125056285013924",
    	["list-down-broken"] = "rbxassetid://101761608094291",
    	["list-down-line-duotone"] = "rbxassetid://80807933902203",
    	["list-down-linear"] = "rbxassetid://120307968840975",
    	["list-down-minimalistic-bold"] = "rbxassetid://120189029652039",
    	["list-down-minimalistic-bold-duotone"] = "rbxassetid://128503484251369",
    	["list-down-minimalistic-broken"] = "rbxassetid://119735385044849",
    	["list-down-minimalistic-line-duotone"] = "rbxassetid://125126724525533",
    	["list-down-minimalistic-linear"] = "rbxassetid://114578762972759",
    	["list-down-minimalistic-outline"] = "rbxassetid://73122473309442",
    	["list-down-outline"] = "rbxassetid://129928561811073",
    	["list-heart-bold"] = "rbxassetid://106712373076387",
    	["list-heart-bold-duotone"] = "rbxassetid://81456074078941",
    	["list-heart-broken"] = "rbxassetid://109052564571194",
    	["list-heart-line-duotone"] = "rbxassetid://106233450601855",
    	["list-heart-linear"] = "rbxassetid://104824027608517",
    	["list-heart-minimalistic-bold"] = "rbxassetid://104682553146049",
    	["list-heart-minimalistic-bold-duotone"] = "rbxassetid://137690242201521",
    	["list-heart-minimalistic-broken"] = "rbxassetid://83318424751139",
    	["list-heart-minimalistic-line-duotone"] = "rbxassetid://96477311883371",
    	["list-heart-minimalistic-linear"] = "rbxassetid://135794953640248",
    	["list-heart-minimalistic-outline"] = "rbxassetid://131687446065188",
    	["list-heart-outline"] = "rbxassetid://79384336158096",
    	["list-line-duotone"] = "rbxassetid://74643637194902",
    	["list-linear"] = "rbxassetid://121044678685848",
    	["list-outline"] = "rbxassetid://135744134213284",
    	["list-up-bold"] = "rbxassetid://113299345449674",
    	["list-up-bold-duotone"] = "rbxassetid://110056201277354",
    	["list-up-broken"] = "rbxassetid://137904488131939",
    	["list-up-line-duotone"] = "rbxassetid://134687444814628",
    	["list-up-linear"] = "rbxassetid://137561679382767",
    	["list-up-minimalistic-bold"] = "rbxassetid://126556397787371",
    	["list-up-minimalistic-bold-duotone"] = "rbxassetid://81451428006822",
    	["list-up-minimalistic-broken"] = "rbxassetid://114173078531712",
    	["list-up-minimalistic-line-duotone"] = "rbxassetid://116631345517408",
    	["list-up-minimalistic-linear"] = "rbxassetid://133598493453322",
    	["list-up-minimalistic-outline"] = "rbxassetid://104747376686282",
    	["list-up-outline"] = "rbxassetid://140015302138680",
    	["lock-bold"] = "rbxassetid://108603238886118",
    	["lock-bold-duotone"] = "rbxassetid://83847817519051",
    	["lock-broken"] = "rbxassetid://85198630107333",
    	["lock-keyhole-bold"] = "rbxassetid://80719048568900",
    	["lock-keyhole-bold-duotone"] = "rbxassetid://94336963605314",
    	["lock-keyhole-broken"] = "rbxassetid://85278007521182",
    	["lock-keyhole-line-duotone"] = "rbxassetid://83891586046705",
    	["lock-keyhole-linear"] = "rbxassetid://131199309687292",
    	["lock-keyhole-minimalistic-bold"] = "rbxassetid://117620446004855",
    	["lock-keyhole-minimalistic-bold-duotone"] = "rbxassetid://104141703829389",
    	["lock-keyhole-minimalistic-broken"] = "rbxassetid://107246075940984",
    	["lock-keyhole-minimalistic-line-duotone"] = "rbxassetid://79232100377310",
    	["lock-keyhole-minimalistic-linear"] = "rbxassetid://76382957317432",
    	["lock-keyhole-minimalistic-outline"] = "rbxassetid://92719722740927",
    	["lock-keyhole-minimalistic-unlocked-bold"] = "rbxassetid://125741681069531",
    	["lock-keyhole-minimalistic-unlocked-bold-duotone"] = "rbxassetid://77267395480555",
    	["lock-keyhole-minimalistic-unlocked-broken"] = "rbxassetid://104006990667431",
    	["lock-keyhole-minimalistic-unlocked-line-duotone"] = "rbxassetid://98786197251968",
    	["lock-keyhole-minimalistic-unlocked-linear"] = "rbxassetid://94386864215076",
    	["lock-keyhole-minimalistic-unlocked-outline"] = "rbxassetid://127933320706248",
    	["lock-keyhole-outline"] = "rbxassetid://85227903429699",
    	["lock-keyhole-unlocked-bold"] = "rbxassetid://98188856634746",
    	["lock-keyhole-unlocked-bold-duotone"] = "rbxassetid://72607391547051",
    	["lock-keyhole-unlocked-broken"] = "rbxassetid://73150612890868",
    	["lock-keyhole-unlocked-line-duotone"] = "rbxassetid://81485922161608",
    	["lock-keyhole-unlocked-linear"] = "rbxassetid://133988748530281",
    	["lock-keyhole-unlocked-outline"] = "rbxassetid://102441788951773",
    	["lock-line-duotone"] = "rbxassetid://94562315625333",
    	["lock-linear"] = "rbxassetid://98462160915351",
    	["lock-outline"] = "rbxassetid://84671551273645",
    	["lock-password-bold"] = "rbxassetid://135892778188250",
    	["lock-password-bold-duotone"] = "rbxassetid://139022630577069",
    	["lock-password-broken"] = "rbxassetid://136586703829846",
    	["lock-password-line-duotone"] = "rbxassetid://75572143091436",
    	["lock-password-linear"] = "rbxassetid://91059659907350",
    	["lock-password-outline"] = "rbxassetid://98869210056284",
    	["lock-password-unlocked-bold"] = "rbxassetid://90454261228974",
    	["lock-password-unlocked-bold-duotone"] = "rbxassetid://104771878499677",
    	["lock-password-unlocked-broken"] = "rbxassetid://82790475097265",
    	["lock-password-unlocked-line-duotone"] = "rbxassetid://131435507816760",
    	["lock-password-unlocked-linear"] = "rbxassetid://91002313690204",
    	["lock-password-unlocked-outline"] = "rbxassetid://139522350083217",
    	["lock-unlocked-bold"] = "rbxassetid://128063016456306",
    	["lock-unlocked-bold-duotone"] = "rbxassetid://92761554023747",
    	["lock-unlocked-broken"] = "rbxassetid://115331464277145",
    	["lock-unlocked-line-duotone"] = "rbxassetid://94705039302043",
    	["lock-unlocked-linear"] = "rbxassetid://117442316361058",
    	["lock-unlocked-outline"] = "rbxassetid://78687695256809",
    	["login-2-bold"] = "rbxassetid://114971775323276",
    	["login-2-bold-duotone"] = "rbxassetid://139317194075422",
    	["login-2-broken"] = "rbxassetid://90076561668007",
    	["login-2-line-duotone"] = "rbxassetid://81761912600182",
    	["login-2-linear"] = "rbxassetid://80599608998009",
    	["login-2-outline"] = "rbxassetid://116516846646888",
    	["login-3-bold"] = "rbxassetid://128849528093452",
    	["login-3-bold-duotone"] = "rbxassetid://128106180903603",
    	["login-3-broken"] = "rbxassetid://119585035601250",
    	["login-3-line-duotone"] = "rbxassetid://80052793056324",
    	["login-3-linear"] = "rbxassetid://75674912460552",
    	["login-3-outline"] = "rbxassetid://107018941860057",
    	["login-bold"] = "rbxassetid://134954817189826",
    	["login-bold-duotone"] = "rbxassetid://75648784713664",
    	["login-broken"] = "rbxassetid://89401128867606",
    	["login-line-duotone"] = "rbxassetid://80564380144801",
    	["login-linear"] = "rbxassetid://81443731401344",
    	["login-outline"] = "rbxassetid://82262415142962",
    	["logout-2-bold"] = "rbxassetid://95446907300146",
    	["logout-2-bold-duotone"] = "rbxassetid://114300000092550",
    	["logout-2-broken"] = "rbxassetid://72194717903918",
    	["logout-2-line-duotone"] = "rbxassetid://129668649028251",
    	["logout-2-linear"] = "rbxassetid://129416388854965",
    	["logout-2-outline"] = "rbxassetid://99675941655562",
    	["logout-3-bold"] = "rbxassetid://75780860392006",
    	["logout-3-bold-duotone"] = "rbxassetid://120218118683795",
    	["logout-3-broken"] = "rbxassetid://104523887135470",
    	["logout-3-line-duotone"] = "rbxassetid://135018189716888",
    	["logout-3-linear"] = "rbxassetid://91556870344141",
    	["logout-3-outline"] = "rbxassetid://72303658285669",
    	["logout-bold"] = "rbxassetid://98485068966564",
    	["logout-bold-duotone"] = "rbxassetid://123348018229792",
    	["logout-broken"] = "rbxassetid://89045387971426",
    	["logout-line-duotone"] = "rbxassetid://137681964003996",
    	["logout-linear"] = "rbxassetid://107048331682423",
    	["logout-outline"] = "rbxassetid://126935702356792",
    	["magic-stick-2-bold"] = "rbxassetid://103228889397546",
    	["magic-stick-2-bold-duotone"] = "rbxassetid://93162452683663",
    	["magic-stick-2-broken"] = "rbxassetid://117325642046390",
    	["magic-stick-2-line-duotone"] = "rbxassetid://109230777736627",
    	["magic-stick-2-linear"] = "rbxassetid://108509593217354",
    	["magic-stick-2-outline"] = "rbxassetid://109613675829509",
    	["magic-stick-3-bold"] = "rbxassetid://134561599449883",
    	["magic-stick-3-bold-duotone"] = "rbxassetid://106437662573780",
    	["magic-stick-3-broken"] = "rbxassetid://137211049881614",
    	["magic-stick-3-line-duotone"] = "rbxassetid://117227057284286",
    	["magic-stick-3-linear"] = "rbxassetid://100541978530972",
    	["magic-stick-3-outline"] = "rbxassetid://128049765830458",
    	["magic-stick-bold"] = "rbxassetid://83508311570631",
    	["magic-stick-bold-duotone"] = "rbxassetid://104064464748424",
    	["magic-stick-broken"] = "rbxassetid://73910425916602",
    	["magic-stick-line-duotone"] = "rbxassetid://87253933422584",
    	["magic-stick-linear"] = "rbxassetid://101926753053136",
    	["magic-stick-outline"] = "rbxassetid://92765768390568",
    	["magnet-bold"] = "rbxassetid://93385488760013",
    	["magnet-bold-duotone"] = "rbxassetid://139047596428835",
    	["magnet-broken"] = "rbxassetid://89561715867484",
    	["magnet-line-duotone"] = "rbxassetid://99941195642850",
    	["magnet-linear"] = "rbxassetid://127408058532395",
    	["magnet-outline"] = "rbxassetid://92801797178715",
    	["magnet-wave-bold"] = "rbxassetid://98654860608359",
    	["magnet-wave-bold-duotone"] = "rbxassetid://87271718493821",
    	["magnet-wave-broken"] = "rbxassetid://108478622604710",
    	["magnet-wave-line-duotone"] = "rbxassetid://88119603619249",
    	["magnet-wave-linear"] = "rbxassetid://99979087284880",
    	["magnet-wave-outline"] = "rbxassetid://87993816212460",
    	["magnifer-bold"] = "rbxassetid://75236956926329",
    	["magnifer-bold-duotone"] = "rbxassetid://72259936728551",
    	["magnifer-broken"] = "rbxassetid://126627695039401",
    	["magnifer-bug-bold"] = "rbxassetid://92109851157710",
    	["magnifer-bug-bold-duotone"] = "rbxassetid://75964581300114",
    	["magnifer-bug-broken"] = "rbxassetid://128559041096918",
    	["magnifer-bug-line-duotone"] = "rbxassetid://103841262355403",
    	["magnifer-bug-linear"] = "rbxassetid://91805623698560",
    	["magnifer-bug-outline"] = "rbxassetid://86279815715522",
    	["magnifer-line-duotone"] = "rbxassetid://125717782373831",
    	["magnifer-linear"] = "rbxassetid://79669273658084",
    	["magnifer-outline"] = "rbxassetid://80525237105311",
    	["magnifer-zoom-in-bold"] = "rbxassetid://138187229750019",
    	["magnifer-zoom-in-bold-duotone"] = "rbxassetid://85672463616021",
    	["magnifer-zoom-in-broken"] = "rbxassetid://95294279763365",
    	["magnifer-zoom-in-line-duotone"] = "rbxassetid://107931415763326",
    	["magnifer-zoom-in-linear"] = "rbxassetid://91616047915202",
    	["magnifer-zoom-in-outline"] = "rbxassetid://138663476550963",
    	["magnifer-zoom-out-bold"] = "rbxassetid://135785169154622",
    	["magnifer-zoom-out-bold-duotone"] = "rbxassetid://105387007268842",
    	["magnifer-zoom-out-broken"] = "rbxassetid://115889185244855",
    	["magnifer-zoom-out-line-duotone"] = "rbxassetid://90639740412010",
    	["magnifer-zoom-out-linear"] = "rbxassetid://95767773130270",
    	["magnifer-zoom-out-outline"] = "rbxassetid://103100978952733",
    	["mailbox-bold"] = "rbxassetid://102244768845572",
    	["mailbox-bold-duotone"] = "rbxassetid://120437586811554",
    	["mailbox-broken"] = "rbxassetid://138268458564253",
    	["mailbox-line-duotone"] = "rbxassetid://91224885300805",
    	["mailbox-linear"] = "rbxassetid://124074316195211",
    	["mailbox-outline"] = "rbxassetid://86162845539361",
    	["map-arrow-down-bold"] = "rbxassetid://108308968641524",
    	["map-arrow-down-bold-duotone"] = "rbxassetid://70769825980835",
    	["map-arrow-down-broken"] = "rbxassetid://106892968100345",
    	["map-arrow-down-line-duotone"] = "rbxassetid://71291933065086",
    	["map-arrow-down-linear"] = "rbxassetid://114629893048334",
    	["map-arrow-down-outline"] = "rbxassetid://79076005674077",
    	["map-arrow-left-bold"] = "rbxassetid://97095461629716",
    	["map-arrow-left-bold-duotone"] = "rbxassetid://80428655369474",
    	["map-arrow-left-broken"] = "rbxassetid://129319696838630",
    	["map-arrow-left-line-duotone"] = "rbxassetid://92433685320717",
    	["map-arrow-left-linear"] = "rbxassetid://77556529094011",
    	["map-arrow-left-outline"] = "rbxassetid://74856401869676",
    	["map-arrow-right-bold"] = "rbxassetid://111905824347529",
    	["map-arrow-right-bold-duotone"] = "rbxassetid://92364733744245",
    	["map-arrow-right-broken"] = "rbxassetid://78934511787110",
    	["map-arrow-right-line-duotone"] = "rbxassetid://116636987953899",
    	["map-arrow-right-linear"] = "rbxassetid://87621594668431",
    	["map-arrow-right-outline"] = "rbxassetid://128000048349508",
    	["map-arrow-square-bold"] = "rbxassetid://136453679510712",
    	["map-arrow-square-bold-duotone"] = "rbxassetid://102970499141914",
    	["map-arrow-square-broken"] = "rbxassetid://123565002910728",
    	["map-arrow-square-line-duotone"] = "rbxassetid://88443741719089",
    	["map-arrow-square-linear"] = "rbxassetid://84375025246360",
    	["map-arrow-square-outline"] = "rbxassetid://97593114369995",
    	["map-arrow-up-bold"] = "rbxassetid://109164912555932",
    	["map-arrow-up-bold-duotone"] = "rbxassetid://90854568952990",
    	["map-arrow-up-broken"] = "rbxassetid://135523733506777",
    	["map-arrow-up-line-duotone"] = "rbxassetid://107676953038513",
    	["map-arrow-up-linear"] = "rbxassetid://123905781038009",
    	["map-arrow-up-outline"] = "rbxassetid://130123268975988",
    	["map-bold"] = "rbxassetid://100008589043828",
    	["map-bold-duotone"] = "rbxassetid://101515742820864",
    	["map-broken"] = "rbxassetid://92774076449436",
    	["map-line-duotone"] = "rbxassetid://137490889440242",
    	["map-linear"] = "rbxassetid://131244263198330",
    	["map-outline"] = "rbxassetid://138449226411947",
    	["map-point-add-bold"] = "rbxassetid://86384257635691",
    	["map-point-add-bold-duotone"] = "rbxassetid://89385171768830",
    	["map-point-add-broken"] = "rbxassetid://122053652102818",
    	["map-point-add-line-duotone"] = "rbxassetid://132060576611187",
    	["map-point-add-linear"] = "rbxassetid://83353575840406",
    	["map-point-add-outline"] = "rbxassetid://108516445485487",
    	["map-point-bold"] = "rbxassetid://81558365588892",
    	["map-point-bold-duotone"] = "rbxassetid://79234177948795",
    	["map-point-broken"] = "rbxassetid://103388623017879",
    	["map-point-favourite-bold"] = "rbxassetid://115064342223946",
    	["map-point-favourite-bold-duotone"] = "rbxassetid://112075632018579",
    	["map-point-favourite-broken"] = "rbxassetid://85394685159432",
    	["map-point-favourite-line-duotone"] = "rbxassetid://112584791394170",
    	["map-point-favourite-linear"] = "rbxassetid://94631164983643",
    	["map-point-favourite-outline"] = "rbxassetid://72163167947252",
    	["map-point-hospital-bold"] = "rbxassetid://86957509039152",
    	["map-point-hospital-bold-duotone"] = "rbxassetid://125208165265033",
    	["map-point-hospital-broken"] = "rbxassetid://90323121401828",
    	["map-point-hospital-line-duotone"] = "rbxassetid://94927519037774",
    	["map-point-hospital-linear"] = "rbxassetid://95189576676258",
    	["map-point-hospital-outline"] = "rbxassetid://107702341905700",
    	["map-point-line-duotone"] = "rbxassetid://121139802633548",
    	["map-point-linear"] = "rbxassetid://114557087159852",
    	["map-point-outline"] = "rbxassetid://135197284465235",
    	["map-point-remove-bold"] = "rbxassetid://122276536498683",
    	["map-point-remove-bold-duotone"] = "rbxassetid://90470086902658",
    	["map-point-remove-broken"] = "rbxassetid://116055734444659",
    	["map-point-remove-line-duotone"] = "rbxassetid://139186369978798",
    	["map-point-remove-linear"] = "rbxassetid://106685110100723",
    	["map-point-remove-outline"] = "rbxassetid://87952414361301",
    	["map-point-rotate-bold"] = "rbxassetid://80973262724422",
    	["map-point-rotate-bold-duotone"] = "rbxassetid://117260323084283",
    	["map-point-rotate-broken"] = "rbxassetid://81596817188805",
    	["map-point-rotate-line-duotone"] = "rbxassetid://113728572277577",
    	["map-point-rotate-linear"] = "rbxassetid://129230482872972",
    	["map-point-rotate-outline"] = "rbxassetid://89437215681726",
    	["map-point-school-bold"] = "rbxassetid://83753429411685",
    	["map-point-school-bold-duotone"] = "rbxassetid://73109534091266",
    	["map-point-school-broken"] = "rbxassetid://88598681678453",
    	["map-point-school-line-duotone"] = "rbxassetid://102907444464921",
    	["map-point-school-linear"] = "rbxassetid://80303269480238",
    	["map-point-school-outline"] = "rbxassetid://125264001999503",
    	["map-point-search-bold"] = "rbxassetid://102729325455587",
    	["map-point-search-bold-duotone"] = "rbxassetid://73960658393748",
    	["map-point-search-broken"] = "rbxassetid://109324067508581",
    	["map-point-search-line-duotone"] = "rbxassetid://77498746664935",
    	["map-point-search-linear"] = "rbxassetid://133623537851922",
    	["map-point-search-outline"] = "rbxassetid://82740275134754",
    	["map-point-wave-bold"] = "rbxassetid://103536088661531",
    	["map-point-wave-bold-duotone"] = "rbxassetid://140510432715538",
    	["map-point-wave-broken"] = "rbxassetid://72707953778308",
    	["map-point-wave-line-duotone"] = "rbxassetid://92702989178844",
    	["map-point-wave-linear"] = "rbxassetid://96692545406563",
    	["map-point-wave-outline"] = "rbxassetid://92018067642690",
    	["mask-happly-bold"] = "rbxassetid://115192008441532",
    	["mask-happly-bold-duotone"] = "rbxassetid://139409101374413",
    	["mask-happly-broken"] = "rbxassetid://110330568401142",
    	["mask-happly-line-duotone"] = "rbxassetid://109095466552436",
    	["mask-happly-linear"] = "rbxassetid://114271077115822",
    	["mask-happly-outline"] = "rbxassetid://121891681251885",
    	["mask-sad-bold"] = "rbxassetid://91365282297784",
    	["mask-sad-bold-duotone"] = "rbxassetid://97407726794426",
    	["mask-sad-broken"] = "rbxassetid://99517564076139",
    	["mask-sad-line-duotone"] = "rbxassetid://115294059874525",
    	["mask-sad-linear"] = "rbxassetid://96873150994070",
    	["mask-sad-outline"] = "rbxassetid://88779859374822",
    	["masks-bold"] = "rbxassetid://117744266908530",
    	["masks-bold-duotone"] = "rbxassetid://132782537731356",
    	["masks-broken"] = "rbxassetid://114746115329706",
    	["masks-line-duotone"] = "rbxassetid://89074513220104",
    	["masks-linear"] = "rbxassetid://82069385052802",
    	["masks-outline"] = "rbxassetid://105301043338489",
    	["maximize-bold"] = "rbxassetid://135835129702009",
    	["maximize-bold-duotone"] = "rbxassetid://93571634992243",
    	["maximize-broken"] = "rbxassetid://76004526135364",
    	["maximize-line-duotone"] = "rbxassetid://70442149178248",
    	["maximize-linear"] = "rbxassetid://121710734276253",
    	["maximize-outline"] = "rbxassetid://134108070048026",
    	["maximize-square-2-bold"] = "rbxassetid://85020484543438",
    	["maximize-square-2-bold-duotone"] = "rbxassetid://74431330695424",
    	["maximize-square-2-broken"] = "rbxassetid://137768854082963",
    	["maximize-square-2-line-duotone"] = "rbxassetid://116314819392812",
    	["maximize-square-2-linear"] = "rbxassetid://91543634308612",
    	["maximize-square-2-outline"] = "rbxassetid://133657060761164",
    	["maximize-square-3-bold"] = "rbxassetid://138780470772627",
    	["maximize-square-3-bold-duotone"] = "rbxassetid://135067483093614",
    	["maximize-square-3-broken"] = "rbxassetid://120003737060163",
    	["maximize-square-3-line-duotone"] = "rbxassetid://76604774324738",
    	["maximize-square-3-linear"] = "rbxassetid://96229470655182",
    	["maximize-square-3-outline"] = "rbxassetid://81989230219732",
    	["maximize-square-bold"] = "rbxassetid://92640655416045",
    	["maximize-square-bold-duotone"] = "rbxassetid://100422964542225",
    	["maximize-square-broken"] = "rbxassetid://70964685616613",
    	["maximize-square-line-duotone"] = "rbxassetid://77690800722794",
    	["maximize-square-linear"] = "rbxassetid://91101498118904",
    	["maximize-square-minimalistic-bold"] = "rbxassetid://124192972540754",
    	["maximize-square-minimalistic-bold-duotone"] = "rbxassetid://137926178748375",
    	["maximize-square-minimalistic-broken"] = "rbxassetid://122481891968634",
    	["maximize-square-minimalistic-line-duotone"] = "rbxassetid://132020566650947",
    	["maximize-square-minimalistic-linear"] = "rbxassetid://127850946294637",
    	["maximize-square-minimalistic-outline"] = "rbxassetid://98120147666583",
    	["maximize-square-outline"] = "rbxassetid://97351623117243",
    	["medal-ribbon-bold"] = "rbxassetid://86474998278598",
    	["medal-ribbon-bold-duotone"] = "rbxassetid://92343066605010",
    	["medal-ribbon-broken"] = "rbxassetid://105324945372649",
    	["medal-ribbon-line-duotone"] = "rbxassetid://85544924903341",
    	["medal-ribbon-linear"] = "rbxassetid://130468600543017",
    	["medal-ribbon-outline"] = "rbxassetid://113794198620960",
    	["medal-ribbon-star-bold"] = "rbxassetid://109915712384772",
    	["medal-ribbon-star-bold-duotone"] = "rbxassetid://95324826042375",
    	["medal-ribbon-star-broken"] = "rbxassetid://85839441134417",
    	["medal-ribbon-star-line-duotone"] = "rbxassetid://116209591339305",
    	["medal-ribbon-star-linear"] = "rbxassetid://71254776478759",
    	["medal-ribbon-star-outline"] = "rbxassetid://76419760578988",
    	["medal-ribbons-star-bold"] = "rbxassetid://137542540514252",
    	["medal-ribbons-star-bold-duotone"] = "rbxassetid://96322806005803",
    	["medal-ribbons-star-broken"] = "rbxassetid://95362691825941",
    	["medal-ribbons-star-line-duotone"] = "rbxassetid://94044633023036",
    	["medal-ribbons-star-linear"] = "rbxassetid://127202074667120",
    	["medal-ribbons-star-outline"] = "rbxassetid://76531493834053",
    	["medal-star-bold"] = "rbxassetid://108976549774193",
    	["medal-star-bold-duotone"] = "rbxassetid://122383553080021",
    	["medal-star-broken"] = "rbxassetid://136264266293626",
    	["medal-star-circle-bold"] = "rbxassetid://116597217497183",
    	["medal-star-circle-bold-duotone"] = "rbxassetid://85017341543007",
    	["medal-star-circle-broken"] = "rbxassetid://94266153494715",
    	["medal-star-circle-line-duotone"] = "rbxassetid://104717207444347",
    	["medal-star-circle-linear"] = "rbxassetid://137587094368792",
    	["medal-star-circle-outline"] = "rbxassetid://94763057332674",
    	["medal-star-line-duotone"] = "rbxassetid://140629690955858",
    	["medal-star-linear"] = "rbxassetid://140028830986435",
    	["medal-star-outline"] = "rbxassetid://114554888057763",
    	["medal-star-square-bold"] = "rbxassetid://133081107505472",
    	["medal-star-square-bold-duotone"] = "rbxassetid://140046232060132",
    	["medal-star-square-broken"] = "rbxassetid://81784977742366",
    	["medal-star-square-line-duotone"] = "rbxassetid://70973453196767",
    	["medal-star-square-linear"] = "rbxassetid://74227507818263",
    	["medal-star-square-outline"] = "rbxassetid://81269918081049",
    	["medical-kit-bold"] = "rbxassetid://109186510977291",
    	["medical-kit-bold-duotone"] = "rbxassetid://76448912882365",
    	["medical-kit-broken"] = "rbxassetid://83907544030147",
    	["medical-kit-line-duotone"] = "rbxassetid://103448189164017",
    	["medical-kit-linear"] = "rbxassetid://91758348990481",
    	["medical-kit-outline"] = "rbxassetid://91070279360089",
    	["meditation-bold"] = "rbxassetid://134230884627081",
    	["meditation-bold-duotone"] = "rbxassetid://90831952123618",
    	["meditation-broken"] = "rbxassetid://81021067397483",
    	["meditation-line-duotone"] = "rbxassetid://99771350683621",
    	["meditation-linear"] = "rbxassetid://74063239282643",
    	["meditation-outline"] = "rbxassetid://140511972173946",
    	["meditation-round-bold"] = "rbxassetid://105326614317912",
    	["meditation-round-bold-duotone"] = "rbxassetid://123614566850129",
    	["meditation-round-broken"] = "rbxassetid://89230140941539",
    	["meditation-round-line-duotone"] = "rbxassetid://77285121453646",
    	["meditation-round-linear"] = "rbxassetid://99055835497102",
    	["meditation-round-outline"] = "rbxassetid://82333874052142",
    	["men-bold"] = "rbxassetid://106732474047966",
    	["men-bold-duotone"] = "rbxassetid://102298345124116",
    	["men-broken"] = "rbxassetid://104507749492859",
    	["men-line-duotone"] = "rbxassetid://139922935123934",
    	["men-linear"] = "rbxassetid://98042600955317",
    	["men-outline"] = "rbxassetid://127453042929229",
    	["mention-circle-bold"] = "rbxassetid://86724094837749",
    	["mention-circle-bold-duotone"] = "rbxassetid://119814342504797",
    	["mention-circle-broken"] = "rbxassetid://83889687560077",
    	["mention-circle-line-duotone"] = "rbxassetid://110838596049058",
    	["mention-circle-linear"] = "rbxassetid://137130270711616",
    	["mention-circle-outline"] = "rbxassetid://130454548893080",
    	["mention-square-bold"] = "rbxassetid://88481159399833",
    	["mention-square-bold-duotone"] = "rbxassetid://107285148644084",
    	["mention-square-broken"] = "rbxassetid://110718301640672",
    	["mention-square-line-duotone"] = "rbxassetid://136082427623536",
    	["mention-square-linear"] = "rbxassetid://97654604404429",
    	["mention-square-outline"] = "rbxassetid://124612891939686",
    	["menu-dots-bold"] = "rbxassetid://97684069841204",
    	["menu-dots-bold-duotone"] = "rbxassetid://75418256315917",
    	["menu-dots-broken"] = "rbxassetid://127932645732757",
    	["menu-dots-circle-bold"] = "rbxassetid://113604546484539",
    	["menu-dots-circle-bold-duotone"] = "rbxassetid://131976661098042",
    	["menu-dots-circle-broken"] = "rbxassetid://116035901061969",
    	["menu-dots-circle-line-duotone"] = "rbxassetid://73147723918577",
    	["menu-dots-circle-linear"] = "rbxassetid://70686687870532",
    	["menu-dots-circle-outline"] = "rbxassetid://123098644946497",
    	["menu-dots-line-duotone"] = "rbxassetid://106989702039909",
    	["menu-dots-linear"] = "rbxassetid://108185170662771",
    	["menu-dots-outline"] = "rbxassetid://71014783403836",
    	["menu-dots-square-bold"] = "rbxassetid://96922289474814",
    	["menu-dots-square-bold-duotone"] = "rbxassetid://82189596357262",
    	["menu-dots-square-broken"] = "rbxassetid://84099465392325",
    	["menu-dots-square-line-duotone"] = "rbxassetid://124956565488530",
    	["menu-dots-square-linear"] = "rbxassetid://91420041168048",
    	["menu-dots-square-outline"] = "rbxassetid://73461278093840",
    	["microphone-2-bold"] = "rbxassetid://97280071273102",
    	["microphone-2-bold-duotone"] = "rbxassetid://91449898624148",
    	["microphone-2-broken"] = "rbxassetid://132942102587968",
    	["microphone-2-line-duotone"] = "rbxassetid://79429783122340",
    	["microphone-2-linear"] = "rbxassetid://127578724424123",
    	["microphone-2-outline"] = "rbxassetid://136906968512391",
    	["microphone-3-bold"] = "rbxassetid://123518127491892",
    	["microphone-3-bold-duotone"] = "rbxassetid://119865388292968",
    	["microphone-3-broken"] = "rbxassetid://85903472396009",
    	["microphone-3-line-duotone"] = "rbxassetid://84037788727278",
    	["microphone-3-linear"] = "rbxassetid://78017147936301",
    	["microphone-3-outline"] = "rbxassetid://114653705704282",
    	["microphone-bold"] = "rbxassetid://120020891918857",
    	["microphone-bold-duotone"] = "rbxassetid://71370725324682",
    	["microphone-broken"] = "rbxassetid://72729768770860",
    	["microphone-large-bold"] = "rbxassetid://108318098992763",
    	["microphone-large-bold-duotone"] = "rbxassetid://127629317830327",
    	["microphone-large-broken"] = "rbxassetid://133534885911237",
    	["microphone-large-line-duotone"] = "rbxassetid://79255071156080",
    	["microphone-large-linear"] = "rbxassetid://86529663735848",
    	["microphone-large-outline"] = "rbxassetid://119515677981353",
    	["microphone-line-duotone"] = "rbxassetid://106115136122771",
    	["microphone-linear"] = "rbxassetid://134571596265564",
    	["microphone-outline"] = "rbxassetid://135254633998582",
    	["minimalistic-magnifer-bold"] = "rbxassetid://70552784281680",
    	["minimalistic-magnifer-bold-duotone"] = "rbxassetid://112499479671230",
    	["minimalistic-magnifer-broken"] = "rbxassetid://117591647381699",
    	["minimalistic-magnifer-bug-bold"] = "rbxassetid://133212897697513",
    	["minimalistic-magnifer-bug-bold-duotone"] = "rbxassetid://94762306155412",
    	["minimalistic-magnifer-bug-broken"] = "rbxassetid://84255168406958",
    	["minimalistic-magnifer-bug-line-duotone"] = "rbxassetid://121539170005383",
    	["minimalistic-magnifer-bug-linear"] = "rbxassetid://137896345409779",
    	["minimalistic-magnifer-bug-outline"] = "rbxassetid://80574941315865",
    	["minimalistic-magnifer-line-duotone"] = "rbxassetid://109405802946025",
    	["minimalistic-magnifer-linear"] = "rbxassetid://78636204443332",
    	["minimalistic-magnifer-outline"] = "rbxassetid://112612073170500",
    	["minimalistic-magnifer-zoom-in-bold"] = "rbxassetid://98656569915187",
    	["minimalistic-magnifer-zoom-in-bold-duotone"] = "rbxassetid://128575064515989",
    	["minimalistic-magnifer-zoom-in-broken"] = "rbxassetid://70849331231853",
    	["minimalistic-magnifer-zoom-in-line-duotone"] = "rbxassetid://120721921800209",
    	["minimalistic-magnifer-zoom-in-linear"] = "rbxassetid://127439132819545",
    	["minimalistic-magnifer-zoom-in-outline"] = "rbxassetid://110085341566505",
    	["minimalistic-magnifer-zoom-out-bold"] = "rbxassetid://79686409038067",
    	["minimalistic-magnifer-zoom-out-bold-duotone"] = "rbxassetid://103982250795157",
    	["minimalistic-magnifer-zoom-out-broken"] = "rbxassetid://117720913574560",
    	["minimalistic-magnifer-zoom-out-line-duotone"] = "rbxassetid://103839153377062",
    	["minimalistic-magnifer-zoom-out-linear"] = "rbxassetid://133235799084469",
    	["minimalistic-magnifer-zoom-out-outline"] = "rbxassetid://120780722159739",
    	["minimize-bold"] = "rbxassetid://75810158557243",
    	["minimize-bold-duotone"] = "rbxassetid://125009986305332",
    	["minimize-broken"] = "rbxassetid://112770976159537",
    	["minimize-line-duotone"] = "rbxassetid://120088043156465",
    	["minimize-linear"] = "rbxassetid://102800887856302",
    	["minimize-outline"] = "rbxassetid://90601879410769",
    	["minimize-square-2-bold"] = "rbxassetid://139234548639631",
    	["minimize-square-2-bold-duotone"] = "rbxassetid://77182657688359",
    	["minimize-square-2-broken"] = "rbxassetid://110475927187196",
    	["minimize-square-2-line-duotone"] = "rbxassetid://107720600632222",
    	["minimize-square-2-linear"] = "rbxassetid://83034805103222",
    	["minimize-square-2-outline"] = "rbxassetid://95931969984995",
    	["minimize-square-3-bold"] = "rbxassetid://86375936396998",
    	["minimize-square-3-bold-duotone"] = "rbxassetid://83429534042358",
    	["minimize-square-3-broken"] = "rbxassetid://105073120689687",
    	["minimize-square-3-line-duotone"] = "rbxassetid://134972937231974",
    	["minimize-square-3-linear"] = "rbxassetid://74778489360272",
    	["minimize-square-3-outline"] = "rbxassetid://116125200252498",
    	["minimize-square-bold"] = "rbxassetid://76780451864744",
    	["minimize-square-bold-duotone"] = "rbxassetid://79676165715250",
    	["minimize-square-broken"] = "rbxassetid://140264591978872",
    	["minimize-square-line-duotone"] = "rbxassetid://80625836139934",
    	["minimize-square-linear"] = "rbxassetid://90933870850093",
    	["minimize-square-minimalistic-bold"] = "rbxassetid://103626408777602",
    	["minimize-square-minimalistic-bold-duotone"] = "rbxassetid://81600729347072",
    	["minimize-square-minimalistic-broken"] = "rbxassetid://107708180770148",
    	["minimize-square-minimalistic-line-duotone"] = "rbxassetid://100134458518859",
    	["minimize-square-minimalistic-linear"] = "rbxassetid://75450469391512",
    	["minimize-square-minimalistic-outline"] = "rbxassetid://104384225847734",
    	["minimize-square-outline"] = "rbxassetid://127172900858012",
    	["minus-circle-bold"] = "rbxassetid://82100189633812",
    	["minus-circle-bold-duotone"] = "rbxassetid://76097680514275",
    	["minus-circle-broken"] = "rbxassetid://121459885959565",
    	["minus-circle-line-duotone"] = "rbxassetid://83118181993956",
    	["minus-circle-linear"] = "rbxassetid://83564978767487",
    	["minus-circle-outline"] = "rbxassetid://107076644164839",
    	["minus-square-bold"] = "rbxassetid://85537484816183",
    	["minus-square-bold-duotone"] = "rbxassetid://118475740742750",
    	["minus-square-broken"] = "rbxassetid://119942961536179",
    	["minus-square-line-duotone"] = "rbxassetid://97686749814874",
    	["minus-square-linear"] = "rbxassetid://121694175236987",
    	["minus-square-outline"] = "rbxassetid://98407642765934",
    	["mirror-bold"] = "rbxassetid://100317746534844",
    	["mirror-bold-1"] = "rbxassetid://85548273362188",
    	["mirror-bold-duotone"] = "rbxassetid://100108806990315",
    	["mirror-bold-duotone-1"] = "rbxassetid://104907587039205",
    	["mirror-broken"] = "rbxassetid://135023411930463",
    	["mirror-broken-1"] = "rbxassetid://105143865880259",
    	["mirror-left-bold"] = "rbxassetid://80263734562480",
    	["mirror-left-bold-duotone"] = "rbxassetid://80195482734061",
    	["mirror-left-broken"] = "rbxassetid://112043620678653",
    	["mirror-left-line-duotone"] = "rbxassetid://102726201835327",
    	["mirror-left-linear"] = "rbxassetid://123463536206452",
    	["mirror-left-outline"] = "rbxassetid://126027318196628",
    	["mirror-line-duotone"] = "rbxassetid://86070772706817",
    	["mirror-line-duotone-1"] = "rbxassetid://132741522555818",
    	["mirror-linear"] = "rbxassetid://89818433552030",
    	["mirror-linear-1"] = "rbxassetid://123051857149638",
    	["mirror-outline"] = "rbxassetid://123796716186108",
    	["mirror-outline-1"] = "rbxassetid://78397744005255",
    	["mirror-right-bold"] = "rbxassetid://125472555950877",
    	["mirror-right-bold-duotone"] = "rbxassetid://130862515229470",
    	["mirror-right-broken"] = "rbxassetid://109287760153525",
    	["mirror-right-line-duotone"] = "rbxassetid://104127857421379",
    	["mirror-right-linear"] = "rbxassetid://77625834790333",
    	["mirror-right-outline"] = "rbxassetid://113168049449661",
    	["money-bag-bold"] = "rbxassetid://117785512690361",
    	["money-bag-bold-duotone"] = "rbxassetid://96397506152227",
    	["money-bag-broken"] = "rbxassetid://97504919746599",
    	["money-bag-line-duotone"] = "rbxassetid://96948288631119",
    	["money-bag-linear"] = "rbxassetid://87463242084971",
    	["money-bag-outline"] = "rbxassetid://83136346841001",
    	["monitor-bold"] = "rbxassetid://79734853554211",
    	["monitor-bold-duotone"] = "rbxassetid://92689360612773",
    	["monitor-broken"] = "rbxassetid://89620968552544",
    	["monitor-camera-bold"] = "rbxassetid://75135248525910",
    	["monitor-camera-bold-duotone"] = "rbxassetid://105694367126196",
    	["monitor-camera-broken"] = "rbxassetid://114223651039973",
    	["monitor-camera-line-duotone"] = "rbxassetid://106114792531403",
    	["monitor-camera-linear"] = "rbxassetid://70663250360184",
    	["monitor-camera-outline"] = "rbxassetid://93415604290551",
    	["monitor-line-duotone"] = "rbxassetid://126125867190251",
    	["monitor-linear"] = "rbxassetid://109713247414722",
    	["monitor-outline"] = "rbxassetid://103543521728097",
    	["monitor-smartphone-bold"] = "rbxassetid://103539301635769",
    	["monitor-smartphone-bold-duotone"] = "rbxassetid://84425341985712",
    	["monitor-smartphone-broken"] = "rbxassetid://80817819892995",
    	["monitor-smartphone-line-duotone"] = "rbxassetid://126815346505971",
    	["monitor-smartphone-linear"] = "rbxassetid://127922899821606",
    	["monitor-smartphone-outline"] = "rbxassetid://115260527583749",
    	["moon-bold"] = "rbxassetid://125873389519219",
    	["moon-bold-duotone"] = "rbxassetid://76156653465845",
    	["moon-broken"] = "rbxassetid://130039155641232",
    	["moon-fog-bold"] = "rbxassetid://139908343281931",
    	["moon-fog-bold-duotone"] = "rbxassetid://135633197865254",
    	["moon-fog-broken"] = "rbxassetid://90783899673282",
    	["moon-fog-line-duotone"] = "rbxassetid://95048500308546",
    	["moon-fog-linear"] = "rbxassetid://110892611420131",
    	["moon-fog-outline"] = "rbxassetid://118187175755434",
    	["moon-line-duotone"] = "rbxassetid://140027689435528",
    	["moon-linear"] = "rbxassetid://81955666054188",
    	["moon-outline"] = "rbxassetid://113018034773643",
    	["moon-sleep-bold"] = "rbxassetid://128595102526074",
    	["moon-sleep-bold-duotone"] = "rbxassetid://78722555503758",
    	["moon-sleep-broken"] = "rbxassetid://130725010343127",
    	["moon-sleep-line-duotone"] = "rbxassetid://77288827828167",
    	["moon-sleep-linear"] = "rbxassetid://120031912816405",
    	["moon-sleep-outline"] = "rbxassetid://105002613661096",
    	["moon-stars-bold"] = "rbxassetid://108940075201970",
    	["moon-stars-bold-duotone"] = "rbxassetid://102703856710481",
    	["moon-stars-broken"] = "rbxassetid://87208295725217",
    	["moon-stars-line-duotone"] = "rbxassetid://107055639840498",
    	["moon-stars-linear"] = "rbxassetid://73695704955801",
    	["moon-stars-outline"] = "rbxassetid://136104380307062",
    	["mouse-bold"] = "rbxassetid://139149894104767",
    	["mouse-bold-duotone"] = "rbxassetid://117240993229126",
    	["mouse-broken"] = "rbxassetid://101006467427683",
    	["mouse-circle-bold"] = "rbxassetid://106321142478582",
    	["mouse-circle-bold-duotone"] = "rbxassetid://116066787317293",
    	["mouse-circle-broken"] = "rbxassetid://105099896827276",
    	["mouse-circle-line-duotone"] = "rbxassetid://113381959539564",
    	["mouse-circle-linear"] = "rbxassetid://122613005614507",
    	["mouse-circle-outline"] = "rbxassetid://120990820494793",
    	["mouse-line-duotone"] = "rbxassetid://104122100285669",
    	["mouse-linear"] = "rbxassetid://74859589024739",
    	["mouse-minimalistic-bold"] = "rbxassetid://112630969536923",
    	["mouse-minimalistic-bold-duotone"] = "rbxassetid://113537330430986",
    	["mouse-minimalistic-broken"] = "rbxassetid://129762342168236",
    	["mouse-minimalistic-line-duotone"] = "rbxassetid://122452054284777",
    	["mouse-minimalistic-linear"] = "rbxassetid://115687057482369",
    	["mouse-minimalistic-outline"] = "rbxassetid://92942326680446",
    	["mouse-outline"] = "rbxassetid://96754316654109",
    	["move-to-folder-bold"] = "rbxassetid://129044278330331",
    	["move-to-folder-bold-duotone"] = "rbxassetid://122459795966956",
    	["move-to-folder-broken"] = "rbxassetid://104619334322692",
    	["move-to-folder-line-duotone"] = "rbxassetid://125224271030988",
    	["move-to-folder-linear"] = "rbxassetid://78906738752696",
    	["move-to-folder-outline"] = "rbxassetid://133843463057224",
    	["multiple-forward-left-bold"] = "rbxassetid://108975997937971",
    	["multiple-forward-left-bold-duotone"] = "rbxassetid://118650677162169",
    	["multiple-forward-left-broken"] = "rbxassetid://109747876414062",
    	["multiple-forward-left-line-duotone"] = "rbxassetid://89493435503610",
    	["multiple-forward-left-linear"] = "rbxassetid://118912862345247",
    	["multiple-forward-left-outline"] = "rbxassetid://124571700403246",
    	["multiple-forward-right-bold"] = "rbxassetid://107355812789520",
    	["multiple-forward-right-bold-duotone"] = "rbxassetid://83271886712684",
    	["multiple-forward-right-broken"] = "rbxassetid://92862977185819",
    	["multiple-forward-right-line-duotone"] = "rbxassetid://87664959453418",
    	["multiple-forward-right-linear"] = "rbxassetid://135194662303450",
    	["multiple-forward-right-outline"] = "rbxassetid://114794419056526",
    	["music-library-2-bold"] = "rbxassetid://99786822107991",
    	["music-library-2-bold-duotone"] = "rbxassetid://109887701378446",
    	["music-library-2-broken"] = "rbxassetid://116596353092791",
    	["music-library-2-line-duotone"] = "rbxassetid://106588544354263",
    	["music-library-2-linear"] = "rbxassetid://128033441273267",
    	["music-library-2-outline"] = "rbxassetid://106718563491321",
    	["music-library-bold"] = "rbxassetid://77994101443980",
    	["music-library-bold-duotone"] = "rbxassetid://70965461708491",
    	["music-library-broken"] = "rbxassetid://110133205120866",
    	["music-library-line-duotone"] = "rbxassetid://121314822965733",
    	["music-library-linear"] = "rbxassetid://78499570208941",
    	["music-library-outline"] = "rbxassetid://114505437238443",
    	["music-note-2-bold"] = "rbxassetid://97445775514198",
    	["music-note-2-bold-duotone"] = "rbxassetid://84821938915664",
    	["music-note-2-broken"] = "rbxassetid://110795270191150",
    	["music-note-2-line-duotone"] = "rbxassetid://106305774649642",
    	["music-note-2-linear"] = "rbxassetid://124422417862446",
    	["music-note-2-outline"] = "rbxassetid://113542403216579",
    	["music-note-3-bold"] = "rbxassetid://74359292721462",
    	["music-note-3-bold-duotone"] = "rbxassetid://128772593780589",
    	["music-note-3-broken"] = "rbxassetid://138904650833162",
    	["music-note-3-line-duotone"] = "rbxassetid://107984151010982",
    	["music-note-3-linear"] = "rbxassetid://112123345947493",
    	["music-note-3-outline"] = "rbxassetid://73043481083932",
    	["music-note-4-bold"] = "rbxassetid://120478072705612",
    	["music-note-4-bold-duotone"] = "rbxassetid://118231070550694",
    	["music-note-4-broken"] = "rbxassetid://129928857382125",
    	["music-note-4-line-duotone"] = "rbxassetid://100364698931996",
    	["music-note-4-linear"] = "rbxassetid://121099010197991",
    	["music-note-4-outline"] = "rbxassetid://92103896684446",
    	["music-note-bold"] = "rbxassetid://123865998868867",
    	["music-note-bold-duotone"] = "rbxassetid://85783524309379",
    	["music-note-broken"] = "rbxassetid://95254876832635",
    	["music-note-line-duotone"] = "rbxassetid://92954161261418",
    	["music-note-linear"] = "rbxassetid://110633917017421",
    	["music-note-outline"] = "rbxassetid://112042254490057",
    	["music-note-slider-2-bold"] = "rbxassetid://104076906079561",
    	["music-note-slider-2-bold-duotone"] = "rbxassetid://97739182728057",
    	["music-note-slider-2-broken"] = "rbxassetid://130542599756143",
    	["music-note-slider-2-line-duotone"] = "rbxassetid://85229961147234",
    	["music-note-slider-2-linear"] = "rbxassetid://89109498841708",
    	["music-note-slider-2-outline"] = "rbxassetid://132208957655361",
    	["music-note-slider-bold"] = "rbxassetid://125710688927378",
    	["music-note-slider-bold-duotone"] = "rbxassetid://126792593883696",
    	["music-note-slider-broken"] = "rbxassetid://100325509826592",
    	["music-note-slider-line-duotone"] = "rbxassetid://114733775855757",
    	["music-note-slider-linear"] = "rbxassetid://134815568882109",
    	["music-note-slider-outline"] = "rbxassetid://102178747945413",
    	["music-notes-bold"] = "rbxassetid://125493609770475",
    	["music-notes-bold-duotone"] = "rbxassetid://76837023378376",
    	["music-notes-broken"] = "rbxassetid://81100102953188",
    	["music-notes-line-duotone"] = "rbxassetid://81636618827682",
    	["music-notes-linear"] = "rbxassetid://105009785127858",
    	["music-notes-outline"] = "rbxassetid://106173515258879",
    	["muted-bold"] = "rbxassetid://138304661448495",
    	["muted-bold-duotone"] = "rbxassetid://125252477018508",
    	["muted-broken"] = "rbxassetid://74145583442183",
    	["muted-line-duotone"] = "rbxassetid://74335073143006",
    	["muted-linear"] = "rbxassetid://132802474234701",
    	["muted-outline"] = "rbxassetid://122405461080791",
    	["notebook-bold"] = "rbxassetid://139800895080670",
    	["notebook-bold-1"] = "rbxassetid://136970416308599",
    	["notebook-bold-duotone"] = "rbxassetid://103643144053567",
    	["notebook-bold-duotone-1"] = "rbxassetid://121793917782137",
    	["notebook-bookmark-bold"] = "rbxassetid://96124487254608",
    	["notebook-bookmark-bold-duotone"] = "rbxassetid://85248665119056",
    	["notebook-bookmark-broken"] = "rbxassetid://70920949950123",
    	["notebook-bookmark-line-duotone"] = "rbxassetid://81889052766333",
    	["notebook-bookmark-linear"] = "rbxassetid://122996510946203",
    	["notebook-bookmark-outline"] = "rbxassetid://72763331268321",
    	["notebook-broken"] = "rbxassetid://93805206667332",
    	["notebook-broken-1"] = "rbxassetid://84826991006316",
    	["notebook-line-duotone"] = "rbxassetid://129816439286601",
    	["notebook-line-duotone-1"] = "rbxassetid://75723381651493",
    	["notebook-linear"] = "rbxassetid://110145863290341",
    	["notebook-linear-1"] = "rbxassetid://93175221116629",
    	["notebook-minimalistic-bold"] = "rbxassetid://101747599077050",
    	["notebook-minimalistic-bold-duotone"] = "rbxassetid://119079666356878",
    	["notebook-minimalistic-broken"] = "rbxassetid://134853482121594",
    	["notebook-minimalistic-line-duotone"] = "rbxassetid://127611530172274",
    	["notebook-minimalistic-linear"] = "rbxassetid://116043291227065",
    	["notebook-minimalistic-outline"] = "rbxassetid://98514530389045",
    	["notebook-outline"] = "rbxassetid://128492400365371",
    	["notebook-outline-1"] = "rbxassetid://81338492916266",
    	["notebook-square-bold"] = "rbxassetid://130858891028085",
    	["notebook-square-bold-duotone"] = "rbxassetid://90897028383125",
    	["notebook-square-broken"] = "rbxassetid://127936123394235",
    	["notebook-square-line-duotone"] = "rbxassetid://117577588560141",
    	["notebook-square-linear"] = "rbxassetid://107377022037314",
    	["notebook-square-outline"] = "rbxassetid://131208945456273",
    	["notes-bold"] = "rbxassetid://116168334467542",
    	["notes-bold-duotone"] = "rbxassetid://117437209039137",
    	["notes-broken"] = "rbxassetid://95236602895750",
    	["notes-line-duotone"] = "rbxassetid://137405585818599",
    	["notes-linear"] = "rbxassetid://120555602198188",
    	["notes-minimalistic-bold"] = "rbxassetid://125360237781928",
    	["notes-minimalistic-bold-duotone"] = "rbxassetid://75588535893480",
    	["notes-minimalistic-broken"] = "rbxassetid://84527450394782",
    	["notes-minimalistic-line-duotone"] = "rbxassetid://86330900292441",
    	["notes-minimalistic-linear"] = "rbxassetid://99357342963913",
    	["notes-minimalistic-outline"] = "rbxassetid://97758214694574",
    	["notes-outline"] = "rbxassetid://74592713281093",
    	["notification-lines-remove-bold"] = "rbxassetid://130830973153831",
    	["notification-lines-remove-bold-duotone"] = "rbxassetid://123323519615154",
    	["notification-lines-remove-broken"] = "rbxassetid://73959436280811",
    	["notification-lines-remove-line-duotone"] = "rbxassetid://80871715847868",
    	["notification-lines-remove-linear"] = "rbxassetid://139221326963052",
    	["notification-lines-remove-outline"] = "rbxassetid://94830314794397",
    	["notification-remove-bold"] = "rbxassetid://76779394800746",
    	["notification-remove-bold-duotone"] = "rbxassetid://75474100848194",
    	["notification-remove-broken"] = "rbxassetid://84582107841913",
    	["notification-remove-line-duotone"] = "rbxassetid://98326032774091",
    	["notification-remove-linear"] = "rbxassetid://91984555352136",
    	["notification-remove-outline"] = "rbxassetid://106048720796796",
    	["notification-unread-bold"] = "rbxassetid://139787932372978",
    	["notification-unread-bold-duotone"] = "rbxassetid://94413546315953",
    	["notification-unread-broken"] = "rbxassetid://107855221369034",
    	["notification-unread-line-duotone"] = "rbxassetid://90689162144541",
    	["notification-unread-linear"] = "rbxassetid://128034361728254",
    	["notification-unread-lines-bold"] = "rbxassetid://101280095447381",
    	["notification-unread-lines-bold-duotone"] = "rbxassetid://120601948342129",
    	["notification-unread-lines-broken"] = "rbxassetid://138843023964713",
    	["notification-unread-lines-line-duotone"] = "rbxassetid://138790024078724",
    	["notification-unread-lines-linear"] = "rbxassetid://136911603207160",
    	["notification-unread-lines-outline"] = "rbxassetid://109097858294042",
    	["notification-unread-outline"] = "rbxassetid://129912231941146",
    	["object-scan-bold"] = "rbxassetid://108611247538232",
    	["object-scan-bold-duotone"] = "rbxassetid://95291564288040",
    	["object-scan-broken"] = "rbxassetid://99919851294933",
    	["object-scan-line-duotone"] = "rbxassetid://130941362321942",
    	["object-scan-linear"] = "rbxassetid://109215840894155",
    	["object-scan-outline"] = "rbxassetid://87437841476565",
    	["outgoing-call-bold"] = "rbxassetid://114725326453202",
    	["outgoing-call-bold-duotone"] = "rbxassetid://100579456022664",
    	["outgoing-call-broken"] = "rbxassetid://107716145297574",
    	["outgoing-call-line-duotone"] = "rbxassetid://87188283274556",
    	["outgoing-call-linear"] = "rbxassetid://114163929711550",
    	["outgoing-call-outline"] = "rbxassetid://117786907552941",
    	["outgoing-call-rounded-bold"] = "rbxassetid://139638671952745",
    	["outgoing-call-rounded-bold-duotone"] = "rbxassetid://123535875697973",
    	["outgoing-call-rounded-broken"] = "rbxassetid://137043312577075",
    	["outgoing-call-rounded-line-duotone"] = "rbxassetid://72535129516227",
    	["outgoing-call-rounded-linear"] = "rbxassetid://95419295482882",
    	["outgoing-call-rounded-outline"] = "rbxassetid://78394573489351",
    	["oven-mitts-bold"] = "rbxassetid://116254499847389",
    	["oven-mitts-bold-duotone"] = "rbxassetid://88023226304974",
    	["oven-mitts-broken"] = "rbxassetid://115082902633233",
    	["oven-mitts-line-duotone"] = "rbxassetid://140272840239983",
    	["oven-mitts-linear"] = "rbxassetid://105285849692202",
    	["oven-mitts-minimalistic-bold"] = "rbxassetid://101629105567959",
    	["oven-mitts-minimalistic-bold-duotone"] = "rbxassetid://96370456759167",
    	["oven-mitts-minimalistic-broken"] = "rbxassetid://116746406670771",
    	["oven-mitts-minimalistic-line-duotone"] = "rbxassetid://77691104077510",
    	["oven-mitts-minimalistic-linear"] = "rbxassetid://103506825255191",
    	["oven-mitts-minimalistic-outline"] = "rbxassetid://107190885512923",
    	["oven-mitts-outline"] = "rbxassetid://92220150578339",
    	["paint-roller-bold"] = "rbxassetid://115221684337796",
    	["paint-roller-bold-duotone"] = "rbxassetid://126279426815551",
    	["paint-roller-broken"] = "rbxassetid://116668348661765",
    	["paint-roller-line-duotone"] = "rbxassetid://135390377434819",
    	["paint-roller-linear"] = "rbxassetid://94641740521436",
    	["paint-roller-outline"] = "rbxassetid://106263837979483",
    	["palette-bold"] = "rbxassetid://71228091130971",
    	["palette-bold-duotone"] = "rbxassetid://113995681469609",
    	["palette-broken"] = "rbxassetid://137876898580061",
    	["palette-line-duotone"] = "rbxassetid://127397149369188",
    	["palette-linear"] = "rbxassetid://77900128560816",
    	["palette-outline"] = "rbxassetid://133100038211929",
    	["palette-round-bold"] = "rbxassetid://135940003948216",
    	["palette-round-bold-duotone"] = "rbxassetid://122356726770472",
    	["palette-round-broken"] = "rbxassetid://99581268794402",
    	["palette-round-line-duotone"] = "rbxassetid://75841543303509",
    	["palette-round-linear"] = "rbxassetid://108131416289685",
    	["palette-round-outline"] = "rbxassetid://125933567210555",
    	["pallete-2-bold"] = "rbxassetid://82581293307519",
    	["pallete-2-bold-duotone"] = "rbxassetid://128688531960821",
    	["pallete-2-broken"] = "rbxassetid://121357106757054",
    	["pallete-2-line-duotone"] = "rbxassetid://105800090036122",
    	["pallete-2-linear"] = "rbxassetid://75259537605177",
    	["pallete-2-outline"] = "rbxassetid://97781229744044",
    	["panorama-bold"] = "rbxassetid://129062576724229",
    	["panorama-bold-duotone"] = "rbxassetid://116231579565491",
    	["panorama-broken"] = "rbxassetid://88757481687007",
    	["panorama-line-duotone"] = "rbxassetid://82643393592880",
    	["panorama-linear"] = "rbxassetid://75329456953170",
    	["panorama-outline"] = "rbxassetid://129353777636309",
    	["paper-bin-bold"] = "rbxassetid://85298397038910",
    	["paper-bin-bold-duotone"] = "rbxassetid://84445593993449",
    	["paper-bin-broken"] = "rbxassetid://117830623739200",
    	["paper-bin-line-duotone"] = "rbxassetid://104072072970534",
    	["paper-bin-linear"] = "rbxassetid://88798761206441",
    	["paper-bin-outline"] = "rbxassetid://103009203455397",
    	["paperclip-2-bold"] = "rbxassetid://112816150233126",
    	["paperclip-2-bold-duotone"] = "rbxassetid://70555216585532",
    	["paperclip-2-broken"] = "rbxassetid://82146340546149",
    	["paperclip-2-line-duotone"] = "rbxassetid://85294335054736",
    	["paperclip-2-linear"] = "rbxassetid://121288328376393",
    	["paperclip-2-outline"] = "rbxassetid://122394689623346",
    	["paperclip-bold"] = "rbxassetid://110226788873111",
    	["paperclip-bold-duotone"] = "rbxassetid://70531383991590",
    	["paperclip-broken"] = "rbxassetid://99154999556498",
    	["paperclip-line-duotone"] = "rbxassetid://104628872016332",
    	["paperclip-linear"] = "rbxassetid://115448889935440",
    	["paperclip-outline"] = "rbxassetid://94536280518497",
    	["paperclip-rounded-2-bold"] = "rbxassetid://95549443574022",
    	["paperclip-rounded-2-bold-duotone"] = "rbxassetid://106667342402538",
    	["paperclip-rounded-2-broken"] = "rbxassetid://80713211717774",
    	["paperclip-rounded-2-line-duotone"] = "rbxassetid://110330063143290",
    	["paperclip-rounded-2-linear"] = "rbxassetid://120116976783874",
    	["paperclip-rounded-2-outline"] = "rbxassetid://126432627071114",
    	["paperclip-rounded-bold"] = "rbxassetid://96771707508519",
    	["paperclip-rounded-bold-duotone"] = "rbxassetid://121511461467247",
    	["paperclip-rounded-broken"] = "rbxassetid://122401744869757",
    	["paperclip-rounded-line-duotone"] = "rbxassetid://98191920646150",
    	["paperclip-rounded-linear"] = "rbxassetid://78238371768428",
    	["paperclip-rounded-outline"] = "rbxassetid://97103607036856",
    	["paragraph-spacing-bold"] = "rbxassetid://90239604766759",
    	["paragraph-spacing-bold-duotone"] = "rbxassetid://130779861421762",
    	["paragraph-spacing-broken"] = "rbxassetid://93391614195346",
    	["paragraph-spacing-line-duotone"] = "rbxassetid://113880782554356",
    	["paragraph-spacing-linear"] = "rbxassetid://130401307944608",
    	["paragraph-spacing-outline"] = "rbxassetid://107149082018050",
    	["passport-bold"] = "rbxassetid://116022167541465",
    	["passport-bold-duotone"] = "rbxassetid://77897118413949",
    	["passport-broken"] = "rbxassetid://117139551434504",
    	["passport-line-duotone"] = "rbxassetid://100113895199350",
    	["passport-linear"] = "rbxassetid://98159838815217",
    	["passport-minimalistic-bold"] = "rbxassetid://76249147601706",
    	["passport-minimalistic-bold-duotone"] = "rbxassetid://78168015804730",
    	["passport-minimalistic-broken"] = "rbxassetid://86620723857347",
    	["passport-minimalistic-line-duotone"] = "rbxassetid://114309620945555",
    	["passport-minimalistic-linear"] = "rbxassetid://119045532707775",
    	["passport-minimalistic-outline"] = "rbxassetid://99796932792577",
    	["passport-outline"] = "rbxassetid://85010212923729",
    	["password-bold"] = "rbxassetid://108958062185057",
    	["password-bold-duotone"] = "rbxassetid://123740684525410",
    	["password-broken"] = "rbxassetid://71968361844940",
    	["password-line-duotone"] = "rbxassetid://117293006021844",
    	["password-linear"] = "rbxassetid://97734788810682",
    	["password-minimalistic-bold"] = "rbxassetid://114975848070011",
    	["password-minimalistic-bold-duotone"] = "rbxassetid://76391372980493",
    	["password-minimalistic-broken"] = "rbxassetid://71837202364373",
    	["password-minimalistic-input-bold"] = "rbxassetid://135265823252301",
    	["password-minimalistic-input-bold-duotone"] = "rbxassetid://82438594697948",
    	["password-minimalistic-input-broken"] = "rbxassetid://120628359932042",
    	["password-minimalistic-input-line-duotone"] = "rbxassetid://140081219703719",
    	["password-minimalistic-input-linear"] = "rbxassetid://140034872312829",
    	["password-minimalistic-input-outline"] = "rbxassetid://74953855012007",
    	["password-minimalistic-line-duotone"] = "rbxassetid://87531677339467",
    	["password-minimalistic-linear"] = "rbxassetid://129505987492813",
    	["password-minimalistic-outline"] = "rbxassetid://110850683729807",
    	["password-outline"] = "rbxassetid://126154081119684",
    	["pause-bold"] = "rbxassetid://108033303358492",
    	["pause-bold-duotone"] = "rbxassetid://100454858991095",
    	["pause-broken"] = "rbxassetid://109243067255078",
    	["pause-circle-bold"] = "rbxassetid://90119286381163",
    	["pause-circle-bold-duotone"] = "rbxassetid://133027231450847",
    	["pause-circle-broken"] = "rbxassetid://107214664249819",
    	["pause-circle-line-duotone"] = "rbxassetid://78205667769516",
    	["pause-circle-linear"] = "rbxassetid://107020493231790",
    	["pause-circle-outline"] = "rbxassetid://96456834373506",
    	["pause-line-duotone"] = "rbxassetid://72323489564861",
    	["pause-linear"] = "rbxassetid://79031664551825",
    	["pause-outline"] = "rbxassetid://111927212661867",
    	["paw-bold"] = "rbxassetid://86004936341358",
    	["paw-bold-duotone"] = "rbxassetid://117621402193977",
    	["paw-broken"] = "rbxassetid://97102627340560",
    	["paw-line-duotone"] = "rbxassetid://138307824840143",
    	["paw-linear"] = "rbxassetid://115795977829142",
    	["paw-outline"] = "rbxassetid://78389972215399",
    	["pen-2-bold"] = "rbxassetid://79579669580124",
    	["pen-2-bold-duotone"] = "rbxassetid://71052170213333",
    	["pen-2-broken"] = "rbxassetid://128818199326492",
    	["pen-2-line-duotone"] = "rbxassetid://131601636680992",
    	["pen-2-linear"] = "rbxassetid://85817156087387",
    	["pen-2-outline"] = "rbxassetid://139754970658751",
    	["pen-bold"] = "rbxassetid://139224507144471",
    	["pen-bold-duotone"] = "rbxassetid://111586157564043",
    	["pen-broken"] = "rbxassetid://89167867241160",
    	["pen-line-duotone"] = "rbxassetid://140118887022175",
    	["pen-linear"] = "rbxassetid://79051750479308",
    	["pen-new-round-bold"] = "rbxassetid://139995667511791",
    	["pen-new-round-bold-duotone"] = "rbxassetid://95147697847316",
    	["pen-new-round-broken"] = "rbxassetid://109655109430564",
    	["pen-new-round-line-duotone"] = "rbxassetid://98032132994976",
    	["pen-new-round-linear"] = "rbxassetid://133908205387272",
    	["pen-new-round-outline"] = "rbxassetid://90253094281911",
    	["pen-new-square-bold"] = "rbxassetid://107532273565583",
    	["pen-new-square-bold-duotone"] = "rbxassetid://116254975535301",
    	["pen-new-square-broken"] = "rbxassetid://106345809329767",
    	["pen-new-square-line-duotone"] = "rbxassetid://140037094025139",
    	["pen-new-square-linear"] = "rbxassetid://94417659863310",
    	["pen-new-square-outline"] = "rbxassetid://106675040806677",
    	["pen-outline"] = "rbxassetid://137850322431385",
    	["people-nearby-bold"] = "rbxassetid://93753043517782",
    	["people-nearby-bold-duotone"] = "rbxassetid://122708768262598",
    	["people-nearby-broken"] = "rbxassetid://134064166427618",
    	["people-nearby-line-duotone"] = "rbxassetid://86846545880090",
    	["people-nearby-linear"] = "rbxassetid://95108929862231",
    	["people-nearby-outline"] = "rbxassetid://137027674945410",
    	["perfume-bold"] = "rbxassetid://89665077488198",
    	["perfume-bold-duotone"] = "rbxassetid://106907565530555",
    	["perfume-broken"] = "rbxassetid://89007725804538",
    	["perfume-line-duotone"] = "rbxassetid://109513376723884",
    	["perfume-linear"] = "rbxassetid://86153628175247",
    	["perfume-outline"] = "rbxassetid://120337110098764",
    	["phone-bold"] = "rbxassetid://106627490150757",
    	["phone-bold-duotone"] = "rbxassetid://105399738036336",
    	["phone-broken"] = "rbxassetid://106948073992840",
    	["phone-calling-bold"] = "rbxassetid://118497451278440",
    	["phone-calling-bold-duotone"] = "rbxassetid://126200697697218",
    	["phone-calling-broken"] = "rbxassetid://91858425012137",
    	["phone-calling-line-duotone"] = "rbxassetid://130038322606970",
    	["phone-calling-linear"] = "rbxassetid://114832264459365",
    	["phone-calling-outline"] = "rbxassetid://136113639169928",
    	["phone-calling-rounded-bold"] = "rbxassetid://126846816166614",
    	["phone-calling-rounded-bold-duotone"] = "rbxassetid://123055958911116",
    	["phone-calling-rounded-broken"] = "rbxassetid://120107769194485",
    	["phone-calling-rounded-line-duotone"] = "rbxassetid://131100384959679",
    	["phone-calling-rounded-linear"] = "rbxassetid://119410186704163",
    	["phone-calling-rounded-outline"] = "rbxassetid://124728980083282",
    	["phone-line-duotone"] = "rbxassetid://93888520584767",
    	["phone-linear"] = "rbxassetid://125632284485576",
    	["phone-outline"] = "rbxassetid://85307309992736",
    	["phone-rounded-bold"] = "rbxassetid://138803353466491",
    	["phone-rounded-bold-duotone"] = "rbxassetid://100488589597132",
    	["phone-rounded-broken"] = "rbxassetid://95384402364799",
    	["phone-rounded-line-duotone"] = "rbxassetid://122784009020712",
    	["phone-rounded-linear"] = "rbxassetid://113434773826498",
    	["phone-rounded-outline"] = "rbxassetid://134483378057293",
    	["pie-chart-2-bold"] = "rbxassetid://119052305114673",
    	["pie-chart-2-bold-duotone"] = "rbxassetid://86676416750937",
    	["pie-chart-2-broken"] = "rbxassetid://74379584825993",
    	["pie-chart-2-line-duotone"] = "rbxassetid://71205569857687",
    	["pie-chart-2-linear"] = "rbxassetid://102595883999811",
    	["pie-chart-2-outline"] = "rbxassetid://83618773121729",
    	["pie-chart-3-bold"] = "rbxassetid://75874792169097",
    	["pie-chart-3-bold-duotone"] = "rbxassetid://86386370487576",
    	["pie-chart-3-broken"] = "rbxassetid://72276628854934",
    	["pie-chart-3-line-duotone"] = "rbxassetid://90961787540520",
    	["pie-chart-3-linear"] = "rbxassetid://75953519583630",
    	["pie-chart-3-outline"] = "rbxassetid://126407321100169",
    	["pie-chart-bold"] = "rbxassetid://116180090774230",
    	["pie-chart-bold-duotone"] = "rbxassetid://124998778267410",
    	["pie-chart-broken"] = "rbxassetid://72148835759038",
    	["pie-chart-line-duotone"] = "rbxassetid://104788848341873",
    	["pie-chart-linear"] = "rbxassetid://106803434251458",
    	["pie-chart-outline"] = "rbxassetid://138970603694485",
    	["pill-bold"] = "rbxassetid://100372428511072",
    	["pill-bold-duotone"] = "rbxassetid://135844002516591",
    	["pill-broken"] = "rbxassetid://87974723490914",
    	["pill-line-duotone"] = "rbxassetid://123144668127693",
    	["pill-linear"] = "rbxassetid://96352981256656",
    	["pill-outline"] = "rbxassetid://71967589047817",
    	["pills-2-bold"] = "rbxassetid://118250365651780",
    	["pills-2-bold-duotone"] = "rbxassetid://108858405290644",
    	["pills-2-broken"] = "rbxassetid://132099131736182",
    	["pills-2-line-duotone"] = "rbxassetid://92844877154419",
    	["pills-2-linear"] = "rbxassetid://122955557246965",
    	["pills-2-outline"] = "rbxassetid://73925060334432",
    	["pills-3-bold"] = "rbxassetid://72133979211424",
    	["pills-3-bold-duotone"] = "rbxassetid://72513301563211",
    	["pills-3-broken"] = "rbxassetid://89663614825029",
    	["pills-3-line-duotone"] = "rbxassetid://124576652624508",
    	["pills-3-linear"] = "rbxassetid://99309729222262",
    	["pills-3-outline"] = "rbxassetid://135607563530679",
    	["pills-bold"] = "rbxassetid://78028338389518",
    	["pills-bold-duotone"] = "rbxassetid://131491941224212",
    	["pills-broken"] = "rbxassetid://103022575468419",
    	["pills-line-duotone"] = "rbxassetid://121116608781340",
    	["pills-linear"] = "rbxassetid://78401433637561",
    	["pills-outline"] = "rbxassetid://107437650521518",
    	["pin-bold"] = "rbxassetid://81516746276415",
    	["pin-bold-duotone"] = "rbxassetid://118698282404577",
    	["pin-broken"] = "rbxassetid://121203923983610",
    	["pin-circle-bold"] = "rbxassetid://99319242174185",
    	["pin-circle-bold-duotone"] = "rbxassetid://90404611590729",
    	["pin-circle-broken"] = "rbxassetid://108219043407326",
    	["pin-circle-line-duotone"] = "rbxassetid://77094302274514",
    	["pin-circle-linear"] = "rbxassetid://137148545391842",
    	["pin-circle-outline"] = "rbxassetid://119277827513937",
    	["pin-line-duotone"] = "rbxassetid://85967228536514",
    	["pin-linear"] = "rbxassetid://135228566547657",
    	["pin-list-bold"] = "rbxassetid://127244881692694",
    	["pin-list-bold-duotone"] = "rbxassetid://88595250249200",
    	["pin-list-broken"] = "rbxassetid://98250238890164",
    	["pin-list-line-duotone"] = "rbxassetid://120006581270700",
    	["pin-list-linear"] = "rbxassetid://78901913518507",
    	["pin-list-outline"] = "rbxassetid://102914514800164",
    	["pin-outline"] = "rbxassetid://94963834932557",
    	["pip-2-bold"] = "rbxassetid://95652338235167",
    	["pip-2-bold-duotone"] = "rbxassetid://101318806554553",
    	["pip-2-broken"] = "rbxassetid://102352471888099",
    	["pip-2-line-duotone"] = "rbxassetid://117879422993917",
    	["pip-2-linear"] = "rbxassetid://110116530511737",
    	["pip-2-outline"] = "rbxassetid://129288432485625",
    	["pip-bold"] = "rbxassetid://74918487335973",
    	["pip-bold-duotone"] = "rbxassetid://94395542781001",
    	["pip-broken"] = "rbxassetid://99073967267286",
    	["pip-line-duotone"] = "rbxassetid://129321556012757",
    	["pip-linear"] = "rbxassetid://105362124938126",
    	["pip-outline"] = "rbxassetid://93428725882602",
    	["pipette-bold"] = "rbxassetid://133581508341712",
    	["pipette-bold-duotone"] = "rbxassetid://139641307902690",
    	["pipette-broken"] = "rbxassetid://75655585381237",
    	["pipette-line-duotone"] = "rbxassetid://121985712661421",
    	["pipette-linear"] = "rbxassetid://78963687079460",
    	["pipette-outline"] = "rbxassetid://92869847198403",
    	["plaaylist-minimalistic-bold"] = "rbxassetid://101958669557540",
    	["plaaylist-minimalistic-bold-duotone"] = "rbxassetid://90265124957979",
    	["plaaylist-minimalistic-broken"] = "rbxassetid://105680350170445",
    	["plaaylist-minimalistic-line-duotone"] = "rbxassetid://113979757712051",
    	["plaaylist-minimalistic-linear"] = "rbxassetid://135180807831299",
    	["plaaylist-minimalistic-outline"] = "rbxassetid://115446488202403",
    	["plain-2-bold"] = "rbxassetid://135764877723540",
    	["plain-2-bold-duotone"] = "rbxassetid://92761612440706",
    	["plain-2-broken"] = "rbxassetid://121480457634967",
    	["plain-2-line-duotone"] = "rbxassetid://125814446675034",
    	["plain-2-linear"] = "rbxassetid://139689249851113",
    	["plain-2-outline"] = "rbxassetid://74590504224437",
    	["plain-3-bold"] = "rbxassetid://110444508953815",
    	["plain-3-bold-duotone"] = "rbxassetid://73262121764010",
    	["plain-3-broken"] = "rbxassetid://83395226620234",
    	["plain-3-line-duotone"] = "rbxassetid://132629987647742",
    	["plain-3-linear"] = "rbxassetid://138081743161851",
    	["plain-3-outline"] = "rbxassetid://111096884411353",
    	["plain-bold"] = "rbxassetid://104436508665228",
    	["plain-bold-duotone"] = "rbxassetid://125044400085010",
    	["plain-broken"] = "rbxassetid://110982047244538",
    	["plain-line-duotone"] = "rbxassetid://135519974136997",
    	["plain-linear"] = "rbxassetid://116582178325477",
    	["plain-outline"] = "rbxassetid://111885722718655",
    	["planet-2-bold"] = "rbxassetid://97685269906778",
    	["planet-2-bold-duotone"] = "rbxassetid://130069391921036",
    	["planet-2-broken"] = "rbxassetid://107406813304145",
    	["planet-2-line-duotone"] = "rbxassetid://92985225969298",
    	["planet-2-linear"] = "rbxassetid://115286033338718",
    	["planet-2-outline"] = "rbxassetid://130915534221207",
    	["planet-3-bold"] = "rbxassetid://114584522323443",
    	["planet-3-bold-duotone"] = "rbxassetid://138139681750902",
    	["planet-3-broken"] = "rbxassetid://124522494588031",
    	["planet-3-line-duotone"] = "rbxassetid://85758320778133",
    	["planet-3-linear"] = "rbxassetid://133557027205352",
    	["planet-3-outline"] = "rbxassetid://124733380879873",
    	["planet-4-bold"] = "rbxassetid://126853183441271",
    	["planet-4-bold-duotone"] = "rbxassetid://110933914451189",
    	["planet-4-broken"] = "rbxassetid://131522234746463",
    	["planet-4-line-duotone"] = "rbxassetid://115142346622642",
    	["planet-4-linear"] = "rbxassetid://122406740041082",
    	["planet-4-outline"] = "rbxassetid://98964372338924",
    	["planet-bold"] = "rbxassetid://110926118391987",
    	["planet-bold-duotone"] = "rbxassetid://87833299354736",
    	["planet-broken"] = "rbxassetid://70995120446421",
    	["planet-line-duotone"] = "rbxassetid://117338641327344",
    	["planet-linear"] = "rbxassetid://78094309343073",
    	["planet-outline"] = "rbxassetid://112602848166679",
    	["plate-bold"] = "rbxassetid://131126152251497",
    	["plate-bold-duotone"] = "rbxassetid://92968039230245",
    	["plate-broken"] = "rbxassetid://138163898487093",
    	["plate-line-duotone"] = "rbxassetid://111098798052604",
    	["plate-linear"] = "rbxassetid://108175384662985",
    	["plate-outline"] = "rbxassetid://113859778720028",
    	["play-bold"] = "rbxassetid://94251290360710",
    	["play-bold-duotone"] = "rbxassetid://94651018756041",
    	["play-broken"] = "rbxassetid://107986264607879",
    	["play-circle-bold"] = "rbxassetid://126174487049903",
    	["play-circle-bold-duotone"] = "rbxassetid://79056958803029",
    	["play-circle-broken"] = "rbxassetid://125443121949639",
    	["play-circle-line-duotone"] = "rbxassetid://73436919172084",
    	["play-circle-linear"] = "rbxassetid://116494241123123",
    	["play-circle-outline"] = "rbxassetid://87429238520331",
    	["play-line-duotone"] = "rbxassetid://128192205547505",
    	["play-linear"] = "rbxassetid://134330694652001",
    	["play-outline"] = "rbxassetid://98384714205476",
    	["play-stream-bold"] = "rbxassetid://71973979059922",
    	["play-stream-bold-duotone"] = "rbxassetid://105152964809195",
    	["play-stream-broken"] = "rbxassetid://75174566664577",
    	["play-stream-line-duotone"] = "rbxassetid://99837057062129",
    	["play-stream-linear"] = "rbxassetid://128359617893313",
    	["play-stream-outline"] = "rbxassetid://89105642182726",
    	["playback-speed-bold"] = "rbxassetid://75658442425524",
    	["playback-speed-bold-duotone"] = "rbxassetid://93998213222149",
    	["playback-speed-broken"] = "rbxassetid://112427331466536",
    	["playback-speed-line-duotone"] = "rbxassetid://132253174377481",
    	["playback-speed-linear"] = "rbxassetid://128057611209522",
    	["playback-speed-outline"] = "rbxassetid://99081098513773",
    	["playlist-2-bold"] = "rbxassetid://101883736307128",
    	["playlist-2-bold-duotone"] = "rbxassetid://91263908838558",
    	["playlist-2-broken"] = "rbxassetid://95307250176805",
    	["playlist-2-line-duotone"] = "rbxassetid://83539952218364",
    	["playlist-2-linear"] = "rbxassetid://70550460702374",
    	["playlist-2-outline"] = "rbxassetid://108879487727985",
    	["playlist-bold"] = "rbxassetid://132670286884790",
    	["playlist-bold-duotone"] = "rbxassetid://74988205470510",
    	["playlist-broken"] = "rbxassetid://122661686236412",
    	["playlist-line-duotone"] = "rbxassetid://138267624905089",
    	["playlist-linear"] = "rbxassetid://116891784095684",
    	["playlist-minimalistic-2-bold"] = "rbxassetid://134106383085691",
    	["playlist-minimalistic-2-bold-duotone"] = "rbxassetid://73294544125748",
    	["playlist-minimalistic-2-broken"] = "rbxassetid://137982264070301",
    	["playlist-minimalistic-2-line-duotone"] = "rbxassetid://97051975762085",
    	["playlist-minimalistic-2-linear"] = "rbxassetid://121495572012041",
    	["playlist-minimalistic-2-outline"] = "rbxassetid://74653587601880",
    	["playlist-minimalistic-3-bold"] = "rbxassetid://92247757217964",
    	["playlist-minimalistic-3-bold-duotone"] = "rbxassetid://102994442590003",
    	["playlist-minimalistic-3-broken"] = "rbxassetid://90829530285366",
    	["playlist-minimalistic-3-line-duotone"] = "rbxassetid://110197860023861",
    	["playlist-minimalistic-3-linear"] = "rbxassetid://99867344439781",
    	["playlist-minimalistic-3-outline"] = "rbxassetid://133862735291458",
    	["playlist-outline"] = "rbxassetid://123116313677100",
    	["plug-circle-bold"] = "rbxassetid://138180123830220",
    	["plug-circle-bold-duotone"] = "rbxassetid://91215598972060",
    	["plug-circle-broken"] = "rbxassetid://140491902768964",
    	["plug-circle-line-duotone"] = "rbxassetid://124034540264300",
    	["plug-circle-linear"] = "rbxassetid://98551790337824",
    	["plug-circle-outline"] = "rbxassetid://78479862748117",
    	["plus-minus-bold"] = "rbxassetid://104295007565085",
    	["plus-minus-bold-duotone"] = "rbxassetid://127958266781009",
    	["plus-minus-broken"] = "rbxassetid://130633397037397",
    	["plus-minus-line-duotone"] = "rbxassetid://101374580071139",
    	["plus-minus-linear"] = "rbxassetid://109108094582727",
    	["plus-minus-outline"] = "rbxassetid://105460082222068",
    	["podcast-bold"] = "rbxassetid://73356483225559",
    	["podcast-bold-duotone"] = "rbxassetid://110963458127932",
    	["podcast-broken"] = "rbxassetid://96972284410551",
    	["podcast-line-duotone"] = "rbxassetid://128144697763975",
    	["podcast-linear"] = "rbxassetid://73047404052535",
    	["podcast-outline"] = "rbxassetid://83174682184219",
    	["point-on-map-bold"] = "rbxassetid://71186034817192",
    	["point-on-map-bold-duotone"] = "rbxassetid://128032422428576",
    	["point-on-map-broken"] = "rbxassetid://120329884954299",
    	["point-on-map-line-duotone"] = "rbxassetid://101258889124741",
    	["point-on-map-linear"] = "rbxassetid://95378604973673",
    	["point-on-map-outline"] = "rbxassetid://96250901575148",
    	["point-on-map-perspective-bold"] = "rbxassetid://110360883026668",
    	["point-on-map-perspective-bold-duotone"] = "rbxassetid://109048427130425",
    	["point-on-map-perspective-broken"] = "rbxassetid://118804623701303",
    	["point-on-map-perspective-line-duotone"] = "rbxassetid://119179717823549",
    	["point-on-map-perspective-linear"] = "rbxassetid://121862721156388",
    	["point-on-map-perspective-outline"] = "rbxassetid://136114233348533",
    	["posts-carousel-horizontal-bold"] = "rbxassetid://116942123304048",
    	["posts-carousel-horizontal-bold-duotone"] = "rbxassetid://78754037102702",
    	["posts-carousel-horizontal-broken"] = "rbxassetid://130298954909700",
    	["posts-carousel-horizontal-line-duotone"] = "rbxassetid://81179365313774",
    	["posts-carousel-horizontal-linear"] = "rbxassetid://119159680696179",
    	["posts-carousel-horizontal-outline"] = "rbxassetid://85603437956562",
    	["posts-carousel-vertical-bold"] = "rbxassetid://89038238613961",
    	["posts-carousel-vertical-bold-duotone"] = "rbxassetid://72679842003208",
    	["posts-carousel-vertical-broken"] = "rbxassetid://94871156141357",
    	["posts-carousel-vertical-line-duotone"] = "rbxassetid://98008695280482",
    	["posts-carousel-vertical-linear"] = "rbxassetid://109234187896288",
    	["posts-carousel-vertical-outline"] = "rbxassetid://92447583122530",
    	["power-bold"] = "rbxassetid://116822581093037",
    	["power-bold-duotone"] = "rbxassetid://112979836098775",
    	["power-broken"] = "rbxassetid://94406988983037",
    	["power-line-duotone"] = "rbxassetid://89492949018538",
    	["power-linear"] = "rbxassetid://140690180001941",
    	["power-outline"] = "rbxassetid://114104386458844",
    	["presentation-graph-bold"] = "rbxassetid://116656393464390",
    	["presentation-graph-bold-duotone"] = "rbxassetid://122403665119640",
    	["presentation-graph-broken"] = "rbxassetid://136616585358646",
    	["presentation-graph-line-duotone"] = "rbxassetid://96717943957490",
    	["presentation-graph-linear"] = "rbxassetid://99931389048436",
    	["presentation-graph-outline"] = "rbxassetid://133301673992793",
    	["printer-2-bold"] = "rbxassetid://130778080492218",
    	["printer-2-bold-duotone"] = "rbxassetid://118246260665242",
    	["printer-2-broken"] = "rbxassetid://103167474604566",
    	["printer-2-line-duotone"] = "rbxassetid://120099920221609",
    	["printer-2-linear"] = "rbxassetid://72263018022568",
    	["printer-2-outline"] = "rbxassetid://83450979352591",
    	["printer-bold"] = "rbxassetid://99889574534641",
    	["printer-bold-duotone"] = "rbxassetid://86171089338468",
    	["printer-broken"] = "rbxassetid://138782890865116",
    	["printer-line-duotone"] = "rbxassetid://113041558554215",
    	["printer-linear"] = "rbxassetid://118037406295441",
    	["printer-minimalistic-bold"] = "rbxassetid://81275571341906",
    	["printer-minimalistic-bold-duotone"] = "rbxassetid://114791893199878",
    	["printer-minimalistic-broken"] = "rbxassetid://119115912668016",
    	["printer-minimalistic-line-duotone"] = "rbxassetid://134743747615820",
    	["printer-minimalistic-linear"] = "rbxassetid://72954555632432",
    	["printer-minimalistic-outline"] = "rbxassetid://103769715487286",
    	["printer-outline"] = "rbxassetid://89242825092833",
    	["programming-bold"] = "rbxassetid://71466343335951",
    	["programming-bold-duotone"] = "rbxassetid://79274221484621",
    	["programming-broken"] = "rbxassetid://91162927003183",
    	["programming-line-duotone"] = "rbxassetid://134695685453849",
    	["programming-linear"] = "rbxassetid://128841187654614",
    	["programming-outline"] = "rbxassetid://74600602451059",
    	["projector-bold"] = "rbxassetid://139210998852889",
    	["projector-bold-duotone"] = "rbxassetid://82925938341487",
    	["projector-broken"] = "rbxassetid://86203314717463",
    	["projector-line-duotone"] = "rbxassetid://138639373652049",
    	["projector-linear"] = "rbxassetid://108915795822336",
    	["projector-outline"] = "rbxassetid://135448947431970",
    	["pulse-2-bold"] = "rbxassetid://139106093250291",
    	["pulse-2-bold-duotone"] = "rbxassetid://118140544072056",
    	["pulse-2-broken"] = "rbxassetid://97835097975637",
    	["pulse-2-line-duotone"] = "rbxassetid://85711734001012",
    	["pulse-2-linear"] = "rbxassetid://139882349825161",
    	["pulse-2-outline"] = "rbxassetid://97005396148892",
    	["pulse-bold"] = "rbxassetid://89560893175804",
    	["pulse-bold-duotone"] = "rbxassetid://139179396316272",
    	["pulse-broken"] = "rbxassetid://127374037421678",
    	["pulse-line-duotone"] = "rbxassetid://122293834961284",
    	["pulse-linear"] = "rbxassetid://75243850068848",
    	["pulse-outline"] = "rbxassetid://89976732237608",
    	["qr-code-bold"] = "rbxassetid://112581659796854",
    	["qr-code-bold-duotone"] = "rbxassetid://84498671397488",
    	["qr-code-broken"] = "rbxassetid://109531660630315",
    	["qr-code-line-duotone"] = "rbxassetid://104487792268620",
    	["qr-code-linear"] = "rbxassetid://135652098262839",
    	["qr-code-outline"] = "rbxassetid://113676885326330",
    	["question-circle-bold"] = "rbxassetid://138795625519584",
    	["question-circle-bold-duotone"] = "rbxassetid://105516252809144",
    	["question-circle-broken"] = "rbxassetid://100640772440718",
    	["question-circle-line-duotone"] = "rbxassetid://88473931796873",
    	["question-circle-linear"] = "rbxassetid://83759727452544",
    	["question-circle-outline"] = "rbxassetid://99867286906748",
    	["question-square-bold"] = "rbxassetid://99401628420524",
    	["question-square-bold-duotone"] = "rbxassetid://74516515616226",
    	["question-square-broken"] = "rbxassetid://83747794605699",
    	["question-square-line-duotone"] = "rbxassetid://123597013592550",
    	["question-square-linear"] = "rbxassetid://74726826506633",
    	["question-square-outline"] = "rbxassetid://82095306642285",
    	["quit-full-screen-bold"] = "rbxassetid://82801632530658",
    	["quit-full-screen-bold-duotone"] = "rbxassetid://80231757775194",
    	["quit-full-screen-broken"] = "rbxassetid://106183253487910",
    	["quit-full-screen-circle-bold"] = "rbxassetid://105519683035641",
    	["quit-full-screen-circle-bold-duotone"] = "rbxassetid://83741726926212",
    	["quit-full-screen-circle-broken"] = "rbxassetid://72399527817024",
    	["quit-full-screen-circle-line-duotone"] = "rbxassetid://120931145898596",
    	["quit-full-screen-circle-linear"] = "rbxassetid://73303452253646",
    	["quit-full-screen-circle-outline"] = "rbxassetid://70766046389300",
    	["quit-full-screen-line-duotone"] = "rbxassetid://95726184696207",
    	["quit-full-screen-linear"] = "rbxassetid://106175468569482",
    	["quit-full-screen-outline"] = "rbxassetid://131234828256707",
    	["quit-full-screen-square-bold"] = "rbxassetid://98332680832491",
    	["quit-full-screen-square-bold-duotone"] = "rbxassetid://114358960732596",
    	["quit-full-screen-square-broken"] = "rbxassetid://71662398367057",
    	["quit-full-screen-square-line-duotone"] = "rbxassetid://113782455083768",
    	["quit-full-screen-square-linear"] = "rbxassetid://73049274597685",
    	["quit-full-screen-square-outline"] = "rbxassetid://140342603441880",
    	["quit-pip-bold"] = "rbxassetid://94122003472728",
    	["quit-pip-bold-duotone"] = "rbxassetid://88156580942872",
    	["quit-pip-broken"] = "rbxassetid://139483918350862",
    	["quit-pip-line-duotone"] = "rbxassetid://136849467134913",
    	["quit-pip-linear"] = "rbxassetid://79883076031158",
    	["quit-pip-outline"] = "rbxassetid://115228264146140",
    	["radar-2-bold"] = "rbxassetid://138254839603600",
    	["radar-2-bold-duotone"] = "rbxassetid://108502185160318",
    	["radar-2-broken"] = "rbxassetid://117067002398187",
    	["radar-2-line-duotone"] = "rbxassetid://106404290722876",
    	["radar-2-linear"] = "rbxassetid://94509043971234",
    	["radar-2-outline"] = "rbxassetid://107000762683788",
    	["radar-bold"] = "rbxassetid://131644584628608",
    	["radar-bold-duotone"] = "rbxassetid://119077728194718",
    	["radar-broken"] = "rbxassetid://102454223654160",
    	["radar-line-duotone"] = "rbxassetid://81924243925504",
    	["radar-linear"] = "rbxassetid://84870943841943",
    	["radar-outline"] = "rbxassetid://103269381651152",
    	["radial-blur-bold"] = "rbxassetid://132056974448622",
    	["radial-blur-bold-duotone"] = "rbxassetid://77608510850455",
    	["radial-blur-broken"] = "rbxassetid://92438913552987",
    	["radial-blur-line-duotone"] = "rbxassetid://110469661810043",
    	["radial-blur-linear"] = "rbxassetid://87454216022897",
    	["radial-blur-outline"] = "rbxassetid://78701145449624",
    	["radio-bold"] = "rbxassetid://107842194557490",
    	["radio-bold-duotone"] = "rbxassetid://138831630707253",
    	["radio-broken"] = "rbxassetid://100104782913355",
    	["radio-line-duotone"] = "rbxassetid://80160162980765",
    	["radio-linear"] = "rbxassetid://94555000975093",
    	["radio-minimalistic-bold"] = "rbxassetid://89235653631008",
    	["radio-minimalistic-bold-duotone"] = "rbxassetid://77695178669239",
    	["radio-minimalistic-broken"] = "rbxassetid://140477798885251",
    	["radio-minimalistic-line-duotone"] = "rbxassetid://71021808353964",
    	["radio-minimalistic-linear"] = "rbxassetid://140674132849045",
    	["radio-minimalistic-outline"] = "rbxassetid://103571328286486",
    	["radio-outline"] = "rbxassetid://114413399924952",
    	["ranking-bold"] = "rbxassetid://90937800962544",
    	["ranking-bold-duotone"] = "rbxassetid://79374157768873",
    	["ranking-broken"] = "rbxassetid://97277979760300",
    	["ranking-line-duotone"] = "rbxassetid://102560175937558",
    	["ranking-linear"] = "rbxassetid://102637532547063",
    	["ranking-outline"] = "rbxassetid://78815323776097",
    	["recive-square-bold"] = "rbxassetid://93342429514158",
    	["recive-square-bold-duotone"] = "rbxassetid://123602448811841",
    	["recive-square-broken"] = "rbxassetid://133949893029586",
    	["recive-square-line-duotone"] = "rbxassetid://117231474611477",
    	["recive-square-linear"] = "rbxassetid://85519735704143",
    	["recive-square-outline"] = "rbxassetid://93174555185859",
    	["recive-twice-square-bold"] = "rbxassetid://71439700201365",
    	["recive-twice-square-bold-duotone"] = "rbxassetid://108524782304106",
    	["recive-twice-square-broken"] = "rbxassetid://106425758138241",
    	["recive-twice-square-line-duotone"] = "rbxassetid://73695291288247",
    	["recive-twice-square-linear"] = "rbxassetid://105856251978240",
    	["recive-twice-square-outline"] = "rbxassetid://106564089857349",
    	["record-bold"] = "rbxassetid://122485335253573",
    	["record-bold-duotone"] = "rbxassetid://120514697835705",
    	["record-broken"] = "rbxassetid://118713880107381",
    	["record-circle-bold"] = "rbxassetid://132489804811974",
    	["record-circle-bold-1"] = "rbxassetid://86216515398982",
    	["record-circle-bold-duotone"] = "rbxassetid://100211469422943",
    	["record-circle-bold-duotone-1"] = "rbxassetid://74017292347233",
    	["record-circle-broken"] = "rbxassetid://118946797744389",
    	["record-circle-broken-1"] = "rbxassetid://114794350988371",
    	["record-circle-line-duotone"] = "rbxassetid://91422461467769",
    	["record-circle-line-duotone-1"] = "rbxassetid://122169646206117",
    	["record-circle-linear"] = "rbxassetid://82065871376265",
    	["record-circle-linear-1"] = "rbxassetid://107462186325628",
    	["record-circle-outline"] = "rbxassetid://81423949986481",
    	["record-circle-outline-1"] = "rbxassetid://119989987720755",
    	["record-line-duotone"] = "rbxassetid://108642318815569",
    	["record-linear"] = "rbxassetid://92907501947531",
    	["record-minimalistic-bold"] = "rbxassetid://132191068013875",
    	["record-minimalistic-bold-duotone"] = "rbxassetid://113363630369149",
    	["record-minimalistic-broken"] = "rbxassetid://127385171636040",
    	["record-minimalistic-line-duotone"] = "rbxassetid://132866873016156",
    	["record-minimalistic-linear"] = "rbxassetid://140323634528899",
    	["record-minimalistic-outline"] = "rbxassetid://101898168571397",
    	["record-outline"] = "rbxassetid://120476349570587",
    	["record-square-bold"] = "rbxassetid://78471724812306",
    	["record-square-bold-duotone"] = "rbxassetid://72238316259372",
    	["record-square-broken"] = "rbxassetid://108310097093114",
    	["record-square-line-duotone"] = "rbxassetid://78318759297856",
    	["record-square-linear"] = "rbxassetid://88129784635823",
    	["record-square-outline"] = "rbxassetid://100031471668087",
    	["reel-2-bold"] = "rbxassetid://116423317770454",
    	["reel-2-bold-duotone"] = "rbxassetid://74591787282128",
    	["reel-2-broken"] = "rbxassetid://104286618566802",
    	["reel-2-line-duotone"] = "rbxassetid://130676639314790",
    	["reel-2-linear"] = "rbxassetid://110424886166593",
    	["reel-2-outline"] = "rbxassetid://100308491553443",
    	["reel-bold"] = "rbxassetid://101242709875910",
    	["reel-bold-duotone"] = "rbxassetid://84364745996119",
    	["reel-broken"] = "rbxassetid://125139158585033",
    	["reel-line-duotone"] = "rbxassetid://111982753412836",
    	["reel-linear"] = "rbxassetid://97106687926785",
    	["reel-outline"] = "rbxassetid://114908521667945",
    	["refresh-bold"] = "rbxassetid://129337684713976",
    	["refresh-bold-duotone"] = "rbxassetid://134528330846063",
    	["refresh-broken"] = "rbxassetid://124571135248118",
    	["refresh-circle-bold"] = "rbxassetid://134055602900175",
    	["refresh-circle-bold-duotone"] = "rbxassetid://125978127272464",
    	["refresh-circle-broken"] = "rbxassetid://131466620541211",
    	["refresh-circle-line-duotone"] = "rbxassetid://117880878512688",
    	["refresh-circle-linear"] = "rbxassetid://78990316508083",
    	["refresh-circle-outline"] = "rbxassetid://115724343265349",
    	["refresh-line-duotone"] = "rbxassetid://87825702883845",
    	["refresh-linear"] = "rbxassetid://102103131425772",
    	["refresh-outline"] = "rbxassetid://111629867439041",
    	["refresh-square-bold"] = "rbxassetid://129609205924612",
    	["refresh-square-bold-duotone"] = "rbxassetid://116831973251214",
    	["refresh-square-broken"] = "rbxassetid://76996707302338",
    	["refresh-square-line-duotone"] = "rbxassetid://128229990204760",
    	["refresh-square-linear"] = "rbxassetid://107515701645926",
    	["refresh-square-outline"] = "rbxassetid://97073348041202",
    	["remote-controller-2-bold"] = "rbxassetid://72902150820770",
    	["remote-controller-2-bold-duotone"] = "rbxassetid://80033629048312",
    	["remote-controller-2-broken"] = "rbxassetid://75757331272528",
    	["remote-controller-2-line-duotone"] = "rbxassetid://88564965576043",
    	["remote-controller-2-linear"] = "rbxassetid://101881516079612",
    	["remote-controller-2-outline"] = "rbxassetid://106650561108950",
    	["remote-controller-bold"] = "rbxassetid://92924216388680",
    	["remote-controller-bold-duotone"] = "rbxassetid://139802928057950",
    	["remote-controller-broken"] = "rbxassetid://92790253493387",
    	["remote-controller-line-duotone"] = "rbxassetid://135084445101609",
    	["remote-controller-linear"] = "rbxassetid://133454703207235",
    	["remote-controller-minimalistic-bold"] = "rbxassetid://98183943186563",
    	["remote-controller-minimalistic-bold-duotone"] = "rbxassetid://124411844477856",
    	["remote-controller-minimalistic-broken"] = "rbxassetid://89381771773967",
    	["remote-controller-minimalistic-line-duotone"] = "rbxassetid://131850487775391",
    	["remote-controller-minimalistic-linear"] = "rbxassetid://134726416507737",
    	["remote-controller-minimalistic-outline"] = "rbxassetid://137761122141623",
    	["remote-controller-outline"] = "rbxassetid://73288144213511",
    	["remove-folder-bold"] = "rbxassetid://126400094160951",
    	["remove-folder-bold-duotone"] = "rbxassetid://76080830019340",
    	["remove-folder-broken"] = "rbxassetid://109644738974784",
    	["remove-folder-line-duotone"] = "rbxassetid://119389449943210",
    	["remove-folder-linear"] = "rbxassetid://86824589481682",
    	["remove-folder-outline"] = "rbxassetid://103249848639523",
    	["reorder-bold"] = "rbxassetid://119032799762106",
    	["reorder-bold-1"] = "rbxassetid://136594072352016",
    	["reorder-bold-duotone"] = "rbxassetid://128228309277035",
    	["reorder-bold-duotone-1"] = "rbxassetid://103144037545949",
    	["reorder-broken"] = "rbxassetid://131305819403619",
    	["reorder-broken-1"] = "rbxassetid://128638364073138",
    	["reorder-line-duotone"] = "rbxassetid://118903725912121",
    	["reorder-line-duotone-1"] = "rbxassetid://100687486035991",
    	["reorder-linear"] = "rbxassetid://72770969823397",
    	["reorder-linear-1"] = "rbxassetid://96985140615201",
    	["reorder-outline"] = "rbxassetid://97582624885106",
    	["reorder-outline-1"] = "rbxassetid://91721504989483",
    	["repeat-bold"] = "rbxassetid://114726563873786",
    	["repeat-bold-duotone"] = "rbxassetid://76654316376064",
    	["repeat-broken"] = "rbxassetid://122944695352082",
    	["repeat-line-duotone"] = "rbxassetid://109301604825879",
    	["repeat-linear"] = "rbxassetid://120344110979460",
    	["repeat-one-bold"] = "rbxassetid://131686730007022",
    	["repeat-one-bold-duotone"] = "rbxassetid://109852127584121",
    	["repeat-one-broken"] = "rbxassetid://119445152897348",
    	["repeat-one-line-duotone"] = "rbxassetid://137313868798510",
    	["repeat-one-linear"] = "rbxassetid://90680530261754",
    	["repeat-one-minimalistic-bold"] = "rbxassetid://70753920636219",
    	["repeat-one-minimalistic-bold-duotone"] = "rbxassetid://117856671255441",
    	["repeat-one-minimalistic-broken"] = "rbxassetid://123816871734064",
    	["repeat-one-minimalistic-line-duotone"] = "rbxassetid://89589846642292",
    	["repeat-one-minimalistic-linear"] = "rbxassetid://90453506177270",
    	["repeat-one-minimalistic-outline"] = "rbxassetid://134630092052236",
    	["repeat-one-outline"] = "rbxassetid://140343641713904",
    	["repeat-outline"] = "rbxassetid://105745370659070",
    	["reply-2-bold"] = "rbxassetid://84607993329604",
    	["reply-2-bold-duotone"] = "rbxassetid://80772646474862",
    	["reply-2-broken"] = "rbxassetid://82511358528397",
    	["reply-2-line-duotone"] = "rbxassetid://77835299609250",
    	["reply-2-linear"] = "rbxassetid://133351674634555",
    	["reply-2-outline"] = "rbxassetid://99206748495571",
    	["reply-bold"] = "rbxassetid://139095646898247",
    	["reply-bold-duotone"] = "rbxassetid://84628267981537",
    	["reply-broken"] = "rbxassetid://127819181561862",
    	["reply-line-duotone"] = "rbxassetid://88385650017965",
    	["reply-linear"] = "rbxassetid://104095591996616",
    	["reply-outline"] = "rbxassetid://137878539384722",
    	["restart-bold"] = "rbxassetid://95329801274970",
    	["restart-bold-duotone"] = "rbxassetid://114657347474896",
    	["restart-broken"] = "rbxassetid://116944963626876",
    	["restart-circle-bold"] = "rbxassetid://97403133577547",
    	["restart-circle-bold-duotone"] = "rbxassetid://106683099260890",
    	["restart-circle-broken"] = "rbxassetid://104911868711188",
    	["restart-circle-line-duotone"] = "rbxassetid://76251342606053",
    	["restart-circle-linear"] = "rbxassetid://126536396061067",
    	["restart-circle-outline"] = "rbxassetid://75010895928753",
    	["restart-line-duotone"] = "rbxassetid://133191682050115",
    	["restart-linear"] = "rbxassetid://126400855148244",
    	["restart-outline"] = "rbxassetid://92403267975856",
    	["restart-square-bold"] = "rbxassetid://112122170803458",
    	["restart-square-bold-duotone"] = "rbxassetid://100602558287124",
    	["restart-square-broken"] = "rbxassetid://126305501920426",
    	["restart-square-line-duotone"] = "rbxassetid://110054754367331",
    	["restart-square-linear"] = "rbxassetid://123065906444979",
    	["restart-square-outline"] = "rbxassetid://71851035573966",
    	["revote-bold"] = "rbxassetid://95931868367643",
    	["revote-bold-duotone"] = "rbxassetid://102043589949480",
    	["revote-broken"] = "rbxassetid://116479030656761",
    	["revote-line-duotone"] = "rbxassetid://97485383191708",
    	["revote-linear"] = "rbxassetid://98135031253137",
    	["revote-outline"] = "rbxassetid://132227080639716",
    	["rewind-10-seconds-back-bold"] = "rbxassetid://91537197722698",
    	["rewind-10-seconds-back-bold-duotone"] = "rbxassetid://80134890136839",
    	["rewind-10-seconds-back-broken"] = "rbxassetid://130937012650196",
    	["rewind-10-seconds-back-line-duotone"] = "rbxassetid://106109914971311",
    	["rewind-10-seconds-back-linear"] = "rbxassetid://81890487973263",
    	["rewind-10-seconds-back-outline"] = "rbxassetid://114166052866789",
    	["rewind-10-seconds-forward-bold"] = "rbxassetid://123931123372126",
    	["rewind-10-seconds-forward-bold-duotone"] = "rbxassetid://119292554035410",
    	["rewind-10-seconds-forward-broken"] = "rbxassetid://120649276022587",
    	["rewind-10-seconds-forward-line-duotone"] = "rbxassetid://115539876638857",
    	["rewind-10-seconds-forward-linear"] = "rbxassetid://139336346990345",
    	["rewind-10-seconds-forward-outline"] = "rbxassetid://86151667459263",
    	["rewind-15-seconds-back-bold"] = "rbxassetid://106117742518223",
    	["rewind-15-seconds-back-bold-duotone"] = "rbxassetid://94187436085506",
    	["rewind-15-seconds-back-broken"] = "rbxassetid://129954118242367",
    	["rewind-15-seconds-back-line-duotone"] = "rbxassetid://136379131785506",
    	["rewind-15-seconds-back-linear"] = "rbxassetid://88488897905772",
    	["rewind-15-seconds-back-outline"] = "rbxassetid://99600339671609",
    	["rewind-15-seconds-forward-bold"] = "rbxassetid://99986591566860",
    	["rewind-15-seconds-forward-bold-duotone"] = "rbxassetid://96015099539568",
    	["rewind-15-seconds-forward-broken"] = "rbxassetid://99777278141369",
    	["rewind-15-seconds-forward-line-duotone"] = "rbxassetid://101402952855806",
    	["rewind-15-seconds-forward-linear"] = "rbxassetid://109398004807153",
    	["rewind-15-seconds-forward-outline"] = "rbxassetid://92391462224931",
    	["rewind-5-seconds-back-bold"] = "rbxassetid://108620182757782",
    	["rewind-5-seconds-back-bold-duotone"] = "rbxassetid://89225316698330",
    	["rewind-5-seconds-back-broken"] = "rbxassetid://132152596502871",
    	["rewind-5-seconds-back-line-duotone"] = "rbxassetid://80355870127764",
    	["rewind-5-seconds-back-linear"] = "rbxassetid://124830335104326",
    	["rewind-5-seconds-back-outline"] = "rbxassetid://78297365440199",
    	["rewind-5-seconds-forward-bold"] = "rbxassetid://132426312965837",
    	["rewind-5-seconds-forward-bold-duotone"] = "rbxassetid://131443915205975",
    	["rewind-5-seconds-forward-broken"] = "rbxassetid://85622344145217",
    	["rewind-5-seconds-forward-line-duotone"] = "rbxassetid://128084095835056",
    	["rewind-5-seconds-forward-linear"] = "rbxassetid://95378772242176",
    	["rewind-5-seconds-forward-outline"] = "rbxassetid://140072187810813",
    	["rewind-back-bold"] = "rbxassetid://129702345365553",
    	["rewind-back-bold-duotone"] = "rbxassetid://98945057911374",
    	["rewind-back-broken"] = "rbxassetid://103267408763824",
    	["rewind-back-circle-bold"] = "rbxassetid://77065883077930",
    	["rewind-back-circle-bold-duotone"] = "rbxassetid://94633300920347",
    	["rewind-back-circle-broken"] = "rbxassetid://138546811401673",
    	["rewind-back-circle-line-duotone"] = "rbxassetid://139596126101036",
    	["rewind-back-circle-linear"] = "rbxassetid://102425455251470",
    	["rewind-back-circle-outline"] = "rbxassetid://85221067478212",
    	["rewind-back-line-duotone"] = "rbxassetid://132512212164197",
    	["rewind-back-linear"] = "rbxassetid://119363003203720",
    	["rewind-back-outline"] = "rbxassetid://85222670290837",
    	["rewind-forward-bold"] = "rbxassetid://135347483133717",
    	["rewind-forward-bold-duotone"] = "rbxassetid://110566707911082",
    	["rewind-forward-broken"] = "rbxassetid://88987052665427",
    	["rewind-forward-circle-bold"] = "rbxassetid://137261432367607",
    	["rewind-forward-circle-bold-duotone"] = "rbxassetid://119574578820645",
    	["rewind-forward-circle-broken"] = "rbxassetid://130951383140083",
    	["rewind-forward-circle-line-duotone"] = "rbxassetid://73692972388256",
    	["rewind-forward-circle-linear"] = "rbxassetid://79031741292526",
    	["rewind-forward-circle-outline"] = "rbxassetid://116970005711042",
    	["rewind-forward-line-duotone"] = "rbxassetid://86990376369229",
    	["rewind-forward-linear"] = "rbxassetid://106897150090672",
    	["rewind-forward-outline"] = "rbxassetid://89392591882059",
    	["rocket-2-bold"] = "rbxassetid://107854914989794",
    	["rocket-2-bold-duotone"] = "rbxassetid://87956089971327",
    	["rocket-2-broken"] = "rbxassetid://72127857535321",
    	["rocket-2-line-duotone"] = "rbxassetid://110760999717589",
    	["rocket-2-linear"] = "rbxassetid://72484476045661",
    	["rocket-2-outline"] = "rbxassetid://75234967914730",
    	["rocket-bold"] = "rbxassetid://125278137665075",
    	["rocket-bold-duotone"] = "rbxassetid://130139492156046",
    	["rocket-broken"] = "rbxassetid://76957527156888",
    	["rocket-line-duotone"] = "rbxassetid://73338789620777",
    	["rocket-linear"] = "rbxassetid://75002336361211",
    	["rocket-outline"] = "rbxassetid://105451820488629",
    	["rolling-pin-bold"] = "rbxassetid://134785489472314",
    	["rolling-pin-bold-duotone"] = "rbxassetid://83207318073740",
    	["rolling-pin-broken"] = "rbxassetid://113350358564542",
    	["rolling-pin-line-duotone"] = "rbxassetid://90190634437417",
    	["rolling-pin-linear"] = "rbxassetid://82384690700443",
    	["rolling-pin-outline"] = "rbxassetid://74672077937087",
    	["round-alt-arrow-down-bold"] = "rbxassetid://137709206640172",
    	["round-alt-arrow-down-bold-duotone"] = "rbxassetid://122960284270710",
    	["round-alt-arrow-down-broken"] = "rbxassetid://93683917858362",
    	["round-alt-arrow-down-line-duotone"] = "rbxassetid://128995089619533",
    	["round-alt-arrow-down-linear"] = "rbxassetid://116586040866084",
    	["round-alt-arrow-down-outline"] = "rbxassetid://112219695157421",
    	["round-alt-arrow-left-bold"] = "rbxassetid://122911768123230",
    	["round-alt-arrow-left-bold-duotone"] = "rbxassetid://91671923040680",
    	["round-alt-arrow-left-broken"] = "rbxassetid://133541178003751",
    	["round-alt-arrow-left-line-duotone"] = "rbxassetid://111763890371658",
    	["round-alt-arrow-left-linear"] = "rbxassetid://121616524660231",
    	["round-alt-arrow-left-outline"] = "rbxassetid://102634044062907",
    	["round-alt-arrow-right-bold"] = "rbxassetid://108253689573115",
    	["round-alt-arrow-right-bold-duotone"] = "rbxassetid://96109842476582",
    	["round-alt-arrow-right-broken"] = "rbxassetid://135441586930429",
    	["round-alt-arrow-right-line-duotone"] = "rbxassetid://78929627024416",
    	["round-alt-arrow-right-linear"] = "rbxassetid://119446089460986",
    	["round-alt-arrow-right-outline"] = "rbxassetid://123461464066287",
    	["round-alt-arrow-up-bold"] = "rbxassetid://119474588732740",
    	["round-alt-arrow-up-bold-duotone"] = "rbxassetid://98504055348229",
    	["round-alt-arrow-up-broken"] = "rbxassetid://106486739250938",
    	["round-alt-arrow-up-line-duotone"] = "rbxassetid://88760345285273",
    	["round-alt-arrow-up-linear"] = "rbxassetid://87115431748577",
    	["round-alt-arrow-up-outline"] = "rbxassetid://110794106057118",
    	["round-arrow-down-bold"] = "rbxassetid://78105440389214",
    	["round-arrow-down-bold-duotone"] = "rbxassetid://84921772263064",
    	["round-arrow-down-broken"] = "rbxassetid://126896144566338",
    	["round-arrow-down-line-duotone"] = "rbxassetid://128934527511500",
    	["round-arrow-down-linear"] = "rbxassetid://134487767565058",
    	["round-arrow-down-outline"] = "rbxassetid://134118672810297",
    	["round-arrow-left-bold"] = "rbxassetid://121202406353568",
    	["round-arrow-left-bold-duotone"] = "rbxassetid://92165125240461",
    	["round-arrow-left-broken"] = "rbxassetid://76292683935665",
    	["round-arrow-left-down-bold"] = "rbxassetid://81318168220860",
    	["round-arrow-left-down-bold-duotone"] = "rbxassetid://118035624428460",
    	["round-arrow-left-down-broken"] = "rbxassetid://72865809055801",
    	["round-arrow-left-down-line-duotone"] = "rbxassetid://132403728501448",
    	["round-arrow-left-down-linear"] = "rbxassetid://87611833667737",
    	["round-arrow-left-down-outline"] = "rbxassetid://140264633431992",
    	["round-arrow-left-line-duotone"] = "rbxassetid://135872811194867",
    	["round-arrow-left-linear"] = "rbxassetid://131484011524274",
    	["round-arrow-left-outline"] = "rbxassetid://132800430493869",
    	["round-arrow-left-up-bold"] = "rbxassetid://135262425341860",
    	["round-arrow-left-up-bold-duotone"] = "rbxassetid://89407661115281",
    	["round-arrow-left-up-broken"] = "rbxassetid://113227350154899",
    	["round-arrow-left-up-line-duotone"] = "rbxassetid://132676485450951",
    	["round-arrow-left-up-linear"] = "rbxassetid://73958982087969",
    	["round-arrow-left-up-outline"] = "rbxassetid://134226218014735",
    	["round-arrow-right-bold"] = "rbxassetid://99296997150346",
    	["round-arrow-right-bold-duotone"] = "rbxassetid://79243188351347",
    	["round-arrow-right-broken"] = "rbxassetid://120468337767823",
    	["round-arrow-right-down-bold"] = "rbxassetid://107383245038267",
    	["round-arrow-right-down-bold-duotone"] = "rbxassetid://102929669017953",
    	["round-arrow-right-down-broken"] = "rbxassetid://139483877592957",
    	["round-arrow-right-down-line-duotone"] = "rbxassetid://101020707876537",
    	["round-arrow-right-down-linear"] = "rbxassetid://77054862945837",
    	["round-arrow-right-down-outline"] = "rbxassetid://109889011918478",
    	["round-arrow-right-line-duotone"] = "rbxassetid://113752459388811",
    	["round-arrow-right-linear"] = "rbxassetid://140380128851116",
    	["round-arrow-right-outline"] = "rbxassetid://115798839958236",
    	["round-arrow-right-up-bold"] = "rbxassetid://79681232750390",
    	["round-arrow-right-up-bold-duotone"] = "rbxassetid://80857305427466",
    	["round-arrow-right-up-broken"] = "rbxassetid://87818652929826",
    	["round-arrow-right-up-line-duotone"] = "rbxassetid://108499161193359",
    	["round-arrow-right-up-linear"] = "rbxassetid://109269435341762",
    	["round-arrow-right-up-outline"] = "rbxassetid://81766645689597",
    	["round-arrow-up-bold"] = "rbxassetid://95823152130765",
    	["round-arrow-up-bold-duotone"] = "rbxassetid://110927724967594",
    	["round-arrow-up-broken"] = "rbxassetid://105265357385683",
    	["round-arrow-up-line-duotone"] = "rbxassetid://83505985414503",
    	["round-arrow-up-linear"] = "rbxassetid://81374316860827",
    	["round-arrow-up-outline"] = "rbxassetid://97052705909765",
    	["round-double-alt-arrow-down-bold"] = "rbxassetid://120876685531946",
    	["round-double-alt-arrow-down-bold-duotone"] = "rbxassetid://105580844727440",
    	["round-double-alt-arrow-down-broken"] = "rbxassetid://89655433344292",
    	["round-double-alt-arrow-down-line-duotone"] = "rbxassetid://80681311807406",
    	["round-double-alt-arrow-down-linear"] = "rbxassetid://116090089894924",
    	["round-double-alt-arrow-down-outline"] = "rbxassetid://89454676722237",
    	["round-double-alt-arrow-left-bold"] = "rbxassetid://111304144085829",
    	["round-double-alt-arrow-left-bold-duotone"] = "rbxassetid://110122815086751",
    	["round-double-alt-arrow-left-broken"] = "rbxassetid://91446200592419",
    	["round-double-alt-arrow-left-line-duotone"] = "rbxassetid://109801183206202",
    	["round-double-alt-arrow-left-linear"] = "rbxassetid://94848590774143",
    	["round-double-alt-arrow-left-outline"] = "rbxassetid://96597570078896",
    	["round-double-alt-arrow-right-bold"] = "rbxassetid://108681982512244",
    	["round-double-alt-arrow-right-bold-duotone"] = "rbxassetid://80621263943384",
    	["round-double-alt-arrow-right-broken"] = "rbxassetid://76936292496848",
    	["round-double-alt-arrow-right-line-duotone"] = "rbxassetid://82812976297149",
    	["round-double-alt-arrow-right-linear"] = "rbxassetid://82558883409768",
    	["round-double-alt-arrow-right-outline"] = "rbxassetid://89039655956054",
    	["round-double-alt-arrow-up-bold"] = "rbxassetid://91877668365698",
    	["round-double-alt-arrow-up-bold-duotone"] = "rbxassetid://85125053350982",
    	["round-double-alt-arrow-up-broken"] = "rbxassetid://119620284731797",
    	["round-double-alt-arrow-up-line-duotone"] = "rbxassetid://114044748413465",
    	["round-double-alt-arrow-up-linear"] = "rbxassetid://103062581824141",
    	["round-double-alt-arrow-up-outline"] = "rbxassetid://109187136279487",
    	["round-graph-bold"] = "rbxassetid://140254424979639",
    	["round-graph-bold-duotone"] = "rbxassetid://102199661569813",
    	["round-graph-broken"] = "rbxassetid://137384484150154",
    	["round-graph-line-duotone"] = "rbxassetid://80465842771217",
    	["round-graph-linear"] = "rbxassetid://72994456618021",
    	["round-graph-outline"] = "rbxassetid://124828922472051",
    	["round-sort-horizontal-bold"] = "rbxassetid://115178957119835",
    	["round-sort-horizontal-bold-duotone"] = "rbxassetid://120637528248744",
    	["round-sort-horizontal-broken"] = "rbxassetid://128871544312106",
    	["round-sort-horizontal-line-duotone"] = "rbxassetid://100244345472727",
    	["round-sort-horizontal-linear"] = "rbxassetid://83510032140806",
    	["round-sort-horizontal-outline"] = "rbxassetid://130265606811602",
    	["round-sort-vertical-bold"] = "rbxassetid://87456118802330",
    	["round-sort-vertical-bold-duotone"] = "rbxassetid://118530240112726",
    	["round-sort-vertical-broken"] = "rbxassetid://81985272307486",
    	["round-sort-vertical-line-duotone"] = "rbxassetid://74155955989337",
    	["round-sort-vertical-linear"] = "rbxassetid://88402224142422",
    	["round-sort-vertical-outline"] = "rbxassetid://99776528544538",
    	["round-transfer-diagonal-bold"] = "rbxassetid://116195469047434",
    	["round-transfer-diagonal-bold-duotone"] = "rbxassetid://138141786201710",
    	["round-transfer-diagonal-broken"] = "rbxassetid://140424988031717",
    	["round-transfer-diagonal-line-duotone"] = "rbxassetid://113482237245250",
    	["round-transfer-diagonal-linear"] = "rbxassetid://107972777053037",
    	["round-transfer-diagonal-outline"] = "rbxassetid://139635936580693",
    	["round-transfer-horizontal-bold"] = "rbxassetid://76835017137335",
    	["round-transfer-horizontal-bold-duotone"] = "rbxassetid://138722078932370",
    	["round-transfer-horizontal-broken"] = "rbxassetid://137601297323030",
    	["round-transfer-horizontal-line-duotone"] = "rbxassetid://123350517194944",
    	["round-transfer-horizontal-linear"] = "rbxassetid://93852835639025",
    	["round-transfer-horizontal-outline"] = "rbxassetid://93114429499958",
    	["round-transfer-vertical-bold"] = "rbxassetid://119101653132288",
    	["round-transfer-vertical-bold-duotone"] = "rbxassetid://72663803941419",
    	["round-transfer-vertical-broken"] = "rbxassetid://106221813370863",
    	["round-transfer-vertical-line-duotone"] = "rbxassetid://74512891116496",
    	["round-transfer-vertical-linear"] = "rbxassetid://75848410861161",
    	["round-transfer-vertical-outline"] = "rbxassetid://97389350685598",
    	["rounded-magnifer-bold"] = "rbxassetid://95134607537185",
    	["rounded-magnifer-bold-duotone"] = "rbxassetid://100057576259527",
    	["rounded-magnifer-broken"] = "rbxassetid://95826125454756",
    	["rounded-magnifer-bug-bold"] = "rbxassetid://94433058810000",
    	["rounded-magnifer-bug-bold-duotone"] = "rbxassetid://96146107699188",
    	["rounded-magnifer-bug-broken"] = "rbxassetid://100432774347139",
    	["rounded-magnifer-bug-line-duotone"] = "rbxassetid://111265564888350",
    	["rounded-magnifer-bug-linear"] = "rbxassetid://74654770172798",
    	["rounded-magnifer-bug-outline"] = "rbxassetid://96469774561511",
    	["rounded-magnifer-line-duotone"] = "rbxassetid://116809143852426",
    	["rounded-magnifer-linear"] = "rbxassetid://88162156300036",
    	["rounded-magnifer-outline"] = "rbxassetid://89161382391667",
    	["rounded-magnifer-zoom-in-bold"] = "rbxassetid://78773101290333",
    	["rounded-magnifer-zoom-in-bold-duotone"] = "rbxassetid://117097385731397",
    	["rounded-magnifer-zoom-in-broken"] = "rbxassetid://84886391708300",
    	["rounded-magnifer-zoom-in-line-duotone"] = "rbxassetid://107495125812982",
    	["rounded-magnifer-zoom-in-linear"] = "rbxassetid://95390021950088",
    	["rounded-magnifer-zoom-in-outline"] = "rbxassetid://92074080934971",
    	["rounded-magnifer-zoom-out-bold"] = "rbxassetid://126519861479187",
    	["rounded-magnifer-zoom-out-bold-duotone"] = "rbxassetid://76046096125494",
    	["rounded-magnifer-zoom-out-broken"] = "rbxassetid://120959242704446",
    	["rounded-magnifer-zoom-out-line-duotone"] = "rbxassetid://126742701649916",
    	["rounded-magnifer-zoom-out-linear"] = "rbxassetid://130753580808695",
    	["rounded-magnifer-zoom-out-outline"] = "rbxassetid://126832591086846",
    	["route-bold"] = "rbxassetid://102943663013157",
    	["route-bold-duotone"] = "rbxassetid://100361725530069",
    	["route-broken"] = "rbxassetid://87749300659258",
    	["route-line-duotone"] = "rbxassetid://76962489309036",
    	["route-linear"] = "rbxassetid://131056195565537",
    	["route-outline"] = "rbxassetid://113938820843799",
    	["routing-2-bold"] = "rbxassetid://88159920359144",
    	["routing-2-bold-duotone"] = "rbxassetid://78232575510706",
    	["routing-2-broken"] = "rbxassetid://129600584094061",
    	["routing-2-line-duotone"] = "rbxassetid://103211231346216",
    	["routing-2-linear"] = "rbxassetid://78507983230003",
    	["routing-2-outline"] = "rbxassetid://119010856989276",
    	["routing-3-bold"] = "rbxassetid://75106024435859",
    	["routing-3-bold-duotone"] = "rbxassetid://83895868618601",
    	["routing-3-broken"] = "rbxassetid://100616570582614",
    	["routing-3-line-duotone"] = "rbxassetid://128279597111378",
    	["routing-3-linear"] = "rbxassetid://85960211142547",
    	["routing-3-outline"] = "rbxassetid://95694499207941",
    	["routing-bold"] = "rbxassetid://78564691541876",
    	["routing-bold-duotone"] = "rbxassetid://95143002641523",
    	["routing-broken"] = "rbxassetid://84701916908248",
    	["routing-line-duotone"] = "rbxassetid://127973542352166",
    	["routing-linear"] = "rbxassetid://71547987958877",
    	["routing-outline"] = "rbxassetid://117580024944722",
    	["ruble-bold"] = "rbxassetid://122151992699406",
    	["ruble-bold-duotone"] = "rbxassetid://105718468816214",
    	["ruble-broken"] = "rbxassetid://70882486370045",
    	["ruble-line-duotone"] = "rbxassetid://110652322903622",
    	["ruble-linear"] = "rbxassetid://122464813311335",
    	["ruble-outline"] = "rbxassetid://90928370390072",
    	["rugby-bold"] = "rbxassetid://95222072436079",
    	["rugby-bold-duotone"] = "rbxassetid://138709756253366",
    	["rugby-broken"] = "rbxassetid://82055013184076",
    	["rugby-line-duotone"] = "rbxassetid://111882558884417",
    	["rugby-linear"] = "rbxassetid://88575681854020",
    	["rugby-outline"] = "rbxassetid://103182942967314",
    	["ruler-angular-bold"] = "rbxassetid://125826556933725",
    	["ruler-angular-bold-duotone"] = "rbxassetid://126648713641079",
    	["ruler-angular-broken"] = "rbxassetid://86998103829859",
    	["ruler-angular-line-duotone"] = "rbxassetid://92155418736172",
    	["ruler-angular-linear"] = "rbxassetid://139982570079409",
    	["ruler-angular-outline"] = "rbxassetid://107706248335720",
    	["ruler-bold"] = "rbxassetid://119326382853863",
    	["ruler-bold-duotone"] = "rbxassetid://75968773388510",
    	["ruler-broken"] = "rbxassetid://132558272933053",
    	["ruler-cross-pen-bold"] = "rbxassetid://101501765759599",
    	["ruler-cross-pen-bold-duotone"] = "rbxassetid://118516108756132",
    	["ruler-cross-pen-broken"] = "rbxassetid://121996187565115",
    	["ruler-cross-pen-line-duotone"] = "rbxassetid://74230770655935",
    	["ruler-cross-pen-linear"] = "rbxassetid://126888896199943",
    	["ruler-cross-pen-outline"] = "rbxassetid://132548089573475",
    	["ruler-line-duotone"] = "rbxassetid://73768258905566",
    	["ruler-linear"] = "rbxassetid://100487501300781",
    	["ruler-outline"] = "rbxassetid://123792055355500",
    	["ruler-pen-bold"] = "rbxassetid://96737749067188",
    	["ruler-pen-bold-duotone"] = "rbxassetid://101546333538298",
    	["ruler-pen-broken"] = "rbxassetid://86792025342538",
    	["ruler-pen-line-duotone"] = "rbxassetid://125351561229017",
    	["ruler-pen-linear"] = "rbxassetid://140301039415317",
    	["ruler-pen-outline"] = "rbxassetid://73884299733126",
    	["running-2-bold"] = "rbxassetid://97162339719605",
    	["running-2-bold-duotone"] = "rbxassetid://111440303310169",
    	["running-2-broken"] = "rbxassetid://94250953563534",
    	["running-2-line-duotone"] = "rbxassetid://121414422465995",
    	["running-2-linear"] = "rbxassetid://98937781975937",
    	["running-2-outline"] = "rbxassetid://71157462087288",
    	["running-bold"] = "rbxassetid://89759466188696",
    	["running-bold-duotone"] = "rbxassetid://114308696043456",
    	["running-broken"] = "rbxassetid://82838841307125",
    	["running-line-duotone"] = "rbxassetid://95744038871959",
    	["running-linear"] = "rbxassetid://79102831159559",
    	["running-outline"] = "rbxassetid://76205314960872",
    	["running-round-bold"] = "rbxassetid://136675007343963",
    	["running-round-bold-duotone"] = "rbxassetid://100957547486099",
    	["running-round-broken"] = "rbxassetid://122866099882993",
    	["running-round-line-duotone"] = "rbxassetid://112842593090399",
    	["running-round-linear"] = "rbxassetid://92463245391114",
    	["running-round-outline"] = "rbxassetid://102016898854307",
    	["sad-circle-bold"] = "rbxassetid://102956731011118",
    	["sad-circle-bold-duotone"] = "rbxassetid://92755076450509",
    	["sad-circle-broken"] = "rbxassetid://128863133200859",
    	["sad-circle-line-duotone"] = "rbxassetid://138453390169068",
    	["sad-circle-linear"] = "rbxassetid://71746814831376",
    	["sad-circle-outline"] = "rbxassetid://77014601129417",
    	["sad-square-bold"] = "rbxassetid://75434403130641",
    	["sad-square-bold-duotone"] = "rbxassetid://80052773745859",
    	["sad-square-broken"] = "rbxassetid://134215107726698",
    	["sad-square-line-duotone"] = "rbxassetid://115833338627291",
    	["sad-square-linear"] = "rbxassetid://131995673431351",
    	["sad-square-outline"] = "rbxassetid://126191320429933",
    	["safe-2-bold"] = "rbxassetid://96825790870143",
    	["safe-2-bold-duotone"] = "rbxassetid://123700915310033",
    	["safe-2-broken"] = "rbxassetid://137809241899679",
    	["safe-2-line-duotone"] = "rbxassetid://81871847818760",
    	["safe-2-linear"] = "rbxassetid://71354872644025",
    	["safe-2-outline"] = "rbxassetid://105678819177795",
    	["safe-circle-bold"] = "rbxassetid://107515643413820",
    	["safe-circle-bold-duotone"] = "rbxassetid://104174967183081",
    	["safe-circle-broken"] = "rbxassetid://126027267274846",
    	["safe-circle-line-duotone"] = "rbxassetid://115882439417113",
    	["safe-circle-linear"] = "rbxassetid://110314171271395",
    	["safe-circle-outline"] = "rbxassetid://105199941132823",
    	["safe-square-bold"] = "rbxassetid://131949849590358",
    	["safe-square-bold-duotone"] = "rbxassetid://73198569509657",
    	["safe-square-broken"] = "rbxassetid://125591208954703",
    	["safe-square-line-duotone"] = "rbxassetid://99759420803622",
    	["safe-square-linear"] = "rbxassetid://75740646292785",
    	["safe-square-outline"] = "rbxassetid://131274590522493",
    	["sale-bold"] = "rbxassetid://118095540025910",
    	["sale-bold-duotone"] = "rbxassetid://105154333256469",
    	["sale-broken"] = "rbxassetid://137877620856348",
    	["sale-line-duotone"] = "rbxassetid://91582837688100",
    	["sale-linear"] = "rbxassetid://122902604949653",
    	["sale-outline"] = "rbxassetid://84900339717345",
    	["sale-square-bold"] = "rbxassetid://115470965191356",
    	["sale-square-bold-duotone"] = "rbxassetid://98186920782841",
    	["sale-square-broken"] = "rbxassetid://88642388082267",
    	["sale-square-line-duotone"] = "rbxassetid://125060448773520",
    	["sale-square-linear"] = "rbxassetid://121595006492908",
    	["sale-square-outline"] = "rbxassetid://123262848152138",
    	["satellite-bold"] = "rbxassetid://127253775531051",
    	["satellite-bold-duotone"] = "rbxassetid://116037120840719",
    	["satellite-broken"] = "rbxassetid://79447745684777",
    	["satellite-line-duotone"] = "rbxassetid://116843271021890",
    	["satellite-linear"] = "rbxassetid://104390312676868",
    	["satellite-outline"] = "rbxassetid://105472970899707",
    	["scale-bold"] = "rbxassetid://103296279194255",
    	["scale-bold-duotone"] = "rbxassetid://113267118161141",
    	["scale-broken"] = "rbxassetid://81516656706729",
    	["scale-line-duotone"] = "rbxassetid://140130902917939",
    	["scale-linear"] = "rbxassetid://134237704239532",
    	["scale-outline"] = "rbxassetid://97382397592789",
    	["scanner-2-bold"] = "rbxassetid://110536896960142",
    	["scanner-2-bold-duotone"] = "rbxassetid://71833791577693",
    	["scanner-2-broken"] = "rbxassetid://130471616712203",
    	["scanner-2-line-duotone"] = "rbxassetid://107659110369150",
    	["scanner-2-linear"] = "rbxassetid://119237290600416",
    	["scanner-2-outline"] = "rbxassetid://97740822119113",
    	["scanner-bold"] = "rbxassetid://101998785706398",
    	["scanner-bold-duotone"] = "rbxassetid://118227696330009",
    	["scanner-broken"] = "rbxassetid://103198084939612",
    	["scanner-line-duotone"] = "rbxassetid://77745862681489",
    	["scanner-linear"] = "rbxassetid://112429980484158",
    	["scanner-outline"] = "rbxassetid://79344662578547",
    	["scissors-bold"] = "rbxassetid://77824226693775",
    	["scissors-bold-duotone"] = "rbxassetid://139374777645025",
    	["scissors-broken"] = "rbxassetid://112090539686462",
    	["scissors-line-duotone"] = "rbxassetid://114337827456600",
    	["scissors-linear"] = "rbxassetid://97868137143427",
    	["scissors-outline"] = "rbxassetid://118010289492779",
    	["scissors-square-bold"] = "rbxassetid://133632397509548",
    	["scissors-square-bold-duotone"] = "rbxassetid://75873097460134",
    	["scissors-square-broken"] = "rbxassetid://117418970916442",
    	["scissors-square-line-duotone"] = "rbxassetid://110722870496907",
    	["scissors-square-linear"] = "rbxassetid://79552582776344",
    	["scissors-square-outline"] = "rbxassetid://93542608821236",
    	["scooter-bold"] = "rbxassetid://82847832551713",
    	["scooter-linear"] = "rbxassetid://82807953834431",
    	["screen-share-bold"] = "rbxassetid://123147801930077",
    	["screen-share-bold-duotone"] = "rbxassetid://100999343991480",
    	["screen-share-broken"] = "rbxassetid://97009428207360",
    	["screen-share-line-duotone"] = "rbxassetid://128470486693459",
    	["screen-share-linear"] = "rbxassetid://82300014021902",
    	["screen-share-outline"] = "rbxassetid://136199056467617",
    	["screencast-2-bold"] = "rbxassetid://89656277813513",
    	["screencast-2-bold-duotone"] = "rbxassetid://129311224693216",
    	["screencast-2-broken"] = "rbxassetid://120625507354534",
    	["screencast-2-line-duotone"] = "rbxassetid://138934505633466",
    	["screencast-2-linear"] = "rbxassetid://120130261827561",
    	["screencast-2-outline"] = "rbxassetid://74920979322661",
    	["screencast-bold"] = "rbxassetid://88060745191178",
    	["screencast-bold-duotone"] = "rbxassetid://97445107074675",
    	["screencast-broken"] = "rbxassetid://91485913798736",
    	["screencast-line-duotone"] = "rbxassetid://95628811801483",
    	["screencast-linear"] = "rbxassetid://109717592303114",
    	["screencast-outline"] = "rbxassetid://78270253073139",
    	["sd-card-bold"] = "rbxassetid://121054027274584",
    	["sd-card-bold-duotone"] = "rbxassetid://135451685434375",
    	["sd-card-broken"] = "rbxassetid://113835041125063",
    	["sd-card-line-duotone"] = "rbxassetid://136834397310027",
    	["sd-card-linear"] = "rbxassetid://120469788966391",
    	["sd-card-outline"] = "rbxassetid://93324095350800",
    	["send-square-bold"] = "rbxassetid://105521306587375",
    	["send-square-bold-duotone"] = "rbxassetid://114650986363045",
    	["send-square-broken"] = "rbxassetid://93755442317872",
    	["send-square-line-duotone"] = "rbxassetid://99435608961914",
    	["send-square-linear"] = "rbxassetid://122109101624469",
    	["send-square-outline"] = "rbxassetid://72435533300991",
    	["send-twice-square-bold"] = "rbxassetid://135998365078660",
    	["send-twice-square-bold-duotone"] = "rbxassetid://120644688150684",
    	["send-twice-square-broken"] = "rbxassetid://119980495733995",
    	["send-twice-square-line-duotone"] = "rbxassetid://104225734431392",
    	["send-twice-square-linear"] = "rbxassetid://139390921884450",
    	["send-twice-square-outline"] = "rbxassetid://136326299875052",
    	["server-2-bold"] = "rbxassetid://89893828269204",
    	["server-2-bold-duotone"] = "rbxassetid://87305953226267",
    	["server-2-broken"] = "rbxassetid://136803109612536",
    	["server-2-line-duotone"] = "rbxassetid://85081639335752",
    	["server-2-linear"] = "rbxassetid://103645840544453",
    	["server-2-outline"] = "rbxassetid://124458873158604",
    	["server-bold"] = "rbxassetid://131822242188074",
    	["server-bold-duotone"] = "rbxassetid://95414708303773",
    	["server-broken"] = "rbxassetid://121032075838789",
    	["server-line-duotone"] = "rbxassetid://77701529372272",
    	["server-linear"] = "rbxassetid://131961222447531",
    	["server-minimalistic-bold"] = "rbxassetid://116549199151156",
    	["server-minimalistic-bold-duotone"] = "rbxassetid://91309249653991",
    	["server-minimalistic-broken"] = "rbxassetid://87278840724100",
    	["server-minimalistic-line-duotone"] = "rbxassetid://97024715420619",
    	["server-minimalistic-linear"] = "rbxassetid://92457367666183",
    	["server-minimalistic-outline"] = "rbxassetid://120587920437169",
    	["server-outline"] = "rbxassetid://111149371843150",
    	["server-path-bold"] = "rbxassetid://132732889918226",
    	["server-path-bold-duotone"] = "rbxassetid://76193442428722",
    	["server-path-broken"] = "rbxassetid://79673914874748",
    	["server-path-line-duotone"] = "rbxassetid://71824761796130",
    	["server-path-linear"] = "rbxassetid://133951813819504",
    	["server-path-outline"] = "rbxassetid://135779660452172",
    	["server-square-bold"] = "rbxassetid://89922620765551",
    	["server-square-bold-duotone"] = "rbxassetid://108721086842654",
    	["server-square-broken"] = "rbxassetid://139937033996360",
    	["server-square-cloud-bold"] = "rbxassetid://81135490817323",
    	["server-square-cloud-bold-duotone"] = "rbxassetid://94326221917988",
    	["server-square-cloud-broken"] = "rbxassetid://83891387180866",
    	["server-square-cloud-line-duotone"] = "rbxassetid://100490923660177",
    	["server-square-cloud-linear"] = "rbxassetid://114142880518300",
    	["server-square-cloud-outline"] = "rbxassetid://125751620248632",
    	["server-square-line-duotone"] = "rbxassetid://78684795806019",
    	["server-square-linear"] = "rbxassetid://79202629364914",
    	["server-square-outline"] = "rbxassetid://97306694614424",
    	["server-square-update-bold"] = "rbxassetid://77400928240062",
    	["server-square-update-bold-duotone"] = "rbxassetid://90957947136370",
    	["server-square-update-broken"] = "rbxassetid://119201244953038",
    	["server-square-update-line-duotone"] = "rbxassetid://92167207443637",
    	["server-square-update-linear"] = "rbxassetid://83686519345893",
    	["server-square-update-outline"] = "rbxassetid://140020797673485",
    	["settings-bold"] = "rbxassetid://140704441124047",
    	["settings-bold-duotone"] = "rbxassetid://88356197807286",
    	["settings-broken"] = "rbxassetid://115208610740334",
    	["settings-line-duotone"] = "rbxassetid://120770320513095",
    	["settings-linear"] = "rbxassetid://81515674479977",
    	["settings-minimalistic-bold"] = "rbxassetid://72727338348045",
    	["settings-minimalistic-bold-duotone"] = "rbxassetid://103571645691504",
    	["settings-minimalistic-broken"] = "rbxassetid://96235550369102",
    	["settings-minimalistic-line-duotone"] = "rbxassetid://118649509740408",
    	["settings-minimalistic-linear"] = "rbxassetid://89643002560599",
    	["settings-minimalistic-outline"] = "rbxassetid://86273609584449",
    	["settings-outline"] = "rbxassetid://132548812899645",
    	["share-bold"] = "rbxassetid://98205282026993",
    	["share-bold-duotone"] = "rbxassetid://102678904109437",
    	["share-broken"] = "rbxassetid://114648056707448",
    	["share-circle-bold"] = "rbxassetid://131699812289817",
    	["share-circle-bold-duotone"] = "rbxassetid://138769451801379",
    	["share-circle-broken"] = "rbxassetid://96015689311851",
    	["share-circle-line-duotone"] = "rbxassetid://74350395611549",
    	["share-circle-linear"] = "rbxassetid://112520866101898",
    	["share-circle-outline"] = "rbxassetid://115351171785033",
    	["share-line-duotone"] = "rbxassetid://135277063148662",
    	["share-linear"] = "rbxassetid://95177325426726",
    	["share-outline"] = "rbxassetid://89553886430922",
    	["shield-bold"] = "rbxassetid://105619007041452",
    	["shield-bold-duotone"] = "rbxassetid://135593101608961",
    	["shield-broken"] = "rbxassetid://112266464476486",
    	["shield-check-bold"] = "rbxassetid://138813829483190",
    	["shield-check-bold-duotone"] = "rbxassetid://109529390936473",
    	["shield-check-broken"] = "rbxassetid://116678057970725",
    	["shield-check-line-duotone"] = "rbxassetid://80386721208054",
    	["shield-check-linear"] = "rbxassetid://129217869925825",
    	["shield-check-outline"] = "rbxassetid://121946450815604",
    	["shield-cross-bold"] = "rbxassetid://73501670141022",
    	["shield-cross-bold-duotone"] = "rbxassetid://79390646979489",
    	["shield-cross-broken"] = "rbxassetid://72408050997200",
    	["shield-cross-line-duotone"] = "rbxassetid://102078525007987",
    	["shield-cross-linear"] = "rbxassetid://85650342911371",
    	["shield-cross-outline"] = "rbxassetid://81725399351497",
    	["shield-keyhole-bold"] = "rbxassetid://126056849024542",
    	["shield-keyhole-bold-duotone"] = "rbxassetid://82926529527503",
    	["shield-keyhole-broken"] = "rbxassetid://88967720803557",
    	["shield-keyhole-line-duotone"] = "rbxassetid://82303997386551",
    	["shield-keyhole-linear"] = "rbxassetid://113090482542231",
    	["shield-keyhole-minimalistic-bold"] = "rbxassetid://111757452305565",
    	["shield-keyhole-minimalistic-bold-duotone"] = "rbxassetid://139758380554919",
    	["shield-keyhole-minimalistic-broken"] = "rbxassetid://133916622945825",
    	["shield-keyhole-minimalistic-line-duotone"] = "rbxassetid://75818702908227",
    	["shield-keyhole-minimalistic-linear"] = "rbxassetid://126020271889973",
    	["shield-keyhole-minimalistic-outline"] = "rbxassetid://85920994426572",
    	["shield-keyhole-outline"] = "rbxassetid://134808345701811",
    	["shield-line-duotone"] = "rbxassetid://87191262835125",
    	["shield-linear"] = "rbxassetid://84211715226276",
    	["shield-minimalistic-bold"] = "rbxassetid://80494162837154",
    	["shield-minimalistic-bold-duotone"] = "rbxassetid://138661336634487",
    	["shield-minimalistic-broken"] = "rbxassetid://86531648776759",
    	["shield-minimalistic-line-duotone"] = "rbxassetid://128455601586649",
    	["shield-minimalistic-linear"] = "rbxassetid://103208536431593",
    	["shield-minimalistic-outline"] = "rbxassetid://137133186139703",
    	["shield-minus-bold"] = "rbxassetid://134582499220374",
    	["shield-minus-bold-duotone"] = "rbxassetid://123162356303726",
    	["shield-minus-broken"] = "rbxassetid://102296398702191",
    	["shield-minus-line-duotone"] = "rbxassetid://72553495783071",
    	["shield-minus-linear"] = "rbxassetid://107250819666385",
    	["shield-minus-outline"] = "rbxassetid://117234124456901",
    	["shield-network-bold"] = "rbxassetid://86532242996762",
    	["shield-network-bold-duotone"] = "rbxassetid://82849617481293",
    	["shield-network-broken"] = "rbxassetid://95454355938515",
    	["shield-network-line-duotone"] = "rbxassetid://110326225510981",
    	["shield-network-linear"] = "rbxassetid://129513434460211",
    	["shield-network-outline"] = "rbxassetid://137797041795450",
    	["shield-outline"] = "rbxassetid://81921618377911",
    	["shield-plus-bold"] = "rbxassetid://136784563828964",
    	["shield-plus-bold-duotone"] = "rbxassetid://84643726153859",
    	["shield-plus-broken"] = "rbxassetid://86978147201009",
    	["shield-plus-line-duotone"] = "rbxassetid://108489115799292",
    	["shield-plus-linear"] = "rbxassetid://91747222134515",
    	["shield-plus-outline"] = "rbxassetid://119708256751935",
    	["shield-star-bold"] = "rbxassetid://70874760305945",
    	["shield-star-bold-duotone"] = "rbxassetid://99859482851083",
    	["shield-star-broken"] = "rbxassetid://99837232135167",
    	["shield-star-line-duotone"] = "rbxassetid://134318080544767",
    	["shield-star-linear"] = "rbxassetid://86876829158103",
    	["shield-star-outline"] = "rbxassetid://73157693239855",
    	["shield-up-bold"] = "rbxassetid://109643147383429",
    	["shield-up-bold-duotone"] = "rbxassetid://71225671460241",
    	["shield-up-broken"] = "rbxassetid://130186839015163",
    	["shield-up-line-duotone"] = "rbxassetid://126372738438753",
    	["shield-up-linear"] = "rbxassetid://101089942625557",
    	["shield-up-outline"] = "rbxassetid://96619113160075",
    	["shield-user-bold"] = "rbxassetid://96854505285284",
    	["shield-user-bold-duotone"] = "rbxassetid://128525427651075",
    	["shield-user-broken"] = "rbxassetid://120172960446204",
    	["shield-user-line-duotone"] = "rbxassetid://126263142119843",
    	["shield-user-linear"] = "rbxassetid://100140984616456",
    	["shield-user-outline"] = "rbxassetid://107847999995031",
    	["shield-warning-bold"] = "rbxassetid://130226573962640",
    	["shield-warning-bold-duotone"] = "rbxassetid://139796731150549",
    	["shield-warning-broken"] = "rbxassetid://82262289027473",
    	["shield-warning-line-duotone"] = "rbxassetid://93265490410096",
    	["shield-warning-linear"] = "rbxassetid://100851445466101",
    	["shield-warning-outline"] = "rbxassetid://113170163475623",
    	["shock-absorber-bold"] = "rbxassetid://89555676609379",
    	["shock-absorber-linear"] = "rbxassetid://89027228618660",
    	["shop-2-bold"] = "rbxassetid://92246295435163",
    	["shop-2-bold-duotone"] = "rbxassetid://83235396124561",
    	["shop-2-broken"] = "rbxassetid://99542600109891",
    	["shop-2-line-duotone"] = "rbxassetid://90787284106242",
    	["shop-2-linear"] = "rbxassetid://90842724783116",
    	["shop-2-outline"] = "rbxassetid://122499524239824",
    	["shop-bold"] = "rbxassetid://87353934937155",
    	["shop-bold-duotone"] = "rbxassetid://93261851774287",
    	["shop-broken"] = "rbxassetid://139554869421720",
    	["shop-line-duotone"] = "rbxassetid://84277284516819",
    	["shop-linear"] = "rbxassetid://77436938169283",
    	["shop-minimalistic-bold"] = "rbxassetid://105022135170615",
    	["shop-minimalistic-bold-duotone"] = "rbxassetid://133339243980865",
    	["shop-minimalistic-broken"] = "rbxassetid://104604691298592",
    	["shop-minimalistic-line-duotone"] = "rbxassetid://109740037420669",
    	["shop-minimalistic-linear"] = "rbxassetid://97623629648268",
    	["shop-minimalistic-outline"] = "rbxassetid://81688785271319",
    	["shop-outline"] = "rbxassetid://125206764907328",
    	["shuffle-bold"] = "rbxassetid://98537688124004",
    	["shuffle-bold-duotone"] = "rbxassetid://135266235212968",
    	["shuffle-broken"] = "rbxassetid://108017018662197",
    	["shuffle-line-duotone"] = "rbxassetid://118292033142156",
    	["shuffle-linear"] = "rbxassetid://91408752099227",
    	["shuffle-outline"] = "rbxassetid://96540773744358",
    	["sidebar-code-bold"] = "rbxassetid://93412654258157",
    	["sidebar-code-bold-duotone"] = "rbxassetid://113597152138557",
    	["sidebar-code-broken"] = "rbxassetid://104124931038727",
    	["sidebar-code-line-duotone"] = "rbxassetid://92442099183788",
    	["sidebar-code-linear"] = "rbxassetid://127031700675539",
    	["sidebar-code-outline"] = "rbxassetid://139195486380128",
    	["sidebar-minimalistic-bold"] = "rbxassetid://92696737298939",
    	["sidebar-minimalistic-bold-duotone"] = "rbxassetid://140590672210635",
    	["sidebar-minimalistic-broken"] = "rbxassetid://126975196141547",
    	["sidebar-minimalistic-line-duotone"] = "rbxassetid://123329717832505",
    	["sidebar-minimalistic-linear"] = "rbxassetid://94073872227575",
    	["sidebar-minimalistic-outline"] = "rbxassetid://98567839741249",
    	["siderbar-bold"] = "rbxassetid://110749999898163",
    	["siderbar-bold-duotone"] = "rbxassetid://137373856130115",
    	["siderbar-broken"] = "rbxassetid://80309274498833",
    	["siderbar-line-duotone"] = "rbxassetid://92482616909683",
    	["siderbar-linear"] = "rbxassetid://93294315851986",
    	["siderbar-outline"] = "rbxassetid://93596752702422",
    	["signpost-2-bold"] = "rbxassetid://130799320325797",
    	["signpost-2-bold-duotone"] = "rbxassetid://72347597865906",
    	["signpost-2-broken"] = "rbxassetid://86126461545761",
    	["signpost-2-line-duotone"] = "rbxassetid://91530025697349",
    	["signpost-2-linear"] = "rbxassetid://137117596768909",
    	["signpost-2-outline"] = "rbxassetid://131543544778121",
    	["signpost-bold"] = "rbxassetid://76178537874048",
    	["signpost-bold-duotone"] = "rbxassetid://108899797947842",
    	["signpost-broken"] = "rbxassetid://73772323935621",
    	["signpost-line-duotone"] = "rbxassetid://101505768164968",
    	["signpost-linear"] = "rbxassetid://136874597734403",
    	["signpost-outline"] = "rbxassetid://81238040975218",
    	["sim-card-bold"] = "rbxassetid://131899681810623",
    	["sim-card-bold-duotone"] = "rbxassetid://139526632849332",
    	["sim-card-broken"] = "rbxassetid://73234166518262",
    	["sim-card-line-duotone"] = "rbxassetid://138335605818289",
    	["sim-card-linear"] = "rbxassetid://88906533450035",
    	["sim-card-minimalistic-bold"] = "rbxassetid://77378751390989",
    	["sim-card-minimalistic-bold-duotone"] = "rbxassetid://96986492541461",
    	["sim-card-minimalistic-broken"] = "rbxassetid://97093158884414",
    	["sim-card-minimalistic-line-duotone"] = "rbxassetid://75671532450114",
    	["sim-card-minimalistic-linear"] = "rbxassetid://97353467878588",
    	["sim-card-minimalistic-outline"] = "rbxassetid://126597665662978",
    	["sim-card-outline"] = "rbxassetid://82356452874121",
    	["sim-cards-bold"] = "rbxassetid://73788905695106",
    	["sim-cards-bold-duotone"] = "rbxassetid://84623078042584",
    	["sim-cards-broken"] = "rbxassetid://104593384485184",
    	["sim-cards-line-duotone"] = "rbxassetid://117350999954060",
    	["sim-cards-linear"] = "rbxassetid://88444504150964",
    	["sim-cards-outline"] = "rbxassetid://117030353051532",
    	["siren-bold"] = "rbxassetid://80264845612183",
    	["siren-bold-duotone"] = "rbxassetid://134901852067284",
    	["siren-broken"] = "rbxassetid://132330820371745",
    	["siren-line-duotone"] = "rbxassetid://125303618968385",
    	["siren-linear"] = "rbxassetid://96071855896554",
    	["siren-outline"] = "rbxassetid://116744314024775",
    	["siren-rounded-bold"] = "rbxassetid://95350629533255",
    	["siren-rounded-bold-duotone"] = "rbxassetid://93803310503171",
    	["siren-rounded-broken"] = "rbxassetid://103192241622623",
    	["siren-rounded-line-duotone"] = "rbxassetid://107809178561676",
    	["siren-rounded-linear"] = "rbxassetid://103586697784316",
    	["siren-rounded-outline"] = "rbxassetid://90019654685477",
    	["skateboard-bold"] = "rbxassetid://84369674199881",
    	["skateboard-bold-duotone"] = "rbxassetid://92336166872441",
    	["skateboard-broken"] = "rbxassetid://138916479789383",
    	["skateboard-line-duotone"] = "rbxassetid://103704562530155",
    	["skateboard-linear"] = "rbxassetid://124450680173226",
    	["skateboard-outline"] = "rbxassetid://82542317642944",
    	["skateboarding-bold"] = "rbxassetid://113729282739078",
    	["skateboarding-bold-duotone"] = "rbxassetid://113616172794711",
    	["skateboarding-broken"] = "rbxassetid://125403623039358",
    	["skateboarding-line-duotone"] = "rbxassetid://104161446210439",
    	["skateboarding-linear"] = "rbxassetid://138222951759512",
    	["skateboarding-outline"] = "rbxassetid://71311963435244",
    	["skateboarding-round-bold"] = "rbxassetid://137792094624164",
    	["skateboarding-round-bold-duotone"] = "rbxassetid://107191647388940",
    	["skateboarding-round-broken"] = "rbxassetid://87368044247593",
    	["skateboarding-round-line-duotone"] = "rbxassetid://129641056413999",
    	["skateboarding-round-linear"] = "rbxassetid://130901844653189",
    	["skateboarding-round-outline"] = "rbxassetid://138075258761914",
    	["skip-next-bold"] = "rbxassetid://127467521419903",
    	["skip-next-bold-duotone"] = "rbxassetid://116177030441408",
    	["skip-next-broken"] = "rbxassetid://98921128603336",
    	["skip-next-line-duotone"] = "rbxassetid://127108994117967",
    	["skip-next-linear"] = "rbxassetid://134290221832501",
    	["skip-next-outline"] = "rbxassetid://87802495391645",
    	["skip-previous-bold"] = "rbxassetid://92672240459844",
    	["skip-previous-bold-duotone"] = "rbxassetid://92854456629379",
    	["skip-previous-broken"] = "rbxassetid://125221791969613",
    	["skip-previous-line-duotone"] = "rbxassetid://119600814784402",
    	["skip-previous-linear"] = "rbxassetid://75129006804070",
    	["skip-previous-outline"] = "rbxassetid://91425459541557",
    	["skirt-bold"] = "rbxassetid://138888640200277",
    	["skirt-bold-duotone"] = "rbxassetid://85910805110545",
    	["skirt-broken"] = "rbxassetid://130092117913011",
    	["skirt-line-duotone"] = "rbxassetid://130799683935778",
    	["skirt-linear"] = "rbxassetid://74185684856107",
    	["skirt-outline"] = "rbxassetid://117909699759559",
    	["slash-circle-bold"] = "rbxassetid://95836958362585",
    	["slash-circle-bold-duotone"] = "rbxassetid://98569210013343",
    	["slash-circle-broken"] = "rbxassetid://127964468710139",
    	["slash-circle-line-duotone"] = "rbxassetid://74014952972094",
    	["slash-circle-linear"] = "rbxassetid://110217905721052",
    	["slash-circle-outline"] = "rbxassetid://82149921250660",
    	["slash-square-bold"] = "rbxassetid://110781777562548",
    	["slash-square-bold-duotone"] = "rbxassetid://118032964013512",
    	["slash-square-broken"] = "rbxassetid://117977905718393",
    	["slash-square-line-duotone"] = "rbxassetid://122284522006338",
    	["slash-square-linear"] = "rbxassetid://137185263165401",
    	["slash-square-outline"] = "rbxassetid://84374060063511",
    	["sledgehammer-bold"] = "rbxassetid://118270658402814",
    	["sledgehammer-bold-duotone"] = "rbxassetid://77104247374701",
    	["sledgehammer-broken"] = "rbxassetid://138133549880644",
    	["sledgehammer-line-duotone"] = "rbxassetid://115337485636926",
    	["sledgehammer-linear"] = "rbxassetid://89755410172356",
    	["sledgehammer-outline"] = "rbxassetid://90916400239183",
    	["sleeping-bold"] = "rbxassetid://74887623287217",
    	["sleeping-bold-duotone"] = "rbxassetid://109761134655027",
    	["sleeping-broken"] = "rbxassetid://92888175019158",
    	["sleeping-circle-bold"] = "rbxassetid://87910637152184",
    	["sleeping-circle-bold-duotone"] = "rbxassetid://77494488195539",
    	["sleeping-circle-broken"] = "rbxassetid://113657330646380",
    	["sleeping-circle-line-duotone"] = "rbxassetid://76945423083541",
    	["sleeping-circle-linear"] = "rbxassetid://94075226950377",
    	["sleeping-circle-outline"] = "rbxassetid://97323120794274",
    	["sleeping-line-duotone"] = "rbxassetid://124223217925718",
    	["sleeping-linear"] = "rbxassetid://96658683373923",
    	["sleeping-outline"] = "rbxassetid://101195504435850",
    	["sleeping-square-bold"] = "rbxassetid://79169508324127",
    	["sleeping-square-bold-duotone"] = "rbxassetid://84043787695174",
    	["sleeping-square-broken"] = "rbxassetid://96979420869189",
    	["sleeping-square-line-duotone"] = "rbxassetid://98718226689948",
    	["sleeping-square-linear"] = "rbxassetid://95940221350641",
    	["sleeping-square-outline"] = "rbxassetid://89339839734072",
    	["slider-horizontal-bold"] = "rbxassetid://96877645370923",
    	["slider-horizontal-bold-duotone"] = "rbxassetid://78004077431541",
    	["slider-horizontal-broken"] = "rbxassetid://131794260069356",
    	["slider-horizontal-line-duotone"] = "rbxassetid://101002128012939",
    	["slider-horizontal-linear"] = "rbxassetid://122490224057743",
    	["slider-horizontal-outline"] = "rbxassetid://119700865538079",
    	["slider-minimalistic-horizontal-bold"] = "rbxassetid://99190245549027",
    	["slider-minimalistic-horizontal-bold-duotone"] = "rbxassetid://123781821774011",
    	["slider-minimalistic-horizontal-broken"] = "rbxassetid://106057270080983",
    	["slider-minimalistic-horizontal-line-duotone"] = "rbxassetid://137555293387441",
    	["slider-minimalistic-horizontal-linear"] = "rbxassetid://136386875964731",
    	["slider-minimalistic-horizontal-outline"] = "rbxassetid://89874160207163",
    	["slider-vertical-bold"] = "rbxassetid://89315075407870",
    	["slider-vertical-bold-duotone"] = "rbxassetid://131303367382375",
    	["slider-vertical-broken"] = "rbxassetid://97982499931577",
    	["slider-vertical-line-duotone"] = "rbxassetid://132290723746515",
    	["slider-vertical-linear"] = "rbxassetid://76054510235210",
    	["slider-vertical-minimalistic-bold"] = "rbxassetid://88646391149048",
    	["slider-vertical-minimalistic-bold-duotone"] = "rbxassetid://117247834029043",
    	["slider-vertical-minimalistic-broken"] = "rbxassetid://107963406151944",
    	["slider-vertical-minimalistic-line-duotone"] = "rbxassetid://135744924333853",
    	["slider-vertical-minimalistic-linear"] = "rbxassetid://87501366120561",
    	["slider-vertical-minimalistic-outline"] = "rbxassetid://90473729396451",
    	["slider-vertical-outline"] = "rbxassetid://82904314644664",
    	["smart-home-angle-bold"] = "rbxassetid://94982212036559",
    	["smart-home-angle-bold-duotone"] = "rbxassetid://100372489284070",
    	["smart-home-angle-broken"] = "rbxassetid://118385287216850",
    	["smart-home-angle-line-duotone"] = "rbxassetid://70460815040669",
    	["smart-home-angle-linear"] = "rbxassetid://113699814964045",
    	["smart-home-angle-outline"] = "rbxassetid://128857048209558",
    	["smart-home-bold"] = "rbxassetid://79549201427230",
    	["smart-home-bold-duotone"] = "rbxassetid://131195658079416",
    	["smart-home-broken"] = "rbxassetid://119459497902858",
    	["smart-home-line-duotone"] = "rbxassetid://123911406346359",
    	["smart-home-linear"] = "rbxassetid://73200988578837",
    	["smart-home-outline"] = "rbxassetid://88796968217367",
    	["smart-speaker-2-bold"] = "rbxassetid://131985660895037",
    	["smart-speaker-2-bold-duotone"] = "rbxassetid://114169540186382",
    	["smart-speaker-2-broken"] = "rbxassetid://72192975424611",
    	["smart-speaker-2-line-duotone"] = "rbxassetid://106544738750286",
    	["smart-speaker-2-linear"] = "rbxassetid://112583621614560",
    	["smart-speaker-2-outline"] = "rbxassetid://121766470949261",
    	["smart-speaker-bold"] = "rbxassetid://93700022659723",
    	["smart-speaker-bold-duotone"] = "rbxassetid://116205505075148",
    	["smart-speaker-broken"] = "rbxassetid://90016626104401",
    	["smart-speaker-line-duotone"] = "rbxassetid://138671976429356",
    	["smart-speaker-linear"] = "rbxassetid://105329164386657",
    	["smart-speaker-minimalistic-bold"] = "rbxassetid://115485996029646",
    	["smart-speaker-minimalistic-bold-duotone"] = "rbxassetid://109814527109431",
    	["smart-speaker-minimalistic-broken"] = "rbxassetid://119727633300322",
    	["smart-speaker-minimalistic-line-duotone"] = "rbxassetid://111066662490120",
    	["smart-speaker-minimalistic-linear"] = "rbxassetid://95781681943676",
    	["smart-speaker-minimalistic-outline"] = "rbxassetid://126962747195288",
    	["smart-speaker-outline"] = "rbxassetid://108514391407682",
    	["smart-vacuum-cleaner-2-bold"] = "rbxassetid://85352847346941",
    	["smart-vacuum-cleaner-2-bold-duotone"] = "rbxassetid://136532839215399",
    	["smart-vacuum-cleaner-2-broken"] = "rbxassetid://73800357585404",
    	["smart-vacuum-cleaner-2-line-duotone"] = "rbxassetid://124910203475852",
    	["smart-vacuum-cleaner-2-linear"] = "rbxassetid://81484013689036",
    	["smart-vacuum-cleaner-2-outline"] = "rbxassetid://136016955794569",
    	["smart-vacuum-cleaner-bold"] = "rbxassetid://96756851737943",
    	["smart-vacuum-cleaner-bold-duotone"] = "rbxassetid://94050376572583",
    	["smart-vacuum-cleaner-broken"] = "rbxassetid://128659860101354",
    	["smart-vacuum-cleaner-line-duotone"] = "rbxassetid://119639053744026",
    	["smart-vacuum-cleaner-linear"] = "rbxassetid://70528948017385",
    	["smart-vacuum-cleaner-outline"] = "rbxassetid://137614646480326",
    	["smartphone-2-bold"] = "rbxassetid://122351971813170",
    	["smartphone-2-bold-duotone"] = "rbxassetid://126088599554328",
    	["smartphone-2-broken"] = "rbxassetid://124622620493603",
    	["smartphone-2-line-duotone"] = "rbxassetid://113732163921426",
    	["smartphone-2-linear"] = "rbxassetid://129297312512934",
    	["smartphone-2-outline"] = "rbxassetid://101798211152960",
    	["smartphone-bold"] = "rbxassetid://79789057878832",
    	["smartphone-bold-duotone"] = "rbxassetid://136405946475492",
    	["smartphone-broken"] = "rbxassetid://78444376954820",
    	["smartphone-line-duotone"] = "rbxassetid://106731278457670",
    	["smartphone-linear"] = "rbxassetid://99719671968910",
    	["smartphone-outline"] = "rbxassetid://137199734248758",
    	["smartphone-rotate-2-bold"] = "rbxassetid://134941817910385",
    	["smartphone-rotate-2-bold-duotone"] = "rbxassetid://108123548440836",
    	["smartphone-rotate-2-broken"] = "rbxassetid://81055040819313",
    	["smartphone-rotate-2-line-duotone"] = "rbxassetid://100687645354543",
    	["smartphone-rotate-2-linear"] = "rbxassetid://131682774399165",
    	["smartphone-rotate-2-outline"] = "rbxassetid://109421086001817",
    	["smartphone-rotate-angle-bold"] = "rbxassetid://108124568463208",
    	["smartphone-rotate-angle-bold-duotone"] = "rbxassetid://84263724663018",
    	["smartphone-rotate-angle-broken"] = "rbxassetid://114137459850343",
    	["smartphone-rotate-angle-line-duotone"] = "rbxassetid://116200099337774",
    	["smartphone-rotate-angle-linear"] = "rbxassetid://96558895130596",
    	["smartphone-rotate-angle-outline"] = "rbxassetid://110700061304825",
    	["smartphone-rotate-orientation-bold"] = "rbxassetid://77000218150348",
    	["smartphone-rotate-orientation-bold-duotone"] = "rbxassetid://123918267213954",
    	["smartphone-rotate-orientation-broken"] = "rbxassetid://74158571488055",
    	["smartphone-rotate-orientation-line-duotone"] = "rbxassetid://100368920961763",
    	["smartphone-rotate-orientation-linear"] = "rbxassetid://82352037944384",
    	["smartphone-rotate-orientation-outline"] = "rbxassetid://102297114805027",
    	["smartphone-update-bold"] = "rbxassetid://96587695327433",
    	["smartphone-update-bold-duotone"] = "rbxassetid://98534421571061",
    	["smartphone-update-broken"] = "rbxassetid://121735689543329",
    	["smartphone-update-line-duotone"] = "rbxassetid://85030155606196",
    	["smartphone-update-linear"] = "rbxassetid://134261128328624",
    	["smartphone-update-outline"] = "rbxassetid://133437300819362",
    	["smartphone-vibration-bold"] = "rbxassetid://132347852148602",
    	["smartphone-vibration-bold-duotone"] = "rbxassetid://138482642321180",
    	["smartphone-vibration-broken"] = "rbxassetid://121399237211654",
    	["smartphone-vibration-line-duotone"] = "rbxassetid://133270221644863",
    	["smartphone-vibration-linear"] = "rbxassetid://128029592793471",
    	["smartphone-vibration-outline"] = "rbxassetid://139161266545005",
    	["smile-circle-bold"] = "rbxassetid://138760841166710",
    	["smile-circle-bold-duotone"] = "rbxassetid://125324892994382",
    	["smile-circle-broken"] = "rbxassetid://132349001097711",
    	["smile-circle-line-duotone"] = "rbxassetid://105174630897150",
    	["smile-circle-linear"] = "rbxassetid://88029338148460",
    	["smile-circle-outline"] = "rbxassetid://90500645912628",
    	["smile-square-bold"] = "rbxassetid://137865571533918",
    	["smile-square-bold-duotone"] = "rbxassetid://129815026838980",
    	["smile-square-broken"] = "rbxassetid://111350452397210",
    	["smile-square-line-duotone"] = "rbxassetid://71244170349500",
    	["smile-square-linear"] = "rbxassetid://114296277629096",
    	["smile-square-outline"] = "rbxassetid://79141302613288",
    	["snowflake-bold"] = "rbxassetid://108962750323036",
    	["snowflake-bold-duotone"] = "rbxassetid://116712508632374",
    	["snowflake-broken"] = "rbxassetid://91995233359094",
    	["snowflake-line-duotone"] = "rbxassetid://82596491678859",
    	["snowflake-linear"] = "rbxassetid://73566351284636",
    	["snowflake-outline"] = "rbxassetid://97678453829829",
    	["socket-bold"] = "rbxassetid://91359635834056",
    	["socket-bold-duotone"] = "rbxassetid://123229537764393",
    	["socket-broken"] = "rbxassetid://97495475791920",
    	["socket-line-duotone"] = "rbxassetid://91097645132198",
    	["socket-linear"] = "rbxassetid://85433192337354",
    	["socket-outline"] = "rbxassetid://129547413143282",
    	["sofa-2-bold"] = "rbxassetid://93906279739092",
    	["sofa-2-bold-duotone"] = "rbxassetid://99329427999568",
    	["sofa-2-broken"] = "rbxassetid://81129039511821",
    	["sofa-2-line-duotone"] = "rbxassetid://136213151673717",
    	["sofa-2-linear"] = "rbxassetid://109178423493061",
    	["sofa-2-outline"] = "rbxassetid://115386884900339",
    	["sofa-3-bold"] = "rbxassetid://132196771477458",
    	["sofa-3-bold-duotone"] = "rbxassetid://70542533851873",
    	["sofa-3-broken"] = "rbxassetid://87127750557454",
    	["sofa-3-line-duotone"] = "rbxassetid://89609649106665",
    	["sofa-3-linear"] = "rbxassetid://75464727037106",
    	["sofa-3-outline"] = "rbxassetid://123840718139495",
    	["sofa-bold"] = "rbxassetid://140144996639548",
    	["sofa-bold-duotone"] = "rbxassetid://137719009965215",
    	["sofa-broken"] = "rbxassetid://77720030521534",
    	["sofa-line-duotone"] = "rbxassetid://106295186162141",
    	["sofa-linear"] = "rbxassetid://115038879496139",
    	["sofa-outline"] = "rbxassetid://96255347088359",
    	["sort-bold"] = "rbxassetid://98667743186414",
    	["sort-bold-duotone"] = "rbxassetid://123827612212044",
    	["sort-broken"] = "rbxassetid://111598708656710",
    	["sort-by-alphabet-bold"] = "rbxassetid://70732409950355",
    	["sort-by-alphabet-bold-duotone"] = "rbxassetid://90999991136137",
    	["sort-by-alphabet-broken"] = "rbxassetid://111872561565724",
    	["sort-by-alphabet-line-duotone"] = "rbxassetid://90939827029391",
    	["sort-by-alphabet-linear"] = "rbxassetid://135793863788790",
    	["sort-by-alphabet-outline"] = "rbxassetid://105983251793896",
    	["sort-by-time-bold"] = "rbxassetid://124205311042948",
    	["sort-by-time-bold-duotone"] = "rbxassetid://95198980404322",
    	["sort-by-time-broken"] = "rbxassetid://89011363323399",
    	["sort-by-time-line-duotone"] = "rbxassetid://82199317014201",
    	["sort-by-time-linear"] = "rbxassetid://133283088305194",
    	["sort-by-time-outline"] = "rbxassetid://124621004349683",
    	["sort-from-bottom-to-top-bold"] = "rbxassetid://89111820626938",
    	["sort-from-bottom-to-top-bold-duotone"] = "rbxassetid://120859962940977",
    	["sort-from-bottom-to-top-broken"] = "rbxassetid://108370725961296",
    	["sort-from-bottom-to-top-line-duotone"] = "rbxassetid://112289661962076",
    	["sort-from-bottom-to-top-linear"] = "rbxassetid://114647372630127",
    	["sort-from-bottom-to-top-outline"] = "rbxassetid://139233952643252",
    	["sort-from-top-to-bottom-bold"] = "rbxassetid://95032665651269",
    	["sort-from-top-to-bottom-bold-duotone"] = "rbxassetid://91230921397068",
    	["sort-from-top-to-bottom-broken"] = "rbxassetid://108609312862461",
    	["sort-from-top-to-bottom-line-duotone"] = "rbxassetid://89353697479771",
    	["sort-from-top-to-bottom-linear"] = "rbxassetid://127245682240344",
    	["sort-from-top-to-bottom-outline"] = "rbxassetid://72218972557970",
    	["sort-horizontal-bold"] = "rbxassetid://82355230930420",
    	["sort-horizontal-bold-duotone"] = "rbxassetid://92766789303077",
    	["sort-horizontal-broken"] = "rbxassetid://103966167539848",
    	["sort-horizontal-line-duotone"] = "rbxassetid://79758751316664",
    	["sort-horizontal-linear"] = "rbxassetid://72298504240076",
    	["sort-horizontal-outline"] = "rbxassetid://123576378061737",
    	["sort-line-duotone"] = "rbxassetid://114860820496918",
    	["sort-linear"] = "rbxassetid://94036484750317",
    	["sort-outline"] = "rbxassetid://140068364527081",
    	["sort-vertical-bold"] = "rbxassetid://121618478093853",
    	["sort-vertical-bold-duotone"] = "rbxassetid://138487894034650",
    	["sort-vertical-broken"] = "rbxassetid://78725593577263",
    	["sort-vertical-line-duotone"] = "rbxassetid://94823956513959",
    	["sort-vertical-linear"] = "rbxassetid://123859557004166",
    	["sort-vertical-outline"] = "rbxassetid://97255823903401",
    	["soundwave-bold"] = "rbxassetid://128596073923474",
    	["soundwave-bold-duotone"] = "rbxassetid://125785567273022",
    	["soundwave-broken"] = "rbxassetid://90685524272117",
    	["soundwave-circle-bold"] = "rbxassetid://90732151124063",
    	["soundwave-circle-bold-duotone"] = "rbxassetid://135966407228783",
    	["soundwave-circle-broken"] = "rbxassetid://112697085931869",
    	["soundwave-circle-line-duotone"] = "rbxassetid://106609840340541",
    	["soundwave-circle-linear"] = "rbxassetid://82669179148131",
    	["soundwave-circle-outline"] = "rbxassetid://85435918519141",
    	["soundwave-line-duotone"] = "rbxassetid://106621656836689",
    	["soundwave-linear"] = "rbxassetid://90682642088283",
    	["soundwave-outline"] = "rbxassetid://135030467683976",
    	["soundwave-square-bold"] = "rbxassetid://72531353857477",
    	["soundwave-square-bold-duotone"] = "rbxassetid://114872127336988",
    	["soundwave-square-broken"] = "rbxassetid://80260120095964",
    	["soundwave-square-line-duotone"] = "rbxassetid://86898788728162",
    	["soundwave-square-linear"] = "rbxassetid://100812113122066",
    	["soundwave-square-outline"] = "rbxassetid://117138472922455",
    	["speaker-bold"] = "rbxassetid://108547564852538",
    	["speaker-bold-duotone"] = "rbxassetid://100932978353505",
    	["speaker-broken"] = "rbxassetid://137297251865544",
    	["speaker-line-duotone"] = "rbxassetid://106114358748259",
    	["speaker-linear"] = "rbxassetid://139789304478997",
    	["speaker-minimalistic-bold"] = "rbxassetid://80844466691420",
    	["speaker-minimalistic-bold-duotone"] = "rbxassetid://88396077899275",
    	["speaker-minimalistic-broken"] = "rbxassetid://127285588044266",
    	["speaker-minimalistic-line-duotone"] = "rbxassetid://128221195103487",
    	["speaker-minimalistic-linear"] = "rbxassetid://83105997922875",
    	["speaker-minimalistic-outline"] = "rbxassetid://129030167840478",
    	["speaker-outline"] = "rbxassetid://82482285945062",
    	["special-effects-bold"] = "rbxassetid://119734418129837",
    	["special-effects-bold-duotone"] = "rbxassetid://98597093661384",
    	["special-effects-broken"] = "rbxassetid://129670874670110",
    	["special-effects-line-duotone"] = "rbxassetid://118185498815455",
    	["special-effects-linear"] = "rbxassetid://89634167389607",
    	["special-effects-outline"] = "rbxassetid://117805158593225",
    	["spedometer-low-bold"] = "rbxassetid://102193215915372",
    	["spedometer-low-linear"] = "rbxassetid://118776643998694",
    	["spedometer-max-bold"] = "rbxassetid://97368814260855",
    	["spedometer-max-linear"] = "rbxassetid://91814839145243",
    	["spedometer-middle-bold"] = "rbxassetid://71225968751991",
    	["spedometer-middle-linear"] = "rbxassetid://70758110827729",
    	["square-academic-cap-2-bold"] = "rbxassetid://126384010038084",
    	["square-academic-cap-2-bold-duotone"] = "rbxassetid://117658375163831",
    	["square-academic-cap-2-broken"] = "rbxassetid://95685947083532",
    	["square-academic-cap-2-line-duotone"] = "rbxassetid://106300012288782",
    	["square-academic-cap-2-linear"] = "rbxassetid://113455705631247",
    	["square-academic-cap-2-outline"] = "rbxassetid://105860886146580",
    	["square-academic-cap-bold"] = "rbxassetid://117787825404757",
    	["square-academic-cap-bold-duotone"] = "rbxassetid://130317975963200",
    	["square-academic-cap-broken"] = "rbxassetid://100552094337646",
    	["square-academic-cap-line-duotone"] = "rbxassetid://75260701900583",
    	["square-academic-cap-linear"] = "rbxassetid://118901094838169",
    	["square-academic-cap-outline"] = "rbxassetid://132220023802807",
    	["square-alt-arrow-down-bold"] = "rbxassetid://134099958781743",
    	["square-alt-arrow-down-bold-duotone"] = "rbxassetid://118048911797652",
    	["square-alt-arrow-down-broken"] = "rbxassetid://120372473599577",
    	["square-alt-arrow-down-line-duotone"] = "rbxassetid://85122255946479",
    	["square-alt-arrow-down-linear"] = "rbxassetid://81370578935511",
    	["square-alt-arrow-down-outline"] = "rbxassetid://72221950079121",
    	["square-alt-arrow-left-bold"] = "rbxassetid://79075944494583",
    	["square-alt-arrow-left-bold-duotone"] = "rbxassetid://80037661519198",
    	["square-alt-arrow-left-broken"] = "rbxassetid://116581462205501",
    	["square-alt-arrow-left-line-duotone"] = "rbxassetid://105392797551987",
    	["square-alt-arrow-left-linear"] = "rbxassetid://76127482756776",
    	["square-alt-arrow-left-outline"] = "rbxassetid://134986828889192",
    	["square-alt-arrow-right-bold"] = "rbxassetid://100823625938458",
    	["square-alt-arrow-right-bold-duotone"] = "rbxassetid://107313795198377",
    	["square-alt-arrow-right-broken"] = "rbxassetid://122079740241313",
    	["square-alt-arrow-right-line-duotone"] = "rbxassetid://79968280026930",
    	["square-alt-arrow-right-linear"] = "rbxassetid://85628002176987",
    	["square-alt-arrow-right-outline"] = "rbxassetid://75244297049856",
    	["square-alt-arrow-up-bold"] = "rbxassetid://79685754994513",
    	["square-alt-arrow-up-bold-duotone"] = "rbxassetid://104446521502804",
    	["square-alt-arrow-up-broken"] = "rbxassetid://117299509856332",
    	["square-alt-arrow-up-line-duotone"] = "rbxassetid://138392336964280",
    	["square-alt-arrow-up-linear"] = "rbxassetid://101339698337456",
    	["square-alt-arrow-up-outline"] = "rbxassetid://73057262115129",
    	["square-arrow-down-bold"] = "rbxassetid://97545824153313",
    	["square-arrow-down-bold-duotone"] = "rbxassetid://118877621261859",
    	["square-arrow-down-broken"] = "rbxassetid://139288674683137",
    	["square-arrow-down-line-duotone"] = "rbxassetid://71418490770984",
    	["square-arrow-down-linear"] = "rbxassetid://87251797261901",
    	["square-arrow-down-outline"] = "rbxassetid://77426712044213",
    	["square-arrow-left-bold"] = "rbxassetid://129305494230971",
    	["square-arrow-left-bold-duotone"] = "rbxassetid://124275697552429",
    	["square-arrow-left-broken"] = "rbxassetid://111559592754835",
    	["square-arrow-left-down-bold"] = "rbxassetid://119608491906826",
    	["square-arrow-left-down-bold-duotone"] = "rbxassetid://128619569907809",
    	["square-arrow-left-down-broken"] = "rbxassetid://131876203975904",
    	["square-arrow-left-down-line-duotone"] = "rbxassetid://139859412701249",
    	["square-arrow-left-down-linear"] = "rbxassetid://122642599666264",
    	["square-arrow-left-down-outline"] = "rbxassetid://138689942428333",
    	["square-arrow-left-line-duotone"] = "rbxassetid://126785942840775",
    	["square-arrow-left-linear"] = "rbxassetid://75825032630075",
    	["square-arrow-left-outline"] = "rbxassetid://127542986993290",
    	["square-arrow-left-up-bold"] = "rbxassetid://85225135130488",
    	["square-arrow-left-up-bold-duotone"] = "rbxassetid://91784200630636",
    	["square-arrow-left-up-broken"] = "rbxassetid://101004824365816",
    	["square-arrow-left-up-line-duotone"] = "rbxassetid://114448543500276",
    	["square-arrow-left-up-linear"] = "rbxassetid://126053830048764",
    	["square-arrow-left-up-outline"] = "rbxassetid://107556180543637",
    	["square-arrow-right-bold"] = "rbxassetid://131581955873172",
    	["square-arrow-right-bold-duotone"] = "rbxassetid://94313504791463",
    	["square-arrow-right-broken"] = "rbxassetid://88265938083306",
    	["square-arrow-right-down-bold"] = "rbxassetid://118212170630211",
    	["square-arrow-right-down-bold-duotone"] = "rbxassetid://107617426969000",
    	["square-arrow-right-down-broken"] = "rbxassetid://77766036881421",
    	["square-arrow-right-down-line-duotone"] = "rbxassetid://123662353179603",
    	["square-arrow-right-down-linear"] = "rbxassetid://130300254020832",
    	["square-arrow-right-down-outline"] = "rbxassetid://80324346357768",
    	["square-arrow-right-line-duotone"] = "rbxassetid://125356972519377",
    	["square-arrow-right-linear"] = "rbxassetid://132058280355574",
    	["square-arrow-right-outline"] = "rbxassetid://81080956528975",
    	["square-arrow-right-up-bold"] = "rbxassetid://108552252615996",
    	["square-arrow-right-up-bold-duotone"] = "rbxassetid://135140151174674",
    	["square-arrow-right-up-broken"] = "rbxassetid://87880822260629",
    	["square-arrow-right-up-line-duotone"] = "rbxassetid://74339388858284",
    	["square-arrow-right-up-linear"] = "rbxassetid://136525211546614",
    	["square-arrow-right-up-outline"] = "rbxassetid://84100599138994",
    	["square-arrow-up-bold"] = "rbxassetid://72749816689089",
    	["square-arrow-up-bold-duotone"] = "rbxassetid://125020463161051",
    	["square-arrow-up-broken"] = "rbxassetid://101256890445141",
    	["square-arrow-up-line-duotone"] = "rbxassetid://79174270321792",
    	["square-arrow-up-linear"] = "rbxassetid://77237794881604",
    	["square-arrow-up-outline"] = "rbxassetid://83699594540977",
    	["square-bottom-down-bold"] = "rbxassetid://114577436375936",
    	["square-bottom-down-bold-duotone"] = "rbxassetid://113149763601329",
    	["square-bottom-down-broken"] = "rbxassetid://111337308779800",
    	["square-bottom-down-line-duotone"] = "rbxassetid://120072340635940",
    	["square-bottom-down-linear"] = "rbxassetid://81941049405444",
    	["square-bottom-down-outline"] = "rbxassetid://105309233142043",
    	["square-bottom-up-bold"] = "rbxassetid://138137323744590",
    	["square-bottom-up-bold-duotone"] = "rbxassetid://79074977525120",
    	["square-bottom-up-broken"] = "rbxassetid://124511959168122",
    	["square-bottom-up-line-duotone"] = "rbxassetid://88739358309462",
    	["square-bottom-up-linear"] = "rbxassetid://93224842372547",
    	["square-bottom-up-outline"] = "rbxassetid://105992878457092",
    	["square-double-alt-arrow-down-bold"] = "rbxassetid://138017005754487",
    	["square-double-alt-arrow-down-bold-duotone"] = "rbxassetid://90590032393059",
    	["square-double-alt-arrow-down-broken"] = "rbxassetid://102135130177723",
    	["square-double-alt-arrow-down-line-duotone"] = "rbxassetid://113151653928417",
    	["square-double-alt-arrow-down-linear"] = "rbxassetid://135585791910016",
    	["square-double-alt-arrow-down-outline"] = "rbxassetid://70821277732914",
    	["square-double-alt-arrow-left-bold"] = "rbxassetid://94290333683906",
    	["square-double-alt-arrow-left-bold-duotone"] = "rbxassetid://131397363398008",
    	["square-double-alt-arrow-left-broken"] = "rbxassetid://93664819671396",
    	["square-double-alt-arrow-left-line-duotone"] = "rbxassetid://109740930759857",
    	["square-double-alt-arrow-left-linear"] = "rbxassetid://97495584638399",
    	["square-double-alt-arrow-left-outline"] = "rbxassetid://77822117951384",
    	["square-double-alt-arrow-right-bold"] = "rbxassetid://132384633231565",
    	["square-double-alt-arrow-right-bold-duotone"] = "rbxassetid://80160699828893",
    	["square-double-alt-arrow-right-broken"] = "rbxassetid://106092690380258",
    	["square-double-alt-arrow-right-line-duotone"] = "rbxassetid://86056845132838",
    	["square-double-alt-arrow-right-linear"] = "rbxassetid://84744193240664",
    	["square-double-alt-arrow-right-outline"] = "rbxassetid://111335435206277",
    	["square-double-alt-arrow-up-bold"] = "rbxassetid://138517487956716",
    	["square-double-alt-arrow-up-bold-duotone"] = "rbxassetid://93461802980869",
    	["square-double-alt-arrow-up-broken"] = "rbxassetid://135473764719870",
    	["square-double-alt-arrow-up-line-duotone"] = "rbxassetid://119268324434181",
    	["square-double-alt-arrow-up-linear"] = "rbxassetid://131965988437152",
    	["square-double-alt-arrow-up-outline"] = "rbxassetid://111763942056266",
    	["square-forward-bold"] = "rbxassetid://122359618460085",
    	["square-forward-bold-duotone"] = "rbxassetid://130282449646650",
    	["square-forward-broken"] = "rbxassetid://105885357546356",
    	["square-forward-line-duotone"] = "rbxassetid://123205454904779",
    	["square-forward-linear"] = "rbxassetid://81054015401445",
    	["square-forward-outline"] = "rbxassetid://135880101706033",
    	["square-share-line-bold"] = "rbxassetid://111128598280002",
    	["square-share-line-bold-duotone"] = "rbxassetid://95159207504955",
    	["square-share-line-broken"] = "rbxassetid://118769622126122",
    	["square-share-line-line-duotone"] = "rbxassetid://84967830948740",
    	["square-share-line-linear"] = "rbxassetid://131270864336880",
    	["square-share-line-outline"] = "rbxassetid://126850835130540",
    	["square-sort-horizontal-bold"] = "rbxassetid://78126092609858",
    	["square-sort-horizontal-bold-duotone"] = "rbxassetid://86239906900408",
    	["square-sort-horizontal-broken"] = "rbxassetid://101620265187055",
    	["square-sort-horizontal-line-duotone"] = "rbxassetid://80178613943250",
    	["square-sort-horizontal-linear"] = "rbxassetid://92922861737929",
    	["square-sort-horizontal-outline"] = "rbxassetid://108268353649683",
    	["square-sort-vertical-bold"] = "rbxassetid://138019096822861",
    	["square-sort-vertical-bold-duotone"] = "rbxassetid://140410873048048",
    	["square-sort-vertical-broken"] = "rbxassetid://100807406009800",
    	["square-sort-vertical-line-duotone"] = "rbxassetid://121903619706017",
    	["square-sort-vertical-linear"] = "rbxassetid://104566906815289",
    	["square-sort-vertical-outline"] = "rbxassetid://139305040857241",
    	["square-top-down-bold"] = "rbxassetid://105540501021737",
    	["square-top-down-bold-duotone"] = "rbxassetid://108402521263998",
    	["square-top-down-broken"] = "rbxassetid://105028597214261",
    	["square-top-down-line-duotone"] = "rbxassetid://124399511355912",
    	["square-top-down-linear"] = "rbxassetid://95025806979587",
    	["square-top-down-outline"] = "rbxassetid://96773424785308",
    	["square-top-up-bold"] = "rbxassetid://130144243002536",
    	["square-top-up-bold-duotone"] = "rbxassetid://117941435241488",
    	["square-top-up-broken"] = "rbxassetid://138771749124087",
    	["square-top-up-line-duotone"] = "rbxassetid://128382142631625",
    	["square-top-up-linear"] = "rbxassetid://135502498269405",
    	["square-top-up-outline"] = "rbxassetid://128047893590653",
    	["square-transfer-horizontal-bold"] = "rbxassetid://83149737584008",
    	["square-transfer-horizontal-bold-duotone"] = "rbxassetid://115918599773492",
    	["square-transfer-horizontal-broken"] = "rbxassetid://123498907792932",
    	["square-transfer-horizontal-line-duotone"] = "rbxassetid://131494551119951",
    	["square-transfer-horizontal-linear"] = "rbxassetid://72285841823959",
    	["square-transfer-horizontal-outline"] = "rbxassetid://119446449426060",
    	["square-transfer-vertical-bold"] = "rbxassetid://123809574427198",
    	["square-transfer-vertical-bold-duotone"] = "rbxassetid://124275856735352",
    	["square-transfer-vertical-broken"] = "rbxassetid://127176384407424",
    	["square-transfer-vertical-line-duotone"] = "rbxassetid://135580981301342",
    	["square-transfer-vertical-linear"] = "rbxassetid://116025454176915",
    	["square-transfer-vertical-outline"] = "rbxassetid://100465020357326",
    	["ssd-round-bold"] = "rbxassetid://90202092250236",
    	["ssd-round-bold-duotone"] = "rbxassetid://81688570874305",
    	["ssd-round-broken"] = "rbxassetid://119916823138130",
    	["ssd-round-line-duotone"] = "rbxassetid://117867797739449",
    	["ssd-round-linear"] = "rbxassetid://107774253907496",
    	["ssd-round-outline"] = "rbxassetid://96528585690915",
    	["ssd-square-bold"] = "rbxassetid://110794977715079",
    	["ssd-square-bold-duotone"] = "rbxassetid://84807296465416",
    	["ssd-square-broken"] = "rbxassetid://140634335255698",
    	["ssd-square-line-duotone"] = "rbxassetid://113417222175094",
    	["ssd-square-linear"] = "rbxassetid://105220365569872",
    	["ssd-square-outline"] = "rbxassetid://95680587683606",
    	["star-angle-bold"] = "rbxassetid://138967642353360",
    	["star-angle-bold-duotone"] = "rbxassetid://112715541806580",
    	["star-angle-broken"] = "rbxassetid://72436088852710",
    	["star-angle-line-duotone"] = "rbxassetid://71204023476511",
    	["star-angle-linear"] = "rbxassetid://96384309888547",
    	["star-angle-outline"] = "rbxassetid://113253668347809",
    	["star-bold"] = "rbxassetid://98157183283283",
    	["star-bold-1"] = "rbxassetid://135772253309337",
    	["star-bold-duotone"] = "rbxassetid://137790055478286",
    	["star-bold-duotone-1"] = "rbxassetid://125460350964306",
    	["star-broken"] = "rbxassetid://93791899073943",
    	["star-broken-1"] = "rbxassetid://88956131437693",
    	["star-circle-bold"] = "rbxassetid://134963294985291",
    	["star-circle-bold-duotone"] = "rbxassetid://99050061164235",
    	["star-circle-broken"] = "rbxassetid://108164924796460",
    	["star-circle-line-duotone"] = "rbxassetid://85132602746623",
    	["star-circle-linear"] = "rbxassetid://133400311514605",
    	["star-circle-outline"] = "rbxassetid://130518516944262",
    	["star-fall-2-bold"] = "rbxassetid://99860835278060",
    	["star-fall-2-bold-duotone"] = "rbxassetid://128932382938120",
    	["star-fall-2-broken"] = "rbxassetid://136148615681415",
    	["star-fall-2-line-duotone"] = "rbxassetid://130393612294260",
    	["star-fall-2-linear"] = "rbxassetid://101802668220447",
    	["star-fall-2-outline"] = "rbxassetid://136240158677404",
    	["star-fall-bold"] = "rbxassetid://88380485367823",
    	["star-fall-bold-duotone"] = "rbxassetid://107721323064028",
    	["star-fall-broken"] = "rbxassetid://90615681543043",
    	["star-fall-line-duotone"] = "rbxassetid://77604616027494",
    	["star-fall-linear"] = "rbxassetid://103909641376809",
    	["star-fall-minimalistic-2-bold"] = "rbxassetid://114012243611304",
    	["star-fall-minimalistic-2-bold-duotone"] = "rbxassetid://72844652846341",
    	["star-fall-minimalistic-2-broken"] = "rbxassetid://110982698015307",
    	["star-fall-minimalistic-2-line-duotone"] = "rbxassetid://134652916882473",
    	["star-fall-minimalistic-2-linear"] = "rbxassetid://95600227025465",
    	["star-fall-minimalistic-2-outline"] = "rbxassetid://133284925133958",
    	["star-fall-minimalistic-bold"] = "rbxassetid://106537137820080",
    	["star-fall-minimalistic-bold-duotone"] = "rbxassetid://96407263059190",
    	["star-fall-minimalistic-broken"] = "rbxassetid://95008015463672",
    	["star-fall-minimalistic-line-duotone"] = "rbxassetid://81107344951676",
    	["star-fall-minimalistic-linear"] = "rbxassetid://85380399119331",
    	["star-fall-minimalistic-outline"] = "rbxassetid://85073774587285",
    	["star-fall-outline"] = "rbxassetid://137183897119907",
    	["star-line-duotone"] = "rbxassetid://108217758469280",
    	["star-line-duotone-1"] = "rbxassetid://132359225696558",
    	["star-linear"] = "rbxassetid://118843799856401",
    	["star-linear-1"] = "rbxassetid://86806122094499",
    	["star-outline"] = "rbxassetid://106382553310002",
    	["star-outline-1"] = "rbxassetid://80833925573726",
    	["star-rainbow-bold"] = "rbxassetid://86471671471759",
    	["star-rainbow-bold-duotone"] = "rbxassetid://100372006194362",
    	["star-rainbow-broken"] = "rbxassetid://136125301360659",
    	["star-rainbow-line-duotone"] = "rbxassetid://81264122984249",
    	["star-rainbow-linear"] = "rbxassetid://103578090257696",
    	["star-rainbow-outline"] = "rbxassetid://100050629517633",
    	["star-ring-bold"] = "rbxassetid://110424632806655",
    	["star-ring-bold-duotone"] = "rbxassetid://104078727470781",
    	["star-ring-broken"] = "rbxassetid://111525831067312",
    	["star-ring-line-duotone"] = "rbxassetid://81587142112076",
    	["star-ring-linear"] = "rbxassetid://112940093909262",
    	["star-ring-outline"] = "rbxassetid://122294694474850",
    	["star-rings-bold"] = "rbxassetid://104928351789424",
    	["star-rings-bold-duotone"] = "rbxassetid://88089495830209",
    	["star-rings-broken"] = "rbxassetid://93971307884505",
    	["star-rings-line-duotone"] = "rbxassetid://115945398710535",
    	["star-rings-linear"] = "rbxassetid://79175458302095",
    	["star-rings-outline"] = "rbxassetid://85230926709403",
    	["star-shine-bold"] = "rbxassetid://114100614749526",
    	["star-shine-bold-duotone"] = "rbxassetid://128765453231859",
    	["star-shine-broken"] = "rbxassetid://120178579904722",
    	["star-shine-line-duotone"] = "rbxassetid://114025068247131",
    	["star-shine-linear"] = "rbxassetid://126428470636647",
    	["star-shine-outline"] = "rbxassetid://86827401644024",
    	["stars-bold"] = "rbxassetid://117722835180948",
    	["stars-bold-1"] = "rbxassetid://114862301713008",
    	["stars-bold-duotone"] = "rbxassetid://112225312664424",
    	["stars-bold-duotone-1"] = "rbxassetid://84724930162109",
    	["stars-broken"] = "rbxassetid://105453489598810",
    	["stars-broken-1"] = "rbxassetid://93193158495123",
    	["stars-line-bold"] = "rbxassetid://87693855497250",
    	["stars-line-bold-duotone"] = "rbxassetid://133492349867550",
    	["stars-line-broken"] = "rbxassetid://129823494076491",
    	["stars-line-duotone"] = "rbxassetid://95965577498084",
    	["stars-line-duotone-1"] = "rbxassetid://78136986923785",
    	["stars-line-line-duotone"] = "rbxassetid://126983686258347",
    	["stars-line-linear"] = "rbxassetid://126512452546363",
    	["stars-line-outline"] = "rbxassetid://98552484845473",
    	["stars-linear"] = "rbxassetid://121581563324484",
    	["stars-linear-1"] = "rbxassetid://93133762646549",
    	["stars-minimalistic-bold"] = "rbxassetid://73767297526258",
    	["stars-minimalistic-bold-duotone"] = "rbxassetid://73362492704957",
    	["stars-minimalistic-broken"] = "rbxassetid://75497327462119",
    	["stars-minimalistic-line-duotone"] = "rbxassetid://75316542391219",
    	["stars-minimalistic-linear"] = "rbxassetid://84856629330687",
    	["stars-minimalistic-outline"] = "rbxassetid://74374909951346",
    	["stars-outline"] = "rbxassetid://84744215825125",
    	["stars-outline-1"] = "rbxassetid://105362176768370",
    	["station-bold"] = "rbxassetid://93623212489133",
    	["station-bold-duotone"] = "rbxassetid://103486945949300",
    	["station-broken"] = "rbxassetid://84750920872958",
    	["station-line-duotone"] = "rbxassetid://83564143991587",
    	["station-linear"] = "rbxassetid://100480380494862",
    	["station-minimalistic-bold"] = "rbxassetid://128716477787126",
    	["station-minimalistic-bold-duotone"] = "rbxassetid://81265776282642",
    	["station-minimalistic-broken"] = "rbxassetid://139193455867842",
    	["station-minimalistic-line-duotone"] = "rbxassetid://124648777046035",
    	["station-minimalistic-linear"] = "rbxassetid://100682898480506",
    	["station-minimalistic-outline"] = "rbxassetid://117681979917286",
    	["station-outline"] = "rbxassetid://116634562228825",
    	["stethoscope-bold"] = "rbxassetid://76623615784640",
    	["stethoscope-bold-duotone"] = "rbxassetid://76001173638627",
    	["stethoscope-broken"] = "rbxassetid://83119520791972",
    	["stethoscope-line-duotone"] = "rbxassetid://77694301371187",
    	["stethoscope-linear"] = "rbxassetid://76871018378969",
    	["stethoscope-outline"] = "rbxassetid://129493398343419",
    	["sticker-circle-bold"] = "rbxassetid://102702766597629",
    	["sticker-circle-bold-duotone"] = "rbxassetid://126451080768188",
    	["sticker-circle-broken"] = "rbxassetid://138964870129745",
    	["sticker-circle-line-duotone"] = "rbxassetid://138229686449280",
    	["sticker-circle-linear"] = "rbxassetid://92836264233761",
    	["sticker-circle-outline"] = "rbxassetid://105322380332538",
    	["sticker-smile-circle-2-bold"] = "rbxassetid://137842219783384",
    	["sticker-smile-circle-2-bold-duotone"] = "rbxassetid://136345055052018",
    	["sticker-smile-circle-2-broken"] = "rbxassetid://72249395917981",
    	["sticker-smile-circle-2-line-duotone"] = "rbxassetid://133716875028903",
    	["sticker-smile-circle-2-linear"] = "rbxassetid://80176841777447",
    	["sticker-smile-circle-2-outline"] = "rbxassetid://120155302875460",
    	["sticker-smile-circle-bold"] = "rbxassetid://85204383335233",
    	["sticker-smile-circle-bold-duotone"] = "rbxassetid://85506738934079",
    	["sticker-smile-circle-broken"] = "rbxassetid://78107048863258",
    	["sticker-smile-circle-line-duotone"] = "rbxassetid://82349269845287",
    	["sticker-smile-circle-linear"] = "rbxassetid://90184239143770",
    	["sticker-smile-circle-outline"] = "rbxassetid://89903398339693",
    	["sticker-smile-square-bold"] = "rbxassetid://106650929786110",
    	["sticker-smile-square-bold-duotone"] = "rbxassetid://110881981637049",
    	["sticker-smile-square-broken"] = "rbxassetid://77052295078456",
    	["sticker-smile-square-line-duotone"] = "rbxassetid://122652787196729",
    	["sticker-smile-square-linear"] = "rbxassetid://124526913529670",
    	["sticker-smile-square-outline"] = "rbxassetid://109158757623968",
    	["sticker-square-bold"] = "rbxassetid://91592586854875",
    	["sticker-square-bold-duotone"] = "rbxassetid://115636300659093",
    	["sticker-square-broken"] = "rbxassetid://84067842972456",
    	["sticker-square-line-duotone"] = "rbxassetid://86678478733357",
    	["sticker-square-linear"] = "rbxassetid://131298092987741",
    	["sticker-square-outline"] = "rbxassetid://109363569928080",
    	["stop-bold"] = "rbxassetid://81987034482699",
    	["stop-bold-duotone"] = "rbxassetid://78628664332723",
    	["stop-broken"] = "rbxassetid://129749650481404",
    	["stop-circle-bold"] = "rbxassetid://108380991475628",
    	["stop-circle-bold-duotone"] = "rbxassetid://98741966043793",
    	["stop-circle-broken"] = "rbxassetid://90108312955109",
    	["stop-circle-line-duotone"] = "rbxassetid://89528208895889",
    	["stop-circle-linear"] = "rbxassetid://85772714611863",
    	["stop-circle-outline"] = "rbxassetid://128180813650388",
    	["stop-line-duotone"] = "rbxassetid://112085869065843",
    	["stop-linear"] = "rbxassetid://113510191996886",
    	["stop-outline"] = "rbxassetid://107430139036424",
    	["stopwatch-bold"] = "rbxassetid://118896472143182",
    	["stopwatch-bold-duotone"] = "rbxassetid://93458278471389",
    	["stopwatch-broken"] = "rbxassetid://83000565341571",
    	["stopwatch-line-duotone"] = "rbxassetid://106660219264264",
    	["stopwatch-linear"] = "rbxassetid://88516823931308",
    	["stopwatch-outline"] = "rbxassetid://114860899646431",
    	["stopwatch-pause-bold"] = "rbxassetid://87099558672298",
    	["stopwatch-pause-bold-duotone"] = "rbxassetid://88602272505344",
    	["stopwatch-pause-broken"] = "rbxassetid://90141432305963",
    	["stopwatch-pause-line-duotone"] = "rbxassetid://119170702601920",
    	["stopwatch-pause-linear"] = "rbxassetid://106769360652961",
    	["stopwatch-pause-outline"] = "rbxassetid://128219488381444",
    	["stopwatch-play-bold"] = "rbxassetid://97438410366861",
    	["stopwatch-play-bold-duotone"] = "rbxassetid://70781958415618",
    	["stopwatch-play-broken"] = "rbxassetid://120836602185039",
    	["stopwatch-play-line-duotone"] = "rbxassetid://126380796368325",
    	["stopwatch-play-linear"] = "rbxassetid://77985125442827",
    	["stopwatch-play-outline"] = "rbxassetid://78287573520915",
    	["stream-bold"] = "rbxassetid://137050375293417",
    	["stream-bold-duotone"] = "rbxassetid://97490874598857",
    	["stream-broken"] = "rbxassetid://108917185568183",
    	["stream-line-duotone"] = "rbxassetid://93086147765746",
    	["stream-linear"] = "rbxassetid://85724250046334",
    	["stream-outline"] = "rbxassetid://93524762186385",
    	["streets-bold"] = "rbxassetid://73004429749236",
    	["streets-bold-duotone"] = "rbxassetid://128176784608344",
    	["streets-broken"] = "rbxassetid://73577583832138",
    	["streets-line-duotone"] = "rbxassetid://134703775543342",
    	["streets-linear"] = "rbxassetid://118849385533978",
    	["streets-map-point-bold"] = "rbxassetid://103312515400216",
    	["streets-map-point-bold-duotone"] = "rbxassetid://123545216951396",
    	["streets-map-point-broken"] = "rbxassetid://88607663369626",
    	["streets-map-point-line-duotone"] = "rbxassetid://126966352127724",
    	["streets-map-point-linear"] = "rbxassetid://113662086183371",
    	["streets-map-point-outline"] = "rbxassetid://137399467943867",
    	["streets-navigation-bold"] = "rbxassetid://106717116500472",
    	["streets-navigation-bold-duotone"] = "rbxassetid://116437413378993",
    	["streets-navigation-broken"] = "rbxassetid://91462780845333",
    	["streets-navigation-line-duotone"] = "rbxassetid://88751518544072",
    	["streets-navigation-linear"] = "rbxassetid://85187080230242",
    	["streets-navigation-outline"] = "rbxassetid://127004073050665",
    	["streets-outline"] = "rbxassetid://98791443680959",
    	["stretching-bold"] = "rbxassetid://93675711491420",
    	["stretching-bold-duotone"] = "rbxassetid://129400152010176",
    	["stretching-broken"] = "rbxassetid://109774739404725",
    	["stretching-line-duotone"] = "rbxassetid://116580068074021",
    	["stretching-linear"] = "rbxassetid://102507730346334",
    	["stretching-outline"] = "rbxassetid://127202435693863",
    	["stretching-round-bold"] = "rbxassetid://78522785077975",
    	["stretching-round-bold-duotone"] = "rbxassetid://134315332417995",
    	["stretching-round-broken"] = "rbxassetid://134385312195723",
    	["stretching-round-line-duotone"] = "rbxassetid://126836577085843",
    	["stretching-round-linear"] = "rbxassetid://81320770457363",
    	["stretching-round-outline"] = "rbxassetid://135021206118202",
    	["structure-bold"] = "rbxassetid://82592687617983",
    	["structure-bold-duotone"] = "rbxassetid://94322212988917",
    	["structure-broken"] = "rbxassetid://133974405395198",
    	["structure-line-duotone"] = "rbxassetid://77531182694311",
    	["structure-linear"] = "rbxassetid://114723859617084",
    	["structure-outline"] = "rbxassetid://74172634910979",
    	["subtitles-bold"] = "rbxassetid://136386805103196",
    	["subtitles-bold-duotone"] = "rbxassetid://97005570051412",
    	["subtitles-broken"] = "rbxassetid://77518353701394",
    	["subtitles-line-duotone"] = "rbxassetid://72172544373883",
    	["subtitles-linear"] = "rbxassetid://94278275327829",
    	["subtitles-outline"] = "rbxassetid://111289236710795",
    	["suitcase-bold"] = "rbxassetid://104946983294612",
    	["suitcase-bold-duotone"] = "rbxassetid://135911549304061",
    	["suitcase-broken"] = "rbxassetid://86848812377375",
    	["suitcase-line-duotone"] = "rbxassetid://85004201756609",
    	["suitcase-linear"] = "rbxassetid://99953219374401",
    	["suitcase-lines-bold"] = "rbxassetid://124611109739574",
    	["suitcase-lines-bold-duotone"] = "rbxassetid://76194812876510",
    	["suitcase-lines-broken"] = "rbxassetid://124255049556237",
    	["suitcase-lines-line-duotone"] = "rbxassetid://73671730076657",
    	["suitcase-lines-linear"] = "rbxassetid://126870312198829",
    	["suitcase-lines-outline"] = "rbxassetid://115221338369492",
    	["suitcase-outline"] = "rbxassetid://114409865131542",
    	["suitcase-tag-bold"] = "rbxassetid://112174358534580",
    	["suitcase-tag-bold-duotone"] = "rbxassetid://71512830906287",
    	["suitcase-tag-broken"] = "rbxassetid://112613669131475",
    	["suitcase-tag-line-duotone"] = "rbxassetid://116553098504431",
    	["suitcase-tag-linear"] = "rbxassetid://80707388368668",
    	["suitcase-tag-outline"] = "rbxassetid://71969367122461",
    	["sun-2-bold"] = "rbxassetid://91474658549548",
    	["sun-2-bold-duotone"] = "rbxassetid://82159746637355",
    	["sun-2-broken"] = "rbxassetid://75499572914409",
    	["sun-2-line-duotone"] = "rbxassetid://94942365961582",
    	["sun-2-linear"] = "rbxassetid://108009441161605",
    	["sun-2-outline"] = "rbxassetid://132995119468680",
    	["sun-bold"] = "rbxassetid://117590500180033",
    	["sun-bold-duotone"] = "rbxassetid://99623288485097",
    	["sun-broken"] = "rbxassetid://131890327773974",
    	["sun-fog-bold"] = "rbxassetid://87435280817694",
    	["sun-fog-bold-duotone"] = "rbxassetid://89418803502962",
    	["sun-fog-broken"] = "rbxassetid://110423055149828",
    	["sun-fog-line-duotone"] = "rbxassetid://138743405812800",
    	["sun-fog-linear"] = "rbxassetid://79515306266377",
    	["sun-fog-outline"] = "rbxassetid://84472513352957",
    	["sun-line-duotone"] = "rbxassetid://106061646117709",
    	["sun-linear"] = "rbxassetid://126776232857992",
    	["sun-outline"] = "rbxassetid://125870356521626",
    	["sunrise-bold"] = "rbxassetid://75484973989494",
    	["sunrise-bold-duotone"] = "rbxassetid://120437892553881",
    	["sunrise-broken"] = "rbxassetid://107845194361506",
    	["sunrise-line-duotone"] = "rbxassetid://77139369198147",
    	["sunrise-linear"] = "rbxassetid://135696396857067",
    	["sunrise-outline"] = "rbxassetid://95189214580187",
    	["sunset-bold"] = "rbxassetid://71097081264800",
    	["sunset-bold-duotone"] = "rbxassetid://74346923848130",
    	["sunset-broken"] = "rbxassetid://102249777649628",
    	["sunset-line-duotone"] = "rbxassetid://82152795527189",
    	["sunset-linear"] = "rbxassetid://118723067445845",
    	["sunset-outline"] = "rbxassetid://102748087669631",
    	["suspension-bold"] = "rbxassetid://84119842548959",
    	["suspension-bolt-bold"] = "rbxassetid://70970017461409",
    	["suspension-bolt-linear"] = "rbxassetid://97397205750515",
    	["suspension-cross-bold"] = "rbxassetid://116676205332516",
    	["suspension-cross-linear"] = "rbxassetid://86060750505772",
    	["suspension-linear"] = "rbxassetid://81028753196479",
    	["swimming-bold"] = "rbxassetid://86794234647329",
    	["swimming-bold-duotone"] = "rbxassetid://77734256551175",
    	["swimming-broken"] = "rbxassetid://90816248786967",
    	["swimming-line-duotone"] = "rbxassetid://112302144097163",
    	["swimming-linear"] = "rbxassetid://109637248313430",
    	["swimming-outline"] = "rbxassetid://120991017507469",
    	["syringe-bold"] = "rbxassetid://74944836618938",
    	["syringe-bold-duotone"] = "rbxassetid://111842894297254",
    	["syringe-broken"] = "rbxassetid://138939865890634",
    	["syringe-line-duotone"] = "rbxassetid://85229280030273",
    	["syringe-linear"] = "rbxassetid://119853632221567",
    	["syringe-outline"] = "rbxassetid://109834661925207",
    	["t-shirt-bold"] = "rbxassetid://89083139578707",
    	["t-shirt-bold-duotone"] = "rbxassetid://87795200482465",
    	["t-shirt-broken"] = "rbxassetid://105256351290313",
    	["t-shirt-line-duotone"] = "rbxassetid://101393660537532",
    	["t-shirt-linear"] = "rbxassetid://87664087333883",
    	["t-shirt-outline"] = "rbxassetid://89133943445531",
    	["tablet-bold"] = "rbxassetid://72450303882114",
    	["tablet-bold-duotone"] = "rbxassetid://131048044750974",
    	["tablet-broken"] = "rbxassetid://114240524144157",
    	["tablet-line-duotone"] = "rbxassetid://125357596287207",
    	["tablet-linear"] = "rbxassetid://129382684975012",
    	["tablet-outline"] = "rbxassetid://107603480249480",
    	["tag-bold"] = "rbxassetid://106092784438331",
    	["tag-bold-duotone"] = "rbxassetid://85763900232550",
    	["tag-broken"] = "rbxassetid://109077854936165",
    	["tag-horizontal-bold"] = "rbxassetid://137208495811844",
    	["tag-horizontal-bold-duotone"] = "rbxassetid://102196443967195",
    	["tag-horizontal-broken"] = "rbxassetid://74239619140358",
    	["tag-horizontal-line-duotone"] = "rbxassetid://134306672616491",
    	["tag-horizontal-linear"] = "rbxassetid://137763449386330",
    	["tag-horizontal-outline"] = "rbxassetid://124749236219678",
    	["tag-line-duotone"] = "rbxassetid://97858379175219",
    	["tag-linear"] = "rbxassetid://89975969223393",
    	["tag-outline"] = "rbxassetid://96476821964729",
    	["tag-price-bold"] = "rbxassetid://139330352014349",
    	["tag-price-bold-duotone"] = "rbxassetid://91404435675580",
    	["tag-price-broken"] = "rbxassetid://101275933052590",
    	["tag-price-line-duotone"] = "rbxassetid://132191007124131",
    	["tag-price-linear"] = "rbxassetid://89254772232273",
    	["tag-price-outline"] = "rbxassetid://86254374450651",
    	["target-bold"] = "rbxassetid://71083101429210",
    	["target-bold-duotone"] = "rbxassetid://87839091594999",
    	["target-broken"] = "rbxassetid://77644973887563",
    	["target-line-duotone"] = "rbxassetid://120879117377907",
    	["target-linear"] = "rbxassetid://71617062045171",
    	["target-outline"] = "rbxassetid://125724633471934",
    	["tea-cup-bold"] = "rbxassetid://81269020320152",
    	["tea-cup-bold-duotone"] = "rbxassetid://107814645965631",
    	["tea-cup-broken"] = "rbxassetid://92502688056865",
    	["tea-cup-line-duotone"] = "rbxassetid://105039821259927",
    	["tea-cup-linear"] = "rbxassetid://91623566235256",
    	["tea-cup-outline"] = "rbxassetid://104568328201529",
    	["telescope-bold"] = "rbxassetid://112666909064777",
    	["telescope-bold-duotone"] = "rbxassetid://102787067971625",
    	["telescope-broken"] = "rbxassetid://81751432637721",
    	["telescope-line-duotone"] = "rbxassetid://118368031296916",
    	["telescope-linear"] = "rbxassetid://132762925496815",
    	["telescope-outline"] = "rbxassetid://90213142476256",
    	["temperature-bold"] = "rbxassetid://112175927992686",
    	["temperature-bold-duotone"] = "rbxassetid://73845100070255",
    	["temperature-broken"] = "rbxassetid://137442038687123",
    	["temperature-line-duotone"] = "rbxassetid://125692060126028",
    	["temperature-linear"] = "rbxassetid://106218554127779",
    	["temperature-outline"] = "rbxassetid://110755048451110",
    	["tennis-2-bold"] = "rbxassetid://132685927629405",
    	["tennis-2-bold-duotone"] = "rbxassetid://128138381692456",
    	["tennis-2-broken"] = "rbxassetid://137891995950532",
    	["tennis-2-line-duotone"] = "rbxassetid://84614072915112",
    	["tennis-2-linear"] = "rbxassetid://113479214651867",
    	["tennis-2-outline"] = "rbxassetid://140045075885709",
    	["tennis-bold"] = "rbxassetid://100807633923595",
    	["tennis-bold-duotone"] = "rbxassetid://97675190996472",
    	["tennis-broken"] = "rbxassetid://83893175424881",
    	["tennis-line-duotone"] = "rbxassetid://73132065239330",
    	["tennis-linear"] = "rbxassetid://90584049987086",
    	["tennis-outline"] = "rbxassetid://126144764839464",
    	["test-tube-bold"] = "rbxassetid://111440711942875",
    	["test-tube-bold-duotone"] = "rbxassetid://93442476414465",
    	["test-tube-broken"] = "rbxassetid://106970760547052",
    	["test-tube-line-duotone"] = "rbxassetid://87089961405547",
    	["test-tube-linear"] = "rbxassetid://102941800275901",
    	["test-tube-minimalistic-bold"] = "rbxassetid://70855878185407",
    	["test-tube-minimalistic-bold-duotone"] = "rbxassetid://98684868072859",
    	["test-tube-minimalistic-broken"] = "rbxassetid://83223358149459",
    	["test-tube-minimalistic-line-duotone"] = "rbxassetid://135471686166371",
    	["test-tube-minimalistic-linear"] = "rbxassetid://103441261473541",
    	["test-tube-minimalistic-outline"] = "rbxassetid://85312401867548",
    	["test-tube-outline"] = "rbxassetid://74800359411552",
    	["text-bold"] = "rbxassetid://134628365459549",
    	["text-bold-bold"] = "rbxassetid://139882292900892",
    	["text-bold-bold-duotone"] = "rbxassetid://89661772897417",
    	["text-bold-broken"] = "rbxassetid://126639074682915",
    	["text-bold-circle-bold"] = "rbxassetid://79290285574949",
    	["text-bold-circle-bold-duotone"] = "rbxassetid://107877928064762",
    	["text-bold-circle-broken"] = "rbxassetid://119018692033332",
    	["text-bold-circle-line-duotone"] = "rbxassetid://95925805816945",
    	["text-bold-circle-linear"] = "rbxassetid://108592205231281",
    	["text-bold-circle-outline"] = "rbxassetid://119380503974917",
    	["text-bold-duotone"] = "rbxassetid://73031791047534",
    	["text-bold-line-duotone"] = "rbxassetid://108952652179752",
    	["text-bold-linear"] = "rbxassetid://138942904970587",
    	["text-bold-outline"] = "rbxassetid://135838935202429",
    	["text-bold-square-bold"] = "rbxassetid://79006047376007",
    	["text-bold-square-bold-duotone"] = "rbxassetid://93961623548967",
    	["text-bold-square-broken"] = "rbxassetid://126849746620972",
    	["text-bold-square-line-duotone"] = "rbxassetid://108525056839360",
    	["text-bold-square-linear"] = "rbxassetid://99628385916276",
    	["text-bold-square-outline"] = "rbxassetid://137021817806237",
    	["text-broken"] = "rbxassetid://101368450366554",
    	["text-circle-bold"] = "rbxassetid://132900019115915",
    	["text-circle-bold-duotone"] = "rbxassetid://130489531613911",
    	["text-circle-broken"] = "rbxassetid://98962335775475",
    	["text-circle-line-duotone"] = "rbxassetid://80617421566958",
    	["text-circle-linear"] = "rbxassetid://87799537173465",
    	["text-circle-outline"] = "rbxassetid://79562500970164",
    	["text-cross-bold"] = "rbxassetid://75438637380021",
    	["text-cross-bold-duotone"] = "rbxassetid://120890206666154",
    	["text-cross-broken"] = "rbxassetid://126712963087725",
    	["text-cross-circle-bold"] = "rbxassetid://75541869223727",
    	["text-cross-circle-bold-duotone"] = "rbxassetid://88891818331561",
    	["text-cross-circle-broken"] = "rbxassetid://75701072146140",
    	["text-cross-circle-line-duotone"] = "rbxassetid://122368195546989",
    	["text-cross-circle-linear"] = "rbxassetid://133709579836882",
    	["text-cross-circle-outline"] = "rbxassetid://106835351115639",
    	["text-cross-line-duotone"] = "rbxassetid://136802116656473",
    	["text-cross-linear"] = "rbxassetid://72113584606609",
    	["text-cross-outline"] = "rbxassetid://123948414421524",
    	["text-cross-square-bold"] = "rbxassetid://82573645024003",
    	["text-cross-square-bold-duotone"] = "rbxassetid://75665722733017",
    	["text-cross-square-broken"] = "rbxassetid://93748928036546",
    	["text-cross-square-line-duotone"] = "rbxassetid://136088490170781",
    	["text-cross-square-linear"] = "rbxassetid://109084823983980",
    	["text-cross-square-outline"] = "rbxassetid://94239680254850",
    	["text-field-bold"] = "rbxassetid://98911237764660",
    	["text-field-bold-duotone"] = "rbxassetid://121780944098054",
    	["text-field-broken"] = "rbxassetid://128413903630654",
    	["text-field-focus-bold"] = "rbxassetid://124774821883834",
    	["text-field-focus-bold-duotone"] = "rbxassetid://134628991310051",
    	["text-field-focus-broken"] = "rbxassetid://92265251059462",
    	["text-field-focus-line-duotone"] = "rbxassetid://116030246803070",
    	["text-field-focus-linear"] = "rbxassetid://81170078896971",
    	["text-field-focus-outline"] = "rbxassetid://110843039594073",
    	["text-field-line-duotone"] = "rbxassetid://72308483463592",
    	["text-field-linear"] = "rbxassetid://98892211716992",
    	["text-field-outline"] = "rbxassetid://92560874627951",
    	["text-italic-bold"] = "rbxassetid://99711208999506",
    	["text-italic-bold-duotone"] = "rbxassetid://102604142813605",
    	["text-italic-broken"] = "rbxassetid://110838865731573",
    	["text-italic-circle-bold"] = "rbxassetid://105822776188761",
    	["text-italic-circle-bold-duotone"] = "rbxassetid://131974179622093",
    	["text-italic-circle-broken"] = "rbxassetid://135756791073129",
    	["text-italic-circle-line-duotone"] = "rbxassetid://74073393580930",
    	["text-italic-circle-linear"] = "rbxassetid://136364207204334",
    	["text-italic-circle-outline"] = "rbxassetid://89565456747805",
    	["text-italic-line-duotone"] = "rbxassetid://124395047506005",
    	["text-italic-linear"] = "rbxassetid://72393154345107",
    	["text-italic-outline"] = "rbxassetid://133872810157107",
    	["text-italic-square-bold"] = "rbxassetid://106379754206823",
    	["text-italic-square-bold-duotone"] = "rbxassetid://90311451824205",
    	["text-italic-square-broken"] = "rbxassetid://118052426143112",
    	["text-italic-square-line-duotone"] = "rbxassetid://132419126151271",
    	["text-italic-square-linear"] = "rbxassetid://103519263924602",
    	["text-italic-square-outline"] = "rbxassetid://139652275272532",
    	["text-line-duotone"] = "rbxassetid://124249590035385",
    	["text-linear"] = "rbxassetid://115548216632230",
    	["text-outline"] = "rbxassetid://105902060978013",
    	["text-selection-bold"] = "rbxassetid://137557112875450",
    	["text-selection-bold-duotone"] = "rbxassetid://99932950652339",
    	["text-selection-broken"] = "rbxassetid://109184640211287",
    	["text-selection-line-duotone"] = "rbxassetid://79927739358402",
    	["text-selection-linear"] = "rbxassetid://72626359600977",
    	["text-selection-outline"] = "rbxassetid://132746570968562",
    	["text-square-2-bold"] = "rbxassetid://136952444331070",
    	["text-square-2-bold-duotone"] = "rbxassetid://74024438523678",
    	["text-square-2-broken"] = "rbxassetid://96330744461886",
    	["text-square-2-line-duotone"] = "rbxassetid://95224769825393",
    	["text-square-2-linear"] = "rbxassetid://87395055313699",
    	["text-square-2-outline"] = "rbxassetid://111744752639148",
    	["text-square-bold"] = "rbxassetid://135137239265675",
    	["text-square-bold-duotone"] = "rbxassetid://92338516051572",
    	["text-square-broken"] = "rbxassetid://100508048737021",
    	["text-square-line-duotone"] = "rbxassetid://113071402309633",
    	["text-square-linear"] = "rbxassetid://95932649983379",
    	["text-square-outline"] = "rbxassetid://99178825303859",
    	["text-underline-bold"] = "rbxassetid://101539591432747",
    	["text-underline-bold-duotone"] = "rbxassetid://117085969234508",
    	["text-underline-broken"] = "rbxassetid://102759581075345",
    	["text-underline-circle-bold"] = "rbxassetid://112775181426135",
    	["text-underline-circle-bold-duotone"] = "rbxassetid://89648264307941",
    	["text-underline-circle-broken"] = "rbxassetid://100532683329730",
    	["text-underline-circle-line-duotone"] = "rbxassetid://81075850675727",
    	["text-underline-circle-linear"] = "rbxassetid://84653086156774",
    	["text-underline-circle-outline"] = "rbxassetid://88782914310299",
    	["text-underline-cross-bold"] = "rbxassetid://71846695076450",
    	["text-underline-cross-bold-duotone"] = "rbxassetid://125892008445274",
    	["text-underline-cross-broken"] = "rbxassetid://135404473883891",
    	["text-underline-cross-line-duotone"] = "rbxassetid://114937568582626",
    	["text-underline-cross-linear"] = "rbxassetid://99770726888988",
    	["text-underline-cross-outline"] = "rbxassetid://115483375141216",
    	["text-underline-line-duotone"] = "rbxassetid://82511664518076",
    	["text-underline-linear"] = "rbxassetid://86532721689765",
    	["text-underline-outline"] = "rbxassetid://102133816562214",
    	["thermometer-bold"] = "rbxassetid://118971215433255",
    	["thermometer-bold-duotone"] = "rbxassetid://78562701476702",
    	["thermometer-broken"] = "rbxassetid://88411180421103",
    	["thermometer-line-duotone"] = "rbxassetid://87424362766355",
    	["thermometer-linear"] = "rbxassetid://79533278859305",
    	["thermometer-outline"] = "rbxassetid://106888135856529",
    	["three-squares-bold"] = "rbxassetid://110449044402886",
    	["three-squares-bold-duotone"] = "rbxassetid://108974520300655",
    	["three-squares-broken"] = "rbxassetid://88609808291820",
    	["three-squares-line-duotone"] = "rbxassetid://132896700634305",
    	["three-squares-linear"] = "rbxassetid://73081964211406",
    	["three-squares-outline"] = "rbxassetid://77916058143137",
    	["ticker-star-bold"] = "rbxassetid://121997263518617",
    	["ticker-star-bold-duotone"] = "rbxassetid://101007798605710",
    	["ticker-star-broken"] = "rbxassetid://99708665128270",
    	["ticker-star-line-duotone"] = "rbxassetid://100311857535657",
    	["ticker-star-linear"] = "rbxassetid://114844630327149",
    	["ticker-star-outline"] = "rbxassetid://123039778906599",
    	["ticket-bold"] = "rbxassetid://128755105546658",
    	["ticket-bold-duotone"] = "rbxassetid://90644759057415",
    	["ticket-broken"] = "rbxassetid://128371129777857",
    	["ticket-line-duotone"] = "rbxassetid://76523237547871",
    	["ticket-linear"] = "rbxassetid://132836498208825",
    	["ticket-outline"] = "rbxassetid://102299165544258",
    	["ticket-sale-bold"] = "rbxassetid://117816353388914",
    	["ticket-sale-bold-duotone"] = "rbxassetid://73196336805426",
    	["ticket-sale-broken"] = "rbxassetid://70610716918659",
    	["ticket-sale-line-duotone"] = "rbxassetid://80982639994006",
    	["ticket-sale-linear"] = "rbxassetid://122570638190726",
    	["ticket-sale-outline"] = "rbxassetid://97526758634285",
    	["to-pip-bold"] = "rbxassetid://122574042264102",
    	["to-pip-bold-duotone"] = "rbxassetid://80653764760324",
    	["to-pip-broken"] = "rbxassetid://122674281795460",
    	["to-pip-line-duotone"] = "rbxassetid://106266639597250",
    	["to-pip-linear"] = "rbxassetid://114249033596686",
    	["to-pip-outline"] = "rbxassetid://105694356224341",
    	["tornado-bold"] = "rbxassetid://135923045449439",
    	["tornado-bold-duotone"] = "rbxassetid://81771264865130",
    	["tornado-broken"] = "rbxassetid://80317935556454",
    	["tornado-line-duotone"] = "rbxassetid://77698891941150",
    	["tornado-linear"] = "rbxassetid://80870294286844",
    	["tornado-outline"] = "rbxassetid://78549922226771",
    	["tornado-small-bold"] = "rbxassetid://99669240821087",
    	["tornado-small-bold-duotone"] = "rbxassetid://116616085179924",
    	["tornado-small-broken"] = "rbxassetid://89776861098552",
    	["tornado-small-line-duotone"] = "rbxassetid://115250406453882",
    	["tornado-small-linear"] = "rbxassetid://88710956588114",
    	["tornado-small-outline"] = "rbxassetid://110682079900042",
    	["traffic-bold"] = "rbxassetid://123402546058727",
    	["traffic-bold-duotone"] = "rbxassetid://136430413957807",
    	["traffic-broken"] = "rbxassetid://115149570312264",
    	["traffic-economy-bold"] = "rbxassetid://77900625152722",
    	["traffic-economy-bold-duotone"] = "rbxassetid://99252536965629",
    	["traffic-economy-broken"] = "rbxassetid://86228556535868",
    	["traffic-economy-line-duotone"] = "rbxassetid://82896158335685",
    	["traffic-economy-linear"] = "rbxassetid://86322945801490",
    	["traffic-economy-outline"] = "rbxassetid://88224997448969",
    	["traffic-line-duotone"] = "rbxassetid://104344423397432",
    	["traffic-linear"] = "rbxassetid://114672918469769",
    	["traffic-outline"] = "rbxassetid://107009685151697",
    	["tram-bold"] = "rbxassetid://116303568356677",
    	["tram-linear"] = "rbxassetid://130776119988431",
    	["transfer-horizontal-bold"] = "rbxassetid://102105242487044",
    	["transfer-horizontal-bold-duotone"] = "rbxassetid://138435351963934",
    	["transfer-horizontal-broken"] = "rbxassetid://103063243181584",
    	["transfer-horizontal-line-duotone"] = "rbxassetid://107259356729794",
    	["transfer-horizontal-linear"] = "rbxassetid://100776547582370",
    	["transfer-horizontal-outline"] = "rbxassetid://94110965846892",
    	["transfer-vertical-bold"] = "rbxassetid://120766061002835",
    	["transfer-vertical-bold-duotone"] = "rbxassetid://73205943273390",
    	["transfer-vertical-broken"] = "rbxassetid://132867632369492",
    	["transfer-vertical-line-duotone"] = "rbxassetid://104165522290494",
    	["transfer-vertical-linear"] = "rbxassetid://92891045404610",
    	["transfer-vertical-outline"] = "rbxassetid://131910671871148",
    	["translation-2-bold"] = "rbxassetid://78889094751104",
    	["translation-2-bold-duotone"] = "rbxassetid://81724373463804",
    	["translation-2-broken"] = "rbxassetid://83769837644220",
    	["translation-2-line-duotone"] = "rbxassetid://132315373371645",
    	["translation-2-linear"] = "rbxassetid://105420741233246",
    	["translation-2-outline"] = "rbxassetid://97162755554328",
    	["translation-bold"] = "rbxassetid://122179759560828",
    	["translation-bold-duotone"] = "rbxassetid://134069991720417",
    	["translation-broken"] = "rbxassetid://120684989056571",
    	["translation-line-duotone"] = "rbxassetid://129534267417822",
    	["translation-linear"] = "rbxassetid://73197957341533",
    	["translation-outline"] = "rbxassetid://116554166461592",
    	["transmission-bold"] = "rbxassetid://126322047226804",
    	["transmission-circle-bold"] = "rbxassetid://109248720581180",
    	["transmission-circle-linear"] = "rbxassetid://79738400567951",
    	["transmission-linear"] = "rbxassetid://105742290491408",
    	["transmission-square-bold"] = "rbxassetid://101980323704791",
    	["transmission-square-linear"] = "rbxassetid://89573572485505",
    	["trash-bin-2-bold"] = "rbxassetid://124950181079965",
    	["trash-bin-2-bold-duotone"] = "rbxassetid://82270197541321",
    	["trash-bin-2-broken"] = "rbxassetid://107100820811392",
    	["trash-bin-2-line-duotone"] = "rbxassetid://100523382287343",
    	["trash-bin-2-linear"] = "rbxassetid://101560152408539",
    	["trash-bin-2-outline"] = "rbxassetid://95438632039834",
    	["trash-bin-minimalistic-2-bold"] = "rbxassetid://137172537537016",
    	["trash-bin-minimalistic-2-bold-duotone"] = "rbxassetid://92674223291310",
    	["trash-bin-minimalistic-2-broken"] = "rbxassetid://71895750207385",
    	["trash-bin-minimalistic-2-line-duotone"] = "rbxassetid://84487060938720",
    	["trash-bin-minimalistic-2-linear"] = "rbxassetid://108715787539678",
    	["trash-bin-minimalistic-2-outline"] = "rbxassetid://123581649706678",
    	["trash-bin-minimalistic-bold"] = "rbxassetid://70865927459256",
    	["trash-bin-minimalistic-bold-duotone"] = "rbxassetid://98841046645755",
    	["trash-bin-minimalistic-broken"] = "rbxassetid://97151694883674",
    	["trash-bin-minimalistic-line-duotone"] = "rbxassetid://125398786469559",
    	["trash-bin-minimalistic-linear"] = "rbxassetid://102640526976018",
    	["trash-bin-minimalistic-outline"] = "rbxassetid://85273537502188",
    	["trash-bin-trash-bold"] = "rbxassetid://76323366897784",
    	["trash-bin-trash-bold-duotone"] = "rbxassetid://70511923959326",
    	["trash-bin-trash-broken"] = "rbxassetid://130544880535785",
    	["trash-bin-trash-line-duotone"] = "rbxassetid://110490359373882",
    	["trash-bin-trash-linear"] = "rbxassetid://94282845846270",
    	["trash-bin-trash-outline"] = "rbxassetid://88683594435305",
    	["treadmill-bold"] = "rbxassetid://129648402750616",
    	["treadmill-bold-duotone"] = "rbxassetid://105946488144977",
    	["treadmill-broken"] = "rbxassetid://114890739408878",
    	["treadmill-line-duotone"] = "rbxassetid://72899535975727",
    	["treadmill-linear"] = "rbxassetid://114042262975047",
    	["treadmill-outline"] = "rbxassetid://76311909279147",
    	["treadmill-round-bold"] = "rbxassetid://94884397103011",
    	["treadmill-round-bold-duotone"] = "rbxassetid://97806041874770",
    	["treadmill-round-broken"] = "rbxassetid://123218408162460",
    	["treadmill-round-line-duotone"] = "rbxassetid://134661992479987",
    	["treadmill-round-linear"] = "rbxassetid://109921116006406",
    	["treadmill-round-outline"] = "rbxassetid://87334307653452",
    	["trellis-bold"] = "rbxassetid://137017874479837",
    	["trellis-bold-duotone"] = "rbxassetid://117585356898830",
    	["trellis-broken"] = "rbxassetid://75661248272715",
    	["trellis-line-duotone"] = "rbxassetid://83631596892734",
    	["trellis-linear"] = "rbxassetid://79275752500481",
    	["trellis-outline"] = "rbxassetid://120319533478538",
    	["tuning-2-bold"] = "rbxassetid://82333306930313",
    	["tuning-2-bold-duotone"] = "rbxassetid://121701902799716",
    	["tuning-2-broken"] = "rbxassetid://77062573895378",
    	["tuning-2-line-duotone"] = "rbxassetid://95022941185443",
    	["tuning-2-linear"] = "rbxassetid://74348229684369",
    	["tuning-2-outline"] = "rbxassetid://140005399201666",
    	["tuning-3-bold"] = "rbxassetid://75757152277151",
    	["tuning-3-bold-duotone"] = "rbxassetid://106012522045706",
    	["tuning-3-broken"] = "rbxassetid://122074078862163",
    	["tuning-3-line-duotone"] = "rbxassetid://119598166100177",
    	["tuning-3-linear"] = "rbxassetid://83641009692687",
    	["tuning-3-outline"] = "rbxassetid://113066664223461",
    	["tuning-4-bold"] = "rbxassetid://135916377999987",
    	["tuning-4-bold-duotone"] = "rbxassetid://135926348150251",
    	["tuning-4-broken"] = "rbxassetid://94420848129291",
    	["tuning-4-line-duotone"] = "rbxassetid://113832961543228",
    	["tuning-4-linear"] = "rbxassetid://81333558331087",
    	["tuning-4-outline"] = "rbxassetid://96302453795842",
    	["tuning-bold"] = "rbxassetid://106185406308820",
    	["tuning-bold-duotone"] = "rbxassetid://95115502353989",
    	["tuning-broken"] = "rbxassetid://139684279271661",
    	["tuning-line-duotone"] = "rbxassetid://112961817412105",
    	["tuning-linear"] = "rbxassetid://80251857186766",
    	["tuning-outline"] = "rbxassetid://78032104492942",
    	["tuning-square-2-bold"] = "rbxassetid://93994359568129",
    	["tuning-square-2-bold-duotone"] = "rbxassetid://115957828334655",
    	["tuning-square-2-broken"] = "rbxassetid://91987629189269",
    	["tuning-square-2-line-duotone"] = "rbxassetid://70681252174150",
    	["tuning-square-2-linear"] = "rbxassetid://100233628078159",
    	["tuning-square-2-outline"] = "rbxassetid://75604184247454",
    	["tuning-square-bold"] = "rbxassetid://138100521939866",
    	["tuning-square-bold-duotone"] = "rbxassetid://115502987142359",
    	["tuning-square-broken"] = "rbxassetid://87384766718777",
    	["tuning-square-line-duotone"] = "rbxassetid://132139650115855",
    	["tuning-square-linear"] = "rbxassetid://126596314997401",
    	["tuning-square-outline"] = "rbxassetid://85777270305541",
    	["turntable-bold"] = "rbxassetid://89367537824987",
    	["turntable-bold-duotone"] = "rbxassetid://93093543702787",
    	["turntable-broken"] = "rbxassetid://76959179973710",
    	["turntable-line-duotone"] = "rbxassetid://116842000532836",
    	["turntable-linear"] = "rbxassetid://139839088323279",
    	["turntable-minimalistic-bold"] = "rbxassetid://115978033833640",
    	["turntable-minimalistic-bold-duotone"] = "rbxassetid://78222712345377",
    	["turntable-minimalistic-broken"] = "rbxassetid://124987978993564",
    	["turntable-minimalistic-line-duotone"] = "rbxassetid://130088407792448",
    	["turntable-minimalistic-linear"] = "rbxassetid://112360115412931",
    	["turntable-minimalistic-outline"] = "rbxassetid://99216183576626",
    	["turntable-music-note-bold"] = "rbxassetid://73335854917174",
    	["turntable-music-note-bold-duotone"] = "rbxassetid://106243495741203",
    	["turntable-music-note-broken"] = "rbxassetid://109233956005020",
    	["turntable-music-note-line-duotone"] = "rbxassetid://114797749173728",
    	["turntable-music-note-linear"] = "rbxassetid://133088866128492",
    	["turntable-music-note-outline"] = "rbxassetid://98462349822737",
    	["turntable-outline"] = "rbxassetid://72013489369415",
    	["tv-bold"] = "rbxassetid://81328242137501",
    	["tv-bold-duotone"] = "rbxassetid://110810684988125",
    	["tv-broken"] = "rbxassetid://125394003926606",
    	["tv-line-duotone"] = "rbxassetid://113068754856126",
    	["tv-linear"] = "rbxassetid://79695544027437",
    	["tv-outline"] = "rbxassetid://73016417185857",
    	["ufo-2-bold"] = "rbxassetid://108307092452400",
    	["ufo-2-bold-duotone"] = "rbxassetid://76274564359079",
    	["ufo-2-broken"] = "rbxassetid://84812893242011",
    	["ufo-2-line-duotone"] = "rbxassetid://95325123231241",
    	["ufo-2-linear"] = "rbxassetid://124826443703365",
    	["ufo-2-outline"] = "rbxassetid://139289154547913",
    	["ufo-3-bold"] = "rbxassetid://140510327756200",
    	["ufo-3-bold-duotone"] = "rbxassetid://109304482376357",
    	["ufo-3-broken"] = "rbxassetid://121744921669791",
    	["ufo-3-line-duotone"] = "rbxassetid://105803434386577",
    	["ufo-3-linear"] = "rbxassetid://105696310637416",
    	["ufo-3-outline"] = "rbxassetid://123056108320997",
    	["ufo-bold"] = "rbxassetid://74519584196021",
    	["ufo-bold-duotone"] = "rbxassetid://139416948057737",
    	["ufo-broken"] = "rbxassetid://131968716098329",
    	["ufo-line-duotone"] = "rbxassetid://120517932527693",
    	["ufo-linear"] = "rbxassetid://109548691163799",
    	["ufo-outline"] = "rbxassetid://129138757970457",
    	["umbrella-bold"] = "rbxassetid://91254497875369",
    	["umbrella-bold-duotone"] = "rbxassetid://98443348073195",
    	["umbrella-broken"] = "rbxassetid://79301769930582",
    	["umbrella-line-duotone"] = "rbxassetid://97165620938195",
    	["umbrella-linear"] = "rbxassetid://116344110361872",
    	["umbrella-outline"] = "rbxassetid://91838471327677",
    	["undo-left-bold"] = "rbxassetid://101535300462497",
    	["undo-left-bold-duotone"] = "rbxassetid://135654741595460",
    	["undo-left-broken"] = "rbxassetid://110999528998234",
    	["undo-left-line-duotone"] = "rbxassetid://87572549100503",
    	["undo-left-linear"] = "rbxassetid://113999189063409",
    	["undo-left-outline"] = "rbxassetid://84135030998003",
    	["undo-left-round-bold"] = "rbxassetid://93326283820468",
    	["undo-left-round-bold-duotone"] = "rbxassetid://105592356513210",
    	["undo-left-round-broken"] = "rbxassetid://118798007416426",
    	["undo-left-round-line-duotone"] = "rbxassetid://108469929480045",
    	["undo-left-round-linear"] = "rbxassetid://97656309761883",
    	["undo-left-round-outline"] = "rbxassetid://88982568304642",
    	["undo-left-round-square-bold"] = "rbxassetid://121916928029783",
    	["undo-left-round-square-bold-duotone"] = "rbxassetid://81464675514038",
    	["undo-left-round-square-broken"] = "rbxassetid://99375348710456",
    	["undo-left-round-square-line-duotone"] = "rbxassetid://72071486547562",
    	["undo-left-round-square-linear"] = "rbxassetid://98278603601780",
    	["undo-left-round-square-outline"] = "rbxassetid://124231671212257",
    	["undo-left-square-bold"] = "rbxassetid://72621879478446",
    	["undo-left-square-bold-duotone"] = "rbxassetid://73061759474176",
    	["undo-left-square-broken"] = "rbxassetid://77573977431566",
    	["undo-left-square-line-duotone"] = "rbxassetid://127223102881746",
    	["undo-left-square-linear"] = "rbxassetid://95604508203312",
    	["undo-left-square-outline"] = "rbxassetid://100303919063413",
    	["undo-right-bold"] = "rbxassetid://130557105074315",
    	["undo-right-bold-duotone"] = "rbxassetid://82900958359510",
    	["undo-right-broken"] = "rbxassetid://131498427805370",
    	["undo-right-line-duotone"] = "rbxassetid://110199648398589",
    	["undo-right-linear"] = "rbxassetid://133925184913840",
    	["undo-right-outline"] = "rbxassetid://136687706046642",
    	["undo-right-round-bold"] = "rbxassetid://130521277062566",
    	["undo-right-round-bold-duotone"] = "rbxassetid://104348371546155",
    	["undo-right-round-broken"] = "rbxassetid://93169144732905",
    	["undo-right-round-line-duotone"] = "rbxassetid://105773498851693",
    	["undo-right-round-linear"] = "rbxassetid://91276930838402",
    	["undo-right-round-outline"] = "rbxassetid://83260280126500",
    	["undo-right-round-square-bold"] = "rbxassetid://88065835584182",
    	["undo-right-round-square-bold-duotone"] = "rbxassetid://91533856849801",
    	["undo-right-round-square-broken"] = "rbxassetid://120022708884516",
    	["undo-right-round-square-line-duotone"] = "rbxassetid://136164473500559",
    	["undo-right-round-square-linear"] = "rbxassetid://75521767637776",
    	["undo-right-round-square-outline"] = "rbxassetid://71264967320005",
    	["undo-right-square-bold"] = "rbxassetid://80269849465980",
    	["undo-right-square-bold-duotone"] = "rbxassetid://122234640758594",
    	["undo-right-square-broken"] = "rbxassetid://128358458602407",
    	["undo-right-square-line-duotone"] = "rbxassetid://124765459162030",
    	["undo-right-square-linear"] = "rbxassetid://114012799490748",
    	["undo-right-square-outline"] = "rbxassetid://120834420018983",
    	["unread-bold"] = "rbxassetid://110416886370701",
    	["unread-bold-duotone"] = "rbxassetid://125407821239352",
    	["unread-broken"] = "rbxassetid://127985164485155",
    	["unread-line-duotone"] = "rbxassetid://114436029333598",
    	["unread-linear"] = "rbxassetid://124363665396833",
    	["unread-outline"] = "rbxassetid://99877753269040",
    	["upload-bold"] = "rbxassetid://82181626860091",
    	["upload-bold-duotone"] = "rbxassetid://121430409936172",
    	["upload-broken"] = "rbxassetid://89972612921418",
    	["upload-line-duotone"] = "rbxassetid://88096182495970",
    	["upload-linear"] = "rbxassetid://140356881321804",
    	["upload-minimalistic-bold"] = "rbxassetid://107646669869079",
    	["upload-minimalistic-bold-duotone"] = "rbxassetid://137846734646927",
    	["upload-minimalistic-broken"] = "rbxassetid://123131131200522",
    	["upload-minimalistic-line-duotone"] = "rbxassetid://103230874428330",
    	["upload-minimalistic-linear"] = "rbxassetid://79657522820532",
    	["upload-minimalistic-outline"] = "rbxassetid://82770168930983",
    	["upload-outline"] = "rbxassetid://120486408734216",
    	["upload-square-bold"] = "rbxassetid://119275582449778",
    	["upload-square-bold-duotone"] = "rbxassetid://96775459058262",
    	["upload-square-broken"] = "rbxassetid://133958417977159",
    	["upload-square-line-duotone"] = "rbxassetid://108767027281515",
    	["upload-square-linear"] = "rbxassetid://108667083248957",
    	["upload-square-outline"] = "rbxassetid://140609070053729",
    	["upload-track-2-bold"] = "rbxassetid://96082765006306",
    	["upload-track-2-bold-duotone"] = "rbxassetid://136507213589807",
    	["upload-track-2-broken"] = "rbxassetid://83965821740960",
    	["upload-track-2-line-duotone"] = "rbxassetid://105973847939743",
    	["upload-track-2-linear"] = "rbxassetid://77944001461841",
    	["upload-track-2-outline"] = "rbxassetid://106382235493074",
    	["upload-track-bold"] = "rbxassetid://123038174128910",
    	["upload-track-bold-duotone"] = "rbxassetid://96901883032627",
    	["upload-track-broken"] = "rbxassetid://102734950644677",
    	["upload-track-line-duotone"] = "rbxassetid://103444802839141",
    	["upload-track-linear"] = "rbxassetid://113334658674994",
    	["upload-track-outline"] = "rbxassetid://71234725525875",
    	["upload-twice-square-bold"] = "rbxassetid://81193322760208",
    	["upload-twice-square-bold-duotone"] = "rbxassetid://94838490486901",
    	["upload-twice-square-broken"] = "rbxassetid://82749610852919",
    	["upload-twice-square-line-duotone"] = "rbxassetid://114015467628571",
    	["upload-twice-square-linear"] = "rbxassetid://81889731096091",
    	["upload-twice-square-outline"] = "rbxassetid://72124439102825",
    	["usb-bold"] = "rbxassetid://106112000914766",
    	["usb-bold-duotone"] = "rbxassetid://85450538765037",
    	["usb-broken"] = "rbxassetid://73607397424075",
    	["usb-circle-bold"] = "rbxassetid://94849067026483",
    	["usb-circle-bold-duotone"] = "rbxassetid://72145859587488",
    	["usb-circle-broken"] = "rbxassetid://128913395643600",
    	["usb-circle-line-duotone"] = "rbxassetid://137023485368933",
    	["usb-circle-linear"] = "rbxassetid://83111987537102",
    	["usb-circle-outline"] = "rbxassetid://124596470927393",
    	["usb-line-duotone"] = "rbxassetid://124043927323962",
    	["usb-linear"] = "rbxassetid://84449360358241",
    	["usb-outline"] = "rbxassetid://112370245945327",
    	["usb-square-bold"] = "rbxassetid://86965694736385",
    	["usb-square-bold-duotone"] = "rbxassetid://100139244725226",
    	["usb-square-broken"] = "rbxassetid://86465109747940",
    	["usb-square-line-duotone"] = "rbxassetid://93291890841441",
    	["usb-square-linear"] = "rbxassetid://116314173495519",
    	["usb-square-outline"] = "rbxassetid://105397576290667",
    	["user-block-bold"] = "rbxassetid://114355063515473",
    	["user-block-bold-duotone"] = "rbxassetid://115407047250716",
    	["user-block-line-duotone"] = "rbxassetid://135941019400411",
    	["user-block-linear"] = "rbxassetid://117305008411302",
    	["user-block-outline"] = "rbxassetid://137584558706180",
    	["user-block-rounded-bold"] = "rbxassetid://104794369369754",
    	["user-block-rounded-bold-duotone"] = "rbxassetid://126549938336400",
    	["user-block-rounded-line-duotone"] = "rbxassetid://119877063640261",
    	["user-block-rounded-linear"] = "rbxassetid://112898341160392",
    	["user-block-rounded-outline"] = "rbxassetid://133222600865558",
    	["user-bold"] = "rbxassetid://125161627986415",
    	["user-bold-duotone"] = "rbxassetid://75452383201285",
    	["user-check-bold"] = "rbxassetid://93659367975786",
    	["user-check-bold-duotone"] = "rbxassetid://70768217279173",
    	["user-check-line-duotone"] = "rbxassetid://86972564106883",
    	["user-check-linear"] = "rbxassetid://138899826175081",
    	["user-check-outline"] = "rbxassetid://121982186782260",
    	["user-check-rounded-bold"] = "rbxassetid://119674379642330",
    	["user-check-rounded-bold-duotone"] = "rbxassetid://123557895545453",
    	["user-check-rounded-line-duotone"] = "rbxassetid://118978684460509",
    	["user-check-rounded-linear"] = "rbxassetid://95900278405528",
    	["user-check-rounded-outline"] = "rbxassetid://82028276489372",
    	["user-circle-bold"] = "rbxassetid://86288701652149",
    	["user-circle-bold-duotone"] = "rbxassetid://79181750204216",
    	["user-circle-line-duotone"] = "rbxassetid://89795742613626",
    	["user-circle-linear"] = "rbxassetid://107841956079901",
    	["user-circle-outline"] = "rbxassetid://74768587278630",
    	["user-cross-bold"] = "rbxassetid://132471506730881",
    	["user-cross-bold-duotone"] = "rbxassetid://137768986857488",
    	["user-cross-line-duotone"] = "rbxassetid://131136938626734",
    	["user-cross-linear"] = "rbxassetid://84641490079719",
    	["user-cross-outline"] = "rbxassetid://134074075605011",
    	["user-cross-rounded-bold"] = "rbxassetid://125371741244205",
    	["user-cross-rounded-bold-duotone"] = "rbxassetid://80984484781157",
    	["user-cross-rounded-line-duotone"] = "rbxassetid://113723633021621",
    	["user-cross-rounded-linear"] = "rbxassetid://111960280006810",
    	["user-cross-rounded-outline"] = "rbxassetid://109158168836588",
    	["user-hand-up-bold"] = "rbxassetid://77880631966096",
    	["user-hand-up-bold-duotone"] = "rbxassetid://73008171861185",
    	["user-hand-up-line-duotone"] = "rbxassetid://129647137492007",
    	["user-hand-up-linear"] = "rbxassetid://80915664104077",
    	["user-hand-up-outline"] = "rbxassetid://117768374987900",
    	["user-hands-bold"] = "rbxassetid://127075603959605",
    	["user-hands-bold-duotone"] = "rbxassetid://123642426200423",
    	["user-hands-line-duotone"] = "rbxassetid://133096621869489",
    	["user-hands-linear"] = "rbxassetid://79855323131391",
    	["user-hands-outline"] = "rbxassetid://104812929379967",
    	["user-heart-bold"] = "rbxassetid://138862194107927",
    	["user-heart-bold-duotone"] = "rbxassetid://86561668129991",
    	["user-heart-line-duotone"] = "rbxassetid://110058308034101",
    	["user-heart-linear"] = "rbxassetid://73850001246232",
    	["user-heart-outline"] = "rbxassetid://128604831869333",
    	["user-heart-rounded-bold"] = "rbxassetid://71668079240282",
    	["user-heart-rounded-bold-duotone"] = "rbxassetid://131562598302056",
    	["user-heart-rounded-line-duotone"] = "rbxassetid://124294430374725",
    	["user-heart-rounded-linear"] = "rbxassetid://117166604795971",
    	["user-heart-rounded-outline"] = "rbxassetid://109538843814703",
    	["user-id-bold"] = "rbxassetid://98773947934088",
    	["user-id-bold-duotone"] = "rbxassetid://81045831959090",
    	["user-id-line-duotone"] = "rbxassetid://92110064513694",
    	["user-id-linear"] = "rbxassetid://125869750781830",
    	["user-id-outline"] = "rbxassetid://111684883491541",
    	["user-line-duotone"] = "rbxassetid://73482102998132",
    	["user-linear"] = "rbxassetid://77763836046064",
    	["user-minus-bold"] = "rbxassetid://72399636270324",
    	["user-minus-bold-duotone"] = "rbxassetid://106565089503131",
    	["user-minus-line-duotone"] = "rbxassetid://103080750579515",
    	["user-minus-linear"] = "rbxassetid://91505523809243",
    	["user-minus-outline"] = "rbxassetid://107130304241254",
    	["user-minus-rounded-bold"] = "rbxassetid://135268670474984",
    	["user-minus-rounded-bold-duotone"] = "rbxassetid://96543034758892",
    	["user-minus-rounded-line-duotone"] = "rbxassetid://86543488194634",
    	["user-minus-rounded-linear"] = "rbxassetid://90587040735398",
    	["user-minus-rounded-outline"] = "rbxassetid://129035415207400",
    	["user-outline"] = "rbxassetid://105812567783581",
    	["user-plus-bold"] = "rbxassetid://94753090743326",
    	["user-plus-bold-duotone"] = "rbxassetid://128011495020001",
    	["user-plus-line-duotone"] = "rbxassetid://75795075502185",
    	["user-plus-linear"] = "rbxassetid://140205010654580",
    	["user-plus-outline"] = "rbxassetid://110887152751672",
    	["user-plus-rounded-bold"] = "rbxassetid://96300834054336",
    	["user-plus-rounded-bold-duotone"] = "rbxassetid://89161248656782",
    	["user-plus-rounded-line-duotone"] = "rbxassetid://115614852712356",
    	["user-plus-rounded-linear"] = "rbxassetid://74837218166429",
    	["user-plus-rounded-outline"] = "rbxassetid://93577131493977",
    	["user-rounded-bold"] = "rbxassetid://94273456177524",
    	["user-rounded-bold-duotone"] = "rbxassetid://99528388270207",
    	["user-rounded-line-duotone"] = "rbxassetid://110156880004944",
    	["user-rounded-linear"] = "rbxassetid://131456424364681",
    	["user-rounded-outline"] = "rbxassetid://108754718272811",
    	["user-speak-bold"] = "rbxassetid://110385470358124",
    	["user-speak-bold-duotone"] = "rbxassetid://77757132328056",
    	["user-speak-line-duotone"] = "rbxassetid://90555839587260",
    	["user-speak-linear"] = "rbxassetid://98751290517541",
    	["user-speak-outline"] = "rbxassetid://74238958305855",
    	["user-speak-rounded-bold"] = "rbxassetid://107485687385793",
    	["user-speak-rounded-bold-duotone"] = "rbxassetid://132073310984084",
    	["user-speak-rounded-line-duotone"] = "rbxassetid://140269899900966",
    	["user-speak-rounded-linear"] = "rbxassetid://77497680364766",
    	["user-speak-rounded-outline"] = "rbxassetid://103354162278898",
    	["users-group-rounded-bold"] = "rbxassetid://126742251911152",
    	["users-group-rounded-bold-duotone"] = "rbxassetid://125795433470799",
    	["users-group-rounded-line-duotone"] = "rbxassetid://106734511415211",
    	["users-group-rounded-linear"] = "rbxassetid://82690154076779",
    	["users-group-rounded-outline"] = "rbxassetid://87786327655941",
    	["users-group-two-rounded-bold"] = "rbxassetid://127970090727557",
    	["users-group-two-rounded-bold-duotone"] = "rbxassetid://137540150239513",
    	["users-group-two-rounded-line-duotone"] = "rbxassetid://71424124222759",
    	["users-group-two-rounded-linear"] = "rbxassetid://134615520644461",
    	["users-group-two-rounded-outline"] = "rbxassetid://103719209030086",
    	["verified-check-bold"] = "rbxassetid://119783053916823",
    	["verified-check-bold-duotone"] = "rbxassetid://128256039484019",
    	["verified-check-broken"] = "rbxassetid://117444916788890",
    	["verified-check-line-duotone"] = "rbxassetid://133045085134543",
    	["verified-check-linear"] = "rbxassetid://103360997878426",
    	["verified-check-outline"] = "rbxassetid://108731840056774",
    	["video-frame-2-bold"] = "rbxassetid://82337478304413",
    	["video-frame-2-bold-duotone"] = "rbxassetid://82136362442442",
    	["video-frame-2-broken"] = "rbxassetid://102016841381375",
    	["video-frame-2-line-duotone"] = "rbxassetid://128715766879907",
    	["video-frame-2-linear"] = "rbxassetid://77705532111538",
    	["video-frame-2-outline"] = "rbxassetid://119829525878202",
    	["video-frame-bold"] = "rbxassetid://73128756981234",
    	["video-frame-bold-duotone"] = "rbxassetid://127600974453038",
    	["video-frame-broken"] = "rbxassetid://106914501519787",
    	["video-frame-cut-2-bold"] = "rbxassetid://119780853690159",
    	["video-frame-cut-2-bold-duotone"] = "rbxassetid://126402882063560",
    	["video-frame-cut-2-broken"] = "rbxassetid://107010380381390",
    	["video-frame-cut-2-line-duotone"] = "rbxassetid://135260793267360",
    	["video-frame-cut-2-linear"] = "rbxassetid://106887714332100",
    	["video-frame-cut-2-outline"] = "rbxassetid://88716834957036",
    	["video-frame-cut-bold"] = "rbxassetid://123929691789983",
    	["video-frame-cut-bold-duotone"] = "rbxassetid://106294060080434",
    	["video-frame-cut-broken"] = "rbxassetid://140325288574454",
    	["video-frame-cut-line-duotone"] = "rbxassetid://88491923553936",
    	["video-frame-cut-linear"] = "rbxassetid://125080381919512",
    	["video-frame-cut-outline"] = "rbxassetid://102761817992324",
    	["video-frame-line-duotone"] = "rbxassetid://118906171366397",
    	["video-frame-linear"] = "rbxassetid://90163448551713",
    	["video-frame-outline"] = "rbxassetid://140483082257004",
    	["video-frame-play-horizontal-bold"] = "rbxassetid://122648668294196",
    	["video-frame-play-horizontal-bold-duotone"] = "rbxassetid://72556353337105",
    	["video-frame-play-horizontal-broken"] = "rbxassetid://117616761695826",
    	["video-frame-play-horizontal-line-duotone"] = "rbxassetid://117281933557693",
    	["video-frame-play-horizontal-linear"] = "rbxassetid://130889361972900",
    	["video-frame-play-horizontal-outline"] = "rbxassetid://86536286728804",
    	["video-frame-play-vertical-bold"] = "rbxassetid://85138471863840",
    	["video-frame-play-vertical-bold-duotone"] = "rbxassetid://122348860286784",
    	["video-frame-play-vertical-broken"] = "rbxassetid://73650774665902",
    	["video-frame-play-vertical-line-duotone"] = "rbxassetid://133434113580224",
    	["video-frame-play-vertical-linear"] = "rbxassetid://90560363236286",
    	["video-frame-play-vertical-outline"] = "rbxassetid://126603988491875",
    	["video-frame-replace-bold"] = "rbxassetid://138891570992053",
    	["video-frame-replace-bold-duotone"] = "rbxassetid://125435562887944",
    	["video-frame-replace-broken"] = "rbxassetid://80508368590231",
    	["video-frame-replace-line-duotone"] = "rbxassetid://135222626630230",
    	["video-frame-replace-linear"] = "rbxassetid://70760512179071",
    	["video-frame-replace-outline"] = "rbxassetid://140603610999384",
    	["video-library-bold"] = "rbxassetid://79214944944624",
    	["video-library-bold-duotone"] = "rbxassetid://138014550241485",
    	["video-library-broken"] = "rbxassetid://118976996223715",
    	["video-library-line-duotone"] = "rbxassetid://131180165898580",
    	["video-library-linear"] = "rbxassetid://71138407919793",
    	["video-library-outline"] = "rbxassetid://130770520856793",
    	["videocamera-add-bold"] = "rbxassetid://89427892975850",
    	["videocamera-add-bold-duotone"] = "rbxassetid://108080864019910",
    	["videocamera-add-broken"] = "rbxassetid://110162361297626",
    	["videocamera-add-line-duotone"] = "rbxassetid://91810854086585",
    	["videocamera-add-linear"] = "rbxassetid://105771392160278",
    	["videocamera-add-outline"] = "rbxassetid://114182211101745",
    	["videocamera-bold"] = "rbxassetid://95818845453265",
    	["videocamera-bold-duotone"] = "rbxassetid://131379977272597",
    	["videocamera-broken"] = "rbxassetid://71720214961394",
    	["videocamera-line-duotone"] = "rbxassetid://77625969042782",
    	["videocamera-linear"] = "rbxassetid://105041626369848",
    	["videocamera-outline"] = "rbxassetid://77697173136825",
    	["videocamera-record-bold"] = "rbxassetid://88046262841338",
    	["videocamera-record-bold-duotone"] = "rbxassetid://84278843732767",
    	["videocamera-record-broken"] = "rbxassetid://106436447089211",
    	["videocamera-record-line-duotone"] = "rbxassetid://136544441303595",
    	["videocamera-record-linear"] = "rbxassetid://135395570953884",
    	["videocamera-record-outline"] = "rbxassetid://85714954140403",
    	["vinyl-bold"] = "rbxassetid://110848145855714",
    	["vinyl-bold-duotone"] = "rbxassetid://95966448994218",
    	["vinyl-broken"] = "rbxassetid://71555141791694",
    	["vinyl-line-duotone"] = "rbxassetid://82082736358603",
    	["vinyl-linear"] = "rbxassetid://126719436318967",
    	["vinyl-outline"] = "rbxassetid://114341683339946",
    	["vinyl-record-bold"] = "rbxassetid://88847483181728",
    	["vinyl-record-bold-duotone"] = "rbxassetid://135921261627822",
    	["vinyl-record-broken"] = "rbxassetid://106099725053639",
    	["vinyl-record-line-duotone"] = "rbxassetid://119794011261944",
    	["vinyl-record-linear"] = "rbxassetid://81967523588498",
    	["vinyl-record-outline"] = "rbxassetid://93857401486100",
    	["virus-bold"] = "rbxassetid://79496716882276",
    	["virus-bold-duotone"] = "rbxassetid://106563236658975",
    	["virus-broken"] = "rbxassetid://76659257543173",
    	["virus-line-duotone"] = "rbxassetid://134547520097050",
    	["virus-linear"] = "rbxassetid://111049945911177",
    	["virus-outline"] = "rbxassetid://107409584189937",
    	["volleyball-2-bold"] = "rbxassetid://88021776097939",
    	["volleyball-2-bold-duotone"] = "rbxassetid://70461574068997",
    	["volleyball-2-broken"] = "rbxassetid://108676329553417",
    	["volleyball-2-line-duotone"] = "rbxassetid://114772155305971",
    	["volleyball-2-linear"] = "rbxassetid://85440603894739",
    	["volleyball-2-outline"] = "rbxassetid://84673653844497",
    	["volleyball-bold"] = "rbxassetid://130485373566106",
    	["volleyball-bold-duotone"] = "rbxassetid://85910157173762",
    	["volleyball-broken"] = "rbxassetid://108307034071124",
    	["volleyball-line-duotone"] = "rbxassetid://115922774324747",
    	["volleyball-linear"] = "rbxassetid://104429720839816",
    	["volleyball-outline"] = "rbxassetid://75418470992532",
    	["volume-bold"] = "rbxassetid://102626706004883",
    	["volume-bold-duotone"] = "rbxassetid://129623450910218",
    	["volume-broken"] = "rbxassetid://137513820506771",
    	["volume-cross-bold"] = "rbxassetid://109348232574607",
    	["volume-cross-bold-duotone"] = "rbxassetid://117207356329740",
    	["volume-cross-broken"] = "rbxassetid://127521440666858",
    	["volume-cross-line-duotone"] = "rbxassetid://103861694868994",
    	["volume-cross-linear"] = "rbxassetid://108864858544993",
    	["volume-cross-outline"] = "rbxassetid://81751744229850",
    	["volume-knob-bold"] = "rbxassetid://97370286327773",
    	["volume-knob-bold-duotone"] = "rbxassetid://97476034944383",
    	["volume-knob-broken"] = "rbxassetid://75178257123970",
    	["volume-knob-line-duotone"] = "rbxassetid://85098417373376",
    	["volume-knob-linear"] = "rbxassetid://127060005162682",
    	["volume-knob-outline"] = "rbxassetid://76438194735219",
    	["volume-line-duotone"] = "rbxassetid://95646979315220",
    	["volume-linear"] = "rbxassetid://103581931632748",
    	["volume-loud-bold"] = "rbxassetid://133324163109944",
    	["volume-loud-bold-duotone"] = "rbxassetid://95765475520663",
    	["volume-loud-broken"] = "rbxassetid://94758347474431",
    	["volume-loud-line-duotone"] = "rbxassetid://78098968869403",
    	["volume-loud-linear"] = "rbxassetid://116945756793938",
    	["volume-loud-outline"] = "rbxassetid://80627826821563",
    	["volume-outline"] = "rbxassetid://105201866812719",
    	["volume-small-bold"] = "rbxassetid://116725011263323",
    	["volume-small-bold-duotone"] = "rbxassetid://70760631940142",
    	["volume-small-broken"] = "rbxassetid://73290657780996",
    	["volume-small-line-duotone"] = "rbxassetid://99297074056226",
    	["volume-small-linear"] = "rbxassetid://78826003629078",
    	["volume-small-outline"] = "rbxassetid://132843759145993",
    	["wad-of-money-bold"] = "rbxassetid://105559865289319",
    	["wad-of-money-bold-duotone"] = "rbxassetid://103341416246866",
    	["wad-of-money-broken"] = "rbxassetid://131741967036192",
    	["wad-of-money-line-duotone"] = "rbxassetid://133590950314303",
    	["wad-of-money-linear"] = "rbxassetid://100428216171182",
    	["wad-of-money-outline"] = "rbxassetid://87581738561354",
    	["walking-bold"] = "rbxassetid://133190246297220",
    	["walking-bold-duotone"] = "rbxassetid://128025772110845",
    	["walking-broken"] = "rbxassetid://81378116242660",
    	["walking-line-duotone"] = "rbxassetid://109018597989403",
    	["walking-linear"] = "rbxassetid://136818032350519",
    	["walking-outline"] = "rbxassetid://111234207673897",
    	["walking-round-bold"] = "rbxassetid://105069478354242",
    	["walking-round-bold-duotone"] = "rbxassetid://129710848336911",
    	["walking-round-broken"] = "rbxassetid://77720115758088",
    	["walking-round-line-duotone"] = "rbxassetid://129365075586501",
    	["walking-round-linear"] = "rbxassetid://133599659988663",
    	["walking-round-outline"] = "rbxassetid://120981628121451",
    	["wallet-2-bold"] = "rbxassetid://103092721640216",
    	["wallet-2-bold-duotone"] = "rbxassetid://100184622833903",
    	["wallet-2-broken"] = "rbxassetid://79379277243913",
    	["wallet-2-line-duotone"] = "rbxassetid://76035809519697",
    	["wallet-2-linear"] = "rbxassetid://101132758420598",
    	["wallet-2-outline"] = "rbxassetid://79750062251584",
    	["wallet-bold"] = "rbxassetid://115541316499580",
    	["wallet-bold-duotone"] = "rbxassetid://130482175443504",
    	["wallet-broken"] = "rbxassetid://129014750527119",
    	["wallet-line-duotone"] = "rbxassetid://107138371096070",
    	["wallet-linear"] = "rbxassetid://100720768847463",
    	["wallet-money-bold"] = "rbxassetid://91080748679499",
    	["wallet-money-bold-duotone"] = "rbxassetid://95799248107169",
    	["wallet-money-broken"] = "rbxassetid://103333126275923",
    	["wallet-money-line-duotone"] = "rbxassetid://100296778408009",
    	["wallet-money-linear"] = "rbxassetid://135940229756368",
    	["wallet-money-outline"] = "rbxassetid://95627602537958",
    	["wallet-outline"] = "rbxassetid://85189327428563",
    	["wallpaper-bold"] = "rbxassetid://107668850940426",
    	["wallpaper-bold-duotone"] = "rbxassetid://82896099970112",
    	["wallpaper-broken"] = "rbxassetid://103536197792760",
    	["wallpaper-line-duotone"] = "rbxassetid://135815777360985",
    	["wallpaper-linear"] = "rbxassetid://109930774528000",
    	["wallpaper-outline"] = "rbxassetid://118392290138574",
    	["washing-machine-bold"] = "rbxassetid://115544099026586",
    	["washing-machine-bold-duotone"] = "rbxassetid://130809900567108",
    	["washing-machine-broken"] = "rbxassetid://73543997968653",
    	["washing-machine-line-duotone"] = "rbxassetid://117206046707042",
    	["washing-machine-linear"] = "rbxassetid://78150115412188",
    	["washing-machine-minimalistic-bold"] = "rbxassetid://90822848541801",
    	["washing-machine-minimalistic-bold-duotone"] = "rbxassetid://97177178122829",
    	["washing-machine-minimalistic-broken"] = "rbxassetid://139094209479393",
    	["washing-machine-minimalistic-line-duotone"] = "rbxassetid://88188240387195",
    	["washing-machine-minimalistic-linear"] = "rbxassetid://119046501018741",
    	["washing-machine-minimalistic-outline"] = "rbxassetid://76249028590851",
    	["washing-machine-outline"] = "rbxassetid://81327088181287",
    	["watch-round-bold"] = "rbxassetid://131590076446195",
    	["watch-round-bold-duotone"] = "rbxassetid://131448958590420",
    	["watch-round-broken"] = "rbxassetid://101570606060405",
    	["watch-round-line-duotone"] = "rbxassetid://122504908283022",
    	["watch-round-linear"] = "rbxassetid://105276191569459",
    	["watch-round-outline"] = "rbxassetid://79582033508778",
    	["watch-square-bold"] = "rbxassetid://126156237544815",
    	["watch-square-bold-duotone"] = "rbxassetid://99562777511121",
    	["watch-square-broken"] = "rbxassetid://137340175911465",
    	["watch-square-line-duotone"] = "rbxassetid://104368894133060",
    	["watch-square-linear"] = "rbxassetid://139996376814440",
    	["watch-square-minimalistic-bold"] = "rbxassetid://79171579158341",
    	["watch-square-minimalistic-bold-duotone"] = "rbxassetid://97544775690926",
    	["watch-square-minimalistic-broken"] = "rbxassetid://94013220542989",
    	["watch-square-minimalistic-charge-bold"] = "rbxassetid://71144410008870",
    	["watch-square-minimalistic-charge-bold-duotone"] = "rbxassetid://95452548739506",
    	["watch-square-minimalistic-charge-broken"] = "rbxassetid://99982630771593",
    	["watch-square-minimalistic-charge-line-duotone"] = "rbxassetid://136719054806470",
    	["watch-square-minimalistic-charge-linear"] = "rbxassetid://107920757128103",
    	["watch-square-minimalistic-charge-outline"] = "rbxassetid://127643415225680",
    	["watch-square-minimalistic-line-duotone"] = "rbxassetid://136273950489429",
    	["watch-square-minimalistic-linear"] = "rbxassetid://109425291934865",
    	["watch-square-minimalistic-outline"] = "rbxassetid://91154034313802",
    	["watch-square-outline"] = "rbxassetid://72872074597412",
    	["water-bold"] = "rbxassetid://73765249018538",
    	["water-bold-duotone"] = "rbxassetid://100278754310756",
    	["water-broken"] = "rbxassetid://88153082122673",
    	["water-line-duotone"] = "rbxassetid://137477258501986",
    	["water-linear"] = "rbxassetid://86780670302331",
    	["water-outline"] = "rbxassetid://128425206745627",
    	["water-sun-bold"] = "rbxassetid://137004236197451",
    	["water-sun-bold-duotone"] = "rbxassetid://83938528363943",
    	["water-sun-broken"] = "rbxassetid://70398785201185",
    	["water-sun-line-duotone"] = "rbxassetid://85534146019511",
    	["water-sun-linear"] = "rbxassetid://89449584765437",
    	["water-sun-outline"] = "rbxassetid://140247398803451",
    	["waterdrop-bold"] = "rbxassetid://120397138191166",
    	["waterdrop-bold-duotone"] = "rbxassetid://110370559472118",
    	["waterdrop-broken"] = "rbxassetid://121737330075702",
    	["waterdrop-line-duotone"] = "rbxassetid://79600705095982",
    	["waterdrop-linear"] = "rbxassetid://129423854795584",
    	["waterdrop-outline"] = "rbxassetid://129870051714432",
    	["waterdrops-bold"] = "rbxassetid://111309368016355",
    	["waterdrops-bold-duotone"] = "rbxassetid://122046639761021",
    	["waterdrops-broken"] = "rbxassetid://84571304737012",
    	["waterdrops-line-duotone"] = "rbxassetid://109963629220116",
    	["waterdrops-linear"] = "rbxassetid://136908540877871",
    	["waterdrops-outline"] = "rbxassetid://106909732485711",
    	["weigher-bold"] = "rbxassetid://86709006687497",
    	["weigher-bold-duotone"] = "rbxassetid://119681202166152",
    	["weigher-broken"] = "rbxassetid://93263663025984",
    	["weigher-line-duotone"] = "rbxassetid://111255964741263",
    	["weigher-linear"] = "rbxassetid://92371104574941",
    	["weigher-outline"] = "rbxassetid://140231085650991",
    	["wheel-angle-bold"] = "rbxassetid://79409056509386",
    	["wheel-angle-linear"] = "rbxassetid://75490543515618",
    	["wheel-bold"] = "rbxassetid://82520002278171",
    	["wheel-linear"] = "rbxassetid://91063586222698",
    	["whisk-bold"] = "rbxassetid://127929087299925",
    	["whisk-bold-duotone"] = "rbxassetid://99460566460311",
    	["whisk-broken"] = "rbxassetid://120466034005461",
    	["whisk-line-duotone"] = "rbxassetid://84073472972588",
    	["whisk-linear"] = "rbxassetid://122370751029796",
    	["whisk-outline"] = "rbxassetid://131399130704207",
    	["wi-fi-router-bold"] = "rbxassetid://71817970702020",
    	["wi-fi-router-bold-duotone"] = "rbxassetid://103521899336661",
    	["wi-fi-router-broken"] = "rbxassetid://101196414616406",
    	["wi-fi-router-line-duotone"] = "rbxassetid://117148369145528",
    	["wi-fi-router-linear"] = "rbxassetid://78786944930000",
    	["wi-fi-router-minimalistic-bold"] = "rbxassetid://140564253402469",
    	["wi-fi-router-minimalistic-bold-duotone"] = "rbxassetid://136648600778594",
    	["wi-fi-router-minimalistic-broken"] = "rbxassetid://91077467264153",
    	["wi-fi-router-minimalistic-line-duotone"] = "rbxassetid://72399442191300",
    	["wi-fi-router-minimalistic-linear"] = "rbxassetid://90538940055131",
    	["wi-fi-router-minimalistic-outline"] = "rbxassetid://107849276247985",
    	["wi-fi-router-outline"] = "rbxassetid://86333264884584",
    	["wi-fi-router-round-bold"] = "rbxassetid://115295340179143",
    	["wi-fi-router-round-bold-duotone"] = "rbxassetid://132276822613820",
    	["wi-fi-router-round-broken"] = "rbxassetid://130863259391780",
    	["wi-fi-router-round-line-duotone"] = "rbxassetid://99034268077164",
    	["wi-fi-router-round-linear"] = "rbxassetid://72852413170944",
    	["wi-fi-router-round-outline"] = "rbxassetid://104291556074611",
    	["widget-2-bold"] = "rbxassetid://89625301483410",
    	["widget-2-bold-duotone"] = "rbxassetid://108894827515056",
    	["widget-2-broken"] = "rbxassetid://92112932142766",
    	["widget-2-line-duotone"] = "rbxassetid://75508971203857",
    	["widget-2-linear"] = "rbxassetid://78455934668293",
    	["widget-2-outline"] = "rbxassetid://126918335144929",
    	["widget-3-bold"] = "rbxassetid://82229378234667",
    	["widget-3-bold-duotone"] = "rbxassetid://71883883334500",
    	["widget-3-broken"] = "rbxassetid://108342700181302",
    	["widget-3-line-duotone"] = "rbxassetid://113551445207324",
    	["widget-3-linear"] = "rbxassetid://98236315646125",
    	["widget-3-outline"] = "rbxassetid://123740444392075",
    	["widget-4-bold"] = "rbxassetid://88900781944791",
    	["widget-4-bold-duotone"] = "rbxassetid://75627422856809",
    	["widget-4-broken"] = "rbxassetid://127462032165674",
    	["widget-4-line-duotone"] = "rbxassetid://100254533828912",
    	["widget-4-linear"] = "rbxassetid://118702908660610",
    	["widget-4-outline"] = "rbxassetid://84287595051384",
    	["widget-5-bold"] = "rbxassetid://136051733282290",
    	["widget-5-bold-duotone"] = "rbxassetid://102594598461859",
    	["widget-5-broken"] = "rbxassetid://117940898811065",
    	["widget-5-line-duotone"] = "rbxassetid://106361967518185",
    	["widget-5-linear"] = "rbxassetid://103737688891265",
    	["widget-5-outline"] = "rbxassetid://84610193092659",
    	["widget-6-bold"] = "rbxassetid://118797841936173",
    	["widget-6-bold-duotone"] = "rbxassetid://82395140422258",
    	["widget-6-broken"] = "rbxassetid://121210629871914",
    	["widget-6-line-duotone"] = "rbxassetid://102587206488038",
    	["widget-6-linear"] = "rbxassetid://101137762802528",
    	["widget-6-outline"] = "rbxassetid://125818162558098",
    	["widget-add-bold"] = "rbxassetid://91034149066074",
    	["widget-add-bold-duotone"] = "rbxassetid://132674517283884",
    	["widget-add-broken"] = "rbxassetid://79266297312712",
    	["widget-add-line-duotone"] = "rbxassetid://81878804183723",
    	["widget-add-linear"] = "rbxassetid://90109580358012",
    	["widget-add-outline"] = "rbxassetid://96931304201786",
    	["widget-bold"] = "rbxassetid://124133264580702",
    	["widget-bold-duotone"] = "rbxassetid://113313863011353",
    	["widget-broken"] = "rbxassetid://111687579139296",
    	["widget-line-duotone"] = "rbxassetid://78407622892607",
    	["widget-linear"] = "rbxassetid://120306885837046",
    	["widget-outline"] = "rbxassetid://128713196305729",
    	["win-rar-bold"] = "rbxassetid://72764770869567",
    	["win-rar-bold-duotone"] = "rbxassetid://81898149028230",
    	["win-rar-broken"] = "rbxassetid://81602672801690",
    	["win-rar-line-duotone"] = "rbxassetid://95562921004604",
    	["win-rar-linear"] = "rbxassetid://119534197171795",
    	["win-rar-outline"] = "rbxassetid://135460600962838",
    	["wind-bold"] = "rbxassetid://126825186378963",
    	["wind-bold-duotone"] = "rbxassetid://123124595712218",
    	["wind-broken"] = "rbxassetid://105192385007483",
    	["wind-line-duotone"] = "rbxassetid://95832327687016",
    	["wind-linear"] = "rbxassetid://140723089514831",
    	["wind-outline"] = "rbxassetid://73826871108702",
    	["window-frame-bold"] = "rbxassetid://87953247223226",
    	["window-frame-bold-duotone"] = "rbxassetid://136656182583503",
    	["window-frame-broken"] = "rbxassetid://132371969485027",
    	["window-frame-line-duotone"] = "rbxassetid://116684756413333",
    	["window-frame-linear"] = "rbxassetid://109735166346538",
    	["window-frame-outline"] = "rbxassetid://136409134084718",
    	["wineglass-bold"] = "rbxassetid://100205828816519",
    	["wineglass-bold-duotone"] = "rbxassetid://111106417656015",
    	["wineglass-broken"] = "rbxassetid://131411402458272",
    	["wineglass-line-duotone"] = "rbxassetid://79296850463469",
    	["wineglass-linear"] = "rbxassetid://75320883866546",
    	["wineglass-outline"] = "rbxassetid://83956416894234",
    	["wineglass-triangle-bold"] = "rbxassetid://128665733855452",
    	["wineglass-triangle-bold-duotone"] = "rbxassetid://107633780840209",
    	["wineglass-triangle-broken"] = "rbxassetid://121111578192602",
    	["wineglass-triangle-line-duotone"] = "rbxassetid://93791699407529",
    	["wineglass-triangle-linear"] = "rbxassetid://111101262329261",
    	["wineglass-triangle-outline"] = "rbxassetid://97306205416954",
    	["wireless-charge-bold"] = "rbxassetid://75123495054514",
    	["wireless-charge-bold-duotone"] = "rbxassetid://76365820491839",
    	["wireless-charge-broken"] = "rbxassetid://88111743452879",
    	["wireless-charge-line-duotone"] = "rbxassetid://130738036143727",
    	["wireless-charge-linear"] = "rbxassetid://121399981264689",
    	["wireless-charge-outline"] = "rbxassetid://126352549007419",
    	["women-bold"] = "rbxassetid://88280644952325",
    	["women-bold-duotone"] = "rbxassetid://91012014748221",
    	["women-broken"] = "rbxassetid://96290888112202",
    	["women-line-duotone"] = "rbxassetid://86273512645042",
    	["women-linear"] = "rbxassetid://122710671576038",
    	["women-outline"] = "rbxassetid://125358279731572",
    	["xxx-bold"] = "rbxassetid://123101921891699",
    	["xxx-bold-duotone"] = "rbxassetid://119177527019966",
    	["xxx-broken"] = "rbxassetid://136362261118048",
    	["xxx-line-duotone"] = "rbxassetid://87600524186909",
    	["xxx-linear"] = "rbxassetid://109899540005724",
    	["xxx-outline"] = "rbxassetid://75110190902317",
    	["zip-file-bold"] = "rbxassetid://99550940262109",
    	["zip-file-bold-duotone"] = "rbxassetid://113057201956711",
    	["zip-file-broken"] = "rbxassetid://99066569879211",
    	["zip-file-line-duotone"] = "rbxassetid://130242676531637",
    	["zip-file-linear"] = "rbxassetid://102428358345128",
    	["zip-file-outline"] = "rbxassetid://134842241804608",
    }

    return solarIcons
end)()

local Icons = {}
for name, id in pairs(defaultIcons) do Icons[name] = id end
for name, id in pairs(lucideIcons)  do Icons["lucide:" .. name] = id end
for name, id in pairs(solarIcons)   do Icons["solar:" .. name]  = id end

local function getIconId(iconName)
    if not iconName or iconName == "" then return "" end
    if iconName:match("^%d+$") then return "rbxassetid://" .. iconName end
    if Icons[iconName] then return Icons[iconName] end
    if iconName:match("^https?://") then return iconName end
    return ""
end

local function getColor(colorInput)
    if typeof(colorInput) == "Color3" then return colorInput end
    if type(colorInput) == "string" then
        if ColorModule[colorInput] then return ColorModule[colorInput] end
        return ColorModule["Default"] or Color3.fromRGB(0, 208, 255)
    end
    return ColorModule["Default"] or Color3.fromRGB(0, 208, 255)
end

local Elements = {}

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Mouse            = LocalPlayer:GetMouse()
local CoreGui          = game:GetService("CoreGui")
local viewport         = workspace.CurrentCamera.ViewportSize

local _NotifyInst = NotifyFactory(TweenService, CoreGui, getIconId, nil)

local function isMobileDevice()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
        and not UserInputService.MouseEnabled
end
local isMobile = isMobileDevice()

local function safeSize(pxWidth, pxHeight)
    local scaleX = pxWidth / viewport.X
    local scaleY = pxHeight / viewport.Y
    if isMobile then
        if scaleX > 0.5 then scaleX = 0.5 end
        if scaleY > 0.3 then scaleY = 0.3 end
    end
    return UDim2.new(scaleX, 0, scaleY, 0)
end

local function MakeDraggable(topbarobject, object, GuiConfig)
    local function CustomPos(topbarobject, object)
        local Dragging, DragInput, DragStart, StartPosition
        local function UpdatePos(input)
            local Delta = input.Position - DragStart
            local pos = UDim2.new(
                StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
            )
            TweenService:Create(object, TweenInfo.new(0.2), { Position = pos }):Play()
        end
        topbarobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then Dragging = false end
                end)
            end
        end)
        topbarobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then UpdatePos(input) end
        end)
    end

    local function CustomSize(object)
        local Dragging, DragInput, DragStart, StartSize
        local cfgW = (GuiConfig and GuiConfig.Size and GuiConfig.Size.X.Offset) or 640
        local cfgH = (GuiConfig and GuiConfig.Size and GuiConfig.Size.Y.Offset) or 400
        local minSizeX, minSizeY = 100, 100
        local defSizeX = isMobile and math.min(cfgW, 470) or cfgW
        local defSizeY = isMobile and math.min(cfgH, 270) or cfgH
        object.Size = UDim2.new(0, defSizeX, 0, defSizeY)

        local changesizeobject = Instance.new("Frame")
        changesizeobject.AnchorPoint = Vector2.new(1, 1)
        changesizeobject.BackgroundTransparency = 1
        changesizeobject.Size = UDim2.new(0, 40, 0, 40)
        changesizeobject.Position = UDim2.new(1, 20, 1, 20)
        changesizeobject.Name = "changesizeobject"
        changesizeobject.Parent = object

        local function UpdateSize(input)
            local Delta = input.Position - DragStart
            local nW = math.max(StartSize.X.Offset + Delta.X, minSizeX)
            local nH = math.max(StartSize.Y.Offset + Delta.Y, minSizeY)
            TweenService:Create(object, TweenInfo.new(0.2), { Size = UDim2.new(0, nW, 0, nH) }):Play()
        end
        changesizeobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true; DragStart = input.Position; StartSize = object.Size
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then Dragging = false end
                end)
            end
        end)
        changesizeobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then UpdateSize(input) end
        end)
    end

    CustomSize(object)
    CustomPos(topbarobject, object)
end

function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.9
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button
        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = Button.AbsoluteSize.X > Button.AbsoluteSize.Y
            and Button.AbsoluteSize.X * 1.5 or Button.AbsoluteSize.Y * 1.5
        local Time = 0.5
        Circle:TweenSizeAndPosition(
            UDim2.new(0, Size, 0, Size),
            UDim2.new(0.5, -Size/2, 0.5, -Size/2),
            "Out", "Quad", Time, false, nil
        )
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.01
            wait(Time / 10)
        end
        Circle:Destroy()
    end)
end

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   FLOATING COLOR PICKER                                         ║
-- ╚══════════════════════════════════════════════════════════════════╝
local _ColorpickerModule = nil
local function _InitColorpicker(AccentColor, MainDropShadow)
    if _ColorpickerModule then return end
    _ColorpickerModule = _ColorpickerSetup(
        TweenService, UserInputService, CoreGui,
        getIconId, {}, false, function() end, ElementsModule
    )
end

local function _MakeColorPicker(Config, SectionAdd, CountItem, AccentColor, MainDropShadow)
    _InitColorpicker(AccentColor, MainDropShadow)
    if not _ColorpickerModule then
        warn("[VelarisUI] Colorpicker.lua gagal dimuat")
        return {}
    end
    return _ColorpickerModule.MakeColorPicker(Config, SectionAdd, CountItem, AccentColor, MainDropShadow)
end

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   HELPER: BUAT KOLOM SCROLL (dipakai SubPage & MultiColumn)     ║
-- ╚══════════════════════════════════════════════════════════════════╝
local function _makeColumnScroll(parent, anchorX, posXScale, posXOffset, accentColor)
    local s = Instance.new("ScrollingFrame")
    s.BackgroundTransparency     = 1
    s.BorderSizePixel            = 0
    s.AnchorPoint                = Vector2.new(anchorX, 0)
    s.Position                   = UDim2.new(posXScale, posXOffset, 0, 4)
    s.Size                       = UDim2.new(0.5, -8, 1, -8)
    s.CanvasSize                 = UDim2.new(0, 0, 0, 0)
    s.AutomaticCanvasSize        = Enum.AutomaticSize.Y
    s.ScrollBarThickness         = 2
    s.ScrollBarImageColor3       = accentColor or Color3.fromRGB(80, 80, 90)
    s.ScrollBarImageTransparency = 0.4
    s.ZIndex                     = 4
    s.Parent                     = parent

    local ul = Instance.new("UIListLayout")
    ul.Padding   = UDim.new(0, 8)
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.Parent    = s

    local up = Instance.new("UIPadding")
    up.PaddingTop    = UDim.new(0, 4)
    up.PaddingBottom = UDim.new(0, 10)
    up.PaddingLeft   = UDim.new(0, 3)
    up.PaddingRight  = UDim.new(0, 3)
    up.Parent        = s

    return s
end

local Chloex = {}

function Chloex:MakeNotify(NotifyConfig)
    return _NotifyInst:MakeNotify(NotifyConfig)
end

function Nt(msg, delay, color, title, desc)
    return _NotifyInst:Nt(msg, delay, color, title, desc)
end
Notify = Nt

function Chloex:Dialog(DialogConfig)
    return DialogModule(DialogConfig)
end

function Chloex:Window(GuiConfig)
    GuiConfig               = GuiConfig or {}
    GuiConfig.Title         = GuiConfig.Title or "Chloe X"
    GuiConfig.Footer        = GuiConfig.Footer or "Chloee :3"
    GuiConfig.Content       = GuiConfig.Content or ""
    GuiConfig.ShowUser      = GuiConfig.ShowUser or false
    GuiConfig.Color         = getColor(GuiConfig.Color or "Default")
    GuiConfig["Tab Width"]  = GuiConfig["Tab Width"] or 120
    GuiConfig.Uitransparent = GuiConfig.Uitransparent or 0.15
    GuiConfig.Image         = GuiConfig.Image or "70884221600423"
    GuiConfig.Icon          = GuiConfig.Icon or "rbxassetid://103875081318049"
    GuiConfig.Size          = GuiConfig.Size or UDim2.fromOffset(640, 400)
    GuiConfig.Search        = GuiConfig.Search ~= nil and GuiConfig.Search or false
    GuiConfig.Version       = GuiConfig.Version or "1.0"
    GuiConfig.Config        = GuiConfig.Config or {}
    GuiConfig.Config.ConfigFolder = GuiConfig.Config.ConfigFolder or "VelarisUI/Config/"
    GuiConfig.Config.AutoSaveFile = GuiConfig.Config.AutoSaveFile or "Default"
    GuiConfig.Config.AutoSave     = GuiConfig.Config.AutoSave ~= nil and GuiConfig.Config.AutoSave or false
    GuiConfig.Config.AutoLoad     = GuiConfig.Config.AutoLoad ~= nil and GuiConfig.Config.AutoLoad or false

    GuiConfig.DiscordSet        = GuiConfig.DiscordSet or {}
    GuiConfig.DiscordSet.Enable = GuiConfig.DiscordSet.Enable ~= nil and GuiConfig.DiscordSet.Enable or false
    GuiConfig.DiscordSet.Title  = GuiConfig.DiscordSet.Title or "DISCORD"
    GuiConfig.DiscordSet.Link   = GuiConfig.DiscordSet.Link or ""
    GuiConfig.DiscordSet.Icon   = GuiConfig.DiscordSet.Icon or ""

    ElementsModule:Initialize(GuiConfig, function() end, {}, Icons)

    local ks = GuiConfig.KeySystem
    if ks then
        local ok, result = pcall(function()
            return loadUrl("https://fitri324.pythonanywhere.com/KeySystemUi.lua/raw")
        end)
        if not ok or type(result) ~= "function" then
            warn("[VelarisUI] KeySystem gagal dimuat")
        else
            local ok2, resolved = pcall(result, ks, GuiConfig, CoreGui, TweenService, getIconId)
            if not ok2 then
                warn("[VelarisUI] KeySystem error: " .. tostring(resolved))
            elseif not resolved then
                while true do task.wait(9999) end
            end
        end
    end

    local GuiFunc = {}

    -- ══════════════════════════════════════════════════════════════
    -- Config System
    -- ══════════════════════════════════════════════════════════════
    local _ConfigData     = {}
    local _ConfigElements = {}
    local _cfgFolder      = GuiConfig.Config.ConfigFolder

    local function _checkFolders()
        pcall(function()
            local parts = _cfgFolder:split("/")
            local path = ""
            for _, p in ipairs(parts) do
                if p ~= "" then
                    path = path == "" and p or (path .. "/" .. p)
                    if not isfolder(path) then makefolder(path) end
                end
            end
        end)
    end

    local function _cfgFile(name)
        return _cfgFolder .. (name or "Default") .. ".json"
    end

    function GuiFunc:SaveConfig(name)
        if not writefile then warn("[VelarisUI] writefile tidak tersedia") return false end
        _checkFolders()
        _ConfigData._version = GuiConfig.Version
        local ok, err = pcall(function()
            writefile(_cfgFile(name), HttpService:JSONEncode(_ConfigData))
        end)
        if not ok then warn("[VelarisUI] SaveConfig error:", err) end
        return ok
    end

    function GuiFunc:LoadConfig(name)
        if not isfile or not readfile then warn("[VelarisUI] isfile/readfile tidak tersedia") return false end
        _checkFolders()
        local f = _cfgFile(name)
        if not isfile(f) then return false end
        local ok, result = pcall(function() return HttpService:JSONDecode(readfile(f)) end)
        if not (ok and type(result) == "table") then return false end
        _ConfigData = result
        for key, elem in pairs(_ConfigElements) do
            local val = _ConfigData[key]
            if val ~= nil and elem.Set then pcall(function() elem:Set(val) end) end
        end
        return true
    end

    function GuiFunc:DeleteConfig(name)
        if not isfile or not delfile then return false end
        local f = _cfgFile(name)
        if isfile(f) then pcall(delfile, f) return true end
        return false
    end

    function GuiFunc:ListConfigs()
        local list = {}
        if not listfiles then return list end
        _checkFolders()
        local ok, files = pcall(listfiles, _cfgFolder)
        if not ok then return list end
        for _, path in ipairs(files) do
            local name = path:match("([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
        return list
    end

    function GuiFunc:ResetConfig(name)
        _ConfigData = {}
        for key, elem in pairs(_ConfigElements) do
            if elem.Set then
                if elem.Type == "Toggle" then pcall(function() elem:Set(false) end)
                elseif elem.Type == "Slider" then pcall(function() elem:Set(elem.Default or 0) end)
                elseif elem.Type == "Dropdown" then pcall(function() elem:Set(elem.Default or (elem.Multi and {} or nil)) end)
                elseif elem.Type == "Input" then pcall(function() elem:Set("") end)
                end
            end
        end
        if name then GuiFunc:DeleteConfig(name) end
    end

    GuiFunc.ConfigData     = _ConfigData
    GuiFunc.ConfigElements = _ConfigElements

    -- ══════════════════════════════════════════════════════════════
    -- GUI UTAMA
    -- ══════════════════════════════════════════════════════════════
    local Chloeex           = Instance.new("ScreenGui")
    local DropShadowHolder  = Instance.new("Frame")
    local DropShadow        = Instance.new("ImageLabel")
    local Main              = Instance.new("Frame")
    local UICorner          = Instance.new("UICorner")
    local MainStroke        = Instance.new("UIStroke")
    local Top               = Instance.new("Frame")
    local TitleIcon         = Instance.new("ImageLabel")
    local TextLabel         = Instance.new("TextLabel")
    local UICorner1         = Instance.new("UICorner")
    local TextLabel1        = Instance.new("TextLabel")
    local Close             = Instance.new("TextButton")
    local ImageLabel1       = Instance.new("ImageLabel")
    local Min               = Instance.new("TextButton")
    local ImageLabel2       = Instance.new("ImageLabel")

    Chloeex.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Chloeex.Name = "VelarisUI"
    Chloeex.ResetOnSpawn = false
    Chloeex.Parent = game:GetService("CoreGui")

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)

    local baseW = GuiConfig.Size.X.Offset
    local baseH = GuiConfig.Size.Y.Offset
    if isMobile then
        DropShadowHolder.Size = safeSize(math.min(baseW, 470), math.min(baseH, 270))
    else
        DropShadowHolder.Size = safeSize(baseW, baseH)
    end

    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = Chloeex

    DropShadowHolder.Position = UDim2.new(
        0, (Chloeex.AbsoluteSize.X // 2 - DropShadowHolder.Size.X.Offset // 2),
        0, (Chloeex.AbsoluteSize.Y // 2 - DropShadowHolder.Size.Y.Offset // 2)
    )

    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    DropShadow.ImageTransparency = 1
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder

    if GuiConfig.Theme then
        Main:Destroy()
        Main = Instance.new("ImageLabel")
        Main.Image = "rbxassetid://" .. GuiConfig.Theme
        Main.ScaleType = Enum.ScaleType.Crop
        Main.BackgroundTransparency = 1
        Main.ImageTransparency = GuiConfig.ThemeTransparency or GuiConfig.Uitransparent or 0.15
    else
        Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Main.BackgroundTransparency = GuiConfig.Uitransparent
    end

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow

    MainStroke.Thickness = 1.2
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.6
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = Main

    UICorner.Parent = Main

    local ColorTint = Instance.new("Frame")
    ColorTint.Name = "ColorTint"
    ColorTint.Size = UDim2.new(1, 0, 1, 0)
    ColorTint.BackgroundColor3 = GuiConfig.Color
    ColorTint.BackgroundTransparency = 0.93
    ColorTint.BorderSizePixel = 0
    ColorTint.ZIndex = 0

    local ImageWrapper = Instance.new("Frame")
    ImageWrapper.Name = "ImageWrapper"
    ImageWrapper.Parent = Main
    ImageWrapper.BackgroundTransparency = 1
    ImageWrapper.Size = UDim2.new(1, 0, 1, 0)
    ImageWrapper.Position = UDim2.new(0, 0, 0, 0)
    ImageWrapper.ZIndex = 0
    ImageWrapper.ClipsDescendants = true
    ColorTint.Parent = Main

    local ThemeImage = Instance.new("ImageLabel")
    ThemeImage.Name = "ThemeImage"
    ThemeImage.Parent = ImageWrapper
    ThemeImage.BackgroundTransparency = 1
    ThemeImage.AnchorPoint = Vector2.new(1, 1)
    ThemeImage.Position = UDim2.new(1, 0, 1, 0)
    ThemeImage.Size = UDim2.new(0.55, 0, 1.0, 0)
    ThemeImage.ZIndex = 0
    ThemeImage.Image = ""
    ThemeImage.ImageTransparency = 1
    ThemeImage.ScaleType = Enum.ScaleType.Fit

    local ThemeGradient = Instance.new("UIGradient")
    ThemeGradient.Rotation = 135
    ThemeGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.45, 0.8),
        NumberSequenceKeypoint.new(0.75, 0.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    ThemeGradient.Parent = ThemeImage

    -- Background Video
    if GuiConfig.BackgroundVideo and GuiConfig.BackgroundVideo ~= "" then
        task.spawn(function()
            local videoInput = GuiConfig.BackgroundVideo
            local videoId = nil
            local isAssetId = videoInput:match("^%d+$") or videoInput:match("^rbxassetid://")
            if isAssetId then
                videoId = videoInput:match("^%d+$") and ("rbxassetid://" .. videoInput) or videoInput
            else
                local fileName = "VelarisUI_bgvideo.webm"
                if writefile and getcustomasset and isfile then
                    if not isfile(fileName) then
                        local ok = pcall(function() writefile(fileName, game:HttpGet(videoInput)) end)
                        if not ok then return end
                    end
                    local ok2, id = pcall(getcustomasset, fileName)
                    if ok2 and id then videoId = id else return end
                else
                    warn("[VelarisUI] BackgroundVideo: writefile/getcustomasset tidak tersedia")
                    return
                end
            end
            local VideoWrapper = Instance.new("Frame")
            VideoWrapper.Name = "VideoWrapper"
            VideoWrapper.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            VideoWrapper.BackgroundTransparency = 0
            VideoWrapper.BorderSizePixel = 0
            VideoWrapper.Size = UDim2.fromScale(1, 1)
            VideoWrapper.Position = UDim2.fromScale(0, 0)
            VideoWrapper.ZIndex = 0
            VideoWrapper.ClipsDescendants = true
            VideoWrapper.Parent = Main
            Instance.new("UICorner", VideoWrapper).CornerRadius = UDim.new(0, 8)

            local BgVideo = Instance.new("VideoFrame")
            BgVideo.Name = "BackgroundVideo"
            BgVideo.Video = videoId
            BgVideo.Looped = true
            BgVideo.Volume = 0
            BgVideo.BackgroundTransparency = 1
            BgVideo.BorderSizePixel = 0
            BgVideo.Size = UDim2.fromScale(1, 1)
            BgVideo.ZIndex = 0
            BgVideo.Parent = VideoWrapper

            local VideoOverlay = Instance.new("Frame")
            VideoOverlay.Name = "VideoOverlay"
            VideoOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            VideoOverlay.BackgroundTransparency = GuiConfig.BackgroundVideoOverlay or 0.4
            VideoOverlay.BorderSizePixel = 0
            VideoOverlay.Size = UDim2.fromScale(1, 1)
            VideoOverlay.ZIndex = 0
            VideoOverlay.Parent = VideoWrapper

            BgVideo.Loaded:Connect(function() BgVideo:Play() end)

            function GuiFunc:SetBackgroundVideoVolume(Vol) BgVideo.Volume = math.clamp(Vol, 0, 10) end
            function GuiFunc:PauseBackgroundVideo() BgVideo:Pause() end
            function GuiFunc:PlayBackgroundVideo() BgVideo:Play() end
            function GuiFunc:SetBackgroundVideoOverlay(Trans) VideoOverlay.BackgroundTransparency = math.clamp(Trans, 0, 1) end
        end)
    end

    Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Top.BackgroundTransparency = 0.999
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main

    TitleIcon.Name = "TitleIcon"
    TitleIcon.Parent = Top
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.BorderSizePixel = 0
    TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
    TitleIcon.Position = UDim2.new(0, 10, 0.5, 0)
    TitleIcon.Size = UDim2.new(0, 20, 0, 20)
    TitleIcon.Image = "rbxassetid://" .. GuiConfig.Image

    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = ""
    TextLabel.TextColor3 = GuiConfig.Color
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.999
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, -135, 1, 0)
    TextLabel.Position = UDim2.new(0, 35, 0, 0)
    TextLabel.Parent = Top

    UICorner1.Parent = Top

    TextLabel1.Font = Enum.Font.GothamBold
    TextLabel1.Text = ""
    TextLabel1.TextColor3 = GuiConfig.Color
    TextLabel1.TextSize = 14
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel1.BackgroundTransparency = 0.999
    TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel1.BorderSizePixel = 0
    TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
    TextLabel1.Position = UDim2.new(0, 25 + TextLabel.TextBounds.X + 10, 0, 0)
    TextLabel1.Parent = Top

    if GuiConfig.Animation then
        TextLabel1.Visible = false
        task.spawn(function()
            local function typeOut(text, charDelay)
                TextLabel.Text = ""
                for i = 1, #text do TextLabel.Text = string.sub(text, 1, i) task.wait(charDelay) end
            end
            local function typeErase(charDelay)
                local current = TextLabel.Text
                for i = #current, 1, -1 do TextLabel.Text = string.sub(current, 1, i-1) task.wait(charDelay) end
                TextLabel.Text = ""
            end
            local titleText  = GuiConfig.Title
            local footerText = GuiConfig.Footer
            local charDelay  = GuiConfig.TypeDelay or 0.07
            local pauseTime  = GuiConfig.TypePause or 2.5
            while true do
                typeOut(titleText, charDelay) task.wait(pauseTime)
                typeErase(charDelay) task.wait(0.15)
                typeOut(footerText, charDelay) task.wait(pauseTime)
                typeErase(charDelay) task.wait(0.15)
            end
        end)
    else
        TextLabel.Text  = GuiConfig.Title
        TextLabel1.Text = GuiConfig.Footer
    end

    local TagContainer = Instance.new("Frame")
    TagContainer.Name = "TagContainer"
    TagContainer.BackgroundTransparency = 1
    TagContainer.BorderSizePixel = 0
    TagContainer.ClipsDescendants = false
    TagContainer.AnchorPoint = Vector2.new(1, 0.5)
    TagContainer.Position = UDim2.new(1, -70, 0.5, 0)
    TagContainer.Size = UDim2.new(0, 200, 0, 26)
    TagContainer.ZIndex = 2
    TagContainer.Parent = Top

    local TagListLayout = Instance.new("UIListLayout")
    TagListLayout.FillDirection = Enum.FillDirection.Horizontal
    TagListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    TagListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TagListLayout.Padding = UDim.new(0, 5)
    TagListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TagListLayout.Parent = TagContainer

    local function UpdateTagPosition()
        local titleW  = TextLabel.TextBounds.X
        local footerW = TextLabel1.TextBounds.X
        local textEnd = 35 + titleW + 10 + footerW + 10
        local rightBound = -70
        local availableW = Top.AbsoluteSize.X + rightBound - textEnd
        if availableW < 0 then availableW = 0 end
        TagContainer.Size = UDim2.new(0, math.min(availableW, 300), 0, 26)
        TagContainer.Position = UDim2.new(1, rightBound, 0.5, 0)
    end

    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateTagPosition)
    TextLabel1:GetPropertyChangedSignal("TextBounds"):Connect(UpdateTagPosition)
    Top:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTagPosition)
    UpdateTagPosition()

    local function UpdateFooterPosition()
        local titleWidth = TextLabel.TextBounds.X
        TextLabel1.Position = UDim2.new(0, 25 + titleWidth + 10, 0, 0)
        TextLabel1.Size = UDim2.new(1, -(titleWidth + 104), 1, 0)
        UpdateTagPosition()
    end
    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateFooterPosition)
    UpdateFooterPosition()

    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(0, 0, 0)
    Close.TextSize = 14
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 0.999
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Name = "Close"
    Close.Parent = Top

    ImageLabel1.Image = "rbxassetid://9886659671"
    ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel1.BackgroundTransparency = 0.999
    ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel1.BorderSizePixel = 0
    ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
    ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
    ImageLabel1.Parent = Close

    Min.Font = Enum.Font.SourceSans
    Min.Text = ""
    Min.TextColor3 = Color3.fromRGB(0, 0, 0)
    Min.TextSize = 14
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Min.BackgroundTransparency = 0.999
    Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Min.BorderSizePixel = 0
    Min.Position = UDim2.new(1, -38, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)
    Min.Name = "Min"
    Min.Parent = Top

    ImageLabel2.Image = "rbxassetid://9886659276"
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel2.BackgroundTransparency = 0.999
    ImageLabel2.ImageTransparency = 0.2
    ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel2.Parent = Min

    if GuiConfig.Content and GuiConfig.Content ~= "" then
        local ContentFrame = Instance.new("Frame")
        ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Size = UDim2.new(1, 0, 0, 25)
        ContentFrame.Position = UDim2.new(0, 0, 0, 38)
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Parent = Main

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Font = Enum.Font.GothamBold
        ContentLabel.Text = GuiConfig.Content
        ContentLabel.TextColor3 = GuiConfig.Color
        ContentLabel.TextSize = 14
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Center
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Center
        ContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentLabel.BorderSizePixel = 0
        ContentLabel.Size = UDim2.new(1, -20, 1, 0)
        ContentLabel.Position = UDim2.new(0, 10, 0, 0)
        ContentLabel.Parent = ContentFrame

        local Divider = Instance.new("Frame")
        Divider.BackgroundColor3 = GuiConfig.Color
        Divider.BackgroundTransparency = 0.8
        Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Divider.BorderSizePixel = 0
        Divider.Size = UDim2.new(1, -20, 0, 1)
        Divider.Position = UDim2.new(0, 10, 1, -1)
        Divider.Parent = ContentFrame
    end

    local LayersTab        = Instance.new("Frame")
    local UICorner2        = Instance.new("UICorner")
    local DecideFrame      = Instance.new("Frame")
    local Layers           = Instance.new("Frame")
    local UICorner6        = Instance.new("UICorner")
    local NameTab          = Instance.new("TextLabel")
    local LayersReal       = Instance.new("Frame")
    local LayersFolder     = Instance.new("Folder")
    local LayersPageLayout = Instance.new("UIPageLayout")

    local topOffset = (GuiConfig.Content and GuiConfig.Content ~= "") and (38 + 25 + 10) or 50

    LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersTab.BackgroundTransparency = 0.999
    LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersTab.BorderSizePixel = 0
    LayersTab.Position = UDim2.new(0, 9, 0, topOffset)
    LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -(topOffset + 9))
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main

    UICorner2.CornerRadius = UDim.new(0, 2)
    UICorner2.Parent = LayersTab

    local ScrollTab    = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    ScrollTab.CanvasSize = UDim2.new(0, 0, 1.1, 0)
    ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Active = true
    ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollTab.BackgroundTransparency = 0.999
    ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.BorderSizePixel = 0
    ScrollTab.Name = "ScrollTab"

    local searchOffset = 0
    if GuiConfig.Search then
        searchOffset = 34
        SearchModule(GuiConfig, LayersTab, LayersFolder, LayersPageLayout, TweenService, searchOffset)
    end

    -- Discord Button
    local ds = GuiConfig.DiscordSet
    local DISCORD_H      = 28
    local DISCORD_MARGIN = 3
    local discordBottomOffset = ds.Enable and ds.Link ~= "" and (DISCORD_H + DISCORD_MARGIN + 2) or 0

    if ds.Enable and ds.Link ~= "" then
        local resolvedIcon = getIconId(ds.Icon)
        if resolvedIcon == "" then resolvedIcon = "rbxassetid://7072725342" end

        local DiscordCard = Instance.new("TextButton")
        DiscordCard.Name = "DiscordCard"
        DiscordCard.AnchorPoint = Vector2.new(0, 1)
        DiscordCard.Position = UDim2.new(0, 3, 1, -DISCORD_MARGIN)
        DiscordCard.Size = UDim2.new(1, -18, 0, DISCORD_H)
        DiscordCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        DiscordCard.BackgroundTransparency = 0
        DiscordCard.BorderSizePixel = 0
        DiscordCard.ClipsDescendants = false
        DiscordCard.ZIndex = 100
        DiscordCard.Text = ""
        DiscordCard.Parent = LayersTab
        Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 5)

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = GuiConfig.Color
        CardStroke.Thickness = 0.8
        CardStroke.Transparency = 0.5
        CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        CardStroke.Parent = DiscordCard

        task.spawn(function()
            local t = 0
            while DiscordCard and DiscordCard.Parent do
                local dt = task.wait(0.04)
                t = t + dt
                local pulse = (math.sin(t * 1.5) + 1) / 2
                CardStroke.Transparency = 0.2 + pulse * 0.55
            end
        end)

        local DIcon = Instance.new("ImageLabel")
        DIcon.BackgroundTransparency = 1
        DIcon.AnchorPoint = Vector2.new(0, 0.5)
        DIcon.Position = UDim2.new(0, 5, 0.5, 0)
        DIcon.Size = UDim2.new(0, 18, 0, 18)
        DIcon.Image = resolvedIcon
        DIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        DIcon.ScaleType = Enum.ScaleType.Fit
        DIcon.ZIndex = 101
        DIcon.Parent = DiscordCard

        local DTitle = Instance.new("TextLabel")
        DTitle.Font = Enum.Font.GothamBold
        DTitle.Text = string.upper(ds.Title)
        DTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        DTitle.TextSize = 10
        DTitle.TextXAlignment = Enum.TextXAlignment.Left
        DTitle.BackgroundTransparency = 1
        DTitle.AnchorPoint = Vector2.new(0, 1)
        DTitle.Position = UDim2.new(0, 28, 0.5, -1)
        DTitle.Size = UDim2.new(1, -32, 0, 11)
        DTitle.ZIndex = 101
        DTitle.Parent = DiscordCard

        local DSub = Instance.new("TextLabel")
        DSub.Font = Enum.Font.GothamBold
        DSub.Text = "JOIN DISCORD"
        DSub.TextColor3 = Color3.fromRGB(30, 200, 255)
        DSub.TextSize = 8
        DSub.TextXAlignment = Enum.TextXAlignment.Left
        DSub.BackgroundTransparency = 1
        DSub.AnchorPoint = Vector2.new(0, 0)
        DSub.Position = UDim2.new(0, 28, 0.5, 1)
        DSub.Size = UDim2.new(1, -32, 0, 10)
        DSub.ZIndex = 101
        DSub.Parent = DiscordCard

        local GradTitle = Instance.new("UIGradient")
        GradTitle.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255)),
        })
        GradTitle.Rotation = 0
        GradTitle.Offset = Vector2.new(-1, 0)
        GradTitle.Parent = DTitle

        task.spawn(function()
            local dir, pos, speed = 1, -1.0, 0.8
            while DiscordCard and DiscordCard.Parent do
                local dt = task.wait(0.03)
                pos = pos + speed * dir * dt
                if pos >= 1.0 then pos = 1.0; dir = -1
                elseif pos <= -1.0 then pos = -1.0; dir = 1 end
                GradTitle.Offset = Vector2.new(pos, 0)
            end
        end)

        local _copied = false
        DiscordCard.Activated:Connect(function()
            if _copied then return end
            _copied = true
            pcall(function() setclipboard(ds.Link) end)
            local origText, origColor = DSub.Text, DSub.TextColor3
            DSub.Text = "LINK COPIED!"
            DSub.TextColor3 = Color3.fromRGB(180, 180, 180)
            task.wait(1.5)
            DSub.Text = origText
            DSub.TextColor3 = origColor
            _copied = false
        end)
    end

    if GuiConfig.ShowUser then
        ScrollTab.Position = UDim2.new(0, 0, 0, searchOffset)
        ScrollTab.Size = UDim2.new(1, 0, 1, -(40 + searchOffset + discordBottomOffset))
    else
        ScrollTab.Position = UDim2.new(0, 0, 0, searchOffset)
        ScrollTab.Size = UDim2.new(1, 0, 1, -(searchOffset + discordBottomOffset))
    end
    ScrollTab.Parent = LayersTab

    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollTab

    local function UpdateSize1()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child.Name ~= "UIListLayout" then
                OffsetY = OffsetY + 3 + child.Size.Y.Offset
            end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    ScrollTab.ChildAdded:Connect(UpdateSize1)
    ScrollTab.ChildRemoved:Connect(UpdateSize1)

    if GuiConfig.ShowUser then
        local pfOffsetY = -(3 + discordBottomOffset)
        local PlayerFooter = Instance.new("Frame")
        PlayerFooter.Name = "PlayerFooter"
        PlayerFooter.AnchorPoint = Vector2.new(0, 1)
        PlayerFooter.BackgroundTransparency = 1
        PlayerFooter.BorderSizePixel = 0
        PlayerFooter.Position = UDim2.new(0, 3, 1, pfOffsetY)
        PlayerFooter.Size = UDim2.new(1, -18, 0, 40)
        PlayerFooter.Parent = LayersTab
        PlayerFooter.ZIndex = 100

        local PlayerAvatar = Instance.new("ImageLabel")
        PlayerAvatar.Name = "PlayerAvatar"
        PlayerAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        PlayerAvatar.BackgroundTransparency = 0.2
        PlayerAvatar.BorderSizePixel = 0
        PlayerAvatar.AnchorPoint = Vector2.new(0, 0.5)
        PlayerAvatar.Position = UDim2.new(0, 0, 0.5, 2)
        PlayerAvatar.Size = UDim2.new(0, 26, 0, 26)
        PlayerAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
        PlayerAvatar.Parent = PlayerFooter
        Instance.new("UICorner", PlayerAvatar).CornerRadius = UDim.new(1, 0)

        local AvatarStroke = Instance.new("UIStroke")
        AvatarStroke.Color = GuiConfig.Color
        AvatarStroke.Thickness = 1.2
        AvatarStroke.Transparency = 0.5
        AvatarStroke.Parent = PlayerAvatar

        local PlayerName = Instance.new("TextLabel")
        PlayerName.Name = "PlayerName"
        PlayerName.Font = Enum.Font.GothamBold
        local displayName = LocalPlayer.DisplayName
        local shortName = #displayName > 3 and (string.sub(displayName, 1, 3) .. "***") or displayName
        PlayerName.Text = "Welcome, " .. shortName
        PlayerName.TextColor3 = Color3.fromRGB(180, 180, 180)
        PlayerName.TextSize = 11
        PlayerName.TextXAlignment = Enum.TextXAlignment.Left
        PlayerName.BackgroundTransparency = 1
        PlayerName.Position = UDim2.new(0, 32, 0, 0)
        PlayerName.Size = UDim2.new(1, -32, 1, 0)
        PlayerName.TextTruncate = Enum.TextTruncate.None
        PlayerName.Parent = PlayerFooter
    end

    _G.ScrollTab = ScrollTab

    DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
    DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DecideFrame.BackgroundTransparency = 0.85
    DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DecideFrame.BorderSizePixel = 0
    DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
    DecideFrame.Size = UDim2.new(1, 0, 0, 1)
    DecideFrame.Name = "DecideFrame"
    DecideFrame.Parent = Main

    Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Layers.BackgroundTransparency = 0.999
    Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, topOffset)
    Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -(topOffset + 9))
    Layers.Name = "Layers"
    Layers.Parent = Main

    UICorner6.CornerRadius = UDim.new(0, 2)
    UICorner6.Parent = Layers

    NameTab.Font = Enum.Font.GothamBold
    NameTab.Text = ""
    NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.TextSize = 24
    NameTab.TextWrapped = true
    NameTab.TextXAlignment = Enum.TextXAlignment.Left
    NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.BackgroundTransparency = 0.999
    NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NameTab.BorderSizePixel = 0
    NameTab.Size = UDim2.new(1, 0, 0, 30)
    NameTab.Name = "NameTab"
    NameTab.Parent = Layers

    LayersReal.AnchorPoint = Vector2.new(0, 1)
    LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersReal.BackgroundTransparency = 0.999
    LayersReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersReal.BorderSizePixel = 0
    LayersReal.ClipsDescendants = true
    LayersReal.Position = UDim2.new(0, 0, 1, 0)
    LayersReal.Size = UDim2.new(1, 0, 1, -33)
    LayersReal.Name = "LayersReal"
    LayersReal.Parent = Layers

    LayersFolder.Name = "LayersFolder"
    LayersFolder.Parent = LayersReal

    LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name = "LayersPageLayout"
    LayersPageLayout.Parent = LayersFolder
    LayersPageLayout.TweenTime = 0.5
    LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

    function GuiFunc:DestroyGui()
        if CoreGui:FindFirstChild("VelarisUI") then Chloeex:Destroy() end
    end

    function GuiFunc:SetToggleKey(keyCode)
        GuiConfig.Keybind = keyCode
    end

    -- ══════════════════════════════════════════════════════════════
    -- ✦ FITUR BARU 1: SEPARATOR
    -- ══════════════════════════════════════════════════════════════
    function GuiFunc:Separator()
        local line = Instance.new("Frame")
        line.Name                   = "Separator"
        line.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.82
        line.BorderSizePixel        = 0
        line.Size                   = UDim2.new(1, -14, 0, 1)
        line.Parent                 = ScrollTab

        local grad = Instance.new("UIGradient")
        grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.2, 0),
            NumberSequenceKeypoint.new(0.8, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
        grad.Parent = line
        return line
    end

    function GuiFunc:Tag(TagConfig)
        TagConfig = TagConfig or {}
        TagConfig.Title = TagConfig.Title or "Tag"
        TagConfig.Icon  = TagConfig.Icon or ""

        local function resolveColor(c)
            if typeof(c) == "Color3" then return c
            elseif type(c) == "string" then
                if c:sub(1,1) == "#" then return Color3.fromHex(c)
                else return getColor(c) end
            end
            return GuiConfig.Color
        end

        local tagColor = resolveColor(TagConfig.Color)
        local TagFrame = Instance.new("Frame")
        TagFrame.BackgroundColor3 = tagColor
        TagFrame.BackgroundTransparency = 0
        TagFrame.BorderSizePixel = 0
        TagFrame.AutomaticSize = Enum.AutomaticSize.X
        TagFrame.Size = UDim2.new(0, 0, 0, 22)
        TagFrame.Name = "Tag"
        TagFrame.ClipsDescendants = false
        TagFrame.Parent = TagContainer

        Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(1, 0)

        local TagStroke = Instance.new("UIStroke")
        TagStroke.Color = tagColor
        TagStroke.Thickness = 1.5
        TagStroke.Transparency = 0.4
        TagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        TagStroke.Parent = TagFrame

        local TagPadding = Instance.new("UIPadding")
        TagPadding.PaddingLeft = UDim.new(0, 8)
        TagPadding.PaddingRight = UDim.new(0, 8)
        TagPadding.Parent = TagFrame

        local TagInner = Instance.new("Frame")
        TagInner.BackgroundTransparency = 1
        TagInner.BorderSizePixel = 0
        TagInner.AutomaticSize = Enum.AutomaticSize.X
        TagInner.Size = UDim2.new(0, 0, 1, 0)
        TagInner.Parent = TagFrame

        local TagInnerList = Instance.new("UIListLayout")
        TagInnerList.FillDirection = Enum.FillDirection.Horizontal
        TagInnerList.VerticalAlignment = Enum.VerticalAlignment.Center
        TagInnerList.Padding = UDim.new(0, 4)
        TagInnerList.Parent = TagInner

        local TagIcon = Instance.new("ImageLabel")
        TagIcon.BackgroundTransparency = 1
        TagIcon.BorderSizePixel = 0
        TagIcon.Size = UDim2.new(0, 12, 0, 12)
        TagIcon.ImageColor3 = Color3.fromRGB(15, 15, 15)
        TagIcon.ScaleType = Enum.ScaleType.Fit
        TagIcon.LayoutOrder = 0
        TagIcon.Parent = TagInner

        local function applyIcon(iconName)
            local id = getIconId(iconName or "")
            TagIcon.Image = id
            TagIcon.Visible = (id ~= "")
        end
        applyIcon(TagConfig.Icon)

        local TagLabel = Instance.new("TextLabel")
        TagLabel.Font = Enum.Font.GothamBold
        TagLabel.Text = TagConfig.Title
        TagLabel.TextColor3 = Color3.fromRGB(15, 15, 15)
        TagLabel.TextSize = 11
        TagLabel.BackgroundTransparency = 1
        TagLabel.BorderSizePixel = 0
        TagLabel.AutomaticSize = Enum.AutomaticSize.X
        TagLabel.Size = UDim2.new(0, 0, 1, 0)
        TagLabel.LayoutOrder = 1
        TagLabel.Parent = TagInner

        task.defer(UpdateTagPosition)

        local TagApi = {}
        function TagApi:SetTitle(newTitle) TagLabel.Text = tostring(newTitle or "") task.defer(UpdateTagPosition) end
        function TagApi:SetIcon(iconName) applyIcon(iconName) task.defer(UpdateTagPosition) end
        function TagApi:SetColor(colorInput)
            local newColor = resolveColor(colorInput)
            TweenService:Create(TagFrame, TweenInfo.new(0.2), { BackgroundColor3 = newColor }):Play()
            TweenService:Create(TagStroke, TweenInfo.new(0.2), { Color = newColor }):Play()
        end
        function TagApi:Destroy() TagFrame:Destroy() task.defer(UpdateTagPosition) end
        TagApi.Frame = TagFrame
        return TagApi
    end

    local _lastPos = nil
    local function AnimateClose(callback)
        _lastPos = DropShadowHolder.Position
        DropShadowHolder.Visible = false
        if callback then callback() end
    end
    local function AnimateOpen()
        if _lastPos then DropShadowHolder.Position = _lastPos end
        DropShadowHolder.Visible = true
    end

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        AnimateClose()
    end)

    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        Chloex:Dialog({
            Title = "Window",
            Content = "Do you want to close this window?\nYou will not be able to open it again",
            Buttons = {
                { Name = "Yes", Callback = function()
                    AnimateClose(function()
                        if Chloeex then Chloeex:Destroy() end
                        if GuiFunc._toggleGui then
                            pcall(function() GuiFunc._toggleGui:Destroy() end)
                            GuiFunc._toggleGui = nil
                        end
                    end)
                end },
                { Name = "Cancel", Callback = function() end }
            }
        })
    end)

    function GuiFunc:ToggleUI()
        if GuiFunc._toggleGui then
            pcall(function() GuiFunc._toggleGui:Destroy() end)
            GuiFunc._toggleGui = nil
        end
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Name = "ToggleUIButton"
        GuiFunc._toggleGui = ScreenGui

        local MainButton = Instance.new("ImageLabel")
        MainButton.Parent = ScreenGui
        MainButton.Size = UDim2.new(0, 40, 0, 40)
        MainButton.Position = UDim2.new(0, 20, 0, 100)
        MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        MainButton.BackgroundTransparency = 0.1
        MainButton.Image = "rbxassetid://" .. GuiConfig.Image
        MainButton.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 8)

        local Button = Instance.new("TextButton")
        Button.Parent = MainButton
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""

        Button.MouseButton1Click:Connect(function()
            if DropShadowHolder then
                if DropShadowHolder.Visible then
                    AnimateClose(function()
                        DropShadowHolder.Visible = false
                        DropShadowHolder.Position = UDim2.new(
                            DropShadowHolder.Position.X.Scale, DropShadowHolder.Position.X.Offset,
                            DropShadowHolder.Position.Y.Scale, DropShadowHolder.Position.Y.Offset + 30
                        )
                    end)
                else
                    AnimateOpen()
                end
            end
        end)

        local dragging, dragStart, startPos = false, nil, nil
        local function update(input)
            local delta = input.Position - dragStart
            MainButton.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
        Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = MainButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

    GuiFunc:ToggleUI()

    GuiConfig.Keybind = GuiConfig.Keybind or Enum.KeyCode.RightShift
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == GuiConfig.Keybind then
            if DropShadowHolder.Visible then
                AnimateClose(function()
                    DropShadowHolder.Visible = false
                    DropShadowHolder.Position = UDim2.new(
                        DropShadowHolder.Position.X.Scale, DropShadowHolder.Position.X.Offset,
                        DropShadowHolder.Position.Y.Scale, DropShadowHolder.Position.Y.Offset + 30
                    )
                end)
            else
                AnimateOpen()
            end
        end
    end)

    MakeDraggable(Top, DropShadowHolder, GuiConfig)

    local MoreBlur          = Instance.new("Frame")
    local DropShadowHolder1 = Instance.new("Frame")
    local DropShadow1       = Instance.new("ImageLabel")
    local UICorner28        = Instance.new("UICorner")
    local ConnectButton     = Instance.new("TextButton")

    MoreBlur.AnchorPoint = Vector2.new(1, 1)
    MoreBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MoreBlur.BackgroundTransparency = 0.999
    MoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MoreBlur.BorderSizePixel = 0
    MoreBlur.ClipsDescendants = true
    MoreBlur.Position = UDim2.new(1, 8, 1, 8)
    MoreBlur.Size = UDim2.new(1, 154, 1, 54)
    MoreBlur.Visible = false
    MoreBlur.Name = "MoreBlur"
    MoreBlur.Parent = Layers

    DropShadowHolder1.BackgroundTransparency = 1
    DropShadowHolder1.BorderSizePixel = 0
    DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder1.ZIndex = 0
    DropShadowHolder1.Name = "DropShadowHolder"
    DropShadowHolder1.Parent = MoreBlur

    DropShadow1.Image = "rbxassetid://6015897843"
    DropShadow1.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow1.ImageTransparency = 1
    DropShadow1.ScaleType = Enum.ScaleType.Slice
    DropShadow1.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow1.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow1.BackgroundTransparency = 1
    DropShadow1.BorderSizePixel = 0
    DropShadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow1.Size = UDim2.new(1, 35, 1, 35)
    DropShadow1.ZIndex = 0
    DropShadow1.Name = "DropShadow"
    DropShadow1.Parent = DropShadowHolder1

    UICorner28.Parent = MoreBlur

    ConnectButton.Font = Enum.Font.SourceSans
    ConnectButton.Text = ""
    ConnectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ConnectButton.TextSize = 14
    ConnectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConnectButton.BackgroundTransparency = 0.999
    ConnectButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConnectButton.BorderSizePixel = 0
    ConnectButton.Size = UDim2.new(1, 0, 1, 0)
    ConnectButton.Name = "ConnectButton"
    ConnectButton.Parent = MoreBlur

    local DropdownSelect     = Instance.new("Frame")
    local UICorner36         = Instance.new("UICorner")
    local UIStroke14         = Instance.new("UIStroke")
    local DropdownSelectReal = Instance.new("Frame")
    local DropdownFolder     = Instance.new("Folder")
    local DropPageLayout     = Instance.new("UIPageLayout")

    DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
    DropdownSelect.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownSelect.BorderSizePixel = 0
    DropdownSelect.LayoutOrder = 1
    DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
    DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
    DropdownSelect.Name = "DropdownSelect"
    DropdownSelect.ClipsDescendants = true
    DropdownSelect.Parent = MoreBlur

    ConnectButton.Activated:Connect(function()
        if MoreBlur.Visible then
            TweenService:Create(DropdownSelect, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 172, 0.5, 0)
            }):Play()
            TweenService:Create(MoreBlur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 0.999
            }):Play()
            task.wait(0.3)
            MoreBlur.Visible = false
        end
    end)

    UICorner36.CornerRadius = UDim.new(0, 6)
    UICorner36.Parent = DropdownSelect

    UIStroke14.Color = GuiConfig.Color
    UIStroke14.Thickness = 1.5
    UIStroke14.Transparency = 0.7
    UIStroke14.Parent = DropdownSelect

    DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
    DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(0, 27, 98)
    DropdownSelectReal.BackgroundTransparency = 0.7
    DropdownSelectReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownSelectReal.BorderSizePixel = 0
    DropdownSelectReal.LayoutOrder = 1
    DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropdownSelectReal.Size = UDim2.new(1, 1, 1, 1)
    DropdownSelectReal.Name = "DropdownSelectReal"
    DropdownSelectReal.Parent = DropdownSelect

    DropdownFolder.Name = "DropdownFolder"
    DropdownFolder.Parent = DropdownSelectReal

    DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
    DropPageLayout.EasingStyle = Enum.EasingStyle.Quad
    DropPageLayout.TweenTime = 0.01
    DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropPageLayout.FillDirection = Enum.FillDirection.Vertical
    DropPageLayout.Archivable = false
    DropPageLayout.Name = "DropPageLayout"
    DropPageLayout.Parent = DropdownFolder

    -- ══════════════════════════════════════════════════════════════
    -- ✦ FIX: Buat wrapper CreateColorpickerElement untuk Tabs.lua
    -- ══════════════════════════════════════════════════════════════
    local function _CreateColorpickerElement(parent, cfg, ci, elems)
        return _MakeColorPicker(cfg, parent, ci, GuiConfig.Color, DropShadowHolder)
    end

    local Tabs = TabsModule(
        GuiConfig, LayersFolder, LayersPageLayout, _G.ScrollTab, NameTab,
        MoreBlur, DropdownFolder, DropdownSelect, DropPageLayout,
        Elements, ElementsModule, KeybindModule, Mouse, TweenService,
        getIconId, CircleClick, function() end, {}, _CreateColorpickerElement  -- ← FIX: tambah argumen ke-19
    )

    for k, v in pairs(Tabs) do GuiFunc[k] = v end

    if GuiConfig.Config.AutoLoad then
        task.defer(function() GuiFunc:LoadConfig(GuiConfig.Config.AutoSaveFile) end)
    end

    -- ══════════════════════════════════════════════════════════════
    -- Inject AddColorpicker + Config System + FITUR BARU (AddTab wrap)
    -- ══════════════════════════════════════════════════════════════
    local origAddTab = GuiFunc.AddTab
    GuiFunc.AddTab = function(self, TabConfig)
        TabConfig = TabConfig or {}

        local useColumns  = TabConfig.Columns == true
        local useSearch   = TabConfig.Search  == true
        TabConfig.Columns = nil

        local Sections = origAddTab(self, TabConfig)

        local _subPages    = {}
        local _subBarFrame = nil
        local _tabPageRef  = nil

        local function _getTabPage()
            if _tabPageRef then return _tabPageRef end
            local ch = LayersFolder:GetChildren()
            for i = #ch, 1, -1 do
                if ch[i]:IsA("Frame") then
                    _tabPageRef = ch[i]
                    return _tabPageRef
                end
            end
            return nil
        end

        local function _ensureSubBar(tabPage)
            if _subBarFrame then return end

            _subBarFrame = Instance.new("Frame")
            _subBarFrame.Name = "SubPageBar"
            _subBarFrame.BackgroundTransparency = 1
            _subBarFrame.BorderSizePixel = 0
            _subBarFrame.Size = UDim2.new(1, -12, 0, 26)
            _subBarFrame.Position = UDim2.new(0, 6, 0, 4)
            _subBarFrame.ZIndex = 5
            _subBarFrame.Parent = tabPage

            local list = Instance.new("UIListLayout")
            list.FillDirection = Enum.FillDirection.Horizontal
            list.VerticalAlignment = Enum.VerticalAlignment.Center
            list.Padding = UDim.new(0, 5)
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Parent = _subBarFrame

            for _, child in ipairs(tabPage:GetChildren()) do
                if child ~= _subBarFrame and child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
        end

        function Sections:AddSubPage(cfg)
            cfg = cfg or {}
            cfg.Title = cfg.Title or "Page"

            task.defer(function()
                local tabPage = _getTabPage()
                if not tabPage then return end
                _ensureSubBar(tabPage)

                local btn = Instance.new("TextButton")
                btn.Text = cfg.Title
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 11
                btn.AutoButtonColor = false
                btn.BorderSizePixel = 0
                btn.Size = UDim2.new(0, 78, 1, 0)
                btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                btn.BackgroundTransparency = 0
                btn.TextColor3 = Color3.fromRGB(130, 130, 145)
                btn.ZIndex = 6
                btn.LayoutOrder = #_subPages + 1
                btn.Parent = _subBarFrame
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

                local btnStroke = Instance.new("UIStroke")
                btnStroke.Color = Color3.fromRGB(55, 55, 68)
                btnStroke.Thickness = 1
                btnStroke.Transparency = 0.5
                btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                btnStroke.Parent = btn

                local subFrame = Instance.new("Frame")
                subFrame.Name = "SubPage_" .. cfg.Title
                subFrame.BackgroundTransparency = 1
                subFrame.BorderSizePixel = 0
                subFrame.Position = UDim2.new(0, 0, 0, 32)
                subFrame.Size = UDim2.new(1, 0, 1, -32)
                subFrame.Visible = false
                subFrame.ZIndex = 4
                subFrame.Parent = tabPage

                local leftCol  = _makeColumnScroll(subFrame, 0,   0,   4, GuiConfig.Color)
                local rightCol = _makeColumnScroll(subFrame, 1, 0.5,  -4, GuiConfig.Color)

                local divider = Instance.new("Frame")
                divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                divider.BackgroundTransparency = 0.88
                divider.BorderSizePixel = 0
                divider.AnchorPoint = Vector2.new(0.5, 0)
                divider.Position = UDim2.new(0.5, 0, 0, 4)
                divider.Size = UDim2.new(0, 1, 1, -8)
                divider.Parent = subFrame

                local Sub = {}
                Sub._btn       = btn
                Sub._btnStroke = btnStroke
                Sub._frame     = subFrame
                Sub._leftCol   = leftCol
                Sub._rightCol  = rightCol

                function Sub:SetActive(bool)
                    for _, other in ipairs(_subPages) do
                        if other ~= self then
                            other._frame.Visible = false
                            other._btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                            other._btn.TextColor3 = Color3.fromRGB(130, 130, 145)
                            other._btnStroke.Color = Color3.fromRGB(55, 55, 68)
                            other._btnStroke.Transparency = 0.5
                        end
                    end
                    self._frame.Visible = bool
                    if bool then
                        TweenService:Create(self._btn, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(18, 18, 24),
                            TextColor3 = Color3.fromRGB(220, 220, 235)
                        }):Play()
                        TweenService:Create(self._btnStroke, TweenInfo.new(0.15), {
                            Color = GuiConfig.Color, Transparency = 0.2
                        }):Play()
                    end
                end

                function Sub:AddSection(sectionCfg)
                    sectionCfg = sectionCfg or {}
                    local side = (sectionCfg.Side or "Left"):lower()
                    local targetCol = (side == "right") and self._rightCol or self._leftCol

                    local SectionFrame = Instance.new("Frame")
                    SectionFrame.Name = "Section_" .. (sectionCfg.Title or "Section")
                    SectionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
                    SectionFrame.BackgroundTransparency = 0.1
                    SectionFrame.BorderSizePixel = 0
                    SectionFrame.Size = UDim2.new(1, 0, 0, 32)
                    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                    SectionFrame.ZIndex = 4
                    SectionFrame.Parent = targetCol

                    Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)

                    local sfStroke = Instance.new("UIStroke")
                    sfStroke.Color = Color3.fromRGB(255, 255, 255)
                    sfStroke.Thickness = 1
                    sfStroke.Transparency = 0.88
                    sfStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    sfStroke.Parent = SectionFrame

                    local header = Instance.new("TextLabel")
                    header.Font = Enum.Font.GothamBold
                    header.Text = sectionCfg.Title or "Section"
                    header.TextColor3 = GuiConfig.Color
                    header.TextSize = 12
                    header.TextXAlignment = Enum.TextXAlignment.Left
                    header.BackgroundTransparency = 1
                    header.BorderSizePixel = 0
                    header.Size = UDim2.new(1, -12, 0, 18)
                    header.Position = UDim2.new(0, 8, 0, 6)
                    header.ZIndex = 5
                    header.Parent = SectionFrame

                    local hline = Instance.new("Frame")
                    hline.BackgroundColor3 = GuiConfig.Color
                    hline.BackgroundTransparency = 0.75
                    hline.BorderSizePixel = 0
                    hline.Size = UDim2.new(1, -16, 0, 1)
                    hline.Position = UDim2.new(0, 8, 0, 26)
                    hline.ZIndex = 5
                    hline.Parent = SectionFrame

                    local contentFrame = Instance.new("Frame")
                    contentFrame.Name = "Content"
                    contentFrame.BackgroundTransparency = 1
                    contentFrame.BorderSizePixel = 0
                    contentFrame.Position = UDim2.new(0, 8, 0, 32)
                    contentFrame.Size = UDim2.new(1, -16, 0, 0)
                    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
                    contentFrame.ZIndex = 5
                    contentFrame.Parent = SectionFrame

                    local contentLayout = Instance.new("UIListLayout")
                    contentLayout.Padding = UDim.new(0, 6)
                    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    contentLayout.Parent = contentFrame

                    local contentPad = Instance.new("UIPadding")
                    contentPad.PaddingBottom = UDim.new(0, 8)
                    contentPad.Parent = SectionFrame

                    local dummyItems = Sections:AddSection(sectionCfg)

                    task.defer(function()
                        for _, child in ipairs(tabPage:GetChildren()) do
                            if child:IsA("ScrollingFrame") and child ~= leftCol and child ~= rightCol then
                                local ch2 = child:GetChildren()
                                for j = #ch2, 1, -1 do
                                    if ch2[j]:IsA("Frame") then
                                        ch2[j].Parent = targetCol
                                        SectionFrame:Destroy()
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end)

                    return dummyItems
                end

                table.insert(_subPages, Sub)

                btn.MouseButton1Click:Connect(function()
                    Sub:SetActive(true)
                end)

                if #_subPages == 1 then
                    Sub:SetActive(true)
                end

                cfg._resolved = Sub
            end)

            local placeholder = {}
            setmetatable(placeholder, {
                __index = function(t, k)
                    return function(...) end
                end
            })
            return placeholder
        end

        if useSearch then
            task.defer(function()
                local tabPage = _getTabPage()
                if not tabPage then return end

                local sectionScroll = nil
                for _, child in ipairs(tabPage:GetChildren()) do
                    if child:IsA("ScrollingFrame") then
                        sectionScroll = child
                        break
                    end
                end
                if not sectionScroll then return end

                sectionScroll.Position = UDim2.new(
                    sectionScroll.Position.X.Scale, sectionScroll.Position.X.Offset,
                    sectionScroll.Position.Y.Scale, sectionScroll.Position.Y.Offset + 36
                )
                sectionScroll.Size = UDim2.new(
                    sectionScroll.Size.X.Scale, sectionScroll.Size.X.Offset,
                    sectionScroll.Size.Y.Scale, sectionScroll.Size.Y.Offset - 36
                )

                local searchBox = Instance.new("TextBox")
                searchBox.Name = "PageSearchBox"
                searchBox.PlaceholderText = "  🔍  Cari..."
                searchBox.Text = ""
                searchBox.Font = Enum.Font.Gotham
                searchBox.TextSize = 12
                searchBox.TextColor3 = Color3.fromRGB(205, 205, 215)
                searchBox.PlaceholderColor3 = Color3.fromRGB(95, 95, 108)
                searchBox.TextXAlignment = Enum.TextXAlignment.Left
                searchBox.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
                searchBox.BorderSizePixel = 0
                searchBox.ClearTextOnFocus = false
                searchBox.Size = UDim2.new(1, -12, 0, 26)
                searchBox.Position = UDim2.new(0, 6, 0, 4)
                searchBox.ZIndex = 6
                searchBox.Parent = tabPage

                Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

                local sbStroke = Instance.new("UIStroke")
                sbStroke.Color = Color3.fromRGB(60, 60, 75)
                sbStroke.Thickness = 1
                sbStroke.Transparency = 0.4
                sbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                sbStroke.Parent = searchBox

                local sbPad = Instance.new("UIPadding")
                sbPad.PaddingLeft = UDim.new(0, 8)
                sbPad.Parent = searchBox

                local accentColor = GuiConfig.Color
                local searchItems = {}

                local function refreshSearchItems()
                    searchItems = {}
                    for _, desc in ipairs(sectionScroll:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.TextSize <= 14 and desc.Text ~= "" then
                            table.insert(searchItems, {
                                label  = desc,
                                origC  = desc.TextColor3,
                                origT  = desc.TextTransparency
                            })
                        end
                    end
                end

                sectionScroll.DescendantAdded:Connect(function(d)
                    if d:IsA("TextLabel") then task.defer(refreshSearchItems) end
                end)
                task.defer(refreshSearchItems)

                local function doSearch(query)
                    query = query:lower()
                    for _, item in ipairs(searchItems) do
                        if not item.label or not item.label.Parent then continue end
                        if query == "" then
                            item.label.TextColor3       = item.origC
                            item.label.TextTransparency = item.origT
                        else
                            local matched = item.label.Text:lower():find(query, 1, true)
                            if matched then
                                TweenService:Create(item.label, TweenInfo.new(0.1), {
                                    TextColor3 = accentColor, TextTransparency = 0
                                }):Play()
                            else
                                TweenService:Create(item.label, TweenInfo.new(0.1), {
                                    TextColor3 = Color3.fromRGB(70, 70, 80),
                                    TextTransparency = 0.5
                                }):Play()
                            end
                        end
                    end
                end

                local renderConn = nil

                searchBox.Focused:Connect(function()
                    TweenService:Create(sbStroke, TweenInfo.new(0.2), {
                        Color = accentColor, Transparency = 0.2
                    }):Play()
                    if renderConn then renderConn:Disconnect() end
                    renderConn = RunService.RenderStepped:Connect(function()
                        doSearch(searchBox.Text)
                    end)
                end)

                searchBox.FocusLost:Connect(function()
                    TweenService:Create(sbStroke, TweenInfo.new(0.2), {
                        Color = Color3.fromRGB(60, 60, 75), Transparency = 0.4
                    }):Play()
                    if renderConn then renderConn:Disconnect() renderConn = nil end
                    if searchBox.Text == "" then doSearch("") end
                end)

                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    doSearch(searchBox.Text)
                end)
            end)
        end

        if useColumns then
            local leftCol, rightCol

            task.defer(function()
                local tabPage = _getTabPage()
                if not tabPage then return end

                for _, child in ipairs(tabPage:GetChildren()) do
                    if child:IsA("ScrollingFrame") then
                        child.Visible = false
                        break
                    end
                end

                leftCol  = _makeColumnScroll(tabPage, 0,   0,  4, GuiConfig.Color)
                rightCol = _makeColumnScroll(tabPage, 1, 0.5, -4, GuiConfig.Color)

                local divider = Instance.new("Frame")
                divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                divider.BackgroundTransparency = 0.88
                divider.BorderSizePixel = 0
                divider.AnchorPoint = Vector2.new(0.5, 0)
                divider.Position = UDim2.new(0.5, 0, 0, 4)
                divider.Size = UDim2.new(0, 1, 1, -8)
                divider.Parent = tabPage
            end)

            local origAddSection = Sections.AddSection
            Sections.AddSection = function(self2, SectionConfig)
                SectionConfig = SectionConfig or {}
                local col = (SectionConfig.Column or "Left"):lower()
                SectionConfig.Column = nil

                local Items = origAddSection(self2, SectionConfig)

                task.defer(function()
                    if not leftCol or not rightCol then return end
                    local target = (col == "right") and rightCol or leftCol
                    local tabPage = _getTabPage()
                    if not tabPage then return end
                    for _, child in ipairs(tabPage:GetChildren()) do
                        if child:IsA("ScrollingFrame") and child ~= leftCol and child ~= rightCol then
                            local ch = child:GetChildren()
                            for i = #ch, 1, -1 do
                                if ch[i]:IsA("Frame") then
                                    ch[i].Parent   = target
                                    ch[i].Size     = UDim2.new(1, 0, 0, ch[i].Size.Y.Offset)
                                    ch[i].Position = UDim2.new(0, 0, 0, 0)
                                    break
                                end
                            end
                            break
                        end
                    end
                end)

                local _itemCount = 0

                function Items:AddColorpicker(Config)
                    local sa = rawget(self, "_sectionAdd") or (type(self) == "table" and self._sectionAdd)
                    local ci = _itemCount
                    if not sa then
                        local origCreate = ElementsModule.CreateToggle
                        local probeFrame = nil
                        ElementsModule.CreateToggle = function(self_em, parent, cfg, ci2, ...)
                            probeFrame = parent
                            ElementsModule.CreateToggle = origCreate
                            return { Set = function() end, GetValue = function() return false end, Value = false, IgnoreConfig = false, Class = "Toggle" }
                        end
                        pcall(function() Items:AddToggle({ Title = "__probe__", Default = false, Callback = function() end }) end)
                        ElementsModule.CreateToggle = origCreate
                        sa = probeFrame
                    end
                    if not sa then return {} end
                    local api = _MakeColorPicker(Config, sa, ci, GuiConfig.Color, DropShadowHolder)
                    _itemCount = _itemCount + 1
                    return api
                end
                Items.AddColorPicker = Items.AddColorpicker

                return Items
            end

            return Sections
        end

        local origAddSection = Sections.AddSection
        Sections.AddSection = function(self2, SectionConfig)
            local Items = origAddSection(self2, SectionConfig)

            local _itemCount = 0

            function Items:AddColorpicker(Config)
                local sa = rawget(self, "_sectionAdd") or (type(self) == "table" and self._sectionAdd)
                local ci = (type(self) == "table" and rawget(self, "_getCountItem") and self._getCountItem()) or _itemCount
                if not sa then
                    local origCreate = ElementsModule.CreateToggle
                    local probeFrame = nil
                    ElementsModule.CreateToggle = function(self_em, parent, cfg, ci2, ...)
                        probeFrame = parent
                        ElementsModule.CreateToggle = origCreate
                        return { Set = function() end, GetValue = function() return false end, Value = false, IgnoreConfig = false, Class = "Toggle" }
                    end
                    pcall(function()
                        Items:AddToggle({ Title = "__probe__", Default = false, Callback = function() end })
                    end)
                    ElementsModule.CreateToggle = origCreate
                    sa = probeFrame
                    if sa then
                        for _, child in ipairs(sa:GetChildren()) do
                            if child:IsA("Frame") and child:FindFirstChild("ToggleTitle") then
                                local tt = child:FindFirstChild("ToggleTitle")
                                if tt and tt.Text == "__probe__" then child:Destroy() break end
                            end
                        end
                    end
                end
                if not sa then return {} end
                local api = _MakeColorPicker(Config, sa, ci, GuiConfig.Color, DropShadowHolder)
                _itemCount = _itemCount + 1
                return api
            end

            Items.AddColorPicker = Items.AddColorpicker

            local function _wrapElem(elem, Cfg, elemType, defaultVal)
                if not elem then return elem end
                if not Cfg.Flag or Cfg.Flag == "" then return elem end
                local key = tostring(Cfg.Flag)
                elem.Type    = elem.Type or elemType
                elem.Default = defaultVal
                elem.Flag    = key
                local saved = _ConfigData[key]
                if saved ~= nil and elem.Set then pcall(function() elem:Set(saved) end) end
                local origSet = elem.Set
                if origSet then
                    elem.Set = function(self_e, val)
                        origSet(self_e, val)
                        _ConfigData[key] = val
                        if GuiConfig.Config.AutoSave then GuiFunc:SaveConfig(GuiConfig.Config.AutoSaveFile) end
                    end
                end
                _ConfigElements[key] = elem
                return elem
            end

            local origAddToggle = Items.AddToggle
            if origAddToggle then
                Items.AddToggle = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddToggle(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Toggle", Cfg.Default or false)
                end
            end

            local origAddSlider = Items.AddSlider
            if origAddSlider then
                Items.AddSlider = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddSlider(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Slider", Cfg.Default or 0)
                end
            end

            local origAddDropdown = Items.AddDropdown
            if origAddDropdown then
                Items.AddDropdown = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddDropdown(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Dropdown", Cfg.Default)
                end
            end

            local origAddInput = Items.AddInput
            if origAddInput then
                Items.AddInput = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddInput(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Input", Cfg.Default or "")
                end
            end

            return Items
        end

        return Sections
    end

    -- ══════════════════════════════════════════════════════════════
    -- GuiFunc:Notify
    -- ══════════════════════════════════════════════════════════════
    function GuiFunc:Notify(Config)
        Config = Config or {}
        Config.Title    = Config.Title   or "Notification"
        Config.Content  = Config.Content or ""
        Config.Duration = Config.Duration or 5
        Config.Buttons  = Config.Buttons or {}

        local NotifGui = CoreGui:FindFirstChild("VelarisUI_Notifs")
        if not NotifGui then
            NotifGui = Instance.new("ScreenGui")
            NotifGui.Name = "VelarisUI_Notifs"
            NotifGui.ResetOnSpawn = false
            NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifGui.Parent = CoreGui

            local Container = Instance.new("Frame")
            Container.Name = "Container"
            Container.BackgroundTransparency = 1
            Container.AnchorPoint = Vector2.new(1, 1)
            Container.Position = UDim2.new(1, -16, 1, -16)
            Container.Size = UDim2.new(0, 280, 1, -32)
            Container.Parent = NotifGui

            local List = Instance.new("UIListLayout")
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.VerticalAlignment = Enum.VerticalAlignment.Bottom
            List.Padding = UDim.new(0, 8)
            List.Parent = Container
        end

        local Container = NotifGui:FindFirstChild("Container")

        local Card = Instance.new("Frame")
        Card.Name = "NotifCard"
        Card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        Card.BorderSizePixel = 0
        Card.Size = UDim2.new(1, 0, 0, 0)
        Card.AutomaticSize = Enum.AutomaticSize.Y
        Card.ClipsDescendants = false
        Card.Parent = Container

        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = GuiConfig.Color
        CardStroke.Thickness = 1
        CardStroke.Transparency = 0.6
        CardStroke.Parent = Card

        local CardPad = Instance.new("UIPadding")
        CardPad.PaddingTop    = UDim.new(0, 10)
        CardPad.PaddingBottom = UDim.new(0, 10)
        CardPad.PaddingLeft   = UDim.new(0, 14)
        CardPad.PaddingRight  = UDim.new(0, 12)
        CardPad.Parent = Card

        local CardList = Instance.new("UIListLayout")
        CardList.SortOrder = Enum.SortOrder.LayoutOrder
        CardList.Padding = UDim.new(0, 6)
        CardList.Parent = Card

        local Accent = Instance.new("Frame")
        Accent.BackgroundColor3 = GuiConfig.Color
        Accent.BorderSizePixel = 0
        Accent.Size = UDim2.new(0, 3, 1, 0)
        Accent.Position = UDim2.new(0, 0, 0, 0)
        Accent.ZIndex = 2
        Accent.Parent = Card
        Instance.new("UICorner", Accent).CornerRadius = UDim.new(1, 0)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = Config.Title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 13
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.TextWrapped = true
        TitleLabel.Size = UDim2.new(1, 0, 0, 16)
        TitleLabel.LayoutOrder = 0
        TitleLabel.Parent = Card

        task.defer(function()
            if TitleLabel and TitleLabel.Parent then
                TitleLabel.Size = UDim2.new(1, 0, 0, TitleLabel.TextBounds.Y)
            end
        end)

        if Config.Content ~= "" then
            local ContentLabel = Instance.new("TextLabel")
            ContentLabel.Text = Config.Content
            ContentLabel.Font = Enum.Font.Gotham
            ContentLabel.TextSize = 11
            ContentLabel.TextColor3 = Color3.fromRGB(170, 170, 185)
            ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.TextWrapped = true
            ContentLabel.Size = UDim2.new(1, 0, 0, 14)
            ContentLabel.LayoutOrder = 1
            ContentLabel.Parent = Card

            task.defer(function()
                if not ContentLabel or not ContentLabel.Parent then return end
                local lineH = 14
                local maxW  = ContentLabel.AbsoluteSize.X
                local lines = 1
                if maxW > 0 then
                    lines = math.max(1, math.ceil(ContentLabel.TextBounds.X / maxW))
                end
                ContentLabel.Size = UDim2.new(1, 0, 0, lineH * lines + 2)
            end)
        end

        if #Config.Buttons > 0 then
            local BtnRow = Instance.new("Frame")
            BtnRow.BackgroundTransparency = 1
            BtnRow.Size = UDim2.new(1, 0, 0, 28)
            BtnRow.LayoutOrder = 2
            BtnRow.Parent = Card

            local BtnList = Instance.new("UIListLayout")
            BtnList.FillDirection = Enum.FillDirection.Horizontal
            BtnList.HorizontalAlignment = Enum.HorizontalAlignment.Right
            BtnList.VerticalAlignment = Enum.VerticalAlignment.Center
            BtnList.Padding = UDim.new(0, 6)
            BtnList.Parent = BtnRow

            for idx, btnCfg in ipairs(Config.Buttons) do
                local Btn = Instance.new("TextButton")
                Btn.Text = btnCfg.Name or ("Button" .. idx)
                Btn.Font = Enum.Font.GothamBold
                Btn.TextSize = 11
                Btn.AutomaticSize = Enum.AutomaticSize.X
                Btn.Size = UDim2.new(0, 0, 1, 0)
                Btn.BorderSizePixel = 0
                Btn.LayoutOrder = idx
                local isPrimary = btnCfg.Primary == true or idx == 1
                Btn.BackgroundColor3 = isPrimary and GuiConfig.Color or Color3.fromRGB(40, 40, 50)
                Btn.TextColor3 = isPrimary and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 195)
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
                local BtnPad = Instance.new("UIPadding")
                BtnPad.PaddingLeft  = UDim.new(0, 10)
                BtnPad.PaddingRight = UDim.new(0, 10)
                BtnPad.Parent = Btn
                Btn.Parent = BtnRow
                Btn.MouseButton1Click:Connect(function()
                    if btnCfg.Callback then pcall(btnCfg.Callback) end
                    Card:Destroy()
                end)
            end
        end

        if Config.Duration > 0 and #Config.Buttons == 0 then
            local ProgressBg = Instance.new("Frame")
            ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            ProgressBg.BorderSizePixel = 0
            ProgressBg.Size = UDim2.new(1, 0, 0, 3)
            ProgressBg.LayoutOrder = 3
            ProgressBg.Parent = Card
            Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)

            local ProgressBar = Instance.new("Frame")
            ProgressBar.BackgroundColor3 = GuiConfig.Color
            ProgressBar.BorderSizePixel = 0
            ProgressBar.Size = UDim2.new(1, 0, 1, 0)
            ProgressBar.Parent = ProgressBg
            Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(1, 0)

            TweenService:Create(ProgressBar, TweenInfo.new(Config.Duration, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()

            task.delay(Config.Duration, function()
                if Card and Card.Parent then Card:Destroy() end
            end)
        end

        Card.Position = UDim2.new(1, 300, 0, 0)
        TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()

        task.defer(function()
            task.wait()
            if Card and Card.Parent then Card.ClipsDescendants = true end
        end)
    end

    return GuiFunc
end

VelarisUI = Chloex


-- =====================================================================
-- ADDON MODULES (belum di-wiring ke Window/Elements manapun di file ini)
-- Ini di-append sesuai permintaan biar ada di satu file yang sama.
-- Kamu perlu manual panggil/hubungkan fungsi-fungsi ini ke tempat yang sesuai.
-- =====================================================================

-- addons/configsection.lua
-- Factory function, dipanggil dengan:
--   AddConfigSectionFactory(Chloex, getConfigFolder, getCURRENT_VERSION, getConfigData, getElements, LoadConfigElements, SaveConfig, Nt, getAutoLoad)
local AddConfigSectionFactory = (function()
    -- // configsection.lua | VelarisUI AddConfigSection Module

    return function(Chloex, getConfigFolder, getCURRENT_VERSION, getConfigData, getElements, LoadConfigElements, SaveConfig, Nt, getAutoLoad)

        local HttpService = game:GetService("HttpService")

        local function notify(msg, delay, color)
            Nt(msg, delay, color)
        end

        function Chloex:AddConfigSection(Tab, SectionConfig)
            local ConfigFolder    = getConfigFolder()
            local CURRENT_VERSION = getCURRENT_VERSION()
            local ConfigData      = getConfigData()

            local sectionName, sectionIcon, customFolderName
            if type(SectionConfig) == "string" then
                sectionName      = SectionConfig
                sectionIcon      = ""
                customFolderName = nil
            elseif type(SectionConfig) == "table" then
                sectionName      = SectionConfig.Name       or "Configuration"
                sectionIcon      = SectionConfig.Icon       or ""
                customFolderName = SectionConfig.FolderName or nil  -- ✅ NEW: custom folder name
            else
                sectionName      = "Configuration"
                sectionIcon      = ""
                customFolderName = nil
            end

            -- ✅ NEW: jika FolderName disediakan, override ConfigFolder base-nya
            if customFolderName and customFolderName ~= "" then
                -- sanitize: hanya izinkan karakter aman untuk nama folder
                local sanitized = customFolderName:match("^%s*(.-)%s*$"):gsub("[^%w_%-]", "_")
                if sanitized ~= "" then
                    ConfigFolder = sanitized
                end
            end

            local cfgFolder = ConfigFolder .. "/Config"

            if isfolder and makefolder then
                if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
                if not isfolder(cfgFolder)    then makefolder(cfgFolder)    end
            end

            local AUTOLOAD_FILE   = ConfigFolder .. "/autoload.txt"
            local currentAutoload = ""
            if isfile and isfile(AUTOLOAD_FILE) then
                pcall(function() currentAutoload = readfile(AUTOLOAD_FILE) end)
            end

            local function toPath(name)
                return cfgFolder .. "/" .. name .. ".json"
            end

            local function getList()
                local list = {}
                if not (listfiles and isfolder) then return list end
                local ok, files = pcall(listfiles, cfgFolder)
                if not ok then return list end
                for _, path in ipairs(files) do
                    local n = path:match("([^/\\]+)%.json$")
                    if n then table.insert(list, n) end
                end
                table.sort(list)
                return list
            end

            local function saveConfig(name)
                if not writefile then return false end
                ConfigData._version = CURRENT_VERSION
                local ok = pcall(writefile, toPath(name), HttpService:JSONEncode(ConfigData))
                return ok
            end

            local function loadConfig(name)
                local path = toPath(name)
                if not (isfile and isfile(path)) then return false end
                local ok, data = pcall(function()
                    return HttpService:JSONDecode(readfile(path))
                end)
                if ok and type(data) == "table" then
                    if data._version == CURRENT_VERSION then
                        for k in pairs(ConfigData) do
                            ConfigData[k] = nil
                        end
                        for k, v in pairs(data) do
                            ConfigData[k] = v
                        end
                        ConfigData._version = CURRENT_VERSION

                        local Elements = getElements()
                        for key, element in pairs(Elements) do
                            if data[key] ~= nil and element.Set then
                                element:Set(data[key], false)
                            elseif element.Set then
                                element:Set(element.Value, true)
                            end
                        end
                        return true
                    else
                        notify("Version mismatch on '" .. name .. "'!", 3, Color3.fromRGB(255, 165, 0))
                    end
                end
                return false
            end

            local function deleteConfig(name)
                local path = toPath(name)
                if isfile and isfile(path) then
                    pcall(delfile, path)
                    return true
                end
                return false
            end

            local function setAutoload(name)
                if writefile then
                    pcall(writefile, AUTOLOAD_FILE, name)
                    currentAutoload = name
                end
            end

            local function clearAutoload()
                if isfile and isfile(AUTOLOAD_FILE) then
                    pcall(delfile, AUTOLOAD_FILE)
                end
                currentAutoload = ""
            end

            local Sections = Tab:AddSection({
                Title  = sectionName,
                Name   = sectionName,
                Icon   = sectionIcon,
                Open   = true,
            })

            local selectedConfig = nil
            local dropdownRef    = nil
            local autoloadLabel  = nil

            local nameInput = Sections:AddInput({
                Title       = "Config name",
                Placeholder = "Enter config name...",
                Default     = "",
                Flag        = "CHX_ConfigNameInput",
                Callback    = function() end,
            })

            Sections:AddButton({
                Title    = "Create config",
                Version  = "V2",
                Icon     = "lucide:file-plus",
                Callback = function()
                    local raw  = nameInput and nameInput.Value or ""
                    local name = raw:match("^%s*(.-)%s*$"):gsub("[^%w_%-]", "_")
                    if name == "" then
                        notify("Config name cannot be empty!", 3, Color3.fromRGB(255, 80, 80))
                        return
                    end
                    if saveConfig(name) then
                        notify("Config '" .. name .. "' created!", 3, Color3.fromRGB(80, 220, 100))
                        if dropdownRef then
                            dropdownRef:SetValues(getList(), selectedConfig)
                        end
                    else
                        notify("Failed to create config!", 3, Color3.fromRGB(255, 80, 80))
                    end
                end,
            })

            dropdownRef = Sections:AddDropdown({
                Title    = "Config list",
                Options  = getList(),
                Default  = nil,
                Flag     = "CHX_ConfigListDropdown",
                Callback = function(val)
                    selectedConfig = val
                end,
            })

            Sections:AddButton({
                Title    = "Load config",
                Version  = "V2",
                Icon     = "lucide:folder-open",
                Callback = function()
                    if not selectedConfig then
                        notify("Select a config first!", 3, Color3.fromRGB(255, 165, 0))
                        return
                    end
                    if loadConfig(selectedConfig) then
                        notify("Loaded '" .. selectedConfig .. "'!", 3, Color3.fromRGB(80, 220, 100))
                    else
                        notify("Failed to load config!", 3, Color3.fromRGB(255, 80, 80))
                    end
                end,
            })

            Sections:AddButton({
                Title    = "Overwrite config",
                Version  = "V2",
                Icon     = "lucide:save",
                Callback = function()
                    if not selectedConfig then
                        notify("Select a config first!", 3, Color3.fromRGB(255, 165, 0))
                        return
                    end
                    if saveConfig(selectedConfig) then
                        notify("Overwritten '" .. selectedConfig .. "'!", 3, Color3.fromRGB(80, 220, 100))
                    else
                        notify("Failed to overwrite config!", 3, Color3.fromRGB(255, 80, 80))
                    end
                end,
            })

            Sections:AddButton({
                Title    = "Delete config",
                Version  = "V2",
                Icon     = "lucide:trash-2",
                Callback = function()
                    if not selectedConfig then
                        notify("Select a config first!", 3, Color3.fromRGB(255, 165, 0))
                        return
                    end
                    local name = selectedConfig
                    if deleteConfig(name) then
                        if currentAutoload == name then
                            clearAutoload()
                            if autoloadLabel then
                                autoloadLabel:SetContent("none")
                            end
                        end
                        selectedConfig = nil
                        if dropdownRef then
                            dropdownRef:SetValues(getList(), nil)
                        end
                        notify("Deleted '" .. name .. "'!", 3, Color3.fromRGB(80, 220, 100))
                    else
                        notify("Failed to delete config!", 3, Color3.fromRGB(255, 80, 80))
                    end
                end,
            })

            Sections:AddButton({
                Title    = "Refresh list",
                Version  = "V2",
                Icon     = "lucide:refresh-cw",
                Callback = function()
                    if dropdownRef then
                        dropdownRef:SetValues(getList(), selectedConfig)
                    end
                    notify("List refreshed!", 2, Color3.fromRGB(80, 180, 255))
                end,
            })

            Sections:AddButton({
                Title    = "Set as autoload",
                Version  = "V2",
                Icon     = "lucide:star",
                Callback = function()
                    if not selectedConfig then
                        notify("Select a config first!", 3, Color3.fromRGB(255, 165, 0))
                        return
                    end
                    setAutoload(selectedConfig)
                    if autoloadLabel then
                        autoloadLabel:SetContent(selectedConfig)
                    end
                    notify("Autoload set to '" .. selectedConfig .. "'!", 3, Color3.fromRGB(80, 220, 100))
                end,
            })

            Sections:AddButton({
                Title    = "Reset autoload",
                Version  = "V2",
                Icon     = "lucide:star-off",
                Callback = function()
                    clearAutoload()
                    if autoloadLabel then
                        autoloadLabel:SetContent("none")
                    end
                    notify("Autoload cleared!", 2, Color3.fromRGB(255, 165, 0))
                end,
            })

            autoloadLabel = Sections:AddParagraph({
                Title   = "Current autoload config",
                Content = currentAutoload ~= "" and currentAutoload or "none",
            })

            local _autoLoadEnabled = (getAutoLoad == nil) or (type(getAutoLoad) == "function" and getAutoLoad() == true)
            if currentAutoload ~= "" and _autoLoadEnabled then
                task.defer(function()
                    task.wait(0.5)
                    if loadConfig(currentAutoload) then
                        notify("Auto-loaded: " .. currentAutoload, 3, Color3.fromRGB(80, 220, 100))
                    end
                end)
            end

            return Sections
        end

    end
end)()

-- src/elements/KeySystem/Luarmor.lua
-- Table KeySystem provider (Name, Icon, Fields, Build, dst). Dipakai sebagai salah satu
-- opsi di dalam KeySystemUi (modul yang masih online / loadUrl di atas).
local KeySystem_Luarmor = (function()
    -- Velaris UI | KeySystem | Type = "luarmor"

    return {
        Name = "Luarmor",
        Icon = "lucide:key",
        Args = { "ScriptId" },

        New = function(ScriptId)
            local function getLuarmorObj()
                if type(_G.luarmor) == "table" then return _G.luarmor end
                if type(_G.Luarmor) == "table" then return _G.Luarmor end
                local ok, env = pcall(getfenv)
                if ok and type(env) == "table" then
                    if type(env.luarmor) == "table" then return env.luarmor end
                    if type(env.Luarmor) == "table" then return env.Luarmor end
                end
                return nil
            end

            local function validateKey(key)
                if not key or key == "" then return false, "Key tidak boleh kosong." end
                local lm = getLuarmorObj()
                if not lm then return false, "Luarmor object tidak ditemukan di _G." end
                local fn = lm.CheckKey or lm.checkKey or lm.check or lm.Validate or lm.validate
                if type(fn) ~= "function" then return false, "Method CheckKey tidak ditemukan." end
                local ok, result = pcall(fn, lm, key)
                if not ok then return false, tostring(result) end
                return result == true, result == true and "Key valid!" or "Key tidak valid."
            end

            local function copyLink()
                return setclipboard("https://luarmor.net/")
            end

            return {
                Verify = validateKey,
                Copy   = copyLink,
            }
        end
    }
end)()

-- src/elements/KeySystem/PandaDeveloper.lua
-- Sama seperti di atas, provider KeySystem lain.
local KeySystem_PandaDeveloper = (function()
    -- Velaris UI | KeySystem | Type = "pandadeveloper"

    return {
        Name = "Panda",
        Icon = "lucide:shield",
        Args = { "ServiceId" },

        New = function(ServiceId)
            local function getPandaObj()
                if type(_G.PandaDeveloper) == "table" then return _G.PandaDeveloper end
                if type(_G.pandaDeveloper) == "table" then return _G.pandaDeveloper end
                if type(_G.PandaKey)       == "table" then return _G.PandaKey       end
                if type(_G.pandakey)       == "table" then return _G.pandakey       end
                if type(_G.Panda)          == "table" then return _G.Panda          end
                local ok, env = pcall(getfenv)
                if ok and type(env) == "table" then
                    if type(env.PandaDeveloper) == "table" then return env.PandaDeveloper end
                    if type(env.PandaKey)       == "table" then return env.PandaKey       end
                end
                return nil
            end

            local function validateKey(key)
                if not key or key == "" then return false, "Key tidak boleh kosong." end
                local pd = getPandaObj()
                if not pd then return false, "PandaDeveloper object tidak ditemukan di _G." end
                local fn = pd.CheckKey or pd.checkKey or pd.check or pd.Validate or pd.validate or pd.VerifyKey or pd.verifyKey
                if type(fn) ~= "function" then return false, "Method CheckKey tidak ditemukan." end
                local ok, result = pcall(fn, pd, key)
                if not ok then return false, tostring(result) end
                return result == true, result == true and "Key valid!" or "Key tidak valid."
            end

            local function copyLink()
                return setclipboard("https://pandadevelopment.net/getkey?service=" .. tostring(ServiceId))
            end

            return {
                Verify = validateKey,
                Copy   = copyLink,
            }
        end
    }
end)()

return Chloex
