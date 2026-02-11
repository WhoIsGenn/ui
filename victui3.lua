-- ==================== VICTUI 3.0 - FIXED VERSION ====================
-- Fixed: Config bugs, Spam notifications, Performance issues, Dropdown updates
-- Author: Fixed by Claude for Victoria Hub
-- Date: 2026

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ==================== CONFIG SYSTEM (FIXED) ====================
local ConfigPath = "VictoriaHub/Config/"

if not isfolder("VictoriaHub") then makefolder("VictoriaHub") end
if not isfolder("VictoriaHub/Config") then makefolder("VictoriaHub/Config") end

local ConfigData = {}
local Elements = {}
local CURRENT_VERSION = nil
local ConfigSaveDebounce = false

-- Debounced save to prevent spam
function SaveConfig(name)
    if ConfigSaveDebounce then return end
    ConfigSaveDebounce = true
    
    task.spawn(function()
        task.wait(0.5) -- Debounce 0.5s
        
        local fileName = ConfigPath .. (name or "Default") .. ".json"
        
        if writefile then
            local saveData = table.clone(ConfigData)
            saveData._version = CURRENT_VERSION
            
            local success, err = pcall(function()
                writefile(fileName, HttpService:JSONEncode(saveData))
            end)
            
            if not success then
                warn("[VictUI] Failed to save config:", err)
            end
        end
        
        ConfigSaveDebounce = false
    end)
end

function LoadConfigFromFile(name)
    local fileName = ConfigPath .. (name or "Default") .. ".json"
    
    if isfile and isfile(fileName) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(fileName))
        end)
        
        if success and type(result) == "table" then
            if not CURRENT_VERSION or result._version == CURRENT_VERSION then
                ConfigData = result
                return true
            else
                warn("[VictUI] Config version mismatch, using defaults")
                ConfigData = { _version = CURRENT_VERSION }
            end
        else
            ConfigData = { _version = CURRENT_VERSION }
        end
    else
        ConfigData = { _version = CURRENT_VERSION }
    end
    return false
end

function LoadConfigElements()
    for key, element in pairs(Elements) do
        local targetValue = ConfigData[key]
        
        if element.Set then
            pcall(function()
                if targetValue ~= nil then
                    element:Set(targetValue, true) -- Silent load
                end
            end)
        end
    end
end

-- ==================== ICONS ====================
local Icons = {
    player    = "rbxassetid://12120698352",
    web       = "rbxassetid://137601480983962",
    bag       = "rbxassetid://8601111810",
    shop      = "rbxassetid://4985385964",
    cart      = "rbxassetid://128874923961846",
    settings  = "rbxassetid://70386228443175",
    loop      = "rbxassetid://122032243989747",
    gps       = "rbxassetid://17824309485",
    compas    = "rbxassetid://125300760963399",
    gamepad   = "rbxassetid://84173963561612",
    boss      = "rbxassetid://13132186360",
    scroll    = "rbxassetid://114127804740858",
    menu      = "rbxassetid://6340513838",
    crosshair = "rbxassetid://12614416478",
    user      = "rbxassetid://108483430622128",
    stat      = "rbxassetid://12094445329",
    eyes      = "rbxassetid://14321059114",
    sword     = "rbxassetid://82472368671405",
    discord   = "rbxassetid://94434236999817",
    star      = "rbxassetid://107005941750079",
    skeleton  = "rbxassetid://17313330026",
    payment   = "rbxassetid://18747025078",
    scan      = "rbxassetid://109869955247116",
    alert     = "rbxassetid://73186275216515",
    question  = "rbxassetid://17510196486",
    idea      = "rbxassetid://16833255748",
    storm     = "rbxassetid://13321880293",
    water     = "rbxassetid://100076212630732",
    dcs       = "rbxassetid://15310731934",
    start     = "rbxassetid://108886429866687",
    next      = "rbxassetid://12662718374",
    rod       = "rbxassetid://103247953194129",
    fish      = "rbxassetid://97167558235554",
    home      = "rbxassetid://135016593915894",
    landmark  = "rbxassetid://139262888943265",
    pinmap    = "rbxassetid://134722365781829",
    fishing   = "rbxassetid://82305997222115",
    handshake = "rbxassetid://118812884427306",
}

-- ==================== UTILITY FUNCTIONS ====================
local viewport = workspace.CurrentCamera.ViewportSize

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

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition

    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

-- ==================== NOTIFICATION SYSTEM (FIXED - NO SPAM) ====================
local NotificationHolder
local NotificationCount = 0
local MaxNotifications = 3

local function CreateNotification(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or "No content provided"
    local duration = config.Duration or 3
    local color = config.Color or Color3.fromRGB(100, 150, 255)
    
    -- Limit notifications
    if NotificationCount >= MaxNotifications then
        return
    end
    
    if not NotificationHolder then
        NotificationHolder = Instance.new("ScreenGui")
        NotificationHolder.Name = "VictUINotifications"
        NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotificationHolder.ResetOnSpawn = false
        NotificationHolder.Parent = CoreGui
        
        local Container = Instance.new("Frame")
        Container.Name = "Container"
        Container.Size = UDim2.new(0, 300, 1, 0)
        Container.Position = UDim2.new(1, -320, 0, 20)
        Container.BackgroundTransparency = 1
        Container.Parent = NotificationHolder
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Container
    end
    
    NotificationCount = NotificationCount + 1
    
    local Container = NotificationHolder:FindFirstChild("Container")
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 80)
    Notif.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.Parent = Container
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notif
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = color
    UIStroke.Thickness = 2
    UIStroke.Parent = Notif
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.BackgroundColor3 = color
    Accent.BorderSizePixel = 0
    Accent.Parent = Notif
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 0, 25)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notif
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -50, 0, 35)
    Content.Position = UDim2.new(0, 15, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Font = Enum.Font.Gotham
    Content.Text = content
    Content.TextColor3 = Color3.fromRGB(200, 200, 200)
    Content.TextSize = 12
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.TextWrapped = true
    Content.Parent = Notif
    
    -- Close button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.BackgroundTransparency = 1
    Close.Font = Enum.Font.GothamBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(200, 200, 200)
    Close.TextSize = 20
    Close.Parent = Notif
    
    -- Animation
    Notif.Size = UDim2.new(1, 0, 0, 0)
    TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(1, 0, 0, 80)
    }):Play()
    
    -- Auto destroy
    local function Destroy()
        TweenService:Create(Notif, TweenInfo.new(0.3), {
            Size = UDim2.new(1, 0, 0, 0)
        }):Play()
        
        task.wait(0.3)
        Notif:Destroy()
        NotificationCount = NotificationCount - 1
    end
    
    Close.MouseButton1Click:Connect(Destroy)
    task.delay(duration, Destroy)
end

-- ==================== MAIN LIBRARY ====================
local VictUI = {}

function VictUI:Window(config)
    config = config or {}
    
    -- Set version
    CURRENT_VERSION = config.Version or "1.0.0"
    
    -- Load config first (NO SPAM NOTIF)
    LoadConfigFromFile()
    
    local GuiConfig = {
        Title = config.Title or "Victoria Hub",
        Footer = config.Footer or "",
        Color = config.Color or Color3.fromRGB(100, 150, 255),
        TabWidth = config["Tab Width"] or 120,
        Version = config.Version or "1.0.0",
        Icon = config.Icon or "rbxassetid://96751490485303",
        Image = config.Image or "96751490485303",
    }
    
    -- Cleanup old UI
    if CoreGui:FindFirstChild("VictoriaHubUI") then
        CoreGui:FindFirstChild("VictoriaHubUI"):Destroy()
    end
    
    -- Main ScreenGui
    local VictoriaHubUI = Instance.new("ScreenGui")
    VictoriaHubUI.Name = "VictoriaHubUI"
    VictoriaHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    VictoriaHubUI.ResetOnSpawn = false
    VictoriaHubUI.Parent = CoreGui
    
    local DropShadowHolder = Instance.new("Frame")
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder.Parent = VictoriaHubUI
    
    local CanvasGroup = Instance.new("CanvasGroup")
    CanvasGroup.Name = "CanvasGroup"
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CanvasGroup.Position = UDim2.new(0.5, 0, 0.5, 0)
    CanvasGroup.Size = isMobile and UDim2.new(0, 470, 0, 270) or UDim2.new(0, 640, 0, 400)
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.GroupTransparency = 0
    CanvasGroup.Parent = DropShadowHolder
    
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Image = "rbxassetid://6014261993"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Parent = CanvasGroup
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Parent = CanvasGroup
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = GuiConfig.Color
    MainStroke.Thickness = 2
    MainStroke.Parent = Main
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 10)
    TopbarCorner.Parent = Topbar
    
    local TopbarFix = Instance.new("Frame")
    TopbarFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Position = UDim2.new(0, 0, 1, -10)
    TopbarFix.Size = UDim2.new(1, 0, 0, 10)
    TopbarFix.Parent = Topbar
    
    MakeDraggable(Topbar, CanvasGroup)
    
    -- Icon
    local IconFrame = Instance.new("Frame")
    IconFrame.Name = "IconFrame"
    IconFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    IconFrame.Position = UDim2.new(0, 10, 0.5, -15)
    IconFrame.Size = UDim2.new(0, 30, 0, 30)
    IconFrame.Parent = Topbar
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 6)
    IconCorner.Parent = IconFrame
    
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.Image = GuiConfig.Icon
    Icon.Parent = IconFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.Size = UDim2.new(1, -100, 0.5, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = GuiConfig.Title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar
    
    local Footer = Instance.new("TextLabel")
    Footer.Name = "Footer"
    Footer.BackgroundTransparency = 1
    Footer.Position = UDim2.new(0, 50, 0.5, 0)
    Footer.Size = UDim2.new(1, -100, 0.5, 0)
    Footer.Font = Enum.Font.Gotham
    Footer.Text = GuiConfig.Footer
    Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
    Footer.TextSize = 11
    Footer.TextXAlignment = Enum.TextXAlignment.Left
    Footer.Parent = Topbar
    
    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Close.Position = UDim2.new(1, -10, 0.5, 0)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Close.TextSize = 18
    Close.Parent = Topbar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    Close.MouseButton1Click:Connect(function()
        DropShadowHolder.Visible = false
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -45)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = GuiConfig.Color
    TabList.BorderSizePixel = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabContainer
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabList
    
    local TabListPadding = Instance.new("UIPadding")
    TabListPadding.PaddingTop = UDim.new(0, 10)
    TabListPadding.PaddingBottom = UDim.new(0, 10)
    TabListPadding.PaddingLeft = UDim.new(0, 10)
    TabListPadding.PaddingRight = UDim.new(0, 10)
    TabListPadding.Parent = TabList
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, GuiConfig.TabWidth, 0, 45)
    ContentContainer.Size = UDim2.new(1, -GuiConfig.TabWidth, 1, -45)
    ContentContainer.Parent = Main
    
    -- Tab Functions
    local Tabs = {}
    local CurrentTab = nil
    local TabCount = 0
    
    function Tabs:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        TabCount = TabCount + 1
        
        local TabName = tabConfig.Name or "Tab " .. TabCount
        local TabIcon = tabConfig.Icon or "settings"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 13
        TabButton.Parent = TabList
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabButtonStroke = Instance.new("UIStroke")
        TabButtonStroke.Color = GuiConfig.Color
        TabButtonStroke.Thickness = 0
        TabButtonStroke.Transparency = 1
        TabButtonStroke.Parent = TabButton
        
        -- Icon
        local TabIconFrame = Instance.new("ImageLabel")
        TabIconFrame.Name = "Icon"
        TabIconFrame.BackgroundTransparency = 1
        TabIconFrame.Position = UDim2.new(0, 8, 0.5, -10)
        TabIconFrame.Size = UDim2.new(0, 20, 0, 20)
        TabIconFrame.Image = Icons[TabIcon] or Icons.settings
        TabIconFrame.ImageColor3 = Color3.fromRGB(200, 200, 200)
        TabIconFrame.Parent = TabButton
        
        -- Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 35, 0, 0)
        TabLabel.Size = UDim2.new(1, -35, 1, 0)
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.Text = TabName
        TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = TabName .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local LeftSide = Instance.new("ScrollingFrame")
        LeftSide.Name = "LeftSide"
        LeftSide.BackgroundTransparency = 1
        LeftSide.Position = UDim2.new(0, 10, 0, 10)
        LeftSide.Size = UDim2.new(0.5, -15, 1, -20)
        LeftSide.ScrollBarThickness = 2
        LeftSide.ScrollBarImageColor3 = GuiConfig.Color
        LeftSide.BorderSizePixel = 0
        LeftSide.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftSide.Parent = TabContent
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0, 10)
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Parent = LeftSide
        
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            LeftSide.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local RightSide = Instance.new("ScrollingFrame")
        RightSide.Name = "RightSide"
        RightSide.BackgroundTransparency = 1
        RightSide.Position = UDim2.new(0.5, 5, 0, 10)
        RightSide.Size = UDim2.new(0.5, -15, 1, -20)
        RightSide.ScrollBarThickness = 2
        RightSide.ScrollBarImageColor3 = GuiConfig.Color
        RightSide.BorderSizePixel = 0
        RightSide.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightSide.Parent = TabContent
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0, 10)
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Parent = RightSide
        
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RightSide.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        local function SelectTab()
            for _, tab in pairs(ContentContainer:GetChildren()) do
                if tab:IsA("Frame") then
                    tab.Visible = false
                end
            end
            
            for _, btn in pairs(TabList:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    }):Play()
                    
                    if btn:FindFirstChild("UIStroke") then
                        TweenService:Create(btn.UIStroke, TweenInfo.new(0.2), {
                            Thickness = 0,
                            Transparency = 1
                        }):Play()
                    end
                    
                    if btn:FindFirstChild("Label") then
                        TweenService:Create(btn.Label, TweenInfo.new(0.2), {
                            TextColor3 = Color3.fromRGB(200, 200, 200)
                        }):Play()
                    end
                    
                    if btn:FindFirstChild("Icon") then
                        TweenService:Create(btn.Icon, TweenInfo.new(0.2), {
                            ImageColor3 = Color3.fromRGB(200, 200, 200)
                        }):Play()
                    end
                end
            end
            
            TabContent.Visible = true
            CurrentTab = TabContent
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            }):Play()
            
            TweenService:Create(TabButtonStroke, TweenInfo.new(0.2), {
                Thickness = 2,
                Transparency = 0
            }):Play()
            
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {
                TextColor3 = GuiConfig.Color
            }):Play()
            
            TweenService:Create(TabIconFrame, TweenInfo.new(0.2), {
                ImageColor3 = GuiConfig.Color
            }):Play()
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        if TabCount == 1 then
            SelectTab()
        end
        
        -- Section Functions
        local Sections = {}
        local SectionCount = 0
        
        function Sections:AddSection(sectionName)
            SectionCount = SectionCount + 1
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName or "Section"
            SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.Parent = (SectionCount % 2 == 1) and LeftSide or RightSide
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 12, 0, 5)
            SectionTitle.Size = UDim2.new(1, -24, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName or "Section"
            SectionTitle.TextColor3 = GuiConfig.Color
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.Size = UDim2.new(1, 0, 1, -30)
            SectionContent.Parent = SectionFrame
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Parent = SectionContent
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingTop = UDim.new(0, 8)
            SectionPadding.PaddingBottom = UDim.new(0, 8)
            SectionPadding.PaddingLeft = UDim.new(0, 12)
            SectionPadding.PaddingRight = UDim.new(0, 12)
            SectionPadding.Parent = SectionContent
            
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 46)
            end)
            
            -- Element Functions
            local Elements = {}
            local ElementCount = 0
            
            -- TOGGLE
            function Elements:AddToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                ElementCount = ElementCount + 1
                
                local ToggleName = toggleConfig.Name or "Toggle"
                local ToggleDefault = toggleConfig.Default or false
                local ToggleCallback = toggleConfig.Callback or function() end
                
                local configKey = TabName .. "_" .. sectionName .. "_" .. ToggleName
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle"
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = ToggleName
                ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleButton.Position = UDim2.new(1, -10, 0.5, 0)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(1, 0)
                ButtonCorner.Parent = ToggleButton
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "Circle"
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Parent = ToggleButton
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle
                
                local ToggleFunc = {
                    Value = ToggleDefault,
                    Type = "Toggle"
                }
                
                function ToggleFunc:Set(value, silent)
                    self.Value = value
                    
                    if value then
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = GuiConfig.Color
                        }):Play()
                        
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -18, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }):Play()
                    else
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        }):Play()
                        
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -8),
                            BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                        }):Play()
                    end
                    
                    ConfigData[configKey] = value
                    if not silent then
                        SaveConfig()
                        ToggleCallback(value)
                    end
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    ToggleFunc:Set(not ToggleFunc.Value)
                end)
                
                ToggleFunc:Set(ToggleDefault, true)
                Elements[configKey] = ToggleFunc
                
                return ToggleFunc
            end
            
            -- BUTTON
            function Elements:AddButton(buttonConfig)
                buttonConfig = buttonConfig or {}
                ElementCount = ElementCount + 1
                
                local ButtonName = buttonConfig.Name or "Button"
                local ButtonCallback = buttonConfig.Callback or function() end
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Name = "Button"
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
                ButtonFrame.Font = Enum.Font.Gotham
                ButtonFrame.Text = ButtonName
                ButtonFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
                ButtonFrame.TextSize = 12
                ButtonFrame.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = ButtonFrame
                
                local ButtonStroke = Instance.new("UIStroke")
                ButtonStroke.Color = GuiConfig.Color
                ButtonStroke.Thickness = 0
                ButtonStroke.Transparency = 1
                ButtonStroke.Parent = ButtonFrame
                
                ButtonFrame.MouseEnter:Connect(function()
                    TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                        Thickness = 2,
                        Transparency = 0
                    }):Play()
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                        Thickness = 0,
                        Transparency = 1
                    }):Play()
                end)
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    ButtonCallback()
                end)
                
                return ButtonFrame
            end
            
            -- SLIDER (OPTIMIZED)
            function Elements:AddSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                ElementCount = ElementCount + 1
                
                local SliderName = sliderConfig.Name or "Slider"
                local SliderMin = sliderConfig.Min or 0
                local SliderMax = sliderConfig.Max or 100
                local SliderDefault = sliderConfig.Default or 50
                local SliderCallback = sliderConfig.Callback or function() end
                
                local configKey = TabName .. "_" .. sectionName .. "_" .. SliderName
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "Slider"
                SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.Size = UDim2.new(1, -20, 0, 15)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = SliderName
                SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0, 10, 0, 5)
                SliderValue.Size = UDim2.new(1, -20, 0, 15)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(SliderDefault)
                SliderValue.TextColor3 = GuiConfig.Color
                SliderValue.TextSize = 12
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderFrame
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                SliderTrack.Position = UDim2.new(0, 10, 0, 28)
                SliderTrack.Size = UDim2.new(1, -20, 0, 4)
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Parent = SliderFrame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = GuiConfig.Color
                SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderTrack
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                local SliderDot = Instance.new("Frame")
                SliderDot.Name = "Dot"
                SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderDot.Position = UDim2.new(0.5, 0, 0.5, 0)
                SliderDot.Size = UDim2.new(0, 12, 0, 12)
                SliderDot.Parent = SliderFill
                
                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = SliderDot
                
                local SliderFunc = {
                    Value = SliderDefault,
                    Type = "Slider",
                    Default = SliderDefault
                }
                
                local Dragging = false
                local UpdateDebounce = false
                
                function SliderFunc:Set(value, silent)
                    value = math.clamp(value, SliderMin, SliderMax)
                    self.Value = value
                    
                    local percent = (value - SliderMin) / (SliderMax - SliderMin)
                    
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderValue.Text = tostring(math.floor(value))
                    
                    ConfigData[configKey] = value
                    
                    if not silent then
                        if not UpdateDebounce then
                            UpdateDebounce = true
                            SaveConfig()
                            SliderCallback(value)
                            
                            task.delay(0.1, function()
                                UpdateDebounce = false
                            end)
                        end
                    end
                end
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local value = SliderMin + (pos * (SliderMax - SliderMin))
                    SliderFunc:Set(value)
                end
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                SliderFunc:Set(SliderDefault, true)
                Elements[configKey] = SliderFunc
                
                return SliderFunc
            end
            
            -- DROPDOWN (FIXED - REFRESH SUPPORT)
            function Elements:AddDropdown(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                ElementCount = ElementCount + 1
                
                local DropdownName = dropdownConfig.Name or "Dropdown"
                local DropdownOptions = dropdownConfig.Options or {}
                local DropdownDefault = dropdownConfig.Default or (dropdownConfig.Multi and {} or "")
                local DropdownMulti = dropdownConfig.Multi or false
                local DropdownCallback = dropdownConfig.Callback or function() end
                
                local configKey = TabName .. "_" .. sectionName .. "_" .. DropdownName
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "Dropdown"
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 0, 35)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = ""
                DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                DropdownButton.TextSize = 12
                DropdownButton.Parent = DropdownFrame
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.Size = UDim2.new(1, -30, 0, 35)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = DropdownName
                DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                DropdownLabel.TextSize = 12
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Name = "Arrow"
                DropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -10, 0, 17.5)
                DropdownArrow.Size = UDim2.new(0, 15, 0, 15)
                DropdownArrow.Font = Enum.Font.GothamBold
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = GuiConfig.Color
                DropdownArrow.TextSize = 10
                DropdownArrow.Parent = DropdownFrame
                
                local DropdownScroll = Instance.new("ScrollingFrame")
                DropdownScroll.Name = "Scroll"
                DropdownScroll.BackgroundTransparency = 1
                DropdownScroll.Position = UDim2.new(0, 0, 0, 35)
                DropdownScroll.Size = UDim2.new(1, 0, 0, 0)
                DropdownScroll.ScrollBarThickness = 2
                DropdownScroll.ScrollBarImageColor3 = GuiConfig.Color
                DropdownScroll.BorderSizePixel = 0
                DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownScroll.Parent = DropdownFrame
                
                local ScrollLayout = Instance.new("UIListLayout")
                ScrollLayout.Padding = UDim.new(0, 2)
                ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ScrollLayout.Parent = DropdownScroll
                
                local ScrollPadding = Instance.new("UIPadding")
                ScrollPadding.PaddingTop = UDim.new(0, 5)
                ScrollPadding.PaddingBottom = UDim.new(0, 5)
                ScrollPadding.PaddingLeft = UDim.new(0, 10)
                ScrollPadding.PaddingRight = UDim.new(0, 10)
                ScrollPadding.Parent = DropdownScroll
                
                ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 10)
                end)
                
                local IsOpen = false
                
                local DropdownFunc = {
                    Value = DropdownDefault,
                    Options = DropdownOptions,
                    Type = "Dropdown",
                    Default = DropdownDefault,
                    Multi = DropdownMulti
                }
                
                function DropdownFunc:Toggle()
                    IsOpen = not IsOpen
                    
                    if IsOpen then
                        local contentHeight = math.min(ScrollLayout.AbsoluteContentSize.Y + 10, 150)
                        
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 35 + contentHeight + 10)
                        }):Play()
                        
                        TweenService:Create(DropdownScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, contentHeight)
                        }):Play()
                        
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {
                            Rotation = 180
                        }):Play()
                    else
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 35)
                        }):Play()
                        
                        TweenService:Create(DropdownScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                        
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {
                            Rotation = 0
                        }):Play()
                    end
                end
                
                function DropdownFunc:Clear()
                    for _, child in pairs(DropdownScroll:GetChildren()) do
                        if child:IsA("Frame") then
                            child:Destroy()
                        end
                    end
                end
                
                function DropdownFunc:AddOption(option)
                    local OptionFrame = Instance.new("Frame")
                    OptionFrame.Name = "Option"
                    OptionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    OptionFrame.BackgroundTransparency = 0.999
                    OptionFrame.Size = UDim2.new(1, 0, 0, 25)
                    OptionFrame:SetAttribute("RealValue", option)
                    OptionFrame.Parent = DropdownScroll
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionFrame
                    
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = "Button"
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 1, 0)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = ""
                    OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                    OptionButton.TextSize = 11
                    OptionButton.Parent = OptionFrame
                    
                    local OptionLabel = Instance.new("TextLabel")
                    OptionLabel.Name = "Label"
                    OptionLabel.BackgroundTransparency = 1
                    OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                    OptionLabel.Size = UDim2.new(1, -16, 1, 0)
                    OptionLabel.Font = Enum.Font.Gotham
                    OptionLabel.Text = tostring(option)
                    OptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    OptionLabel.TextSize = 11
                    OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                    OptionLabel.Parent = OptionFrame
                    
                    local OptionCheck = Instance.new("Frame")
                    OptionCheck.Name = "Check"
                    OptionCheck.AnchorPoint = Vector2.new(0, 0.5)
                    OptionCheck.BackgroundColor3 = GuiConfig.Color
                    OptionCheck.Position = UDim2.new(0, 2, 0.5, 0)
                    OptionCheck.Size = UDim2.new(0, 0, 0, 0)
                    OptionCheck.Parent = OptionFrame
                    
                    local CheckCorner = Instance.new("UICorner")
                    CheckCorner.CornerRadius = UDim.new(0, 2)
                    CheckCorner.Parent = OptionCheck
                    
                    local CheckStroke = Instance.new("UIStroke")
                    CheckStroke.Color = GuiConfig.Color
                    CheckStroke.Thickness = 1.6
                    CheckStroke.Transparency = 0.999
                    CheckStroke.Parent = OptionCheck
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        if DropdownMulti then
                            if not table.find(DropdownFunc.Value, option) then
                                table.insert(DropdownFunc.Value, option)
                            else
                                for i, v in pairs(DropdownFunc.Value) do
                                    if v == option then
                                        table.remove(DropdownFunc.Value, i)
                                        break
                                    end
                                end
                            end
                        else
                            DropdownFunc.Value = option
                            DropdownFunc:Toggle()
                        end
                        
                        DropdownFunc:Set(DropdownFunc.Value)
                    end)
                end
                
                function DropdownFunc:Set(value, silent)
                    if DropdownMulti then
                        self.Value = type(value) == "table" and value or {}
                    else
                        self.Value = (type(value) == "table" and value[1]) or value
                    end
                    
                    ConfigData[configKey] = self.Value
                    if not silent then
                        SaveConfig()
                    end
                    
                    local displayTexts = {}
                    
                    for _, optionFrame in pairs(DropdownScroll:GetChildren()) do
                        if optionFrame:IsA("Frame") and optionFrame:GetAttribute("RealValue") then
                            local optVal = optionFrame:GetAttribute("RealValue")
                            local isSelected = DropdownMulti and table.find(self.Value, optVal) or self.Value == optVal
                            
                            local check = optionFrame:FindFirstChild("Check")
                            
                            if isSelected then
                                TweenService:Create(check, TweenInfo.new(0.2), {
                                    Size = UDim2.new(0, 1, 0, 12)
                                }):Play()
                                
                                TweenService:Create(check.UIStroke, TweenInfo.new(0.2), {
                                    Transparency = 0
                                }):Play()
                                
                                TweenService:Create(optionFrame, TweenInfo.new(0.2), {
                                    BackgroundTransparency = 0.935
                                }):Play()
                                
                                table.insert(displayTexts, optionFrame.Label.Text)
                            else
                                TweenService:Create(check, TweenInfo.new(0.1), {
                                    Size = UDim2.new(0, 0, 0, 0)
                                }):Play()
                                
                                TweenService:Create(check.UIStroke, TweenInfo.new(0.1), {
                                    Transparency = 0.999
                                }):Play()
                                
                                TweenService:Create(optionFrame, TweenInfo.new(0.1), {
                                    BackgroundTransparency = 0.999
                                }):Play()
                            end
                        end
                    end
                    
                    DropdownLabel.Text = (#displayTexts == 0) 
                        and (DropdownMulti and "Select Options" or "Select Option")
                        or table.concat(displayTexts, ", ")
                    
                    if not silent then
                        if DropdownMulti then
                            DropdownCallback(self.Value)
                        else
                            DropdownCallback(tostring(self.Value))
                        end
                    end
                end
                
                function DropdownFunc:SetValue(val)
                    self:Set(val)
                end
                
                function DropdownFunc:GetValue()
                    return self.Value
                end
                
                -- ✅ FIXED: REFRESH/UPDATE DROPDOWN OPTIONS
                function DropdownFunc:SetValues(newList, selecting)
                    newList = newList or {}
                    selecting = selecting or (DropdownMulti and {} or nil)
                    
                    -- Clear old options
                    self:Clear()
                    
                    -- Add new options
                    for _, option in ipairs(newList) do
                        self:AddOption(option)
                    end
                    
                    -- Update options list
                    self.Options = newList
                    
                    -- Set new selection
                    self:Set(selecting)
                end
                
                function DropdownFunc:Refresh(newList, selecting)
                    self:SetValues(newList, selecting)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    DropdownFunc:Toggle()
                end)
                
                -- Initialize options
                for _, option in ipairs(DropdownOptions) do
                    DropdownFunc:AddOption(option)
                end
                
                DropdownFunc:Set(DropdownDefault, true)
                Elements[configKey] = DropdownFunc
                
                return DropdownFunc
            end
            
            -- INPUT/TEXTBOX
            function Elements:AddInput(inputConfig)
                inputConfig = inputConfig or {}
                ElementCount = ElementCount + 1
                
                local InputName = inputConfig.Name or "Input"
                local InputDefault = inputConfig.Default or ""
                local InputPlaceholder = inputConfig.Placeholder or "Enter text..."
                local InputCallback = inputConfig.Callback or function() end
                
                local configKey = TabName .. "_" .. sectionName .. "_" .. InputName
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = "Input"
                InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                InputFrame.Size = UDim2.new(1, 0, 0, 60)
                InputFrame.Parent = SectionContent
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = InputFrame
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Name = "Label"
                InputLabel.BackgroundTransparency = 1
                InputLabel.Position = UDim2.new(0, 10, 0, 5)
                InputLabel.Size = UDim2.new(1, -20, 0, 15)
                InputLabel.Font = Enum.Font.Gotham
                InputLabel.Text = InputName
                InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                InputLabel.TextSize = 12
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame
                
                local InputBox = Instance.new("TextBox")
                InputBox.Name = "Box"
                InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                InputBox.Position = UDim2.new(0, 10, 0, 28)
                InputBox.Size = UDim2.new(1, -20, 0, 25)
                InputBox.Font = Enum.Font.Gotham
                InputBox.PlaceholderText = InputPlaceholder
                InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
                InputBox.Text = InputDefault
                InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputBox.TextSize = 11
                InputBox.ClearTextOnFocus = false
                InputBox.Parent = InputFrame
                
                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = InputBox
                
                local BoxPadding = Instance.new("UIPadding")
                BoxPadding.PaddingLeft = UDim.new(0, 8)
                BoxPadding.PaddingRight = UDim.new(0, 8)
                BoxPadding.Parent = InputBox
                
                local InputFunc = {
                    Value = InputDefault,
                    Type = "Input"
                }
                
                function InputFunc:Set(value, silent)
                    self.Value = value
                    InputBox.Text = value
                    
                    ConfigData[configKey] = value
                    if not silent then
                        SaveConfig()
                        InputCallback(value)
                    end
                end
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        InputFunc:Set(InputBox.Text)
                    end
                end)
                
                InputFunc:Set(InputDefault, true)
                Elements[configKey] = InputFunc
                
                return InputFunc
            end
            
            -- DIVIDER
            function Elements:AddDivider()
                ElementCount = ElementCount + 1
                
                local Divider = Instance.new("Frame")
                Divider.Name = "Divider"
                Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Divider.Size = UDim2.new(1, 0, 0, 2)
                Divider.BorderSizePixel = 0
                Divider.Parent = SectionContent
                
                local DividerGradient = Instance.new("UIGradient")
                DividerGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
                    ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                }
                DividerGradient.Parent = Divider
                
                local DividerCorner = Instance.new("UICorner")
                DividerCorner.CornerRadius = UDim.new(0, 2)
                DividerCorner.Parent = Divider
                
                return Divider
            end
            
            -- LABEL/PARAGRAPH
            function Elements:AddLabel(text)
                ElementCount = ElementCount + 1
                
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Label.Size = UDim2.new(1, 0, 0, 30)
                Label.Font = Enum.Font.Gotham
                Label.Text = text or "Label"
                Label.TextColor3 = Color3.fromRGB(200, 200, 200)
                Label.TextSize = 12
                Label.TextWrapped = true
                Label.TextYAlignment = Enum.TextYAlignment.Top
                Label.Parent = SectionContent
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 6)
                LabelCorner.Parent = Label
                
                local LabelPadding = Instance.new("UIPadding")
                LabelPadding.PaddingTop = UDim.new(0, 8)
                LabelPadding.PaddingBottom = UDim.new(0, 8)
                LabelPadding.PaddingLeft = UDim.new(0, 10)
                LabelPadding.PaddingRight = UDim.new(0, 10)
                LabelPadding.Parent = Label
                
                -- Auto-resize based on text
                local TextService = game:GetService("TextService")
                local textBounds = TextService:GetTextSize(
                    Label.Text,
                    Label.TextSize,
                    Label.Font,
                    Vector2.new(Label.AbsoluteSize.X - 20, math.huge)
                )
                
                Label.Size = UDim2.new(1, 0, 0, textBounds.Y + 16)
                
                return Label
            end
            
            return Elements
        end
        
        return Sections
    end
    
    -- Toggle Button
    local ToggleUIButton = Instance.new("ScreenGui")
    ToggleUIButton.Name = "VictoriaHubToggle"
    ToggleUIButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleUIButton.ResetOnSpawn = false
    ToggleUIButton.Parent = CoreGui
    
    local Button = Instance.new("ImageButton")
    Button.Name = "Button"
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(0, 60, 0, 60)
    Button.Position = UDim2.new(0, 10, 0, 60)
    Button.Image = GuiConfig.Icon
    Button.Draggable = true
    Button.Parent = ToggleUIButton
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 16)
    ButtonCorner.Parent = Button
    
    local ButtonScale = Instance.new("UIScale")
    ButtonScale.Scale = 1
    ButtonScale.Parent = Button
    
    local isWindowOpen = true
    
    Button.MouseButton1Click:Connect(function()
        isWindowOpen = not isWindowOpen
        DropShadowHolder.Visible = isWindowOpen
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(ButtonScale, TweenInfo.new(0.1), { Scale = 1.2 }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(ButtonScale, TweenInfo.new(0.1), { Scale = 1 }):Play()
    end)
    
    -- Keybind toggle (Right Control)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            isWindowOpen = not isWindowOpen
            DropShadowHolder.Visible = isWindowOpen
        end
    end)
    
    -- Notification function
    function Tabs:Notify(config)
        CreateNotification(config)
    end
    
    -- Destroy function
    function Tabs:Destroy()
        if VictoriaHubUI then
            VictoriaHubUI:Destroy()
        end
        if ToggleUIButton then
            ToggleUIButton:Destroy()
        end
        if NotificationHolder then
            NotificationHolder:Destroy()
        end
    end
    
    -- Load saved config (AFTER UI is created)
    task.defer(function()
        task.wait(0.5)
        LoadConfigElements()
    end)
    
    -- Performance optimization: Cleanup on destroy
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            SaveConfig()
        end
    end)
    
    return Tabs
end

return VictUI
